OBJECT table 17253 ReceiptsProcessing_L-Checkoff
{
  OBJECT-PROPERTIES
  {
    Date=04/05/23;
    Time=[ 9:34:41 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnModify=BEGIN
               IF Posted = TRUE THEN
               ERROR('You cannot modify a Posted Check Off');
             END;

    OnDelete=BEGIN
               IF Posted = TRUE THEN
               ERROR('You cannot delete a Posted Check Off');
             END;

    OnRename=BEGIN
               IF Posted = TRUE THEN
               ERROR('You cannot rename a Posted Check Off');
             END;

  }
  FIELDS
  {
    { 1   ;   ;Staff/Payroll No    ;Code20         }
    { 2   ;   ;Amount              ;Decimal        }
    { 3   ;   ;No Repayment        ;Boolean        }
    { 4   ;   ;Staff Not Found     ;Boolean        }
    { 5   ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter }
    { 6   ;   ;Transaction Date    ;Date           }
    { 8   ;   ;Generated           ;Boolean        }
    { 9   ;   ;Payment No          ;Integer        }
    { 10  ;   ;Posted              ;Boolean        }
    { 11  ;   ;Multiple Receipts   ;Boolean        }
    { 12  ;   ;Name                ;Text200        }
    { 13  ;   ;Early Remitances    ;Boolean        }
    { 14  ;   ;Early Remitance Amount;Decimal      }
    { 15  ;   ;Trans Type          ;Option        ;OptionCaptionML=ENU=" ,sShare,sLoan,sDeposits,sInterest,sInsurance,sBenevolent";
                                                   OptionString=[ ,sShare,sLoan,sDeposits,sInterest,sInsurance,sBenevolent] }
    { 16  ;   ;Description         ;Text60         }
    { 17  ;   ;Member Found        ;Boolean        }
    { 18  ;   ;Search Index        ;Code20         }
    { 19  ;   ;Loan Found          ;Boolean        }
    { 20  ;   ;Loan No             ;Code20        ;TableRelation="Loans Register"."Loan  No." WHERE (Client Code=FIELD(Member No),
                                                                                                     Posted=CONST(Yes));
                                                   OnValidate=BEGIN
                                                                 memb.RESET;
                                                                 memb.SETRANGE(memb."No.","Member No");
                                                                 IF memb.FIND('-') THEN BEGIN
                                                                  loans.RESET;
                                                                  loans.SETRANGE(loans."Loan  No.","Loan No");
                                                                  IF loans.FIND('-') THEN BEGIN
                                                                   IF "Trans Type"="Trans Type"::sInsurance THEN BEGIN
                                                                    Amount:=100;
                                                                   END ELSE IF "Trans Type"="Trans Type"::sDeposits THEN BEGIN
                                                                   loans.CALCFIELDS(loans."Interest Due",loans."Outstanding Balance");
                                                                  /// IF loans."Interest Due">0 THEN
                                                                  // Amount:=loans."Interest Due";
                                                                    Amount:=0.01*loans."Outstanding Balance";
                                                                   END ELSE IF  "Trans Type"="Trans Type"::sLoan THEN BEGIN
                                                                   Amount:=loans.Repayment;
                                                                  END;
                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 21  ;   ;User                ;Code20         }
    { 22  ;   ;Member Moved        ;Boolean        }
    { 23  ;   ;Employer Code       ;Code20         }
    { 24  ;   ;Batch No.           ;Code30        ;TableRelation="Loan Disburesment-Batching"."Batch No." }
    { 25  ;   ;Member No           ;Code20        ;TableRelation="Members Register".No. WHERE (Customer Type=FILTER(Member));
                                                   OnValidate=BEGIN
                                                                memb.RESET;
                                                                memb.SETRANGE(memb."No.","Member No");
                                                                IF memb.FIND('-') THEN BEGIN
                                                                "Staff/Payroll No":=memb."Payroll/Staff No";
                                                                "ID No.":=memb."ID No.";
                                                                Name:=memb.Name;
                                                                "Employer Code":=memb."Employer Code";
                                                                IF "Trans Type"="Trans Type"::sShare THEN BEGIN
                                                                Amount:=memb."Monthly Contribution"
                                                                END ELSE IF "Trans Type"="Trans Type"::sInterest THEN BEGIN
                                                                Amount:=200
                                                                END ELSE IF "Trans Type"="Trans Type"::sInsurance THEN BEGIN
                                                                Amount:=100
                                                                END ELSE IF "Trans Type"="Trans Type"::sBenevolent THEN BEGIN
                                                                //memb.CALCFIELDS(memb."KMA Withdrawable Savings");
                                                                //Amount:=memb."KMA Withdrawable Savings"*-1;
                                                                END ELSE IF "Trans Type"="Trans Type"::"7" THEN BEGIN
                                                                //memb.CALCFIELDS(memb."Children Savings");
                                                                //Amount:=memb."Children Savings"*-1;
                                                                END ELSE IF "Trans Type"="Trans Type"::"8" THEN BEGIN
                                                                //memb.CALCFIELDS(memb."CIC Fixed Deposits");
                                                                //Amount:=memb."CIC Fixed Deposits"*-1;
                                                                END ELSE IF "Trans Type"="Trans Type"::"9" THEN BEGIN
                                                                //memb.CALCFIELDS(memb."UAP Premiums");
                                                                //Amount:=memb."UAP Premiums"*-1;




                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 26  ;   ;ID No.              ;Code20         }
    { 27  ;   ;Receipt Header No   ;Code20        ;TableRelation=ReceiptsProcessing_H-Checkoff.No }
    { 28  ;   ;Receipt Line No     ;Integer       ;AutoIncrement=Yes }
    { 29  ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,None,Staff;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,None,Staff }
    { 30  ;   ;Entry No            ;Integer        }
    { 31  ;   ;Xmas Contribution   ;Decimal        }
    { 32  ;   ;Xmas Account        ;Code10         }
    { 33  ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=Loan,Deposits,ESS;
                                                   OptionString=Loan,Deposits,ESS }
    { 34  ;   ;Loan Code           ;Code10         }
    { 35  ;   ;Loan Product Type   ;Code50         }
    { 36  ;   ;Loan type Code      ;Code50         }
    { 37  ;   ;Posting Date        ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(ReceiptsProcessing_H-Checkoff."Posting date" WHERE (No=FIELD(Receipt Header No))) }
    { 38  ;   ;Deposit Amount      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Member Ledger Entry".Amount WHERE (Document No.=FIELD(Document No),
                                                                                                          Customer No.=FIELD(Member No),
                                                                                                          Transaction Type=CONST(Deposit Contribution))) }
    { 39  ;   ;Document No         ;Code40        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(ReceiptsProcessing_H-Checkoff."Document No" WHERE (No=FIELD(Receipt Header No))) }
  }
  KEYS
  {
    {    ;Receipt Header No,Receipt Line No       ;SumIndexFields=Amount;
                                                   Clustered=Yes }
    {    ;Receipt Line No                          }
    {    ;Staff/Payroll No                         }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      memb@1102755000 : Record 51516223;
      loans@1102755001 : Record 51516230;

    BEGIN
    END.
  }
}

