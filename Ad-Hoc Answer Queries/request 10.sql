/*
Request 10. Get the Top 3 products in each division that have a high
total_sold_quantity in the fiscal_year 2021? The final output contains these
fields,
division
product_code
product
total_sold_quantity
rank_order
*/

WITH product_table AS (
  SELECT 
    p.division, 
    p.product_code, 
    p.product, 
    SUM(fs.sold_quantity) AS total_sold_quantity
  FROM fact_sales_monthly fs
  JOIN dim_product p ON fs.product_code = p.product_code
  WHERE fs.fiscal_year = 2021
  GROUP BY p.division, p.product_code, p.product
),
ranked_products AS (
  SELECT 
    division,
    product_code,
    product,
    total_sold_quantity,
    DENSE_RANK() OVER (PARTITION BY division ORDER BY total_sold_quantity DESC) AS rank_order
  FROM product_table
)
SELECT 
  division,
  product_code,
  product,
  total_sold_quantity,
  rank_order
FROM ranked_products
WHERE rank_order <= 3;