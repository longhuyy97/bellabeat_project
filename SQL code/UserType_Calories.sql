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
			and Tab_Temp.Fairly < AVG_comp.FairlyActive
			and Tab_Temp.Lightly < AVG_comp.LightlyActive
			and Tab_Temp.Sedentary < AVG_comp.Sedentary
			then 'Very'

		when Tab_Temp.Fairly > AVG_comp.FairlyActive 
			and Tab_Temp.Very < AVG_comp.VeryActive
			and Tab_Temp.Lightly < AVG_comp.LightlyActive
			and Tab_Temp.Sedentary < AVG_comp.Sedentary
			then 'Fairly'
			
		when Tab_Temp.Lightly > AVG_comp.LightlyActive
			and Tab_Temp.Very < AVG_comp.VeryActive
			and Tab_Temp.Fairly < AVG_comp.FairlyActive
			and Tab_Temp.Sedentary < AVG_comp.Sedentary
			then 'Lightly'

		when Tab_Temp.Sedentary > AVG_comp.Sedentary 
			and Tab_Temp.Very < AVG_comp.VeryActive
			and  Tab_Temp.Fairly < AVG_comp.FairlyActive
			and Tab_Temp.Lightly < AVG_comp.LightlyActive
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
		group by id ) as Tab_Temp, AVG_comp




