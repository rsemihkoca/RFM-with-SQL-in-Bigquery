-- create table `analytics-bootcamp-2-340509.tbcase.Q2_Data` as
-- (

--     select *
--     from  `analytics-bootcamp-2-340509.tbcase.transaction` as t
--     join  `analytics-bootcamp-2-340509.tbcase.users` as u using (user_id)
--     where order_date < '2020-09-01 00:00:00' and Platform = 'Grocery' order by order_date asc -- 1 Eylül 2020
-- )


--    MIN ORDER DATE 2020-06-10 06:58:10.735 10 HAZİRANDAN 
--    MAX ORDER DATE 2020-08-31 23:53:29.197 1 EYLULE KADAR

--Orders per week
with main as 
(
    select 
    extract(week from order_date) as week_of_year
    ,count(distinct user_id) as Active_User
    ,count(distinct order_parent_id) Number_of_Orders
    ,round(sum(total_amount),2) as total_amount_per_week
    ,round(sum(total_amount)/ count(distinct user_id),2) as amount_per_active_user
    ,round(count(distinct order_parent_id)/ count(distinct user_id),2) Orders_per_Active_User
    ,count(distinct SHIPMENT_DISTRICT_ID) as Number_of_Active_Districts

    from  `analytics-bootcamp-2-340509.tbcase.Q2_Data`
    group by 1 order by 1 
),


--haftalık yeni kullanıcı sayısı
--kullanıcının verdiği sipariş go'daki first order date'indeki haftayla eşleşiyorsa yeni kullanıcı oluyor
--Bu sayede Core'dan Go'ya geçenleri ve sadece Go kullanıp ilk siparişi verenleri haftalık bazda inceleyebiliyoruz.
new_users_calculation as 
(
    select week_of_year, count(distinct user_id) New_Users_Count

        from 
        (   
            select *
            ,extract(week from order_date) as week_of_year
            ,min(order_date) over(Partition by user_id) as go_first_order_date           -- Grocerydeki ilk sipariş tarihi kullanıcı bazınca çekildi
            ,extract(week from (min(order_date) over(Partition by user_id))) as go_first_order_week -- Grocerydeki ilk sipariş tarihinden haftayı çıkardık
            ,case extract(week from (min(order_date) over(Partition by user_id))) when extract(week from order_date) then 1 else 0 end as first_order_condition -- Grocerydeki ilk sipariş tarihi ilgili siparişin haftasına eşit mi kontrolü
            from  `analytics-bootcamp-2-340509.tbcase.transaction` as t
            left join  `analytics-bootcamp-2-340509.tbcase.users` as u using (user_id)
            where order_date < '2020-09-01 00:00:00' and Platform = 'Grocery'
              
        ) where first_order_condition = 1 group by week_of_year order by 1    
)

select *
,ROUND(new_users_calculation.New_Users_Count/main.Active_User,2) as New_User_Ratio 
from new_users_calculation JOIN main using(week_of_year) where week_of_year between 24 and 34 order by week_of_year;


--5. eklenene district (28. haftada katılan) 59 muş
with weeks_extracted_all as (
  select *
  ,extract(week from order_date) as week_of_year
  ,min(order_date) over(Partition by user_id) as go_first_order_date           -- Grocerydeki ilk sipariş tarihi kullanıcı bazınca çekildi
  ,extract(week from (min(order_date) over(Partition by user_id))) as go_first_order_week -- Grocerydeki ilk sipariş tarihinden haftayı çıkardık
  ,case extract(week from (min(order_date) over(Partition by user_id))) when extract(week from order_date) then 1 else 0 end as first_order_condition -- Grocerydeki ilk sipariş tarihi ilgili siparişin haftasına eşit mi kontrolü
  from  `analytics-bootcamp-2-340509.tbcase.Q2_Data`
  where order_date < '2020-09-01 00:00:00' and Platform = 'Grocery'
  )



select distinct SHIPMENT_DISTRICT_ID,week_of_year from weeks_extracted_all where week_of_year = 28;
--1. sorunun cevabı da bu olabilir diye düşünüyorum.
