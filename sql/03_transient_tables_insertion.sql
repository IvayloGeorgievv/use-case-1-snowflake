----------------------------------------------
------------INVALID DATE RECORDS--------------
----------------------------------------------

CREATE TRANSIENT TABLE TD_INVALID_DATE_FORMAT ( -- Table for records with Invalid Dates
    Order_ID INT,
    Customer_ID VARCHAR,
    Customer_Name VARCHAR,
    Order_Date VARCHAR, -- Keep invalid date format records as VARCHAR so INSERT does not fail
    Product VARCHAR,
    Quantity INT,
    Price FLOAT,
    Discount FLOAT,
    Total_Amount FLOAT,
    Payment_Method VARCHAR,
    Shipping_Address VARCHAR,
    Status VARCHAR
);


INSERT INTO TD_INVALID_DATE_FORMAT (
    Order_ID,
    Customer_ID,
    Customer_Name,
    Order_Date,
    Product,
    Quantity,
    Price,
    Discount,
    Total_Amount,
    Payment_Method,
    Shipping_Address,
    Status
)
SELECT DISTINCT 
    TRY_TO_NUMBER(Order_ID) AS Order_ID,
    Customer_ID,
    Customer_Name,
    Order_Date,
    Product,
    TRY_TO_NUMBER(Quantity) AS Quantity,
    TRY_TO_DECIMAL(Price, 10, 2) AS Price,
    TRY_TO_DECIMAL(Discount, 10, 2) AS Discount,
    TRY_TO_DECIMAL(Total_Amount, 10, 2) AS Total_Amount,
    Payment_Method,
    Shipping_Address,
    Status
FROM ECOMERCE_ORDERS_RAW
WHERE Flag = 'INVALID_DATE';


----------------------------------------------
--------RECORDS WITHOUT SHIPPING ADDRESS------
----------------------------------------------

-- Table for Records without Shipping Address
CREATE TABLE TD_FOR_REVIEW (
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


INSERT INTO TD_FOR_REVIEW (
    Order_ID,
    Customer_ID,
    Customer_Name,
    Order_Date,
    Product,
    Quantity,
    Price,
    Discount,
    Total_Amount,
    Payment_Method,
    Shipping_Address,
    Status
)
SELECT DISTINCT 
    TRY_TO_NUMBER(Order_ID) AS Order_ID,
    Customer_ID,
    Customer_Name,
    TRY_TO_DATE(Order_Date, 'YYYY-MM-DD') AS Order_Date,
    Product,
    TRY_TO_NUMBER(Quantity) AS Quantity,
    TRY_TO_DECIMAL(Price, 10, 2) AS Price,
    TRY_TO_DECIMAL(Discount, 10, 2) AS Discount,
    TRY_TO_DECIMAL(Total_Amount, 10, 2) AS Total_Amount,
    Payment_Method,
    Shipping_Address,
    Status
FROM ECOMERCE_ORDERS_RAW
WHERE Flag = 'MISSING_SHIPPING_ADDRESS';



----------------------------------------------
----------------INVALID QUANTITY--------------
----------------------------------------------

CREATE TRANSIENT TABLE TD_INVALID_QUANTITY (
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


INSERT INTO TD_INVALID_QUANTITY (
    Order_ID,
    Customer_ID,
    Customer_Name,
    Order_Date,
    Product,
    Quantity,
    Price,
    Discount,
    Total_Amount,
    Payment_Method,
    Shipping_Address,
    Status
)
SELECT DISTINCT
    TRY_TO_NUMBER(Order_ID) AS Order_ID,
    Customer_ID,
    Customer_Name,
    TRY_TO_DATE(Order_Date) AS Order_Date,
    Product,
    TRY_TO_NUMBER(Quantity) AS Quantity,
    TRY_TO_DECIMAL(Price, 10, 2) AS Price,
    TRY_TO_DECIMAL(Discount, 10, 2) AS Discount,
    TRY_TO_DECIMAL(Total_Amount, 10, 2) AS Total_Amount,
    Payment_Method,
    Shipping_Address,
    Status
FROM ECOMERCE_ORDERS_RAW
WHERE Flag = 'INVALID_QUANTITY_PRICE';



----------------------------------------------
----------------SUSPICIOUS RECORDS------------
----------------------------------------------

CREATE TRANSIENT TABLE TD_SUSPICIOUS_RECORDS (
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


INSERT INTO TD_SUSPICIOUS_RECORDS (
    Order_ID,
    Customer_ID,
    Customer_Name,
    Order_Date,
    Product,
    Quantity,
    Price,
    Discount,
    Total_Amount,
    Payment_Method,
    Shipping_Address,
    Status
)
SELECT DISTINCT
    TRY_TO_NUMBER(Order_ID) AS Order_ID,
    Customer_ID,
    Customer_Name,
    TRY_TO_DATE(Order_Date, 'YYYY-MM-DD') AS Order_Date,
    Product,
    TRY_TO_NUMBER(Quantity) AS Quantity,
    TRY_TO_DECIMAL(Price, 10, 2) AS Price,
    TRY_TO_DECIMAL(Discount, 10, 2) AS Discount,
    TRY_TO_DECIMAL(Total_Amount, 10, 2) AS Total_Amount,
    Payment_Method,
    Shipping_Address,
    Status
FROM ECOMERCE_ORDERS_RAW
WHERE Flag = 'MISSING_CUSTOMER_INFO';



