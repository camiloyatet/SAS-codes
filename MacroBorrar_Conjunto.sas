/*Macro to delete auxiliar datasets*/

%macro Borrar_Conjunto(lib/*Libname*/, input/*Space separated list of datasets to be deleted*/);
	proc datasets nodetails nolist nowarn lib=&lib;
	delete &input;
	run;
%mend;
