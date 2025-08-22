/*
Query 2: For customer and product, show the average sales before, during and after each
		quarter (e.g., for Q2, show average sales of Q1 and Q3. For “before” Q1 and “after”
		Q4, display <NULL>. The “YEAR” attribute is not considered for this query – for
		example, both Q1 of 2007 and Q1 of 2008 are considered Q1 regardless of the year.

*/ 

-- step 1: create an extended sales table by adding "quarter" to the sales table 

with ext_sales as (
	select cust, prod, month, ceiling(month/3.0) as qtr, quant
	from sales 
	order by cust, prod, month 
),
-- step 2: create a base table for avgs for (cust,prod,quarter)
t2 as (
	select cust, prod, qtr, round(avg(quant), 0) as during_average 
	from ext_sales 
	group by cust, prod, qtr 
	order by cust, prod, qtr 
),
-- step 3: join 2 copies of base table to compute avg for BEFORE quarters 
t3 as (
	select t.cust, t.prod, t.qtr, t2.during_average as before_average 
	from t2 as t 
	full outer join t2 
	on t2.cust = t.cust and t2.prod = t.prod and t2.qtr = t.qtr - 1
	order by t.cust, t.prod, t.qtr 
),
-- step 4: join 2 copies of base table to compute avg for AFTER quarters 
t4 as (
	select t.cust, t.prod, t.qtr, t2.during_average as after_average 
	from t2 as t 
	full outer join t2 
	on t2.cust = t.cust and t2.prod = t.prod and t2.qtr = t.qtr + 1
	order by t.cust, t.prod, t.qtr  
)
-- step 5: join outputs with BEFORE_AVG, AFTER_AVG and DURING_AVG
select * 
from t3 natural join t2 natural join t4
order by cust, prod,  qtr


