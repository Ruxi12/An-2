--4 Câte filme (titluri, respectiv exemplare) au fost împrumutate din cea mai cerută categorie?
select title 
from TITLE
WHERE CATEGORY = 
    (select category, max(count(*))
    from RENTAL
    INNER JOIN TITLE 
    USING TITLE_ID
    GROUP BY CATEGORY);

--5 Câte exemplaredin fiecare film
--sunt disponibile în prezent(considerați că statusul unuiexemplarnu este setat, 
--deci nu poate fi utilizat)?

SELECT TITLE, COUNT(STATUS)
FROM TITLE_COPY 
INNER JOIN TITLE 
USING TITLE_ID
WHERE STATUS = 'AVAILABLE'
GROUP BY TITLE;

--6 Afișați următoareleinformații: 
--titlul filmului,numărul exemplarului, statusul setat șistatusul corect.
SELECT TITLE.TITLE, TITLE_COPY.TITLE_ID, TITLE_COPY.STATUS, CASE
WHEN (TITLE.TITLE_ID, TITLE_COPY.COPY_ID) NOT IN 
                                        (SELECT TITLE_ID, COPY_ID 
                                        FROM RENTAL
                                        WHERE ACT_REC_DATE IS NULL )
    THEN 'AVAILABLE'
    ELSE 'RENTED'
END "STATUS CORECT"
FROM TITLE, TITLE_COPY 
WHERE TITLE.TITLE_ID = TITLE_COPY.TITLE_ID;

--7 a.Câte exemplareau statusul eronat? 
SELECT COUNT(*) "STATUT ERONATE - NUMAR "
FROM 
    (SELECT TITLE.TITLE, TITLE_COPY.COPY_ID, TITLE_COPY.STATUS, CASE
    WHEN (TITLE.TITLE, TITLE_COPY.COPY_ID) NOT IN 
                                                (SELECT TITLE_ID, COPY_ID FROM RENTAL 
                                                WHERE ACT_RET_DATE IS NULL )
        THEN 'AVAILABLE'
        ELSE 'RENTED'
END "STATUS CORECT"
FROM TITLE, TITLE_COPY
WHERE TITLE.TITLE_ID = TITLE_COPY.TITLE_ID;

--B Setați statusul corect pentrutoate exemplarele care au statusul eronat.
CREATE TABLE TITLE_COPY_RMG AS 
SELECT *
FROM TITLE_COPY;
UPDATE TITLE_COPY_RMG SET STATUS = (CASE WHEN (TITLE_ID, COPY_ID) NOT IN (SELECT TITLE_ID, COPY_ID FROM RENTAL WHERE ACT_RET_DATE IS NULL)
    THEN 'AVAILABLE'
    ELSE 'RENTED' END);
SELECT *
FROM TITLE_COPY_RMG

--8 Toate filmelerezervate au 
--fost împrumutate la data rezervării?Afișați textul “Da” sau ”Nu” în funcție de situație.
SELECT 
    CASE WHEN 
        (SELECT COUNT(*)
        FROM RENTAL
        INNER JOIN RESERVATION ON (RENTAL.MEMBER_ID = RESERVATION.MEMBER_ID AND RENTAL.TITLE_ID = RESERVATION.TITLE_ID)
        WHERE BOOK_DATE != RES_DATE)>0
    THEN 'NU'
    ELSE 'DA'
    END "AU FOST TOTI CORECTI?"
FROM DUAL;

--9
--De câte ori a împrumutat unmembru(nume și prenume)fiecare film(titlu)?
SELECT MEMBER.LAST_NAME "NUME", MEMBER.FIRST_NAME "PRENUME", TITLE.TITLE "TITLU", COUNT(TITLE.TITLE_ID) "IMPRUMUTAT"
FROM MEMBER
INNER JOIN RENTAL ON (RENTAL.MEMBER_ID = MEMBER.MEMBER_ID)
INNER JOIN TITLE_COPY ON (TITLE_COPY.COPY_ID = RENTAL.COPY_ID AND TITLE_COPY.TITLE_ID = RENTAL.TITLE_ID)
INNER JOIN TITLE T ON(T.TITLE_ID = TITLE_COPY.TITLE_ID)
GROUP BY T.TITLE_ID, T.TITLE, MEMBER.LAST_NAME, MEMBER.FIRST_NAME
ORDER BY MEMBER.LAST_NAME, MEMBER.FIRST_NAME;

--10 De câte ori a împrumutat un membru(nume și prenume)fiecareexemplar(cod)alunui film(titlu)? 
SELECT MEMBER.LAST_NAME "NUME", MEMBER.FIRST_NAME "PRENUME",RENTAL.COPY_ID, TITLE.TITLE "TITLU", COUNT(TITLE.TITLE_ID) "IMPRUMUTAT"
FROM MEMBER
INNER JOIN RENTAL ON (RENTAL.MEMBER_ID = MEMBER.MEMBER_ID)
INNER JOIN TITLE_COPY ON (TITLE_COPY.COPY_ID = RENTAL.COPY_ID AND TITLE_COPY.TITLE_ID = RENTAL.TITLE_ID)
INNER JOIN TITLE T ON(T.TITLE_ID = TITLE_COPY.TITLE_ID)
GROUP BY T.TITLE_ID, T.TITLE, MEMBER.LAST_NAME, MEMBER.FIRST_NAME
ORDER BY MEMBER.LAST_NAME, MEMBER.FIRST_NAME;

--11 Obțineți statusul celui mai des împrumutat exemplar al fiecărui film(titlu).
--SELECT TITLE.TITLE "TITLU", MAX(COUNT(TITLE.TITLE_ID)) "IMPRUMUTAT", TITLE_COPY.STATUS
--FROM TITLE
--INNER JOIN RENTAL ON (RENTAL.MEMBER_ID = MEMBER.MEMBER_ID)
--INNER JOIN TITLE_COPY ON (TITLE_COPY.COPY_ID = RENTAL.COPY_ID AND TITLE_COPY.TITLE_ID = RENTAL.TITLE_ID)
--INNER JOIN TITLE T ON(T.TITLE_ID = TITLE_COPY.TITLE_ID)
--GROUP BY T.TITLE_ID, T.TITLE, MEMBER.LAST_NAME, MEMBER.FIRST_NAME
--ORDER BY MEMBER.LAST_NAME, MEMBER.FIRST_NAME;              
SELECT TITLE AS "TITLU", TC.STATUS AS "STATUS"
FROM TITLE_COPY TC
INNER JOIN TITLE T ON (T.TITLE_ID = TC.TITLE_ID)
WHERE TC.COPY_ID = ( SELECT COPY_ID 
                    FROM (SELECT TC.COPY_ID 
                          FROM RENTAL R JOIN TITLE_COPY_TC ON (R.COPY_ID = TC.COPY_ID)
                          GROUP BY TC.COPY_ID
                          ORDER BY COUNT(TC.COPY_ID) DESC)
                    WHERE ROWNUM = 1);
                    
--12 Pentru anumite zile specificate dinlunacurentă,obțineți numărul de împrumuturi efectuate.
--a.Se iau în considerare doar primele 2 zile din lună.
SELECT DT, (
    SELECT COUNT(*)
    FROM RENTAL WHERE
    EXTRACT (DAY FROM BOOK_DATE) =  EXTRACT(DAY FROM DT)
    AND EXTRACT (MONTH FROM BOOK_DATE) = EXTRACT(MONTH FORM DT)) AS "IMPRUMUTURI"
FROM(SELECT TRUNC (last_day(add_months(SYSDATE, -1)) + ROWNUM) dt
     FROM DUAL CONNECT BY ROWNUM < 3
     )
ORDER BY DT;
--b
select book_date, count(*) as "Imprumuturi"
from rental 
where extract(month from book_date) = extract(month from sysdate) 
group by book_date 
order by book_date asc;
--c
SELECT DT, (
    select count(*) 
    from rental where 
    extract(day from book_date) = extract(day from DT)
    and extract(month from book_date) = extract(month from DT))  as "Imprumuturi"
FROM(SELECT TRUNC (last_day(SYSDATE) - ROWNUM) dt
     FROM DUAL CONNECT BY ROWNUM < extract(day from last_day(sysdate))
     )
ORDER BY DT;
