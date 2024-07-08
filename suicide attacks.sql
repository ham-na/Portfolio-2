-- DATA CLEANING:

CREATE TEMPORARY TABLE temp_dates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    date varchar(255)
);

INSERT INTO temp_dates (date)
VALUES
	('Sunday-November 19-1995'),
	('Monday-November 6-2000')
;
	
UPDATE suicide_attacks_pak sa
JOIN temp_dates td ON sa.id = td.id
SET sa.dates = td.date;

alter table suicide_attacks_pak
add proper_date int
;

alter table suicide_attacks_pak
modify column proper_date varchar(255)
;

UPDATE suicide_attacks_pak
SET proper_date = right(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(dates, '-', 2), '-', -1)), 2)
;

update suicide_attacks_pak
set proper_date = '29'
where id = 459
;

alter table suicide_attacks_pak
modify column proper_date int
;

alter table suicide_attacks_pak
add year int
;

UPDATE suicide_attacks_pak
SET year = SUBSTRING_INDEX(REVERSE(SUBSTRING_INDEX(REVERSE(date), '-', 1)), '-', -1) 
;

update suicide_attacks_pak
set month =
    (CASE 
        WHEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(dates, '-', 2), '-', -1)) like '%Jan%' THEN '01'
        WHEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(dates, '-', 2), '-', -1)) like '%Feb%' THEN '02'
        WHEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(dates, '-', 2), '-', -1)) like '%Mar%' THEN '03'
        WHEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(dates, '-', 2), '-', -1)) like '%Apr%' THEN '04'
        WHEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(dates, '-', 2), '-', -1)) like '%May%' THEN '05'
        WHEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(dates, '-', 2), '-', -1)) like '%June%' THEN '06'
        WHEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(dates, '-', 2), '-', -1)) like '%July%' THEN '07'
        WHEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(dates, '-', 2), '-', -1)) like '%Aug%' THEN '08'
        WHEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(dates, '-', 2), '-', -1)) like '%Sep%' THEN '09'
        WHEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(dates, '-', 2), '-', -1)) like '%Oct%' THEN '10'
        WHEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(dates, '-', 2), '-', -1)) like '%Nov%' THEN '11'
        WHEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(dates, '-', 2), '-', -1)) like '%Dec%' THEN '12'
        ELSE '00' -- In case the month is not recognized
    END );

select SUBSTRING_INDEX(SUBSTRING_INDEX(Date, '-', -1), '-', 1)
from suicide_attacks_pak
;

update suicide_attacks_pak
set DATE = concat(year, '-',month, '-', proper_date)
;

-- DATA EXPLORATION

select count(*)
from suicide_attacks_pak
;

alter table suicide_attacks_pak
add column month int
;

select Province, count(*) as `number of attacks`
from suicide_attacks_pak
group by `Province`
order by count(*) desc
;

select `Location Category`, count(*) as `number of attacks`
from suicide_attacks_pak
group by `Location Category`
order by count(*) desc
;

select `Location Sensitivity`, count(*) as `number of attacks`
from suicide_attacks_pak
group by `Location Sensitivity`
order by count(*) desc
;

select count(*) as `number of attacks` , year
from suicide_attacks_pak
group by year
order by count(*) desc
;

select month, count(*) as `number of attacks`
from suicide_attacks_pak
group by month
order by count(*) desc
;

select day_of_week, count(*) as `number of attacks`
from suicide_attacks_pak
group by day_of_week
order by count(*) desc
;

With Cte_example as
(select count(*) as `number of attacks`, month
from suicide_attacks_pak
group by month)
select format(avg(`number of attacks`), 0) as `avg attacks per month`
from Cte_example
;

select count(*) as `number of attacks`, `Targeted Sect if any`
from suicide_attacks_pak
group by `Targeted Sect if any`
;

select count(*) as `number of attacks`, `Target Type`
from suicide_attacks_pak
group by `Target Type`
;

select round(avg(`Killed Max`),0) as `average people killed`, 
		round(avg(`Injured Max`),0) as `average people injured`
from suicide_attacks_pak
;

select province, sum(`Killed Max`) as `number of people killed`
from suicide_attacks_pak
group by province
;

select `holiday type`, count(*) as `number of attacks`
from suicide_attacks_pak
group by `holiday type`
;

select Longitude, Latitude, count(*) as `number of attacks`, sum(`Killed Max`) as `fatalities`
from suicide_attacks_pak
group by Longitude, Latitude
;


