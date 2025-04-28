CREATE DATABASE SNAKE_ECOMERCE_DB;

CREATE SCHEMA SNAKE_ECOMERCE_DB.RAW_DATA;


-- Creating Temporary Table for Raw Data in a VARCHAR format for every column
-- That way we don't get error on records with invalid data
CREATE TEMPORARY TABLE SNAKE_ECOMERCE_DB.RAW_DATA.ECOMERCE_ORDERS_RAW (
    Order_ID VARCHAR,
    Customer_ID VARCHAR,
    Customer_Name VARCHAR,
    Order_Date VARCHAR,
    Product VARCHAR,
    Quantity VARCHAR,
    Price VARCHAR,
    Discount VARCHAR,
    Total_Amount VARCHAR,
    Payment_Method VARCHAR,
    Shipping_Address VARCHAR,
    Status VARCHAR,
    Flag VARCHAR -- This flag will help us eliminate duplicates inside the different transient tables for invalid records
);


-- Using the DB we've created for global tools in class and the file format I've created then
-- That way we know there are all the stages and everything is in one place
CREATE STAGE _SNAKE_GLOBAL_TOOLS.STAGES.STG_ECOMERCE_DATA
FILE_FORMAT = _SNAKE_GLOBAL_TOOLS.STAGES.CSV_FORMAT;

-- After creating the stage we go into the Snowflake UI to upload the csv files 
-- Then we execute the next COPY INTO statement!

COPY INTO SNAKE_ECOMERCE_DB.RAW_DATA.ECOMERCE_ORDERS_RAW (
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
FROM @_SNAKE_GLOBAL_TOOLS.STAGES.STG_ECOMERCE_DATA/ecommerce_orders.csv; -- add file with it's name and format


