-- enabling uuid extension..

CREATE extension IF NOT EXISTS 'uuid-ossp';

--cars, quantity and prices table

CREATE TABLE IF NOT EXISTS car_comp(
    id UUID NOT NULL,
    cars VARCHAR(20) NOT NULL UNIQUE,  
    prices NUMERIC(10, 2) NOT NULL CHECK (prices > 0), --NUMERIC(10, 2) MEANS 10 DIGITS ALLOWED AND APPROXIMATE TO 2DP
    quantity INTEGER NOT NULL,
    stat VARCHAR(10) CHECK (stat = 'available' OR stat = 'sold') not null

);

--HISTORY TABLE

CREATE TABLE IF NOT EXISTS history(
    car VARCHAR(20),
    price NUMERIC(10,2) NOT NULL,
    order_quantity numeric(10, 2) NOT NULL,
    purchase_date TIMESTAMP DEFAULT NOW(),
    total_price NUMERIC(10, 2) NOT NULL GENERATED ALWAYS AS(price * order_quantity) STORED 
);

--Inserting into car_comp table

INSERT INTO car_comp(id, cars, prices, quantity, stat) VALUES (uuid_generate_v4(), 'rollsroyce_phantom', 1200000, 7, 'available');

INSERT INTO car_comp(id, cars, prices, quantity, stat) VALUES (uuid_generate_v4(), 'toyota_corolla', 89567.4567, 15, 'available');

INSERT INTO car_comp(id, cars, prices, quantity, stat) VALUES (uuid_generate_v4(), 'BMW', 650567.6785, 8, 'available');

INSERT INTO car_comp(id, cars, prices, quantity, stat) VALUES (uuid_generate_v4(), 'huyandai', 189000, 12, 'available');

INSERT INTO car_comp(id, cars, prices, quantity, stat) VALUES (uuid_generate_v4(), 'lamborghini', 2600000.6789, 6, 'available');

INSERT INTO car_comp(id, cars, prices, quantity, stat) VALUES (uuid_generate_v4(), 'ferrari', 1600000.7897, 7, 'available');

INSERT INTO car_comp(id, cars, prices, quantity, stat) VALUES (uuid_generate_v4(), 'G-wagon', 200000.0000, 0, 'sold');
--Inserting into history table

INSERT INTO history (car, price, order_quantity) VALUES ('ferrari', 1600000.7897, 3);
INSERT INTO history (car, price, order_quantity) VALUES ('rollsroyce_phantom', 1600000.7897, 4);
INSERT INTO history (car, price, order_quantity) VALUES ('toyota_corolla', 89567.4567, 6);
INSERT INTO history (car, price, order_quantity) VALUES ('BMW', 650567.6785, 5);
INSERT INTO history (car, price, order_quantity) VALUES ('huyandai', 189000, 7);
INSERT INTO history (car, price, order_quantity) VALUES ('lamborghini', 2600000, 4);
--INSERT INTO history (car, amount, order_quantity) VALUES ('G-wagon', 200000, );

--updating rollsroyce price

UPDATE car_comp SET prices = 900000 WHERE cars = 'rollsroyce_phantom';


--getting the car with the higest price in the table

SELECT cars, prices FROM car_comp ORDER BY prices DESC LIMIT 1;

--this provides the car with the highest price in the table acr_comp


--________________________

-- getting the car with the lowest price 
SELECT cars, prices FROM car_comp ORDER BY prices LIMIT 1;

--it provides the datyas in ascending order by default so i dont need to use ASC


--________________________

--ALTER car_comp table to add an array of price history outdated prices

ALTER TABLE car_comp ADD price_history numeric[];

--get the car with the highest quantity

SELECT cars, prices, quantity FROM car_comp ORDER BY quantity DESC LIMIT 1;


--GET THE CAR WITH THE LOWEST QUANTITY 

SELECT cars, prices, quantity FROM car_comp ORDER BY quantity LIMIT 1;

-- add or append some recent prices to the price_history array

UPDATE car_comp SET price_history = array_append(price_history, prices) WHERE cars = 'toyota_corolla';
UPDATE car_comp SET price_history = array_append(price_history, prices) WHERE cars = 'rollsroyce_phantom';
UPDATE car_comp SET price_history = array_append(price_history, prices) WHERE cars = 'BMW';
UPDATE car_comp SET price_history = array_append(price_history, prices) WHERE cars = 'G-wagon';
UPDATE car_comp SET price_history = array_append(price_history, prices) WHERE cars = 'ferrari';
UPDATE car_comp SET price_history = array_append(price_history, prices) WHERE cars = 'lamborghini';
UPDATE car_comp SET price_history = array_append(price_history, prices) WHERE cars = 'huyandai';

--update the price of lamborghini

UPDATE car_comp SET prices = 3000000 where cars = 'lamborghini';

-- append new price to lamborghini price_list

UPDATE car_comp SET price_history = array_append(price_history, prices) WHERE cars = 'lamborghini';

-- updating the price and price history of other cars
UPDATE car_comp SET prices = 3000000 where cars = 'toyota_corolla';
UPDATE car_comp SET prices = 2100000 where cars = 'rollsroyce_phantom';
UPDATE car_comp SET prices = 250695.6789 where cars = 'G-wagon';
UPDATE car_comp SET prices = 2567999.9999 where cars = 'ferrari';
UPDATE car_comp SET prices = 200000 where cars = 'huyandai';
UPDATE car_comp SET prices = 700598.8796 where cars = 'BMW';

-- price_history column in car_comp update

UPDATE car_comp SET price_history = array_append(price_history, prices) WHERE cars = 'toyota_corolla';
UPDATE car_comp SET price_history = array_append(price_history, prices) WHERE cars = 'rollsroyce_phantom';
UPDATE car_comp SET price_history = array_append(price_history, prices) WHERE cars = 'BMW';
UPDATE car_comp SET price_history = array_append(price_history, prices) WHERE cars = 'G-wagon';
UPDATE car_comp SET price_history = array_append(price_history, prices) WHERE cars = 'ferrari';
UPDATE car_comp SET price_history = array_append(price_history, prices) WHERE cars = 'huyandai';

--seelcting all the data from the car_comp table 
select * from car_comp;

-- selecting THE FIRST FIVE CARS FROM car_comp 

SELECT * FROM car_comp LIMIT 5;

-- altering the car_comp table and adding a new column cont

ALTER TABLE car_comp ADD cont BIGSERIAL;

-- selecting the last five cars from the table 
SELECT * FROM car_comp ORDER BY cont DESC LIMIT 5;

-- ALTERING THE TABLS car_comp and history by adding the unique constraint to the id of the car_comp and car of  the history table 

ALTER TABLE car_comp ADD CONSTRAINT idcons UNIQUE (id);

ALTER TABLE history ADD CONSTRAINT unicar UNIQUE(car);

-- indexing the array in car_comp to get a price of lamborghini 

SELECT price_history[1] FROM car_comp WHERE cars = 'lamborghini';

--deleting a car from the table car_comp rollsroys

DELETE FROM car_comp where cars = 'rollsroyce_phantom';

--conclusioin droping tables ......

DROP TABLE car_comp;
DROP TABLE history;

--yup done some stuff... rii
