OBJECT table 20368 loans Cuess
{
  OBJECT-PROPERTIES
  {
    Date=05/06/16;
    Time=11:14:05 AM;
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10         }
    { 2   ;   ;Applied Loans       ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Approval Status=CONST(Open))) }
    { 3   ;   ;Approved Loans      ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Approval Status=CONST(Approved))) }
    { 4   ;   ;Pending Loans       ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Approval Status=CONST(Pending))) }
    { 5   ;   ;Rejected Loans      ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Approval Status=CONST(Rejected))) }
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

