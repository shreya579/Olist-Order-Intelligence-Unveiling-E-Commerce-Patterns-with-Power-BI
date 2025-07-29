# 📦 E-Commerce Delivery and Review Analysis Dashboard
![Ecommerce-Wallpaper](screenshots/sales_dashboard.png)

This Power BI project explores the interplay between **order delivery performance**, **customer reviews**, and **product category revenue** using a real-world e-commerce dataset. The aim is to understand how logistics and customer satisfaction metrics impact overall sales performance and business growth.

---

## 📚 Table of Contents

* [📊 Project Overview](#-project-overview)
* [🎯 Business Objectives](#-business-objectives)
* [🧩 Dataset Description](#-dataset-description)
* [🔍 Exploratory Analysis](#-exploratory-analysis)
* [📈 Visualizations](#-visualizations)
* [📥 Data Cleaning](#-data-cleaning)
* [💡 Insights](#-insights)
* [🛠️ Tools Used](#-tools-used)
* [📌 Future Enhancements](#-future-enhancements)
* [📁 Project Structure](#-project-structure)

---

## 📊 Project Overview

This Power BI dashboard provides an analytical deep dive into the **Brazilian E-Commerce dataset**, focusing on key performance indicators related to:

* Delivery Timeliness
* Review Scores
* Product Category Revenue
* Sales Trends and Seasonality

The project targets key stakeholder questions about **logistics efficiency**, **customer satisfaction**, and **profitability** across product segments.

---

## 🎯 Business Objectives

* Analyze the **impact of delivery delays on customer reviews**.
* Understand **sales distribution by product category**.
* Identify **top-performing categories** and **their revenue contributions**.
* Evaluate **sales trends** across time and geography.

---

## 🧩 Dataset Description

The dataset is sourced from a public Brazilian e-commerce platform and includes:

* **Orders Table:** Purchase, delivery dates, customer IDs
* **Order Items Table:** Price, product ID, seller ID
* **Products Table:** Product names, categories
* **Reviews Table:** Review score, title, and comments
* **Payments Table:** Payment types and values
* **Customers Table:** Customer location data

---

## 🔍 Exploratory Analysis

Key exploration steps:

* **Delivery Delay**: Calculated using estimated vs. actual delivery dates.
* **Review Score**: Mapped to delivery performance.
* **Revenue Trends**: Grouped by product category.
* **Time-based Trends**: Monthly sales and review fluctuations.
* **TopN Analysis**: Identified top 5 categories by revenue.

---

## 📈 Visualizations

* **Bar Chart**: Total Revenue by Product Category
* **Stacked Area Chart**: Sales Trend Over Time
* **Scatter Plot**: Review Score vs. Delivery Delay
* **Box Plot**: Delivery Delay distribution by Review Score
* **KPI Cards**: Total Revenue, Average Delivery Delay, Order Count
* **Map**: Revenue and Orders by Customer State

#### Review 
![Report_Page1](screenshots/Analysis_Report_page-0001.jpg)

---

## 📥 Data Cleaning

* Removed rows with missing or incorrect dates.
* Filtered out records with negative delivery durations.
* Standardized column names and formatted date fields.
* Joined tables on appropriate foreign keys (e.g., order\_id, product\_id).

---

## 💡 Insights

* **Late deliveries often correlate with low review scores**, especially in cases exceeding a delay of 7+ days.
* **Top 5 product categories** contribute to over **65% of total revenue**, highlighting uneven revenue distribution.
* The **majority of sales** come from **Southeast Brazil**, especially São Paulo and Rio de Janeiro.
* Products with **consistent delivery and 5-star reviews** enjoy **higher AOV** (Average Order Value) and customer retention.
* Seasonal spikes in November and December indicate **holiday purchase behavior**.

---

## 🛠️ Tools Used

* **Power BI** for data modeling and visualization
* **DAX** for measures and KPI calculation
* **Power Query Editor** for data transformation
* **SQL** (optional) for raw data pre-processing
* **GitHub** for version control and project documentation

---

## 📌 Future Enhancements

* Incorporate **shipping costs** to analyze logistics expense vs. revenue.
* Add **predictive modeling** to forecast future revenue and review trends.
* Integrate **marketing data** to measure campaign effectiveness.
* Include **customer lifetime value (CLV)** analysis.

---

## 📁 Project Structure

```
📦 Ecommerce-PBI-Review-Delivery-Analysis/
├── 📁 PowerBI_Dashboard
│   └── ECommerce_Review_Analysis.pbix
├── 📄 README.md
└── 📊 VisualExports/
    └── Charts and KPI screenshots
```
