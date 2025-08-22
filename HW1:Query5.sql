/*
	For each product, output the maximum sales quantities for each quarter in 4 separate
	columns. Like the first report, display the corresponding dates (i.e., dates of those
	corresponding maximum sales quantities). Ignore the YEAR component of the dates (i.e.,
	10/25/2016 is considered the same date as 10/25/2017, etc.).

	Note: are we assuming months (1-3) are first quarter month (4-6) are second quarter etc ? 
	 --> double check with Prof Kim in class 
*/
with q1 as ( -- first get the q1_max (first three months of the year)
	select prod, max(quant) q1_max
	from sales
	where month = 1 or month = 2 or month = 3 
	group by prod  
	order by prod 
),
q2 as ( -- next get q1_max (next three months)
	select prod, max(quant) q2_max 
	from sales
	where month = 4 or month = 5 or month = 6 
	group by prod
	order by prod
),
q3 as ( -- next get q3_max (next three months)
	select prod, max(quant) q3_max
	from sales
	where month = 7 or month = 8 or month = 9 
	group by prod
	order by prod
),
q4 as ( -- finally, get q4_max (last three months)
	select prod, max(quant) q4_max
	from sales
	where month = 10 or month = 11 or month = 12 
	group by prod  
	order by prod
),
q5 as (  -- combine all quarter max values together into one intermediate table (this is mainly for testing purposes; to make sure I did up until this point right)
	select q1.prod, q1.q1_max, q2.q2_max, q3.q3_max, q4.q4_max
	from q1
	join q2 on q1.prod = q2.prod
	join q3 on q1.prod = q3.prod
	join q4 on q1.prod = q4.prod 
	order by q1.prod 
),
q6 as ( -- extract q1_max date 
	select q5.prod, q5.q1_max, s.date q1_date
	from sales s 
	join q5 on s.quant = q5.q1_max and s.prod = q5.prod
	where s.month = 1 or s.month = 2 or s.month = 3
	order by prod
),
q7 as ( -- extract q2_max date 
	select q5.prod, q5.q2_max, s.date q2_date
	from sales s 
	join q5 on s.quant = q5.q2_max and s.prod = q5.prod
	where s.month = 4 or s.month = 5 or s.month = 6
	order by prod
),
q8 as ( -- extract q3_max date 
	select q5.prod, q5.q3_max, s.date q3_date 
	from sales s 
	join q5 on s.quant = q5.q3_max and s.prod = q5.prod
	where s.month = 7 or s.month = 8 or s.month = 9
	order by prod
),
q9 as (  -- extract q4_max date 
	select q5.prod, q5.q4_max, s.date q4_date 
	from sales s 
	join q5 on s.quant = q5.q4_max and s.prod = q5.prod
	where s.month = 10 or s.month = 11 or s.month = 12
	order by prod
)  -- combine everything together with quarterly maxes + dates 
select q6.prod, q6.q1_max, q6.q1_date,
	q7.q2_max, q7.q2_date,
	q8.q3_max, q8.q3_date,
	q9.q4_max, q9.q4_date
from q6
join q7 on q6.prod = q7.prod
join q8 on q6.prod = q8.prod
join q9 on q6.prod = q9.prod 
order by q6.prod 

