bash "run tablereorg" do
     user "oracle"
     group "oinstall"
code <<-EOH

export ORACLE_SID='orcl'
export ORACLE_HOME=/opt/oracle/12R1
export PATH=$ORACLE_HOME/bin:$PATH
sqlplus sys/sys as sysdba <<-EOL
spool wastespace_beforereorg.txt;
set linesize 800
select table_name,owner,round((blocks*8),2) "size (kb)" ,round((num_rows*avg_row_len/1024),2) "actual_data (kb)",(round((blocks*8),2) - round((num_rows*avg_row_len/1024),2)) "wasted_space (kb)",(case when round(round((blocks*8),2))*100 <> 0 then ((round((blocks*8),2) - round((num_rows*avg_row_len/1024),2))/round((blocks*8),2))*100 end) "waste percent" from dba_tables where owner='SCOTT';
spool off;
spool pctfreebefore.txt
set linesize 800
select TABLE_NAME,PCT_FREE from dba_tables where OWNER= 'SCOTT' and table_name IN (select table_name from (select table_name,(case when round((blocks*8),2) <> 0 then ((round((blocks*8),2) - round((num_rows*avg_row_len/1024),2))/round((blocks*8),2))*100 end) as wastepercent from dba_tables) dba_tables where wastepercent >= 25);
spool off;

exit;
<<-EOL

sqlplus scott/tiger <<-EOL1 
ALTER TABLE reorg ENABLE ROW MOVEMENT;   
ALTER TABLE reorg SHRINK SPACE; 
exit;  

sqlplus sys/sys as sysdba <<-EOL2
spool wastespace_afterreorg.txt;
set linesize 800
select table_name,owner,round((blocks*8),2) "size (kb)" ,round((num_rows*avg_row_len/1024),2) "actual_data (kb)",(round((blocks*8),2) - round((num_rows*avg_row_len/1024),2)) "wasted_space (kb)",(case when round(round((blocks*8),2))*100 <> 0 then ((round((blocks*8),2) - round((num_rows*avg_row_len/1024),2))/round((blocks*8),2))*100 end) "waste percent" from dba_tables where owner='SCOTT';
spool off;
spool pctfreeafter.txt;
set linesize 800
select TABLE_NAME,PCT_FREE from dba_tables where OWNER='SCOTT' and table_name IN (select table_name from (select table_name,(case when round((blocks*8),2) <> 0 then ((round((blocks*8),2) - round((num_rows*avg_row_len/1024),2))/round((blocks*8),2))*100 end) as wastepercent from dba_tables) dba_tables where wastepercent >= 25);
spool off;

exit;
<<-EOL2

EOH
end



