%macro sasmail(to /*(s) Quotated ans spaced separated*/, from /*Sender Adress Quotated*/, cc /*Copy*/, subject /*If empty fills with automatic variables*/, type /*text/plain*/, attach /*File name Quotated*/, mail_text /*Mail Body*/);

%if &subject.= %then %let subject="Correo automático de la cuenta de &syshostname. : &SYSSCPL.-SAS";
%if &type.= %then %let type="text/plain";

%if %length(&attach.) le 0 %then %do;
	FILENAME MYFILE EMAIL (&to.)
	SUBJECT=&subject.
	TYPE=&type.
	emailid=&from.
	cc=&cc.;
	 data _null_;
	 file myfile;
	 put "Buenos días" ;
	 put " " ;
	 put &mail_text.;
	 put " " ;
	 put " " ;
	 put " " ;
	 put "Nota: Este es un correo automático generado en &SYSSCPL.-SAS. Si usted ha recibido este correo por error, equivocación u omisión, queda estrictamente prohibido la utilización, copia, reimpresión o reenvío del mismo.";
	 put "Para mayor información, favor escribir a hyate@mc21colombia.com" ;
	 run;
	%end;

%else %do;
	FILENAME MYFILE EMAIL (&to.)
	SUBJECT=&subject.
	TYPE=&type.
	emailid=&from.
	attach=&attach.
	cc=&cc.;
	 data _null_;
	 file myfile;
     put "Buenos días" ;
	 put " " ; 
	 put &mail_text.;
	 put " " ;
	 put " " ;
	 put " " ;
	 put " " ;
	 put " " ;
	 put "Nota: Este es un correo automático generado en &SYSSCPL.-SAS. Si usted ha recibido este correo por error, equivocación u omisión, queda estrictamente prohibido la utilización, copia, reimpresión o reenvío del mismo." ;
	 put "Para mayor información, favor escribir a hyate@mc21colombia.com" ;
	 run;
%end;

%mend sasmail;
