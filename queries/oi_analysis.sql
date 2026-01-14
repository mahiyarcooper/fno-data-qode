-- =====================================================
-- Improved OI Analysis:
-- Top 10 symbols by OPEN INTEREST ACTIVITY
-- (expiry-aware, futures only, last 30 trading days)
-- =====================================================

WITH last_30_trading_days AS (
    SELECT DISTINCT trade_date
    FROM trades
    ORDER BY trade_date DESC
    LIMIT 30
),

oi_delta AS (
    SELECT
        i.symbol,
        t.instrument_id,
        t.expiry_id,
        t.trade_date,
        t.open_int,
        t.open_int
            - LAG(t.open_int) OVER (
                PARTITION BY t.expiry_id
                ORDER BY t.trade_date
              ) AS oi_change
    FROM trades t
    JOIN instruments i
        ON t.instrument_id = i.instrument_id
    WHERE t.trade_date IN (SELECT trade_date FROM last_30_trading_days)
      AND i.instrument_type LIKE 'FUT%'   -- focus on futures only
)

SELECT
    symbol,
    SUM(ABS(oi_change)) AS total_oi_activity
FROM oi_delta
WHERE oi_change IS NOT NULL
GROUP BY symbol
ORDER BY total_oi_activity DESC
LIMIT 10;
