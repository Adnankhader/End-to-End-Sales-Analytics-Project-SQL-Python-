-- Generate a Report that shows all key metrics of the business
create view sales_metrics as
select 
	'Total Revenue' as Measure, sum(total_revenue) as Measure_value from gold.fact_sales
union all 
select 
	'Total customers' , count(order_id)  from gold.fact_sales
union all

select 
	'Total Quantity' , sum(quantity)  from gold.fact_sales
union all 

select 
	'Total Profit' , sum(total_profit)  from gold.fact_sales
union all 
select 
	'Average Discount' , round(avg(discount_amount),2)  from gold.fact_sales
union all
select 
	'Average Order Value' ,round(sum(total_revenue)*1.0/ count(order_id),2)  from gold.fact_sales


