#This is the Python code I've used when I created the Streamlit app via the Snowflake UI ->

# Import packages
import streamlit as st
import pandas as pd
from snowflake.snowpark.context import get_active_session

st.set_page_config(page_title="Ecommerce Data Explorer", layout="wide")
st.title("Ecommerce Data Explorer")
st.markdown("View Raw, Invalid and Valid Data Sets")

session = get_active_session()

# Queries to load each dataset valid or not

query_valid = """
SELECT * 
FROM SNAKE_ECOMERCE_DB.VALID_DATA.TD_CLEAN_RECORDS
"""

query_invalid_date = """
SELECT * 
FROM SNAKE_ECOMERCE_DB.INVALID_DATA.TD_INVALID_DATE_FORMAT
"""

query_missing_address = """
SELECT * 
FROM SNAKE_ECOMERCE_DB.INVALID_DATA.TD_FOR_REVIEW
"""

query_invalid_quantity = """
SELECT * 
FROM SNAKE_ECOMERCE_DB.INVALID_DATA.TD_INVALID_QUANTITY
"""

query_missing_customer_info = """
SELECT * 
FROM SNAKE_ECOMERCE_DB.INVALID_DATA.TD_SUSPICIOUS_RECORDS
"""

# Loading datasets into pandas dataframes
data_valid = session.sql(query_valid).to_pandas()
data_invalid_date = session.sql(query_invalid_date).to_pandas()
data_missing_address = session.sql(query_missing_address).to_pandas()
data_invalid_quantity = session.sql(query_invalid_quantity).to_pandas()
data_missing_customer_info = session.sql(query_missing_customer_info).to_pandas()

# Creating simple sidebar to choose what to display
dataset_choice = st.sidebar.selectbox(
    "Select Data Set to View:",
    (
        "Valid Data",
        "Invalid Data - Date Format",
        "Invalid Data - Missing Shipping Address",
        "Invalid Data - Invalid Quantity/Price",
        "Invalid Data - Missing Customer Info"
    )
)

# Based on choice, display data
if dataset_choice == "Valid Data":
    st.header("Valid Orders")
    st.dataframe(data_valid, use_container_width=True)

elif dataset_choice == "Invalid Data - Date Format":
    st.header("Invalid Orders - Date Format")
    st.dataframe(data_invalid_date, use_container_width=True)

elif dataset_choice == "Invalid Data - Missing Shipping Address":
    st.header("Invalid Orders - Missing Shipping Address")
    st.dataframe(data_missing_address, use_container_width=True)

elif dataset_choice == "Invalid Data - Invalid Quantity/Price":
    st.header("Invalid Orders - Quantity/Price")
    st.dataframe(data_invalid_quantity, use_container_width=True)

elif dataset_choice == "Invalid Data - Missing Customer Info":
    st.header("Invalid Orders - Missing Customer Information")
    st.dataframe(data_missing_customer_info, use_container_width=True)

# Sidebar Metrics
st.sidebar.markdown("---")
st.sidebar.metric("Valid Records", f"{len(data_valid):,}")
st.sidebar.metric("Invalid Date Records", f"{len(data_invalid_date):,}")
st.sidebar.metric("Missing Shipping Records", f"{len(data_missing_address):,}")
st.sidebar.metric("Invalid Quantity/Price Records", f"{len(data_invalid_quantity):,}")
st.sidebar.metric("Missing Customer Info Records", f"{len(data_missing_customer_info):,}")
