use notes;
drop table if exists test ;
create table test (id int auto_increment primary key, nom varchar(50) not null unique);

insert into test (nom) values ('iam');
insert into test (nom) values ('meditel');
insert into test (nom) values ('meditel');
insert into test (nom) values (null);



drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(v_name varchar(50))
begin
		declare exit handler for 1062 select("ce nom exist déjà");
		declare exit handler for 1048 select("le nom est obligatoire");
		insert into  test (nom) values (v_name);
end$$
delimiter ;


drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(v_name varchar(50))
begin
	declare flag boolean default true;
	begin
		declare exit handler for 1062 set flag=false;
		declare exit handler for 1048 set flag=false;
		insert into  test (nom) values (v_name);
	end;
    if not flag then
		select("erreur d'insertion");
    end if;
    -- select("fin du script");
end$$
delimiter ;



drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(v_name varchar(50))
begin
	declare msg varchar(100) default "";
	begin
		declare exit handler for 1062 set msg="ce nom exist deja";
		declare exit handler for 1048 set msg="le nom est obligatoire";
		insert into  test (nom) values (v_name);
	end;
    if msg!="" then
		select(msg);
    end if;
    -- select("fin du script");
end$$
delimiter ;



drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(v_name varchar(50))
begin
	declare err int default 0;
	begin
		declare exit handler for 1062 set err=1;
		declare exit handler for 1048 set err=2;
		insert into  test (nom) values (v_name);
	end;
    if err!=0 then
	case err
		when 1 then select "ce nom existe déjà";
        when 2 then select "le nom est obligatoire";
    end case;
    end if;
    -- select("fin du script");
end$$
delimiter ;


drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(v_name varchar(50))
begin
	declare flag boolean default true;
    declare errno int;
    declare msgtext varchar(50);
    declare sql_state varchar(5);
	begin
		declare exit handler for sqlexception 
        begin
			get diagnostics  condition 1 
					sql_state = RETURNED_SQLSTATE, 
					errno = MYSQL_ERRNO, 
                    msgtext = MESSAGE_TEXT;
			set flag=false;
        end;
		insert into  test (nom) values (v_name);
	end;
    if not flag then
	  select msgtext;
    end if;
    -- select("fin du script");
end$$
delimiter ;





drop procedure if exists set_test;
delimiter $$
create procedure set_test(v_name varchar(50))
begin
	declare flag boolean default true;
	declare a int;
	begin
		declare exit handler for sqlstate 'HY000' set flag=false;
		set a = v_name;
	end;
    if not flag then
	  select "erreur de conversion";
    end if;
    -- select("fin du script");
end$$
delimiter ;




drop procedure if exists get_id_by_name;
delimiter $$
create procedure get_id_by_name(v_name varchar(50), out v_id int )
begin
	declare flag boolean default true;
	begin
		declare exit handler for not found set flag=false;
		select id into v_id from test where nom = v_name;
        select "ce nom exist";
	end;
    if not flag then
	  select "ce nom n'existe pas";
    end if;
    -- select("fin du script");
end$$
delimiter ;

call get_id_by_name("ofppt654",@a);
select @a;



call set_test('1');
call set_test(null);
select * from test;




#appel d'une procedure en cas d'erreur
drop procedure if exists ps_err;
DELIMITER $$
CREATE PROCEDURE ps_err ()
BEGIN
	SELECT 'Une autre erreur est survenue' ;
END$$
DELIMITER ;

drop procedure if exists select_test;
delimiter $$
create procedure select_test(v_name varchar(50))
begin 
	declare var1 varchar(50);
    declare exit handler for  sqlexception call ps_err();
    INSERT INTO table_inexistante VALUES (1);
end$$
delimiter ;

call select_test("ismo");




drop procedure if exists division;
delimiter $$
create procedure division(a int, b int)
begin
    declare r float;
	if b=0 then
		signal SQLSTATE 'HY001' SET MESSAGE_TEXT = 'division par zero non autorisée';
	else
		set r = a/b;
	end if;
	select r;
end$$
delimiter ;

call division(3,0);



drop procedure if exists divide;
DELIMITER $$
CREATE PROCEDURE Divide(IN numerator INT,	IN denominator INT,	OUT result double)
BEGIN
	DECLARE division_by_zero CONDITION FOR SQLSTATE '22012' ;
	DECLARE CONTINUE HANDLER FOR division_by_zero 
	 RESIGNAL SET MESSAGE_TEXT = 'Division by zero / Denominator cannot bezero';
	IF denominator = 0 THEN
		SIGNAL division_by_zero;
	ELSE
		SET result = numerator / denominator;
	END IF ;
END$$
delimiter ;

call Divide(5,0,@r);
select @r;