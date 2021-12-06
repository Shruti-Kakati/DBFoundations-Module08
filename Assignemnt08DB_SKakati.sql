--*************************************************************************--
-- Title: Assignment08
-- Author: Shruti Kakati
-- Desc: This file demonstrates how to use Stored Procedures
-- Change Log:
-- 2021-12-6 - Shruti Kakati - Created Database
-- 2021-12-6 - Shruti Kakati - Created Tables - (Categories, Products, Inventories, Employees)
-- 2021-12-6 - Shruti Kakati - Created Views for tables (Categories, Products, Inventories, Employees)
-- 2021-12-6 - Shruti Kakati - Created and Executed Stored Procedure to Insert, Update, Delete data from tables 
--                             (Categories, Products, Inventories, Employees)
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment08DB_ShrutiKakati')
	 Begin 
	  Alter Database [Assignment08DB_ShrutiKakati] set Single_user With Rollback Immediate;
	  Drop Database Assignment08DB_ShrutiKakati;
	 End
	Create Database Assignment08DB_ShrutiKakati;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment08DB_ShrutiKakati;


-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
-- NOTE: We are starting without data this time!

-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, [Count] From dbo.Inventories;
go

/********************************* Questions and Answers *********************************/
/* NOTE:Use the following template to create your stored procedures and plan on this taking ~2-3 hours

Create Procedure <pTrnTableName>
 (<@P1 int = 0>)
 -- Author: <YourNameHere>
 -- Desc: Processes <Desc text>
 -- Change Log: When,Who,What
 -- <2017-01-01>,<Your Name Here>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	-- Transaction Code --
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
*/

-- Question 1 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Categories table?
--Create Procedure pInsCategories

Create Procedure pInsCategories
 (
		@CategoryName nvarchar(100)
 )
 -- Author: Shruti Kakati
 -- Desc:  These set of Stored Procedure statements allows us to insert data in table Categories
 -- Change Log: 
 -- 2021-12-06,Shruti Kakati ,Created Stored Procedure to insert data in table Categories
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	INSERT INTO Categories (CategoryName)
    VALUES (@CategoryName)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

------Create Procedure pUpdCategories--------------------------
Create Procedure pUpdCategories
 (
	 	@CategoryID int,
		@CategoryName nvarchar(100)
 )
 -- Author: Shruti Kakati
 -- Desc:   These set of Stored Procedure statements allows us to Update data in table Categories
 -- Change Log: 
 -- 2021-12-06,Shruti Kakati ,Created Stored Procedure to Update data in table Categories
AS
 Begin
  Declare @RC int = 0;
  Begin Try
  Begin TRANSACTION
 	UPDATE Categories 
    SET CategoryName = @CategoryName
		WHERE CategoryID = @CategoryID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pDelCategories
Create Procedure pDelCategories
 (
	 	@CategoryID int
 )
 -- Author: Shruti Kakati
 -- Desc:   These set of Stored Procedure statements allows us to Delete data in table Categories
 -- Change Log: 
 -- 2021-12-06,Shruti Kakati ,Created Stored Procedure to Delete data in table Categories
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin TRANSACTION
 	DELETE 
	 FROM Categories 
		WHERE CategoryID = @CategoryID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Question 2 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Products table?
--Create Procedure pInsProducts
Create Procedure pInsProducts
 (
	 	@ProductName NVARCHAR(100),
		@CategoryID INT,
		@UnitPrice money
 )
 -- Author: Shruti Kakati
 -- Desc:   These set of Stored Procedure statements allows us to Insert data in table Products
 -- Change Log: 
 -- 2021-12-06,Shruti Kakati ,Created Stored Procedure to Insert data in table Products
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	INSERT INTO Products (ProductName, CategoryID, UnitPrice)
    VALUES (@ProductName, @CategoryID, @UnitPrice)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

----------Create Procedure pUpdProducts------------------------
Create Procedure pUpdProducts
 (
   @ProductID INT,
		@ProductName nvarchar(100),
    @UnitPrice money
 )
 -- Author: Shruti Kakati
 -- Desc:   These set of Stored Procedure statements allows us to Update data in table Products
 -- Change Log: 
 -- 2021-12-06,Shruti Kakati ,Created Stored Procedure to Update data in table Products
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin TRANSACTION
 	UPDATE Products
    SET   ProductName = @ProductName,
          UnitPrice = @UnitPrice
		WHERE ProductID = @ProductID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--------Create Procedure pDelProducts--------------
Create Procedure pDelProducts
 (
	 	@ProductID int
 )
 -- Author: Shruti Kakati
 -- Desc:   These set of Stored Procedure statements allows us to Delete data in table Products
 -- Change Log: 
 -- 2021-12-06, Shruti Kakati ,Created Stored Procedure to Delete data in table Products
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin TRANSACTION
 	DELETE 
	 FROM Products 
		WHERE ProductID = @ProductID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Question 3 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Employees table?
--Create Procedure pInsEmployees
Create Procedure pInsEmployees
 (
	 	@EmployeeFirstName NVARCHAR(100),
		@EmployeeLastName NVARCHAR(100),
		@ManagerID INT
 )
 -- Author: Shruti Kakati
 -- Desc:   These set of Stored Procedure statements allows us to Insert data in table Employees
 -- Change Log: 
 -- 2021-12-06,Shruti Kakati ,Created Stored Procedure to Insert data in table Employees
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	INSERT INTO Employees (EmployeeFirstName, EmployeeLastName, ManagerID)
    VALUES (@EmployeeFirstName, @EmployeeLastName, @ManagerID)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pUpdEmployees
Create Procedure pUpdEmployees
 (
	 		@EmployeeLastName NVARCHAR(100),
      @EmployeeID INT
 )
 -- Author: Shruti Kakati
 -- Desc:   These set of Stored Procedure statements allows us to Update data in table Employees
 -- Change Log: 
 -- 2021-12-06, Shruti Kakati ,Created Stored Procedure to Update data in table Employees
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin TRANSACTION
 	UPDATE Employees
    SET   EmployeeLastName = @EmployeeLastName
		WHERE EmployeeID = @EmployeeID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pDelEmployees

Create Procedure pDelEmployees
 (
	 	@EmployeeID int
 )
 -- Author: Shruti Kakati
 -- Desc:   These set of Stored Procedure statements allows us to Delete data in table Employees
 -- Change Log: 
 -- 2021-12-06, Shruti Kakati ,Created Stored Procedure to Delete data in table Employees
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin TRANSACTION
 	DELETE 
	 FROM Employees 
		WHERE EmployeeID = @EmployeeID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Question 4 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Inventories table?

--Create Procedure pInsInventories

Create Procedure pInsInventories
 (
	 	@InventoryDate Date,
		@EmployeeID int,
		@ProductID INT,
    @Count INT
 )
 -- Author: Shruti Kakati
 -- Desc:   These set of Stored Procedure statements allows us to Insert data in table Inventories
 -- Change Log: 
 -- 2021-12-06, Shruti Kakati ,Created Stored Procedure to Insert data in table Inventories
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	INSERT INTO Inventories (InventoryDate, EmployeeID, ProductID, Count)
    VALUES (@InventoryDate, @EmployeeID, @ProductID, @Count)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pUpdInventories
Create Procedure pUpdInventories
 (
   @InventoryID int,
   @InventoryDate Date,
   @Count INT 		
 )
 -- Author: Shruti Kakati
 -- Desc:   These set of Stored Procedure statements allows us to Update data in table Inventories
 -- Change Log: 
 -- 2021-12-06, Shruti Kakati ,Created Stored Procedure to Update data in table Inventories
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin TRANSACTION
 	UPDATE Inventories
    SET   InventoryDate = @InventoryDate,
          Count = @Count
		WHERE InventoryID = @InventoryID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pDelInventories
Create Procedure pDelInventories
 (
	 	@InventoryID int
 )
 -- Author: Shruti Kakati
 -- Desc:   These set of Stored Procedure statements allows us to Delete data in table Inventories
 -- Change Log: 
 -- 2021-12-06, Shruti Kakati ,Created Stored Procedure to Delete data in table Inventories
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin TRANSACTION
 	DELETE 
	 FROM Inventories 
		WHERE InventoryID = @InventoryID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Question 5 (20 pts): How can you Execute each of your Insert, Update, and Delete stored procedures? 
-- Include custom messages to indicate the status of each sproc's execution.

-- Here is template to help you get started:
/*
Declare @Status int;
Exec @Status = <SprocName>
                @ParameterName = 'A'
Select Case @Status
  When +1 Then '<TableName> Insert was successful!'
  When -1 Then '<TableName> Insert failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From <ViewName> Where ColID = 1;
go
*/

--< Test Insert Sprocs >--
-- Test [dbo].[pInsCategories]
Declare @Status int;
Exec @Status = pInsCategories
                @CategoryName = 'A'
Select Case @Status
  When +1 Then 'Categories Insert was successful!'
  When -1 Then 'Categories Insert failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vCategories 
GO

-- Test [dbo].[pInsProducts]
Declare @Status int;
Exec @Status = pInsProducts
                @ProductName = 'A',
                @CategoryID = '1',
                @UnitPrice = '9.99'
Select Case @Status
  When +1 Then 'Product Insert was successful!'
  When -1 Then 'Product Insert failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vProducts 
GO

-- Test [dbo].[pInsEmployees]
Declare @Status int;
Exec @Status = pInsEmployees
                @EmployeeFirstName = 'Abe',
                @EmployeeLastName = 'Archer',
                @ManagerID = '1'
Select Case @Status
  When +1 Then 'Employees Insert was successful!'
  When -1 Then 'Employees Insert failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vEmployees 
GO

-- Test [dbo].[pInsInventories]
Declare @Status int;
Exec @Status = pInsInventories
                @InventoryDate = '2021-01-01',
                @EmployeeID = '1',
                @ProductID = '1',
                @Count = '42'
Select Case @Status
  When +1 Then 'Inventories Insert was successful!'
  When -1 Then 'Inventories Insert failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vInventories 
GO

--< Test Update Sprocs >--
-- Test Update [dbo].[pUpdCategories]
Declare @Status int;
Exec @Status = pUpdCategories
								@CategoryID = 1,
                @CategoryName = 'B'
Select Case @Status
  When +1 Then 'Categories Update was successful!'
  When -1 Then 'Categories Update failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vCategories WHERE CategoryID = 1
GO

-- Test [dbo].[pUpdProducts]
Declare @Status int;
Exec @Status = pUpdProducts
                @ProductId = 1,
								@ProductName = 'B',
                @UnitPrice = '1.0'
Select Case @Status
  When +1 Then 'Products Update was successful!'
  When -1 Then 'Products Update failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vProducts WHERE ProductID = 1
GO

-- Test [dbo].[pUpdEmployees]
Declare @Status int;
Exec @Status = pUpdEmployees
                @EmployeeLastName = 'Arch',
                @EmployeeID = 1
Select Case @Status
  When +1 Then 'Employees Update was successful!'
  When -1 Then 'Employees Update failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vEmployees WHERE EmployeeID = 1
GO

-- Test [dbo].[pUpdInventories]
Declare @Status int;
Exec @Status = pUpdInventories
                @InventoryID = 1,
                @InventoryDate = '2021-01-02',
                @Count = 43
Select Case @Status
  When +1 Then 'Inventories Update was successful!'
  When -1 Then 'Inventories Update failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vInventories WHERE InventoryID = 1
GO

--< Test Delete Sprocs >--
-- Test [dbo].[pDelInventories]
Declare @Status int;
Exec @Status = pDelInventories
                @InventoryID = 1
Select Case @Status
  When +1 Then 'Inventories Deleted was successful!'
  When -1 Then 'Inventories Deleted failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vInventories WHERE InventoryID = 1
GO

-- Test [dbo].[pDelEmployees]
Declare @Status int;
Exec @Status = pDelEmployees
                @EmployeeID = 1
Select Case @Status
  When +1 Then 'Employees Deleted was successful!'
  When -1 Then 'Employees Deleted failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vEmployees WHERE EmployeeID = 1
GO

-- Test [dbo].[pDelProducts]
Declare @Status int;
Exec @Status = pDelProducts
                @ProductID = 1
Select Case @Status
  When +1 Then 'Products Deleted was successful!'
  When -1 Then 'Products Deleted failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vProducts WHERE ProductID = 1
GO

-- Test [dbo].[pDelCategories]
Declare @Status int;
Exec @Status = pDelCategories
								@CategoryID = 2
Select Case @Status
  When +1 Then 'Categories Delete was successful!'
  When -1 Then 'Categories Delete failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From vCategories WHERE CategoryID = 2
GO

--{ IMPORTANT!!! }--
-- To get full credit, your script must run without having to highlight individual statements!!!  

/***************************************************************************************/