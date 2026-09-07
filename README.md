# Online Retail SQL Database

## Overview

A relational database project for an online shopping environment, covering database creation, normalisation, data import, SQL querying, stored procedures, and query optimisation.

The project demonstrates how a structured relational database can support transactional operations while generating business insights for customer, product, payment, and sales analysis.

## Objectives

- Design a normalised relational database.
- Import and validate structured data.
- Establish relationships between business entities.
- Use SQL to answer business questions.
- Implement stored procedures for repeatable business logic.
- Apply query optimisation techniques.
- Demonstrate how database outputs can support business decisions.

## Data Model

The database includes relationships between entities such as:

- Customers
- Orders
- Order Items
- Products
- Payments

The database is designed around Third Normal Form (3NF).

## Database Workflow

1. Create the database structure.
2. Load source CSV files into temporary tables.
3. Transfer validated data into final tables.
4. Verify data integrity.
5. Establish primary and foreign-key relationships.
6. Execute analytical SQL queries.
7. Implement stored procedures.
8. Apply query optimisation techniques.

## Example Business Questions

The project addresses questions such as:

- Which customers have order totals between £500 and £1,000?
- Which UK customers purchased more than three products in an order?
- What are the highest and second-highest VAT-adjusted payments from the UK or Australia?
- Which products have the highest purchase quantities?
- Which customers spent more than £1,000?
- Which customers have not completed payments?
- How should qualifying orders receive a 5% discount?

## SQL Techniques

- JOINs
- GROUP BY
- HAVING
- ORDER BY
- Subqueries
- Stored procedures
- Filtering
- Aggregation
- Indexing
- Query optimisation

A stored procedure was developed to apply a 5% discount to qualifying orders involving laptops or smartphones and payments of at least £17,000, with original payment information preserved in a backup table.

## Business Insights

The queries support:

- Customer segmentation
- High-value customer identification
- Inventory and demand analysis
- Revenue monitoring
- Promotional targeting
- Payment follow-up
- Sales analysis

## Query Optimisation

The project applies several optimisation principles:

- Avoid unnecessary joins.
- Filter early using WHERE and HAVING.
- Use EXISTS where appropriate.
- Select only required columns.
- Use indexing to improve retrieval performance.

## Tools

- SQL
- Relational database design
- 3NF normalisation
- Stored procedures
- Query optimisation

## Conclusion

The project demonstrates the complete lifecycle of a relational database solution, from schema design and data import to analytical queries and optimisation.

It combines technical database skills with practical business-analysis use cases.
