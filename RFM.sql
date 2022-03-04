CREATE OR REPLACE table `analytics-bootcamp-2-340509.tbcase.Q3_RFM_VALUES`  as 
(
    
with a as
(
    SELECT user_id,
    avg(total_amount) average_amount,
    (select sum(average) from ((select avg(total_amount) average FROM `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
group by user_id))) sum_total_amount,
    avg(total_amount)/(select sum(average) from ((select avg(total_amount) average FROM `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
group by user_id)))  ratio
    FROM `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`

    group by user_id
    order by 2 desc
),
b as (
    select 
    user_id,
    average_amount,
    ratio,
    SUM(ratio) OVER(order by ratio desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as Percentage
    from a 
),
c as (
    select 
    user_id,
    average_amount,
    ROUND(Percentage,3),
    case 
    when Percentage BETWEEN 0 AND 0.2 then 1 
    when Percentage BETWEEN 0.2 AND 0.4 then 2 
    when Percentage BETWEEN 0.4 AND 0.6 then 3 
    when Percentage BETWEEN 0.6 AND 0.8 then 4 
    when Percentage BETWEEN 0.8 AND 1 then 5 else 6 end M
    from b order by Percentage 
),


-- table_view_M as 
-- (    select 1 as M,(select Count(M) from c where c.M=1) as Sayi, Round((select Count(M) from c where c.M=1)/(select Count(M) from c),2) as  Yuzde
--     UNION ALL
--     select 2 as M,(select Count(M) from c where c.M=2) as Sayi, round((select Count(M) from c where c.M=2)/(select Count(M) from c),2 ) as Yuzde
--     UNION ALL
--     select 3 as M,(select Count(M) from c where c.M=3) as Sayi ,round((select Count(M) from c where c.M=3)/(select Count(M) from c),2) as Yuzde
--     UNION ALL
--     select 4 as M,(select Count(M) from c where c.M=4) as Sayi, round((select Count(M) from c where c.M=4)/(select Count(M) from c),2) as Yuzde
--     UNION ALL
--     select 5 as M,(select Count(M) from c where c.M=5) as Sayi, round((select Count(M) from c where c.M=5)/(select Count(M) from c),2) as Yuzde
-- )
--Select* from table_view_M order by 1

--select M,count(M) from c group by M;

--RECENCY
 d as
(  
    select 
    distinct user_id,
    last_order_date,
    DATE_DIFF(last_order_date,(select min(order_date) min_order_date from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
),day) as recency,
    (select sum(recencyy) from (select distinct user_id, DATE_DIFF(last_order_date,(select min(order_date) min_order_date from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
),day) as recencyy from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
) ) total_recency,
    DATE_DIFF(last_order_date,(select min(order_date) min_order_date from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
),day)/(select sum(recencyy) from (select distinct user_id, DATE_DIFF(last_order_date,(select min(order_date) min_order_date from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
),day) as recencyy from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
) ) as ratio
    from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
  
    order by 3 desc
),
e as 
(
    select 
    user_id,
    last_order_date,
    recency,
    total_recency,
    ratio,
    SUM(ratio) OVER(order by ratio desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as Percentage
    from d
),
f as (
    select 
    user_id,
    last_order_date,
    ROUND(Percentage,3),
    case 
    when Percentage BETWEEN 0 AND 0.2 then 1 
    when Percentage BETWEEN 0.2 AND 0.4 then 2 
    when Percentage BETWEEN 0.4 AND 0.6 then 3 
    when Percentage BETWEEN 0.6 AND 0.8 then 4 
    when Percentage BETWEEN 0.8 AND 1 then 5 else 6 end R
    from e order by Percentage 
),



-- table_view_R as 
-- (    select 1 as R,(select Count(R) from f where f.R=1) as Sayi, Round((select Count(R) from f where f.R=1)/(select Count(R) from f),2) as  Yuzde
--     UNION ALL
--     select 2 as R,(select Count(R) from f where f.R=2) as Sayi, round((select Count(R) from f where f.R=2)/(select Count(R) from f),2 ) as Yuzde
--     UNION ALL
--     select 3 as R,(select Count(R) from f where f.R=3) as Sayi, round((select Count(R) from f where f.R=3)/(select Count(R) from f),2) as Yuzde
--     UNION ALL
--     select 4 as R,(select Count(R) from f where f.R=4) as Sayi, round((select Count(R) from f where f.R=4)/(select Count(R) from f),2) as Yuzde
--     UNION ALL
--     select 5 as R,(select Count(R) from f where f.R=5) as Sayi, round((select Count(R) from f where f.R=5)/(select Count(R) from f),2) as Yuzde
-- )
-- Select* from table_view_R order by 1

--select R,count(R) from f group by 1 order by 2;

--FREQUENCY

alltime as (
    select 
    distinct user_id,
    count(distinct(extract(date from order_date))) as alltime_Cargo,
    count(distinct(extract(date from order_date)))/(select DATE_DIFF( max(order_date), min(order_date), DAY) from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
) as alltime_freq,
    ROUND(count(distinct(extract(date from order_date)))/(select DATE_DIFF( max(order_date), min(order_date), DAY) from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
),3) as alltime_freq_rounded
    from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`

    where 
    DATE_DIFF( (select max(order_date) from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
),(order_date), DAY)<=(select DATE_DIFF( max(order_date), min(order_date), DAY) from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
)
    group by user_id
    order by 3 desc,2 desc
),
g as
(
    select 
    distinct user_id,alltime_Cargo,alltime.alltime_freq as overall_freq
    from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
 gwc 
    left join alltime using(user_id)
    order by 3 desc,2 desc
),
x as(
    select user_id,
    alltime_Cargo,
    overall_freq,
    overall_freq/(select sum(overall_freq) from g) ratio
    from g
),
h as(

    select 
    user_id,
    alltime_Cargo,
    ratio,
    SUM(ratio) OVER(order by ratio desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as Percentage
    from x
),
i as (
    select 
    user_id,
    alltime_Cargo,
    ROUND(Percentage,3),
    case 
    when Percentage BETWEEN 0 AND 0.2 then 1 
    when Percentage BETWEEN 0.2 AND 0.4 then 2 
    when Percentage BETWEEN 0.4 AND 0.6 then 3 
    when Percentage BETWEEN 0.6 AND 0.8 then 4 
    when Percentage BETWEEN 0.8 AND 1 then 5 else 6 end F
    from h order by Percentage 
)
-- table_view_F as 
-- (    select 1 as F,(select Count(F) from i where i.F=1) as Sayi, Round((select Count(F) from i where i.F=1)/(select Count(F) from i),2) as  Yuzde
--     UNION ALL
--     select 2 as F,(select Count(F) from i where i.F=2) as Sayi, round((select Count(F) from i where i.F=2)/(select Count(F) from i),2 ) as Yuzde
--     UNION ALL
--     select 3 as F,(select Count(F) from i where i.F=3) as Sayi, round((select Count(F) from i where i.F=3)/(select Count(F) from i),2) as Yuzde
--     UNION ALL
--     select 4 as F,(select Count(F) from i where i.F=4) as Sayi, round((select Count(F) from i where i.F=4)/(select Count(F) from i),2) as Yuzde
--     UNION ALL
--     select 5 as F,(select Count(F) from i where i.F=5) as Sayi, round((select Count(F) from i where i.F=5)/(select Count(F) from i),2) as Yuzde
-- )


-- select distinct user_id,i.F as F  from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
 
-- left join i using(user_id)

-- select distinct user_id,f.R as R,i.F as F,c.M as M  from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
 
-- left join f using(user_id)
-- left join i using(user_id)
-- left join c using(user_id);



select distinct user_id,f.R as R,i.F as F,c.M as M  from `analytics-bootcamp-2-340509.tbcase.Q3_gecmis_data_with_users_corona`
 
left join f using(user_id)
left join i using(user_id)
left join c using(user_id));