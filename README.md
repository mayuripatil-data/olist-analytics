# Olist E-Commerce: Why Don't Customers Come Back?

End-to-end retention and delivery analysis of ~100k orders from Olist, a Brazilian e-commerce marketplace (2016–2018).

## Business question
Almost all Olist customers buy only once. **What drives this, and what is fixing it worth?**

Sub-questions:
1. How large is the repeat-purchase gap, and how do cohorts retain over time?
2. Do late deliveries lower review scores, and do low scores reduce repeat purchases?
3. Which states, sellers and product categories cause the most problems?
4. Which customer segments (RFM) should the business target first?

## Key findings
_Work in progress, updated as the analysis progresses._

## Tech stack
SQL (DuckDB) · Python (pandas, matplotlib, seaborn, scipy, scikit-learn) · Power BI (DAX, Power Query) · Git/GitHub

## Project structure
```
data/raw/        Original Olist CSVs (not committed; see below)
sql/             Cleaning and data-model queries
notebooks/       Exploratory and statistical analysis
src/             Reusable Python helpers
dashboard/       Power BI file and screenshots
reports/         Final business summary and figures
docs/            KPI definitions
```

## How to run
1. Download the dataset from Kaggle: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
2. Unzip the CSVs into `data/raw/`
3. `pip install -r requirements.txt`
4. Open the notebooks in order (`01_…`, `02_…`)

## Author
Mayuri, M.Sc. Applied Computer Science, TH Deggendorf
