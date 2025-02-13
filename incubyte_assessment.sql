Create database sales;

use sales;

create table Sale
(
TransactionID int primary key,
CustomerID int null,
TransactionDate Datetime null,
TransactionAmount decimal(10,2) not null,
PaymentMethod varchar(20),
Quantity int not null,
DiscountPercent decimal(10,2),
City varchar(15),
StoreType Varchar(15),
CustomerAge int,
CustomerGender varchar(10),
LoyaltyPoints int,
ProductName varchar(30),
Region varchar(30),
Returned enum('Yes', 'No') not null,
FeedbackScore int,
ShippingCost decimal(10,2),
DeliveryTimeDays int,
IsPromotional enum('Yes', 'No') not null
);

select * from sale;

load data infile 'assessment_dataset(in)'
into table sale
fields terminated by','
lines terminated by '\n'
(TransactionDate)
set TransactionDate =
str_to_date(TransactionDate
, '%d-%m-%y %H:%i');

select * from sale;

# Customer Age Group Analysis  to find 
# and helps to understand which age groups spend the most

SELECT 
    CASE 
        WHEN CustomerAge BETWEEN 18 AND 25 THEN '18-25'
        WHEN CustomerAge BETWEEN 26 AND 35 THEN '26-35'
        WHEN CustomerAge BETWEEN 36 AND 45 THEN '36-45'
        WHEN CustomerAge BETWEEN 46 AND 60 THEN '46-60'
        WHEN CustomerAge BETWEEN 61 AND 90 THEN '61-90'
        ELSE 'null'
    END AS Age_Group, 
    COUNT(TransactionID) AS Total_Transactions,
    SUM(TransactionAmount) AS Total_Spent
FROM sale
GROUP BY Age_Group
ORDER BY Total_Spent DESC;

# This query helps businesses understand which age group prefers which product and how much they spend on them.

SELECT 
    CASE 
        WHEN CustomerAge BETWEEN 18 AND 25 THEN '18-25'
        WHEN CustomerAge BETWEEN 26 AND 35 THEN '26-35'
        WHEN CustomerAge BETWEEN 36 AND 45 THEN '36-45'
        WHEN CustomerAge BETWEEN 46 AND 60 THEN '46-60'
        WHEN CustomerAge BETWEEN 61 AND 90 THEN '61-90'
        ELSE 'null'
    END AS Age_Group, 
    ProductName,
    COUNT(TransactionID) AS Total_Transactions,
    SUM(TransactionAmount) AS Total_Spent
FROM sale
GROUP BY Age_Group, ProductName
ORDER BY Age_Group, Total_Spent DESC;

# spending behavior varies among genders along the age groups, If "Unknown" or "Other" genders are spending a lot on specific items, businesses can explore gender-neutral marketing strategies.

SELECT 
    CASE 
        WHEN CustomerAge BETWEEN 18 AND 25 THEN '18-25'
        WHEN CustomerAge BETWEEN 26 AND 35 THEN '26-35'
        WHEN CustomerAge BETWEEN 36 AND 45 THEN '36-45'
        WHEN CustomerAge BETWEEN 46 AND 60 THEN '46-60'
        WHEN CustomerAge BETWEEN 61 AND 90 THEN '61-90'
        ELSE 'null'
    END AS Age_Group, 

    COALESCE(CustomerGender, 'Unknown') AS Gender,  -- Handling NULL values
    ProductName,
    COUNT(TransactionID) AS Total_Transactions,
    SUM(TransactionAmount) AS Total_Spent
FROM sale
GROUP BY Age_Group, Gender, ProductName
ORDER BY Age_Group, Gender, Total_Spent DESC;

-- Calculating the Total Revenue and Total Transactions, this provides a high-level overview of how much revenue has been generated and how many transactions took place.

SELECT 
    SUM(TransactionAmount) AS Total_Revenue, 
    COUNT(TransactionID) AS Total_Transactions
FROM sale;

-- To calculate the average transaction amount, Average Order Value helps measure customer spending behavior. Higher values indicate customers are making larger purchases.

SELECT 
    SUM(TransactionAmount) / COUNT(TransactionID) AS Avg_Order_Value
FROM sale;

-- This query shows which payment methods are used the most. This reveals the most preferred payment methods, helping businesses optimize checkout processes.

SELECT 
    PaymentMethod, 
    COUNT(TransactionID) AS Transaction_Count, 
    SUM(TransactionAmount) AS Total_Revenue
FROM sale
GROUP BY PaymentMethod
ORDER BY Total_Revenue DESC;

-- Let's find the top 5 best-selling products based on total revenue.

SELECT 
    ProductName, 
    SUM(TransactionAmount) AS Total_Revenue,
    COUNT(TransactionID) AS Sales_Count
FROM sale
GROUP BY ProductName
ORDER BY Total_Revenue DESC
LIMIT 5;

/* 
Finding the best-selling products based on quantity sold and revenue.
Identifying which products have high/low ratings and which age groups give the lowest feedback.
What age group & gender buy them the most?
Find out which products have high return rates and whether it's age-group or gender-related.
Let's begin with the query 
 */

SELECT 
    ProductName,
    CASE 
        WHEN CustomerAge BETWEEN 18 AND 25 THEN '18-25'
        WHEN CustomerAge BETWEEN 26 AND 35 THEN '26-35'
        WHEN CustomerAge BETWEEN 36 AND 45 THEN '36-45'
        WHEN CustomerAge BETWEEN 46 AND 60 THEN '46-60'
        WHEN CustomerAge BETWEEN 61 AND 90 THEN '61-90'
        ELSE 'null'
    END AS Age_Group,

    COALESCE(CustomerGender, 'Unknown') AS Gender,  -- Handling NULL values

    FeedbackScore,
    Returned,
    COUNT(TransactionID) AS Total_Transactions,
    SUM(TransactionAmount) AS Total_Spent,
    SUM(Quantity) AS Total_Units_Sold
FROM sale
GROUP BY ProductName, Age_Group, Gender, FeedbackScore, Returned
ORDER BY Total_Units_Sold DESC, Total_Spent DESC;

# Best-rated products (Feedback 3, 4, 5) with highest sales.

SELECT 
    ProductName,
    CASE 
        WHEN CustomerAge BETWEEN 18 AND 25 THEN '18-25'
        WHEN CustomerAge BETWEEN 26 AND 35 THEN '26-35'
        WHEN CustomerAge BETWEEN 36 AND 45 THEN '36-45'
        WHEN CustomerAge BETWEEN 46 AND 60 THEN '46-60'
        WHEN CustomerAge BETWEEN 61 AND 90 THEN '61-90'
        ELSE 'null'
    END AS Age_Group,

    COALESCE(CustomerGender, 'Unknown') AS Gender,  -- Handling NULL values

    FeedbackScore,
    Returned,
    COUNT(TransactionID) AS Total_Transactions,
    SUM(TransactionAmount) AS Total_Spent,
    SUM(Quantity) AS Total_Units_Sold
FROM sale
WHERE FeedbackScore IN (3, 4, 5)  -- Filter only positive feedback
GROUP BY ProductName, Age_Group, Gender, FeedbackScore, Returned
ORDER BY Total_Units_Sold DESC, Total_Spent DESC;

# Sales Breakdown by Region

SELECT 
    Region, 
    SUM(TransactionAmount) AS Total_Revenue, 
    COUNT(TransactionID) AS Total_Transactions
FROM sale
GROUP BY Region
ORDER BY Total_Revenue DESC;

# Sales Breakdown by Cities and thier regions

SELECT
	City,
    Region, 
    SUM(TransactionAmount) AS Total_Revenue, 
    COUNT(TransactionID) AS Total_Transactions
FROM sale
GROUP BY city, region
ORDER BY Total_Revenue DESC;

# This query compares online and in-store sales, helps businesses decide whether to invest more in e-commerce or physical stores.

SELECT 
    StoreType, 
    SUM(TransactionAmount) AS Total_Revenue, 
    COUNT(TransactionID) AS Total_Transactions
FROM sale
GROUP BY StoreType;

# Sales Trend Over Time, Identifies seasonal trends and peak sales months

SELECT 
    DATE_FORMAT(TransactionDate, '%Y-%m') AS Month, 
    SUM(TransactionAmount) AS Total_Revenue
FROM sale
GROUP BY Month
ORDER BY Month;

# Shipping Cost Impact on Orders

WITH Shipping_Categorized AS (
    SELECT 
        TransactionID,
        ProductName,
        CustomerAge,
        COALESCE(CustomerGender, 'Unknown') AS Gender,
        FeedbackScore,
        Returned,
        ShippingCost,
        TransactionAmount,
        Quantity,
        
        -- Divide shipping cost into 3 equal-sized groups using NTILE
        CASE 
            WHEN NTILE(3) OVER (ORDER BY ShippingCost ASC) = 1 THEN 'Low Shipping Cost'
            WHEN NTILE(3) OVER (ORDER BY ShippingCost ASC) = 2 THEN 'Medium Shipping Cost'
            ELSE 'High Shipping Cost'
        END AS Shipping_Cost_Category
        
    FROM sale
)
SELECT 
    Shipping_Cost_Category,
    COUNT(TransactionID) AS Total_Orders,
    SUM(TransactionAmount) AS Total_Sales,
    AVG(ShippingCost) AS Avg_Shipping_Cost,
    AVG(FeedbackScore) AS Avg_Feedback,
    SUM(CASE WHEN Returned = 'Yes' THEN 1 ELSE 0 END) AS Total_Returns
FROM Shipping_Categorized
GROUP BY Shipping_Cost_Category
ORDER BY Total_Sales DESC;

# This query analyzes how promotions affect revenue, we can further clasify it by applying more factors such as region and city based or which age groups influenced by these ads, etc.

SELECT 
    IsPromotional, 
    COUNT(TransactionID) AS Total_Transactions,
    SUM(TransactionAmount) AS Total_Revenue
FROM sale
GROUP BY IsPromotional;




