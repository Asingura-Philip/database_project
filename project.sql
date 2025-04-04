create database granary_ug;

use granary_ug;

create table farmer(
	farmer_id int primary key auto_increment,
    name varchar(50),
    contact varchar(40),
    farm_location varchar(100),
    registered_date date,
    business_type varchar(50)
);

create table produce(
	produce_id int primary key auto_increment,
    name varchar(100),
    type varchar(100),
    storage_temperature_range varchar(100),
    drying_requirements varchar(100),
    farmer_id int,
    foreign key(farmer_id) references farmer(farmer_id)
);

