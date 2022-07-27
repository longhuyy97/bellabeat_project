-- Find daily steps by WeekDay
select DATENAME(WEEKDAY,[Date]) WeekDay, round(avg(cast(StepTotal as float)),4) as 'Daily Steps'
from DailySteps
group by DATENAME(WEEKDAY,[Date]);

