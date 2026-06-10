# 📐 Schema Reference — Car Company DB

Full schema documentation for all tables in the `car_comp` project.

---

## Table: `car_comp`

> Stores the dealership's car inventory.

```sql
CREATE TABLE IF NOT EXISTS car_comp(
    id            UUID          NOT NULL,
    cars          VARCHAR(20)   NOT NULL UNIQUE,
    prices        NUMERIC(10,2) NOT NULL CHECK (prices > 0),
    quantity      INTEGER       NOT NULL,
    stat          VARCHAR(10)   NOT NULL CHECK (stat = 'available' OR stat = 'sold'),

    -- Added later via ALTER TABLE:
    price_history NUMERIC[],
    cont          BIGSERIAL
);
```

### Column Details

| Column          | Constraint                          | Description                                         |
|-----------------|-------------------------------------|-----------------------------------------------------|
| `id`            | NOT NULL, UNIQUE (added via ALTER)  | UUID generated with `uuid_generate_v4()`            |
| `cars`          | NOT NULL, UNIQUE                    | Car model name (max 20 chars)                       |
| `prices`        | NOT NULL, CHECK > 0                 | Current listing price, 10 digits, 2 decimal places  |
| `quantity`      | NOT NULL                            | Units currently in stock                            |
| `stat`          | NOT NULL, CHECK IN (available/sold) | Availability status                                 |
| `price_history` | —                                   | Array of previous prices, appended on each update   |
| `cont`          | BIGSERIAL (auto-increment)          | Row counter used for ordering / pagination          |

---

## Table: `history`

> Records purchase transactions.

```sql
CREATE TABLE IF NOT EXISTS history(
    car            VARCHAR(20),
    price          NUMERIC(10,2)  NOT NULL,
    order_quantity NUMERIC(10,2)  NOT NULL,
    purchase_date  TIMESTAMP      DEFAULT NOW(),
    total_price    NUMERIC(10,2)  NOT NULL GENERATED ALWAYS AS (price * order_quantity) STORED,

    -- Added later via ALTER TABLE:
    CONSTRAINT unicar UNIQUE(car)
);
```

### Column Details

| Column           | Constraint                          | Description                                        |
|------------------|-------------------------------------|----------------------------------------------------|
| `car`            | UNIQUE (added via ALTER)            | Car name, references cars in `car_comp`            |
| `price`          | NOT NULL                            | Unit price at time of sale                         |
| `order_quantity` | NOT NULL                            | How many units were ordered                        |
| `purchase_date`  | DEFAULT NOW()                       | Timestamp of transaction                           |
| `total_price`    | GENERATED ALWAYS AS (stored)        | Auto-calculated: `price × order_quantity`          |

---

## Constraints Summary

| Table      | Constraint Name | Type   | Column   |
|------------|-----------------|--------|----------|
| `car_comp` | (inline)        | UNIQUE | `cars`   |
| `car_comp` | `idcons`        | UNIQUE | `id`     |
| `car_comp` | (inline)        | CHECK  | `prices > 0` |
| `car_comp` | (inline)        | CHECK  | `stat IN ('available', 'sold')` |
| `history`  | `unicar`        | UNIQUE | `car`    |

---

## Extension Required

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

This must be run before any `uuid_generate_v4()` call.
