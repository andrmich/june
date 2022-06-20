Scripts: 
Problem: Improve readability of logs provided by Clickhouse  (example logs are taken from this Github issue: 
https://github.com/ClickHouse/ClickHouse/issues/26952) by:
- extracting only those pertaining PostgreSQL
- only level Debug
- replace  every occurrence of 'PostgreSQLReaplicaConsumer' to 'RC' and change its color to yellow
- replace every occurrence of 'PostgreSQLConnection' to 'CO' and change its color to blue
- output should include timestamp and all the fields after the '<Debug>' field