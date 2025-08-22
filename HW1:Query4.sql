/*
	For each customer and product combination, show the average sales quantities for the
	four seasons, Spring, Summer, Fall and Winter in four separate columns – Spring being
	the 3 months of March, April and May; and Summer the next 3 months (June, July and
	August); and so on – ignore the YEAR component of the dates (i.e., 10/25/2016 is
	considered the same date as 10/25/2017, etc.). Additionally, compute the average for the
	“whole” year (again ignoring the YEAR component, meaning simply compute AVG) along
	with the total quantities (SUM) and the counts (COUNT).
*/
-- Spring = March, April, May 
-- Summer = June, July August
-- Fall = September, October, November
-- Winter = December, January, February
with q1 as (  -- avg's for winter 
	select cust, prod, round(avg(quant), 0) winter_avg 
	from sales
	where month = 12 or month = 1 or month = 2
	group by cust, prod
	order by prod, cust 
),
q2 as (  -- avg's for spring 
	select cust, prod, round(avg(quant), 0) spring_avg  
	from sales
	where month = 3 or month = 4 or month = 5
	group by cust, prod
	order by prod, cust 
),
q3 as (  -- avg's for summer 
	select cust, prod, round(avg(quant), 0) summer_avg
	from sales
	where month = 6 or month = 7 or month = 8
	group by cust, prod
	order by prod, cust
),
q4 as (  -- avg's for fall 
	select cust, prod, round(avg(quant), 0) fall_avg
	from sales
	where month = 9 or month = 10 or month = 11
	group by cust, prod
	order by prod, cust
),
q5 as (  -- avg's for year?
	select cust, prod, round(avg(quant), 0) yr_avg, sum(quant) total, count(quant) count_
	from sales 
	group by cust, prod
	order by prod, cust 
)
select q1.cust, q1.prod, q2.spring_avg, q3.summer_avg, q4.fall_avg, q1.winter_avg, q5.yr_avg, q5.total, q5.count_
from q1
join q2 on q1.cust = q2.cust and q1.prod = q2.prod 
join q3 on q1.cust = q3.cust and q1.prod = q3.prod
join q4 on q1.cust = q4.cust and q1.prod = q4.prod
join q5 on q1.cust = q5.cust and q1.prod = q5.prod
order by q1.cust, q1.prod

