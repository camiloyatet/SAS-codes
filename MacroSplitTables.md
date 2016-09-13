#Split Tables in given number of tables '&num'

This macro is useful in order to split a large dataset in a number of smaller tables.

    %macro split_rows(lib,db,num);
    
    proc sql; select count(*) format=best10. into :numobs from &lib..&db; quit;
    
    %let n=%sysevalf(&numobs/&num,ceil);
    
    	%do j=1 %to &num;	
    
    	data part_&j;
    	set &lib..&db;
    	if %eval(&n*(&j-1))<_n_<= %eval(&n*&j) then output part_&J;
    	run;
    
    	proc export data=part_&j replace
    	outfile="C:\Users\hyate\Desktop\CargaTableau\&&part_&J..txt"
    	dbms=dlm; 
    	delimiter='~';
    	run;
    
    	%end;
    
    %mend split_rows; 
