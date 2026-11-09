Greater Perth Food Accessibility Analysis

Project overview

Access to supermarkets is an important part of everyday life, but stores are not evenly distributed across communities. This project examines supermarket accessibility across Greater Perth, Western Australia, and identifies areas that may benefit from additional supermarket coverage.

The analysis combines supermarket locations with 2021 Australian Census data to explore geographic access, population, household income and vehicle ownership. Its goal is to support preliminary area-level screening, not to declare definitive food deserts or select specific commercial sites.

Project objectives

Map existing supermarkets across Greater Perth.

Estimate each Statistical Area Level 2 (SA2) area's distance to its nearest supermarket.

Explore relationships between supermarket distance, population, household income and vehicle ownership.

Identify populated areas with potential gaps in supermarket coverage.

Highlight candidate communities for further investigation.

Data sources

Dataset

Source

Purpose

Supermarket locations

OpenStreetMap via Overpass Turbo

Map existing supermarkets tagged shop=supermarket

SA2 boundaries (2021)

Australian Bureau of Statistics — ASGS

Define Greater Perth SA2 areas

2021 Census General Community Profile, WA SA2

Australian Bureau of Statistics — Census DataPacks

Population (G01), median weekly household income (G02) and motor vehicles per dwelling (G34)

The supermarket data was extracted using an Overpass bounding-box query. The Census and geographic boundary files were downloaded separately from the ABS. See Reproducing the analysis below for the required inputs.

Approach

Collect and clean data: Check supermarket geometries, duplicate identifiers and missing fields; prepare SA2 boundaries and Census indicators.

Measure proximity: Project the geographic data to GDA2020 / MGA Zone 50 (EPSG:7850), use a representative point for each SA2 and calculate the straight-line distance to the nearest supermarket.

Explore socioeconomic patterns: Compare supermarket distance with population, median weekly household income and the percentage of dwellings reporting no motor vehicle.

Screen areas: Identify SA2 areas with at least 5,000 residents and an estimated supermarket distance of at least 3 km. Count supermarkets recorded within each shortlisted SA2.

Map and discuss candidates: Highlight potential gaps and provide preliminary recommendations with appropriate caveats.

The screening thresholds are exploratory choices, not an official food-desert definition.

Key findings

Relationship with supermarket distance

Spearman correlation (ρ)

P-value

Interpretation

SA2 population

-0.251

0.0007

Weak negative association

Median weekly household income

0.040

0.5947

No statistically significant association

Dwellings without a motor vehicle (%)

-0.408

< 0.0001

Moderate negative association

More populated areas generally had slightly shorter estimated supermarket distances. Household income showed little evidence of an association. Areas with more car-free dwellings tended to be closer to supermarkets, potentially reflecting differences between urban and outer-suburban locations. These are associations, not causal findings.

Six SA2 areas met the initial population-and-distance criteria. Four had no supermarket recorded within their SA2 boundaries and were selected as preliminary candidates:

Candidate area

2021 population

Estimated nearest supermarket distance

The Vines

12,457

5.58 km

Mundijong

7,165

5.29 km

Mount Nasura – Mount Richon – Bedfordale

8,241

4.33 km

Tapping – Ashby – Sinagra

13,569

3.62 km

Important: A lack of supermarkets inside an SA2 does not mean supermarkets are inaccessible: stores may be located just beyond its boundary. The four areas are candidates for further investigation, not confirmed locations for new stores.

Final map



Orange areas show the four preliminary candidate SA2s; blue points show mapped supermarkets.

Repository structure

food_accessibility_analysis/
├── data/
│   ├── raw/                        # Source downloads (not committed if large)
│   └── processed/
│       ├── perth_supermarkets_clean.geojson
│       └── perth_sa2_accessibility.gpkg
├── notebooks/
│   ├── 01_grocery_store_eda.ipynb
│   ├── 02_spatial_accessibility.ipynb
│   └── 03_underserved_areas.ipynb
├── outputs/
│   └── maps/
│       └── potential_supermarket_areas.png
├── README.md
└── requirements.txt

Reproducing the analysis

Use Python 3.11 or newer and install the dependencies from this project folder:

python -m pip install -r requirements.txt

Download the 2021 ABS SA2 boundary shapefile archive and the 2021 Census General Community Profile for Western Australia at SA2 level. Place these ZIP files in data/raw/.

Export the supermarket locations from OpenStreetMap using Overpass Turbo and save them as data/raw/perth_supermarkets.geojson. The original extraction used the approximate bounding box (-32.80187, 115.44948, -31.45512, 116.41514) (south, west, north, east) and the shop=supermarket tag.

Run the notebooks in order from the notebooks/ folder:

01_grocery_store_eda.ipynb — clean and inspect supermarkets.

02_spatial_accessibility.ipynb — integrate boundaries and Census data, calculate distances and save the combined GeoPackage.

03_underserved_areas.ipynb — shortlist candidates, map them and summarise recommendations.

Note: The notebooks use relative paths such as ../data/raw/. File names for the downloaded Census ZIP may differ; update the ZIP path variable if necessary. If the processed datasets are already included in the repository, Notebook 03 can be run without repeating the earlier preparation steps.

Limitations

Approximate distance: Distance is measured in a straight line from one representative point per SA2, not from households along actual walking or driving routes.

Uneven population distribution: Residents may live far from the representative point, especially in large rural SA2s.

Incomplete store records: OpenStreetMap data and the chosen extraction area may omit some supermarkets.

Neighbouring areas: An SA2 with zero recorded supermarkets may still have accessible stores nearby across its boundary.

Limited transport information: Vehicle ownership does not measure public transport access, walkability or travel costs.

Exploratory interpretation: Area-level associations may hide differences between households; spatial clustering may also affect conventional statistical significance tests.

A more detailed site-selection study would use residential population locations, road-network travel times, verified store data, and commercial feasibility criteria.

Tools

Python, pandas, GeoPandas, NumPy, Matplotlib, Folium, SciPy and Jupyter notebooks.