-- =====================================================
-- Indexes for Indian Futures & Options database
-- Focus: time-series analytics and contract lookups
-- =====================================================

-- -------------------------
-- 1. Exchanges
-- -------------------------
-- Fast lookup by exchange code (NSE, BSE, MCX)
CREATE INDEX idx_exchanges_code
ON exchanges (exchange_code);

-- -------------------------
-- 2. Instruments
-- -------------------------
-- Common filter: symbol within an exchange
CREATE INDEX idx_instruments_symbol_exchange
ON instruments (symbol, exchange_id);

-- Useful for joins from trades
CREATE INDEX idx_instruments_exchange
ON instruments (exchange_id);

-- -------------------------
-- 3. Expiries
-- -------------------------
-- Frequent option-chain queries by instrument and expiry
CREATE INDEX idx_expiries_instrument_expiry
ON expiries (instrument_id, expiry_dt);

-- Strike-based option chain lookups
CREATE INDEX idx_expiries_strike
ON expiries (strike_pr);

-- -------------------------
-- 4. Trades (FACT TABLE)
-- -------------------------

-- Most common access pattern:
-- instrument + date range (rolling windows, OI change)
CREATE INDEX idx_trades_instrument_date
ON trades (instrument_id, trade_date);

-- Expiry-specific time-series queries
CREATE INDEX idx_trades_expiry_date
ON trades (expiry_id, trade_date);

-- For recent-data queries (last 7 / 30 days)
CREATE INDEX idx_trades_trade_date
ON trades (trade_date);

-- Open interest analysis
CREATE INDEX idx_trades_open_int
ON trades (open_int);

-- -----------------------------------------------------
-- Optional (PostgreSQL-specific, mention in reasoning)
-- -----------------------------------------------------
-- BRIN index for very large time-series tables
-- Uncomment if using PostgreSQL
--
-- CREATE INDEX idx_trades_trade_date_brin
-- ON trades
-- USING BRIN (trade_date);
