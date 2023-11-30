OBJECT table 17286 Checkoff Lines-Distributed
{
  OBJECT-PROPERTIES
  {
    Date=11/13/17;
    Time=[ 4:14:52 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Staff/Payroll No    ;Code20         }
    { 2   ;   ;Amount              ;Decimal        }
    { 3   ;   ;No Repayment        ;Boolean        }
    { 4   ;   ;Staff Not Found     ;Boolean        }
    { 5   ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter }
    { 6   ;   ;Transaction Date    ;Date           }
    { 7   ;   ;Entry No            ;Integer       ;AutoIncrement=Yes }
    { 8   ;   ;Generated           ;Boolean        }
    { 9   ;   ;Payment No          ;Integer        }
    { 10  ;   ;Posted              ;Boolean        }
    { 11  ;   ;Multiple Receipts   ;Boolean        }
    { 12  ;   ;Name                ;Text200        }
    { 13  ;   ;Early Remitances    ;Boolean        }
    { 14  ;   ;Early Remitance Amount;Decimal      }
    { 15  ;   ;Loan No.            ;Code20        ;TableRelation="Loans Register"."Loan  No." WHERE (Client Code=FIELD(Member No.)) }
    { 16  ;   ;Member No.          ;Code20         }
    { 17  ;   ;Interest            ;Decimal        }
    { 18  ;   ;Loan Type           ;Code10         }
    { 19  ;   ;DEPT                ;Code10         }
    { 20  ;   ;Expected Amount     ;Decimal        }
    { 21  ;   ;FOSA Account        ;Code20         }
    { 22  ;   ;Utility Type        ;Code20         }
    { 23  ;   ;Transaction Type    ;Option        ;OptionString=[ ,Deposits Contribution,Insurance contribution,SchFees Shares,Interest Paid,Registration Fee,Repayment,Principle Unallocated,Interest Unallocated] }
    { 24  ;   ;Reference           ;Code50         }
    { 25  ;   ;Account type        ;Code10         }
    { 26  ;   ;Variance            ;Decimal        }
    { 27  ;   ;Employer Code       ;Code20         }
    { 28  ;   ;GPersonalNo         ;Code10         }
    { 29  ;   ;Gnames              ;Text80         }
    { 30  ;   ;Gnumber             ;Code10         }
    { 31  ;   ;Userid1             ;Code15         }
    { 32  ;   ;Loans Not found     ;Boolean        }
    { 33  ;   ;Receipt Header No   ;Code20        ;TableRelation="Checkoff Header-Distributed".No }
    { 34  ;   ;Loan Balance        ;Decimal        }
    { 35  ;   ;adviced             ;Boolean        }
    { 36  ;   ;Interest Balance    ;Decimal        }
  }
  KEYS
  {
    {    ;Receipt Header No,Entry No              ;Clustered=Yes }
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

