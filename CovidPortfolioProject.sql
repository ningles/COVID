SELECT * 
FROM covid_deaths
ORDER BY 3,4

SELECT * 
FROM covid_vaccinations
ORDER BY 3,4
--All Data from tables we will be using

SELECT location, date, total_cases, total_deaths, total_deaths/ CAST(total_cases AS FLOAT)*100 AS DeathPercentage
FROM covid_deaths
WHERE date = '2022-07-15' AND location = 'United States'
ORDER BY 1,2
--Death Rate as of yesterday in United States

SELECT location, date, total_cases, population, total_cases/ CAST(population AS FLOAT)*100 AS PercentPopulationInfected
FROM covid_deaths
WHERE location = 'United States'
ORDER BY 1,2
--Percentage of Total Cases vs Population in the United States

SELECT location, population, MAX(total_cases)AS HighestInfectionCount, MAX(total_cases/CAST(population AS FLOAT))*100 AS PercentPopulationInfected
FROM covid_deaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC
-- Countries with Highest Infection Rate by Country

SELECT location, MAX(total_deaths)AS TotalDeathCount
FROM covid_deaths
WHERE continent is NOT NULL 
AND total_deaths is NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC
-- Countries with Highest Death Count per Population

SELECT continent, MAX(total_deaths)AS TotalDeathCount
FROM covid_deaths
WHERE continent is NOT NULL 
AND total_deaths is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC
--Highest Death Count by Continent

SELECT SUM(new_cases)AS total_cases,SUM(new_deaths)AS total_deaths, SUM (new_deaths)/SUM(new_cases)*100 AS GlobalDeathPercentage
FROM covid_deaths
WHERE continent is NOT NULL
ORDER BY 1,2
--Global Death Rate

WITH PopVsVac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
AS(
SELECT dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, SUM(vacc.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent is NOT NULL
ORDER BY 2,3)
SELECT *,(RollingPeopleVaccinated/Population)*100 AS VaccinatedVsPopulation
FROM PopVsVac
--Rolling People Vaccinated by Country and Vaccinated Percentage by Date/Country

CREATE VIEW VaccinatedVsPopulation AS(
SELECT dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, SUM(vacc.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent is NOT NULL
)
--Create VIEW VaccinatedVsPopulation


CREATE VIEW TotalDeathCount AS(
SELECT continent, MAX(total_deaths)AS TotalDeathCount
FROM covid_deaths
WHERE continent is NOT NULL 
AND total_deaths is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC
)
--Create VIEW TotalDeathCount by Continent


CREATE VIEW PercentPopulationInfected AS
(SELECT location, population, MAX(total_cases)AS HighestInfectionCount, MAX(total_cases/CAST(population AS FLOAT))*100 AS PercentPopulationInfected
FROM covid_deaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC)
--Create VIEW PercentPopulationInfected


CREATE VIEW TotalDeathCountCountry AS (
SELECT location, MAX(total_deaths)AS TotalDeathCount
FROM covid_deaths
WHERE continent is NOT NULL 
AND total_deaths is NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC
)
--Create VIEW TotalDeathCountCountry










