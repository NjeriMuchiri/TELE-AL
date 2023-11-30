OBJECT table 17272 Approvals Set Up
{
  OBJECT-PROPERTIES
  {
    Date=10/05/15;
    Time=[ 5:52:38 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page50233;
    DrillDownPageID=Page50233;
  }
  FIELDS
  {
    { 1   ;   ;Approval Type       ;Option        ;OptionString=Loans,Bridging Loans,Personal Loans,Refunds,Funeral Expenses,Withdrawals - Resignation,Withdrawals - Death,Branch Loans,Journals,File Movement,Appeal Loans,Bosa Loan Approval }
    { 2   ;   ;Stage               ;Integer        }
    { 3   ;   ;Description         ;Text50         }
    { 4   ;   ;Station             ;Code50         }
    { 5   ;   ;Duration (Hr)       ;Decimal        }
  }
  KEYS
  {
    {    ;Approval Type,Stage,Station             ;Clustered=Yes }
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

