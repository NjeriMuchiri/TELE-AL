OBJECT table 20433 SurePESA Transactions
{
  OBJECT-PROPERTIES
  {
    Date=10/12/20;
    Time=[ 5:41:37 PM];
    Modified=Yes;
    Version List=SurePESA;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Account No          ;Code30         }
    { 2   ;   ;Account Name        ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Vendor.Name WHERE (No.=FIELD(Account No))) }
    { 3   ;   ;Document No         ;Code30         }
    { 4   ;   ;Document Date       ;Date           }
    { 5   ;   ;Transaction Time    ;Time           }
    { 6   ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=" ,Withdrawal,Deposit,Balance,Ministatement,Airtime,Loan balance,Loan Status,Share Deposit Balance,Transfer to Fosa,Transfer to Bosa,Utility Payment,Loan Application,Standing orders";
                                                   OptionString=[ ,Withdrawal,Deposit,Balance,Ministatement,Airtime,Loan balance,Loan Status,Share Deposit Balance,Transfer to Fosa,Transfer to Bosa,Utility Payment,Loan Application,Standing orders] }
    { 7   ;   ;Telephone Number    ;Code30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Vendor."Phone No." WHERE (No.=FIELD(Account No))) }
    { 8   ;   ;Posted              ;Boolean        }
    { 9   ;   ;Date Posted         ;DateTime       }
    { 10  ;   ;Account No2         ;Text30         }
    { 11  ;   ;Loan No             ;Code30         }
    { 12  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Pending,Completed,Failed;
                                                   OptionString=Pending,Completed,Failed }
    { 13  ;   ;Comments            ;Text50         }
    { 14  ;   ;Amount              ;Decimal        }
    { 15  ;   ;Charge              ;Decimal        }
    { 16  ;   ;Description         ;Text100        }
    { 18  ;   ;Entry               ;Integer       ;AutoIncrement=Yes }
    { 20  ;   ;Client              ;Code50         }
    { 21  ;   ;Posting Date        ;Date           }
    { 22  ;   ;SMS Message         ;Text250        }
    { 23  ;   ;Staff No            ;Code100       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Vendor."Staff No" WHERE (No.=FIELD(Account No))) }
    { 24  ;   ;Account Balance     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(Account No))) }
  }
  KEYS
  {
    {    ;Document No                             ;Clustered=Yes }
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

