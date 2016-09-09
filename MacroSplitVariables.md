# Macro for Split and Consolidate Variables
This macro splits a variariable according to a given character and creates one variable for each value. It returns a narrow table

    %macro separar(input, output, variable, char, consolidar=0);
    
    proc sql noprint; select (max(count(&variable,"&char")))+1 into :nvars from &input ;quit;
    proc contents data=&input out=metadata noprint ;run;
    proc sql noprint; select name into :vars_copy separated by " " from metadata where name ne "&variable" order by VARNUM ; quit;
    
    %if &consolidar %then %do;
    
    data step1;
      set &input;
      %do i=1 %to &nvars;
       &variable&i=scan(&variable,&i,'|');
      %end;
    drop &variable;
    run;
    
    proc sort data=step1; by &vars_copy; run;
    
    proc transpose data=step1 out= step2 (drop=_name_); 
    by &vars_copy;
    var &variable.1 - &variable%trim(&nvars);
    run;
    
    data &output;
    set step2 (rename=col1=&variable);
    where &variable ne '';
    run;
    
    %end;
    
    %else %do;
    
    data &output;
      set &input;
      %do i=1 %to &nvars;
       &variable&i=scan(&variable,&i,'|');
      %end;
    drop &variable;
    run;
    
    %end;
    
    proc datasets nodetails nolist nowarn lib=work;
    delete step1 step2 metadata;
    run;
    
    %mend;
