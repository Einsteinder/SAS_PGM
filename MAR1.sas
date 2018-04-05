***TASK A***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskA wait = no sysrputsync = yes;
libname  sasdata "Y:\Downloads\SAS_dataA";
*%sysrput pathtaskB*;
endrsubmit;
RDISPLAY;


***TASK B***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskB wait = no sysrputsync = yes;
libname  sasdata "Y:\Downloads\SAS_dataB";

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

signoff _all_;






rsubmit taskA wait=no sysrputsync = yes;
proc sql;
create table max_income as
select max(Gross_income) as max_income from
sasdata.spanish_bank;
quit;

endrsubmit;


rsubmit taskB wait=no sysrputsync = yes;
proc sql;
create table max_income as
select max(Gross_income) as max_income from
sasdata.spanish_bank;
quit;

endrsubmit;


waitfor _all_ taskA taskB;
*%put &pathtask1;
*%put &pathtask2;
libname rworkA slibref = work server = taskA;
libname rworkB slibref = work server = taskB;


LISTTASK _ALL_;

rget taskb;

data bothAB;
set rworkA.max_income rworkB.max_income;
run;


libname sasdata "Y:\Downloads\SAS_Data";

proc copy in=sasdata out=work;
   select Character_matrix ;
run;

proc sql;
create table Numerator as
select count(*) as Numerator from 
Character_matrix
where doc5=1 and doc6=1;
quit;

proc sql;
create table Denom as
select count(*) as Denom from
Character_matrix
where doc5=1 or doc6=1;
quit;


proc sql;
create table similar as
select a.numerator/b.denom as similar 
from Numerator a,
denom b
;
quit;
