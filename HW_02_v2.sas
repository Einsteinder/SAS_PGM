***HW_02_#1***;
libname sasdata  "Y:\Downloads\SAS_Data";
libname sasdataA "Y:\Downloads\SAS_dataA";
libname sasdataB "Y:\Downloads\SAS_dataB";
libname sasdataC "Y:\Downloads\SAS_dataC";
libname sasdataD "Y:\Downloads\SAS_dataD";

proc copy in=sasdata out=work;
	select spanish_bank_student_acct;
run;



%let prim=997;

proc format;
  value clstfmt 
     low   - 249  =A
     250  - 499   =B
     500  - 749   =C
     750 -  high  =D
  ;
run;
data work.Spanish_bank_student_acct;
  set work.Spanish_bank_student_acct;
run;

data sasdataA.Spanish_bank_student_acct 
     sasdataB.Spanish_bank_student_acct 
     sasdataC.Spanish_bank_student_acct 
     sasdataD.Spanish_bank_student_acct 
	 empty
	 ;
 set work.Spanish_bank_student_acct
      ;
 cluster =put(mod(Customer_code,997),clstfmt.);
  
        if cluster='A' then output sasdataA.Spanish_bank_student_acct ;
   else if cluster='B' then output sasdataB.Spanish_bank_student_acct ;
   else if cluster='C' then output sasdataC.Spanish_bank_student_acct ;
   else if cluster='D' then output sasdataD.Spanish_bank_student_acct ;
   else output empty;
run;

***HW_02_#2***;

***TASK O***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit tasko wait = no sysrputsync = yes;
libname  sasdata "Y:\Downloads\SAS_data";
endrsubmit;
RDISPLAY;





rsubmit tasko wait=no sysrputsync = yes;
proc sql;
create table Numerator as
select count(*) as Numerator from 
sasdata.Spanish_bank_student_acct
where E_account=1 and Payroll=1;
quit;

proc sql;
create table Denom as
select count(*) as Denom from
sasdata.Spanish_bank_student_acct
where E_account=1 or Payroll=1;
quit;


proc sql;
create table EP_similar as
select a.numerator/b.denom as EP_similar 
from Numerator a,
denom b
;
quit;


proc sql;
create table EDNumerator as
select count(*) as Numerator from 
sasdata.Spanish_bank_student_acct
where E_account=1 and Direct_Debit=1;
quit;

proc sql;
create table EDDenom as
select count(*) as Denom from
sasdata.Spanish_bank_student_acct
where E_account=1 or Direct_Debit=1;
quit;


proc sql;
create table ED_similar as
select a.numerator/b.denom as ED_similar 
from EDNumerator a,
EDDenom b
;
quit;

endrsubmit;





libname rworko slibref = work server = tasko;



data oo;
set rworko.EP_similar;
set rworko.ED_similar;
run;


***
Conclusion:
Distance betwween the E_account” and  the “Payroll” is 0.1215588902 
Distance betwween the E_account” and  the “Direct_debit” is 0.162877222
***;
