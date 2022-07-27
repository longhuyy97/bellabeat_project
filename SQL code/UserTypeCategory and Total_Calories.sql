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



