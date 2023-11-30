OBJECT table 17283 Partial Disbursment Table
{
  OBJECT-PROPERTIES
  {
    Date=03/04/15;
    Time=[ 9:33:21 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan No.            ;Code20         }
    { 2   ;   ;Application Date    ;Date           }
    { 3   ;   ;Loan Product Type   ;Code20        ;Editable=Yes }
    { 4   ;   ;Client Code         ;Code20         }
    { 5   ;   ;Group Code          ;Code20         }
    { 8   ;   ;Requested Amount    ;Decimal        }
    { 9   ;   ;Approved Amount     ;Decimal       ;Editable=Yes }
    { 26  ;   ;Client Name         ;Text50        ;Editable=No }
    { 29  ;   ;Issued Date         ;Date           }
    { 30  ;   ;Installments        ;Integer        }
    { 34  ;   ;Loan Disbursement Date;Date         }
    { 35  ;   ;Mode of Disbursement;Option        ;OptionString=[ ,Cheque,Bank Transfer,FOSA Loans] }
    { 67  ;   ;Date Approved       ;Date           }
    { 53050;  ;Repayment           ;Decimal        }
    { 53055;  ;Disbursment Balance ;Decimal       ;CaptionML=ENU=Disbursment Balance;
                                                   Editable=No }
    { 53056;  ;Partial Amount Disbursed;Decimal    }
  }
  KEYS
  {
    {    ;Loan No.                                ;Clustered=Yes }
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

