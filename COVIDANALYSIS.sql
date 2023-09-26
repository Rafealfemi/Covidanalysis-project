CREATE TABLE coviddeaths(

COPY coviddeaths FROM 'C:\Users\Public\Documents\coviddeaths.csv' DELIMITER ',' CSV HEADER;
  
);
CREATE TABLE Vaccinations(

iso_code VARCHAR,
  continent VARCHAR,
  location VARCHAR,
  Date DATETIME,
  new_tests BIGINT,
  total_tests BIGINT,
  total_test_per_thousand NUMERIC,
  new_test-per_thousand  NUMERIC,
  new_test_smoothed BIGINT,
  new_test_smoothed_per_thousand NUMERIC,
  positive_rate NUMERIC,
  test_per_case FLOAT8,
  test_units VARCHAR,
  total_vaccinations BIGINT,
  people_vaccinated BIGINT,
  people_fully_vaccinated BIGINT,
  new_vaccinations BIGINT,
  new_vaccination smoothed BIGINT,
  total_vaccination_per_hundred FLOAT8,
  people_vaccinated_per_thousand FLOAT8,
  people_fully-vaccinated_per_hundred FLOAT8,
  new_vaccination_smoothed_per_million  BIGINT,
  stringency_index FLOAT8,
  population_density FLOAT8,
  median_age FLOAT8,
  aged_65_older NUMERIC,
  aged_70_older NUMERIC,
  gdp_per_capita FLOAT8,
  extreme_poverty FLOAT8,
  cardiovasc_death_rate FLOAT8,
  death_rate FLOAT8,
  female_smokers FLOAT8,
  male_smokers FLOAT8,
  handwashing_facilities NUMERIC,
  hospital_beds_per_thousand NUMERIC,
  life_expectancy NUMERIC,
  human_development_index NUMERIC);

COPY vaccination FROM 'C:\Users\Public\Documents\Vaccination.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM vaccination;

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM coviddeaths
ORDER BY 1,2;

---Death Percentage shows likelihood of death from covid in locations----
SELECT location,date,total_cases,total_deaths,CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT)*100 AS Death_Percent
FROM coviddeaths
WHERE Location='Nigeria'
ORDER BY 1,2;

---Percentage of people that caught covid---
SELECT location,date,total_cases,population,CAST(total_cases AS FLOAT)/CAST(population AS FLOAT)*100 AS infection_rate
FROM coviddeaths
--WHERE Location='Nigeria'
ORDER BY 1,2;
---countries with most infection rates--
SELECT location,MAX(total_cases),population,MAX(CAST(total_cases AS FLOAT)/CAST(population AS FLOAT)*100) AS infection_rate
FROM coviddeaths
GROUP BY location,population
ORDER BY infection_rate DESC;

---Highest death count by country---
SELECT location,population, MAX(CAST(total_deaths AS FLOAT)) AS Total_death_count
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY Total_death_count DESC;

---Highest death rate by continent---
SELECT distinct(continent), MAX(CAST(total_deaths AS FLOAT)) AS Total_death_count
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_death_count DESC;

----GLOBAL NUMBERS----
SELECT date,SUM(CAST(total_deaths AS FLOAT)) AS Total_death_count,SUM(CAST(new_cases AS FLOAT)) AS new_cases,SUM(CAST(new_deaths AS FLOAT)) AS new_deaths
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

---Join vaccination and coviddeaths----

SELECT *
FROM Coviddeaths CD
JOIN Vaccination VA
ON CD.location=VA.location
AND CD.date=VA.date;
----Total Vaccination by Population---
SELECT CD.continent,CD.location,CD.date,CD.population,VA.new_vaccinations
FROM Coviddeaths CD
JOIN Vaccination VA
ON CD.location=VA.location
AND CD.date=VA.date
WHERE CD.continent IS NOT NULL
ORDER BY 1,2,3;

----PARTITION BY TO GET ROLLINGCOUNT OF VACCINATION---
SELECT CD.continent,CD.location,CD.date,CD.population,VA.new_vaccinations,
SUM(CONVERT (INT,VA.new_vaccinations)) OVER (PARTITION BY CD.loaction order by CD.location,CD.date) AS rollingcountvaccinated
FROM Coviddeaths CD
JOIN Vaccination VA
ON CD.location=VA.location
AND CD.date=VA.date
WHERE CD.continent IS NOT NULL
ORDER BY 1,2,3;

CREATE VIEW Totalvaccinationbypopulation AS
SELECT CD.continent,CD.location,CD.date,CD.population,VA.new_vaccinations
FROM Coviddeaths CD
JOIN Vaccination VA
ON CD.location=VA.location
AND CD.date=VA.date
WHERE CD.continent IS NOT NULL
ORDER BY 1,2,3;

CREATE VIEW Globalnumbers AS
SELECT date,SUM(CAST(total_deaths AS FLOAT)) AS Total_death_count,SUM(CAST(new_cases AS FLOAT)) AS new_cases,SUM(CAST(new_deaths AS FLOAT)) AS new_deaths
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;


CREATE VIEW Deathrate AS
SELECT distinct(continent), MAX(CAST(total_deaths AS FLOAT)) AS Total_death_count
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_death_count DESC;
























