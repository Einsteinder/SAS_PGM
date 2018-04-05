libname sasdata "\\Mac\Home\Desktop\SAS_data";
libname sasdataA "\\Mac\Home\Desktop\SASdataA";
libname sasdataB "\\Mac\Home\Desktop\SASdataB";
libname sasdataC "\\Mac\Home\Desktop\SASdataC";
libname sasdataD "\\Mac\Home\Desktop\SASdataD";


proc copy in=sasdata out=work;
	select spanish_bank_student;
run;

data spanish_bank_student2;
	set spanish_bank_student(rename=(Gross_income=Gross_incomeb));
	Gross_income=input(Gross_incomeb,8.);
	GI_Cat=put(Gross_income,GIfmt.);
	nmod=mod(_n_,11);
run;

proc format;
	value GIfmt
		low	- 200000 =A
		200000< - high =B
	;
run;

%let prim=997;

proc format;
	value clstfmt
		low - 249 =A
		250 - 499 =B
		500 - 749 =C
		750 - high =D
	;
run;

data sasdataa.spanish_bank
	 sasdatab.spanish_bank
	 sasdatac.spanish_bank
	 sasdatad.spanish_bank
	 empty
	 ;
	set sasdata.spanish_bank_student;
	cluster =put(mod(customer_code,997),clstfmt.);
	
		if cluster ='A' then output sasdataa.spanish_bank ;
		else if cluster ='B' then output sasdatab.spanish_bank ;
		else if cluster ='C' then output sasdatac.spanish_bank ;
		else if cluster ='D' then output sasdatad.spanish_bank ;
		else output empty;
run;
