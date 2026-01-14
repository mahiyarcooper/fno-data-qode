-- =====================================================
-- Option Chain Summary for NIFTY Options
-- Grouped by expiry date and strike price
-- =====================================================

WITH nifty_option_chain AS (
    SELECT
        e.expiry_dt,
        e.strike_pr,
        e.option_typ,
        t.volume,
        t.open_int
    FROM trades t
    JOIN instruments i
        ON t.instrument_id = i.instrument_id
    JOIN expiries e
        ON t.expiry_id = e.expiry_id
    WHERE i.symbol = 'NIFTY'
      AND i.instrument_type = 'OPTIDX'
      AND e.option_typ IN ('CE', 'PE')
)

SELECT
    expiry_dt,
    strike_pr,
    option_typ,
    SUM(volume) AS total_volume,
    AVG(open_int) AS avg_open_interest
FROM nifty_option_chain
GROUP BY expiry_dt, strike_pr, option_typ
ORDER BY expiry_dt, strike_pr, option_typ;
