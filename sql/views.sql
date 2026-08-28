create view  vw_product_revenue as
with a as (
           select *, oi.quantity * (oi.unit_price * (1 - oi.discount_pct)) as line_revenue       
           from order_items oi 
           join orders o on o.order_id = oi.order_id
           where o.order_status in  ('Completed', 'Shipped')
)
select a.product_id, p.product_name, SUM(a.line_revenue) as revenue_by_product    
from a 
join products p on p.product_id = a.product_id 
group by a.product_id, p.product_name  
ORDER BY revenue_by_product desc;

create view vw_customer_revenue as
select o.customer_id ,c.full_name, ROUND(SUM(oi.quantity *(oi.unit_price *(1- oi.discount_pct ))), 2) as total 
from customers c 
join orders o on o.customer_id = c.customer_id 
join order_items oi on oi.order_id = o.order_id 
where o.order_status in ('Completed', 'Shipped')
group by c.full_name, o.customer_id   
order by total desc;

create view vw_orders_by_city as
select COUNT(o.order_id) as order_count, o.shipping_city  
from orders o 
where o.order_status in ('Completed', 'Shipped', 'Pending')
group by o.shipping_city
order by order_count desc;

create view vw_sales_by_channel as
select COUNT(o.order_id) as count_sales_platform, o.sales_channel 
from orders o 
where o.order_status not in ('Cancelled')
group by o.sales_channel 
order by count_sales_platform desc;

create view vw_most_ordered_products as
select oi.product_id, sum(oi.quantity) as quantity_count, p.product_name  
from order_items oi 
join products p on p.product_id = oi.product_id 
group by oi.product_id, p.product_name  
order by quantity_count desc;


create view vw_return_reason as
select COUNT(r.return_id ), r.return_reason 
from "returns" r
group by r.return_reason 


-- monthly sales_revenure
CREATE VIEW vw_monthly_revenue AS
select
    DATE_TRUNC('month', o.order_date) AS month,
    ROUND(SUM(oi.quantity *(oi.unit_price * (1 - oi.discount_pct))),2) as revenue
from orders o
join order_items oi on oi.order_id = o.order_id
where o.order_status IN ('Completed', 'Shipped', 'Pending')
group by DATE_TRUNC('month', o.order_date)
order by month;


create view vw_payment_method as
select COUNT(o.order_id) as count_pay_mthd, o.payment_method 
from orders o 
where o.order_status not in ('Cancelled')
group by o.payment_method 
order by count_pay_mthd desc
