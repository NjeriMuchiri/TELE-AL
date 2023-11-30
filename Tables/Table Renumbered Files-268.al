OBJECT table 20411 Loan Repayment Calculator
{
  OBJECT-PROPERTIES
  {
    Date=11/29/16;
    Time=[ 5:53:38 PM];
    Modified=Yes;
    Version List=LM;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 3   ;   ;Loan Category       ;Code20         }
    { 8   ;   ;Closed Date         ;Date           }
    { 9   ;   ;Loan Amount         ;Decimal        }
    { 14  ;   ;Interest Rate       ;Decimal        }
    { 15  ;   ;Monthly Repayment   ;Decimal        }
    { 17  ;   ;Member Name         ;Text30         }
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
    { 52  ;   ;Administration Fee  ;Decimal        }
  }
  KEYS
  {
    {    ;Instalment No                           ;SumIndexFields=Monthly Interest,Principal Repayment,Monthly Repayment;
                                                   Clustered=Yes }
    {    ;Loan Category                            }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NoSeriesMngnt@1102750001 : Codeunit 396;
      SACCOMember@1102750002 : Record 51516223;
      LoanCategory@1102750003 : Record 51516240;

    BEGIN
    END.
  }
}

