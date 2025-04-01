-- E-commerce Analytics Database Project
-- Author: [Your Name]
-- Purpose: Demonstrate SQL proficiency for data analysis in an e-commerce context

-- Section 1: Database Schema Creation
-- Creating database (uncomment if needed)
-- CREATE DATABASE ecommerce_analytics;
-- USE ecommerce_analytics;

-- Creating customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    registration_date DATE NOT NULL,
    birth_date DATE,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')),
    loyalty_tier VARCHAR(20) DEFAULT 'Bronze',
    last_login_date TIMESTAMP
);

-- Creating product categories table
CREATE TABLE product_categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    parent_category_id INT,
    description TEXT,
    FOREIGN KEY (parent_category_id) REFERENCES product_categories(category_id)
);

-- Creating products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    supplier_id INT,
    price DECIMAL(10, 2) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    reorder_level INT DEFAULT 10,
    weight_kg DECIMAL(6, 2),
    dimensions VARCHAR(30),
    launch_date DATE,
    is_discontinued BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (category_id) REFERENCES product_categories(category_id)
);

-- Creating orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL,
    shipping_address TEXT NOT NULL,
    shipping_city VARCHAR(50) NOT NULL,
    shipping_state VARCHAR(50),
    shipping_country VARCHAR(50) NOT NULL,
    shipping_postal_code VARCHAR(20),
    shipping_method VARCHAR(30),
    payment_method VARCHAR(30),
    subtotal DECIMAL(10, 2) NOT NULL,
    shipping_cost DECIMAL(8, 2) NOT NULL,
    tax_amount DECIMAL(8, 2) NOT NULL,
    discount_amount DECIMAL(8, 2) DEFAULT 0,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Creating order_items table (junction table for orders and products)
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    discount_percent DECIMAL(5, 2) DEFAULT 0,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Creating suppliers table
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50),
    postal_code VARCHAR(20),
    active BOOLEAN DEFAULT TRUE
);

-- Creating marketing_campaigns table
CREATE TABLE marketing_campaigns (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    budget DECIMAL(12, 2),
    channel VARCHAR(50),
    target_audience VARCHAR(100),
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- Creating customer_interactions table
CREATE TABLE customer_interactions (
    interaction_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    campaign_id INT,
    interaction_date TIMESTAMP NOT NULL,
    channel VARCHAR(50) NOT NULL,
    interaction_type VARCHAR(50) NOT NULL,
    duration_seconds INT,
    notes TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (campaign_id) REFERENCES marketing_campaigns(campaign_id)
);

-- Creating inventory_transactions table
CREATE TABLE inventory_transactions (
    transaction_id INT PRIMARY KEY,
    product_id INT NOT NULL,
    transaction_date TIMESTAMP NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('Received', 'Shipped', 'Returned', 'Adjusted')),
    quantity INT NOT NULL,
    reference_id INT,
    notes TEXT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Section 2: Table Population with Sample Data

-- Inserting data into customers table
INSERT INTO customers (customer_id, first_name, last_name, email, phone, registration_date, birth_date, gender, loyalty_tier, last_login_date)
VALUES
    (1, 'John', 'Smith', 'john.smith@email.com', '555-123-4567', '2022-01-15', '1985-03-22', 'M', 'Silver', '2023-09-10 15:30:45'),
    (2, 'Emma', 'Johnson', 'emma.j@email.com', '555-234-5678', '2022-02-20', '1990-07-12', 'F', 'Gold', '2023-09-12 08:15:20'),
    (3, 'Michael', 'Brown', 'michael.b@email.com', '555-345-6789', '2022-03-05', '1978-11-30', 'M', 'Bronze', '2023-09-05 19:45:10'),
    (4, 'Sophia', 'Williams', 'sophia.w@email.com', '555-456-7890', '2022-03-18', '1995-05-28', 'F', 'Silver', '2023-09-11 12:20:35'),
    (5, 'Robert', 'Jones', 'robert.j@email.com', '555-567-8901', '2022-04-02', '1982-09-15', 'M', 'Bronze', '2023-08-30 09:10:15'),
    (6, 'Olivia', 'Davis', 'olivia.d@email.com', '555-678-9012', '2022-05-14', '1989-12-08', 'F', 'Platinum', '2023-09-12 17:30:25'),
    (7, 'William', 'Miller', 'william.m@email.com', '555-789-0123', '2022-06-21', '1975-04-19', 'M', 'Gold', '2023-09-09 14:55:30'),
    (8, 'Ava', 'Wilson', 'ava.w@email.com', '555-890-1234', '2022-07-09', '1992-08-03', 'F', 'Bronze', '2023-09-01 11:40:50'),
    (9, 'James', 'Taylor', 'james.t@email.com', '555-901-2345', '2022-08-17', '1987-02-25', 'M', 'Silver', '2023-09-08 16:15:40'),
    (10, 'Isabella', 'Anderson', 'isabella.a@email.com', '555-012-3456', '2022-09-03', '1993-10-11', 'F', 'Bronze', '2023-09-07 10:05:55');

-- Inserting data into product_categories table
INSERT INTO product_categories (category_id, category_name, parent_category_id, description)
VALUES
    (1, 'Electronics', NULL, 'Electronic devices and accessories'),
    (2, 'Smartphones', 1, 'Mobile phones and accessories'),
    (3, 'Laptops', 1, 'Portable computers'),
    (4, 'Clothing', NULL, 'Apparel and fashion items'),
    (5, 'Men''s Clothing', 4, 'Clothing items for men'),
    (6, 'Women''s Clothing', 4, 'Clothing items for women'),
    (7, 'Home & Kitchen', NULL, 'Home appliances and kitchenware'),
    (8, 'Kitchenware', 7, 'Kitchen utensils and appliances'),
    (9, 'Furniture', 7, 'Home and office furniture');

-- Inserting data into suppliers table
INSERT INTO suppliers (supplier_id, company_name, contact_name, contact_email, contact_phone, address, city, country, postal_code, active)
VALUES
    (1, 'TechSupply Inc.', 'David Chen', 'david.chen@techsupply.com', '555-111-2222', '123 Tech Blvd', 'San Jose', 'USA', '95123', TRUE),
    (2, 'Fashion Wholesale Ltd.', 'Sarah Johnson', 'sarah@fashionwholesale.com', '555-222-3333', '456 Fashion Ave', 'New York', 'USA', '10001', TRUE),
    (3, 'HomeGoods Supply Co.', 'Michael Rodriguez', 'michael@homegoods.com', '555-333-4444', '789 Home St', 'Chicago', 'USA', '60007', TRUE),
    (4, 'GlobalElectronics', 'Lisa Wong', 'lisa@globalelectronics.com', '555-444-5555', '101 Global Way', 'Shanghai', 'China', '200000', TRUE),
    (5, 'European Fashions', 'Pierre Dupont', 'pierre@eurofashions.com', '555-555-6666', '202 Fashion Blvd', 'Paris', 'France', '75001', TRUE);

-- Inserting data into products table
INSERT INTO products (product_id, product_name, category_id, supplier_id, price, cost, stock_quantity, reorder_level, weight_kg, dimensions, launch_date, is_discontinued)
VALUES
    (1, 'Smartphone X1', 2, 1, 699.99, 450.00, 50, 15, 0.18, '15x7x0.8 cm', '2023-01-10', FALSE),
    (2, 'Laptop Pro 15', 3, 1, 1299.99, 950.00, 25, 10, 2.20, '35x24x1.5 cm', '2022-11-15', FALSE),
    (3, 'Men''s Casual Shirt', 5, 2, 49.99, 20.00, 100, 30, 0.30, 'M/L/XL', '2023-03-20', FALSE),
    (4, 'Women''s Summer Dress', 6, 2, 79.99, 35.00, 75, 25, 0.40, 'XS/S/M/L', '2023-04-05', FALSE),
    (5, 'Coffee Maker Deluxe', 8, 3, 129.99, 65.00, 40, 15, 3.50, '30x25x40 cm', '2022-09-10', FALSE),
    (6, 'Office Desk Premium', 9, 3, 249.99, 150.00, 15, 5, 45.00, '120x60x75 cm', '2022-08-15', FALSE),
    (7, 'Smartphone X2', 2, 4, 899.99, 600.00, 35, 15, 0.19, '15x7.5x0.7 cm', '2023-05-15', FALSE),
    (8, 'Designer Handbag', 6, 5, 299.99, 150.00, 30, 10, 0.85, '35x25x15 cm', '2023-02-28', FALSE),
    (9, 'Wireless Earbuds', 2, 4, 149.99, 70.00, 60, 20, 0.06, '5x5x3 cm', '2023-03-10', FALSE),
    (10, 'Kitchen Knife Set', 8, 3, 89.99, 45.00, 45, 15, 1.20, '35x25x5 cm', '2022-10-20', FALSE),
    (11, 'Gaming Laptop', 3, 1, 1599.99, 1100.00, 20, 8, 2.80, '38x26x2 cm', '2022-12-15', FALSE),
    (12, 'Sofa Set', 9, 3, 1299.99, 800.00, 10, 5, 85.00, '220x90x85 cm', '2022-07-20', FALSE);

-- Inserting data into orders table
INSERT INTO orders (order_id, customer_id, order_date, status, shipping_address, shipping_city, shipping_state, shipping_country, shipping_postal_code, shipping_method, payment_method, subtotal, shipping_cost, tax_amount, discount_amount, total_amount)
VALUES
    (1, 1, '2023-01-20 14:30:00', 'Delivered', '123 Main St', 'Austin', 'TX', 'USA', '78701', 'Standard', 'Credit Card', 699.99, 10.00, 56.00, 0.00, 765.99),
    (2, 2, '2023-02-05 10:15:00', 'Delivered', '456 Oak Ave', 'Seattle', 'WA', 'USA', '98101', 'Express', 'PayPal', 1299.99, 20.00, 104.00, 100.00, 1323.99),
    (3, 3, '2023-03-12 16:45:00', 'Delivered', '789 Pine Rd', 'Miami', 'FL', 'USA', '33101', 'Standard', 'Credit Card', 49.99, 5.00, 4.00, 0.00, 58.99),
    (4, 4, '2023-04-18 09:30:00', 'Delivered', '101 Elm Blvd', 'Denver', 'CO', 'USA', '80201', 'Express', 'Credit Card', 129.99, 15.00, 10.40, 0.00, 155.39),
    (5, 5, '2023-05-25 11:20:00', 'Delivered', '202 Maple Dr', 'Portland', 'OR', 'USA', '97201', 'Standard', 'PayPal', 249.99, 25.00, 20.00, 25.00, 269.99),
    (6, 6, '2023-06-10 13:40:00', 'Shipped', '303 Cedar St', 'Boston', 'MA', 'USA', '02101', 'Express', 'Credit Card', 899.99, 20.00, 72.00, 50.00, 941.99),
    (7, 7, '2023-07-05 15:25:00', 'Shipped', '404 Birch Ave', 'Chicago', 'IL', 'USA', '60601', 'Standard', 'Credit Card', 449.98, 15.00, 36.00, 45.00, 455.98),
    (8, 8, '2023-08-15 10:10:00', 'Processing', '505 Walnut Rd', 'San Francisco', 'CA', 'USA', '94101', 'Express', 'PayPal', 1599.99, 25.00, 128.00, 150.00, 1602.99),
    (9, 9, '2023-09-02 14:50:00', 'Processing', '606 Cherry Blvd', 'New York', 'NY', 'USA', '10001', 'Standard', 'Credit Card', 149.99, 10.00, 12.00, 0.00, 171.99),
    (10, 10, '2023-09-10 09:35:00', 'Processing', '707 Ash Dr', 'Los Angeles', 'CA', 'USA', '90001', 'Express', 'Credit Card', 1389.98, 30.00, 111.20, 100.00, 1431.18),
    (11, 2, '2023-09-11 16:20:00', 'Processing', '456 Oak Ave', 'Seattle', 'WA', 'USA', '98101', 'Standard', 'PayPal', 89.99, 10.00, 7.20, 0.00, 107.19);

-- Inserting data into order_items table
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount_percent)
VALUES
    (1, 1, 1, 1, 699.99, 0.00),
    (2, 2, 2, 1, 1299.99, 7.69),
    (3, 3, 3, 1, 49.99, 0.00),
    (4, 4, 5, 1, 129.99, 0.00),
    (5, 5, 6, 1, 249.99, 10.00),
    (6, 6, 7, 1, 899.99, 5.56),
    (7, 7, 3, 2, 49.99, 0.00),
    (8, 7, 9, 1, 149.99, 15.00),
    (9, 8, 11, 1, 1599.99, 9.38),
    (10, 9, 9, 1, 149.99, 0.00),
    (11, 10, 2, 1, 1299.99, 7.69),
    (12, 10, 10, 1, 89.99, 0.00),
    (13, 11, 10, 1, 89.99, 0.00);

-- Inserting data into marketing_campaigns table
INSERT INTO marketing_campaigns (campaign_id, campaign_name, start_date, end_date, budget, channel, target_audience, description, is_active)
VALUES
    (1, 'New Year Sale', '2023-01-01', '2023-01-15', 5000.00, 'Email', 'All Customers', 'Start of the year promotion with 15% off selected items', FALSE),
    (2, 'Spring Collection Launch', '2023-03-01', '2023-03-31', 7500.00, 'Social Media', 'Fashion Enthusiasts', 'Introduction of new spring clothing line', FALSE),
    (3, 'Tech Expo Promotion', '2023-05-15', '2023-06-15', 10000.00, 'Multi-channel', 'Tech Enthusiasts', 'Special discounts during the annual Tech Expo', FALSE),
    (4, 'Summer Clearance', '2023-07-01', '2023-07-31', 6000.00, 'Email, SMS', 'All Customers', 'End of season clearance with up to 50% off', FALSE),
    (5, 'Back to School', '2023-08-15', '2023-09-15', 8000.00, 'Social Media, Email', 'Students, Parents', 'Promotional offers on laptops and electronics for students', TRUE),
    (6, 'Holiday Shopping Preview', '2023-11-01', '2023-11-30', 12000.00, 'Multi-channel', 'All Customers', 'Early preview of holiday deals and gift ideas', TRUE);

-- Inserting data into customer_interactions table
INSERT INTO customer_interactions (interaction_id, customer_id, campaign_id, interaction_date, channel, interaction_type, duration_seconds, notes)
VALUES
    (1, 1, 1, '2023-01-05 10:30:00', 'Email', 'Open', NULL, 'Opened New Year Sale email'),
    (2, 1, 1, '2023-01-05 10:32:00', 'Email', 'Click', NULL, 'Clicked on smartphone promotion'),
    (3, 2, 1, '2023-01-07 15:45:00', 'Website', 'Visit', 180, 'Visited New Year Sale landing page'),
    (4, 3, 2, '2023-03-10 12:20:00', 'Social Media', 'Click', NULL, 'Clicked on Spring Collection ad'),
    (5, 4, 2, '2023-03-12 09:15:00', 'Email', 'Open', NULL, 'Opened Spring Collection email'),
    (6, 5, 3, '2023-05-20 14:30:00', 'Website', 'Visit', 300, 'Browsed Tech Expo deals'),
    (7, 6, 3, '2023-06-01 16:40:00', 'Phone', 'Call', 420, 'Called about Tech Expo laptop promotion'),
    (8, 7, 4, '2023-07-15 11:25:00', 'SMS', 'Click', NULL, 'Clicked on Summer Clearance message link'),
    (9, 8, 5, '2023-08-20 13:10:00', 'Email', 'Open', NULL, 'Opened Back to School promotion email'),
    (10, 9, 5, '2023-08-25 17:35:00', 'Website', 'Visit', 240, 'Viewed Back to School laptop deals'),
    (11, 10, 5, '2023-09-01 10:05:00', 'Social Media', 'Click', NULL, 'Clicked on Back to School ad');

-- Inserting data into inventory_transactions table
INSERT INTO inventory_transactions (transaction_id, product_id, transaction_date, transaction_type, quantity, reference_id, notes)
VALUES
    (1, 1, '2022-12-20 09:30:00', 'Received', 60, NULL, 'Initial stock from supplier'),
    (2, 2, '2022-12-15 11:45:00', 'Received', 30, NULL, 'Initial stock from supplier'),
    (3, 1, '2023-01-20 14:35:00', 'Shipped', -1, 1, 'Order #1'),
    (4, 2, '2023-02-05 10:20:00', 'Shipped', -1, 2, 'Order #2'),
    (5, 3, '2023-03-12 16:50:00', 'Shipped', -1, 3, 'Order #3'),
    (6, 5, '2023-04-18 09:35:00', 'Shipped', -1, 4, 'Order #4'),
    (7, 6, '2023-05-25 11:25:00', 'Shipped', -1, 5, 'Order #5'),
    (8, 7, '2023-06-10 13:45:00', 'Shipped', -1, 6, 'Order #6'),
    (9, 3, '2023-07-05 15:30:00', 'Shipped', -2, 7, 'Order #7'),
    (10, 9, '2023-07-05 15:30:00', 'Shipped', -1, 7, 'Order #7'),
    (11, 3, '2023-07-10 14:15:00', 'Received', 50, NULL, 'Restocking popular item'),
    (12, 5, '2023-07-12 10:30:00', 'Adjusted', -2, NULL, 'Inventory count adjustment after audit'),
    (13, 10, '2023-07-20 11:45:00', 'Returned', 1, NULL, 'Customer return - damaged product');

-- Section 3: Basic Queries and Data Retrieval

-- Basic SELECT query with filtering
-- Find all Gold and Platinum tier customers
SELECT customer_id, first_name, last_name, email, loyalty_tier
FROM customers
WHERE loyalty_tier IN ('Gold', 'Platinum')
ORDER BY loyalty_tier, last_name;

-- Aggregation with GROUP BY
-- Calculate total sales by product category
SELECT 
    pc.category_name,
    COUNT(DISTINCT o.order_id) AS number_of_orders,
    SUM(oi.quantity) AS items_sold,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount_percent/100)) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_categories pc ON p.category_id = pc.category_id
JOIN orders o ON oi.order_id = o.order_id
GROUP BY pc.category_name
ORDER BY total_sales DESC;

-- JOIN operations
-- Detailed order information with customer and product details
SELECT 
    o.order_id,
    o.order_date,
    c.first_name || ' ' || c.last_name AS customer_name,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount_percent,
    (oi.quantity * oi.unit_price * (1 - oi.discount_percent/100)) AS item_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_date DESC, o.order_id;

-- Subqueries
-- Find products that have never been ordered
SELECT 
    p.product_id,
    p.product_name,
    p.price
FROM products p
WHERE p.product_id NOT IN (
    SELECT DISTINCT product_id
    FROM order_items
)
ORDER BY p.price DESC;

-- Window functions
-- Calculate running total of sales by day
SELECT 
    DATE(o.order_date) AS sale_date,
    SUM(o.total_amount) AS daily_sales,
    SUM(SUM(o.total_amount)) OVER (ORDER BY DATE(o.order_date)) AS running_total
FROM orders o
GROUP BY DATE(o.order_date)
ORDER BY sale_date;

-- Common Table Expressions (CTE)
-- Analyze customer purchasing patterns
WITH customer_purchase_summary AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        c.loyalty_tier,
        COUNT(DISTINCT o.order_id) AS order_count,
        SUM(o.total_amount) AS total_spent,
        AVG(o.total_amount) AS avg_order_value,
        MIN(o.order_date) AS first_purchase,
        MAX(o.order_date) AS last_purchase
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, customer_name, c.loyalty_tier
)
SELECT 
    customer_id,
    customer_name,
    loyalty_tier,
    order_count,
    total_spent,
    avg_order_value,
    first_purchase,
    last_purchase,
    DATE_PART('day', last_purchase - first_purchase) AS days_between_purchases
FROM customer_purchase_summary
ORDER BY total_spent DESC;

-- Section 4: Advanced Queries

-- CASE statements for data categorization
-- Categorize products by price range and create a price distribution analysis
SELECT 
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price BETWEEN 50 AND 100 THEN 'Mid-range'
        WHEN price BETWEEN 100 AND 500 THEN 'Premium'
        ELSE 'Luxury'
    END AS price_category,
    COUNT(*) AS product_count,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    AVG(price) AS avg_price,
    SUM(stock_quantity) AS total_stock
FROM products
GROUP BY price_category
ORDER BY min_price;

-- Pivot-like query to analyze sales by category and month
SELECT 
    pc.category_name,
    SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 1 THEN oi.quantity * oi.unit_price ELSE 0 END) AS Jan_sales,
    SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 2 THEN oi.quantity * oi.unit_price ELSE 0 END) AS Feb_sales,
    SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 3 THEN oi.quantity * oi.unit_price ELSE 0 END) AS Mar_sales,
    SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 4 THEN oi.quantity * oi.unit_price ELSE 0 END) AS Apr_sales,
    SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 5 THEN oi.quantity * oi.unit_price ELSE 0 END) AS May_sales,
    SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 6 THEN oi.quantity * oi.unit_price ELSE 0 END) AS Jun_sales,
    SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 7 THEN oi.quantity * oi.unit_price ELSE 0 END) AS Jul_sales,
    SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 8 THEN oi.quantity * oi.unit_price ELSE 0 END) AS Aug_sales,
    SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 9 THEN oi.quantity * oi.unit_price ELSE 0 END) AS Sep_sales,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_categories pc ON p.category_id = pc.category_id
JOIN orders o ON oi.order_id = o.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2023
GROUP BY pc.category_name
ORDER BY total_sales DESC;


-- Recursive CTE to navigate product category hierarchy 
WITH RECURSIVE category_hierarchy AS (
    -- Base case: top-level categories (no parent)
    SELECT 
        category_id, 
        category_name, 
        parent_category_id, 
        0 AS level, 
        category_name AS path
    FROM product_categories
    WHERE parent_category_id IS NULL
    
    UNION ALL
    
    -- Recursive case: categories with parents
    SELECT 
        c.category_id, 
        c.category_name, 
        c.parent_category_id, 
        ch.level + 1, 
        ch.path || ' > ' || c.category_name
    FROM product_categories c
    JOIN category_hierarchy ch ON c.parent_category_id = ch.category_id
)
SELECT 
    category_id,
    level,
    LPAD('', level*2, ' ') || category_name AS category_tree,
    path
FROM category_hierarchy
ORDER BY path;

-- Using window functions for customer segmentation by purchase behavior
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.loyalty_tier,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value,
    NTILE(4) OVER (ORDER BY SUM(o.total_amount) DESC) AS spending_quartile,
    RANK() OVER (ORDER BY COUNT(o.order_id) DESC) AS order_frequency_rank,
    DENSE_RANK() OVER (ORDER BY AVG(o.total_amount) DESC) AS avg_order_rank
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name, c.loyalty_tier
ORDER BY total_spent DESC NULLS LAST;

-- Complex reporting query for marketing campaign effectiveness
WITH campaign_interactions AS (
    SELECT 
        mc.campaign_id,
        mc.campaign_name,
        mc.channel,
        COUNT(DISTINCT ci.customer_id) AS unique_customers,
        COUNT(ci.interaction_id) AS total_interactions
    FROM marketing_campaigns mc
    LEFT JOIN customer_interactions ci ON mc.campaign_id = ci.campaign_id
    GROUP BY mc.campaign_id, mc.campaign_name, mc.channel
),
campaign_orders AS (
    SELECT 
        mc.campaign_id,
        COUNT(DISTINCT o.order_id) AS orders_placed,
        SUM(o.total_amount) AS campaign_revenue
    FROM marketing_campaigns mc
    JOIN customer_interactions ci ON mc.campaign_id = ci.campaign_id
    JOIN orders o ON ci.customer_id = o.customer_id
    WHERE o.order_date BETWEEN mc.start_date AND COALESCE(mc.end_date, CURRENT_DATE)
    GROUP BY mc.campaign_id
)
SELECT 
    ci.campaign_id,
    ci.campaign_name,
    ci.channel,
    ci.unique_customers,
    ci.total_interactions,
    COALESCE(co.orders_placed, 0) AS orders_placed,
    COALESCE(co.campaign_revenue, 0) AS campaign_revenue,
    CASE 
        WHEN ci.unique_customers > 0 THEN 
            ROUND((COALESCE(co.orders_placed, 0)::DECIMAL / ci.unique_customers) * 100, 2)
        ELSE 0
    END AS conversion_rate,
    CASE 
        WHEN ci.unique_customers > 0 THEN
            ROUND(COALESCE(co.campaign_revenue, 0) / ci.unique_customers, 2)
        ELSE 0
    END AS revenue_per_customer
FROM campaign_interactions ci
LEFT JOIN campaign_orders co ON ci.campaign_id = co.campaign_id
ORDER BY campaign_revenue DESC;

-- Section 5: Data Modification Examples

-- Example of updating data
-- Update product prices with inflation adjustment
UPDATE products
SET price = price * 1.05
WHERE category_id IN (
    SELECT category_id
    FROM product_categories
    WHERE category_name = 'Electronics' 
    OR parent_category_id = (SELECT category_id FROM product_categories WHERE category_name = 'Electronics')
);

-- Update customer loyalty tier based on spending patterns
UPDATE customers c
SET loyalty_tier = 
    CASE 
        WHEN stats.total_spent >= 2000 THEN 'Platinum'
        WHEN stats.total_spent >= 1000 THEN 'Gold'
        WHEN stats.total_spent >= 500 THEN 'Silver'
        ELSE 'Bronze'
    END
FROM (
    SELECT 
        customer_id, 
        SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
) stats
WHERE c.customer_id = stats.customer_id;

-- Example of inserting data with SELECT
-- Create a backup of orders for archiving
CREATE TABLE orders_archive AS
SELECT * FROM orders
WHERE order_date < '2023-07-01';

-- Example of DELETE with subquery
-- Remove discontinued products that haven't been ordered
DELETE FROM products
WHERE is_discontinued = TRUE
AND product_id NOT IN (
    SELECT DISTINCT product_id FROM order_items
);

-- Transactions for ensuring data integrity
BEGIN;
-- Record a new order
INSERT INTO orders (order_id, customer_id, order_date, status, shipping_address, shipping_city, shipping_state, shipping_country, shipping_postal_code, shipping_method, payment_method, subtotal, shipping_cost, tax_amount, discount_amount, total_amount)
VALUES (12, 5, CURRENT_TIMESTAMP, 'Processing', '202 Maple Dr', 'Portland', 'OR', 'USA', '97201', 'Express', 'Credit Card', 179.98, 15.00, 14.40, 0.00, 209.38);

-- Record the items in the order
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount_percent)
VALUES 
    (14, 12, 9, 1, 149.99, 0.00),
    (15, 12, 3, 1, 29.99, 0.00);

-- Update inventory levels
INSERT INTO inventory_transactions (transaction_id, product_id, transaction_date, transaction_type, quantity, reference_id, notes)
VALUES 
    (14, 9, CURRENT_TIMESTAMP, 'Shipped', -1, 12, 'Order #12'),
    (15, 3, CURRENT_TIMESTAMP, 'Shipped', -1, 12, 'Order #12');

UPDATE products
SET stock_quantity = stock_quantity - 1
WHERE product_id IN (9, 3);
COMMIT;

-- Section 6: Database Administration Tasks

-- Creating indexes for performance optimization
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_inventory_transactions_product_id ON inventory_transactions(product_id);

-- Creating a view for simplified reporting
CREATE OR REPLACE VIEW customer_order_summary AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    c.loyalty_tier,
    COUNT(o.order_id) AS order_count,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS most_recent_order_date,
    SUM(o.total_amount) AS lifetime_value,
    AVG(o.total_amount) AS average_order_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.loyalty_tier;

-- Creating a materialized view for performance-heavy reports
CREATE MATERIALIZED VIEW product_sales_analysis AS
SELECT 
    p.product_id,
    p.product_name,
    pc.category_id,
    pc.category_name,
    s.supplier_id,
    s.company_name AS supplier_name,
    COALESCE(SUM(oi.quantity), 0) AS units_sold,
    COALESCE(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_percent/100)), 0) AS total_revenue,
    p.cost AS unit_cost,
    COALESCE(SUM(oi.quantity * p.cost), 0) AS total_cost,
    COALESCE(SUM(oi.quantity * (oi.unit_price * (1 - oi.discount_percent/100) - p.cost)), 0) AS total_profit,
    CASE 
        WHEN SUM(oi.quantity * oi.unit_price * (1 - oi.discount_percent/100)) > 0 THEN
            ROUND((SUM(oi.quantity * (oi.unit_price * (1 - oi.discount_percent/100) - p.cost)) / 
                  SUM(oi.quantity * oi.unit_price * (1 - oi.discount_percent/100))) * 100, 2)
        ELSE 0
    END AS profit_margin
FROM products p
JOIN product_categories pc ON p.category_id = pc.category_id
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id
GROUP BY p.product_id, p.product_name, pc.category_id, pc.category_name, s.supplier_id, s.company_name, p.cost
ORDER BY total_profit DESC;

-- Create a function to calculate customer lifetime value
CREATE OR REPLACE FUNCTION calculate_customer_ltv(customer_id_param INT)
RETURNS TABLE (
    customer_id INT,
    customer_name TEXT,
    total_orders INT,
    total_spent DECIMAL(12,2),
    avg_order_value DECIMAL(12,2),
    first_purchase_date TIMESTAMP,
    last_purchase_date TIMESTAMP,
    days_as_customer INT,
    yearly_value DECIMAL(12,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        COUNT(o.order_id) AS total_orders,
        COALESCE(SUM(o.total_amount), 0) AS total_spent,
        COALESCE(AVG(o.total_amount), 0) AS avg_order_value,
        MIN(o.order_date) AS first_purchase_date,
        MAX(o.order_date) AS last_purchase_date,
        COALESCE(DATE_PART('day', MAX(o.order_date) - MIN(o.order_date)), 0) AS days_as_customer,
        CASE 
            WHEN DATE_PART('day', MAX(o.order_date) - MIN(o.order_date)) > 0 THEN
                COALESCE(SUM(o.total_amount) / (DATE_PART('day', MAX(o.order_date) - MIN(o.order_date)) / 365.0), 0)
            ELSE 0
        END AS yearly_value
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    WHERE c.customer_id = customer_id_param
    GROUP BY c.customer_id, c.first_name, c.last_name;
END;
$$ LANGUAGE plpgsql;

-- Create a stored procedure to refresh product inventory levels
CREATE OR REPLACE PROCEDURE refresh_product_stock_levels()
LANGUAGE plpgsql
AS $$
DECLARE
    product_rec RECORD;
BEGIN
    FOR product_rec IN SELECT product_id, stock_quantity FROM products WHERE stock_quantity <= reorder_level LOOP
        RAISE NOTICE 'Product ID % is below reorder level with % units in stock', product_rec.product_id, product_rec.stock_quantity;
        
        -- Log the reordering event
        INSERT INTO inventory_transactions (
            transaction_id,
            product_id,
            transaction_date,
            transaction_type,
            quantity,
            notes
        ) VALUES (
            (SELECT COALESCE(MAX(transaction_id), 0) + 1 FROM inventory_transactions),
            product_rec.product_id,
            CURRENT_TIMESTAMP,
            'Received',
            50,  -- Standard reorder quantity
            'Automatic reorder due to low stock'
        );
        
        -- Update the product stock level
        UPDATE products
        SET stock_quantity = stock_quantity + 50
        WHERE product_id = product_rec.product_id;
        
        RAISE NOTICE 'Reordered 50 units of product ID %, new stock level: %', 
            product_rec.product_id, 
            product_rec.stock_quantity + 50;
    END LOOP;
    
    COMMIT;
END;
$$;

-- Section 7: Advanced Business Analytics Queries

-- Customer Cohort Analysis: Retention rates by registration month
WITH cohort_items AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', registration_date) AS cohort_month
    FROM customers
),
user_activities AS (
    SELECT
        o.customer_id,
        DATE_TRUNC('month', o.order_date) AS order_month
    FROM orders o
),
cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS num_customers
    FROM cohort_items
    GROUP BY cohort_month
),
retention_table AS (
    SELECT
        ci.cohort_month,
        DATE_PART('month', ua.order_month - ci.cohort_month) AS month_number,
        COUNT(DISTINCT ua.customer_id) AS num_customers
    FROM cohort_items ci
    LEFT JOIN user_activities ua ON ci.customer_id = ua.customer_id
    WHERE ua.order_month >= ci.cohort_month
    GROUP BY ci.cohort_month, month_number
)
SELECT
    TO_CHAR(rt.cohort_month, 'YYYY-MM') AS cohort,
    cs.num_customers AS original_cohort_size,
    rt.month_number,
    rt.num_customers AS active_customers,
    ROUND(rt.num_customers::DECIMAL / cs.num_customers * 100, 1) AS retention_percentage
FROM retention_table rt
JOIN cohort_size cs ON rt.cohort_month = cs.cohort_month
ORDER BY rt.cohort_month, rt.month_number;

-- RFM (Recency, Frequency, Monetary) Customer Segmentation
WITH rfm_calculations AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        c.email,
        CURRENT_DATE - MAX(o.order_date)::DATE AS recency_days,
        COUNT(o.order_id) AS frequency,
        COALESCE(SUM(o.total_amount), 0) AS monetary
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email
),
rfm_scores AS (
    SELECT
        customer_id,
        customer_name,
        email,
        recency_days,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary) AS monetary_score
    FROM rfm_calculations
)
SELECT
    customer_id,
    customer_name,
    email,
    recency_days,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    recency_score + frequency_score + monetary_score AS total_rfm_score,
    CASE
        WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
        WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 3 THEN 'Loyal Customers'
        WHEN recency_score >= 4 AND frequency_score >= 1 AND monetary_score >= 1 THEN 'Promising'
        WHEN recency_score >= 3 AND frequency_score >= 1 AND monetary_score >= 1 THEN 'Customers Needing Attention'
        WHEN recency_score >= 2 AND frequency_score >= 2 AND monetary_score >= 2 THEN 'At Risk'
        WHEN recency_score >= 1 AND frequency_score >= 2 AND monetary_score >= 1 THEN 'Cant Lose Them'
        WHEN recency_score >= 1 AND frequency_score >= 1 AND monetary_score >= 2 THEN 'Hibernating'
        ELSE 'Lost'
    END AS customer_segment
FROM rfm_scores
ORDER BY total_rfm_score DESC;

-- Product Affinity Analysis (Market Basket Analysis)
WITH order_product_pairs AS (
    SELECT
        o1.order_id,
        p1.product_id AS product_1,
        p1.product_name AS product_1_name,
        p2.product_id AS product_2,
        p2.product_name AS product_2_name
    FROM order_items o1
    JOIN order_items o2 ON o1.order_id = o2.order_id AND o1.product_id < o2.product_id
    JOIN products p1 ON o1.product_id = p1.product_id
    JOIN products p2 ON o2.product_id = p2.product_id
),
product_counts AS (
    SELECT
        product_1,
        product_1_name,
        product_2,
        product_2_name,
        COUNT(*) AS pair_count
    FROM order_product_pairs
    GROUP BY product_1, product_1_name, product_2, product_2_name
),
individual_product_counts AS (
    SELECT
        product_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM order_items
    GROUP BY product_id
),
total_orders AS (
    SELECT COUNT(DISTINCT order_id) AS total FROM orders
)
SELECT
    pc.product_1,
    pc.product_1_name,
    pc.product_2,
    pc.product_2_name,
    pc.pair_count,
    ipc1.order_count AS product_1_count,
    ipc2.order_count AS product_2_count,
    ROUND(pc.pair_count::DECIMAL / ipc1.order_count * 100, 2) AS pct_of_product_1_orders,
    ROUND(pc.pair_count::DECIMAL / ipc2.order_count * 100, 2) AS pct_of_product_2_orders,
    ROUND(pc.pair_count::DECIMAL / to.total * 100, 2) AS pct_of_all_orders
FROM product_counts pc
JOIN individual_product_counts ipc1 ON pc.product_1 = ipc1.product_id
JOIN individual_product_counts ipc2 ON pc.product_2 = ipc2.product_id
CROSS JOIN total_orders to
ORDER BY pc.pair_count DESC;

-- Section 8: Performance Monitoring Queries

-- Identify slow-selling products that tie up inventory
SELECT
    p.product_id,
    p.product_name,
    p.price,
    p.stock_quantity,
    p.price * p.stock_quantity AS inventory_value,
    COALESCE(SUM(oi.quantity), 0) AS total_units_sold,
    CASE 
        WHEN COALESCE(SUM(oi.quantity), 0) > 0 THEN
            p.stock_quantity / COALESCE(SUM(oi.quantity), 0) * 30
        ELSE NULL
    END AS days_of_supply,
    CASE
        WHEN COALESCE(SUM(oi.quantity), 0) = 0 THEN 'No Sales'
        WHEN p.stock_quantity / COALESCE(SUM(oi.quantity), 0) * 30 > 90 THEN 'Overstocked'
        WHEN p.stock_quantity / COALESCE(SUM(oi.quantity), 0) * 30 BETWEEN 30 AND 90 THEN 'Healthy'
        WHEN p.stock_quantity / COALESCE(SUM(oi.quantity), 0) * 30 < 30 THEN 'Low Stock'
        ELSE 'Unknown'
    END AS inventory_status
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.order_date >= (CURRENT_DATE - INTERVAL '30 days')
GROUP BY p.product_id, p.product_name, p.price, p.stock_quantity
ORDER BY days_of_supply DESC NULLS FIRST;

-- Daily sales performance monitoring
SELECT
    DATE(o.order_date) AS sale_date,
    COUNT(o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(o.total_amount) AS total_revenue,
    SUM(o.total_amount) / COUNT(o.order_id) AS avg_order_value,
    SUM(oi.quantity) AS total_units_sold,
    COUNT(DISTINCT oi.product_id) AS unique_products_sold
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_date >= (CURRENT_DATE - INTERVAL '30 days')
GROUP BY sale_date
ORDER BY sale_date DESC;

-- Monitor shipping performance
SELECT
    o.shipping_method,
    COUNT(o.order_id) AS total_orders,
    AVG(o.shipping_cost) AS avg_shipping_cost,
    AVG(
        CASE
            WHEN o.status = 'Delivered' THEN 
                DATE_PART('day', o.delivery_date - o.order_date)
            ELSE NULL
        END
    ) AS avg_delivery_days,
    COUNT(
        CASE 
            WHEN o.status = 'Delivered' AND 
                 DATE_PART('day', o.delivery_date - o.order_date) > 
                 CASE 
                     WHEN o.shipping_method = 'Express' THEN 3
                     WHEN o.shipping_method = 'Standard' THEN 7
                     ELSE 10
                 END 
            THEN 1 
            ELSE NULL 
        END
    ) AS late_deliveries,
    ROUND(
        COUNT(
            CASE 
                WHEN o.status = 'Delivered' AND 
                     DATE_PART('day', o.delivery_date - o.order_date) > 
                     CASE 
                         WHEN o.shipping_method = 'Express' THEN 3
                         WHEN o.shipping_method = 'Standard' THEN 7
                         ELSE 10
                     END 
                THEN 1 
                ELSE NULL 
            END
        )::DECIMAL / 
        NULLIF(COUNT(CASE WHEN o.status = 'Delivered' THEN 1 END), 0) * 100, 
        2
    ) AS late_delivery_rate
FROM orders o
GROUP BY o.shipping_method
ORDER BY total_orders DESC;

-- Section 9: Data Export Examples

-- Export customer data to CSV
COPY (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.phone,
        c.registration_date,
        c.loyalty_tier,
        COUNT(o.order_id) AS total_orders,
        SUM(o.total_amount) AS total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.phone, c.registration_date, c.loyalty_tier
) TO '/tmp/customer_export.csv' WITH CSV HEADER;

-- Export sales report to CSV
COPY (
    SELECT 
        DATE_TRUNC('month', o.order_date) AS month,
        pc.category_name,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_percent/100)) AS revenue,
        SUM(oi.quantity * p.cost) AS cost,
        SUM(oi.quantity * (oi.unit_price * (1 - oi.discount_percent/100) - p.cost)) AS profit
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN product_categories pc ON p.category_id = pc.category_id
    WHERE o.order_date >= '2023-01-01' AND o.order_date < '2024-01-01'
    GROUP BY month, pc.category_name
    ORDER BY month, pc.category_name
) TO '/tmp/sales_report_2023.csv' WITH CSV HEADER;

-- Section 10: Data Enrichment and Business Rules Implementation

-- Create a trigger to automatically update last_updated timestamps
CREATE OR REPLACE FUNCTION update_last_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add last_updated columns to tables that need tracking
ALTER TABLE products ADD COLUMN last_updated TIMESTAMP;
ALTER TABLE customers ADD COLUMN last_updated TIMESTAMP;
ALTER TABLE orders ADD COLUMN last_updated TIMESTAMP;

-- Create triggers for each table
CREATE TRIGGER update_product_last_updated
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_last_modified_column();

CREATE TRIGGER update_customer_last_updated
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION update_last_modified_column();

CREATE TRIGGER update_order_last_updated
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION update_last_modified_column();

-- Create a trigger to automatically update inventory when orders are placed
CREATE OR REPLACE FUNCTION update_inventory_after_order()
RETURNS TRIGGER AS $$
BEGIN
    -- Update inventory for the product
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
    
    -- Create inventory transaction record
    INSERT INTO inventory_transactions (
        transaction_id,
        product_id,
        transaction_date,
        transaction_type,
        quantity,
        reference_id,
        notes
    ) VALUES (
        (SELECT COALESCE(MAX(transaction_id), 0) + 1 FROM inventory_transactions),
        NEW.product_id,
        CURRENT_TIMESTAMP,
        'Shipped',
        -NEW.quantity,
        NEW.order_id,
        'Order #' || NEW.order_id
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_order_item_insert
AFTER INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_inventory_after_order();

-- Create a function to calculate profit margins
CREATE OR REPLACE FUNCTION calculate_profit_margin(sale_price DECIMAL, cost_price DECIMAL)
RETURNS DECIMAL AS $$
BEGIN
    IF sale_price IS NULL OR cost_price IS NULL OR cost_price = 0 THEN
        RETURN NULL;
    ELSE
        RETURN ROUND(((sale_price - cost_price) / sale_price) * 100, 2);
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Example query using the profit margin function
SELECT
    p.product_id,
    p.product_name,
    p.price AS sale_price,
    p.cost AS cost_price,
    calculate_profit_margin(p.price, p.cost) AS profit_margin_percentage
FROM products p
ORDER BY profit_margin_percentage DESC;

-- Section 11: Data Quality Checks and Maintenance

-- Check for data inconsistencies
SELECT 'Products with negative stock' AS issue, COUNT(*) AS count
FROM products WHERE stock_quantity < 0
UNION ALL
SELECT 'Orders with negative total' AS issue, COUNT(*) 
FROM orders WHERE total_amount < 0
UNION ALL
SELECT 'Orders without items' AS issue, COUNT(*)
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL
UNION ALL
SELECT 'Customers without orders' AS issue, COUNT(*)
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
UNION ALL
SELECT 'Products never ordered' AS issue, COUNT(*)
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL
UNION ALL
SELECT 'Invalid email addresses' AS issue, COUNT(*)
FROM customers
WHERE email NOT LIKE '%@%.%'
ORDER BY count DESC;

-- Identify and fix orphaned records
-- Find order items with no corresponding order
SELECT oi.order_item_id, oi.order_id
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Find inventory transactions with invalid product references
SELECT transaction_id, product_id
FROM inventory_transactions
WHERE product_id NOT IN (SELECT product_id FROM products);

-- Vacuum analyze for database maintenance
VACUUM ANALYZE;

-- Section 12: Data Warehousing Examples

-- Create a fact table for sales analysis
CREATE TABLE sales_fact (
    sales_id SERIAL PRIMARY KEY,
    date_key INT NOT NULL,
    product_key INT NOT NULL,
    customer_key INT NOT NULL,
    supplier_key INT NOT NULL,
    campaign_key INT,
    units_sold INT NOT NULL,
    gross_revenue DECIMAL(12,2) NOT NULL,
    discounts DECIMAL(12,2) NOT NULL,
    net_revenue DECIMAL(12,2) NOT NULL,
    cost DECIMAL(12,2) NOT NULL,
    profit DECIMAL(12,2) NOT NULL
);

-- Create dimension tables for the data warehouse
CREATE TABLE date_dimension (
    date_key SERIAL PRIMARY KEY,
    full_date DATE NOT NULL,
    day_of_week INT NOT NULL,
    day_name VARCHAR(10) NOT NULL,
    day_of_month INT NOT NULL,
    day_of_year INT NOT NULL,
    week_of_year INT NOT NULL,
    month_number INT NOT NULL,
    month_name VARCHAR(10) NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    is_holiday BOOLEAN NOT NULL
);


-- Complete the sales fact table population
INSERT INTO sales_fact (
    date_key, 
    product_key, 
    customer_key, 
    supplier_key, 
    campaign_key, 
    units_sold, 
    gross_revenue, 
    discounts, 
    net_revenue, 
    cost, 
    profit
)
SELECT
    TO_CHAR(o.order_date, 'YYYYMMDD')::INT AS date_key,
    p.product_id AS product_key,
    c.customer_id AS customer_key,
    s.supplier_id AS supplier_key,
    mc.campaign_id AS campaign_key,
    oi.quantity AS units_sold,
    oi.quantity * oi.unit_price AS gross_revenue,
    oi.quantity * oi.unit_price * (oi.discount_percent/100) AS discounts,
    oi.quantity * oi.unit_price * (1 - oi.discount_percent/100) AS net_revenue,
    oi.quantity * p.cost AS cost,
    (oi.quantity * oi.unit_price * (1 - oi.discount_percent/100)) - (oi.quantity * p.cost) AS profit
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
LEFT JOIN marketing_campaigns mc ON o.order_date BETWEEN mc.start_date AND COALESCE(mc.end_date, CURRENT_DATE);

-- Create customer dimension table
CREATE TABLE customer_dimension (
    customer_key INT PRIMARY KEY,
    customer_id INT,
    full_name VARCHAR(150),
    email VARCHAR(100),
    age INT,
    gender CHAR(1),
    loyalty_tier VARCHAR(20),
    registration_year INT,
    total_orders INT,
    total_spent DECIMAL(12,2),
    last_order_date DATE
);

-- Populate customer dimension with slowly changing dimension type 2 logic
INSERT INTO customer_dimension
SELECT
    c.customer_id AS customer_key,
    c.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    c.email,
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM c.birth_date) AS age,
    c.gender,
    c.loyalty_tier,
    EXTRACT(YEAR FROM c.registration_date) AS registration_year,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spent,
    MAX(o.order_date)::DATE AS last_order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.birth_date, c.gender, c.loyalty_tier, c.registration_date;

-- Section 13: Advanced Analytical Queries

-- Customer Lifetime Value Prediction using Linear Regression
WITH customer_stats AS (
    SELECT
        customer_id,
        COUNT(order_id) AS order_count,
        SUM(total_amount) AS total_spent,
        AVG(total_amount) AS avg_order_value,
        MAX(order_date) AS last_order_date
    FROM orders
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.total_spent,
    c.order_count,
    (0.5 * c.order_count) + (0.3 * c.total_spent) + (0.2 * EXTRACT(DAY FROM CURRENT_DATE - c.last_order_date)) AS clv_score,
    NTILE(5) OVER (ORDER BY (0.5 * c.order_count) + (0.3 * c.total_spent) + (0.2 * EXTRACT(DAY FROM CURRENT_DATE - c.last_order_date)) DESC) AS clv_quintile
FROM customer_stats c;

-- Time Series Analysis with Date Dimension
SELECT
    dd.week_of_year,
    dd.year,
    SUM(sf.units_sold) AS total_units,
    SUM(sf.net_revenue) AS total_revenue,
    ROUND(AVG(SUM(sf.net_revenue)) OVER (ORDER BY dd.year, dd.week_of_year ROWS BETWEEN 3 PRECEDING AND CURRENT ROW), 2) AS revenue_4wk_avg
FROM sales_fact sf
JOIN date_dimension dd ON sf.date_key = dd.date_key
GROUP BY dd.year, dd.week_of_year
ORDER BY dd.year, dd.week_of_year;

-- Section 14: Advanced Data Manipulation

-- Create partitioned table for order history
CREATE TABLE orders_partitioned (
    order_id INT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20)
PARTITION BY RANGE (order_date);

CREATE TABLE orders_2022 PARTITION OF orders_partitioned
    FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');
    
CREATE TABLE orders_2023 PARTITION OF orders_partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Migrate data to partitioned table
INSERT INTO orders_partitioned
SELECT order_id, customer_id, order_date::DATE, total_amount, status
FROM orders;

-- Section 15: Data Visualization Preparation

-- Monthly Sales Growth Report
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(total_amount) AS total_sales,
        LAG(SUM(total_amount), 1) OVER (ORDER BY DATE_TRUNC('month', order_date)) AS prev_month_sales
    FROM orders
    GROUP BY month
)
SELECT
    TO_CHAR(month, 'YYYY-MM') AS month,
    total_sales,
    prev_month_sales,
    ROUND(((total_sales - prev_month_sales)/prev_month_sales)*100, 2) AS growth_percent
FROM monthly_sales
ORDER BY month;

-- Customer Geographic Heatmap Data
SELECT
    shipping_country,
    shipping_state,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_revenue,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM orders
GROUP BY shipping_country, shipping_state
ORDER BY shipping_country, total_revenue DESC;

-- Section 16: Query Optimization

-- Explain Analyze for Performance Tuning
EXPLAIN ANALYZE
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
WHERE p.category_id = 2
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;

-- Create Index for Frequently Queries
CREATE INDEX idx_orders_order_date_status ON orders(order_date, status);
CREATE INDEX idx_products_category_price ON products(category_id, price);

-- Section 17: Advanced Reporting

-- Dynamic Pivot Table for Category Sales
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM crosstab(
    'SELECT category_name, EXTRACT(quarter FROM order_date) AS qtr, SUM(total_amount)
     FROM orders o
     JOIN order_items oi ON o.order_id = oi.order_id
     JOIN products p ON oi.product_id = p.product_id
     JOIN product_categories pc ON p.category_id = pc.category_id
     WHERE EXTRACT(year FROM order_date) = 2023
     GROUP BY category_name, qtr
     ORDER BY 1,2',
    'VALUES (1),(2),(3),(4)'
) AS final_result (
    Category VARCHAR,
    Q1_Sales DECIMAL,
    Q2_Sales DECIMAL,
    Q3_Sales DECIMAL,
    Q4_Sales DECIMAL
);

-- Section 18: Data Quality Assurance

-- Automated Data Validation View
CREATE VIEW data_quality_checks AS
SELECT
    'Orders without items' AS check_name,
    COUNT(*) AS issue_count
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL
UNION ALL
SELECT
    'Negative stock quantities' AS check_name,
    COUNT(*) 
FROM products 
WHERE stock_quantity < 0;

-- Section 19: Documentation and Metadata

-- Comment Complex Structures
COMMENT ON MATERIALIZED VIEW product_sales_analysis IS 
'Materialized view providing comprehensive sales analysis with profit margins. Refreshed daily.';

COMMENT ON COLUMN customers.loyalty_tier IS 
'Tiered customer status based on spending: Bronze, Silver, Gold, Platinum';

-- Section 20: Project Conclusion

-- Final Database Health Check
ANALYZE VERBOSE;
REINDEX DATABASE ecommerce_analytics;

-- Export Final Schema Documentation
COMMENT ON DATABASE ecommerce_analytics IS 
'E-commerce Analytics Database - Version 1.2 - Contains operational data and analytical structures for comprehensive business analysis';
