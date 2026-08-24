create table customers (
    customer_id VARCHAR(20) primary key,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    city VARCHAR(100),
    signup_date DATE,
    age INTEGER,
    full_name VARCHAR(200)
);


create table products (
    product_id VARCHAR(20) primary key,
    product_name VARCHAR(200),
    category VARCHAR(100),
    brand VARCHAR(100),
    unit_cost NUMERIC(10,2),
    list_price NUMERIC(10,2)
);


create table orders (
    order_id VARCHAR(20) primary key,
    customer_id VARCHAR(20),
    order_date DATE,
    payment_method VARCHAR(100),
    sales_channel VARCHAR(100),
    order_status VARCHAR(100),
    shipping_city VARCHAR(100),
    shipping_fee NUMERIC(10,2),
    
    foreign key (customer_id)
        references customers(customer_id)
);


create table order_items (
    order_item_id VARCHAR(20) primary key,
    order_id VARCHAR(20),
    product_id VARCHAR(20),
    quantity INTEGER,
    unit_price NUMERIC(10,2),
    discount_pct NUMERIC(5,2),
    
    foreign key (order_id)
        references orders(order_id),
    foreign key (product_id)
        references products(product_id)
); 

create table returns (
    return_id VARCHAR(20) primary key,
    order_id VARCHAR(20),
    return_date DATE,
    return_reason VARCHAR(100),
    refund_amount NUMERIC(10,2),
    
    foreign key (order_id)
        references orders(order_id)
);