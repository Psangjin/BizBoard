
CREATE TABLE users (
    id          VARCHAR2(50) PRIMARY KEY,    -- 일반회원: 아이디 / SNS회원: provider_id
    pw          VARCHAR2(100),               -- 일반회원만 입력
    email       VARCHAR2(100) UNIQUE,        -- 이메일 (SNS회원도 필수)
    name        VARCHAR2(50) NOT NULL,       -- 이름    
    sign_date   DATE DEFAULT SYSDATE         -- 가입일
);
