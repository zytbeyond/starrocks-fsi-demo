-- ============================================================================
-- StarRocks Advanced Features Demo for Financial Services Industry (FSI)
-- ============================================================================
-- This script demonstrates StarRocks' unique capabilities with a focus on features
-- that are particularly valuable for financial institutions facing challenges with
-- real-time analytics, regulatory compliance, and cost optimization.

-- Create a database for our demo
CREATE DATABASE IF NOT EXISTS globalbank;
USE globalbank;

-- ----------------------------------------------------------------------------
-- FEATURE 1: Primary Key Tables for Real-time Risk Management
-- ----------------------------------------------------------------------------

-- Create market_data table with Primary Key
CREATE TABLE market_data (
    instrument_id VARCHAR(20) NOT NULL COMMENT "Unique instrument identifier",
    timestamp DATETIME NOT NULL COMMENT "Timestamp of the market data point",
    price DECIMAL(18,6) NOT NULL COMMENT "Current market price",
    bid DECIMAL(18,6) NOT NULL COMMENT "Bid price",
    ask DECIMAL(18,6) NOT NULL COMMENT "Ask price",
    volume INT NOT NULL COMMENT "Trading volume",
    volatility DECIMAL(10,6) COMMENT "Implied volatility",
    market_cap DECIMAL(20,2) COMMENT "Market capitalization",
    sector VARCHAR(50) COMMENT "Industry sector",
    region VARCHAR(50) COMMENT "Geographic region",
    last_update DATETIME NOT NULL COMMENT "Last update timestamp"
)
PRIMARY KEY (instrument_id, timestamp)
PARTITION BY date_trunc('day', timestamp)
DISTRIBUTED BY HASH(instrument_id)
PROPERTIES (
    "replication_num" = "1",
    "storage_medium" = "SSD"
);

-- Create position table with Primary Key
CREATE TABLE positions (
    position_id BIGINT NOT NULL COMMENT "Unique position identifier",
    position_date DATE NOT NULL COMMENT "Position date",
    instrument_id VARCHAR(20) NOT NULL COMMENT "Instrument identifier",
    portfolio_id VARCHAR(20) NOT NULL COMMENT "Portfolio identifier",
    trader_id VARCHAR(20) NOT NULL COMMENT "Trader identifier",
    quantity DECIMAL(18,6) NOT NULL COMMENT "Position quantity",
    cost_basis DECIMAL(18,6) NOT NULL COMMENT "Cost basis per unit",
    currency VARCHAR(3) NOT NULL COMMENT "Currency code (USD, EUR, etc.)",
    strategy VARCHAR(50) COMMENT "Trading strategy",
    desk VARCHAR(50) COMMENT "Trading desk",
    last_update DATETIME NOT NULL COMMENT "Last update timestamp"
)
PRIMARY KEY (position_id, position_date)
PARTITION BY date_trunc('day', position_date)
DISTRIBUTED BY HASH(position_id)
PROPERTIES (
    "replication_num" = "1",
    "storage_medium" = "SSD"
);

-- Create counterparty table
CREATE TABLE counterparties (
    counterparty_id VARCHAR(20) NOT NULL COMMENT "Unique counterparty identifier",
    name VARCHAR(100) NOT NULL COMMENT "Counterparty name",
    type VARCHAR(50) NOT NULL COMMENT "Counterparty type (Bank, Broker, etc.)",
    credit_rating VARCHAR(10) COMMENT "Credit rating (AAA, AA+, etc.)",
    country VARCHAR(50) NOT NULL COMMENT "Country of registration",
    region VARCHAR(50) NOT NULL COMMENT "Geographic region",
    tier INT COMMENT "Counterparty tier (1, 2, 3)",
    risk_score DECIMAL(5,2) COMMENT "Internal risk score",
    exposure_limit DECIMAL(18,2) COMMENT "Maximum exposure limit",
    active TINYINT(1) NOT NULL COMMENT "Whether the counterparty is active (0=false, 1=true)",
    last_update DATETIME NOT NULL COMMENT "Last update timestamp"
)
PRIMARY KEY (counterparty_id)
DISTRIBUTED BY HASH(counterparty_id);

-- Insert sample market data
INSERT INTO market_data VALUES
('US912810TW04', '2025-05-19 08:00:00', 98.25, 98.20, 98.30, 1500000, 0.12, 0, 'Government', 'North America', '2025-05-19 08:00:00'),
('US912810TW04', '2025-05-19 08:15:00', 98.28, 98.25, 98.32, 1200000, 0.11, 0, 'Government', 'North America', '2025-05-19 08:15:00'),
('US912810TW04', '2025-05-19 08:30:00', 98.32, 98.30, 98.35, 1350000, 0.11, 0, 'Government', 'North America', '2025-05-19 08:30:00'),
('US0378331005', '2025-05-19 08:00:00', 182.50, 182.45, 182.55, 500000, 0.22, 2850000000000, 'Technology', 'North America', '2025-05-19 08:00:00'),
('US0378331005', '2025-05-19 08:15:00', 183.25, 183.20, 183.30, 450000, 0.21, 2860000000000, 'Technology', 'North America', '2025-05-19 08:15:00'),
('US0378331005', '2025-05-19 08:30:00', 183.75, 183.70, 183.80, 520000, 0.21, 2870000000000, 'Technology', 'North America', '2025-05-19 08:30:00'),
('GB0007980591', '2025-05-19 08:00:00', 525.30, 525.20, 525.40, 320000, 0.18, 105000000000, 'Energy', 'Europe', '2025-05-19 08:00:00'),
('GB0007980591', '2025-05-19 08:15:00', 526.50, 526.40, 526.60, 280000, 0.17, 105200000000, 'Energy', 'Europe', '2025-05-19 08:15:00'),
('GB0007980591', '2025-05-19 08:30:00', 527.20, 527.10, 527.30, 310000, 0.17, 105400000000, 'Energy', 'Europe', '2025-05-19 08:30:00'),
('JP3633400001', '2025-05-19 08:00:00', 7250.00, 7245.00, 7255.00, 150000, 0.19, 102000000000, 'Automotive', 'Asia', '2025-05-19 08:00:00'),
('JP3633400001', '2025-05-19 08:15:00', 7265.00, 7260.00, 7270.00, 140000, 0.18, 102200000000, 'Automotive', 'Asia', '2025-05-19 08:15:00'),
('JP3633400001', '2025-05-19 08:30:00', 7280.00, 7275.00, 7285.00, 160000, 0.18, 102500000000, 'Automotive', 'Asia', '2025-05-19 08:30:00');

-- Insert sample positions
INSERT INTO positions VALUES
(1001, '2025-05-19', 'US912810TW04', 'FIXED_INCOME_01', 'TRADER001', 10000000, 98.25, 'USD', 'HOLD', 'TREASURY', '2025-05-19 08:00:00'),
(1002, '2025-05-19', 'US0378331005', 'EQUITY_TECH_01', 'TRADER002', 50000, 182.50, 'USD', 'LONG', 'EQUITY', '2025-05-19 08:00:00'),
(1003, '2025-05-19', 'GB0007980591', 'EQUITY_ENERGY_01', 'TRADER003', 100000, 525.30, 'GBP', 'LONG', 'EQUITY', '2025-05-19 08:00:00'),
(1004, '2025-05-19', 'JP3633400001', 'EQUITY_AUTO_01', 'TRADER004', 25000, 7250.00, 'JPY', 'SHORT', 'EQUITY', '2025-05-19 08:00:00');

-- Insert sample counterparties
INSERT INTO counterparties VALUES
('CP001', 'Goldman Sachs', 'Investment Bank', 'A+', 'United States', 'North America', 1, 85.5, 500000000, 1, '2025-05-19 08:00:00'),
('CP002', 'Deutsche Bank', 'Investment Bank', 'BBB+', 'Germany', 'Europe', 1, 78.2, 350000000, 1, '2025-05-19 08:00:00'),
('CP003', 'Mitsubishi UFJ', 'Commercial Bank', 'A', 'Japan', 'Asia', 1, 82.7, 400000000, 1, '2025-05-19 08:00:00'),
('CP004', 'Barclays', 'Investment Bank', 'BBB', 'United Kingdom', 'Europe', 2, 76.5, 300000000, 1, '2025-05-19 08:00:00'),
('CP005', 'Credit Suisse', 'Investment Bank', 'BBB-', 'Switzerland', 'Europe', 2, 72.8, 250000000, 1, '2025-05-19 08:00:00');

-- Create a view that joins positions with the latest market data
CREATE VIEW position_market_data AS
SELECT 
    p.position_id,
    p.instrument_id,
    p.portfolio_id,
    p.quantity,
    p.cost_basis,
    p.currency,
    m.price AS current_price,
    m.volatility,
    (p.quantity * m.price) AS market_value,
    (p.quantity * m.price) - (p.quantity * p.cost_basis) AS unrealized_pnl,
    m.last_update AS market_data_time
FROM 
    positions p
JOIN 
    (
        SELECT 
            instrument_id, 
            price, 
            volatility, 
            last_update,
            ROW_NUMBER() OVER (PARTITION BY instrument_id ORDER BY timestamp DESC) as rn
        FROM 
            market_data
    ) m ON p.instrument_id = m.instrument_id AND m.rn = 1;

-- Create a view for Value-at-Risk calculation
CREATE VIEW value_at_risk AS
SELECT 
    portfolio_id,
    SUM(market_value) AS total_portfolio_value,
    -- Calculate 1-day 95% VaR using parametric method (1.645 is the Z-score for 95% confidence)
    SUM(market_value * volatility * 1.645) AS var_95_1day,
    -- Calculate 10-day 99% VaR (2.326 is the Z-score for 99% confidence, multiply by sqrt(10) for time scaling)
    SUM(market_value * volatility * 2.326 * SQRT(10)) AS var_99_10day,
    MAX(market_data_time) AS calculation_time
FROM 
    position_market_data
GROUP BY 
    portfolio_id;

-- Query to show current risk metrics
SELECT 
    portfolio_id,
    ROUND(total_portfolio_value, 2) AS portfolio_value_usd,
    ROUND(var_95_1day, 2) AS var_95_1day_usd,
    ROUND(var_95_1day / total_portfolio_value * 100, 2) AS var_95_pct,
    ROUND(var_99_10day, 2) AS var_99_10day_usd,
    ROUND(var_99_10day / total_portfolio_value * 100, 2) AS var_99_pct,
    calculation_time
FROM 
    value_at_risk
ORDER BY 
    portfolio_id;

-- BUSINESS IMPACT SUMMARY:
-- 1. Instant visibility into changing risk profiles during market volatility
-- 2. Ability to identify at-risk portfolios within milliseconds
-- 3. Automated risk threshold monitoring and alerting
-- 4. Compliance with regulatory requirements for timely risk assessment
-- 5. Competitive advantage through faster reaction to market events
-- 6. Reduced operational risk through real-time decision making
-- 7. Enhanced stress testing capabilities for regulatory compliance
-- 8. Improved capital efficiency through more accurate risk assessment