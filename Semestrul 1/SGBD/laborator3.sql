--laborator 3 
select * 
from employees
where
extract (month from hire_date) =( extract( month from sysdate) 
and 
extract (day from hire_day) in ('1', '2');

select count(*)
from rental
right join dual 
on (extract month from dual ) = (extract(month from sysdate))
and (extract (year from book_date) = (extract (year from sysdate))
where extract(month from book_date) = extract(month from sysdate)
and extract(year from book_date) = extract(year from sysdate)
group by(book_date);

select last_day (sysdate) from dual;

select ZIUA, (SELECT COUNT(*) FROM RENTAL 
            WHERE 
            TO_CHAR(BOOK_DATE,'DD.MM.YY') = TO_CHAR(ZIUA, 'DD.MM.YY')) NR
FROM (SELECT EXTRACT(MONTH FROM SYSDATE) + LEVEL + 1 +ZIUA FROM DUAL )
        CONNECT BY LEVEL EXTRACT(DAY FROM LAST_DATE(SYSDATE)
FROM RENTAL; 

--WHERE

--SELECT EXTRACT (DAY FROM SYSDATE) + LEVEL - EXTRACT (DAY FROM LAST_DAY(SYSDATE)) FROM DUAL
--CONNECT BY LEVEL <= EXTRACT (DAY FROM LAST_DAY(SYSDATE));

SELECT D.ZIUA, COUNT(*)
FROM 
(SELECT LEVEL AS ZIUA FROM DUAL
CONNECT BY LEVEL <= EXTRACT(DAY FROM LAST_DAY(SYSDATE))) D
LEFT JOIN RENTAL R ON  ON (EXTRACT (MONTH FROM LAST_DAY(SYSDATE)) = (EXTRACT (MONTH FROM SYSDATE) )
                            AND (EXTRACT (YEAR FROM BOOK_DATE)) = EXTRACT(YEAR FROM SYSDATE) 
                            AND (EXTRACT (day from book_date) = D.ZIUA)
GROUP BY D.ZIUA;


--pl sql
BEGIN 
    SELECT DEPARTMENT_NAME, COUNT(DEPARTMENT_NAME)
    FROM EMPLOYEES
    RIGHT JOIN departments ON departments.department_id = EMPLOYEES.DEPARTMENT_ID
    GROUP BY DEPARTMET_NAME
    HAVING COUNT(EMPLOYEES.DEPARTMENT_ID) = 
    (SELECT MAX(COUNT(*)) FROM departments
    GROUP BY DEPARTMENT_ID)

END;
