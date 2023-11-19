CREATE VIEW V_EMP
AS SELECT emp.num matricule ,emp.nom ,emp.n_dept,(salaire + comm) GAINS, dept.lieu
FROM emp INNER JOIN dept ON emp.n_dept = dept.n_dept;

SELECT * FROM V_EMP WHERE GAINS > 10000;

UPDATE v_emp SET NOM = "MARTIN" WHERE MATRICULE = "2";

CREATE VIEW V_EMP10
AS SELECT emp.num matricule ,emp.nom ,emp.n_dept,(salaire + comm) GAINS, dept.lieu
FROM emp INNER JOIN dept ON emp.n_dept = dept.n_dept
WHERE emp.n_dept=10;


DROP VIEW V_EMP10;

CREATE VIEW V_EMP10
AS SELECT emp.num matricule ,emp.nom ,emp.n_dept,(salaire + comm) GAINS, dept.lieu
FROM emp INNER JOIN dept ON emp.n_dept = dept.n_dept
WHERE emp.n_dept=10
WITH CHECK OPTION ;

SELECT SUM(GAINS) FROM v_emp;


CREATE UNIQUE INDEX idx_nom ON emp(nom);

CREATE INDEX idx_dept ON emp(n_dept);


DROP INDEX idx_nom;

INSERT INTO emp(nom, num, fonction, n_sup, embauche, salaire, comm, n_dept) VALUES ('ANSARI', 1111, 'INFO', 11, 'ALI', 5000, 3, 1);

COMMIT;

UPDATE emp SET salaire = 1000 WHERE nom = 'ali';

set transaction read only;


UPDATE emp SET salaire = 1000 WHERE nom = 'ali';


update emp set salaire = 8999 where n_dept = 10;


SET SERVEROUTPUT ON

DECLARE
v_deptno dept.n_dept%TYPE;
v_dname dept.nom%TYPE;
v_loc dept.lieu%TYPE;
BEGIN
SELECT n_dept,nom,lieu
INTO v_deptno,v_dname,v_loc
FROM dept
WHERE n_dept=20;

DBMS_OUTPUT.PUT_LINE (v_deptno || v_dname || v_loc);

END;
