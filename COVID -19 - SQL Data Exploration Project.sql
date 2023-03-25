Skills used: SELECT, FROM, JOIN, SUM, ROUND, AVG, MAX, MIN, GROUP BY, ORDER BY, and UNION ALL

-- Number of people vaccinated in each country 

SELECT location, SUM(people_vaccinated)
FROM covid_tests
GROUP BY location
HAVING SUM(people_vaccinated) NOT NULL
ORDER BY 2;

-- The mortality rate (case-fatality rate) by country
SELECT location, SUM(total_deaths), SUM(total_cases), 
    ROUND(SUM( CAST(total_deaths AS float) ) / SUM ( CAST( total_cases AS float) ) *100,2) AS 'Mortality Rate'
FROM deaths_and_cases 
WHERE total_deaths IS NOT NULL AND total_cases IS NOT NULL
GROUP BY location; 

-- The mortality rate (case-fatality rate) per continent
SELECT continent, SUM(total_deaths), SUM(total_cases), 
    ROUND(SUM( CAST(total_deaths AS float) ) / SUM ( CAST( total_cases AS float) ) *100,2) AS 'Mortality Rate'
FROM deaths_and_cases 
WHERE total_deaths IS NOT NULL AND total_cases IS NOT NULL
AND  continent is NOT NULL
GROUP BY continent
ORDER BY 2 DESC;

-- global numbers
SELECT SUM(total_deaths), SUM(total_cases), SUM(total_vaccinations), 
    ROUND(SUM(CAST(total_deaths as float))/SUM(CAST (total_cases AS FLOAT))*100,2) AS 'case-fatality rate',
    ROUND(SUM(CAST(total_deaths AS FLOAT)) / SUM(CAST(population AS FLOAT)) *100, 2) AS 'Death Rate'
FROM deaths_and_cases
WHERE total_deaths NOT NULL and total_cases NOT NULL

--The mortality rate(case-fatality rate) in a specific country

SELECT location, SUM(total_deaths), SUM(total_cases), 
    ROUND(SUM( CAST(total_deaths AS float) ) / SUM ( CAST( total_cases AS float) )*100, 2) AS "Deaths Per Cases"
FROM deaths_and_cases 
WHERE location like '%states' 
GROUP BY location; 

-- Country with the highest life expectancy 

SELECT location, AVG(life_expectancy) 
FROM diseases_mortality
GROUP BY LOCATION
ORDER BY 2 DESC
LIMIT 1;

-- Top 10 countries with the highest life expectancy 

SELECT location, AVG(life_expectancy)
FROM diseases_mortality
WHERE life_expectancy NOT NULL
GROUP BY location
ORDER BY 2 DESC LIMIT 10;

-- Overall total cases and total deaths in each country 

SELECT location, SUM(total_deaths), SUM(total_cases)
FROM deaths_and_cases
WHERE total_deaths NOT NULL and total_cases NOT NULL
GROUP BY location;

-- Death rate (per population) in each country 

SELECT location, ROUND(SUM(CAST(total_deaths AS FLOAT)) / SUM(CAST(population AS FLOAT)) *100, 2) AS 'Death Rate'
FROM deaths_and_cases
GROUP BY location
ORDER BY 2 DESC;
-- Death rate per continent

SELECT continent, SUM(CAST(total_deaths AS FLOAT)) / SUM(CAST(population AS FLOAT)) *100 AS 'Death Rate'
FROM deaths_and_cases
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY 2 DESC;

-- Countries with the highest death count per population

SELECT location, SUM(total_deaths), 
    ROUND(SUM(CAST (total_deaths AS FLOAT) /CAST (population AS FLOAT))*100,2) AS "Death Count"
FROM deaths_and_cases
WHERE total_deaths NOT NULL 
GROUP BY location
ORDER BY 3 DESC LIMIT 5;

-- First day of recorded vaccinations for every country 

SELECT location, MIN(date) as 'First Vaccinations Date', total_vaccinations
FROM deaths_and_cases
WHERE total_vaccinations IS NOT NULL AND continent IS NOT NULL
GROUP BY location
ORDER BY 2;

-- Countries with the highest count of cases (infection rate) compared to Population over time

SELECT location, population, SUM(total_cases) as "Infection Count", ROUND(SUM(CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100, 2) AS "Infection Rate"
FROM deaths_and_cases
GROUP by location, population
ORDER BY 4 DESC;

-- Day with the highest infection rate in each country
SELECT location, population, date, ROUND(MAX(infection_rate) ,2) as "Infection Rate"
FROM (
    SELECT location, population, date, 
    CAST(total_cases AS FLOAT) / CAST(population AS FLOAT) * 100 AS infection_rate
    FROM deaths_and_cases
    ) 
GROUP BY location, population
ORDER BY 4 DESC;

--  Cardiovascular death rate of people with Covid-19 in each country 

SELECT location, ROUND(AVG(cardiovasc_death_rate),2)
FROM diseases_mortality
WHERE cardiovasc_death_rate NOT NULL
GROUP BY location;

--  Rate of covid-19 infected people who have diabetes in each country
SELECT location, ROUND(AVG(diabetes_prevalence),2)
FROM diseases_mortality
WHERE diabetes_prevalence NOT NULL
GROUP BY location;

-- Day with the highest number of new cases for each country (remove the continent results)
SELECT t1.location, t1.date, t1.new_cases
FROM deaths_and_cases t1
INNER JOIN (
    SELECT location, MAX(new_cases) AS max_new_cases
    FROM deaths_and_cases
    WHERE continent IS NOT NULL
    GROUP BY location
    ) t2
    ON t1.location = t2.location AND t1.new_cases = t2.max_new_cases
ORDER BY t1.location;

-- Total number of people fully vaccinated in each country with the total vaccinated 
SELECT location, SUM(people_fully_vaccinated) AS total_people_fully_vaccinated
FROM covid_tests
WHERE people_fully_vaccinated IS NOT NULL
GROUP BY location
    UNION ALL
SELECT 'Total', SUM(people_fully_vaccinated) AS total_people_fully_vaccinated
FROM covid_tests
WHERE people_fully_vaccinated IS NOT NULL;

-- Total people vaccinated population, and new cases for each country
SELECT d.location, t.people_fully_vaccinated, d.population, d.new_cases
FROM deaths_and_cases d
JOIN covid_tests t
ON d.iso_code = t.iso_code;


-- Case and death trends over time
SELECT date, SUM(new_cases), SUM(total_deaths)
FROM deaths_and_cases
WHERE continent IS NOT NULL AND new_cases IS NOT NULL AND total_deaths IS NOT NULL
GROUP BY date;


-- percentage of hospitalized, and intensive care patients for each country 
SELECT 
    location, 
    SUM(hosp_patients) AS total_hosp_patients, 
    SUM(icu_patients) AS total_icu_patients, 
    ROUND(SUM(CAST(hosp_patients AS FLOAT)) / SUM(CAST(total_cases AS FLOAT)) * 100, 2) AS hosp_patients_percentage,
    ROUND(SUM(CAST(icu_patients AS FLOAT)) / SUM(CAST(total_cases AS FLOAT)) * 100, 2) AS icu_patients_percentage,
    ROUND(SUM(CAST(icu_patients AS FLOAT)) / SUM(CAST(hosp_patients AS FLOAT)) * 100, 2) AS icu_vs_hosp_percentage
FROM deaths_and_cases
WHERE hosp_patients IS NOT NULL AND icu_patients IS NOT NULL
GROUP BY location;
