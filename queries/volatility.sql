-- =====================================================
-- 7-day rolling volatility of NIFTY options
-- Volatility = rolling standard deviation of close price
-- =====================================================

WITH nifty_options AS (
    SELECT
        t.trade_date,
        i.symbol,
        i.instrument_type,
        e.expiry_id,
        e.option_typ,
        t.close_pr
    FROM trades t
    JOIN instruments i
        ON t.instrument_id = i.instrument_id
    JOIN expiries e
        ON t.expiry_id = e.expiry_id
    WHERE i.symbol = 'NIFTY'
      AND i.instrument_type = 'OPTIDX'
      AND e.option_typ IN ('CE', 'PE')
),

volatility_calc AS (
    SELECT
        trade_date,
        symbol,
        expiry_id,
        option_typ,
        STDDEV(close_pr) OVER (
            PARTITION BY expiry_id, option_typ
            ORDER BY trade_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_7d_volatility
    FROM nifty_options
)

SELECT
    trade_date,
    symbol,
    option_typ,
    expiry_id,
    rolling_7d_volatility
FROM volatility_calc
WHERE rolling_7d_volatility IS NOT NULL
ORDER BY trade_date, expiry_id, option_typ;
