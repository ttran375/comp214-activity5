-- ## Question 1

-- Assignment 8-1: Reviewing Dependency Information in the Data Dictionary
-- Two data dictionary views store information on dependencies: USER_OBJECTS and USER_DEPENDENCIES. Take a closer look at these views to examine the information in them:
-- 1. In SQL Developer, issue a DESCRIBE command on the USER_OBJECTS view and review the available columns. Which columns are particularly relevant to dependencies? The STATUS column indicates whether the object is VALID or INVALID. The TIMESTAMP column is used in remote connections to determine invalidation.
-- 2. Query the USER_OBJECTS view, selecting the OBJECT_NAME, STATUS, and TIMESTAMP columns for all procedures. Recall that you can use a WHERE clause to look for object types of PROCEDURE to list only procedure information.
-- 3. Now issue a DESCRIBE command on the USER_DEPENDENCIES view to review the available columns. If you query this table for the name of a specific object, a list of all the objects it references is displayed. However, if you query for a specific referenced name, you see a list of objects that are dependent on this particular object.
-- 4. Say you intend to make a modification to the BB_BASKET table and need to identify all dependent program units to finish recompiling. Run the following query to list all objects that are dependent on the BB_BASKET table:
-- SELECT name, type
-- FROM user_dependencies
-- WHERE referenced_name = 'BB_BASKET';

DESCRIBE USER_OBJECTS

SELECT
    OBJECT_NAME,
    STATUS,
    TIMESTAMP
FROM
    USER_OBJECTS
WHERE
    OBJECT_TYPE = 'PROCEDURE';

DESCRIBE USER_DEPENDENCIES;

SELECT
    name,
    type
FROM
    user_dependencies
WHERE
    referenced_name = 'BB_BASKET';

-- ## Question 2

-- Assignment 8-2: Testing Dependencies on Stand-Alone Program Units
-- In this assignment, you verify the effect of object modifications on the status of dependent objects. You work with a procedure and a function.
-- 1. In a text editor, open the assignment08-02.txt file in the Chapter08 folder. This file contains statements to create the STATUS_CHECK_SP procedure and the STATUS_DESC_SF function. Review the code, and notice that the procedure includes a call to the function. Use the code in this file to create the two program units in SQL Developer.
-- 2. Enter and run the following query to verify that the status of both objects is VALID:
-- SELECT object_name, status
-- FROM user_objects
-- WHERE object_name IN ('STATUS_CHECK_SP','STATUS_DESC_SF');

CREATE OR REPLACE FUNCTION status_desc_sf
  (p_stage IN NUMBER)
  RETURN VARCHAR2
 IS
  lv_stage_txt VARCHAR2(30);
BEGIN
 IF p_stage = 1 THEN
   lv_stage_txt := 'Order Submitted';
 ELSIF p_stage = 2 THEN
   lv_stage_txt := 'Accepted, sent to shipping';
 ELSIF p_stage = 3 THEN
   lv_stage_txt := 'Backordered';
 ELSIF p_stage = 4 THEN
   lv_stage_txt := 'Cancelled';
 ELSIF p_stage = 5 THEN
   lv_stage_txt := 'Shipped';
 END IF;
 RETURN lv_stage_txt;
END;

CREATE OR REPLACE PROCEDURE status_check_sp
  (p_bask IN NUMBER,
   p_stage OUT NUMBER,
   p_desc OUT VARCHAR2)
 IS
BEGIN
  SELECT idstage
   INTO p_stage
   FROM bb_basketstatus
   WHERE idBasket = p_bask;
  p_desc := status_desc_sf(p_stage);
END;
/

SELECT object_name, status
FROM user_objects
WHERE object_name IN ('STATUS_CHECK_SP','STATUS_DESC_SF');

-- 3. The STATUS_DESC_SF function adds a description of the numeric value for the IDSTAGE column. The company needs to add another order status stage for situations in which credit card approval fails. In SQL Developer, modify the function by adding the following ELSIF clause, and compile it. (Don’t compile or run the function again.)
-- ELSIF p_stage = 6 THEN
-- lv_stage_txt := 'Credit Card Not Approved';
-- 4. Does the modification in Step 3 affect the STATUS_CHECK_SP procedure’s status? Verify by repeating the query in Step 2. The procedure is dependent on the function, so it’s now INVALID and must be recompiled.
-- 5. Call the procedure for basket 13, as shown in the following code:
-- DECLARE
-- lv_stage_num NUMBER(2); lv_desc_txt VARCHAR2(30);
-- BEGIN status_check_sp(13,lv_stage_num,lv_desc_txt); END;
-- 6. Repeat the query in Step 2 to verify the STATUS_CHECK_SP procedure’s status. The procedure now shows the status VALID as a result of automatic recompiling when the procedure was called.
