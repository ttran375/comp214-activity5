-- 1. Assignment 7-2 from text: Using Program Units in a Package
-- In this activity, you use program units in a package created to store basket information. The
-- package contains a function that returns the recipient’s name and a procedure that retrieves the
-- shopper ID and order date for a basket.
-- a. In SQL Developer, create the ORDER_INFO_PKG package, using the Assignment07-
-- 02.txt file located in eCentennial. Review the code to become familiar with the two
-- program units in the package.
-- b. Create an anonymous block that calls both the packaged procedure and function with
-- basket ID 12 to test these program units. Use DBMS_OUTPUT statements to display
-- values returned from the program units to verify the data.
-- c. Also, test the packaged function by using it in a SELECT clause on the BB_BASKET
-- table.
-- d. Use a WHERE clause to select only the basket 12 row.
CREATE OR REPLACE PACKAGE order_info_pkg IS

    FUNCTION ship_name_pf (
        p_basket IN NUMBER
    ) RETURN VARCHAR2;

    PROCEDURE basket_info_pp (
        p_basket IN NUMBER,
        p_shop OUT NUMBER,
        p_date OUT DATE
    );
END;
/

CREATE OR REPLACE PACKAGE BODY order_info_pkg IS

    FUNCTION ship_name_pf (
        p_basket IN NUMBER
    ) RETURN VARCHAR2 IS
        lv_name_txt VARCHAR2(25);
    BEGIN
        SELECT
            shipfirstname
            ||' '
            ||shiplastname INTO lv_name_txt
        FROM
            bb_basket
        WHERE
            idBasket = p_basket;
        RETURN lv_name_txt;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Invalid basket id');
    END ship_name_pf;

    PROCEDURE basket_info_pp (
        p_basket IN NUMBER,
        p_shop OUT NUMBER,
        p_date OUT DATE
    ) IS
    BEGIN
        SELECT
            idshopper,
            dtordered INTO p_shop,
            p_date
        FROM
            bb_basket
        WHERE
            idbasket = p_basket;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Invalid basket id');
    END basket_info_pp;
END;
/

-- test procedure and function in block (returns nulls)
DECLARE
    lv_id      NUMBER := 12;
    lv_name    VARCHAR2(25);
    lv_shopper bb_basket.idshopper%type;
    lv_date    bb_basket.dtcreated%type;
BEGIN
 -- test function
    lv_name := order_info_pkg.ship_name_pf(lv_id);
    dbms_output.put_line(lv_id
                         ||' '
                         ||lv_name);
 -- test procedure
    order_info_pkg.basket_info_pp(lv_id, lv_shopper, lv_date);
    dbms_output.put_line(lv_id
                         ||' '
                         ||lv_shopper
                         ||' '
                         ||lv_date);
END;
/

-- test with select - again, prints nothing
SELECT
    lpad(order_info_pkg.ship_name_pf(idbasket), 20) "ship_name_pf on 12"
FROM
    bb_basket
WHERE
    idbasket = 12;

/

-- 2. Assignment 7-3 from text: Creating a Package with Private Program Units
-- In this activity, you modify a package to make program units private. The Brewbean’s
-- programming group decided that the SHIP_NAME_PF function in the ORDER_INFO_PKG
-- package should be used only from inside the package. Follow these steps to make this
-- modification:
-- a. In Notepad, open the Assignment07-03.txt file in the Chapter07 folder, and review the
-- package code.
-- b. Modify the package code to add to the BASKET_INFO_PP procedure so that it also
-- returns the name an order is shipped by using the SHIP_NAME_PF function. Make the
-- necessary changes to make the SHIP_NAME_PF function private.
-- c. Create the package by using the modified code.
-- d. Create and run an anonymous block that calls the BASKET_INFO_PP procedure and
-- displays the shopper ID, order date, and shipped-to name to check the values returned.
-- e. Use DBMS_OUTPUT statements to display the values.
CREATE OR REPLACE PACKAGE order_info_pkg IS
 -- deleted function
    PROCEDURE basket_info_pp (
        p_basket IN NUMBER,
        p_shop OUT NUMBER,
        p_date OUT DATE,
        p_ship OUT VARCHAR
    ); -- added out variable
END;
/

CREATE OR REPLACE PACKAGE BODY order_info_pkg IS

    FUNCTION ship_name_pf (
        p_basket IN NUMBER
    ) RETURN VARCHAR2 IS
        lv_name_txt VARCHAR2(25);
    BEGIN
        SELECT
            shipfirstname
            ||' '
            ||shiplastname INTO lv_name_txt
        FROM
            bb_basket
        WHERE
            idBasket = p_basket;
        RETURN lv_name_txt;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Invalid basket id');
    END ship_name_pf;

    PROCEDURE basket_info_pp (
        p_basket IN NUMBER,
        p_shop OUT NUMBER,
        p_date OUT DATE,
        p_ship OUT VARCHAR
    ) -- added out variable
    IS
    BEGIN
        SELECT
            idshopper,
            dtordered INTO p_shop,
            p_date
        FROM
            bb_basket
        WHERE
            idbasket = p_basket;
        p_ship := ship_name_pf(p_basket); -- out variable used here
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Invalid basket id');
    END basket_info_pp;
END;
/

-- test procedure in block, this time I used basket
-- id 6, so we could actually see a name
DECLARE
    lv_id      NUMBER := 6;
    lv_name    VARCHAR2(25);
    lv_shopper bb_basket.idshopper%type;
    lv_date    bb_basket.dtcreated%type;
BEGIN
 -- test procedure
    order_info_pkg.basket_info_pp(lv_id, lv_shopper, lv_date, lv_name);
    dbms_output.put_line(lv_id
                         ||' '
                         ||lv_shopper
                         ||' '
                         ||lv_date
                         ||' '
                         ||lv_name);
END;
/
