# BizBoard - 팀 업무·일정 협업 보드

팀/조직의 **프로젝트·일정·업무를 한 곳에서 관리**하는 웹 애플리케이션입니다.  
프로젝트별 멤버 관리, 캘린더/스케줄, 인박스(알림), 마이페이지를 제공합니다.

---

## 목차
- [🚀 주요 기능](#-주요-기능)
- [🛠 기술 스택](#-기술-스택)
- [📁 프로젝트 구조](#-프로젝트-구조)
- [🗄 데이터베이스 스키마 (요약)](#-데이터베이스-스키마-요약)
- [⚙️ 실행 방법](#️-실행-방법)
- [📱 주요 엔드포인트(예시)](#-주요-엔드포인트예시)
- [🔀 브랜치 & 커밋 규칙(예시)](#-브랜치--커밋-규칙예시)
- [🤝 기여 방법](#-기여-방법)
- [📄 라이선스](#-라이선스)
- [📬 문의](#-문의)

---

## 🚀 주요 기능

### 👥 계정/권한
- 회원가입/로그인, 비밀번호 변경, **회원탈퇴**
- 권한(Role) 기반 접근 제어: `ADMIN`, `USER`
- 프로필 편집(닉네임/연락처/아바타 등)

### 🗂 프로젝트
- 프로젝트 생성/수정/삭제
- 멤버 초대 및 역할 지정(관리자/구성원)
- 참여 프로젝트 목록(마이페이지 노출)

### 📅 일정(스케줄)
- 프로젝트별 일정 등록/수정/삭제
- 상태, 마감일, 담당자, 반복 여부, 메모
- 달력/리스트 뷰, 검색·필터

### 📥 인박스(알림)
- 나에게 배정/멘션/마감 임박 등 알림 수신
- 읽음/안읽음 관리
- *(선택)* SSE/폴링 기반 실시간 갱신

### 🙋 마이페이지
- **참여 프로젝트 목록** (테이블 `t_project`, `project_user` 연동)
- 나의 일정/할 일 요약, 최근 활동

---

## 🛠 기술 스택

**Backend**
- Java 11 *(pom.xml에 맞게 조정)*
- Spring Boot / Spring MVC
- MyBatis 3.x
- Oracle Database 19c
- Maven

**Frontend / View**
- JSP (JSTL) 기반 서버사이드 렌더링  
  *(Thymeleaf 사용 시 해당 부분만 변경)*

**Infra & 기타**
- Lombok, Validation, Logback
- JUnit (단위테스트)

---

## 📁 프로젝트 구조

~~~text
BizBoard/
├── src/
│   ├── main/
│   │   ├── java/com/app/
│   │   │   ├── controller/        # 웹/REST 컨트롤러
│   │   │   ├── service/           # 비즈니스 로직
│   │   │   ├── mapper/            # MyBatis 매퍼 인터페이스
│   │   │   ├── domain/            # 엔티티(VO)
│   │   │   └── dto/               # 요청/응답 DTO
│   │   ├── resources/
│   │   │   ├── mybatis/           # *.xml 매퍼 파일
│   │   │   ├── application.properties
│   │   │   └── sql/               # 초기 스키마/샘플 데이터
│   │   └── webapp/WEB-INF/jsp/    # JSP 뷰
│   └── test/java/...              # 테스트 코드
└── pom.xml
~~~

---

## 🗄 데이터베이스 스키마 (요약)

> 실제 컬럼은 `src/main/resources/sql/*.sql` 또는 매퍼 XML 참고

- `t_user` : 사용자(아이디/비번/이름/이메일/권한/상태)
- `t_project` : 프로젝트(제목/설명/상태/생성자/기간)
- `project_user` : **프로젝트-사용자 매핑(M:N)**, 역할/초대상태
- `schedule` : 일정(프로젝트ID/제목/시작~종료/담당자/상태/반복)
- *(선택)* `inbox` : 알림(타입/대상자/읽음여부/관련ID)

---

## ⚙️ 실행 방법

### 1) DB 준비

1) Oracle 19c 이상 구동  
2) 사용자/스키마 생성 후 접속 정보 확인  
3) 초기 스키마 실행

~~~sql
-- 예시 (경로는 환경에 맞게 조정)
@src/main/resources/sql/schema.sql
@src/main/resources/sql/sample-data.sql
~~~

### 2) 애플리케이션 설정

`src/main/resources/application.properties`

~~~properties
spring.datasource.url=jdbc:oracle:thin:@localhost:1521:xe   # ← 환경에 맞게
spring.datasource.username=YOUR_USER
spring.datasource.password=YOUR_PASS
mybatis.mapper-locations=classpath:mybatis/*.xml

spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
server.port=8080
~~~

### 3) 빌드 & 실행

~~~bash
# Maven 빌드
mvn clean package

# 방법 A) 개발용 실행
mvn spring-boot:run

# 방법 B) 패키지 실행
java -jar target/bizboard-*.jar
~~~

---

## 📱 주요 엔드포인트(예시)

~~~text
# Auth
POST   /auth/login                # 로그인
POST   /auth/logout               # 로그아웃
POST   /auth/signup               # 회원가입
DELETE /auth/withdraw             # 회원탈퇴

# Project
GET    /projects                  # 프로젝트 목록
POST   /projects                  # 생성
GET    /projects/{id}             # 상세
PUT    /projects/{id}             # 수정
DELETE /projects/{id}             # 삭제
POST   /projects/{id}/members     # 멤버 초대/추가

# Schedule
GET    /projects/{id}/schedules
POST   /projects/{id}/schedules
PUT    /schedules/{scheduleId}
DELETE /schedules/{scheduleId}

# Inbox
GET    /inbox                     # 내 알림 목록
PUT    /inbox/{id}/read           # 읽음 처리
~~~

---

## 🔀 브랜치 & 커밋 규칙(예시)

- 브랜치: `ft-<기능>`, `fix-<이슈>`, `hotfix-<긴급>`  
  예) `ft-inbox`, `ft-account`, `fix-schedule-timezone`
- 커밋: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`

---

## 🤝 기여 방법

~~~text
1) Fork
2) 기능 브랜치 생성: git checkout -b ft-awesome
3) 커밋: git commit -m "feat: add awesome"
4) 푸시: git push origin ft-awesome
5) PR 생성
~~~

---

## 📄 라이선스

이 프로젝트는 **MIT License**를 따릅니다.

---

## 📬 문의

이슈 탭에 등록해 주세요. (관리자/연락처는 필요 시 추가)
