# pizzahut
# creating The Database
```
CREATE DATABASE pizza_hut;
USE pizza_hut;
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);
```
```
CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);
```
```
CREATE TABLE pizza_types (
    pizza_type_id TEXT PRIMARY KEY,
    name TEXT,
    category TEXT,
    ingredients TEXT
);
```
```
CREATE TABLE pizzas (
    pizza_id TEXT PRIMARY KEY,
    pizza_type_id TEXT,
    size TEXT,
    price DOUBLE,
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id)
);
```
# Retrieve the total number of orders placed.
```
select count(distinct order_id)as total_orders from orders;
```
| total_orders |
|--------------|
| 21350        |


 # Calculate the total revenue generated from pizza sales.
```
SELECT 
    ROUND(SUM(o.quantity * p.price), 2) AS total_revenue
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id;
```
| total_revenue |
|---------------|
| 81760.05      |

  # Identify the most common pizza size ordered.
```
SELECT 
    p.size, COUNT(o.order_details_id) AS order_count
FROM
    pizzas p
        JOIN
    order_details o ON p.pizza_id = o.pizza_id
GROUP BY p.size
ORDER BY order_count DESC
LIMIT 1;
```
| size | order_count |
|------|-------------|
| L    | 18526       |



