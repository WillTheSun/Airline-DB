-------------------------- Winning Ticket Generator --------------------------
-- CPSC 437 Databases Final Project                                         --
-- Xinyu Hong, Yang Zhang, William Sun, Liu Wang
-- Select a winner from the Bids. Then find tickets for the winner.         --
-- If no tickets match the winner, nothing is returned.                     --
------------------------------------------------------------------------------

-------------------------- Clean Up Views --------------------------
DROP VIEW IF EXISTS qualified_bids, potential_winners, 
winner, alt_route_winner, augmented_winner,
alt_date_route_flights, accepted_alt_date_route_flights, 
tickets CASCADE;

-------------------------- 1. Choose a winner --------------------------
-- Filter by bids over 50
CREATE VIEW qualified_bids AS
SELECT *
FROM Bid
WHERE bidding > 50 AND willing BETWEEN 0 AND 9999;

--Generate a random number
UPDATE lucky 
SET lucky_number = round(random() * 10000);

-- Choose the customer whose 'willing' guess is closest to the lucky numberwinner with the smallest client_id.
CREATE VIEW potential_winners AS
SELECT *
FROM qualified_bids
WHERE @ (willing - (SELECT * FROM lucky)) 
      <= all (SELECT @ (willing - (SELECT * FROM lucky))    
              FROM qualified_bids);
                                           
-- Split ties based on the smallest client_id.                                           
CREATE VIEW winner AS
SELECT client_id, bidding, departure_airport, arrival_airport, date           --no willing
FROM potential_winners
WHERE client_id <= all (SELECT client_id   
                        FROM potential_winners);


-------------------------- 2. Find Routes for Winner --------------------------
--  Returns original route, and routes from nearby airports
--  We'd limit distance to 100mi in reality, but for testing our data set we use 1000mi

CREATE VIEW alt_route_winner AS
SELECT client_id, bidding, Driving_distance.end_airport AS departure_airport, arrival_airport, date, winner.departure_airport AS orig_departure_airport            --no willing
FROM winner JOIN Driving_distance ON (winner.departure_airport = Driving_distance.start_airport)
WHERE miles <= 100;

CREATE VIEW augmented_winner AS
(SELECT *, departure_airport AS orig_departure_airport
FROM winner)
UNION
(SELECT *
FROM alt_route_winner);

--  Check routes that include flight times +- 3 days
CREATE VIEW alt_date_route_flights AS
SELECT bidding, flight_number, airline, standard_price, augmented_winner.date AS winner_date, schedule.date AS schedule_date, seat_sold, aircraft_id, time_id, departure_airport, arrival_airport, orig_departure_airport 
FROM ((augmented_winner JOIN Route USING (departure_airport, arrival_airport))
     JOIN Flight USING (route_code))
     JOIN Schedule USING (flight_number)     --no date
WHERE @ (augmented_winner.date - Schedule.date) BETWEEN 0 AND 3;


-------------------------- 3. Find Tickets For Winner's Routes --------------------------
-- Select routes where the winner's bid is more than lowest_acceptable_price
CREATE VIEW accepted_alt_date_route_flights AS
SELECT flight_number, airline, time_id, departure_airport, arrival_airport, orig_departure_airport, winner_date, schedule_date
FROM alt_date_route_flights JOIN Aircraft USING (aircraft_id)
WHERE (seat_sold * standard_price * 0.8 / number_of_seats) <= bidding;

-- Select Tickets 
  --Tickets for the exact day and the exact departure_airport (if it is not empty)
  --Else tickets for +-3 days and the exact departure_airport  (if it is not empty)      
  --Else tickets for the exact day and a nearby departure_airport  (if it is not empty)
  --ELse tickets for +-3 days and a nearby departure_airport  (if it is not empty)
  --Else we have to reject the winner. (empty table)
CREATE VIEW tickets AS
SELECT flight_number, airline, schedule_date, time_id, departure_airport, arrival_airport
FROM accepted_alt_date_route_flights
WHERE CASE
      WHEN EXISTS (SELECT * 
                   FROM accepted_alt_date_route_flights
                   WHERE winner_date = schedule_date AND departure_airport = orig_departure_airport)
          THEN winner_date = schedule_date AND departure_airport = orig_departure_airport
      WHEN EXISTS (SELECT * 
                   FROM accepted_alt_date_route_flights
                   WHERE departure_airport = orig_departure_airport)
          THEN departure_airport = orig_departure_airport
      WHEN EXISTS (SELECT * 
                   FROM accepted_alt_date_route_flights
                   WHERE winner_date = schedule_date)
          THEN winner_date = schedule_date
      ELSE true
      END;


SELECT * FROM winner;
SELECT * FROM tickets;





    







