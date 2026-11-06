Australian Housing Market — Economic Analysis and Machine Learning

Project Overview

This project investigates Australian capital-city housing markets, with a particular focus on Perth's rapid house-price growth.

Using economic indicators from the Australian Bureau of Statistics (ABS) and Reserve Bank of Australia (RBA), the project examines the relationships between population growth, housing supply, interest rates, and annual house-price movements.

It also evaluates whether these indicators can predict future annual house-price growth using supervised machine learning.

Research Questions

How have house prices changed across Australia's capital cities?

What relationships exist between population growth, dwelling approvals, and house-price movements?

Can previous-year economic indicators predict subsequent house-price growth?

How well do different regression models generalise to changing economic conditions?

Data Sources

ABS Total Value of Dwellings: Quarterly median established-house transfer prices.

ABS Regional Population: Annual population estimates for capital-city regions.

ABS Building Approvals: Monthly dwelling approvals by capital-city region.

RBA Statistical Table F1.1: Monthly cash rate target.

The modelling dataset contains annual observations for eight capital-city regions from 2017 to 2025.

Methodology

Data preparation: Clean and combine ABS and RBA datasets, aggregate monthly and quarterly observations into annual measures, and create one-year lagged economic predictors.

Exploratory data analysis: Investigate housing-price trends, population growth, dwelling approvals, interest-rate movements, and changes in feature distributions.

Machine learning: Train models using 2017–2022 observations and evaluate on the 2023–2025 period.

Models evaluated:

Historical-average baseline

Linear Regression

Ridge Regression

Linear Regression without interest rates

Random Forest Regression

Results

Model

Test MAE

Test R²

Baseline

6.53

-0.160

Linear Regression

20.17

-7.262

Ridge Regression

16.57

-4.725

Linear Regression without cash rate

6.84

-0.171

Random Forest

9.23

-1.453

MAE is measured in percentage points.

The baseline achieved the best predictive performance.

The analysis identified a substantial shift in interest-rate conditions between training and testing, which contributed to poor generalisation in the regression models.

Key Takeaways

Economic indicators may exhibit meaningful historical relationships without producing reliable future predictions.

Small datasets and changing economic conditions present important challenges for machine learning.

Greater model complexity does not guarantee improved performance.

Baseline comparisons and error analysis are essential for evaluating model usefulness.

Project Structure

australian-property-ml/
├── data/
│   ├── raw/
│   └── processed/
├── notebooks/
│   ├── 01_data_cleaning_eda.ipynb
│   └── 02_machine_learning.ipynb
├── requirements.txt
└── README.md

Reproducibility

Install the dependencies from requirements.txt.

Run the notebooks in order, starting with data cleaning and EDA, followed by machine learning.

Raw and processed datasets are excluded from the repository. To reproduce the analysis, download the source datasets from ABS and RBA and place them in data/raw/ using the filenames referenced in the preprocessing notebook.

Limitations

The study uses a relatively small annual dataset and a limited set of economic indicators. Housing-market relationships may change across cities and economic conditions.

Additionally, median transaction prices do not control for changes in the composition of properties sold.

The results should be interpreted as exploratory rather than reliable forecasts or causal estimates.