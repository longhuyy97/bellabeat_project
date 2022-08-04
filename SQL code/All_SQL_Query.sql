
-- Categorize users by number of day of use
select id, count(id) as days_used,
 case
    when count(id) between 25 and 31 then 'High use'
    when COUNT(id) between 15 and 24 then 'Moderate use'
    when COUNT(id) between 1 and 14 then 'Low use'
    else 'Unknown'
 end as Usage
from DailyActivity
group by id;

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
from Percentage;

-- Categorize users into 4 categories by Active Minutes metric: VeryActive, FairlyActive, LightlyActive, Sedentary
;with AVG_comp as (
	select 
		round(AVG(cast(VeryActiveMinutes as float)),4) as VeryActive, 
		round(AVG(cast(FairlyActiveMinutes as float)),4) as FairlyActive, 
		round(AVG(cast(LightlyActiveMinutes as float)),4) as LightlyActive, 
		round(AVG(cast(SedentaryMinutes as float)),4) as Sedentary
	from DailyActivity)

select ID, Tab_Temp.Calories1 as Calories,
	case
		when Tab_Temp.Very > AVG_comp.VeryActive
			then 'Very'

		when Tab_Temp.Fairly > AVG_comp.FairlyActive 
			then 'Fairly'
			
		when Tab_Temp.Lightly > AVG_comp.LightlyActive
			then 'Lightly'

		when Tab_Temp.Sedentary > AVG_comp.Sedentary 
			then 'Sendentary'
		else 'Unknown'  
		end as UserType
from (
		select id, 
			round(AVG(cast(VeryActiveMinutes as float)),4) as Very, 
			round(AVG(cast(FairlyActiveMinutes as float)),4) as Fairly , 
			round(AVG(cast(LightlyActiveMinutes as float)),4) as Lightly, 
			round(AVG(cast(SedentaryMinutes as float)),4) as Sedentary, 
			round(AVG(cast(Calories as float)),4) as Calories1
		from DailyActivity
		group by id ) as Tab_Temp, AVG_comp;

-- Calculate the total user in each category
;with AVG_comp as (
	select 
		round(AVG(cast(VeryActiveMinutes as float)),4) as VeryActive, 
		round(AVG(cast(FairlyActiveMinutes as float)),4) as FairlyActive, 
		round(AVG(cast(LightlyActiveMinutes as float)),4) as LightlyActive, 
		round(AVG(cast(SedentaryMinutes as float)),4) as Sedentary
	from DailyActivity)

select Tab_Temp2.UserType as UserType, count(id) as TotalUser, round(avg(Tab_Temp2.Calories2),4) as Calories
from(
		select id, Tab_Temp.Calories1 as Calories2,
			case
				when Tab_Temp.Very > AVG_comp.VeryActive then 'Very'
				when Tab_Temp.Fairly > AVG_comp.FairlyActive then 'Fairly'
				when Tab_Temp.Lightly > AVG_comp.LightlyActive then 'Lightly'
				when Tab_Temp.Sedentary > AVG_comp.Sedentary then 'Sendentary'
				else 'Unknown'  
			end as UserType
		from (
				select id, 
					round(AVG(cast(VeryActiveMinutes as float)),4) as Very, 
					round(AVG(cast(FairlyActiveMinutes as float)),4) as Fairly , 
					round(AVG(cast(LightlyActiveMinutes as float)),4) as Lightly, 
					round(AVG(cast(SedentaryMinutes as float)),4) as Sedentary, 
					round(AVG(cast(Calories as float)),4) as Calories1
				from DailyActivity
				group by id
			  ) as Tab_Temp, AVG_comp
	) as Tab_Temp2

group by Tab_Temp2.UserType
order by Calories desc;

-- Find daily steps by WeekDay
select DATENAME(WEEKDAY,[Date]) WeekDay, round(avg(cast(StepTotal as float)),4) as 'Daily Steps'
from DailySteps
group by DATENAME(WEEKDAY,[Date]);

-- Find Steps through the day
select cast(ActivityHour as time) as Time, avg(StepTotal) as StepsthroughDay
from HourlySteps
group by cast(ActivityHour as time)
order by cast(ActivityHour as time)

-- Find hours for sleep by WeekDay
SELECT DATENAME(WEEKDAY,[Date]) as WeekDay, round(avg(cast(TotalMinutesAsleep as float))/60,4) as Hours
from SleepDate
GROUP BY DATENAME(WEEKDAY,[Date])





