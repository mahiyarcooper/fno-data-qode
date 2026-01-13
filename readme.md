# Indian Futures & Options Database Design

## Objective
Design and implement a scalable relational database to store and analyze
high-volume Futures & Options (F&O) data across Indian exchanges (NSE, BSE, MCX).

The focus is on:
- Normalized schema design (3NF)
- Time-series analytics
- Performance-aware modeling

## Dataset
NSE Futures and Options Dataset (3 months) sourced from Kaggle.
The dataset contains daily aggregated OHLC prices, volume, and open interest.

## Database Design Overview
The schema separates:
- Reference data (exchanges, instruments)
- Contract specifications (expiries)
- High-volume time-series data (daily F&O prices)

This avoids redundancy and supports efficient option-chain and rolling-window analysis.

## Technology Stack
- DuckDB (analytical SQL engine)
- SQL (window functions, joins, partitioning)
- Python (for data ingestion and orchestration)

## Repository Structure
- diagrams/: ER diagram
- schema/: table definitions and constraints
- queries/: analytical SQL queries
- ingestion/: notebook for loading Kaggle data
- docs/: design reasoning and documentation
