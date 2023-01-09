--LABOARTOR 2 PL/SQL
DECLARE
    TYPE tablou_indexat IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    t tablou_indexat;
BEGIN
    --A
    FOR i IN 1 .. 10 LOOP
        t(i) := i;
    end loop;
    DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
    for i in t.first ..t.LAST loop
        DBMS_OUTPUT.PUT(t(i) || ' ');

    end loop;
    DBMS_OUTPUT.NEW_LINE();
    -- b  Setați la valoarea null elementele de pe pozițiile impare.
    for i in 1..10 loop
        if i mod 2 = 1 then 
            t(i) := null;
        end if;
    end loop;
    dbms_output.put('Tabloul are ' || t.count || ' elemente: ');
    for i in t.first..t.last loop
        dbms_output.put(nvl(t(i), 0) || ' ');
    end loop;
    DBMS_OUTPUT.new_line;
    -- c Ștergeți primul element, elementele de pe pozițiile 5, 6 și 7, respectiv ultimul element. Afișați
    --valoarea și indicele primului, respectiv ultimului element. Afișați elementele tabloului și numărul
    --acestora.
    t.delete(t.first());
    t.delete(5, 7);
    t.delete(t.last());
    DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first ||
         ' si valoarea ' || nvl(t(t.first),0));
    DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last ||
         ' si valoarea ' || nvl(t(t.last),0));
    DBMS_OUTPUT.PUT_line('Tabloul are ' || t.COUNT ||' elemente: ');
    
    DBMS_OUTPUT.NEW_LINE;
    -- punctul d
    t.delete;
    DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
end;
/
--5
DECLARE 
    TYPE TABLOU_INDEXAT IS TABLE OF EMP_RMG%ROWTYPE INDEX BY BINARY_INTEGER;
    T TABLOU_INDEXAT;
BEGIN 
    DELETE FROM EMP_RMG 
    WHERE ROWNUM<=2
    RETURNING employee_id, first_name, last_name, email, phone_number,
             hire_date, job_id, salary, commission_pct, manager_id,
             department_id
    BULK COLLECT INTO T;
    --AFISARE ELEMENT DIN TABLOU
    DBMS_OUTPUT.PUT_LINE(T(1).EMPLOYEE_ID || ' ' || T(1).LAST_NAME );
    DBMS_OUTPUT.PUT_LINE(T(2).EMPLOYEE_ID || ' ' || T(2).LAST_NAME );
    -- INSERARE CELE 2 LINII IN TABEL
    INSERT INTO EMP_RMG VALUES T(1);
    INSERT INTO EMP_RMG VALUES T(2);
END;     
/

--6
DECLARE
    TYPE TABLOU_IMBRICAT IS TABLE OF NUMBER;
    T TABLOU_IMBRICAT := TABLOU_IMBRICAT();
BEGIN 
    --a
    FOR I IN 1..10 LOOP
        T.EXTEND;
        T(I) := I;
    END LOOP;
    DBMS_OUTPUT.PUT('TABLOUL ARE ' || T.COUNT || ' ELEMENTE: ');
    FOR I IN T.FIRST..T.LAST LOOP
        DBMS_OUTPUT.PUT(T(I) || ' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
    --B
    -- punctul b
      FOR i IN 1..10 LOOP
        IF i mod 2 = 1 THEN t(i):=null;
        END IF;
      END LOOP;
      DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
      FOR i IN t.FIRST..t.LAST LOOP
          DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' ');
      END LOOP;
      DBMS_OUTPUT.NEW_LINE;
END;
/

--7 
DECLARE
    TYPE TABLOU_IMBRICAT IS TABLE OF CHAR(1);
    T TABLOU_IMBRICAT := TABLOU_IMBRICAT('M', 'I', 'N', 'I', 'M');
    I INTEGER;
BEGIN
    I := T.FIRST;
    WHILE I <= T.LAST LOOP
        DBMS_OUTPUT.PUT(T(I));
        I := T.NEXT(I);
    END LOOP;
    dbms_output.new_line;
    
    -- INVERS
    I := T.LAST;
    WHILE I>=T.FIRST LOOP
        DBMS_OUTPUT.PUT(T(I));
        I := T.PRIOR(I);
    END LOOP;
    dbms_output.new_line;
    -- ELIMINARE ELEM
    T.DELETE(2);
    T.DELETE(4);
    T.DELETE(7);
    I := T.FIRST;
    WHILE I <= T.LAST LOOP
        DBMS_OUTPUT.PUT(T(I));
        I := T.NEXT(I);
    END LOOP;
    dbms_output.new_line;
    
END;
/
--8 
DECLARE 
    TYPE VECTOR IS VARRAY(20) OF NUMBER ;
    T VECTOR := VECTOR();
BEGIN 
    --A 
    FOR I IN 1..10 LOOP
        T.EXTEND;
        T(I) := I;
    END LOOP;
END;
/

--10
CREATE TABLE EMP_TEST_RMG AS
                SELECT EMPLOYEE_ID, LAST_NAME 
                FROM EMPLOYEES
                WHERE ROWNUM <= 2;
CREATE OR REPLACE TYPE TIP_TELEFON_RMG IS TABLE OF VARCHAR(12);
/
ALTER TABLE EMP_TEST_RMG
ADD (TELEFON TIP_TELEFON_RMG)
NESTED TABLE TELEFON STORE AS TABLE_TELEFON_RMG;

INSERT INTO EMP_TEST_RMG
VALUES (500, 'XYZ', TIP_TELEFON_RMG('074XXX', '0213XXX', '037XXX'));

SELECT *
FROM EMP_TEST_RMG;

UPDATE EMP_TEST_RMG
SET TELEFON = TIP_TELEFON_RMG('073XXX', '0214XXX')
WHERE EMPLOYEE_ID = 100;
-- AFISARE INTERESANTA 
SELECT A.EMPLOYEE_ID, B.*
FROM EMP_TEST_RMG A, TABLE(A.TELEFON) B;
DROP TABLE emp_test_RMG;
DROP TYPE  tip_telefon_RMG;


-- LABORATOR 3
--1
DECLARE 
    V_NR NUMBER(4);
    V_NUME DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    CURSOR C IS 
        SELECT DEPARTMENT_NAME NUME, COUNT(EMPLOYEE_ID) NR
        FROM DEPARTMENTS D, EMPLOYEES E 
        WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID (+)
        GROUP BY DEPARTMENT_NAME;
BEGIN
    OPEN C;
    LOOP
        FETCH C INTO V_NUME, V_NR;
        EXIT WHEN C%NOTFOUND;
        IF v_nr=0 THEN
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume||' nu lucreaza angajati');
        ELSIF v_nr=1 THEN
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume|| ' lucreaza un angajat');
        ELSE
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume|| ' lucreaza '|| v_nr||' angajati');
        END IF;
    END LOOP;
    CLOSE C;
END;
/

--2

DECLARE 
    TYPE TAB_NUME IS TABLE OF DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    TYPE TAB_NR IS TABLE OF NUMBER(4);
    CURSOR C IS 
        SELECT DEPARTMENT_NAME NUME, COUNT(EMPLOYEE_ID) NR
        FROM DEPARTMENTS D, EMPLOYEES E 
        WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID (+)
        GROUP BY DEPARTMENT_NAME;
BEGIN
    OPEN C;
    LOOP
        FETCH C BULK COLLECT INTO T_NUME, T_NR;
        EXIT WHEN C%NOTFOUND;
        IF v_nr=0 THEN
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume||' nu lucreaza angajati');
        ELSIF v_nr=1 THEN
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume|| ' lucreaza un angajat');
        ELSE
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume|| ' lucreaza '|| v_nr||' angajati');
        END IF;
    END LOOP;
    CLOSE C;
END;
/

-- 3 CICLU CURSOR
DECLARE 
    CURSOR  C IS 
        SELECT DEPARTMENT_NAME NUME, COUNT(EMPLOYEE_ID) NR
        FROM DEPARTMENTS D, EMPLOYEES E
        WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID(+)
        GROUP BY DEPARTMENT_NAME;
BEGIN 
    FOR I IN C LOOP
        IF I.NR = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||' nu lucreaza angajati');
        ELSIF i.nr=1 THEN
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume ||' lucreaza un angajat');
        ELSE
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||' lucreaza '|| i.nr||' angajati');
        END IF;
    END LOOP;
END;
/
    
--4 CICLU CURSOR CU SUBCERERI

BEGIN
    FOR I IN (SELECT DEPARTMENT_NAME NUME, COUNT(EMPLOYEE_ID) NR
                FROM DEPARTMENTS D, EMPLOYEES E
                WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID(+)
                GROUP BY DEPARTMENT_NAME) LOOP
         IF I.NR = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||' nu lucreaza angajati');
        ELSIF i.nr=1 THEN
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume ||' lucreaza un angajat');
        ELSE
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||' lucreaza '|| i.nr||' angajati');
        END IF;
    END LOOP;
END;
/

--5 PRIMII 3 MANAGERI CU CEI MAI MULTI SUBORDONATI
DECLARE 
    V_COD EMPLOYEES.EMPLOYEE_ID%TYPE;
    V_NUME EMPLOYEES.LAST_NAME%TYPE;
    V_NR NUMBER(4);
    CURSOR C IS 
        SELECT SEF.EMPLOYEE_ID COD, MAX(SEF.LAST_NAME) NUME, COUNT(*) NR
        FROM EMPLOYEES SEF, EMPLOYEES ANG
        WHERE ANG.MANAGER_ID = SEF.EMPLOYEE_ID
        GROUP BY SEF.EMPLOYEE_ID
        ORDER BY NR DESC;
BEGIN
    OPEN C;
        LOOP
            FETCH C INTO V_COD, V_NUME, V_NR;
            EXIT WHEN C%ROWCOUNT>3 OR C%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Managerul '|| v_cod ||' avand numele ' || v_nume || ' conduce ' || v_nr||' angajati');
        END LOOP;
    CLOSE C;
END;
/

-- 8 DEPARTAMENTELE LA CARE LUCREAZA CEL PUTIN X ANGAJATI
DECLARE 
    V_X NUMBER(4) := &P_X;
    V_NR NUMBER(4);
    V_NUME DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    CURSOR C (PARAMETRU NUMBER) IS
        SELECT DEPARTMENT_NAME NUME, COUNT(EMPLOYEE_ID) NR
        FROM DEPARTMENTS D, EMPLOYEES E
        WHERE d.department_id=e.department_id
        GROUP BY department_name
        HAVING COUNT(EMPLOYEE_ID) < PARAMETRU;
BEGIN
    OPEN C(V_X);
    LOOP
        FETCH C INTO V_NUME, V_NR;
        EXIT WHEN C%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume|| ' lucreaza '|| v_nr||' angajati');
    END LOOP;
    CLOSE C;
END;
/

--9 
SELECT *
FROM EMP_RMG;
SELECT *
        FROM EMP_RMG
        WHERE TO_CHAR(HIRE_DATE, 'YYYY') = 2000;
DECLARE 
    CURSOR C IS 
        SELECT *
        FROM EMP_RMG
        WHERE TO_CHAR(HIRE_DATE, 'YYYY') = 2000
        FOR UPDATE OF SALARY NOWAIT;
BEGIN 
    FOR I IN C LOOP
        UPDATE EMP_RMG
        SET SALARY = SALARY + 1000
        WHERE CURRENT OF C;        
    END LOOP;
END;
/

--10
-- numele departamentului si lista angajatilor


-- NUMELE DEPARTAMENTULUI SI LISTA ANGAJATILOR
-- CICLU CURSOR CU SUBCERERI

BEGIN
    FOR v_dept IN (SELECT department_id, department_name
                    FROM departments
                    WHERE department_id IN (10,20,30,40))
            LOOP
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||v_dept.department_name);
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            FOR v_emp IN (SELECT last_name
                            FROM employees
                            WHERE department_id = v_dept.department_id)
                LOOP
                DBMS_OUTPUT.PUT_LINE (v_emp.last_name);
                END LOOP;
            END LOOP;
END;
/

DECLARE 
    CURSOR C_DEPT IS
        SELECT department_id, department_name
        FROM departments
        WHERE department_id IN (10,20,30,40);

BEGIN
    FOR I IN C_DEPT LOOP
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||I.department_name);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        FOR V_EMP IN ( SELECT LAST_NAME
                        FROM EMPLOYEES
                        WHERE EMPLOYEES.DEPARTMENT_ID = I.DEPARTMENT_ID) LOOP
               DBMS_OUTPUT.PUT_LINE (v_emp.last_name);   
        END LOOP;
    END LOOP; 
END;
/
-- 
DECLARE 
    CURSOR C_DEPT IS
        SELECT department_id, department_name
        FROM departments
        WHERE department_id IN (10,20,30,40);
 
        
BEGIN
    FOR I IN C_DEPT LOOP
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||I.department_name);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        FOR V_EMP IN ( SELECT LAST_NAME
                        FROM EMPLOYEES
                        WHERE EMPLOYEES.DEPARTMENT_ID = I.DEPARTMENT_ID) LOOP
               DBMS_OUTPUT.PUT_LINE (v_emp.last_name);   
        END LOOP;
    END LOOP; 
END;
/

-- EXPRESII CURSOR
DECLARE 
    TYPE REFCURSOR IS REF CURSOR ;
    CURSOR C_DEPT IS 
        SELECT DEPARTMENT_NAME,
                CURSOR ( SELECT LAST_NAME
                         FROM EMPLOYEES E
                         WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID )
        FROM DEPARTMENTS D
        WHERE DEPARTMENT_ID IN (10, 20, 30, 40);
    V_NUME_DEPT     DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    V_CURSOR        REFCURSOR;
    V_NUME_EMP      EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    OPEN C_DEPT;
    LOOP
        FETCH C_DEPT INTO V_NUME_DEPT, V_CURSOR;
        EXIT WHEN C_DEPT%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||v_nume_dept);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        LOOP
            FETCH V_CURSOR INTO V_NUME_EMP;
            EXIT WHEN V_CURSOR%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE (v_nume_emp);
        END LOOP;
    END LOOP;
    CLOSE C_DEPT;
END;
/

--11
DECLARE
    --TYPE EMP_TIP IS REF CURSOR RETURN EMPLOYEES%ROWTYPE;
    -- SAU 
    TYPE EMP_TIP IS REF CURSOR;
    V_EMP       EMP_TIP;
    V_OPTIUNE   NUMBER := &P_OPTIUNE;
    V_ANG       EMPLOYEES%ROWTYPE;
BEGIN
    IF V_OPTIUNE = 1 THEN 
        OPEN V_EMP FOR SELECT *
                        FROM EMPLOYEES;
    ELSIF V_OPTIUNE = 2 THEN 
        OPEN V_EMP FOR SELECT *
                        FROM EMPLOYEES
                        WHERE SALARY BETWEEN 10000 AND 20000;
    ELSIF v_optiune = 3 THEN
        OPEN v_emp FOR SELECT *
                    FROM employees
                    WHERE TO_CHAR(hire_date, 'YYYY') = 2000;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Optiune incorecta');
    END IF;
    
    LOOP
        FETCH V_EMP INTO V_ANG;
        EXIT WHEN V_EMP%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_ang.last_name);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Au fost procesate '||v_emp%ROWCOUNT
                        || ' linii');
   CLOSE v_emp;
END;
/
    
--TEMA 
--1 PENTRU FIECARE JOB NUMELE SI SALARIUL OAMENILOR
--A
SELECT *
FROM JOBS;
SELECT *
FROM EMPLOYEES;
DECLARE 
    CURSOR C (JOB_CURENT JOBS.JOB_ID%TYPE) IS
        SELECT E.LAST_NAME, E.FIRST_NAME, E.SALARY
        FROM EMPLOYEES E, JOBS J
        WHERE J.JOB_ID = E.JOB_ID AND J.JOB_ID = JOB_CURENT;
    
    NUMAR_JOBURI NUMBER;
    TITLU_JOB JOBS.JOB_TITLE%TYPE;
    NUME_ANGAJAT EMPLOYEES.LAST_NAME%TYPE;
    PRENUME_ANGAJAT EMPLOYEES.FIRST_NAME%TYPE;
    SALARIU EMPLOYEES.SALARY%TYPE;
    
    TYPE TIP_JOBURI IS TABLE OF JOBS.JOB_ID%TYPE;
    JOBURI TIP_JOBURI := TIP_JOBURI();
    COUNTER NUMBER(5);
    
BEGIN
    SELECT COUNT(*)
    INTO NUMAR_JOBURI
    FROM JOBS;
    -- II ALOCAM MEMORIE 
    JOBURI.EXTEND(NUMAR_JOBURI);
    -- PUNEM IN VECTOR ID-URILE DE JOBURI
    SELECT J.JOB_ID BULK COLLECT 
    INTO JOBURI
    FROM JOBS J;
    -- SE PARCURG ID-URILE
    FOR I IN JOBURI.FIRST .. JOBURI.LAST LOOP
        
        SELECT JOB_TITLE
        INTO TITLU_JOB 
        FROM JOBS J
        WHERE J.JOB_ID = JOBURI(I);
        DBMS_OUTPUT.PUT_LINE(TITLU_JOB);
        COUNTER := 0;
        
        OPEN C(JOBURI(I));
        LOOP
            FETCH C INTO NUME_ANGAJAT, PRENUME_ANGAJAT, SALARIU;
            EXIT WHEN C%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(NUME_ANGAJAT || ' ' || PRENUME_ANGAJAT || ' ' || SALARIU);
            COUNTER := COUNTER + 1;
        END LOOP;
        
        CLOSE C;
        IF COUNTER = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('NU EXISTA ANGAJAT IN' || TITLU_JOB );
        END IF;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/

--B

DECLARE 
    CURSOR C (JOB_CURENT JOBS.JOB_ID%TYPE) IS
        SELECT E.LAST_NAME, E.FIRST_NAME, E.SALARY
        FROM EMPLOYEES E, JOBS J
        WHERE J.JOB_ID = E.JOB_ID AND J.JOB_ID = JOB_CURENT;
    
    NUMAR_JOBURI NUMBER;
    TITLU_JOB JOBS.JOB_TITLE%TYPE;
    NUME_ANGAJAT EMPLOYEES.LAST_NAME%TYPE;
    PRENUME_ANGAJAT EMPLOYEES.FIRST_NAME%TYPE;
    SALARIU EMPLOYEES.SALARY%TYPE;
    
    TYPE TIP_JOBURI IS TABLE OF JOBS.JOB_ID%TYPE;
    JOBURI TIP_JOBURI := TIP_JOBURI();
    COUNTER NUMBER(5);
    
BEGIN
    SELECT COUNT(*)
    INTO NUMAR_JOBURI
    FROM JOBS;
    -- II ALOCAM MEMORIE 
    JOBURI.EXTEND(NUMAR_JOBURI);
    -- PUNEM IN VECTOR ID-URILE DE JOBURI
    SELECT J.JOB_ID BULK COLLECT 
    INTO JOBURI
    FROM JOBS J;
    -- SE PARCURG ID-URILE
    FOR I IN JOBURI.FIRST .. JOBURI.LAST LOOP
        
        SELECT JOB_TITLE
        INTO TITLU_JOB 
        FROM JOBS J
        WHERE J.JOB_ID = JOBURI(I);
        DBMS_OUTPUT.PUT_LINE(TITLU_JOB);
        COUNTER := 0;
        
        FOR J IN C(JOBURI(I)) LOOP
            EXIT WHEN C%NOTFOUND;
            DBMS_OUTPUT.put_line(j.fIRST_name || ' ' || j.lAST_name || ' ' || j.salary);
            counter := counter + 1;
        END LOOP;
        
        IF COUNTER = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('NU EXISTA ANGAJAT IN' || TITLU_JOB );
        END IF;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/

--C


DECLARE 
    CURSOR C (JOB_CURENT JOBS.JOB_ID%TYPE) IS
        SELECT E.LAST_NAME, E.FIRST_NAME, E.SALARY
        FROM EMPLOYEES E, JOBS J
        WHERE J.JOB_ID = E.JOB_ID AND J.JOB_ID = JOB_CURENT;
    
    NUMAR_JOBURI NUMBER;
    TITLU_JOB JOBS.JOB_TITLE%TYPE;
    NUME_ANGAJAT EMPLOYEES.LAST_NAME%TYPE;
    PRENUME_ANGAJAT EMPLOYEES.FIRST_NAME%TYPE;
    SALARIU EMPLOYEES.SALARY%TYPE;
    
    TYPE TIP_JOBURI IS TABLE OF JOBS.JOB_ID%TYPE;
    JOBURI TIP_JOBURI := TIP_JOBURI();
    COUNTER NUMBER(5);
    
BEGIN
    SELECT COUNT(*)
    INTO NUMAR_JOBURI
    FROM JOBS;
    -- II ALOCAM MEMORIE 
    JOBURI.EXTEND(NUMAR_JOBURI);
    -- PUNEM IN VECTOR ID-URILE DE JOBURI
    SELECT J.JOB_ID BULK COLLECT 
    INTO JOBURI
    FROM JOBS J;
    -- SE PARCURG ID-URILE
    FOR I IN JOBURI.FIRST .. JOBURI.LAST LOOP
        
        SELECT JOB_TITLE
        INTO TITLU_JOB 
        FROM JOBS J
        WHERE J.JOB_ID = JOBURI(I);
        DBMS_OUTPUT.PUT_LINE(TITLU_JOB);
        COUNTER := 0;
        
        FOR K IN (SELECT E.LAST_NAME L_NAME, E.FIRST_NAME F_NAME, E.SALARY SALARY
                    FROM EMPLOYEES E, JOBS J
                    WHERE J.JOB_ID = E.JOB_ID AND J.JOB_ID = JOBURI(I) ) LOOP
                DBMS_OUTPUT.put_line(K.f_name || ' ' || K.l_name || ' ' || K.salary);            
                counter := counter + 1;
        END LOOP;
        
        IF COUNTER = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('NU EXISTA ANGAJAT IN' || TITLU_JOB );
        END IF;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/

--D  EXPRESII CURSOR 
DECLARE
    TYPE REFCURSOR IS REF CURSOR ;
    CURSOR C IS
        SELECT J2.JOB_TITLE, CURSOR
            (SELECT E.LAST_NAME, E.FIRST_NAME, E.SALARY
            FROM EMPLOYEES E, JOBS J
            WHERE J.JOB_ID = E.JOB_ID AND J.JOB_ID = J2.JOB_ID)
        FROM JOBS J2;
    --titlu_job jobs.job_title%TYPE;
    nume_angajat employees.first_name%TYPE;
    prenume_angajat employees.last_name%TYPE;
    salariu employees.salary%TYPE;
    titlu_job jobs.job_title%TYPE;
    referinta_cursor refcursor;
    counter NUMBER(5);
BEGIN
    OPEN C;
    LOOP
        FETCH C INTO TITLU_JOB, REFERINTA_CURSOR;
        EXIT WHEN C%NOTFOUND;
        DBMS_OUTPUT.put_line(titlu_job);
        LOOP 
            FETCH REFERINTA_CURSOR INTO NUME_ANGAJAT, PRENUME_ANGAJAT, SALARIU;
            EXIT WHEN REFERINTA_CURSOR%NOTFOUND;
            DBMS_OUTPUT.put_line(nume_angajat || ' ' || prenume_angajat || ' ' || salariu);
        END LOOP;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/

--2 OBTINERE NUMAR DE ORDINE PENTRU FIECARE ANGAJAT
--2
DECLARE 
    TYPE tip_joburi IS TABLE OF jobs.job_id%TYPE;
    CURSOR c (job_curent jobs.job_id%TYPE)IS 
        SELECT e.last_name, e.first_name, e.salary
        FROM employees e, jobs j
        WHERE j.job_id = e.job_id and
                j.job_id = job_curent;
                    numar_joburi NUMBER;
    titlu_job jobs.job_title%TYPE;
    nume_angajat employees.first_name%TYPE;
    prenume_angajat employees.last_name%TYPE;
    salariu employees.salary%TYPE;
    joburi tip_joburi := tip_joburi();
    numar_salariati NUMBER(5);
    counter NUMBER(5);
    salariu_total_job NUMBER(8,2);
    salariu_mediu_job NUMBER(8,2);
    salariu_total NUMBER(10,2) := 0;
    salariu_mediu NUMBER(10,2) := 0;
    counter_total NUMBER(5) := 0;
BEGIN
    select count(*) into numar_joburi from jobs;
    joburi.EXTEND(numar_joburi);
    select j.job_id bulk collect into joburi from jobs j;
    
    FOR i IN joburi.FIRST..joburi.LAST LOOP   
    
        SELECT job_title
        INTO titlu_job
        FROM jobs j
        WHERE j.job_id = joburi(i);     
        counter := 0;
        salariu_total_job := 0;
        
        SELECT count(*)
        INTO numar_salariati
        FROM employees e, jobs j
        WHERE e.job_id = j.job_id and
            j.job_id = joburi(i);
        
        IF numar_salariati = 0 THEN
            DBMS_OUTPUT.put_line('Nu lucreaza niciun angajat pe postul de ' || titlu_job);
        ELSIF numar_salariati = 1 THEN
            DBMS_OUTPUT.put_line('Un angajat lucreaza ca ' || titlu_job);
        ELSIF numar_salariati < 20 THEN
            DBMS_OUTPUT.put_line(numar_salariati || ' angajati lucreaza ca ' || titlu_job);
        ELSE
            DBMS_OUTPUT.put_line(numar_salariati || ' de angajati lucreaza ca ' || titlu_job);
        END IF;
        
        OPEN c(joburi(i));
        LOOP
            FETCH c INTO nume_angajat, prenume_angajat, salariu;
            EXIT WHEN c%NOTFOUND;
            DBMS_OUTPUT.put_line(counter + 1 || ' ' || nume_angajat || ' ' || prenume_angajat || ' ' || salariu);
            counter := counter + 1;
            salariu_total_job := salariu_total_job + salariu;
            counter_total := counter_total + 1;
        END LOOP;
        CLOSE c;
        
        salariu_total := salariu_total + salariu_total_job;
        IF counter = 0 THEN 
            DBMS_OUTPUT.put_line('Nu exista niciun angajat.');
        ELSE
            salariu_mediu_job := salariu_total_job / counter;
            DBMS_OUTPUT.put_line('Salariul total al angajatilor este ' || salariu_total_job || ' iar cel mediu este ' || salariu_mediu_job);
        END IF;
        DBMS_OUTPUT.new_line();
    END LOOP;
    salariu_mediu := salariu_total / counter_total;
    DBMS_OUTPUT.put_line('Salariul total al tuturor angajatilor este ' || salariu_total || ' iar cel mediu este ' || salariu_mediu);
END;
/


--4
DECLARE 
    TYPE tip_joburi IS TABLE OF jobs.job_id%TYPE;
    CURSOR c (job_curent jobs.job_id%TYPE)IS 
        SELECT e.last_name, e.first_name, e.salary, e.commission_pct
        FROM employees e, jobs j
        WHERE j.job_id = e.job_id and
                j.job_id = job_curent
        ORDER BY e.salary DESC; 
    numar_joburi NUMBER;
    titlu_job jobs.job_title%TYPE;
    nume_angajat employees.first_name%TYPE;
    prenume_angajat employees.last_name%TYPE;
    salariu employees.salary%TYPE;
    joburi tip_joburi := tip_joburi();
    numar_salariati NUMBER(5);
    counter NUMBER(5);
    salariu_total_job NUMBER(8,2);
    salariu_mediu_job NUMBER(8,2);
    salariu_total NUMBER(10,2) := 0;
    salariu_mediu NUMBER(10,2) := 0;
    counter_total NUMBER(5) := 0;
    procentaj_comision NUMBER(5) := 0;
    total_cu_comision NUMBER(10,2) := 0;
BEGIN  
    
    select count(*) into numar_joburi from jobs;
    joburi.EXTEND(numar_joburi);
    select j.job_id bulk collect into joburi from jobs j;
    
    FOR i IN joburi.FIRST..joburi.LAST LOOP   
        counter := 0;
        SELECT job_title
        INTO titlu_job
        FROM jobs j
        WHERE j.job_id = joburi(i); 
        
        SELECT count(*)
        INTO numar_salariati
        FROM employees e, jobs j
        WHERE e.job_id = j.job_id and
            j.job_id = joburi(i);

        IF numar_salariati < 5 THEN
            DBMS_OUTPUT.put_line('Lucreaza mai putin de 5 angajati ca  ' || titlu_job);
        ELSE
            DBMS_OUTPUT.put_line(titlu_job);
        END IF;
        
        OPEN c(joburi(i));
        LOOP
            FETCH c INTO nume_angajat, prenume_angajat, salariu, procentaj_comision;
            EXIT WHEN c%NOTFOUND or c%ROWCOUNT > 5;
            DBMS_OUTPUT.put_line(counter + 1 || ' ' || nume_angajat || ' ' || prenume_angajat || ' ' || salariu);
            counter := counter + 1;
        END LOOP;
        CLOSE c;
         
        DBMS_OUTPUT.new_line();
    END LOOP;
END;
/
 
--5
DECLARE 
    TYPE tip_joburi IS TABLE OF jobs.job_id%TYPE;
    CURSOR c (job_curent jobs.job_id%TYPE)IS 
        SELECT e.last_name, e.first_name, e.salary, e.commission_pct
        FROM employees e, jobs j
        WHERE j.job_id = e.job_id and
                j.job_id = job_curent
        ORDER BY e.salary DESC; 
    numar_joburi NUMBER;
    titlu_job jobs.job_title%TYPE;
    nume_angajat employees.first_name%TYPE;
    prenume_angajat employees.last_name%TYPE;
    salariu employees.salary%TYPE;
    joburi tip_joburi := tip_joburi();
    numar_salariati NUMBER(5);
    counter NUMBER(5);
    salariu_total_job NUMBER(8,2);
    salariu_mediu_job NUMBER(8,2);
    salariu_total NUMBER(10,2) := 0;
    salariu_mediu NUMBER(10,2) := 0;
    counter_total NUMBER(5) := 0;
    procentaj_comision NUMBER(5) := 0;
    total_cu_comision NUMBER(10,2) := 0;
    salariu_angajat employees.salary%TYPE;
BEGIN  
    
    select count(*) into numar_joburi from jobs;
    joburi.EXTEND(numar_joburi);
    select j.job_id bulk collect into joburi from jobs j;
    
    FOR i IN joburi.FIRST..joburi.LAST LOOP   
        salariu_angajat := 0;
        counter := 0;
        SELECT job_title
        INTO titlu_job
        FROM jobs j
        WHERE j.job_id = joburi(i); 
        
        SELECT count(*)
        INTO numar_salariati
        FROM employees e, jobs j
        WHERE e.job_id = j.job_id and
            j.job_id = joburi(i);

        IF numar_salariati < 5 THEN
            DBMS_OUTPUT.put_line('Lucreaza mai putin de 5 angajati ca  ' || titlu_job);
        ELSE
            DBMS_OUTPUT.put_line(titlu_job);
        END IF;
        
        OPEN c(joburi(i));
        LOOP
            FETCH c INTO nume_angajat, prenume_angajat, salariu, procentaj_comision;
            EXIT WHEN c%NOTFOUND or c%ROWCOUNT > 5;
            IF salariu_angajat = 0 or salariu <> salariu_angajat THEN
                salariu_angajat := salariu;
                counter := counter + 1;
            END IF;
            DBMS_OUTPUT.put_line(counter || ' ' || nume_angajat || ' ' || prenume_angajat || ' ' || salariu);
        END LOOP;
        CLOSE c;
         
        DBMS_OUTPUT.new_line();
    END LOOP;
END;
/


-- LABORATOR 4 PL/SQL
-- proceduri 

-- 1 SALARIUL UNUI ANGAJAT AL CARUI NUME ESTE SPECIFICAT
-- functie locala 
DECLARE 
    V_NUME  EMPLOYEES.LAST_NAME%TYPE := INITCAP('&P_NUME');
    FUNCTION F1 RETURN NUMBER IS SALARIU EMPLOYEES.SALARY%TYPE;
    BEGIN
    SELECT SALARY 
    INTO SALARIU
    FROM EMPLOYEES
    WHERE LAST_NAME = V_NUME;
    RETURN SALARIU;
    
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
             DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat');
        WHEN TOO_MANY_ROWS THEN 
             DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati '|| 'cu numele dat');
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('ALTA EROARE!');
    END F1;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('SALARIUL ESTE ' || F1);
END;
/

--2 functie stocata
CREATE OR REPLACE FUNCTION F2_RMG
    (V_NUME EMPLOYEES.LAST_NAME%TYPE DEFAULT 'Bell')
RETURN NUMBER IS 
    SALARIU EMPLOYEES.SALARY%TYPE;
    BEGIN 
        SELECT SALARY
        INTO SALARIU
        FROM EMPLOYEES
        WHERE LAST_NAME = V_NUME;
        RETURN SALARIU;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            RAISE_APPLICATION_ERROR(-20000,'Nu exista angajati cu numele dat');
        WHEN TOO_MANY_ROWS THEN 
            RAISE_APPLICATION_ERROR(-20001,'Exista mai multi angajati cu numele dat');
        WHEN OTHERS THEN 
            RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END F2_RMG;
/
-- SE AFISEAZA PENTRU CEL DEFAULT 
BEGIN
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| F2_RMG);
END;
/
-- EROARE TOO MANY ROWS
BEGIN
 DBMS_OUTPUT.PUT_LINE('Salariul este '|| F2_RMG('King'));
END;
/

--SQL
SELECT F2_RMG FROM DUAL;
SELECT F2_RMG('King')
FROM DUAL;

-- SQL PLUS CU VARIABILA HOST
VARIABLE NR NUMBER
EXECUTE :NR := F2_RMG('Bell');
PRINT NR

-- 3 procedura locala 
-- varianta 1
DECLARE
    V_NUME EMPLOYEES.LAST_NAME%TYPE := INITCAP('&P_NUME');
    
    PROCEDURE P3
    IS 
        SALARIU EMPLOYEES.SALARY%TYPE;
    BEGIN
        SELECT SALARY
        INTO SALARIU
        FROM EMPLOYEES
        WHERE LAST_NAME = V_NUME;
        DBMS_OUTPUT.PUT_LINE('SALARIU ESTE ' || SALARIU);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati '|| 'cu numele dat');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Alta eroare!');
    END P3;
BEGIN 
    P3;
END;
/

--4 procedura stocata 
--varianta 1
CREATE OR REPLACE PROCEDURE P4_RMG(V_NUME EMPLOYEES.LAST_NAME%TYPE)
    IS SALARIU EMPLOYEES.SALARY%TYPE;
    BEGIN 
        SELECT SALARY 
        INTO SALARIU
        FROM EMPLOYEES
        WHERE LAST_NAME = V_NUME;
        DBMS_OUTPUT.PUT_LINE('SALARIUL ESTE ' || SALARIU);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000,'Nu exista angajati cu numele dat');
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20001,'Exista mai multi angajati cu numele dat');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
    END P4_RMG;
/
--METODE DE APELARE 
-- 1 BLOC PL SQL
BEGIN 
    P4_RMG('Bell');
END;
/

--2. sql plus
EXECUTE P4_RMG('Bell');  -- afisa salariu
EXECUTE P4_RMG('King'); -- mai multi 
EXECUTE P4_RMG('Kimball'); -- nu exista

-- varianta 2 de procedura stocata
CREATE OR REPLACE PROCEDURE P4_RMG(V_NUME IN EMPLOYEES.LAST_NAME%TYPE,
                                    SALARIU OUT EMPLOYEES.SALARY%TYPE) IS
    BEGIN
        SELECT SALARY
        INTO SALARIU
        FROM EMPLOYEES
        WHERE LAST_NAME = V_NUME;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20000,
                'Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20001,
'Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
  END P4_RMG;
  /
-- metode apelare -- 1. Bloc PLSQL DECLARE
DECLARE
   v_salariu employees.salary%type;
BEGIN
  p4_RMG('Bell',v_salariu);
  DBMS_OUTPUT.PUT_LINE('Salariul este '|| v_salariu);
END;
/
-- 2. SQL*PLUS
VARIABLE v_sal NUMBER
EXECUTE p4_RMG ('Bell',:v_sal)
PRINT v_sal

--5 PROCEDURA STOCATA CARE PRIMESTE CODUL UNUI ANGAJAT SI RETURNEAZA PRIN 
--  ACELASI PARAMETRU NUMELE MANAGERULUI
CREATE OR REPLACE PROCEDURE P5_RMG ( NR IN OUT NUMBER) IS 
BEGIN 
    SELECT MANAGER_ID 
    INTO NR
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = NR;
END P5_RMG;
/
VARIABLE ANG_MAN NUMBER 
BEGIN 
    :ANG_MAN := 200;
END;
/
EXECUTE P5_RMG(:ANG_MAN)
PRINT ANG_MAN;

SELECT EMPLOYEE_ID, LAST_NAME
FROM EMPLOYEES 
WHERE EMPLOYEE_ID =200;

-- 6 PROCEDURA LOCALA
-- REZULTAT = LAST_NAME DIN EMPLOYEES
DECLARE
    NUME EMPLOYEES.LAST_NAME%TYPE;
    PROCEDURE P6 ( REZULTAT OUT EMPLOYEES.LAST_NAME%TYPE,
                   COMISION IN EMPLOYEES.commission_pct%TYPE:=NULL,
                   COD      IN EMPLOYEES.EMPLOYEE_ID%TYPE:=NULL)
    IS
    BEGIN
        IF (COMISION IS NOT NULL) THEN
            SELECT last_name 
            INTO REZULTAT
            FROM EMPLOYEES 
            WHERE COMMISSION_PCT = COMISION;
            DBMS_OUTPUT.PUT_LINE('numele salariatului care are comisionul '||comision||' este '||rezultat);
        else
            SELECT LAST_NAME 
            INTO REZULTAT
            FROM EMPLOYEES
            WHERE EMPLOYEE_ID = COD;
            DBMS_OUTPUT.PUT_LINE('numele salariatului avand codul '|| cod ||' este '||rezultat);
        END IF;
    END P6;
BEGIN 
    P6(NUME, 0.4);
    P6(NUME, COD=>200);
END;
/
--7
DECLARE 
    MEDIE1 NUMBER(10, 2);
    MEDIE2 NUMBER(10, 2);
    -- PRIMA FUNCTIE, CEA CARE PRIMESTE DOAR ID DE DEPARTAMENT
    FUNCTION MEDIE (V_DEPT EMPLOYEES.DEPARTMENT_ID%TYPE)
        RETURN NUMBER IS
        REZULTAT NUMBER (10, 2);
    BEGIN
        SELECT AVG(SALARY)
        INTO REZULTAT
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID = V_DEPT;
        RETURN REZULTAT;
    END;
    
    -- FUNCTIA CU 2 PARAMETRII
    FUNCTION MEDIE (V_DEPT EMPLOYEES.DEPARTMENT_ID%TYPE,
                    V_JOB EMPLOYEES.JOB_ID % TYPE)
            RETURN NUMBER IS 
            REZULTAT NUMBER(10, 2);
        BEGIN
            SELECT AVG(SALARY)
            INTO REZULTAT
            FROM EMPLOYEES
            WHERE DEPARTMENT_ID = V_DEPT && V_JOB = JOB_ID;
            RETURN REZULTAT;
        END;
BEGIN
    MEDIE := MEDIE(80);
    DBMS_OUTPUT.PUT_LINE('Media salariilor din departamentul 80'
      || ' este ' || medie1);
  medie2 := medie(80,'SA_MAN');
  DBMS_OUTPUT.PUT_LINE('Media salariilor managerilor din'
      || ' departamentul 80 este ' || medie2);
END;
/

-- 8 FACTORIALUL UNUI NUMAR - RECURSIVITATE
CREATE OR REPLACE FUNCTION FACTORIAL_RMG ( N NUMBER)
    RETURN INTEGER IS
    
    BEGIN
        IF (N = 0) THEN
            RETURN 1;
        ELSE 
            RETURN N * FACTORIAL_RMG(N-1);
        END IF;
END FACTORIAL_RMG;
/
DECLARE 
    NR INTEGER := 4;
BEGIN
    DBMS_OUTPUT.PUT_LINE('FACTORIALUL NUMARULUI ' || NR || ' ESTE ' || FACTORIAL_RMG(4));
END;
/

--9 NUMELE SI SALARIU ANGAJATILOR CU SALARIU PESTE CEL MEDIU
CREATE OR REPLACE FUNCTION MEDIE_RMG
RETURN NUMBER 
IS 
REZULTAT NUMBER;
BEGIN
    SELECT AVG(SALARY)
    INTO REZULTAT
    FROM EMPLOYEES;
    RETURN REZULTAT;
END;
/
SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY >= MEDIE_RMG;
    
-- EXERCITII LABOAROTOR 4
-- Creați tabelul info_*** cu următoarele coloane:
-- utilizator (numele utilizatorului care a inițiat o comandă)
-- data (data și timpul la care utilizatorul a inițiat comanda)
-- comanda (comanda care a fost inițiată de utilizatorul respectiv)
-- nr_linii (numărul de linii selectate/modificate de comandă)
-- eroare (un mesaj pentru excepții).
CREATE TABLE INFO_RMG (
    ID NUMBER (10, 2 ) PRIMARY KEY,
    UTILIZATOR VARCHAR2(50),
    DATA DATE,
    COMANDA VARCHAR2(100),
    NR_LINII NUMBER,
    EROARE VARCHAR2(50)
    );
--2 
create or REPLACE FUNCTION F2_RMG (NUME EMPLOYEES.LAST_NAME%TYPE)
    RETURN NUMBER IS 
        IDD NUMBER (10, 2) := 1;
        SALARIU  NUMBER(10, 2);
        DATA1    DATE;
        UTILIZATOR VARCHAR2(50);
        EROARE VARCHAR2(50);
        NR_LINII NUMBER;
BEGIN
    SELECT USER 
    INTO UTILIZATOR 
    FROM DUAL;
    
    SELECT SYSDATE
    INTO DATA1
    FROM DUAL;
    
    SELECT COUNT(*)
    INTO NR_LINII
    FROM EMPLOYEES
    WHERE LAST_NAME = NUME ;
    
    SELECT SALARY 
    INTO SALARIU
    FROM EMPLOYEES
    WHERE LOWER(LAST_NAME) = LOWER(NUME);
    
    INSERT INTO INFO_RMG VALUES (IDD, UTILIZATOR, DATA1, 'SELECT', 1, 'SUCCES');
    IDD := IDD + 1;
    RETURN SALARIU;
    
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat');
            EROARE := SUBSTR(SQLERRM, 1, 90); -- EROARE SQL
            INSERT INTO INFO_RMG (IDD, UTILIZATOR, DATA1, 'SELECT', 0, EROARE);
            IDD := IDD + 1;
            RETURN -1;
        WHEN TOO_MANY_ROWS THEN
            EROARE := SUBSTR(SQLERRM, 1, 90);
            --INSERT INTO INFO_RMG (utilizator, data1, 'SELECT', NR_LINII, EROARE);
            RAISE_APPLICATION_ERROR(-20000, 'Exista mai multi angajati cu numele dat');
            return -2;
        WHEN OTHERS THEN 
            EROARE := SUBSTR(SQLERRM, 1, 90);
            --INSERT INTO INFO_RMG(utilizator, data1, 'SELECT', NR_LINII, EROARE);
            RAISE_APPLICATION_ERROR(-20001, 'Alta eroare');
END F2_RMG;
/
           
           
           
           
SELECT *
FROM EMPLOYEES;
SELECT *
FROM LOCATIONS;
SELECT *
FROM LOCATIONS;
-- 3. FUNCTIE STOCATA 
-- DETERM NUMARUL DE ANGAJATI CARE AU AVUT CEL PUTIN 2 JOBURI SI LUCREAZA INTR-UN ORAS DAT CA PARAMETRU

CREATE OR REPLACE FUNCTON F3_FIND_RMG (ORAS LOCATIONS.CITY%TYPE)
RETURN NUMBER IS
    V_RASPUNS NUMBER(5);
    V_ERROR VARCHAR2(50);
    V_UTILIZATOR VARCHAR2(50);
    BEGIN
        SELECT USER 
        INTO V_UTILIZATOR
        FROM DUAL;
        
        V_RASPUNS := 5;

    RETURN v_raspuns;
END;
/       
                        
                        

-- 1
CREATE TABLE info_bhd(
    ID          NUMBER(10, 2) PRIMARY KEY,
    utilizator  VARCHAR2(50),
    data        DATE,
    comanda     VARCHAR2(100),
    nr_linii    NUMBER,
    eroare      VARCHAR2(50));
/
-- 3
SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION find_employees_bhd (
    oras locations.city%TYPE
) RETURN NUMBER IS
    v_raspuns         NUMBER;
    v_error         VARCHAR2(100);
    v_utilizator  info_bhd.utilizator%TYPE;
BEGIN
    SELECT user INTO v_utilizator FROM dual;

    IF oras IS NULL THEN
        INSERT INTO info_bhd VALUES (
            (
                SELECT
                    nvl(MAX(id), 0) + 1
                FROM
                    info_bhd
            ),
            v_utilizator,
            sysdate,
            NULL,
            0,
            'Oras null'
        );

        RETURN 0;
    END IF;

    SELECT COUNT(*)
    INTO v_raspuns
    FROM employees e
    JOIN departments d ON (e.department_id = d.department_id)
    JOIN locations l ON (l.location_id = d.location_id)
    WHERE
        (SELECT COUNT(*) FROM job_history WHERE employee_id = e.employee_id ) >= 1;
    IF v_raspuns = 0 THEN
        v_error := 'Niciun angajat gasit';
    END IF;
    INSERT INTO info_bhd VALUES (
        (
            SELECT
                nvl(MAX(id), 0) + 1
            FROM
                info_bhd
        ),
        v_utilizator,
        sysdate,
        NULL,
        0,
        v_error
    );

    RETURN v_raspuns;
END;
/
variable x number
execute :x := find_employees_bhd('New York');
execute :x := find_employees_bhd('London');
execute :x := find_employees_bhd('Bucuresti');
execute :x := find_employees_bhd('Oradea');
execute :x := find_employees_bhd('Beijing');

select *
from info_bhd;
select *
from job_history;

--4
-- se maresc cu 10% salariile tuturor anj condusi direct sau indirect de un manager dat ca param
CREATE OR REPLACE PROCEDURE P4_RMG (P_COD EMPLOYEES.EMPLOYEE_ID%TYPE)
IS
    V_NR        NUMBER(5);
    V_NR_LINII  NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO V_NR 
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = P_COD;
    
    IF V_NR = 0 THEN
        insert into info_BHD values(
        
        (
                SELECT
                    nvl(MAX(id), 0) + 1
                FROM
                    info_bhd
            ),
        
        user, sysdate, 'nothing', 
        v_nr, 'Nu exista manager cu codul dat!');
    ELSE 
        UPDATE EMP_RMG
        SET SALARY = SALARY * 1.1
        WHERE MANAGER_ID IN (SELECT EMPLOYEE_ID
                             FROM EMPLOYEES
                             START WITH EMPLOYEE_ID = P_COD
                             CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID);
        V_NR_LINII := SQL%ROWCOUNT;
        
        ROLLBACK;
        
        insert into info_BHD values(
        
        (
                SELECT
                    nvl(MAX(id), 0) + 1
                FROM
                    info_bhd
            ),
        user, sysdate, 'UPDATE', 
        V_NR_LINII, 'NO ERROR');       
    END IF;
END P4_RMG;
/
BEGIN 
    P4_RMG(114);
END;
/
EXECUTE P4_RMG(100);
SELECT *
FROM DEPARTMENTS;
SELECT *
FROM EMPLOYEES;
--5
-- PENTRU FIECARE NUME DE DEPARTAMENT SE RETINE ZIUA DIN SAPT IN CARE AU FOST ANG CELE MAI MULTE PERSOANE 
CREATE OR REPLACE PROCEDURE P5_1 IS 
    CURSOR C_DEPT IS 
        SELECT DEPARTMENT_NAME, ZI, NR_ANG
        FROM DEPARTMENTS 
        LEFT JOIN ( SELECT DEPARTMENT_ID, TO_CHAR(HIRE_DATE, 'D') ZI, COUNT(*) NR_ANG
                    FROM EMPLOYEES E
                    GROUP BY DEPARTMENT_ID, TO_CHAR(HIRE_DATE, 'D')
                    HAVING COUNT(*) = ( SELECT MAX(COUNT(*))
                                        FROM EMPLOYEES
                                        GROUP BY EMPLOYEES.DEPARTMENT_ID, TO_CHAR(HIRE_DATE, 'D')
                                        HAVING DEPARTMENT_ID = E.DEPARTMENT_ID )
                    ) USING (DEPARTMENT_ID);
BEGIN
    FOR LINIE IN C_DEPT LOOP
        IF LINIE.ZI IS NULL THEN
            dbms_output.put_line('In departamentul ' || linie.department_name || ' nu exista angajati');
        ELSE
            dbms_output.put_line('In departamentul ' || linie.department_name ||
                           ', cele mai multe angajari au avut loc in ziua ' ||
                           linie.zi || ' a saptamanii, in numar de ' || 
                           linie.nr_ang || ', dupa cum urmeaza: ');
            FOR angajat IN (SELECT first_name || ' ' || last_name nume,
                             ROUND(SYSDATE - hire_date) vechime,
                             salary * (1 + NVL(commission_pct, 0)) venit
                      FROM employees JOIN departments USING (department_id)
                      WHERE department_name = linie.department_name 
                            AND TO_CHAR(hire_date, 'D') = linie.zi)
      LOOP
        dbms_output.put_line(angajat.nume || ' ' || angajat.vechime 
                             || ' ' || angajat.venit);
     END LOOP;
                             
        END IF;
    END LOOP;
END P5_1;
/

CREATE OR REPLACE PROCEDURE p5_2 IS
  CURSOR c_dept IS
    SELECT department_name, zi, nr_ang
    FROM departments LEFT JOIN (SELECT department_id,
                                       TO_CHAR(hire_date, 'D') zi,
                                       COUNT(*) nr_ang
                                FROM employees e
                                GROUP BY department_id, TO_CHAR(hire_date, 'D')
                                HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                                   FROM employees
                                                   GROUP BY employees.department_id,
                                                            TO_CHAR(hire_date, 'D')
                                                   HAVING department_id = e.department_id)
                                ) USING (department_id);

BEGIN
  FOR linie IN c_dept LOOP
    IF linie.zi IS NULL THEN
      dbms_output.put_line('In departamentul ' || linie.department_name || 
                           ' nu exista angajati');
    ELSE
      dbms_output.put_line('In departamentul ' || linie.department_name || 
                           ', cele mai multe angajari au avut loc in ziua ' 
                           || linie.zi || ' a saptamanii, in numar de ' || 
                           linie.nr_ang || ', dupa cum urmeaza: ');
      FOR angajat IN (SELECT first_name || ' ' || last_name nume,
                             ROUND(SYSDATE - NVL((SELECT MIN(start_date) 
                                                  FROM job_history 
                                                  WHERE employee_id = e.employee_id), hire_date))                        AS vechime,
                             salary * (1 + NVL(commission_pct, 0)) venit
                      FROM employees e JOIN departments d
                           ON (e.department_id = d.department_id)
                      WHERE department_name = linie.department_name
                            AND TO_CHAR(hire_date, 'D') = linie.zi)
      LOOP
        dbms_output.put_line( angajat.nume || ', cu salariul ' || angajat.vechime || ' si vechimea ' || angajat.venit);
      END LOOP;
    END IF;
  END LOOP;
END;
/


BEGIN
    p5_2;
END;
/

--LABORATOR 6 TRIGGERI
-- 1.modif doar decât în intervalul de ore 8:00 - 20:00, de luni până sâmbătă
CREATE OR REPLACE TRIGGER TRIG1_RMG
BEFORE INSERT OR UPDATE OR DELETE ON EMP_RMG
BEGIN 
    IF (TO_CHAR(SYSDATE, 'D') = 1 ) OR (TO_CHAR(SYSDATE, 'HH24') NOT BETWEEN 8 AND 18) THEN
        RAISE_APPLICATION_ERROR(-20001,'tabelul nu poate fi actualizat');
    END IF;
END;
/
DROP TABLE EMP_RMG;
SELECT *
FROM EMP_RMG;
CREATE TABLE EMP_RMG AS SELECT * FROM EMPLOYEES;

DROP TRIGGER TRIG1_RMG;

--2. Definiți un declanșator prin care să nu se permită micșorarea salariilor angajaților
CREATE OR REPACE

CREATE OR REPLACE TRIGGER trig1_rmg
 BEFORE INSERT OR UPDATE OR DELETE ON emp_rmg
BEGIN
IF (TO_CHAR(SYSDATE,'D') = 1)
 OR (TO_CHAR(SYSDATE,'HH24') NOT BETWEEN 8 AND 20)
THEN
dbms_output.put_line(TO_CHAR(SYSDATE,'D') || ' ' || TO_CHAR(SYSDATE,'HH24' );
RAISE_APPLICATION_ERROR(-20001,'tabelul nu poate fi actualizat');
END IF;
END;
/
DROP TRIGGER trig1_rmg;

-- 2 nu se permite miscorarea salariilor
CREATE OR REPLACE TRIGGER TRIG21_RMG 
    BEFORE UPDATE OF SALARY ON EMP_RMG
    FOR EACH ROW
BEGIN
    IF (:NEW.SALARY < :OLD.SALARY) THEN
        RAISE_APPLICATION_ERROR(-20002,'salariul nu poate fi micsorat');
    END IF;
END;
/
UPDATE EMP_RMG
SET SALARY = SALARY - 100;

DROP TRIGGER TRIG21_RMG;

CREATE OR REPLACE TRIGGER TRIG21_RMG
  BEFORE UPDATE OF salary ON EMP_RMG
  FOR EACH ROW
BEGIN
  IF (:NEW.salary < :OLD.salary) THEN
  RAISE_APPLICATION_ERROR(-20002,'salariul nu poate fi micsorat');
END IF; 
END;
/
UPDATE EMP_RMG
SET    salary = salary-100;

--VARIANTA 2
CREATE OR REPLACE TRIGGER TRIG22_RMG
    BEFORE UPDATE OF SALARY ON EMP_RMG
    FOR EACH ROW
    WHEN (NEW.SALARY < OLD.SALARY)
BEGIN
    RAISE_APPLICATION_ERROR(-20002, 'SALARIUL NU POATE FI MODIF');
END;
/
UPDATE EMP_RMG
SET    salary = salary-100;
DROP TRIGGER TRIG22_RMG;

SELECT *
FROM JOB_GRADES;
CREATE TABLE JOB_GRADES_RMG AS SELECT * FROM JOB_GRADES;

-- 3. 
CREATE OR REPLACE TRIGGER TRIG3_RMG
    BEFORE UPDATE OF LOWEST_SAL, HIGHEST_SAL ON JOB_GRADES_RMG
    FOR EACH ROW
DECLARE
    V_MIN_SAL   EMP_RMG.SALARY%TYPE;
    V_MAX_SAL   EMP_RMG.SALARY%TYPE;
    EXCEPTIE    EXCEPTION;
BEGIN
    SELECT MIN(SALARY), MAX(SALARY)
    INTO V_MIN_SAL, V_MAX_SAL
    FROM EMP_RMG;
    
    IF (:OLD.GRADE_LEVEL = 1) AND (V_MIN_SAL < :NEW.LOWEST_SAL)
        THEN RAISE EXCEPTIE;
    END IF;
    
    IF (:OLD.GRADE_LEVEL = 7) AND (V_MAX_SAL > :NEW.HIGHEST_SAL)
        THEN RAISE EXCEPTIE;
    END IF;
    
    EXCEPTION
        WHEN EXCEPTIE THEN
            RAISE_APPLICATION_ERROR (-20003, 'EXISTA SALARII CARE SE GASESC IN AFARA INTERVALULUI');
END;
/

UPDATE JOB_GRADES_RMG
SET LOWEST_SAL = 3000
WHERE GRADE_LEVEL  =1;

UPDATE job_grades_RMG
SET    highest_sal =20000
WHERE  grade_level=7;

DROP TRIGGER TRIG3_RMG;

-- 4
create table INFO_DEPT_RMG(id number(10) primary key, nume_dept varchar2(25), 
                           plati number(8, 2));
SELECT *
FROM INFO_DEPT_RMG;
DROP TABLE INFO_DEPT_RMG;
--B
INSERT INTO INFO_DEPT_RMG
SELECT DEPARTMENT_ID, DEPARTMENT_NAME, SUM(SALARY)
FROM EMPLOYEES
JOIN DEPARTMENTS USING (DEPARTMENT_ID)
GROUP BY DEPARTMENT_ID, DEPARTMENT_NAME;
/
--C
CREATE OR REPLACE PROCEDURE MODIFIC_PLATI_RMG
        ( V_CODD    INFO_DEPT_RMG.ID%TYPE,
          V_PLATI   INFO_DEPT_RMG.PLATI%TYPE) AS
BEGIN
    UPDATE INFO_DEPT_RMG
    SET PLATI = NVL(PLATI, 0) + V_PLATI
    WHERE ID = V_CODD;
END;
/
CREATE OR REPLACE TRIGGER TRIG4_RMG
    AFTER DELETE OR UPDATE OR INSERT OF SALARY ON EMP_RMG
    FOR EACH ROW
BEGIN
    IF DELETING THEN
        -- SE STERGE UN ANGAJAT 
        MODIFIC_PLATI_RMG(:OLD.DEPARTMENT_ID, -1 * :OLD.SALARY);
    ELSIF UPDATING THEN
        -- SE MODIF SALARIUL UNUI ANGAJAT
        MODIFIC_PLATI_RMG(:OLD.DEPARTMENT_ID, :NEW.SALARY - :OLD.SALARY);
    ELSE 
        -- SE INTRODUCE UN NOU ANGAJAT
        MODIFIC_PLATI_RMG(:NEW.DEPARTMENT_ID, :NEW.SALARY);
    END IF;
END;
/

SELECT *
FROM INFO_DEPT_RMG
WHERE ID = 90;

INSERT INTO EMP_RMG (employee_id, last_name, email, hire_date,
                     job_id, salary, department_id)
VALUES (300, 'N1', 'n1@g.com',sysdate, 'SA_REP', 2000, 90);

UPDATE EMP_RMG
SET    salary = salary + 1000
WHERE  employee_id=300;

SELECT *
FROM EMP_RMG;

DROP TRIGGER TRIG4_RMG;

-- 5 
CREATE TABLE info_emp_RMG (id, nume, prenume, salariu, id_dept) AS 
SELECT employee_id, last_name, first_name, salary, department_id
FROM employees;

ALTER TABLE INFO_EMP_RMG 
ADD CONSTRAINT EINFO_EMP_PK PRIMARY KEY (ID);

SELECT *
FROM INFO_DEPT_RMG;

ALTER TABLE INFO_EMP_RMG 
ADD CONSTRAINT EINFO_EMP_DEPT_FK FOREIGN KEY(ID_DEPT) REFERENCES INFO_DEPT_RMG(ID);


-- D PENTRU A VEDEA CARACTERISTICILE VIUALIZARII
CREATE OR REPLACE VIEW V_INFO_RMG AS
    SELECT E.ID, E.NUME, E.PRENUME, E.SALARIU, E.ID_DEPT,
            D.NUME_DEPT, D.PLATI
    FROM INFO_EMP_RMG E, INFO_DEPT_RMG D
    WHERE E.ID_DEPT = D.ID;

SELECT *
FROM USER_UPDATABLE_COLUMNS
WHERE TABLE_NAME = UPPER('V_INFO_RMG');

CREATE OR REPLACE TRIGGER TRIG5_RMG
    INSTEAD OF INSERT OR DELETE OR UPDATE ON V_INFO_RMG
    FOR EACH ROW
BEGIN
    IF INSERTING THEN 
        -- INSERAREA IN VIZUALIZARE DETERMINA INSERAREA IN INFO_EMP_RMG SI REACTUALIZAREA IN INFO_DEPT_RMG
        --  SE PRESUPUNE CA DEPT EXISTA
        INSERT INTO INFO_EMP_RMG
        VALUES (:NEW.ID, :NEW.NUME, :NEW.PRENUME, :NEW.SALARIU, :NEW.ID_DEPT);
        
        UPDATE INFO_DEPT_RMG
        SET PLATI = PLATI + :NEW.SALARIU
        WHERE ID = :NEW.ID_DEPT;
    ELSIF DELETING THEN 
        -- stergerea unui salariat din vizualizare determina
       -- stergerea din info_emp_*** si reactualizarea in
       -- info_dept_***
       DELETE FROM INFO_EMP_RMG
       WHERE ID = :OLD.ID;
       
       UPDATE INFO_DEPT_RMG
       SET PLATI = PLATI - :OLD.SALARIU
       WHERE ID = :OLD.ID_DEPT;
    ELSIF UPDATING ('salariu') THEN
   /* modificarea unui salariu din vizualizare determina
      modificarea salariului in info_emp_*** si reactualizarea
      in info_dept_***    */
        UPDATE  INFO_EMP_RMG
        SET     salariu = :NEW.salariu
        WHERE   id = :OLD.id;
        UPDATE INFO_DEPT_RMG
        SET    plati = plati - :OLD.salariu + :NEW.salariu
        WHERE  id = :OLD.id_dept;

    ELSIF UPDATING ('id_dept') THEN
    /* modificarea unui cod de departament din vizualizare
       determina modificarea codului in info_emp_***
       si reactualizarea in info_dept_***  */        
        UPDATE INFO_EMP_RMG
        SET    id_dept = :NEW.id_dept
        WHERE  id = :OLD.id;
        UPDATE INFO_DEPT_RMG
        SET    plati = plati - :OLD.salariu
        WHERE  id = :OLD.id_dept;
        UPDATE INFO_DEPT_RMG
        SET    plati = plati + :NEW.salariu
        WHERE  id = :NEW.id_dept;        
        
    END IF;    
END;
/

SELECT *
FROM   user_updatable_columns
WHERE  table_name = UPPER('INFO_DEPT_RMG');
-- adaugarea unui nou angajat
SELECT * FROM  info_dept_RMG WHERE id=10;
INSERT INTO V_INFO_RMG
VALUES (400, 'N1', 'P1', 3000,10, 'Nume dept', 0);
SELECT * FROM  INFO_EMP_RMG WHERE id=400;
SELECT * FROM  info_dept_RMG WHERE id=10;
-- modificarea salariului unui angajat
UPDATE v_info_RMG
SET    salariu=salariu + 1000
WHERE  id=400;
SELECT * FROM  info_emp_RMG WHERE id=400;
SELECT * FROM  info_dept_RMG WHERE id=10;
-- modificarea departamentului unui angajat
SELECT * FROM  info_dept_RMG WHERE id=90;
UPDATE v_info_RMG
SET    id_dept=90
WHERE  id=400;
SELECT * FROM  info_emp_RMG WHERE id=400;
SELECT * FROM  info_dept_RMG WHERE id IN (10,90);
-- eliminarea unui angajat
DELETE FROM v_info_RMG WHERE id = 400;
SELECT * FROM  info_emp_RMG WHERE id=400;
SELECT * FROM  info_dept_RMG WHERE id = 90;
DROP TRIGGER trig5_RMG;

SELECT USER
FROM DUAL;
-- 6
CREATE OR REPLACE TRIGGER TRIG6_RMG
    BEFORE DELETE ON EMP_RMG
BEGIN
    IF USER = UPPER('GRUPA244') THEN
        RAISE_APPLICATION_ERROR(-20900, 'NU AI VOIE SA STERGI !');
    END IF;
END;
/
DELETE FROM EMP_RMG 
WHERE EMPLOYEE_ID = 100;
DROP TRIGGER TRIG6_RMG;

--7
CREATE TABLE audit_RMG
(utilizator VARCHAR2(30),
 nume_bd    VARCHAR2(50),
 eveniment  VARCHAR2(20),
 nume_obiect    VARCHAR2(30),
 data           DATE);
CREATE OR REPLACE TRIGGER trig7_RMG
  AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
  INSERT INTO audit_RMG
  VALUES (SYS.LOGIN_USER, SYS.DATABASE_NAME, SYS.SYSEVENT,
          SYS.DICTIONARY_OBJ_NAME, SYSDATE);
END; 
/
CREATE INDEX ind_RMG ON info_emp_RMG(nume);
DROP INDEX ind_RMG;
SELECT * FROM audit_RMG;
DROP TRIGGER trig7_RMG;

--8
CREATE OR REPLACE PACKAGE pachet_RMG
AS
     smin emp_RMG.salary%type;
     smax emp_RMG.salary%type;
     smed emp_RMG.salary%type;
END pachet_RMG;
/
CREATE OR REPLACE TRIGGER trig81_RMG
BEFORE UPDATE OF salary ON emp_RMG
BEGIN
SELECT MIN(salary),AVG(salary),MAX(salary)
  INTO pachet_RMG.smin, pachet_RMG.smed, pachet_RMG.smax
  FROM emp_RMG;
END;
/
CREATE OR REPLACE TRIGGER trig82_RMG
BEFORE UPDATE OF salary ON emp_RMG
FOR EACH ROW
BEGIN
IF(:OLD.salary=pachet_RMG.smin)AND (:NEW.salary>pachet_RMG.smed)
 THEN
   RAISE_APPLICATION_ERROR(-20001,'Acest salariu depaseste
                                   valoarea medie');
ELSIF (:OLD.salary= pachet_RMG.smax)
       AND (:NEW.salary<  pachet_RMG.smed)
 THEN
   RAISE_APPLICATION_ERROR(-20001,'Acest salariu este sub
                                   valoarea medie');
END IF; END;
/
SELECT AVG(salary)
FROM   emp_RMG;
UPDATE emp_RMG
SET    salary=10000
WHERE  salary=(SELECT MIN(salary) FROM emp_RMG);
UPDATE emp_RMG
SET    salary=1000
WHERE  salary=(SELECT MAX(salary) FROM emp_RMG);
DROP TRIGGER trig81_RMG;
DROP TRIGGER trig82_RMG;

CREATE TABLE DEPT_RMG AS SELECT * FROM DEPARTMENTS;
-- EXERCITII LABORATOR 6
--1  
CREATE OR REPLACE TRIGGER T1_RMG
BEFORE DELETE ON DEPT_RMG
BEGIN
    IF USER != 'SCOTT' THEN
        RAISE_APPLICATION_ERROR(-20000, 'NO PERMISSION FOR DELETE!');
    END IF;
END;
/
DELETE FROM DEPT_RMG
WHERE DEPARTMENT_ID = 30;

DROP TRIGGER T1_RMG;

-- 2 NU SE PERMITE MARIREA COMISIONULUI ASTFEL INCAT SA DEPASEASCA 1/2 DIN VAL SAL
CREATE OR REPLACE TRIGGER T2_RMG
BEFORE UPDATE OF COMMISSION_PCT ON EMP_RMG
FOR EACH ROW
BEGIN
    IF :NEW.COMMISSION_PCT > 0.5 THEN
        RAISE_APPLICATION_ERROR(-20000, 'NU SE POATE MARI COMISIONUL');
    END IF;
END;
/

UPDATE EMP_RMG
SET COMMISSION_PCT = 0.7;

DROP TRIGGER T2_RMG;

-- 3 
--A
CREATE TABLE INFO_DEPT_RMG AS SELECT * FROM DEPARTMENTS;
ALTER TABLE INFO_DEPT_RMG ADD NUMAR NUMBER(4);

UPDATE INFO_DEPT_RMG D
SET NUMAR = (SELECT COUNT(*)
             FROM EMPLOYEES E
             WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID);

DROP TABLE INFO_DEPT_RMG;           
SELECT *
FROM INFO_DEPT_RMG;

-- B
--- b)
CREATE OR REPLACE TRIGGER t3_rmg
AFTER DELETE OR INSERT OR UPDATE OF department_id
ON emp_rmg
FOR EACH ROW
BEGIN
  if deleting then
    update info_dept_rmg
    set numar = numar - 1
    where department_id = :old.department_id;
  elsif inserting then
    update info_dept_rmg
    set numar = numar + 1
    where department_id = :new.department_id;
  else
    update info_dept_rmg
    set numar = numar - 1
    where department_id = :old.department_id;
    
    update info_dept_rmg
    set numar = numar + 1
    where department_id = :new.department_id;
  end if;
END;
/

insert into emp_rmg values(4000, 'ana', 'maria', 'aa', null, sysdate, 'AD_VP', 10000, 0.2, 86, 3);

delete from emp_rmg
where department_id = 50;

update emp_rmg
set department_id = 2
where employee_id = 200;

drop trigger trig6_rmg;
drop trigger t3_rmg;

CREATE OR REPLACE TRIGGER t4_rmg
BEFORE INSERT OR UPDATE OF department_id 
ON emp_rmg
FOR EACH ROW
DECLARE
  nr_ang    number;
BEGIN
  select count(*)
  into nr_ang
  from emp_rmg
  where department_id = :new.department_id;
    
  if nr_ang + 1 > 45 then
    raise_application_error(-20000, 'Nu se poate insera angajatul in acel departament!');
  end if;
END;
/

-- inserare
insert into emp_rmg values(123567, 'Prenume', 'Nume', 'e', 't', SYSDATE, 'IT_PROG', 70000, 0.6, 80, 51);

-- eroare la update
update emp_rmg
set department_id = 50
where employee_id = 206;
rollback;

drop trigger t4_rmg;
select *
from employees;
-- 5

create table emp_test_rmg as select employee_id, last_name, first_name, department_id from employees, foreign key(sno), references;
select *
from emp_test_rmg;
                    
create table dept_test_rmg as select department_id , department_name from departments;  

drop table emp_test_rmg;

create table emp_test_rmg (
    employee_id number primary key, 
    last_name varchar2(30), 
    first_name varchar2(30), 
    department_id number,
    constraint fk_dept foreign key(department_id) references dept_test
    from employees;


-- stergerea angajatilor din din emp_test daca le este sters departamentul


-- LABOARATOR 7
DECLARE
  v NUMBER;
  CURSOR c IS
      SELECT employee_id FROM employees;
BEGIN
    -- no data found
    SELECT employee_id
    INTO v
    FROM employees
    WHERE 1=0;
    -- too many rows
    SELECT employee_id
    INTO v
    FROM employees;
      -- invalid number
    SELECT employee_id
    INTO v
    FROM employees
    WHERE 2='s';
      -- when others
    v := 's';
      -- cursor already open
      open c;
      open c;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE (' no data found: ' ||SQLCODE || ' - ' ||SQLERRM);
     WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE (' too many rows: ' ||SQLCODE || ' - ' || SQLERRM);
     WHEN INVALID_NUMBER THEN
        DBMS_OUTPUT.PUT_LINE (' invalid number: ' ||SQLCODE || ' - ' || SQLERRM);
    
     WHEN CURSOR_ALREADY_OPEN THEN
    DBMS_OUTPUT.PUT_LINE (' cursor already open: ' ||SQLCODE || ' - ' || SQLERRM);
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE (SQLCODE || ' - ' || SQLERRM);
END; 
/


-- exercitii de la tema
--1  afisare radical al unei variabile

CREATE TABLE error_rmg
(cod    NUMBER,
 mesaj  VARCHAR2(100));
ACCEPT NR PROMPT 'DATI UN NUMAR '
DECLARE 
    V_NR NUMBER(10, 2) := &NR;
    EXCEPTIE_NEGATIV EXCEPTION;
    cod    NUMBER;
    mesaj  VARCHAR2(100);
BEGIN 
    IF V_NR < 0 THEN
        RAISE EXCEPTIE_NEGATIV;
    ELSE 
        DBMS_OUTPUT.PUT_LINE('NUMARUL ESTE ' || V_NR);
    END IF;
    EXCEPTION 
        WHEN EXCEPTIE_NEGATIV THEN 
            DBMS_OUTPUT.PUT_LINE('ATI INTRODUS UN NR NEGATIV!');
            COD := -2001;
            MESAJ := 'NUMAR NEGATIV LA RADICAL';
            INSERT INTO ERROR_RMG VALUES (COD, MESAJ);
END;
/

SELECT *
FROM ERROR_RMG;
SELECT *
FROM EMPLOYEES;
--2
-- BLOC CARE AFISEAZA NUMELE SALARIATULUI CARE CASTIGA UN ANUMIT SALARIU
ACCEPT C_SALARIU PROMPT 'DATI UN SALARIU'
DECLARE 
    SALARIU     NUMBER(8, 2) := &C_SALARIU; 
    V_NUME      VARCHAR2(30);
BEGIN
    SELECT LAST_NAME
    INTO V_NUME
    FROM EMPLOYEES
    WHERE ( SALARY + SALARY * NVL(COMMISSION_PCT, 0) ) = SALARIU;
    DBMS_OUTPUT.PUT_LINE(v_nume);
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('nu exista salariati care sa castige acest salariu ');
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('exista mai mulţi salariati care castiga acest salariu');
END;
/
CREATE TABLE DEPT_RMG AS SELECT * FROM DEP_MGB;
SELECT *
FROM DEPT_RMG;
-- 3
-- . Să se creeze un bloc PL/SQL care tratează eroarea apărută în cazul 
--în care se modifică codul unui departament în care lucrează angajaţi.
DECLARE
    NR_ANG NUMBER;
    EXCEPTIE EXCEPTION;
BEGIN
     SELECT COUNT(*)
     INTO NR_ANG
     FROM EMPLOYEES
     WHERE DEPARTMENT_ID = 30;
     
     IF NR_ANG > 0 THEN
        RAISE EXCEPTIE;
     END IF;
     
     UPDATE DEPT_RMG
     SET DEPARTMENT_ID = 30
     WHERE UPPER(DEPARTMENT_NAME)  = 'HUMAN RESOURCES';
     
     
EXCEPTION 
    WHEN EXCEPTIE THEN 
        DBMS_OUTPUT.PUT_LINE ('MODIFICATI CODUL UNUI DEPT UNDE LUCREAZA ANGAJATI');
END;
/
SELECT *
FROM DEPARTMENTS;
--4
ACCEPT LIM_INF PROMPT 'DATI O LIMITA INFERIOARA '
ACCEPT LIM_SUP PROMPT 'DATI O LIMITA SUPERIOARA'
DECLARE
    LIM_INF NUMBER := &LIM_INF;
    LIM_SUP NUMBER := &LIM_SUP;
    NUME_DEPT10 VARCHAR2(40);
    NR_ANG_DEPT10 NUMBER;
    OUT_LIMIT EXCEPTION;
    INVERSARE EXCEPTION;
BEGIN
    --DBMS_OUTPUT.PUT_LINE(LIM_INF || LIM_SUP);
    SELECT DEPARTMENT_NAME
    INTO NUME_DEPT10
    FROM DEPARTMENTS
    WHERE DEPARTMENT_ID = 10;
    
    SELECT COUNT(*)
    INTO NR_ANG_DEPT10
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = 10;
    --DBMS_OUTPUT.PUT_LINE(NR_ANG_DEPT10);
    IF LIM_SUP < LIM_INF THEN
        RAISE INVERSARE;
    END IF;
    IF NR_ANG_DEPT10 > LIM_INF AND NR_ANG_DEPT10 < LIM_SUP THEN
        SELECT DEPARTMENT_NAME
        INTO NUME_DEPT10
        FROM DEPARTMENTS
        WHERE DEPARTMENT_ID = 10;
        DBMS_OUTPUT.PUT_LINE('DEPARTAMENTUL 10 SE NUMESTE ' || NUME_DEPT10);
    ELSE 
        RAISE OUT_LIMIT;
    END IF;
EXCEPTION
    WHEN OUT_LIMIT THEN 
        DBMS_OUTPUT.PUT_LINE('NUMARUL DE ANGAJATI NU SE AFLA IN INTERVALUL ' || LIM_INF
        || ' ' || LIM_SUP || ' ' || SQLCODE || ' ' || SQLERRM);
    WHEN INVERSARE THEN
        DBMS_OUTPUT.PUT_LINE('VALORI INCORECTE LA INTRARE');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE || ' ' || SQLERRM);
END;
/

--5 Să se modifice numele unui departament al cărui cod este dat de la tastatură. 
-- Să se trateze cazul în care nu există acel departament.

SELECT *
FROM DEP_MGB;
ACCEPT P_COD PROMPT 'DATI CODUL'
DECLARE
    V_COD  NUMBER := &P_COD;
BEGIN
    UPDATE DEP_MGB
    SET DEPARTMENT_NAME = 'HARPERS BAZAAR'
    WHERE DEPARTMENT_ID = V_COD;
    
    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20999, 'DEPARTAMENTUL NU EXISTA');
    END IF;
END;
/
SELECT *
FROM DEPARTMENTS;
SELECT *
FROM LOCATIONS;
-- 6 VARIANTA 1
DECLARE 
    NUME_DEPT1 DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    NUME_DEPT2 DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    V_LOCALIZARE NUMBER;
BEGIN 
    V_LOCALIZARE := 1;
    SELECT DEPARTMENT_NAME
    INTO NUME_DEPT1
    FROM DEPARTMENTS
    JOIN LOCATIONS USING (LOCATION_ID)
    WHERE UPPER(CITY) = 'OXFORD';
    DBMS_OUTPUT.PUT_LINE ('DEPT-LOCATIE ' || NUME_DEPT1);
    
    V_LOCALIZARE :=2;
    SELECT DEPARTMENT_NAME 
    INTO NUME_DEPT2
    FROM DEPARTMENTS
    WHERE DEPARTMENT_ID = 500;
    DBMS_OUTPUT.PUT_LINE ('DEPT-COD ' || NUME_DEPT2);
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('comanda SELECT ' || v_localizare || ' nu returneaza nimic');
END;
/

-- varianta 2
DECLARE 
    NUME_DEPT1 DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    NUME_DEPT2 DEPARTMENTS.DEPARTMENT_NAME%TYPE;
BEGIN
    BEGIN 
        SELECT DEPARTMENT_NAME
        INTO NUME_DEPT1
        FROM DEPARTMENTS
        JOIN LOCATIONS USING (LOCATION_ID)
        WHERE UPPER(CITY) = 'OXFORD';
        DBMS_OUTPUT.PUT_LINE ('DEPT-LOCATIE ' || NUME_DEPT1);
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('comanda SELECT1 ' || ' nu returneaza nimic');
    END;
    
    BEGIN    
        SELECT DEPARTMENT_NAME 
        INTO NUME_DEPT2
        FROM DEPARTMENTS
        WHERE DEPARTMENT_ID = 500;
        DBMS_OUTPUT.PUT_LINE ('DEPT-COD ' || NUME_DEPT2);
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('comanda SELECT2 ' || ' nu returneaza nimic');
    END;
END;
/



--- 5

drop table emp_test_rmg;

select * from dept_test_rmg;
select * from emp_test_rmg;

create table dept_test_rmg (
    department_name VARCHAR2(20),
    department_id INT NOT NULL,
    CONSTRAINT pk1 PRIMARY KEY(department_id)
);
drop table dept_test_rmg;


create table emp_test_rmg (
    employee_id INT NOT NULL,
    department_id INT NOT NULL,
    CONSTRAINT pk PRIMARY KEY(employee_id),
    CONSTRAINT fk FOREIGN KEY (department_id) REFERENCES dept_test_rmg(department_id) ON DELETE set null
);

create table dept_test_rmg (
    department_name VARCHAR2(20),
    department_id INT NOT NULL,
    CONSTRAINT pk1 PRIMARY KEY(department_id)
);
drop table dept_test_rmg;


create table emp_test_rmg2 as select employee_id , last_name, first_name, department_id from employees;
drop table emp_test_rmg2;


CREATE OR REPLACE TRIGGER trigger_name  
AFTER 
UPDATE OR DELETE  
OF department_id  
ON emp_test_rmg2
FOR EACH ROW  
DECLARE     
BEGIN  
      dbms_output.put_line('sters'); 
END; 
/

UPDATE dept_test_rmg
SET department_id = 5,
WHERE department_id = 1;

DELETE
FROM
    dept_test_rmg
WHERE
    department_id = 1;
    
    
INSERT INTO emp_test_rmg2 VALUES (1, 1);
INSERT INTO dept_test_rmg VALUES ('aaa', 1);

select * from dept_test_rmg;
select ora_database_name from dual;

CREATE TABLE TABELRMG (USER_ID  SYS.LOGIN_USER%type ,
                        nume_bd  SYS.DATABASE_NAME%type,
                        ERORI    DBMS_UTILITY.FORMAT_ERROR_STACK%type,
                        DATA2     VARCHAR2(500)
                        );
                        

CREATE TABLE TABELRMG (USER_ID  number ,
                        nume_bd  VARCHAR2(500),
                        ERORI    number,
                        DATA2    date
                        );
drop table TABELRMG;
create or replace trigger t_error 
After servererror on schema
declare 
begin 
    insert into tablermg (USER_ID, nume_bd, ERORI, DATA2 )
    values (user, ora_database_name, SQLERRM  , sysdate);
end;
/
