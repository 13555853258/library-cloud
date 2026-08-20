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
('reader','Reader@123','高思晗','13800000003','reader@library.com','READER');
INSERT INTO book_category(name,code,sort_no) VALUES ('计算机科学','CS',1),('文学小说','LITERATURE',2),('历史文化','HISTORY',3),('经济管理','ECONOMY',4),('自然科学','SCIENCE',5);
INSERT INTO publisher(name,address,contact_phone) VALUES ('人民邮电出版社','北京市丰台区','010-81055000'),('机械工业出版社','北京市西城区','010-88379000'),('清华大学出版社','北京市海淀区','010-62770175');
INSERT INTO book(isbn,title,category_id,publisher_id,author_name,publish_date,price,description,location,total_copies,available_copies,borrow_count) VALUES
('9787115428028','Java核心技术 卷I',1,1,'凯·S.霍斯特曼','2022-01-01',119.00,'系统讲解Java基础与核心技术','A区-01-01',5,3,28),
('9787111213826','深入理解计算机系统',1,2,'Randal E. Bryant','2021-03-01',139.00,'从程序员视角理解计算机系统','A区-01-02',4,2,36),
('9787302517597','数据库系统概论',1,3,'王珊、萨师煊','2019-06-01',59.00,'高等学校数据库课程经典教材','A区-02-01',6,5,45),
('9787020002207','红楼梦',2,1,'曹雪芹','2020-01-01',69.00,'中国古典文学名著','B区-01-01',8,6,53),
('9787544253994','百年孤独',2,1,'加西亚·马尔克斯','2017-08-01',55.00,'魔幻现实主义文学代表作','B区-01-02',5,4,41),
('9787101003048','史记',3,1,'司马迁','2018-11-01',88.00,'中国第一部纪传体通史','C区-01-01',4,4,19);
INSERT INTO book_copy(book_id,barcode,status,shelf_location) VALUES (1,'BK000001','BORROWED','A区-01-01'),(1,'BK000002','AVAILABLE','A区-01-01'),(1,'BK000003','AVAILABLE','A区-01-01'),(2,'BK000004','AVAILABLE','A区-01-02'),(3,'BK000005','AVAILABLE','A区-02-01'),(4,'BK000006','AVAILABLE','B区-01-01');
INSERT INTO reader(user_id,reader_no,reader_type,college,major,max_borrow_count,credit_score,expire_date) VALUES (3,'R20260001','STUDENT','软件学院','软件工程',5,100,'2028-07-01');
INSERT INTO borrow_rule(reader_type,max_count,borrow_days,max_renew_count,renew_days,daily_fine) VALUES ('STUDENT',5,30,2,15,0.50),('TEACHER',10,60,3,30,0.20);
INSERT INTO announcement(title,content,type,priority,publisher_id) VALUES ('欢迎使用智慧图书馆','系统已开放图书检索、借阅、预约和续借服务。','NOTICE',10,1),('暑假开放时间调整','暑假期间图书馆开放时间为每日9:00至17:00。','IMPORTANT',8,1);

