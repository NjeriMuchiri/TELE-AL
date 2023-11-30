OBJECT table 17215 HR Employee Attachments
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=10:59:12 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    LookupPageID=Page51516218;
  }
  FIELDS
  {
    { 1   ;   ;Employee No         ;Code50        ;TableRelation="HR Employees".No.;
                                                   NotBlank=Yes }
    { 2   ;   ;Document Description;Text200       ;NotBlank=Yes }
    { 3   ;   ;Document Link       ;Text200        }
    { 6   ;   ;Attachment No.      ;Integer       ;AutoIncrement=Yes;
                                                   Editable=No }
    { 7   ;   ;Language Code (Default);Code10     ;TableRelation=Language }
    { 8   ;   ;Attachment          ;Option        ;OptionString=No,Yes;
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Employee No,Document Description        ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      DocLink@1102755000 : Record 51516211;

    PROCEDURE PlaceFilter@1102755000(prompt@1102755000 : Boolean;EmployeeNo@1102755001 : Code[10]) : Boolean;
    BEGIN
      IF prompt THEN BEGIN
      SETFILTER("Employee No",EmployeeNo);
      END;
    END;

    BEGIN
    END.
  }
}

