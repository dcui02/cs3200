CREATE DATABASE restaurant_db;
GRANT ALL PRIVILEGES ON restaurant_db.* TO 'webapp'@'%';
FLUSH PRIVILEGES;

USE restaurant_db;

CREATE TABLE Customers (
	customerID int PRIMARY KEY AUTO_INCREMENT,
	groupSize int NOT NULL,
	seatingTime datetime, -- null if not seated yet; on waitlist
    departureTime datetime -- null if customer is still dining
);

CREATE TABLE TableTypes (
    tableTypeID int PRIMARY KEY AUTO_INCREMENT,
    typeName varchar(255) NOT NULL
);

CREATE TABLE FrontStations (
	frontStationID int PRIMARY KEY AUTO_INCREMENT,
	stationName varchar(255)
);

CREATE TABLE FrontWorkers (
	frontWorkerID int PRIMARY KEY AUTO_INCREMENT,
	firstName varchar(255) NOT NULL,
	lastName varchar(255) NOT NULL,
	frontStationID int NOT NULL,
	dateHired date NOT NULL DEFAULT (UTC_DATE),
	salary double NOT NULL,
	CONSTRAINT fk_0
        FOREIGN KEY (frontStationID) REFERENCES FrontStations (frontStationID)
);

CREATE TABLE Tables (
    tableID int PRIMARY KEY AUTO_INCREMENT,
    frontWorkerID int, -- null if no front worker is helping the table yet
    customerID int, -- null if table is available
    capacity int NOT NULL,
    tableTypeID int NOT NULL,
    CONSTRAINT fk_1
        FOREIGN KEY (frontWorkerID) REFERENCES FrontWorkers (frontWorkerID),
    CONSTRAINT fk_2
        FOREIGN KEY (customerID) REFERENCES Customers (customerID),
    CONSTRAINT fk_3
        FOREIGN KEY (tableTypeID) REFERENCES TableTypes (tableTypeID)
);

CREATE TABLE BackStations (
	backStationID int PRIMARY KEY AUTO_INCREMENT,
	stationName varchar(255)
);

CREATE TABLE BackWorkers (
	backWorkerID int PRIMARY KEY AUTO_INCREMENT,
	firstName varchar(255) NOT NULL,
	lastName varchar(255) NOT NULL,
	backStationID int NOT NULL,
	dateHired date NOT NULL,
	salary double NOT NULL,
	CONSTRAINT fk_4
        FOREIGN KEY (backStationID) REFERENCES BackStations (backStationID)
);

CREATE TABLE FoodTypes (
	foodTypeID int PRIMARY KEY AUTO_INCREMENT,
	typeName varchar(255) NOT NULL
);

CREATE TABLE FoodItems (
	foodItemID int PRIMARY KEY AUTO_INCREMENT,
	foodTypeID int NOT NULL,
	itemName varchar(255) NOT NULL,
	itemPrice double NOT NULL,
	CONSTRAINT fk_5
        FOREIGN KEY (foodTypeID) REFERENCES FoodTypes (foodTypeID)
);

CREATE TABLE Ingredients (
    ingredientID int PRIMARY KEY AUTO_INCREMENT,
    ingredientName varchar(255) NOT NULL,
    expirationDate date -- some ingredients don't expire
);

CREATE TABLE ItemTags (
    tagID int PRIMARY KEY AUTO_INCREMENT,
    tagName varchar(255) NOT NULL -- gluten free, vegan, spicy, etc.
);

CREATE TABLE FoodTags (
    foodItemID int NOT NULL,
    tagID int NOT NULL,
    PRIMARY KEY (foodItemID, tagID),
    CONSTRAINT fk_6
        FOREIGN KEY (foodItemID) REFERENCES FoodItems (foodItemID),
    CONSTRAINT fk_7
        FOREIGN KEY (tagID) REFERENCES ItemTags (tagID)
);

CREATE TABLE IngredientTags (
    ingredientID int NOT NULL,
    tagID int NOT NULL,
    PRIMARY KEY (ingredientID, tagID),
    CONSTRAINT fk_8
        FOREIGN KEY (ingredientID) REFERENCES Ingredients (ingredientID),
    CONSTRAINT fk_9
        FOREIGN KEY (tagID) REFERENCES ItemTags (tagID)
);

CREATE TABLE FoodIngredients (
    foodItemID int NOT NULL,
    ingredientID int NOT NULL,
    quantity int NOT NULL,
    PRIMARY KEY (foodItemID, ingredientID),
    CONSTRAINT fk_10
        FOREIGN KEY (foodItemID) REFERENCES FoodItems (foodItemID),
    CONSTRAINT fk_11
        FOREIGN KEY (ingredientID) REFERENCES Ingredients (ingredientID)
);

CREATE TABLE Orders (
    orderID int PRIMARY KEY AUTO_INCREMENT,
    backWorkerID int, -- who fulfilled the order: null if still waiting to be made
    tableID int NOT NULL,
	foodItemID int NOT NULL,
	quantityOrdered int NOT NULL,
    timeOrdered datetime NOT NULL DEFAULT (UTC_TIMESTAMP),
    CONSTRAINT fk_12
        FOREIGN KEY (backWorkerID) REFERENCES BackWorkers (backWorkerID),
    CONSTRAINT fk_13
        FOREIGN KEY (foodItemID) REFERENCES FoodItems (foodItemID),
    CONSTRAINT fk_14
        FOREIGN KEY (tableID) REFERENCES Tables (tableID)
);

CREATE TABLE Payments (
	sequenceNum int AUTO_INCREMENT,
	frontWorkerID int NOT NULL,
	customerID int NOT NULL,
	amount double NOT NULL,
	tip double NOT NULL,
	paymentMethod varchar(255) NOT NULL,
    timePaid datetime NOT NULL DEFAULT (UTC_TIMESTAMP),
    PRIMARY KEY (sequenceNum, customerID),
    CONSTRAINT fk_15
        FOREIGN KEY (frontWorkerID) REFERENCES FrontWorkers (frontWorkerID),
    CONSTRAINT fk_16
        FOREIGN KEY (customerID) REFERENCES Customers (customerID)
);

CREATE TABLE Waitlist (
    customerID int PRIMARY KEY,
    phoneNumber varchar(32), -- customer may not want to leave phone number
    firstName varchar(255) NOT NULL,
    lastName varchar(255), -- last name usually unnecessary
    joinTime datetime NOT NULL DEFAULT (UTC_TIMESTAMP),
    exitTime datetime,
    CONSTRAINT fk_17
        FOREIGN KEY (customerID) REFERENCES Customers (customerID)
);

CREATE TABLE FrontSchedule (
    frontWorkerID int NOT NULL,
    startTime datetime NOT NULL,
    endTime datetime NOT NULL,
    breakLength int NOT NULL, -- how long in minutes
    PRIMARY KEY (frontWorkerID, startTime),
    CONSTRAINT fk_18
        FOREIGN KEY (frontWorkerID) REFERENCES FrontWorkers (frontWorkerID)
);

CREATE TABLE BackSchedule (
    backWorkerID int NOT NULL,
    startTime datetime NOT NULL,
    endTime datetime NOT NULL,
    breakLength int NOT NULL, -- how long in minutes
    PRIMARY KEY (backWorkerID, startTime),
    CONSTRAINT fk_19
        FOREIGN KEY (backWorkerID) REFERENCES BackWorkers (backWorkerID)
);

CREATE TABLE Specialties (
    backWorkerID int NOT NULL,
    foodItemID int NOT NULL,
    PRIMARY KEY (backWorkerID, foodItemID),
    CONSTRAINT fk_20
        FOREIGN KEY (backWorkerID) REFERENCES BackWorkers (backWorkerID),
    CONSTRAINT fk_21
        FOREIGN KEY (foodItemID) REFERENCES FoodItems (foodItemID)
);

-- dummy customers
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (1, 8, '2022-01-27 19:58:46', '2022-01-27 22:41:25');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (2, 1, '2022-09-26 14:37:25', '2022-09-26 15:41:47');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (3, 5, '2021-04-29 12:33:01', '2021-04-29 14:05:50');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (4, 7, '2022-11-12 17:46:41', '2022-11-12 18:38:36');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (5, 4, '2022-02-09 22:59:03', '2022-02-10 01:16:29');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (6, 1, '2021-11-20 19:46:07', '2021-11-20 20:29:30');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (7, 2, '2022-09-30 02:48:04', '2022-09-30 03:10:34');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (8, 8, '2021-03-29 02:27:43', '2021-03-29 04:08:47');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (9, 1, '2021-01-02 14:21:19', '2021-01-02 15:09:45');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (10, 8, '2021-04-25 03:16:00', '2021-04-25 04:02:56');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (11, 3, '2021-03-20 13:33:11', '2021-03-20 14:34:59');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (12, 7, '2022-07-21 00:24:07', '2022-07-21 02:30:46');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (13, 7, '2021-11-17 14:00:22', '2021-11-17 16:37:25');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (14, 7, '2022-07-10 03:12:29', '2022-07-10 05:25:20');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (15, 5, '2021-05-22 00:30:04', '2021-05-22 01:37:26');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (16, 1, '2021-09-14 23:37:17', '2021-09-15 01:02:36');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (17, 5, '2021-04-29 16:07:35', '2021-04-29 18:14:00');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (18, 5, '2021-07-03 12:36:51', '2021-07-03 13:42:45');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (19, 1, '2021-08-18 03:22:21', '2021-08-18 05:42:08');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (20, 1, '2022-08-14 20:29:19', '2022-08-14 22:48:49');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (21, 6, '2022-07-02 15:12:42', '2022-07-02 15:45:06');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (22, 7, '2021-05-23 02:03:09', '2021-05-23 03:59:31');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (23, 8, '2022-02-15 12:50:36', '2022-02-15 14:15:30');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (24, 4, '2021-08-20 10:35:53', '2021-08-20 13:32:55');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (25, 3, '2022-11-13 22:47:18', '2022-11-13 23:59:25');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (26, 4, '2022-04-11 18:31:21', '2022-04-11 19:24:25');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (27, 8, '2020-12-24 20:06:47', '2020-12-24 21:57:58');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (28, 8, '2022-08-23 13:56:26', '2022-08-23 15:22:36');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (29, 5, '2020-11-09 18:55:11', '2020-11-09 20:28:39');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (30, 1, '2021-03-07 18:20:06', '2021-03-07 19:13:05');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (31, 7, '2021-08-21 21:13:13', '2021-08-21 21:45:15');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (32, 6, '2022-06-29 02:47:57', '2022-06-29 03:22:32');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (33, 8, '2022-05-29 21:36:33', '2022-05-29 21:57:31');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (34, 3, '2022-07-19 23:27:27', '2022-07-20 00:28:54');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (35, 8, '2022-10-17 23:08:43', '2022-10-18 00:16:11');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (36, 2, '2022-09-24 14:23:51', '2022-09-24 14:56:22');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (37, 3, '2020-08-15 12:31:22', '2020-08-15 13:41:41');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (38, 5, '2020-12-27 18:09:16', '2020-12-27 19:19:58');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (39, 5, '2021-06-12 10:58:43', '2021-06-12 13:38:48');
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (40, 3, '2021-06-05 01:30:01', null);
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (41, 1, '2022-03-19 15:33:23', null);
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (42, 4, '2020-11-18 20:21:55', null);
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (43, 7, '2021-09-03 16:06:52', null);
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (44, 2, '2021-01-07 07:45:34', null);
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (45, 8, '2022-03-23 16:37:14', null);
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (46, 8, '2022-12-8 19:20:51', null);
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (47, 5, null, null);
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (48, 5, null, null);
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (49, 4, null, null);
insert into Customers (customerID, groupSize, seatingTime, departureTime) values (50, 1, null, null);

-- dummy table types
insert into TableTypes (tableTypeID, typeName) values (1, 'Booth');
insert into TableTypes (tableTypeID, typeName) values (2, 'Window');
insert into TableTypes (tableTypeID, typeName) values (3, 'Lazy Susan');
insert into TableTypes (tableTypeID, typeName) values (4, 'Bar');
insert into TableTypes (tableTypeID, typeName) values (5, 'Outdoor');

-- dummy front worker stations
insert into FrontStations (frontStationID, stationName) values (1, 'Host');
insert into FrontStations (frontStationID, stationName) values (2, 'Server');
insert into FrontStations (frontStationID, stationName) values (3, 'Sommelier');

-- dummy front workers
insert into FrontWorkers (frontWorkerID, firstName, lastName, frontStationID, dateHired, salary) values (1, 'Angel', 'Makepeace', 1, '2022-04-26', 15.26);
insert into FrontWorkers (frontWorkerID, firstName, lastName, frontStationID, dateHired, salary) values (2, 'Godfry', 'Cunnow', 3, '2021-11-14', 14.42);
insert into FrontWorkers (frontWorkerID, firstName, lastName, frontStationID, dateHired, salary) values (3, 'Ciel', 'Megany', 2, '2022-11-06', 24.93);
insert into FrontWorkers (frontWorkerID, firstName, lastName, frontStationID, dateHired, salary) values (4, 'Stevana', 'Manwaring', 3, '2022-06-29', 25.42);
insert into FrontWorkers (frontWorkerID, firstName, lastName, frontStationID, dateHired, salary) values (5, 'Davis', 'Faircloth', 1, '2022-07-29', 22.25);

-- dummy tables
insert into Tables (tableID, frontWorkerID, customerID, capacity, tableTypeID) values (1, 3, 40, 6, 1);
insert into Tables (tableID, frontWorkerID, customerID, capacity, tableTypeID) values (2, 3, 41, 3, 1);
insert into Tables (tableID, frontWorkerID, customerID, capacity, tableTypeID) values (3, 5, 42, 2, 2);
insert into Tables (tableID, frontWorkerID, customerID, capacity, tableTypeID) values (4, null, null, 6, 5);
insert into Tables (tableID, frontWorkerID, customerID, capacity, tableTypeID) values (5, 3, 43, 7, 4);
insert into Tables (tableID, frontWorkerID, customerID, capacity, tableTypeID) values (6, null, null, 2, 3);
insert into Tables (tableID, frontWorkerID, customerID, capacity, tableTypeID) values (7, null, null, 1, 2);
insert into Tables (tableID, frontWorkerID, customerID, capacity, tableTypeID) values (8, 3, 44, 5, 2);
insert into Tables (tableID, frontWorkerID, customerID, capacity, tableTypeID) values (9, 2, 45, 6, 2);
insert into Tables (tableID, frontWorkerID, customerID, capacity, tableTypeID) values (10, 1, 46, 2, 5);

-- dummy back worker stations
insert into BackStations (backStationID, stationName) values (1, 'Line Cook');
insert into BackStations (backStationID, stationName) values (2, 'Head Chef');
insert into BackStations (backStationID, stationName) values (3, 'Sous Chef');

-- dummy back workers
insert into BackWorkers (backWorkerID, firstName, lastName, backStationID, dateHired, salary) values (1, 'Nicko', 'Finnan', 2, '2022-07-15', 19.99);
insert into BackWorkers (backWorkerID, firstName, lastName, backStationID, dateHired, salary) values (2, 'Caty', 'Goodyer', 1, '2022-10-19', 17.27);
insert into BackWorkers (backWorkerID, firstName, lastName, backStationID, dateHired, salary) values (3, 'Brion', 'Stoyles', 3, '2022-04-09', 24.52);
insert into BackWorkers (backWorkerID, firstName, lastName, backStationID, dateHired, salary) values (4, 'Layton', 'Boar', 2, '2022-05-20', 16.82);
insert into BackWorkers (backWorkerID, firstName, lastName, backStationID, dateHired, salary) values (5, 'Nicholas', 'McBeath', 3, '2022-01-29', 24.61);

-- dummy food types
insert into FoodTypes (foodTypeID, typeName) values (1, 'Appetizer');
insert into FoodTypes (foodTypeID, typeName) values (2, 'Soup');
insert into FoodTypes (foodTypeID, typeName) values (3, 'Salad');
insert into FoodTypes (foodTypeID, typeName) values (4, 'Entree');
insert into FoodTypes (foodTypeID, typeName) values (5, 'Side');
insert into FoodTypes (foodTypeID, typeName) values (6, 'Dessert');

-- dummy food items
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (1, 4, 'Chicken Quesadilla', 18.04);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (2, 1, 'Boneless Wings', 10.09);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (3, 4, 'Chicken Fingers', 14.96);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (4, 4, 'Macaroni & Cheese', 27.42);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (5, 5, 'Fried Pickles', 14.04);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (6, 5, 'French Fries', 20.54);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (7, 2, 'Clam Chowder', 14.21);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (8, 3, 'Caesar Salad', 20.13);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (9, 1, 'Calamari', 13.19);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (10, 6, 'Cheesecake', 23.18);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (11, 6, 'Chocolate Pudding', 18.25);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (12, 6, 'Apple Pie', 16.2);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (13, 2, 'French Onion Soup', 13.18);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (14, 5, 'Soft Pretzels', 12.26);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (15, 3, 'Cucumber Salad', 15.62);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (16, 5, 'Chips & Salsa', 13.82);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (17, 4, 'BBQ Ribs', 12.76);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (18, 4, 'Fried Rice', 16.34);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (19, 1, 'Avocado Toast', 9.66);
insert into FoodItems (foodItemID, foodTypeID, itemName, itemPrice) values (20, 6, 'Lemon Squares', 23.82);

-- dummy ingredients
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (1, 'Meatballs', '2022-11-26');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (2, 'Anchovies', '2022-11-07');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (3, 'Garlic', '2022-11-16');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (4, 'Drumstick', '2022-10-28');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (5, 'Pheasant', '2022-10-29');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (6, 'Mortadella', '2022-11-09');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (7, 'Eggplant', '2022-11-24');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (8, 'Olives', '2022-10-25');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (9, 'Naan', '2022-11-05');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (10, 'Blueberries', '2022-11-02');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (11, 'Butter', '2022-11-12');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (12, 'Nuts', '2022-11-14');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (13, 'Lettuce', '2022-11-22');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (14, 'Marmalade', '2022-11-09');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (15, 'Chocolate Chips', '2022-11-19');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (16, 'Papaya', '2022-10-15');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (17, 'Onions', '2022-10-17');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (18, 'Custard', '2022-11-26');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (19, 'Salmon', '2022-11-25');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (20, 'Milk', '2022-11-20');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (21, 'Eggs', '2022-11-01');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (22, 'Flour', '2022-10-21');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (23, 'Chips', '2022-10-13');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (24, 'Potato', '2022-10-31');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (25, 'Applesauce', '2022-10-16');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (26, 'Cereal', '2022-11-12');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (27, 'Paprika', '2022-10-19');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (28, 'Peppers', '2022-10-25');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (29, 'Clam', '2022-11-20');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (30, 'Marmalade', '2022-11-02');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (31, 'Citronella', '2022-10-20');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (32, 'Persimmons', '2022-11-20');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (33, 'Cream', '2022-10-16');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (34, 'Pokeberry', '2022-11-05');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (35, 'Soybeans', '2022-11-28');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (36, 'Soy Sauce', '2022-12-04');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (37, 'Gelatin', '2022-11-08');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (38, 'Steak', '2022-11-14');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (39, 'Grain', '2022-12-01');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (40, 'Kiwano', '2022-10-26');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (41, 'Rambutan', '2022-11-05');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (42, 'Noodles', '2022-12-01');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (43, 'Rojos', '2022-11-23');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (44, 'Broccoli', '2022-10-18');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (45, 'Ice', '2022-10-13');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (46, 'Ground Beef', '2022-11-19');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (47, 'Roots', '2022-11-22');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (48, 'Sausage', '2022-11-10');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (49, 'Avocados', '2022-10-15');
insert into Ingredients (ingredientID, ingredientName, expirationDate) values (50, 'Cucumbers', '2022-11-26');

-- dummy tags
insert into ItemTags (tagID, tagName) values (1, 'Gluten Free');
insert into ItemTags (tagID, tagName) values (2, 'Contains Tree Nuts');
insert into ItemTags (tagID, tagName) values (3, 'Contains Shellfish');
insert into ItemTags (tagID, tagName) values (4, 'Spicy');
insert into ItemTags (tagID, tagName) values (5, 'Vegan');
insert into ItemTags (tagID, tagName) values (6, 'Vegetarian');

-- dummy food-tag relationships
insert into FoodTags (foodItemID, tagID) values (20, 5);
insert into FoodTags (foodItemID, tagID) values (2, 6);
insert into FoodTags (foodItemID, tagID) values (5, 2);
insert into FoodTags (foodItemID, tagID) values (3, 2);
insert into FoodTags (foodItemID, tagID) values (2, 2);
insert into FoodTags (foodItemID, tagID) values (18, 4);
insert into FoodTags (foodItemID, tagID) values (19, 3);
insert into FoodTags (foodItemID, tagID) values (14, 5);
insert into FoodTags (foodItemID, tagID) values (15, 2);
insert into FoodTags (foodItemID, tagID) values (20, 2);
insert into FoodTags (foodItemID, tagID) values (18, 2);
insert into FoodTags (foodItemID, tagID) values (9, 6);
insert into FoodTags (foodItemID, tagID) values (11, 5);
insert into FoodTags (foodItemID, tagID) values (13, 6);
insert into FoodTags (foodItemID, tagID) values (19, 4);
insert into FoodTags (foodItemID, tagID) values (4, 3);
insert into FoodTags (foodItemID, tagID) values (1, 5);
insert into FoodTags (foodItemID, tagID) values (5, 5);
insert into FoodTags (foodItemID, tagID) values (8, 6);
insert into FoodTags (foodItemID, tagID) values (6, 1);
insert into FoodTags (foodItemID, tagID) values (2, 4);
insert into FoodTags (foodItemID, tagID) values (3, 1);
insert into FoodTags (foodItemID, tagID) values (4, 2);
insert into FoodTags (foodItemID, tagID) values (12, 6);
insert into FoodTags (foodItemID, tagID) values (18, 5);
insert into FoodTags (foodItemID, tagID) values (2, 3);
insert into FoodTags (foodItemID, tagID) values (5, 1);
insert into FoodTags (foodItemID, tagID) values (16, 6);
insert into FoodTags (foodItemID, tagID) values (18, 6);
insert into FoodTags (foodItemID, tagID) values (16, 5);

-- dummy ingredient-tag relationships
insert into IngredientTags (ingredientID, tagID) values (18, 3);
insert into IngredientTags (ingredientID, tagID) values (32, 2);
insert into IngredientTags (ingredientID, tagID) values (49, 5);
insert into IngredientTags (ingredientID, tagID) values (33, 6);
insert into IngredientTags (ingredientID, tagID) values (44, 2);
insert into IngredientTags (ingredientID, tagID) values (50, 3);
insert into IngredientTags (ingredientID, tagID) values (26, 3);
insert into IngredientTags (ingredientID, tagID) values (29, 2);
insert into IngredientTags (ingredientID, tagID) values (41, 3);
insert into IngredientTags (ingredientID, tagID) values (31, 5);
insert into IngredientTags (ingredientID, tagID) values (16, 3);
insert into IngredientTags (ingredientID, tagID) values (26, 5);
insert into IngredientTags (ingredientID, tagID) values (15, 6);
insert into IngredientTags (ingredientID, tagID) values (38, 2);
insert into IngredientTags (ingredientID, tagID) values (32, 1);
insert into IngredientTags (ingredientID, tagID) values (25, 2);
insert into IngredientTags (ingredientID, tagID) values (22, 3);
insert into IngredientTags (ingredientID, tagID) values (42, 5);
insert into IngredientTags (ingredientID, tagID) values (16, 5);
insert into IngredientTags (ingredientID, tagID) values (28, 5);
insert into IngredientTags (ingredientID, tagID) values (30, 2);
insert into IngredientTags (ingredientID, tagID) values (43, 2);
insert into IngredientTags (ingredientID, tagID) values (23, 6);
insert into IngredientTags (ingredientID, tagID) values (40, 6);
insert into IngredientTags (ingredientID, tagID) values (6, 3);
insert into IngredientTags (ingredientID, tagID) values (37, 5);
insert into IngredientTags (ingredientID, tagID) values (50, 6);
insert into IngredientTags (ingredientID, tagID) values (19, 4);
insert into IngredientTags (ingredientID, tagID) values (8, 6);
insert into IngredientTags (ingredientID, tagID) values (30, 6);

-- dummy food-ingredient relationships
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (3, 21, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (15, 37, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (10, 28, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (1, 21, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (3, 35, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (3, 2, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (11, 41, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (2, 38, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (20, 4, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (4, 44, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (9, 5, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (3, 23, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (13, 14, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (4, 10, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (16, 35, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (9, 30, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (16, 27, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (9, 23, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (13, 9, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (14, 34, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (12, 42, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (10, 24, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (12, 26, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (7, 11, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (7, 49, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (7, 3, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (14, 1, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (5, 3, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (3, 45, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (19, 13, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (12, 15, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (17, 21, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (8, 41, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (13, 29, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (9, 34, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (11, 47, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (19, 6, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (20, 38, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (9, 4, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (20, 36, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (10, 22, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (19, 8, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (17, 9, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (2, 22, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (16, 12, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (1, 24, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (7, 33, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (1, 49, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (18, 2, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (5, 32, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (1, 8, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (13, 16, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (20, 37, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (19, 14, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (18, 3, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (9, 29, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (4, 35, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (15, 13, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (10, 4, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (17, 25, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (3, 9, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (13, 37, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (2, 36, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (16, 13, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (4, 36, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (12, 7, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (16, 4, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (17, 31, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (6, 44, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (20, 14, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (5, 44, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (8, 11, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (2, 24, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (17, 40, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (6, 11, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (6, 39, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (11, 3, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (16, 31, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (16, 39, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (13, 25, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (11, 25, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (1, 33, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (6, 2, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (17, 1, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (14, 38, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (16, 2, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (19, 11, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (11, 32, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (19, 21, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (1, 9, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (16, 5, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (11, 49, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (3, 34, 4);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (19, 3, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (10, 17, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (2, 8, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (6, 27, 2);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (1, 18, 1);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (14, 45, 3);
insert into FoodIngredients (foodItemID, ingredientID, quantity) values (3, 28, 2);

-- dummy orders
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 2, 1, 3, '2021-03-12 02:03:11');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 1, 17, 5, '2021-06-29 14:18:56');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 2, 20, 4, '2021-09-13 18:11:56');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 6, 6, 1, '2022-06-29 15:54:49');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 9, 3, 5, '2022-09-19 10:38:58');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 9, 20, 4, '2021-06-15 13:54:17');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 4, 16, 4, '2022-02-09 12:41:16');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 10, 17, 3, '2022-01-29 23:42:26');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 9, 16, 5, '2021-11-08 10:07:40');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 1, 7, 3, '2021-12-23 18:39:02');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 6, 14, 4, '2022-03-25 11:37:00');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 6, 9, 2, '2021-03-19 16:55:31');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 3, 12, 5, '2022-05-09 23:14:53');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 2, 1, 4, '2022-06-21 14:47:36');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 7, 11, 1, '2022-04-25 21:37:19');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 4, 5, 4, '2022-01-18 06:23:58');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 8, 4, 4, '2022-05-21 01:47:14');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 9, 1, 2, '2022-06-13 23:13:58');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 10, 15, 2, '2021-11-11 06:14:51');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 3, 19, 3, '2021-05-14 23:23:50');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 2, 9, 4, '2022-07-05 18:27:33');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 4, 7, 4, '2022-07-20 17:46:06');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 4, 12, 4, '2021-06-05 22:04:13');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 6, 14, 2, '2022-05-27 10:28:47');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 9, 3, 2, '2022-04-08 00:54:26');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 7, 1, 3, '2022-09-09 22:35:49');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 6, 6, 2, '2022-01-29 01:01:58');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 4, 12, 5, '2021-07-11 18:53:52');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 7, 5, 3, '2021-10-25 08:15:50');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 7, 18, 4, '2022-07-11 18:32:31');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 10, 8, 3, '2022-09-30 01:23:33');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 7, 19, 3, '2021-03-23 00:38:06');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 6, 17, 2, '2022-01-11 07:41:17');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 1, 4, 3, '2022-01-03 18:24:46');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 2, 13, 4, '2022-06-06 14:24:03');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 9, 16, 1, '2022-10-22 11:25:31');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 7, 19, 1, '2021-06-01 05:55:25');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 7, 13, 1, '2020-12-25 11:04:54');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 2, 15, 5, '2021-10-25 13:32:35');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 1, 13, 4, '2022-01-31 01:43:42');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 6, 13, 2, '2022-01-23 05:19:03');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 6, 9, 4, '2021-07-18 22:18:24');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 1, 5, 1, '2021-11-26 19:47:10');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 9, 18, 4, '2022-06-24 16:12:35');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 5, 17, 3, '2022-06-05 08:59:11');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 1, 4, 5, '2021-01-13 23:24:00');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 4, 14, 5, '2021-06-07 22:20:31');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 10, 7, 4, '2021-07-15 02:20:59');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 8, 5, 2, '2022-03-28 09:07:15');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 10, 18, 2, '2021-12-23 10:37:48');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 10, 5, 1, '2022-10-27 16:43:35');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 1, 16, 3, '2021-04-01 19:55:23');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 9, 6, 4, '2021-09-05 19:01:56');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 3, 19, 5, '2021-11-29 10:45:24');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 5, 1, 2, '2021-02-23 16:07:58');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 6, 13, 4, '2022-08-27 01:22:16');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 9, 16, 4, '2022-11-03 16:15:40');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 3, 1, 1, '2020-12-30 16:15:06');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 3, 2, 4, '2021-05-21 10:42:47');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 3, 12, 5, '2021-01-10 10:49:42');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 1, 17, 2, '2022-05-19 17:49:28');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 3, 5, 2, '2022-03-06 03:01:55');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 6, 20, 2, '2022-01-21 19:23:29');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 1, 1, 2, '2021-09-26 21:40:52');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 1, 9, 4, '2022-02-18 18:29:41');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 5, 15, 1, '2021-09-04 11:20:51');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 5, 8, 2, '2021-09-16 00:28:12');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 7, 6, 1, '2021-01-02 18:18:57');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 9, 3, 4, '2021-02-04 15:51:56');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 9, 12, 3, '2021-06-15 15:42:46');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 3, 9, 4, '2021-01-25 15:16:55');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 4, 2, 1, '2022-11-04 15:49:15');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 9, 1, 5, '2021-04-01 13:21:22');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 3, 10, 2, '2022-08-11 12:22:22');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 4, 6, 2, '2021-07-12 10:39:08');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 6, 8, 5, '2021-12-29 10:19:18');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 6, 18, 5, '2022-08-14 19:09:58');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 1, 16, 4, '2021-08-12 07:57:44');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 8, 18, 5, '2022-04-01 08:54:35');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 9, 2, 1, '2021-09-19 18:25:25');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (4, 10, 9, 4, '2022-04-03 02:38:48');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 6, 4, 4, '2021-08-11 20:21:33');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 6, 10, 2, '2021-04-25 21:26:13');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 4, 12, 2, '2022-01-11 22:58:50');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 8, 7, 3, '2022-09-13 16:42:50');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 10, 13, 4, '2022-11-06 03:59:03');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (2, 2, 12, 3, '2021-04-14 23:24:21');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 4, 10, 2, '2021-07-23 15:55:18');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 7, 4, 2, '2021-08-11 01:14:35');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (1, 8, 14, 5, '2022-07-04 09:49:10');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (3, 9, 3, 1, '2021-08-01 19:31:57');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 9, 20, 1, '2022-06-26 03:04:36');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (5, 2, 18, 3, '2021-06-02 02:23:39');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (null, 5, 19, 3, '2021-04-16 06:30:09');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (null, 7, 4, 1, '2021-03-24 01:42:38');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (null, 1, 20, 5, '2022-05-28 16:05:57');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (null, 2, 3, 3, '2022-01-03 05:34:36');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (null, 5, 9, 2, '2021-03-13 22:26:42');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (null, 5, 6, 1, '2021-01-16 10:25:48');
insert into Orders (backWorkerID, tableID, foodItemID, quantityOrdered, timeOrdered) values (null, 1, 16, 5, '2021-05-04 22:45:46');

-- dummy payments
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (1, 3, 2, 67.03, 5.41, 'Visa ending with 7783', '2022-10-17 12:21:30');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (2, 1, 2, 66.94, 3.82, 'Mastercard ending with 3292', '2022-02-06 08:53:57');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (3, 3, 2, 34.6, 1.64, 'Mastercard ending with 4088', '2022-08-08 14:24:53');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (1, 4, 4, 68.99, 6.2, 'Amex ending with 6680', '2022-09-04 00:49:08');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (2, 1, 4, 71.57, 5.44, 'Visa ending with 3164', '2022-03-11 16:03:02');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (3, 5, 4, 44.98, 7.32, 'Amex ending with 2888', '2022-02-04 14:32:57');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (1, 5, 3, 63.92, 3.92, 'Cash', '2022-04-27 16:00:16');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (2, 5, 3, 37.03, 9.91, 'Amex', '2022-01-07 00:15:27');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (1, 2, 6, 35.25, 5.69, 'Visa ending with 8430', '2022-04-07 04:58:44');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (1, 3, 7, 34.37, 2.16, 'Discover ending with 6647', '2021-12-01 00:10:19');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (2, 2, 7, 41.04, 1.6, 'Mastercard ending with 4265', '2022-01-04 15:51:49');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (1, 3, 5, 33.87, 4.56, 'Visa ending with 0346', '2022-11-08 02:19:04');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (2, 5, 5, 41.44, 7.63, 'Cash', '2022-07-09 05:19:14');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (3, 4, 5, 61.17, 9.36, 'Discover ending with 5880', '2021-11-28 03:36:57');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (1, 2, 1, 70.93, 6.82, 'Discover ending with 9569', '2022-05-16 07:32:42');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (1, 4, 8, 41.49, 9.76, 'Discover ending with 9511', '2021-12-20 11:14:51');
insert into Payments (sequenceNum, frontWorkerID, customerID, amount, tip, paymentMethod, timePaid) values (2, 5, 8, 53.04, 4.89, 'Amex ending with 9303', '2022-10-23 12:01:35');

-- dummy waitlist entries
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (1, '+57 (673) 897-7485', 'Meg', null, '2022-01-30 13:39:54', '2022-01-30 16:26:37');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (2, '+82 (990) 339-8286', 'Samson', null, '2022-08-03 08:34:57', '2022-08-03 11:15:37');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (3, '+92 (913) 543-0655', 'Eddi', 'Manby', '2021-09-09 01:53:27', '2021-09-09 04:23:59');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (4, null, 'Anett', 'Larway', '2021-10-19 05:01:07', '2021-10-19 06:18:22');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (5, null, 'Kerry', null, '2022-09-30 07:53:01', '2022-09-30 09:23:12');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (6, '+1 (916) 416-9885', 'Odo', null, '2020-12-31 05:41:21', '2020-12-31 06:02:42');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (7, '+1 (282) 705-9236', 'Darlleen', 'Ferrieri', '2020-12-13 12:13:41', '2020-12-13 13:15:30');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (8, '+351 (463) 995-6682', 'Gaspar', null, '2021-05-01 20:41:45', '2021-05-01 21:18:50');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (9, '+47 (549) 467-3816', 'Rodi', null, '2020-12-18 23:34:50', '2020-12-19 00:27:29');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (10, '+27 (250) 429-9912', 'Analise', 'Keat', '2020-12-14 22:50:13', '2020-12-15 00:54:30');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (11, null, 'Adah', null, '2021-03-30 05:47:03', '2021-03-30 07:01:20');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (12, '+51 (227) 742-4982', 'Oralia', 'Everest', '2021-05-29 14:16:22', '2021-05-29 17:03:12');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (13, '+86 (187) 204-6540', 'Briana', 'Farens', '2021-12-04 07:29:07', '2021-12-04 09:05:54');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (14, '+46 (333) 902-3549', 'Conan', 'Stallibrass', '2021-09-16 05:45:03', '2021-09-16 07:44:16');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (15, '+375 (832) 803-6363', 'Jasen', 'Bedson', '2021-02-18 02:49:34', '2021-02-18 04:36:32');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (16, null, 'Boy', 'Domb', '2021-06-09 11:53:43', '2021-06-09 14:13:25');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (17, null, 'Mable', 'Milbourn', '2021-08-26 21:10:14', '2021-08-27 00:09:17');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (18, '+420 (501) 741-5256', 'Betti', null, '2022-09-24 16:08:32', '2022-09-24 16:52:37');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (19, '+7 (941) 268-2328', 'Clarissa', 'Marie', '2022-06-17 02:40:59', '2022-06-17 05:01:53');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (20, '+502 (582) 357-5703', 'Ingrim', null, '2021-01-15 09:55:18', '2021-01-15 11:19:58');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (21, null, 'Ellswerth', 'Chinery', '2021-10-07 12:50:11', '2021-10-07 13:18:45');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (22, '+86 (953) 741-8124', 'Gavrielle', null, '2021-12-26 10:29:45', '2021-12-26 12:34:22');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (23, '+33 (589) 134-2493', 'Skelly', null, '2021-01-09 13:27:46', '2021-01-09 14:20:21');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (24, '+62 (866) 537-4792', 'Lilla', null, '2022-11-19 10:54:39', '2022-11-19 12:50:23');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (25, null, 'Jackie', 'Dodell', '2022-11-17 04:10:32', '2022-11-17 05:52:51');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (26, '+33 (456) 309-0865', 'Adelle', 'Batterson', '2022-05-03 22:57:51', '2022-05-04 01:02:54');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (27, null, 'Allyn', null, '2021-10-10 21:48:32', '2021-10-11 00:42:01');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (28, null, 'Ara', 'Robley', '2022-02-15 08:34:46', '2022-02-15 09:24:07');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (29, '+63 (502) 257-6820', 'Garnet', 'Lacroutz', '2022-10-15 14:48:35', '2022-10-15 15:08:18');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (30, '+351 (749) 362-5406', 'Marisa', null, '2021-02-06 03:03:36', '2021-02-06 04:33:04');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (31, '+55 (429) 747-1080', 'Rozelle', 'Rimour', '2020-12-21 17:14:52', '2020-12-21 19:25:46');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (32, null, 'Cissiee', null, '2022-06-09 22:16:04', '2022-06-09 23:40:22');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (33, '+1 (346) 606-2117', 'Herrick', null, '2021-03-02 22:07:19', '2021-03-03 00:40:28');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (34, '+86 (925) 174-4583', 'Royce', null, '2022-07-29 15:44:12', '2022-07-29 17:51:33');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (35, null, 'Olia', null, '2022-09-20 02:21:12', '2022-09-20 03:53:53');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (36, '+374 (856) 450-0194', 'Robena', null, '2022-01-15 05:24:30', '2022-01-15 07:31:25');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (37, '+48 (955) 613-0797', 'Cosme', null, '2022-05-18 23:25:12', '2022-05-19 01:03:15');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (38, null, 'Maggy', 'Faull', '2020-12-20 16:53:18', '2020-12-20 18:58:05');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (39, null, 'Kelly', null, '2021-01-19 12:51:54', '2021-01-19 15:30:53');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (40, '+86 (394) 226-2805', 'Link', null, '2021-10-17 11:22:42', '2021-10-17 12:09:27');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (41, null, 'Allyce', null, '2022-08-22 05:47:33', '2022-08-22 07:11:26');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (42, '+7 (428) 964-8090', 'Cole', null, '2022-10-07 04:33:06', '2022-10-07 05:59:00');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (43, '+1 (744) 414-1975', 'Dilly', null, '2021-09-29 22:31:02', '2021-09-29 23:56:18');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (44, '+86 (667) 567-1966', 'Gibby', 'Atter', '2020-12-20 02:13:55', '2020-12-20 03:28:50');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (45, null, 'Paxon', null, '2022-07-06 12:00:19', '2022-07-06 14:32:43');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (46, '+359 (516) 505-0430', 'Lonnie', null, '2021-11-04 14:17:15', '2021-11-04 15:18:52');
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (47, '+55 (521) 816-5696', 'Desirae', null, '2022-08-30 11:18:18', null);
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (48, '+86 (867) 253-3870', 'Stanislaw', 'Duckering', '2021-03-05 21:36:49', null);
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (49, '+1 (973) 705-8059', 'Nelly', 'Bent', '2022-03-17 12:54:30', null);
insert into Waitlist (customerID, phoneNumber, firstName, lastName, joinTime, exitTime) values (50, null, 'Gustaf', null, '2020-12-13 17:37:00', null);

-- dummy front worker shifts
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (5, '2022-04-10 12:33:47', '2022-04-10 18:33:47', 30);
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (4, '2022-07-18 06:44:21', '2022-07-18 13:44:21', 30);
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (4, '2022-06-08 15:23:13', '2022-06-08 20:23:13', 30);
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (5, '2022-03-09 04:28:21', '2022-03-09 04:28:21', 30);
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (4, '2022-05-30 20:53:23', '2022-05-31 01:53:23', 45);
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (2, '2022-03-18 19:18:07', '2022-03-19 02:18:07', 45);
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (5, '2022-05-21 00:51:46', '2022-05-21 08:51:46', 60);
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (4, '2022-01-19 09:38:29', '2022-01-19 09:38:29', 45);
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (3, '2022-11-07 16:06:14', '2022-11-07 18:06:14', 45);
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (1, '2022-04-30 04:45:45', '2022-04-30 06:45:45', 30);
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (5, '2022-01-05 01:31:14', '2022-01-05 08:31:14', 45);
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (5, '2022-06-19 11:15:11', '2022-06-19 16:15:11', 45);
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (4, '2022-05-09 09:39:06', '2022-05-09 09:39:06', 60);
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (3, '2022-04-24 17:36:10', '2022-04-24 23:36:10', 30);
insert into FrontSchedule (frontWorkerID, startTime, endTime, breakLength) values (4, '2022-03-30 06:23:05', '2022-03-30 07:23:05', 15);

-- dummy back worker shifts
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (5, '2022-04-03 06:43:24', '2022-04-03 06:43:24', 45);
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (3, '2022-01-06 11:30:07', '2022-01-06 16:30:07', 60);
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (5, '2022-09-24 15:53:06', '2022-09-24 19:53:06', 30);
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (5, '2022-06-01 16:35:30', '2022-06-01 18:35:30', 30);
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (2, '2022-09-21 18:33:17', '2022-09-22 01:33:17', 30);
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (1, '2022-01-13 19:33:15', '2022-01-13 23:33:15', 45);
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (2, '2022-06-19 19:03:57', '2022-06-19 22:03:57', 15);
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (1, '2022-09-06 11:33:56', '2022-09-06 17:33:56', 15);
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (5, '2022-11-14 01:33:03', '2022-11-14 01:33:03', 45);
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (4, '2022-01-05 00:43:26', '2022-01-05 00:43:26', 60);
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (3, '2022-03-21 14:31:49', '2022-03-21 18:31:49', 30);
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (4, '2022-11-05 06:16:08', '2022-11-05 10:16:08', 15);
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (5, '2022-06-08 22:07:53', '2022-06-09 06:07:53', 15);
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (5, '2022-05-30 13:48:04', '2022-05-30 16:48:04', 60);
insert into BackSchedule (backWorkerID, startTime, endTime, breakLength) values (3, '2022-10-26 16:42:38', '2022-10-26 23:42:38', 45);

-- dummy specialty dishes
insert into Specialties (backWorkerID, foodItemID) values (2, 1);
insert into Specialties (backWorkerID, foodItemID) values (1, 4);
insert into Specialties (backWorkerID, foodItemID) values (4, 3);
insert into Specialties (backWorkerID, foodItemID) values (3, 3);
insert into Specialties (backWorkerID, foodItemID) values (4, 2);