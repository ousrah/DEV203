

drop table  if exists bankaccounts;


CREATE TABLE bankaccounts(accountno varchar(20) PRIMARY KEY NOT NULL, 
							funds decimal(8,2),
                            check (funds>=0));

INSERT INTO bankaccounts VALUES("ACC1", 1000);
INSERT INTO bankaccounts VALUES("ACC2", 1000);

UPDATE bankaccounts SET funds=funds+200 WHERE accountno="acc1"; 
UPDATE bankaccounts SET funds=funds-200 WHERE accountno="acc2"; 

select * from bankaccounts;


select * from bankaccounts


DROP PROCEDURE IF EXISTS virement;
delimiter $$
CREATE PROCEDURE virement(acc1 varchar(10), acc2 varchar(10), amount float)
BEGIN
   DECLARE exit handler for SQLEXCEPTION
   BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
            @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
      --  set autocommit=1;
        SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
        SELECT @full_error;
   END;
-- set autocommit=0;
start transaction ;     
UPDATE bankaccounts SET funds=funds+amount WHERE accountno=acc2; 
UPDATE bankaccounts SET funds=funds-amount WHERE accountno=acc1; 
commit; 
-- set autocommit=1;
end$$
delimiter ;

call virement('acc1','acc2',300);
select * from bankaccounts;


SHOW VARIABLES LIKE 'AUTOCOMMIT';




















1