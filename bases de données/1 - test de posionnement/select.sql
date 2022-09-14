use location_dev203;

#A.	La liste des bien de type ‘villa’
#methode 1
select b.* 
from bien b inner join type_bien t on b.type_bien_id = t.id
where t.libelle = 'villa';

#methode 2
select * 
from bien 
where type_bien_id in (select id 
					   from type_bien
					   where libelle = 'villa');


#B.	La liste des appartements qui se trouve à Tétouan
#methode 1
select b.* 
from bien b inner join type_bien t on b.type_bien_id = t.id
			inner join quartier q on b.quartier_id = q.id
			inner join ville v on q.ville_id = v.id
where t.libelle = 'appartement'
	  and v.libelle='tetouan';


#methode 2
select * 
from bien 
where type_bien_id in (select id 
					   from type_bien
					   where libelle = 'appartement')
and quartier_id in (select id
					from quartier
                    where ville_id in (select id 
										from ville
										where libelle = 'tetouan')
					);
                       
#C.	La liste des appartements loués par M. Marchoud Ali
select b.* 
from bien b inner join type_bien t on b.type_bien_id = t.id
where t.libelle = 'appartement'
and reference in (select bien_reference 
					from contrat 
					where 
					client_cin in (select cin
								   from client
								   where nom like'marchoud' and prenom like 'ali')
				);

#D.	Le nombre des appartements loués dans le mois en cours
select count(*) as 'nombre app' from bien 
where reference in (
					select bien_reference
					from contrat 
					where month(date_creation) = month(current_date)
					 and year(date_creation)=year(current_date)
					 )
and type_bien_id in (select id from type_bien where libelle = 'appartement')


#E.	Les appartements 
disponibles actuellement 
à Martil 
dont le loyer est inférieur à 2000 DH 
triés du moins chère au plus chère




#F.	La liste des biens qui n’ont jamais été loués

#G.	La somme des loyers du mois en cours
 
 