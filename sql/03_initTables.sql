CREATE TABLE Airport(
airport_code varchar(10) PRIMARY KEY,
airport_name varchar(100),
city varchar(20),
state varchar(20)
);

CREATE TABLE Driving_distance(
start_airport varchar(10) REFERENCES Airport(airport_code),
end_airport varchar(10) REFERENCES Airport(airport_code),
miles real,
primary key(start_airport, end_airport)
);

CREATE TABLE Route(
route_code varchar(20) PRIMARY KEY,
departure_airport varchar(10) REFERENCES Airport(airport_code),
arrival_airport varchar(10) REFERENCES Airport(airport_code),
miles real
);

CREATE TABLE Flight(
flight_number varchar(20) PRIMARY KEY,
airline varchar(20),
standard_price int,
route_code varchar(20) REFERENCES Route(route_code)
);

CREATE TABLE Aircraft(
aircraft_id varchar(20) PRIMARY KEY,
model varchar(10),
number_of_seats int,
manufacturer varchar(20)
);

CREATE TABLE Schedule(
flight_number varchar(20),
date date,
time_id varchar(10),
aircraft_id varchar(20) REFERENCES Aircraft(aircraft_id),
seat_sold int,
primary key(flight_number, date)
);

CREATE TABLE Time(
time_id varchar(10) PRIMARY KEY,
departure_time time,
arrival_time time
);

CREATE TABLE Client(
first_name varchar(20),
last_name varchar(13),
client_id int PRIMARY KEY, --changed name varchar(20),
date_of_birth date
);

CREATE TABLE Bid(
client_id int REFERENCES Client(client_id),
bidding int,
willing int,
departure_airport varchar(10) REFERENCES Airport(airport_code),
arrival_airport varchar(10) REFERENCES Airport(airport_code),
date date,
primary key(client_id, bidding, willing, departure_airport, arrival_airport)
);

CREATE TABLE Contact(
client_id int REFERENCES Client(client_id),
phone varchar(20),
email varchar(50),
street_number int,
street_name varchar(50),
-- --delete apt_number varchar(10),
city varchar(50),
state varchar(50),
zip int --changed primary key(client_id, street_number, street_name, city, state)
);

CREATE TABLE lucky(
lucky_number int
);

INSERT INTO lucky
VALUES(0);
