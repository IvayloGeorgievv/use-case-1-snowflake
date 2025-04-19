CREATE DATABASE SNAKE_ECOMERCE_DB;

USE DATABASE SNAKE_ECOMERCE_DB;

CREATE SCHEMA RAW_STAGE;

USE SCHEMA RAW_STAGE;

-- Creating Temporary Table for Raw Data in a VARCHAR format for every column
-- That way we don't get error on records with invalid data
CREATE TEMPORARY TABLE ECOMERCE_ORDERS_RAW (
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


CREATE FILE FORMAT CSV_ECOMERCE_FORMAT
TYPE = CSV -- Type of file
FIELD_OPTIONALLY_ENCLOSED_BY = '"'  -- Some columns/attributes can be enclosed by double quotes - " "
SKIP_HEADER = 1; -- Skipping the header row so only data rows are processed

CREATE STAGE EXTERNAL_STAGE_CSV_ECOMERCE_DATA
FILE_FORMAT = CSV_ECOMERCE_FORMAT; 


COPY INTO ECOMERCE_ORDERS_RAW (
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
FROM @EXTERNAL_STAGE_CSV_ECOMERCE_DATA/ecommerce_orders.csv; -- add file with it's name and format


