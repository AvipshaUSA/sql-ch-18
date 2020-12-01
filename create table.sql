create table plant (
plant_id integer primary key auto_increment,
plant_name varchar(155),
zone integer ,
season varchar(155)
);

create table seeds (
seed_id integer primary key auto_increment,
expiration_date date ,
quantity integer,
reorder bool,
plant_id integer,
foreign key(plant_id) references plant (plant_id)

);

create table garden_bed (
space_number integer primary key auto_increment,
date_planted date,
doing_well bool,
plant_id integer,
foreign key(plant_id) references plant (plant_id)


);