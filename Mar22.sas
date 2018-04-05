libname sasdata  "Y:\Downloads\SAS_Data";
libname sasdataA "Y:\Downloads\SAS_dataA";
libname sasdataB "Y:\Downloads\SAS_dataB";
libname sasdataC "Y:\Downloads\SAS_dataC";
libname sasdataD "Y:\Downloads\SAS_dataD";

proc copy in=sasdata out=work;
	select cereal_ds;
run;

proc reg data=cereal_ds;
model rating = Sugars;
run;
quit;


title " Multipe Regression for the cereal dataset rating vs. sugars and fiber";
proc reg data=cereal_ds  ;
     model     rating = sugars Fiber protein;
      OUTPUT OUT=reg_cerealOUT  
       h=lev cookd=Cookd  dffits=dffit
L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95

         ;  
    
  quit;


  proc univariate data = reg_cerealOUT;
  var lev cookd dffit;
  run;


  title " Multipe Regression for the cereal dataset rating vs. sugars and fiber";
proc reg data=cereal_ds  ;
     model     rating = Fiber protein/stb;
      OUTPUT OUT=reg_cerealOUT  
       h=lev cookd=Cookd  dffits=dffit
L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95

         ;  
    
  quit;


  PROC STANDARD DATA = cereal_ds(keep = rating sugars fiber protein)
  				MEAN=0 STD =1
				OUT = cereal_ds_z;
	VAR rating sugars fiber protein;
RUN;


proc reg data=cereal_ds_z  ;
     model     rating = Fiber protein;
      OUTPUT OUT=reg_cerealOUT  
       h=lev cookd=Cookd  dffits=dffit
L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95

         ;  
    
  quit;
