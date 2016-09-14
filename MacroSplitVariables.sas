* Macro for Split and Consolidate Variables;
* This macro splits a variariable according to a given character;
* It returns a narrow table it can return a narrow or wide table according to the parameter 'consolidar';

%macro separar(input /*Input*/, output /*Output*/, variable /*Variable to split*/, 
char /*Spliting character*/, consolidar /*1: Narrow table 0:Wide table*/);

  proc sql noprint; select (max(count(&variable,"&char")))+1 into :nvars from &input ;quit;
  
  proc contents data=&input out=metadata noprint ;run;
  proc sql noprint; select name into :vars_copy separated by " " from metadata where name ne "&variable" 
  order by varnum ; quit;
  
  %if &consolidar %then %do;
  
    data step1;
      set &input;
      %do i=1 %to &nvars;
        &variable&i=scan(&variable,&i,"&char");
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
