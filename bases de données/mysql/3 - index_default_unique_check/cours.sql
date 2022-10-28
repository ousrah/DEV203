##################################
# indexes
###############################

use librairie;
#la recherch est très lente sur les champs non indexés
select * from ecrivain where paysecr = 'france';
# creation d'index sur un champ existant
create index idx_pays on ecrivain(paysecr);


drop table if exists test;

#creation d'une nouvelle table avec des indexes
create table test (id int auto_increment primary key,
					nom varchar(50) ,
					 index (nom));

#ajout d'un champs					
ALTER table test add ville varchar(50);
#ajout d'un index
alter table test add index (ville);
#ajout d'un champs avec un index
alter table test add pays varchar(50), add index (pays);

#supprimer un index
alter table test drop index pays;
drop index idx_pays on ecrivain;


##################################
# default
###############################

drop table if exists test;

#creation d'un table avec la ville par defaut
create table test (id int auto_increment primary key,
 nom varchar(50), 
 ville varchar(50) default 'tetouan');
 
insert into test (nom) values ('a');
insert into test (nom,ville) values ('b','tanger');
select * from test;

#ajout d'un champs avec valeur par defaut
alter table test add pays varchar(50) default 'Maroc';

#ajout d'un champs
alter table test add langue varchar(50);

#ajout d'une valeur par defaut a un champ existant
alter table test alter column langue set default 'arabe';

#ajout d'un champs 
alter table test add ecole varchar(50);

#modifier le champs pour ajouter une valeur par defaut
alter table test modify ecole varchar(50) default 'ismo';
alter table test change ecole ecole varchar(50) default 'ismo';
#test d'insertion
insert into test (nom) values ('c');
select * from test;
insert into test (nom, ecole) values ('d',null);





##################################
# unique
###############################
use librairie;
drop table if exists client;

#creation d'un table avec un champs unique (n'accept pas les doublons)
create table client  (id int auto_increment primary key, 
					raison_social varchar(50) unique);

#Test d'insertion
insert into client (raison_social) values ('meditel');
insert into client (raison_social) values ('IAM');
insert into client (raison_social) values ('wana');

#erreur
insert into client (raison_social) values ('meditel');

#ajout d'un champ a une table existante avec la constraint unique
alter table client add num_patente bigint unique;

#Ajout d'un nouveau champ
alter table client add email varchar(50);

#ajout de la contrainte unique sur un champ existant
alter table client add constraint unq_email unique (email);

alter table client add telephone varchar(50);
alter table client add fax varchar(50);

#ajout de la contrainte unique sur plusieurs champs
alter table client add constraint unq_telephone_fax unique(telephone, fax);



             






##################################
# checks
###############################

drop table if exists produit;

#creation d'un table avec une règle de validation sur le prix
create table produit (id int auto_increment primary key,
					designation varchar(50),
                    prix float, check (prix>0));
                    
 #test d'insertion                   
insert into produit (designation, prix) values ('pc',2500);

#erreurs
insert into produit (designation, prix) values ('pc',-500);
insert into produit (designation, prix) values ('pc',0);

#suppression de la règle de validation
alter table produit drop constraint produit_chk_1;

#ajout d'un règle a une table existante
alter table produit add constraint chk_prix check(prix>=0);

#test
insert into produit (designation, prix) values ('pc',0);

#l'insertion accept les valeurs nuls
insert into produit (designation) values ('imprimate');

#méthode 1 pour ajouter un règle de validation pour les valeurs non nuls
#erreur puisqu'il y a des enregistrement qui ne respectent pas cette règle
alter table produit add constraint chk_prix_non_null check (prix is not null);

select * from produit;
#correction des anomalies (erreurs)
update produit set prix=0 where prix is null;                   

#application de la règle de validation
alter table produit add constraint chk_prix_non_null check (prix is not null);

#test
insert into produit (designation) values ('scanner');

#on peut appliquer la règle not null sans ajout de constrainte check
alter table produit modify column prix float not null;

#ajout de plusieurs conditions dans la même règle de validation
alter table produit drop constraint chk_prix;
alter table produit drop constraint chk_prix_non_null;
alter table produit add constraint chk_prix check(prix>=0 and prix is not null);

