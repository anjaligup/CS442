/*
Query 1: For each product and month, count the number of sales transactions that were
		between the previous and the following month's average sales quantities. For
		January and December, you can display <NULL> or 0; alternatively, you can skip
		those months (those that do not have averages for the previous and/or following
		months).
*/ 

-- create a reference table by computing the avg(quant) for (current_month - 1) and (current_month + 1)

with t1 as (
	-- first compute the averages for each prod/month combination 
	select prod, month, round(avg(quant), 0) as avg_quant  
	from sales
	group by prod, month
	order by prod, month
),
t2 as (
	-- display prev_avg
	-- join it with itself, use where condition (month - 1 = month)
	select t.prod, t.month, t1.avg_quant as prev_avg
	from t1 as t
	left join t1
	on t.prod = t1.prod and t1.month = t.month - 1
	order by t.prod, t.month	
),
t3 as (
	-- display next_avg
	select t.prod, t.month, t1.avg_quant as next_avg
	from t1 as t
	left join t1
	on t.prod = t1.prod and t1.month = t.month + 1
	order by t.prod, t.month
),
t4 as (
	-- join both prev_avg and next_avg together 
	select t2.prod as product, t2.month as month_a, t2.prev_avg, t3.next_avg
	from t2 natural join t3 
	where t2.prod = t3.prod and t2.month = t3.month
	order by t2.prod, t2.month 
)

-- create a another table that displays months with 0, left outer join with query below 
select s.prod, s.month, count(s.quant) as sales_count_btw_avgs
from sales s, t4 as r 
where s.prod = r.product 
and s.month = r.month_a 
and ((s.quant between r.prev_avg and r.next_avg) or (s.quant between r.next_avg and r.prev_avg))
group by s.prod, s.month
order by s.prod, s.month 

