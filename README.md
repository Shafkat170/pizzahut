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
