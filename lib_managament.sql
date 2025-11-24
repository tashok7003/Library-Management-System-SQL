create database lib;
use lib;


-- Table: tbl_publisher
CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress TEXT,
    publisher_PublisherPhone VARCHAR(15)
);

select * from tbl_publisher;


-- Table: tbl_book
CREATE TABLE tbl_book (
    book_BookID INT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
);

select * from tbl_book;

-- Table: tbl_book_authors
CREATE TABLE tbl_book_authors (
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
);

select * from tbl_book_authors;



-- Table: tbl_library_branch
CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress TEXT
);

select * from tbl_library_branch;

-- Table: tbl_book_copies
CREATE TABLE tbl_book_copies (
    book_copies_CopiesID INT PRIMARY KEY AUTO_INCREMENT,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
);

select * from tbl_book_copies;

-- Table: tbl_borrower
CREATE TABLE tbl_borrower (
    borrower_CardNo INT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress TEXT,
    borrower_BorrowerPhone VARCHAR(15)
);

select * from tbl_borrower;


-- Table: tbl_book_loans
CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE,
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID),
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
);

select * from tbl_book_loans;


-- Query 1: How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

SELECT 
    lb.library_branch_BranchName AS Branch_Name,
    b.book_Title AS Book_Title,
    bc.book_copies_No_Of_Copies AS Total_Copies
FROM 
    tbl_book_copies bc
JOIN 
    tbl_book b ON bc.book_copies_BookID = b.book_BookID
JOIN 
    tbl_library_branch lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE 
    b.book_Title = 'The Lost Tribe'
    AND lb.library_branch_BranchName = 'Sharpstown';
    
    
-- Query 2: How many copies of the book titled "The Lost Tribe" are owned by each library branch?

SELECT 
    lb.library_branch_BranchName AS Branch_Name,
    b.book_Title AS Book_Title,
    bc.book_copies_No_Of_Copies AS Total_Copies
FROM 
    tbl_book_copies bc
JOIN    
    tbl_book b ON bc.book_copies_BookID = b.book_BookID
JOIN 
    tbl_library_branch lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE 
    b.book_Title = 'The Lost Tribe';
    


-- Query 3: Retrieve the names of all borrowers who do not have any books checked out.

SELECT 
    br.borrower_BorrowerName AS Borrower_Name
FROM 
    tbl_borrower br
LEFT JOIN 
    tbl_book_loans bl ON br.borrower_CardNo = bl.book_loans_CardNo
WHERE 
    bl.book_loans_CardNo IS NULL;
    
    
-- Query 4: For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address.

select * from tbl_book_loans;

SELECT 
    b.book_Title AS Book_Title,
    br.borrower_BorrowerName AS Borrower_Name,
    br.borrower_BorrowerAddress AS Borrower_Address
FROM 
    tbl_book_loans bl
JOIN 
    tbl_book b ON bl.book_loans_BookID = b.book_BookID
JOIN 
    tbl_borrower br ON bl.book_loans_CardNo = br.borrower_CardNo
JOIN 
    tbl_library_branch lb ON bl.book_loans_BranchID = lb.library_branch_BranchID
WHERE 
    TRIM(lb.library_branch_BranchName) = 'Sharpstown'
    AND bl.book_loans_DueDate = '0002/03/18';
    
    
    
-- Query 5: For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

SELECT 
    lb.library_branch_BranchName AS Branch_Name,
    COUNT(bl.book_loans_LoansID) AS Total_Books_Loaned
FROM 
    tbl_library_branch lb
LEFT JOIN 
    tbl_book_loans bl ON lb.library_branch_BranchID = bl.book_loans_BranchID
GROUP BY 
    lb.library_branch_BranchName;
    
    
-- Query 6: Retrieve names, addresses, and number of books checked out for borrowers who have more than five books checked out.    
    
SELECT 
    br.borrower_BorrowerName AS Borrower_Name,
    br.borrower_BorrowerAddress AS Borrower_Address,
    COUNT(bl.book_loans_BookID) AS Books_Checked_Out
FROM 
    tbl_borrower br
JOIN 
    tbl_book_loans bl ON br.borrower_CardNo = bl.book_loans_CardNo
GROUP BY 
    br.borrower_CardNo, br.borrower_BorrowerName, br.borrower_BorrowerAddress
HAVING 
    COUNT(bl.book_loans_BookID) > 5;


-- Query 7: For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

SELECT 
    b.book_Title AS Book_Title,
    lb.library_branch_BranchName AS Branch_Name,
    bc.book_copies_No_Of_Copies AS Total_Copies
FROM 
    tbl_book b
JOIN 
    tbl_book_authors ba ON b.book_BookID = ba.book_authors_BookID
JOIN 
    tbl_book_copies bc ON b.book_BookID = bc.book_copies_BookID
JOIN 
    tbl_library_branch lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE 
    ba.book_authors_AuthorName = 'Stephen King'
    AND lb.library_branch_BranchName = 'Central';
