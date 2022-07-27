-- Find Steps through the day
select cast(ActivityHour as time) as Time, avg(StepTotal) as StepsthroughDay
from HourlySteps
group by cast(ActivityHour as time)
order by cast(ActivityHour as time)