USE PortfolioProject

SELECT *
FROM CovidDeaths
Where continent is not null
ORDER BY 3,4

SELECT * 
FROM CovidVaccinations
Order By 3,4

-- Select Data that we're going to be using 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
Where continent is not null
Order By 1,2

-- Looking at Total Cases vs. Total Deaths
--Shows the liklihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
Where location like '%states%'
and continent is not null
Order By 1,2

-- Looking at Total Cases vs. Population
--Shows percentage of population that contracted Covid

SELECT location, date, total_cases, population, (total_cases/population)*100 as CovidPopPercentage
FROM CovidDeaths
Order By 1,2

--Looking at countries with the highest infection rate compared to population 

SELECT location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as CovidPopPercentage
FROM CovidDeaths
GROUP BY location, population
Order By 4 desc

--Showing the countries with highest death count per population
--Use CAST function to change 'total_deaths' from nvarchar to int to order data correctly 
--United States is number 1

SELECT location, Max(CAST(total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
Where continent is not null
GROUP BY location
Order By 2 desc


--LET'S BREAK THINGS DOWNN BY CONTINENT/COUNTRY


--Showing Continents with highest death count 

SELECT continent, Max(CAST(total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
Where continent is not null
GROUP BY continent
Order By 2 desc


--Showing Countries with highest vaccination count
SELECT location, MAX(CAST(people_vaccinated as bigint)) as TotalVaccinated
FROM CovidVaccinations
WHERE continent is not null
GROUP BY location
ORDER BY 2 DESC



-- GLOBAL NUMBERS


--Global Covid Death Percentage

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths AS int)) total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE continent is not null
ORDER BY 1,2


--Global Covid Death Percentage per Day

SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths AS int)) total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE continent is not null
GROUP BY date 
ORDER BY 1,2


--Looking at Total Vaccinations (per day) vs. Population

SELECT CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations
FROM CovidDeaths
JOIN CovidVaccinations
	ON CovidDeaths.location = CovidVaccinations.location
	and CovidDeaths.date = CovidVaccinations.date
WHERE CovidDeaths.continent is not null
ORDER BY 2,3


--Showing visual for new vaccinations being added to total vaccinations and percentage of population vaccinated
--Create a CTE to showcase % vaccinated since you can't use column you JUST created

SELECT CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, 
	CovidDeaths.population, CovidVaccinations.new_vaccinations, SUM(CONVERT(int, CovidVaccinations.new_vaccinations)) 
	OVER (PARTITION BY CovidDeaths.location ORDER BY CovidDeaths.location, CovidDeaths.date) as PeopleVaccinated,
	--(RollingPeopleVaccinated/population)*100
FROM CovidDeaths
JOIN CovidVaccinations
	ON CovidDeaths.location = CovidVaccinations.location
	and CovidDeaths.date = CovidVaccinations.date
WHERE CovidDeaths.continent is not null
ORDER BY 2,3


--USE CTE 

WITH PopvsVac (continent, location, date, population, New_Vaccinations, PeopleVaccinated)
as
(
SELECT CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, 
	CovidDeaths.population, CovidVaccinations.new_vaccinations, SUM(CONVERT(int, CovidVaccinations.new_vaccinations)) 
	OVER (PARTITION BY CovidDeaths.location ORDER BY CovidDeaths.location, CovidDeaths.date) as PeopleVaccinated
--	(PeopleVaccinated/population)*100
FROM CovidDeaths
JOIN CovidVaccinations
	ON CovidDeaths.location = CovidVaccinations.location
	and CovidDeaths.date = CovidVaccinations.date
WHERE CovidDeaths.continent is not null
)
SELECT *, (PeopleVaccinated/population)*100 as PercentVaccinated
FROM PopvsVac



-- You could also create a Temp Table

CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
PeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, 
	CovidDeaths.population, CovidVaccinations.new_vaccinations, SUM(CONVERT(bigint, CovidVaccinations.new_vaccinations)) 
	OVER (PARTITION BY CovidDeaths.location ORDER BY CovidDeaths.location, CovidDeaths.date) as PeopleVaccinated
FROM CovidDeaths
JOIN CovidVaccinations
	ON CovidDeaths.location = CovidVaccinations.location
	and CovidDeaths.date = CovidVaccinations.date

SELECT * 
FROM #PercentPopulationVaccinated

--Final Code for finding Percentage of population vaccinated

SELECT *, (PeopleVaccinated/population)*100 as PercentageVaccinated
FROM #PercentPopulationVaccinated


--Creating View to store data for later visualizations 
--Can't use ORDER BY

CREATE VIEW PercentPopulationVaccinated as
SELECT CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, 
	CovidDeaths.population, CovidVaccinations.new_vaccinations, SUM(CONVERT(bigint, CovidVaccinations.new_vaccinations)) 
	OVER (PARTITION BY CovidDeaths.location ORDER BY CovidDeaths.location, CovidDeaths.date) as PeopleVaccinated
FROM CovidDeaths
JOIN CovidVaccinations
	ON CovidDeaths.location = CovidVaccinations.location
	and CovidDeaths.date = CovidVaccinations.date
WHERE CovidDeaths.continent is not null

SELECT * 
FROM PercentPopulationVaccinated



CREATE VIEW GlobalDeathPctg as
SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths AS int)) total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE continent is not null

SELECT * 
FROM GlobalDeathPctg



CREATE VIEW DailyGlobalDeathPctg as
SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths AS int)) total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE continent is not null
GROUP BY date 

SELECT * 
FROM DailyGlobalDeathPctg