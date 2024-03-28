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
DESC user_objects;

/

SELECT
  rpad(object_name, 23) "OBJECT_NAME",
  status,
  timestamp
FROM
  user_objects
WHERE
  object_type = 'PROCEDURE';

/

desc user_dependencies;

/

column name format a15

SELECT
  name,
  type
FROM
  user_dependencies
WHERE
  referenced_name = 'BB_BASKET';

/
