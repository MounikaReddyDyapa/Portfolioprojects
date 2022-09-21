Select *
From PortfolioProject..[coviddeaths]
order by 3,4

Select *
From PortfolioProject..[covidvaccinations]
order by 3,4


-- Select Data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..[coviddeaths]
order by 1,2

-- Looking at total cases vs total deaths
--shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
From PortfolioProject..[coviddeaths]
where location like '%india%'
where continent is not null
order by 1,2

--Looking at the total cases vs population
-- shows what percentage  of population got covid
Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..[coviddeaths]
--where location like '%india%'
where continent is not null
order by 1,2

--Looking at countries with Highest Infection Rate compared to population

Select Location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..[coviddeaths]
--where location like '%india%'
where continent is not null
Group by Location, population
order by PercentPopulationInfected desc


--Showing Countries with Highest death count per population

select Location, Max(cast(total_deaths as int)) as Totaldeathcount
From  PortfolioProject..[coviddeaths]
--where location like '%india%'
where continent is not null
Group by Location, population
order by Totaldeathcount desc

-- Let's break things down by continent

select continent, Max(cast(total_deaths as int)) as Totaldeathcount
From  PortfolioProject..[coviddeaths]
--where location like '%india%'
where continent is not null
Group by continent
order by Totaldeathcount desc

-- showing continents with highest death counts per population

select continent, Max(cast(total_deaths as int)) as Totaldeathcount
From  PortfolioProject..[coviddeaths]
--where location like '%india%'
where continent is not null
Group by continent
order by Totaldeathcount desc


-- Global Numbers

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..[coviddeaths]
--where location like '%india%'
where continent is not null
-- group by date
order by 1,2

-- Global Numbers by date

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..[coviddeaths]
--where location like '%india%'
where continent is not null
group by date
order by 1,2

--WORKING ON COVID VACCINATION DATA

-- looking at total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location, dea.date) as Rollingpeoplevaccinated
From PortfolioProject..[coviddeaths] dea
join PortfolioProject..[covidvaccinations] vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Order by 2, 3


--USE CTE

With PopvsVac (continent, location, date, population, new_vaccinations, Rollingpeoplevaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location, dea.date) as Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
From PortfolioProject..[coviddeaths] dea
join PortfolioProject..[covidvaccinations] vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- order by 2, 3
)
select *, (Rollingpeoplevaccinated/population)*100 
from PopvsVac


--Temp Table
Drop table if exists  #Percentpopulationvaccinated
Create Table #Percentpopulationvaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
population numeric,
new_vaccinations numeric,
Rollingpeoplevaccinated numeric
)

Insert into #Percentpopulationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location, dea.date) as Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
From PortfolioProject..[coviddeaths] dea
join PortfolioProject..[covidvaccinations] vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- order by 2, 3

select *, (Rollingpeoplevaccinated/population)*100 
from #Percentpopulationvaccinated


-- creating view to store data for later visualisations

create view Percentpopvacc as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location, dea.date) as Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
From PortfolioProject..[coviddeaths] dea
join PortfolioProject..[covidvaccinations] vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- order by 2, 3

select * from Percentpopvacc











     



     










