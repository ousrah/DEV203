drop database if exists ecole;
create database ecole collate "utf8_general_ci";
use ecole;

create table Salle (NumSalle int auto_increment primary key,
					Etage int ,
					NombreChaises int,
                    check (nombrechaises between 20 and 30));
                    
create table Transfert (id int auto_increment primary key,
						NumSalleOrigine int,
                        foreign key (NumSalleOrigine) references salle(NumSalle),
                        NumSalleDestination int, 
                        foreign key (NumSalleDestination) references salle(NumSalle),
                        DateTransfert datetime default current_timestamp,
                        NbChaisesTransférées int);
                        
insert into salle values (1,1,24),(2,1,26),(3,1,26),(4,2,28);

drop procedure if exists tranfertChaises;
delimiter $$
create procedure  tranfertChaises(so int, sd int, nc int)
begin
	 declare exit handler for sqlexception  
     begin
		 select("erreur de transfert");
		 rollback;
	 end;
	start transaction;
		update salle set nombrechaises = nombrechaises - nc where NumSalle = so;
		update salle set nombrechaises = nombrechaises + nc where NumSalle = sd;
		insert into transfert(NumSalleOrigine,NumSalleDestination,NbChaisesTransférées) values (so,sd,nc);
	commit;
end$$
delimiter ;

call tranfertChaises(3,2,2);
select * from salle;
