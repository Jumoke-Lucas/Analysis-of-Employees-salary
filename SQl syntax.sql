use employees_mod;

/*Create a visualization that provides a breakdown between each male & female employees working in the company each year,
 starting from 1990*/
Select year(d.from_date) as Calender_year, e.gender, count(e.emp_no) as no_of_employees
from t_employees e join t_dept_emp d 
on d.emp_no = e.emp_no
group by Calender_year, e.gender
having Calender_year >= '1990';

use employees_mod;

/*2.Compare the number of male managers to the number of female managers from different departments for each year,
 starting from 1990.*/
Select d.dept_name, em.gender, dm.from_date, dm.to_date, e.Calender_year,
case when Year(dm.to_date)>=e.calender_year and year(dm.from_date)<=e.calender_year then 1 else 0 end as active_year
from (select year(hire_date) as calender_year from t_employees group by calender_year) e
cross join t_dept_manager dm
join t_departments d on dm.dept_no = d.dept_no
join t_employees em on dm.emp_no = em.emp_no
order by dm.emp_no, calender_year;

/*3.Compare the average salary of female versus male employees in the entire company until year 2002, 
and add a filter allowing you to see that per each department.*/
Select e.Gender, d.dept_name,Round(avg(s.salary),2) as Salary, year(s.from_date) as calender_year
from t_salaries s join t_employees e on s.emp_no = e.emp_no
join t_dept_emp de on de.emp_no = e.emp_no
join t_departments d on d.dept_no = de.dept_no
group by d.dept_no, e.gender, calender_year
having calender_year <=2002
order by d.dept_no;

/*4.Create an SQL stored procedure that will allow you to obtain the average male and female salary per department within a certain salary range. Let this range be defined by two values the user can insert when calling the procedure.
Finally, visualize the obtained result-set in Tableau as a double bar chart. */

Select min(salary) from t_salaries;
select max(salary) from t_salaries;

Drop procedure if exists Filter_salary;
Delimiter $$
Create procedure Filter_salary (IN p_min_salary FLOAT, IN p_max_salary FLOAT)
BEGIN
Select avg(s.salary) as Avg_salary, e.gender, d.dept_name
from t_salaries s join t_employees e on s.emp_no = e.emp_no
join t_dept_emp de on de.emp_no = e.emp_no
join t_departments d on d.dept_no = de.dept_no
where s.salary between p_min_salary and p_max_salary
group by e.gender,d.dept_no;
end $$
Delimiter ;

Call Filter_salary (50000, 90000); 