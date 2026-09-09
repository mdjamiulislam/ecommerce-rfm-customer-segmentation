-- =====================================================
-- Lesson: 32
-- Topic: Calculate Customer Purchase Frequency
-- Database: ecommerce_rfm
-- Schema: public
-- Project: E-Commerce Customer Segmentation
-- Author: Md Jamiul Islam
-- Purpose: Calculate and analyse RFM purchase Frequency
-- =====================================================


-- =====================================================
-- SECTION 1: CONNECTION CHECK
-- =====================================================

SELECT
    current_database() AS database_name,
    current_schema() AS schema_name,
    current_user AS connected_user;


-- =====================================================
-- SECTION 2: CREATE CUSTOMER TABLE
-- =====================================================

DROP TABLE IF EXISTS lesson32_customers;

CREATE TEMP TABLE lesson32_customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(50),
    home_country VARCHAR(100),
    loyalty_tier VARCHAR(20)
);


INSERT INTO lesson32_customers (
    customer_id,
    customer_name,
    home_country,
    loyalty_tier
)
VALUES
    ('1001', 'Customer A', 'United Kingdom', 'Gold'),
    ('1002', 'Customer B', 'France', 'Silver'),
    ('1003', 'Customer C', 'Germany', 'Bronze'),
    ('1004', 'Customer D', 'Spain', 'Silver'),
    ('1005', 'Customer E', 'Australia', 'Gold'),
    ('1006', 'Customer F', 'Ireland', 'Bronze'),
    ('1007', 'Customer G', 'Netherlands', 'Silver');


-- =====================================================
-- SECTION 3: CREATE TRANSACTION TABLE
-- =====================================================

DROP TABLE IF EXISTS lesson32_transactions;

CREATE TEMP TABLE lesson32_transactions (
    sale_id INTEGER PRIMARY KEY,
    invoice_no VARCHAR(20),
    customer_id VARCHAR(20),
    product_name VARCHAR(100),
    quantity INTEGER,
    unit_price NUMERIC(12, 2),
    invoice_date TIMESTAMP
);


-- =====================================================
-- SECTION 4: INSERT TRANSACTIONS
-- =====================================================

INSERT INTO lesson32_transactions (
    sale_id,
    invoice_no,
    customer_id,
    product_name,
    quantity,
    unit_price,
    invoice_date
)
VALUES
    (1, 'INV001', '1001', 'Desk Lamp',
     2, 10.00, '2026-08-01 09:00:00'),

    (2, 'INV001', '1001', 'Notebook',
     1, 5.00, '2026-08-01 09:00:00'),

    (3, 'INV002', '1001', 'Storage Box',
     3, 8.00, '2026-08-03 14:15:00'),

    (4, 'INV003', '1002', 'Coffee Mug',
     4, 7.50, '2026-08-04 10:30:00'),

    (5, 'INV004', '1003', 'Wall Clock',
     2, 12.00, '2026-08-05 11:20:00'),

    (6, 'INV005', '1004', 'Gift Bag',
     5, 4.00, '2026-08-06 15:45:00'),

    (7, 'INV006', '1005', 'Premium Hamper',
     1, 50.00, '2026-08-07 17:00:00'),

    (8, 'INV007', '1002', 'Photo Frame',
     2, 9.00, '2026-08-08 12:10:00'),

    (9, 'INV008', '1003', 'Tea Set',
     3, 6.00, '2026-08-09 13:30:00'),

    (10, 'INV009', '1004', 'Travel Bag',
     1, 15.00, '2026-08-10 16:00:00'),

    (11, 'INV010', '1005', 'Gift Basket',
     2, 20.00, '2026-08-11 10:15:00'),

    (12, 'INV011', '1005', 'Premium Tea Set',
     1, 30.00, '2026-08-12 11:45:00'),

    (13, 'INV012', '1006', 'Storage Basket',
     2, 6.00, '2026-08-13 14:00:00');


-- =====================================================
-- SECTION 5: PREVIEW TRANSACTIONS
-- =====================================================

SELECT
    sale_id,
    invoice_no,
    customer_id,
    product_name,
    quantity,
    unit_price,

    ROUND(
        quantity * unit_price,
        2
    ) AS line_revenue,

    invoice_date

FROM lesson32_transactions

ORDER BY sale_id;


-- =====================================================
-- SECTION 6: TRANSACTION LINES VS INVOICES
-- =====================================================

SELECT
    COUNT(*) AS transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS distinct_invoices,

    COUNT(DISTINCT customer_id)
        AS purchasing_customers

FROM lesson32_transactions;


-- =====================================================
-- SECTION 7: CUSTOMER LINE COUNT VS FREQUENCY
-- =====================================================

SELECT
    customer_id,

    COUNT(*)
        AS transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS frequency

FROM lesson32_transactions

GROUP BY customer_id

ORDER BY customer_id;


-- =====================================================
-- SECTION 8: BASIC CUSTOMER FREQUENCY
-- =====================================================

SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency

FROM lesson32_transactions

GROUP BY customer_id

ORDER BY
    frequency DESC,
    customer_id;


-- =====================================================
-- SECTION 9: FREQUENCY + PURCHASE DATES
-- =====================================================

SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    MIN(invoice_date)::DATE
        AS first_purchase,

    MAX(invoice_date)::DATE
        AS last_purchase

FROM lesson32_transactions

GROUP BY customer_id

ORDER BY
    frequency DESC,
    customer_id;


-- =====================================================
-- SECTION 10: FREQUENCY + MONETARY
-- =====================================================

SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS monetary_value

FROM lesson32_transactions

GROUP BY customer_id

ORDER BY
    frequency DESC,
    monetary_value DESC;


-- =====================================================
-- SECTION 11: ONE-TIME CUSTOMERS
-- =====================================================

SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency

FROM lesson32_transactions

GROUP BY customer_id

HAVING COUNT(DISTINCT invoice_no) = 1

ORDER BY customer_id;


-- =====================================================
-- SECTION 12: REPEAT CUSTOMERS
-- =====================================================

SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency

FROM lesson32_transactions

GROUP BY customer_id

HAVING COUNT(DISTINCT invoice_no) >= 2

ORDER BY
    frequency DESC,
    customer_id;


-- =====================================================
-- SECTION 13: HIGH-FREQUENCY CUSTOMERS
-- =====================================================

SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency

FROM lesson32_transactions

GROUP BY customer_id

HAVING COUNT(DISTINCT invoice_no) >= 3

ORDER BY frequency DESC;


-- =====================================================
-- SECTION 14: FREQUENCY CATEGORY
-- =====================================================

SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    CASE
        WHEN COUNT(DISTINCT invoice_no) >= 3
            THEN 'High Frequency'

        WHEN COUNT(DISTINCT invoice_no) = 2
            THEN 'Repeat Customer'

        ELSE 'One-Time Customer'
    END AS frequency_category

FROM lesson32_transactions

GROUP BY customer_id

ORDER BY
    frequency DESC,
    customer_id;


-- =====================================================
-- SECTION 15: INCLUDE ZERO-PURCHASE CUSTOMERS
-- =====================================================

SELECT
    c.customer_id,
    c.customer_name,

    COUNT(DISTINCT t.invoice_no)
        AS frequency

FROM lesson32_customers AS c

LEFT JOIN lesson32_transactions AS t
    ON c.customer_id = t.customer_id

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY
    frequency DESC,
    c.customer_id;


-- =====================================================
-- SECTION 16: ALL-CUSTOMER FREQUENCY CATEGORY
-- =====================================================

SELECT
    c.customer_id,
    c.customer_name,

    COUNT(DISTINCT t.invoice_no)
        AS frequency,

    CASE
        WHEN COUNT(DISTINCT t.invoice_no) = 0
            THEN 'No Purchase'

        WHEN COUNT(DISTINCT t.invoice_no) = 1
            THEN 'One-Time Customer'

        WHEN COUNT(DISTINCT t.invoice_no) = 2
            THEN 'Repeat Customer'

        ELSE 'High Frequency'
    END AS frequency_category

FROM lesson32_customers AS c

LEFT JOIN lesson32_transactions AS t
    ON c.customer_id = t.customer_id

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY
    frequency DESC,
    c.customer_id;


-- =====================================================
-- SECTION 17: COUNT(*) LEFT-JOIN DEMONSTRATION
-- =====================================================

SELECT
    c.customer_id,

    COUNT(*)
        AS count_star,

    COUNT(t.sale_id)
        AS transaction_lines,

    COUNT(DISTINCT t.invoice_no)
        AS frequency

FROM lesson32_customers AS c

LEFT JOIN lesson32_transactions AS t
    ON c.customer_id = t.customer_id

GROUP BY c.customer_id

ORDER BY c.customer_id;


-- =====================================================
-- SECTION 18: AVERAGE FREQUENCY
-- PURCHASING CUSTOMERS
-- =====================================================

WITH customer_frequency AS (

    SELECT
        customer_id,

        COUNT(DISTINCT invoice_no)
            AS frequency

    FROM lesson32_transactions

    GROUP BY customer_id
)

SELECT
    ROUND(
        AVG(frequency),
        2
    ) AS average_frequency

FROM customer_frequency;


-- =====================================================
-- SECTION 19: AVERAGE FREQUENCY
-- ALL CUSTOMERS
-- =====================================================

WITH customer_frequency AS (

    SELECT
        c.customer_id,

        COUNT(DISTINCT t.invoice_no)
            AS frequency

    FROM lesson32_customers AS c

    LEFT JOIN lesson32_transactions AS t
        ON c.customer_id = t.customer_id

    GROUP BY c.customer_id
)

SELECT
    ROUND(
        AVG(frequency),
        2
    ) AS average_frequency_all_customers

FROM customer_frequency;


-- =====================================================
-- SECTION 20: REPEAT CUSTOMER RATE
-- =====================================================

WITH customer_frequency AS (

    SELECT
        customer_id,

        COUNT(DISTINCT invoice_no)
            AS frequency

    FROM lesson32_transactions

    GROUP BY customer_id
)

SELECT
    COUNT(*) AS purchasing_customers,

    COUNT(*) FILTER (
        WHERE frequency >= 2
    ) AS repeat_customers,

    COUNT(*) FILTER (
        WHERE frequency = 1
    ) AS one_time_customers,

    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE frequency >= 2
        )
        /
        NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_pct

FROM customer_frequency;


-- =====================================================
-- SECTION 21: FREQUENCY DISTRIBUTION
-- =====================================================

WITH customer_frequency AS (

    SELECT
        c.customer_id,

        COUNT(DISTINCT t.invoice_no)
            AS frequency

    FROM lesson32_customers AS c

    LEFT JOIN lesson32_transactions AS t
        ON c.customer_id = t.customer_id

    GROUP BY c.customer_id
)

SELECT
    frequency,

    COUNT(*) AS customer_count

FROM customer_frequency

GROUP BY frequency

ORDER BY frequency;


-- =====================================================
-- SECTION 22: FREQUENCY BY LOYALTY TIER
-- =====================================================

WITH customer_frequency AS (

    SELECT
        c.customer_id,
        c.loyalty_tier,

        COUNT(DISTINCT t.invoice_no)
            AS frequency

    FROM lesson32_customers AS c

    LEFT JOIN lesson32_transactions AS t
        ON c.customer_id = t.customer_id

    GROUP BY
        c.customer_id,
        c.loyalty_tier
)

SELECT
    loyalty_tier,

    COUNT(*) AS customer_count,

    ROUND(
        AVG(frequency),
        2
    ) AS average_frequency,

    SUM(frequency)
        AS total_invoices

FROM customer_frequency

GROUP BY loyalty_tier

ORDER BY
    average_frequency DESC;


-- =====================================================
-- SECTION 23: TOTAL VS RECENT FREQUENCY
-- =====================================================

SELECT
    c.customer_id,
    c.customer_name,

    COUNT(DISTINCT t.invoice_no)
        AS total_frequency,

    COUNT(DISTINCT t.invoice_no)
        FILTER (
            WHERE t.invoice_date::DATE
                  >= DATE '2026-08-16' - 7
        ) AS recent_frequency

FROM lesson32_customers AS c

LEFT JOIN lesson32_transactions AS t
    ON c.customer_id = t.customer_id

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY
    total_frequency DESC,
    c.customer_id;


-- =====================================================
-- SECTION 24: CREATE INVOICE-LEVEL CTE
-- =====================================================

WITH invoice_summary AS (

    SELECT
        customer_id,
        invoice_no,

        MIN(invoice_date)
            AS invoice_date,

        ROUND(
            SUM(quantity * unit_price),
            2
        ) AS invoice_value

    FROM lesson32_transactions

    GROUP BY
        customer_id,
        invoice_no
)

SELECT *
FROM invoice_summary

ORDER BY
    customer_id,
    invoice_no;


-- =====================================================
-- SECTION 25: FREQUENCY FROM INVOICE GRAIN
-- =====================================================

WITH invoice_summary AS (

    SELECT
        customer_id,
        invoice_no

    FROM lesson32_transactions

    GROUP BY
        customer_id,
        invoice_no
)

SELECT
    customer_id,

    COUNT(*)
        AS frequency

FROM invoice_summary

GROUP BY customer_id

ORDER BY
    frequency DESC,
    customer_id;


-- =====================================================
-- SECTION 26: VALIDATE TWO FREQUENCY METHODS
-- =====================================================

WITH direct_frequency AS (

    SELECT
        customer_id,

        COUNT(DISTINCT invoice_no)
            AS frequency

    FROM lesson32_transactions

    GROUP BY customer_id
),

invoice_summary AS (

    SELECT
        customer_id,
        invoice_no

    FROM lesson32_transactions

    GROUP BY
        customer_id,
        invoice_no
),

invoice_frequency AS (

    SELECT
        customer_id,

        COUNT(*)
            AS frequency

    FROM invoice_summary

    GROUP BY customer_id
)

SELECT
    d.customer_id,

    d.frequency
        AS direct_frequency,

    i.frequency
        AS invoice_level_frequency,

    CASE
        WHEN d.frequency = i.frequency
            THEN 'Match'
        ELSE 'Check'
    END AS validation_status

FROM direct_frequency AS d

INNER JOIN invoice_frequency AS i
    ON d.customer_id = i.customer_id

ORDER BY d.customer_id;


-- =====================================================
-- SECTION 27: FREQUENCY RECONCILIATION
-- =====================================================

WITH customer_frequency AS (

    SELECT
        customer_id,

        COUNT(DISTINCT invoice_no)
            AS frequency

    FROM lesson32_transactions

    GROUP BY customer_id
)

SELECT
    SUM(frequency)
        AS sum_customer_frequency,

    (
        SELECT
            COUNT(DISTINCT invoice_no)
        FROM lesson32_transactions
    ) AS overall_invoice_count

FROM customer_frequency;


-- =====================================================
-- SECTION 28: RECENCY + FREQUENCY
-- =====================================================

SELECT
    customer_id,

    MAX(invoice_date)::DATE
        AS last_purchase_date,

    DATE '2026-08-16'
    -
    MAX(invoice_date)::DATE
        AS recency,

    COUNT(DISTINCT invoice_no)
        AS frequency

FROM lesson32_transactions

GROUP BY customer_id

ORDER BY
    recency,
    frequency DESC;


-- =====================================================
-- SECTION 29: RAW RFM MEASURES
-- =====================================================

SELECT
    customer_id,

    DATE '2026-08-16'
    -
    MAX(invoice_date)::DATE
        AS recency,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS monetary

FROM lesson32_transactions

GROUP BY customer_id

ORDER BY
    recency,
    frequency DESC;


-- =====================================================
-- SECTION 30: ALL-CUSTOMER RFM PREPARATION
-- =====================================================

WITH customer_rfm AS (

    SELECT
        customer_id,

        MAX(invoice_date)::DATE
            AS last_purchase_date,

        COUNT(DISTINCT invoice_no)
            AS frequency,

        ROUND(
            SUM(quantity * unit_price),
            2
        ) AS monetary

    FROM lesson32_transactions

    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.customer_name,
    c.home_country,
    c.loyalty_tier,

    r.last_purchase_date,

    CASE
        WHEN r.last_purchase_date IS NULL
            THEN NULL

        ELSE
            DATE '2026-08-16'
            -
            r.last_purchase_date
    END AS recency,

    COALESCE(
        r.frequency,
        0
    ) AS frequency,

    COALESCE(
        r.monetary,
        0
    ) AS monetary,

    CASE
        WHEN r.customer_id IS NULL
            THEN 'No Purchase History'

        WHEN r.frequency = 1
            THEN 'One-Time Customer'

        WHEN r.frequency = 2
            THEN 'Repeat Customer'

        ELSE 'High Frequency Customer'
    END AS frequency_status

FROM lesson32_customers AS c

LEFT JOIN customer_rfm AS r
    ON c.customer_id = r.customer_id

ORDER BY
    frequency DESC,
    monetary DESC;


-- =====================================================
-- SECTION 31: LESSON COMPLETION
-- =====================================================

SELECT
    'Lesson 32 completed successfully'
        AS lesson_status;