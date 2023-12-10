LIbname REG QUERY "HKEY_CURRENT_USER\Control Panel\International" ;
 
data _null_;
  infile reg dsd;
  input;
  if (find(_infile_,'sShortDate')>0) then
    do;
      result = scan(_infile_,-1,' ');
      call symput('SHORTDATE',result);
    end;
run;
 
%put Short date format is &shortdate.;