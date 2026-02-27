CREATE DATABASE hr_analytics;
USE hr_analytics;
drop table if exists hr_raw;
CREATE TABLE hr_raw (
    emp_id varchar(10),
    age INT,
    age_group VARCHAR(20),
    attrition VARCHAR(10),
    business_travel VARCHAR(50),
    daily_rate INT,
    department VARCHAR(50),
    distance_from_home INT,
    education INT,
    education_field VARCHAR(50),
    employee_count INT,
    employee_number INT,
    environment_satisfaction INT,
    gender VARCHAR(20),
    hourly_rate INT,
    job_involvement INT,
    job_level INT,
    job_role VARCHAR(50),
    job_satisfaction INT,
    marital_status VARCHAR(20),
    monthly_income INT,
    salary_slab VARCHAR(20),
    monthly_rate INT,
    num_companies_worked INT,
    over18 VARCHAR(5),
    over_time VARCHAR(10),
    percent_salary_hike INT,
    performance_rating INT,
    relationship_satisfaction INT,
    standard_hours INT,
    stock_option_level INT,
    total_working_years INT,
    training_times_last_year INT,
    work_life_balance INT,
    years_at_company INT,
    years_in_current_role INT,
    years_since_last_promotion INT,
    years_with_curr_manager INT
);

CREATE TABLE employees AS
SELECT 
    emp_id,
    age,
    age_group,
    gender,
    marital_status,
    education,
    education_field,
    attrition
FROM hr_raw;
select * from employees;

CREATE TABLE job_details AS
SELECT 
    emp_id,
    department,
    job_role,
    job_level,
    job_involvement,
    job_satisfaction,
    environment_satisfaction,
    work_life_balance,
    years_at_company,
    years_in_current_role,
    years_since_last_promotion,
    years_with_curr_manager
FROM hr_raw;
select * from job_details;

CREATE TABLE compensation AS
SELECT 
    emp_id,
    daily_rate,
    hourly_rate,
    monthly_income,
    salary_slab,
    percent_salary_hike,
    performance_rating,
    stock_option_level
FROM hr_raw;
select * from compensation;


-- TOTAL EMPLOYEES -----------------------------------------------------------------------
SELECT COUNT(*) FROM employees;


-- ATTRIBUTE RATE -------------------------------------------------------------------------
SELECT 
    attrition,
    COUNT(*) AS count
FROM employees
GROUP BY attrition;

-- ATTRIBUTE BY DEPARTMENT ----------------------------------------------------------------
SELECT 
    j.department,
    SUM(CASE WHEN e.attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left
FROM employees e
JOIN job_details j
ON e.emp_id = j.emp_id
GROUP BY j.department;

-- AVERAGE SALARY BY DEPARTMENT -----------------------------------------------------------
SELECT 
    j.department,
    AVG(c.monthly_income) AS avg_salary
FROM job_details j
JOIN compensation c
ON j.emp_id = c.emp_id
GROUP BY j.department;

-- TOP FIVE HIGHEST PAID EMPLOYEES ----------------------------------------------------------
SELECT 
    e.emp_id,
    j.job_role,
    c.monthly_income
FROM employees e
JOIN job_details j ON e.emp_id = j.emp_id
JOIN compensation c ON e.emp_id = c.emp_id
ORDER BY c.monthly_income DESC
LIMIT 5;



-- EMPLOYEES WHO LEFT --------------------------------------------------------------------------
SELECT *
FROM employees
WHERE attrition = 'Yes';

-- EMPLOYEES IN SALES DEPARTMENT ---------------------------------------------------------------
SELECT e.emp_id, j.department
FROM employees e
JOIN job_details j ON e.emp_id = j.emp_id
WHERE j.department = 'Sales';

-- AVERAGE SALARY GREATER THAN 6000 -------------------------------------------------------------
SELECT 
    j.department,
    AVG(c.monthly_income) AS avg_salary
FROM job_details j
JOIN compensation c ON j.emp_id = c.emp_id
GROUP BY j.department
HAVING AVG(c.monthly_income) > 6000;

-- HIGH RISK JOB ROLES --------------------------------------------------------------------------
SELECT 
    j.job_role,
    COUNT(*) AS total_attrition
FROM employees e
JOIN job_details j ON e.emp_id = j.emp_id
WHERE e.attrition = 'Yes'
GROUP BY j.job_role
ORDER BY total_attrition DESC;