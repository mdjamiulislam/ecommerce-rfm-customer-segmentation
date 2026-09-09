-- =====================================================
-- Lesson: 37
-- Topic: Create Customer Segments from RFM Scores
--        Using CASE WHEN
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
-- SECTION 2: CREATE CUSTOMER MASTER
-- =====================================================

DROP TABLE IF EXISTS lesson37_customers;

CREATE TEMP TABLE lesson37_customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(50),
    home_country VARCHAR(100)
);

INSERT INTO lesson37_customers (
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
-- SECTION 3: CREATE RFM SCORE TABLE
-- =====================================================

DROP TABLE IF EXISTS lesson37_rfm_scores;

CREATE TEMP TABLE lesson37_rfm_scores (
    customer_id VARCHAR(20) PRIMARY KEY,
    recency INTEGER,
    frequency INTEGER,
    monetary NUMERIC(12, 2),
    r_score INTEGER,
    f_score INTEGER,
    m_score INTEGER
);

INSERT INTO lesson37_rfm_scores (
    customer_id,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score
)
VALUES
    ('1001', 2,  3, 300.00, 5, 4, 5),
    ('1002', 5,  2, 240.00, 5, 2, 5),
    ('1003', 7,  3, 220.00, 4, 5, 4),
    ('1004', 10, 2, 180.00, 4, 3, 4),
    ('1005', 15, 3, 160.00, 3, 5, 3),
    ('1006', 20, 2, 140.00, 3, 3, 3),
    ('1007', 30, 1, 120.00, 2, 1, 2),
    ('1008', 45, 2, 100.00, 2, 4, 2),
    ('1009', 60, 1,  80.00, 1, 1, 1),
    ('1010', 90, 1,  60.00, 1, 2, 1);


-- =====================================================
-- SECTION 4: PREVIEW RFM SCORES
-- =====================================================

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

FROM lesson37_rfm_scores

ORDER BY customer_id;


-- =====================================================
-- SECTION 5: CREATE CUSTOMER SEGMENTS
-- =====================================================

WITH rfm_segmented AS (

    SELECT
        *,

        r_score::TEXT
        || f_score::TEXT
        || m_score::TEXT
            AS rfm_code,

        r_score
        + f_score
        + m_score
            AS total_rfm_score,

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

    FROM lesson37_rfm_scores
)

SELECT *
FROM rfm_segmented

ORDER BY
    total_rfm_score DESC,
    monetary DESC;


-- =====================================================
-- SECTION 6: CUSTOMER SEGMENT + ACTION
-- =====================================================

WITH rfm_segmented AS (

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

    FROM lesson37_rfm_scores
)

SELECT
    customer_id,
    customer_segment,

    CASE
        WHEN customer_segment = 'Champions'
            THEN 'Reward, retain and offer VIP benefits'

        WHEN customer_segment = 'Loyal Customers'
            THEN 'Cross-sell and strengthen loyalty'

        WHEN customer_segment = 'Potential Loyalists'
            THEN 'Encourage additional purchases'

        WHEN customer_segment = 'New Customers'
            THEN 'Welcome and encourage second purchase'

        WHEN customer_segment = 'Promising'
            THEN 'Increase engagement'

        WHEN customer_segment = 'Need Attention'
            THEN 'Personalised re-engagement'

        WHEN customer_segment = 'At Risk'
            THEN 'Run a targeted win-back campaign'

        WHEN customer_segment = 'Hibernating'
            THEN 'Use low-cost reactivation'

        WHEN customer_segment = 'Lost Customers'
            THEN 'Low-priority reacquisition'

        ELSE 'Review customer manually'
    END AS recommended_action

FROM rfm_segmented

ORDER BY customer_id;


-- =====================================================
-- SECTION 7: CUSTOMER COUNT BY SEGMENT
-- =====================================================

WITH rfm_segmented AS (

    SELECT
        customer_id,

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

    FROM lesson37_rfm_scores
)

SELECT
    customer_segment,
    COUNT(*) AS customer_count

FROM rfm_segmented

GROUP BY customer_segment

ORDER BY
    customer_count DESC,
    customer_segment;


-- =====================================================
-- SECTION 8: REVENUE BY SEGMENT
-- =====================================================

WITH rfm_segmented AS (

    SELECT
        monetary,

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

    FROM lesson37_rfm_scores
)

SELECT
    customer_segment,

    COUNT(*) AS customer_count,

    ROUND(
        SUM(monetary),
        2
    ) AS segment_revenue

FROM rfm_segmented

GROUP BY customer_segment

ORDER BY segment_revenue DESC;


-- =====================================================
-- SECTION 9: SEGMENT REVENUE SHARE
-- =====================================================

WITH rfm_segmented AS (

    SELECT
        monetary,

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

    FROM lesson37_rfm_scores
),

segment_revenue AS (

    SELECT
        customer_segment,
        SUM(monetary) AS segment_revenue

    FROM rfm_segmented

    GROUP BY customer_segment
)

SELECT
    customer_segment,

    ROUND(
        segment_revenue,
        2
    ) AS segment_revenue,

    ROUND(
        100.0
        * segment_revenue
        /
        SUM(segment_revenue) OVER (),
        2
    ) AS revenue_share_pct

FROM segment_revenue

ORDER BY segment_revenue DESC;


-- =====================================================
-- SECTION 10: SEGMENT AVERAGE RFM VALUES
-- =====================================================

WITH rfm_segmented AS (

    SELECT
        recency,
        frequency,
        monetary,

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

    FROM lesson37_rfm_scores
)

SELECT
    customer_segment,

    COUNT(*) AS customers,

    ROUND(
        AVG(recency),
        2
    ) AS avg_recency,

    ROUND(
        AVG(frequency),
        2
    ) AS avg_frequency,

    ROUND(
        AVG(monetary),
        2
    ) AS avg_monetary

FROM rfm_segmented

GROUP BY customer_segment

ORDER BY avg_monetary DESC;


-- =====================================================
-- SECTION 11: FINAL CUSTOMER SEGMENT REPORT
-- =====================================================

WITH rfm_segmented AS (

    SELECT
        *,

        r_score::TEXT
        || f_score::TEXT
        || m_score::TEXT
            AS rfm_code,

        r_score
        + f_score
        + m_score
            AS total_rfm_score,

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

    FROM lesson37_rfm_scores
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
    r.total_rfm_score,
    r.customer_segment

FROM lesson37_customers AS c

INNER JOIN rfm_segmented AS r
    ON c.customer_id = r.customer_id

ORDER BY
    r.total_rfm_score DESC,
    r.monetary DESC;


-- =====================================================
-- SECTION 12: ALL-CUSTOMER REPORT
-- =====================================================

WITH rfm_segmented AS (

    SELECT
        *,

        r_score::TEXT
        || f_score::TEXT
        || m_score::TEXT
            AS rfm_code,

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

    FROM lesson37_rfm_scores
)

SELECT
    c.customer_id,
    c.customer_name,
    c.home_country,

    r.recency,

    COALESCE(
        r.frequency,
        0
    ) AS frequency,

    COALESCE(
        r.monetary,
        0
    ) AS monetary,

    r.rfm_code,

    CASE
        WHEN r.customer_id IS NULL
            THEN 'No Purchase History'

        ELSE r.customer_segment
    END AS customer_segment

FROM lesson37_customers AS c

LEFT JOIN rfm_segmented AS r
    ON c.customer_id = r.customer_id

ORDER BY
    r.monetary DESC NULLS LAST,
    c.customer_id;


-- =====================================================
-- SECTION 13: SEGMENT VALIDATION
-- =====================================================

WITH rfm_segmented AS (

    SELECT
        customer_id,

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

    FROM lesson37_rfm_scores
)

SELECT
    COUNT(*) AS total_rfm_customers,

    COUNT(*) FILTER (
        WHERE customer_segment = 'Other'
    ) AS unclassified_customers

FROM rfm_segmented;


-- =====================================================
-- SECTION 14: LESSON COMPLETION
-- =====================================================

SELECT
    'Lesson 37 completed successfully'
        AS lesson_status;