/*
Query 2:

For each year and month combination, find the “busiest” and the “slowest” day (those
days with the most and the least total sales quantities of products sold) and the
corresponding total sales quantities (i.e., SUMs).
*/

-- HW1/Query 2 

-- First generate an intermediate table with sums of quantities for each day with corresponding month and year 
with q1 as (
	select day, month, year, sum(quant) sum_i
	from sales 
	group by day, month, year
	order by month, year, day
),
	-- select the minimum + maximum sums of each month/year combination 
q2 as (
	select min(q1.sum_i) min_quant, max(q1.sum_i) max_quant, q1.month, q1.year  
	from q1
	group by month, year
	order by month, year
), -- now we must select the days that correspond with the min sums
q3 as (
	select distinct q1.month, q1.year, q1.day busy_day, q2.max_quant 
	from q1
	join q2 on q1.month = q2.month and q1.year = q2.year  -- need to use join to distinctly match year and month instead of cartesian product 
	where q1.sum_i = q2.max_quant
	order by year 
), -- select the days that correspond with the max sums 
q4 as (
	select distinct q1.month, q1.year, q1.day slow_day, q2.min_quant
	from q1
	join q2 on q1.month = q2.month and q1.year = q2.year -- need to use join to distinctly match year and month instead of cartesian product 
	where q1.sum_i = q2.min_quant
	order by year 
)
-- join both queries together with natural join 
select  q4.year, q4.month, q3.busy_day, max_quant, q4.slow_day, min_quant
from q3 natural join q4 



