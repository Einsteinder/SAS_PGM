PROC IMPORT OUT= WORK.INCOME_BY_ZIP_2015 
            DATAFILE= "Y:\Downloads\SAS_Data\15zpallagi.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
