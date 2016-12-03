#!/bin/bash

# draw 10 winners and check if there are avalable tickets for them
for i in 1 2 3 4 5 6 7 8 9 10
do
	echo "New DRAW!"
   PGPASSWORD=1234 psql -h lab.zoo.cs.yale.edu -U xh83 -q < queries.sql
   #psql -f queries.sql
done
