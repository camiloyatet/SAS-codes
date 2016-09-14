*Count records (__rows__) on every table from a given library;
*The following code takes a library's name (__libref__) and counts the rows of each table belonging to that library.;

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
					select "&val", count(*) from &&lib..&val
			;quit;
		
			%let num=%eval(&num+1);
			%let Val=%scan(&syspbuff,&num);
			
		%end;
		%mend;
		
		%Contar_Registros(&tabla);
