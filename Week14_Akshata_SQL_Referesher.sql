
#creating database

create database hotel;

#using database
use hotel;

#Creating the Tables 

#Table 1:- Hotel including the columns name hotel number, name and its address.
CREATE TABLE hotel( 
hotel_no CHAR(4) NOT NULL, 
name VARCHAR(20) NOT NULL,
address VARCHAR(50) NOT NULL);

#Table 2 :-Room which has the column names room number, hotel number,Room type and it's price.
CREATE TABLE room (
room_no VARCHAR(4) NOT NULL,
hotel_no CHAR(4) NOT NULL,
type CHAR(1) NOT NULL,
price DECIMAL(5,2) NOT NULL);

#Table 3:- Booking which has column name hotel number,guest number, date from and date to  and room number details.
CREATE TABLE booking (
hotel_no CHAR(4) NOT NULL, 
guest_no CHAR(4) NOT NULL, 
date_from DATETIME NOT NULL, 
date_to DATETIME NULL, 
room_no CHAR(4) NOT NULL); 
#Dates: YYYY-MM-DD;

#Table 4 :- Guest which are having the details of Guest number, their name and address.
CREATE TABLE guest ( 
guest_no CHAR(4) NOT NULL, 
name VARCHAR(20) NOT NULL, 
address VARCHAR(50) NOT NULL);


#Populating the Tables

 INSERT INTO hotel VALUES ('H111', 'Grosvenor Hotel', 'London'); 
 INSERT INTO room VALUES ('1', 'H111', 'S', 72.00);
 INSERT INTO guest VALUES ('G111', 'John Smith', 'London'); 
 INSERT INTO booking VALUES ('H111', 'G111', DATE'1999-01-01', DATE'1999-01-02', '1');
 
#Updating the Tables

#Updating the price of Room table by 1.05 dollars

UPDATE room SET price = price*1.05;
select * from room;

#Create a separate table with the same structure as the Booking table to hold archive records.

#creating archive records for booking old table
CREATE TABLE booking_old 
( hotel_no CHAR(4) NOT NULL, 
guest_no CHAR(4) NOT NULL, 
date_from DATETIME NOT NULL, 
date_to DATETIME NULL, room_no VARCHAR(4) NOT NULL);


#Inserting the values at booking old table
INSERT INTO booking_old 
(SELECT * FROM booking WHERE date_to < DATE'2000-01-01'); 

/*Using the INSERT statement, copy the records from the Booking table to the archive table relating to bookings before 1st January 2000. 
Delete all bookings before 1st January 2000 from the Booking table.*/

#deleting the entries before 1/01/2000 from Booking Table
DELETE FROM booking 
WHERE date_to < DATE ('2000-01-01');

select * from booking;

#Queries: Back to the Database Hotel (Hotel_No, Name, Address) Room (Room_No, Hotel_No, Type, Price) Booking (Hotel_No, Guest_No, Date_From, Date_To, Room_No) Guest (Guest_No, Name, Address)

#SIMPLE QUERIES:-

#1-List full details of all hotels.

#soln:- Fetching all details of Hotel
select * from hotel;

#2-List full details of all hotels in London. 

#soln:- fetching all details of hotel by applying the condition for address belongs to London
select * from hotel
where address = 'London';

#3-List the names and addresses of all guests in London, alphabetically ordered by name. 

#soln:-fetching all details of guest whose address is from London and ordering it alphabetically
select * from guest
where address = 'London'
order by name;

#4-List all double or family rooms with a price below £40.00 per night, in ascending order of price. 

#soln:- Fetching all details of Double/Family Room whose price is less than 40 doller per night using where clause and ordering by price

select * from room
where price < 40.00 and type in ('Double','Family')
order by price;

#5:-List the bookings for which no date_to has been specified.

#fetching all details of Booking table applying where class for which no date is specified.
select * from booking
where date_to is null;

##Aggregate Functions##


#1-How many hotels are there? 

#soln:- getting count of hotels from Hotel table using agg function count.

SELECT count(*) as Hotel_count from hotel;

#2-What is the average price of a room? 

#soln:- getting avg price of room using agg function avg/.
select room_no,avg(price)from room;

#3-What is the total revenue per night from all double rooms? 

#soln:- getting revenue of the double type room using agg function Sum and applying where clause condition.

SELECT SUM(price) FROM room WHERE type = 'Double';
 #or

select type, sum(price) as total_revenue_per_night from room;

#4-How many different guests have made bookings for August?

#getting count of differnt guest using agg function and applying condition to get booking for August.
SELECT COUNT(DISTINCT guest_no) as Guest_count
FROM booking
WHERE (date_from >= '2021-08-01' AND date_from <= '2021-08-31');


##SUBQUERIES AND JOINS##

#1:-List the price and type of all rooms at the Grosvenor Hotel.

#soln:- fetching price and type of room from Room table and applying where clause to get details of Grosvenor Hotel
SELECT price, type FROM Room
WHERE hotel_No =(SELECT hotel_No FROM Hotel WHERE Name = 'Grosvenor Hotel'); 

#2:-List all guests currently staying at the Grosvenor Hotel. 

#soln: fetching all details of guest and then applying where clause and fetch the details for current date. Used another condition to get Hotel detaoils.
SELECT * FROM Guest
 WHERE guest_No =
 (SELECT guest_No FROM Booking
 WHERE date_From <= CURRENT_DATE AND
 date_To >= CURRENT_DATE AND
 hotel_No =
 (SELECT hotel_No FROM Hotel
 WHERE Name = 'Grosvenor Hotel')); 
 
 #3-List the details of all rooms at the Grosvenor Hotel, including the name of the guest staying in the room, if the room is occupied. 
 
 #Soln:- Fetching details of room, applying where clause to get the details of guest who are currently staying.
SELECT r.* FROM Room r left JOIN
 (SELECT g.Name, h.hotel_No, b.room_No FROM Guest g, Booking b, Hotel h
 WHERE g.guest_No = b.guest_No AND b.hotel_No = h.hotel_No AND 
 h.Name= 'Grosvenor Hotel' AND
 date_From <= CURRENT_DATE AND
 date_To >= CURRENT_DATE) AS A
 ON r.hotel_No = A.hotel_No AND r.room_No = A.room_No; 
 
 #4- What is the total income from bookings for the Grosvenor Hotel today? 

#soln:- fetching sum of price from booking table and applying condition to get the details of current bookings by joining Hotel and room tables
SELECT SUM(price) FROM booking b, room r, hotel h
WHERE (b.date_from <= CURRENT_DATE AND
b.date_to >= CURRENT_DATE) AND
r.hotel_no = h.hotel_no AND r.room_no = b.room_no;

#5:-List the rooms that are currently unoccupied at the Grosvenor Hotel. 

#soln:- getting all details of room and applying condition to get the details of booking by joining booking and hotel table. Also used where clause to get hotel details.
SELECT * FROM room r
WHERE room_no NOT IN
(SELECT room_no FROM booking b, hotel h
WHERE (date_from <= CURRENT_DATE AND
date_to >= CURRENT_DATE) AND
b.hotel_no = h.hotel_no AND name = 'Grosvenor hotel');


#6-What is the lost income from unoccupied rooms at the Grosvenor Hotel?

#son:- after getting unoccupied room details in above query, we have used agg function sum to get lost income.
SELECT SUM(price) FROM room r
WHERE room_no NOT IN
(SELECT room_no FROM booking b, hotel h
WHERE (date_from <= CURRENT_DATE AND
date_to >= CURRENT_DATE) AND
b.hotel_no = h.hotel_no AND name = 'Grosvenor');


#Grouping ##

#1-List the number of rooms in each hotel. 

#fetching hotel details and grouping it by Room no.
SELECT hOTEL_NO,COUNT(ROOM_NO) AS ROOM_COUNT FROM ROOM
GROUP BY ROOM_NO;

#2-List the number of rooms in each hotel in London. 

#getting room details by joining room and hotel details and grouping it by Hotel no.
SELECT r.hotel_no, COUNT(room_no)
FROM room r, hotel h
WHERE r.hotel_no=h.hotel_no AND
ADDRESS = 'London'
GROUP BY r.hotel_no;

#3-What is the average number of bookings for each hotel in August? 

#getting average of booking in hotel by using agg function and to get booking details, we habve created another temporary table where we have grouped data by hotel no.

SELECT AVG(X) AS AveNumBook FROM
(SELECT hotel_no, COUNT(hotel_no) AS X
FROM booking b
WHERE (b.date_from >= DATE'2021-08-01' AND b.date_from <= DATE'2021-08-31')
GROUP BY hotel_no) AS XX;


#4-What is the most commonly booked room type for each hotel in London? 

#soln:- used agg function max to get the most commanly booked room by creating a another subquery to get the count of booked room where condition has been applied.

SELECT MAX(X) AS MostlyBook
FROM (SELECT type, COUNT(type) AS X
FROM booking b, hotel h, room r
WHERE r.room_no = b.room_no AND b.hotel_no = h.hotel_no AND
h.address = 'London'
GROUP BY type) AS XX;


#5-What is the lost income from unoccupied rooms at each hotel today?

#soln:- fetching hotel no, sum of price from room table. Applying where clause to get the details of unoccupied rooms using subqueries and grouping it by hotel.
SELECT hotel_no, SUM(price) FROM room r
WHERE room_no NOT IN
(SELECT room_no FROM booking b, hotel h
WHERE (date_from <= CURRENT_DATE AND
date_to >= CURRENT_DATE) AND
b.hotel_no = h.hotel_no)
GROUP BY hotel_no;