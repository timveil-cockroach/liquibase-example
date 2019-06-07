# CockroachDB + Liquibase Example
A quick example/test using SpringBoot, Liquibase and CockroachDB.

## Getting Started
From the root directory, run `docker-compose up` to start a single node CockroachDB instance.  See [docker-compose.yml](docker-compose.yml) for more details.

## Tests

### Test 1
1. Create the `test` database on the CockroachDB Docker instance

```bash
docker-compose exec crdb /cockroach/cockroach sql --insecure --execute="CREATE DATABASE test;"
```

2. Start the `LiquibaseDemoApplication` SpringBoot app.  

```bash
./mvnw spring-boot:run
```

This will read the Liquibase changelog file at startup and create the described tables.  See [db.changelog-master.yml](src/main/resources/db/changelog/db.changelog-master.yaml) for more details.  If it completes successfully you should see log file entries like this...

```
2019-06-07 09:48:36.280  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : SELECT COUNT(*) FROM public.databasechangeloglock
2019-06-07 09:48:36.300  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : CREATE TABLE public.databasechangeloglock (ID INTEGER NOT NULL, LOCKED BOOLEAN NOT NULL, LOCKGRANTED TIMESTAMP WITHOUT TIME ZONE, LOCKEDBY VARCHAR(255), CONSTRAINT DATABASECHANGELOGLOCK_PKEY PRIMARY KEY (ID))
2019-06-07 09:48:36.324  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : SELECT COUNT(*) FROM public.databasechangeloglock
2019-06-07 09:48:36.344  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : DELETE FROM public.databasechangeloglock
2019-06-07 09:48:36.349  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : INSERT INTO public.databasechangeloglock (ID, LOCKED) VALUES (1, FALSE)
2019-06-07 09:48:36.355  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : SELECT LOCKED FROM public.databasechangeloglock WHERE ID=1
2019-06-07 09:48:36.368  INFO 13434 --- [           main] l.lockservice.StandardLockService        : Successfully acquired change log lock
2019-06-07 09:48:36.987  INFO 13434 --- [           main] l.c.StandardChangeLogHistoryService      : Creating database history table with name: public.databasechangelog
2019-06-07 09:48:36.988  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : CREATE TABLE public.databasechangelog (ID VARCHAR(255) NOT NULL, AUTHOR VARCHAR(255) NOT NULL, FILENAME VARCHAR(255) NOT NULL, DATEEXECUTED TIMESTAMP WITHOUT TIME ZONE NOT NULL, ORDEREXECUTED INTEGER NOT NULL, EXECTYPE VARCHAR(10) NOT NULL, MD5SUM VARCHAR(35), DESCRIPTION VARCHAR(255), COMMENTS VARCHAR(255), TAG VARCHAR(255), LIQUIBASE VARCHAR(20), CONTEXTS VARCHAR(255), LABELS VARCHAR(255), DEPLOYMENT_ID VARCHAR(10))
2019-06-07 09:48:36.999  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : SELECT COUNT(*) FROM public.databasechangelog
2019-06-07 09:48:37.011  INFO 13434 --- [           main] l.c.StandardChangeLogHistoryService      : Reading from public.databasechangelog
2019-06-07 09:48:37.011  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : SELECT * FROM public.databasechangelog ORDER BY DATEEXECUTED ASC, ORDEREXECUTED ASC
2019-06-07 09:48:37.014  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : SELECT COUNT(*) FROM public.databasechangeloglock
2019-06-07 09:48:37.021  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : CREATE TABLE public.person (id SERIAL NOT NULL, first_name VARCHAR(255) NOT NULL, last_name VARCHAR(255) NOT NULL, CONSTRAINT PERSON_PKEY PRIMARY KEY (id))
2019-06-07 09:48:37.028  INFO 13434 --- [           main] liquibase.changelog.ChangeSet            : Table person created
2019-06-07 09:48:37.032  INFO 13434 --- [           main] liquibase.changelog.ChangeSet            : ChangeSet db/changelog/db.changelog-master.yaml::1::marceloverdijk ran successfully in 11ms
2019-06-07 09:48:37.033  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : SELECT MAX(ORDEREXECUTED) FROM public.databasechangelog
2019-06-07 09:48:37.036  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : INSERT INTO public.databasechangelog (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('1', 'marceloverdijk', 'db/changelog/db.changelog-master.yaml', NOW(), 1, '8:5540715bfd4176617b0d42bc69810f87', 'createTable tableName=person', '', 'EXECUTED', NULL, NULL, '3.6.3', '9915317016')
2019-06-07 09:48:37.046  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : INSERT INTO public.person (first_name, last_name) VALUES ('Marcel', 'Overdijk')
2019-06-07 09:48:37.056  INFO 13434 --- [           main] liquibase.changelog.ChangeSet            : New row inserted into person
2019-06-07 09:48:37.060  INFO 13434 --- [           main] liquibase.changelog.ChangeSet            : ChangeSet db/changelog/db.changelog-master.yaml::2::marceloverdijk ran successfully in 14ms
2019-06-07 09:48:37.061  INFO 13434 --- [           main] liquibase.executor.jvm.JdbcExecutor      : INSERT INTO public.databasechangelog (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('2', 'marceloverdijk', 'db/changelog/db.changelog-master.yaml', NOW(), 2, '8:63f079ffe738ba8d1f67983b405f1be9', 'insert tableName=person', '', 'EXECUTED', NULL, NULL, '3.6.3', '9915317016')
2019-06-07 09:48:37.073  INFO 13434 --- [           main] l.lockservice.StandardLockService        : Successfully released change log lock
2019-06-07 09:48:37.129  INFO 13434 --- [           main] i.c.liquibase.LiquibaseDemoApplication   : Started LiquibaseDemoApplication in 2.129 seconds (JVM running for 2.525)
```

### Test 2
1. Use the CockroachDB `workload` command to generate the `tpcc` database and schema

```bash
docker-compose exec crdb /cockroach/cockroach workload init tpcc
```

2. Run `liquibase:generateChangeLog` to generate a Liquibase changelog for the `tpcc` database.  This will generate a file called [generated-tpcc.xml](src/main/resources/db/changelog/generated-tpcc.xml)
```bash
./mvnw liquibase:generateChangeLog
```

3. Ensure that `spring.liquibase.change-log` in `application.properties` now points to the newly generated change log.
```properties
spring.liquibase.change-log=db/changelog/generated-tpcc.xml
```

4. Restart the SpringBoot app.  You should now see the `tpcc` schema created in the `test` database.
```bash
./mvnw spring-boot:run
```

## Helpful Commands

Open shell to CockroachDB node
```bash
docker-compose exec crdb /bin/bash
```