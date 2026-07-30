-- RetentionIQ SQL Analytics

-- 1. Overall churn KPIs
SELECT
    COUNT(*) AS total_customers,
    SUM(ChurnFlag) AS churned_customers,
    COUNT(*) - SUM(ChurnFlag) AS retained_customers,
    ROUND(
        100.0 * SUM(ChurnFlag) / COUNT(*),
        2
    ) AS churn_rate,
    ROUND(
        SUM(ActualMonthlyRevenueLost),
        2
    ) AS monthly_revenue_lost,
    ROUND(
        SUM(ActualAnnualRevenueLost),
        2
    ) AS annualized_revenue_lost
FROM telecom_customers;

-- 2. Churn by contract type
SELECT
    ContractType,
    COUNT(*) AS customers,
    SUM(ChurnFlag) AS churned_customers,
    ROUND(
        100.0 * SUM(ChurnFlag) / COUNT(*),
        2
    ) AS churn_rate,
    ROUND(
        SUM(
            CASE
                WHEN ChurnFlag = 1 THEN MonthlyCharges
                ELSE 0
            END
        ),
        2
    ) AS monthly_revenue_lost
FROM telecom_customers
GROUP BY
    ContractType
ORDER BY churn_rate DESC;

-- 3. Churn by tech support
SELECT
    TechSupport,
    COUNT(*) AS customers,
    SUM(ChurnFlag) AS churned_customers,
    ROUND(
        100.0 * SUM(ChurnFlag) / COUNT(*),
        2
    ) AS churn_rate,
    ROUND(AVG(MonthlyCharges), 2) AS average_monthly_charge
FROM telecom_customers
GROUP BY
    TechSupport
ORDER BY churn_rate DESC;

-- 4. Churn by tenure segment
SELECT
    TenureSegment,
    COUNT(*) AS customers,
    SUM(ChurnFlag) AS churned_customers,
    ROUND(
        100.0 * SUM(ChurnFlag) / COUNT(*),
        2
    ) AS churn_rate,
    ROUND(
        SUM(ActualAnnualRevenueLost),
        2
    ) AS annualized_revenue_lost
FROM telecom_customers
GROUP BY
    TenureSegment
ORDER BY churn_rate DESC;

-- 5. Revenue risk by action
SELECT
    RecommendedAction,
    COUNT(*) AS customers,
    ROUND(SUM(AnnualRevenueAtRisk), 2) AS annual_revenue_at_risk,
    ROUND(SUM(InterventionCost), 2) AS campaign_cost,
    ROUND(
        SUM(ExpectedRevenueProtected),
        2
    ) AS expected_revenue_protected,
    ROUND(SUM(ExpectedNetBenefit), 2) AS expected_net_benefit
FROM customer_retention_scores
GROUP BY
    RecommendedAction
ORDER BY expected_net_benefit DESC;

-- 6. Top retention candidates
SELECT
    CampaignRank,
    CustomerID,
    ROUND(ChurnProbability, 4) AS churn_probability,
    CampaignRiskTier,
    ROUND(CustomerValueScore, 4) AS customer_value_score,
    RecommendedAction,
    ROUND(AnnualRevenueAtRisk, 2) AS annual_revenue_at_risk,
    ROUND(ExpectedNetBenefit, 2) AS expected_net_benefit,
    ROUND(CumulativeCampaignCost, 2) AS cumulative_campaign_cost
FROM campaign_candidates
ORDER BY CampaignRank
LIMIT 20;

-- 7. Campaign budget scenarios
SELECT
    CampaignBudget,
    CustomersTargeted,
    CampaignCost,
    UnusedBudget,
    ROUND(ExpectedRevenueProtected, 2) AS expected_revenue_protected,
    ROUND(ExpectedNetBenefit, 2) AS expected_net_benefit,
    ROUND(ExpectedROI, 2) AS expected_roi
FROM campaign_budget_scenarios
ORDER BY CampaignBudget;