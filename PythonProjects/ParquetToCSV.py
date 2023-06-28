import pandas as pd

def parquet_to_csv(parquet_file, csv_file):
    # Read Parquet file into a DataFrame
    df = pd.read_parquet(parquet_file)
    
    # Convert DataFrame to CSV
    df.to_csv(csv_file, index=False)

# Usage example
parquet_file = 'input.parquet'
csv_file = 'output.csv'
parquet_to_csv(parquet_file, csv_file)
