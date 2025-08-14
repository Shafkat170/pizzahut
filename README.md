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

# Identify the highest-priced pizza.
```
SELECT 
    pi.name, p.price
FROM
    pizza_types pi
        JOIN
    pizzas p ON pi.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;
```
| name            | price |
|-----------------|-------|
| The Greek Pizza | 35.95 |
# List the top 5 most ordered pizza types along with their quantities.
```
SELECT 
    pi.name, SUM(o.quantity) AS quantity
FROM
    pizza_types pi
        JOIN
    pizzas p ON pi.pizza_type_id = p.pizza_type_id
        JOIN
    order_details o ON o.pizza_id = p.pizza_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```
| name                        | quantity |
|-----------------------------|----------|
| The Classic Deluxe Pizza    | 2453     |
| The Barbecue Chicken Pizza  | 2432     |
| The Hawaiian Pizza          | 2422     |
| The Pepperoni Pizza         | 2418     |
| The Thai Chicken Pizza      | 2371     |







