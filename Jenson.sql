#1. Find the total number of products sold by each store along with the store name.
select stores.store_id , sum(order_items.quantity), stores.store_name
from stores left join orders using(store_id) inner join order_items using(order_id) 
group by stores.store_id, stores.store_name; # with rollup shows sub totals with grand totals it is the best way to check the final ans
#select sum(order_items.quantity) from order_items(check the final answer after roll up with this query)

#2. Calculate the cumulative sum of quantities sold for each product over time.
select  orders.order_date, products.product_id, products.product_name, order_items.quantity,
sum(order_items.quantity) over(partition by products.product_id order by orders.order_date) as cumulative_sum
from products left join order_items using(product_id) inner join orders using(order_id);

#3. Find the product with the highest total sales (quantity * price) for each category.
select category_id, category_name, product_id, product_name, total_sales
from (select c.category_id, c.category_name, p.product_id, p.product_name, sum(oi.quantity * oi.list_price) as total_sales,
row_number() over (partition by c.category_id order by sum(oi.quantity * oi.list_price) desc) as rn
from products p join categories c on p.category_id = c.category_id join order_items oi on p.product_id = oi.product_id
group by c.category_id, c.category_name, p.product_id, p.product_name
) x
where rn = 1;

#4. Find the customer who spent the most money on orders.
select c.customer_id, c.first_name, c.last_name, sum(oi.quantity * oi.list_price) as total_sales 
from customers c join orders o on c.customer_id = o.customer_id join order_items oi on o.order_id = oi.order_id 
group by c.customer_id, c.first_name, c.last_name order by total_sales desc limit 1;

#5. Find the highest-priced product for each category name.
with ranked_products as (select c.category_id, c.category_name, p.product_name, p.list_price,
row_number() over (partition by c.category_id order by p.list_price desc) as rn
from categories c join products p on c.category_id = p.category_id)
select category_id, category_name, product_name, list_price from ranked_products where rn = 1;

#6. Find the total number of orders placed by each customer per store.
select c.customer_id, c.first_name, c.last_name, s.store_id, s.store_name, count(o.order_id) as total_orders
from customers c join orders o on c.customer_id = o.customer_id join stores s on o.store_id = s.store_id
group by c.customer_id, c.first_name, c.last_name, s.store_id, s.store_name order by c.customer_id, s.store_id;

#7. Find the names of staff members who have not made any sales.
select s.staff_id, s.first_name, s.last_name, o.order_id 
from staffs s left join orders o using(staff_id) where o.order_id is null;

#8. Find the top 3 most sold products in terms of quantity.
select p.product_name, sum(oi.quantity) as total_sales 
from products p join order_items oi on p.product_id = oi.product_id
group by p.product_name order by total_sales desc limit 3;

#9. Find the median value of the price list. 
with a as(select list_price, row_number() over(order by list_price) as rn, count(*) over() as n from products)
select 
	case 
		when n%2 = 0 then (select avg(list_price) from a where rn in ((n/2), (n/2)+1))
        else (select list_price from a where rn = (n+1)/2)
	end as median 
from a 
limit 1;

#10. List all products that have never been ordered.(use Exists)
select p.product_name, p.product_id
from products p
where not exists (select oi.order_id from order_items oi where oi.product_id = p.product_id); #p.product_id here refers to the p.product_id from outer query for making them correlated 

#11. List the names of staff members who have made more sales than the average number of sales by all staff members.
with staff_sales as (select s.staff_id, concat(s.first_name,'', s.last_name) as full_name, coalesce(sum(oi.quantity * oi.list_price),0) as total_sales 
from staffs s left join orders o using(staff_id) left join order_items oi using(order_id) 
group by s.staff_id, s.first_name, s.last_name)
select * from staff_sales where total_sales > (select avg(total_sales) from staff_sales);

#12. Identify the customers who have ordered all types of products (i.e., from every category).
select c.customer_id, concat(c.first_name, c.last_name) as full_name, count(p.category_id) as product_count_per_category
from customers c join orders o using(customer_id) join order_items oi using(order_id) join products p using(product_id)
group by c.customer_id
having count(distinct p.category_id) = (select count(category_id) from categories)


