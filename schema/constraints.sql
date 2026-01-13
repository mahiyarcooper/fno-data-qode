-- =====================================================
-- Constraints for Indian Futures & Options database
-- =====================================================

-- -------------------------
-- 1. Exchanges constraints
-- -------------------------
ALTER TABLE exchanges
ADD CONSTRAINT uq_exchange_code UNIQUE (exchange_code);

-- -------------------------
-- 2. Instruments constraints
-- -------------------------
ALTER TABLE instruments
ADD CONSTRAINT uq_instrument_symbol_exchange
UNIQUE (symbol, exchange_id);

ALTER TABLE instruments
ADD CONSTRAINT chk_instrument_type
CHECK (instrument_type IN ('FUTIDX', 'FUTSTK', 'OPTIDX', 'OPTSTK'));

-- -------------------------
-- 3. Expiries constraints
-- -------------------------
-- Prevent duplicate contracts for the same instrument
ALTER TABLE expiries
ADD CONSTRAINT uq_expiry_contract
UNIQUE (instrument_id, expiry_dt, strike_pr, option_typ);

-- Option type validation
ALTER TABLE expiries
ADD CONSTRAINT chk_option_type
CHECK (option_typ IN ('CE', 'PE', 'XX'));

-- -------------------------
-- 4. Trades constraints
-- -------------------------
-- One row per instrument-expiry per trading day
ALTER TABLE trades
ADD CONSTRAINT uq_trade_day
UNIQUE (instrument_id, expiry_id, trade_date);

-- Basic sanity checks
ALTER TABLE trades
ADD CONSTRAINT chk_prices_non_negative
CHECK (
    open_pr >= 0
    AND high_pr >= 0
    AND low_pr >= 0
    AND close_pr >= 0
    AND settle_pr >= 0
);
