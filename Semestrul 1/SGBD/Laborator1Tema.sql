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
spool 'fisier.sql'
select 'drop table' || table_name || ';'
from user_tables
where table_name like '%_PVA';
spool off

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
