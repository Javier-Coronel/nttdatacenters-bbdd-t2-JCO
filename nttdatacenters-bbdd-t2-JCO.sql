use DUAL_NTTDATA;

/*
 * El procedimiento hara que el salario de los mentores aumente 
 * dependiendo de cuantos alumnos tienen a su cargo.
*/
drop procedure if exists modificacionDeSueldo;
delimiter $$
create procedure modificacionDeSueldo()
begin
	declare dniACambiar varchar(9);
	declare porcentaje double(9,2);
	declare especialidad varchar(20);
	declare done boolean default true;
	declare contador int default 0;
	declare relacion cursor for select count(alumno), m.DNI, m.especializacion  
		from mentor m inner join ensenanza e on m.DNI = e.mentor group by m.DNI ;
	declare continue handler for not found set done = false;
	open relacion;

	while done do
		fetch relacion into porcentaje, dniACambiar, especialidad ;
		-- Hacemos que si el mentor tiene de especializacion full stack se duplique el aumento
		if especialidad like "Full Stack" then 
			set porcentaje = porcentaje * 2;
		end if;
		update cuenta c set c.salario = (c.salario * (100 + porcentaje))/100 where c.dni = dniACambiar ;
		set contador = contador + 1;
	end while;
	close relacion;
end$$ 
delimiter ;

call modificacionDeSueldo;

