OBJECT table 17260 Approvals Users Set Up
{
  OBJECT-PROPERTIES
  {
    Date=09/11/19;
    Time=[ 3:49:49 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Approval Type       ;Option        ;OptionString=Loans,Bridging Loans,Personal Loans,Refunds,Funeral Expenses,Withdrawals - Resignation,Withdrawals - Death,Branch Loans,Journals,File Movement,Appeal Loans,Withdrawal Batch }
    { 2   ;   ;Stage               ;Integer       ;TableRelation="Job-Ledger Entryy"."Job No." WHERE (Entry No.=FIELD(Approval Type)) }
    { 3   ;   ;User ID             ;Code20        ;TableRelation=User."User Name" }
    { 4   ;   ;Approver            ;Boolean        }
  }
  KEYS
  {
    {    ;Approval Type,Stage,User ID             ;Clustered=Yes }
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

