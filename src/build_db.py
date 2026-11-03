"""Build the Olist DuckDB database from the raw CSVs and print first insights.

Run from the project root:  python src/build_db.py
"""
from pathlib import Path
import duckdb

ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "data" / "olist.duckdb"
SQL_DIR = ROOT / "sql"


def run_file(con, name):
    sql = (SQL_DIR / name).read_text()
    con.execute(sql)
    print(f"ran {name}")


def main():
    con = duckdb.connect(str(DB_PATH))
    # read_csv_auto paths in the SQL are relative to the project root
    con.execute(f"SET file_search_path = '{ROOT}'")
    run_file(con, "01_load_raw.sql")
    run_file(con, "02_clean_model.sql")

    for table in ["dim_customers", "dim_products", "dim_sellers", "fct_orders"]:
        n = con.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
        print(f"  {table:15s} {n:>8,} rows")

    insights = (SQL_DIR / "03_first_insights.sql").read_text()
    for query in [q for q in insights.split(";") if "SELECT" in q]:
        print()
        print(con.execute(query).df().to_string(index=False))
    con.close()


if __name__ == "__main__":
    main()
