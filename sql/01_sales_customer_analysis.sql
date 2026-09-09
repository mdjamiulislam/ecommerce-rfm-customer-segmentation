SELECT
    current_database() AS database_name,
    current_schema() AS schema_name,
    current_user AS connected_user;

DROP TABLE IF EXISTS lesson24_online_retail;

CREATE TEMP TABLE lesson24_online_retail (
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

INSERT INTO lesson24_online_retail (
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
FROM lesson24_online_retail
ORDER BY sale_id;

SELECT
    country,
    COUNT(*) AS transaction_lines
FROM lesson24_online_retail
WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL
GROUP BY country
ORDER BY
    transaction_lines DESC,
    country;

SELECT
    country,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_revenue

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY country

ORDER BY gross_revenue DESC;

SELECT
    country,

    COUNT(*) AS transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS invoice_count,

    COUNT(DISTINCT customer_id)
        AS customer_count

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY country

ORDER BY
    invoice_count DESC,
    country;

SELECT
    country,

    SUM(quantity) AS total_units,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_revenue

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY country

ORDER BY total_units DESC;

SELECT
    country,

    COUNT(*) AS invoice_count,

    ROUND(
        SUM(invoice_revenue),
        2
    ) AS total_revenue,

    ROUND(
        AVG(invoice_revenue),
        2
    ) AS average_invoice_value

FROM (
    SELECT
        country,
        invoice_no,

        SUM(quantity * unit_price)
            AS invoice_revenue

    FROM lesson24_online_retail

    WHERE NOT is_cancelled
      AND quantity > 0
      AND unit_price > 0
      AND customer_id IS NOT NULL

    GROUP BY
        country,
        invoice_no

) AS invoice_summary

GROUP BY country

ORDER BY
    total_revenue DESC;

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
        AVG(unit_price),
        2
    ) AS average_unit_price,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_revenue,

    ROUND(
        AVG(quantity * unit_price),
        2
    ) AS average_line_value,

    ROUND(
        MIN(quantity * unit_price),
        2
    ) AS minimum_line_value,

    ROUND(
        MAX(quantity * unit_price),
        2
    ) AS maximum_line_value,

    MIN(invoice_date)
        AS first_transaction,

    MAX(invoice_date)
        AS latest_transaction

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY country

ORDER BY gross_revenue DESC;

SELECT
    country,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_revenue

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY country

ORDER BY gross_revenue DESC

LIMIT 3;

SELECT
    country,
    sales_channel,

    COUNT(*) AS transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS invoice_count,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_revenue

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY
    country,
    sales_channel

ORDER BY
    country,
    gross_revenue DESC;

SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY customer_id

ORDER BY
    frequency DESC,
    customer_id;

SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS monetary_value

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY customer_id

HAVING COUNT(DISTINCT invoice_no) >= 2

ORDER BY
    frequency DESC,
    monetary_value DESC;


SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS monetary_value,
	
	CASE
		WHEN COUNT(DISTINCT invoice_no) >= 2
			AND SUM(quantity * unit_price) >= 100
				THEN 'Repeat High Value'
		WHEN SUM(quantity * unit_price) >= 100
				THEN 'High Value One-Time'
		WHEN COUNT(DISTINCT invoice_no) >= 2
			THEN 'Repeat Customer'
		ELSE 'STandard Customer'
	END AS customer_type
FROM lesson24_online_retail
WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY
	monetary_value DESC;


SELECT
    customer_id,
    country,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    SUM(quantity)
        AS total_units,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS monetary_value,

    MAX(invoice_date)
        AS last_purchase

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY
    customer_id,
    country

ORDER BY monetary_value DESC;

SELECT
    customer_id,

    COUNT(*) AS invoice_count,

    ROUND(
        SUM(invoice_revenue),
        2
    ) AS monetary_value,

    ROUND(
        AVG(invoice_revenue),
        2
    ) AS average_invoice_value

FROM (
    SELECT
        customer_id,
        invoice_no,

        SUM(quantity * unit_price)
            AS invoice_revenue

    FROM lesson24_online_retail

    WHERE NOT is_cancelled
      AND quantity > 0
      AND unit_price > 0
      AND customer_id IS NOT NULL

    GROUP BY
        customer_id,
        invoice_no

) AS invoice_summary

GROUP BY customer_id

ORDER BY monetary_value DESC;

SELECT
    customer_id,

    COUNT(*) AS invoice_count,

    ROUND(
        AVG(invoice_revenue),
        2
    ) AS average_invoice_value

FROM (
    SELECT
        customer_id,
        invoice_no,

        SUM(quantity * unit_price)
            AS invoice_revenue

    FROM lesson24_online_retail

    WHERE NOT is_cancelled
      AND quantity > 0
      AND unit_price > 0
      AND customer_id IS NOT NULL

    GROUP BY
        customer_id,
        invoice_no

) AS invoice_summary

GROUP BY customer_id

ORDER BY
    average_invoice_value DESC;

SELECT
    customer_id,
    country,

    COUNT(*) AS transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    SUM(quantity)
        AS total_units,

    ROUND(
        AVG(unit_price),
        2
    ) AS average_unit_price,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS monetary_value,

    ROUND(
        AVG(quantity * unit_price),
        2
    ) AS average_line_value,

    MIN(invoice_date)
        AS first_purchase,

    MAX(invoice_date)
        AS last_purchase

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY
    customer_id,
    country

ORDER BY monetary_value DESC;


-- =====================================================
-- Lesson: 24
-- Topic: Analyse Sales by Country and Customer
-- Database: ecommerce_rfm
-- Schema: public
-- Project: E-Commerce Customer Segmentation
-- Author: Md Jamiul Islam
-- Created: 2026-08-16
-- Purpose: Analyse country and customer sales performance
-- =====================================================


-- =====================================================
-- SECTION 1: CONNECTION CHECK
-- =====================================================

SELECT
    current_database() AS database_name,
    current_schema() AS schema_name,
    current_user AS connected_user;


-- =====================================================
-- SECTION 2: CREATE TEMP PRACTICE TABLE
-- =====================================================

DROP TABLE IF EXISTS lesson24_online_retail;

CREATE TEMP TABLE lesson24_online_retail (
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
-- SECTION 3: INSERT PRACTICE DATA
-- =====================================================

INSERT INTO lesson24_online_retail (
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
-- SECTION 4: PREVIEW
-- =====================================================

SELECT *
FROM lesson24_online_retail
ORDER BY sale_id;


-- =====================================================
-- SECTION 5: COUNTRY REVENUE
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
        SUM(quantity * unit_price),
        2
    ) AS gross_revenue

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY country

ORDER BY gross_revenue DESC;


-- =====================================================
-- SECTION 6: COUNTRY KPI REPORT
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
        AVG(unit_price),
        2
    ) AS average_unit_price,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_revenue,

    ROUND(
        AVG(quantity * unit_price),
        2
    ) AS average_line_value,

    ROUND(
        MIN(quantity * unit_price),
        2
    ) AS minimum_line_value,

    ROUND(
        MAX(quantity * unit_price),
        2
    ) AS maximum_line_value,

    MIN(invoice_date)
        AS first_transaction,

    MAX(invoice_date)
        AS latest_transaction

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY country

ORDER BY gross_revenue DESC;


-- =====================================================
-- SECTION 7: TOP THREE COUNTRIES
-- =====================================================

SELECT
    country,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_revenue

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY country

ORDER BY gross_revenue DESC

LIMIT 3;


-- =====================================================
-- SECTION 8: COUNTRY + SALES CHANNEL
-- =====================================================

SELECT
    country,
    sales_channel,

    COUNT(*) AS transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS invoice_count,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_revenue

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY
    country,
    sales_channel

ORDER BY
    country,
    gross_revenue DESC;


-- =====================================================
-- SECTION 9: INVOICE-LEVEL REVENUE
-- =====================================================

SELECT
    country,
    invoice_no,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS invoice_revenue

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY
    country,
    invoice_no

ORDER BY
    country,
    invoice_no;


-- =====================================================
-- SECTION 10: AVERAGE INVOICE VALUE BY COUNTRY
-- =====================================================

SELECT
    country,

    COUNT(*) AS invoice_count,

    ROUND(
        SUM(invoice_revenue),
        2
    ) AS total_revenue,

    ROUND(
        AVG(invoice_revenue),
        2
    ) AS average_invoice_value

FROM (
    SELECT
        country,
        invoice_no,

        SUM(quantity * unit_price)
            AS invoice_revenue

    FROM lesson24_online_retail

    WHERE NOT is_cancelled
      AND quantity > 0
      AND unit_price > 0
      AND customer_id IS NOT NULL

    GROUP BY
        country,
        invoice_no

) AS invoice_summary

GROUP BY country

ORDER BY total_revenue DESC;


-- =====================================================
-- SECTION 11: CUSTOMER FREQUENCY
-- =====================================================

SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY customer_id

ORDER BY
    frequency DESC,
    customer_id;


-- =====================================================
-- SECTION 12: CUSTOMER MONETARY VALUE
-- =====================================================

SELECT
    customer_id,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS monetary_value

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY customer_id

ORDER BY monetary_value DESC;


-- =====================================================
-- SECTION 13: CUSTOMER KPI REPORT
-- =====================================================

SELECT
    customer_id,

    COUNT(*) AS transaction_lines,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    SUM(quantity)
        AS total_units,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS monetary_value,

    MIN(invoice_date)
        AS first_purchase,

    MAX(invoice_date)
        AS last_purchase

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY customer_id

ORDER BY monetary_value DESC;


-- =====================================================
-- SECTION 14: CUSTOMER + COUNTRY PROFILE
-- =====================================================

SELECT
    customer_id,
    country,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    SUM(quantity)
        AS total_units,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS monetary_value,

    MAX(invoice_date)
        AS last_purchase

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY
    customer_id,
    country

ORDER BY monetary_value DESC;


-- =====================================================
-- SECTION 15: REPEAT CUSTOMERS
-- =====================================================

SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS monetary_value

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY customer_id

HAVING COUNT(DISTINCT invoice_no) >= 2

ORDER BY
    frequency DESC,
    monetary_value DESC;


-- =====================================================
-- SECTION 16: HIGH-VALUE CUSTOMERS
-- =====================================================

SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS monetary_value

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY customer_id

HAVING SUM(quantity * unit_price) >= 40

ORDER BY monetary_value DESC;


-- =====================================================
-- SECTION 17: CUSTOMER BUSINESS CATEGORY
-- =====================================================

SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS monetary_value,

    CASE
        WHEN COUNT(DISTINCT invoice_no) >= 2
         AND SUM(quantity * unit_price) >= 100
            THEN 'Repeat High Value'

        WHEN SUM(quantity * unit_price) >= 100
            THEN 'High Value One-Time'

        WHEN COUNT(DISTINCT invoice_no) >= 2
            THEN 'Repeat Customer'

        ELSE 'Standard Customer'
    END AS customer_type

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY customer_id

ORDER BY monetary_value DESC;


-- =====================================================
-- SECTION 18: AVERAGE INVOICE VALUE BY CUSTOMER
-- =====================================================

SELECT
    customer_id,

    COUNT(*) AS invoice_count,

    ROUND(
        SUM(invoice_revenue),
        2
    ) AS monetary_value,

    ROUND(
        AVG(invoice_revenue),
        2
    ) AS average_invoice_value

FROM (
    SELECT
        customer_id,
        invoice_no,

        SUM(quantity * unit_price)
            AS invoice_revenue

    FROM lesson24_online_retail

    WHERE NOT is_cancelled
      AND quantity > 0
      AND unit_price > 0
      AND customer_id IS NOT NULL

    GROUP BY
        customer_id,
        invoice_no

) AS invoice_summary

GROUP BY customer_id

ORDER BY monetary_value DESC;


-- =====================================================
-- SECTION 19: ACTIVE COUNTRY SCREEN
-- =====================================================

SELECT
    country,

    COUNT(DISTINCT customer_id)
        AS customer_count,

    COUNT(DISTINCT invoice_no)
        AS invoice_count,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_revenue

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY country

HAVING COUNT(DISTINCT customer_id) >= 2
   AND COUNT(DISTINCT invoice_no) >= 2

ORDER BY gross_revenue DESC;


-- =====================================================
-- SECTION 20: COUNTRY SCALE + REVENUE SCREEN
-- =====================================================

SELECT
    country,

    COUNT(DISTINCT invoice_no)
        AS invoice_count,

    COUNT(DISTINCT customer_id)
        AS customer_count,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_revenue

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY country

HAVING COUNT(DISTINCT invoice_no) >= 2
   AND SUM(quantity * unit_price) >= 50

ORDER BY gross_revenue DESC;


-- =====================================================
-- SECTION 21: RFM PREPARATION
-- =====================================================

SELECT
    customer_id,

    COUNT(DISTINCT invoice_no)
        AS frequency,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS monetary_value,

    MAX(invoice_date)
        AS last_purchase_date

FROM lesson24_online_retail

WHERE NOT is_cancelled
  AND quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL

GROUP BY customer_id

ORDER BY monetary_value DESC;


-- =====================================================
-- SECTION 22: LESSON COMPLETION
-- =====================================================

SELECT
    'Lesson 24 completed successfully'
        AS lesson_status;
