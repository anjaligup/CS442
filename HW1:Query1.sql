-- HW 1/Query 1

/*
Query 1: 
For each customer, compute the minimum and maximum sales quantities along with the
corresponding products (purchased), dates (i.e., dates of those minimum and maximum
sales quantities) and the states in which the sale transactions took place. If there are >1
occurrences of the min or max, display all.

For the same customer, compute the average sales quantity.

Thought process - use nested subqueries 
1. First get the min, max and avg quantities from sales 
2. Use first query in the first nested subquery to retrieve all minq products with their corresponding date and state 
3. Use fist nested subquery to then merge first nested subquery and retrieve all max_q products with their cooresponding date and state

*/ 
-- this section returns customers w/ their min, max and avg quant purchased
with agg as (
	select cust, min(quant) minq, max(quant) maxq, round(avg(quant), 0) avgq
	from sales 
	group by cust
),
-- get the cooresponding products, dates and states for min quantities
min1 as (
	select agg.cust, s.prod, s.date, s.state, agg.minq, agg.maxq, agg.avgq
	from agg, sales s 
	where agg.cust = s.cust and agg.minq = s.quant
),
max1 as (
	select min1.cust, min1.minq min_q, min1.prod min_prod, min1.date min_date, min1.state min_state, 
	min1.maxq max_q, s.prod max_prod, s.date max_date, s.state max_state, min1.avgq avg_q
	from min1, sales s 
	where min1.cust = s.cust and min1.maxq = s.quant
)
select * from max1
