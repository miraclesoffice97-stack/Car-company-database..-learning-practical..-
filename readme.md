# 🚗 Car Company Database — `car_comp`

A PostgreSQL project that models a car dealership's inventory and purchase history. It covers table creation, data seeding, querying, updates, schema alterations, and teardown.

---

## 📁 Project Structure

```
car_comp/
├── car_comp.sql       # Main SQL file — schema, seed data, queries & cleanup
├── README.md          # Project documentation (you're here)
├── SCHEMA.md          # Detailed schema reference
└── QUERIES.md         # Quick reference for all queries used
```

---

## 🗄️ Database Schema

### `car_comp` — Inventory Table
| Column          | Type            | Notes                                      |
|-----------------|-----------------|--------------------------------------------|
| `id`            | UUID            | Primary identifier, generated via `uuid_generate_v4()` |
| `cars`          | VARCHAR(20)     | Car name — must be unique                  |
| `prices`        | NUMERIC(10, 2)  | Must be greater than 0                     |
| `quantity`      | INTEGER         | Stock count                                |
| `stat`          | VARCHAR(10)     | Either `'available'` or `'sold'`           |
| `price_history` | NUMERIC[]       | Array of past prices (added via `ALTER`)   |
| `cont`          | BIGSERIAL       | Auto-incrementing row counter (added via `ALTER`) |

### `history` — Purchase History Table
| Column           | Type            | Notes                                          |
|------------------|-----------------|------------------------------------------------|
| `car`            | VARCHAR(20)     | Car name — unique constraint added later       |
| `price`          | NUMERIC(10, 2)  | Unit price at time of purchase                 |
| `order_quantity` | NUMERIC(10, 2)  | Number of units ordered                        |
| `purchase_date`  | TIMESTAMP       | Defaults to `NOW()`                            |
| `total_price`    | NUMERIC(10, 2)  | **Generated column** — `price * order_quantity` |

---

## 🚀 Getting Started

### Prerequisites
- [PostgreSQL](https://www.postgresql.org/) 12+
- The `uuid-ossp` extension enabled on your database

### Setup

```bash
# Connect to your database
psql -U your_username -d your_database

# Enable UUID generation (required before running the script)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

# Run the SQL file
\i car_comp.sql
```

---

## 🌱 Seed Data

The following cars are inserted into the `car_comp` table:

| Car                  | Price (USD)       | Quantity | Status    |
|----------------------|-------------------|----------|-----------|
| Rolls-Royce Phantom  | $1,200,000.00     | 7        | available |
| Toyota Corolla       | $89,567.46        | 15       | available |
| BMW                  | $650,567.68       | 8        | available |
| Hyundai              | $189,000.00       | 12       | available |
| Lamborghini          | $2,600,000.68     | 6        | available |
| Ferrari              | $1,600,000.79     | 7        | available |
| G-Wagon              | $200,000.00       | 0        | available |

---

## 🔍 Key Queries

```sql
-- Most expensive car
SELECT cars, prices FROM car_comp ORDER BY prices DESC LIMIT 1;

-- Cheapest car
SELECT cars, prices FROM car_comp ORDER BY prices LIMIT 1;

-- Car with highest stock
SELECT cars, prices, quantity FROM car_comp ORDER BY quantity DESC LIMIT 1;

-- Car with lowest stock
SELECT cars, prices, quantity FROM car_comp ORDER BY quantity LIMIT 1;

-- First 5 cars
SELECT * FROM car_comp LIMIT 5;

-- Last 5 cars (uses cont serial column)
SELECT * FROM car_comp ORDER BY cont DESC LIMIT 5;

-- Get first historical price for Lamborghini
SELECT price_history[1] FROM car_comp WHERE cars = 'lamborghini';
```

---

## 🛠️ Schema Changes Made (ALTER TABLE)

- Added `price_history NUMERIC[]` to track price changes over time
- Added `cont BIGSERIAL` for row ordering
- Added `UNIQUE` constraint on `car_comp.id`
- Added `UNIQUE` constraint on `history.car`

---

## 🧹 Teardown

```sql
DROP TABLE car_comp;
DROP TABLE history;
```

---

## 📝 Notes

- `total_price` in the `history` table is a **generated column** and cannot be inserted manually.
- `price_history` uses PostgreSQL's native array type with `array_append()` to log each price update.
- The `uuid-ossp` extension must be active for `uuid_generate_v4()` to work.

---

## 👤 Author

Car Company DB — a PostgreSQL learning project.
