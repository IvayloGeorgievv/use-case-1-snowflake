-- Based on Order of Priority I update the flag in the raw data records and later that would help me with inserting them into correct tables
UPDATE ECOMERCE_ORDERS_RAW
SET Flag = CASE
    WHEN TRY_TO_DATE(Order_Date, 'YYYY-MM-DD') IS NULL
        THEN 'INVALID_DATE'
    WHEN ((Shipping_Address IS NULL OR TRIM(Shipping_Address) = '')
            AND UPPER(Status) IN ('DELIVERED', 'SHIPPED'))
        THEN 'MISSING_SHIPPING_ADDRESS'
    WHEN TRY_TO_NUMBER(Quantity) <= 0 OR TRY_TO_DECIMAL(Price, 10, 2) <= 0 
        THEN 'INVALID_QUANTITY_PRICE'
    WHEN Customer_ID IS NULL OR TRIM(Customer_ID) = ''
            OR Customer_Name IS NULL OR TRIM(Customer_Name) = ''
        THEN 'MISSING_CUSTOMER_INFO'
    ELSE 'VALID'
END;


--Count of records with different flags
SELECT Flag, COUNT(*) AS Record_Count
FROM ECOMERCE_ORDERS_RAW
GROUP BY Flag;