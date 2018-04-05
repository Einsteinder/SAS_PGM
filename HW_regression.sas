*HW_regression*;

libname sasdata  "Y:\Downloads\SAS_Data";

proc copy in=sasdata out=work;
	select lung;
run;

proc copy in=sasdata out=work;
	select depression;
run;

*1-Using the “Family Lung” data set fit the regression plane for the father using FVC of father as the 
dependent variable and age and height of the father as the independent variables (see below)*;



proc reg data=WORK.lung	  ;
     model     FVC_FATHER = AGE_FATHER HEIGHT_FATHER/stb;
      OUTPUT OUT=reg_LUNGOUT  PREDICTED =FVC_predict
	   RESIDUAL=c_Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
	   rstudent = C_rstudent h=lev cookd=Cookd  dffits=dffit;  
    
  quit;


*2-For the “Depression” dataset predict the reported level of depression as given by CESD, using 
income, sex, age as independent variables. Analyze the residuals and decide whether or not it is reasonable 
to assume that they follow a normal distribution.* ;

proc reg data=WORK.depression;	 
     model     cat_total = income sex age/stb;
      OUTPUT OUT=reg_depressionOUT  PREDICTED =level_predict
	   RESIDUAL=c_Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
	   rstudent = C_rstudent h=lev cookd=Cookd  dffits=dffit
         ;  
    
  quit;
 *Answer: We cannot asuume that residuals follow a normal distribution, because it is like an arc. 
  Normal distribution would be follow the regression line.*



*3- Using the “Family Lung” data set fit a regression model to predict height of the oldest child by choosing 
from among the variables: AGE of oldest child,  WEIGHT of oldest child, HEIGHT of the mother, WEIGHT of the mother, 
HEIGHT of the father, WEIGHT of the father (see below).*;

proc reg data=WORK.lung;	 
     model     Height_oldest_child = Age_oldest_child Weight_oldest_child Height_mother Weight_mother Height_father Weight_father/stb;
      OUTPUT OUT=reg_lungOUT2  PREDICTED =heightOfOchild_predict
	   RESIDUAL=c_Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
	   rstudent = C_rstudent h=lev cookd=Cookd  dffits=dffit
         ;  
    
  quit;

  *After analysis, we can find Weight_mother and Weight_father is not significant through observing P value, so we can drop them. *;

  proc reg data=WORK.lung;	 
     model     Height_oldest_child = Age_oldest_child Weight_oldest_child Height_mother Height_father /stb;
      OUTPUT OUT=reg_lungOUT3  PREDICTED =heightOfOchild_predict
	   RESIDUAL=c_Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
	   rstudent = C_rstudent h=lev cookd=Cookd  dffits=dffit
         ;  
    
  quit;
  *For now, our model is good.*
