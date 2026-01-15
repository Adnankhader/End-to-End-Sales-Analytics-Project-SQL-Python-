-- Magnitude Analysis

-- Total Customers by year

select
	order_year,
	count(*) as number_of_customers
from gold.dim_date
group by order_year

-- Total Customers by month

select
	order_month,
	count(*) as number_of_customers
from gold.dim_date
group by order_month,order_month_number
order by order_month_number


-- Sales over a time period
select
	order_year,
	order_month,
	round(sum(total_revenue),2) total_revenue,
	count(order_id) number_of_orders
from gold.fact_sales s
left join gold.dim_date d
on d.date_key=s.date_key
group by d.order_year,d.order_month_number,d.order_month
order by order_year, order_month_number

-- Cumulative Analysis (running sales)

with sum_revenue as (
    select
        d.order_year,
        d.order_month,
        d.order_month_number,
        sum(s.total_revenue) as revenue
    from gold.fact_sales s
    join gold.dim_date d
        on d.date_key = s.date_key
    group by
        d.order_year,
        d.order_month,
        d.order_month_number
)
select
    order_year,
    order_month,
    sum(revenue) over (
        order by order_year, order_month_number
    ) as running_revenue
from sum_revenue
order by order_year, order_month_number;



-- Performance Analysis ( Month-over-Month)

select
	order_year,
	order_month_number,
	order_month,
	round(sum(total_revenue),2) current_sales,
	lag(round(sum(total_revenue),2)) over(order by order_year,order_month_number) prev_month_sales,
	round(sum(total_revenue),2)-lag(round(sum(total_revenue),2)) over(order by order_year,order_month_number) sales_diff,
	(round(sum(total_revenue),2)-lag(round(sum(total_revenue),2)) over(order by order_year,order_month_number))*100
	/lag(round(sum(total_revenue),2)) over(order by order_year,order_month_number) mom_change,
	case
		when round(sum(total_revenue),2)-lag(round(sum(total_revenue),2)) over(order by order_year,order_month_number) > 0 then 'Sales Increment'
		when round(sum(total_revenue),2)-lag(round(sum(total_revenue),2)) over(order by order_year,order_month_number) <0 then 'Sales Decrement'
		else 'No Change'
    end 
from gold.fact_sales s
left join gold.dim_date d
on d.date_key=s.date_key
group by d.order_year,d.order_month_number,d.order_month
order by order_year, order_month_number


-- Number of products in each sub category
select
	category,
	sub_category,
	count(*)
from gold.dim_products
group by category, sub_category
order by category

-- revenue and profit of each category
select
	p.category,
	sum(s.total_revenue) total_revenue,
	sum(s.total_profit) total_profit,
	count(s.order_id) number_of_orders
from gold.fact_sales s
left join gold.dim_products p
on p.product_key=s.product_key
group by p.category

-- Average cost price, list price,average_profit, total_revenue,total_profit for each sub-category
select
	p.category,
	p.sub_category,
	avg(p.cost_price) average_cost_price,
	avg(p.list_price) average_list_price,
	round(avg(s.total_profit),2) average_profit,
	round(sum(s.total_revenue),2) total_revenue,
	round(sum(s.total_profit),2) total_profit,
	case
		when round(avg(s.total_profit),2) < 20 then 'low profit segment'
		when round(avg(s.total_profit),2) < 80 then 'medium profit segment'
		else 'high profit segment'
	end Categorising_segments
from gold.fact_sales as s
left join gold.dim_products as p
on s.product_key=p.product_key
group by category, sub_category
order by category


-- Number of profitable and non profitable orders
select
	profit_loss_flag,
	count(*) number_of_orders
from gold.fact_sales
group by profit_loss_flag

-- profit by region

select
    l.region,
    sum(f.total_profit) as profit
from gold.fact_sales f
join gold.dim_location l
    on f.location_key = l.location_key
group by l.region
order by profit desc;