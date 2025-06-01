--Pembuatan Table Analysis

CREATE OR REPLACE TABLE kimia_farma.kf_analysis AS
WITH base_data AS (
  SELECT 
    ft.transaction_id,
    ft.date,
    kc.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,
    ft.customer_name,
    p.product_id,
    p.product_name,
    p.price AS actual_price,
    ft.discount_percentage,
    CASE
      WHEN p.price <= 50000 THEN 0.1
      WHEN p.price BETWEEN 50000 AND 100000 THEN 0.15
      WHEN p.price BETWEEN 100000 AND 300000 THEN 0.2
      WHEN p.price BETWEEN 300000 AND 500000 THEN 0.25
      WHEN p.price > 500000 THEN 0.3
    END AS percentage_gross_laba,
    ft.rating as rating_transaksi
  FROM `rakamin-kf-analytics-460916.kimia_farma.kf_final_transaction` as ft
  LEFT JOIN `rakamin-kf-analytics-460916.kimia_farma.kf_kantor_cabang`as kc
    ON ft.branch_id = kc.branch_id
  LEFT JOIN `rakamin-kf-analytics-460916.kimia_farma.kf_product` as p
    ON ft.product_id = p.product_id
)
SELECT *,
  (actual_price * (1 - discount_percentage)) AS nett_sales,
  (
    (actual_price * (1 - discount_percentage)) * percentage_gross_laba
    - ((actual_price * (1 - discount_percentage)) - actual_price)
  ) AS nett_profit
FROM base_data;


-- Panggil table
SELECT * 
FROM `rakamin-kf-analytics-460916.kimia_farma.kf_analysis`
