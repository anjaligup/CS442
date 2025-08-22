/*
Query 4: For each product, find the median sales quantity (assume an odd number of sales for
		simplicity of presentation). (NOTE – “median” is defined as “denoting or relating to a
		value or quantity lying at the midpoint of a frequency distribution of observed values or
		quantities, such that there is an equal probability of falling above or below it.” E.g.,
		Median value of the list {13, 23, 12, 16, 15, 9, 29} is 15


From OH's: 
-> first create table that computes the ordered position 
-> second, create a second table that generates median position 
->third, display distinct prod where ordered position matches with median position 
*/
with base  as (
	select prod, quant
	from sales 
	order by prod, quant
),
pos as (
	-- first compute ordered position 
	select b.prod, b.quant, count(s.quant) as order_pos 
	from base b, sales s
	where s.quant <= b.quant and b.prod = s.prod
	group by b.prod, b.quant
	order by b.prod, b.quant
),
median as (
	-- compute median pos
	select prod, ceiling(count(quant)/2) as val 
	from sales 
	group by prod
),
t3 as (
	-- order_pos that are greater than or equal to median's val
	select pos.prod, pos.order_pos
	from pos natural join median
	where pos.order_pos >= median.val
),
t4 as (
	-- select the minimum of previous 
	select prod, min(order_pos) as pos_1
	from t3
	group by prod
)
select distinct t4.prod as product, p.quant as median_quant
from pos as p 
join t4 on (p.prod = t4.prod and t4.pos_1 = p.order_pos)
order by t4.prod