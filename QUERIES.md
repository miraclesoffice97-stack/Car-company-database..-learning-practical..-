# 🔍 Query Reference — Car Company DB

A quick-reference cheat sheet for all queries and operations used in `car_comp.sql`.

---

## SELECT Queries

### Get all cars
```sql
SELECT * FROM car_comp;
```

### Most expensive car
```sql
SELECT cars, prices
FROM car_comp
ORDER BY prices DESC
LIMIT 1;
```

### Cheapest car
```sql
SELECT cars, prices
FROM car_comp
ORDER BY prices  -- ASC is default, no need to specify
LIMIT 1;
```

### Car with highest stock
```sql
SELECT cars, prices, quantity
FROM car_comp
ORDER BY quantity DESC
LIMIT 1;
```

### Car with lowest stock
```sql
SELECT cars, prices, quantity
FROM car_comp
ORDER BY quantity
LIMIT 1;
```

### First 5 cars
```sql
SELECT * FROM car_comp LIMIT 5;
```

### Last 5 cars (by insertion order)
```sql
SELECT * FROM car_comp ORDER BY cont DESC LIMIT 5;
```

### Get first price in history array for a specific car
```sql
SELECT price_history[1]    -- PostgreSQL arrays are 1-indexed
FROM car_comp
WHERE cars = 'lamborghini';
```

---

## UPDATE Operations

### Update a car's price
```sql
UPDATE car_comp SET prices = 3000000 WHERE cars = 'lamborghini';
```

### Append current price to price history
```sql
UPDATE car_comp
SET price_history = array_append(price_history, prices)
WHERE cars = 'lamborghini';
```

> 💡 **Best practice:** always append the old price to `price_history` *before* updating `prices`, so history stays accurate.

---

## INSERT Operations

### Add a car to inventory
```sql
INSERT INTO car_comp(id, cars, prices, quantity, stat)
VALUES (uuid_generate_v4(), 'car_name', 99999.99, 10, 'available');
```

### Record a purchase in history
```sql
INSERT INTO history (car, price, order_quantity)
VALUES ('car_name', 99999.99, 2);
-- total_price is auto-generated, purchase_date defaults to NOW()
```

---

## ALTER TABLE Operations

### Add an array column for price history
```sql
ALTER TABLE car_comp ADD price_history NUMERIC[];
```

### Add an auto-incrementing counter column
```sql
ALTER TABLE car_comp ADD cont BIGSERIAL;
```

### Add a unique constraint
```sql
ALTER TABLE car_comp ADD CONSTRAINT idcons UNIQUE (id);
ALTER TABLE history  ADD CONSTRAINT unicar UNIQUE (car);
```

---

## DELETE & DROP

### Remove a specific car
```sql
DELETE FROM car_comp WHERE cars = 'rollsroyce_phantom';
```

### Drop all tables (teardown)
```sql
DROP TABLE car_comp;
DROP TABLE history;
```

---

## Tips & Gotchas

- PostgreSQL arrays are **1-indexed** — `price_history[1]` is the first element.
- `total_price` in `history` is a **generated column** — never include it in an `INSERT`.
- `uuid_generate_v4()` requires the `uuid-ossp` extension to be enabled.
- `NUMERIC(10, 2)` allows up to 10 total digits with 2 decimal places.
- `stat` only accepts `'available'` or `'sold'` due to the `CHECK` constraint.
