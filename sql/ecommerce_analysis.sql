-- ================================================
-- Global E-Commerce Supply Chain Analysis
-- Author: Saad Ahmed
-- Tool: MySQL Workbench
-- Dataset: DataCo Smart Supply Chain (180,516 orders)
-- ================================================

USE ecommerce_analysis;

-- -----------------------------------------------
-- QUERY 1: Overall Business Summary
-- -----------------------------------------------
SELECT
    COUNT(DISTINCT order_id)                        AS total_orders,
    ROUND(SUM(sales), 2)                            AS total_revenue,
    ROUND(AVG(profit_ratio) * 100, 2)              AS avg_profit_pct,
    ROUND(AVG(late_delivery_risk) * 100, 2)        AS late_delivery_pct
FROM fact_orders;

-- -----------------------------------------------
-- QUERY 2: Revenue & Late Delivery by Market
-- -----------------------------------------------
SELECT
    market,
    COUNT(DISTINCT order_id)                        AS total_orders,
    ROUND(SUM(sales), 2)                            AS total_revenue,
    ROUND(SUM(sales) * 100.0 /
          (SELECT SUM(sales) FROM fact_orders), 2)  AS revenue_share_pct,
    ROUND(AVG(late_delivery_risk) * 100, 2)        AS late_delivery_pct
FROM fact_orders
GROUP BY market
ORDER BY total_revenue DESC;

-- -----------------------------------------------
-- QUERY 3: Top 5 Categories by Revenue & Profit
-- -----------------------------------------------
SELECT
    c.category_name,
    COUNT(DISTINCT f.order_id)                      AS total_orders,
    ROUND(SUM(f.sales), 2)                          AS total_revenue,
    ROUND(AVG(f.profit_ratio) * 100, 2)            AS avg_profit_pct
FROM fact_orders f
JOIN dim_categories c ON f.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_revenue DESC
LIMIT 5;

-- -----------------------------------------------
-- QUERY 4: Shipping Mode Performance
-- -----------------------------------------------
SELECT
    shipping_mode,
    COUNT(*)                                        AS total_orders,
    ROUND(AVG(late_delivery_risk) * 100, 2)        AS late_delivery_pct,
    ROUND(AVG(days_shipping_real), 1)              AS avg_days_actual,
    ROUND(AVG(days_shipping_scheduled), 1)         AS avg_days_scheduled,
    ROUND(AVG(days_shipping_real) -
          AVG(days_shipping_scheduled), 1)         AS avg_days_overdue
FROM fact_orders
GROUP BY shipping_mode
ORDER BY late_delivery_pct DESC;

-- -----------------------------------------------
-- QUERY 5: Revenue Lost to Late & Canceled Orders
-- -----------------------------------------------
SELECT
    delivery_status,
    COUNT(*)                                        AS total_orders,
    ROUND(SUM(sales), 2)                           AS total_revenue,
    ROUND(SUM(sales) * 100.0 /
          (SELECT SUM(sales) FROM fact_orders), 2) AS revenue_share_pct,
    ROUND(AVG(profit_ratio) * 100, 2)             AS avg_profit_pct
FROM fact_orders
GROUP BY delivery_status
ORDER BY total_orders DESC;