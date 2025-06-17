CREATE DATABASE telecom_provider_db;

USE telecom_provider_db;

CREATE TABLE Subscription_Plan (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    data_limit INT NOT NULL CHECK (data_limit >= 0),
    call_limit INT NOT NULL CHECK (call_limit >= 0),
    sms_limit INT NOT NULL CHECK (sms_limit >= 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(15) NOT NULL,
    address TEXT,
	plan_id INT NOT NULL,
    FOREIGN KEY (plan_id) REFERENCES Subscription_Plan(plan_id),
    CHECK (CHAR_LENGTH(phone_number) BETWEEN 10 AND 15)
);



CREATE TABLE Device (
    device_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    imei_number VARCHAR(20) NOT NULL UNIQUE,
    model VARCHAR(100),
    os_version VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Location (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    region_name VARCHAR(100) NOT NULL,
    country_code CHAR(2) NOT NULL
);

CREATE TABLE Usage_Data (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    usage_date DATE NOT NULL,
    usage_summary JSON NOT NULL,
    location_id INT,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

CREATE TABLE Billing (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    billing_month VARCHAR(7) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CHECK (billing_month REGEXP '^[0-9]{4}-[0-9]{2}$') -- Format YYYY-MM
);


CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    bill_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL,
    payment_date DATE,
    FOREIGN KEY (bill_id) REFERENCES Billing(bill_id),
    CHECK (payment_method IN ('Card', 'UPI', 'Wallet', 'Cash')),
    CHECK (status IN ('Paid', 'Failed', 'Pending'))
);


CREATE TABLE Customer_Support (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    issue TEXT NOT NULL,
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CHECK (status IN ('Open', 'In Progress', 'Closed'))
);


CREATE TABLE User_Login_Log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    login_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(45),
    device_info VARCHAR(255),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);


INSERT INTO Subscription_Plan (plan_id, name, data_limit, call_limit, sms_limit, price) VALUES
(1, 'Basic 4G', 1000, 200, 100, 199.00),
(2, 'Standard 5G', 5000, 500, 300, 399.00),
(3, 'Premium 5G+', 10000, 1000, 1000, 699.00),
(4, 'Family Pack', 8000, 1500, 2000, 999.00),
(5, 'Student Saver', 2000, 300, 500, 249.00);



INSERT INTO Customer (customer_id, plan_id, name, email, phone_number, address) VALUES
(1, 5, 'Fiza Kousar', 'fiza.k@example.com', '9876543210', 'Bangalore, India'),
(2, 2, 'Saira Banu', 'saira.b@example.com', '9876543211', 'Hyderabad, India'),
(3, 3, 'Nayaz Pasha', 'nayaz.p@example.com', '9876543212', 'Chennai, India'),
(4, 4, 'Fardin Pasha', 'fardin.p@example.com', '9876543213', 'Delhi, India'),
(5, 5, 'Dharmendra Chaudhary', 'dharmendra.c@example.com', '9876543214', 'Patna, India'),
(6, 1, 'Hari Prasad', 'hari.p@example.com', '9876543215', 'Kolkata, India'),
(7, 2, 'Bala Jii', 'bala.j@example.com', '9876543216', 'Coimbatore, India'),
(8, 3, 'Manisha K', 'manisha.k@example.com', '9876543217', 'Mumbai, India'),
(9, 4, 'Leekhitha M', 'leekhitha.m@example.com', '9876543218', 'Pune, India'),
(10, 5, 'Poornima Gowda', 'poornima.g@example.com', '9876543219', 'Mysore, India'),
(11, 1, 'Ian Somh', 'ian.s@example.com', '9876543220', 'Berlin, Germany'),
(12, 2, 'Tony Stark', 'tony.s@example.com', '9876543221', 'New York, USA'),
(13, 3, 'Ravi Kumar', 'ravi.k@example.com', '9876543222', 'Lucknow, India'),
(14, 4, 'Anita Das', 'anita.d@example.com', '9876543223', 'Bhubaneswar, India'),
(15, 5, 'Mohammed Ismail', 'ismail.m@example.com', '9876543224', 'Mangalore, India'),
(16, 1, 'Sneha Reddy', 'sneha.r@example.com', '9876543225', 'Vizag, India'),
(17, 2, 'Karan Mehta', 'karan.m@example.com', '9876543226', 'Jaipur, India'),
(18, 3, 'Ayesha Siddiqui', 'ayesha.s@example.com', '9876543227', 'Nagpur, India'),
(19, 4, 'Rohit Sharma', 'rohit.s@example.com', '9876543228', 'Ahmedabad, India'),
(20, 5, 'Pooja Sharma', 'pooja.s@example.com', '9876543229', 'Indore, India'),
(21, 1, 'David Miller', 'david.m@example.com', '9876543230', 'Cape Town, South Africa'),
(22, 2, 'Lucy Brown', 'lucy.b@example.com', '9876543231', 'London, UK'),
(23, 3, 'John Wick', 'john.w@example.com', '9876543232', 'Chicago, USA'),
(24, 4, 'Jaya Verma', 'jaya.v@example.com', '9876543233', 'Noida, India'),
(25, 5, 'Abdul Rahman', 'abdul.r@example.com', '9876543234', 'Riyadh, Saudi Arabia'),
(27, 3, 'dharma cha', 'dharmendra@gmail.com', '8296002673', 'Berlin,Germnay'),
(28, 3, 'Riya Sharma', 'riya124@email.com', '9980056330', 'Paris, France');














INSERT INTO Device (customer_id, imei_number, model, os_version) VALUES
(1, '860000000001', 'iPhone 13', 'iOS 16'),
(2, '860000000002', 'Samsung Galaxy S21', 'Android 12'),
(3, '860000000003', 'OnePlus 9R', 'Android 11'),
(4, '860000000004', 'Pixel 6', 'Android 12'),
(5, '860000000005', 'iPhone 14', 'iOS 16'),
(6, '860000000006', 'Samsung A52', 'Android 11'),
(7, '860000000007', 'Redmi Note 10', 'Android 11'),
(8, '860000000008', 'iPhone SE', 'iOS 14'),
(9, '860000000009', 'Vivo V21', 'Android 10'),
(10, '860000000010', 'Realme 8 Pro', 'Android 11'),
(11, '860000000011', 'iPhone 11', 'iOS 14'),
(12, '860000000012', 'Motorola G60', 'Android 11'),
(13, '860000000013', 'Poco X3', 'Android 10'),
(14, '860000000014', 'iPhone XR', 'iOS 13'),
(15, '860000000015', 'Asus ROG Phone 5', 'Android 11'),
(16, '860000000016', 'Oppo Reno6', 'Android 11'),
(17, '860000000017', 'Nokia 5.4', 'Android 10'),
(18, '860000000018', 'Lava Z6', 'Android 10'),
(19, '860000000019', 'iPhone 12 Mini', 'iOS 15'),
(20, '860000000020', 'Samsung Note 20', 'Android 11'),
(21, '860000000021', 'Tecno Spark 7', 'Android 9'),
(22, '860000000022', 'Sony Xperia XZ2', 'Android 10'),
(23, '860000000023', 'LG G8X', 'Android 10'),
(24, '860000000024', 'Mi 11X', 'Android 11'),
(25, '860000000025', 'Honor 9X', 'Android 9');


INSERT INTO Location (region_name, country_code) VALUES
('Bangalore', 'IN'),      -- location_id = 1
('Delhi', 'IN'),          -- location_id = 2
('Berlin', 'DE'),         -- location_id = 3
('New York', 'US'),       -- location_id = 4
('London', 'UK');         -- location_id = 5




SET SQL_SAFE_UPDATES = 0;

DELETE FROM Usage_Data;

-- Step 1: Delete existing data from Usage_Data
DELETE FROM Usage_Data;

-- Step 2: Insert new rows with valid JSON in usage_summary
INSERT INTO Usage_Data (customer_id, usage_date, usage_summary, location_id)
VALUES
(1, '2025-05-01', JSON_OBJECT('sms_count', 5,  'mb_used', 850,  'call_count', 10, 'duration_minutes', 35), 1),
(2, '2025-05-01', JSON_OBJECT('sms_count', 10, 'mb_used', 1200, 'call_count', 20, 'duration_minutes', 90), 2),
(3, '2025-05-01', JSON_OBJECT('sms_count', 2,  'mb_used', 430,  'call_count', 8,  'duration_minutes', 22), 3),
(4, '2025-05-01', JSON_OBJECT('sms_count', 1,  'mb_used', 900,  'call_count', 5,  'duration_minutes', 15), 4),
(5, '2025-05-01', JSON_OBJECT('sms_count', 6,  'mb_used', 1150, 'call_count', 12, 'duration_minutes', 40), 5),
(6, '2025-05-01', JSON_OBJECT('sms_count', 3,  'mb_used', 500,  'call_count', 18, 'duration_minutes', 70), 1),
(7, '2025-05-01', JSON_OBJECT('sms_count', 15, 'mb_used', 1600, 'call_count', 22, 'duration_minutes', 120), 2),
(8, '2025-05-01', JSON_OBJECT('sms_count', 4,  'mb_used', 950,  'call_count', 7,  'duration_minutes', 25), 3),
(9, '2025-05-01', JSON_OBJECT('sms_count', 12, 'mb_used', 1700, 'call_count', 30, 'duration_minutes', 150), 4),
(10, '2025-05-01', JSON_OBJECT('sms_count', 7,  'mb_used', 1100, 'call_count', 15, 'duration_minutes', 50), 5),
(11, '2025-05-01', JSON_OBJECT('sms_count', 2,  'mb_used', 600,  'call_count', 9,  'duration_minutes', 28), 1),
(12, '2025-05-01', JSON_OBJECT('sms_count', 8,  'mb_used', 1020, 'call_count', 14, 'duration_minutes', 45), 2),
(13, '2025-05-01', JSON_OBJECT('sms_count', 6,  'mb_used', 970,  'call_count', 11, 'duration_minutes', 38), 3),
(14, '2025-05-01', JSON_OBJECT('sms_count', 10, 'mb_used', 1400, 'call_count', 17, 'duration_minutes', 60), 4),
(15, '2025-05-01', JSON_OBJECT('sms_count', 5,  'mb_used', 890,  'call_count', 13, 'duration_minutes', 42), 5),
(16, '2025-05-01', JSON_OBJECT('sms_count', 2,  'mb_used', 450,  'call_count', 6,  'duration_minutes', 19), 1),
(17, '2025-05-01', JSON_OBJECT('sms_count', 9,  'mb_used', 1350, 'call_count', 19, 'duration_minutes', 75), 2),
(18, '2025-05-01', JSON_OBJECT('sms_count', 4,  'mb_used', 800,  'call_count', 10, 'duration_minutes', 30), 3),
(19, '2025-05-01', JSON_OBJECT('sms_count', 3,  'mb_used', 780,  'call_count', 8,  'duration_minutes', 24), 4),
(20, '2025-05-01', JSON_OBJECT('sms_count', 13, 'mb_used', 1650, 'call_count', 21, 'duration_minutes', 98), 5),
(21, '2025-05-01', JSON_OBJECT('sms_count', 1,  'mb_used', 400,  'call_count', 5,  'duration_minutes', 17), 1),
(22, '2025-05-01', JSON_OBJECT('sms_count', 6,  'mb_used', 1200, 'call_count', 16, 'duration_minutes', 53), 2),
(23, '2025-05-01', JSON_OBJECT('sms_count', 11, 'mb_used', 1500, 'call_count', 20, 'duration_minutes', 85), 3),
(24, '2025-05-01', JSON_OBJECT('sms_count', 4,  'mb_used', 980,  'call_count', 12, 'duration_minutes', 37), 4),
(25, '2025-05-01', JSON_OBJECT('sms_count', 2,  'mb_used', 600,  'call_count', 7,  'duration_minutes', 18), 5),
(27, '2025-05-01', JSON_OBJECT('sms_count', 7,  'mb_used', 800,  'call_count', 12, 'duration_minutes', 40), 3),
(28, '2025-05-01', JSON_OBJECT('sms_count', 9,  'mb_used', 950,  'call_count', 15, 'duration_minutes', 45), 3);

INSERT INTO Billing (customer_id, billing_month, total_amount) VALUES
(1, '2025-05', 199.00),
(2, '2025-05', 399.00),
(3, '2025-05', 199.00),
(4, '2025-05', 699.00),
(5, '2025-05', 999.00),
(6, '2025-05', 249.00),
(7, '2025-05', 199.00),
(8, '2025-05', 399.00),
(9, '2025-05', 699.00),
(10, '2025-05', 999.00),
(11, '2025-05', 249.00),
(12, '2025-05', 199.00),
(13, '2025-05', 399.00),
(14, '2025-05', 699.00),
(15, '2025-05', 999.00),
(16, '2025-05', 249.00),
(17, '2025-05', 199.00),
(18, '2025-05', 399.00),
(19, '2025-05', 699.00),
(20, '2025-05', 999.00),
(21, '2025-05', 249.00),
(22, '2025-05', 199.00),
(23, '2025-05', 399.00),
(24, '2025-05', 699.00),
(25, '2025-05', 999.00);


INSERT INTO Payment (bill_id, payment_method, status, payment_date) VALUES
(1, 'Card', 'Paid', '2025-06-05'),
(2, 'UPI', 'Paid', '2025-05-06'),
(4, 'Card', 'Paid', '2025-05-08'),
(5, 'UPI', 'Paid', '2025-05-09'),
(6, 'Card', 'Paid', '2025-05-10'),
(7, 'UPI', 'Paid', '2025-05-11'),
(8, 'Wallet', 'Paid', '2025-05-12'),
(9, 'Card', 'Paid', '2025-05-13'),
(10, 'UPI', 'Paid', '2025-05-14'),
(11, 'Card', 'Paid', '2025-05-15'),
(12, 'Wallet', 'Paid', '2025-05-16'),
(13, 'Cash', 'Paid', '2025-05-17'),
(14, 'UPI', 'Paid', '2025-05-18'),
(15, 'Card', 'Paid', '2025-05-19'),
(16, 'Cash', 'Paid', '2025-05-20'),
(17, 'UPI', 'Paid', '2025-05-21'),
(18, 'Card', 'Paid', '2025-05-22'),
(19, 'Wallet', 'Paid', '2025-05-23'),
(20, 'UPI', 'Paid', '2025-05-24'),
(21, 'Cash', 'Paid', '2025-05-25'),
(22, 'Card', 'Paid', '2025-05-26'),
(23, 'UPI', 'Paid', '2025-05-27'),
(24, 'Wallet', 'Paid', '2025-05-28'),
(25, 'Cash', 'Paid', '2025-05-29'),
(26, 'UPI', 'Paid', '2025-05-30'),
(27, 'Card', 'Paid', '2025-05-31'),
(28, 'Wallet', 'Paid', '2025-06-01'),
(29, 'Cash', 'Paid', '2025-06-02'),
(30, 'UPI', 'Paid', '2025-06-03');


INSERT INTO Customer_Support (customer_id, issue, status) VALUES
(2, 'Data speed is too slow.', 'Open'),
(5, 'Unable to send SMS.', 'In Progress'),
(8, 'Incorrect billing amount.', 'Closed'),
(10, 'App not responding.', 'Open'),
(12, 'Network drops frequently.', 'Open'),
(14, 'International roaming not working.', 'In Progress'),
(17, 'Can’t login to the self-care portal.', 'Closed'),
(20, 'Recharge amount not updated.', 'Open'),
(23, 'VoLTE not enabled.', 'Closed'),
(25, 'No signal inside my house.', 'In Progress');


INSERT INTO User_Login_Log (customer_id, ip_address, device_info) VALUES
(1, '192.168.0.1', 'Chrome on Windows'),
(2, '192.168.0.2', 'Safari on iPhone'),
(3, '192.168.0.3', 'Edge on Windows'),
(4, '192.168.0.4', 'Firefox on Mac'),
(5, '192.168.0.5', 'Chrome on Android'),
(6, '192.168.0.6', 'Safari on iPad'),
(7, '192.168.0.7', 'Chrome on Linux'),
(8, '192.168.0.8', 'Edge on Android'),
(9, '192.168.0.9', 'Safari on iPhone'),
(10, '192.168.0.10', 'Firefox on Linux'),
(11, '192.168.0.11', 'Chrome on Windows'),
(12, '192.168.0.12', 'Safari on Mac'),
(13, '192.168.0.13', 'Edge on Android'),
(14, '192.168.0.14', 'Chrome on Android'),
(15, '192.168.0.15', 'Firefox on Mac'),
(16, '192.168.0.16', 'Safari on iPhone'),
(17, '192.168.0.17', 'Edge on Windows'),
(18, '192.168.0.18', 'Chrome on Mac'),
(19, '192.168.0.19', 'Firefox on Windows'),
(20, '192.168.0.20', 'Safari on Android'),
(21, '192.168.0.21', 'Chrome on iPad'),
(22, '192.168.0.22', 'Edge on Linux'),
(23, '192.168.0.23', 'Safari on Android'),
(24, '192.168.0.24', 'Chrome on iPhone'),
(25, '192.168.0.25', 'Firefox on Android');

use telecom_provider_db;
-- Q1
SELECT 
    c.customer_id,
    c.name,
    c.email,
    c.phone_number,
    sp.name AS plan_name,
    sp.data_limit,
    sp.call_limit,
    sp.sms_limit,
    sp.price
FROM Customer c
JOIN Subscription_Plan sp ON c.plan_id = sp.plan_id;

-- Q2
SELECT 
    sp.plan_id,
    sp.name AS plan_name,
    sp.price,
    COUNT(c.customer_id) AS total_customers
FROM Subscription_Plan sp
LEFT JOIN Customer c ON c.plan_id = sp.plan_id
GROUP BY sp.plan_id, sp.name, sp.price;


-- upadate function
UPDATE Usage_Data 
SET usage_summary = REPLACE(REPLACE(usage_summary, '"', ''), ' ', ', ')
WHERE usage_summary NOT LIKE '{%}';

UPDATE Usage_Data 
SET usage_summary = CONCAT('{', 
                          REGEXP_REPLACE(usage_summary, '([a-z_]+):', '"$1":'), 
                          '}')
WHERE usage_summary NOT LIKE '{%}';


-- Q3
SELECT 
    c.customer_id,
    c.name,
    ud.usage_date,
    ud.usage_summary->>"$.duration_minutes" AS total_call_minutes
FROM 
    Customer c
JOIN 
    Usage_Data ud ON c.customer_id = ud.customer_id
ORDER BY 
    CAST(ud.usage_summary->>"$.duration_minutes" AS DECIMAL(10,2)) DESC
LIMIT 5;

-- Q4
SELECT 
    sp.name AS plan_name,
    ROUND(AVG(b.total_amount), 2) AS avg_billing
FROM Subscription_Plan sp
JOIN Customer c ON sp.plan_id = c.plan_id
JOIN Billing b ON c.customer_id = b.customer_id
GROUP BY sp.plan_id, sp.name;

-- Q5

SELECT 
    c.customer_id,
    c.name,
    ud.usage_summary->>"$.mb_used" AS data_used_mb,
    RANK() OVER (ORDER BY CAST(ud.usage_summary->>"$.mb_used" AS UNSIGNED) DESC) AS data_usage_rank
FROM Customer c
JOIN Usage_Data ud ON c.customer_id = ud.customer_id
WHERE ud.usage_date = '2025-05-01';



-- PROCEDURES
DELIMITER //

CREATE PROCEDURE CheckDataLimit(IN cust_id INT, IN check_date DATE)
BEGIN
    DECLARE plan_limit INT;
    DECLARE data_used INT;
    DECLARE customer_name VARCHAR(100);
    DECLARE plan_name VARCHAR(100);

    -- Get customer details and plan data limit
    SELECT c.name, sp.name, sp.data_limit 
    INTO customer_name, plan_name, plan_limit
    FROM Customer c
    JOIN Subscription_Plan sp ON c.plan_id = sp.plan_id
    WHERE c.customer_id = cust_id;

    -- Get the data usage from properly formatted JSON
    SELECT CAST(usage_summary->>"$.mb_used" AS UNSIGNED) INTO data_used
    FROM Usage_Data
    WHERE customer_id = cust_id AND usage_date = check_date
    LIMIT 1;

    -- Compare usage and limit
    IF data_used > plan_limit THEN
        SELECT CONCAT('⚠️ ', customer_name, ' (Plan: ', plan_name, ') exceeded data limit by ', 
               data_used - plan_limit, ' MB on ', check_date) AS alert;
    ELSE
        SELECT CONCAT('✅ ', customer_name, ' (Plan: ', plan_name, ') is within data limit. ',
               plan_limit - data_used, ' MB remaining on ', check_date) AS status;
    END IF;
END //

DELIMITER ;

CALL CheckDataLimit(29, '2025-05-01');


-- procedure 2
DELIMITER //

CREATE PROCEDURE GenerateMonthlyBill(
    IN p_customer_id INT,
    IN p_billing_month VARCHAR(7) -- Format: YYYY-MM
)
BEGIN
    DECLARE v_plan_id INT;
    DECLARE v_plan_name VARCHAR(100);
    DECLARE v_data_limit INT;
    DECLARE v_call_limit INT;
    DECLARE v_sms_limit INT;
    DECLARE v_plan_price DECIMAL(10,2);
    DECLARE v_total_data_used INT;
    DECLARE v_total_calls_used INT;
    DECLARE v_total_sms_used INT;
    DECLARE v_total_duration_minutes INT;
    DECLARE v_overage_charges DECIMAL(10,2) DEFAULT 0;
    DECLARE v_tax_amount DECIMAL(10,2);
    DECLARE v_total_amount DECIMAL(10,2);
    DECLARE v_bill_exists INT;
    DECLARE v_customer_name VARCHAR(100);
    
    -- Check if customer exists
    SELECT COUNT(*) INTO v_bill_exists 
    FROM Customer 
    WHERE customer_id = p_customer_id;
    
    IF v_bill_exists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Customer does not exist';
    END IF;
    
    -- Get customer and plan details
    SELECT c.name, c.plan_id, sp.name, sp.data_limit, sp.call_limit, sp.sms_limit, sp.price
    INTO v_customer_name, v_plan_id, v_plan_name, v_data_limit, v_call_limit, v_sms_limit, v_plan_price
    FROM Customer c
    JOIN Subscription_Plan sp ON c.plan_id = sp.plan_id
    WHERE c.customer_id = p_customer_id;
    
    -- Calculate usage for the month
    SELECT 
        SUM(JSON_EXTRACT(usage_summary, '$.mb_used')) AS total_data,
        SUM(JSON_EXTRACT(usage_summary, '$.call_count')) AS total_calls,
        SUM(JSON_EXTRACT(usage_summary, '$.sms_count')) AS total_sms,
        SUM(JSON_EXTRACT(usage_summary, '$.duration_minutes')) AS total_duration
    INTO 
        v_total_data_used, v_total_calls_used, v_total_sms_used, v_total_duration_minutes
    FROM Usage_Data
    WHERE customer_id = p_customer_id
    AND DATE_FORMAT(usage_date, '%Y-%m') = p_billing_month;
    
    -- Handle NULL values (if no usage data)
    SET v_total_data_used = IFNULL(v_total_data_used, 0);
    SET v_total_calls_used = IFNULL(v_total_calls_used, 0);
    SET v_total_sms_used = IFNULL(v_total_sms_used, 0);
    SET v_total_duration_minutes = IFNULL(v_total_duration_minutes, 0);
    
    -- Calculate overage charges (example rates: data $0.10/MB, calls $0.05/min, SMS $0.01 each)
    IF v_data_limit > 0 AND v_total_data_used > v_data_limit THEN
        SET v_overage_charges = v_overage_charges + (v_total_data_used - v_data_limit) * 0.10;
    END IF;
    
    IF v_call_limit > 0 AND v_total_calls_used > v_call_limit THEN
        SET v_overage_charges = v_overage_charges + (v_total_calls_used - v_call_limit) * 0.05;
    END IF;
    
    IF v_sms_limit > 0 AND v_total_sms_used > v_sms_limit THEN
        SET v_overage_charges = v_overage_charges + (v_total_sms_used - v_sms_limit) * 0.01;
    END IF;
    
    -- Calculate tax (18% of plan price + overages)
    SET v_tax_amount = (v_plan_price + v_overage_charges) * 0.18;
    
    -- Calculate total amount
    SET v_total_amount = v_plan_price + v_overage_charges + v_tax_amount;
    
    -- Check if bill already exists for this month
    SELECT COUNT(*) INTO v_bill_exists 
    FROM Billing 
    WHERE customer_id = p_customer_id 
    AND billing_month = p_billing_month;
    
    -- Insert or update the billing record
    IF v_bill_exists > 0 THEN
        UPDATE Billing
        SET total_amount = v_total_amount
        WHERE customer_id = p_customer_id
        AND billing_month = p_billing_month;
    ELSE
        INSERT INTO Billing (customer_id, billing_month, total_amount)
        VALUES (p_customer_id, p_billing_month, v_total_amount);
    END IF;
    
    -- Return the bill details
    SELECT 
        p_customer_id AS customer_id,
        v_customer_name AS customer_name,
        p_billing_month AS billing_month,
        v_plan_id AS plan_id,
        v_plan_name AS plan_name,
        v_plan_price AS base_charge,
        v_total_data_used AS data_used_mb,
        v_data_limit AS data_limit_mb,
        v_total_calls_used AS calls_used,
        v_call_limit AS call_limit,
        v_total_sms_used AS sms_used,
        v_sms_limit AS sms_limit,
        v_overage_charges AS overage_charges,
        v_tax_amount AS tax_amount,
        v_total_amount AS total_amount;
END //

DELIMITER ;

CALL GenerateMonthlyBill(29, '2025-05');

-- Functions
DELIMITER //

CREATE FUNCTION CalculateSMSOveruseCost(
    p_customer_id INT,
    p_billing_month VARCHAR(7)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_sms_limit INT;
    DECLARE v_total_sms_used INT;
    DECLARE v_overage_cost DECIMAL(10,2) DEFAULT 0;
    
    SELECT sp.sms_limit INTO v_sms_limit
    FROM Customer c
    JOIN Subscription_Plan sp ON c.plan_id = sp.plan_id
    WHERE c.customer_id = p_customer_id;
    
    SELECT SUM(JSON_EXTRACT(usage_summary, '$.sms_count')) INTO v_total_sms_used
    FROM Usage_Data
    WHERE customer_id = p_customer_id
    AND DATE_FORMAT(usage_date, '%Y-%m') = p_billing_month;
    
    SET v_total_sms_used = IFNULL(v_total_sms_used, 0);
    
    IF v_sms_limit > 0 AND v_total_sms_used > v_sms_limit THEN
        SET v_overage_cost = (v_total_sms_used - v_sms_limit) * 0.01; -- $0.01 per extra SMS
    END IF;
    
    RETURN v_overage_cost;
END //

DELIMITER ;

SELECT CalculateSMSOveruseCost(30, '2025-05') AS sms_overuse_cost;


-- function2
DELIMITER //

CREATE FUNCTION CalculateCallOveruseCost(
    p_customer_id INT,
    p_billing_month VARCHAR(7)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_call_limit INT;
    DECLARE v_total_calls_used INT;
    DECLARE v_overage_cost DECIMAL(10,2) DEFAULT 0;
    
    SELECT sp.call_limit INTO v_call_limit
    FROM Customer c
    JOIN Subscription_Plan sp ON c.plan_id = sp.plan_id
    WHERE c.customer_id = p_customer_id;
    
    SELECT SUM(JSON_EXTRACT(usage_summary, '$.call_count')) INTO v_total_calls_used
    FROM Usage_Data
    WHERE customer_id = p_customer_id
    AND DATE_FORMAT(usage_date, '%Y-%m') = p_billing_month;
    
    SET v_total_calls_used = IFNULL(v_total_calls_used, 0);
    
    IF v_call_limit > 0 AND v_total_calls_used > v_call_limit THEN
        SET v_overage_cost = (v_total_calls_used - v_call_limit) * 0.05; -- $0.05 per extra call
    END IF;
    
    RETURN v_overage_cost;
END //

DELIMITER ;

SELECT CalculateCallOveruseCost(30, '2025-05') AS call_overuse_cost;






