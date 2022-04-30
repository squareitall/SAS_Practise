PROC IMPORT DATAFILE="/home/u60733603/web_analytics_sales.xlsx"
            OUT=web
            DBMS=xlsx
            REPLACE;
RUN;


data web;
	set web;
	
	trend=_n_;
	log_sales=log(Sales);
	M1 = (put(month,monname3.)='Jan');
  	M2 = (put(month,monname3.)='Feb');
  	M3 = (put(month,monname3.)='Mar');
  	M4 = (put(month,monname3.)='Apr');
  	M5 = (put(month,monname3.)='May');
  	M6 = (put(month,monname3.)='Jun');
  	M7 = (put(month,monname3.)='Jul');
  	M8 = (put(month,monname3.)='Aug');
  	M9 = (put(month,monname3.)='Sep');
  	M10= (put(month,monname3.)='Oct');
  	M11= (put(month,monname3.)='Nov');
  	M12= (put(month,monname3.)='Dec');
  	
  	lag_log_sales1=lag(log_sales);
  	lag_log_sales2=lag2(log_sales);
  	lag_log_sales3=lag3(log_sales);
  	lag_log_sales4=lag4(log_sales);
  	lag_log_sales5=lag5(log_sales);
  	lag_log_sales6=lag6(log_sales);
  	lag_log_sales7=lag7(log_sales);
  	lag_log_sales8=lag8(log_sales);
  	lag_log_sales9=lag9(log_sales);
  	lag_log_sales10=lag10(log_sales);
  	lag_log_sales11=lag11(log_sales);
  	lag_log_sales12=lag12(log_sales);
  	
Run;


Proc plot data=web;
	plot sales*month;
	plot log_sales*month;
Run;

Proc Reg Data=web;
	model log_sales=month / Spec;
run;

/* Testing Linearity, Independence of residuals using Ramsey and DurbinWatson Tests respectively that are available as options in Autoreg procedure  */

Proc Autoreg Data=web;
	model log_sales=month / RESET dwprob;
	output out=web r=residual_web;
Run;
/* Testing for Normality of residuals stored in the web data  */

Proc univariate data=web normal;
	var residual_web;
Run;

Proc reg Data=web;
	model log_sales=month M1-M11;
	output out=web r=residual_web;
Run;


Proc reg Data=web;
	model log_sales=month lag_log_sales1-lag_log_sales12;
	output out=web r=residual_web;
Run;

/* ## Ans 6  */
proc reg data=web;
  model log_sales=month lag_log_sales1-lag_log_sales12 / selection=stepwise inclide=1 slentry=0.05  slstay=0.10;
RUN;

Proc reg Data=web;
	model log_sales=month lag_log_sales1 lag_log_sales12;
	output out=web r=residual_web;
Run;

/*And 7 to 10  */

proc arima data=web; 
  identify var=log_sales nlags=24;
run;


proc arima data=web; 
  identify var=log_sales(1) ;
run;


data web;
	set web;
	log_log_sales=log(log_sales);
run;


