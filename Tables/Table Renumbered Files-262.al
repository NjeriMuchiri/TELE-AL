OBJECT table 20405 Loans Cue
{
  OBJECT-PROPERTIES
  {
    Date=05/06/16;
    Time=[ 8:59:46 AM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code20         }
    { 2   ;   ;Applied Loans       ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Approval Status=CONST(Open))) }
    { 3   ;   ;Pending Loans       ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Approval Status=CONST(Pending))) }
    { 4   ;   ;Approved Loans      ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Approval Status=CONST(Approved))) }
    { 5   ;   ;Rejected Loans      ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Approval Status=CONST(Rejected))) }
    { 6   ;   ;Issued Loans        ;Integer       ;FieldClass=Normal }
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

