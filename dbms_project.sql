
/* DAIRY FARM MANAGEMENT SYSTEM */
create database project;
use project;

/* creatng tables */
CREATE TABLE Cow (
    cow_id INT PRIMARY KEY,
    breed VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    health_status VARCHAR(50) NOT NULL
);

CREATE TABLE FeedSchedule (
    feed_id INT PRIMARY KEY,
    cow_id INT,
    feed_type VARCHAR(50) NOT NULL,
    feed_time TIME NOT NULL,
    FOREIGN KEY (cow_id) REFERENCES Cow(cow_id)
);

CREATE TABLE HealthRecord (
    record_id INT PRIMARY KEY,
    cow_id INT,
    checkup_date DATE NOT NULL,
    diagnosis VARCHAR(255),
    treatment VARCHAR(255),
    FOREIGN KEY (cow_id) REFERENCES Cow(cow_id)
);

CREATE TABLE MilkProduction (
    production_id INT PRIMARY KEY,
    cow_id INT,
    production_date DATE NOT NULL,
    liters DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (cow_id) REFERENCES Cow(cow_id)
);

CREATE TABLE MilkSale (
    sale_id INT PRIMARY KEY,
    production_id INT,
    customer_name VARCHAR(100) NOT NULL,
    sale_date DATE NOT NULL,
    quantity DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (production_id) REFERENCES MilkProduction(production_id)
);

/*inserting values into tables */
INSERT INTO Cow VALUES
(1, 'Holstein', 4, 'Healthy'),
(2, 'Jersey', 3, 'Healthy'),
(3, 'Brown Swiss', 5, 'Sick'),
(4, 'Gir', 2, 'Healthy'),
(5, 'Sahiwal', 6, 'Recovering');


INSERT INTO FeedSchedule VALUES
(1, 1, 'Grass', '06:00'),
(2, 1, 'Corn Mix', '18:00'),
(3, 2, 'Silage', '07:00'),
(4, 3, 'Hay', '08:00'),
(5, 4, 'Corn Mix', '17:00');


INSERT INTO HealthRecord VALUES
(1, 1, '2026-01-10', 'Routine Checkup', 'None'),
(2, 2, '2026-02-01', 'Routine Checkup', 'None'),
(3, 3, '2026-02-05', 'Fever', 'Antibiotics'),
(4, 5, '2026-02-08', 'Injury', 'Bandage & Rest'),
(5, 4, '2026-02-15', 'Routine Checkup', 'None');


INSERT INTO MilkProduction VALUES
(1, 1, '2026-02-20', 12.5),
(2, 2, '2026-02-20', 10.0),
(3, 3, '2026-02-20', 8.3),
(4, 4, '2026-02-20', 11.0),
(5, 5, '2026-02-20', 9.8);

INSERT INTO MilkSale VALUES
(1, 1, 'Ram Dairy', '2026-02-21', 5.0),
(2, 1, 'Sharma Milk Center', '2026-02-21', 3.5),
(3, 2, 'FreshMart', '2026-02-21', 6.0),
(4, 3, 'Local Market', '2026-02-21', 4.0),
(5, 4, 'City Dairy', '2026-02-21', 7.0);

/* milk production with cow detail */
SELECT MilkProduction.production_id, Cow.breed, MilkProduction.liters
FROM MilkProduction
INNER JOIN Cow ON MilkProduction.cow_id = Cow.cow_id;

/* show all cows with any health records */

SELECT Cow.cow_id, Cow.breed, HealthRecord.checkup_date
FROM Cow
LEFT JOIN HealthRecord ON Cow.cow_id = HealthRecord.cow_id;

SELECT cow_id, COUNT(*) AS total_feeds
FROM FeedSchedule
GROUP BY cow_id;

/*Get breed of cow with highest milk production */
SELECT breed
FROM Cow
WHERE cow_id = (
    SELECT cow_id
    FROM MilkProduction
    ORDER BY liters DESC
    LIMIT 1
);

CREATE VIEW Production_Detail AS
SELECT MilkProduction.production_id, Cow.breed, MilkProduction.liters, MilkProduction.production_date
FROM MilkProduction
JOIN Cow ON MilkProduction.cow_id = Cow.cow_id;

START TRANSACTION;

INSERT INTO MilkSale VALUES
(10, 2, 'Everest Dairy', '2026-03-01', 5.5);

-- If transaction successful:
COMMIT;

-- If error occurs:
 ROLLBACK;
 
 /*Find cow with highest milk production (in a single day) */
 SELECT MAX(liters) AS highest_daily_production
FROM MilkProduction;
 
 /*Find cow with lowest milk production */
 SELECT MIN(liters) AS lowest_daily_production
FROM MilkProduction;

  /*Total milk produced by the dairy farm */
  SELECT SUM(liters) AS total_milk_produced
FROM MilkProduction;

   /*Total number of health checkups */
   SELECT COUNT(*) AS total_health_records
FROM HealthRecord;


    /*Cows producing more than 10 liters milk */
    SELECT cow_id, SUM(liters) AS total_milk
FROM MilkProduction
GROUP BY cow_id
HAVING total_milk > 10;
     /* Total milk sold per customer*/
     SELECT customer_name, SUM(quantity) AS total_bought
FROM MilkSale
GROUP BY customer_name;
      /* Average milk production per breed*/
      SELECT Cow.breed, AVG(MilkProduction.liters) AS avg_liters
FROM MilkProduction
JOIN Cow ON MilkProduction.cow_id = Cow.cow_id
GROUP BY Cow.breed;