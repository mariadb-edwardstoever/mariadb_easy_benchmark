-- script by Edward Stoever for Mariadb Support
insert into MESSAGES (msg_sent,msg_sender,msg_recipient,msg_subject,msg_text)VALUES(now() - interval cast(substr(regexp_replace(md5(rand()),'[a-f]',''),1,9) as integer) second,substr(md5(rand()),1,16),substr(md5(rand()),1,16),concat(regexp_replace(md5(rand()),'[0-9]',''),' ',substr(regexp_replace(md5(rand()),'[0-9]',''),1,3),' ',regexp_replace(md5(rand()),'[0-9]','')),concat(regexp_replace(md5(rand()),'[0-9]',''),' ',regexp_replace(md5(rand()),'[0-9]',''),' ',regexp_replace(md5(rand()),'[0-9]',''),' ',regexp_replace(md5(rand()),'[0-9]',''),' ',regexp_replace(md5(rand()),'[0-9]',''),' ',regexp_replace(md5(rand()),'[0-9]',''),' '));
set @STUDENT_OR_PROFESSOR = FLOOR(1 + RAND() * (10 - 1 + 1));
select DISC from (select @AA:=FLOOR(1 + RAND() * (5 - 1 + 1)) as AA, case WHEN @AA = 1 then 'SCIENCE' when @AA = 2 then 'DESIGN' when @AA = 3 then 'LINGO' when @AA = 4 then 'MATH' else 'TRANSPORT' end as DISC) as X into @PRIN_DISC;
select FIELD from (select @AA:=FLOOR(1 + RAND() * (9 - 1 + 1)) as AA, case WHEN @AA = 1 then 'Probablility Theory' when @AA = 2 then 'Phonetics' when @AA = 3 then 'Ecology' when @AA = 4 then 'Geometry' when @AA = 5 then 'Logic in Computer Science' when @AA = 6 then 'Applied Linguistics' when @AA = 7 then 'Civil Engineering' when @AA = 8 then 'Algorithms' else 'Lexicology' end as FIELD) as X into @ACAD_FIELD;
select IDTYPE from (select @AA:=FLOOR(1 + RAND() * (5 - 1 + 1)) as AA, case WHEN @AA = 1 then 'passport' when @AA = 2 then 'drivers license' when @AA = 3 then 'state photo id' when @AA = 4 then 'cedula' else 'generic identification' end as IDTYPE) as X into @ID_TYPE;
set @FRQ1=FLOOR(1 + RAND() * (1000 - 1 + 1));
set @FRQ2=FLOOR(1 + RAND() * (2000 - 1 + 1));
set @SUBSTR_PERS_ID = substr(md5(rand()),1,3);
set @PROBLEM_CODE = substr(regexp_replace(md5(rand()),'[0-9]',''),1,5);
select CMT from (select @AA:=FLOOR(1 + RAND() * (9 - 1 + 1)) as AA, case WHEN @AA = 1 then 'Good behavior.' when @AA = 2 then 'Award winning.' when @AA = 3 then concat('Internal code: ',regexp_replace(md5(rand()),'[0-9]','')) when @AA = 4 then 'Friend of the Dean.' when @AA = 5 then 'Disciplined.' when @AA = 6 then 'Item in Lost and Found.' when @AA = 7 then 'Parent notified.' when @AA = 8 then 'Dropped a class.' else 'Friendly.' end as CMT) as X into @CMT;
select last_pers_id into @PREV_PERSON from LAST_RUN limit 1;
insert ignore into PERSONS (pers_id,pers_first_name,pers_middle_name,pers_last_name,pers_external_id_type,pers_external_id_number,pers_date_of_birth,pers_created,pers_updated)VALUES(@PERS_ID:=substr(md5(rand()),1,16),regexp_replace(md5(rand()),'[0-9]',''),regexp_replace(md5(rand()),'[0-9]',''),regexp_replace(md5(rand()),'[0-9]',''),@ID_TYPE,substr(regexp_replace(md5(rand()),'[a-f]',''),1,9),now() - interval cast(substr(regexp_replace(md5(rand()),'[a-f]',''),1,9) as integer) second,now(),now());
insert into PROFESSORS(prof_pers_id,prof_principal_discipline,prof_last_day_employed,prof_created,prof_updated)SELECT @PERS_ID, @PRIN_DISC, str_to_date('2099-12-31','%Y-%m-%d'),now(),now() from information_schema.SCHEMATA where SCHEMA_NAME='information_schema' and @STUDENT_OR_PROFESSOR=5;
INSERT INTO STUDENTS(stud_pers_id,stud_academic_field,stud_last_day_of_study,stud_created,stud_updated)SELECT @PERS_ID,@ACAD_FIELD,str_to_date('2099-12-31','%Y-%m-%d'),now(),now() from information_schema.SCHEMATA where SCHEMA_NAME='information_schema' and @STUDENT_OR_PROFESSOR!=5;
select pers_id, concat(pers_first_name,' ',pers_middle_name,' ',pers_last_name) as full_name, pers_external_id_type, pers_external_id_number, pers_date_of_birth
prof_principal_discipline, prof_last_day_employed from PERSONS INNER JOIN PROFESSORS ON ( pers_id = prof_pers_id) WHERE pers_id=@PERS_ID;
select pers_id, concat(pers_first_name,' ',pers_middle_name,' ',pers_last_name) as full_name, pers_external_id_type, pers_external_id_number, pers_date_of_birth,
stud_academic_field,stud_last_day_of_study from PERSONS INNER JOIN STUDENTS ON (pers_id =stud_pers_id) WHERE pers_id=@PERS_ID;
select count(*) as how_many, pers_external_id_type from PERSONS group by pers_external_id_type;
insert into MESSAGES (msg_sent,msg_sender,msg_recipient,msg_subject,msg_text)VALUES(now() - interval cast(substr(regexp_replace(md5(rand()),'[a-f]',''),1,9) as integer) second,substr(md5(rand()),1,16),substr(md5(rand()),1,16),concat(regexp_replace(md5(rand()),'[0-9]',''),' ',substr(regexp_replace(md5(rand()),'[0-9]',''),1,3),' ',regexp_replace(md5(rand()),'[0-9]','')),concat(regexp_replace(md5(rand()),'[0-9]',''),' ',regexp_replace(md5(rand()),'[0-9]',''),' ',regexp_replace(md5(rand()),'[0-9]',''),' ',regexp_replace(md5(rand()),'[0-9]',''),' ',regexp_replace(md5(rand()),'[0-9]',''),' ',regexp_replace(md5(rand()),'[0-9]',''),' '));
update PERSONS set pers_comment=concat('Rising Star Code: ', substr(regexp_replace(md5(rand()),'[0-9]',''),1,5)), pers_updated=now() where pers_id=@PERS_ID and @FRQ2=999;
update PERSONS set pers_comment=concat('Problem code: ', @PROBLEM_CODE), pers_updated=now() where substr(pers_id,1,3)=@SUBSTR_PERS_ID and @FRQ2=333;
update PERSONS set pers_external_id_type='new id card', pers_updated=now() where pers_id=@PERS_ID and @FRQ2=555;
update PERSONS set pers_comment=@CMT, pers_updated=now() where pers_id=@PREV_PERSON and @FRQ1 < 200;
delete from PROFESSORS where prof_pers_id=@PREV_PERSON and @FRQ1 < 10;
delete from STUDENTS where stud_pers_id=@PREV_PERSON and @FRQ1 < 10;
delete from PERSONS where pers_id=@PREV_PERSON and @FRQ1 < 10;
update LAST_RUN set run_count=(run_count+1), last_pers_id=@PERS_ID,updated=now();
