-- 1.
SELECT e.first_name, e.last_name, s.salary FROM employees e JOIN salaries s ON e.emp_no = s.emp_no WHERE s.to_date = '9999-01-01' AND s.salary > 90000;
-- 2.
SELECT e.first_name, e.last_name, d.dept_name FROM employees e JOIN current_dept_emp cde ON e.emp_no = cde.emp_no JOIN departments d ON cde.dept_no = d.dept_no WHERE cde.to_date = '9999-01-01' AND cde.dept_no IN ('d008', 'd009');
-- 3.
SELECT e.first_name, e.last_name, t.title FROM employees e JOIN titles t ON e.emp_no = t.emp_no WHERE t.to_date = '9999-01-01' AND e.gender = 'F' AND t.title = 'Technique Leader';
-- 4.
SELECT DISTINCT e.first_name, e.last_name, s.salary FROM employees e JOIN salaries s ON e.emp_no = s.emp_no JOIN titles t ON e.emp_no = t.emp_no WHERE s.to_date = '9999-01-01' AND t.title <> 'Senior Engineer' ORDER BY s.salary ASC;
-- 5.
SELECT first_name, last_name, birth_date FROM employees e ORDER BY birth_date DESC;
-- 6.
SELECT e.first_name, e.last_name FROM employees e JOIN dept_manager dm ON e.emp_no = dm.emp_no WHERE dm.to_date = '9999-01-01';
-- 7.
SELECT e.first_name, e.last_name, d.dept_name FROM employees e JOIN salaries s ON e.emp_no = s.emp_no JOIN current_dept_emp cde ON e.emp_no = cde.emp_no JOIN departments d ON cde.dept_no = d.dept_no WHERE s.salary = (SELECT MAX(salary) FROM salaries) LIMIT 1;

