-- Find hours for sleep by WeekDay
SELECT DATENAME(WEEKDAY,[Date]) as WeekDay, round(avg(cast(TotalMinutesAsleep as float))/60,4) as Hours
from SleepDate
GROUP BY DATENAME(WEEKDAY,[Date])
