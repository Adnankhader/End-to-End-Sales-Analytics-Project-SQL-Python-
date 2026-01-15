-- Ranking Analysis

-- ranking categories based on total_revenue
select
	rank() over(order by sum(s.total_revenue)) rank,
	p.category,
	sum(s.total_revenue) total_revenue
from gold.fact_sales s
left join gold.dim_products p
on p.product_key=s.product_key
group by p.category

-- Ranking subcategories within categories based on total_revenue
select
	rank() over(partition by category order by sum(s.total_revenue) desc) rank,
	p.category,
	p.sub_category,
	sum(s.total_revenue) total_revenue
from gold.fact_sales s
left join gold.dim_products p
on p.product_key=s.product_key
group by p.category,p.sub_category
