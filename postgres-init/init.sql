
--Теперь звезда, вместо снежинки
--Убрал атрибут ключевой sourse, дабы не париться из-за составного ключа. - вместо этогов producer происходит инкримент:3
--Ради отсутствия необходимости для звезды считать количество символов в каждой из строк - заменил varchar на text.
CREATE TABLE IF NOT EXISTS dim_customers (
    customer_id INT,
    first_name TEXT,
    last_name TEXT,
    age INT,
    customer_email TEXT,
    customer_country TEXT,
    customer_postal_code TEXT,
    PRIMARY KEY (customer_id)
);

CREATE TABLE IF NOT EXISTS dim_sellers (
    seller_id INT,
    first_name TEXT,
    last_name TEXT,
    seller_email TEXT,
    seller_country TEXT,
    seller_postal_code TEXT,
    PRIMARY KEY (seller_id)
);

CREATE TABLE IF NOT EXISTS dim_products (
    product_id INT,
    name TEXT,
    category TEXT,
    price DECIMAL(10,2),
    quantity INT,
    weight DECIMAL(10,2),
    color TEXT,
    size TEXT,
    brand TEXT,
    material TEXT,
    description TEXT,
    rating DECIMAL(3,2),
    reviews INT,
    release_date TEXT,
    expiry_date TEXT,
    PRIMARY KEY (product_id)
);

CREATE TABLE IF NOT EXISTS dim_stores (
    store_id INT,
    name TEXT,
    location TEXT,
    store_city TEXT,
    store_state TEXT,
    store_country TEXT,
    store_phone TEXT,
    store_email TEXT,
    PRIMARY KEY (store_id)
);




CREATE TABLE IF NOT EXISTS dim_suppliers (
    supplier_id INT,
    name TEXT,
    contact TEXT,
    supplier_email TEXT,
    supplier_phone TEXT,
    address TEXT,
    supplier_city TEXT,
    supplier_country TEXT,
    PRIMARY KEY (supplier_id)
);

CREATE TABLE IF NOT EXISTS dim_pets (
    pet_id INT,
    pet_category TEXT,
    pet_type TEXT,
    name TEXT,
    breed TEXT,
    PRIMARY KEY (pet_id)
);


CREATE TABLE IF NOT EXISTS fact_sales (
    sale_id INT,
    customer_id INT,
    seller_id INT,
    product_id INT,
    store_id INT,
    supplier_id INT,
    pet_id INT,
    sale_date TEXT,
    quantity INT,
    total_price DECIMAL(10,2),
    PRIMARY KEY (sale_id)
);

