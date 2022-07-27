-- Categorize users by number of day of use
select id, count(id) as days_used,
 case
    when count(id) between 25 and 31 then 'High use'
    when COUNT(id) between 15 and 24 then 'Moderate use'
    when COUNT(id) between 1 and 14 then 'Low use'
    else 'Unknown'
 end as Usage
from DailyActivity
group by id

