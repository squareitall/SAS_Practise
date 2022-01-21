libname square "/home/u60733603/first_files";
data square.record;
	input name $ age salary gender $;
	newsalary= salary*1.10;
datalines;

Bill 30 36000 M
Mary 40 30000 F
Jim 32 27000 M

run;
proc means data=work.data1;
run;
proc reg;
	model salary = age;
run;
quit;

	