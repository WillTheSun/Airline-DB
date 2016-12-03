On Windows: Download PSQL and run 

```sh
$ \i '/yourdirectorypath.../install.sql'
```

Mac/Linux: First, install Postgresql and PSQL.

Then install the database tables and set up sample data:

```sh
$ psql -f /yourdirectorypath.../install.sql
```

Next, execute the queries yourself
```sh
$ psql -f /yourdirectorypath.../queries.sql
```

Or use our bash script to Draw 10 Winners
```sh
$ ./draw10winners.sh
```
