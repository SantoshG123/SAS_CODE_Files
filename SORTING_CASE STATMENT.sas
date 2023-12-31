PROC SORT DATA=REMIINPUT.CR_POPULATION  OUT=WORK.CR_POPULATION;
ACCT_ID SID_ID ACCT_NUM SEQ_NUM IMPACT_DT IMPACT_END_DT  ADJ_DT EVENT_CNT;
RUN;

DATA REQ1.SEQ1_1;
SET CR_POPULATION;
BY ACCT_ID SID_ID ACCT_NUM SEQ_NUM IMPACT_DT IMPACT_END_DT  ADJ_DT EVENT_CNT;
RETAIN EVENT_CNT;
IF FIRST.IMPACT_DT THEN EVENT_CNT =1;
ELSE EVENT_CNT +1;
RUN;

/* CREATE FLAGS */

PROC SQL;
CREATE TABLE FLG_FILE_EXT
A.*
CASE WHEN A.ADJ_DPD >=70 THEN 1 ELSE 0 END AS ADJ_EXCL
, CASE WHEN RES_DATE <= '22JUN2018'D THEN 1 ELSE 0 END AS  RES_EXCL
,CASE WHEN EVENT_CNT >1 THEN 1 ELSE 0 END as EVENT_EXCL
, B.REM_FLG1
,B.IMPACT_DT
FROM REQ1.SEQ1_1
LEFT JOIN RM_STAGE B
ON A. ACCT_ID = B.ACCT_ID
AND A.IMPACT_DT = B.IMPACT_DT
QUIT;

PROC SQL;
CREATE TABLE FLG_FILE_EXT
A.*
CASE WHEN A.ADJ_DPD >=70 THEN 1 ELSE 0 END AS ADJ_EXCL
, CASE WHEN RES_DATE <= '22JUN2018'D THEN 1 ELSE 0 END AS  RES_EXCL
,CASE WHEN EVENT_CNT >1 THEN 1 ELSE 0 END as EVENT_EXCL
, B.REM_FLG1
,B.IMPACT_DT
FROM REQ1.SEQ1_1
LEFT JOIN RM_STAGE B
ON A. ACCT_ID = B.ACCT_ID
AND A.IMPACT_DT = B.IMPACT_DT
WHERE REM_FLG1 =1
GROUP BY ACCT_NUM
HAVING SEQ_NUM=MAX(SEQ_NUM)
QUIT;


 