OBJECT table 20366 Loan Interest Variance ScheduX
{
  OBJECT-PROPERTIES
  {
    Date=04/27/16;
    Time=[ 8:00:04 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan No.            ;Code40         }
    { 2   ;   ;Member No.          ;Code20        ;TableRelation="Members Register".No. }
    { 3   ;   ;Loan Category       ;Code20         }
    { 8   ;   ;Closed Date         ;Date           }
    { 9   ;   ;Loan Amount         ;Decimal        }
    { 14  ;   ;Interest Rate       ;Decimal        }
    { 15  ;   ;Monthly Repayment   ;Decimal        }
    { 17  ;   ;Member Name         ;Text30         }
    { 21  ;   ;Monthly Interest    ;Decimal        }
    { 25  ;   ;Amount Repayed      ;Decimal        }
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
    VAR
      NoSeriesMngnt@1000000002 : Codeunit 396;
      SACCOMember@1000000001 : Record 18;
      LoanCategory@1000000000 : Record 51516240;

    BEGIN
    END.
  }
}

