--liquibase formatted sql

--changeset marceloverdijk:1
drop view foo_view;
create view foo_view as select id from foo;
