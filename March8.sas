***sales based advertise*;

libname sasdata "Y:\Downloads\SAS_Data";

proc copy in=sasdata out=work;
   select cereal_ds ;
run;

proc univariate data=cereal_ds normal;
var sugars;
run;

**title " Multipe regression for the cereal dataset rating vs. sugars anc"**;
title  "Simple Regression for the cereal dataset rating vs. sugars";
proc reg data = cereal_ds;
   model rating = sugars  /;
quit;
