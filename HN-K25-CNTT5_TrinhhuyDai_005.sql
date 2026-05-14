CREATE DATABASE project;
USE project;

CREATE TABLE products(
product_id VARCHAR(50)PRIMARY KEY,
product_name VARCHAR(50)NOT NULL,
sku_code VARCHAR(50)NOT NULL UNIQUE,
category VARCHAR(50)NOT NULL,
manufacture_date DATE
);

CREATE TABLE employees (
employee_id VARCHAR(50) PRIMARY KEY,
full_name VARCHAR(50)NOT NULL,
role VARCHAR(50)NOT NULL,
phone_number VARCHAR(50)NOT NULL UNIQUE,
performance_score DECIMAL(10,2) 
);

CREATE TABLE stock_orders (
order_id VARCHAR(50) PRIMARY KEY,
product_id VARCHAR(50),
employee_id VARCHAR(50),
order_time DATETIME NOT NULL,
quantity VARCHAR(50) CHECK (quantity > 0), 
status ERUM('Pending', 'Completed', 'Cancelled'),
FOREIGN KEY (product_id) REFERENCES products(id),
FOREIGN KEY (employee_id) REFERENCES employees(id)
); 

CREATE TABLE transaction_logs (
log_id VARCHAR(50) PRIMARY KEY,
detail_id VARCHAR(100) NOT NULL,
employee_id VARCHAR(50) NOT NULL,
log_time DATETIME NOT NULL,
NOTE TEXT,
FOREIGN KEY (detail_id) REFERENCES order_Details(id),
FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE TABLE order_details(
detail_id VARCHAR(50) PRIMARY KEY,
order_id VARCHAR(100),
storage_zone VARCHAR(50) NOT NULL,
condition_check VARCHAR(50) NOT NULL,
handling_method TEXT,
detail_date DATETIME
);

INSERT INTO products (product_id,product_name,sku_code,category,manufacture_date)
VALUES 
(1,'Laptop Dell XPS','DELL01','Điện tử','2023-12-03'),
(2,'Bàn phím cơ','KEY02','Phụ kiện','1996-11-25'),
(3,'Chuột Logitech','LOG03','Phụ kiện','2001-07-08'),
(4,'Màn hình LG 27 inch','LG04','Điện tử','1998-01-19'),
(5,'Tai nghe Sony','SONY05','Âm thanh','2000-09-30');

INSERT INTO employees (employee_id,full_name,role,phone_number,performance_score)
VALUES 
(1,'Nguyễn Văn Hải','Chủ kho','0931112223','4.8'),
(2,'Trần Thu Hà','Thủ kho','0932223334','5.0'),
(3,'Lê Quốc Tuấn','Tài xế','0933334445','4.6'),
(4,'Phạm Minh Châu','Kiểm kê','0935556667','4.9'),
(5,'Hoàng Gia Bảo','Thủ kho','0935556667','4.7');

INSERT INTO stock_orders (order_id,product_id,employee_id,order_time,quantity,status)
VALUES
(7001,1,1,'2024-05-20 08:00',200,'Pending'),
(7002,2,2,'2024-05-20 09:30',250,'Completed'),
(7003,3,3,'2024-05-20 10:15',300,'Pending'),
(7004,4,5,'2024-05-20 07:00',350,'Completed'),
(7005,5,4,'2024-05-20 08:45',220,'Cancelled');

INSERT INTO order_details (detail_id,order_id,storage_zone,condition_check,handling_method,detail_date)
VALUES
(8001,7002,'Khu A1','Bao bì nguyên vẹn','Nhập kho','2024-05-20 10:00'),
(8002,7004,'Khu B2','Thùng móp nhẹ','Kiểm tra kỹ + Nhập','2024-05-21 8:00'),
(8003,7001,'Khu C1','Đang tháo dỡ','Phân loại','2024-05-20 9:00'),
(8004,7003,'Khu A2','Chờ xe nâng','Sắp xếp pallet','2024-05-20 11:00'),
(8005,7005,'Khu D1','Sai mã hàng','Trả về NCC','2024-05-21 09:00');

INSERT INTO transaction_logs (log_id,detail_id,employee_id,log_time,note)
VALUES
(1,8003,1,'2024-05-20 09:05','Bắt đầu dỡ hàng'),
(2,8001,2,'2024-05-20 10:05','Hoàn tất nhập kho'),
(3,8004,3,'2024-05-20 11:10','Đang vận chuyển nội bộ'),
(4,8002,4,'2024-05-21 08:10','Chờ phê duyệt ngoại lệ'),
(5,8005,5,'2024-05-21 09:05','Hủy do sai mã');

-- Update
UPDATE stock_orders 
SET quantity = quantity * 1.1
WHERE 

-- Delete
DELETE FROM transaction_logs
WHERE log_time < 20/05/2024
-- Phần 3:
-- câu 1:
SELECT full_name
FROM employees 
WHERE erformance_score > 4.7
-- câu 2:
SELECT * FROM