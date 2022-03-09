Select *
From [Portfolio Project ]..CovidDeaths
Where continent is not null
order by 3,4


--Select *
--From [Portfolio Project ]..CovidVaccinations
--order by 3,4


----Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population 
From [Portfolio Project ]..CovidDeaths
Where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project ]..CovidDeaths
Where location like '%states%'
and continent is not null
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population that got Covid

Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From [Portfolio Project ]..CovidDeaths
--Where location like '%states%'
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population 

Select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project ]..CovidDeaths
--Where location like '%states%'
Group by Location,population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population

---LET'S BREAK THINGS DOWN BY CONTINENT




--Showing continents with the highest death count per population

Select continent, MAX(cast (Total_deaths as int)) as TotalDeathCount
From [Portfolio Project ]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM
(New_Cases)*100 as DeathPercentage
From [Portfolio Project ]..CovidDeaths
where continent is not null
--Group By date
order by 1,2

-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as BIGINT)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) *100
From [Portfolio Project ]..CovidDeaths dea 
Join [Portfolio Project ]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3

	--USE CTE

	With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
	as
	(
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) *100
From [Portfolio Project ]..CovidDeaths dea 
Join [Portfolio Project ]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3 
	)
	
	Select *, (RollingPeopleVaccinated/Population)*100
	From PopvsVac

	--TEMP TABLE

	Create Table #PercentPopulationVaccinated
	(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)


	Insert into #PercentPopulationVaccinated
		Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) *100
From [Portfolio Project ]..CovidDeaths dea 
Join [Portfolio Project ]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null

	
	Select *, (RollingPeopleVaccinated/Population)*100
	From #PercentPopulationVaccinated

	--Creating view to store data for later visualizations
	
	Create View PercentPopulationVaccinated as
		Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) *100
From [Portfolio Project ]..CovidDeaths dea 
Join [Portfolio Project ]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
	--order by 2,3

	Select*
	From PercentPopulationVaccinated