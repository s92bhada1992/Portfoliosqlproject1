


--select * 
--from Portfolio..Covidvacination$
select * 
from Portfolio..Coviddeath$
where continent is not null


--select Location, date, total_cases, new_cases, total_deaths, population
--from Portfolio..Coviddeath$
--looking for total cases vs total deaths
-- showing likelihood of dying if you are contract covid in your country

Select location, date, total_cases, total_deaths,(total_deaths/Nullif(total_cases,0))*100 as deathpercent 
from Portfolio..Coviddeath$
where location='China' and 
 continent is not null
order by 1,2

-- looking for total cases vs total population
--shows what %age of population got covid

Select location, date, total_cases, population,(total_cases/ population)*100 as casepercent 
from Portfolio..Coviddeath$
where location='China' and 
continent is not null
order by 1,2

--looking countries with highest infection rate compared population 
Select Location, population ,max(total_cases) as highestinfectioncount, max((total_cases/ population))*100  as populationinfectedpercent 
from Portfolio..Coviddeath$
--where location='China'
where continent is not null
group by Location, population
order by highestinfectioncount  desc

--showing countries with highest death count per population

Select Location ,max(cast(total_deaths as int)) as highesdeathcount
--max((total_deaths/ population))*100  as deathpercent 
from Portfolio..Coviddeath$
--where location='China'
where continent is not null
group by Location, population
order by highesdeathcount  desc

-- let's break things doen by continent
--Showing continent with highest deaths

Select continent ,max(cast(total_deaths as int)) as highesdeathcount
--max((total_deaths/ population))*100  as deathpercent 
from Portfolio..Coviddeath$
--where location='China'
where continent is not null
group by continent
order by highesdeathcount  desc

-- GLobal Numbers

Select  date ,Sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(Nullif(new_cases,0))*100 as deathpercentage--total_deaths, (total_deaths/Nullif(total_cases,0))*100 as deathpercent
from Portfolio..Coviddeath$
--where location='China'
where continent is not null
Group by date
order by 1 ,2

Select  Sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(Nullif(new_cases,0))*100 as deathpercentage--total_deaths, (total_deaths/Nullif(total_cases,0))*100 as deathpercent
from Portfolio..Coviddeath$
--where location='China'
where continent is not null
--Group by date
order by 1 ,2

-- looking at total population vs vaccination 

Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from Portfolio..Coviddeath$ dea
join Portfolio..Covidvacination$ vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 order by 2,3
  --use of CTE
with popvac ( conitinent, location,  date, population, new_vaccinations, rollingpeoplevaccinated)

as
(
 Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from Portfolio..Coviddeath$ dea
join Portfolio..Covidvacination$ vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 --group by dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
 
 )
 Select * ,(rollingpeoplevaccinated/population)*100
 From popvac
 --, (rollingpeoplevaccinated/population)*100


 --Temp Table
 Drop table if exists  #percenatgepopulationvaccinated
 Create table #percenatgepopulationvaccinated(
 Continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 rollingpeoplevaccinated numeric
 )

 Insert  #percenatgepopulationvaccinated
 
 Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from Portfolio..Coviddeath$ dea
join Portfolio..Covidvacination$ vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 --group by dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
 
 
 Select * ,(rollingpeoplevaccinated/population)*100
 From #percenatgepopulationvaccinated
 --, (rollingpeoplevaccinated/population)*100

 -- Create View

 Create view percentpopulationvaccinated as 
 Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from Portfolio..Coviddeath$ dea
join Portfolio..Covidvacination$ vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 --group by dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
 

Select * from percentpopulationvaccinated