#la programmation procédurale sous my sql

#Les blocks
#Exemples de blocks avec des fonctions simples et procedures stockées simples
#un block peut être fonction, procedure, trigger, cursor, transaction....alter

/*
create type_block name_block(arguments...)
...
begin
	instructions
    begin
		instructions
    
	end
end
*/

#exemple d'une fonction sans paramètres hello
use notes;

drop function if exists hello;
delimiter $$
create function hello()
returns varchar(50)
deterministic
begin
	return "hello world";
end$$
delimiter ;

select current_date();
select left("abcde",2);
select hello() as salutation;

#exemple fonction avec paramètres somme

drop function if exists somme;
delimiter $$
create function somme(a int, b int)
returns bigint
deterministic
begin
	return a+b;
end$$
delimiter ;

select somme(3,5) as addition;

#exemple d'un bloc de procedure stockée sans paramètres
drop procedure if exists ps_hello;
delimiter $$
create procedure ps_hello()
begin
	select "hello world" as salutation;
end$$
delimiter ;

call ps_hello();

#exemple procedure stockée avec des paramètres d'entrée in
drop procedure if exists ps_somme;
delimiter $$
create procedure ps_somme(in a int, in b int)
begin
	select a+b as addition;
end$$
delimiter ;

call ps_somme(8,9);


#Les instructions de controles
	#la déclaration
    -- declare a int;
    -- declare b int default 5;
    
   
		drop function if exists somme;
		delimiter $$
		create function somme(a int, b int)
		returns bigint
		deterministic
		begin
			declare c bigint default a+b;
			return c;
		end$$
		delimiter ;

select somme(3,5) as addition; 
    
    
	#l'affectation
    -- declare a int;
    -- declare b date;
    -- set a=5;
    -- select current_date() into b; 
 
		drop function if exists somme;
		delimiter $$
		create function somme(a int, b int)
		returns bigint
		deterministic
		begin
			declare c bigint;
            #set c = a+b;
            select a+b into c;
			return c;
		end$$
		delimiter ;

		select somme(3,5) as addition; 
    
       
    
    
	#Les conditions
		#IF
        #syntaxe if sans else
    drop function if exists get_phone_type;
    delimiter $$
    create function get_phone_type(phone varchar(50))
    returns varchar(50)
    deterministic
    begin
		declare type_phone varchar(50) default "fixe";
       # if phone like "06%" or phone like "07%" then
		if left(phone,2) in ("06","07") then
			set type_phone = "portable";
        end if;
        RETURN type_phone;
    end$$
    delimiter ;
     
     select get_phone_type("06215487");
        
 
    #syntaxe if avec else
    drop function if exists get_phone_type;
    delimiter $$
    create function get_phone_type(phone varchar(50))
    returns varchar(50)
    deterministic
    begin
		declare type_phone varchar(50);
		if left(phone,2) in ("06","07") then
			set type_phone = "portable";
		else
			set type_phone = "fixe";
        end if;
        RETURN type_phone;
    end$$
    delimiter ;
     
     select get_phone_type("03215487");
        
      #syntaxe if ... elseif ... else ..
    drop function if exists get_phone_type;
    delimiter $$
    create function get_phone_type(phone varchar(50))
    returns varchar(50)
    deterministic
    begin
		declare type_phone varchar(50);
		if left(phone,2) in ("06","07") then
			set type_phone = "portable";
		elseif left(phone,2) = "05" then
			set type_phone = "fixe";
		else
			set type_phone = "invalide";
        end if;
        RETURN type_phone;
    end$$
    delimiter ;
     
     select get_phone_type("06215487");
           
        
        
		#CASE
        #exemple case avec conditions >
        
       drop function if exists get_mention;
       delimiter $$
       create function get_mention(note float)
       returns varchar(50)
       deterministic
       begin
			declare mention varchar(50);
            case 
				when note>=18 then set mention="Excellent";
				when note>=16 then set mention="T Bien";
				when note>=14 then set mention="Bien";
				when note>=12 then set mention="A. Bien";
				when note>=10 then set mention="Passable";
				when note>=8 then set mention="Faible";
				else set mention="Insuffisant";
            end case;
		return mention;
       end$$
       
       delimiter ;
        
        select get_mention(2.5);
     
     #exemple case avec conditions egalité
     
     drop function if exists get_day_name;
     delimiter $$
     create function get_day_name(day int)
     returns varchar(50)
     deterministic
     begin
		declare day_name varchar(50);
        case day
			when 1 then set day_name="Dimanche";
			when 2 then set day_name="Lundi";
			when 3 then set day_name="Mardi";
			when 4 then set day_name="Mercredi";
			when 5 then set day_name="Jeudi";
			when 6 then set day_name="Vendredi";
			when 7 then set day_name="Samedi";
			else
				set day_name="erreur";
        
        end case;
     
		return day_name;
     end$$
     
     delimiter ;
      select get_day_name(2)  

#equation 1er degrès
Ax+B=0
A=0 et B=0 solution toute valeur de R
A=0 et B!=0  Solution  impossible
A!=0  x=-B/A

#equation 2ème degrès
Ax²+Bx+C=0
a=0 et b=0 et c=0    R	
a=0 et b=0 et c!=0   impossible
a=0 et b!=0           x=-c/b
a!=0  delta=pow(b,2)-(4*a*c)
	delta = 0 x1=x2=-b/2a
	delta < 0  impossible de R
	delta > 0 x1 = -b-sqrt(delta)/2a
				x2 = -b+sqrt(delta)/2a
        
        
        
	#Les boucles
		#while
		#repeat
		#loop
    
#Les fonctions

#Les procedures