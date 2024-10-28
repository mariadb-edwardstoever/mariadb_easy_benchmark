# Mariadb Easy Benchmark

Mariadb Easy Benchmark is a quick and easy method to use mariadb-slap to benchmark Mariadb instances.

Benchmarking is the activity of flooding an instance with transactions to see how its performance compares to other instances. Mariadb-slap is a program that can do this. Mariadb-slap is limited in that it can run just one script which can only have one delimiter. Certain syntax that would be acceptable in the standard mariadb client will break mariadb-slap. If you need a more robust tool for benchmarking, you might try Mariadb Connection Pool Simulator, available here: https://github.com/mariadb-edwardstoever/conn_pool_sim

On the up-side, Mariadb-slap is easy to use if you have the right script to provide it. Also, mariadb-slap is distributed with Mariadb software.

Mariadb-slap will connect to the database as many times as you want simultaneously, and run a script that you provide. When it completes, it provides results like this:
```
Benchmark
        Average number of seconds to run all queries: 0.077 seconds
        Minimum number of seconds to run all queries: 0.072 seconds
        Maximum number of seconds to run all queries: 0.094 seconds
        Number of clients running queries: 30
        Average number of queries per client: 27
```
---
## Getting Started

To download Mariadb Easy Benchmark direct to your linux server, you may use git or wget:
```
git clone https://github.com/mariadb-edwardstoever/mariadb_easy_benchmark.git
```

```
wget https://github.com/mariadb-edwardstoever/mariadb_easy_benchmark/archive/refs/heads/main.zip
```

To setup the BENCHMARK schema, run the script:
```
mariadb < setup_benchmark.sql
```

## Running on a Stand-alone instance

To benchmark a stand-alone instance, you simply run a mariadb-slap command like this:

```
mariadb-slap  --delimiter=";" --create_schema="BENCHMARK" --query="easy_benchmark.sql" --concurrency=50 --iterations=100
```

## Running on a Primary/Master in a replication group

To benchmark instances in replication, you can run mariadb-slap on the master like this:

```
mariadb-slap --delimiter=";" --create_schema="BENCHMARK"  --query="replication_benchmark.sql" --concurrency=50 --iterations=100
```

The script replication_benchmark.sql provides a way to compare the performance of each instance to the performance of the others. For example, after benchmarking completes, I run the following query on a slave to see how far behind the master it got:
```
MariaDB [BENCHMARK]> select * from REPLICATION_PROGRESS where id in(select max(id) from REPLICATION_PROGRESS union all select min(id) from REPLICATION_PROGRESS);
+------+----------+---------------------+---------------------+------------------+----------------+
| id   | hostname | master_timestamp    | instance_timestamp  | gtid_current_pos | gtid_slave_pos |
+------+----------+---------------------+---------------------+------------------+----------------+
|    1 | db2      | 2024-10-28 15:07:42 | 2024-10-28 15:07:42 | 0-1-7148625      | 0-1-7148625    |
| 5000 | db2      | 2024-10-28 15:08:01 | 2024-10-28 15:08:18 | 0-1-7179523      | 0-1-7179523    |
+------+----------+---------------------+---------------------+------------------+----------------+
2 rows in set (0.002 sec)
```
We can see that the master was flooded with 30,898 changes based on gtid_slave_pos. We can also see that during the benchmark, the slave fell behind the master by 17 seconds.

## Providing Results to Mariadb Support

If you need to share your results with Mariadb Support, dump the BENCHMARK schema on each instance in your replication group to a sql file like this:
```
mariadb-dump BENCHMARK > $(hostname)_BENCHMARK.sql
```

## Clean up when done

You probably want to drop the BENCHMARK schema when you are finished, like so:
```
mariadb < drop_benchmark_schema.sql
```
