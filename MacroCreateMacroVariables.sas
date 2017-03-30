%macro CrearMacroVariables(input /*Input dataset*/, var /*Source Variable*/, name /*Prefix for macro variables*/, SASnames /*Boolean 1: Fix names in SAS rules 0:As it */);

%if &SASnames %then %do;

	data step1;
	set &input;
	&var=substr(compress(scan(&var,1,'. -|'),,'ka'),1,32);
	run;

	%global n&name;
	proc sql  noprint; select count(distinct &var) into :n&name from step1 ;
	 %do i=1 %to &&n&name;
	 	%global &&name.&i;
	 %end;
	select distinct(&var) into :&name.1- :&name%left(&&n&name) from step1 ;
	quit;
	
	%Borrar_Conjunto(work, step1);

%end;

%else %do;

	%global n&name;
	proc sql noprint; select count(distinct &var) into :n&name from &input ;
	 %do i=1 %to &&n&name;
	 	%global &&name.&i;
	 %end;
	select distinct(&var) into :&name.1- :&name%left(&&n&name) from &input ;
	quit;

%end;

%put _global_;

%mend;
