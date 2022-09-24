/*Série 1 : Les Contraintes d’intégrités

Exercice 1 :

Soit le modèle relationnel suivant relatif à la gestion des notes annuelles d'une promotion d’étudiants :
ETUDIANT (NEtudiant, Nom, Prénom)
MATIERE (CodeMat, LibelleMat, CoeffMat)
EVALUER (NEtudiant, CodeMat, DateExamen, Note)
Questions :*/
#1.	Créer la base de données avec le nom « Ecole »;
drop database if exists ecole;
create database ecole collate utf8_general_ci;
use ecole;

#2.	Créer les tables avec les clés primaires sans spécifier les clés étrangères ;
create table ETUDIANT (NEtudiant int auto_increment primary key
					, Nom varchar(50)
					, Prénom varchar(50));
create table MATIERE (CodeMat int auto_increment primary key, 
					LibelleMat varchar(50),
                    CoeffMat int);
create table EVALUER (NEtudiant int, 
					CodeMat int, 
					DateExamen date, 
                    Note float,
                    primary key (nEtudiant,CodeMat));

#3.	Ajouter les clés étrangères à la table EVALUER ; 

alter table evaluer add constraint fk_eva_etu foreign key (netudiant) references etudiant(netudiant);
alter table evaluer add constraint fk_eva_mat foreign key (codemat) references matiere(codemat);


#4.	Ajouter la colonne Groupe dans la table ETUDIANT: Groupe NOT NULL ; 
alter table etudiant add groupe varchar(50) not null;



#5.	Ajouter la contrainte unique pour l’attribut (LibelleMat) ; 
alter table matiere add constraint unq_mat unique(libelleMat);


#6.	Ajouter une colonne Age à la table ETUDIANT, avec la contrainte (age >16) ;
alter table etudiant
add column age int check (age>16);


#7.	Ajouter une contrainte sur la note pour qu’elle soit dans l’intervalle (0-20) ; 

alter table evaluer add constraint check(note between 0 and 20);

#8.	Remplir les tables par les données ;



/*Exercice 2 :

Soit le schéma relationnel suivant :

  AVION ( NumAv, TypeAv, CapAv, VilleAv)
  PILOTE (NumPil, NomPil,titre, VillePil) 
  VOL (NumVol, VilleD, VilleA, DateD, DateA, NumPil#,NumAv#)

Travail à réaliser :

  À l'aide de script SQL: 
*/
#1.	Créer la base de données sans préciser les contraintes de clés.
drop database if exists vols;
create database vols collate utf8_general_ci;
use vols;
create table   AVION ( NumAv int auto_increment unique, TypeAv varchar(50), CapAv int, VilleAv varchar(50));
create table    PILOTE (NumPil int auto_increment unique, NomPil varchar(50),titre varchar(50), VillePil varchar(50)) ;
create table    VOL (NumVol int auto_increment unique, VilleD varchar(50), VilleA varchar(50), DateD date default (current_date), DateA date, NumPil int,NumAv int);


#2.	Ajouter les contraintes de clés aux tables de la base.

alter table avion add constraint pk_avion primary key (numav);
alter table PILOTE add constraint pk_pilote primary key (NumPil);
alter table VOL add constraint pk_vol primary key (NumVol);

alter table VOL add constraint fk_vol_avion foreign key (numav) references avion(numav);
alter table VOL add constraint fk_vol_pilot foreign key (numpil) references pilote(numpil);

#3.	Ajouter des contraintes qui correspondent aux règles de gestion suivantes
#	Le titre de courtoisie doit appartenir à la liste de constantes suivantes :
#M, Melle, Mme.

alter table PILOTE
add constraint name_chk check(titre in ("M" ,"Melle" ,"Mme"));



#	Les valeurs noms, ville doivent être renseignées.
alter table pilote modify nompil varchar(50) not null;

alter table pilote add constraint chk_villepil check(villepil is not null);
alter table avion add constraint chk_villeav check(villeav is not null);

alter table vol add constraint chk_villed check(villed is not null);
alter table vol add constraint chk_villea check(villea is not null);



#	La capacité d’un avion doit être entre 50 et 100.
alter table avion add constraint chk_cap check(capav between 50 and 100);


#4.	Ajouter la  colonne ‘date de naissance’ du pilote : DateN 
alter table pilote add column dateNaissance date;

#5.	Ajouter une contrainte qui vérifie que la date de départ d’un vol est toujours inférieure ou égale à sa date d’arrivée.
alter table vol add constraint chk_datea check (dated <= datea);

#6.	Supprimer la colonne VilleAv
alter table avion drop column villeav;


#7.	Supprimer la table PILOTE

alter table vol drop constraint fk_vol_pilot;
drop table pilote;



#8.	Remplir la base de données pour vérifier les contraintes appliquées.

