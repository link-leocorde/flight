use flight
go

/************
* LOAD DATA *
************/

declare @dt date = getdate();

insert into dbo.Airport (
	AirportCode
	,AirportName
	,Terminals
	,City
	,[State]
)

select
	AirportCode
	,AirportName
	,(abs(checksum(newid())) % 48)+12
	,City
	,[State]
from (values
	('ATL', 'Atlanta International Airport', 'Atlanta', 'GA')
	,('BOS', 'Boston Logan International Airport', 'Boston', 'MA')
	,('BWI', 'Baltimore/Washington International Airport', 'BWI Airport', 'MD')
	,('CLT', 'Charlotte/Douglas International Airport', 'Charlotte', 'NC')
	,('CVG', 'Cincinnati/Northern Kentucky International Airport', 'Cincinnati', 'OH')
	,('DCA', 'Ronald Reagan Washington National Airport', 'Washington', 'DC')
	,('DEN', 'Denver International Airport', 'Denver', 'CO')
	,('DFW', 'Dallas/Fort Worth International Airport', 'Dallas', 'TX')
	,('DTW', 'Detroit Metro Airport', 'Detroit', 'MI')
	,('EWR', 'Newark Liberty International Airport', 'Newark', 'NJ')
	,('FLL', 'Fort Lauderdale-Hollywood International Airport', 'Fort Lauderdale', 'FL')
	,('HNL', 'Honolulu International Airport', 'Honolulu', 'HI')
	,('IAD', 'Washington Dulles International Airport', 'Washington', 'DC')
	,('IAH', 'Bush Intercontinental Airport', 'Houston', 'TX')
	,('JFK', 'John F. Kennedy International Airport', 'New York', 'NY')
	,('LAS', 'McCarran International Airport', 'Las Vegas', 'NV')
	,('LAX', 'Los Angeles International Airport', 'Los Angeles', 'CA')
	,('LGA', 'La Guardia Airport', 'New York', 'NY')
	,('MCO', 'Orlando International Airport', 'Orlando', 'FL')
	,('MDW', 'Chicago Midway Airport', 'Chicago', 'IL')
	,('MIA', 'Miami International Airport', 'Miami', 'FL')
	,('MSP', 'MSP Airport', 'Minneapolis', 'MN')
	,('OAK', 'Oakland International Airport', 'Oakland', 'CA')
	,('ORD', 'Chicago O''Hare International Airport', 'Chicago', 'IL')
	,('PHL', 'Philadelphia International Airport', 'Philadelphia', 'PA')
	,('PHX', 'Phoenix Sky Harbor International Airport', 'Phoenix', 'AZ')
	,('PIT', 'Pittsburgh International Airport', 'Pittsburgh', 'PA')
	,('SAN', 'San Diego International Airport', 'San Diego', 'CA')
	,('SEA', 'Seattle/Tacoma International Airport', 'Seattle', 'WA')
	,('SFO', 'San Francisco International Airport', 'San Francisco', 'CA')
	,('SLC', 'Salt Lake City International Airport', 'Salt Lake City', 'UT')
	,('STL', 'St. Louis Lambert International Airport', 'Saint Louis', 'MO')
	,('TPA', 'Tampa International Airport', 'Tampa', 'FL')

) v(
	AirportCode
	,AirportName
	,City
	,[State]
);

insert into ref.CrewRank (CrewRankName) values
	('Captain'),('Copilot'),('Engineer');

insert into dbo.Crew (
	CrewRankId
	,FirstName
	,LastName
	,IsActive
)
select
	cr.CrewRankId
	,v.FirstName
	,v.LastName
	,v.IsActive
from (values
	('Captain', 'Julius', 'Hammond', 1)
	,('Captain', 'Hayden', 'Foxley', 0)
	,('Captain', 'Chris', 'Calderwood', 0)
	,('Captain', 'Martin', 'Glass', 1)
	,('Captain', 'Ilona', 'Bolton', 0)
	,('Copilot', 'Freya', 'Plumb', 1)
	,('Engineer', 'Boris', 'Brennan', 1)
	,('Captain', 'Marigold', 'Young', 1)
	,('Captain', 'Ruby', 'Thorpe', 1)
	,('Captain', 'Alice', 'Sherry', 1)
	,('Captain', 'Johnny', 'Mcgregor', 0)
	,('Captain', 'Roger', 'Dale', 1)
	,('Engineer', 'Abdul', 'Partridge', 1)
	,('Captain', 'Lucas', 'Shelton', 1)
	,('Captain', 'Benny', 'Phillips', 1)
	,('Captain', 'Mark', 'Knight', 1)
	,('Copilot', 'Morgan', 'Emerson', 1)
	,('Captain', 'Ryan', 'Graves', 1)
	,('Engineer', 'Alba', 'Abbot', 1)
	,('Captain', 'William', 'Chappell', 1)
	,('Captain', 'Valentina', 'Rodgers', 1)
	,('Captain', 'Summer', 'Holt', 1)
	,('Copilot', 'Nate', 'Andrews', 0)
	,('Captain', 'Logan', 'Stanton', 1)
	,('Copilot', 'Clint', 'Edwards', 1)
	,('Captain', 'Karla', 'Nanton', 1)
	,('Captain', 'Julius', 'Poulton', 1)
	,('Engineer', 'Margaret', 'Weston', 1)
	,('Copilot', 'Melanie', 'Yates', 0)
	,('Copilot', 'Michaela', 'Jacobs', 1)
	,('Copilot', 'Marvin', 'Reese', 1)
	,('Captain', 'Julianna', 'Tobin', 0)
	,('Captain', 'Alba', 'Goldsmith', 1)
	,('Copilot', 'Hazel', 'Jarrett', 1)
	,('Copilot', 'Mason', 'Jenkins', 0)
	,('Copilot', 'Carla', 'Power', 1)
	,('Captain', 'Noah', 'Oliver', 1)
	,('Captain', 'Dakota', 'Cox', 1)
	,('Captain', 'Kurt', 'Shields', 1)
	,('Copilot', 'Rosalie', 'Walsh', 1)
	,('Captain', 'Destiny', 'Griffiths', 1)
	,('Copilot', 'Miriam', 'Todd', 1)
) v(
	CrewRankName
	,FirstName
	,LastName
	,IsActive
)
join ref.CrewRank cr
	on cr.CrewRankName=v.CrewRankName;

insert into ref.Model (ModelSerial,ModelName) values
	('#FF00FF', 'Coral Puma')
	,('#9e0806', 'Orange Tapir')
	,('#2d2212', 'Fuchsia Langur')
	,('#FFFF00', 'Camel Komodo')
	,('#00FF00', 'Aquamarine Wallaby')
	,('#0000FF', 'Cadet Blue Bear')
	,('#7FFFD4', 'Blue Deer')
	,('#4286f4', 'Magenta Wombat')
	,('#493c0b', 'Sky Blue Pelican')
	,('#733ea8', 'Rosegold Kongoni')
	,('#144187', 'Magenta Falcon')
	,('#7d8ca3', 'Aqua JellyFish')
	,('#b2aea7', 'Gray Gull');

declare @md int = (select max(ModelId) from ref.Model);

with planes as (
	select 1 n
	union all
	select n+1
	from planes
	where n<42
)
insert into dbo.Airplane (
	Serial
	,ModelId
)
select
	newid()
	,(abs(checksum(newid())) % @md)+1
from planes;

insert into dbo.[Route] (
	OriginAirportId
	,DestinationAirportId
)
select
	o.AirportId
	,d.AirportId
from dbo.Airport o
cross join dbo.Airport d
where d.AirportId<>o.AirportId;

with active_routes as (
	select top 20 percent
		(select min(id) from (values (OriginAirportId),(DestinationAirportId)) v(id)) id_one
		,(select max(id) from (values (OriginAirportId),(DestinationAirportId)) v(id)) id_two
	from dbo.[Route]
)

update r
set IsActive=1
from dbo.[Route] r
join active_routes a
	on r.OriginAirportId in (a.id_one,a.id_two)
	and r.DestinationAirportId in (a.id_one,a.id_two);

declare @rt int = (select max(RouteId) from dbo.[Route]);
declare @ap int = (select max(AirplaneId) from dbo.Airplane);

with flights as (
	select 1 n
	union all
	select n+1
	from flights
	where n<1200
)
,flight_data (RouteId,AirplaneId,TakeoffLocal) as (
	select
		(abs(checksum(newid())) % @rt)+1
		,(abs(checksum(newid())) % @ap)+1
		,dateadd(hh,(abs(checksum(newid())) % 24),cast(cast(dateadd(d,-(abs(checksum(newid())) % 1000)+250,getdate()) as date) as datetime2))
	from flights
)
insert into dbo.Flight (
	RouteId
	,AirplaneId
	,TakeoffLocal
)
select
	fd.RouteId
	,fd.AirplaneId
	,fd.TakeoffLocal
from flight_data fd
join dbo.[Route] r
	on r.RouteId=fd.RouteId
	and r.IsActive=1
option (maxrecursion 5000);

update dbo.Flight
set LandingLocal=dateadd(hh,(abs(checksum(newid())) % 15)+2,TakeoffLocal);

insert into ref.CrewType (CrewTypeName)
select distinct CrewRankName
from ref.CrewRank;

declare @crew_type table (CrewId int, CrewRankId int, rw int);
insert into @crew_type (CrewId, CrewRankId, rw)
select
	CrewId
	,CrewRankId
	,row_number() over (
		partition by CrewRankId
		order by CrewId asc
	) rw
from dbo.Crew;

declare @captain_rw int = (
	select max(rw)
	from @crew_type ct
	join ref.CrewRank cr
		on cr.CrewRankId=ct.CrewRankId
		and cr.CrewRankName='Captain'
);

declare @copilot_rw int = (
	select max(rw)
	from @crew_type ct
	join ref.CrewRank cr
		on cr.CrewRankId=ct.CrewRankId
		and cr.CrewRankName='Copilot'
);

declare @engineer_rw int = (
	select max(rw)
	from @crew_type ct
	join ref.CrewRank cr
		on cr.CrewRankId=ct.CrewRankId
		and cr.CrewRankName='Engineer'
);

declare @flight_crew table (FlightId int, CaptainId int, CopilotId int, EngineerId int);

with flight_crew as (
	select
		FlightId
		,(abs(checksum(newid())) % @captain_rw)+1 Captain
		,(abs(checksum(newid())) % @copilot_rw)+1 Copilot
		,case
			when ((abs(checksum(newid())) % 10)+1)>6 then (abs(checksum(newid())) % @engineer_rw)+1
			else null
		end Engineer
	from dbo.Flight
)
insert into @flight_crew (FlightId, CaptainId, CopilotId, EngineerId)
select
	fc.FlightId
	,cap.CrewId
	,cop.CrewId
	,eng.CrewId
from flight_crew fc
left join @crew_type cap
	on cap.rw=fc.Captain
	and cap.CrewRankId=(select CrewRankId from ref.CrewRank where CrewRankName='Captain')
left join @crew_type cop
	on cop.rw=fc.Copilot
	and cop.CrewRankId=(select CrewRankId from ref.CrewRank where CrewRankName='Copilot')
left join @crew_type eng
	on eng.rw=fc.Engineer
	and eng.CrewRankId=(select CrewRankId from ref.CrewRank where CrewRankName='Engineer')
;

insert into dbo.FlightCrew (
	FlightId
	,CrewId
	,CrewTypeId
)
select
	fc.FlightId
	,c.CrewId
	,ct.CrewTypeId
from @flight_crew fc
join dbo.Crew c
	on c.CrewId=fc.CaptainId
join ref.CrewRank cr
	on cr.CrewRankId=c.CrewRankId
join ref.CrewType ct
	on ct.CrewTypeName=cr.CrewRankName
where fc.CaptainId is not null

	union all

select
	fc.FlightId
	,c.CrewId
	,ct.CrewTypeId
from @flight_crew fc
join dbo.Crew c
	on c.CrewId=fc.CopilotId
join ref.CrewRank cr
	on cr.CrewRankId=c.CrewRankId
join ref.CrewType ct
	on ct.CrewTypeName=cr.CrewRankName
where fc.CopilotId is not null

	union all

select
	fc.FlightId
	,c.CrewId
	,ct.CrewTypeId
from @flight_crew fc
join dbo.Crew c
	on c.CrewId=fc.EngineerId
join ref.CrewRank cr
	on cr.CrewRankId=c.CrewRankId
join ref.CrewType ct
	on ct.CrewTypeName=cr.CrewRankName
where fc.EngineerId is not null
order by 1,2
;
go
