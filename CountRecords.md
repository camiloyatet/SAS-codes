# Contar los registros de todas las tablas de una libreria en particular

Este código toma como insumo el nombre de una libreria asignada a la conexión y cuenta los registros en cada las tablas de dicha libreria

		%let lib=SASHELP;
		
		proc sql noprint;
		    select memname into :tabla separated by ','
		     from dictionary.tables
		       where libname=&lib
		;quit;
		
		data registros;
			length Tabla $50;
				input Tabla $ Registros;
					cards;
		;run;
		
		%macro Contar_Registros /parmbuff;
		
		%let num=1;
		%let Val=%scan(&syspbuff,&num);
		%do  %while (&Val ne);
		
			proc sql;
				insert into registros
					select "&val", count(*) from SASHELP.&val
			;quit;
		
			%let num=%eval(&num+1);
			%let Val=%scan(&syspbuff,&num);
			
		%end;
		%mend;
		
		%Contar_Registros(&tabla);
