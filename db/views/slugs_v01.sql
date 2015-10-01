SELECT slug, type as model
FROM products

UNION ALL

SELECT slug, 'Trail' as model
FROM trails
