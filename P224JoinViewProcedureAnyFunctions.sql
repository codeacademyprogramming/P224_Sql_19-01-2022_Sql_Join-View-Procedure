Create Database P224JoinViewProcedureAnyFunctions

Use P224JoinViewProcedureAnyFunctions

Create Table Students
(
	Id int primary key identity,
	FirstName nvarchar(25) NOT NULL,
	SurName nvarchar(25)
)

Create Table Groups
(
	Id int primary key identity,
	Name nvarchar(20)
)

Create Table Grades
(
	Id int primary key identity,
	Name nvarchar(20),
	Min int,
	Max int
)

Create Table Positions
(
	Id int primary key identity,
	Name nvarchar(20),
	ParentId int references Positions(Id)
)

Create Table Products
(
	Id int primary key identity,
	Name nvarchar(20)
)

Create Table Sizes
(
	Id int primary key identity,
	Name nvarchar(20)
)

Create Table Employees
(
	Id int primary key identity,
	FirstName nvarchar(25) NOT NULL,
	SurName nvarchar(25)
)

Alter Table Students 
Add GroupId int Constraint FK_Students_Groups references Groups(Id)

Alter Table Students
Drop FK_Students_Groups

Alter Table Students
Add Constraint FK_Students_Groups FOREIGN KEY(GroupId) references Groups(Id)

Alter Table Groups
Add UNIQUE(Name)

Alter Table Students
Alter Column GroupId int NOt NUll

Alter Table Students
Add Grade decimal(10,2)

Select SUM(Grade) From Students

Select Count(Grade) From Students Where Grade > 60

Select distinct Grade From Students Order By (Grade) Desc

Select * From Students
Order By FirstName, SurName

Select * From Students where Grade Between 50 and 100

Select * From Students Where Grade in(40,50,60,100)

Select COUNT(distinct Grade) From Students

Select Count(Grade) From Students

Select (FirstName+' '+SurName) as [Full Name], Grade, Name as [Group Name]  From Students 
Inner Join Groups 
On Students.GroupId = Groups.Id
Where Grade > 50

Select (FirstName+' '+SurName) as [Full Name], Grade, Name as [Group Name]  From Students 
Join Groups 
On Students.GroupId = Groups.Id
Where Name = 'P224'

Select (FirstName+' '+SurName) as [Full Name], Grade, Name as [Group Name]  From Groups 
Join Students 
On Groups.Id = Students.GroupId
Where Name = 'P224'

Select ISNULL((FirstName+' '+SurName),'-') as [Full Name], ISNULL(Grade,0) as [Grade], Name as [Group Name]  From Groups 
Left Outer Join Students 
On Groups.Id = Students.GroupId

Select ISNULL((FirstName+' '+SurName),'-') as [Full Name], ISNULL(Grade,0) as [Grade], Name as [Group Name]  From Students 
Left Join Groups 
On Groups.Id = Students.GroupId

Select ISNULL((FirstName+' '+SurName),'-') as [Full Name], ISNULL(Grade,0) as [Grade], Name as [Group Name]  From Students 
Right Outer Join Groups 
On Groups.Id = Students.GroupId

Select ISNULL((FirstName+' '+SurName),'-') as [Full Name], ISNULL(Grade,0) as [Grade], Name as [Group Name]  From Groups 
Right Outer Join Students 
On Groups.Id = Students.GroupId

Select ISNULL((FirstName+' '+SurName),'-') as [Full Name], ISNULL(Grade,0) as [Grade], Name as [Group Name]  From Students 
Full Outer Join Groups 
On Groups.Id = Students.GroupId

--Non Equal Join
Select (FirstName+' '+SurName) as [Full Name], Grade, g.Name, gr.Name From Students s
Join Grades g
On s.Grade BetWeen g.Min And g.Max
Join Groups gr
On s.GroupId = gr.Id

--Self Join
Select pa.Name,ISNULL(p.Name, 'Hec Kimenen Asli deyil') 'Asili Oldugu Vezife' From Positions p
right Join Positions pa
On p.Id = pa.ParentId

Select p.Name as [Product name], s.Name as [Size Name] From Products p
cross join Sizes s
Where p.Name Like 't%'


Select Grade, COUNT(Grade) 'Count'  From Students s
Where s.Grade > 50
Group By s.Grade
having (COUNT(Grade) > 1)

Select distinct Grade from Students s Where s.Grade > 50

Select s.FirstName, s.SurName From Students s
Union 
Select e.FirstName, e.SurName From Employees e

Select e.FirstName, e.SurName From Employees e
Union 
Select s.FirstName, s.SurName From Students s

Select s.Id, s.FirstName, s.SurName From Students s
Union 
Select e.Id, e.FirstName, e.SurName From Employees e

Select e.FirstName, e.SurName From Employees e
Union All
Select s.FirstName, s.SurName From Students s

Select * From(
				Select e.FirstName, e.SurName From Employees e
				Union All
				Select s.FirstName, s.SurName From Students s
			) as [TBL] Order By FirstName

Select * From(
				Select e.FirstName, e.SurName From Employees e
				Union All
				Select s.FirstName, s.SurName From Students s
			) as [TBL] Where TBL.FirstName Like '%a%' Order By FirstName

Select FirstName, COUNT(FirstName) From(
				Select e.FirstName, e.SurName From Employees e
				Union All
				Select s.FirstName, s.SurName From Students s
			) as [TBL] Group By FirstName having(COUNT(FirstName) > 1)

Select s.Id, s.FirstName, s.SurName From Students s
intersect
Select  e.Id, e.FirstName, e.SurName From Employees e

Select e.FirstName, e.SurName From Employees e
intersect
Select s.FirstName, s.SurName From Students s

Select s.FirstName, s.SurName From Students s
except
Select e.FirstName, e.SurName From Employees e

Select e.FirstName, e.SurName From Employees e
except
Select s.FirstName, s.SurName From Students s

Create View usv_GetAllPerson
As
Select e.FirstName, e.SurName From Employees e
Union All
Select s.FirstName, s.SurName From Students s


Create View usv_GetAllPersonByGroup
As
Select s.FirstName, COUNT(s.FirstName) 'Count' From usv_GetAllPerson s Group By s.FirstName

Create View usv_GetAllPersonByGroupMoreOne
As
Select * From usv_GetAllPersonByGroup Where Count > 1

Select * From usv_GetAllPersonByGroupMoreOne

Create procedure usp_GetStudentByGrade
@Gradepoint int
As
Begin
Select * from Students Where Grade > @Gradepoint
End

exec usp_GetStudentByGrade 30

Alter procedure usp_GetStudentByGrade
(@Gradepoint int,
@GroupName nvarchar(20))
As
Begin
Select * from Students s
Join Groups g
On s.GroupId = g.Id
Where Grade > @Gradepoint And g.Name = @GroupName
End

exec usp_GetStudentByGrade 30,'20'