CREATE DATABASE project;
USE project;

-- Bảng products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    sku_code VARCHAR(50) NOT NULL UNIQUE,
    category VARCHAR(100) NOT NULL,
    manufacture_date DATE,
    CHECK (manufacture_date < CURRENT_DATE)
);

-- Bảng employees
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    performance_score DECIMAL(2,1) DEFAULT 5.0,
    CHECK (performance_score BETWEEN 0.0 AND 5.0)
);

-- Bảng stock_orders
CREATE TABLE stock_orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    employee_id INT,
    order_time DATETIME NOT NULL,
    quantity INT CHECK (quantity > 0),
    status ENUM('Pending', 'Completed', 'Cancelled'),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Bảng order_details
CREATE TABLE order_details (
    detail_id INT PRIMARY KEY,
    order_id INT,
    storage_zone VARCHAR(100) NOT NULL,
    condition_check VARCHAR(255) NOT NULL,
    handling_method TEXT,
    detail_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES stock_orders(order_id)
);

-- Bảng transaction_logs
CREATE TABLE transaction_logs (
    log_id INT PRIMARY KEY,
    detail_id INT,
    employee_id INT,
    log_time DATETIME NOT NULL,
    note TEXT,
    FOREIGN KEY (detail_id) REFERENCES order_details(detail_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);


-- PHẦN 2: DML
-- INSERT products
INSERT INTO products
VALUES
(1, 'Laptop Dell XPS', 'DELL01', 'Điện tử', '2023-12-03'),
(2, 'Bàn phím cơ', 'KEY02', 'Phụ kiện', '1996-11-25'),
(3, 'Chuột Logitech', 'LOG03', 'Phụ kiện', '2001-07-08'),
(4, 'Màn hình LG 27 inch', 'LG04', 'Điện tử', '1998-01-19'),
(5, 'Tai nghe Sony', 'SONY05', 'Âm thanh', '2000-09-30');

-- INSERT employees
INSERT INTO employees
VALUES
(1, 'Nguyễn Văn Hải', 'Chủ kho', '0931112223', 4.8),
(2, 'Trần Thu Hà', 'Thủ kho', '0932223334', 5.0),
(3, 'Lê Quốc Tuấn', 'Tài xế', '0933334445', 4.6),
(4, 'Phạm Minh Châu', 'Kiểm kê', '0934445556', 4.9),
(5, 'Hoàng Gia Bảo', 'Thủ kho', '0935556667', 4.7);

-- INSERT stock_orders
INSERT INTO stock_orders
VALUES
(7001, 1, 1, '2024-05-20 08:00:00', 200, 'Pending'),
(7002, 2, 2, '2024-05-20 09:30:00', 250, 'Completed'),
(7003, 3, 3, '2024-05-20 10:15:00', 300, 'Pending'),
(7004, 4, 5, '2024-05-21 07:00:00', 350, 'Completed'),
(7005, 5, 4, '2024-05-21 08:45:00', 220, 'Cancelled');

-- INSERT order_details
INSERT INTO order_details
VALUES
(8001, 7002, 'Khu A1', 'Bao bì nguyên vẹn', 'Nhập kho', '2024-05-20 10:00:00'),
(8002, 7004, 'Khu B2', 'Thùng móp nhẹ', 'Kiểm tra kỹ + Nhập', '2024-05-21 08:00:00'),
(8003, 7001, 'Khu C1', 'Đang tháo dỡ', 'Phân loại', '2024-05-20 09:00:00'),
(8004, 7003, 'Khu A2', 'Chờ xe nâng', 'Sắp xếp pallet', '2024-05-20 11:00:00'),
(8005, 7005, 'Khu D1', 'Sai mã hàng', 'Trả về NCC', '2024-05-21 09:00:00');

-- INSERT transaction_logs
INSERT INTO transaction_logs
VALUES
(1, 8003, 1, '2024-05-20 09:05:00', 'Bắt đầu dỡ hàng'),
(2, 8001, 2, '2024-05-20 10:05:00', 'Hoàn tất nhập kho'),
(3, 8004, 3, '2024-05-20 11:10:00', 'Đang vận chuyển nội bộ'),
(4, 8002, 5, '2024-05-21 08:10:00', 'Chờ phê duyệt ngoại lệ'),
(5, 8005, 4, '2024-05-21 09:05:00', 'Hủy do sai mã');


-- UPDATE
UPDATE stock_orders so
JOIN products p
ON so.product_id = p.product_id
SET so.quantity = so.quantity * 1.1
WHERE so.status = 'Completed'
AND YEAR(p.manufacture_date) < 2000;


-- DELETE
DELETE FROM transaction_logs
WHERE log_time < '2024-05-20';

-- PHẦN 3: TRUY VẤN CƠ BẢN
-- Câu 1
SELECT full_name, role, performance_score
FROM employees
WHERE performance_score > 4.7
OR role = 'Thủ kho';

-- Câu 2
SELECT product_name, sku_code
FROM products
WHERE manufacture_date BETWEEN '1998-01-01' AND '2001-12-31'
AND sku_code LIKE 'L%';

-- Câu 3
SELECT order_id, order_time, quantity
FROM stock_orders
ORDER BY quantity DESC
LIMIT 2 OFFSET 2;

-- TRUY VẤN NÂNG CAO
-- Câu 1
SELECT 
    p.product_name,
    e.full_name,
    e.role,
    so.quantity,
    so.order_time
FROM stock_orders so
JOIN products p
ON so.product_id = p.product_id
JOIN employees e
ON so.employee_id = e.employee_id;

-- Câu 2
SELECT 
    e.full_name,
    SUM(so.quantity) AS total_quantity
FROM employees e
JOIN stock_orders so
ON e.employee_id = so.employee_id
WHERE so.status = 'Completed'
GROUP BY e.employee_id, e.full_name
HAVING SUM(so.quantity) > 500;

-- Câu 3
SELECT employee_id, full_name, performance_score
FROM employees
WHERE performance_score = (
    SELECT MAX(performance_score)
    FROM employees
);

-- PHẦN 5: INDEX & VIEW
-- INDEX
CREATE INDEX idx_status_quantity
ON stock_orders(status, quantity);

-- PHẦN 6: TRIGGER
DELIMITER $$

-- Trigger cập nhật Completed
CREATE TRIGGER trg_order_completed
AFTER UPDATE ON stock_orders
FOR EACH ROW
BEGIN
    IF NEW.status = 'Completed'
    AND OLD.status != 'Completed' THEN
        INSERT INTO transaction_logs (
            log_id,
            detail_id,
            employee_id,
            log_time,
            note
        )
        VALUES (
            (SELECT IFNULL(MAX(log_id),0) + 1 FROM transaction_logs),
            (SELECT detail_id FROM order_details WHERE order_id = NEW.order_id LIMIT 1),
            NEW.employee_id,
            NOW(),
            'Order completed'
        );
    END IF;
END $$
DELIMITER ;





