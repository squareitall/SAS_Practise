libname square "/home/u60733603/first_files";
data square.RATINGS;
  infile '/home/u60733603/first_files/job ratings.txt' firstobs=2;
  input JOB KNOWHOW PROBLEM_SOLVING ACCOUNTABILITY SALARY;
cards;
run;

proc princomp data=square.RATINGS out=job_ratings_PCA_3;
var KNOWHOW PROBLEM_SOLVING ACCOUNTABILITY;
RUN;

data square.prin_data;
  infile '/home/u60733603/first_files/col_prin.txt' firstobs=1;
  input KNOWHOW PROBLEM_SOLVING ACCOUNTABILITY PRIN1 PRIN2 PRIN3;
cards;
run;

proc reg data=square.prin_data;
model PRIN1 = KNOWHOW PROBLEM_SOLVING ACCOUNTABILITY /Noint;
run;

proc reg data=square.prin_data;
model KNOWHOW = PRIN1 PRIN2 PRIN3 /Noint;
run;

proc corr data=square.prin_data;
var PRIN1 PRIN2 PRIN3;
with KNOWHOW PROBLEM_SOLVING ACCOUNTABILITY;
run;

/* proc sort data=square.RATINGS; */
/* by KNOWHOW PROBLEM_SOLVING ACCOUNTABILITY; */
/* run; */
/* proc sort data=square.prin_data; */
/* by KNOWHOW PROBLEM_SOLVING ACCOUNTABILITY; */
/* run; */

data square.merged_data;
merge square.RATINGS square.prin_data;
/* by KNOWHOW PROBLEM_SOLVING ACCOUNTABILITY; */
run;

/* proc options option=mergenoby; */
/* run; */

proc reg data=square.merged_data;
model Salary = PRIN1 PRIN2 PRIN3 ;
run;

proc reg data=square.merged_data;
model Salary = PRIN1 PRIN2 PRIN3 / ss1 ss2 vif;
run;
/* As three components are independednt the ss1 scores will be same as ss2 */

proc reg data=square.merged_data;
model Salary = PRIN1  / ss1 ss2 vif;
run;
