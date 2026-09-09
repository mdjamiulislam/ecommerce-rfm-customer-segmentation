-- =====================================================
-- Lesson: 35
-- Topic: Create RFM Score Groups Using NTILE()
-- Database: ecommerce_rfm
-- Schema: public
-- Project: E-Commerce Customer Segmentation
-- Author: Md Jamiul Islam
-- Purpose:
-- Convert raw RFM measures into 1-5 quintile scores
-- =====================================================


-- =====================================================
-- SECTION 1: CONNECTION CHECK
-- =====================================================

SELECT
    current_database() AS database_name,
    current_schema() AS schema_name,
    current_user AS connected_user;


-- =====================================================
-- SECTION 2: CREATE CUSTOMER MASTER
-- =====================================================

DROP TABLE IF EXISTS lesson35_customers;

CREATE TEMP TABLE lesson35_customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(50),
    home_country VARCHAR(100)
);


INSERT INTO lesson35_customers (
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
-- SECTION 3: CREATE RAW RFM TABLE
-- =====================================================

DROP TABLE IF EXISTS lesson35_rfm_base;

CREATE TEMP TABLE lesson35_rfm_base (
    customer_id VARCHAR(20) PRIMARY KEY,
    recency INTEGER,
    frequency INTEGER,
    monetary NUMERIC(12, 2)
);


INSERT INTO lesson35_rfm_base (
    customer_id,
    recency,
    frequency,
    monetary
)
VALUES
    ('1001', 2,  10, 520.00),
    ('1002', 5,   4, 420.00),
    ('1003', 7,   9, 180.00),
    ('1004', 10,  3, 300.00),
    ('1005', 15,  8, 250.00),
    ('1006', 20,  5,  90.00),
    ('1007', 30,  2, 160.00),
    ('1008', 45,  7, 120.00),
    ('1009', 60,  6, 350.00),
    ('1010', 90,  1,  40.00);


-- =====================================================
-- SECTION 4: PREVIEW RAW RFM
-- =====================================================

SELECT *
FROM lesson35_rfm_base
ORDER BY customer_id;


-- =====================================================
-- SECTION 5: MONETARY SCORE
-- HIGHER MONETARY = HIGHER SCORE
-- =====================================================

SELECT
    customer_id,
    monetary,

    NTILE(5)
    OVER (
        ORDER BY monetary ASC
    ) AS m_score

FROM lesson35_rfm_base

ORDER BY
    m_score,
    monetary;


-- =====================================================
-- SECTION 6: FREQUENCY SCORE
-- HIGHER FREQUENCY = HIGHER SCORE
-- =====================================================

SELECT
    customer_id,
    frequency,

    NTILE(5)
    OVER (
        ORDER BY frequency ASC
    ) AS f_score

FROM lesson35_rfm_base

ORDER BY
    f_score,
    frequency;


-- =====================================================
-- SECTION 7: RECENCY SCORE
-- LOWER RECENCY = HIGHER SCORE
-- =====================================================

SELECT
    customer_id,
    recency,

    NTILE(5)
    OVER (
        ORDER BY recency DESC
    ) AS r_score

FROM lesson35_rfm_base

ORDER BY
    r_score,
    recency DESC;


-- =====================================================
-- SECTION 8: ALL RFM SCORES
-- =====================================================

SELECT
    customer_id,
    recency,
    frequency,
    monetary,

    NTILE(5)
    OVER (
        ORDER BY recency DESC
    ) AS r_score,

    NTILE(5)
    OVER (
        ORDER BY frequency ASC
    ) AS f_score,

    NTILE(5)
    OVER (
        ORDER BY monetary ASC
    ) AS m_score

FROM lesson35_rfm_base

ORDER BY customer_id;


-- =====================================================
-- SECTION 9: RFM CODE
-- =====================================================

WITH rfm_scored AS (

    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5)
        OVER (
            ORDER BY recency DESC
        ) AS r_score,

        NTILE(5)
        OVER (
            ORDER BY frequency ASC
        ) AS f_score,

        NTILE(5)
        OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM lesson35_rfm_base
)

SELECT
    customer_id,
    recency,
    frequency,
    monetary,

    r_score,
    f_score,
    m_score,

    r_score::TEXT
    || f_score::TEXT
    || m_score::TEXT
        AS rfm_code

FROM rfm_scored

ORDER BY customer_id;


-- =====================================================
-- SECTION 10: TOTAL RFM SCORE
-- =====================================================

WITH rfm_scored AS (

    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5)
        OVER (
            ORDER BY recency DESC
        ) AS r_score,

        NTILE(5)
        OVER (
            ORDER BY frequency ASC
        ) AS f_score,

        NTILE(5)
        OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM lesson35_rfm_base
)

SELECT
    customer_id,
    r_score,
    f_score,
    m_score,

    r_score
    + f_score
    + m_score
        AS total_rfm_score

FROM rfm_scored

ORDER BY
    total_rfm_score DESC,
    customer_id;


-- =====================================================
-- SECTION 11: PRACTICE SCORE BANDS
-- =====================================================

WITH rfm_scored AS (

    SELECT
        customer_id,

        NTILE(5)
        OVER (
            ORDER BY recency DESC
        ) AS r_score,

        NTILE(5)
        OVER (
            ORDER BY frequency ASC
        ) AS f_score,

        NTILE(5)
        OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM lesson35_rfm_base
),

rfm_total AS (

    SELECT
        *,

        r_score
        + f_score
        + m_score
            AS total_rfm_score

    FROM rfm_scored
)

SELECT
    customer_id,
    r_score,
    f_score,
    m_score,
    total_rfm_score,

    CASE
        WHEN total_rfm_score >= 13
            THEN 'Strong RFM'

        WHEN total_rfm_score >= 10
            THEN 'Above Average'

        WHEN total_rfm_score >= 7
            THEN 'Mixed'

        ELSE 'Low Overall'
    END AS practice_score_band

FROM rfm_total

ORDER BY
    total_rfm_score DESC,
    customer_id;


-- =====================================================
-- SECTION 12: R SCORE DISTRIBUTION
-- =====================================================

WITH scored AS (

    SELECT
        customer_id,

        NTILE(5)
        OVER (
            ORDER BY recency DESC
        ) AS r_score

    FROM lesson35_rfm_base
)

SELECT
    r_score,
    COUNT(*) AS customer_count

FROM scored

GROUP BY r_score

ORDER BY r_score;


-- =====================================================
-- SECTION 13: F SCORE DISTRIBUTION
-- =====================================================

WITH scored AS (

    SELECT
        customer_id,

        NTILE(5)
        OVER (
            ORDER BY frequency ASC
        ) AS f_score

    FROM lesson35_rfm_base
)

SELECT
    f_score,
    COUNT(*) AS customer_count

FROM scored

GROUP BY f_score

ORDER BY f_score;


-- =====================================================
-- SECTION 14: M SCORE DISTRIBUTION
-- =====================================================

WITH scored AS (

    SELECT
        customer_id,

        NTILE(5)
        OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM lesson35_rfm_base
)

SELECT
    m_score,
    COUNT(*) AS customer_count

FROM scored

GROUP BY m_score

ORDER BY m_score;


-- =====================================================
-- SECTION 15: MONETARY SCORE BOUNDARIES
-- =====================================================

WITH scored AS (

    SELECT
        monetary,

        NTILE(5)
        OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM lesson35_rfm_base
)

SELECT
    m_score,

    MIN(monetary)
        AS minimum_monetary,

    MAX(monetary)
        AS maximum_monetary,

    COUNT(*)
        AS customers

FROM scored

GROUP BY m_score

ORDER BY m_score;


-- =====================================================
-- SECTION 16: RECENCY SCORE BOUNDARIES
-- =====================================================

WITH scored AS (

    SELECT
        recency,

        NTILE(5)
        OVER (
            ORDER BY recency DESC
        ) AS r_score

    FROM lesson35_rfm_base
)

SELECT
    r_score,

    MIN(recency)
        AS minimum_recency,

    MAX(recency)
        AS maximum_recency,

    COUNT(*)
        AS customers

FROM scored

GROUP BY r_score

ORDER BY r_score;


-- =====================================================
-- SECTION 17: FREQUENCY SCORE BOUNDARIES
-- =====================================================

WITH scored AS (

    SELECT
        frequency,

        NTILE(5)
        OVER (
            ORDER BY frequency ASC
        ) AS f_score

    FROM lesson35_rfm_base
)

SELECT
    f_score,

    MIN(frequency)
        AS minimum_frequency,

    MAX(frequency)
        AS maximum_frequency,

    COUNT(*)
        AS customers

FROM scored

GROUP BY f_score

ORDER BY f_score;


-- =====================================================
-- SECTION 18: CUSTOMER DETAILS + RFM SCORES
-- =====================================================

WITH rfm_scored AS (

    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5)
        OVER (
            ORDER BY recency DESC
        ) AS r_score,

        NTILE(5)
        OVER (
            ORDER BY frequency ASC
        ) AS f_score,

        NTILE(5)
        OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM lesson35_rfm_base
)

SELECT
    c.customer_id,
    c.customer_name,
    c.home_country,

    r.recency,
    r.frequency,
    r.monetary,

    r.r_score,
    r.f_score,
    r.m_score,

    r.r_score::TEXT
    || r.f_score::TEXT
    || r.m_score::TEXT
        AS rfm_code

FROM lesson35_customers AS c

INNER JOIN rfm_scored AS r
    ON c.customer_id = r.customer_id

ORDER BY
    r.r_score DESC,
    r.f_score DESC,
    r.m_score DESC;


-- =====================================================
-- SECTION 19: INCLUDE NO-PURCHASE CUSTOMERS
-- =====================================================

WITH rfm_scored AS (

    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5)
        OVER (
            ORDER BY recency DESC
        ) AS r_score,

        NTILE(5)
        OVER (
            ORDER BY frequency ASC
        ) AS f_score,

        NTILE(5)
        OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM lesson35_rfm_base
)

SELECT
    c.customer_id,
    c.customer_name,

    r.recency,
    r.frequency,
    r.monetary,

    r.r_score,
    r.f_score,
    r.m_score,

    CASE
        WHEN r.customer_id IS NULL
            THEN 'No Purchase History'

        ELSE
            r.r_score::TEXT
            || r.f_score::TEXT
            || r.m_score::TEXT
    END AS rfm_code_or_status

FROM lesson35_customers AS c

LEFT JOIN rfm_scored AS r
    ON c.customer_id = r.customer_id

ORDER BY
    r.r_score DESC NULLS LAST,
    c.customer_id;


-- =====================================================
-- SECTION 20: COMPLETE RFM SCORING REPORT
-- =====================================================

WITH rfm_scored AS (

    SELECT
        customer_id,
        recency,
        frequency,
        monetary,

        NTILE(5)
        OVER (
            ORDER BY recency DESC
        ) AS r_score,

        NTILE(5)
        OVER (
            ORDER BY frequency ASC
        ) AS f_score,

        NTILE(5)
        OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM lesson35_rfm_base
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

    r.recency,
    r.frequency,
    r.monetary,

    r.r_score,
    r.f_score,
    r.m_score,

    r.rfm_code,
    r.total_rfm_score

FROM final_rfm AS r

INNER JOIN lesson35_customers AS c
    ON r.customer_id = c.customer_id

ORDER BY
    r.total_rfm_score DESC,
    r.monetary DESC;


-- =====================================================
-- SECTION 21: LESSON COMPLETION
-- =====================================================

SELECT
    'Lesson 35 completed successfully'
        AS lesson_status;