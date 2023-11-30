OBJECT table 20429 Checkoff Lines-DistributedD
{
  OBJECT-PROPERTIES
  {
    Date=08/04/17;
    Time=[ 1:06:40 PM];
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
    { 7   ;   ;Entry No            ;Integer        }
    { 8   ;   ;Generated           ;Boolean        }
    { 9   ;   ;Payment No          ;Integer        }
    { 10  ;   ;Posted              ;Boolean        }
    { 11  ;   ;Multiple Receipts   ;Boolean        }
    { 12  ;   ;Name                ;Text200        }
    { 13  ;   ;Early Remitances    ;Boolean        }
    { 14  ;   ;Early Remitance Amount;Decimal      }
    { 15  ;   ;Loan No.            ;Code20        ;TableRelation="Loans Register"."Loan  No." WHERE (Client Code=FIELD(Member No.), Outstanding Balance=FILTER(<>0));
                                                   OnValidate=BEGIN
                                                                lo:= "Loan No.";
                                                                loanR.SETCURRENTKEY("Loan  No.");

                                                                loanR.SETRANGE(loanR."Loan  No.",lo);
                                                                IF loanR.FINDFIRST THEN  BEGIN
                                                                  "Loan Type":=loanR."Product Code";
                                                                END;
                                                              END;
                                                               }
    { 16  ;   ;Member No.          ;Code20        ;TableRelation="Members Register".No.;
                                                   OnValidate=BEGIN
                                                                Cust.RESET;
                                                                Cust.SETRANGE(Cust."No.","Member No.");
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                Name:=Cust.Name;
                                                                END;
                                                              END;
                                                               }
    { 17  ;   ;Interest            ;Decimal        }
    { 18  ;   ;Loan Type           ;Code20         }
    { 19  ;   ;DEPT                ;Code10         }
    { 20  ;   ;Expected Amount     ;Decimal        }
    { 21  ;   ;FOSA Account        ;Code20         }
    { 22  ;   ;Utility Type        ;Code20         }
    { 23  ;   ;Transaction Type    ;Option        ;OptionString=Deposits Contribution,Insurance contribution }
    { 24  ;   ;Reference           ;Code50        ;TableRelation="CheckOff Options".Code }
    { 25  ;   ;Account type        ;Code50         }
    { 26  ;   ;Variance            ;Decimal        }
    { 27  ;   ;Employer Code       ;Code10         }
    { 28  ;   ;GPersonalNo         ;Code10         }
    { 29  ;   ;Gnames              ;Text80         }
    { 30  ;   ;Gnumber             ;Code10         }
    { 31  ;   ;Userid1             ;Code25         }
    { 32  ;   ;Loans Not found     ;Boolean        }
    { 33  ;   ;Receipt Header No   ;Code20        ;TableRelation="Checkoff Header-Distributed".No }
    { 34  ;   ;Branch              ;Code20        ;TableRelation="Dimension Value".Code }
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
    VAR
      Cust@1000000000 : Record 51516364;
      loanR@1000000001 : Record 51516371;
      lo@1000000002 : Code[10];

    BEGIN
    END.
  }
}

