CREATE TABLE schedule (
  id NUMBER PRIMARY KEY,
  title VARCHAR2(100),
  content VARCHAR2(4000),
  type VARCHAR2(10),
  start_dt TIMESTAMP,
  end_dt TIMESTAMP,
  completed VARCHAR(5),
  color VARCHAR2(20)
);

CREATE SEQUENCE schedule_seq START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE t_project (
  id NUMBER PRIMARY KEY,
  manager VARCHAR2(32),
  title VARCHAR2(100),
  content VARCHAR2(4000),
  start_dt TIMESTAMP,
  end_dt TIMESTAMP
);

CREATE SEQUENCE project_seq START WITH 1 INCREMENT BY 1 NOCACHE;


CREATE TABLE project_user (
  user_id VARCHAR2(32),	
  project_id NUMBER,
  PRIMARY KEY (user_id, project_id)
);
