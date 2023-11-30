OBJECT table 50069 HR Employee Kin
{
  OBJECT-PROPERTIES
  {
    Date=02/26/18;
    Time=[ 3:18:30 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnDelete=VAR
               HRCommentLine@1000 : Record 5208;
             BEGIN
               HRCommentLine.SETRANGE("Table Name",HRCommentLine."Table Name"::"Employee Relative");
               HRCommentLine.SETRANGE("No.","Employee Code");
               HRCommentLine.DELETEALL;
             END;

    CaptionML=ENU=Employee Relative;
  }
  FIELDS
  {
    { 1   ;   ;Employee Code       ;Code20        ;TableRelation="HR Employees".City;
                                                   NotBlank=Yes }
    { 2   ;   ;Relationship        ;Code20        ;TableRelation="HR Lookup Values".Code WHERE (Type=CONST(Next of Kin));
                                                   NotBlank=Yes }
    { 3   ;   ;SurName             ;Text50        ;NotBlank=Yes }
    { 4   ;   ;Other Names         ;Text100       ;NotBlank=Yes }
    { 5   ;   ;ID No/Passport No   ;Text50         }
    { 6   ;   ;Date Of Birth       ;Date           }
    { 7   ;   ;Occupation          ;Text100        }
    { 8   ;   ;Address             ;Text250        }
    { 9   ;   ;Office Tel No       ;Text100        }
    { 10  ;   ;Home Tel No         ;Text50         }
    { 12  ;   ;Type                ;Option        ;OptionString=Next of Kin,Beneficiary }
    { 13  ;   ;Line No.            ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=ENU=Line No. }
    { 14  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Human Resource Comment Line" WHERE (Table Name=CONST(Employee Relative),
                                                                                                          No.=FIELD(Employee Code),
                                                                                                          Table Line No.=FIELD(Line No.)));
                                                   CaptionML=ENU=Comment;
                                                   Editable=No }
    { 50000;  ;E-mail              ;Text60         }
  }
  KEYS
  {
    {    ;Employee Code,Type,Relationship,SurName,Other Names,Line No.;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

