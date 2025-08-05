-- Retrieve the total number of orders placed.

select count(distinct order_id)as total_orders from orders;-- 21350
-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(o.quantity * p.price), 2) AS total_revenue
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id;
    -- Identify the most common pizza size ordered.

SELECT 
    p.size, COUNT(o.order_details_id) AS order_count
FROM
    pizzas p
        JOIN
    order_details o ON p.pizza_id = o.pizza_id
GROUP BY p.size
ORDER BY order_count DESC
LIMIT 1;
-- Identify the highest-priced pizza.

SELECT 
    pi.name, p.price
FROM
    pizza_types pi
        JOIN
    pizzas p ON pi.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;
-- List the top 5 most ordered pizza types along with their quantities.

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
-- Join the necessary tables to find the total quantity of each pizza category ordered.
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
-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY 1
ORDER BY 2 DESC;
-- Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name) from pizza_types group by 1;
-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity), 0) AS average_pizza_orderd_perday
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS quantity
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY 1) AS order_quantity;
-- Determine the top 3 most ordered pizza types based on revenue.
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
-- Calculate the percentage contribution of each pizza type to total revenue. 
WITH category_wise_revenue AS
(SELECT 
    pt.category, SUM(o.quantity * p.price) AS revenue FROM
    pizza_types pt JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
	JOIN  order_details o ON o.pizza_id = p.pizza_id GROUP BY 1),
total_revenue as
(select round(sum(revenue),2)as total_revenue from category_wise_revenue)
SELECT cr.category,ROUND((cr.revenue / tr.total_revenue) * 100, 2) AS percentage_contribution 
FROM category_wise_revenue cr JOIN total_revenue tr ORDER BY percentage_contribution desc;

-- Analyze the cumulative revenue generated over time.
select order_date,sum(revenue) over(order by order_date) as cum_revenue from
(SELECT 
    o.order_date, round(sum(od.quantity * p.price),2) as revenue
FROM
    orders o
        JOIN
    order_details od ON o.order_id = od.order_id
        JOIN
    pizzas p ON p.pizza_id = od.pizza_id group by 1) as sales ;