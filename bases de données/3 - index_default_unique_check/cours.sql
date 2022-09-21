##################################
# indexes
###############################

use librairie;
#la recherch est très lente sur les champs non indexés
select * from ecrivain where paysecr = 'france'
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
select * from test

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


##################################
# checks
###############################
