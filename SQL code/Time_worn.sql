-- Categorize user into 3 categories: All day, More than half day, Less than half day
with Percentage as (SELECT id,
                    round(((cast(SedentaryMinutes as float) + 
                            cast(FairlyActiveMinutes as float) + 
                            cast(LightlyActiveMinutes as float) + 
                            cast(VeryActiveMinutes as float))/1440)*100,2) as Percentage_Minutes_worn
from DailyActivity)

select Id, Percentage_Minutes_worn,
    case
        when Percentage_Minutes_worn = 100 then 'All day'
        when Percentage_Minutes_worn < 100 and Percentage_Minutes_worn >= 50 then 'More than half day'
        when Percentage_Minutes_worn > 0 and Percentage_Minutes_worn < 50 then 'Less than half day'
        else 'Unknown'
    end as Worn
from Percentage