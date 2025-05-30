CREATE TABLE mock_data (
    id INT,
    customer_first_name STRING,
    customer_last_name STRING,
    customer_age INT,
    customer_email STRING,
    customer_country STRING,
    customer_postal_code STRING,
    customer_pet_type STRING,
    customer_pet_name STRING,
    customer_pet_breed STRING,
    seller_first_name STRING,
    seller_last_name STRING,
    seller_email STRING,
    seller_country STRING,
    seller_postal_code STRING,
    product_name STRING,
    product_category STRING,
    product_price DECIMAL(10,2),
    product_quantity INT,
    sale_date STRING,
    sale_customer_id STRING,
    sale_seller_id STRING,
    sale_product_id STRING,
    sale_quantity INT,
    sale_total_price DECIMAL(10,2),
    store_name STRING,
    store_location STRING,
    store_city STRING,
    store_state STRING,
    store_country STRING,
    store_phone STRING,
    store_email STRING,
    pet_category STRING,
    product_weight DECIMAL(10,2),
    product_color STRING,
    product_size STRING,
    product_brand STRING,
    product_material STRING,
    product_description STRING,
    product_rating DECIMAL(3,2),
    product_reviews INT,
    product_release_date STRING,
    product_expiry_date STRING,
    supplier_name STRING,
    supplier_contact STRING,
    supplier_email STRING,
    supplier_phone STRING,
    supplier_address STRING,
    supplier_city STRING,
    supplier_country STRING
) WITH (
    'connector' = 'kafka',
    'topic' = 'sales_topic',
    'properties.bootstrap.servers' = 'kafka:9092',
    'properties.group.id' = 'flink_consumer',
    'format' = 'json',
    'scan.startup.mode' = 'earliest-offset',
    'scan.bounded.mode' = 'latest-offset',
    'properties.auto.offset.reset' = 'earliest',
    'json.ignore-parse-errors' = 'true',         
    'json.timestamp-format.standard' = 'ISO-8601'
);


CREATE TABLE dim_customers (
    customer_id INT,
    first_name STRING,
    last_name STRING,
    age INT,
    customer_email STRING,
    customer_country STRING,
    customer_postal_code STRING,
    PRIMARY KEY (customer_id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://postgres:5432/sales_dw',
    'table-name' = 'dim_customers',
    'username' = 'postgres',
    'password' = 'postgres',
    'driver' = 'org.postgresql.Driver'
);

CREATE TABLE dim_sellers (
    seller_id INT,
    first_name STRING,
    last_name STRING,
    seller_email STRING,
    seller_country STRING,
    seller_postal_code STRING,
    PRIMARY KEY (seller_id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://postgres:5432/sales_dw',
    'table-name' = 'dim_sellers',
    'username' = 'postgres',
    'password' = 'postgres',
    'driver' = 'org.postgresql.Driver'
);

CREATE TABLE dim_products (
    product_id INT,
    name STRING,
    category STRING,
    price DECIMAL(10,2),
    quantity INT,
    weight DECIMAL(10,2),
    color STRING,
    size STRING,
    brand STRING,
    material STRING,
    description STRING,
    rating DECIMAL(3,2),
    reviews INT,
    release_date STRING,
    expiry_date STRING,
    PRIMARY KEY (product_id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://postgres:5432/sales_dw',
    'table-name' = 'dim_products',
    'username' = 'postgres',
    'password' = 'postgres',
    'driver' = 'org.postgresql.Driver'
);

CREATE TABLE dim_stores (
    store_id INT,
    name STRING,
    location STRING,
    store_city STRING,
    store_state STRING,
    store_country STRING,
    store_phone STRING,
    store_email STRING,
    PRIMARY KEY (store_id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://postgres:5432/sales_dw',
    'table-name' = 'dim_stores',
    'username' = 'postgres',
    'password' = 'postgres',
    'driver' = 'org.postgresql.Driver'
);




CREATE TABLE dim_suppliers (
    supplier_id INT,
    name STRING,
    contact STRING,
    supplier_email STRING,
    supplier_phone STRING,
    address STRING,
    supplier_city STRING,
    supplier_country STRING,
    PRIMARY KEY (supplier_id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://postgres:5432/sales_dw',
    'table-name' = 'dim_suppliers',
    'username' = 'postgres',
    'password' = 'postgres',
    'driver' = 'org.postgresql.Driver'
);

CREATE TABLE dim_pets (
    pet_id INT,
    pet_category STRING,
    pet_type STRING,
    name STRING,
    breed STRING,
    PRIMARY KEY (pet_id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://postgres:5432/sales_dw',
    'table-name' = 'dim_pets',
    'username' = 'postgres',
    'password' = 'postgres',
    'driver' = 'org.postgresql.Driver'
);


CREATE TABLE fact_sales (
    sale_id INT,
    customer_id INT,
    seller_id INT,
    product_id INT,
    store_id INT,
    supplier_id INT,
    pet_id INT,
    sale_date STRING,
    quantity INT,
    total_price DECIMAL(10,2),
    PRIMARY KEY (sale_id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://postgres:5432/sales_dw',
    'table-name' = 'fact_sales',
    'username' = 'postgres',
    'password' = 'postgres',
    'driver' = 'org.postgresql.Driver'
);


INSERT INTO dim_customers
SELECT DISTINCT
    id AS customer_id,
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code
FROM mock_data;

INSERT INTO dim_sellers
SELECT DISTINCT
    id AS seller_id,
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
FROM mock_data;

INSERT INTO dim_products
SELECT DISTINCT
    id AS product_id,
    product_name AS name,
    product_category AS category,
    product_price AS price,
    product_quantity AS quantity,
    product_weight AS weight,
    product_color AS color,
    product_size AS size,
    product_brand as brand,
    product_material as material,
    product_description AS description,
    product_rating AS rating,
    product_reviews AS reviews,
    product_release_date as release_date,
    product_expiry_date as expiry_date
FROM mock_data;

INSERT INTO dim_stores
SELECT DISTINCT
    id AS store_id,
    store_name AS name,
    store_location AS location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
FROM mock_data;

INSERT INTO dim_suppliers
SELECT DISTINCT
    id AS supplier_id,
    supplier_name AS name,
    supplier_contact AS contact,
    supplier_email,
    supplier_phone,
    supplier_address AS address,
    supplier_city,
    supplier_country
FROM mock_data;

INSERT INTO dim_pets
SELECT DISTINCT
    id AS pet_id,
    pet_category,
    customer_pet_type,
    customer_pet_name AS name,
    customer_pet_breed AS breed
FROM mock_data;


INSERT INTO fact_sales
SELECT
    CAST(mock.id AS INT) AS sale_id,
    cust.customer_id,
    sell.seller_id,
    prod.product_id,
    st.store_id,
    sup.supplier_id,
    pet.pet_id,
    mock.sale_date,
    mock.sale_quantity AS quantity,
    mock.sale_total_price AS total_price
FROM mock_data mock
JOIN dim_customers cust ON mock.id = cust.customer_id
JOIN dim_sellers sell ON mock.id = sell.seller_id 
JOIN dim_products prod ON mock.id = prod.product_id
JOIN dim_stores st ON mock.id = st.store_id
JOIN dim_suppliers sup ON mock.id = sup.supplier_id
JOIN dim_pets pet ON mock.id = pet.pet_id;