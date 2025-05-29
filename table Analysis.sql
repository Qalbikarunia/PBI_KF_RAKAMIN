--Pembuatan Table Analysis

CREATE OR REPLACE TABLE kimia_farma.kf_analysis AS
SELECT 
  ft.transaction_id,
  ft.date,
  kc.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating as rating_cabang,
  ft.customer_name,
  p.product_id,
  p.product_name,
  p.price as actual_price,
  ft.discount_percentage,
  CASE
    WHEN p.price <= 50000 THEN 0.1
    WHEN p.price BETWEEN 50000 AND 100000 THEN 0.15
    WHEN p.price BETWEEN 100000 AND 300000 THEN 0.2
    WHEN p.price BETWEEN 300000 AND 500000 THEN 0.25
    WHEN p.price > 500000 THEN 0.3
  END AS percentage_gross_laba,
  (p.price * (1 - ft.discount_percentage)) as nett_sales,
  (((p.price * (1 - ft.discount_percentage)) * 
  CASE
    WHEN p.price <= 50000 THEN 0.1
    WHEN p.price BETWEEN 50000 AND 100000 THEN 0.15
    WHEN p.price BETWEEN 100000 AND 300000 THEN 0.2
    WHEN p.price BETWEEN 300000 AND 500000 THEN 0.25
    WHEN p.price > 500000 THEN 0.3
  END) - ((p.price * (1 - ft.discount_percentage)) - p.price)) as nett_profit,
  ft.rating as rating_transaksi
FROM `rakamin-kf-analytics-460916.kimia_farma.kf_final_transaction` as ft
  INNER JOIN `rakamin-kf-analytics-460916.kimia_farma.kf_kantor_cabang`as kc
    ON ft.branch_id = kc.branch_id
  INNER JOIN `rakamin-kf-analytics-460916.kimia_farma.kf_product` as p
    ON ft.product_id = p.product_id

-- Panggil table
SELECT * 
FROM `rakamin-kf-analytics-460916.kimia_farma.kf_analysis`
