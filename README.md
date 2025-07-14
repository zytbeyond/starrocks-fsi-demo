# StarRocks Financial Services Industry Demo

This repository contains a hands-on demonstration of StarRocks capabilities for Financial Services Industry (FSI) use cases. It showcases how StarRocks addresses key challenges in the financial sector through a realistic scenario featuring GlobalBank, a multinational financial institution.

## Overview

StarRocks is a high-performance analytical database that excels in real-time analytics for financial services. This demo showcases:

1. **Real-time Risk Management** - Value-at-Risk (VaR) calculations with real-time market data updates
2. **Automatic Materialized Views** - Intelligent query optimization for complex analytics
3. **Dual Materialized View Approach** - Balancing real-time consistency with complex analytics

## Key Features Demonstrated

1. **Primary Key Tables**
   - Delete+Insert strategy with DelVector technology
   - High-performance real-time updates

2. **Automatic Materialized Views (AutoMV)**
   - Tunespace for transparent recommendations
   - Query pattern registration and optimization

3. **Dual Materialized View Approach**
   - Synchronous MVs for real-time consistency
   - Asynchronous MVs for complex analytics

## Repository Structure

- `README.md` - This file
- `scripts/` - Shell scripts for running the demo
  - `demo_starrocks_fsi.sh` - Interactive demo script
  - `run_starrocks_fsi_demo.sh` - Setup script for the demo
- `sql/` - SQL scripts for the demo
  - `starrocks_fsi_demo.sql` - Main SQL script for the demo
- `docs/` - Documentation files
  - `DEMO_STORYLINE.md` - Narrative framework for the demo
  - `FSI_DEMO_SUMMARY.md` - Summary of the demo
  - `Presentation_Script.md` - Detailed talking points

## Prerequisites

- Docker installed
- 8GB+ RAM available
- MySQL client installed

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/zytbeyond/starrocks-fsi-demo.git
   cd starrocks-fsi-demo
   ```

2. Run the setup script:
   ```bash
   ./scripts/run_starrocks_fsi_demo.sh
   ```

3. Run the interactive demo:
   ```bash
   ./scripts/demo_starrocks_fsi.sh
   ```

## Important Note on Credentials

This demo uses the following default credentials:

- **Database Host**: 127.0.0.1
- **Database Port**: 9030
- **Database User**: root
- **Database Password**: [NO PASSWORD]

> **⚠️ SECURITY WARNING**: These are default credentials for local demo purposes only. In a production environment, always use strong passwords and proper security measures.

## Customization

You can customize this demo by:
1. Modifying the SQL scripts to match your specific use cases
2. Adjusting the data model to reflect your organization's structure
3. Adding your own data (with proper anonymization)

## License

MIT License

## Acknowledgements

This demo was created to showcase StarRocks capabilities for financial services use cases.
