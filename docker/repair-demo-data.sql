SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

USE library_cloud;

UPDATE sys_user SET real_name = '系统管理员' WHERE username = 'admin';
UPDATE sys_user SET real_name = '图书管理员' WHERE username = 'librarian';
UPDATE sys_user SET real_name = '高思晗' WHERE username = 'reader';
