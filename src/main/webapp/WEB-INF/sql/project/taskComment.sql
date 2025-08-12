create table task_comment(
id NUMBER primary key,
schedule_id NUMBER not null,
user_id varchar2(50) not null,
title varchar2(200) not null,
description clob,
file_path varchar2(400),
write_time timestamp(6) with time zone default systimestamp not null
);

create sequence seq_task_comment start with 1;