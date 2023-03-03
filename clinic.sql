drop database if exists clinic;

create database clinic;

use clinic;

create table userWebSideDoctor_Dentist (
User_code int not null primary key auto_increment,
User_Login nvarchar(20) not null,
FirstName nvarchar(20) not null,
Email nvarchar(20) not null,
Birthday date null,
User_password nvarchar(20) not null,
Confirm_password nvarchar(20) not null,
Day_date text null,
Hour_day text null,
Serial_codeHour int null,
UserType_code int not null,
IsActive bit default 1
);

create table ReviewsWebSideDoctor_Dentist (
Serial_code int not null primary key auto_increment,
textReviews text not null,
Date_published date null,
Publish_by int not null,
IsActive bit default 1,
foreign key (Publish_by) references userWebSideDoctor_Dentist(User_code)
);

create table Day_Appointment_Web_SideDoctor_Dentist (
Serial_code int not null primary key auto_increment,
Day_date nvarchar(20) not null,
IsActive bit default 1
);

create table Hours_Appointment_Web_SideDoctor_Dentist (
Serial_code int not null primary key auto_increment,
Hour_day nvarchar(10) not null,
Day_date int not null,
IsActive bit default 1,
foreign key (Day_date) references Day_Appointment_Web_SideDoctor_Dentist(Serial_code)
);

create table medical_file_user_SideDoctor_Dentist(
Publish_by int not null,
Serial_code int not null primary key auto_increment,
Date_published date null,
File_user text null,
textDoctor text not null,
priceSevice text not null,
IsActive bit default 1,
foreign key (Publish_by) references userWebSideDoctor_Dentist(User_code)
);

create table ReviewsWebSideDoctor_Dentist_Likes(
Serial_code_how_Like int not null,
Serial_code int not null primary key auto_increment,
how_like text null,
foreign key (Serial_code_how_Like) references ReviewsWebSideDoctor_Dentist(Serial_code)
);

DELIMITER //
create function Count_Likes (Serial_code int)
returns int
DETERMINISTIC
begin
	declare count int;
	select Count(Serial_code) into count from clinic.ReviewsWebSideDoctor_Dentist_Likes where Serial_code_how_Like = Serial_code;
	return count;
end//

create procedure Add_Review_Likes (Serial_code_how_Like int, how_like text, out Serial_code int)
begin
	insert into clinic.ReviewsWebSideDoctor_Dentist_Likes(Serial_code_how_Like, how_like)
	values(Serial_code_how_Like,how_like);
	set Serial_code = auto_increment;
end//

create procedure Select_users_blocked_from_Dentist()
begin
	select * from clinic.userWebSideDoctor_Dentist where IsActive = 0 and UserType_code = 1;
end//

create procedure Select_users_check_Active_queues_from_Dentist()
begin
	select * from clinic.userWebSideDoctor_Dentist where Day_date IS NOT NULL;
end//

create procedure Select_users_from_Dentist_by_usercode(User_code int)
begin
    select * from clinic.userWebSideDoctor_Dentist where clinic.userWebSideDoctor_Dentist.User_code = User_code; 
end//

create procedure Find_user_from_Dentist(Email nvarchar(20))
begin
	select * from userWebSideDoctor_Dentist where Email = Email;
end//

create procedure Delete_User_WebSideDoctor_Dentist(User_code int)
begin
	update clinic.userWebSideDoctor_Dentist set IsActive=0 where User_code=User_code;
end//

create procedure Reactivate_User_WebSideDoctor_Dentist(User_code int)
begin
	update clinic.userWebSideDoctor_Dentist set IsActive=1 where User_code=User_code;
end//

create procedure Select_View_medical_file_user(Publish_by int)
begin
    select * from View_medical_file_user where Publish_by = Publish_by and IsActive=1;
end//

create procedure Select_View_medical_file_userIsActive_Not(Publish_by int)
begin
    select * from View_medical_file_user where Publish_by = Publish_by and IsActive=0;
end//

create procedure Delete_medical_file_user(Serial_code int)
begin
	update clinic.medical_file_user_SideDoctor_Dentist set IsActive=0 where Serial_code=Serial_code;
end//

create procedure Delete_View_Review_user(Serial_code int)
begin
	update clinic.ReviewsWebSideDoctor_Dentist set IsActive=0 where Serial_code=Serial_code;
end//

create procedure countReviews()
begin
	select Count(Serial_code) AS Count_Reviews from clinic.ReviewsWebSideDoctor_Dentist where IsActive = 1;
end//

create procedure Select_days_from_Dentist_Serial_code()
begin
	select * from clinic.Day_Appointment_Web_SideDoctor_Dentist where IsActive = 1;
end//

create procedure Delete_hour(Serial_code int)
begin
	update clinic.Hours_Appointment_Web_SideDoctor_Dentist set IsActive=0 where Serial_code=Serial_code;
end//

create procedure Add_Hours_from_Dentist(Hour_day nvarchar(10), Day_date int, out Serial_code int)
begin
	insert into clinic.Hours_Appointment_Web_SideDoctor_Dentist(Hour_day,Day_date) values(Hour_day,Day_date);
    set Serial_code = auto_increment;
end//







