-- Creating SCHEMA for the Valid records
CREATE SCHEMA SNAKE_ECOMERCE_DB.VALID_DATA;

CREATE TABLE SNAKE_ECOMERCE_DB.VALID_DATA.TD_CLEAN_RECORDS (
    Order_ID INT,
    Customer_ID VARCHAR,
    Customer_Name VARCHAR,
    Order_Date DATE,
    Product VARCHAR,
    Quantity INT,
    Price FLOAT,
    Discount FLOAT,
    Total_Amount FLOAT,
    Payment_Method VARCHAR,
    Shipping_Address VARCHAR,
    Status VARCHAR
);

-- Using Inser Into so we can calculate accurately the Total Price
INSERT INTO SNAKE_ECOMERCE_DB.VALID_DATA.TD_CLEAN_RECORDS
SELECT Order_ID,
        Customer_ID,
        Customer_Name,
        Order_Date,
        Product,
        Quantity,
        Price,
        Discount,
        -- Calculate Actual Total Price based on fixed discount, quantity and price
        (Quantity * Price * (1 - Discount)) AS Total_Amount,
        Payment_Method,
        Shipping_Address,
        Status
FROM (
    SELECT DISTINCT
        TRY_TO_NUMBER(Order_ID) AS Order_ID,
        Customer_ID,
        Customer_Name,
        Product,
        TRY_TO_NUMBER(Quantity) AS Quantity,
        TRY_TO_DECIMAL(Price, 10, 2) AS Price,
        TRY_TO_DATE(Order_Date, 'YYYY-MM-DD') AS Order_Date,

        -- Cases for Discount:
        CASE
            WHEN TRY_TO_DECIMAL(Discount, 10, 2) < 0 THEN 0
            WHEN TRY_TO_DECIMAL(Discount, 10, 2) > 0.5 THEN 0.5
            ELSE TRY_TO_DECIMAL(Discount, 10, 2)
        END AS Discount,

        -- Cases for Payment Method:
        CASE   
            WHEN TRIM(Payment_Method) IS NULL OR TRIM(Payment_Method) = '' THEN 'Unknown'
            ELSE Payment_Method
        END AS Payment_Method,

        Shipping_Address,
        Status

    FROM SNAKE_ECOMERCE_DB.RAW_DATA.ECOMERCE_ORDERS_RAW
    WHERE Flag = 'VALID'
) AS a;


-- Count of Unique Records in Raw Table:
SELECT COUNT(*) AS Raw_Records_Count
FROM (
    SELECT DISTINCT *
    FROM SNAKE_ECOMERCE_DB.RAW_DATA.ECOMERCE_ORDERS_RAW
) AS t;



-- Count of Records in all different tables collected:
SELECT 'TD_INVALID_DATE_FORMAT' AS Table_Name, COUNT(*) AS Record_Count
FROM SNAKE_ECOMERCE_DB.INVALID_DATA.TD_INVALID_DATE_FORMAT
UNION ALL
SELECT 'TD_FOR_REVIEW' AS Table_Name, COUNT(*) AS Record_Count
FROM SNAKE_ECOMERCE_DB.INVALID_DATA.TD_FOR_REVIEW
UNION ALL
SELECT 'TD_SUSPICIOUS_RECORDS' AS Table_Name, COUNT(*) AS Record_Count
FROM SNAKE_ECOMERCE_DB.INVALID_DATA.TD_SUSPICIOUS_RECORDS
UNION ALL
SELECT 'TD_INVALID_QUANTITY' AS Table_Name, COUNT(*) AS Record_Count
FROM SNAKE_ECOMERCE_DB.INVALID_DATA.TD_INVALID_QUANTITY
UNION ALL
SELECT 'TD_CLEAN_RECORDS' AS Table_Name, COUNT(*) AS Record_Count
FROM SNAKE_ECOMERCE_DB.VALID_DATA.TD_CLEAN_RECORDS
UNION ALL
SELECT 'TOTAL_RECORDS' AS Table_Name,
        ((SELECT COUNT(*) FROM SNAKE_ECOMERCE_DB.INVALID_DATA.TD_INVALID_DATE_FORMAT) + 
        (SELECT COUNT(*) FROM SNAKE_ECOMERCE_DB.INVALID_DATA.TD_FOR_REVIEW) +
        (SELECT COUNT(*) FROM SNAKE_ECOMERCE_DB.INVALID_DATA.TD_SUSPICIOUS_RECORDS) +
        (SELECT COUNT(*) FROM SNAKE_ECOMERCE_DB.INVALID_DATA.TD_INVALID_QUANTITY) +
        (SELECT COUNT(*) FROM SNAKE_ECOMERCE_DB.VALID_DATA.TD_CLEAN_RECORDS)
    ) AS Record_Count;
