# Group Lab Activity #3 – March 28, 2024

## Question 1

Assignment 8-1: Reviewing Dependency Informa;on in the Data Dic;onary
Two data dic/onary views store informa/on on dependencies: USER_OBJECTS and
USER_DEPENDENCIES. Take a closer look at these views to examine the informa/on in them:
1. In SQL Developer, issue a DESCRIBE command on the USER_OBJECTS view and review the
available columns. Which columns are par/cularly relevant to dependencies? The STATUS
column indicates whether the object is VALID or INVALID. The TIMESTAMP column is used in
remote connec/ons to determine invalida/on.
2. Query the USER_OBJECTS view, selec/ng the OBJECT_NAME, STATUS, and TIMESTAMP columns
for all procedures. Recall that you can use a WHERE clause to look for object types of
PROCEDURE to list only procedure informa/on.
3. Now issue a DESCRIBE command on the USER_DEPENDENCIES view to review the available
columns. If you query this table for the name of a specific object, a list of all the objects it
references is displayed. However, if you query for a specific referenced name, you see a list of
objects that are dependent on this par/cular object.
4. Say you intend to make a modifica/on to the BB_BASKET table and need to iden/fy all
dependent program units to finish recompiling. Run the following query to list all objects that
are dependent on the BB_BASKET table:
 SELECT name, type
FROM user_dependencies
WHERE referenced_name = 'BB_BASKET';

## Question 2

Assignment 8-2: Tes;ng Dependencies on Stand-Alone Program Units
In this assignment, you verify the effect of object modifica/ons on the status of dependent objects. You
work with a procedure and a func/on.
1. In a text editor, open the assignment08-02.txt file in the Chapter08 folder. This file contains
statements to create the STATUS_CHECK_SP procedure and the STATUS_DESC_SF func/on.
Review the code, and no/ce that the procedure includes a call to the func/on. Use the code in
this file to create the two program units in SQL Developer.
2. Enter and run the following query to verify that the status of both objects is VALID:
 SELECT object_name, status
FROM user_objects
WHERE object_name IN
('STATUS_CHECK_SP','STATUS_DESC_SF');
3. The STATUS_DESC_SF func/on adds a descrip/on of the numeric value for the IDSTAGE column.
The company needs to add another order status stage for situa/ons in which credit card
approval fails. In SQL Developer, modify the func/on by adding the following ELSIF clause, and
compile it. (Don’t compile or run the func/on again.)
ELSIF p_stage = 6 THEN
lv_stage_txt := 'Credit Card Not Approved';
4. Does the modifica/on in Step 3 affect the STATUS_CHECK_SP procedure’s status? Verify by
repea/ng the query in Step 2. The procedure is dependent on the func/on, so it’s now INVALID
and must be recompiled.
5. Call the procedure for basket 13, as shown in the following code:
 DECLARE
lv_stage_num NUMBER(2);
lv_desc_txt VARCHAR2(30);
 BEGIN
status_check_sp(13,lv_stage_num,lv_desc_txt);
 END;
6. Repeat the query in Step 2 to verify the STATUS_CHECK_SP procedure’s status. The procedure
now shows the status VALID as a result of automa/c recompiling when the procedure was
called.