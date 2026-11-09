# Customer Churn Prediction
### Exploratory Data Analysis and Machine Learning

## Project Overview

Customer churn is a major concern for telecommunications companies, as losing customers can lead to reduced recurring revenue and increased customer acquisition costs.

This project investigates the factors associated with customer churn and develops a machine learning model to identify customers at risk of discontinuing their services.

The primary focus is not only on predictive performance, but also on **interpreting model results and translating them into actionable business insights**.

## Project Objectives

- Identify customer characteristics associated with churn through exploratory data analysis (EDA).
- Develop and compare machine learning models to classify potential churners.
- Prioritise churn detection while considering the trade-off between false positives and false negatives.
- Interpret model predictions to support potential customer retention strategies.

## Dataset

The project uses the Telco Customer Churn dataset, containing customer demographics, subscribed services, contract information, billing details, and churn status.

The original dataset contains 7,043 customer records. After data cleaning, 7,032 observations were retained.

**Target variable:** `Churn` (Yes / No)

## Methodology

### 1. Data Cleaning and Exploratory Data Analysis

- Investigated missing values and data types, including 11 missing `TotalCharges` records.
- Examined the distribution of customer churn and its relationship with customer characteristics.
- Used statistical tests, including chi-square tests, to assess associations between categorical variables and churn.
- Investigated multicollinearity using correlation analysis and Variance Inflation Factor (VIF).
- Excluded `TotalCharges` from modelling due to its strong relationship with tenure and monthly charges, retaining the latter variables for interpretability.

### 2. Data Preprocessing

- Used a stratified 80/20 train-test split.
- Standardised numerical features and one-hot encoded categorical features.
- Applied preprocessing within machine learning pipelines to prevent cross-validation data leakage.
- Used 5-fold stratified cross-validation for model comparison and hyperparameter tuning.

### 3. Model Development and Comparison

Three machine learning approaches were evaluated:

- **Logistic Regression (L1):** Linear classification with regularisation and feature-selection capability.
- **Random Forest:** Ensemble learning using bagging.
- **Gradient Boosting:** Sequential ensemble learning using boosting.

Hyperparameters were optimised using GridSearchCV, with ROC-AUC as the primary tuning metric.

| Model | Cross-Validation ROC-AUC |
|---|---:|
| Logistic Regression (L1) | 0.8449 |
| Random Forest | 0.8461 |
| Gradient Boosting | 0.8502 |

Although Gradient Boosting achieved the highest ROC-AUC, the differences between models were relatively small.

**Logistic Regression (L1) was selected** because it achieved strong churn recall, demonstrated stable generalisation, and offered greater interpretability.

### 4. Classification Threshold Analysis

Different classification thresholds were evaluated to investigate the trade-off between precision and recall.

A threshold of **0.5** was retained as a practical compromise between detecting churners and limiting false positives. This decision reflects the business objective of identifying at-risk customers without generating excessive unnecessary retention interventions.

## Results

### Baseline vs. Final Model

The final model was compared against the initial unweighted Logistic Regression baseline.

| Metric | Baseline (L2) | Final (L1) |
|---|---:|---:|
| Accuracy | 80.4% | 73.0% |
| ROC-AUC | 0.833 | 0.834 |
| Churn Precision | 64.8% | 49.5% |
| Churn Recall | 57.5% | **78.6%** |
| Churn F1-score | 0.61 | 0.61 |
| False Negatives | 159 | **80** |
| False Positives | 117 | 300 |

**Key Result:** The final model improved churn recall by approximately 21 percentage points, reducing the number of missed churners from 159 to 80.

However, this improvement came with more false positives and lower overall accuracy. The ROC-AUC remained nearly unchanged, indicating that the main improvement was in churn detection at the selected operating threshold rather than overall ranking performance.

This demonstrates why model selection should consider business priorities instead of relying solely on accuracy or ROC-AUC.

## Key Business Insights

The selected model identified several customer characteristics associated with churn risk:

- **Contract Type:** Month-to-month contracts are associated with higher churn risk, while two-year contracts are associated with lower risk.
- **Customer Tenure:** Customers with shorter subscription histories are associated with higher churn risk.
- **Monthly Charges:** Higher monthly charges are positively associated with predicted churn.
- **Additional Services:** Online security and technical support are associated with lower predicted churn risk.

### Business Recommendations

Based on these findings, telecommunications companies could:

1. Prioritise high-risk customers for targeted retention campaigns.
2. Improve early customer engagement, particularly among newer customers.
3. Investigate personalised retention incentives for customers with higher monthly charges.
4. Evaluate the relationship between additional service offerings and customer retention.

These recommendations should be tested before implementation, as predictive associations do not establish causation.

## Limitations and Future Improvements

Several limitations should be considered:

- **False Positives:** The final model's relatively low precision may result in unnecessary retention spending.
- **Business Cost Data:** Customer lifetime value and retention expenses were unavailable, limiting cost-based threshold optimisation.
- **Probability Calibration:** Balanced class weights may affect the reliability of predicted probabilities.
- **Causality:** Important predictive features are not necessarily causes of customer churn.
- **Evaluation:** The test set was examined during initial baseline experiments, so the final evaluation was not entirely independent of the development process.

Future work could explore probability calibration, cost-sensitive decision thresholds, and evaluation on new customer data.

## Project Structure

- `data/raw/` — Original dataset
- `data/processed/telco_churn_cleaned.csv` — Cleaned dataset
- `notebooks/01_eda.ipynb` — Data cleaning and exploratory data analysis
- `notebooks/02_modeling.ipynb` — Model development, tuning, comparison, and evaluation

## Tools and Technologies

**Language:** Python

**Libraries:** pandas, NumPy, Matplotlib, Seaborn, SciPy, scikit-learn, statsmodels

**Techniques:** EDA, statistical hypothesis testing, multicollinearity analysis, preprocessing pipelines, stratified cross-validation, hyperparameter tuning, regularisation, model evaluation, and threshold analysis.

## Conclusion

This project demonstrates an end-to-end approach to customer churn prediction, combining exploratory analysis, machine learning, and business interpretation.

While the final model did not substantially improve ROC-AUC compared with the baseline, it identified significantly more actual churners. This highlights the importance of aligning model selection and evaluation with the underlying business objective.

The project also demonstrates how interpretable machine learning models can provide useful insights to support customer retention decisions.