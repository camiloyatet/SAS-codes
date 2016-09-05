# Macro for Spliting Variables
This macro splits a variariable according to a given character and creates one variable for each value.

    data resultado;
    length variable $50 paciente 8 valor $900;
    input variable $CHAR50. paciente BEST2. valor $CHAR900.;
    cards;
    ;run;

    %macro separar(input, variable, char);
    
    	proc sql noprint; select (max(count(&variable,"&char")))+1 into :ndx from &input ;quit;
    
    	data paso1;
    	set &input
    	%do i=1 %to &ndx;
    	 &variable&i=scan(&variable,&i,'|');
    	%end;
    	keep id %do i=1 %to &ndx; &variable&i %end; ;
    	run;
    
    	%do i=1 %to &ndx;
    	proc sql; insert into resultado select "&variable", Id, strip(compbl(upcase(&variable&i))) 
    	from paso1 where &variable&i ne '';quit;
    	%end;
    
    %mend;
    
    %separar(tabla, DC_Dx, |)
