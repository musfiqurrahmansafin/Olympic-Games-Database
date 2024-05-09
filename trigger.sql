-- Athlete_Existence_Check using trigger
-- Trigger
CREATE OR REPLACE TRIGGER check_athlete_before_insert
BEFORE INSERT ON RESULT
FOR EACH ROW
DECLARE
  v_count INT;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM ATHLETE
  WHERE Athlete_id =:new.Athlete_id;

  IF v_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Invalid athlete ID. Insertion failed.');
  END IF;
END check_athlete_before_insert;
/

insert into result values(201, 2016,'Summer','Men 105 kg','Individual','Men','Gold');
insert into result values(601, 2016,'Summer','Men 105 kg','Individual','Men','Gold');