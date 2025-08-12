create table notice(
id NUMBER primary key,
project_id NUMBER not null,
user_id varchar2(50) not null,
title varchar2(200) not null,
description clob,
write_time timestamp(6) with time zone default systimestamp not null
);
create sequence seq_notice start with 1;

select * from notice;