# 1.	Liste des noms des éditeurs situés à Paris triés par ordre
# alphabétique. 
select * 
from editeur
where villeed = 'paris'
order by nomed asc;

#2.	Liste des écrivains de (tous les champs)  langue française, triés
# par ordre alphabétique sur le nom et le prénom.
select *
from ecrivain
where languecr = 'français'
order by nomecr, prenomecr; 


#3.	Liste des titres des ouvrages (NOMOUVR) ayant été  édités entre 
#(ANNEEPARU) 1986 et 1987.
# methode 1
select nomouvr
from ouvrage 
where anneeparu >= 1986 and ANNEEPARU <= 1987;

# methode 2
select nomouvr
from ouvrage 
where anneeparu between 1986 and 1987;

#4.	Liste des éditeurs dont le n° de téléphone est inconnu

select * 
from editeur 
where editeur.TELED is null;


#5.	Liste des auteurs (nom + prénom) dont le nom contient un ‘C’.
#methode 1
select nomecr,prenomecr
from ecrivain
where nomecr like '%C%';

#methode 2
select nomecr,prenomecr
from ecrivain
where nomecr regexp 'C';  #voir https://www.geeksforgeeks.org/mysql-regular-expressions-regexp/


#6.	Liste des titres d’ouvrages contenant  le mot "banque" 
#(éditer une liste triée par n° d'ouvrage croissant). 
select nomouvr
from ouvrage
where nomouvr like '%banque%'
order by numouvr asc;



#7.	Liste des dépôts (nom) situés à Grenoble ou à Lyon. 
select nomdep, villedep
from depot
where villedep in ('grenoble','lyon');


#8.	Liste des écrivains (nom + prénom) américains
# ou de langue française. 
select nomecr,prenomecr
from ecrivain
where languecr='francais' 
or PAYSECR='usa';


#9.	Liste des auteurs (nom + prénom) de langue française dont le 
#nom ou le prénom commence par un ‘H’. 
select NOMECR,PRENOMECR , languecr
from ecrivain 	
where LANGUECR="français" 
	and ( NOMECR like "H%"  or PRENOMECR like "H%");

#10.	Titres des ouvrages en stock au dépôt n°2. 
select nomouvr
from ouvrage o
inner join stocker s on o.numouvr=s.numouvr
where numdep=2;

#11.	Liste des auteurs (nom + prénom) ayant écrit des livres coûtant au
# moins 30 € au 1/10/2002.
#methode1 
select distinct nomecr,prenomecr 
from ecrivain e
inner join ecrire ec on ec.NUMECR=e.NUMECR
#inner join ouvrage o on ec.NUMOUVR= o.numouvr
inner join tarifer t on t.numouvr =ec.numouvr
where PRIXVENTE>=30
and datedeb = '2002/10/01';

#methode2
select nomecr,prenomecr 
from ecrivain 
where numecr in (select numecr 
					from ecrire 
					where numouvr in (select numouvr 
										from tarifer 
										where PRIXVENTE>=30
										and datedeb = '2002/10/01'));



#12.	Ecrivains (nom + prénom) ayant écrit des livres sur le thème (LIBRUB) 
#des « finances publiques ». 

create view R12 as (
select distinct nomecr,prenomecr from ecrivain e
inner join ecrire ec on ec.numecr=e.numecr
inner join ouvrage o on ec.numouvr= o.numouvr
inner join classification c on c.numrub = o.NUMRUB
where librub = 'finances publiques');

create temporary table t1
select distinct nomecr,prenomecr from ecrivain e
inner join ecrire ec on ec.numecr=e.numecr
inner join ouvrage o on ec.numouvr= o.numouvr
inner join classification c on c.numrub = o.NUMRUB
where librub = 'finances publiques';


select * from t1 where nomecr like '%a%';





#13.	Idem R12 mais on veut seulement les auteurs dont le nom contient un ‘A’. 

select * 
from r12 
where NOMECR like '%a%';

select * from 
(select distinct e.numecr, nomecr,prenomecr from ecrivain e
inner join ecrire ec on ec.numecr=e.numecr
inner join ouvrage o on ec.numouvr= o.numouvr
inner join classification c on c.numrub = o.NUMRUB
where librub = 'finances publiques')  t1
where nomecr like '%a%';

with t1 as (select distinct e.numecr, nomecr,prenomecr from ecrivain e
inner join ecrire ec on ec.numecr=e.numecr
inner join ouvrage o on ec.numouvr= o.numouvr
inner join classification c on c.numrub = o.NUMRUB
where librub = 'finances publiques')

select * from t1 where nomecr like '%a%';




#14.	En supposant l’attribut PRIXVENTE dans TARIFER 
#comme un prix TTC et un taux de TVA égal à 15,5% sur les ouvrages, 
#donner le prix HT de chaque ouvrage. 
select o.nomouvr,prixvente, round(PRIXVENTE/1.155,2)
from ouvrage o
inner join tarifer t on t.numouvr= o.NUMOUVR;



#15.	Nombre d'écrivains dont la langue est l’anglais ou l’allemand. 
#methode1
select count(*)
from ecrivain
where LANGUECR = 'anglais' or LANGUECR = 'allemand';

#methode1
select count(*)
from ecrivain
where LANGUECR in('anglais','allemand');

#16.	Nombre total d'exemplaires d’ouvrages sur la « gestion de portefeuilles »
# (LIBRUB) stockés dans les dépôts Grenoblois. 

#methode 1
select sum(qtestock) from stocker 
where NUMOUVR in(select numouvr 
from ouvrage 
where numrub in (select  numrub  
from classification where librub='gestion de portefeuilles')) 
and numdep in(select numdep 
from depot where VILLEDEP='Grenoble');
 
#methode 2
select sum(qtestock) 
from depot d
inner join stocker s  on s.NUMDEP = d.numdep
inner join ouvrage o on s.numouvr = o.numouvr
inner join classification c on c.numrub = o.numrub
 where librub='gestion de portefeuilles' 
      and VILLEDEP='Grenoble';

#17.	Titre de l’ouvrage ayant le prix le plus élevé - faire deux requêtes.
# (réponse: Le Contr ôle de gestion dans la banque.)

#methode 1
select nomouvr
from ouvrage o
inner join tarifer t on o.NUMOUVR = t.NUMOUVR
where PRIXVENTE in (select max(PRIXVENTE) from tarifer);

#methode2
select nomouvr
from ouvrage o inner join tarifer t on o.NUMOUVR = t.NUMOUVR
inner join (select max(PRIXVENTE) m from tarifer) t1 on prixvente = m

#methode3
with maxpv as (select max(PRIXVENTE) m from tarifer)
select nomouvr
from ouvrage o inner join tarifer t on o.NUMOUVR = t.NUMOUVR
inner join maxpv on prixvente = m


#18.	Liste des écrivains avec pour chacun le nombre d’ouvrages qu’il a écrits. 


select e.numecr, NOMECR,prenomecr, count(e.NUMECR) 
from ecrivain e
inner join ecrire ec on ec.NUMECR =e.NUMECR
inner join ouvrage o on o.NUMOUVR = ec.NUMOUVR
group by(e.NuMECR);


#19.	Liste des rubriques de classification avec, pour chacune, 
#le nombre d'exemplaires en stock dans les dépôts grenoblois. 

select librub, sum(qtestock) 
from depot d
inner join stocker s  on s.NUMDEP = d.numdep
inner join ouvrage o on s.numouvr = o.numouvr
inner join classification c on c.numrub = o.numrub
where VILLEDEP='Grenoble'
group by librub ;

#20.	Liste des rubriques de classification avec leur état de stock dans les dépôts grenoblois: ‘élevé’ s’il y a plus de 1000 exemplaires dans cette rubrique, ‘faible’ sinon. (réutiliser la requête 19). 

select librub, sum(qtestock) , if (sum(qtestock) >1000,'eleve','faible') as etat
from depot d
inner join stocker s  on s.NUMDEP = d.numdep
inner join ouvrage o on s.numouvr = o.numouvr
inner join classification c on c.numrub = o.numrub
where VILLEDEP='Grenoble'
group by librub ;

#changement des conditions pour
>5000 très eleve
>1000 eleve
>500 faible
<=500 très faible

select librub, sum(qtestock) , 
if (sum(qtestock) >5000,' tres eleve',
		if (sum(qtestock) >1000,' eleve',
					if (sum(qtestock) >500,' faible',
								'tres faible') 	) 	) 
as etat
from depot d
inner join stocker s  on s.NUMDEP = d.numdep
inner join ouvrage o on s.numouvr = o.numouvr
inner join classification c on c.numrub = o.numrub
where VILLEDEP='Grenoble'
group by librub ;

#utilisation de case
select librub, sum(qtestock) , 
case 
		when sum(qtestock) >5000 then ' tres eleve'
		when sum(qtestock) >1000 then ' eleve'
		when sum(qtestock) >500 then ' faible'
		else 'tres faible'
end as etat
from depot d
inner join stocker s  on s.NUMDEP = d.numdep
inner join ouvrage o on s.numouvr = o.numouvr
inner join classification c on c.numrub = o.numrub
where VILLEDEP='Grenoble'
group by librub ;

#autre façon d'utiliser case
select distinct paysecr ,
case paysecr
	when 'France' then 'فرنسا'
	when 'Grande Bretagne' then 'بريطانيا'
	when 'USA' then 'الولايات المتحدة'
	when 'Pays bas' then 'هولاندا'
	when 'Allemagne' then 'ألمانيا'
	when 'Italie' then 'إيطاليا'
end as paysArabe
from ecrivain;



#21.	Liste des auteurs (nom + prénom) ayant écrit des livres 
#sur le thème (LIBRUB) des « finances publiques » ou 
#bien ayant écrit des livres coûtant au moins 30 € au 1/10/2002 -
# réutiliser les requêtes 11 et 12. 
#methode 1
select distinct e.numecr, nomecr,prenomecr 
from ecrivain e
inner join ecrire ec on ec.NUMECR=e.NUMECR
inner join tarifer t on t.numouvr =ec.numouvr
where PRIXVENTE>=30
and datedeb = '2002/10/01'
union # union all  affiche les doublons
select distinct e.numecr, nomecr,prenomecr from ecrivain e
inner join ecrire ec on ec.numecr=e.numecr
inner join ouvrage o on ec.numouvr= o.numouvr
inner join classification c on c.numrub = o.NUMRUB
where librub = 'finances publiques';


#methode 2
with r11 as (select distinct e.numecr, nomecr,prenomecr 
from ecrivain e
inner join ecrire ec on ec.NUMECR=e.NUMECR
inner join tarifer t on t.numouvr =ec.numouvr
where PRIXVENTE>=30
and datedeb = '2002/10/01'),
r12 as (select distinct e.numecr, nomecr,prenomecr from ecrivain e
inner join ecrire ec on ec.numecr=e.numecr
inner join ouvrage o on ec.numouvr= o.numouvr
inner join classification c on c.numrub = o.NUMRUB
where librub = 'finances publiques')

select * from r11
union 
select * from r12;


#22.	Liste des écrivains (nom et prénom) n’ayant écrit aucun 
#des ouvrages présents dans la base. 

#methode1
select * from ecrivain
where numecr not in (select numecr from ecrire);

#methode2
select e.* from
ecrivain e left join ecrire ec on e.numecr = ec.numecr
where numouvr is null


#23.	Mettre à 0 le stock de l’ouvrage n°6 dans le dépôt Lyon2. 
#methode1
update stocker set qtestock=0 where numouvr = 6
and numdep in (select numdep from depot where nomdep = 'lyon2')
#methode2
update stocker s inner join depot d on s.numdep = d.numdep
set qtestock=0 
where numouvr = 6 and nomdep = 'lyon2'

#24.	Supprimer tous les ouvrages de chez Vuibert de la table OUVRAGE.
delete from ecrire where numouvr in (select numouvr from ouvrage where nomed = 'vuibert');
delete from stocker where numouvr in (select numouvr from ouvrage where nomed = 'vuibert');
delete from tarifer where numouvr in (select numouvr from ouvrage where nomed = 'vuibert');
delete from ouvrage where nomed = 'vuibert';

#25.	créer une table contenant les éditeurs situés à Paris et leur n° de tel.  

create table editeurDeParis
select nomed, villeed from editeur where villeed='paris'

select * from editeurDeParis


