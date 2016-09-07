# Macro for Spliting Variables
This macro splits a variariable according to a given character and creates one variable for each value.

    %macro separar(input, output, variable, char);
    proc sql noprint; select (max(count(&variable,"&char")))+1 into :nvars from &input ;quit;
    proc contents data=&input out=metadata noprint ;run;
    proc sql noprint; select distinct(name) into :vars_copy separated by " " from metadata where name ne "&variable"; quit;
  
    data paso1;
      set &input;
      %do i=1 %to &nvars;
       &variable&i=scan(&variable,&i,'|');
      %end;
    drop &variable;
      run
   
    proc transpose data=paso1 out= trans (drop=_name_); 
    by &vars_copy;
    var &variable.1 - &variable%trim(&nvars);
    run;
    
    data &output;
    set trans (rename=col1=&variable);
    where &variable ne '';
    run;
    
    proc datasets nodetails nolist nowarn lib=work;
    delete paso1 trans metadata;
    run;
  
    %mend;
