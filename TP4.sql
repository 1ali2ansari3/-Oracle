SET SERVEROUTPUT ON

--EX1
DECLARE
  v_vol VARCHAR2(10) := 'AF110';
  v_dep_time VARCHAR2(10) := '23h10';
  v_arr_time VARCHAR2(10) := '21h40';
  v_dep_city VARCHAR2(20) := 'Paris';
  v_arr_city VARCHAR2(20) := 'Dublin';
BEGIN
  INSERT INTO vol (NUMVOL, HEURE_DEPART, HEURE_ARRIVEE, VILLE_DEPART, VILLE_ARRIVEE)
  VALUES (v_vol, v_dep_time, v_arr_time, v_dep_city, v_arr_city);
  COMMIT;
END;
--EX2
DECLARE
  v_no NUMBER := 1;
BEGIN
  WHILE v_no <= 100 LOOP
    INSERT INTO res (NO) VALUES (v_no);
    v_no := v_no + 1;
  END LOOP;
  COMMIT;
END;
--EX3
DECLARE
  v_sum NUMBER := 0;
BEGIN
  FOR i IN 1000..10000 LOOP
    v_sum := v_sum + i;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('La somme des nombres entre 1000 et 10000 est ' || v_sum);
END;
--EX4
DECLARE
  TYPE tab_entiers IS TABLE OF NUMBER(10) INDEX BY PLS_INTEGER;
  v_tab tab_entiers;
BEGIN
  v_tab := tab_entiers();
  v_tab.EXTEND(20);
  FOR i IN 1..20 LOOP
    v_tab(i) := i*i;
  END LOOP;
  FOR i IN 1..20 LOOP
    DBMS_OUTPUT.PUT_LINE('Element ' || i || ' : ' || v_tab(i));
  END LOOP;
END;
--EX5
DECLARE
   total_salaires NUMBER := 0;   
   nb_pilotes NUMBER := 0;      
   moyenne_salaires NUMBER;     
BEGIN
  
   FOR pilote IN (SELECT Salaire FROM PILOTE WHERE Age >= 30 AND Age <= 40) LOOP
      total_salaires := total_salaires + pilote.Salaire; 
      nb_pilotes := nb_pilotes + 1;                      
   END LOOP;

      moyenne_salaires := total_salaires / nb_pilotes;

   DBMS_OUTPUT.PUT_LINE('La moyenne des salaires des pilotes entre 30 et 40 ans est : ' || moyenne_salaires);
END;
--EX6
CREATE OR REPLACE TRIGGER check_partition_capacity
BEFORE INSERT ON PARTITION
FOR EACH ROW
DECLARE
   total_taille NUMBER;
   capacite_disque NUMBER; 
BEGIN

   SELECT capacité INTO capacite_disque
   FROM DISQUE
   WHERE nom = :NEW.nom_Disque;

   SELECT NVL(SUM(taille), 0) INTO total_taille
   FROM PARTITION
   WHERE nom_Disque = :NEW.nom_Disque;

   IF total_taille + :NEW.taille > capacite_disque THEN     
      DBMS_OUTPUT.PUT_LINE('La capacité du disque est dépassée. L''enregistrement de la nouvelle partition est annulé.');
      RAISE_APPLICATION_ERROR(-20001, 'La capacité du disque est dépassée.');
   END IF;
END;

--EX7
DECLARE      
   nb_employes_affectes NUMBER := 0;  
BEGIN

   UPDATE EMPLOYE
   SET SALAIRE = SALAIRE + 200
   WHERE DEPARTEMENT = 'Commercial';
  
  SELECT COUNT(*) INTO nb_employes_affectes FROM EMPLOYE WHERE DEPARTEMENT = 'Commercial';

   DBMS_OUTPUT.PUT_LINE('Le nombre d''employés affectés par le changement est : ' || nb_employes_affectes);
END;
--EX8
DECLARE
     
   nom_employe EMPLOYE.NOM%TYPE; 
BEGIN

   FOR employe IN ( SELECT NOM FROM EMPLOYE WHERE DEPARTEMENT = 'Commercial' AND AGE > 40 ) LOOP 
   nom_employe := employe.NOM
   DBMS_OUTPUT.PUT_LINE('Nom de l''employé : ' || nom_employe); 
   END LOOP;

END;

--EX9

CREATE PROCEDURE employes(N NUMBER) IS
   CURSOR c_employes IS
      SELECT DISTINCT DEPARTEMENT, COUNT(*) AS nb_employes
      FROM EMPLOYE
      WHERE AGE > N

   v_departement EMPLOYE.DEPARTEMENT%TYPE;
   v_nb_employes NUMBER;
BEGIN
   OPEN c_employes;
   FOR rec IN c_employes LOOP
      v_departement := rec.DEPARTEMENT;
      v_nb_employes := rec.nb_employes;
      DBMS_OUTPUT.PUT_LINE('Département : ' || v_departement || ', Nombre d''employés : ' || v_nb_employes);
   END LOOP;

   CLOSE c_employes;
END;

--EX10

CREATE FUNCTION temperature_humidite(p_ville METEO.NUM_VILLE%TYPE) 
RETURN METEO.NUM_VILLE%TYPE IS
   v_temperature METEO.Temperature%TYPE;
   v_humidite METEO.Humidite%TYPE;
BEGIN
   SELECT Temperature, Humidite INTO v_temperature, v_humidite
   FROM METEO
   WHERE NOM_VILLE = p_ville;
   
   RETURN 'Température : ' || v_temperature || ', Humidité : ' || v_humidite;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN 'La ville spécifiée n''existe pas.';
END;

--EX11

CREATE TRIGGER meteo
BEFORE INSERT ON METEO
FOR EACH ROW
DECLARE
   v_count NUMBER;
BEGIN
SELECT MAX(Temperature) INTO v_max_temperature
   FROM METEO;
   
   IF :NEW.Temperature >= v_max_temperature THEN
      DBMS_OUTPUT.PUT_LINE('Avertissement : La température de la nouvelle ville est la plus grande de toutes les villes.');
   END IF;

   SELECT COUNT(*) INTO v_count
   FROM METEO
   WHERE NOM_VILLE = :NEW.NOM_VILLE;
   
   IF v_count > 0 THEN
      UPDATE METEO
      SET Temperature = :NEW.Temperature,
          Humidite = :NEW.Humidite
      WHERE NOM_VILLE = :NEW.NOM_VILLE;
      RAISE_APPLICATION_ERROR(-20001, 'La ville existe déjà dans la table. La mise à jour a été effectuée.');
   END IF;
END;

--EX12
DECLARE
  v_nom_competition COMPETITION.NOM_COMPETITION%TYPE := &v_nom_competition;
  v_total_score SCORE.NOTE%TYPE := 0;

  CURSOR c_participants (p_nom_competition COMPETITION.NOM_COMPETITION%TYPE) IS
    SELECT P.NO_PART, P.NOM_PART, SUM(S.NOTE) AS TOTAL_SCORE
    FROM PARTICIPANT P
    INNER JOIN SCORE S ON P.NO_PART = S.NO_PART
    INNER JOIN COMPETITION C ON S.CODE_COMP = C.CODE_COMP
    WHERE C.NOM_COMPETITION = p_nom_competition;

BEGIN
 
  OPEN c_participants(v_nom_competition);

  DBMS_OUTPUT.PUT_LINE('Participants et scores pour la compétition ' || v_nom_competition || ' :');
  LOOP
    FETCH c_participants INTO v_no_part, v_nom_part, v_total_score;
    EXIT WHEN c_participants%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Participant : ' || v_nom_part || ', Score total : ' || v_total_score);
  END LOOP;

  CLOSE c_participants;
END;

--EX13

CREATE  TRIGGER check_code_competition
BEFORE INSERT ON COMPETITION
FOR EACH ROW

BEGIN
    IF SUBSTR(:NEW.CODE_COMP, 1, 3) != 'CMP' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Le code de la compétition doit commencer par ''CMP''.');
    END IF;
END;

--EX14
CREATE FUNCTION client
  RETURN NUMBER IS
  client_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO client_count
  FROM CLIENT cl
  JOIN ABONNEMENT ab ON cl.CL_ID = ab.CL_ID
  JOIN MAGAZINE mag ON ab.MAG_ID = mag.MAG_ID
  WHERE cl.CL_VILLE = 'Errachidia'
    AND mag.MAG_NOM = 'Vogue'
    AND ab.START_DATE > DATE '2020-08-01';

  IF client_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Aucun client d''Errachidia ne s''est abonné à Vogue après août 2020.');
  END IF;

  RETURN client_count;

END;
--EX15
CREATE OR REPLACE TRIGGER update_track_abonnements
AFTER INSERT ON ABONNEMENT
FOR EACH ROW
DECLARE
  v_mag_nom MAGAZINE.MAG_NOM%TYPE;
BEGIN
  SELECT MAG_NOM INTO v_mag_nom
  FROM MAGAZINE
  WHERE MAG_ID = :new.MAG_ID;

  UPDATE TRACK_ABONNEMENTS
  SET NB_ABONN = NB_ABONN + 1
  WHERE MAG_NOM = v_mag_nom;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    INSERT INTO TRACK_ABONNEMENTS (MAG_NOM, NB_ABONN)
    VALUES (v_mag_nom, 1);
END;
--EX16
DECLARE
  v_nb_escales NUMBER;
  v_depart VARCHAR2(50) := 'Paris';
  v_arrivee VARCHAR2(50) := 'Paris';
  v_escale_num NUMBER;
  v_escale_ville VARCHAR2(50);
  v_escale_duree NUMBER;
BEGIN
  v_nb_escales := &nb_escales;

  DBMS_OUTPUT.PUT_LINE(v_depart);

  FOR i IN 1..v_nb_escales LOOP
    SELECT Numescale, Ville_Escale, Durée_Escale
    INTO v_escale_num, v_escale_ville, v_escale_duree
    FROM ESCALE
    WHERE Numescale = i;

    DBMS_OUTPUT.PUT_LINE('Escale no ' || v_escale_num || ': ' || v_escale_ville);
    DBMS_OUTPUT.PUT_LINE('Durée d''escale : ' || v_escale_duree || ' heures');
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(v_arrivee);
END;
--EX17

DECLARE
  v_nb_escales NUMBER;
  v_depart VARCHAR2(50) := 'Paris';
  v_arrivee VARCHAR2(50) := 'Paris';
  v_escale_num NUMBER;
  v_escale_ville VARCHAR2(50);
  v_escale_duree NUMBER;
BEGIN
  v_nb_escales := &nb_escales;

  DBMS_OUTPUT.PUT_LINE(v_depart);

  FOR i IN 1..v_nb_escales LOOP
    SELECT Numescale, Ville_Escale, Durée_Escale
    INTO v_escale_num, v_escale_ville, v_escale_duree
    FROM ESCALE
    WHERE Numescale = i;

    DBMS_OUTPUT.PUT_LINE('Escale no ' || v_escale_num || ': ' || v_escale_ville);
    DBMS_OUTPUT.PUT_LINE('Durée d''escale : ' || v_escale_duree || ' heures');


   FOR v_flight IN (SELECT *
                     FROM VOL
                     WHERE Ville_départ = v_depart
                       AND Ville_arrivée = v_escale_ville) LOOP
      DBMS_OUTPUT.PUT_LINE('Vol : ' || v_flight.Numvol);
      DBMS_OUTPUT.PUT_LINE('Heure départ : ' || v_flight.Heure_départ);
      DBMS_OUTPUT.PUT_LINE('Heure arrivée : ' || v_flight.Heure_arrivée);
    END LOOP;

    v_depart := v_escale_ville;


  END LOOP;

  DBMS_OUTPUT.PUT_LINE(v_arrivee);
END;
--EX18
CREATE OR REPLACE PROCEDURE ProposerToursDuMonde(
  villeDepart IN VARCHAR2,
  nbEscalesMin IN NUMBER,
  nbEscalesMax IN NUMBER
)
IS
  PROCEDURE ProposerTourDuMonde(
    villeDepart IN VARCHAR2,
    nbEscalesMin IN NUMBER,
    nbEscalesMax IN NUMBER,
    escalesCourantes IN VARCHAR2
  )
  IS
    v_nbEscales NUMBER;
  BEGIN

    IF nbEscalesMin <= 0 THEN

      dbms_output.put_line(escalesCourantes || villeDepart);
    ELSE

      SELECT COUNT(*)
      INTO v_nbEscales
      FROM VOL
      WHERE Ville_Départ = villeDepart;
      

      IF v_nbEscales > 0 THEN

        FOR vol IN (
          SELECT Ville_Arrivée
          FROM VOL
          WHERE Ville_Départ = villeDepart
        ) LOOP

          ProposerTourDuMonde(
            vol.Ville_Arrivée,
            nbEscalesMin - 1,
            nbEscalesMax - 1,
            escalesCourantes || villeDepart || ' -> '
          );
        END LOOP;
      END IF;
    END IF;
  END ProposerTourDuMonde;
BEGIN

  ProposerTourDuMonde(villeDepart, nbEscalesMin, nbEscalesMax, '');
END;
/