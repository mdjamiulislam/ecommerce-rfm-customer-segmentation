-- =====================================================
-- Lesson: 39
-- Topic: Validate Complete RFM Model and Data Quality
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

DROP TABLE IF EXISTS lesson39_customers;

CREATE TEMP TABLE lesson39_customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(50),
    home_country VARCHAR(100)
);

INSERT INTO lesson39_customers (
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

DROP TABLE IF EXISTS lesson39_raw_transactions;

CREATE TEMP TABLE lesson39_raw_transactions (
    sale_id INTEGER PRIMARY KEY,
    invoice_no VARCHAR(20),
    customer_id VARCHAR(20),
    product_name VARCHAR(100),
    quantity INTEGER,
    unit_price NUMERIC(12, 2),
    invoice_date TIMESTAMP
);

INSERT INTO lesson39_raw_transactions (
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

    (22, 'CINV021', '1001', 'Returned Item',
     -1, 50.00, '2026-08-15 10:00:00'),

    (23, 'INV022', NULL, 'Guest Purchase',
     1, 75.00, '2026-08-15 11:00:00'),

    (24, 'INV023', '1002', 'Zero Quantity Test',
     0, 100.00, '2026-08-15 12:00:00'),

    (25, 'INV024', '1003', 'Zero Price Test',
     1, 0.00, '2026-08-15 13:00:00');


-- =====================================================
-- SECTION 4: RAW DATA AUDIT
-- =====================================================

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_id,

    COUNT(*) FILTER (
        WHERE invoice_no LIKE 'C%'
    ) AS cancellation_rows,

    COUNT(*) FILTER (
        WHERE quantity <= 0
    ) AS invalid_quantity_rows,

    COUNT(*) FILTER (
        WHERE unit_price <= 0
    ) AS invalid_price_rows

FROM lesson39_raw_transactions;


-- =====================================================
-- SECTION 5: UNIQUE REJECTED ROWS
-- =====================================================

SELECT
    COUNT(*) AS rejected_rows

FROM lesson39_raw_transactions

WHERE customer_id IS NULL
   OR invoice_no IS NULL
   OR invoice_date IS NULL
   OR invoice_no LIKE 'C%'
   OR quantity <= 0
   OR unit_price <= 0;


-- =====================================================
-- SECTION 6: CREATE CLEAN TRANSACTION TABLE
-- =====================================================

DROP TABLE IF EXISTS lesson39_clean_transactions;

CREATE TEMP TABLE lesson39_clean_transactions AS

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

FROM lesson39_raw_transactions

WHERE customer_id IS NOT NULL
  AND invoice_no IS NOT NULL
  AND invoice_date IS NOT NULL
  AND invoice_no NOT LIKE 'C%'
  AND quantity > 0
  AND unit_price > 0;


-- =====================================================
-- SECTION 7: CLEAN DATA VALIDATION
-- =====================================================

SELECT
    COUNT(*) AS clean_rows,

    COUNT(DISTINCT invoice_no)
        AS clean_invoices,

    COUNT(DISTINCT customer_id)
        AS purchasing_customers,

    ROUND(
        SUM(line_revenue),
        2
    ) AS clean_revenue

FROM lesson39_clean_transactions;


-- =====================================================
-- SECTION 8: CHECK INVALID ROWS REMAINING
-- =====================================================

SELECT *
FROM lesson39_clean_transactions

WHERE customer_id IS NULL
   OR invoice_no IS NULL
   OR invoice_date IS NULL
   OR invoice_no LIKE 'C%'
   OR quantity <= 0
   OR unit_price <= 0;


-- =====================================================
-- SECTION 9: DUPLICATE SALE ID CHECK
-- =====================================================

SELECT
    sale_id,
    COUNT(*) AS row_count

FROM lesson39_clean_transactions

GROUP BY sale_id

HAVING COUNT(*) > 1;


-- =====================================================
-- SECTION 10: INVOICE CUSTOMER CONSISTENCY
-- =====================================================

SELECT
    invoice_no,

    COUNT(
        DISTINCT customer_id
    ) AS customer_count

FROM lesson39_clean_transactions

GROUP BY invoice_no

HAVING COUNT(
           DISTINCT customer_id
       ) <> 1;


-- =====================================================
-- SECTION 11: INVOICE DATE CONSISTENCY
-- =====================================================

SELECT
    invoice_no,

    COUNT(
        DISTINCT invoice_date
    ) AS date_count

FROM lesson39_clean_transactions

GROUP BY invoice_no

HAVING COUNT(
           DISTINCT invoice_date
       ) > 1;


-- =====================================================
-- SECTION 12: FUTURE DATE CHECK
-- =====================================================

SELECT *
FROM lesson39_clean_transactions

WHERE invoice_date::DATE
      > DATE '2026-08-16';


-- =====================================================
-- SECTION 13: CREATE INVOICE SUMMARY
-- =====================================================

DROP TABLE IF EXISTS lesson39_invoice_summary;

CREATE TEMP TABLE lesson39_invoice_summary AS

SELECT
    customer_id,
    invoice_no,

    MIN(invoice_date)
        AS invoice_date,

    ROUND(
        SUM(line_revenue),
        2
    ) AS invoice_value

FROM lesson39_clean_transactions

GROUP BY
    customer_id,
    invoice_no;


-- =====================================================
-- SECTION 14: INVOICE REVENUE RECONCILIATION
-- =====================================================

SELECT
    (
        SELECT
            ROUND(
                SUM(line_revenue),
                2
            )
        FROM lesson39_clean_transactions
    ) AS transaction_revenue,

    (
        SELECT
            ROUND(
                SUM(invoice_value),
                2
            )
        FROM lesson39_invoice_summary
    ) AS invoice_revenue;


-- =====================================================
-- SECTION 15: CREATE FINAL RFM MODEL
-- =====================================================

DROP TABLE IF EXISTS lesson39_final_rfm;

CREATE TEMP TABLE lesson39_final_rfm AS

WITH analysis_settings AS (

    SELECT
        DATE '2026-08-16'
            AS reference_date
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

    FROM lesson39_invoice_summary AS i

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

rfm_codes AS (

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
    *,

    CASE
        WHEN r_score >= 4
         AND f_score >= 4
         AND m_score >= 4
            THEN 'Champions'

        WHEN r_score >= 3
         AND f_score >= 4
            THEN 'Loyal Customers'

        WHEN r_score >= 4
         AND f_score BETWEEN 2 AND 3
            THEN 'Potential Loyalists'

        WHEN r_score = 5
         AND f_score = 1
            THEN 'New Customers'

        WHEN r_score = 4
         AND f_score = 1
            THEN 'Promising'

        WHEN r_score = 3
         AND f_score BETWEEN 2 AND 3
            THEN 'Need Attention'

        WHEN r_score <= 2
         AND f_score >= 3
            THEN 'At Risk'

        WHEN r_score <= 2
         AND f_score = 2
            THEN 'Hibernating'

        WHEN r_score <= 2
         AND f_score = 1
            THEN 'Lost Customers'

        ELSE 'Other'
    END AS customer_segment

FROM rfm_codes;


-- =====================================================
-- SECTION 16: CUSTOMER COUNT VALIDATION
-- =====================================================

SELECT
    COUNT(*) AS rfm_customers

FROM lesson39_final_rfm;


-- =====================================================
-- SECTION 17: NO-PURCHASE CUSTOMER CHECK
-- =====================================================

SELECT
    c.customer_id,
    c.customer_name

FROM lesson39_customers AS c

LEFT JOIN lesson39_final_rfm AS r
    ON c.customer_id = r.customer_id

WHERE r.customer_id IS NULL;


-- =====================================================
-- SECTION 18: DUPLICATE RFM CUSTOMER CHECK
-- =====================================================

SELECT
    customer_id,
    COUNT(*) AS rows_per_customer

FROM lesson39_final_rfm

GROUP BY customer_id

HAVING COUNT(*) > 1;


-- =====================================================
-- SECTION 19: RECENCY QA
-- =====================================================

SELECT *
FROM lesson39_final_rfm

WHERE recency IS NULL
   OR recency < 0;


-- =====================================================
-- SECTION 20: RECENCY CALCULATION CHECK
-- =====================================================

SELECT *
FROM lesson39_final_rfm

WHERE recency
      <>
      DATE '2026-08-16'
      -
      last_purchase_date;


-- =====================================================
-- SECTION 21: FREQUENCY QA
-- =====================================================

SELECT *
FROM lesson39_final_rfm

WHERE frequency IS NULL
   OR frequency <= 0;


-- =====================================================
-- SECTION 22: FREQUENCY RECONCILIATION
-- =====================================================

SELECT
    (
        SELECT
            SUM(frequency)
        FROM lesson39_final_rfm
    ) AS sum_customer_frequency,

    (
        SELECT
            COUNT(*)
        FROM lesson39_invoice_summary
    ) AS invoice_count;


-- =====================================================
-- SECTION 23: MONETARY QA
-- =====================================================

SELECT *
FROM lesson39_final_rfm

WHERE monetary IS NULL
   OR monetary <= 0;


-- =====================================================
-- SECTION 24: FULL REVENUE RECONCILIATION
-- =====================================================

SELECT
    (
        SELECT
            ROUND(
                SUM(line_revenue),
                2
            )
        FROM lesson39_clean_transactions
    ) AS clean_transaction_revenue,

    (
        SELECT
            ROUND(
                SUM(invoice_value),
                2
            )
        FROM lesson39_invoice_summary
    ) AS invoice_revenue,

    (
        SELECT
            ROUND(
                SUM(monetary),
                2
            )
        FROM lesson39_final_rfm
    ) AS rfm_monetary;


-- =====================================================
-- SECTION 25: RFM SCORE VALIDATION
-- =====================================================

SELECT *
FROM lesson39_final_rfm

WHERE r_score NOT BETWEEN 1 AND 5
   OR f_score NOT BETWEEN 1 AND 5
   OR m_score NOT BETWEEN 1 AND 5
   OR r_score IS NULL
   OR f_score IS NULL
   OR m_score IS NULL;


-- =====================================================
-- SECTION 26: RFM CODE VALIDATION
-- =====================================================

SELECT *
FROM lesson39_final_rfm

WHERE rfm_code !~ '^[1-5]{3}$'
   OR rfm_code IS NULL;


-- =====================================================
-- SECTION 27: TOTAL SCORE VALIDATION
-- =====================================================

SELECT *
FROM lesson39_final_rfm

WHERE total_rfm_score
      <>
      r_score
      + f_score
      + m_score

   OR total_rfm_score
      NOT BETWEEN 3 AND 15;


-- =====================================================
-- SECTION 28: SCORE DISTRIBUTIONS
-- =====================================================

SELECT
    r_score,
    COUNT(*) AS customers

FROM lesson39_final_rfm

GROUP BY r_score

ORDER BY r_score;


SELECT
    f_score,
    COUNT(*) AS customers

FROM lesson39_final_rfm

GROUP BY f_score

ORDER BY f_score;


SELECT
    m_score,
    COUNT(*) AS customers

FROM lesson39_final_rfm

GROUP BY m_score

ORDER BY m_score;


-- =====================================================
-- SECTION 29: FREQUENCY TIE WARNING
-- =====================================================

SELECT
    frequency,

    COUNT(*) AS customers,

    COUNT(
        DISTINCT f_score
    ) AS different_f_scores,

    MIN(f_score)
        AS minimum_f_score,

    MAX(f_score)
        AS maximum_f_score

FROM lesson39_final_rfm

GROUP BY frequency

HAVING COUNT(
           DISTINCT f_score
       ) > 1

ORDER BY frequency;


-- =====================================================
-- SECTION 30: SEGMENT VALIDATION
-- =====================================================

SELECT *
FROM lesson39_final_rfm

WHERE customer_segment = 'Other'
   OR customer_segment IS NULL;


-- =====================================================
-- SECTION 31: SEGMENT COUNTS
-- =====================================================

SELECT
    customer_segment,
    COUNT(*) AS customers

FROM lesson39_final_rfm

GROUP BY customer_segment

ORDER BY
    customers DESC,
    customer_segment;


-- =====================================================
-- SECTION 32: SEGMENT REVENUE RECONCILIATION
-- =====================================================

SELECT
    ROUND(
        SUM(segment_revenue),
        2
    ) AS total_segment_revenue

FROM (
    SELECT
        customer_segment,

        SUM(monetary)
            AS segment_revenue

    FROM lesson39_final_rfm

    GROUP BY customer_segment
) AS segment_summary;


-- =====================================================
-- SECTION 33: CUSTOMER MASTER RECONCILIATION
-- =====================================================

SELECT
    (
        SELECT COUNT(*)
        FROM lesson39_customers
    ) AS all_customers,

    (
        SELECT COUNT(*)
        FROM lesson39_final_rfm
    ) AS purchasing_customers,

    (
        SELECT COUNT(*)

        FROM lesson39_customers AS c

        LEFT JOIN lesson39_final_rfm AS r
            ON c.customer_id = r.customer_id

        WHERE r.customer_id IS NULL
    ) AS no_purchase_customers;


-- =====================================================
-- SECTION 34: ANOMALY SUMMARY
-- =====================================================

SELECT
    COUNT(*) FILTER (
        WHERE recency < 0
    ) AS negative_recency,

    COUNT(*) FILTER (
        WHERE frequency <= 0
    ) AS invalid_frequency,

    COUNT(*) FILTER (
        WHERE monetary <= 0
    ) AS invalid_monetary,

    COUNT(*) FILTER (
        WHERE r_score NOT BETWEEN 1 AND 5
    ) AS invalid_r_score,

    COUNT(*) FILTER (
        WHERE f_score NOT BETWEEN 1 AND 5
    ) AS invalid_f_score,

    COUNT(*) FILTER (
        WHERE m_score NOT BETWEEN 1 AND 5
    ) AS invalid_m_score,

    COUNT(*) FILTER (
        WHERE rfm_code !~ '^[1-5]{3}$'
    ) AS invalid_rfm_code,

    COUNT(*) FILTER (
        WHERE customer_segment = 'Other'
           OR customer_segment IS NULL
    ) AS unclassified_customers

FROM lesson39_final_rfm;


-- =====================================================
-- SECTION 35: OVERALL QA STATUS
-- =====================================================

WITH anomaly_summary AS (

    SELECT
        COUNT(*) FILTER (
            WHERE recency < 0
        )
        +
        COUNT(*) FILTER (
            WHERE frequency <= 0
        )
        +
        COUNT(*) FILTER (
            WHERE monetary <= 0
        )
        +
        COUNT(*) FILTER (
            WHERE r_score NOT BETWEEN 1 AND 5
        )
        +
        COUNT(*) FILTER (
            WHERE f_score NOT BETWEEN 1 AND 5
        )
        +
        COUNT(*) FILTER (
            WHERE m_score NOT BETWEEN 1 AND 5
        )
        +
        COUNT(*) FILTER (
            WHERE customer_segment = 'Other'
               OR customer_segment IS NULL
        ) AS total_anomalies

    FROM lesson39_final_rfm
)

SELECT
    total_anomalies,

    CASE
        WHEN total_anomalies = 0
            THEN 'PASS - RFM model passed core QA checks'

        ELSE
            'FAIL - Investigate RFM anomalies'
    END AS qa_status

FROM anomaly_summary;


-- =====================================================
-- SECTION 36: LESSON COMPLETION
-- =====================================================

SELECT
    'Lesson 39 completed successfully'
        AS lesson_status;