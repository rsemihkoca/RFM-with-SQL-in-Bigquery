
With f as(
    SELECT * FROM `analytics-bootcamp-2-340509.tbcase.Q3_RFM_VALUES`
),
 i as(
    SELECT * FROM `analytics-bootcamp-2-340509.tbcase.Q3_RFM_VALUES`
),
 c as(
    SELECT * FROM `analytics-bootcamp-2-340509.tbcase.Q3_RFM_VALUES`
),

table_view_R as 
(    select 1 as R,(select Count(R) from f where f.R=1) as Sayi, Round((select Count(R) from f where f.R=1)/(select Count(R) from f),2) as  Yuzde
    UNION ALL
    select 2 as R,(select Count(R) from f where f.R=2) as Sayi, round((select Count(R) from f where f.R=2)/(select Count(R) from f),2 ) as Yuzde
    UNION ALL
    select 3 as R,(select Count(R) from f where f.R=3) as Sayi, round((select Count(R) from f where f.R=3)/(select Count(R) from f),2) as Yuzde
    UNION ALL
    select 4 as R,(select Count(R) from f where f.R=4) as Sayi, round((select Count(R) from f where f.R=4)/(select Count(R) from f),2) as Yuzde
    UNION ALL
    select 5 as R,(select Count(R) from f where f.R=5) as Sayi, round((select Count(R) from f where f.R=5)/(select Count(R) from f),2) as Yuzde
),

table_view_F as 
(    select 1 as F,(select Count(F) from i where i.F=1) as Sayi, Round((select Count(F) from i where i.F=1)/(select Count(F) from i),2) as  Yuzde
    UNION ALL
    select 2 as F,(select Count(F) from i where i.F=2) as Sayi, round((select Count(F) from i where i.F=2)/(select Count(F) from i),2 ) as Yuzde
    UNION ALL
    select 3 as F,(select Count(F) from i where i.F=3) as Sayi, round((select Count(F) from i where i.F=3)/(select Count(F) from i),2) as Yuzde
    UNION ALL
    select 4 as F,(select Count(F) from i where i.F=4) as Sayi, round((select Count(F) from i where i.F=4)/(select Count(F) from i),2) as Yuzde
    UNION ALL
    select 5 as F,(select Count(F) from i where i.F=5) as Sayi, round((select Count(F) from i where i.F=5)/(select Count(F) from i),2) as Yuzde
),

table_view_M as 
(    select 1 as M,(select Count(M) from c where c.M=1) as Sayi, Round((select Count(M) from c where c.M=1)/(select Count(M) from c),2) as  Yuzde
    UNION ALL
    select 2 as M,(select Count(M) from c where c.M=2) as Sayi, round((select Count(M) from c where c.M=2)/(select Count(M) from c),2 ) as Yuzde
    UNION ALL
    select 3 as M,(select Count(M) from c where c.M=3) as Sayi ,round((select Count(M) from c where c.M=3)/(select Count(M) from c),2) as Yuzde
    UNION ALL
    select 4 as M,(select Count(M) from c where c.M=4) as Sayi, round((select Count(M) from c where c.M=4)/(select Count(M) from c),2) as Yuzde
    UNION ALL
    select 5 as M,(select Count(M) from c where c.M=5) as Sayi, round((select Count(M) from c where c.M=5)/(select Count(M) from c),2) as Yuzde
)


select * from table_view_R
JOIN table_view_F ON table_view_F.F= table_view_R.R 
JOIN table_view_M ON table_view_R.R=table_view_M.M 

order by table_view_R.R;