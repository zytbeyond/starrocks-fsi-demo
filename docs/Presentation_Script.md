# StarRocks Financial Services Industry Demo - Presentation Script

## Introduction (2 minutes)

Good [morning/afternoon/evening], everyone. Today, I'm excited to demonstrate how StarRocks can transform real-time analytics for financial institutions. We'll be using a realistic scenario featuring GlobalBank, a multinational financial institution facing challenges that might sound familiar to many of you.

In the next [30/45/60] minutes, we'll explore how StarRocks addresses three critical challenges in the financial services industry:

1. **Real-time Risk Management**: How to calculate Value-at-Risk metrics in real-time during market volatility
2. **Intelligent Query Optimization**: How to automatically optimize complex analytics without manual tuning
3. **Balancing Real-time and Complex Analytics**: How to maintain both immediate updates and sophisticated analysis

Let's dive in!

## Demo Setup (1 minute)

For this demonstration, we're using:
- StarRocks [version] running in a Docker container
- A financial services dataset with market data, trading positions, and risk metrics
- A series of SQL queries that simulate real-world financial analytics scenarios

All the code and data you'll see today are available in our GitHub repository, which we'll share at the end of the session.

## Part 1: Real-time Risk Management (10 minutes)

### The Challenge

Imagine you're in GlobalBank's risk committee meeting. The market has suddenly become volatile, but your risk dashboards are still showing outdated metrics from hours ago. In traditional systems, risk calculations require batch processing that can take hours to complete.

With regulations like Basel III and FRTB requiring intraday risk calculations, this delay is not just an operational issue—it's a compliance risk and a competitive disadvantage.

### The Solution: Primary Key Tables

StarRocks' Primary Key Tables use a specialized Delete+Insert strategy with DelVector technology that provides 3-10x better query performance than traditional approaches. This enables real-time updates with high query performance.

Let me show you how this works in practice.

[DEMO: Run the baseline risk metrics query]

Here we see the current risk metrics for GlobalBank's portfolios:
- The EQUITY_TECH_01 portfolio has the highest VaR percentage at 34.55%
- The FIXED_INCOME_01 portfolio has the largest absolute VaR at $177.9M

Now, let's simulate a sudden market shock:
- US Treasury prices drop and volatility increases by 50%
- Tech stocks drop by 2% and volatility increases by 27%
- Energy stocks drop by 1% and volatility increases by 20%
- Automotive stocks drop by 3% and volatility increases by 30%

[DEMO: Insert the updated market data]

In a traditional data warehouse, risk managers would need to wait for the next batch processing cycle to see how this affects their risk exposure. With StarRocks, we can see the impact immediately:

[DEMO: Run the updated risk metrics query]

Look at how quickly the risk metrics have been recalculated! As soon as the new market data arrived, the risk metrics were instantly updated:
- EQUITY_TECH_01 portfolio: VaR has increased from 34.55% to 46.06%
- EQUITY_AUTO_01 portfolio: VaR has increased from 29.61% to 41.13%
- FIXED_INCOME_01 portfolio: Absolute VaR has increased from $177.9M to $289.7M

Let's analyze the precise impact of the market shock:

[DEMO: Run the risk impact analysis query]

The key insights are:
- All portfolios have decreased in value, with EQUITY_AUTO_01 showing the largest percentage drop at -3.00%
- The VaR for all portfolios has increased significantly, with FIXED_INCOME_01 showing a 62.85% increase despite only a 0.48% drop in value

This demonstrates how risk can increase disproportionately to price movements due to volatility changes. In traditional systems, risk managers would be blind to these changes until the next batch processing cycle.

## Part 2: Automatic Materialized Views (10 minutes)

### The Challenge

Financial institutions often struggle with optimizing complex analytics queries. Database administrators spend countless hours manually creating and maintaining materialized views, often guessing which views will provide the best performance.

When new query patterns emerge—for example, when fraud analysts discover a new fraud pattern—it can take days to optimize the system for these new queries.

### The Solution: AutoMV with Tunespace

StarRocks' AutoMV feature automatically identifies frequently used query patterns and creates materialized views to optimize them without manual intervention.

Let me demonstrate how this works:

[DEMO: Create a Tunespace and add queries]

First, we create a Tunespace to collect multiple query patterns:
1. Portfolio summary by portfolio_id
2. Risk analysis by portfolio_id and currency
3. Currency exposure analysis

After analyzing these queries, StarRocks' AutoMV recommends a single materialized view that can optimize all three queries:

[DEMO: Show the recommended materialized view]

The key insight is that if you pre-compute aggregations at the finest granularity (portfolio_id + currency), you can derive coarser aggregations on the fly.

Let's create this materialized view:

[DEMO: Create the recommended materialized view]

Now, let's run all three queries and see how they all benefit from the same materialized view:

[DEMO: Run the three queries]

All three queries are automatically optimized using the SAME materialized view! This is the power of StarRocks' AutoMV feature.

The benefits of this approach include:
1. Storage Efficiency: One view serves multiple queries
2. Maintenance Simplicity: Fewer materialized views to manage
3. Automatic Optimization: StarRocks determines which view to use
4. Intelligent Design: The system analyzes query patterns
5. Resource Savings: Reduces both storage and computation costs

## Part 3: Dual Materialized View Approach (10 minutes)

### The Challenge

Financial institutions often face a dilemma: they need both real-time updates for monitoring and complex analytics for decision-making. Traditional systems force a choice between consistency and complexity.

### The Solution: Dual Materialized View Approach

StarRocks provides both synchronous and asynchronous materialized views, allowing financial institutions to balance real-time consistency with complex analytics.

Let me demonstrate the difference:

[DEMO: Create a duplicate key table and insert risk data]

First, let's create a simple duplicate key table for risk metrics and insert some risk data.

Now, let's create a synchronous materialized view for risk summaries:

[DEMO: Create a synchronous materialized view]

And let's create an asynchronous materialized view for complex risk analysis:

[DEMO: Create an asynchronous materialized view]

Now, let's add another risk value for EQUITY_TECH_01 and see how the synchronous materialized view automatically updates:

[DEMO: Insert additional risk data and query the base table]

Let's query with an aggregation that matches our synchronous materialized view:

[DEMO: Query the synchronous materialized view]

And let's use EXPLAIN to confirm that StarRocks is using our synchronous materialized view:

[DEMO: Run the EXPLAIN query]

Notice in the EXPLAIN output, the 'rollup' field shows 'sync_mv_risk_summary' instead of 'risk_metrics_duplicate'. This confirms that our query is using the synchronous materialized view.

And now let's see the detailed risk analysis from our asynchronous materialized view:

[DEMO: Query the asynchronous materialized view]

The key differences between these two approaches are:

1. Synchronous Materialized View:
   - Updates automatically when the base table changes
   - Provides immediate aggregation results
   - Simple aggregations for fast updates
   - Perfect for time-sensitive monitoring

2. Asynchronous Materialized View:
   - Updates on a schedule (every hour in our example)
   - Provides detailed risk analysis with complex calculations
   - More comprehensive metrics
   - Perfect for in-depth analysis and reporting

With StarRocks' dual materialized view approach, risk managers get:
- Real-time aggregations through synchronous MVs
- Detailed analysis through asynchronous MVs
- The best of both worlds without compromising performance

## Conclusion and Business Impact (3 minutes)

In this demo, we've clearly shown StarRocks' three key features that make it ideal for financial services:

1. **PRIMARY KEY TABLES**: Like having instant bank account updates instead of waiting for overnight processing
   - We demonstrated this by updating market data and seeing risk metrics change instantly
   - This enables real-time decision making during market volatility

2. **AUTOMATIC MATERIALIZED VIEWS (AUTOMV)**: Like a refrigerator that learns what you eat and restocks itself
   - We demonstrated this with our portfolio summary query that used an automatically created view
   - This enables faster queries without requiring database expertise to create and maintain views

3. **DUAL MATERIALIZED VIEW APPROACH**: Like having both live security cameras and HD recordings
   - We demonstrated this with our risk threshold alerts that combined real-time data with complex analytics
   - This enables both immediate alerts and detailed analysis from the same system

The business impact of StarRocks for financial institutions includes:
1. Instant visibility into changing risk profiles during market volatility
2. Ability to identify at-risk portfolios within milliseconds
3. Automated risk threshold monitoring and alerting
4. Compliance with regulatory requirements for timely risk assessment
5. Competitive advantage through faster reaction to market events
6. Reduced operational risk through real-time decision making
7. Enhanced stress testing capabilities for regulatory compliance
8. Improved capital efficiency through more accurate risk assessment

## Q&A (Remaining time)

I'd be happy to answer any questions you have about what we've demonstrated today or how StarRocks can address your specific challenges.

## Next Steps

If you're interested in exploring how StarRocks can benefit your organization:
1. We can provide access to this demo environment for your team to explore
2. We can schedule a technical deep dive focused on your specific use cases
3. We can help you identify a proof of concept project to demonstrate value quickly

Thank you for your time today!