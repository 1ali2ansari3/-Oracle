SET SERVEROUTPUT ON
--EX1
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

--EX2
INSERT INTO dept VALUES (60,'RHU','ERACHIDIA');

--EX3

VARIABLE v_num NUMBER;
VARIABLE v_dept VARCHAR2(50);
VARIABLE v_lieu VARCHAR2(50);

EXEC :v_num := 70;
EXEC :v_dept := 'Finance';
EXEC :v_lieu := 'Errachidia';

DECLARE
  v_num_copy NUMBER := :v_num;
  v_dept_copy VARCHAR2(50) := :v_dept;
  v_lieu_copy VARCHAR2(50) := :v_lieu;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Num: ' || v_num_copy);
  DBMS_OUTPUT.PUT_LINE('Dept: ' || v_dept_copy);
  DBMS_OUTPUT.PUT_LINE('Lieu: ' || v_lieu_copy);
END;

--EX4

DECLARE
v_deptno dept.n_dept%TYPE;
v_dname dept.nom%TYPE;
v_loc dept.lieu%TYPE;
BEGIN
SELECT n_dept,nom,lieu
INTO v_deptno,v_dname,v_loc
FROM dept
WHERE n_dept=30;

DBMS_OUTPUT.PUT_LINE (v_deptno || v_dname || v_loc);

END;

--EX5

DECLARE 
   v_dept DEPT%ROWTYPE; 
BEGIN 
   SELECT * INTO v_dept FROM DEPT WHERE n_dept = 30; 
   DBMS_OUTPUT.PUT_LINE('Le contenu de la variable v_dept est : ' || v_dept.n_dept || ', ' || v_dept.nom || ', ' || v_dept.lieu); 
END;

--EX6

DECLARE 
   n_nom emp.nom%TYPE;
   v_sal emp.salaire%TYPE;
BEGIN 
    SELECT nom,salaire INTO n_nom,v_sal FROM emp WHERE nom = 'Alaoui';
    IF v_sal < 1000 THEN
  DBMS_OUTPUT.PUT_LINE('Bas salaire');
    ELSE
  DBMS_OUTPUT.PUT_LINE('Haut salaire');
    END IF;
END;

--EX7

DECLARE 
   v_comm emp.comm%TYPE;
BEGIN 
  SELECT comm INTO v_comm FROM emp WHERE nom = 'Alaoui';
  IF v_comm > 0 THEN
  DBMS_OUTPUT.PUT_LINE('l emploiye a une commession');
  ELSIF v_comm = 0 THEN
  DBMS_OUTPUT.PUT_LINE('zero');
  ELSE 
  DBMS_OUTPUT.PUT_LINE('PAS DE COMMESSION');
  END IF;
END;

--EX8

DECLARE
P NUMBER(4) := 1;
v_entier NUMBER(3) := 1;
BEGIN
DBMS_OUTPUT.PUT_LINE('factor(5) = ');
WHILE (v_entier<=5 ) LOOP
P := P*v_entier;
v_entier := v_entier + 1;
DBMS_OUTPUT.PUT_LINE(v_entier-1 );
END LOOP;
DBMS_OUTPUT.PUT_LINE(' = ' || p);
END;

--EX9

DECLARE

TYPE eng IS RECORD(nom EMP.NOM%TYPE, job EMP.FONCTION%TYPE, salaire EMP.SALAIRE%TYPE);
AA eng;
BEGIN
SELECT NOM, FONCTION, SALAIRE INTO AA.nom, AA.job , AA.salaire FROM EMP WHERE NOM = 'ali';

DBMS_OUTPUT.PUT_LINE(AA.nom || AA.job || AA.salaire );

END;

--EX10

CREATE TABLE dept_table AS
SELECT * FROM DEPT;

--EX11
--1
DECLARE
CURSOR cur_emp IS
SELECT NUM,NOM, FONCTION FROM EMP WHERE nom = 'Alaoui';
v_empno EMP.NUM%type;
v_ename EMP.NOM%type;
v_FON EMP.FONCTION%type;
BEGIN
OPEN cur_emp;

FETCH cur_emp INTO v_empno, v_ename, v_FON;
DBMS_OUTPUT.PUT_LINE('No Emp : '||v_empno);
DBMS_OUTPUT.PUT_LINE('Nom Emp : '||v_ename);
DBMS_OUTPUT.PUT_LINE('FON Emp : '||v_FON);

CLOSE cur_emp; 
END;
--2
DECLARE 
  CURSOR cur_emp IS 
    SELECT e.nom, e.salaire, d.nom
    FROM emp e INNER JOIN dept d ON e.n_dept = d.n_dept
    WHERE e.nom = 'Alaoui';
    E_NOM EMP.NOM%type;
    E_SAL EMP.SALAIRE%type;
    D_NOM DEPT.NOM%type;
BEGIN
  OPEN cur_emp;
  FETCH cur_emp INTO E_NOM,E_SAL,D_NOM;
  DBMS_OUTPUT.PUT_LINE(E_NOM || ' ' || E_SAL || ' ' || D_NOM);
  CLOSE cur_emp;
END;
--3
DECLARE 
  v_entier NUMBER(3) := 1;
  CURSOR cur_emp IS 
    SELECT nom, salaire FROM emp;
    E_NOM EMP.NOM%type;
    E_SAL EMP.SALAIRE%type;
BEGIN
  OPEN cur_emp;
  WHILE (v_entier<=5 ) LOOP
    FETCH cur_emp INTO E_NOM,E_SAL;
    DBMS_OUTPUT.PUT_LINE(E_NOM|| ' ' || E_SAL);
    v_entier := v_entier + 1;

  END LOOP;
  CLOSE cur_emp;
END;
--4
DECLARE 
  CURSOR cur_emp IS 
    SELECT nom, salaire FROM emp;
    E_NOM EMP.NOM%type;
    E_SAL EMP.SALAIRE%type;
BEGIN
  OPEN cur_emp;
  WHILE (cur_emp%ROWCOUNT<=6 ) LOOP
    FETCH cur_emp INTO E_NOM,E_SAL;
    EXIT WHEN cur_emp%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(E_NOM|| ' ' || E_SAL);

  END LOOP;
  CLOSE cur_emp;
END;
--5
DECLARE 
  CURSOR cur_DEPT IS 
    SELECT * FROM DEPT;
     dept_rec dept%ROWTYPE;
BEGIN
  OPEN cur_DEPT;
  WHILE (cur_DEPT%ROWCOUNT<3 ) LOOP
    FETCH cur_DEPT INTO dept_rec;
    EXIT WHEN cur_DEPT%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(dept_rec.N_DEPT|| ' ' ||dept_rec.NOM|| ' ' || dept_rec.LIEU);

  END LOOP;
  CLOSE cur_DEPT;
END;
--6
DECLARE 
  CURSOR cur_emp IS 
    SELECT nom, salaire FROM emp;
    E_NOM EMP.NOM%type;
    E_SAL EMP.SALAIRE%type;
BEGIN
  OPEN cur_emp;
  LOOP
    FETCH cur_emp INTO E_NOM,E_SAL;
    EXIT WHEN cur_emp%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(E_NOM|| ' ' || E_SAL);

  END LOOP;
  CLOSE cur_emp;
END;
--7
DECLARE 
  CURSOR cur_emp IS 
    SELECT num, salaire FROM emp WHERE nom = 'Alaoui';
  TYPE eng IS RECORD (
    num emp.num%TYPE,
    salaire emp.salaire%TYPE
  );
  enr_emp eng;
BEGIN
  OPEN cur_emp;
  FETCH cur_emp INTO enr_emp.num, enr_emp.salaire;
  DBMS_OUTPUT.PUT_LINE(enr_emp.num || ' ' || enr_emp.salaire);
  CLOSE cur_emp;
END;


