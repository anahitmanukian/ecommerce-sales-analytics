SELECT 'customers' AS table_name, COUNT(*) FROM public.customers
UNION ALL
SELECT 'products', COUNT(*) FROM public.products
UNION ALL
SELECT 'orders', COUNT(*) FROM public.orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM public.order_items
UNION ALL
SELECT 'returns', COUNT(*) FROM public.returns;

-- How many items got ordered
select SUM(oi.quantity)
from order_items oi 
join orders o on o.order_id = oi.order_id 
where o.order_status not in ('Cancelled')

-- Which city has the most customers
select COUNT(c.customer_id) as city_count, c.city 
from customers c  
group by c.city
order by city_count desc

-- Order Status stats
select count(o.order_status), o.order_status 
from orders o 
group by o.order_status 

-- Order count
select count(distinct o.order_id)
from orders o 
where o.order_status not in ('Cancelled')

-- Payment method stats
select COUNT(o.order_id) as count_pay_mthd, o.payment_method 
from orders o 
where o.order_status not in ('Cancelled')
group by o.payment_method 
order by count_pay_mthd desc

-- Sales platform stats
select COUNT(o.order_id) as count_sales_platform, o.sales_channel 
from orders o 
group by o.sales_channel 
order by count_sales_platform desc

-- Average shipping fee by city
select ROUND(AVG(o.shipping_fee), 2) as avg_shipping_fee_by_city, o.shipping_city 
from orders o 
group by o.shipping_city 
order by avg_shipping_fee_by_city desc


-- 
select oi.product_id, sum(oi.quantity) as quantity_count, p.product_name  
from order_items oi 
join products p on p.product_id = oi.product_id 
group by oi.product_id, p.product_name  
order by quantity_count desc

-- Return reasons stats
select COUNT(r.return_id) as count_reason, r.return_reason    
from returns r 
group by r.return_reason 
order by count_reason desc


with a as (
select *, oi.quantity * (oi.unit_price * (1 - oi.discount_pct)) as line_revenue
from order_items oi 
)
select a.product_id, p.product_name, SUM(a.line_revenue) as revenue_by_product    
from a 
join products p on p.product_id = a.product_id 
group by a.product_id, p.product_name  
ORDER BY revenue_by_product desc
limit 10


-- Customers with the most orders
select o.customer_id, COUNT(order_id) as orders_count, c.full_name 
from customers c 
join orders o on o.customer_id = c.customer_id 
group by o.customer_id, c.full_name 
order by orders_count desc
limit 10

-- Customers who spent the most money
select c.full_name, ROUND(SUM(oi.quantity *(oi.unit_price *(1- oi.discount_pct ))), 2) as total 
from customers c 
join orders o on o.customer_id = c.customer_id 
join order_items oi on oi.order_id = o.order_id 
where o.order_status = 'Completed'
group by c.full_name, o.customer_id   
order by total desc 
limit 10

select * 
from customers c 
left join orders o on o.customer_id = c.customer_id 
where o.order_id is null

-- Category-level return analysis cannot be reliably calculated 
-- because returns are recorded at the order level rather than the order-item level.

select r.return_id , r.return_reason 
from orders o 
join "returns" r on r.order_id = o.order_id 
where o.order_status in ('Pending', 'Shipped')


select r.order_id, COUNT(r.return_id ) as row_count
from "returns" r
group by r.order_id 
having COUNT(r.return_id ) > 1


select COUNT(distinct r.return_id), COUNT(distinct o.order_id)
from orders o
left join returns r on o.order_id = r.order_id
where o.order_status in ('Completed','Pending', 'Shipped')