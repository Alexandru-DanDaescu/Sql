

CREATE TABLE Users (
	user_id SERIAL PRIMARY KEY,
	username VARCHAR(50) NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
	password VARCHAR(100) NOT NULL
);

CREATE TABLE Addresses (
	address_id SERIAL PRIMARY KEY,
	user_id INT REFERENCES Users(user_id),
	street_name VARCHAR(255) NOT NULL,
	city VARCHAR(50) NOT NULL,
	zip_code VARCHAR(10)
);


CREATE TABLE Messages(
	message_id SERIAL PRIMARY KEY,
	user_id INT REFERENCES Users(user_id),
	content TEXT,
	timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--1. Insert a new user into the Users table.
INSERT INTO Users (user_id, username, email, password) VALUES (1, 'randi','test@gmail.com', 123456);
INSERT INTO Users (user_id, username, email, password) VALUES (2, 'sammy','mad@gmail.com', 45627859);
INSERT INTO Users (user_id, username, email, password) VALUES (3, 'dev','dev@gmail.com', 458342);

--2. Retrieve all users from the Users table.
SELECT * FROM Users;

--3. Change a user's email in the Users table.
UPDATE Users SET email = 'changedemail@gmail.com' where user_id = 1;

--4. Delete a user from the Users table based on their username.
DELETE FROM Users WHERE username = 'sammy';

--5. Insert multiple records: Insert three more users into the Users table at once.

INSERT INTO Users (user_id, username, email, password)
VALUES (12,'aasmd', 'maa@yahoo.com', 764545),
       (13, 'eafdd', 'garan@gmail.com', 3443),
	   (14, 'asem', 'sers@yahoo.com', 35876),
	   (15, 'ded', 'tek@yahoo.com', 436512),
       (10, 'brad', 'meda@gmail.com', 11111),
	   (11, 'aaaa', 'deee@yahoo.com', 2222);

--6. Specific select: Retrieve only the usernames and emails of all users from the Users table.
SELECT username, email FROM Users;

--7. Conditional select: Retrieve users from the Users table who have email addresses ending with "@example.com".

SELECT email FROM Users WHERE email = 'sads@yahoo.com';

--8. Insert with reference: Insert an address for one of the users you added.
-- Make sure to link it to the user using the user_id field in the Addresses table.

INSERT INTO Addresses (address_id, user_id, street_name, city, zip_code) VALUES (1, 7, 'Street name', 'City name', '000000');
INSERT INTO Addresses (address_id, user_id, street_name, city, zip_code) VALUES (3, 10, 'Something', 'aaa', '111111');
INSERT INTO Addresses (address_id, user_id, street_name, city, zip_code) VALUES (9, 15, 'TestTest', 'Again', '234923');
INSERT INTO Addresses (address_id, user_id, street_name, city, zip_code) VALUES (6, 12, 'Agh', 'eh', '222222');



--9. Update with condition: Change all messages in the Messages table with the word "hello" in their content to "Hello World!".


INSERT INTO Messages (message_id, user_id, content, timestamp) VALUES (2, 6, 'hello', '2020-03-11');

UPDATE Messages SET content = 'Hello World!' WHERE message_id = 2;


--10. Delete with JOIN: Delete all addresses associated with users who have an email address ending with "@example.com".
--   (This one introduces them to using JOIN with DELETE).

DELETE FROM Adresses AS aa
USING users as uu
WHERE aa.user_id = uu.user_id AND uu.email like '@example.com';



--11. Aggregate function: Count the number of messages each user has sent and order the result by the number of messages in descending order.

INSERT INTO Messages (message_id, user_id, content, timestamp) VALUES (3, 7, 'Test', '2021-05-06');
INSERT INTO Messages (message_id, user_id, content, timestamp) VALUES (4, 8, 'Sandas', '2022-02-12');
INSERT INTO Messages (message_id, user_id, content, timestamp) VALUES (5, 7, 'No', '2023-05-06');
INSERT INTO Messages (message_id, user_id, content, timestamp) VALUES (6, 8, 'Yes', '2024-02-12');
INSERT INTO Messages (message_id, user_id, content, timestamp) VALUES (7, 1, 'Yes', '2025-02-12');

SELECT user_id, COUNT(user_id)
FROM Messages
GROUP BY  user_id
ORDER BY COUNT(user_id) DESC;


--12. Retrieve all messages along with the username of the person who sent them.

SELECT Users.username, Messages.content
FROM Users
JOIN Messages ON Users.user_id = Messages.user_id;

--13. Find all messages sent in the last 7 days.

SELECT * FROM Messages
WHERE timestamp > NOW() - INTERVAL '7 day';


--14. Find all users whose usernames start with 'john'.

SELECT username FROM Users WHERE username = 'as';

--15. Find the total number of users from each city using the Addresses table.

SELECT city, COUNT(user_id)
FROM Addresses
GROUP BY city
ORDER BY COUNT(user_id) DESC;

--16. Classify messages into 'Short' and 'Long' based on the length of their content (e.g., classify as 'Short' if the length is under 100 characters).

SELECT message_id, content,
CASE
    WHEN LENGTH(content) < 10 THEN 'Short'
	ELSE 'Long'
	END AS message_length
	FROM Messages;


--17. Retrieve the next 5 users starting from the third user in the Users table.

SELECT * FROM Users OFFSET 3 LIMIT 5;

--18. Retrieve all addresses sorted by city in ascending order and then by street_name in descending order.

SELECT * FROM Addresses
ORDER BY city asc, street_name desc;

--19. Find all unique cities from the Addresses table.
SELECT DISTINCT city
FROM Addresses;

--20. Find users whose usernames are 'john_doe', 'jane_doe', or 'sam_smith'.

SELECT * FROM Users 
WHERE username in ('as','randi','amd');

--21. Find users who have not sent any messages.

SELECT * FROM Users
LEFT JOIN Messages ON Users.user_id = Messages.user_id
WHERE Messages.message_id IS NULL;


--22. Retrieve all messages with both the username and the address (city) of the sender.

SELECT m.message_id, u.username, a.city, m.content
FROM Messages m
INNER JOIN Users AS u ON m.user_id = u.user_id
INNER JOIN Addresses AS a ON u.user_id = a.user_id;

--23. Find cities in the Addresses table that have more than 3 users.
SELECT city, COUNT(user_id) > 3
FROM Addresses
GROUP BY city;



--24. Calculate the average length of messages for each user, and display only those users who have an average message length greater than 50 characters.
SELECT u.user_id, u.username, AVG(LENGTH(m.content)) AS avg_message_length
FROM users u
INNER JOIN messages m ON u.user_id = m.user_id
GROUP BY u.user_id, u.username
HAVING AVG(LENGTH(m.content)) > 10;

