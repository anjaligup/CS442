/*
	For each customer, find the “most favorite” product (the product that the customer
	purchased the most) and the “least favorite” product (the product that the customer
	purchased the least).

	Question: can there me multiple least_fav_prod, similarly can there be multiple most_fav_prod ?? 
*/


-- first, we want to find the max(fav) and min(least fav) quantities with corresponding customer name
with q1 as (
	select cust, max(quant) most_quant, min(quant) min_quant
	from sales
	group by cust 
), -- now we want to grab the corresponding product name for most  
q2 as (
	select distinct s.prod most_fav_prod, q1.cust, q1.most_quant
	from q1, sales s 
	where q1.cust = s.cust and q1.most_quant = s.quant
	order by q1.cust
), -- now we want to grab the corresponding product name for min 
q3 as (
	select distinct s.prod least_fav_prod, q1.cust, q1.min_quant
	from q1, sales s 
	where q1.cust = s.cust and q1.min_quant = s.quant
	order by q1.cust
)
-- combine both queries and order them according to assignment query 
select cust, q2.most_fav_prod, q3.least_fav_prod
from q2 natural join q3
order by cust 
