OBJECT table 20427 Members Cue
{
  OBJECT-PROPERTIES
  {
    Date=05/06/16;
    Time=[ 9:17:59 AM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code20         }
    { 2   ;   ;Active Members      ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active))) }
    { 3   ;   ;Non-Active Members  ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Non-Active))) }
    { 4   ;   ;Dormant Members     ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Dormant))) }
    { 5   ;   ;Blocked Members     ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Blocked))) }
    { 6   ;   ;Reinstated Members  ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Re-instated))) }
    { 7   ;   ;Defaulted members   ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Defaulter))) }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
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

