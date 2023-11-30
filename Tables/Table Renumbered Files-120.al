OBJECT table 17238 Loan Repayment Schedule
{
  OBJECT-PROPERTIES
  {
    Date=03/10/20;
    Time=11:45:22 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan No.            ;Code20         }
    { 2   ;   ;Member No.          ;Code20         }
    { 3   ;   ;Loan Category       ;Code20         }
    { 8   ;   ;Closed Date         ;Date           }
    { 9   ;   ;Loan Amount         ;Decimal        }
    { 14  ;   ;Interest Rate       ;Decimal        }
    { 15  ;   ;Monthly Repayment   ;Decimal        }
    { 17  ;   ;Member Name         ;Text50         }
    { 21  ;   ;Monthly Interest    ;Decimal        }
    { 25  ;   ;Amount Repayed      ;Decimal       ;FieldClass=Normal }
    { 26  ;   ;Repayment Date      ;Date           }
    { 27  ;   ;Principal Repayment ;Decimal        }
    { 28  ;   ;Paid                ;Boolean        }
    { 29  ;   ;Remaining Debt      ;Decimal       ;Editable=No }
    { 30  ;   ;Instalment No       ;Integer        }
    { 45  ;   ;Actual Loan Repayment Date;Date     }
    { 46  ;   ;Repayment Code      ;Code20         }
    { 47  ;   ;Group Code          ;Code20         }
    { 48  ;   ;Loan Application No ;Code20         }
    { 49  ;   ;Actual Principal Paid;Decimal       }
    { 50  ;   ;Actual Interest Paid;Decimal        }
    { 51  ;   ;Actual Installment Paid;Decimal     }
    { 52  ;   ;Repayment Adjustment;Decimal        }
    { 53  ;   ;Loan Balance        ;Decimal        }
    { 55  ;   ;Close Schedule      ;Boolean        }
  }
  KEYS
  {
    {    ;Loan No.,Member No.,Repayment Date      ;SumIndexFields=Monthly Interest,Principal Repayment,Monthly Repayment;
                                                   Clustered=Yes }
    {    ;Member No.                               }
    {    ;Paid                                     }
    {    ;Loan No.,Member No.,Paid                 }
    {    ;Loan Category                            }
    {    ;Loan No.,Member No.,Paid,Loan Category   }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NoSeriesMngnt@1102750001 : Codeunit 396;
      SACCOMember@1102750002 : Record 18;
      LoanCategory@1102750003 : Record 51516240;

    BEGIN
    END.
  }
}

