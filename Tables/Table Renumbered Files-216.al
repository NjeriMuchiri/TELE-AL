OBJECT table 17337 Ssacco Transactions
{
  OBJECT-PROPERTIES
  {
    Date=10/04/14;
    Time=[ 7:03:14 PM];
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnModify=BEGIN
               IF Posted=TRUE THEN BEGIN
               ERROR('You cannot modify posted MPESA transactions.');
               END;
             END;

    OnDelete=BEGIN
               ERROR('You cannot delete MPESA transactions.');
             END;

  }
  FIELDS
  {
    { 1   ;   ;Document No.        ;Code30         }
    { 2   ;   ;Transaction Date    ;Date           }
    { 3   ;   ;Account No.         ;Code50         }
    { 4   ;   ;Description         ;Text200        }
    { 5   ;   ;Amount              ;Decimal        }
    { 6   ;   ;Posted              ;Boolean        }
    { 7   ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=Withdrawal,Deposit,Balance,Ministatement,Transfer,Advance,Loan Repayment;
                                                   OptionString=Withdrawal,Deposit,Balance,Ministatement,Transfer,Advance,Loan Repayment }
    { 8   ;   ;Transaction Time    ;Time           }
    { 11  ;   ;Date Posted         ;Date           }
    { 12  ;   ;Time Posted         ;Time           }
    { 25  ;   ;Entry No            ;Integer       ;AutoIncrement=Yes }
    { 26  ;   ;Comments            ;Text250        }
  }
  KEYS
  {
    {    ;Entry No                                ;Clustered=Yes }
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

