use notes;
drop procedure if exists get_list_name;
DELIMITER $
CREATE PROCEDURE get_list_name (INOUT name_list varchar(800))
BEGIN
  -- déclarer la variable pour le gestionnaire NOT FOUND.
  DECLARE is_done INTEGER DEFAULT 0;
  -- déclarer la variable qui va contenir les noms des clients récupérer par le curseur .
  DECLARE c_name varchar(100)  DEFAULT "";
  -- déclarer le curseur
  DECLARE client_cursor CURSOR FOR
    SELECT nom FROM stagiaire;
  -- déclarer le gestionnaire NOT FOUND
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_done = 1;
  
  -- ouvrir le curseur
  OPEN client_cursor;
	-- parcourir la liste des noms des clients et concatèner tous les noms où chaque nom est séparé par un point-virgule(;)
	  l: LOOP
	  FETCH client_cursor INTO c_name;
		  IF is_done = 1 THEN
		  LEAVE get_list;
		  END IF;
		  SET name_list = CONCAT(c_name,";",name_list);
	  END LOOP l;
	  -- fermer le curseur
  CLOSE client_cursor;
END$
set @a="";
call get_list_name(@a);
select @a;