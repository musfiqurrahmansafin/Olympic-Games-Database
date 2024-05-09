-- Procedure Name: result_info
-- Procedure
CREATE OR REPLACE PROCEDURE result_info(type_in VARCHAR2, medal_type_in VARCHAR2) AS
  CURSOR c_result IS
    SELECT *
    FROM RESULT
    WHERE Type = type_in AND Medal_type = medal_type_in;
  res RESULT%ROWTYPE;
BEGIN
  OPEN c_result;
  LOOP
    FETCH c_result INTO res;
    EXIT WHEN c_result%NOTFOUND;
    -- Process each row as needed
    DBMS_OUTPUT.PUT_LINE('Athelete Id: '||res.Athlete_id||', Type: ' || res.Type || ', Medal Type: ' || res.Medal_type||' ,Discipline_name: '||res.Discipline_name);
  END LOOP;
  CLOSE c_result;
END;
/

SET SERVEROUTPUT ON;

-- Call the Procedure
BEGIN
  result_info('Individual', 'Gold'); 
END;
/


-- Function Name: validate_athlete_id
-- Function
-- Create the function
CREATE OR REPLACE FUNCTION validate_athlete_id(p_athlete_id IN INT)
RETURN BOOLEAN
IS
  v_count INT;
BEGIN
  SELECT COUNT(*)
  INTO v_count
  FROM ATHLETE
  WHERE Athlete_id = p_athlete_id;

  IF v_count > 0 THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    -- Handle exceptions if any
    RETURN FALSE;
END;
/

-- Enable DBMS output
SET SERVEROUTPUT ON;

-- Declare a variable to hold the result
DECLARE
  is_valid BOOLEAN;
BEGIN
  -- Call the function with an athlete ID
  is_valid := validate_athlete_id(241);
  
  -- Output the result
  IF is_valid THEN
    DBMS_OUTPUT.PUT_LINE('Valid Athlete ID');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Not Valid Athlete ID');
  END IF;
END;
/


-- Function Name: validate_olympic_year_season
-- Function
CREATE OR REPLACE FUNCTION validate_olympic_year_season(p_year INT, p_season VARCHAR2)
RETURN BOOLEAN
IS
  v_count INT;
BEGIN
  SELECT COUNT(*)
  INTO v_count
  FROM OLYMPIC
  WHERE Year = p_year AND Season = p_season;

  IF v_count > 0 THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    -- Handle exceptions if any
    RETURN FALSE;
END;
/

-- Function Call Example
set serveroutput on;
DECLARE
  v_valid BOOLEAN;
BEGIN
  v_valid := validate_olympic_year_season(2016, 'Summer');
  IF v_valid THEN
    DBMS_OUTPUT.PUT_LINE('Olympic year and season are valid');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Olympic year and season are not valid');
  END IF;
END;
/

-- Function Name: validate_discipline
-- Function
CREATE OR REPLACE FUNCTION validate_discipline(p_discipline_name VARCHAR2, p_kind VARCHAR2, p_type VARCHAR2)
RETURN BOOLEAN
IS
  v_count INT;
BEGIN
  SELECT COUNT(*)
  INTO v_count
  FROM DISCIPLINE
  WHERE Discipline_name = p_discipline_name AND Kind = p_kind AND Type = p_type;

  IF v_count > 0 THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    -- Handle exceptions if any
    RETURN FALSE;
END;
/
set serveroutput on;
DECLARE
  v_valid BOOLEAN;
BEGIN
  v_valid := validate_discipline('High jump','Men','Individual');
  IF v_valid THEN
    DBMS_OUTPUT.PUT_LINE('Discipline exists');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Discipline does not exist');
  END IF;
END;
/

-- Function Name: validate_result_insertion
-- Function
CREATE OR REPLACE FUNCTION validate_result_insertion(
    p_athlete_id INT,
    p_year INT,
    p_season VARCHAR2,
    p_discipline_name VARCHAR2,
    p_type VARCHAR2,
    p_kind VARCHAR2,
    p_medal_type VARCHAR2
) RETURN BOOLEAN IS
    v_athlete_count INT;
    v_olympic_count INT;
    v_discipline_count INT;
BEGIN
    -- Check if athlete exists
    SELECT COUNT(*)
    INTO v_athlete_count
    FROM ATHLETE
    WHERE Athlete_id = p_athlete_id;

    -- Check if Olympic year and season exist
    SELECT COUNT(*)
    INTO v_olympic_count
    FROM OLYMPIC
    WHERE Year = p_year AND Season = p_season;

    -- Check if discipline exists
    SELECT COUNT(*)
    INTO v_discipline_count
    FROM DISCIPLINE
    WHERE Discipline_name = p_discipline_name
    AND Type = p_type
    AND Kind = p_kind;

    -- If all conditions are met, return true
    IF v_athlete_count = 1 AND v_olympic_count = 1 AND v_discipline_count = 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;
/

-- Call the function with example parameters
SET SERVEROUTPUT ON;

DECLARE
    is_valid BOOLEAN;
BEGIN
    is_valid := validate_result_insertion(201, 2016, 'Summer', 'Parallel bars', 'Individual', 'Men', 'Gold');

    IF is_valid THEN
        DBMS_OUTPUT.PUT_LINE('Result insertion is valid.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Result insertion is not valid.');
    END IF;
END;
/