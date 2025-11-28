SELECT slug, type as model
FROM products

UNION ALL

SELECT slug, 'Trail' as model
FROM trails

UNION ALL

SELECT slug, 'Topic' as model
FROM topics
