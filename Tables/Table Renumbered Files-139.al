OBJECT table 17257 Movement Tracker
{
  OBJECT-PROPERTIES
  {
    Date=10/05/15;
    Time=[ 5:47:52 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Document No.        ;Code20         }
    { 2   ;   ;Approval Type       ;Option        ;OptionCaptionML=ENU=Loans,Special Loans,Personal Loans,Refunds,Funeral Expenses,Withdrawals - Resignation,Withdrawals - Death,Branch Loans;
                                                   OptionString=Loans,Special Loans,Personal Loans,Refunds,Funeral Expenses,Withdrawals - Resignation,Withdrawals - Death,Branch Loans }
    { 3   ;   ;Stage               ;Integer       ;TableRelation="Job-Ledger Entryy"."Job No." WHERE (Entry No.=FIELD(Approval Type)) }
    { 4   ;   ;Remarks             ;Text50         }
    { 5   ;   ;Status              ;Option        ;OptionCaptionML=ENU=Being Processed,Approved,Rejected;
                                                   OptionString=Being Processed,Approved,Rejected }
    { 6   ;   ;Current Location    ;Boolean        }
    { 7   ;   ;Date/Time In        ;DateTime       }
    { 8   ;   ;Date/Time Out       ;DateTime       }
    { 9   ;   ;USER ID             ;Code20         }
    { 10  ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes }
    { 11  ;   ;Description         ;Text50         }
    { 12  ;   ;Station             ;Code50         }
  }
  KEYS
  {
    {    ;Entry No.                                }
    {    ;Document No.,Approval Type,Entry No.,Stage;
                                                   Clustered=Yes }
    {    ;Document No.,Current Location            }
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

