# Business Data Analyzer

> Comprehensive business intelligence tool for hardware store operations with automated reporting and visualizations.

## 🎯 Features

- **Database Analysis**: Connect to SQL Server databases with smart filtering
- **Comprehensive Metrics**: Financial KPIs, customer analytics, product performance, inventory optimization
- **Automated Visualizations**: Professional charts and reports (PNG format)
- **Strategic Recommendations**: AI-driven business insights
- **E-commerce Integration**: Magento-specific strategies and recommendations
- **Flexible Configuration**: Environment-based configuration with security best practices

## 📊 What It Analyzes

### Financial Metrics
- Revenue analysis (with/without IVA tax)
- Profit margins and gross profit
- Average order value and cost analysis

### Customer Analytics
- Customer segmentation (VIP, High Value, Frequent, Regular, Occasional)
- Top customers by revenue
- Customer concentration analysis
- Purchase diversity tracking

### Product Analytics
- Top-selling products
- Product profitability
- Underperforming items identification
- Star products (high margin)

### Category Performance
- Category-level revenue and margins
- Subcategory breakdowns
- Risk assessment (Critical, High, Medium, Low)

### Inventory Intelligence
- Fast-moving items identification
- Slow-moving inventory detection
- Velocity analysis

### Trend Analysis
- Monthly revenue trends
- Category distribution
- Seasonal patterns

## 🚀 Quick Start

### 1. Installation

```bash
# Clone the repository
git clone <repository-url>
cd coding_omarchy

# Install dependencies
pip install -r requirements.txt
```

### 2. Configuration

```bash
# Copy the example environment file
cp .env.example .env

# Edit with your credentials
nano .env
```

Choose one authentication method:

**Option A: Navicat NCX File**
```bash
NCX_FILE_PATH=/path/to/connections.ncx
```

**Option B: Direct Database Connection**
```bash
DB_HOST=your-server-host
DB_PORT=1433
DB_USER=your-username
DB_PASSWORD=your-password
DB_NAME=SmartBusiness
```

### 3. Run Analysis

```bash
# Basic analysis (default 1000 records)
python business_analyzer_combined.py

# Analyze more records
python business_analyzer_combined.py --limit 5000

# Analyze specific date range
python business_analyzer_combined.py --start-date 2025-01-01 --end-date 2025-10-31

# Custom NCX file
python business_analyzer_combined.py --ncx-file /path/to/connections.ncx

# Skip re-analysis, just regenerate visualizations
python business_analyzer_combined.py --skip-analysis
```

## 📁 Output Files

All reports are saved to `~/business_reports/` by default (configurable):

- **JSON Analysis**: `analysis_comprehensive_YYYY-MM-DD_to_YYYY-MM-DD.json`
- **Visualization Report**: `business_analysis_report_YYYYMMDD_HHMMSS.png`

## 🛠️ Configuration Options

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `NCX_FILE_PATH` | Path to Navicat connections file | `~/Coding_OMARCHY/python_files/connections.ncx` |
| `DB_HOST` | Database server host | None |
| `DB_PORT` | Database server port | `1433` |
| `DB_USER` | Database username | None |
| `DB_PASSWORD` | Database password | None |
| `DB_NAME` | Database name | `SmartBusiness` |
| `OUTPUT_DIR` | Report output directory | `~/business_reports` |
| `DEFAULT_LIMIT` | Default record limit | `1000` |
| `REPORT_DPI` | Visualization DPI quality | `300` |
| `LOG_LEVEL` | Logging level | `INFO` |

### Business Logic Configuration

Edit `config.py` to customize:

**Customer Segmentation Thresholds**:
- `VIP_REVENUE_THRESHOLD`: Revenue for VIP status (default: 500,000)
- `HIGH_VALUE_THRESHOLD`: High-value customer threshold (default: 200,000)
- `FREQUENT_ORDERS_THRESHOLD`: Frequent buyer threshold (default: 10 orders)

**Inventory Analysis**:
- `FAST_MOVER_THRESHOLD`: Fast-moving item threshold (default: 5 transactions)
- `SLOW_MOVER_THRESHOLD`: Slow-moving item threshold (default: 2 transactions)

**Profitability**:
- `LOW_MARGIN_THRESHOLD`: Low margin warning (default: 10%)
- `STAR_PRODUCT_MARGIN`: Star product threshold (default: 30%)

## 📖 Usage Examples

### Analyze Last Quarter
```bash
python business_analyzer_combined.py \
  --start-date 2025-07-01 \
  --end-date 2025-09-30 \
  --limit 50000
```

### Quick Analysis with Custom Output
```bash
export OUTPUT_DIR=~/my_reports
python business_analyzer_combined.py --limit 1000
```

### Production Run with Environment Variables
```bash
export DB_HOST=prod-server.example.com
export DB_USER=analyst
export DB_PASSWORD=secure_password
export OUTPUT_DIR=/var/reports
python business_analyzer_combined.py --limit 100000
```

## 🔒 Security

**IMPORTANT**: Never commit credentials to version control!

See [SECURITY.md](SECURITY.md) for detailed security guidelines including:
- Credential management best practices
- Using .env files securely
- Production deployment recommendations
- Secret management service integration

## 📊 Visualization Report

The generated report includes:
1. **KPI Summary Cards**: Key metrics at a glance
2. **Top Products Chart**: Best-selling items
3. **Category Distribution**: Sales by category (pie chart)
4. **Customer Analysis**: Top customers by revenue
5. **Category Performance**: Revenue vs. cost comparison
6. **Profit Margin Analysis**: Category profitability
7. **Revenue Breakdown**: IVA vs. base revenue
8. **Strategic Insights**: Automated recommendations

## 🏗️ Project Structure

```
coding_omarchy/
├── business_analyzer_combined.py  # Main application
├── config.py                      # Configuration management
├── .env.example                   # Example environment config
├── requirements.txt               # Python dependencies
├── README.md                      # This file
├── SECURITY.md                    # Security guidelines
└── setup_instructions.md          # Setup guide
```

## 🔧 Development

### Running Tests
```bash
# Install dev dependencies
pip install pytest black flake8

# Run tests (when available)
pytest

# Format code
black *.py

# Lint code
flake8 *.py
```

### Code Style
- Follow PEP 8 guidelines
- Use type hints for function signatures
- Document classes and functions with docstrings
- Maximum line length: 100 characters

## 📝 Data Filtering

The analyzer automatically excludes certain document types:
- `XY` - Excluded document type
- `AS` - Excluded document type
- `TS` - Excluded document type

To modify, edit `Config.EXCLUDED_DOCUMENT_CODES` in `config.py`.

## 🐛 Troubleshooting

### "No valid database configuration found"
- Ensure `.env` file exists or environment variables are set
- Check that NCX file path is correct

### "Matplotlib not available"
- Install visualization dependencies: `pip install matplotlib numpy`
- Analysis will still run, but without visual reports

### "NavicatCipher not available"
- Required only for NCX file decryption
- Use direct database credentials as alternative

### Connection Timeout
- Increase timeout values in `config.py`
- Check network connectivity to database server
- Verify firewall rules

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

[Specify your license here]

## 👥 Authors

[Your name/organization]

## 🙏 Acknowledgments

- Built for hardware store business intelligence
- Designed for Magento e-commerce integration
- Compatible with SmartBusiness ERP systems

## 📞 Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Email: [your-email]
- Documentation: See `setup_instructions.md` and `SECURITY.md`

---

**Note**: This tool processes business data. Ensure compliance with data privacy regulations (GDPR, CCPA, etc.) when handling customer information.
