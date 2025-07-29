# ApplePulse: Global Store & Product Analytics

## Project Overview

This project delves into sales and warranty data to uncover actionable insights. It includes analysis such as sales trends over product lifecycle periods, correlations between price and warranty claims, store performance in handling warranty repairs, and running totals of store sales over time. The project leverages SQL queries to generate key business intelligence, offering valuable recommendations for improving sales strategies, operational efficiency and customer satisfaction.

## Entity Relationship Diagram (ERD)

![ERD](https://github.com/wajiha-khanam/Apple_Data/blob/main/erd.png)


## Database Schema

The project uses five main tables:

1. **stores**: Contains information about Apple retail stores.
   - `store_id`: Unique identifier for each store.
   - `store_name`: Name of the store.
   - `city`: City where the store is located.
   - `country`: Country of the store.

2. **category**: Holds product category information.
   - `category_id`: Unique identifier for each product category.
   - `category_name`: Name of the category.

3. **products**: Details about Apple products.
   - `product_id`: Unique identifier for each product.
   - `product_name`: Name of the product.
   - `category_id`: References the category table.
   - `launch_date`: Date when the product was launched.
   - `price`: Price of the product.

4. **sales**: Stores sales transactions.
   - `sale_id`: Unique identifier for each sale.
   - `sale_date`: Date of the sale.
   - `store_id`: References the store table.
   - `product_id`: References the product table.
   - `quantity`: Number of units sold.

5. **warranty**: Contains information about warranty claims.
   - `claim_id`: Unique identifier for each warranty claim.
   - `claim_date`: Date the claim was made.
   - `sale_id`: References the sales table.
   - `repair_status`: Status of the warranty claim (e.g., Paid Repaired, Warranty Void).

## Dataset

- **Size**: 1 million+ rows of sales data.
- **Period Covered**: The data spans multiple years, allowing for long-term trend analysis.
- **Geographical Coverage**: Sales data from Apple stores across various countries.

## Project Insights:

1. - The UK and USA lead with 10 stores each, followed by Canada with 8 stores, while mid-tier countries like China (4 stores) and Australia (3 stores) have moderate representation.
   - Countries such as Brazil, Japan, Spain, Turkey, India, France, Germany, and UAE each have 2 stores, while all other countries have only 1 store each.

2. - Top-performing stores (e.g., Apple South Coast Plaza) achieve sales close to 50,000 units, demonstrating strong market performance and demand.
   - Many stores experience moderate to low sales figures, with units dropping significantly as we move down the list (e.g., Apple Manchester with just 714 units).

3. There were 32,846 sales transactions recorded in December 2023.

4. There are 58 stores that have never had a warranty claim filed.

5. Approximately 23.16% of warranty claims have been marked as "Warranty Void."

6. - The store with the highest total units sold in the past year is "Apple Mumbai" (Store ID ST-52).
   - This store achieved 4,428 units sold, reflecting its strong performance and customer demand in the past year.

7. A total of 50 unique products were sold over the past year.

8. * Highest Priced Category: - The "Laptop" category (CAT-1) has the highest average product price at $1511.5.
   * Other Notable Categories: - "Desktop" (CAT-7) also has a relatively high average price of $1199.
                               - "Smartphone" (CAT-4) and "Tablet" (CAT-3) have average prices of $889.43 and $656.5 respectively.
   * Lowest Priced Category:   - The "Accessory" category (CAT-10) has the lowest average product price at $29.

9. A total of 2,750 warranty claims were filed in the year 2020.

10. * Top Stores with High Best-Selling Days: - ST-5 ("Apple South Coast Plaza") achieved 7,221 units on its best-selling day (Thursday).
                                              - ST-1 ("Apple Fifth Avenue") saw 6,830 units on Thursday.
                                              - ST-3 ("Apple Michigan Avenue") recorded 6,759 units on Thursday.
    * Day Trends: - Thursdays appear as a dominant day for many stores (e.g., ST-1, ST-5, ST-14).
                  - Many stores also saw strong sales on Sundays, indicating weekends' influence on purchasing behavior.


11. *  Frequent Least-Selling Products: - iPhone 13 Mini: The least-selling product in several countries (e.g., Argentina, Bolivia, Costa Rica, Peru).
                                        - iPad Air (4th Gen): Frequently the least popular product in countries like China, Indonesia, and Taiwan.
    * Country-Specific Observations: - USA: Although the iPhone 12 Mini is the least-selling product, its sales (1,025 units) are significantly higher than other countries' least-sellers, reflecting a higher baseline demand.
                                     - Chile & Malaysia: Products like Mac mini (M1) and MacBook Air (M1) have very low sales (26 and 25 units, respectively), possibly due to niche demand or limited marketing.

12. A total of 19,907 warranty claims were filed within 180 days of the product sale. This indicates the volume of warranty issues arising relatively soon after purchase.

13. * Total Claims for Recent Products:
                                     - iPhone 15: 321 claims out of 21,547 sales.
                                     - iPhone 15 Pro: 290 claims out of 21,861 sales.
                                     - iPhone 15 Pro Max: 320 claims out of 21,661 sales.

14. The last quarter of 2022 (September to December) had consistently high sales.

15. * Smartphone leads significantly with 9,015 claims, reflecting its high sales volume and potential for frequent warranty usage due to extensive daily use.
    *  Tablet is the second most claimed category (3,201 claims), followed by Wearable (985) and Subscription Service (940).

16. * UAE has the highest percentage of warranty claims at 65.87%, indicating significant risk.
    * Countries like Indonesia, USA, and many others have a 0% risk, implying no warranty claims recorded during the analysis period.
    * The global average risk appears quite low for most countries except a few outliers.

17. * Stores in cities like Mumbai, Istanbul, and Seoul exhibited extraordinary growth rates in 2023, with year-on-year growth ratios of 571.71%, 567.23%, and 558.08%, respectively. 
    * Despite previous growth, many stores in prominent locations, including New York (Fifth Avenue), London (Regent Street), and Tokyo (Marunouchi), experienced steep sales declines in 2023, with reductions of over 70%. 
    * While newer or less saturated markets like Mumbai and Istanbul displayed strong sales surges, traditional flagship stores in established regions (e.g., Michigan Avenue, The Grove, and Union Square) showed consistent patterns of extreme sales volatility

18. * Warranty Claims Decrease as Product Price Increases
     - Less Expensive products (< $500) account for the highest number of claims, totaling 14,422.
     - Mid-range products ($500–$1000) follow with 11,951 claims.
     - Expensive products (> $1000) have the fewest claims at 4,463.

19. * Apple Kurfürstendamm (ST-26) has the highest percentage of "Paid Repaired" claims at 37.50% (60 out of 160 claims).
    * Apple Dubai Mall (ST-31) and Apple Milan (ST-30) handled the largest volume of total repairs (5838 and 1691 respectively), but their percentage of "Paid Repaired" claims is among the lowest at 24.44% and 24.66%.

21. * High Initial Demand for New Products
        - AirTag and iPhone 14 series show massive demand in the first six months (0 - 6 months) after launch:
          -- AirTag: 82,549 units sold.
          -- iPhone 14 and iPhone 14 Pro: ~32,000 units each.
    * Declining Momentum in Later Stages
       - Many products see a sharp decline in sales after the first six months:
          -- AirPods (3rd Gen): Drops from 6,099 units (0 - 6 months) to 2,655 units (6 - 12 months) and then to 364 (12 - 18 months).
          -- MacBook Pro (M1 Max, 16-inch) follows a similar trend, with sales dropping significantly after the initial six months.
    * Longevity of Flagship Products
       - Certain flagship products maintain moderate sales even in the 18+ months category:
          - iPhone XR and iPhone X continue to sell thousands of units years after launch, with 15,906 and 61,561 units sold in the 18+ period, respectively.
          - AirPods (2nd Gen) also shows sustained demand in the 18+ lifecycle with 3,375 units sold.




