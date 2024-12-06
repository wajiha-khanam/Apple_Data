-- Apple sales project

select * from category;
select * from products;
select * from stores;
select * from sales;
select * from warranty;


-- EDA

select distinct repair_status from warranty;
select count(*) from sales;


-- Improving query performance

-- ET: 230.00ms
-- PT: 0.186ms
-- after index ET: 5-10 ms
explain analyze
select * from sales
where product_id = 'P-44'

-- ET: 246.93ms
-- PT: 0.0.22ms
-- after index ET: 4ms
explain analyze
select * from sales
where store_id = 'ST-31'

create index sales_product_id on sales(product_id);
create index sales_store_id on sales(store_id);
create index sales_sale_date on sales(sale_date);



-- Business problems

-- 1. Find the number of stores in each country.
select country, count(store_id) as total_stores
from stores
group by 1
order by 2 desc;


-- 2. Calculate the total number of units sold by each store.
select s.store_id, st.store_name, sum(s.quantity) as total_units_sold
from sales s
join stores st on s.store_id = st.store_id
group by 1,2
order by 3 desc;


-- 3. Identify how many sales occured in DEcember 2023.
select count(sale_id) as total_sales
from sales
where to_char(sale_date, 'MM-YYYY') = '12-2023';


--4. Determine how many stores have never had a warranty claim filed.
select count(*) 
from stores
where store_id not in
(
		select distinct store_id
		from sales as s
		right join warranty as w on s.sale_id = w.sale_id
);


--5. Calculate the percentage of warranty claims marked as "Warranty void".
select round((count(claim_id)/(select count(*) from warranty)::numeric) * 100,2) as warranty_void_percentage
from warranty
where repair_status = 'Warranty Void';


--6. Identify which store had the highest total units sold in the last year.
select s.store_id, st.store_name, sum(s.quantity) as total_units_sold
from sales as s
join stores as st on s.store_id = st.store_id
where sale_date >= (current_date - interval '1 Year')
group by 1, 2
order by 3 desc 
limit 1;


--7. Count the number of unique products sold in the last year.
select count(distinct product_id) 
from sales
where sale_date >= (current_date - interval '1 Year');


-- 8. Find the average price of products in each category.
select p.category_id, c.category_name, avg(p.price) as avg_price
from products as p
join category as c on p.category_id = c.category_id
group by 1,2
order by 3 desc;


--9. How many warranty claims were filed in 2020.
select count(*) as warranty_claim
from warranty
where extract(year from claim_date) = 2020; 


-- 10. For each store, identify the best-selling day based on highest quantity sold.
select store_id, day_name as best_selling_day, total_units_sold
from
	(
		select store_id, to_char(sale_date, 'day') as day_name, sum(quantity) as total_units_sold, 
		rank() over(partition by store_id order by sum(quantity) desc) as rank
		from sales
		group by 1, 2
	) as t1
where rank = 1;


--11. Identify the least selling product in each country based on total units sold.
with cte as
(
	select st.country, p.product_name, sum(s.quantity) as total_qty_sold,
	rank() over(partition by st.country order by sum(s.quantity)) as rank
	from sales s
	join stores st on s.store_id = st.store_id
	join products p on s.product_id = p.product_id
	group by 1, 2
)
select country, product_name, total_qty_sold
from cte
where rank = 1;


--12. Calculate how many warranty claims were filed within 180 days of a product sale.
select count(*)
from warranty as w
left join sales as s on s.sale_id = w.sale_id
where w.claim_date - s.sale_date <= 180;


--13. Determine how many warranty claims were filed for products launched in the last two years.
select p.product_name, count(w.claim_id) as no_of_claim, count(s.sale_id) as no_of_sales
from warranty w 
right join sales s on w.sale_id = s.sale_id
join products p on p.product_id = s.product_id
where p.launch_date >= current_date - interval '2 years'
group by 1;


--14. List the months in the last three years where sales exceeded 5000 units in the USA.
select to_char(sale_date, 'MM-YYYY') as month, sum(s.quantity) as total_units_sold
from sales s 
join stores st on s.store_id = st.store_id
where st.country = 'USA' and s.sale_date >= current_date - interval '3 years'
group by 1
having sum(s.quantity) > 5000;


-- 15. Identify the product category with the most warranty claims filed in the last two years.
select c.category_name, count(w.claim_id) as total_claims
from warranty w
left join sales s on s.sale_id = w.sale_id
join products p on p.product_id = s.product_id
join category c on c.category_id = p.category_id
where w.claim_date >= current_date - interval '2 years'
group by 1
order by 2 desc;


-- 16. Determine the percentage chance of receiving warranty claims after each purchase for each country.
select  country, total_units_sold, total_claims, 
round(coalesce((total_claims::numeric/total_units_sold::numeric) * 100, 0),2) as risk
from
(
	select st.country, sum(s.quantity) as total_units_sold, count(w.claim_id) as total_claims
	from sales s
	join stores st on s.store_id = st.store_id
	left join warranty w on s.sale_id = w.sale_id
	group by 1
) t1
order by 4 desc;


--17. Analyze the year-by-year growth ratio for each store.
with cte as
(
	select s.store_id, st.store_name, extract(year from sale_date) as year, sum(s.quantity * p.price) as total_sale
	from sales s
	join products p on s.product_id = p.product_id
	join stores st on st.store_id = s.store_id
	group  by 1, 2, 3
	order by 2, 3
	),
cte2 as
(
select store_name, 
	year, 
	lag(total_sale, 1) over(partition by store_name order by year) as last_year_sale, 
	total_sale as current_year_sale 
from cte
)
select store_name, 
	year, 
	last_year_sale,
	current_year_sale,
	round((current_year_sale - last_year_sale)::numeric/last_year_sale::numeric * 100, 2) as growth_ratio
from cte2
where last_year_sale is not null and year <> extract(year from current_date);


--18. Calculate the correlation between product price and 
--warranty claims for products sold in the last five years , segmented by price range.
select 
case when p.price < 500 then 'Less Expensive'
	when p.price between 500 and 1000 then 'Mid range'
	else 'Expensive'  end as price_segment,
	count(w.claim_id) as total_claim
from warranty w 
left join sales s on w.sale_id = s.sale_id
join products p on p.product_id = s.product_id
where claim_date >= current_date - interval '5 Years'
group by 1;


--19. Identify the store with the highest percentage of "Paid Repaired" claims relative to total claims filed.
with cte1 as
(
	select s.store_id, count(w.claim_id) as paid_repaired
	from sales s
	right join warranty w on s.sale_id = w.sale_id
	where w.repair_status = 'Paid Repaired'
	group by 1
),
cte2 as
(
		select s.store_id, count(w.claim_id) as total_repaired
		from sales s
		right join warranty w on s.sale_id = w.sale_id
		group by 1
)
select a.store_id, st.store_name, a.paid_repaired, b.total_repaired, round((a.paid_repaired::numeric/b.total_repaired::numeric * 100),2) as percentage_paid_repaired
from cte1 a
join cte2 b on a.store_id = b.store_id
join stores st on st.store_id = b.store_id


--20. Write a query to calculate the monthly running total of sales for each store over the past four years 
-- and compare trends during this period.
with cte1 as 
(
select 
	store_id,
	extract(year from sale_date) as year, 
	extract(month from sale_date) as month,
	sum(p.price * s.quantity) as total_revenue
from sales s
join products p on s.product_id = s.product_id
group by 1, 2, 3
order by 1, 2, 3
)
select store_id, month, year, total_revenue, sum(total_revenue) over(partition by store_id order by year, month) as running_total
from cte1;


--21. Analyze product sales trends over time , 
-- segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months and beyond 18 months.
select 
	p.product_name,
	case when s.sale_date between p.launch_date and p.launch_date + interval '6 month' then '0 - 6 month'
	when s.sale_date between p.launch_date + interval '6 month' and p.launch_date + interval '12 month' then '6 - 12 month'
	when s.sale_date between p.launch_date + interval '12 month' and p.launch_date + interval '18 month' then '12 - 18 month'
	else '18+' end as plc,
	sum(s.quantity) as total_quantity_sale
from sales s
join products p on s.product_id = p.product_id
group by 1, 2
order by 1, 3 desc;







