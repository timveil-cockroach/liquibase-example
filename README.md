# CockroachDB + Liquibase Example
A quick example/test using SpringBoot, Liquibase and CockroachDB.

## Tests

### Test 1
Test creates a simple schema from an existing changelog file.

1. From the root directory, run `docker-compose up -d` to start a single node CockroachDB instance.  See [docker-compose.yml](docker-compose.yml) for more details.

2. Start the `LiquibaseDemoApplication` SpringBoot app.  
    ```bash
    ./mvnw spring-boot:run -Dspring-boot.run.profiles=test1
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
3. Open [CockroachDB UI](http://localhost:8080/#/databases/tables) and verify that the table `person` has been created and data exists

4. Bring down the CockroachDB cluster to clean up resources using `docker-compose down --remove-orphans --volumes`

### Test 2
Test uses CockroachDB to generate a complex schema, generates a Liquibase `changelog` for the schema and then applies to a different database.

1. From the root directory, run `docker-compose up -d` to start a single node CockroachDB instance.  See [docker-compose.yml](docker-compose.yml) for more details.

2. Use the CockroachDB `workload` command to generate the `tpcc` database and schema
    ```bash
    docker-compose exec crdb /cockroach/cockroach workload init tpcc
    ```

3. Run `liquibase:generateChangeLog` to generate a Liquibase changelog for the `tpcc` database.  This will generate a file called `generated-tpcc.xml` in `src/main/resources/db/changelog/`.
    ```bash
    ./mvnw clean liquibase:generateChangeLog
    ```

4. Ensure that `spring.liquibase.change-log` in `application-test2.properties` points to the newly generated change log.
    ```properties
    spring.liquibase.change-log=db/changelog/generated-tpcc.xml
    ```

5. Restart the SpringBoot app.  You should now see the `tpcc` schema created in the `test` database [here](http://localhost:8080/#/databases/tables).
    ```bash
    ./mvnw spring-boot:run -Dspring-boot.run.profiles=test2
    ```

6. Bring down the CockroachDB cluster to clean up resources using `docker-compose down --remove-orphans --volumes`

### Test 3
Dropping and recreating a view in a changeset errors out

1. From the root directory, run `docker-compose up -d` to start a single node CockroachDB instance.  See [docker-compose.yml](docker-compose.yml) for more details.

2. `docker-compose exec crdb /bin/bash` to open shell to CockroachDB node. Then run the following to create table `foo` and view `foo_view`
```
cockroach sql --insecure
set database=test;
create table foo (id UUID, name STRING);
create view foo_view as select id from foo;
```

3. Exit the shell to the CockroachDB node

4. Start the `LiquibaseDemoApplication` SpringBoot app.  
    ```bash
    ./mvnw spring-boot:run -Dspring-boot.run.profiles=test3
    ```

You see the stacktrace below. If you go into the CockroachDB node using the same commands from step #2, you see that `foo_view` was **not** dropped.

If you alter the [changeset](src/main/resources/db/changelog/db.changelog-master.sql) to only drop `foo_view` then the application starts. The combination of dropping `foo_view` and recreating `foo_view` results in the error.

```
Error starting ApplicationContext. To display the conditions report re-run your application with 'debug' enabled.
2020-05-24 23:55:52.001 ERROR 96441 --- [           main] o.s.boot.SpringApplication               : Application run failed

org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'liquibase' defined in class path resource [org/springframework/boot/autoconfigure/liquibase/LiquibaseAutoConfiguration$LiquibaseConfiguration.class]: Invocation of init method failed; nested exception is liquibase.exception.MigrationFailedException: Migration failed for change set db/changelog/db.changelog-master.sql::1::marceloverdijk:
     Reason: liquibase.exception.DatabaseException: ERROR: relation "foo_view" already exists [Failed SQL: (0) create view foo_view as select id from foo]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.initializeBean(AbstractAutowireCapableBeanFactory.java:1796) ~[spring-beans-5.2.6.RELEASE.jar:5.2.6.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:595) ~[spring-beans-5.2.6.RELEASE.jar:5.2.6.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:517) ~[spring-beans-5.2.6.RELEASE.jar:5.2.6.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.lambda$doGetBean$0(AbstractBeanFactory.java:323) ~[spring-beans-5.2.6.RELEASE.jar:5.2.6.RELEASE]
	at org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:226) ~[spring-beans-5.2.6.RELEASE.jar:5.2.6.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:321) ~[spring-beans-5.2.6.RELEASE.jar:5.2.6.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:202) ~[spring-beans-5.2.6.RELEASE.jar:5.2.6.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:310) ~[spring-beans-5.2.6.RELEASE.jar:5.2.6.RELEASE]
	at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:202) ~[spring-beans-5.2.6.RELEASE.jar:5.2.6.RELEASE]
	at org.springframework.beans.factory.support.DefaultListableBeanFactory.preInstantiateSingletons(DefaultListableBeanFactory.java:895) ~[spring-beans-5.2.6.RELEASE.jar:5.2.6.RELEASE]
	at org.springframework.context.support.AbstractApplicationContext.finishBeanFactoryInitialization(AbstractApplicationContext.java:878) ~[spring-context-5.2.6.RELEASE.jar:5.2.6.RELEASE]
	at org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:550) ~[spring-context-5.2.6.RELEASE.jar:5.2.6.RELEASE]
	at org.springframework.boot.SpringApplication.refresh(SpringApplication.java:758) ~[spring-boot-2.3.0.RELEASE.jar:2.3.0.RELEASE]
	at org.springframework.boot.SpringApplication.refresh(SpringApplication.java:750) ~[spring-boot-2.3.0.RELEASE.jar:2.3.0.RELEASE]
	at org.springframework.boot.SpringApplication.refreshContext(SpringApplication.java:397) ~[spring-boot-2.3.0.RELEASE.jar:2.3.0.RELEASE]
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:315) ~[spring-boot-2.3.0.RELEASE.jar:2.3.0.RELEASE]
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:1237) ~[spring-boot-2.3.0.RELEASE.jar:2.3.0.RELEASE]
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:1226) ~[spring-boot-2.3.0.RELEASE.jar:2.3.0.RELEASE]
	at io.crdb.liquibase.LiquibaseDemoApplication.main(LiquibaseDemoApplication.java:10) ~[classes/:na]
Caused by: liquibase.exception.MigrationFailedException: Migration failed for change set db/changelog/db.changelog-master.sql::1::marceloverdijk:
     Reason: liquibase.exception.DatabaseException: ERROR: relation "foo_view" already exists [Failed SQL: (0) create view foo_view as select id from foo]
	at liquibase.changelog.ChangeSet.execute(ChangeSet.java:646) ~[liquibase-core-3.9.0.jar:na]
	at liquibase.changelog.visitor.UpdateVisitor.visit(UpdateVisitor.java:53) ~[liquibase-core-3.9.0.jar:na]
	at liquibase.changelog.ChangeLogIterator.run(ChangeLogIterator.java:83) ~[liquibase-core-3.9.0.jar:na]
	at liquibase.Liquibase.update(Liquibase.java:202) ~[liquibase-core-3.9.0.jar:na]
	at liquibase.Liquibase.update(Liquibase.java:179) ~[liquibase-core-3.9.0.jar:na]
	at liquibase.integration.spring.SpringLiquibase.performUpdate(SpringLiquibase.java:366) ~[liquibase-core-3.9.0.jar:na]
	at liquibase.integration.spring.SpringLiquibase.afterPropertiesSet(SpringLiquibase.java:314) ~[liquibase-core-3.9.0.jar:na]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.invokeInitMethods(AbstractAutowireCapableBeanFactory.java:1855) ~[spring-beans-5.2.6.RELEASE.jar:5.2.6.RELEASE]
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.initializeBean(AbstractAutowireCapableBeanFactory.java:1792) ~[spring-beans-5.2.6.RELEASE.jar:5.2.6.RELEASE]
	... 18 common frames omitted
Caused by: liquibase.exception.DatabaseException: ERROR: relation "foo_view" already exists [Failed SQL: (0) create view foo_view as select id from foo]
	at liquibase.executor.jvm.JdbcExecutor$ExecuteStatementCallback.doInStatement(JdbcExecutor.java:402) ~[liquibase-core-3.9.0.jar:na]
	at liquibase.executor.jvm.JdbcExecutor.execute(JdbcExecutor.java:59) ~[liquibase-core-3.9.0.jar:na]
	at liquibase.executor.jvm.JdbcExecutor.execute(JdbcExecutor.java:131) ~[liquibase-core-3.9.0.jar:na]
	at liquibase.database.AbstractJdbcDatabase.execute(AbstractJdbcDatabase.java:1276) ~[liquibase-core-3.9.0.jar:na]
	at liquibase.database.AbstractJdbcDatabase.executeStatements(AbstractJdbcDatabase.java:1258) ~[liquibase-core-3.9.0.jar:na]
	at liquibase.changelog.ChangeSet.execute(ChangeSet.java:609) ~[liquibase-core-3.9.0.jar:na]
	... 26 common frames omitted
Caused by: org.postgresql.util.PSQLException: ERROR: relation "foo_view" already exists
	at org.postgresql.core.v3.QueryExecutorImpl.receiveErrorResponse(QueryExecutorImpl.java:2533) ~[postgresql-42.2.12.jar:42.2.12]
	at org.postgresql.core.v3.QueryExecutorImpl.processResults(QueryExecutorImpl.java:2268) ~[postgresql-42.2.12.jar:42.2.12]
	at org.postgresql.core.v3.QueryExecutorImpl.execute(QueryExecutorImpl.java:313) ~[postgresql-42.2.12.jar:42.2.12]
	at org.postgresql.jdbc.PgStatement.executeInternal(PgStatement.java:448) ~[postgresql-42.2.12.jar:42.2.12]
	at org.postgresql.jdbc.PgStatement.execute(PgStatement.java:369) ~[postgresql-42.2.12.jar:42.2.12]
	at org.postgresql.jdbc.PgStatement.executeWithFlags(PgStatement.java:310) ~[postgresql-42.2.12.jar:42.2.12]
	at org.postgresql.jdbc.PgStatement.executeCachedSql(PgStatement.java:296) ~[postgresql-42.2.12.jar:42.2.12]
	at org.postgresql.jdbc.PgStatement.executeWithFlags(PgStatement.java:273) ~[postgresql-42.2.12.jar:42.2.12]
	at org.postgresql.jdbc.PgStatement.execute(PgStatement.java:268) ~[postgresql-42.2.12.jar:42.2.12]
	at com.zaxxer.hikari.pool.ProxyStatement.execute(ProxyStatement.java:95) ~[HikariCP-3.4.5.jar:na]
	at com.zaxxer.hikari.pool.HikariProxyStatement.execute(HikariProxyStatement.java) ~[HikariCP-3.4.5.jar:na]
	at liquibase.executor.jvm.JdbcExecutor$ExecuteStatementCallback.doInStatement(JdbcExecutor.java:398) ~[liquibase-core-3.9.0.jar:na]
	... 31 common frames omitted

[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  2.747 s
[INFO] Finished at: 2020-05-24T23:55:52-04:00
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.springframework.boot:spring-boot-maven-plugin:2.3.0.RELEASE:run (default-cli) on project liquibase-demo: Application finished with exit code: 1 -> [Help 1]
[ERROR]
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR]
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoExecutionException
```

## Helpful Commands

Open shell to CockroachDB node
```bash
docker-compose exec crdb /bin/bash
```
