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

***TASK A***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskA wait = no sysrputsync = yes;
libname  sasdata "Y:\Downloads\SAS_dataA";
endrsubmit;
RDISPLAY;


***TASK B***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskB wait = no sysrputsync = yes;
libname  sasdata "Y:\Downloads\SAS_dataA";
endrsubmit;
RDISPLAY;

***TASK C***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskC wait = no sysrputsync = yes;
libname  sasdata "Y:\Downloads\SAS_dataC";

endrsubmit;
RDISPLAY;


***TASK D***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskD wait = no sysrputsync = yes;
libname  sasdata "Y:\Downloads\SAS_dataD";

endrsubmit;
RDISPLAY;



rsubmit taskA wait=no sysrputsync = yes;
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


rsubmit taskB wait=no sysrputsync = yes;
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



rsubmit taskC wait=no sysrputsync = yes;
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


rsubmit taskD wait=no sysrputsync = yes;
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






libname rworkA slibref = work server = taskA;
libname rworkB slibref = work server = taskB;
libname rworkC slibref = work server = taskC;
libname rworkD slibref = work server = taskD;


data ALLABCD;
set rworkA.EP_similar rworkB.EP_similar rworkC.EP_similar rworkD.EP_similar ;
set rworkA.ED_similar rworkB.ED_similar rworkC.ED_similar rworkD.ED_similar;
run;


data RESULT;
set WORK.ALLABCD.EP_similar/4;
set WORK.ALLABCD.ED_similar/4;
run;

proc sql;
create table RESULT as
select avg(EP_similar), avg(ED_similar)from WORK.ALLABCD 
;
quit;

***
Conclusion:
Distance betwween the E_account” and  the “Payroll” is 0.1204430333   
Distance betwween the E_account” and  the “Direct_debit” is 0.1590853176
