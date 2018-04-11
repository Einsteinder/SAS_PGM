*HW_Midtem*;
*1*;
libname sasdata  "Y:\Downloads\SAS_Data";


proc copy in=sasdata out=work;
    select baseball;
run;


*** Normalize the data ***;
PROC STANDARD DATA=baseball(keep= age games at_bats runs hits doubles triples rbis walks strikeouts bat_ave on_base_pct slugging_pct stolen_bases caught_stealing) MEAN=0 STD=1 
             OUT=baseball_z;
RUN;


title "Principal Component Analysis"; 

proc princomp   data=baseball_z ;
   var  age games at_bats runs hits doubles triples RBIs walks strikeouts bat_ave on_base_pct slugging_pct stolen_bases caught_stealing;
run;
*Result: First 4 component data
Eigenvalues of the Correlation Matrix 
  Eigenvalue Difference Proportion Cumulative 
1 8.70254667 6.19412458 0.5802 0.5802 
2 2.50842209 1.22997734 0.1672 0.7474 
3 1.27844475 0.36819826 0.0852 0.8326 
4 0.91024649 0.49023842 0.0607 0.8933 

*;

*4 components should be extracted, because sn eigenvalue of 1 would mean that the component would explain about “one variable’s worth” of the variability. 
And Component 4 has an eigenvalue of 0.91024649, which is not too far from 1, so I decide to consider retaining this component as well*;





*2*;
proc copy in=sasdata out=work;
    select cereal_ds;
run;
*a)*;
*Construct the scatter plot*;
proc sgplot data=cereal_ds  ;
  scatter     x= sodium  y=rating ;  
run;
*b)*;
*regression analysis*;
proc reg data=cereal_ds      ;
     model     rating = sodium;
      OUTPUT OUT=reg_cereal_out  PREDICTED =rating_predict
       RESIDUAL=c_Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
       rstudent = C_rstudent h=lev cookd=Cookd  dffits=dffit;  
    
  quit;






 *3*;
 *a)*;
 * Multiple Regression for the cereal dataset depression vs. income, sex and age*;
  proc copy in=sasdata out=work;
    select depression;
run;
  proc reg data=depression;     
     model     cat_total = income sex age/stb;
      OUTPUT OUT=reg_depressionOUT  PREDICTED =level_predict
       RESIDUAL=c_Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
       rstudent = C_rstudent h=lev cookd=Cookd  dffits=dffit
         ;  
    
  quit;
 *Answer: We cannot assume that residuals follow a normal distribution, because it is like an arc. 
  The normal distribution would follow the regression line.*;

*b)*;
*influential observations are evaluated by Cook's Distance, So I am ready to delete first 15 rows with highest Cook's Distance*;
*Sort depression data set according to Cook's Distance*;
 proc sort data=reg_depressionOUT out=reg_depressionOUT_sorted;    
     by descending Cookd ;
run;

*The 15th observation's Cook's distance is 0.0136471014 *;

*Delet rows that Cook's distance bigger and equal than 0.0136471014 *;
 DATA reg_dep_sorted_delete_15;
     SET reg_depressionOUT_sorted;
     IF Cookd < 0.0136471014;
  RUN;

*Repeat the regression after delete 15 observations that are most influential*;
    proc reg data=reg_dep_sorted_delete_15;     
     model     cat_total = income sex age/stb;
      OUTPUT OUT=re_reg_depressionOUT_delete15  PREDICTED =level_predict
       RESIDUAL=c_Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
       rstudent = C_rstudent h=lev cookd=Cookd  dffits=dffit
         ;  
    
  quit;
 *Answer: We still cannot assume that residuals follow a normal distribution, because it is like an arc. 
  A normal distribution would follow the regression line.*;

*c)*;
*observations' leverage is evaluated by leverage score, So I am ready to delete first 15 rows with highest leverage score*;

*Sort depression data set according leverage score*;
   proc sort data=reg_depressionOUT out=reg_depressionOUT_sorted_lev;    
     by descending lev ;
run;

*The 15th observation's leverage score is 0.0267672895 *;

*Delet rows that Cook's distance bigger and equal than 0.0267672895 *;
 DATA reg_dep_sorted_delete_lev_15;
     SET reg_depressionOUT_sorted_lev;
     IF lev < 0.0267672895;
  RUN;

  
*Repeat the regression after delete 15 observations that are most influential*;
    proc reg data=reg_dep_sorted_delete_lev_15;     
     model     cat_total = income sex age/stb;
      OUTPUT OUT=re_reg_depressionOUT_delete15_lev  PREDICTED =level_predict
       RESIDUAL=c_Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
       rstudent = C_rstudent h=lev cookd=Cookd  dffits=dffit
         ;  
    
  quit;
 *Answer: We still cannot assume that residuals follow a normal distribution, because it is like an arc. 
  A normal distribution would follow the regression line.*;



  *4*;

*Distribute SAS data over multiple node*;
 
libname sasdataA "Y:\Downloads\SAS_dataA";
libname sasdataB "Y:\Downloads\SAS_dataB";
libname sasdataC "Y:\Downloads\SAS_dataC";
libname sasdataD "Y:\Downloads\SAS_dataD";

  proc copy in=sasdata out=work;
    select spanish_bank_student;
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


data sasdataA.Spanish_bank_student 
     sasdataB.Spanish_bank_student
     sasdataC.Spanish_bank_student
     sasdataD.Spanish_bank_student
	 empty
	 ;
 set Spanish_bank_student
      ;
 cluster =put(mod(Customer_code,997),clstfmt.);
  
        if cluster='A' then output sasdataA.Spanish_bank_student ;
   else if cluster='B' then output sasdataB.Spanish_bank_student ;
   else if cluster='C' then output sasdataC.Spanish_bank_student ;
   else if cluster='D' then output sasdataD.Spanish_bank_student ;
   else output empty;
run;
*Distributed SQL*;

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



*Calucate the number of observation and the sum of ages in each remote server*;

rsubmit taskA wait=no sysrputsync = yes;
proc sql;
create table membercount as
select count(*) as denominator from 
sasdata.Spanish_bank_student
quit;

proc sql;
create table sumage as
SELECT SUM(age) as totalage
FROM sasdata.Spanish_bank_student

quit;

endrsubmit;

rsubmit taskB wait=no sysrputsync = yes;
proc sql;
create table membercount as
select count(*) as denominator from 
sasdata.Spanish_bank_student
quit;

proc sql;
create table sumage as
SELECT SUM(age) as totalage
FROM sasdata.Spanish_bank_student

quit;

endrsubmit;

rsubmit taskC wait=no sysrputsync = yes;
proc sql;
create table membercount as
select count(*) as denominator from 
sasdata.Spanish_bank_student
quit;

proc sql;
create table sumage as
SELECT SUM(age) as totalage
FROM sasdata.Spanish_bank_student

quit;

endrsubmit;

rsubmit taskD wait=no sysrputsync = yes;
proc sql;
create table membercount as
select count(*) as denominator from 
sasdata.Spanish_bank_student
quit;

proc sql;
create table sumage as
SELECT SUM(age) as totalage
FROM sasdata.Spanish_bank_student

quit;

endrsubmit;

*set up remote library*;
libname rworkA slibref = work server = taskA;
libname rworkB slibref = work server = taskB;
libname rworkC slibref = work server = taskC;
libname rworkD slibref = work server = taskD;

*retrieve data from remote server*;
data sumandage;
set rworkA.membercount rworkB.membercount rworkC.membercount rworkD.membercount ;
set rworkA.sumage rworkB.sumage rworkC.sumage rworkD.sumage;
run;


*Caculate reault*;
proc sql;
create table RESULT as
select sum(totalage)/sum(denominator)from work.sumandage
;
quit;

*we got reault is 56.213125886 *;
*So the average age is 56.213125886 *;
