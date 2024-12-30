-- LIBRARY MANAGEMENT SYSTEM

-- create branch table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
branch_id VARCHAR(10) PRIMARY KEY,
manager_id VARCHAR(10),
branch_address VARCHAR(55),
contact_no VARCHAR(20)
);


DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
emp_id VARCHAR(10) PRIMARY KEY,
emp_name VARCHAR(25),
position VARCHAR(15),
salary INT,
branch_id VARCHAR(25) -- FK
);


DROP TABLE IF EXISTS books;
CREATE TABLE books
(
isbn VARCHAR(20) PRIMARY KEY,
book_title VARCHAR(75),
category VARCHAR(15),	
rental_price	FLOAT,
status	VARCHAR(15),
author	VARCHAR(35),
publisher VARCHAR(55)
);


DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
issued_id	VARCHAR(10) PRIMARY KEY,
issued_member_id	VARCHAR(10), -- FK
issued_book_name	VARCHAR(75),
issued_date	DATE,
issued_book_isbn	VARCHAR(25), -- FK
issued_emp_id VARCHAR(10) -- FK
);


DROP TABLE IF EXISTS members;
CREATE TABLE members
(
member_id	VARCHAR(10) PRIMARY KEY,
member_name	VARCHAR(25),
member_address	VARCHAR(75),
reg_date date
);


DROP TABLE IF EXISTS return_status;
 CREATE TABLE return_status(
 return_id		VARCHAR(10) PRIMARY KEY,
 issued_id	VARCHAR(10),
 return_book_name	VARCHAR(75),	
 return_date	date,
 return_book_isbn	VARCHAR(20) 
 );
 
 --  adding foregin key
 ALTER TABLE issued_status
 ADD CONSTRAINT fk_members
 FOREIGN KEY (issued_member_id)
 REFERENCES members(member_id);
 
 ALTER TABLE issued_status
 ADD CONSTRAINT fk_books
 FOREIGN KEY (issued_book_isbn)
 REFERENCES books(isbn);
 
 ALTER TABLE issued_status
 ADD CONSTRAINT fk_employees
 FOREIGN KEY (issued_emp_id)
 REFERENCES employees(emp_id);
 
  ALTER TABLE employees
 ADD CONSTRAINT fk_branch
 FOREIGN KEY (branch_id)
 REFERENCES branch(branch_id);
 
  ALTER TABLE return_status
 ADD CONSTRAINT fk_issued_status
 FOREIGN KEY (issued_id)
 REFERENCES issued_status(issued_id);
 
 ALTER TABLE branch
 MODIFY COLUMN contact_no VARCHAR(20);
 
  ALTER TABLE books
 MODIFY COLUMN category VARCHAR(20);
 
-- Task 1: Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
-- Task 2: Update an Existing Member's Address
-- Task 3: Delete a Record from the Issued Status Table Objective: Delete the record with issued_id = 'IS134' from the issued_status table.
-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
-- Task 6: Create Summary Tables : Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
-- Task 7: Retrieve All Books in a Specific Category
-- Task 8: Find Total Rental Income by Category
-- Task 9: List Members Who Registered in the Last 180 Days
-- Task 10: List Employees with Their Branch Manager's Name and their branch details
-- Task 11: Create a Table of Books with Rental Price Above a Certain Threshold
-- Task 12: Retrieve the List of Books Not Yet Returned
 

-- 1.
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUE (
'978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'
);

-- 2.
UPDATE members
SET member_address= "321 Main St"
WHERE member_id="C101";
SELECT * FROM members;

-- 3.
DELETE FROM issued_status
WHERE issued_id="IS134";

-- 4.
SELECT * FROM employees
WHERE emp_id="E101";

-- 5.
 SELECT issued_emp_id,COUNT(*)
 FROM issued_status
 GROUP BY 1
HAVING COUNT(*) >1;
 
 -- 6.
CREATE TABLE book_issued_count AS
SELECT 
    b.isbn,
    b.book_title,
    COUNT(ist.issued_id) AS no_issued
FROM 
    books AS b
JOIN 
    issued_status AS ist
ON 
    ist.issued_book_isbn = b.isbn
GROUP BY 
    b.isbn, b.book_title;
SELECT * FROM book_issued_count;

-- 7.
SELECT * FROM books
WHERE category="Classic";

-- 8.
SELECT 
    b.category,SUM(b.rental_price),COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY b.category;

-- 9.
SELECT * FROM members
WHERE reg_date  >= current_date - interval 180 DAY;

-- 10.
SELECT 
e1.emp_id,
e1.emp_name,
e1.position,
e1.salary,
b.*,
e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id=b.branch_id
Join 
employees as e2
ON e2.emp_id=b.manager_id;

-- 11.
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price >7.00;

-- 12. 
SELECT * FROM issued_status as isu
LEFT JOIN
return_status as ret
ON 
ret.issued_id=isu.issued_id
WHERE ret.return_id IS NULL;