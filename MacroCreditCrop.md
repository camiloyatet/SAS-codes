# Crediit crop construction

This macro creates a credit crop according to a given number of days of default. This macro uses the macro variables created by the [MacroDates](https://github.com/camiloyatet/SAS-codes/blob/master/MacroDates.md)


    %macro cosechas (altura);
    
    proc sql;
    	create table step1 as 
    	select 
    	periodo
    	,count(id_cliente) as Cuenta
    		%do i=&meses %to 0 %by -1;
    			,sum(case when diasmora&&per_&i > &altura then 1 else 0 end) as pct&&per_&i
    		%end;
    	from BD
    	group by 1
    ;quit;
    
    data step2;
      set step1;
      array pct(*) cuenta--pct&per_0;
      array mes(*) mes0-mes&meses;
      
      %do i=&meses %to 0 %by -1;
        if mes_financiacion=&&per_&i then cons=%eval(&meses+1)-&i;
      %end;
    
      do j=2 to dim(pct);
        pct(j)=pct(j)/pct(1);
      end;
    
      do k=1 to num;
        pos=k+cons;
        if pos<=num then mes(k)=pct(pos);
      end;
    
      format mes0-mes&meses percent10.2;
      drop pct&&per_&meses--pct&per_0 num cons k pos j;
    run;
    
    proc sql;
      title "Cosecha a &altura dias";
      select * from step2
    ;quit;
    
    proc datasets lib=work nolist nodetails nowarn;
      delete step1 step2;
    run;
    
    %mend cosechas;
