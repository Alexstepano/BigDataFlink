import json
import csv
import time
from kafka import KafkaProducer
import os
import re
from kafka.errors import NoBrokersAvailable

def wait_for_kafka(max_retries=30, delay=5):
    retries = 0
    while retries < max_retries:
        try:
            producer = KafkaProducer(bootstrap_servers=['kafka:9092'])
            producer.close()
            print("Kafka is ready!")
            return True
        except NoBrokersAvailable:
            print(f"Waiting for Kafka... (attempt {retries + 1}/{max_retries})")
            time.sleep(delay)
            retries += 1
    return False

def extract_file_number(filename):
    match = re.search(r'(\d+)', filename)
    return int(match.group(1)) if match else 0

def read_csv_and_produce():
    if not wait_for_kafka():
        print("Failed to connect to Kafka after retries")
        return

    producer = KafkaProducer(
        bootstrap_servers=['kafka:9092'],
        value_serializer=lambda x: json.dumps(x).encode('utf-8')
    )
    
    topic = 'sales_topic'  # Изменено для соответствия Flink SQL
    mock_data_dir = '/app/mock_data'
    
    files = sorted(
        [f for f in os.listdir(mock_data_dir) if f.startswith('mock_data') and f.endswith('.csv')],
        key=lambda x: extract_file_number(x)
    )
    
    for filename in files:
        file_num = extract_file_number(filename)
        base_id = 1000 * file_num
        
        with open(os.path.join(mock_data_dir, filename), 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            for row_idx, row in enumerate(reader, 1):
                # Добавляем все необходимые поля для соответствия схеме
                row['id'] = str(base_id + row_idx)
                row['sale_customer_id'] = str(base_id + row_idx)
                row['sale_seller_id'] = str(base_id + row_idx)
                row['sale_product_id'] = str(base_id + row_idx)
                
                producer.send(topic, value=row)
                print(f"Sent record {row['id']} from {filename}")
                time.sleep(0.1)
    
    producer.flush()

if __name__ == "__main__":
    read_csv_and_produce()