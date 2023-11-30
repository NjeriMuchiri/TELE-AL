OBJECT table 20391 HR Human Resource Comments
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=11:40:19 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=VAR
               lRec_UserTable@1000000000 : Record 2000000120;
             BEGIN

               lRec_UserTable.GET(USERID);
               User := lRec_UserTable."Full Name";
               Date := WORKDATE;
             END;

    OnModify=VAR
               lRec_UserTable@1000000000 : Record 2000000120;
             BEGIN

               lRec_UserTable.GET(USERID);
               User := lRec_UserTable."Full Name";
               Date := WORKDATE;
             END;

  }
  FIELDS
  {
    { 1   ;   ;Table Name          ;Option        ;OptionString=Employee,Relative,Relation Management,Correspondence History,Images,Absence and Holiday,Cost to Company,Pay History,Bank Details,Maternity,SAQA Training History,Absence Information,Incident Report,Emp History,Medical History,Career History,Appraisal,Disciplinary,Exit Interviews,Grievances,Existing Qualifications,Proffesional Membership,Education Assistance,Learning Intervention,NOSA or other Training,Company Skills Plan,Development Plan,Skills Plan,Emp Salary,Unions }
    { 2   ;   ;No.                 ;Code20         }
    { 3   ;   ;Table Line No.      ;Integer        }
    { 4   ;   ;Key Date            ;Date           }
    { 6   ;   ;Line No.            ;Integer        }
    { 7   ;   ;Date                ;Date           }
    { 8   ;   ;Code                ;Code10         }
    { 9   ;   ;Comment             ;Text80         }
    { 10  ;   ;User                ;Text30         }
  }
  KEYS
  {
    {    ;No.,Table Name,Table Line No.           ;Clustered=Yes }
    { No ;                                         }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    PROCEDURE SetUpNewLine@1();
    VAR
      HumanResCommentLine@1000000000 : Record 51516194;
    BEGIN
      // HumanResCommentLine := Rec;
      // HumanResCommentLine.SETRECFILTER;
      // HumanResCommentLine.SETRANGE("Line No.");
      // IF NOT HumanResCommentLine.FIND('-') THEN
      //   Date := WORKDATE;
    END;

    BEGIN
    END.
  }
}

