/*
Query 3: For each customer, product and state combination, compute (1) the product’s average
		sale of this customer for the state (i.e., the simple AVG for the group-by attributes –
		this is the easy part), (2) the average sale of the product and the state but for all of the
		other customers and (3) the customer’s average sale for the given state, but for all of
		the other products.
*/

-- step 1: create a base table by computing current avg for (cust, prod, state)
with base as (
	select cust, prod, state, round(avg(quant), 0) as current_avg
	from sales
	group by cust, prod, state
	order by cust, prod
),
-- step 2: join output from base with sales to compute OTHER_PROD_AVG
t1 as (
	select b.cust, b.prod, b.state, round(avg(s.quant), 0) as other_prod_avg
	from base as b, sales as s 
	where b.cust = s.cust and b.state = s.state and b.prod != s.prod
	group by b.cust, b.prod, b.state
	order by b.cust, b.prod 
),
-- step 3: join output from base with sales to compute OTHER_CUST_AVG
t2 as (
	select b.cust, b.prod, b.state, round(avg(s.quant), 0) as other_cust_avg
	from base as b, sales as s 
	where b.cust != s.cust and b.state = s.state and b.prod = s.prod
	group by b.cust, b.prod, b.state
	order by b.cust, b.prod 
)
-- step 4: join output from base, t1 and t2
select cust, prod, state, base.current_avg as prod_avg, t2.other_cust_avg, t1.other_prod_avg 
from base natural join t1 natural join t2
order by cust, prod, state