SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

CREATE DATABASE IF NOT EXISTS library_cloud
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE library_cloud;

CREATE TABLE sys_user (
  id BIGINT PRIMARY KEY AUTO_INCREMENT, username VARCHAR(50) NOT NULL UNIQUE, password VARCHAR(100) NOT NULL,
  real_name VARCHAR(50) NOT NULL, phone VARCHAR(20), email VARCHAR(100), avatar VARCHAR(255), role_code VARCHAR(30) NOT NULL,
  status TINYINT NOT NULL DEFAULT 1, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, deleted TINYINT NOT NULL DEFAULT 0
);
CREATE TABLE book_category (id BIGINT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(80) NOT NULL, code VARCHAR(30) NOT NULL UNIQUE, parent_id BIGINT DEFAULT 0, sort_no INT DEFAULT 0, status TINYINT DEFAULT 1, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, deleted TINYINT DEFAULT 0);
CREATE TABLE publisher (id BIGINT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(120) NOT NULL, address VARCHAR(200), contact_phone VARCHAR(20), status TINYINT DEFAULT 1, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, deleted TINYINT DEFAULT 0);
CREATE TABLE author (id BIGINT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(80) NOT NULL, country VARCHAR(50), introduction TEXT, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, deleted TINYINT DEFAULT 0);
CREATE TABLE book (
  id BIGINT PRIMARY KEY AUTO_INCREMENT, isbn VARCHAR(20) NOT NULL UNIQUE, title VARCHAR(150) NOT NULL, category_id BIGINT NOT NULL, publisher_id BIGINT,
  author_name VARCHAR(150) NOT NULL, publish_date DATE, price DECIMAL(10,2) DEFAULT 0, cover_url VARCHAR(255), description TEXT,
  location VARCHAR(100), total_copies INT NOT NULL DEFAULT 0, available_copies INT NOT NULL DEFAULT 0, borrow_count INT NOT NULL DEFAULT 0,
  status TINYINT NOT NULL DEFAULT 1, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, deleted TINYINT DEFAULT 0,
  CONSTRAINT fk_book_category FOREIGN KEY(category_id) REFERENCES book_category(id), CONSTRAINT fk_book_publisher FOREIGN KEY(publisher_id) REFERENCES publisher(id)
);
CREATE TABLE book_copy (id BIGINT PRIMARY KEY AUTO_INCREMENT, book_id BIGINT NOT NULL, barcode VARCHAR(50) NOT NULL UNIQUE, status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE', shelf_location VARCHAR(80), purchase_date DATE, price DECIMAL(10,2), created_at DATETIME DEFAULT CURRENT_TIMESTAMP, deleted TINYINT DEFAULT 0, CONSTRAINT fk_copy_book FOREIGN KEY(book_id) REFERENCES book(id));
CREATE TABLE reader (id BIGINT PRIMARY KEY AUTO_INCREMENT, user_id BIGINT NOT NULL UNIQUE, reader_no VARCHAR(30) NOT NULL UNIQUE, reader_type VARCHAR(20) DEFAULT 'STUDENT', college VARCHAR(100), major VARCHAR(100), max_borrow_count INT DEFAULT 5, credit_score INT DEFAULT 100, status TINYINT DEFAULT 1, expire_date DATE, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, deleted TINYINT DEFAULT 0);
CREATE TABLE borrow_record (id BIGINT PRIMARY KEY AUTO_INCREMENT, reader_id BIGINT NOT NULL, book_id BIGINT NOT NULL, copy_id BIGINT NOT NULL, borrow_time DATETIME NOT NULL, due_time DATETIME NOT NULL, return_time DATETIME, renew_count INT DEFAULT 0, status VARCHAR(20) NOT NULL DEFAULT 'BORROWED', operator_id BIGINT, remark VARCHAR(255), created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, INDEX idx_borrow_reader(reader_id), INDEX idx_borrow_due(due_time));
CREATE TABLE reservation (id BIGINT PRIMARY KEY AUTO_INCREMENT, reader_id BIGINT NOT NULL, book_id BIGINT NOT NULL, queue_no INT DEFAULT 1, reserve_time DATETIME DEFAULT CURRENT_TIMESTAMP, expire_time DATETIME, status VARCHAR(20) DEFAULT 'WAITING', notified TINYINT DEFAULT 0, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP);
CREATE TABLE fine_record (id BIGINT PRIMARY KEY AUTO_INCREMENT, borrow_id BIGINT NOT NULL, reader_id BIGINT NOT NULL, fine_type VARCHAR(20) DEFAULT 'OVERDUE', amount DECIMAL(10,2) NOT NULL, paid_amount DECIMAL(10,2) DEFAULT 0, status VARCHAR(20) DEFAULT 'UNPAID', paid_time DATETIME, created_at DATETIME DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE book_favorite (id BIGINT PRIMARY KEY AUTO_INCREMENT, reader_id BIGINT NOT NULL, book_id BIGINT NOT NULL, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, UNIQUE KEY uk_favorite(reader_id, book_id));
CREATE TABLE announcement (id BIGINT PRIMARY KEY AUTO_INCREMENT, title VARCHAR(150) NOT NULL, content TEXT NOT NULL, type VARCHAR(30) DEFAULT 'NOTICE', priority INT DEFAULT 0, publisher_id BIGINT, status TINYINT DEFAULT 1, publish_time DATETIME DEFAULT CURRENT_TIMESTAMP, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, deleted TINYINT DEFAULT 0);
CREATE TABLE borrow_rule (id BIGINT PRIMARY KEY AUTO_INCREMENT, reader_type VARCHAR(20) NOT NULL UNIQUE, max_count INT NOT NULL, borrow_days INT NOT NULL, max_renew_count INT NOT NULL, renew_days INT NOT NULL, daily_fine DECIMAL(10,2) NOT NULL, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP);
CREATE TABLE operation_log (id BIGINT PRIMARY KEY AUTO_INCREMENT, user_id BIGINT, username VARCHAR(50), module VARCHAR(50), operation VARCHAR(100), method VARCHAR(200), request_uri VARCHAR(255), ip VARCHAR(50), success TINYINT DEFAULT 1, cost_ms BIGINT DEFAULT 0, created_at DATETIME DEFAULT CURRENT_TIMESTAMP);

INSERT INTO sys_user(username,password,real_name,phone,email,role_code) VALUES
('admin','Admin@123','系统管理员','13800000001','admin@library.com','ADMIN'),
('librarian','Library@123','图书管理员','13800000002','librarian@library.com','LIBRARIAN'),
('reader','Reader@123','高思晗','13800000003','reader@library.com','READER'),
('reader02','Reader@123','李明','13800000004','reader02@library.com','READER'),
('reader03','Reader@123','王芳','13800000005','reader03@library.com','READER'),
('reader04','Reader@123','张伟','13800000006','reader04@library.com','READER'),
('reader05','Reader@123','刘洋','13800000007','reader05@library.com','READER'),
('reader06','Reader@123','陈晨','13800000008','reader06@library.com','READER'),
('reader07','Reader@123','赵敏','13800000009','reader07@library.com','READER'),
('reader08','Reader@123','周杰','13800000010','reader08@library.com','READER'),
('reader09','Reader@123','孙悦','13800000011','reader09@library.com','READER'),
('reader10','Reader@123','吴桐','13800000012','reader10@library.com','READER'),
('reader11','Reader@123','郑欣','13800000013','reader11@library.com','READER'),
('reader12','Reader@123','冯宇','13800000014','reader12@library.com','READER'),
('reader13','Reader@123','褚涵','13800000015','reader13@library.com','READER'),
('reader14','Reader@123','蒋宁','13800000016','reader14@library.com','READER'),
('reader15','Reader@123','沈佳','13800000017','reader15@library.com','READER'),
('reader16','Reader@123','韩雪','13800000018','reader16@library.com','READER');
INSERT INTO book_category(name,code,sort_no) VALUES ('计算机科学','CS',1),('文学小说','LITERATURE',2),('历史文化','HISTORY',3),('经济管理','ECONOMY',4),('自然科学','SCIENCE',5);
INSERT INTO publisher(name,address,contact_phone) VALUES ('人民邮电出版社','北京市丰台区','010-81055000'),('机械工业出版社','北京市西城区','010-88379000'),('清华大学出版社','北京市海淀区','010-62770175');
INSERT INTO book(isbn,title,category_id,publisher_id,author_name,publish_date,price,description,location,total_copies,available_copies,borrow_count) VALUES
('9787115428028','Java核心技术 卷I',1,1,'凯·S.霍斯特曼','2022-01-01',119.00,'系统讲解Java基础与核心技术','A区-01-01',5,3,28),
('9787111213826','深入理解计算机系统',1,2,'Randal E. Bryant','2021-03-01',139.00,'从程序员视角理解计算机系统','A区-01-02',4,2,36),
('9787302517597','数据库系统概论',1,3,'王珊、萨师煊','2019-06-01',59.00,'高等学校数据库课程经典教材','A区-02-01',6,5,45),
('9787020002207','红楼梦',2,1,'曹雪芹','2020-01-01',69.00,'中国古典文学名著','B区-01-01',8,6,53),
('9787544253994','百年孤独',2,1,'加西亚·马尔克斯','2017-08-01',55.00,'魔幻现实主义文学代表作','B区-01-02',5,4,41),
('9787101003048','史记',3,1,'司马迁','2018-11-01',88.00,'中国第一部纪传体通史','C区-01-01',4,4,19),
('9787111407010','算法导论',1,2,'托马斯·科尔曼','2013-01-01',128.00,'系统介绍算法设计与分析方法','A区-02-02',5,4,32),
('9787115546081','Python编程：从入门到实践',1,1,'埃里克·马瑟斯','2020-10-01',109.80,'面向初学者的Python编程实践教程','A区-02-03',6,5,27),
('9787302581208','软件工程：实践者的研究方法',1,3,'Roger S. Pressman','2021-07-01',89.00,'系统讲解软件工程过程与实践','A区-03-01',4,4,18),
('9787530215593','活着',2,1,'余华','2017-06-01',35.00,'讲述普通人在时代变迁中的生命故事','B区-02-01',7,6,46),
('9787532747993','一九八四',2,1,'乔治·奥威尔','2009-06-01',29.00,'反乌托邦文学经典作品','B区-02-02',5,5,34),
('9787101065525','中国通史',3,3,'吕思勉','2015-01-01',68.00,'系统梳理中国历史发展脉络','C区-01-02',4,3,22),
('9787301204689','全球通史',3,3,'斯塔夫里阿诺斯','2012-02-01',96.00,'从全球视角讲述人类文明进程','C区-02-01',4,4,25),
('9787301256909','经济学原理',4,3,'N.格里高利·曼昆','2015-05-01',88.00,'经济学基础理论经典教材','D区-01-01',5,4,30),
('9787535732309','时间简史',5,1,'史蒂芬·霍金','2018-01-01',45.00,'通俗介绍宇宙、时间与空间理论','E区-01-01',6,5,38);
INSERT INTO book_copy(book_id,barcode,status,shelf_location) VALUES (1,'BK000001','BORROWED','A区-01-01'),(1,'BK000002','AVAILABLE','A区-01-01'),(1,'BK000003','AVAILABLE','A区-01-01'),(2,'BK000004','AVAILABLE','A区-01-02'),(3,'BK000005','AVAILABLE','A区-02-01'),(4,'BK000006','AVAILABLE','B区-01-01');
INSERT INTO book_copy(book_id,barcode,status,shelf_location) SELECT id,'BK000007','BORROWED','A区-02-02' FROM book WHERE isbn='9787111407010';
INSERT INTO book_copy(book_id,barcode,status,shelf_location) SELECT id,'BK000008','AVAILABLE','A区-02-03' FROM book WHERE isbn='9787115546081';
INSERT INTO book_copy(book_id,barcode,status,shelf_location) SELECT id,'BK000009','BORROWED','A区-03-01' FROM book WHERE isbn='9787302581208';
INSERT INTO book_copy(book_id,barcode,status,shelf_location) SELECT id,'BK000010','AVAILABLE','B区-02-01' FROM book WHERE isbn='9787530215593';
INSERT INTO book_copy(book_id,barcode,status,shelf_location) SELECT id,'BK000011','AVAILABLE','B区-02-02' FROM book WHERE isbn='9787532747993';
INSERT INTO book_copy(book_id,barcode,status,shelf_location) SELECT id,'BK000012','BORROWED','C区-01-02' FROM book WHERE isbn='9787101065525';
INSERT INTO book_copy(book_id,barcode,status,shelf_location) SELECT id,'BK000013','AVAILABLE','C区-02-01' FROM book WHERE isbn='9787301204689';
INSERT INTO book_copy(book_id,barcode,status,shelf_location) SELECT id,'BK000014','BORROWED','D区-01-01' FROM book WHERE isbn='9787301256909';
INSERT INTO book_copy(book_id,barcode,status,shelf_location) SELECT id,'BK000015','AVAILABLE','E区-01-01' FROM book WHERE isbn='9787535732309';
INSERT INTO reader(user_id,reader_no,reader_type,college,major,max_borrow_count,credit_score,expire_date)
SELECT id,'R20260001','STUDENT','软件学院','软件工程',5,100,'2028-07-01' FROM sys_user WHERE username='reader'
UNION ALL SELECT id,'R20260002','STUDENT','计算机科学与工程学院','计算机科学与技术',5,96,'2028-07-01' FROM sys_user WHERE username='reader02'
UNION ALL SELECT id,'R20260003','STUDENT','软件学院','信息安全',5,92,'2028-07-01' FROM sys_user WHERE username='reader03'
UNION ALL SELECT id,'R20260004','STUDENT','信息科学与工程学院','人工智能',5,88,'2028-07-01' FROM sys_user WHERE username='reader04'
UNION ALL SELECT id,'R20260005','STUDENT','自动化学院','自动化',5,95,'2028-07-01' FROM sys_user WHERE username='reader05'
UNION ALL SELECT id,'R20260006','STUDENT','理学院','数学与应用数学',5,90,'2028-07-01' FROM sys_user WHERE username='reader06'
UNION ALL SELECT id,'R20260007','STUDENT','文法学院','行政管理',5,86,'2028-07-01' FROM sys_user WHERE username='reader07'
UNION ALL SELECT id,'R20260008','STUDENT','工商管理学院','工商管理',5,98,'2028-07-01' FROM sys_user WHERE username='reader08'
UNION ALL SELECT id,'R20260009','STUDENT','机械工程与自动化学院','机械工程',5,82,'2028-07-01' FROM sys_user WHERE username='reader09'
UNION ALL SELECT id,'R20260010','STUDENT','软件学院','软件工程',5,93,'2028-07-01' FROM sys_user WHERE username='reader10'
UNION ALL SELECT id,'R20260011','TEACHER','计算机科学与工程学院','计算机应用技术',10,100,'2030-07-01' FROM sys_user WHERE username='reader11'
UNION ALL SELECT id,'R20260012','STUDENT','资源与土木工程学院','土木工程',5,84,'2028-07-01' FROM sys_user WHERE username='reader12'
UNION ALL SELECT id,'R20260013','STUDENT','外国语学院','英语',5,89,'2028-07-01' FROM sys_user WHERE username='reader13'
UNION ALL SELECT id,'R20260014','TEACHER','软件学院','软件工程',10,99,'2030-07-01' FROM sys_user WHERE username='reader14'
UNION ALL SELECT id,'R20260015','STUDENT','医学与生物信息工程学院','生物医学工程',5,78,'2028-07-01' FROM sys_user WHERE username='reader15'
UNION ALL SELECT id,'R20260016','STUDENT','艺术学院','视觉传达设计',5,91,'2028-07-01' FROM sys_user WHERE username='reader16';
INSERT INTO borrow_record(reader_id,book_id,copy_id,borrow_time,due_time,return_time,renew_count,status,operator_id,remark)
SELECT r.id,bc.book_id,bc.id,NOW()-INTERVAL 10 DAY,NOW()+INTERVAL 20 DAY,NULL,0,'BORROWED',1,'DEMO-BORROW-001' FROM reader r JOIN book_copy bc ON bc.barcode='BK000001' WHERE r.reader_no='R20260001';
INSERT INTO borrow_record(reader_id,book_id,copy_id,borrow_time,due_time,return_time,renew_count,status,operator_id,remark)
SELECT r.id,bc.book_id,bc.id,NOW()-INTERVAL 50 DAY,NOW()-INTERVAL 20 DAY,NOW()-INTERVAL 18 DAY,0,'RETURNED',1,'DEMO-BORROW-002' FROM reader r JOIN book_copy bc ON bc.barcode='BK000004' WHERE r.reader_no='R20260002';
INSERT INTO borrow_record(reader_id,book_id,copy_id,borrow_time,due_time,return_time,renew_count,status,operator_id,remark)
SELECT r.id,bc.book_id,bc.id,NOW()-INTERVAL 45 DAY,NOW()-INTERVAL 15 DAY,NULL,0,'BORROWED',1,'DEMO-BORROW-003' FROM reader r JOIN book_copy bc ON bc.barcode='BK000007' WHERE r.reader_no='R20260003';
INSERT INTO borrow_record(reader_id,book_id,copy_id,borrow_time,due_time,return_time,renew_count,status,operator_id,remark)
SELECT r.id,bc.book_id,bc.id,NOW()-INTERVAL 36 DAY,NOW()-INTERVAL 6 DAY,NOW()-INTERVAL 8 DAY,1,'RETURNED',1,'DEMO-BORROW-004' FROM reader r JOIN book_copy bc ON bc.barcode='BK000008' WHERE r.reader_no='R20260004';
INSERT INTO borrow_record(reader_id,book_id,copy_id,borrow_time,due_time,return_time,renew_count,status,operator_id,remark)
SELECT r.id,bc.book_id,bc.id,NOW()-INTERVAL 60 DAY,NOW()-INTERVAL 30 DAY,NOW()-INTERVAL 20 DAY,0,'OVERDUE_RETURNED',1,'DEMO-BORROW-005' FROM reader r JOIN book_copy bc ON bc.barcode='BK000010' WHERE r.reader_no='R20260005';
INSERT INTO borrow_record(reader_id,book_id,copy_id,borrow_time,due_time,return_time,renew_count,status,operator_id,remark)
SELECT r.id,bc.book_id,bc.id,NOW()-INTERVAL 6 DAY,NOW()+INTERVAL 24 DAY,NULL,0,'BORROWED',1,'DEMO-BORROW-006' FROM reader r JOIN book_copy bc ON bc.barcode='BK000009' WHERE r.reader_no='R20260006';
INSERT INTO borrow_record(reader_id,book_id,copy_id,borrow_time,due_time,return_time,renew_count,status,operator_id,remark)
SELECT r.id,bc.book_id,bc.id,NOW()-INTERVAL 25 DAY,NOW()+INTERVAL 5 DAY,NOW()-INTERVAL 3 DAY,0,'RETURNED',1,'DEMO-BORROW-007' FROM reader r JOIN book_copy bc ON bc.barcode='BK000011' WHERE r.reader_no='R20260007';
INSERT INTO borrow_record(reader_id,book_id,copy_id,borrow_time,due_time,return_time,renew_count,status,operator_id,remark)
SELECT r.id,bc.book_id,bc.id,NOW()-INTERVAL 12 DAY,NOW()+INTERVAL 18 DAY,NULL,1,'BORROWED',1,'DEMO-BORROW-008' FROM reader r JOIN book_copy bc ON bc.barcode='BK000012' WHERE r.reader_no='R20260008';
INSERT INTO borrow_record(reader_id,book_id,copy_id,borrow_time,due_time,return_time,renew_count,status,operator_id,remark)
SELECT r.id,bc.book_id,bc.id,NOW()-INTERVAL 42 DAY,NOW()-INTERVAL 12 DAY,NOW()-INTERVAL 15 DAY,0,'RETURNED',1,'DEMO-BORROW-009' FROM reader r JOIN book_copy bc ON bc.barcode='BK000013' WHERE r.reader_no='R20260009';
INSERT INTO borrow_record(reader_id,book_id,copy_id,borrow_time,due_time,return_time,renew_count,status,operator_id,remark)
SELECT r.id,bc.book_id,bc.id,NOW()-INTERVAL 3 DAY,NOW()+INTERVAL 27 DAY,NULL,0,'BORROWED',1,'DEMO-BORROW-010' FROM reader r JOIN book_copy bc ON bc.barcode='BK000014' WHERE r.reader_no='R20260010';
INSERT INTO borrow_record(reader_id,book_id,copy_id,borrow_time,due_time,return_time,renew_count,status,operator_id,remark)
SELECT r.id,bc.book_id,bc.id,NOW()-INTERVAL 32 DAY,NOW()-INTERVAL 2 DAY,NOW()-INTERVAL 4 DAY,0,'RETURNED',1,'DEMO-BORROW-011' FROM reader r JOIN book_copy bc ON bc.barcode='BK000015' WHERE r.reader_no='R20260011';
INSERT INTO borrow_rule(reader_type,max_count,borrow_days,max_renew_count,renew_days,daily_fine) VALUES ('STUDENT',5,30,2,15,0.50),('TEACHER',10,60,3,30,0.20);
INSERT INTO announcement(title,content,type,priority,publisher_id) VALUES ('欢迎使用智慧图书馆','系统已开放图书检索、借阅、预约和续借服务。','NOTICE',10,1),('暑假开放时间调整','暑假期间图书馆开放时间为每日9:00至17:00。','IMPORTANT',8,1);

