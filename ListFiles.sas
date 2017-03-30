/*Macro to create a table with all the files within a directory that match with a given extension*/

%macro ListarArchivos(dir /*Directory to list*/,ext/*Extension of desired files*/,output=listado /*Name of output table*/);  

proc sql;create table &output as select '' as Listado length= 100 format=$CHAR100. as Archivo from sasuser.librefs  where 1=0;quit;
 
%local filrf rc did memcnt name i;

%let rc=%sysfunc(filename(filrf,&dir));
%let did=%sysfunc(dopen(&filrf));

%if &did eq 0 %then %do; /* If directory can't be open, shows message and ends macro execution */
	%put El directorio &dir no se pudo abrir o no existe;
	%return;
%end;

%do i = 1 %to %sysfunc(dnum(&did)); /*Loop through directory*/

	/* Store name of each file */
	%let name=%qsysfunc(dread(&did,&i));

	/* Checks if the extension matches the parameter value*/
	
	%if %qupcase(%qscan(&name,-1,.)) = %upcase(&ext) %then %do; /* if condition is true insert name into output table*/
		proc sql; insert into &output values ("&name"); quit;
	%end;

	%else %if %qscan(&name,2,.) = %then %do; /*Test for null character values*/
		%ListarArchivos(&dir\%unquote(&name),&ext)
	%end;

%end;

/* closes the directory and clear the fileref */
%let rc=%sysfunc(dclose(&did));
%let rc=%sysfunc(filename(filrf));

%mend ListarArchivos;
