drop database if exists gestionCommerciale;

create database gestionCommerciale collate 'utf8_general_ci';

use gestionCommerciale;

create table produit (
	id int auto_increment primary key, 
	designation varchar(100), 
	prix_unitaire float, 
	stock float);

create table client (
	id int auto_increment primary key, 
	nom varchar(50), 
	prenom varchar(50));

create table commande (
	id int auto_increment primary key, 
	date_commande date, 
	client_id int, 
	foreign key (client_id) references client(id));

create table ligne (
	qte float, 
	prix_vente float,  
	commande_id int, 
	produit_id int, 
	primary key(commande_id, produit_id), 
	foreign key (commande_id) references commande(id), 
	foreign key (produit_id) references produit(id));


insert into produit values
	(1,'table',150,10), 
	(2,'chaise',80,20), 
	(3,'armoire',2500,3);

insert into client values 
	(1,'fadili','mohamed'), 
	(2,'jaouhari','soukaina'),
	(3,'benhsain','zakaria');
    
insert into commande values 
	(1,'2022/10/15',1), 
	(2,'2022/10/16',2), 
	(3,'2022/10/17',3);

select * from produit;
select * from client;
select * from commande;
select * from ligne;

insert into ligne values (5,150,1,1);

drop trigger if exists t1;
delimiter $$
create trigger t1 after insert on ligne for each row
begin
	update produit set stock = stock-new.qte where id = new.produit_id;
end$$
delimiter ;


alter table produit add check (stock >=0);


#creer le trigger qui ajoute la quantité du produit dans le stock lorsqu'on supprimer un enregistrement de la table ligne

drop trigger if exists t2;
delimiter $$
create trigger t2 after delete on ligne for each row
begin
	update produit set stock = stock+old.qte where id = old.produit_id;
end$$
delimiter ;

delete from ligne where commande_id = 2 and produit_id = 1;


#creer le trigger qui modifie la quantité du produit dans le stock lorsqu'on modifie un enregistrement de la table ligne

drop trigger if exists t3;
delimiter $$
create trigger t3 after update on ligne for each row
begin
	update produit set stock = stock+(old.qte-new.qte) where id = old.produit_id;
end$$
delimiter ;
select * from ligne
select * from produit
update ligne set qte = 1 where commande_id = 3 and produit_id = 1;
delete from ligne;
