-- =====================================================
-- Lesson: 36
-- Topic: Complete RFM Values and Scores from Transactions
-- Database: ecommerce_rfm
-- Schema: public
-- Project: E-Commerce Customer Segmentation
-- Author: Md Jamiul Islam
-- =====================================================


-- =====================================================
-- SECTION 1: CONNECTION CHECK
-- =====================================================

SELECT
    current_database() AS database_name,
    current_schema() AS schema_name,
    current_user AS connected_user;


-- =====================================================
-- SECTION 2: CUSTOMER MASTER
-- =====================================================

DROP TABLE IF EXISTS lesson36_customers;

CREATE TEMP TABLE lesson36_customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(50),
    home_country VARCHAR(100)
);

INSERT INTO lesson36_customers (
    customer_id,
    customer_name,
    home_country
)
VALUES
    ('1001', 'Customer A', 'United Kingdom'),
    ('1002', 'Customer B', 'France'),
    ('1003', 'Customer C', 'Germany'),
    ('1004', 'Customer D', 'Spain'),
    ('1005', 'Customer E', 'Australia'),
    ('1006', 'Customer F', 'Ireland'),
    ('1007', 'Customer G', 'Netherlands'),
    ('1008', 'Customer H', 'Canada'),
    ('1009', 'Customer I', 'New Zealand'),
    ('1010', 'Customer J', 'Singapore'),
    ('1011', 'Customer K', 'United Kingdom');


-- =====================================================
-- SECTION 3: RAW TRANSACTION TABLE
-- =====================================================

DROP TABLE IF EXISTS lesson36_raw_transactions;

CREATE TEMP TABLE lesson36_raw_transactions (
    sale_id INTEGER PRIMARY KEY,
    invoice_no VARCHAR(20),
    customer_id VARCHAR(20),
    product_name VARCHAR(100),
    quantity INTEGER,
    unit_price NUMERIC(12, 2),
    invoice_date TIMESTAMP
);


-- =====================================================
-- SECTION 4: INSERT RAW TRANSACTIONS
-- =====================================================

INSERT INTO lesson36_raw_transactions (
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
     2, 30.00, '2026-08-01 09:00:00'),

    (2, 'INV001', '1001', 'Notebook Set',
     1, 40.00, '2026-08-01 09:00:00'),

    (3, 'INV002', '1001', 'Storage Box',
     2, 50.00, '2026-08-07 14:00:00'),

    (4, 'INV003', '1001', 'Premium Hamper',
     1, 100.00, '2026-08-14 16:00:00'),

    (5, 'INV004', '1002', 'Coffee Set',
     2, 60.00, '2026-08-03 10:00:00'),

    (6, 'INV005', '1002', 'Kitchen Set',
     3, 40.00, '2026-08-11 11:00:00'),

    (7, 'INV006', '1003', 'Wall Clock',
     1, 70.00, '2026-08-02 09:30:00'),

    (8, 'INV007', '1003', 'Tea Set',
     2, 35.00, '2026-08-05 13:00:00'),

    (9, 'INV008', '1003', 'Gift Set',
     1, 80.00, '2026-08-09 15:00:00'),

    (10, 'INV009', '1004', 'Gift Bag',
     3, 30.00, '2026-08-01 12:00:00'),

    (11, 'INV010', '1004', 'Travel Bag',
     2, 45.00, '2026-08-06 16:00:00'),

    (12, 'INV011', '1005', 'Photo Frame',
     1, 50.00, '2026-07-20 10:00:00'),

    (13, 'INV012', '1005', 'Home Decor Set',
     2, 25.00, '2026-07-25 14:00:00'),

    (14, 'INV013', '1005', 'Mug Set',
     3, 20.00, '2026-08-01 11:00:00'),

    (15, 'INV014', '1006', 'Office Set',
     1, 70.00, '2026-07-10 10:30:00'),

    (16, 'INV015', '1006', 'Desk Organiser',
     2, 35.00, '2026-07-27 15:30:00'),

    (17, 'INV016', '1007', 'Premium Tea Set',
     2, 60.00, '2026-07-17 11:00:00'),

    (18, 'INV017', '1008', 'Gift Box',
     1, 40.00, '2026-06-20 09:00:00'),

    (19, 'INV018', '1008', 'Accessory Set',
     3, 20.00, '2026-07-02 17:00:00'),

    (20, 'INV019', '1009', 'Storage Set',
     2, 40.00, '2026-06-17 12:00:00'),

    (21, 'INV020', '1010', 'Basic Gift Set',
     3, 20.00, '2026-05-18 13:00:00'),

    -- Invalid cancellation
    (22, 'CINV021', '1001', 'Returned Item',
     -1, 50.00, '2026-08-15 10:00:00'),

    -- Missing Customer ID
    (23, 'INV022', NULL, 'Guest Purchase',
     1, 75.00, '2026-08-15 11:00:00'),

    -- Zero quantity
    (24, 'INV023', '1002', 'Zero Quantity Test',
     0, 100.00, '2026-08-15 12:00:00'),

    -- Zero price
    (25, 'INV024', '1003', 'Zero Price Test',
     1, 0.00, '2026-08-15 13:00:00');


-- =====================================================
-- SECTION 5: RAW DATA AUDIT
-- =====================================================

SELECT
    COUNT(*) AS total_raw_rows,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_rows,

    COUNT(*) FILTER (
        WHERE invoice_no LIKE 'C%'
    ) AS cancellation_rows,

    COUNT(*) FILTER (
        WHERE quantity <= 0
    ) AS invalid_quantity_rows,

    COUNT(*) FILTER (
        WHERE unit_price <= 0
    ) AS invalid_price_rows

FROM lesson36_raw_transactions;


-- =====================================================
-- SECTION 6: COUNT UNIQUE EXCLUDED ROWS
-- =====================================================

SELECT
    COUNT(*) AS excluded_rows

FROM lesson36_raw_transactions

WHERE customer_id IS NULL
   OR invoice_no IS NULL
   OR invoice_date IS NULL
   OR invoice_no LIKE 'C%'
   OR quantity <= 0
   OR unit_price <= 0;


-- =====================================================
-- SECTION 7: CLEAN DATA SUMMARY
-- =====================================================

SELECT
    COUNT(*) AS transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS invoices,

    COUNT(DISTINCT customer_id)
        AS purchasing_customers,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS revenue

FROM lesson36_raw_transactions

WHERE customer_id IS NOT NULL
  AND invoice_no IS NOT NULL
  AND invoice_date IS NOT NULL
  AND invoice_no NOT LIKE 'C%'
  AND quantity > 0
  AND unit_price > 0;


-- =====================================================
-- SECTION 8: COMPLETE RFM PIPELINE
-- =====================================================

WITH analysis_settings AS (

    SELECT
        DATE '2026-08-16'
            AS reference_date
),

clean_transactions AS (

    SELECT
        sale_id,
        invoice_no,
        customer_id,
        product_name,
        quantity,
        unit_price,
        invoice_date,

        ROUND(
            quantity * unit_price,
            2
        ) AS line_revenue

    FROM lesson36_raw_transactions

    WHERE customer_id IS NOT NULL
      AND invoice_no IS NOT NULL
      AND invoice_date IS NOT NULL
      AND invoice_no NOT LIKE 'C%'
      AND quantity > 0
      AND unit_price > 0
),

invoice_summary AS (

    SELECT
        customer_id,
        invoice_no,

        MIN(invoice_date)
            AS invoice_date,

        ROUND(
            SUM(line_revenue),
            2
        ) AS invoice_value

    FROM clean_transactions

    GROUP BY
        customer_id,
        invoice_no
),

customer_rfm AS (

    SELECT
        i.customer_id,

        MAX(i.invoice_date)::DATE
            AS last_purchase_date,

        s.reference_date
        -
        MAX(i.invoice_date)::DATE
            AS recency,

        COUNT(*)
            AS frequency,

        ROUND(
            SUM(i.invoice_value),
            2
        ) AS monetary

    FROM invoice_summary AS i

    CROSS JOIN analysis_settings AS s

    GROUP BY
        i.customer_id,
        s.reference_date
),

rfm_scored AS (

    SELECT
        customer_id,
        last_purchase_date,
        recency,
        frequency,
        monetary,

        NTILE(5)
        OVER (
            ORDER BY
                recency DESC,
                customer_id
        ) AS r_score,

        NTILE(5)
        OVER (
            ORDER BY
                frequency ASC,
                customer_id
        ) AS f_score,

        NTILE(5)
        OVER (
            ORDER BY
                monetary ASC,
                customer_id
        ) AS m_score

    FROM customer_rfm
),

final_rfm AS (

    SELECT
        *,

        r_score::TEXT
        || f_score::TEXT
        || m_score::TEXT
            AS rfm_code,

        r_score
        + f_score
        + m_score
            AS total_rfm_score

    FROM rfm_scored
)

SELECT
    c.customer_id,
    c.customer_name,
    c.home_country,

    r.last_purchase_date,
    r.recency,
    r.frequency,
    r.monetary,

    r.r_score,
    r.f_score,
    r.m_score,

    r.rfm_code,
    r.total_rfm_score

FROM final_rfm AS r

INNER JOIN lesson36_customers AS c
    ON r.customer_id = c.customer_id

ORDER BY
    r.total_rfm_score DESC,
    r.monetary DESC;


-- =====================================================
-- SECTION 9: ALL-CUSTOMER RFM REPORT
-- INCLUDING NO-PURCHASE CUSTOMERS
-- =====================================================

WITH analysis_settings AS (

    SELECT
        DATE '2026-08-16'
            AS reference_date
),

clean_transactions AS (

    SELECT
        invoice_no,
        customer_id,
        invoice_date,

        ROUND(
            quantity * unit_price,
            2
        ) AS line_revenue

    FROM lesson36_raw_transactions

    WHERE customer_id IS NOT NULL
      AND invoice_no IS NOT NULL
      AND invoice_date IS NOT NULL
      AND invoice_no NOT LIKE 'C%'
      AND quantity > 0
      AND unit_price > 0
),

invoice_summary AS (

    SELECT
        customer_id,
        invoice_no,

        MIN(invoice_date)
            AS invoice_date,

        ROUND(
            SUM(line_revenue),
            2
        ) AS invoice_value

    FROM clean_transactions

    GROUP BY
        customer_id,
        invoice_no
),

customer_rfm AS (

    SELECT
        i.customer_id,

        MAX(i.invoice_date)::DATE
            AS last_purchase_date,

        s.reference_date
        -
        MAX(i.invoice_date)::DATE
            AS recency,

        COUNT(*)
            AS frequency,

        ROUND(
            SUM(i.invoice_value),
            2
        ) AS monetary

    FROM invoice_summary AS i

    CROSS JOIN analysis_settings AS s

    GROUP BY
        i.customer_id,
        s.reference_date
),

rfm_scored AS (

    SELECT
        *,

        NTILE(5)
        OVER (
            ORDER BY
                recency DESC,
                customer_id
        ) AS r_score,

        NTILE(5)
        OVER (
            ORDER BY
                frequency ASC,
                customer_id
        ) AS f_score,

        NTILE(5)
        OVER (
            ORDER BY
                monetary ASC,
                customer_id
        ) AS m_score

    FROM customer_rfm
),

final_rfm AS (

    SELECT
        *,

        r_score::TEXT
        || f_score::TEXT
        || m_score::TEXT
            AS rfm_code,

        r_score
        + f_score
        + m_score
            AS total_rfm_score

    FROM rfm_scored
)

SELECT
    c.customer_id,
    c.customer_name,
    c.home_country,

    r.last_purchase_date,
    r.recency,

    COALESCE(
        r.frequency,
        0
    ) AS frequency,

    COALESCE(
        r.monetary,
        0
    ) AS monetary,

    r.r_score,
    r.f_score,
    r.m_score,

    r.rfm_code,
    r.total_rfm_score,

    CASE
        WHEN r.customer_id IS NULL
            THEN 'No Purchase History'
        ELSE 'RFM Eligible'
    END AS rfm_status

FROM lesson36_customers AS c

LEFT JOIN final_rfm AS r
    ON c.customer_id = r.customer_id

ORDER BY
    r.total_rfm_score DESC NULLS LAST,
    c.customer_id;


-- =====================================================
-- SECTION 10: FINAL VALIDATION
-- =====================================================

SELECT
    COUNT(*) AS clean_transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS clean_invoices,

    COUNT(DISTINCT customer_id)
        AS rfm_customers,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS clean_revenue

FROM lesson36_raw_transactions

WHERE customer_id IS NOT NULL
  AND invoice_no IS NOT NULL
  AND invoice_date IS NOT NULL
  AND invoice_no NOT LIKE 'C%'
  AND quantity > 0
  AND unit_price > 0;


-- =====================================================
-- SECTION 11: LESSON COMPLETION
-- =====================================================

SELECT
    'Lesson 36 completed successfully'
        AS lesson_status;