drop database if exists notes;
create database notes collate utf8_general_ci;
use notes;

select * from etudiants;

drop table if exists ville;
create table ville (id int auto_increment primary key)
select distinct ville as nomVille from etudiants;

drop table if exists classe;
create table classe (id int auto_increment primary key)
select distinct classe as nomClasse from etudiants;

drop table if exists matiere;
create table matiere (id int auto_increment primary key)
select distinct matière as nomMatiere from etudiants;

drop table if exists appreciation;
create table appreciation (id int auto_increment primary key)
select distinct appréciation as nomAppreciation from etudiants;

 drop table if exists stagiaire;
 create table stagiaire (id int auto_increment primary key)
select distinct `Nom stagiaire` nom ,
  `prénom Stagiaire` prenom,
 date(concat( right(`Date Naissance`,4),'/',  substring(`Date Naissance`,4,2), '/', left(`Date Naissance`,2))) daten , 
 v.id as idVille,
 c.id as idClasse
 from etudiants e inner join ville v on e.ville = v.nomVille
				  inner join classe c on e.classe=c.nomClasse;
                  
drop table if exists evaluation;
create table evaluation
select 
s.id as idStagiaire,
m.id as idMatiere,
a.id as idAppreciation,
convert(replace(note,",","."),float) note 
from etudiants e
     inner join stagiaire s on e.`Nom stagiaire`=s.nom and e.`Prénom stagiaire`=s.prenom
     inner join matiere m on e.matière = m.nomMatiere
     inner join appreciation a on  e.appréciation = a.nomAppreciation;
     
alter table evaluation add constraint pk_evaluation primary key (idStagiaire, idMatiere, idAppreciation);

alter table stagiaire add constraint fk_sta_vil foreign key (idVille) references ville(id);
alter table stagiaire add constraint fk_sta_cla  foreign key (idClasse) references classe(id);

alter table evaluation add constraint fk_eva_sta  foreign key (idStagiaire) references stagiaire(id);
alter table evaluation add constraint fk_eva_mat  foreign key (idMatiere) references matiere(id);
alter table evaluation add constraint fk_eva_app  foreign key (idAppreciation) references appreciation(id);

drop table etudiants;
 