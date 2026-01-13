
-- Create tables for Indian Futures & Options database
-- Compatible with DuckDB and PostgreSQL


-- -------------------------
-- 1. Exchanges (dimension)
-- -------------------------
CREATE TABLE exchanges (
    exchange_id     INTEGER PRIMARY KEY,
    exchange_code   VARCHAR(10) NOT NULL,   -- NSE, BSE, MCX
    exchange_name   VARCHAR(50),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------
-- 2. Instruments (dimension)
-- -------------------------
CREATE TABLE instruments (
    instrument_id     INTEGER PRIMARY KEY,
    symbol            VARCHAR(50) NOT NULL,   -- NIFTY, BANKNIFTY, ACC
    instrument_type   VARCHAR(10) NOT NULL,   -- FUTIDX, FUTSTK, OPTIDX, OPTSTK
    underlying_type   VARCHAR(20),            -- INDEX, EQUITY, COMMODITY
    exchange_id       INTEGER NOT NULL,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP,

    FOREIGN KEY (exchange_id)
        REFERENCES exchanges(exchange_id)
);

-- -------------------------
-- 3. Expiries (contract specification)
-- -------------------------
CREATE TABLE expiries (
    expiry_id      INTEGER PRIMARY KEY,
    instrument_id  INTEGER NOT NULL,
    expiry_dt      DATE NOT NULL,
    strike_pr      DOUBLE,          -- NULL / 0 for futures
    option_typ     VARCHAR(2),       -- CE / PE / XX
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (instrument_id)
        REFERENCES instruments(instrument_id)
);

-- -------------------------
-- 4. Trades (fact table - daily F&O prices)
-- -------------------------
CREATE TABLE trades (
    trade_id       BIGINT PRIMARY KEY,
    instrument_id  INTEGER NOT NULL,
    expiry_id      INTEGER NOT NULL,
    trade_date     DATE NOT NULL,

    open_pr        DOUBLE,
    high_pr        DOUBLE,
    low_pr         DOUBLE,
    close_pr       DOUBLE,
    settle_pr      DOUBLE,

    volume         BIGINT,
    open_int       BIGINT,
    chg_in_oi      BIGINT,

    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP,

    FOREIGN KEY (instrument_id)
        REFERENCES instruments(instrument_id),

    FOREIGN KEY (expiry_id)
        REFERENCES expiries(expiry_id)
);
