-- =====================================================
-- Lesson: 38
-- Topic: Analyse RFM Segments
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
-- SECTION 2: CREATE CUSTOMER TABLE
-- =====================================================

DROP TABLE IF EXISTS lesson38_customers;

CREATE TEMP TABLE lesson38_customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(50),
    home_country VARCHAR(100)
);

INSERT INTO lesson38_customers (
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
-- SECTION 3: CREATE SEGMENTED RFM TABLE
-- =====================================================

DROP TABLE IF EXISTS lesson38_rfm_segments;

CREATE TEMP TABLE lesson38_rfm_segments (
    customer_id VARCHAR(20) PRIMARY KEY,
    recency INTEGER,
    frequency INTEGER,
    monetary NUMERIC(12, 2),
    r_score INTEGER,
    f_score INTEGER,
    m_score INTEGER,
    rfm_code VARCHAR(10),
    total_rfm_score INTEGER,
    customer_segment VARCHAR(50)
);

INSERT INTO lesson38_rfm_segments (
    customer_id,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    rfm_code,
    total_rfm_score,
    customer_segment
)
VALUES
    ('1001', 2, 3, 300.00, 5, 4, 5, '545', 14, 'Champions'),
    ('1002', 5, 2, 240.00, 5, 2, 5, '525', 12, 'Potential Loyalists'),
    ('1003', 7, 3, 220.00, 4, 5, 4, '454', 13, 'Champions'),
    ('1004', 10, 2, 180.00, 4, 3, 4, '434', 11, 'Potential Loyalists'),
    ('1005', 15, 3, 160.00, 3, 5, 3, '353', 11, 'Loyal Customers'),
    ('1006', 20, 2, 140.00, 3, 3, 3, '333', 9, 'Need Attention'),
    ('1007', 30, 1, 120.00, 2, 1, 2, '212', 5, 'Lost Customers'),
    ('1008', 45, 2, 100.00, 2, 4, 2, '242', 8, 'At Risk'),
    ('1009', 60, 1, 80.00, 1, 1, 1, '111', 3, 'Lost Customers'),
    ('1010', 90, 1, 60.00, 1, 2, 1, '121', 4, 'Hibernating');


-- =====================================================
-- SECTION 4: PREVIEW
-- =====================================================

SELECT *
FROM lesson38_rfm_segments

ORDER BY
    total_rfm_score DESC,
    monetary DESC;


-- =====================================================
-- SECTION 5: CUSTOMER COUNT BY SEGMENT
-- =====================================================

SELECT
    customer_segment,
    COUNT(*) AS customer_count

FROM lesson38_rfm_segments

GROUP BY customer_segment

ORDER BY
    customer_count DESC,
    customer_segment;


-- =====================================================
-- SECTION 6: CUSTOMER SHARE BY SEGMENT
-- =====================================================

WITH segment_counts AS (

    SELECT
        customer_segment,
        COUNT(*) AS customer_count

    FROM lesson38_rfm_segments

    GROUP BY customer_segment
)

SELECT
    customer_segment,
    customer_count,

    ROUND(
        100.0
        * customer_count
        /
        SUM(customer_count) OVER (),
        2
    ) AS customer_share_pct

FROM segment_counts

ORDER BY
    customer_count DESC,
    customer_segment;


-- =====================================================
-- SECTION 7: REVENUE BY SEGMENT
-- =====================================================

SELECT
    customer_segment,

    COUNT(*) AS customer_count,

    ROUND(
        SUM(monetary),
        2
    ) AS segment_revenue

FROM lesson38_rfm_segments

GROUP BY customer_segment

ORDER BY segment_revenue DESC;


-- =====================================================
-- SECTION 8: REVENUE SHARE BY SEGMENT
-- =====================================================

WITH segment_revenue AS (

    SELECT
        customer_segment,

        SUM(monetary)
            AS segment_revenue

    FROM lesson38_rfm_segments

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
-- SECTION 9: AVERAGE RFM BY SEGMENT
-- =====================================================

SELECT
    customer_segment,

    COUNT(*) AS customer_count,

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

FROM lesson38_rfm_segments

GROUP BY customer_segment

ORDER BY avg_monetary DESC;


-- =====================================================
-- SECTION 10: CHAMPIONS
-- =====================================================

SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    rfm_code,
    total_rfm_score

FROM lesson38_rfm_segments

WHERE customer_segment = 'Champions'

ORDER BY monetary DESC;


-- =====================================================
-- SECTION 11: LOYAL CUSTOMERS
-- =====================================================

SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    rfm_code

FROM lesson38_rfm_segments

WHERE customer_segment = 'Loyal Customers'

ORDER BY monetary DESC;


-- =====================================================
-- SECTION 12: POTENTIAL LOYALISTS
-- =====================================================

SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    rfm_code

FROM lesson38_rfm_segments

WHERE customer_segment = 'Potential Loyalists'

ORDER BY monetary DESC;


-- =====================================================
-- SECTION 13: NEED ATTENTION
-- =====================================================

SELECT *
FROM lesson38_rfm_segments

WHERE customer_segment = 'Need Attention'

ORDER BY monetary DESC;


-- =====================================================
-- SECTION 14: AT-RISK CUSTOMERS
-- =====================================================

SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    rfm_code

FROM lesson38_rfm_segments

WHERE customer_segment = 'At Risk'

ORDER BY monetary DESC;


-- =====================================================
-- SECTION 15: LOST CUSTOMERS
-- =====================================================

SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    rfm_code

FROM lesson38_rfm_segments

WHERE customer_segment = 'Lost Customers'

ORDER BY monetary DESC;


-- =====================================================
-- SECTION 16: HIBERNATING CUSTOMERS
-- =====================================================

SELECT *
FROM lesson38_rfm_segments

WHERE customer_segment = 'Hibernating'

ORDER BY monetary DESC;


-- =====================================================
-- SECTION 17: RISK-SEGMENT REVENUE
-- =====================================================

SELECT
    ROUND(
        SUM(monetary),
        2
    ) AS risk_segment_revenue

FROM lesson38_rfm_segments

WHERE customer_segment IN (
    'At Risk',
    'Hibernating',
    'Lost Customers'
);


-- =====================================================
-- SECTION 18: RISK REVENUE PERCENTAGE
-- =====================================================

SELECT
    ROUND(
        100.0
        * SUM(
            CASE
                WHEN customer_segment IN (
                    'At Risk',
                    'Hibernating',
                    'Lost Customers'
                )
                    THEN monetary

                ELSE 0
            END
        )
        /
        SUM(monetary),
        2
    ) AS risk_revenue_pct

FROM lesson38_rfm_segments;


-- =====================================================
-- SECTION 19: STRONG CUSTOMER REVENUE
-- =====================================================

SELECT
    ROUND(
        SUM(monetary),
        2
    ) AS strong_customer_revenue

FROM lesson38_rfm_segments

WHERE customer_segment IN (
    'Champions',
    'Loyal Customers',
    'Potential Loyalists'
);


-- =====================================================
-- SECTION 20: STRONG REVENUE SHARE
-- =====================================================

SELECT
    ROUND(
        100.0
        * SUM(
            CASE
                WHEN customer_segment IN (
                    'Champions',
                    'Loyal Customers',
                    'Potential Loyalists'
                )
                    THEN monetary

                ELSE 0
            END
        )
        /
        SUM(monetary),
        2
    ) AS strong_customer_revenue_pct

FROM lesson38_rfm_segments;


-- =====================================================
-- SECTION 21: RANK CUSTOMERS WITHIN SEGMENT
-- =====================================================

WITH ranked_customers AS (

    SELECT
        customer_id,
        customer_segment,
        recency,
        frequency,
        monetary,

        ROW_NUMBER()
        OVER (
            PARTITION BY customer_segment

            ORDER BY
                monetary DESC,
                customer_id
        ) AS segment_value_rank

    FROM lesson38_rfm_segments
)

SELECT *
FROM ranked_customers

ORDER BY
    customer_segment,
    segment_value_rank;


-- =====================================================
-- SECTION 22: TOP CUSTOMER IN EACH SEGMENT
-- =====================================================

WITH ranked_customers AS (

    SELECT
        customer_id,
        customer_segment,
        monetary,

        ROW_NUMBER()
        OVER (
            PARTITION BY customer_segment

            ORDER BY
                monetary DESC,
                customer_id
        ) AS segment_rank

    FROM lesson38_rfm_segments
)

SELECT
    customer_id,
    customer_segment,
    monetary

FROM ranked_customers

WHERE segment_rank = 1

ORDER BY monetary DESC;


-- =====================================================
-- SECTION 23: RETENTION PRIORITY
-- =====================================================

SELECT
    customer_id,
    customer_segment,
    recency,
    frequency,
    monetary,

    CASE
        WHEN customer_segment IN (
            'Champions',
            'At Risk'
        )
            THEN 1

        WHEN customer_segment IN (
            'Loyal Customers',
            'Potential Loyalists',
            'Need Attention'
        )
            THEN 2

        ELSE 3
    END AS retention_priority

FROM lesson38_rfm_segments

ORDER BY
    retention_priority,
    monetary DESC;


-- =====================================================
-- SECTION 24: RECOMMENDED ACTION
-- =====================================================

SELECT
    customer_id,
    customer_segment,

    CASE
        WHEN customer_segment = 'Champions'
            THEN 'Retain, reward and encourage advocacy'

        WHEN customer_segment = 'Loyal Customers'
            THEN 'Cross-sell, upsell and reward loyalty'

        WHEN customer_segment = 'Potential Loyalists'
            THEN 'Encourage repeat purchases and loyalty enrolment'

        WHEN customer_segment = 'Need Attention'
            THEN 'Use personalised re-engagement'

        WHEN customer_segment = 'At Risk'
            THEN 'Immediate win-back and retention campaign'

        WHEN customer_segment = 'Hibernating'
            THEN 'Use low-cost reactivation offers'

        WHEN customer_segment = 'Lost Customers'
            THEN 'Test low-cost reacquisition only'

        ELSE 'Review customer profile'
    END AS recommended_action

FROM lesson38_rfm_segments

ORDER BY customer_id;


-- =====================================================
-- SECTION 25: MANAGEMENT SEGMENT SUMMARY
-- =====================================================

WITH segment_summary AS (

    SELECT
        customer_segment,

        COUNT(*) AS customer_count,

        SUM(monetary)
            AS segment_revenue,

        AVG(recency)
            AS avg_recency,

        AVG(frequency)
            AS avg_frequency,

        AVG(monetary)
            AS avg_monetary

    FROM lesson38_rfm_segments

    GROUP BY customer_segment
)

SELECT
    customer_segment,
    customer_count,

    ROUND(
        100.0
        * customer_count
        /
        SUM(customer_count) OVER (),
        2
    ) AS customer_share_pct,

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
    ) AS revenue_share_pct,

    ROUND(
        avg_recency,
        2
    ) AS avg_recency,

    ROUND(
        avg_frequency,
        2
    ) AS avg_frequency,

    ROUND(
        avg_monetary,
        2
    ) AS avg_monetary

FROM segment_summary

ORDER BY segment_revenue DESC;


-- =====================================================
-- SECTION 26: CUSTOMER DETAILS + SEGMENT
-- =====================================================

SELECT
    c.customer_id,
    c.customer_name,
    c.home_country,

    r.recency,
    r.frequency,
    r.monetary,
    r.rfm_code,
    r.customer_segment

FROM lesson38_customers AS c

INNER JOIN lesson38_rfm_segments AS r
    ON c.customer_id = r.customer_id

ORDER BY
    r.monetary DESC;


-- =====================================================
-- SECTION 27: INCLUDE NO-PURCHASE CUSTOMERS
-- =====================================================

SELECT
    c.customer_id,
    c.customer_name,
    c.home_country,

    r.customer_segment,

    CASE
        WHEN r.customer_id IS NULL
            THEN 'No Purchase History'
        ELSE 'Purchasing Customer'
    END AS customer_status

FROM lesson38_customers AS c

LEFT JOIN lesson38_rfm_segments AS r
    ON c.customer_id = r.customer_id

ORDER BY c.customer_id;


-- =====================================================
-- SECTION 28: CUSTOMER COUNT VALIDATION
-- =====================================================

SELECT
    COUNT(*) AS rfm_customers
FROM lesson38_rfm_segments;


SELECT
    COUNT(*) AS all_customers
FROM lesson38_customers;


-- =====================================================
-- SECTION 29: REVENUE VALIDATION
-- =====================================================

SELECT
    ROUND(
        SUM(monetary),
        2
    ) AS total_rfm_revenue

FROM lesson38_rfm_segments;


-- =====================================================
-- SECTION 30: LESSON COMPLETION
-- =====================================================

SELECT
    'Lesson 38 completed successfully'
        AS lesson_status;