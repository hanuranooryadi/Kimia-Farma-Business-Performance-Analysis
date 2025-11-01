CREATE TABLE `rakaminkfanalytics-476414.kimia_farma.kf_tabel_analisa` AS (
  SELECT
    t.transaction_id,
    t.date,
    t.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang,
    t.customer_name,
    p.product_id,
    p.product_name,
    p.price AS actual_price,
    t.discount_percentage,
    
    -- Persentase laba berdasarkan kategori harga
    CASE
      WHEN p.price <= 50000 THEN 0.10
      WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
      WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
      WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
      WHEN p.price > 500000 THEN 0.30
    END AS persentase_gross_laba,

    -- Hitung harga setelah diskon
    (p.price * (1 - (t.discount_percentage / 100))) AS nett_sales,

    -- Hitung keuntungan (nett_profit)
    (p.price * (1 - (t.discount_percentage / 100))) * 
    CASE
      WHEN p.price <= 50000 THEN 0.10
      WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
      WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
      WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
      WHEN p.price > 500000 THEN 0.30
    END AS nett_profit,

    t.rating AS rating_transaksi

  FROM `rakaminkfanalytics-476414.kimia_farma.kf_final_transaction` t
  LEFT JOIN `rakaminkfanalytics-476414.kimia_farma.kf_inventory` i
    ON t.product_id = i.product_id AND t.branch_id = i.branch_id
  LEFT JOIN `rakaminkfanalytics-476414.kimia_farma.kf_kantor_cabang` c
    ON t.branch_id = c.branch_id
  LEFT JOIN `rakaminkfanalytics-476414.kimia_farma.kf_product` p
    ON t.product_id = p.product_id
)