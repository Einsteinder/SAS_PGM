libname sasdata  "Y:\Downloads\SAS_Data";

proc copy in=sasdata out =work;
	SELECT Cereal_ds vif_example;
	run;



  title " Multipe Regression for the cereal dataset rating vs. sugars and fiber";
proc reg data=cereal_ds  ;
     model     rating = sugars Fiber protein/stb;
      OUTPUT OUT=reg_cerealOUT  PREDICTED =c_predict
	   RESIDUAL=c_Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
	   rstudent = C_rstudent h=lev cookd=Cookd  dffits=dffit
         ;  
    
  quit;


  data cereal_ds_b;
  set cereal_ds;
  row_no=_n_;
  run;
  proc reg data=cereal_ds_b;
  model rating = sugars fiber  row_no;
  quit;


proc univariate data = vif_example normaltest noraml plot;
var y x1 x2;
run;

proc reg data = vif_example;
	*model y =x1;
	*model y=   x2;
	model y=x1 x2/vif;
quit;

  data cereal_ds2;
  	set cereal_ds;
	if shelf=1 then shelf1=1;
	else shelf1=0;
	if shelf=2 then shelf2=1;
	else shelf2=0;
	if shelf=3 then shelf3=1;
	else shelf3=0;
	shelf2_cal=shelf2*calories;
run;
proc reg data=cereal_ds2;
model rating = calories shelf1 shelf2/vif;
quit;


proc reg data=cereal_ds2;
model rating = calories shelf2/vif;
quit;


proc reg data=cereal_ds2;
model rating = calories shelf2_cal shelf2/vif;
quit;
