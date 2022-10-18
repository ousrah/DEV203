use cuisine;

select * from recettes;
select * from ingrédients;
select * from composition_recette;


#"Recette : (Nom de la recette), temps de préparation : (Temps)


drop procedure if exists ps9;
delimiter $$
create procedure ps9()
begin
    declare v_num int;
	declare v_nom varchar(50);
    declare v_temps int;
    declare v_methode varchar(50);
    declare v_prix float;
    declare flag boolean default true;
    declare c1 cursor for
		select numrec, nomrec, tempspreparation, methodepreparation  from recettes;
	declare continue handler for not found set flag = false;
    open c1;
    b1:loop
		fetch c1 into v_num,  v_nom, v_temps,v_methode;
        if not flag then
			leave b1;
        end if;
		select concat("Recette : (",v_nom,"), temps de préparation : (",v_temps,")") recette;
		select noming, qteutilisee from ingrédients i  inner join composition_recette c on i.numing = c.numing
		where numrec = v_num ;
        select concat("sa méthode de préparation est : ",v_methode,")") methode;
        
        select sum(PUIng* qteutilisee) into v_prix  from ingrédients i  inner join composition_recette c on i.numing = c.numing
		where numrec = v_num ;
        if v_prix <50 then
        select concat("prix interessant ", v_prix);
        end if;
    end loop b1;
	close c1;
end$$
delimiter ;

call ps9();