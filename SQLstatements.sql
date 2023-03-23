-- Total people vaccinated per country, per date where data is not NULL
SELECT location, SUM(people_vaccinated)
	FROM covid_tests
	GROUP BY location
	HAVING SUM(people_vaccinated) NOT NULL
	ORDER BY 2;

-- Total deaths per cases per country
SELECT location, SUM(total_deaths), SUM(total_cases), 
SUM( CAST(total_deaths AS float) ) / SUM ( CAST( total_cases AS float) )
		FROM deaths_and_cases 
		GROUP BY location; 
	
-- Total deaths per cases in the US
SELECT location, SUM(total_deaths), SUM(total_cases), 
ROUND(SUM( CAST(total_deaths AS float) ) / SUM ( CAST( total_cases AS float) )*100, 2) AS "Deaths Per Cases"
		FROM deaths_and_cases 
		WHERE location like '%states' 
		GROUP BY location; 

-- country with highest life expectancy 
SELECT location, AVG(life_expectancy) 
	FROM diseases_mortality
	GROUP BY LOCATION
	ORDER BY 2 DESC
	LIMIT 1;

-- top 5 countries with highest deaths per population
SELECT d.location, SUM( CAST(total_deaths AS float) ) / SUM ( CAST( population AS float) )
	FROM deaths_and_cases d
	JOIN vaccinations v
		on d.iso_code = v.iso_code
GROUP BY d.location
ORDER BY 2 LIMIT 5;

-- total cases, total deaths, new cases per country 

SELECT location, SUM(total_deaths), SUM(total_cases), SUM(new_cases)
	FROM deaths_and_cases
	GROUP BY location;

--  death rate per population per country 
SELECT location, ROUND(SUM(CAST(total_deaths AS FLOAT)) / SUM(CAST(population AS FLOAT)) *100, 2)
	FROM deaths_and_cases
	GROUP BY location
	ORDER BY 2 DESC;

-- first day of recorded vaccinations for every country 
SELECT location, MIN(date)
	FROM deaths_and_cases
	GROUP BY location
	ORDER BY 2;