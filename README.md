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
    pizza_type_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    ingredients TEXT
);

```
```
CREATE TABLE pizzas (
    pizza_id VARCHAR(10) PRIMARY KEY,
    pizza_type_id VARCHAR(10),
    size VARCHAR(20),
    price DOUBLE,
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id)
);

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

# Join the necessary tables to find the total quantity of each pizza category ordered.
```
SELECT 
    category, SUM(o.quantity) AS quantity
FROM
    pizza_types pi
        JOIN
    pizzas p ON pi.pizza_type_id = p.pizza_type_id
        JOIN
    order_details o ON o.pizza_id = p.pizza_id
GROUP BY 1
ORDER BY 2 DESC;
```
| category | quantity |
|----------|----------|
| Classic  | 14888    |
| Supreme  | 11987    |
| Veggie   | 11649    |
| Chicken  | 11050    |
# Determine the distribution of orders by hour of the day.
```
SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY 1
ORDER BY 2 DESC;
-- Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name) from pizza_types group by 1;
```
| hour | order_count |
|------|-------------|
| 12   | 2520        |
| 13   | 2455        |
| 18   | 2399        |
| 17   | 2336        |
| 19   | 2009        |
| 16   | 1920        |
| 20   | 1642        |
| 14   | 1472        |
| 15   | 1468        |
| 11   | 1231        |
| ...  | ...         |

# Join relevant tables to find the category-wise distribution of pizzas.
```
select category,count(name) from pizza_types group by 1;
```
| category | count(name) |
|----------|-------------|
| Chicken  | 6           |
| Classic  | 8           |
| Supreme  | 9           |
| Veggie   | 7           |

# Group the orders by date and calculate the average number of pizzas ordered per day.
```
SELECT 
    ROUND(AVG(quantity), 0) AS average_pizza_orderd_perday
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS quantity
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY 1) AS order_quantity;
```
| average_pizza_orderd_perday |
|-----------------------------|
| 138                         |

# Determine the top 3 most ordered pizza types based on revenue.
```
SELECT 
    pt.name, ROUND(SUM(o.quantity * p.price), 0) AS revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details o ON o.pizza_id = p.pizza_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;
```
| name                         | revenue |
|------------------------------|---------|
| The Thai Chicken Pizza       | 43434   |
| The Barbecue Chicken Pizza   | 42768   |
| The California Chicken Pizza | 41410   |

# Calculate the percentage contribution of each pizza type to total revenue. 
```
WITH category_wise_revenue AS
(SELECT 
    pt.category, SUM(o.quantity * p.price) AS revenue FROM
    pizza_types pt JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
	JOIN  order_details o ON o.pizza_id = p.pizza_id GROUP BY 1),
total_revenue as
(select round(sum(revenue),2)as total_revenue from category_wise_revenue)
SELECT cr.category,ROUND((cr.revenue / tr.total_revenue) * 100, 2) AS percentage_contribution 
FROM category_wise_revenue cr JOIN total_revenue tr ORDER BY percentage_contribution desc;
```
| category | percentage_contribution |
|----------|--------------------------|
| Classic  | 26.91                    |
| Supreme  | 25.46                    |
| Chicken  | 23.96                    |
| Veggie   | 23.68                    |

# Determine the top 3 most ordered pizza types based on revenue for each pizza category.
```
-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name,revenue from
(select category,name, revenue, rank() over(partition by category order by revenue desc) as rank_number from 
(SELECT 
    pt.category,pt.name, round(SUM(o.quantity * p.price),0) AS revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details o ON o.pizza_id = p.pizza_id
GROUP BY 1,2) as sales) as sales_2 where rank_number<=3;
```
| name                        | revenue |
|-----------------------------|---------|
| The Thai Chicken Pizza      | 43434   |
| The Barbecue Chicken Pizza  | 42768   |
| The California Chicken Pizza| 41410   |
| The Classic Deluxe Pizza    | 38180   |
| The Hawaiian Pizza          | 32273   |
| The Pepperoni Pizza         | 30162   |
| The Spicy Italian Pizza     | 34831   |
| The Italian Supreme Pizza   | 33477   |
| ...                         | ...     |













