-- Creating Dimension and Fact Tables

-- Date Dimensions

if object_id('gold.dim_date', 'V') is not null
    drop view gold.dim_date;
go

create view gold.dim_date as
select
    row_number() over(order by order_date) as date_key,
    order_date,
    order_day,
    order_month_number,
    order_month,
    order_year
from (
    select distinct
        order_date,
        order_day,
        order_month_number,
        order_month,
        order_year
    from bronze.orders
) d;
go


-- Product Dimensions

if object_id('gold.dim_products', 'V') is not null
    drop view gold.dim_products;
go

create view gold.dim_products as
select
    row_number() over(order by product_id) as product_key,
    product_id,
    category,
    sub_category,
    cost_price,
    list_price
from (
    select distinct
        product_id,
        category,
        sub_category,
        cost_price,
        list_price
    from bronze.orders
) p;
go


-- Location Dimensions
if object_id('gold.dim_location', 'V') is not null
    drop view gold.dim_location;
go

create view gold.dim_location as
select
    row_number() over(
        order by country, region, state, city, postal_code
    ) as location_key,
    country,
    region,
    state,
    city,
    postal_code
from (
    select distinct
        country,
        region,
        state,
        city,
        postal_code
    from bronze.orders
) l;
go


-- Shipping Dimentsion
if object_id('gold.dim_ship_mode', 'V') is not null
    drop view gold.dim_ship_mode;
go

create view gold.dim_ship_mode as
select
    row_number() over(order by ship_mode) as ship_mode_key,
    ship_mode
from (
    select distinct ship_mode
    from bronze.orders
) s;
go

-- Segment Dimension

if object_id('gold.dim_segment', 'V') is not null
    drop view gold.dim_segment;
go

create view gold.dim_segment as
select
    row_number() over(order by segment) as segment_key,
    segment
from (
    select distinct segment
    from bronze.orders
) g;
go

-- Sales Fact

if object_id('gold.fact_sales', 'V') is not null
    drop view gold.fact_sales;
go

create view gold.fact_sales as
select
    o.order_id,
    d.date_key,
    p.product_key,
    l.location_key,
    sm.ship_mode_key,
    sg.segment_key,
    o.quantity,
    o.selling_price,
    o.discount_amount,
    o.total_revenue,
    o.total_profit,
    o.profit_loss_flag,
    o.order_value_bucket
from bronze.orders o
left join gold.dim_date d
    on o.order_date = d.order_date
left join gold.dim_products p
    on o.product_id = p.product_id
left join gold.dim_location l
    on o.country = l.country
   and o.region  = l.region
   and o.state   = l.state
   and o.city    = l.city
   and o.postal_code = l.postal_code
left join gold.dim_ship_mode sm
    on o.ship_mode = sm.ship_mode
left join gold.dim_segment sg
    on o.segment = sg.segment;
go




