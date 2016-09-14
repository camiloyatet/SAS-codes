* Create date macrovariables;

* This short macro creates a set of global macrovariables in YYYYMM format acording to an initial and a final date;
* It also creates a variable that stores the number of months in the interval;
* The variable &per_0 stores the most recent month's value and &&per_&meses the least one.;

%let mes_inicial=01Sep2015;
%let mes_actual=31Aug2016; 
%let meses=%sysfunc(intck(month,"&mes_inicial"d,"&mes_actual"d));
 
%macro fechas;

  data _null_;
    %do i=&meses %to 0 %by -1; 
      %global per_&i;
      call symputx (compress("per_"||&i),put(intnx('month',"&mes_actual"d,-&i),yymmn6.)*1);
    %end;
  run;
  
%mend fechas;


