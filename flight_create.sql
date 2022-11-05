use master
go

create database flight
go

use flight
go

/****************
* CREATE SCHEMA *
****************/

create schema ref;
go

create table dbo.Airport (
	AirportId int identity not null
	,AirportCode varchar(5) not null
	,AirportName varchar(255) not null
	,Terminals int
	,City varchar(255) not null
	,[State] varchar(2) not null
);
go

create table ref.CrewRank (
	CrewRankId int identity not null
	,CrewRankName varchar(255) not null
);
go


create table dbo.Crew (
	CrewId int identity not null
	,CrewRankId int
	,FirstName varchar(255)
	,LastName varchar(255)
	,IsActive bit default 0 not null
);
go

create table ref.Model (
	ModelId int identity not null
	,ModelSerial varchar(50) not null
	,ModelName varchar(255) not null
);
go

create table dbo.Airplane (
	AirplaneId int identity not null
	,Serial uniqueidentifier not null
	,ModelId int
);
go

create table dbo.[Route] (
	RouteId int identity not null
	,OriginAirportId int not null
	,DestinationAirportId int not null
	,IsActive bit default 0 not null
);
go

create table dbo.Flight (
	FlightId int identity not null
	,RouteId int
	,AirplaneId int
	,TakeoffLocal datetime2
	,LandingLocal datetime2
);
go

create table ref.CrewType (
	CrewTypeId int identity not null
	,CrewTypeName varchar(255) not null
);
go

create table dbo.FlightCrew (
	FlightCrewId int identity not null
	,FlightId int
	,CrewId int
	,CrewTypeId int
);
go

/***********************
* CREATE RELATIONSHIPS *
***********************/

alter table dbo.Airport
	add constraint pk_Airport_AirportId primary key clustered (AirportId);
go

alter table dbo.Airport
	add constraint uq_Airport_AirportCode unique (AirportCode);
go

alter table ref.CrewRank
	add constraint pk_CrewRank_CrewRankId primary key clustered (CrewRankId);
go

alter table ref.CrewRank
	add constraint uq_CrewRank_RankName unique (CrewRankName);
go

alter table dbo.Crew
	add constraint pk_Crew_CrewId primary key clustered (CrewId);
go

alter table dbo.Crew
	add constraint fk_Crew_CrewRankId foreign key (CrewRankId)
	references ref.CrewRank (CrewRankId)
	on delete set null
	on update cascade;
go

alter table ref.Model
	add constraint pk_Model_ModelId primary key clustered (ModelId);
go

alter table ref.Model
	add constraint uq_Model_ModelSerial unique (ModelSerial);
go

alter table ref.Model
	add constraint uq_Model_ModelName unique (ModelName);
go

alter table dbo.Airplane
	add constraint pk_Airplane_AirplaneId primary key clustered (AirplaneId);
go

alter table dbo.Airplane
	add constraint uq_Airplane_Serial unique (Serial);
go

alter table dbo.Airplane
	add constraint fk_Airplane_ModelId foreign key (ModelId)
	references ref.Model (ModelId)
	on delete set null
	on update cascade;
go

alter table dbo.[Route]
	add constraint pk_Route_RouteId primary key clustered (RouteId);
go

alter table dbo.[Route]
	add constraint uq_Route_NoDupRoutes unique (OriginAirportId,DestinationAirportId);
go

alter table dbo.[Route]
	add constraint fk_Route_OriginAirportId foreign key (OriginAirportId)
	references dbo.Airport (AirportId)
	on delete no action
	on update no action;
go

alter table dbo.[Route]
	add constraint fk_Route_DestinationAirportId foreign key (DestinationAirportId)
	references dbo.Airport (AirportId)
	on delete no action
	on update no action;
go

alter table dbo.Flight
	add constraint pk_Flight_FlightId primary key clustered (FlightId);
go

alter table dbo.Flight
	add constraint uq_Flight_Traffic unique (RouteId,TakeoffLocal,LandingLocal);
go

alter table dbo.Flight
	add constraint fk_Flight_RouteId foreign key (RouteId)
	references dbo.[Route] (RouteId)
	on delete set null
	on update cascade;
go

alter table dbo.Flight
	add constraint fk_Flight_AirplaneId foreign key (AirplaneId)
	references dbo.Airplane (AirplaneId)
	on delete set null
	on update cascade;
go

alter table ref.CrewType
	add constraint pk_CrewType_CrewTypeId primary key clustered (CrewTypeId);
go

alter table ref.CrewType
	add constraint uq_CrewType_CrewTypeName unique (CrewTypeName);
go

alter table dbo.FlightCrew
	add constraint pk_FlightCrew_FlightCrewId primary key clustered (FlightCrewId);
go

alter table dbo.FlightCrew
	add constraint uq_FlightCrew_FlightCrewType unique (FlightId,CrewTypeId);
go

alter table dbo.FlightCrew
	add constraint fk_FlightCrew_FlightId foreign key (FlightId)
	references dbo.Flight (FlightId)
	on delete set null
	on update cascade;
go

alter table dbo.FlightCrew
	add constraint fk_FlightCrew_CrewId foreign key (CrewId)
	references dbo.Crew (CrewId)
	on delete set null
	on update cascade;
go

alter table dbo.FlightCrew
	add constraint fk_FlightCrew_CrewTypeId foreign key (CrewTypeId)
	references ref.CrewType (CrewTypeId)
	on delete set null
	on update cascade;
go

/***************
* CREATE VIEWS *
***************/

create schema rpt;
go

create or alter view rpt.vwCrew as

select
	c.CrewId
	,cr.CrewRankName CrewRank
	,c.FirstName
	,c.LastName
	,c.IsActive
from dbo.Crew c
left join ref.CrewRank cr
	on cr.CrewRankId=c.CrewRankId;
go

create or alter view rpt.vwAirplane as

select
	a.AirplaneId
	,a.Serial
	,m.ModelName Model
from dbo.Airplane a
left join ref.Model m
	on m.ModelId=a.ModelId;
go

create or alter view rpt.vwFlight as

select
	f.FlightId
	,o.AirportCode OriginAirportCode
	,d.AirportCode DestinationAirportCode
	,max(iif(ct.CrewTypeName='Captain',concat(c.LastName,', ',c.FirstName),null)) Captain
	,max(iif(ct.CrewTypeName='Copilot',concat(c.LastName,', ',c.FirstName),null)) Copilot
	,max(iif(ct.CrewTypeName='Engineer',concat(c.LastName,', ',c.FirstName),null)) Engineer
	,a.Serial AirplaneSerial
	,f.TakeoffLocal
	,f.LandingLocal
	,r.IsActive RouteIsActive
from dbo.Flight f
join dbo.[Route] r
	on r.RouteId=f.RouteId
join dbo.Airport o
	on o.AirportId=r.OriginAirportId
join dbo.Airport d
	on d.AirportId=r.DestinationAirportId
join dbo.Airplane a
	on a.AirplaneId=f.AirplaneId
left join dbo.FlightCrew fc
	on fc.FlightId=f.FlightId
left join ref.CrewType ct
	on ct.CrewTypeId=fc.CrewTypeId
left join dbo.Crew c
	on c.CrewId=fc.CrewId
group by
	f.FlightId
	,o.AirportCode
	,d.AirportCode
	,r.IsActive
	,a.Serial
	,f.TakeoffLocal
	,f.LandingLocal;
go
