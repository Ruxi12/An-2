--11
select * 
from emp_MGB;

COMMENT ON TABLE emp_MGB IS 'Informaţii despre angajati';

--12
select * 
from user_tab_comments;

--13
ALTER SESSION SET NLS_DATE_FORMAT = 'DD.MM.YYYY:HH24:MI:SS';

--14  
select extract(year from sysdate)
from dual;  --raspuns: A extras data curenta

--15
select extract(month from sysdate)
from dual;
select extract(day from sysdate)
from dual;

--16
SELECT * FROM all_users;
select * from user_tables;

--17
select * 
from user_tables
where table_name like('%244');
drop table emp_244;

SPOOL ON;
set feedback off;
SET PAGESIZE 0;


SPOOL d:\sterge.sql;
SELECT 'DROP TABLE' || TABLE_NAME || ';'
FROM USER_TABLES
where table_name like('%244')

--18 verificare rezultate
--20
SET FEEDBACK OFF;
--21
SET PAGESIZE 0
--22
--- Exemplu de eroare: Scriptul da eroare atunci cand tabelele ce trebuie sterse nu exista.
--- Rezolvare: Verificam daca exista sau nu tabelele la stergere, adaugand conditie inainte de drop table. 

--23
SET FEEDBACK OFF;
SPOOL insert_tabela.sql;
select 'insert into departments (department_id, department_name, location_id)
values(' || department_id || ', ' || department_name || ', ' || location_id || ');'
from departments;
SPOOL OFF;
SET FEEDBACK ON;


