WITH yearly_sales AS (
    SELECT
        p.prod_subcategory,
        EXTRACT(YEAR FROM t.end_of_cal_year) AS sale_year,
        SUM(s.amount_sold) AS total_sales
    FROM
        sales s
    JOIN
        products p ON s.prod_id = p.prod_id
    JOIN
        times t ON s.time_id = t.time_id
    WHERE
        EXTRACT(YEAR FROM t.end_of_cal_year) BETWEEN 1998 AND 2001
    GROUP BY
        p.prod_subcategory, sale_year
),
previous_year_sales AS (
    SELECT
        p.prod_subcategory,
        EXTRACT(YEAR FROM t.end_of_cal_year) + 1 AS sale_year,
        SUM(s.amount_sold) AS total_sales
    FROM
        sales s
    JOIN
        products p ON s.prod_id = p.prod_id
    JOIN
        times t ON s.time_id = t.time_id
    WHERE
        EXTRACT(YEAR FROM t.end_of_cal_year) BETWEEN 1997 AND 2000
    GROUP BY
        p.prod_subcategory, sale_year
)
SELECT
    ys.prod_subcategory
FROM
    yearly_sales ys
JOIN
    previous_year_sales pys ON ys.prod_subcategory = pys.prod_subcategory AND ys.sale_year = pys.sale_year
WHERE
    ys.total_sales > pys.total_sales
GROUP BY
    ys.prod_subcategory
HAVING
    COUNT(*) = 4; -- Subcategories with consistently higher sales for 4 consecutive years (1998 to 2001)
