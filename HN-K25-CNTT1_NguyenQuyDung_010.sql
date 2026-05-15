drop database if exists cuoi_mon;
create database cuoi_mon;
use cuoi_mon;

create table Customers (
	customer_id varchar(10) primary key,
    full_name varchar(100) not null,
    phone_number varchar(11) not null unique,
    email varchar(100) not null,
    join_date datetime not null default current_timestamp
);

create table Insurance_Packages (
	package_id varchar(10) primary key,
    package_name varchar(255) not null check (package_name in('Sức khỏe','Ô tô','Nhân thọ','Du lịch','Tai nạn')), 
    max_limit decimal(14,2) check (max_limit > 0) not null,
    base_premium decimal(14,2) not null check (base_premium > 0)
);

create table Policies (
	policy_id varchar(10) primary key,
    customer_id varchar(10) not null,
    package_id varchar(10) not null,
    start_date datetime not null,
    end_date datetime not null check( end_date > start_date ),
    status varchar(100) not null check (status in ('Active', 'Expired', 'Cancelled')),
    foreign key (customer_id) references Customers(customer_id) ON UPDATE CASCADE ON DELETE NO ACTION,
    foreign key (package_id) references Insurance_Packages(customer_id) ON UPDATE CASCADE ON DELETE NO ACTION
);



