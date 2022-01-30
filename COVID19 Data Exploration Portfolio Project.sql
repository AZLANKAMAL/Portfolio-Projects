/*
COVID-19 Data Exploration

Skills used: Aggregrate Functions, Converting Data Types, Joins, Subqueries, Common Table Expression

*/




--Select Data that we are going to start with

Select location,date,total_cases,new_cases,total_deaths, population
From [Portfolio Project 3]..['20220120 Covid Deaths$']
Where continent IS NOT NULL
order by 1,2;



--Compares Total Cases with Total Deaths
--Shows the likelihood of dying if you get infected with COVID-19 in your country over time

Select location,date,total_cases,total_deaths, ROUND((total_deaths/total_cases)*100,2) as DeathPercentage
From [Portfolio Project 3]..['20220120 Covid Deaths$']
Where location like '%malaysia%'
order by 1,2;

--Compares Total Cases with Population
--Shows what percentage of population that are infected with COVID-19 over time

Select location,date,Population,total_cases, ROUND((total_cases/Population)*100,2) as PercentagofInfectedPopulation
From [Portfolio Project 3]..['20220120 Covid Deaths$']
order by 1,2;


--Shows the countries with the highest infection rate relative to their population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, ROUND(MAX((total_cases/population))*100,2) as PercentPopulationInfected
From [Portfolio Project 3]..['20220120 Covid Deaths$']
Group by Location, Population
order by PercentPopulationInfected desc;


--Shows the countries with the highest death count per population


Select Location, continent, MAX(cast(Total_deaths as int)) as TotalDeathNumbers, ROUND(MAX((total_deaths/population))*100,4) as PercentPopulationDied
From [Portfolio Project 3]..['20220120 Covid Deaths$']
Where continent is not null 
Group by Location, continent
Order by PercentPopulationDied desc;


-- Breaking data down by continent

-- Showing continents with the highest death numbers 


Select continent, SUM(TotalDeathNumbers) as TotalDeathNumbersContinents
FROM
(Select Location, continent,population, MAX(cast(Total_deaths as int)) as TotalDeathNumbers
From [Portfolio Project 3]..['20220120 Covid Deaths$']
Where continent is not null 
Group by location, continent,population) AS TEMP
GROUP BY continent
ORDER BY 2 desc;

-- Shows the highest death numbers based on the four income levels of a country

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathNumbers
From [Portfolio Project 3]..['20220120 Covid Deaths$']
Where location in ('Low income', 'Lower middle income', 'Upper middle income', 'High income')
Group by Location
Order by TotalDeathNumbers desc;


-- Shows the highest COVID-19 based on the four income levels of the countries (Low Income, Lower Middle Income, Upper Middle Income, High Income)

Select Location, Sum(New_cases) as TotalCases
From [Portfolio Project 3]..['20220120 Covid Deaths$']
Where location in ('Low income', 'Lower middle income', 'Upper middle income', 'High income')
Group by Location
Order by TotalCases desc;

--Global Numbers for total cases, total deaths and death percentage

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, ROUND(SUM(cast(new_deaths as int))/SUM(New_Cases)*100,2) as DeathPercentage
FROM [Portfolio Project 3]..['20220120 Covid Deaths$']
where continent is not null
Order by 1,2;


--Shows highest number of  fully vaccinated individuals per hundred people for each country


Select Location, continent, MAX(cast(people_fully_vaccinated_per_hundred as numeric)) as TotalVaccinatedPerHundred
From [Portfolio Project 3]..['20220120 Covid Vacs$']
Where continent is not null 
Group by location, continent
Order by 3 desc;

--Shows the maximum number of people fully vaccinated per hundred people based on the four income levels of the countries (Low Income, Lower Middle Income, Upper Middle Income, High Income)

Select Location, Max(cast(people_fully_vaccinated_per_hundred as numeric)) as  PeopleFullyVaccinatedPerHundred
From [Portfolio Project 3]..['20220120 Covid Vacs$']
Where location in ('Low income', 'Lower middle income', 'Upper middle income', 'High income')
Group by Location
Order by  PeopleFullyVaccinatedPerHundred desc;


--Shows the progress of number of people fully vaccinated per hundred people based on the four income levels of the countries (Low Income, Lower Middle Income, Upper Middle Income, High Income) over time

Select date, location, people_fully_vaccinated_per_hundred
From [Portfolio Project 3]..['20220120 Covid Vacs$']
Where location in ('Low income', 'Lower middle income', 'Upper middle income', 'High income')
Order by 1,2 desc;


--Shows the top countries that have COVID-19 boosters administrated per hundred people for the population

Select Location, Max(cast(total_boosters_per_hundred as numeric)) as TotalBoostersPerHundred
From [Portfolio Project 3]..['20220120 Covid Vacs$']
Where continent is not null
Group by Location
Order by TotalBoostersPerHundred desc;

--Shows the top per hundred people based on the four income levels of the countries (Low Income, Lower Middle Income, Upper Middle Income, High Income)

Select Location, Max(cast(total_boosters_per_hundred as numeric)) as TotalBoostersPerHundred
From [Portfolio Project 3]..['20220120 Covid Vacs$']
Where location in ('Low income', 'Lower middle income', 'Upper middle income', 'High income')
Group by Location
Order by TotalBoostersPerHundred desc;


--Shows the progress of new cases, new deaths, with percentage of population vaccinated and percentage of population that have taken the COVID-19 Booster over time


With PopvsVac (Continent, Location, Date, Population, New_Cases, New_Deaths, Number_People_Fully_Vaccinated,Number_of_Boosters_Administratived)
as
(
Select d.continent, d.location, d.date, d.population, d.new_cases, d.new_deaths
, v.people_fully_vaccinated,total_boosters
From [Portfolio Project 3]..['20220120 Covid Deaths$'] d
Join [Portfolio Project 3]..['20220120 Covid Vacs$'] v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null

)
Select Continent,Location,Date,Population,New_Cases, New_Deaths, ROUND(Number_People_Fully_Vaccinated/Population*100,2) as PercentageofPopulationVaccinated, ROUND(Number_of_Boosters_Administratived/Population*100,2) as PercentageofPopulationThatHaveTakenBooster
From PopvsVac
Order by 2,3 asc