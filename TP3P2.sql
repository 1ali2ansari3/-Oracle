--EX1
SET SERVEROUTPUT ON
--a
DECLARE
x CHAR(20) := 'HELLOW WORD';
BEGIN


DBMS_OUTPUT.PUT_LINE (x);

END;

--b
DECLARE
v_entier NUMBER(3);
BEGIN

SELECT COUNT(codegenere) INTO v_entier FROM GENREFILM WHERE codeGenere = 'CO';


DBMS_OUTPUT.PUT_LINE (v_entier);

END;

--EX2
--a
DECLARE
    v_num FILM.NUMFILM%TYPE;
    v_tit FILM.TITRE%TYPE;
    v_rea FILM.REALISATEUR%TYPE;
BEGIN
    SELECT NUMFILM, TITRE, REALISATEUR
    INTO v_num, v_tit, v_rea
    FROM film
    WHERE NUMFILM = (SELECT NUMFILM FROM EXEMPLAIRE  WHERE NUMEXEMPLAIRE = 10 );

    DBMS_OUTPUT.PUT_LINE('Num�ro de film : ' || v_num);
    DBMS_OUTPUT.PUT_LINE('Titre : ' || v_tit);
    DBMS_OUTPUT.PUT_LINE('R�alisateur : ' || v_rea);
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE ('Plus d''un film trouv� ');
    WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE ('Aucun film trouv� ayant au moins 10 exemplaires ');
END;


--EX3

DECLARE
  n NUMBER := 0;
  nombre_acteurs NUMBER := 0;
BEGIN
  n := &n; 

  SELECT COUNT(DISTINCT numIndividu) INTO nombre_acteurs
  FROM ACTEUR
  HAVING COUNT(DISTINCT numFilm) >= n;

  DBMS_OUTPUT.PUT_LINE('Le nombre d''acteurs ayant jou� dans au moins ' || n || ' films est : ' || nombre_acteurs);
END;

--EX4
DECLARE
  v_num_individu NUMBER := &num_individu; 
  CURSOR c_films_acteur IS
    SELECT f.titre
    FROM FILM f
    INNER JOIN ACTEUR a ON f.numFilm = a.numFilm
    WHERE a.numIndividu = v_num_individu;

  v_titre_film FILM.titre%TYPE;
BEGIN
  OPEN c_films_acteur;

  LOOP
    FETCH c_films_acteur INTO v_titre_film;

    EXIT WHEN c_films_acteur%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(v_titre_film);
  END LOOP;

  CLOSE c_films_acteur;
END;
--EX5
--a
CREATE TABLE tableBonus (
  login VARCHAR(255),
  bonus NUMBER(8,2),
  nbrExLoues NUMBER(8)
);
--b

INSERT INTO tableBonus (login, nbrExLoues)
SELECT Location.login, COUNT(*) AS nbrExLoues
FROM Location
WHERE Location.datelocation BETWEEN TO_DATE('2020-01-01', 'YYYY-MM-DD') AND TO_DATE('2020-12-31', 'YYYY-MM-DD')
GROUP BY Location.login;

--c

DECLARE
   n1 NUMBER(8) := &1;
   n2 NUMBER(8) := &2;
BEGIN
   UPDATE tableBonus
   SET bonus = CASE
                  WHEN nbrExLoues > 0 AND nbrExLoues < n1 THEN 0.1
                  WHEN nbrExLoues >= n1 AND nbrExLoues < n2 THEN 0.2
                  WHEN nbrExLoues >= n2 THEN 0.4
                  ELSE 0
               END;
END;

--d
SELECT c.nomclient, c.prenomclient, b.bonus
FROM Client c
INNER JOIN tableBonus b
ON c.login = b.login;

--EX6

SELECT E.NUMEXEMPLAIRE, COUNT(*)*100/(SELECT COUNT(*) FROM Location WHERE login = &login) AS pourcentage
FROM Location l
INNER JOIN EXEMPLAIRE E
ON E.numexemplaire = l.numexemplaire
WHERE l.login = &login
GROUP BY  E.NUMEXEMPLAIRE;

--EX7

DECLARE
    v_nbExemplaires NUMBER;
BEGIN
    FOR film IN (SELECT numfilm FROM Film GROUP BY numfilm)
    LOOP
        SELECT COUNT(*) INTO v_nbExemplaires FROM EXEMPLAIRE WHERE numfilm = film.numfilm;
        DBMS_OUTPUT.PUT_LINE('Le film num�ro ' || film.numfilm || ' poss�de ' || v_nbExemplaires || ' exemplaire(s).');
        IF v_nbExemplaires >= 2 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Erreur : le film num�ro ' || film.numfilm || ' a au moins deux exemplaires.');
        END IF;
    END LOOP;
END;



