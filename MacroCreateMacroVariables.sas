/*Create character macrovariables for each record in a given table*/
%macro CrearMacroVariables(input /*Input dataset*/, var /*Source Variable*/, name /*Prefix for macro variables*/, SASnames /*Boolean 1: Fix names in SAS rules 0:As is */);

%if &SASnames %then %do;

	data step1; /*Imp. Oportunity*/
	set &input;
	if lengthn(compress(&var,,'kf'))=1 then &var=substr(compress(scan(&var,1,'. -|'),,'kn'),1,30);
	else &var=cats('_',substr(compress(scan(&var,1,'. -|'),,'kn'),1,30));	
	run;

	%global n&name;
	proc sql  noprint; select count(distinct &var) into :n&name from step1 ;
	 %do Cnt1=1 %to &&n&name;
	 	%global &&name.&Cnt1;
	 %end;
	select distinct(&var) into :&name.1- :&name%left(&&n&name) from step1 ;
	quit;
	
	%Borrar_Conjunto(work, step1);

%end;

%else %do;

	%global n&name;
	proc sql noprint; select count(distinct &var) into :n&name from &input ;
	 %do Cnt1=1 %to &&n&name;
	 	%global &&name.&Cnt1;
	 %end;
	select distinct(&var) into :&name.1- :&name%left(&&n&name) from &input ;
	quit;

%end;

%mend;
