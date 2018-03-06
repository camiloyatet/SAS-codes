/*Macro to list the detail of all tables within a specified library ("lib") such as: name, number of variables 
  (total, numeric, character) creation date, last modification date and the total number or records*/
%macro MapearLibreria(lib /*Library name (case insensitive)*/);

* Listado y número de variables;
	proc sql;
		create table lista as
		select libname,	memname, nvar,	num_character,	num_numeric
		from dictionary.tables where libname=upcase("&lib")
		order by 2
	;quit;

* Conteo de Registros;
	proc sql; create table conteos as select '' length=32 as memname , . as Registros_&sysdate from sashelp.AIR where 1=0; quit;

	%CrearMacroVariables(lista,memname,tab,0);

	%do i=Cnt1 %to &ntab;
	*Este codigo es util cuando las tablas tienes permisos de lectura completos. 
	Adicionalmete, es mucho más eficiente;

	/*	data _null_;*/
	/*	set &lib..&&tab&i nobs=n;*/
	/*	call symput ('nrows',n);*/
	/*	stop;*/
	/*	run;*/

	/*	proc sql; insert into conteos values("&&tab&Cnt1", &nrows); quit;*/

		proc sql; insert into conteos select "&&tab&Cnt1", count(*) from &lib..&&tab&Cnt1; quit;

	%end;

* Unión de Tablas;
	data Mapeo_&lib._&sysdate;
	merge lista(in=a) conteos (in=b);
	by memname;
	if a;
	run;

*Eliminación de tablas auxiliares;

	%Borrar_Conjunto(work, lista conteos);

%mend;
