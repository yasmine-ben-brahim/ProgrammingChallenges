---- PMG SQL Challenge ----- Yasmine Ben-Brahim----------------------------------------------------------------------
---- LINK TO BigQuery: https://console.cloud.google.com/bigquery?sq=832051637942:5bae93f998584ad5a21a929b6d10a202

# 1. Write a query to get the sum of impressions by day.
/* NOTE: I wrote two queries for this question. Depending on how it is interpreted, the user may want the unique dates or day of the week.*/

# by date
SELECT CAST(mp.date AS date) AS day, SUM(impressions) AS totImpressions 
FROM `pmg.marketing_performance` AS mp
GROUP BY date
ORDER BY date;

# by day of the week
SELECT FORMAT_DATE('%A', mp.date) AS day, SUM(impressions) AS totImpressions 
FROM `pmg.marketing_performance` AS mp
GROUP BY day
ORDER BY totImpressions DESC;

#---------------------------------------------------------------------------------------------------

# 2. Write a query to get the top three revenue-generating states in order of best to worst. How much revenue did the third best state generate?

SELECT state, SUM(revenue) AS totRevenue FROM `pmg.website_revenue`
GROUP BY state
ORDER BY SUM(revenue) DESC
limit 3;

# The third best state, Ohio, generated $37,577.00 in revenue.

#---------------------------------------------------------------------------------------------------

# 3. Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output. 

SELECT ci.name, ROUND(SUM(mp.cost),2) AS totCost, SUM(mp.impressions) AS totImpressions, SUM(mp.clicks) AS totClicks, SUM(wr.revenue) AS totRevenue
FROM `pmg.campaign_info` AS ci
INNER JOIN `pmg.marketing_performance` AS mp ON CAST(ci.id AS string) = mp.campaign_id 
INNER JOIN `pmg.website_revenue` AS wr ON mp.campaign_id = wr.campaign_id
GROUP BY ci.name
ORDER BY ci.name;

/* NOTE: Rounding isn't explicity stated in the question, and depending on the business requirements, we may not want to round. However, for the purpose of this exercise, I rounded to 2 decimals, or the cent, to maintain a clean view of the results.*/

#---------------------------------------------------------------------------------------------------

# 4. Write a query to get the number of conversions of Campaign5 by state. Which state generated the most conversions for this campaign? 

SELECT wr.state, COUNT(mp.conversions) AS numConversions
FROM `pmg.campaign_info` AS ci
INNER JOIN `pmg.marketing_performance` AS mp ON CAST(ci.id AS string) = mp.campaign_id 
INNER JOIN `pmg.website_revenue` AS wr ON mp.campaign_id = wr.campaign_id
WHERE ci.name = 'Campaign5'
GROUP BY wr.state
ORDER BY COUNT(mp.conversions) DESC;

# Georgia generated the most conversions (9) for Campaign5.

#---------------------------------------------------------------------------------------------------

# 5. In your opinion, which campaign was the most efficient, and why? 

SELECT ci.name, COUNT(mp.conversions) AS numConversions, ROUND(SUM(mp.cost),2) AS totCost, ROUND((SUM(mp.cost)/COUNT(mp.conversions)),2) AS costPerConversion, ROUND(100*((SUM(wr.revenue) - SUM(mp.cost))/SUM(wr.revenue)),2) AS profitPercent 
FROM `pmg.campaign_info` AS ci
INNER JOIN `pmg.marketing_performance` AS mp ON CAST(ci.id AS string) = mp.campaign_id 
INNER JOIN `pmg.website_revenue` AS wr ON mp.campaign_id = wr.campaign_id
GROUP BY ci.name
ORDER BY costPerConversion;

# Campaign 4 is the most efficient. Explanation below.
/*
When it comes to marketing, efficiency is about finding ways to make your marketing cost less. The more efficient your marketing, the faster and cheaper you can achieve maximum effectiveness. When considering "effectiveness", I am analyzing the conversions since this is when a recipient of the message resonds to the call-to-action.

So, our goal is to minimize costs and maximize conversions. I have used profit percentage as a gauge, however depending on the business requirements this could look different.

Based on the result, Campaign 4 is the most efficient campaign because the cost per conversion is the least amount and the number of conversions is equal to the median across all campaigns. Although Campaign 3 has the most conversions, the cost is relatively high and the profit percentage is comparable to Campaign 4. 
*/

#---------------------------------------------------------------------------------------------------

# 6. Bonus Question: Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.

SELECT FORMAT_DATE('%A', mp.date) AS day, ROUND(AVG(mp.conversions),1) AS avgConversions, ROUND(AVG(mp.impressions),1) AS avgImpressions, ROUND(AVG(mp.clicks),1) AS avgClicks
FROM `pmg.campaign_info` AS ci
INNER JOIN `pmg.marketing_performance` AS mp ON CAST(ci.id AS string) = mp.campaign_id 
INNER JOIN `pmg.website_revenue` AS wr ON mp.campaign_id = wr.campaign_id
GROUP BY day
ORDER BY avgConversions DESC;

# The best day of the week to run ads is on Wednesday.
/* This query is written based on the averages across all days. Although Wednesday doesn't have the highest average number of impressions, it still stands out in the other categories. Wednesday leads in the average number of conversions and the highest average clicks. Therefore, with our goal of finding out which day that ads will get the most interaction, Wednesday is the best day to run ads.
*/
