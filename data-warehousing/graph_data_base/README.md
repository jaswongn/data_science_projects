Airline Route Network — Neo4j Graph Database

Project Overview

This project designs and implements a graph database for exploring airline routes and connections. Rather than storing the network only in relational tables, the project represents airlines, airports, aircraft types, and flight-service records as nodes connected by relationships.

Using Python, pandas, Neo4j, and Cypher, the project transforms a raw airline-route dataset into a property graph and answers questions about connectivity, multi-stop routes, aircraft types, and competition between airlines.

Project Objectives

Design a property graph that represents airlines, airports, aircraft, and flight-service records.

Build an ETL workflow to clean and transform source data into node and relationship files.

Load and validate the graph in Neo4j.

Use Cypher to analyse routes, airport connections, and airline competition.

Explore how graph modelling supports network-based business questions.

Tools and Technologies

Technology

Purpose

Python and pandas

Data cleaning, transformation, and preparation of graph files

Neo4j

Property graph database

Cypher

Data loading, graph traversal, and analytical queries

Neo4j APOC

Additional graph procedures and metadata exploration

Neo4j Arrows

Property graph schema design

Jupyter Notebook

ETL development and data inspection

Dataset

The project uses an airline-route dataset containing airline names and countries, departure and arrival airports, and aircraft types associated with route records.

An important preparation step was splitting the Plane Name field, which contained multiple aircraft types separated by semicolons. The dataset did not provide suitable unique identifiers for all graph entities, so surrogate IDs were generated during ETL.

The data represents the route/service records supplied for the project; it should not be interpreted as a complete, current flight timetable or as actual passenger traffic.

Graph Database Design

The graph contains four node types:

Node

Description

Airline

Airline operating a service

Airport

Departure or arrival airport

Airplane

Aircraft type associated with a service

Flight

A unique flight-service record in the prepared dataset

Five relationship types connect these nodes:

Relationship

Meaning

OPERATED_BY

Flight → Airline

DEPARTS_FROM

Flight → Airport

ARRIVES_AT

Flight → Airport

USES

Flight → Airplane

ROUTES

Airport → Airport

graph LR
    F[Flight] -->|OPERATED_BY| L[Airline]
    F -->|USES| P[Airplane]
    F -->|DEPARTS_FROM| D[Departure Airport]
    F -->|ARRIVES_AT| A[Arrival Airport]
    D -->|ROUTES| A

The departure and arrival airport boxes above illustrate roles of the same Airport node type, not two separate node types.

Methodology

1. Data Cleaning and Transformation

Python and pandas were used to inspect the dataset, remove duplicates and unnecessary whitespace, expand multiple aircraft types, and generate surrogate keys. Distinct node tables and their corresponding relationship tables were then prepared and exported as CSV files.

2. Graph Implementation

The CSV files were imported into Neo4j using Cypher's LOAD CSV WITH HEADERS workflow. Indexes on node identifiers were introduced after relationship imports proved slow, improving the practicality of linking records at scale.

3. Validation

The completed graph was checked using Cypher queries to inspect node labels, relationship types, totals, and sample connections. The report records 60,739 nodes, including 57,301 Flight nodes.

4. Network Analysis with Cypher

The analytical queries explored questions such as:

Which airlines are associated with Australia?

How many supplied route records are domestic versus international?

Which airport pairs appear most frequently in the dataset?

Which airport pairs are served by the widest variety of aircraft types?

What multi-hop routes connect Beijing Capital International Airport and Perth International Airport?

Which airline pairs share the most routes and may compete directly?

The project also used Neo4j procedures to inspect graph connections and metadata.

Selected Findings

Network connectivity: The route graph supported multi-hop searches that would be cumbersome to express using simple tabular summaries. One query returned 599 distinct paths from Beijing Capital International Airport to Perth International Airport using at most three route relationships in the supplied dataset.

Route competition: Shared airport pairs were used to identify airlines serving overlapping routes.

Aircraft diversity: Queries compared airport pairs by the number of distinct aircraft types appearing in their route records.

Data engineering: Adding indexes addressed slow relationship-loading operations during Neo4j import.

These results describe the provided dataset, not verified real-world itinerary availability or airline market share.

Limitations

The analysis is limited to the coverage and accuracy of the supplied airline-route dataset.

Route records do not provide verified flight schedules, travel times, prices, or passenger volumes.

Multi-hop paths indicate graph connectivity; they do not guarantee feasible transfers or bookable itineraries.

Modelling each service record as a Flight node can create a large graph, while the direct ROUTES relationship duplicates connectivity that can also be derived through flight nodes.

Graph algorithms such as degree centrality and Dijkstra's shortest path were discussed as possible extensions, not implemented as part of the reported analysis.

Reproducing the Project

Obtain the original airline-route dataset, subject to its sharing and licensing conditions.

Run the project's Python ETL notebook to generate node and relationship CSV files.

Create a Neo4j database and import the CSV files using the project's Cypher loading queries.

Create appropriate indexes and verify node and relationship counts.

Run the analytical Cypher queries to explore the airline network.

The ETL notebook, Cypher scripts, and source data (where redistribution is permitted) should be included alongside this README for full reproducibility.

Project Context

Developed as an individual project for CITS5504 Data Warehouse, University of Western Australia (2026).