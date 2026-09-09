SELECT
    current_database() AS database_name,
    current_schema() AS schema_name,
    current_user AS connected_user;

DROP TABLE IF EXISTS lesson25_raw_online_retail;

CREATE TEMP TABLE lesson25_raw_online_retail (
    sale_id INTEGER,
    invoice_no VARCHAR(20),
    description TEXT,
    category VARCHAR(50),
    quantity INTEGER,
    unit_price NUMERIC(12, 2),
    discount_pct NUMERIC(5, 2),
    invoice_date TIMESTAMP,
    customer_id VARCHAR(20),
    country VARCHAR(100),
    sales_channel VARCHAR(30),
    is_cancelled BOOLEAN
);

INSERT INTO lesson25_raw_online_retail (
    sale_id,
    invoice_no,
    description,
    category,
    quantity,
    unit_price,
    discount_pct,
    invoice_date,
    customer_id,
    country,
    sales_channel,
    is_cancelled
)
VALUES
    (
        1, '536365', 'White Hanging Heart',
        'Home Decor', 6, 2.55, 0,
        '2010-12-01 08:26:00',
        '17850', 'United Kingdom',
        'Online', FALSE
    ),
    (
        2, '536365', 'White Metal Lantern',
        'Home Decor', 6, 3.39, 5,
        '2010-12-01 08:26:00',
        '17850', 'United Kingdom',
        'Online', FALSE
    ),
    (
        3, '536366', 'Hand Warmer',
        'Accessories', 6, 1.85, 0,
        '2010-12-01 08:28:00',
        '17850', 'United Kingdom',
        'Online', FALSE
    ),
    (
        4, '536367', 'Bird Ornament',
        'Home Decor', 12, 1.69, 10,
        '2010-12-01 08:34:00',
        '13047', 'United Kingdom',
        'Wholesale', FALSE
    ),
    (
        5, '536368', 'Ceramic Mug',
        'Kitchen', 4, 3.75, 0,
        '2010-12-01 08:36:00',
        '12583', 'France',
        'Online', FALSE
    ),
    (
        6, 'C536369', 'Glass Star Decoration',
        'Home Decor', -10, 4.25, 0,
        '2010-12-01 08:40:00',
        '12583', 'France',
        'Wholesale', TRUE
    ),
    (
        7, '536370', 'Notebook Set',
        'Stationery', 8, 5.50, 15,
        '2010-12-01 08:45:00',
        NULL, 'Germany',
        'Online', FALSE
    ),
    (
        8, '536371', 'Red Woolly Hottie',
        'Accessories', 5, 4.25, 5,
        '2010-12-01 09:00:00',
        '13748', 'United Kingdom',
        'Online', FALSE
    ),
    (
        9, '536372', 'Wooden Picture Frame',
        'Home Decor', 3, 7.95, 0,
        '2010-12-01 09:01:00',
        '17850', 'United Kingdom',
        'Online', FALSE
    ),
    (
        10, '536373', 'Retro Coffee Mug',
        'Kitchen', 12, 2.95, 10,
        '2010-12-01 09:02:00',
        '17850', 'United Kingdom',
        'Online', FALSE
    ),
    (
        11, '536374', 'Paper Chain Kit',
        'Stationery', 5, 4.95, 0,
        '2010-12-01 09:09:00',
        '15100', 'Spain',
        'Wholesale', FALSE
    ),
    (
        12, '536375', 'Lunch Bag',
        'Kitchen', 10, 1.65, 0,
        '2010-12-02 10:15:00',
        '17850', 'United Kingdom',
        'Online', FALSE
    ),
    (
        13, '536376', 'Alarm Clock',
        'Home Decor', 4, 3.75, 5,
        '2010-12-02 14:30:00',
        '15291', 'Netherlands',
        'Online', FALSE
    ),
    (
        14, '536377', 'Christmas Garland',
        'Seasonal', 8, 6.25, 20,
        '2010-12-03 11:45:00',
        '17850', 'United Kingdom',
        'Wholesale', FALSE
    ),
    (
        15, '536378', 'Travel Sewing Kit',
        'Accessories', 7, 2.10, 0,
        '2010-12-03 16:20:00',
        '14688', 'France',
        'Online', FALSE
    ),
    (
        16, '536379', 'Storage Basket',
        'Home Decor', 5, 8.50, 10,
        '2010-12-04 09:05:00',
        '16029', 'Germany',
        'Online', FALSE
    ),
    (
        17, '536380', 'Promotional Sample',
        'Miscellaneous', 0, 0.00, 0,
        '2010-12-04 13:15:00',
        '17200', NULL,
        'Unknown', FALSE
    ),
    (
        18, '536381', 'Premium Gift Hamper',
        'Gift Sets', 20, 12.50, 25,
        '2010-12-05 18:30:00',
        '18000', 'Australia',
        'Wholesale', FALSE
    ),
    (
        19, '536382', 'Tea Cup Set',
        'Kitchen', 6, 3.20, NULL,
        '2010-12-05 19:00:00',
        '18100', 'Germany',
        'Online', FALSE
    ),
    (
        20, '536383', 'O''Brien Gift Card',
        'Gift Cards', 2, 10.00, 0,
        '2010-12-06 10:00:00',
        '18200', 'Ireland',
        'Online', FALSE
    );

SELECT *
FROM lesson25_raw_online_retail
ORDER BY sale_id;

SELECT
	COUNT(*) AS raw_row_count
FROM lesson25_raw_online_retail;

SELECT
	sale_id,
	invoice_no,
	description,
	customer_id
FROM lesson25_raw_online_retail
WHERE customer_id IS NULL;

SELECT
	COUNT(*) AS raw_row_count
FROM lesson25_raw_online_retail
WHERE customer_id IS NULL;

SELECT
    COUNT(*) AS missing_invoice_rows
FROM lesson25_raw_online_retail
WHERE invoice_no IS NULL;

SELECT
    COUNT(*) AS missing_invoice_dates
FROM lesson25_raw_online_retail
WHERE invoice_date IS NULL;

SELECT
    sale_id,
    invoice_no,
    description,
    quantity,
    unit_price
FROM lesson25_raw_online_retail
WHERE invoice_no LIKE 'C%';

SELECT
    sale_id,
    invoice_no,
    description,
    quantity
FROM lesson25_raw_online_retail
WHERE quantity <= 0
ORDER BY sale_id;

SELECT
    sale_id,
    invoice_no,
    description,
    unit_price
FROM lesson25_raw_online_retail
WHERE unit_price <= 0
ORDER BY sale_id;

SELECT
	COUNT(*) AS total_rows,
	COUNT(*) FILTER(WHERE customer_id IS NULL) AS missing_customer_rows,
	COUNT(*) FILTER(WHERE invoice_no IS NULL) AS missing_invoice_rows,
	COUNT(*) FILTER(WHERE invoice_date IS NULL) AS missing_date_rows,
	COUNT(*) FILTER(WHERE invoice_no LIKE 'C%') AS cancelled_rows,
	COUNT(*) FILTER(WHERE quantity <= 0) AS non_positive_quantity_rows,
	COUNT(*) FILTER(WHERE unit_price <= 0) AS non_positive_price_rows
FROM lesson25_raw_online_retail;

SELECT
	COUNT(*) AS rows_to_exclude
FROM lesson25_raw_online_retail
WHERE customer_id IS NULL
	OR invoice_no IS NULL
	OR invoice_date IS NULL
	OR invoice_no LIKE 'C%'
	OR quantity <= 0
	OR unit_price <= 0;

SELECT
    sale_id,
    invoice_no,
    description,
    quantity,
    unit_price,
    invoice_date,
    customer_id,
    country
FROM lesson25_raw_online_retail
WHERE customer_id IS NULL
   OR invoice_no IS NULL
   OR invoice_date IS NULL
   OR invoice_no LIKE 'C%'
   OR quantity <= 0
   OR unit_price <= 0
ORDER BY sale_id;

SELECT
    sale_id,
    invoice_no,
    description,
    quantity,
    unit_price,
    customer_id,

    CASE
        WHEN customer_id IS NULL
            THEN 'Exclude - Missing Customer'

        WHEN invoice_no IS NULL
            THEN 'Exclude - Missing Invoice'

        WHEN invoice_date IS NULL
            THEN 'Exclude - Missing Date'

        WHEN invoice_no LIKE 'C%'
            THEN 'Exclude - Cancellation'

        WHEN quantity <= 0
            THEN 'Exclude - Quantity'

        WHEN unit_price <= 0
            THEN 'Exclude - Price'

        ELSE 'Include in RFM'
    END AS rfm_status

FROM lesson25_raw_online_retail

ORDER BY sale_id;

SELECT
    rfm_status,
    COUNT(*) AS row_count
FROM (
    SELECT
        CASE
            WHEN customer_id IS NULL
                THEN 'Exclude - Missing Customer'

            WHEN invoice_no IS NULL
                THEN 'Exclude - Missing Invoice'

            WHEN invoice_date IS NULL
                THEN 'Exclude - Missing Date'

            WHEN invoice_no LIKE 'C%'
                THEN 'Exclude - Cancellation'

            WHEN quantity <= 0
                THEN 'Exclude - Quantity'

            WHEN unit_price <= 0
                THEN 'Exclude - Price'

            ELSE 'Include in RFM'
        END AS rfm_status

    FROM lesson25_raw_online_retail
) AS quality_check

GROUP BY rfm_status

ORDER BY
    row_count DESC,
    rfm_status;

SELECT
    sale_id,
    invoice_no,
    description,
    quantity,
    unit_price,
    invoice_date,
    customer_id,
    country
FROM lesson25_raw_online_retail
WHERE customer_id IS NOT NULL
  AND invoice_no IS NOT NULL
  AND invoice_date IS NOT NULL
  AND invoice_no NOT LIKE 'C%'
  AND quantity > 0
  AND unit_price > 0
ORDER BY sale_id;

DROP TABLE IF EXISTS lesson25_cleaned_transactions;

CREATE TEMP TABLE lesson25_cleaned_transactions AS

SELECT
	sale_id,
    invoice_no,
    description,
    category,
    quantity,
    unit_price,
    discount_pct,
    invoice_date,
	invoice_date::DATE AS transaction_date,
	customer_id,
	country,
	sales_channel,
	ROUND(quantity * unit_price, 2) AS line_revenue
FROM lesson25_raw_online_retail
WHERE customer_id IS NOT NULL
  AND invoice_no IS NOT NULL
  AND invoice_date IS NOT NULL
  AND invoice_no NOT LIKE 'C%'
  AND quantity > 0
  AND unit_price > 0;

 SELECT *
 FROM lesson25_cleaned_transactions
 ORDER BY sale_id;

 SELECT
    (
        SELECT COUNT(*)
        FROM lesson25_raw_online_retail
    ) AS raw_rows,

    (
        SELECT COUNT(*)
        FROM lesson25_cleaned_transactions
    ) AS cleaned_rows;

 SELECT
    (
        SELECT COUNT(*)
        FROM lesson25_raw_online_retail
    )
    -
    (
        SELECT COUNT(*)
        FROM lesson25_cleaned_transactions
    )
    AS excluded_rows;

SELECT
    (
        SELECT COUNT(*)
        FROM lesson25_raw_online_retail
    ) AS raw_rows,

    (
        SELECT COUNT(*)
        FROM lesson25_cleaned_transactions
    ) AS cleaned_rows,

    ROUND(
        100.0
        * (
            SELECT COUNT(*)
            FROM lesson25_cleaned_transactions
        )
        /
        NULLIF(
            (
                SELECT COUNT(*)
                FROM lesson25_raw_online_retail
            ),
            0
        ),
        2
    ) AS retained_pct;

SELECT
    COUNT(*) AS cleaned_rows,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_rows,

    COUNT(*) FILTER (
        WHERE invoice_no IS NULL
    ) AS missing_invoice_rows,

    COUNT(*) FILTER (
        WHERE invoice_date IS NULL
    ) AS missing_date_rows,

    COUNT(*) FILTER (
        WHERE invoice_no LIKE 'C%'
    ) AS cancellation_rows,

    COUNT(*) FILTER (
        WHERE quantity <= 0
    ) AS invalid_quantity_rows,

    COUNT(*) FILTER (
        WHERE unit_price <= 0
    ) AS invalid_price_rows

FROM lesson25_cleaned_transactions;

SELECT
    sale_id,
    invoice_no,
    description,
    quantity,
    unit_price,
    line_revenue
FROM lesson25_cleaned_transactions
ORDER BY sale_id;

SELECT
    sale_id,
    invoice_no,
    description,
    quantity,
    unit_price,
    line_revenue
FROM lesson25_cleaned_transactions
ORDER BY sale_id;

SELECT
    COUNT(*) AS incorrect_revenue_rows
FROM lesson25_cleaned_transactions
WHERE line_revenue
      <> ROUND(quantity * unit_price, 2);

SELECT
    COUNT(*) AS transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS invoice_count,

    COUNT(DISTINCT customer_id)
        AS customer_count,

    COUNT(DISTINCT country)
        AS country_count,

    SUM(quantity)
        AS total_units,

    ROUND(
        SUM(line_revenue),
        2
    ) AS gross_revenue,

    MIN(invoice_date)
        AS earliest_transaction,

    MAX(invoice_date)
        AS latest_transaction

FROM lesson25_cleaned_transactions;

SELECT
    ROUND(
        (
            SELECT SUM(quantity * unit_price)
            FROM lesson25_raw_online_retail
        ),
        2
    ) AS raw_revenue,

    ROUND(
        (
            SELECT SUM(line_revenue)
            FROM lesson25_cleaned_transactions
        ),
        2
    ) AS cleaned_revenue;

SELECT
    country,

    COUNT(*) AS transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS invoice_count,

    COUNT(DISTINCT customer_id)
        AS customer_count,

    SUM(quantity)
        AS total_units,

    ROUND(
        SUM(line_revenue),
        2
    ) AS gross_revenue

FROM lesson25_cleaned_transactions

GROUP BY country

ORDER BY gross_revenue DESC;

SELECT
    country,

    COUNT(*) AS transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS invoice_count,

    COUNT(DISTINCT customer_id)
        AS customer_count,

    SUM(quantity)
        AS total_units,

    ROUND(
        SUM(line_revenue),
        2
    ) AS gross_revenue

FROM lesson25_cleaned_transactions

GROUP BY country

ORDER BY gross_revenue DESC;

SELECT
    customer_id,

    MAX(invoice_date)
        AS last_purchase_date,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    ROUND(
        SUM(line_revenue),
        2
    ) AS monetary_value

FROM lesson25_cleaned_transactions

GROUP BY customer_id

ORDER BY monetary_value DESC;

SELECT
    invoice_no,
    description,
    quantity,
    unit_price,
    invoice_date,
    customer_id,
    country,

    COUNT(*) AS duplicate_count

FROM lesson25_cleaned_transactions

GROUP BY
    invoice_no,
    description,
    quantity,
    unit_price,
    invoice_date,
    customer_id,
    country

HAVING COUNT(*) > 1;

SELECT
    column_name,
    data_type,
    ordinal_position
FROM information_schema.columns
WHERE table_name = 'lesson25_cleaned_transactions'
ORDER BY ordinal_position;

-- =====================================================
-- Lesson: 25
-- Topic: Create a Cleaned Transaction Dataset for RFM
-- Database: ecommerce_rfm
-- Schema: public
-- Project: E-Commerce Customer Segmentation
-- Author: Md Jamiul Islam
-- Created: 2026-08-16
-- Purpose: Build and validate an RFM-ready transaction set
-- =====================================================


-- =====================================================
-- SECTION 1: CONNECTION CHECK
-- =====================================================

SELECT
    current_database() AS database_name,
    current_schema() AS schema_name,
    current_user AS connected_user;


-- =====================================================
-- SECTION 2: CREATE RAW PRACTICE TABLE
-- =====================================================

DROP TABLE IF EXISTS lesson25_raw_online_retail;

CREATE TEMP TABLE lesson25_raw_online_retail (
    sale_id INTEGER,
    invoice_no VARCHAR(20),
    description TEXT,
    category VARCHAR(50),
    quantity INTEGER,
    unit_price NUMERIC(12, 2),
    discount_pct NUMERIC(5, 2),
    invoice_date TIMESTAMP,
    customer_id VARCHAR(20),
    country VARCHAR(100),
    sales_channel VARCHAR(30),
    is_cancelled BOOLEAN
);


-- =====================================================
-- SECTION 3: INSERT RAW PRACTICE DATA
-- =====================================================

INSERT INTO lesson25_raw_online_retail (
    sale_id,
    invoice_no,
    description,
    category,
    quantity,
    unit_price,
    discount_pct,
    invoice_date,
    customer_id,
    country,
    sales_channel,
    is_cancelled
)
VALUES
    (1, '536365', 'White Hanging Heart',
     'Home Decor', 6, 2.55, 0,
     '2010-12-01 08:26:00',
     '17850', 'United Kingdom', 'Online', FALSE),

    (2, '536365', 'White Metal Lantern',
     'Home Decor', 6, 3.39, 5,
     '2010-12-01 08:26:00',
     '17850', 'United Kingdom', 'Online', FALSE),

    (3, '536366', 'Hand Warmer',
     'Accessories', 6, 1.85, 0,
     '2010-12-01 08:28:00',
     '17850', 'United Kingdom', 'Online', FALSE),

    (4, '536367', 'Bird Ornament',
     'Home Decor', 12, 1.69, 10,
     '2010-12-01 08:34:00',
     '13047', 'United Kingdom', 'Wholesale', FALSE),

    (5, '536368', 'Ceramic Mug',
     'Kitchen', 4, 3.75, 0,
     '2010-12-01 08:36:00',
     '12583', 'France', 'Online', FALSE),

    (6, 'C536369', 'Glass Star Decoration',
     'Home Decor', -10, 4.25, 0,
     '2010-12-01 08:40:00',
     '12583', 'France', 'Wholesale', TRUE),

    (7, '536370', 'Notebook Set',
     'Stationery', 8, 5.50, 15,
     '2010-12-01 08:45:00',
     NULL, 'Germany', 'Online', FALSE),

    (8, '536371', 'Red Woolly Hottie',
     'Accessories', 5, 4.25, 5,
     '2010-12-01 09:00:00',
     '13748', 'United Kingdom', 'Online', FALSE),

    (9, '536372', 'Wooden Picture Frame',
     'Home Decor', 3, 7.95, 0,
     '2010-12-01 09:01:00',
     '17850', 'United Kingdom', 'Online', FALSE),

    (10, '536373', 'Retro Coffee Mug',
     'Kitchen', 12, 2.95, 10,
     '2010-12-01 09:02:00',
     '17850', 'United Kingdom', 'Online', FALSE),

    (11, '536374', 'Paper Chain Kit',
     'Stationery', 5, 4.95, 0,
     '2010-12-01 09:09:00',
     '15100', 'Spain', 'Wholesale', FALSE),

    (12, '536375', 'Lunch Bag',
     'Kitchen', 10, 1.65, 0,
     '2010-12-02 10:15:00',
     '17850', 'United Kingdom', 'Online', FALSE),

    (13, '536376', 'Alarm Clock',
     'Home Decor', 4, 3.75, 5,
     '2010-12-02 14:30:00',
     '15291', 'Netherlands', 'Online', FALSE),

    (14, '536377', 'Christmas Garland',
     'Seasonal', 8, 6.25, 20,
     '2010-12-03 11:45:00',
     '17850', 'United Kingdom', 'Wholesale', FALSE),

    (15, '536378', 'Travel Sewing Kit',
     'Accessories', 7, 2.10, 0,
     '2010-12-03 16:20:00',
     '14688', 'France', 'Online', FALSE),

    (16, '536379', 'Storage Basket',
     'Home Decor', 5, 8.50, 10,
     '2010-12-04 09:05:00',
     '16029', 'Germany', 'Online', FALSE),

    (17, '536380', 'Promotional Sample',
     'Miscellaneous', 0, 0.00, 0,
     '2010-12-04 13:15:00',
     '17200', NULL, 'Unknown', FALSE),

    (18, '536381', 'Premium Gift Hamper',
     'Gift Sets', 20, 12.50, 25,
     '2010-12-05 18:30:00',
     '18000', 'Australia', 'Wholesale', FALSE),

    (19, '536382', 'Tea Cup Set',
     'Kitchen', 6, 3.20, NULL,
     '2010-12-05 19:00:00',
     '18100', 'Germany', 'Online', FALSE),

    (20, '536383', 'O''Brien Gift Card',
     'Gift Cards', 2, 10.00, 0,
     '2010-12-06 10:00:00',
     '18200', 'Ireland', 'Online', FALSE);


-- =====================================================
-- SECTION 4: PREVIEW RAW DATA
-- =====================================================

SELECT *
FROM lesson25_raw_online_retail
ORDER BY sale_id;


-- =====================================================
-- SECTION 5: RAW DATA QUALITY AUDIT
-- =====================================================

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_rows,

    COUNT(*) FILTER (
        WHERE invoice_no IS NULL
    ) AS missing_invoice_rows,

    COUNT(*) FILTER (
        WHERE invoice_date IS NULL
    ) AS missing_date_rows,

    COUNT(*) FILTER (
        WHERE invoice_no LIKE 'C%'
    ) AS cancelled_rows,

    COUNT(*) FILTER (
        WHERE quantity <= 0
    ) AS non_positive_quantity_rows,

    COUNT(*) FILTER (
        WHERE unit_price <= 0
    ) AS non_positive_price_rows

FROM lesson25_raw_online_retail;


-- =====================================================
-- SECTION 6: ROWS FAILING ANY CLEANING RULE
-- =====================================================

SELECT
    sale_id,
    invoice_no,
    description,
    quantity,
    unit_price,
    invoice_date,
    customer_id,
    country

FROM lesson25_raw_online_retail

WHERE customer_id IS NULL
   OR invoice_no IS NULL
   OR invoice_date IS NULL
   OR invoice_no LIKE 'C%'
   OR quantity <= 0
   OR unit_price <= 0

ORDER BY sale_id;


-- =====================================================
-- SECTION 7: COUNT UNIQUE EXCLUDED ROWS
-- =====================================================

SELECT
    COUNT(*) AS rows_to_exclude

FROM lesson25_raw_online_retail

WHERE customer_id IS NULL
   OR invoice_no IS NULL
   OR invoice_date IS NULL
   OR invoice_no LIKE 'C%'
   OR quantity <= 0
   OR unit_price <= 0;


-- =====================================================
-- SECTION 8: RFM ELIGIBILITY STATUS
-- =====================================================

SELECT
    sale_id,
    invoice_no,
    description,
    quantity,
    unit_price,
    customer_id,

    CASE
        WHEN customer_id IS NULL
            THEN 'Exclude - Missing Customer'

        WHEN invoice_no IS NULL
            THEN 'Exclude - Missing Invoice'

        WHEN invoice_date IS NULL
            THEN 'Exclude - Missing Date'

        WHEN invoice_no LIKE 'C%'
            THEN 'Exclude - Cancellation'

        WHEN quantity <= 0
            THEN 'Exclude - Quantity'

        WHEN unit_price <= 0
            THEN 'Exclude - Price'

        ELSE 'Include in RFM'
    END AS rfm_status

FROM lesson25_raw_online_retail

ORDER BY sale_id;


-- =====================================================
-- SECTION 9: PREVIEW ROWS TO RETAIN
-- =====================================================

SELECT
    sale_id,
    invoice_no,
    description,
    quantity,
    unit_price,
    invoice_date,
    customer_id,
    country

FROM lesson25_raw_online_retail

WHERE customer_id IS NOT NULL
  AND invoice_no IS NOT NULL
  AND invoice_date IS NOT NULL
  AND invoice_no NOT LIKE 'C%'
  AND quantity > 0
  AND unit_price > 0

ORDER BY sale_id;


-- =====================================================
-- SECTION 10: CREATE CLEANED TRANSACTION TABLE
-- =====================================================

DROP TABLE IF EXISTS lesson25_cleaned_transactions;

CREATE TEMP TABLE lesson25_cleaned_transactions AS

SELECT
    sale_id,
    invoice_no,
    description,
    category,
    quantity,
    unit_price,
    discount_pct,
    invoice_date,

    invoice_date::DATE
        AS transaction_date,

    customer_id,
    country,
    sales_channel,

    ROUND(
        quantity * unit_price,
        2
    ) AS line_revenue

FROM lesson25_raw_online_retail

WHERE customer_id IS NOT NULL
  AND invoice_no IS NOT NULL
  AND invoice_date IS NOT NULL
  AND invoice_no NOT LIKE 'C%'
  AND quantity > 0
  AND unit_price > 0;


-- =====================================================
-- SECTION 11: PREVIEW CLEANED DATA
-- =====================================================

SELECT *
FROM lesson25_cleaned_transactions
ORDER BY sale_id;


-- =====================================================
-- SECTION 12: RAW VS CLEAN ROW COUNTS
-- =====================================================

SELECT
    raw_rows,
    cleaned_rows,

    raw_rows - cleaned_rows
        AS excluded_rows,

    ROUND(
        100.0 * cleaned_rows
        / NULLIF(raw_rows, 0),
        2
    ) AS retained_pct,

    ROUND(
        100.0 * (raw_rows - cleaned_rows)
        / NULLIF(raw_rows, 0),
        2
    ) AS excluded_pct

FROM (
    SELECT
        (
            SELECT COUNT(*)
            FROM lesson25_raw_online_retail
        ) AS raw_rows,

        (
            SELECT COUNT(*)
            FROM lesson25_cleaned_transactions
        ) AS cleaned_rows

) AS row_counts;


-- =====================================================
-- SECTION 13: CLEAN-TABLE VALIDATION
-- =====================================================

SELECT
    COUNT(*) AS cleaned_rows,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_rows,

    COUNT(*) FILTER (
        WHERE invoice_no IS NULL
    ) AS missing_invoice_rows,

    COUNT(*) FILTER (
        WHERE invoice_date IS NULL
    ) AS missing_date_rows,

    COUNT(*) FILTER (
        WHERE invoice_no LIKE 'C%'
    ) AS cancellation_rows,

    COUNT(*) FILTER (
        WHERE quantity <= 0
    ) AS invalid_quantity_rows,

    COUNT(*) FILTER (
        WHERE unit_price <= 0
    ) AS invalid_price_rows

FROM lesson25_cleaned_transactions;


-- =====================================================
-- SECTION 14: CHECK REVENUE CALCULATION
-- =====================================================

SELECT
    sale_id,
    invoice_no,
    description,
    quantity,
    unit_price,
    line_revenue

FROM lesson25_cleaned_transactions

ORDER BY sale_id;


-- =====================================================
-- SECTION 15: CLEANED DATASET SUMMARY
-- =====================================================

SELECT
    COUNT(*) AS transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS invoice_count,

    COUNT(DISTINCT customer_id)
        AS customer_count,

    COUNT(DISTINCT country)
        AS country_count,

    SUM(quantity)
        AS total_units,

    ROUND(
        SUM(line_revenue),
        2
    ) AS gross_revenue,

    MIN(invoice_date)
        AS earliest_transaction,

    MAX(invoice_date)
        AS latest_transaction

FROM lesson25_cleaned_transactions;


-- =====================================================
-- SECTION 16: RAW VS CLEAN REVENUE
-- =====================================================

SELECT
    ROUND(
        (
            SELECT SUM(quantity * unit_price)
            FROM lesson25_raw_online_retail
        ),
        2
    ) AS raw_revenue,

    ROUND(
        (
            SELECT SUM(line_revenue)
            FROM lesson25_cleaned_transactions
        ),
        2
    ) AS cleaned_revenue;


-- =====================================================
-- SECTION 17: EXCLUDED REVENUE
-- =====================================================

SELECT
    COUNT(*) AS excluded_rows,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS excluded_net_revenue

FROM lesson25_raw_online_retail

WHERE customer_id IS NULL
   OR invoice_no IS NULL
   OR invoice_date IS NULL
   OR invoice_no LIKE 'C%'
   OR quantity <= 0
   OR unit_price <= 0;


-- =====================================================
-- SECTION 18: DUPLICATE AUDIT
-- =====================================================

SELECT
    invoice_no,
    description,
    quantity,
    unit_price,
    invoice_date,
    customer_id,
    country,

    COUNT(*) AS duplicate_count

FROM lesson25_cleaned_transactions

GROUP BY
    invoice_no,
    description,
    quantity,
    unit_price,
    invoice_date,
    customer_id,
    country

HAVING COUNT(*) > 1;


-- =====================================================
-- SECTION 19: COUNTRY SUMMARY
-- =====================================================

SELECT
    country,

    COUNT(*) AS transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS invoice_count,

    COUNT(DISTINCT customer_id)
        AS customer_count,

    SUM(quantity)
        AS total_units,

    ROUND(
        SUM(line_revenue),
        2
    ) AS gross_revenue

FROM lesson25_cleaned_transactions

GROUP BY country

ORDER BY gross_revenue DESC;


-- =====================================================
-- SECTION 20: CUSTOMER SUMMARY
-- =====================================================

SELECT
    customer_id,

    COUNT(*) AS transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    SUM(quantity)
        AS total_units,

    ROUND(
        SUM(line_revenue),
        2
    ) AS monetary_value,

    MIN(invoice_date)
        AS first_purchase,

    MAX(invoice_date)
        AS last_purchase

FROM lesson25_cleaned_transactions

GROUP BY customer_id

ORDER BY monetary_value DESC;


-- =====================================================
-- SECTION 21: RFM PREPARATION TABLE
-- =====================================================

SELECT
    customer_id,

    MAX(invoice_date)
        AS last_purchase_date,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    ROUND(
        SUM(line_revenue),
        2
    ) AS monetary_value

FROM lesson25_cleaned_transactions

GROUP BY customer_id

ORDER BY monetary_value DESC;


-- =====================================================
-- SECTION 22: LESSON COMPLETION
-- =====================================================

SELECT
    'Lesson 25 completed successfully'
        AS lesson_status;