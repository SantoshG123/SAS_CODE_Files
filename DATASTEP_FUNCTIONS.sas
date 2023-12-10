PROC IMPORT OUT = RMINPUT.IR_ID._INPUTFILE_1
    DATAFILE= "/sasapp/Ccode/dss5/datamasterinput1.xlsx"
    DBMS=XLSX Replace;
    OPTIONS VALIDVARNAME=v7 MSGLEVEL=I;
 RUN;
 
 PROC SQL;
 CREATE TABLE out.TRANS_TABLE
 SELECT *, INPUT(PUT(TRANS_DT,8.),YYMMDD8.) FORMAT MMDDYY10. AS TRANSOFF_DT
 FROM IR_ID._INPUTFILE_1
 WHERE TRAN_CD = 'RRX'
 ;
 QUIT;
 
 DATA out.TRAN_FINAL_STEP_1;
 SET out.TRANS_TABLE;
 BY LOAN_ID TRANS_DT TRAN_CD LO_SSID EFF_DT_ADJ;
 RETAIN PREVTRANDT 0 PREVEFFDT 0 PREV_ACCT_NBR 0 PRIM_ACCT_NBR 0;
 PREVTRANDT = LAG (TRANS_DT);
 IF FIRST_LOAN_ID THEN PREVTRANDT=0;
 PREVEFFDT = LAG (EFF_DT_ADJ);
 IF FIRST_LOAN_ID THEN PREVEFFDT=0;
RUN;

PROC SQL;
CREATE TABLE out.TRAN_FINAL_STEP AS
SELECT LOAN_ID 
,MIN (TRANS_DT) AS TRANS_DT
,MAX (SANS_DT)
,intnx('day', INPUT(PUT(PREVEFFDT,8.),YYMMDD8.), PREVEFFDT_ADJ) FORMAT MMDDYY10. AS PREEFF_DT
FROM out.TRAN_FINAL_STEP_1
GROUP BY LOAN_ID, TRANS_DT
ORDER BY LOAN_ID;
QUIT;
 
 