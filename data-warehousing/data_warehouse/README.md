Airline Passenger Data Warehouse

Project Overview

This project focuses on designing and implementing a data warehouse to support the analysis of airline passenger information and flight operations.

Airline data is often stored across multiple datasets, making it difficult to analyse passenger demographics, airport activity, and flight performance together.

The project addresses this problem by integrating multiple data sources into a structured star-schema data warehouse, allowing users to perform multidimensional analysis and answer business questions efficiently.

The warehouse was implemented using PostgreSQL and Databricks, with Tableau used for data visualisation and business reporting.

Project Objectives

Design and implement a data warehouse using dimensional modelling principles.

Develop an ETL process to clean, transform, and integrate multiple airline datasets.

Implement a star schema with fact and dimension tables.

Use SQL and OLAP operations to analyse passenger and flight patterns.

Apply association rule mining to identify potential relationships between passenger characteristics and flight status.

Technologies Used

Technology

Purpose

Python

Data cleaning and transformation

pandas

Data preparation and ETL

PostgreSQL

Relational data warehouse

Databricks

Data warehouse implementation and analysis

SQL

Database creation and analytical queries

Tableau

Data visualisation and reporting

mlxtend

Apriori association rule mining

Data Sources

The project integrates four datasets:

Airline Passenger Dataset: Passenger demographics, departure dates, airports, and flight status.

Airport Dataset: Airport names, geographic information, and airport sizes.

Country Dataset: Country-level geographic information.

Region Dataset: Regional information associated with countries.

These datasets were cleaned and combined before being transformed into the data warehouse structure.

Methodology

1. Data Preparation and ETL

An ETL process was developed using Python and pandas to prepare the data for dimensional modelling.

The process involved:

Importing and inspecting multiple datasets.

Identifying missing values and duplicate records.

Standardising column names and data formats.

Joining datasets using airport and geographic identifiers.

Handling unmatched airport records.

Creating additional attributes such as age groups and departure quarters.

Generating fact and dimension tables for the data warehouse.

The resulting datasets were exported for loading into PostgreSQL and Databricks.

2. Data Warehouse Design

A star schema was designed using a factless fact table to represent passenger departure events.

Each fact table record represents a passenger departure event associated with a specific airport, date, and flight status.

The warehouse consists of:

Fact Table

Fact_Flights

Dimension Tables

Dim_Passenger

Dim_Nationality

Dim_Date

Dim_Location

Dim_Airport

Dim_Status

This structure supports analysis across passenger demographics, geographic locations, airport characteristics, time periods, and flight status.

3. Data Warehouse Implementation

The dimensional model was implemented in both PostgreSQL and Databricks.

The implementation involved creating database tables, defining primary and foreign keys, loading the transformed data, and establishing relationships between the fact and dimension tables.

The warehouse was then connected to Tableau to support analytical queries and visualisations.

4. Business Analysis and OLAP

Five business questions were developed to demonstrate the analytical capabilities of the warehouse:

Which countries recorded the highest passenger volumes in 2022?

Which nationalities contributed most to passenger activity in Australia, and during which quarters?

How did flight delays and cancellations vary across quarters?

How did flight status differ across airport sizes in Australia?

Which age groups contributed the most passenger activity across Australian regions?

SQL queries and Tableau visualisations were used to explore these questions through aggregation, filtering, and multidimensional analysis.

5. Association Rule Mining

In addition to traditional OLAP analysis, the project applied the Apriori algorithm to investigate associations between passenger characteristics, airport attributes, and flight status.

Association rules were evaluated using:

Support: How frequently an item combination occurs.

Confidence: How frequently an outcome occurs when specified conditions are present.

Lift: How strongly two events are associated relative to their overall frequencies.

Flight status was selected as the outcome of interest.

Key Findings

The OLAP analysis demonstrated how an integrated data warehouse can support comparisons across passenger demographics, airports, regions, and time periods.

The analysis explored variations in passenger activity, seasonal travel patterns, and flight performance across different airport categories.

However, association rule mining did not identify strong relationships with flight status. The strongest rules had lift values close to 1, suggesting that the selected passenger and airport attributes provided limited explanatory value.

This highlights the importance of evaluating analytical results rather than assuming that every discovered pattern is meaningful.

Project Limitations

Several limitations were identified:

The source data lacked certain operational variables needed for more detailed flight analysis.

An issue with airport fields prevented reliable origin-to-destination route analysis.

Some records could not be matched to airport information during data integration.

Association rule mining produced weak relationships, limiting the usefulness of the resulting rules.

The analysis was based on the available 2022 dataset and should not be treated as a comprehensive representation of the aviation industry.

Conclusion

This project demonstrates the end-to-end process of transforming raw operational data into a structured data warehouse for business analytics.

Through ETL development, dimensional modelling, database implementation, SQL analysis, and data visualisation, the project illustrates how data warehousing supports the integration and exploration of information from multiple sources.

The additional association rule mining component demonstrates how data mining techniques can complement traditional business intelligence while highlighting the importance of critically interpreting analytical findings.

Project Context

This project was completed collaboratively as part of CITS5504 Data Warehouse at the University of Western Australia (2026).

Project contributors: Jason Wong and Chalaka Nawarathna.