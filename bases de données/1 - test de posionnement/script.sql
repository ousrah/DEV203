create database if not exists location203 collate utf8_general_ci;
use location203;

drop table if exists contrat;
drop table if exists bien;
drop table if exists client;
drop table if exists quartier;
drop table if exists ville;
drop table if exists type_bien;










create table type_bien(
id int AUTO_INCREMENT primary key,
libelle varchar(30) not null
)engine=innodb;

create table ville(
id int AUTO_INCREMENT ,
libelle varchar(30) not null,
constraint pk_ville primary key (id)
);

create table quartier(
	id int AUTO_INCREMENT ,
	libelle varchar(30) not null,
	ville_id int,
	constraint fk_quartier_ville foreign key (ville_id) references ville(id),
	primary key (id)
);


create table client (
cin varchar(10) primary key,
nom varchar(30) not null,
prenom varchar(30) ,
adresse varchar(255) , 
telephone varchar(30) not null
);

create table bien(
reference  varchar(10) primary key,
superficie float not null,
nb_pieces int not null,
adresse varchar(255),
loyer float not null,
client_cin varchar(10), 
quartier_id int,  
type_bien_id int,
constraint fk_bien_client foreign key (client_cin) references client(cin),
constraint fk_bien_quartier foreign key (quartier_id) references quartier(id),
constraint fk_bien_type_bien  foreign key (type_bien_id) references type_bien(id)
);

create table contrat(
bien_reference varchar(10),
client_cin varchar(10),
date_creation date not null,
date_entree date,
date_sortie date,
loyer float not null,
charges float not null,
constraint fk_contrat_bien foreign key (bien_reference) references bien(reference) ,
constraint fk_contrat_client foreign key (client_cin) references client(cin),
constraint pk_contrat primary key (bien_reference, client_cin)
);




