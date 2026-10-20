-- PROJECT: SaaS Metrics & Analytics Database Structure
-- DESCRIPTION: This script initializes a database designed to track and analyze
--  client behavior, plans, and subscription states for a SaaS platform.

-- 1. DATABASE & INITIAL SCHEMA CREATION

-- Creates a dedicated database instance for managing SaaS-specific operations.
CREATE DATABASE Saas_Metrics_DB; 
USE Saas_Metrics_DB;

-- Creates the 'Clients' master table to store firmographic information.
CREATE TABLE Clients(
   client_id INT PRIMARY KEY ,
    Company_Name VARCHAR(50) NOT NULL,
    Industry TEXT  CHECK(Industry IN ('Finance', 'Healthcare','E-Commerce','Logistics','EdTech')),-- A CHECK constraint restricts the 'Industry' column to fixed target sectors.
    Country VARCHAR(50)
    ); 
    
    SELECT * FROM  Clients;
    
    -- Creates the 'Plans' master table defining subscription product offerings.
-- Restricts tiers to strict options and ensures payment rates are numerical and present.
  CREATE TABLE Plans(
   Plan_id INT PRIMARY KEY ,
   Plan_Name VARCHAR(50) NOT NULL,
   Tier TEXT CHECK(Tier IN ('Basic','Professional','Enterprise')),
   Monthly_Rate REAL NOT NULL
   );
   
SELECT * FROM  Plans;

-- Refactors the primary key of the Clients table from 'client_id' to 'ID'.
-- This updates column naming conventions before referencing it in transactional tables.
  ALTER TABLE Clients
  CHANGE COLUMN client_id ID  INT ; 
  
  -- Creates the 'Subscriptions' bridge/transactional table linking clients to plans.
-- Implements Foreign Keys for data integrity. 
-- 'ON DELETE CASCADE' ensures that deleting a client removes all corresponding subscription history.
  CREATE TABLE Subscriptions(
    Subscription_id INT PRIMARY KEY,
    Client_id INT,
    Plan_id INT,
    Start_date DATE,
    status TEXT CHECK(status IN ('Active', 'Upgraded', 'Cancelled')),
    Support_tickets_raised INT DEFAULT 0,
    FOREIGN KEY (Client_id) REFERENCES Clients(ID) ON DELETE CASCADE,
    FOREIGN KEY (Plan_id) REFERENCES Plans(Plan_id)
);
SELECT * FROM Subscriptions;

-- 2.Data Population  (SEEDING DATA)

-- Populates core data sheets for 10 sample B2B clients, 3 standard product tiers,
-- and 50 historical subscription records tracking lifecycle actions.
INSERT INTO clients VALUES 
(101, 'Alpha Financials', 'Finance', 'India'), (102, 'Beta Health Corp', 'Healthcare', 'USA'),
(103, 'Gamma Cart', 'E-Commerce', 'UK'), (104, 'Delta Logistics', 'Logistics', 'India'),
(105, 'Omega Edu', 'EdTech', 'USA'), (106, 'Vertex Capital', 'Finance', 'UK'),
(107, 'Apex Medical', 'Healthcare', 'India'), (108, 'Zeta Shop', 'E-Commerce', 'USA'),
(109, 'Speedy Cargo', 'Logistics', 'UK'), (110, 'Sigma Learn', 'EdTech', 'India');

INSERT INTO Plans VALUES 
(501, 'Cloud Starter Kit', 'Basic', 49.00),
(502, 'Business Scale Suite', 'Professional', 199.00),
(503, 'Enterprise Ultimate', 'Enterprise', 999.00);

INSERT INTO Subscriptions VALUES
(1, 101, 503, '2025-01-10', 'Active', 1),
(2, 102, 501, '2025-01-12', 'Cancelled', 8),  
(3, 103, 502, '2025-01-15', 'Active', 2),
(4, 104, 502, '2025-01-18', 'Cancelled', 9),  
(5, 105, 503, '2025-01-20', 'Upgraded', 3),
(6, 106, 501, '2025-01-22', 'Active', 0),
(7, 107, 502, '2025-01-25', 'Cancelled', 7),  
(8, 108, 503, '2025-01-28', 'Active', 1),
(9, 109, 501, '2025-02-01', 'Active', 2),
(10, 110, 502, '2025-02-03', 'Cancelled', 8),
(11, 101, 501, '2025-02-05', 'Active', 1),
(12, 102, 502, '2025-02-07', 'Active', 3),
(13, 103, 503, '2025-02-10', 'Upgraded', 2),
(14, 104, 501, '2025-02-12', 'Active', 0),
(15, 105, 502, '2025-02-14', 'Cancelled', 9),
(16, 106, 503, '2025-02-16', 'Active', 1),
(17, 107, 501, '2025-02-18', 'Active', 2),
(18, 108, 502, '2025-02-20', 'Active', 4),
(19, 109, 503, '2025-02-22', 'Cancelled', 7),
(20, 110, 501, '2025-02-25', 'Active', 0),
(21, 101, 502, '2025-03-01', 'Active', 2),
(22, 102, 503, '2025-03-03', 'Upgraded', 1),
(23, 103, 501, '2025-03-05', 'Cancelled', 8),
(24, 104, 502, '2025-03-08', 'Active', 3),
(25, 105, 503, '2025-03-10', 'Active', 1),
(26, 106, 502, '2025-03-12', 'Cancelled', 9),
(27, 107, 503, '2025-03-15', 'Active', 0),
(28, 108, 501, '2025-03-17', 'Active', 2),
(29, 109, 502, '2025-03-19', 'Active', 1),
(30, 110, 503, '2025-03-22', 'Cancelled', 8),
(31, 101, 501, '2025-03-25', 'Active', 0),
(32, 102, 502, '2025-03-28', 'Active', 2),
(33, 103, 503, '2025-04-01', 'Upgraded', 3),
(34, 104, 501, '2025-04-03', 'Cancelled', 7),
(35, 105, 502, '2025-04-05', 'Active', 1),
(36, 106, 503, '2025-04-08', 'Active', 2),
(37, 107, 501, '2025-04-10', 'Cancelled', 8),
(38, 108, 502, '2025-04-12', 'Active', 0),
(39, 109, 503, '2025-04-15', 'Active', 4),
(40, 110, 501, '2025-04-17', 'Cancelled', 9),
(41, 101, 502, '2025-04-20', 'Active', 1),
(42, 102, 503, '2025-04-22', 'Active', 2),
(43, 103, 501, '2025-04-25', 'Active', 0),
(44, 104, 502, '2025-04-28', 'Cancelled', 8),
(45, 105, 503, '2025-05-01', 'Upgraded', 2),
(46, 106, 501, '2025-05-03', 'Active', 1),
(47, 107, 502, '2025-05-05', 'Active', 3),
(48, 108, 503, '2025-05-08', 'Cancelled', 7),
(49, 109, 501, '2025-05-10', 'Active', 0),
(50, 110, 502, '2025-05-12', 'Active', 2);




-- 3. ANALYTICAL QUERIES (BI & INSIGHTS GENERATION)

 -- QUERY 1: HIGH-LEVEL PRODUCT PERFORMANCE DASHBOARD
-- RATIONALE: Aggregates volume metrics, theoretical MRR (Monthly Recurring Revenue), 
--            and support volume per plan. Features a correlated subquery to map total 
--            account churn per plan group.

    SELECT p.plan_name,p.tier,
    COUNT(s.subscription_id) AS total_subscriptions,
    SUM(p.monthly_rate) AS potential_monthly_revenue,
    AVG(s.support_tickets_raised) AS avg_support_tickets,
    -- Correlated subquery calculating total absolute churned logs for this explicit plan
    (SELECT COUNT(*) 
     FROM subscriptions s2 
     WHERE s2.plan_id = p.plan_id AND s2.status = 'Cancelled') AS total_cancelled_accounts
FROM subscriptions AS s
INNER JOIN plans AS p
 ON s.plan_id = p.plan_id
GROUP BY p.plan_id, p.plan_name, p.tier 
HAVING total_subscriptions > 10
ORDER BY potential_monthly_revenue DESC;

-- QUERY 2: ADVANCED CHURN & CUSTOMER HEALTH MATRIX
-- RATIONALE: This advanced inquiry performs a behavioral diagnosis by isolating 
--            support ticket patterns. It calculates a baseline threshold (active users)
--            and contrasts it directly against churned account behavior to isolate
--            potential system errors, UX bugs, or customer dissatisfaction flags.
SELECT 
    p.plan_name,
    p.tier, 
    COUNT(s.subscription_id) AS total_subscriptions, 
    SUM(p.monthly_rate) AS potential_monthly_revenue, 
    
    -- Metrics 1. Total Churned/Cancelled Accounts
    (SELECT COUNT(*) 
     FROM subscriptions s2 
     WHERE s2.plan_id = s.plan_id AND s2.status = 'Cancelled') AS total_cancelled_accounts,

    -- Metrics 2. Avg tickets raised by clients who CANCELLED (The "Bug" Indicator)
    (SELECT AVG(s3.support_tickets_raised) 
     FROM subscriptions s3 
     WHERE s3.plan_id = s.plan_id AND s3.status = 'Cancelled') AS avg_tickets_cancelled_clients,

    -- Metrics 3. Avg tickets raised by clients who STAYED ACTIVE (The Baseline)
    (SELECT AVG(s4.support_tickets_raised) 
     FROM subscriptions s4 
     WHERE s4.plan_id = s.plan_id AND s4.status = 'Active') AS avg_tickets_active_clients

FROM subscriptions AS s 
INNER JOIN plans AS p ON s.plan_id = p.plan_id 
GROUP BY p.plan_id, p.plan_name, p.tier 
HAVING total_subscriptions > 10 
ORDER BY potential_monthly_revenue DESC;
