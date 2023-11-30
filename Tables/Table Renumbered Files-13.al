OBJECT table 50032 Coop Reconcilation Header
{
  OBJECT-PROPERTIES
  {
    Date=03/20/23;
    Time=[ 7:49:10 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnInsert=VAR
               SalesSetup@1120054000 : Record 51516258;
               NoSeriesMgt@1120054001 : Codeunit 396;
             BEGIN
               IF "No." = '' THEN BEGIN
                 NoSeriesMgt.InitSeries('ATM_REC',xRec."No. Series",0D,"No.","No. Series");
               END;

               "Reconcilled By" := USERID;
             END;

  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=VAR
                                                                SalesSetup@1120054001 : Record 51516258;
                                                                NoSeriesMgt@1120054000 : Codeunit 396;
                                                              BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual('ATM_REC');
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Reconcillation Date ;Date           }
    { 3   ;   ;No. Series          ;Code30         }
    { 4   ;   ;Reconcilled By      ;Code30         }
    { 5   ;   ;Status              ;Option        ;OptionString=Open,Pending,Approved,Rejected }
    { 6   ;   ;Rec.   Start Date   ;Date          ;OnValidate=VAR
                                                                CoopATMTransaction@1120054000 : Record 170041;
                                                                CoopReconcillationtrans@1120054001 : Record 170066;
                                                              BEGIN
                                                                TESTFIELD("No.");
                                                                "Rec.   End Date":=0D;
                                                              END;
                                                               }
    { 7   ;   ;Rec.   End Date     ;Date          ;OnValidate=VAR
                                                                CoopATMTransaction@1120054001 : Record 170041;
                                                                CoopReconcillationtrans@1120054000 : Record 170066;
                                                              BEGIN
                                                                TESTFIELD("Rec.   Start Date");
                                                                CoopATMTransaction.RESET;
                                                                CoopATMTransaction.SETRANGE(CoopATMTransaction."Transaction Date","Rec.   Start Date","Rec.   End Date");
                                                                IF CoopATMTransaction.FINDFIRST THEN BEGIN
                                                                  REPEAT
                                                                   CoopATMTransaction."Reconcillation Header":= "No.";
                                                                   CoopATMTransaction.MODIFY;
                                                                  UNTIL CoopATMTransaction.NEXT =0;
                                                                END;
                                                              END;
                                                               }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
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

OBJECT Table 51516000 Payment Header
{
  OBJECT-PROPERTIES
  {
    Date=09/01/23;
    Time=[ 6:05:01 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 IF "Payment Type"="Payment Type"::Normal THEN BEGIN   //Cheque Payments
                   Setup.GET;
                   Setup.TESTFIELD(Setup."Payment Voucher Nos");
                   NoSeriesMgt.InitSeries(Setup."Payment Voucher Nos",xRec."No. Series",0D,"No.","No. Series");
                 END;
                 IF "Payment Type"="Payment Type"::"Cash Purchase" THEN BEGIN       //Cash Payments
                   Setup.GET;
                   Setup.TESTFIELD(Setup."Cash Voucher Nos");
                   NoSeriesMgt.InitSeries(Setup."Cash Voucher Nos",xRec."No. Series",0D,"No.","No. Series");
                 END;
                 IF "Payment Type"="Payment Type"::"Petty Cash" THEN BEGIN      //PettyCash Payments
                   Setup.GET;
                   Setup.TESTFIELD(Setup."PettyCash Nos");
                   NoSeriesMgt.InitSeries(Setup."PettyCash Nos",xRec."No. Series",0D,"No.","No. Series");
                 END;
                 IF "Payment Type"="Payment Type"::Mobile THEN BEGIN        //Mobile Payments
                   Setup.GET;
                   Setup.TESTFIELD(Setup."Mobile Payment Nos");
                   NoSeriesMgt.InitSeries(Setup."Mobile Payment Nos",xRec."No. Series",0D,"No.","No. Series");
                 END;

               END;
               "Document Type":="Document Type"::Payment;
               "Document Date":=TODAY;
               "User ID":=USERID;
               Cashier:=USERID;
             END;

  }
  FIELDS
  {
    { 10  ;   ;No.                 ;Code20        ;Editable=No }
    { 11  ;   ;Document Type       ;Option        ;OptionCaptionML=ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt";
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt];
                                                   Editable=No }
    { 12  ;   ;Document Date       ;Date          ;Editable=No }
    { 13  ;   ;Posting Date        ;Date           }
    { 14  ;   ;Currency Code       ;Code10        ;TableRelation=Currency }
    { 15  ;   ;Currency Factor     ;Decimal        }
    { 16  ;   ;Payee               ;Text100        }
    { 17  ;   ;On Behalf Of        ;Text100        }
    { 18  ;   ;Payment Mode        ;Option        ;OptionCaptionML=ENU=" ,Cash,Cheque,EFT,Letter of Credit,Custom 3,Custom 4,Custom 5";
                                                   OptionString=[ ,Cash,Cheque,EFT,Letter of Credit,Custom 3,Custom 4,Custom 5];
                                                   Editable=No }
    { 19  ;   ;Amount              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line".Amount WHERE (Document No=FIELD(No.)));
                                                   Editable=No }
    { 20  ;   ;Amount(LCY)         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line"."Amount(LCY)" WHERE (Document No=FIELD(No.)));
                                                   Editable=No }
    { 21  ;   ;VAT Amount          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line"."VAT Amount" WHERE (Document No=FIELD(No.)));
                                                   Editable=No }
    { 22  ;   ;VAT Amount(LCY)     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line"."VAT Amount(LCY)" WHERE (Document No=FIELD(No.)));
                                                   Editable=No }
    { 23  ;   ;WithHolding Tax Amount;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line"."W/TAX Amount" WHERE (Document No=FIELD(No.)));
                                                   Editable=No }
    { 24  ;   ;WithHolding Tax Amount(LCY);Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line"."W/TAX Amount(LCY)" WHERE (Document No=FIELD(No.)));
                                                   Editable=No }
    { 25  ;   ;Net Amount          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line"."Net Amount" WHERE (Document No=FIELD(No.)));
                                                   Editable=No }
    { 26  ;   ;Net Amount(LCY)     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line"."Net Amount(LCY)" WHERE (Document No=FIELD(No.)));
                                                   Editable=No }
    { 27  ;   ;Bank Account        ;Code10        ;TableRelation="Bank Account";
                                                   OnValidate=BEGIN
                                                                 BankAccount.RESET;
                                                                 BankAccount.SETRANGE(BankAccount."No.","Bank Account");
                                                                 IF BankAccount.FINDFIRST THEN BEGIN
                                                                    "Bank Account Name":=BankAccount.Name;
                                                                 END;
                                                              END;
                                                               }
    { 28  ;   ;Bank Account Name   ;Text50        ;Editable=No }
    { 29  ;   ;Bank Account Balance;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Bank Account Ledger Entry".Amount WHERE (Bank Account No.=FIELD(Bank Account)));
                                                   Editable=No }
    { 30  ;   ;Cheque Type         ;Option        ;OptionCaptionML=ENU=Computer Cheque,Manual Cheque;
                                                   OptionString=Computer Cheque,Manual Cheque }
    { 31  ;   ;Cheque No           ;Code20         }
    { 32  ;   ;Payment Description ;Text50         }
    { 33  ;   ;Global Dimension 1 Code;Code10     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1),
                                                                                               Dimension Value Type=CONST(Standard));
                                                   CaptionClass='1,1,1' }
    { 34  ;   ;Global Dimension 2 Code;Code10     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2),
                                                                                               Dimension Value Type=CONST(Standard));
                                                   CaptionClass='1,2,2' }
    { 35  ;   ;Shortcut Dimension 3 Code;Code10    }
    { 36  ;   ;Shortcut Dimension 4 Code;Code10    }
    { 37  ;   ;Shortcut Dimension 5 Code;Code10    }
    { 38  ;   ;Shortcut Dimension 6 Code;Code10    }
    { 39  ;   ;Shortcut Dimension 7 Code;Code10    }
    { 40  ;   ;Shortcut Dimension 8 Code;Code10    }
    { 41  ;   ;Status              ;Option        ;OptionCaptionML=ENG=New,Pending Approval,Approved,Rejected,Posted,Cancelled;
                                                   OptionString=New,Pending Approval,Approved,Rejected,Posted,Cancelled;
                                                   Editable=Yes }
    { 42  ;   ;Posted              ;Boolean       ;Editable=Yes }
    { 43  ;   ;Posted By           ;Code50        ;TableRelation="User Setup"."User ID";
                                                   Editable=No }
    { 44  ;   ;Date Posted         ;Date          ;Editable=No }
    { 45  ;   ;Time Posted         ;Time          ;Editable=No }
    { 46  ;   ;Cashier             ;Code100       ;TableRelation="User Setup"."User ID";
                                                   Editable=No }
    { 47  ;   ;No. Series          ;Code30         }
    { 48  ;   ;Responsibility Center;Code50       ;TableRelation="Responsibility Center".Code }
    { 49  ;   ;Retention Amount    ;Decimal       ;Editable=No }
    { 50  ;   ;Retention Amount(LCY);Decimal      ;Editable=No }
    { 51  ;   ;User ID             ;Code70         }
    { 52  ;   ;Payment Type        ;Option        ;OptionCaptionML=ENU=Normal,Petty Cash,Express,Cash Purchase,Mobile;
                                                   OptionString=Normal,Petty Cash,Express,Cash Purchase,Mobile;
                                                   Editable=No }
    { 51516430;;Investor Payment   ;Boolean        }
    { 51516431;;Expense Account    ;Code20        ;TableRelation="G/L Account" }
    { 51516432;;Total Payment Amount;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line".Amount WHERE (No=FIELD(No.)));
                                                   Description=Stores the amount of the payment voucher;
                                                   Editable=No }
    { 51516433;;Paying Type        ;Option        ;OptionCaptionML=ENU=" ,Vendor,Bank";
                                                   OptionString=[ ,Vendor,Bank] }
    { 51516434;;Payments Type      ;Option        ;OptionCaptionML=ENU=Normal,Petty Cash,Delegates;
                                                   OptionString=Normal,Petty Cash,Delegates;
                                                   Editable=No }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Setup@1000 : Record 51516030;
      NoSeriesMgt@1001 : Codeunit 396;
      BankAccount@1002 : Record 270;

    BEGIN
    END.
  }
}

OBJECT Table 51516001 Payment Line
{
  OBJECT-PROPERTIES
  {
    Date=11/05/20;
    Time=12:58:28 PM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
                  "Document Type":="Document Type"::Payment;
             END;

  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20         }
    { 2   ;   ;Member No           ;Code20        ;TableRelation="Members Register".No.;
                                                   NotBlank=Yes }
    { 3   ;   ;Interest Amount     ;Decimal       ;OnValidate=BEGIN
                                                                {IF (" Bosa Transaction Type" = " Bosa Transaction Type"::"Registration Fee") THEN BEGIN
                                                                IF "Loan No." = '' THEN
                                                                ERROR('You must specify loan no. for loan transactions.');
                                                                END; }


                                                                IF Loans.GET("Loan No.") THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Oustanding Interest");
                                                                IF "Interest Amount" > Loans."Oustanding Interest" THEN
                                                                ERROR('Interest Repayment cannot be more than the loan oustanding balance.');
                                                                END;


                                                                "Total Amount":=Amount+"Interest Amount";
                                                              END;
                                                               }
    { 6   ;   ;Interest Balance    ;Decimal        }
    { 7   ;   ;Total Amount        ;Decimal       ;Editable=No }
    { 8   ;   ;Amount Balance      ;Decimal        }
    { 10  ;   ;Line No             ;Integer       ;AutoIncrement=Yes;
                                                   MinValue=1000 }
    { 11  ;   ;Document No         ;Code10        ;TableRelation="Payment Header".No.;
                                                   NotBlank=Yes;
                                                   Editable=No }
    { 12  ;   ;Document Type       ;Option        ;OptionCaptionML=ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt";
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt] }
    { 13  ;   ;Currency Code       ;Code10        ;TableRelation=Currency }
    { 14  ;   ;Currency Factor     ;Decimal        }
    { 15  ;   ;Payment Type        ;Code20        ;TableRelation="Funds Transaction Types"."Transaction Code" WHERE (Transaction Type=CONST(Payment));
                                                   OnValidate=BEGIN
                                                                 FundsTypes.RESET;
                                                                 FundsTypes.SETRANGE(FundsTypes."Transaction Code","Payment Type");
                                                                 IF FundsTypes.FINDFIRST THEN BEGIN
                                                                  "Default Grouping":=FundsTypes."Default Grouping";
                                                                  "Account Type":=FundsTypes."Account Type";
                                                                  "Account No.":=FundsTypes."Account No";
                                                                  "Transaction Type Description":=FundsTypes."Transaction Description";
                                                                  "Payment Description":=FundsTypes."Transaction Description";
                                                                  IF FundsTypes."VAT Chargeable" THEN
                                                                     "VAT Code":=FundsTypes."VAT Code";
                                                                  IF FundsTypes."Withholding Tax Chargeable" THEN
                                                                     "W/TAX Code":=FundsTypes."Withholding Tax Code";
                                                                 END;
                                                                 PHeader.RESET;
                                                                 PHeader.SETRANGE(PHeader."No.","Document No");
                                                                 IF PHeader.FINDFIRST THEN BEGIN
                                                                   "Global Dimension 1 Code":=PHeader."Global Dimension 1 Code";
                                                                   "Global Dimension 2 Code":=PHeader."Global Dimension 2 Code";
                                                                   "Shortcut Dimension 3 Code":=PHeader."Shortcut Dimension 3 Code";
                                                                   "Shortcut Dimension 4 Code":=PHeader."Shortcut Dimension 4 Code";
                                                                   "Shortcut Dimension 5 Code":=PHeader."Shortcut Dimension 5 Code";
                                                                   "Shortcut Dimension 6 Code":=PHeader."Shortcut Dimension 6 Code";
                                                                   "Shortcut Dimension 7 Code":=PHeader."Shortcut Dimension 7 Code";
                                                                   "Shortcut Dimension 8 Code":=PHeader."Shortcut Dimension 8 Code";

                                                                   "Responsibility Center":=PHeader."Responsibility Center";
                                                                   //"Pay Mode":=
                                                                   "Currency Code":=PHeader."Currency Code";
                                                                   "Currency Factor":=PHeader."Currency Factor";
                                                                   //"Document Type":=
                                                                  END;

                                                                  VALIDATE("Account Type");
                                                              END;

                                                   NotBlank=Yes }
    { 16  ;   ;Account Type        ;Option        ;OnValidate=BEGIN
                                                                   VALIDATE("Account No.");
                                                              END;

                                                   CaptionML=ENU=Account Type;
                                                   OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor;
                                                   Editable=No }
    { 17  ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting),
                                                                                                                           Blocked=CONST(No))
                                                                                                                           ELSE IF (Account Type=CONST(Customer)) Customer
                                                                                                                           ELSE IF (Account Type=CONST(Vendor)) Vendor WHERE (Vendor Posting Group=FIELD(Default Grouping))
                                                                                                                           ELSE IF (Account Type=CONST(Bank Account)) "Bank Account"
                                                                                                                           ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                                                           ELSE IF (Account Type=CONST(IC Partner)) "IC Partner"
                                                                                                                           ELSE IF (Account Type=CONST(Investor)) "Profitability Set up-Micro"
                                                                                                                           ELSE IF (Account Type=CONST(Member)) "Members Register";
                                                   OnValidate=BEGIN
                                                                   IF "Account Type"="Account Type"::"G/L Account" THEN BEGIN
                                                                      "G/L Account".RESET;
                                                                      "G/L Account".SETRANGE("G/L Account"."No.","Account No.");
                                                                      IF "G/L Account".FINDFIRST THEN BEGIN
                                                                        "Account Name":="G/L Account".Name;
                                                                      END;
                                                                   END;
                                                                   IF "Account Type"="Account Type"::Customer THEN BEGIN
                                                                      Customer.RESET;
                                                                      Customer.SETRANGE(Customer."No.","Account No.");
                                                                      IF Customer.FINDFIRST THEN BEGIN
                                                                        "Account Name":=Customer.Name;
                                                                      END;
                                                                   END;

                                                                   IF "Account Type"="Account Type"::Vendor THEN BEGIN
                                                                      supp.RESET;
                                                                      supp.SETRANGE(supp."No.","Account No.");
                                                                      IF supp.FINDFIRST THEN BEGIN
                                                                        "Account Name":=supp.Name;
                                                                      END;
                                                                   END;
                                                                   IF "Account Type"="Account Type":: Investor THEN BEGIN
                                                                      Investor.RESET;
                                                                      Investor.SETRANGE(Investor.Code,"Account No.");
                                                                      IF Investor.FINDFIRST THEN BEGIN
                                                                        "Account Name":=Investor.Description;
                                                                      END;
                                                                   END;

                                                                   IF "Account No."='' THEN
                                                                    "Account Name":='';
                                                                   IF "Account Type"="Account Type"::Member THEN BEGIN
                                                                      Cust.RESET;
                                                                      Cust.SETRANGE(Cust."No.","Account No.");
                                                                      IF Cust.FINDFIRST THEN BEGIN
                                                                        "Account Name":=Cust.Name;
                                                                      END;
                                                                   END;

                                                                   IF "Account No."='' THEN
                                                                    "Account Name":='';
                                                              END;

                                                   CaptionML=ENU=Account No. }
    { 18  ;   ;Account Name        ;Text50        ;Editable=No }
    { 19  ;   ;Transaction Type Description;Text50 }
    { 20  ;   ;Payment Description ;Text100        }
    { 21  ;   ;Amount              ;Decimal       ;OnValidate=BEGIN

                                                                  IF "Currency Code"<>'' THEN BEGIN
                                                                     "Amount(LCY)":= ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code",Amount,"Currency Factor"));
                                                                  END ELSE BEGIN
                                                                     "Amount(LCY)":=Amount;
                                                                  END;

                                                                  VALIDATE("VAT Code");
                                                                  VALIDATE("W/TAX Code");
                                                              END;
                                                               }
    { 22  ;   ;Amount(LCY)         ;Decimal       ;Editable=No }
    { 23  ;   ;VAT Code            ;Code20        ;TableRelation="Funds Tax Codes"."Tax Code" WHERE (Type=CONST(VAT));
                                                   OnValidate=BEGIN
                                                                 FundsTaxCodes.RESET;
                                                                 FundsTaxCodes.SETRANGE(FundsTaxCodes."Tax Code","VAT Code");
                                                                 IF FundsTaxCodes.FINDFIRST THEN BEGIN
                                                                   "VAT Amount":=Amount*(FundsTaxCodes.Percentage/100);
                                                                 END;
                                                                 VALIDATE("VAT Amount");
                                                              END;
                                                               }
    { 24  ;   ;VAT Amount          ;Decimal       ;OnValidate=BEGIN
                                                                  "Net Amount":=Amount-"VAT Amount";
                                                                  IF "Currency Code"<>'' THEN BEGIN
                                                                     "VAT Amount(LCY)":= ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code","VAT Amount","Currency Factor"));
                                                                     "Net Amount(LCY)":=ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code","Net Amount","Currency Factor"));
                                                                  END ELSE BEGIN
                                                                     "VAT Amount(LCY)":="VAT Amount";
                                                                     "Net Amount(LCY)":="Net Amount";
                                                                  END;
                                                              END;

                                                   Editable=No }
    { 25  ;   ;VAT Amount(LCY)     ;Decimal       ;Editable=No }
    { 26  ;   ;W/TAX Code          ;Code20        ;TableRelation="Funds Tax Codes"."Tax Code" WHERE (Type=CONST(W/Tax));
                                                   OnValidate=BEGIN
                                                                 FundsTaxCodes.RESET;
                                                                 FundsTaxCodes.SETRANGE(FundsTaxCodes."Tax Code","W/TAX Code");
                                                                 IF FundsTaxCodes.FINDFIRST THEN BEGIN
                                                                   "W/TAX Amount":=Amount*(FundsTaxCodes.Percentage/100);
                                                                 END;
                                                                 VALIDATE("W/TAX Amount");
                                                              END;
                                                               }
    { 27  ;   ;W/TAX Amount        ;Decimal       ;OnValidate=BEGIN
                                                                  "Net Amount":=Amount-"W/TAX Amount";
                                                                  IF "Currency Code"<>'' THEN BEGIN
                                                                     "W/TAX Amount(LCY)":= ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code","W/TAX Amount","Currency Factor"));
                                                                     "Net Amount(LCY)":=ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code","Net Amount","Currency Factor"));
                                                                  END ELSE BEGIN
                                                                     "W/TAX Amount(LCY)":="W/TAX Amount";
                                                                     "Net Amount(LCY)":="Net Amount";
                                                                  END;
                                                              END;

                                                   Editable=No }
    { 28  ;   ;W/TAX Amount(LCY)   ;Decimal       ;Editable=No }
    { 29  ;   ;Retention Code      ;Code20        ;TableRelation="Funds Tax Codes"."Tax Code" WHERE (Type=CONST(Retention)) }
    { 30  ;   ;Retention Amount    ;Decimal       ;Editable=No }
    { 31  ;   ;Retention Amount(LCY);Decimal      ;Editable=No }
    { 32  ;   ;Net Amount          ;Decimal       ;Editable=No }
    { 33  ;   ;Net Amount(LCY)     ;Decimal       ;Editable=No }
    { 34  ;   ;Committed           ;Boolean        }
    { 35  ;   ;Vote Book           ;Code20         }
    { 36  ;   ;Gen. Bus. Posting Group;Code20      }
    { 37  ;   ;Gen. Prod. Posting Group;Code20     }
    { 38  ;   ;VAT Bus. Posting Group;Code20       }
    { 39  ;   ;VAT Prod. Posting Group;Code20      }
    { 40  ;   ;Global Dimension 1 Code;Code10     ;Editable=No }
    { 41  ;   ;Global Dimension 2 Code;Code10     ;Editable=No }
    { 42  ;   ;Shortcut Dimension 3 Code;Code10    }
    { 43  ;   ;Shortcut Dimension 4 Code;Code10    }
    { 44  ;   ;Shortcut Dimension 5 Code;Code10    }
    { 45  ;   ;Shortcut Dimension 6 Code;Code10    }
    { 46  ;   ;Shortcut Dimension 7 Code;Code10    }
    { 47  ;   ;Shortcut Dimension 8 Code;Code10    }
    { 48  ;   ;Applies-to Doc. Type;Option        ;CaptionML=ENU=Applies-to Doc. Type;
                                                   OptionCaptionML=ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund";
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 49  ;   ;Applies-to Doc. No. ;Code20        ;OnLookup=VAR
                                                              VendLedgEntry@1102756003 : Record 25;
                                                              PayToVendorNo@1102756001 : Code[20];
                                                              OK@1102756000 : Boolean;
                                                              Text000@1102756004 : TextConst 'ENU=You must specify %1 or %2.';
                                                            BEGIN
                                                            END;

                                                   CaptionML=ENU=Applies-to Doc. No. }
    { 50  ;   ;Applies-to ID       ;Code50        ;OnValidate=VAR
                                                                TempVendLedgEntry@1000 : Record 25;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Applies-to ID }
    { 51  ;   ;VAT Withheld        ;Code20         }
    { 52  ;   ;VAT Withheld Amount ;Decimal       ;Editable=No }
    { 53  ;   ;VAT Withheld Amount(LCY);Decimal   ;Editable=No }
    { 54  ;   ;Status              ;Option        ;OptionCaptionML=ENU=New,Pending Approval,Approved,Rejected,Posted;
                                                   OptionString=New,Pending Approval,Approved,Rejected,Posted;
                                                   Editable=No }
    { 55  ;   ;Posted              ;Boolean       ;Editable=No }
    { 56  ;   ;Posted By           ;Code50        ;TableRelation="User Setup"."User ID";
                                                   Editable=No }
    { 57  ;   ;Date Posted         ;Date          ;Editable=No }
    { 58  ;   ;Time Posted         ;Time          ;Editable=No }
    { 59  ;   ;Default Grouping    ;Code50        ;Editable=No }
    { 60  ;   ;Responsibility Center;Code50       ;Editable=No }
    { 61  ;   ;Posting Date        ;Date           }
    { 62  ;   ;Date                ;Date           }
    { 50000;  ;Names               ;Text30         }
    { 50001;  ;Loan No.            ;Code20        ;TableRelation=IF (Transaction Type=CONST(Loan)) "Loans Register"."Loan  No." WHERE (Client Code=FIELD(Account No.)) }
    { 50002;  ;Transaction Type    ;Option        ;OptionCaptionML=ENU=" ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid";
                                                   OptionString=[ ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid] }
    { 50003;  ;Refund Charge       ;Decimal        }
    { 51516430;;Investor Interest Code;Code20     ;TableRelation=IF (Account Type=CONST(Investor)) "Investor Amounts"."Interest Code" WHERE (Investor No=FIELD(Account No.)) }
    { 51516431;;Investment Date    ;Date          ;TableRelation=IF (Account Type=CONST(Investor)) "Investor Amounts"."Investment Date" WHERE (Investor No=FIELD(Account No.),
                                                                                                                                               Interest Code=FIELD(Investor Interest Code));
                                                   OnValidate=BEGIN
                                                                   InvestorAmounts.RESET;
                                                                   InvestorAmounts.SETRANGE(InvestorAmounts."Investor No","Account No.");
                                                                   InvestorAmounts.SETRANGE(InvestorAmounts."Interest Code","Investor Interest Code");
                                                                   InvestorAmounts.SETRANGE(InvestorAmounts."Investment Date","Investment Date");
                                                                   IF InvestorAmounts.FINDFIRST THEN BEGIN
                                                                    InterestCodes.RESET;
                                                                    InterestCodes.SETRANGE(InterestCodes.Code,InvestorAmounts."Interest Code");
                                                                    IF InterestCodes.FINDFIRST THEN BEGIN
                                                                      Amount:=(InvestorAmounts.Amount)*(InterestCodes.Percentage/100);
                                                                      VALIDATE(Amount);
                                                                    END;
                                                                   END;
                                                              END;
                                                               }
    { 51516432;;Withholding Tax Code;Code20       ;TableRelation=IF (Account Type=CONST(Vendor)) "Tariff Codes".Code WHERE (Type=CONST(W/Tax));
                                                   OnValidate=BEGIN
                                                                      //CalculateTax();
                                                              END;
                                                               }
    { 51516433;;Payee              ;Text100        }
  }
  KEYS
  {
    {    ;Line No,Document No,Payment Type        ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      FundsTypes@1000 : Record 51516032;
      PHeader@1001 : Record 51516000;
      "G/L Account"@1002 : Record 15;
      Customer@1003 : Record 18;
      Vendor@1004 : Record 23;
      Investor@1005 : Record 51516433;
      FundsTaxCodes@1006 : Record 51516033;
      CurrExchRate@1007 : Record 330;
      Loans@1009 : Record 51516230;
      Cust@1008 : Record 51516223;
      InvestorAmounts@1010 : Record 51516440;
      InterestCodes@1011 : Record 51516439;
      supp@1120054000 : Record 51516017;

    BEGIN
    END.
  }
}

OBJECT Table 51516002 Receipt Header
{
  OBJECT-PROPERTIES
  {
    Date=02/23/16;
    Time=11:04:35 AM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 Setup.GET;
                 Setup.TESTFIELD(Setup."Receipt Nos");
                 NoSeriesMgt.InitSeries(Setup."Receipt Nos",xRec."No. Series",0D,"No.","No. Series");
               END;
               "User ID":=USERID;
               Date:=TODAY;
               "Document Type":="Document Type"::Receipt;
             END;

  }
  FIELDS
  {
    { 10  ;   ;No.                 ;Code10        ;Editable=No }
    { 11  ;   ;Document Type       ;Option        ;OptionCaptionML=ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt";
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt];
                                                   Editable=No }
    { 12  ;   ;Date                ;Date          ;Editable=No }
    { 13  ;   ;Posting Date        ;Date           }
    { 14  ;   ;Bank Code           ;Code20        ;TableRelation="Bank Account".No.;
                                                   OnValidate=BEGIN
                                                                  BankAccount.RESET;
                                                                  BankAccount.SETRANGE(BankAccount."No.","Bank Code");
                                                                  IF BankAccount.FINDFIRST THEN BEGIN
                                                                    "Bank Name":=BankAccount.Name;
                                                                  END;
                                                              END;
                                                               }
    { 15  ;   ;Bank Name           ;Text50        ;Editable=No }
    { 16  ;   ;Bank Balance        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Bank Account Ledger Entry".Amount WHERE (Bank Account No.=FIELD(Bank Code)));
                                                   Editable=No }
    { 17  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                  VALIDATE("Responsibility Center");
                                                              END;
                                                               }
    { 18  ;   ;Currency Factor     ;Decimal        }
    { 19  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1),
                                                                                               Dimension Value Type=CONST(Standard));
                                                   CaptionClass='1,1,1' }
    { 20  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2),
                                                                                               Dimension Value Type=CONST(Standard));
                                                   CaptionClass='1,2,2' }
    { 21  ;   ;Shortcut Dimension 3 Code;Code20    }
    { 22  ;   ;Shortcut Dimension 4 Code;Code20    }
    { 23  ;   ;Shortcut Dimension 5 Code;Code20    }
    { 24  ;   ;Shortcut Dimension 6 Code;Code20    }
    { 25  ;   ;Shortcut Dimension 7 Code;Code20    }
    { 26  ;   ;Shortcut Dimension 8 Code;Code20    }
    { 27  ;   ;Responsibility Center;Code20       ;TableRelation="Responsibility Center".Code }
    { 28  ;   ;Amount Received     ;Decimal       ;OnValidate=BEGIN
                                                                  IF "Currency Code"='' THEN BEGIN
                                                                    "Amount Received(LCY)":="Amount Received";
                                                                  END ELSE BEGIN
                                                                    "Currency Factor":=CurrExchRate.ExchangeRate("Posting Date","Currency Code");
                                                                   "Amount Received(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code","Amount Received","Currency Factor"));
                                                                  END;
                                                              END;
                                                               }
    { 29  ;   ;Amount Received(LCY);Decimal       ;Editable=No }
    { 30  ;   ;Total Amount        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Receipt Line".Amount WHERE (Document No=FIELD(No.)));
                                                   Editable=No }
    { 31  ;   ;Total Amount(LCY)   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Receipt Line"."Amount(LCY)" WHERE (Document No=FIELD(No.)));
                                                   Editable=No }
    { 32  ;   ;User ID             ;Code50        ;Editable=No }
    { 33  ;   ;Status              ;Option        ;OptionCaptionML=ENU=New,Pending Approval,Approved,Rejected,Posted;
                                                   OptionString=New,Pending Approval,Approved,Rejected,Posted;
                                                   Editable=No }
    { 34  ;   ;Description         ;Text50         }
    { 35  ;   ;Received From       ;Text50         }
    { 36  ;   ;On Behalf of        ;Text50         }
    { 37  ;   ;No. Series          ;Code20         }
    { 38  ;   ;Posted              ;Boolean       ;Editable=No }
    { 39  ;   ;Date Posted         ;Date          ;Editable=No }
    { 40  ;   ;Time Posted         ;Time          ;Editable=No }
    { 41  ;   ;Posted By           ;Code50        ;Editable=No }
    { 42  ;   ;Cheque No           ;Code20         }
    { 43  ;   ;Date Created        ;Date          ;Editable=No }
    { 44  ;   ;Time Created        ;Time          ;Editable=No }
    { 45  ;   ;Receipt Type        ;Option        ;OptionCaptionML=ENU=Bank,Cash;
                                                   OptionString=Bank,Cash }
    { 51516450;;Investor Transaction;Option       ;OptionCaptionML=ENU=" ,Principle,Topup";
                                                   OptionString=[ ,Principle,Topup];
                                                   Description=Investment Management }
    { 51516451;;Interest Code      ;Code20        ;TableRelation="Interest Rates".Code;
                                                   Description=Investment Management }
    { 51516452;;Investor Net Amount;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Receipt Line"."Net Amount" WHERE (Investor Principle/Topup=CONST(Yes),
                                                                                                      Document No=FIELD(No.)));
                                                   Description=Investment Management;
                                                   Editable=No }
    { 51516453;;Investor Net Amount(LCY);Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Receipt Line"."Net Amount(LCY)" WHERE (Investor Principle/Topup=CONST(Yes),
                                                                                                           Document No=FIELD(No.)));
                                                   Description=Investment Management;
                                                   Editable=No }
    { 51516454;;Investor No.       ;Code20        ;TableRelation="Profitability Set up-Micro".Code;
                                                   OnValidate=BEGIN
                                                                  "Investor Account".RESET;
                                                                  "Investor Account".SETRANGE("Investor Account".Code,"Investor No.");
                                                                  IF "Investor Account".FINDFIRST THEN BEGIN
                                                                    "Investor Name":="Investor Account".Description;
                                                                  END;
                                                              END;

                                                   Description=Investment Management }
    { 51516455;;Investor Name      ;Text50        ;Description=Investment Management;
                                                   Editable=No }
    { 51516830;;Project Code       ;Code20        ;TableRelation="Fixed Asset".No. WHERE (Project Asset=CONST(Yes),
                                                                                          Closed=CONST(No));
                                                   OnValidate=BEGIN
                                                                 IF "Project Code"<>'' THEN BEGIN
                                                                    FA.RESET;
                                                                    FA.SETRANGE(FA."No.","Project Code");
                                                                    IF FA.FINDFIRST THEN BEGIN
                                                                      "Project Name":=FA.Description;
                                                                    END;
                                                                 END;
                                                              END;

                                                   Description=Project Management Field }
    { 51516831;;Property Code      ;Code20        ;TableRelation="Fixed Asset".No. WHERE (Project No.=FIELD(Project Code),
                                                                                          Property Asset=CONST(Yes),
                                                                                          Receipted=CONST(No));
                                                   OnValidate=BEGIN
                                                                 IF "Property Code"<>'' THEN BEGIN
                                                                    FA.RESET;
                                                                    FA.SETRANGE(FA."No.","Property Code");
                                                                    IF FA.FINDFIRST THEN BEGIN
                                                                      "Property Name":=FA.Description;
                                                                    END;
                                                                 END;
                                                              END;

                                                   Description=Project Management Field }
    { 51516832;;Project Name       ;Text50        ;Description=Project Management Field;
                                                   Editable=No }
    { 51516833;;Property Name      ;Text50        ;Description=Project Management Field;
                                                   Editable=No }
    { 51516834;;Receipt Category   ;Option        ;OptionCaptionML=ENU=Normal,Investor,Property;
                                                   OptionString=Normal,Investor,Property }
    { 51516835;;Property Total Amount;Decimal     ;Description=Project Management Field }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Setup@1000 : Record 51516030;
      NoSeriesMgt@1001 : Codeunit 396;
      BankAccount@1002 : Record 270;
      CurrExchRate@1003 : Record 330;
      "Investor Account"@1004 : Record 51516433;
      FA@1005 : Record 5600;

    BEGIN
    END.
  }
}

OBJECT Table 51516003 Receipt Line
{
  OBJECT-PROPERTIES
  {
    Date=04/05/18;
    Time=11:31:21 AM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Line No             ;Integer       ;AutoIncrement=Yes;
                                                   Editable=No }
    { 11  ;   ;Document No         ;Code20        ;Editable=No }
    { 12  ;   ;Document Type       ;Option        ;OptionCaptionML=ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt";
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt];
                                                   Editable=No }
    { 13  ;   ;Transaction Type    ;Code20        ;TableRelation="Funds Transaction Types"."Transaction Code" WHERE (Transaction Type=CONST(Receipt));
                                                   OnValidate=BEGIN
                                                                 FundsTypes.RESET;
                                                                 FundsTypes.SETRANGE(FundsTypes."Transaction Code","Transaction Type");
                                                                 IF FundsTypes.FINDFIRST THEN BEGIN
                                                                  "Default Grouping":=FundsTypes."Default Grouping";
                                                                  "Account Type":=FundsTypes."Account Type";
                                                                  "Account Code":=FundsTypes."Account No";
                                                                  Description:=FundsTypes."Transaction Description";
                                                                  //"Legal Fee Code":=FundsTypes."Legal Fee Code";
                                                                  //"Legal Fee Amount":=FundsTypes."Legal Fee Amount";
                                                                  "Investor Principle/Topup":=FundsTypes."Investor Principle/Topup";
                                                                 END;
                                                                  RHeader.RESET;
                                                                  RHeader.SETRANGE(RHeader."No.","Document No");
                                                                  IF RHeader.FINDFIRST THEN BEGIN
                                                                      "Global Dimension 1 Code":=RHeader."Global Dimension 1 Code";
                                                                      "Global Dimension 2 Code":=RHeader."Global Dimension 2 Code";
                                                                      "Shortcut Dimension 3 Code":=RHeader."Shortcut Dimension 3 Code";
                                                                      "Shortcut Dimension 4 Code":=RHeader."Shortcut Dimension 4 Code";
                                                                      "Shortcut Dimension 5 Code":=RHeader."Shortcut Dimension 5 Code";
                                                                      "Shortcut Dimension 6 Code":=RHeader."Shortcut Dimension 6 Code";
                                                                      "Shortcut Dimension 7 Code":=RHeader."Shortcut Dimension 7 Code";
                                                                      "Shortcut Dimension 8 Code":=RHeader."Shortcut Dimension 8 Code";

                                                                      "Responsibility Center":=RHeader."Responsibility Center";
                                                                      //"Pay Mode":=
                                                                      "Currency Code":=RHeader."Currency Code";
                                                                      "Currency Factor":=RHeader."Currency Factor";
                                                                      "Document Type":="Document Type"::Receipt;
                                                                  END;
                                                                  VALIDATE("Account Type");
                                                              END;
                                                               }
    { 14  ;   ;Default Grouping    ;Code20        ;Editable=No }
    { 15  ;   ;Account Type        ;Option        ;OnValidate=BEGIN
                                                                   IF "Account Type"="Account Type"::Investor THEN BEGIN
                                                                    RHeader.RESET;
                                                                    RHeader.SETRANGE(RHeader."No.","Document No");
                                                                    IF RHeader.FINDFIRST THEN BEGIN
                                                                     "Account Code":=RHeader."Investor No.";
                                                                     "Account Name":=RHeader."Investor Name";
                                                                    END;
                                                                   END;
                                                                   VALIDATE("Account Code");
                                                              END;

                                                   OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Staff,Investor,Member;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Staff,Investor,Member;
                                                   Editable=Yes }
    { 16  ;   ;Account Code        ;Code20        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Account Type=CONST(Investor)) "Profitability Set up-Micro";
                                                   OnValidate=BEGIN
                                                                   IF "Account Type"="Account Type"::"G/L Account" THEN BEGIN
                                                                      "G/L Account".RESET;
                                                                      "G/L Account".SETRANGE("G/L Account"."No.","Account Code");
                                                                      IF "G/L Account".FINDFIRST THEN BEGIN
                                                                        "Account Name":="G/L Account".Name;
                                                                      END;
                                                                   END;
                                                                   IF "Account Type"="Account Type"::Customer THEN BEGIN
                                                                      Customer.RESET;
                                                                      Customer.SETRANGE(Customer."No.","Account Code");
                                                                      IF Customer.FINDFIRST THEN BEGIN
                                                                        "Account Name":=Customer.Name;
                                                                      END;
                                                                   END;
                                                                   IF "Account Type"="Account Type"::Vendor THEN BEGIN
                                                                      Vendor.RESET;
                                                                      Vendor.SETRANGE(Vendor."No.","Account Code");
                                                                      IF Vendor.FINDFIRST THEN BEGIN
                                                                        "Account Name":=Vendor.Name;
                                                                      END;
                                                                   END;
                                                                   IF "Account Type"="Account Type"::Investor THEN BEGIN
                                                                      Investor.RESET;
                                                                      Investor.SETRANGE(Investor.Code,"Account Code");
                                                                      IF Investor.FINDFIRST THEN BEGIN
                                                                        "Account Name":=Investor.Description;
                                                                      END;
                                                                   END;

                                                                   IF "Account Code"='' THEN
                                                                    "Account Name":='';
                                                              END;
                                                               }
    { 17  ;   ;Account Name        ;Text50        ;Editable=No }
    { 18  ;   ;Description         ;Text50        ;Editable=No }
    { 19  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1),
                                                                                               Dimension Value Type=CONST(Standard));
                                                   Editable=No;
                                                   CaptionClass='1,1,1' }
    { 20  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2),
                                                                                               Dimension Value Type=CONST(Standard));
                                                   Editable=No;
                                                   CaptionClass='1,2,2' }
    { 21  ;   ;Shortcut Dimension 3 Code;Code20   ;Editable=No }
    { 22  ;   ;Shortcut Dimension 4 Code;Code20   ;Editable=No }
    { 23  ;   ;Shortcut Dimension 5 Code;Code20   ;Editable=No }
    { 24  ;   ;Shortcut Dimension 6 Code;Code20   ;Editable=No }
    { 25  ;   ;Shortcut Dimension 7 Code;Code20   ;Editable=No }
    { 26  ;   ;Shortcut Dimension 8 Code;Code20   ;Editable=No }
    { 27  ;   ;Responsibility Center;Code20        }
    { 28  ;   ;Pay Mode            ;Option        ;OptionCaptionML=ENU=" ,Cash,Cheque,Deposit Slip,EFT,Bankers Cheque,RTGS";
                                                   OptionString=[ ,Cash,Cheque,Deposit Slip,EFT,Bankers Cheque,RTGS] }
    { 29  ;   ;Currency Code       ;Code20         }
    { 30  ;   ;Currency Factor     ;Decimal        }
    { 31  ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                 IF "Currency Code"='' THEN BEGIN
                                                                   "Amount(LCY)":=Amount;
                                                                 END ELSE BEGIN
                                                                   "Amount(LCY)":= ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code",Amount,"Currency Factor"));
                                                                 END;
                                                                 //VALIDATE("Legal Fee Code");

                                                                 "Net Amount":=Amount;
                                                                 "Net Amount(LCY)":="Amount(LCY)";
                                                              END;
                                                               }
    { 32  ;   ;Amount(LCY)         ;Decimal       ;Editable=No }
    { 33  ;   ;Cheque No           ;Code20         }
    { 34  ;   ;Applies-To Doc No.  ;Code20         }
    { 35  ;   ;Applies-To ID       ;Code20         }
    { 36  ;   ;VAT Code            ;Code20        ;TableRelation="Funds Tax Codes"."Tax Code" WHERE (Type=CONST(VAT)) }
    { 37  ;   ;VAT Percentage      ;Decimal        }
    { 38  ;   ;VAT Amount          ;Decimal        }
    { 39  ;   ;VAT Amount(LCY)     ;Decimal        }
    { 40  ;   ;W/TAX Code          ;Code20        ;TableRelation="Funds Tax Codes"."Tax Code" WHERE (Type=CONST(W/Tax)) }
    { 41  ;   ;W/TAX Percentage    ;Decimal        }
    { 42  ;   ;W/TAX Amount        ;Decimal        }
    { 43  ;   ;W/TAX Amount(LCY)   ;Decimal        }
    { 44  ;   ;Net Amount          ;Decimal       ;Editable=No }
    { 45  ;   ;Net Amount(LCY)     ;Decimal       ;Editable=No }
    { 46  ;   ;Gen. Bus. Posting Group;Code20      }
    { 47  ;   ;Gen. Prod. Posting Group;Code20     }
    { 48  ;   ;VAT Bus. Posting Group;Code20       }
    { 49  ;   ;VAT Prod. Posting Group;Code20      }
    { 50  ;   ;User ID             ;Code50        ;Editable=No }
    { 51  ;   ;Status              ;Option        ;OptionCaptionML=ENU=New,Pending Approval,Approved,Rejected,Posted;
                                                   OptionString=New,Pending Approval,Approved,Rejected,Posted;
                                                   Editable=No }
    { 52  ;   ;Posted              ;Boolean       ;Editable=No }
    { 53  ;   ;Date Posted         ;Date          ;Editable=No }
    { 54  ;   ;Time Posted         ;Time          ;Editable=No }
    { 55  ;   ;Posted By           ;Code50        ;Editable=No }
    { 56  ;   ;Date Created        ;Date          ;Editable=No }
    { 57  ;   ;Time Created        ;Time          ;Editable=No }
    { 58  ;   ;Legal Fee Code      ;Code20        ;TableRelation="Funds Tax Codes"."Tax Code" WHERE (Type=CONST(Legal));
                                                   OnValidate=BEGIN
                                                                   { TESTFIELD(Amount);
                                                                    "Net Amount":=Amount-"Legal Fee Amount";
                                                                    IF "Currency Code"='' THEN BEGIN
                                                                      "Legal Fee Amount(LCY)":="Legal Fee Amount";
                                                                      "Net Amount(LCY)":=Amount-"Legal Fee Amount";
                                                                    END ELSE BEGIN
                                                                      "Legal Fee Amount(LCY)":=ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code","Legal Fee Amount","Currency Factor"));
                                                                      "Net Amount(LCY)":=ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code","Net Amount","Currency Factor"));
                                                                    END;}
                                                              END;

                                                   Description=Investment Field }
    { 59  ;   ;Legal Fee Amount    ;Decimal       ;Description=Investment Field;
                                                   Editable=No }
    { 60  ;   ;Legal Fee Amount(LCY);Decimal      ;Description=Investment Field }
    { 61  ;   ;Date                ;Date           }
    { 62  ;   ;Posting Date        ;Date           }
    { 63  ;   ;Investor Principle/Topup;Boolean   ;Description=Investment Field }
    { 51516000;;Loan No            ;Code10        ;TableRelation="Loans Register"."Loan  No." WHERE (Client Code=FIELD(Account Code),
                                                                                                     Posted=FILTER(Yes)) }
    { 51516001;;BOSATransaction Type;Option       ;OptionCaptionML=ENU=" ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated";
                                                   OptionString=[ ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated] }
  }
  KEYS
  {
    {    ;Line No,Document No,Transaction Type    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      FundsTypes@1000 : Record 51516032;
      "G/L Account"@1001 : Record 15;
      Customer@1002 : Record 18;
      Vendor@1003 : Record 23;
      Investor@1004 : Record 51516433;
      RHeader@1005 : Record 51516002;
      FundsTaxCodes@1006 : Record 51516033;
      CurrExchRate@1007 : Record 330;

    BEGIN
    END.
  }
}

OBJECT Table 51516004 Funds Transfer Header
{
  OBJECT-PROPERTIES
  {
    Date=07/12/18;
    Time=[ 3:03:09 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "No."=''THEN BEGIN
                 GenFundsSetup.GET;
                 GenFundsSetup.TESTFIELD(GenFundsSetup."Funds Transfer Nos");
                 NoSeriesMgt.InitSeries(GenFundsSetup."Funds Transfer Nos",xRec."No. Series",0D,"No.","No. Series");
               END;
               "Time Created":=TIME;
               "Date Created":=TODAY;
             END;

    OnModify=BEGIN
               IF Posted=TRUE THEN
               ERROR('You cannot MODIFY a posted document' );
             END;

    OnDelete=BEGIN
               ERROR('You cannot delete a document');
             END;

  }
  FIELDS
  {
    { 10  ;   ;No.                 ;Code10        ;OnValidate=BEGIN
                                                                IF "No."<> xRec."No." THEN BEGIN
                                                                  GenFundsSetup.GET;
                                                                  NoSeriesMgt.TestManual(GenFundsSetup."Funds Transfer Nos");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 11  ;   ;Date                ;Date           }
    { 12  ;   ;Posting Date        ;Date           }
    { 13  ;   ;Paying Bank Account ;Code20        ;TableRelation="Bank Account".No.;
                                                   OnValidate=BEGIN
                                                                 BankAcc.RESET;
                                                                 BankAcc.SETRANGE(BankAcc."No.");
                                                                 IF BankAcc.FINDFIRST THEN BEGIN
                                                                    "Paying Bank Name":=BankAcc.Name;
                                                                 END;
                                                              END;
                                                               }
    { 14  ;   ;Paying Bank Name    ;Text50         }
    { 15  ;   ;Bank Balance        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Bank Account Ledger Entry".Amount WHERE (Bank Account No.=FIELD(Paying Bank Account))) }
    { 16  ;   ;Bank Balance(LCY)   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Bank Account Ledger Entry"."Amount (LCY)" WHERE (Bank Account No.=FIELD(No.),
                                                                                                                     Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Global Dimension 2 Code=FIELD(Global Dimension 2 Filter))) }
    { 20  ;   ;Amount to Transfer  ;Decimal        }
    { 21  ;   ;Amount to Transfer(LCY);Decimal     }
    { 22  ;   ;Total Line Amount   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Funds Transfer Line"."Amount to Receive" WHERE (Document No=FIELD(No.))) }
    { 23  ;   ;Total Line Amount(LCY);Decimal      }
    { 24  ;   ;Pay Mode            ;Option        ;OptionCaptionML=ENU=" ,Cash,Cheque";
                                                   OptionString=[ ,Cash,Cheque,Bank Slip];
                                                   Editable=No }
    { 25  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending Approval,Approved,Cancelled,Posted;
                                                   OptionString=Open,Pending Approval,Approved,Cancelled,Posted;
                                                   Editable=Yes }
    { 26  ;   ;Cheque/Doc. No      ;Code20         }
    { 27  ;   ;Description         ;Text50         }
    { 28  ;   ;No. Series          ;Code20         }
    { 29  ;   ;Posted              ;Boolean       ;Editable=No }
    { 30  ;   ;Posted By           ;Code20        ;Editable=No }
    { 31  ;   ;Date Posted         ;Date          ;Editable=No }
    { 32  ;   ;Time Posted         ;Time           }
    { 33  ;   ;Created By          ;Code60         }
    { 34  ;   ;Date Created        ;Date           }
    { 35  ;   ;Time Created        ;Time           }
    { 36  ;   ;Source Transfer Type;Option        ;OptionString=Intra-Company,Inter-Company }
    { 56  ;   ;Global Dimension 1 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Global Dimension 1 Filter;
                                                   CaptionClass='1,3,1' }
    { 57  ;   ;Global Dimension 2 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=ENU=Global Dimension 2 Filter;
                                                   CaptionClass='1,3,2' }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      GenFundsSetup@1007 : Record 51516030;
      NoSeriesMgt@1006 : Codeunit 396;
      TempBatch@1005 : Record 51516031;
      BankAcc@1004 : Record 270;
      DimVal@1003 : Record 349;
      ICPartner@1002 : Record 413;
      RespCenter@1001 : Record 5714;
      UserMgt@1000 : Codeunit 51516155;
      Setup@1000000002 : Record 51516030;

    BEGIN
    END.
  }
}

OBJECT Table 51516005 Funds Transfer Line
{
  OBJECT-PROPERTIES
  {
    Date=05/10/16;
    Time=[ 4:30:27 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Line No             ;Integer       ;AutoIncrement=Yes }
    { 11  ;   ;Document No         ;Code10         }
    { 12  ;   ;Document Type       ;Code10         }
    { 13  ;   ;Date                ;Date           }
    { 14  ;   ;Posting Date        ;Date           }
    { 15  ;   ;Pay Mode            ;Option        ;OptionCaptionML=ENU=" ,Cash,Cheque";
                                                   OptionString=[ ,Cash,Cheque] }
    { 16  ;   ;Receiving Bank Account;Code40      ;TableRelation="Bank Account".No.;
                                                   OnValidate=BEGIN
                                                                BankAcc.RESET;
                                                                 BankAcc.SETRANGE(BankAcc."No.","Receiving Bank Account");
                                                                 IF BankAcc.FINDFIRST THEN BEGIN
                                                                    "Bank Name":=BankAcc.Name;
                                                                 END;
                                                              END;
                                                               }
    { 17  ;   ;Bank Name           ;Text50         }
    { 18  ;   ;Bank Balance        ;Decimal        }
    { 19  ;   ;Bank Balance(LCY)   ;Decimal        }
    { 20  ;   ;Bank Account No.    ;Code20         }
    { 21  ;   ;Currency Code       ;Code20         }
    { 22  ;   ;Currency Factor     ;Decimal        }
    { 23  ;   ;Amount to Receive   ;Decimal        }
    { 24  ;   ;Amount to Receive (LCY);Decimal    ;Editable=No }
    { 25  ;   ;External Doc No.    ;Code20         }
    { 32  ;   ;Receiving Transfer Type;Option     ;OptionString=Intra-Company,Inter-Company }
  }
  KEYS
  {
    {    ;Document No,Line No                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      BankAcc@1000000000 : Record 270;

    BEGIN
    END.
  }
}

OBJECT Table 51516006 Imprest Header
{
  OBJECT-PROPERTIES
  {
    Date=09/24/15;
    Time=[ 9:44:45 AM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;No.                 ;Code10         }
    { 11  ;   ;Document Type       ;Option        ;OptionCaptionML=ENU=Normal,Cash Purchase,Petty Cash,Express;
                                                   OptionString=Normal,Cash Purchase,Petty Cash,Express }
    { 12  ;   ;Document Date       ;Date           }
    { 13  ;   ;Posting Date        ;Date          ;TableRelation=Currency }
    { 14  ;   ;Currency Code       ;Code10        ;TableRelation=Currency }
    { 15  ;   ;Currency Factor     ;Decimal        }
    { 16  ;   ;Payee               ;Text100        }
    { 17  ;   ;On Behalf Of        ;Text100        }
    { 18  ;   ;Payment Mode        ;Option        ;OptionCaptionML=ENU=" ,Cash,Cheque,EFT,Letter of Credit,Custom 3,Custom 4,Custom 5";
                                                   OptionString=[ ,Cash,Cheque,EFT,Letter of Credit,Custom 3,Custom 4,Custom 5] }
    { 19  ;   ;Amount              ;Decimal       ;FieldClass=FlowField }
    { 20  ;   ;Amount(LCY)         ;Decimal        }
    { 21  ;   ;VAT Amount          ;Decimal        }
    { 22  ;   ;VAT Amount(LCY)     ;Decimal        }
    { 23  ;   ;WithHolding Tax Amount;Decimal      }
    { 24  ;   ;WithHolding Tax Amount(LCY);Decimal }
    { 25  ;   ;Net Amount          ;Decimal        }
    { 26  ;   ;Net Amount(LCY)     ;Decimal        }
    { 27  ;   ;Bank Account        ;Code10        ;TableRelation="Bank Account" }
    { 28  ;   ;Bank Account Name   ;Text100        }
    { 29  ;   ;Bank Account Balance;Decimal        }
    { 30  ;   ;Cheque Type         ;Option        ;OptionCaptionML=ENU=Computer Cheque,Manual Cheque;
                                                   OptionString=Computer Cheque,Manual Cheque }
    { 31  ;   ;Cheque No           ;Code20         }
    { 32  ;   ;Payment Description ;Text100        }
    { 33  ;   ;Global Dimension 1 Code;Code10      }
    { 34  ;   ;Global Dimension 2 Code;Code10      }
    { 35  ;   ;Shortcut Dimension 3 Code;Code10    }
    { 36  ;   ;Shortcut Dimension 4 Code;Code10    }
    { 37  ;   ;Shortcut Dimension 5 Code;Code10    }
    { 38  ;   ;Shortcut Dimension 6 Code;Code10    }
    { 39  ;   ;Shortcut Dimension 7 Code;Code10    }
    { 40  ;   ;Shortcut Dimension 8 Code;Code10    }
    { 41  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending Approval,Approved,Rejected,Posted;
                                                   OptionString=Open,Pending Approval,Approved,Rejected,Posted }
    { 42  ;   ;Posted              ;Boolean        }
    { 43  ;   ;Posted By           ;Code20        ;TableRelation="User Setup"."User ID" }
    { 44  ;   ;Date Posted         ;Date           }
    { 45  ;   ;Time Posted         ;Time           }
    { 46  ;   ;Cashier             ;Code20        ;TableRelation="User Setup"."User ID" }
    { 47  ;   ;No. Series          ;Code10         }
    { 48  ;   ;Responsibility Center;Code20       ;TableRelation="Responsibility Center".Code }
    { 49  ;   ;Retention Amount    ;Decimal        }
    { 50  ;   ;Retention Amount(LCY);Decimal       }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
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

OBJECT Table 51516007 Imprest Line
{
  OBJECT-PROPERTIES
  {
    Date=09/24/15;
    Time=[ 9:47:49 AM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Line No             ;Integer        }
    { 11  ;   ;Document No         ;Code10        ;TableRelation="Payment Header".No. }
    { 12  ;   ;Document Type       ;Option        ;OptionCaptionML=ENU=Normal,Cash Purchase,Petty Cash,Express;
                                                   OptionString=Normal,Cash Purchase,Petty Cash,Express }
    { 13  ;   ;Currency Code       ;Code10        ;TableRelation=Currency }
    { 14  ;   ;Currency Factor     ;Decimal        }
    { 15  ;   ;Transaction Type    ;Code20        ;TableRelation="Funds Transaction Types"."Transaction Code" }
    { 16  ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=G/L Account,Customer,Vendor,Item;
                                                   OptionString=G/L Account,Customer,Vendor,Item }
    { 17  ;   ;Account No          ;Code20         }
    { 18  ;   ;Account Name        ;Text50         }
    { 19  ;   ;Transaction Type Description;Text50 }
    { 20  ;   ;Payment Description ;Text50         }
    { 21  ;   ;Amount              ;Decimal        }
    { 22  ;   ;Amount(LCY)         ;Decimal        }
    { 23  ;   ;VAT Code            ;Code10         }
    { 24  ;   ;VAT Amount          ;Decimal        }
    { 25  ;   ;VAT Amount(LCY)     ;Decimal        }
    { 26  ;   ;W/TAX Code          ;Code10         }
    { 27  ;   ;W/TAX Amount        ;Decimal        }
    { 28  ;   ;W/TAX Amount(LCY)   ;Decimal        }
    { 29  ;   ;Retention Code      ;Code10         }
    { 30  ;   ;Retention Amount    ;Decimal        }
    { 31  ;   ;Retention Amount(LCY);Decimal       }
    { 32  ;   ;Net Amount          ;Decimal        }
    { 33  ;   ;Net Amount(LCY)     ;Decimal        }
    { 34  ;   ;Committed           ;Boolean        }
    { 35  ;   ;Vote Book           ;Code20         }
    { 36  ;   ;Gen. Bus. Posting Group;Code20      }
    { 37  ;   ;Gen. Prod. Posting Group;Code20     }
    { 38  ;   ;VAT Bus. Posting Group;Code20       }
    { 39  ;   ;VAT Prod. Posting Group;Code20      }
    { 40  ;   ;Global Dimension 1 Code;Code10      }
    { 41  ;   ;Global Dimension 2 Code;Code10      }
    { 42  ;   ;Shortcut Dimension 3 Code;Code10    }
    { 43  ;   ;Shortcut Dimension 4 Code;Code10    }
    { 44  ;   ;Shortcut Dimension 5 Code;Code10    }
    { 45  ;   ;Shortcut Dimension 6 Code;Code10    }
    { 46  ;   ;Shortcut Dimension 7 Code;Code10    }
    { 47  ;   ;Shortcut Dimension 8 Code;Code10    }
    { 48  ;   ;Applies-to Doc. Type;Option        ;CaptionML=ENU=Applies-to Doc. Type;
                                                   OptionCaptionML=ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund";
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 49  ;   ;Applies-to Doc. No. ;Code20        ;OnLookup=VAR
                                                              VendLedgEntry@1102756003 : Record 25;
                                                              PayToVendorNo@1102756001 : Code[20];
                                                              OK@1102756000 : Boolean;
                                                              Text000@1102756004 : TextConst 'ENU=You must specify %1 or %2.';
                                                            BEGIN
                                                            END;

                                                   CaptionML=ENU=Applies-to Doc. No. }
    { 50  ;   ;Applies-to ID       ;Code20        ;OnValidate=VAR
                                                                TempVendLedgEntry@1000 : Record 25;
                                                              BEGIN
                                                              END;

                                                   CaptionML=ENU=Applies-to ID }
  }
  KEYS
  {
    {    ;Line No                                 ;Clustered=Yes }
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

OBJECT Table 51516008 Imprest Accounting Header
{
  OBJECT-PROPERTIES
  {
    Date=08/01/16;
    Time=[ 8:36:32 AM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN


               IF "No." = '' THEN BEGIN
                 GenLedgerSetup.GET;
                 IF "Payment Type"="Payment Type"::Imprest THEN
                   BEGIN
                    GenLedgerSetup.TESTFIELD(GenLedgerSetup."Imprest Nos");
                    NoSeriesMgt.InitSeries(GenLedgerSetup."Imprest Nos",xRec."No. Series",0D,"No.","No. Series");
                   END
               END;

               {
               UserTemplate.RESET;
               UserTemplate.SETRANGE(UserTemplate.UserID,USERID);
               IF UserTemplate.FINDFIRST THEN
                 BEGIN
                   "Paying Bank Account":=UserTemplate."Default Payment Bank";
                   VALIDATE("Paying Bank Account");
                 END;
                  }

               Date:=TODAY;
               Cashier:=USERID;
               VALIDATE(Cashier);

               IF UserSetup.GET(USERID)THEN BEGIN

               UserSetup.TESTFIELD("Staff Travel Account");
               "Account Type":="Account Type"::Customer;
               "Account No.":=UserSetup."Staff Travel Account";
               //VALIDATE("Account No.");
               END ELSE
               ERROR('User must be setup under User Setup and their respective Account Entered');
             END;

    OnModify=BEGIN
               IF Status=Status::Pending THEN
                  UpdateHeaderToLine;

                  { IF (Status=Status::Approved) OR (Status=Status::Posted)OR (Status=Status::"Pending Approval") THEN
                      ERROR('You Cannot Modify this record its status is not Pending');}
             END;

    OnDelete=BEGIN
                   IF (Status=Status::Approved) OR (Status=Status::Posted) OR (Status=Status::"Pending Approval")THEN
                      ERROR('You Cannot Delete this record its status is not Pending');
             END;

    LookupPageID=Page39004030;
    DrillDownPageID=Page39004030;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;NotBlank=No;
                                                   Description=Stores the reference of the payment voucher in the database }
    { 2   ;   ;Date                ;Date          ;OnValidate=BEGIN
                                                                IF ImpLinesExist THEN BEGIN
                                                                ERROR('You first need to delete the existing imprest lines before changing the Currency Code'
                                                                );
                                                                END;

                                                                IF  "Currency Code" = xRec."Currency Code" THEN
                                                                  UpdateCurrencyFactor;

                                                                IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                                                                    UpdateCurrencyFactor;
                                                                    //RecreatePurchLines(FIELDCAPTION("Currency Code"));
                                                                  END ELSE
                                                                    IF "Currency Code" <> '' THEN
                                                                      UpdateCurrencyFactor;

                                                                 UpdateHeaderToLine;
                                                              END;

                                                   Description=Stores the date when the payment voucher was inserted into the system }
    { 3   ;   ;Currency Factor     ;Decimal       ;CaptionML=ENU=Currency Factor;
                                                   DecimalPlaces=0:15;
                                                   MinValue=0;
                                                   Editable=No }
    { 4   ;Yes;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                IF ImpLinesExist THEN BEGIN
                                                                ERROR('You first need to delete the existing imprest lines before changing the Currency Code'
                                                                );
                                                                END;

                                                                IF  "Currency Code" = xRec."Currency Code" THEN
                                                                  UpdateCurrencyFactor;

                                                                IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                                                                    UpdateCurrencyFactor;
                                                                    //RecreatePurchLines(FIELDCAPTION("Currency Code"));
                                                                  END ELSE
                                                                    IF "Currency Code" <> '' THEN
                                                                      UpdateCurrencyFactor;

                                                                 UpdateHeaderToLine;
                                                              END;

                                                   CaptionML=ENU=Currency Code;
                                                   Editable=Yes }
    { 9   ;   ;Payee               ;Text100       ;Description=Stores the name of the person who received the money }
    { 10  ;   ;On Behalf Of        ;Text100       ;Description=Stores the name of the person on whose behalf the payment voucher was taken }
    { 11  ;   ;Cashier             ;Code50        ;Description=Stores the identifier of the cashier in the database }
    { 16  ;   ;Posted              ;Boolean       ;Description=Stores whether the payment voucher is posted or not }
    { 17  ;   ;Date Posted         ;Date          ;Description=Stores the date when the payment voucher was posted }
    { 18  ;   ;Time Posted         ;Time          ;Description=Stores the time when the payment voucher was posted }
    { 19  ;   ;Posted By           ;Code20        ;Description=Stores the name of the person who posted the payment voucher }
    { 20  ;   ;Total Payment Amount;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line".Amount WHERE (No=FIELD(No.)));
                                                   Description=Stores the amount of the payment voucher;
                                                   Editable=No }
    { 28  ;   ;Paying Bank Account ;Code20        ;TableRelation="Bank Account".No. WHERE (Currency Code=FIELD(Currency Code));
                                                   OnValidate=BEGIN
                                                                BankAcc.RESET;
                                                                "Bank Name":='';
                                                                IF BankAcc.GET("Paying Bank Account") THEN
                                                                  BEGIN
                                                                    "Bank Name":=BankAcc.Name;
                                                                   // "Currency Code":=BankAcc."Currency Code";   //Currency Being determined first before document is released for approval
                                                                   // VALIDATE("Currency Code");
                                                                  END;
                                                              END;

                                                   Description=Stores the name of the paying bank account in the database }
    { 30  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                DimVal.RESET;
                                                                DimVal.SETRANGE(DimVal."Global Dimension No.",1);
                                                                DimVal.SETRANGE(DimVal.Code,"Global Dimension 1 Code");
                                                                 IF DimVal.FIND('-') THEN
                                                                    "Function Name":=DimVal.Name;

                                                                UpdateHeaderToLine;
                                                              END;

                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   NotBlank=No;
                                                   Description=Stores the reference to the first global dimension in the database;
                                                   CaptionClass='1,1,1' }
    { 35  ;   ;Status              ;Option        ;OptionString=Pending,1st Approval,2nd Approval,Cheque Printing,Posted,Cancelled,Checking,VoteBook,Pending Approval,Approved;
                                                   Description=Stores the status of the record in the database }
    { 38  ;   ;Payment Type        ;Option        ;OptionString=Imprest }
    { 56  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                DimVal.RESET;
                                                                DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                                                                DimVal.SETRANGE(DimVal.Code,"Shortcut Dimension 2 Code");
                                                                 IF DimVal.FIND('-') THEN
                                                                    "Budget Center Name":=DimVal.Name;

                                                                UpdateHeaderToLine;
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 2 Code;
                                                   NotBlank=No;
                                                   Description=Stores the reference of the second global dimension in the database;
                                                   CaptionClass='1,2,2' }
    { 57  ;   ;Function Name       ;Text100       ;Description=Stores the name of the function in the database }
    { 58  ;   ;Budget Center Name  ;Text100       ;Description=Stores the name of the budget center in the database }
    { 59  ;   ;Bank Name           ;Text100       ;Description=Stores the description of the paying bank account in the database }
    { 60  ;   ;No. Series          ;Code20        ;Description=Stores the number series in the database }
    { 61  ;   ;Select              ;Boolean       ;Description=Enables the user to select a particular record }
    { 62  ;   ;Total VAT Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line"."VAT Amount" WHERE (No=FIELD(No.)));
                                                   Editable=No }
    { 63  ;   ;Total Witholding Tax Amount;Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line".Field27808440 WHERE (No=FIELD(No.)));
                                                   Editable=No }
    { 64  ;   ;Total Net Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Imprest Accounting Lines".Amount WHERE (No=FIELD(No.)));
                                                   Editable=No }
    { 65  ;   ;Current Status      ;Code20        ;Description=Stores the current status of the payment voucher in the database }
    { 66  ;   ;Cheque No.          ;Code20         }
    { 67  ;   ;Pay Mode            ;Option        ;OptionString=[ ,Cash,Cheque,EFT,Letter of Credit,Custom 3,Custom 4,Custom 5] }
    { 68  ;   ;Payment Release Date;Date          ;OnValidate=BEGIN

                                                                  //Changed to ensure Release date is not less than the Date entered
                                                                  IF "Payment Release Date"<Date THEN
                                                                     ERROR('The Payment Release Date cannot be lesser than the Document Date');
                                                              END;
                                                               }
    { 69  ;   ;No. Printed         ;Integer        }
    { 70  ;   ;VAT Base Amount     ;Decimal        }
    { 71  ;   ;Exchange Rate       ;Decimal        }
    { 72  ;   ;Currency Reciprical ;Decimal        }
    { 73  ;   ;Current Source A/C Bal.;Decimal     }
    { 74  ;   ;Cancellation Remarks;Text250        }
    { 75  ;   ;Register Number     ;Integer        }
    { 76  ;   ;From Entry No.      ;Integer        }
    { 77  ;   ;To Entry No.        ;Integer        }
    { 78  ;   ;Invoice Currency Code;Code10       ;TableRelation=Currency;
                                                   CaptionML=ENU=Invoice Currency Code;
                                                   Editable=Yes }
    { 79  ;   ;Total Net Amount LCY;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Imprest Accounting Lines"."Amount LCY" WHERE (No=FIELD(No.)));
                                                   Editable=No }
    { 80  ;   ;Document Type       ;Option        ;OptionString=Payment Voucher,Petty Cash }
    { 81  ;   ;Shortcut Dimension 3 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3));
                                                   OnValidate=BEGIN
                                                                DimVal.RESET;
                                                                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                                                                DimVal.SETRANGE(DimVal.Code,"Shortcut Dimension 3 Code");
                                                                 IF DimVal.FIND('-') THEN
                                                                    Dim3:=DimVal.Name ;

                                                                UpdateHeaderToLine;
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 3 Code;
                                                   Description=Stores the reference of the Third global dimension in the database;
                                                   CaptionClass='1,2,3' }
    { 82  ;   ;Shortcut Dimension 4 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4));
                                                   OnValidate=BEGIN
                                                                DimVal.RESET;
                                                                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                                                                 DimVal.SETRANGE(DimVal.Code,"Shortcut Dimension 4 Code");
                                                                 IF DimVal.FIND('-') THEN
                                                                    Dim4:=DimVal.Name;

                                                                UpdateHeaderToLine;
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 4 Code;
                                                   Description=Stores the reference of the Third global dimension in the database;
                                                   CaptionClass='1,2,4' }
    { 83  ;   ;Dim3                ;Text250        }
    { 84  ;   ;Dim4                ;Text250        }
    { 85  ;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   OnValidate=BEGIN

                                                                TESTFIELD(Status,Status::Pending);
                                                                IF NOT UserMgt.CheckRespCenter(1,"Shortcut Dimension 3 Code") THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    RespCenter.TABLECAPTION,UserMgt.GetPurchasesFilter);
                                                                 {
                                                                "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
                                                                IF "Location Code" = '' THEN BEGIN
                                                                  IF InvtSetup.GET THEN
                                                                    "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
                                                                END ELSE BEGIN
                                                                  IF Location.GET("Location Code") THEN;
                                                                  "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
                                                                END;

                                                                UpdateShipToAddress;
                                                                   }
                                                                   {
                                                                CreateDim(
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DATABASE::Vendor,"Pay-to Vendor No.",
                                                                  DATABASE::"Salesperson/Purchaser","Purchaser Code",
                                                                  DATABASE::Campaign,"Campaign No.");

                                                                IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
                                                                  RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
                                                                  "Assigned User ID" := '';
                                                                END;
                                                                  }
                                                              END;

                                                   CaptionML=ENU=Responsibility Center }
    { 86  ;   ;Account Type        ;Option        ;CaptionML=ENU=Account Type;
                                                   OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner;
                                                   Editable=No }
    { 87  ;   ;Account No.         ;Code20        ;TableRelation=Customer.No. WHERE (Customer Posting Group=FILTER(STAFF|IMPREST));
                                                   OnValidate=BEGIN
                                                                    Cust.RESET;
                                                                    IF Cust.GET("Account No.") THEN BEGIN
                                                                       Cust.TESTFIELD("Gen. Bus. Posting Group");
                                                                       Cust.TESTFIELD(Blocked,Cust.Blocked::" ");
                                                                       Payee:=Cust.Name;
                                                                       "On Behalf Of":=Cust.Name;
                                                                       //"Employee Job Group":=Cust."Employee Job Group";

                                                                    //Check CreditLimit Here In cases where you have a credit limit set for employees
                                                                     Cust.CALCFIELDS(Cust."Balance (LCY)");
                                                                      IF Cust."Balance (LCY)">Cust."Credit Limit (LCY)" THEN BEGIN
                                                                      IF Type=Type::Imprest THEN
                                                                         ERROR('The allowable unaccounted balance of %1 has been exceeded',Cust."Credit Limit (LCY)");

                                                                    END;

                                                                    END;

                                                                      Cust.RESET();
                                                                      Cust.GET("Account No.");
                                                                      //"PF No.":= Cust."Payroll/Staff No";
                                                              END;

                                                   CaptionML=ENU=Account No.;
                                                   Editable=Yes }
    { 88  ;   ;Surrender Status    ;Option        ;OptionString=[ ,Full,Partial] }
    { 89  ;   ;Purpose             ;Text250        }
    { 90  ;   ;Type                ;Option        ;OptionCaptionML=ENU=" ,Imprest,Advance";
                                                   OptionString=[ ,Imprest,Advance] }
    { 91  ;   ;Employee Job Group  ;Code10        ;TableRelation="Employee Statistics Group";
                                                   Editable=No }
    { 92  ;   ;PF No.              ;Code10        ;Description=Stores the Payroll No. of  Staff }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CStatus@1102755004 : Code[20];
      UserTemplate@1102755001 : Record 51516031;
      GLAcc@1102760038 : Record 15;
      Cust@1102760037 : Record 18;
      Vend@1102760036 : Record 23;
      FA@1102760035 : Record 5600;
      BankAcc@1102760034 : Record 270;
      NoSeriesMgt@1102760033 : Codeunit 396;
      GenLedgerSetup@1102760032 : Record 51516030;
      RecPayTypes@1102760031 : Record 51516032;
      CashierLinks@1102760030 : Record 51516052;
      GLAccount@1102760029 : Record 15;
      EntryNo@1102760028 : Integer;
      SingleMonth@1102760026 : Boolean;
      DateFrom@1102760025 : Date;
      DateTo@1102760024 : Date;
      Budget@1102760023 : Decimal;
      CurrMonth@1102760022 : Code[10];
      CurrYR@1102760021 : Code[10];
      BudgDate@1102760020 : Text[30];
      BudgetDate@1102760019 : Date;
      YrBudget@1102760018 : Decimal;
      BudgetDateTo@1102760017 : Date;
      BudgetAvailable@1102760016 : Decimal;
      GenLedSetup@1102760015 : Record 98;
      "Total Budget"@1102760014 : Decimal;
      CommittedAmount@1102760012 : Decimal;
      MonthBudget@1102760011 : Decimal;
      Expenses@1102760010 : Decimal;
      Header@1102760009 : Text[250];
      "Date From"@1102760008 : Text[30];
      "Date To"@1102760007 : Text[30];
      LastDay@1102760006 : Date;
      TotAmt@1102760003 : Decimal;
      DimVal@1102760000 : Record 349;
      RespCenter@1102755006 : Record 5714;
      UserMgt@1102755005 : Codeunit 5700;
      Text001@1102755007 : TextConst 'ENU=Your identification is set up to process from %1 %2 only.';
      Pline@1102755008 : Record 51516009;
      CurrExchRate@1102755002 : Record 330;
      ImpLines@1102756000 : Record 51516009;
      UserSetup@1102756001 : Record 91;

    PROCEDURE UpdateHeaderToLine@1102755000();
    VAR
      PayLine@1102755000 : Record 51516009;
    BEGIN
      PayLine.RESET;
      PayLine.SETRANGE(PayLine.No,"No.");
      IF PayLine.FIND('-') THEN BEGIN
      REPEAT
      PayLine."Imprest Holder":="Account No.";
      PayLine."Global Dimension 1 Code":="Global Dimension 1 Code";
      PayLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
      PayLine."Shortcut Dimension 3 Code":="Shortcut Dimension 3 Code";
      PayLine."Shortcut Dimension 4 Code":="Shortcut Dimension 4 Code";
      PayLine."Currency Code":="Currency Code";
      PayLine."Currency Factor":="Currency Factor";
      PayLine.VALIDATE("Currency Factor");
      PayLine.MODIFY;
      UNTIL PayLine.NEXT=0;
      END;
    END;

    LOCAL PROCEDURE UpdateCurrencyFactor@12();
    VAR
      CurrencyDate@1102755000 : Date;
    BEGIN
      IF "Currency Code" <> '' THEN BEGIN
        CurrencyDate := Date;
        "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
      END ELSE
        "Currency Factor" := 0;
    END;

    PROCEDURE ImpLinesExist@3() : Boolean;
    BEGIN
      ImpLines.RESET;
      ImpLines.SETRANGE(No,"No.");
      EXIT(ImpLines.FINDFIRST);
    END;

    BEGIN
    END.
  }
}

OBJECT Table 51516009 Imprest Accounting Lines
{
  OBJECT-PROPERTIES
  {
    Date=08/01/16;
    Time=[ 8:57:11 AM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               ImprestHeader.RESET;
               ImprestHeader.SETRANGE(ImprestHeader."No.",No);
               IF ImprestHeader.FINDFIRST THEN
                 BEGIN
                   "Date Taken":=ImprestHeader.Date;
                   ImprestHeader.TESTFIELD("Responsibility Center");
                   ImprestHeader.TESTFIELD("Global Dimension 1 Code");
                   ImprestHeader.TESTFIELD("Shortcut Dimension 2 Code");
                   "Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
                   "Shortcut Dimension 2 Code":=ImprestHeader."Shortcut Dimension 2 Code";
                   "Shortcut Dimension 3 Code":=ImprestHeader."Shortcut Dimension 3 Code";
                   "Shortcut Dimension 4 Code":=ImprestHeader."Shortcut Dimension 4 Code";
                   "Currency Factor":=ImprestHeader."Currency Factor";
                   "Currency Code":=ImprestHeader."Currency Code";
                   Purpose:=ImprestHeader.Purpose;
                 END;
             END;

    OnModify=BEGIN
               ImprestHeader.RESET;
               ImprestHeader.SETRANGE(ImprestHeader."No.",No);
               IF ImprestHeader.FINDFIRST THEN
                 BEGIN
                   IF (ImprestHeader.Status=ImprestHeader.Status::Approved) OR
                       (ImprestHeader.Status=ImprestHeader.Status::Posted)OR
                       (ImprestHeader.Status=ImprestHeader.Status::"Pending Approval") THEN
                      //ERROR('You Cannot Modify this record its status is not Pending');

                   "Date Taken":=ImprestHeader.Date;
                   "Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
                   "Shortcut Dimension 2 Code":=ImprestHeader."Shortcut Dimension 2 Code";
                   "Shortcut Dimension 3 Code":=ImprestHeader."Shortcut Dimension 3 Code";
                   "Shortcut Dimension 4 Code":=ImprestHeader."Shortcut Dimension 4 Code";
                   "Currency Factor":=ImprestHeader."Currency Factor";
                   "Currency Code":=ImprestHeader."Currency Code";
                   Purpose:=ImprestHeader.Purpose;

                 END;

                 //TESTFIELD(Committed,FALSE);
             END;

    OnDelete=BEGIN
               ImprestHeader.RESET;
               ImprestHeader.SETRANGE(ImprestHeader."No.",No);
               IF ImprestHeader.FINDFIRST THEN
                 BEGIN
                       IF (ImprestHeader.Status=ImprestHeader.Status::Approved) OR
                       (ImprestHeader.Status=ImprestHeader.Status::Posted)OR
                       (ImprestHeader.Status=ImprestHeader.Status::"Pending Approval") THEN
                      ERROR('You Cannot Delete this record its status is not Pending');
                 END;
                 TESTFIELD(Committed,FALSE);
             END;

  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20        ;OnValidate=BEGIN
                                                                // IF Pay.GET(No) THEN
                                                                // "Imprest Holder":=Pay."Account No.";
                                                              END;

                                                   NotBlank=Yes }
    { 2   ;   ;Account No:         ;Code20        ;TableRelation="G/L Account".No.;
                                                   OnValidate=BEGIN
                                                                IF GLAcc.GET("Account No:") THEN
                                                                 "Account Name":=GLAcc.Name;
                                                                 GLAcc.TESTFIELD("Direct Posting",TRUE);
                                                                 "Budgetary Control A/C":=GLAcc."Budget Controlled";
                                                                 Pay.SETRANGE(Pay."No.",No);
                                                                IF Pay.FINDFIRST THEN BEGIN
                                                                 IF Pay."Account No."<>'' THEN
                                                                "Imprest Holder":=Pay."Account No."
                                                                 ELSE
                                                                  ERROR('Please Enter the Customer/Account Number');
                                                                END;
                                                              END;

                                                   NotBlank=No;
                                                   Editable=No }
    { 3   ;   ;Account Name        ;Text30         }
    { 4   ;   ;Amount              ;Decimal       ;OnValidate=BEGIN

                                                                ImprestHeader.RESET;
                                                                ImprestHeader.SETRANGE(ImprestHeader."No.",No);
                                                                IF ImprestHeader.FINDFIRST THEN
                                                                  BEGIN
                                                                    "Date Taken":=ImprestHeader.Date;
                                                                    ///ImprestHeader.TESTFIELD("Responsibility Center");
                                                                    ImprestHeader.TESTFIELD("Global Dimension 1 Code");
                                                                    ImprestHeader.TESTFIELD("Shortcut Dimension 2 Code");
                                                                    "Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
                                                                    "Shortcut Dimension 2 Code":=ImprestHeader."Shortcut Dimension 2 Code";
                                                                    "Shortcut Dimension 3 Code":=ImprestHeader."Shortcut Dimension 3 Code";
                                                                    "Shortcut Dimension 4 Code":=ImprestHeader."Shortcut Dimension 4 Code";
                                                                    "Currency Factor":=ImprestHeader."Currency Factor";
                                                                    "Currency Code":=ImprestHeader."Currency Code";
                                                                    Purpose:=ImprestHeader.Purpose;

                                                                  END;

                                                                 IF "Currency Factor"<>0 THEN
                                                                   "Amount LCY":=Amount/"Currency Factor"
                                                                  ELSE
                                                                    "Amount LCY":=Amount;
                                                              END;
                                                               }
    { 5   ;   ;Due Date            ;Date           }
    { 6   ;   ;Imprest Holder      ;Code20        ;TableRelation=Customer.No.;
                                                   Editable=Yes }
    { 7   ;   ;Actual Spent        ;Decimal        }
    { 30  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   NotBlank=No;
                                                   Description=Stores the reference to the first global dimension in the database;
                                                   CaptionClass='1,1,1' }
    { 41  ;   ;Apply to            ;Code20         }
    { 42  ;   ;Apply to ID         ;Code20         }
    { 44  ;   ;Surrender Date      ;Date           }
    { 45  ;   ;Surrendered         ;Boolean        }
    { 46  ;   ;M.R. No             ;Code20         }
    { 47  ;   ;Date Issued         ;Date           }
    { 48  ;   ;Type of Surrender   ;Option        ;OptionString=[ ,Cash,Receipt] }
    { 49  ;   ;Dept. Vch. No.      ;Code20         }
    { 50  ;   ;Cash Surrender Amt  ;Decimal        }
    { 51  ;   ;Bank/Petty Cash     ;Code20        ;TableRelation="Bank Account" }
    { 52  ;   ;Surrender Doc No.   ;Code20         }
    { 53  ;   ;Date Taken          ;Date           }
    { 54  ;   ;Purpose             ;Text250        }
    { 56  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=ENU=Shortcut Dimension 2 Code;
                                                   NotBlank=No;
                                                   Description=Stores the reference of the second global dimension in the database;
                                                   CaptionClass='1,2,2' }
    { 79  ;   ;Budgetary Control A/C;Boolean       }
    { 81  ;   ;Shortcut Dimension 3 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3));
                                                   CaptionML=ENU=Shortcut Dimension 3 Code;
                                                   Description=Stores the reference of the Third global dimension in the database;
                                                   CaptionClass='1,2,3' }
    { 82  ;   ;Shortcut Dimension 4 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4));
                                                   CaptionML=ENU=Shortcut Dimension 4 Code;
                                                   Description=Stores the reference of the fourth global dimension in the database;
                                                   CaptionClass='1,2,4' }
    { 83  ;   ;Committed           ;Boolean        }
    { 84  ;   ;Advance Type        ;Code20        ;TableRelation="Funds Transaction Types" WHERE (Transaction Type=CONST(Imprest));
                                                   OnValidate=BEGIN

                                                                ImprestHeader.RESET;
                                                                ImprestHeader.SETRANGE(ImprestHeader."No.",No);
                                                                IF ImprestHeader.FINDFIRST THEN
                                                                  BEGIN
                                                                        IF (ImprestHeader.Status=ImprestHeader.Status::Approved) OR
                                                                        (ImprestHeader.Status=ImprestHeader.Status::Posted)OR
                                                                        (ImprestHeader.Status=ImprestHeader.Status::"Pending Approval") THEN
                                                                       ERROR('You Cannot Insert a new record when the status of the document is not Pending');
                                                                  END;

                                                                     RecPay.RESET;
                                                                    RecPay.SETRANGE(RecPay."Transaction Code","Advance Type");
                                                                    RecPay.SETRANGE(RecPay."Transaction Type",RecPay."Transaction Type"::Imprest);
                                                                    IF RecPay.FIND('-') THEN BEGIN
                                                                      "Account No:":=RecPay."Account No";
                                                                      VALIDATE("Account No:");
                                                                      //Copy the Based on Rate boolean
                                                                        //"Based on Rates":=RecPay."Based On Travel Rates Table";

                                                                    END;
                                                              END;
                                                               }
    { 85  ;   ;Currency Factor     ;Decimal       ;OnValidate=BEGIN
                                                                 IF "Currency Factor"<>0 THEN
                                                                   "Amount LCY":=Amount/"Currency Factor"
                                                                  ELSE
                                                                    "Amount LCY":=Amount;
                                                              END;

                                                   CaptionML=ENU=Currency Factor;
                                                   DecimalPlaces=0:15;
                                                   MinValue=0;
                                                   Editable=No }
    { 86  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=ENU=Currency Code;
                                                   Editable=Yes }
    { 87  ;   ;Amount LCY          ;Decimal        }
    { 88  ;   ;Line No.            ;Integer       ;AutoIncrement=Yes }
    { 90  ;   ;Employee Job Group  ;Code10        ;TableRelation="Employee Statistics Group";
                                                   Editable=No }
    { 91  ;   ;Daily Rate(Amount)  ;Decimal        }
    { 92  ;   ;No. of Days         ;Decimal       ;OnValidate=VAR
                                                                Text003@1102755000 : TextConst 'ENU=The Advance type for this line is not based on predefined rates';
                                                              BEGIN
                                                                 IF "Based on Rates" THEN BEGIN
                                                                  Amount:="Daily Rate(Amount)"*"No. of Days";
                                                                  VALIDATE(Amount);
                                                                 END ELSE
                                                                     ERROR(Text003);
                                                              END;
                                                               }
    { 93  ;   ;Destination Code    ;Code10        ;OnValidate=VAR
                                                                Text001@1102755001 : TextConst 'ENU=The Zero Daily rate for this advance type';
                                                                Text002@1102755000 : TextConst 'ENU=The Combination of Travel Rate Setup has not been defined';
                                                              BEGIN
                                                                GLSetup.GET();Curr_Code:='';
                                                                ImprestHeader.RESET;
                                                                ImprestHeader.SETRANGE(ImprestHeader."No.",No);
                                                                IF ImprestHeader.FINDFIRST THEN
                                                                  BEGIN
                                                                       IF ImprestHeader."Currency Code"='' THEN
                                                                           Curr_Code:=GLSetup."LCY Code"
                                                                         ELSE
                                                                               Curr_Code:=ImprestHeader."Currency Code";

                                                                  END;

                                                                    RecPay.RESET;
                                                                    RecPay.SETRANGE(RecPay."Transaction Code","Advance Type");
                                                                    RecPay.SETRANGE(RecPay."Transaction Type",RecPay."Transaction Type"::Imprest);
                                                                    {IF RecPay.FIND('-') THEN BEGIN
                                                                        {IF NOT RecPay."Based On Travel Rates Table" THEN
                                                                           ERROR('Advance Type %1 is not based on Travel Rates Table',"Advance Type");
                                                                           }
                                                                      IF RecPay."Based On Travel Rates Table" THEN BEGIN
                                                                         DestinationRateSetup.RESET;
                                                                         DestinationRateSetup.SETRANGE(DestinationRateSetup."Advance Code","Advance Type");
                                                                         DestinationRateSetup.SETRANGE(DestinationRateSetup."Employee Job Group",ImprestHeader."Employee Job Group");
                                                                         DestinationRateSetup.SETRANGE(DestinationRateSetup.Currency,Curr_Code);
                                                                         DestinationRateSetup.SETRANGE(DestinationRateSetup."Destination Code","Destination Code");
                                                                          IF  DestinationRateSetup.FIND('-') THEN BEGIN
                                                                            IF DestinationRateSetup."Daily Rate (Amount)" <>0 THEN
                                                                               "Daily Rate(Amount)":=DestinationRateSetup."Daily Rate (Amount)"
                                                                              ELSE
                                                                                ERROR(Text001); //If Daily Rate is Zero
                                                                          END ELSE
                                                                             ERROR(Text002);  //If no combination of Rates and parameters set throw error

                                                                      END;

                                                                    END;}
                                                              END;
                                                               }
    { 94  ;   ;Based on Rates      ;Boolean        }
  }
  KEYS
  {
    {    ;Line No.,No                             ;SumIndexFields=Amount,Amount LCY;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      GLAcc@1102755006 : Record 15;
      Pay@1102755005 : Record 51516008;
      ImprestHeader@1102755004 : Record 51516008;
      RecPay@1102755003 : Record 51516032;
      Curr_Code@1102755002 : Code[20];
      GLSetup@1102755001 : Record 98;
      DestinationRateSetup@1102755000 : Record 51516035;

    BEGIN
    END.
  }
}

OBJECT Table 51516010 Funds Claims Header
{
  OBJECT-PROPERTIES
  {
    Date=08/14/15;
    Time=12:09:15 PM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;No.                 ;Code10         }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
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

OBJECT Table 51516011 Funds Claims Line
{
  OBJECT-PROPERTIES
  {
    Date=08/14/15;
    Time=12:10:01 PM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Line No             ;Integer        }
    { 11  ;   ;Document No         ;Code10         }
  }
  KEYS
  {
    {    ;Line No                                 ;Clustered=Yes }
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

OBJECT Table 51516012 buffer1
{
  OBJECT-PROPERTIES
  {
    Date=07/15/16;
    Time=11:01:20 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code30         }
    { 2   ;   ;Details             ;Decimal        }
    { 3   ;   ;Fosa                ;Code60         }
    { 4   ;   ;Detail1             ;Text30         }
    { 5   ;   ;Detail2             ;Text30         }
    { 6   ;   ;Details3            ;Text30         }
  }
  KEYS
  {
    {    ;No,Fosa                                 ;Clustered=Yes }
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

OBJECT Table 51516013 Checkoff Ctrl
{
  OBJECT-PROPERTIES
  {
    Date=11/17/16;
    Time=[ 2:27:01 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan No             ;Code20         }
  }
  KEYS
  {
    {    ;Loan No                                 ;Clustered=Yes }
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

OBJECT Table 51516014 Advice Months
{
  OBJECT-PROPERTIES
  {
    Date=11/15/17;
    Time=[ 9:43:24 AM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Advice Month        ;Code10         }
    { 2   ;   ;Advice Month Description;Code50     }
  }
  KEYS
  {
    {    ;Advice Month                            ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Advice Month Description,Advice Month    }
  }
  CODE
  {

    BEGIN
    END.
  }
}

OBJECT Table 51516015 Fixed Deposit
{
  OBJECT-PROPERTIES
  {
    Date=05/16/22;
    Time=[ 5:02:23 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnInsert=BEGIN

               IF "FD No" = '' THEN BEGIN
                 PurchSetup.GET;
                 PurchSetup.TESTFIELD(PurchSetup.FixedDposit);
                 NoSeriesMgt.InitSeries(PurchSetup.FixedDposit,xRec."No. Series",0D,"FD No","No. Series");
               END;


               "Creted by":=USERID;
               Date:=TODAY;
             END;

    OnDelete=BEGIN
               ERROR('You are not authorised to delete this transaction.');
             END;

  }
  FIELDS
  {
    { 1   ;   ;FD No               ;Code30         }
    { 2   ;   ;Account No          ;Code30        ;TableRelation=Vendor.No. WHERE (Account Type=CONST(ORDINARY));
                                                   OnValidate=BEGIN
                                                                IF Vend.GET("Account No") THEN
                                                                "Account Name":=Vend.Name;
                                                                "ID NO":=Vend."ID No.";
                                                                "Staff Number":=Vend."Staff No";
                                                              END;
                                                               }
    { 3   ;   ;Account Name        ;Text30         }
    { 4   ;   ;Fd Duration         ;Code10        ;TableRelation="Fixed Deposit Type".Code }
    { 6   ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                IF FDType.GET("Fd Duration") THEN
                                                                    months:=FDType."No. of Months";


                                                                IF Vend.GET("Account No") THEN
                                                                  Vend.CALCFIELDS(Vend.Balance);
                                                                Vend.Balance:=Vend.Balance-1000;
                                                                 IF Amount>Vend.Balance THEN
                                                                 ERROR('Your Savings are not sufficient for this activity');

                                                                IF "Fd Duration"='3M' THEN BEGIN
                                                                IF (Amount>20000) AND (Amount<300000) THEN
                                                                InterestRate:=5
                                                                ELSE IF (Amount>299999) AND (Amount<600000) THEN
                                                                InterestRate:=6.5
                                                                ELSE IF (Amount>599999) AND (Amount<1000000) THEN
                                                                InterestRate:=7.5
                                                                ELSE IF (Amount>999999) AND (Amount<3000000) THEN
                                                                InterestRate:=8
                                                                ELSE IF (Amount>2999999) AND (Amount<5000000) THEN
                                                                InterestRate:=9
                                                                ELSE IF (Amount>4999999) AND (Amount<10000000) THEN
                                                                InterestRate:=10
                                                                ELSE IF (Amount>9999999) THEN
                                                                InterestRate:=11
                                                                END;

                                                                IF "Fd Duration"='6M' THEN BEGIN
                                                                IF (Amount>20000) AND (Amount<300000) THEN
                                                                InterestRate:=5
                                                                ELSE IF (Amount>299999) AND (Amount<600000) THEN
                                                                InterestRate:=6.5
                                                                ELSE IF (Amount>599999) AND (Amount<1000000) THEN
                                                                InterestRate:=7.5
                                                                ELSE IF (Amount>999999) AND (Amount<3000000) THEN
                                                                InterestRate:=8
                                                                ELSE IF (Amount>2999999) AND (Amount<5000000) THEN
                                                                InterestRate:=9
                                                                ELSE IF (Amount>4999999) AND (Amount<10000000) THEN
                                                                InterestRate:=10
                                                                ELSE IF (Amount>9999999) THEN
                                                                InterestRate:=11
                                                                END;


                                                                IF "Fd Duration"='12M' THEN BEGIN
                                                                IF (Amount>20000) AND (Amount<300000) THEN
                                                                InterestRate:=7.5
                                                                ELSE IF (Amount>299999) AND (Amount<600000) THEN
                                                                InterestRate:=8
                                                                ELSE IF (Amount>599999) AND (Amount<1000000) THEN
                                                                InterestRate:=8.5
                                                                ELSE IF (Amount>999999) AND (Amount<3000000) THEN
                                                                InterestRate:=9
                                                                ELSE IF (Amount>2999999) AND (Amount<5000000) THEN
                                                                InterestRate:=10
                                                                ELSE IF (Amount>4999999) AND (Amount<10000000) THEN
                                                                InterestRate:=11
                                                                ELSE IF (Amount>9999999) THEN
                                                                InterestRate:=12
                                                                END;
                                                                InterestMonthly:=0;
                                                                InterestP:=0;
                                                                InterestMonthly:=((InterestRate/12));
                                                                InterestP:=ROUND((InterestMonthly/100),0.0001,'=');
                                                                //MESSAGE('Interest Monthly %1 Interest100%2',InterestMonthly,InterestP);
                                                                "Interest Earned":=Amount*InterestP*months;
                                                                "Amount After maturity":=Amount+"Interest Earned";
                                                                MaturityDate:=CALCDATE(FORMAT(months)+'M',TODAY);
                                                              END;
                                                               }
    { 7   ;   ;InterestRate        ;Decimal       ;Editable=No }
    { 8   ;   ;Creted by           ;Text30         }
    { 9   ;   ;No. Series          ;Code10         }
    { 10  ;   ;Amount After maturity;Decimal       }
    { 11  ;   ;Date                ;Date          ;OnValidate=BEGIN
                                                                Date:=TODAY;
                                                              END;
                                                               }
    { 12  ;   ;MaturityDate        ;Date          ;OnValidate=BEGIN
                                                                IF MaturityDate=TODAY THEN BEGIN
                                                                  matured:=TRUE;
                                                                  MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 13  ;   ;Posted              ;Boolean        }
    { 14  ;   ;matured             ;Boolean        }
    { 15  ;   ;Credited            ;Boolean        }
    { 16  ;   ;ID NO               ;Code20         }
    { 17  ;   ;Posted Date         ;Date           }
    { 18  ;   ;posted time         ;Time           }
    { 19  ;   ;Posted By           ;Code30         }
    { 20  ;   ;Withholding Tax     ;Decimal        }
    { 21  ;   ;interestLessTax     ;Decimal        }
    { 22  ;   ;Revoked             ;Boolean        }
    { 23  ;   ;Revoked Date        ;Date           }
    { 24  ;   ;Revoked Time        ;Time           }
    { 25  ;   ;Revoked By          ;Code60         }
    { 26  ;   ;Interest Earned     ;Decimal        }
    { 27  ;   ;Fixed               ;Boolean       ;Editable=No }
    { 28  ;   ;Fixed Date          ;Date          ;Editable=No }
    { 29  ;   ;Fixed By            ;Code60        ;Editable=No }
    { 30  ;   ;Duration            ;Integer        }
    { 31  ;   ;Staff Number        ;Code20         }
  }
  KEYS
  {
    {    ;FD No                                   ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      PurchSetup@1120054022 : Record 51516258;
      CommentLine@1120054021 : Record 97;
      PurchOrderLine@1120054020 : Record 39;
      PostCode@1120054019 : Record 225;
      VendBankAcc@1120054018 : Record 288;
      OrderAddr@1120054017 : Record 224;
      GenBusPostingGrp@1120054016 : Record 250;
      ItemCrossReference@1120054015 : Record 5717;
      RMSetup@1120054014 : Record 5079;
      ServiceItem@1120054013 : Record 5940;
      NoSeriesMgt@1120054012 : Codeunit 396;
      MoveEntries@1120054011 : Codeunit 361;
      UpdateContFromVend@1120054010 : Codeunit 5057;
      DimMgt@1120054009 : Codeunit 408;
      InsertFromContact@1120054008 : Boolean;
      AccountTypes@1120054007 : Record 51516295;
      UsersID@1120054006 : Record 2000000120;
      FDType@1120054005 : Record 51516305;
      Cust@1120054004 : Record 51516223;
      NOKBOSA@1120054003 : Record 51516225;
      NOKApp@1120054002 : Record 51516291;
      GenSetUp@1120054001 : Record 51516257;
      VendorFDR@1120054000 : Record 23;
      months@1120054023 : Integer;
      FDInterestCriter@1120054024 : Record 51516306;
      fd@1120054025 : Record 51516015;
      Vend@1120054026 : Record 23;
      InterestMonthly@1120054027 : Decimal;
      InterestP@1120054028 : Decimal;

    BEGIN
    END.
  }
}

OBJECT Table 51516016 Staff Claims Header
{
  OBJECT-PROPERTIES
  {
    Date=02/18/20;
    Time=11:58:32 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  GenLedgerSetup.GET;
                                                                  NoSeriesMgt.TestManual(GenLedgerSetup."Claim Nos");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   Description=Stores the reference of the payment voucher in the database;
                                                   Editable=No }
    { 2   ;   ;Date                ;Date          ;OnValidate=BEGIN
                                                                IF ImpLinesExist THEN BEGIN
                                                                ERROR('You first need to delete the existing imprest lines before changing the Currency Code'
                                                                );
                                                                END;

                                                                IF  "Currency Code" = xRec."Currency Code" THEN
                                                                  UpdateCurrencyFactor;

                                                                IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                                                                    UpdateCurrencyFactor;
                                                                    //RecreatePurchLines(FIELDCAPTION("Currency Code"));
                                                                  END ELSE
                                                                    IF "Currency Code" <> '' THEN
                                                                      UpdateCurrencyFactor;

                                                                 UpdateHeaderToLine;
                                                              END;

                                                   Description=Stores the date when the payment voucher was inserted into the system }
    { 3   ;   ;Currency Factor     ;Decimal       ;CaptionML=ENU=Currency Factor;
                                                   DecimalPlaces=0:15;
                                                   Editable=No;
                                                   MinValue=0 }
    { 4   ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                IF ImpLinesExist THEN BEGIN
                                                                ERROR('You first need to delete the existing imprest lines before changing the Currency Code'
                                                                );
                                                                END;

                                                                IF  "Currency Code" = xRec."Currency Code" THEN
                                                                  UpdateCurrencyFactor;

                                                                IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                                                                    UpdateCurrencyFactor;
                                                                    //RecreatePurchLines(FIELDCAPTION("Currency Code"));
                                                                  END ELSE
                                                                    IF "Currency Code" <> '' THEN
                                                                      UpdateCurrencyFactor;

                                                                 UpdateHeaderToLine;
                                                              END;

                                                   CaptionML=ENU=Currency Code;
                                                   Editable=Yes }
    { 9   ;   ;Payee               ;Text100       ;Description=Stores the name of the person who received the money }
    { 10  ;   ;On Behalf Of        ;Text100       ;Description=Stores the name of the person on whose behalf the payment voucher was taken }
    { 11  ;   ;Cashier             ;Code50        ;Description=Stores the identifier of the cashier in the database }
    { 16  ;   ;Posted              ;Boolean       ;Description=Stores whether the payment voucher is posted or not }
    { 17  ;   ;Date Posted         ;Date          ;Description=Stores the date when the payment voucher was posted }
    { 18  ;   ;Time Posted         ;Time          ;Description=Stores the time when the payment voucher was posted }
    { 19  ;   ;Posted By           ;Code50        ;Description=Stores the name of the person who posted the payment voucher }
    { 20  ;   ;Total Payment Amount;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line.".Amount WHERE (No=FIELD(No.)));
                                                   Description=Stores the amount of the payment voucher;
                                                   Editable=No }
    { 28  ;   ;Paying Bank Account ;Code20        ;TableRelation="Bank Account".No. WHERE (Currency Code=FIELD(Currency Code));
                                                   OnValidate=BEGIN
                                                                BankAcc.RESET;
                                                                "Bank Name":='';
                                                                IF BankAcc.GET("Paying Bank Account") THEN
                                                                  BEGIN
                                                                    "Bank Name":=BankAcc.Name;
                                                                   // "Currency Code":=BankAcc."Currency Code";   //Currency Being determined first before document is released for approval
                                                                   // VALIDATE("Currency Code");
                                                                  END;
                                                              END;

                                                   Description=Stores the name of the paying bank account in the database }
    { 30  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1),Dimension Value Type=CONST(Standard));
                                                   OnValidate=BEGIN
                                                                DimVal.RESET;
                                                                DimVal.SETRANGE(DimVal."Global Dimension No.",1);
                                                                DimVal.SETRANGE(DimVal.Code,"Global Dimension 1 Code");
                                                                 IF DimVal.FIND('-') THEN
                                                                    "Function Name":=DimVal.Name;

                                                                UpdateHeaderToLine;
                                                                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                                                              END;

                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   NotBlank=No;
                                                   Description=Stores the reference to the first global dimension in the database;
                                                   CaptionClass='1,1,1' }
    { 35  ;   ;Status              ;Option        ;OptionString=Pending,1st Approval,2nd Approval,Cheque Printing,Posted,Cancelled,Checking,VoteBook,Pending Approval,Approved;
                                                   Description=Stores the status of the record in the database }
    { 38  ;   ;Payment Type        ;Option        ;OptionString=Imprest }
    { 56  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2),Dimension Value Type=CONST(Standard));
                                                   OnValidate=BEGIN
                                                                DimVal.RESET;
                                                                DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                                                                DimVal.SETRANGE(DimVal.Code,"Shortcut Dimension 2 Code");
                                                                 IF DimVal.FIND('-') THEN
                                                                    "Budget Center Name":=DimVal.Name;

                                                                UpdateHeaderToLine;
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 2 Code;
                                                   NotBlank=No;
                                                   Description=Stores the reference of the second global dimension in the database;
                                                   CaptionClass='1,2,2' }
    { 57  ;   ;Function Name       ;Text100       ;Description=Stores the name of the function in the database }
    { 58  ;   ;Budget Center Name  ;Text100       ;Description=Stores the name of the budget center in the database }
    { 59  ;   ;Bank Name           ;Text100       ;Description=Stores the description of the paying bank account in the database }
    { 60  ;   ;No. Series          ;Code20        ;Description=Stores the number series in the database }
    { 61  ;   ;Select              ;Boolean       ;Description=Enables the user to select a particular record }
    { 62  ;   ;Total VAT Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line."."VAT Amount" WHERE (No=FIELD(No.)));
                                                   Editable=No }
    { 63  ;   ;Total Witholding Tax Amount;Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line."."Withholding Tax Amount" WHERE (No=FIELD(No.)));
                                                   Editable=No }
    { 64  ;   ;Total Net Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Staff Claim Lines".Amount WHERE (No=FIELD(No.)));
                                                   Editable=No }
    { 65  ;   ;Current Status      ;Code20        ;Description=Stores the current status of the payment voucher in the database }
    { 66  ;   ;Cheque No.          ;Code20         }
    { 67  ;   ;Pay Mode            ;Option        ;OptionString=[ ,Cash,Cheque,EFT,Letter of Credit,Custom 3,Custom 4,Custom 5] }
    { 68  ;   ;Payment Release Date;Date          ;OnValidate=BEGIN

                                                                  //Changed to ensure Release date is not less than the Date entered
                                                                  IF "Payment Release Date"<Date THEN
                                                                     ERROR('The Payment Release Date cannot be lesser than the Document Date');
                                                              END;
                                                               }
    { 69  ;   ;No. Printed         ;Integer        }
    { 70  ;   ;VAT Base Amount     ;Decimal        }
    { 71  ;   ;Exchange Rate       ;Decimal        }
    { 72  ;   ;Currency Reciprical ;Decimal        }
    { 73  ;   ;Current Source A/C Bal.;Decimal     }
    { 74  ;   ;Cancellation Remarks;Text250        }
    { 75  ;   ;Register Number     ;Integer        }
    { 76  ;   ;From Entry No.      ;Integer        }
    { 77  ;   ;To Entry No.        ;Integer        }
    { 78  ;   ;Invoice Currency Code;Code10       ;TableRelation=Currency;
                                                   CaptionML=ENU=Invoice Currency Code;
                                                   Editable=Yes }
    { 79  ;   ;Total Net Amount LCY;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Staff Claim Lines"."Amount LCY" WHERE (No=FIELD(No.)));
                                                   Editable=No }
    { 80  ;   ;Document Type       ;Option        ;OptionString=Payment Voucher,Petty Cash }
    { 81  ;   ;Shortcut Dimension 3 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3));
                                                   OnValidate=BEGIN
                                                                DimVal.RESET;
                                                                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                                                                DimVal.SETRANGE(DimVal.Code,"Shortcut Dimension 3 Code");
                                                                 IF DimVal.FIND('-') THEN
                                                                    Dim3:=DimVal.Name ;

                                                                UpdateHeaderToLine;
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 3 Code;
                                                   Description=Stores the reference of the Third global dimension in the database;
                                                   CaptionClass='1,2,3' }
    { 82  ;   ;Shortcut Dimension 4 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4));
                                                   OnValidate=BEGIN
                                                                DimVal.RESET;
                                                                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                                                                DimVal.SETRANGE(DimVal.Code,"Shortcut Dimension 4 Code");
                                                                 IF DimVal.FIND('-') THEN
                                                                    Dim4:=DimVal.Name;

                                                                UpdateHeaderToLine;
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 4 Code;
                                                   Description=Stores the reference of the Third global dimension in the database;
                                                   CaptionClass='1,2,4' }
    { 83  ;   ;Dim3                ;Text250        }
    { 84  ;   ;Dim4                ;Text250        }
    { 85  ;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   OnValidate=BEGIN

                                                                TESTFIELD(Status,Status::Pending);
                                                                IF NOT UserMgt.CheckRespCenter(1,"Shortcut Dimension 3 Code") THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    RespCenter.TABLECAPTION,UserMgt.GetPurchasesFilter);
                                                                 {
                                                                "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
                                                                IF "Location Code" = '' THEN BEGIN
                                                                  IF InvtSetup.GET THEN
                                                                    "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
                                                                END ELSE BEGIN
                                                                  IF Location.GET("Location Code") THEN;
                                                                  "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
                                                                END;

                                                                UpdateShipToAddress;
                                                                   }
                                                                   {
                                                                CreateDim(
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DATABASE::Vendor,"Pay-to Vendor No.",
                                                                  DATABASE::"Salesperson/Purchaser","Purchaser Code",
                                                                  DATABASE::Campaign,"Campaign No.");

                                                                IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
                                                                  RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
                                                                  "Assigned User ID" := '';
                                                                END;
                                                                  }
                                                              END;

                                                   CaptionML=ENU=Responsibility Center }
    { 86  ;   ;Account Type        ;Option        ;CaptionML=ENU=Account Type;
                                                   OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner;
                                                   Editable=No }
    { 87  ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type=CONST(Customer)) Customer;
                                                   OnValidate=BEGIN
                                                                    Cust.RESET;
                                                                    IF Cust.GET("Account No.") THEN BEGIN
                                                                       Cust.TESTFIELD("Gen. Bus. Posting Group");
                                                                       Cust.TESTFIELD(Blocked,Cust.Blocked::" ");
                                                                       Payee:=Cust.Name;
                                                                       "On Behalf Of":=Cust.Name;
                                                                {
                                                                    //Check CreditLimit Here In cases where you have a credit limit set for employees
                                                                     Cust.CALCFIELDS(Cust."Balance (LCY)");
                                                                      IF Cust."Balance (LCY)">Cust."Credit Limit (LCY)" THEN
                                                                         ERROR('The allowable unaccounted balance of %1 has been exceeded',Cust."Credit Limit (LCY)");
                                                                 }
                                                                    END;
                                                              END;

                                                   CaptionML=ENU=Account No.;
                                                   Editable=Yes }
    { 88  ;   ;Surrender Status    ;Option        ;OptionString=[ ,Full,Partial] }
    { 89  ;   ;Purpose             ;Text50         }
    { 90  ;   ;External Document No;Code20         }
    { 91  ;   ;RecordId            ;RecordID       }
    { 92  ;   ;Creation Doc No     ;Code20         }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation=;
                                                   OnLookup=BEGIN
                                                              //ShowDimensions
                                                            END;

                                                   CaptionML=ENU=Dimension Set ID;
                                                   Editable=No }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CStatus@1120054043 : Code[20];
      PVUsers@1120054042 : Record 51516039;
      UserTemplate@1120054041 : Record 51516035;
      GLAcc@1120054040 : Record 15;
      Cust@1120054039 : Record 18;
      Vend@1120054038 : Record 23;
      FA@1120054037 : Record 5600;
      BankAcc@1120054036 : Record 270;
      NoSeriesMgt@1120054035 : Codeunit 396;
      GenLedgerSetup@1120054034 : Record 51516030;
      RecPayTypes@1120054033 : Record 51516004;
      CashierLinks@1120054032 : Record 51516047;
      GLAccount@1120054031 : Record 15;
      EntryNo@1120054030 : Integer;
      SingleMonth@1120054029 : Boolean;
      DateFrom@1120054028 : Date;
      DateTo@1120054027 : Date;
      Budget@1120054026 : Decimal;
      CurrMonth@1120054025 : Code[10];
      CurrYR@1120054024 : Code[10];
      BudgDate@1120054023 : Text[30];
      BudgetDate@1120054022 : Date;
      YrBudget@1120054021 : Decimal;
      BudgetDateTo@1120054020 : Date;
      BudgetAvailable@1120054019 : Decimal;
      GenLedSetup@1120054018 : Record 98;
      "Total Budget"@1120054017 : Decimal;
      CommittedAmount@1120054016 : Decimal;
      MonthBudget@1120054015 : Decimal;
      Expenses@1120054014 : Decimal;
      Header@1120054013 : Text[250];
      "Date From"@1120054012 : Text[30];
      "Date To"@1120054011 : Text[30];
      LastDay@1120054010 : Date;
      TotAmt@1120054009 : Decimal;
      DimVal@1120054008 : Record 349;
      PVSteps@1120054007 : Record 51516058;
      RespCenter@1120054006 : Record 51516045;
      UserMgt@1120054005 : Codeunit 51516155;
      Pline@1120054004 : Record 51516007;
      CurrExchRate@1120054003 : Record 330;
      ImpLines@1120054002 : Record 51516007;
      UserSetup@1120054001 : Record 91;
      DimMgt@1120054000 : Codeunit 408;

    BEGIN
    END.
  }
}

OBJECT Table 51516017 Suppliers
{
  OBJECT-PROPERTIES
  {
    Date=12/13/18;
    Time=[ 9:52:14 AM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    LookupPageID=Page51516063;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code40        ;AltSearchField=Search Name;
                                                   OnValidate=BEGIN

                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  PurchSetup.GET;
                                                                  NoSeriesMgt.TestManual(PurchSetup."Vendor Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                                IF "Invoice Disc. Code" = '' THEN
                                                                  "Invoice Disc. Code" := "No.";

                                                              END;

                                                   CaptionML=[ENU=No.;
                                                              ESM=N ;
                                                              FRC=N ;
                                                              ENC=No.] }
    { 2   ;   ;Name                ;Text40        ;OnValidate=BEGIN
                                                                IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
                                                                  "Search Name" := Name;
                                                              END;

                                                   CaptionML=[ENU=Name;
                                                              ESM=Nombre;
                                                              FRC=Nom;
                                                              ENC=Name] }
    { 3   ;   ;Search Name         ;Code50        ;CaptionML=[ENU=Search Name;
                                                              ESM=Alias;
                                                              FRC=Rechercher un nom;
                                                              ENC=Search Name] }
    { 4   ;   ;Name 2              ;Text45        ;CaptionML=[ENU=Name 2;
                                                              ESM=Nombre 2;
                                                              FRC=Nom 2;
                                                              ENC=Name 2] }
    { 5   ;   ;Address             ;Text50        ;CaptionML=[ENU=Address;
                                                              ESM=Direcci n;
                                                              FRC=Adresse;
                                                              ENC=Address] }
    { 6   ;   ;Address 2           ;Text45        ;CaptionML=[ENU=Address 2;
                                                              ESM=Colonia;
                                                              FRC=Adresse 2;
                                                              ENC=Address 2] }
    { 7   ;   ;City                ;Text31        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[ENU=City;
                                                              ESM=Municipio/Ciudad;
                                                              FRC=Ville;
                                                              ENC=City] }
    { 8   ;   ;Contact             ;Text50        ;OnValidate=BEGIN
                                                                {
                                                                IF RMSetup.GET THEN
                                                                  IF RMSetup."Bus. Rel. Code for Vendors" <> '' THEN
                                                                    IF (xRec.Contact = '') AND (xRec."Primary Contact No." = '') THEN BEGIN
                                                                      MODIFY;
                                                                      UpdateContFromVend.OnModify(Rec);
                                                                      UpdateContFromVend.InsertNewContactPerson(Rec,FALSE);
                                                                      MODIFY(TRUE);
                                                                    END
                                                                    }
                                                              END;

                                                   CaptionML=[ENU=Contact;
                                                              ESM=Contacto;
                                                              FRC="Contact  ";
                                                              ENC=Contact] }
    { 9   ;   ;Phone No.           ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[ENU=Phone No.;
                                                              ESM=N  tel fono;
                                                              FRC=N  t l phone;
                                                              ENC=Phone No.] }
    { 10  ;   ;Telex No.           ;Text20        ;CaptionML=[ENU=Telex No.;
                                                              ESM=N  t lex;
                                                              FRC=N  t lex;
                                                              ENC=Telex No.];
                                                   Description=s }
    { 14  ;   ;Our Account No.     ;Text22        ;CaptionML=[ENU=Our Account No.;
                                                              ESM=Ntro. n  cuenta;
                                                              FRC=Notre n  compte;
                                                              ENC=Our Account No.] }
    { 15  ;   ;Territory Code      ;Code10        ;TableRelation=Territory;
                                                   CaptionML=[ENU=Territory Code;
                                                              ESM=C d. territorio;
                                                              FRC=Code de territoire;
                                                              ENC=Territory Code] }
    { 16  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                //ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                                                              END;

                                                   CaptionML=[ENU=Global Dimension 1 Code;
                                                              ESM=C d. dimensi n global 1;
                                                              FRC=Code de dimension principal 1;
                                                              ENC=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 17  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                //ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                                                              END;

                                                   CaptionML=[ENU=Global Dimension 2 Code;
                                                              ESM=C d. dimensi n global 2;
                                                              FRC=Code de dimension principal 2;
                                                              ENC=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 19  ;   ;Budgeted Amount     ;Integer       ;CaptionML=[ENU=Budgeted Amount;
                                                              ESM=Importe pptdo.;
                                                              FRC=Montant budg t ;
                                                              ENC=Budgeted Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 21  ;   ;Vendor Posting Group;Code11        ;TableRelation="Vendor Posting Group";
                                                   CaptionML=[ENU=Vendor Posting Group;
                                                              ESM=Grupo contable proveedor;
                                                              FRC=Param tre report fournisseur;
                                                              ENC=Vendor Posting Group] }
    { 22  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[ENU=Currency Code;
                                                              ESM=C d. divisa;
                                                              FRC=Code devise;
                                                              ENC=Currency Code] }
    { 24  ;   ;Language Code       ;Code11        ;TableRelation=Language;
                                                   CaptionML=[ENU=Language Code;
                                                              ESM=C d. idioma;
                                                              FRC=Code langue;
                                                              ENC=Language Code] }
    { 26  ;   ;Statistics Group    ;Integer       ;CaptionML=[ENU=Statistics Group;
                                                              ESM=N  grupo estad stico;
                                                              FRC=Groupe statistiques;
                                                              ENC=Statistics Group] }
    { 27  ;   ;Payment Terms Code  ;Code9         ;TableRelation="Payment Terms";
                                                   CaptionML=[ENU=Payment Terms Code;
                                                              ESM=C d. t rminos pago;
                                                              FRC=Code modalit s de paiement;
                                                              ENC=Payment Terms Code] }
    { 28  ;   ;Fin. Charge Terms Code;Code9       ;TableRelation="Finance Charge Terms";
                                                   CaptionML=[ENU=Fin. Charge Terms Code;
                                                              ESM=C d. inter s;
                                                              FRC=Code modalit s frais financier;
                                                              ENC=Fin. Charge Terms Code] }
    { 29  ;   ;Purchaser Code      ;Code9         ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[ENU=Purchaser Code;
                                                              ESM=C d. comprador;
                                                              FRC=Code acheteur;
                                                              ENC=Purchaser Code] }
    { 30  ;   ;Shipment Method Code;Code9         ;TableRelation="Shipment Method";
                                                   CaptionML=[ENU=Shipment Method Code;
                                                              ESM=C d. m todo de env o;
                                                              FRC=Code m thode de livraison;
                                                              ENC=Shipment Method Code] }
    { 31  ;   ;Shipping Agent Code ;Code9         ;TableRelation="Shipping Agent";
                                                   CaptionML=[ENU=Shipping Agent Code;
                                                              ESM=C d. transportista;
                                                              FRC=Code agent de livraison;
                                                              ENC=Shipping Agent Code] }
    { 33  ;   ;Invoice Disc. Code  ;Code9         ;TableRelation=Vendor;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[ENU=Invoice Disc. Code;
                                                              ESM=C d. dto. factura;
                                                              FRC=Code escompte facture;
                                                              ENC=Invoice Disc. Code] }
    { 35  ;   ;Country/Region Code ;Code9         ;TableRelation=Country/Region;
                                                   CaptionML=[ENU=Country/Region Code;
                                                              ESM=C d. pa s/regi n;
                                                              FRC=Code pays/r gion;
                                                              ENC=Country/Region Code] }
    { 38  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Comment Line" WHERE (Table Name=CONST(Vendor),
                                                                                           No.=FIELD(No.)));
                                                   CaptionML=[ENU=Comment;
                                                              ESM=Comentario;
                                                              FRC=Commentaire;
                                                              ENC=Comment];
                                                   Editable=No }
    { 39  ;   ;Blocked             ;Option        ;CaptionML=[ENU=Blocked;
                                                              ESM=Bloqueado;
                                                              FRC=Bloqu ;
                                                              ENC=Blocked];
                                                   OptionCaptionML=[ENU=" ,Payment,All";
                                                                    ESM=" ,Pago,Todos";
                                                                    FRC=" ,Paiement,Tout";
                                                                    ENC=" ,Payment,All"];
                                                   OptionString=[ ,Payment,All] }
    { 45  ;   ;Pay-to Vendor No.   ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[ENU=Vendor No.;
                                                              ESM=Pago-a N  proveedor;
                                                              FRC=N  fournisseur cr ancier;
                                                              ENC=Pay-to Vendor No.] }
    { 46  ;   ;Priority            ;Integer       ;CaptionML=[ENU=Priority;
                                                              ESM=Prioridad;
                                                              FRC=Priorit ;
                                                              ENC=Priority] }
    { 47  ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   CaptionML=[ENU=Payment Method Code;
                                                              ESM=C d. forma pago;
                                                              FRC=Code mode de paiement;
                                                              ENC=Payment Method Code] }
    { 54  ;   ;Last Date Modified  ;Date          ;CaptionML=[ENU=Last Date Modified;
                                                              ESM=Fecha  lt. modificaci n;
                                                              FRC=Date derni re modification;
                                                              ENC=Last Date Modified];
                                                   Editable=No }
    { 55  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[ENU=Date Filter;
                                                              ESM=Filtro fecha;
                                                              FRC=Filtre date;
                                                              ENC=Date Filter] }
    { 56  ;   ;Global Dimension 1 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[ENU=Global Dimension 1 Filter;
                                                              ESM=Filtro dimensi n global 1;
                                                              FRC=Filtre dimension principale 1;
                                                              ENC=Global Dimension 1 Filter];
                                                   CaptionClass='1,3,1' }
    { 57  ;   ;Global Dimension 2 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[ENU=Global Dimension 2 Filter;
                                                              ESM=Filtro dimensi n global  2;
                                                              FRC=Filtre dimension principale 2;
                                                              ENC=Global Dimension 2 Filter];
                                                   CaptionClass='1,3,2' }
    { 58  ;   ;Balance             ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Balance;
                                                              ESM=Saldo;
                                                              FRC=Solde;
                                                              ENC=Balance];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 59  ;   ;Balance (LCY)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Balance ($);
                                                              ESM=Saldo ($);
                                                              FRC=Solde ($);
                                                              ENC=Balance ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 60  ;   ;Net Change          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Net Change;
                                                              ESM=Saldo periodo;
                                                              FRC=Variation nette;
                                                              ENC=Net Change];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 61  ;   ;Net Change (LCY)    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Net Change ($);
                                                              ESM=Saldo periodo ($);
                                                              FRC=Variation nette ($);
                                                              ENC=Net Change ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 62  ;   ;Purchases (LCY)     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Vendor Ledger Entry"."Purchase (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                  Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                  Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                  Posting Date=FIELD(Date Filter),
                                                                                                                  Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Purchases ($);
                                                              ESM=Compras ($);
                                                              FRC=Achats ($);
                                                              ENC=Purchases ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 64  ;   ;Inv. Discounts (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Vendor Ledger Entry"."Inv. Discount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                       Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                       Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Inv. Discounts ($);
                                                              ESM=Dtos. factura ($);
                                                              FRC=Escomptes facture ($);
                                                              ENC=Inv. Discounts ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 65  ;   ;Pmt. Discounts (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                       Entry Type=FILTER(Payment Discount..'Payment Discount (VAT Adjustment)'),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Pmt. Discounts ($);
                                                              ESM=Dto. P.P. ($);
                                                              FRC=Escomptes de paiement ($);
                                                              ENC=Pmt. Discounts ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 66  ;   ;Balance Due         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FIELD(No.),
                                                                                                                Posting Date=FIELD(UPPERLIMIT(Date Filter)),
                                                                                                                Initial Entry Due Date=FIELD(Date Filter),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Balance Due;
                                                              ESM=Saldo vencido;
                                                              FRC=Solde d ;
                                                              ENC=Balance Due];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 67  ;   ;Balance Due (LCY)   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                        Posting Date=FIELD(UPPERLIMIT(Date Filter)),
                                                                                                                        Initial Entry Due Date=FIELD(Date Filter),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Balance Due ($);
                                                              ESM=Saldo vencido ($);
                                                              FRC=Solde d  ($);
                                                              ENC=Balance Due ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 69  ;   ;Payments            ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Payment),
                                                                                                               Entry Type=CONST(Initial Entry),
                                                                                                               Vendor No.=FIELD(No.),
                                                                                                               Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                               Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                               Posting Date=FIELD(Date Filter),
                                                                                                               Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Payments;
                                                              ESM=Pagos;
                                                              FRC=Paiements;
                                                              ENC=Payments];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 70  ;   ;Invoice Amounts     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Invoice),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Invoice Amounts;
                                                              ESM=Facturado;
                                                              FRC=Montants facture;
                                                              ENC=Invoice Amounts];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 71  ;   ;Cr. Memo Amounts    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Credit Memo),
                                                                                                               Entry Type=CONST(Initial Entry),
                                                                                                               Vendor No.=FIELD(No.),
                                                                                                               Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                               Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                               Posting Date=FIELD(Date Filter),
                                                                                                               Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Cr. Memo Amounts;
                                                              ESM=Imp. de notas de cr dito;
                                                              FRC=Montants note de cr dit;
                                                              ENC=Cr. Memo Amounts];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 72  ;   ;Finance Charge Memo Amounts;Decimal;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Finance Charge Memo),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Finance Charge Memo Amounts;
                                                              ESM=Importes doc. inter s;
                                                              FRC=Montants note frais financiers;
                                                              ENC=Finance Charge Memo Amounts];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 74  ;   ;Payments (LCY)      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Payment),
                                                                                                                       Entry Type=CONST(Initial Entry),
                                                                                                                       Vendor No.=FIELD(No.),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Payments ($);
                                                              ESM=Pagos ($);
                                                              FRC=Paiements ($);
                                                              ENC=Payments ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 75  ;   ;Inv. Amounts (LCY)  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Invoice),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Inv. Amounts ($);
                                                              ESM=Facturado ($);
                                                              FRC=Montants de la facture ($);
                                                              ENC=Inv. Amounts ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 76  ;   ;Cr. Memo Amounts (LCY);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Credit Memo),
                                                                                                                       Entry Type=CONST(Initial Entry),
                                                                                                                       Vendor No.=FIELD(No.),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Cr. Memo Amounts ($);
                                                              ESM=Notas de Cr dito ($);
                                                              FRC=Montants de notes de cr dit ($);
                                                              ENC=Cr. Memo Amounts ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 77  ;   ;Fin. Charge Memo Amounts (LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Finance Charge Memo),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Fin. Charge Memo Amounts ($);
                                                              ESM=Importes doc. inter s ($);
                                                              FRC=Montants de note de frais fin. ($);
                                                              ENC=Fin. Charge Memo Amounts ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 78  ;   ;Outstanding Orders  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Amount" WHERE (Document Type=CONST(Order),
                                                                                                               Pay-to Vendor No.=FIELD(No.),
                                                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                               Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[ENU=Outstanding Orders;
                                                              ESM=Importe pedidos pendientes;
                                                              FRC=Commandes en suspens;
                                                              ENC=Outstanding Orders];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 79  ;   ;Amt. Rcd. Not Invoiced;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Amt. Rcd. Not Invoiced" WHERE (Document Type=CONST(Order),
                                                                                                                   Pay-to Vendor No.=FIELD(No.),
                                                                                                                   Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                   Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                   Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[ENU=Amt. Rcd. Not Invoiced;
                                                              ESM=Importe recibido no facturado;
                                                              FRC=Montant re u non factur ;
                                                              ENC=Amt. Rcd. Not Invoiced];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 80  ;   ;Application Method  ;Option        ;CaptionML=[ENU=Application Method;
                                                              ESM=M todo liquidaci n;
                                                              FRC=M thode d'affectation;
                                                              ENC=Application Method];
                                                   OptionCaptionML=[ENU=Manual,Apply to Oldest;
                                                                    ESM=Manual,Por antig edad;
                                                                    FRC=Manuel,Affecter   la plus vieille;
                                                                    ENC=Manual,Apply to Oldest];
                                                   OptionString=Manual,Apply to Oldest }
    { 82  ;   ;Prices Including VAT;Boolean       ;OnValidate=VAR
                                                                PurchPrice@1000 : Record 7012;
                                                                Item@1001 : Record 27;
                                                                VATPostingSetup@1002 : Record 325;
                                                                Currency@1003 : Record 4;
                                                              BEGIN
                                                                PurchPrice.SETCURRENTKEY("Vendor No.");
                                                                PurchPrice.SETRANGE("Vendor No.","No.");
                                                                IF PurchPrice.FIND('-') THEN BEGIN
                                                                  IF VATPostingSetup.GET('','') THEN;
                                                                  IF CONFIRM(
                                                                       STRSUBSTNO(
                                                                         //Text002,
                                                                         FIELDCAPTION("Prices Including VAT"),"Prices Including VAT",PurchPrice.TABLECAPTION),TRUE)
                                                                  THEN
                                                                    REPEAT
                                                                      IF PurchPrice."Item No." <> Item."No." THEN
                                                                        Item.GET(PurchPrice."Item No.");
                                                                      IF ("VAT Bus. Posting Group" <> VATPostingSetup."VAT Bus. Posting Group") OR
                                                                         (Item."VAT Prod. Posting Group" <> VATPostingSetup."VAT Prod. Posting Group")
                                                                      THEN
                                                                        VATPostingSetup.GET("VAT Bus. Posting Group",Item."VAT Prod. Posting Group");
                                                                      IF PurchPrice."Currency Code" = '' THEN
                                                                        Currency.InitRoundingPrecision
                                                                      ELSE
                                                                        IF PurchPrice."Currency Code" <> Currency.Code THEN
                                                                          Currency.GET(PurchPrice."Currency Code");
                                                                      IF VATPostingSetup."VAT %" <> 0 THEN BEGIN
                                                                        IF "Prices Including VAT" THEN
                                                                          PurchPrice."Direct Unit Cost" :=
                                                                            ROUND(
                                                                              PurchPrice."Direct Unit Cost" * (1 + VATPostingSetup."VAT %" / 100),
                                                                              Currency."Unit-Amount Rounding Precision")
                                                                        ELSE
                                                                          PurchPrice."Direct Unit Cost" :=
                                                                            ROUND(
                                                                              PurchPrice."Direct Unit Cost" / (1 + VATPostingSetup."VAT %" / 100),
                                                                              Currency."Unit-Amount Rounding Precision");
                                                                        PurchPrice.MODIFY;
                                                                      END;
                                                                    UNTIL PurchPrice.NEXT = 0;
                                                                END;
                                                              END;

                                                   CaptionML=[ENU=Prices Including VAT;
                                                              ESM=Precios IVA incluido;
                                                              FRC=Prix incluant la TVA;
                                                              ENC=Prices Including VAT] }
    { 84  ;   ;Fax No.             ;Text30        ;CaptionML=[ENU=Fax No.;
                                                              ESM=N  fax;
                                                              FRC=N  t l copieur;
                                                              ENC=Fax No.] }
    { 85  ;   ;Telex Answer Back   ;Text20        ;CaptionML=[ENU=Telex Answer Back;
                                                              ESM=N  t lex respuesta;
                                                              FRC=T lex retour;
                                                              ENC=Telex Answer Back] }
    { 86  ;   ;VAT Registration No.;Text20        ;OnValidate=VAR
                                                                VATRegNoFormat@1000 : Record 381;
                                                                VATRegistrationLogMgt@1002 : Codeunit 249;
                                                              BEGIN
                                                                IF VATRegNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Vendor) THEN
                                                                  IF "VAT Registration No." <> xRec."VAT Registration No." THEN
                                                                   // VATRegistrationLogMgt.LogVendor(Rec);
                                                              END;

                                                   CaptionML=[ENU=Tax Registration No.;
                                                              ESM=RFC/Curp;
                                                              FRC=N  identification de la TPS/TVH;
                                                              ENC=GST/HST Registration No.] }
    { 88  ;   ;Gen. Bus. Posting Group;Code10     ;TableRelation="Gen. Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                                                                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                                                                    VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
                                                              END;

                                                   CaptionML=[ENU=Gen. Bus. Posting Group;
                                                              ESM=Grupo contable negocio;
                                                              FRC=Groupe de report de march ;
                                                              ENC=Gen. Bus. Posting Group] }
    { 89  ;   ;Picture             ;BLOB          ;CaptionML=[ENU=Picture;
                                                              ESM=Imagen;
                                                              FRC=Image;
                                                              ENC=Picture];
                                                   SubType=Bitmap }
    { 90  ;   ;GLN                 ;Code13        ;OnValidate=VAR
                                                                GLNCalculator@1000 : Codeunit 1607;
                                                              BEGIN
                                                                IF GLN <> '' THEN
                                                                  GLNCalculator.AssertValidCheckDigit13(GLN);
                                                              END;

                                                   CaptionML=[ENU=GLN;
                                                              ESM=GLN;
                                                              FRC=GLN;
                                                              ENC=GLN];
                                                   Numeric=Yes }
    { 91  ;   ;Post Code           ;Code20        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[ENU=ZIP Code;
                                                              ESM=C.P.;
                                                              FRC=Code postal;
                                                              ENC=Postal/ZIP Code] }
    { 92  ;   ;County              ;Text30        ;CaptionML=[ENU=State;
                                                              ESM=Provincia;
                                                              FRC=Comt ;
                                                              ENC=Province/State] }
    { 97  ;   ;Debit Amount        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Debit Amount" WHERE (Vendor No.=FIELD(No.),
                                                                                                                       Entry Type=FILTER(<>Application),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Debit Amount;
                                                              ESM=Importe debe;
                                                              FRC=Montant de d bit;
                                                              ENC=Debit Amount];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 98  ;   ;Credit Amount       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Credit Amount" WHERE (Vendor No.=FIELD(No.),
                                                                                                                        Entry Type=FILTER(<>Application),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Credit Amount;
                                                              ESM=Importe haber;
                                                              FRC=Montant de cr dit;
                                                              ENC=Credit Amount];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 99  ;   ;Debit Amount (LCY)  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                             Entry Type=FILTER(<>Application),
                                                                                                                             Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                             Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                             Posting Date=FIELD(Date Filter),
                                                                                                                             Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Debit Amount ($);
                                                              ESM=Importe debe ($);
                                                              FRC=Montant de d bit ($);
                                                              ENC=Debit Amount ($)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 100 ;   ;Credit Amount (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Credit Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                              Entry Type=FILTER(<>Application),
                                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Credit Amount ($);
                                                              ESM=Importe haber ($);
                                                              FRC=Montant de cr dit ($);
                                                              ENC=Credit Amount ($)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 102 ;   ;E-Mail              ;Text80        ;ExtendedDatatype=E-Mail;
                                                   CaptionML=[ENU=E-Mail;
                                                              ESM=Correo electr nico;
                                                              FRC=Courriel;
                                                              ENC=E-Mail] }
    { 103 ;   ;Home Page           ;Text80        ;ExtendedDatatype=URL;
                                                   CaptionML=[ENU=Home Page;
                                                              ESM=P gina principal;
                                                              FRC=Page d'accueil;
                                                              ENC=Home Page] }
    { 104 ;   ;Reminder Amounts    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Reminder),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Reminder Amounts;
                                                              ESM=Importe recordatorio;
                                                              FRC=Montants rappel;
                                                              ENC=Reminder Amounts];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 105 ;   ;Reminder Amounts (LCY);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Reminder),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Reminder Amounts ($);
                                                              ESM=Importe recordatorio ($);
                                                              FRC=Montants rappel ($);
                                                              ENC=Reminder Amounts ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 107 ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=[ENU=No. Series;
                                                              ESM=Nos. serie;
                                                              FRC=S ries de n ;
                                                              ENC=No. Series];
                                                   Editable=No }
    { 108 ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=[ENU=Tax Area Code;
                                                              ESM=C d.  rea impuesto;
                                                              FRC=Code de r gion fiscale;
                                                              ENC=Tax Area Code] }
    { 109 ;   ;Tax Liable          ;Boolean       ;CaptionML=[ENU=Tax Liable;
                                                              ESM=Sujeto a impuesto;
                                                              FRC=Imposable;
                                                              ENC=Tax Liable] }
    { 110 ;   ;VAT Bus. Posting Group;Code10      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[ENU=Tax Bus. Posting Group;
                                                              ESM=Grupo registro IVA neg.;
                                                              FRC=Groupe de reports de taxe sur la valeur ajout e de l'entreprise;
                                                              ENC=Tax Bus. Posting Group] }
    { 111 ;   ;Currency Filter     ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation=Currency;
                                                   CaptionML=[ENU=Currency Filter;
                                                              ESM=Filtro divisa;
                                                              FRC=Filtre devise;
                                                              ENC=Currency Filter] }
    { 113 ;   ;Outstanding Orders (LCY);Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                     Pay-to Vendor No.=FIELD(No.),
                                                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[ENU=Outstanding Orders ($);
                                                              ESM=Pedidos pendientes ($);
                                                              FRC=Commandes en suspens ($);
                                                              ENC=Outstanding Orders ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 114 ;   ;Amt. Rcd. Not Invoiced (LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Amt. Rcd. Not Invoiced (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                         Pay-to Vendor No.=FIELD(No.),
                                                                                                                         Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                         Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                         Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[ENU=Amt. Rcd. Not Invoiced ($);
                                                              ESM=Imp. recibido no factur. ($);
                                                              FRC=Montant re u non factur  ($);
                                                              ENC=Amt. Rcd. Not Invoiced ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 116 ;   ;Block Payment Tolerance;Boolean    ;CaptionML=[ENU=Block Payment Tolerance;
                                                              ESM=Bloquear tolerancia pagos;
                                                              FRC=Tol r. vers. en fonds bloqu s;
                                                              ENC=Block Payment Tolerance] }
    { 117 ;   ;Pmt. Disc. Tolerance (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                       Entry Type=FILTER(Payment Discount Tolerance|'Payment Discount Tolerance (VAT Adjustment)'|'Payment Discount Tolerance (VAT Excl.)'),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Pmt. Disc. Tolerance ($);
                                                              ESM=Tolerancia dto. P.P ($);
                                                              FRC=Validation tol rance d'escompte de paiement $;
                                                              ENC=Pmt. Disc. Tolerance ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 118 ;   ;Pmt. Tolerance (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                       Entry Type=FILTER(Payment Tolerance|'Payment Tolerance (VAT Adjustment)'|'Payment Tolerance (VAT Excl.)'),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Pmt. Tolerance ($);
                                                              ESM=Tolerancia pagos ($);
                                                              FRC=Tol rance de r glement $;
                                                              ENC=Pmt. Tolerance ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 119 ;   ;IC Partner Code     ;Code20        ;TableRelation="IC Partner";
                                                   OnValidate=VAR
                                                                VendLedgEntry@1001 : Record 25;
                                                                AccountingPeriod@1000 : Record 50;
                                                                ICPartner@1002 : Record 413;
                                                              BEGIN
                                                                IF xRec."IC Partner Code" <> "IC Partner Code" THEN BEGIN
                                                                  VendLedgEntry.SETCURRENTKEY("Vendor No.","Posting Date");
                                                                  VendLedgEntry.SETRANGE("Vendor No.","No.");
                                                                  AccountingPeriod.SETRANGE(Closed,FALSE);
                                                                  IF AccountingPeriod.FINDFIRST THEN
                                                                    VendLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
                                                                  IF VendLedgEntry.FINDFIRST THEN
                                                                  //  IF NOT CONFIRM(Text009,FALSE,TABLECAPTION) THEN
                                                                      "IC Partner Code" := xRec."IC Partner Code";

                                                                  VendLedgEntry.RESET;
                                                                  IF NOT VendLedgEntry.SETCURRENTKEY("Vendor No.",Open) THEN
                                                                    VendLedgEntry.SETCURRENTKEY("Vendor No.");
                                                                  VendLedgEntry.SETRANGE("Vendor No.","No.");
                                                                  VendLedgEntry.SETRANGE(Open,TRUE);
                                                                  IF VendLedgEntry.FINDLAST THEN
                                                                  //  ERROR(Text010,FIELDCAPTION("IC Partner Code"),TABLECAPTION);
                                                                //END;

                                                                IF "IC Partner Code" <> '' THEN BEGIN
                                                                  ICPartner.GET("IC Partner Code");
                                                                  IF (ICPartner."Vendor No." <> '') AND (ICPartner."Vendor No." <> "No.") THEN
                                                                   // ERROR(Text008,FIELDCAPTION("IC Partner Code"),"IC Partner Code",TABLECAPTION,ICPartner."Vendor No.");
                                                                  ICPartner."Vendor No." := "No.";
                                                                  ICPartner.MODIFY;
                                                                END;

                                                                IF (xRec."IC Partner Code" <> "IC Partner Code") AND ICPartner.GET(xRec."IC Partner Code") THEN BEGIN
                                                                  ICPartner."Vendor No." := '';
                                                                  ICPartner.MODIFY;
                                                                END;
                                                                END
                                                              END;

                                                   CaptionML=[ENU=IC Partner Code;
                                                              ESM=C digo socio IC;
                                                              FRC=Code de partenaire IC;
                                                              ENC=IC Partner Code] }
    { 120 ;   ;Refunds             ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Refund),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Refunds;
                                                              ESM=Reembolsos;
                                                              FRC=Remboursements;
                                                              ENC=Refunds] }
    { 121 ;   ;Refunds (LCY)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Refund),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Refunds ($);
                                                              ESM=Reembolsos ($);
                                                              FRC=Remboursements ($);
                                                              ENC=Refunds ($)] }
    { 122 ;   ;Other Amounts       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(" "),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Other Amounts;
                                                              ESM=Otros importes;
                                                              FRC=Autres montants;
                                                              ENC=Other Amounts] }
    { 123 ;   ;Other Amounts (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(" "),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Other Amounts ($);
                                                              ESM=Otros importes ($);
                                                              FRC=Autres montants ($);
                                                              ENC=Other Amounts ($)] }
    { 124 ;   ;Prepayment %        ;Decimal       ;CaptionML=[ENU=Prepayment %;
                                                              ESM=% anticipo;
                                                              FRC=% paiement anticip ;
                                                              ENC=Prepayment %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 125 ;   ;Outstanding Invoices;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Amount" WHERE (Document Type=CONST(Invoice),
                                                                                                               Pay-to Vendor No.=FIELD(No.),
                                                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                               Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[ENU=Outstanding Invoices;
                                                              ESM=Facturas pendientes;
                                                              FRC=Factures en suspens;
                                                              ENC=Outstanding Invoices];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 126 ;   ;Outstanding Invoices (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Invoice),
                                                                                                                     Pay-to Vendor No.=FIELD(No.),
                                                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[ENU=Outstanding Invoices ($);
                                                              ESM=Facturas pendientes ($);
                                                              FRC=Factures en suspens ($);
                                                              ENC=Outstanding Invoices ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 130 ;   ;Pay-to No. Of Archived Doc.;Integer;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header Archive" WHERE (Document Type=CONST(Order),
                                                                                                      Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=Pay-to No. Of Archived Doc.;
                                                              ESM=Pago a-N  de doc. archivado;
                                                              FRC=N  de "pay   " des doc. archiv s;
                                                              ENC=No. Of Archived Doc.] }
    { 131 ;   ;Buy-from No. Of Archived Doc.;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header Archive" WHERE (Document Type=CONST(Order),
                                                                                                      Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=Buy-from No. Of Archived Doc.;
                                                              ESM=Compra a-N  de doc. archivado;
                                                              FRC=Achat - Nbre de doc. archiv s;
                                                              ENC=Buy-from No. Of Archived Doc.] }
    { 132 ;   ;Partner Type        ;Option        ;CaptionML=[ENU=Partner Type;
                                                              ESM=Tipo socio;
                                                              FRC=Type partenaire;
                                                              ENC=Partner Type];
                                                   OptionCaptionML=[ENU=" ,Company,Person";
                                                                    ESM=" ,Empresa,Persona";
                                                                    FRC=" ,Compagnie,Personne";
                                                                    ENC=" ,Company,Person"];
                                                   OptionString=[ ,Company,Person] }
    { 170 ;   ;Creditor No.        ;Code20        ;CaptionML=[ENU=Creditor No.;
                                                              ESM=N  acreedor;
                                                              FRC=N  cr diteur;
                                                              ENC=Creditor No.];
                                                   Numeric=Yes }
    { 288 ;   ;Preferred Bank Account;Code10      ;TableRelation="Vendor Bank Account".Code WHERE (Vendor No.=FIELD(No.));
                                                   CaptionML=[ENU=Preferred Bank Account;
                                                              ESM=Cuenta bancaria preferida;
                                                              FRC=Compte bancaire pr f r ;
                                                              ENC=Preferred Bank Account] }
    { 840 ;   ;Cash Flow Payment Terms Code;Code10;TableRelation="Payment Terms";
                                                   CaptionML=[ENU=Cash Flow Payment Terms Code;
                                                              ESM=C d. t rminos de pago de flujo de caja;
                                                              FRC=Code modalit s de paiement de tr sorerie;
                                                              ENC=Cash Flow Payment Terms Code] }
    { 5049;   ;Primary Contact No. ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                Cont@1001 : Record 5050;
                                                                ContBusRel@1000 : Record 5054;
                                                              BEGIN
                                                                Contact := '';
                                                                IF "Primary Contact No." <> '' THEN BEGIN
                                                                  Cont.GET("Primary Contact No.");

                                                                  ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                                  ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
                                                                  ContBusRel.SETRANGE("No.","No.");
                                                                  ContBusRel.FINDFIRST;

                                                                  IF Cont."Company No." <> ContBusRel."Contact No." THEN
                                                                    //ERROR(Text004,Cont."No.",Cont.Name,"No.",Name);

                                                                  IF Cont.Type = Cont.Type::Person THEN
                                                                    Contact := Cont.Name
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              Cont@1001 : Record 5050;
                                                              ContBusRel@1000 : Record 5054;
                                                            BEGIN
                                                              ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                              ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
                                                              ContBusRel.SETRANGE("No.","No.");
                                                              IF ContBusRel.FINDFIRST THEN
                                                                Cont.SETRANGE("Company No.",ContBusRel."Contact No.")
                                                              ELSE
                                                                Cont.SETRANGE("No.",'');

                                                              IF "Primary Contact No." <> '' THEN
                                                                IF Cont.GET("Primary Contact No.") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN
                                                                VALIDATE("Primary Contact No.",Cont."No.");
                                                            END;

                                                   CaptionML=[ENU=Primary Contact No.;
                                                              ESM=N  contacto principal;
                                                              FRC=N  contact principal;
                                                              ENC=Primary Contact No.] }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   CaptionML=[ENU=Responsibility Center;
                                                              ESM=Centro responsabilidad;
                                                              FRC=Centre de gestion;
                                                              ENC=Responsibility Centre] }
    { 5701;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[ENU=Location Code;
                                                              ESM=C d. almac n;
                                                              FRC=Code d'emplacement;
                                                              ENC=Location Code] }
    { 5790;   ;Lead Time Calculation;DateFormula  ;AccessByPermission=TableData 120=R;
                                                   CaptionML=[ENU=Lead Time Calculation;
                                                              ESM=Plazo entrega (d as);
                                                              FRC=D lai de r approvisionnement;
                                                              ENC=Lead Time Calculation] }
    { 7177;   ;No. of Pstd. Receipts;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Rcpt. Header" WHERE (Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=No. of Pstd. Receipts;
                                                              ESM=N  hist ricos recepciones;
                                                              FRC=Nombre de r ceptions report es;
                                                              ENC=No. of Pstd. Receipts];
                                                   Editable=No }
    { 7178;   ;No. of Pstd. Invoices;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Inv. Header" WHERE (Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=No. of Pstd. Invoices;
                                                              ESM=N  de facturas registradas;
                                                              FRC=Nombre de factures report es;
                                                              ENC=No. of Pstd. Invoices];
                                                   Editable=No }
    { 7179;   ;No. of Pstd. Return Shipments;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Return Shipment Header" WHERE (Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=No. of Pstd. Return Shipments;
                                                              ESM=N  env os devoluci n reg.;
                                                              FRC=Nombre de livraisons de retour report es;
                                                              ENC=No. of Pstd. Return Shipments];
                                                   Editable=No }
    { 7180;   ;No. of Pstd. Credit Memos;Integer  ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Cr. Memo Hdr." WHERE (Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=No. of Pstd. Credit Memos;
                                                              ESM=N  de notas de cr dito registradas;
                                                              FRC=Nbre notes de cr dit report es;
                                                              ENC=No. of Pstd. Credit Memos];
                                                   Editable=No }
    { 7181;   ;Pay-to No. of Orders;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Order),
                                                                                              Pay-to Vendor No.=FIELD(No.)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[ENU=Pay-to No. of Orders;
                                                              ESM=Pago a-N  de pedidos;
                                                              FRC=N  de "pay   " des commandes;
                                                              ENC=Pay-to No. of Orders];
                                                   Editable=No }
    { 7182;   ;Pay-to No. of Invoices;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Invoice),
                                                                                              Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=Pay-to No. of Invoices;
                                                              ESM=Pago a-N  de facturas;
                                                              FRC=N  de "pay   " des factures;
                                                              ENC=Pay-to No. of Invoices];
                                                   Editable=No }
    { 7183;   ;Pay-to No. of Return Orders;Integer;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Return Order),
                                                                                              Pay-to Vendor No.=FIELD(No.)));
                                                   AccessByPermission=TableData 6650=R;
                                                   CaptionML=[ENU=Pay-to No. of Return Orders;
                                                              ESM=Pago a-N  de devoluciones;
                                                              FRC=N  de "pay   " des retours;
                                                              ENC=Pay-to No. of Return Orders];
                                                   Editable=No }
    { 7184;   ;Pay-to No. of Credit Memos;Integer ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Credit Memo),
                                                                                              Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=Pay-to No. of Credit Memos;
                                                              ESM=Pago a-N  de notas de Cr dito;
                                                              FRC=N  de "pay   " des notes de cr dit;
                                                              ENC=Pay-to No. of Credit Memos];
                                                   Editable=No }
    { 7185;   ;Pay-to No. of Pstd. Receipts;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Rcpt. Header" WHERE (Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=Pay-to No. of Pstd. Receipts;
                                                              ESM=Pago a-N  hist ricos recepciones;
                                                              FRC=N  de "pay   " des r ceptions report es;
                                                              ENC=Pay-to No. of Pstd. Receipts];
                                                   Editable=No }
    { 7186;   ;Pay-to No. of Pstd. Invoices;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Inv. Header" WHERE (Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=Pay-to No. of Pstd. Invoices;
                                                              ESM=Pago a-N  de facturas registradas;
                                                              FRC=N  de "pay   " des factures report es;
                                                              ENC=Pay-to No. of Pstd. Invoices];
                                                   Editable=No }
    { 7187;   ;Pay-to No. of Pstd. Return S.;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Return Shipment Header" WHERE (Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=No. of Pstd. Return S.;
                                                              ESM=Pago a-N  de env os devoluci n reg.;
                                                              FRC=N  de "pay   " des livraisons retour report es;
                                                              ENC=No. of Pstd. Return S.];
                                                   Editable=No }
    { 7188;   ;Pay-to No. of Pstd. Cr. Memos;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Cr. Memo Hdr." WHERE (Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=No. of Pstd. Cr. Memos;
                                                              ESM=Pago a-N  de notas de cr dito registradas;
                                                              FRC=N  de "pay   " des notes de cr dit report es;
                                                              ENC=No. of Pstd. Cr. Memos];
                                                   Editable=No }
    { 7189;   ;No. of Quotes       ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Quote),
                                                                                              Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=No. of Quotes;
                                                              ESM=N  de cotizaciones;
                                                              FRC=Nombre de devis;
                                                              ENC=No. of Quotes];
                                                   Editable=No }
    { 7190;   ;No. of Blanket Orders;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Blanket Order),
                                                                                              Buy-from Vendor No.=FIELD(No.)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[ENU=No. of Blanket Orders;
                                                              ESM=N  de pedidos abiertos;
                                                              FRC=Nombre de commandes permanentes;
                                                              ENC=No. of Blanket Orders];
                                                   Editable=No }
    { 7191;   ;No. of Orders       ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Order),
                                                                                              Buy-from Vendor No.=FIELD(No.)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[ENU=No. of Orders;
                                                              ESM=N  de pedidos;
                                                              FRC=Nombre de commandes;
                                                              ENC=No. of Orders] }
    { 7192;   ;No. of Invoices     ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Invoice),
                                                                                              Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=No. of Invoices;
                                                              ESM=N  de facturas;
                                                              FRC=Nombre de factures;
                                                              ENC=No. of Invoices];
                                                   Editable=No }
    { 7193;   ;No. of Return Orders;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Return Order),
                                                                                              Buy-from Vendor No.=FIELD(No.)));
                                                   AccessByPermission=TableData 6650=R;
                                                   CaptionML=[ENU=No. of Return Orders;
                                                              ESM=N  de devoluciones;
                                                              FRC=Nombre de commandes de retour;
                                                              ENC=No. of Return Orders];
                                                   Editable=No }
    { 7194;   ;No. of Credit Memos ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Credit Memo),
                                                                                              Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=No. of Credit Memos;
                                                              ESM=N  de notas de Cr dito;
                                                              FRC=Nombre de notes de cr dit;
                                                              ENC=No. of Credit Memos];
                                                   Editable=No }
    { 7195;   ;No. of Order Addresses;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Order Address" WHERE (Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=No. of Order Addresses;
                                                              ESM=N  de direcciones de pedido;
                                                              FRC=Nbre d'adresses de commande;
                                                              ENC=No. of Order Addresses];
                                                   Editable=No }
    { 7196;   ;Pay-to No. of Quotes;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Quote),
                                                                                              Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[ENU=Pay-to No. of Quotes;
                                                              ESM=Pago a-N  de cotizaciones;
                                                              FRC=N  de "pay   " des devis;
                                                              ENC=Pay-to No. of Quotes];
                                                   Editable=No }
    { 7197;   ;Pay-to No. of Blanket Orders;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Blanket Order),
                                                                                              Pay-to Vendor No.=FIELD(No.)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[ENU=Pay-to No. of Blanket Orders;
                                                              ESM=Pago a-N  de pedidos abiertos;
                                                              FRC=N  de "pay   " des Commandes Ouvertes;
                                                              ENC=Pay-to No. of Blanket Orders] }
    { 7600;   ;Base Calendar Code  ;Code10        ;TableRelation="Base Calendar";
                                                   CaptionML=[ENU=Base Calendar Code;
                                                              ESM=C digo calendario base;
                                                              FRC=Code calendrier principal;
                                                              ENC=Base Calendar Code] }
    { 10004;  ;UPS Zone            ;Code2         ;CaptionML=[ENU=UPS Zone;
                                                              ESM=Zona UPS;
                                                              FRC=Zone UPS;
                                                              ENC=UPS Zone] }
    { 10016;  ;Federal ID No.      ;Text30        ;CaptionML=[ENU=Federal ID No.;
                                                              ESM=CURP;
                                                              FRC=N  d'identification f d ral;
                                                              ENC=Federal BIN No.] }
    { 10017;  ;Bank Communication  ;Option        ;CaptionML=[ENU=Bank Communication;
                                                              ESM=Comunicaci n banco;
                                                              FRC=Communication avec la banque;
                                                              ENC=Bank Communication];
                                                   OptionCaptionML=[ENU=E English,F French,S Spanish;
                                                                    ESM=I Ingl s,F Franc s,E Espa ol;
                                                                    FRC=E Anglais,F Fran ais,S Espagnol;
                                                                    ENC=E English,F French,S Spanish];
                                                   OptionString=E English,F French,S Spanish }
    { 10018;  ;Check Date Format   ;Option        ;CaptionML=[ENU=Check Date Format;
                                                              ESM=Comprobar formato fecha;
                                                              FRC=V rifier format date;
                                                              ENC=Cheque Date Format];
                                                   OptionCaptionML=[ENU=" ,MM DD YYYY,DD MM YYYY,YYYY MM DD";
                                                                    ESM=" ,MM DD AAAA,DD MM AAAA,AAAA MM DD";
                                                                    FRC=" ,MM DD YYYY,DD MM YYYY,YYYY MM DD";
                                                                    ENC=" ,MM DD YYYY,DD MM YYYY,YYYY MM DD"];
                                                   OptionString=[ ,MM DD YYYY,DD MM YYYY,YYYY MM DD] }
    { 10019;  ;Check Date Separator;Option        ;CaptionML=[ENU=Check Date Separator;
                                                              ESM=Comprobar separador fecha;
                                                              FRC=V rifier s parateur de dates;
                                                              ENC=Cheque Date Separator];
                                                   OptionCaptionML=[ENU=" ,-,.,/";
                                                                    ESM=" ,-,.,/";
                                                                    FRC=" ,-,.,/";
                                                                    ENC=" ,-,.,/"];
                                                   OptionString=[ ,-,.,/] }
    { 10020;  ;IRS 1099 Code       ;Code10        ;TableRelation="IRS 1099 Form-Box";
                                                   CaptionML=[ENU=IRS 1099 Code;
                                                              ESM=C d. form. 1099 de IRS;
                                                              FRC=Code IRS 1099;
                                                              ENC=IRS 1099 Code] }
    { 10021;  ;Balance on Date     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FIELD(No.),
                                                                                                                Posting Date=FIELD(UPPERLIMIT(Date Filter)),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Balance on Date;
                                                              ESM=Saldo fecha;
                                                              FRC=Solde en date;
                                                              ENC=Balance on Date];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 10022;  ;Balance on Date (LCY);Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                        Posting Date=FIELD(UPPERLIMIT(Date Filter)),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[ENU=Balance on Date ($);
                                                              ESM=Saldo fecha ($);
                                                              FRC=Solde en date ($);
                                                              ENC=Balance on Date ($)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 10023;  ;RFC No.             ;Code13        ;OnValidate=VAR
                                                                Vendor@1020000 : Record 23;
                                                              BEGIN
                                                                {
                                                                CASE "Tax Identification Type" OF
                                                                  "Tax Identification Type"::"Legal Entity":
                                                                    ValidateRFCNo(12);
                                                                  "Tax Identification Type"::"Natural Person":
                                                                    ValidateRFCNo(13);
                                                                END;
                                                                Vendor.RESET;
                                                                Vendor.SETRANGE("RFC No.","RFC No.");
                                                                Vendor.SETFILTER("No.",'<>%1',"No.");
                                                                IF Vendor.FINDFIRST THEN
                                                                  MESSAGE(Text10002,"RFC No.");
                                                                  }
                                                              END;

                                                   CaptionML=[ENU=RFC No.;
                                                              ESM=N  RFC;
                                                              FRC=N  RFC;
                                                              ENC=RFC No.] }
    { 10024;  ;CURP No.            ;Code18        ;OnValidate=BEGIN
                                                                IF STRLEN("CURP No.") <> 18 THEN
                                                                  //ERROR(Text10001,"CURP No.");
                                                              END;

                                                   CaptionML=[ENU=CURP No.;
                                                              ESM=N  CURP;
                                                              FRC=N  CURP;
                                                              ENC=CURP No.] }
    { 10025;  ;State Inscription   ;Text30        ;CaptionML=[ENU=State Inscription;
                                                              ESM=Inscripci n estatal;
                                                              FRC=Inscription d' tat;
                                                              ENC=Province/State Inscription] }
    { 14020;  ;Tax Identification Type;Option     ;CaptionML=[ENU=Tax Identification Type;
                                                              ESM=Tipo identificaci n impto.;
                                                              FRC=Type d'identification taxe;
                                                              ENC=Tax Identification Type];
                                                   OptionCaptionML=[ENU=Legal Entity,Natural Person;
                                                                    ESM=Persona jur dica,Persona f sica;
                                                                    FRC=Entit  juridique,Personne physique;
                                                                    ENC=Legal Entity,Natural Person];
                                                   OptionString=Legal Entity,Natural Person }
    { 68000;  ;Creditor Type       ;Option        ;OptionString=[ ,Account] }
    { 68001;  ;Staff No            ;Code20         }
    { 68002;  ;ID No.              ;Code50         }
    { 68003;  ;Last Maintenance Date;Date          }
    { 68004;  ;Activate Sweeping Arrangement;Boolean }
    { 68005;  ;Sweeping Balance    ;Decimal        }
    { 68006;  ;Sweep To Account    ;Code30        ;TableRelation=Vendor }
    { 68007;  ;Fixed Deposit Status;Option        ;OptionCaptionML=ENU=" ,Active,Matured,Closed,Not Matured";
                                                   OptionString=[ ,Active,Matured,Closed,Not Matured] }
    { 68008;  ;Call Deposit        ;Boolean       ;OnValidate=BEGIN
                                                                IF AccountTypes.GET("Account Type") THEN BEGIN
                                                                IF AccountTypes."Fixed Deposit" = FALSE THEN
                                                                ERROR('Call deposit only applicable for Fixed Deposits.');
                                                                END;
                                                              END;
                                                               }
    { 68009;  ;Mobile Phone No     ;Code50        ;OnValidate=BEGIN

                                                                Vend.RESET;
                                                                Vend.SETRANGE(Vend."Staff No","Staff No");
                                                                IF Vend.FIND('-') THEN
                                                                Vend.MODIFYALL(Vend."Mobile Phone No","Mobile Phone No");

                                                                {Cust.RESET;
                                                                Cust.SETRANGE(Cust."Staff No","Staff No");
                                                                IF Cust.FIND('-') THEN
                                                                Cust.MODIFYALL(Cust."Mobile Phone No","Mobile Phone No");}
                                                              END;
                                                               }
    { 68010;  ;Marital Status      ;Option        ;OptionCaptionML=ENU=" ,Single,Married,Devorced,Widower";
                                                   OptionString=[ ,Single,Married,Devorced,Widower] }
    { 68011;  ;Registration Date   ;Date          ;OnValidate=BEGIN
                                                                //IF FDType.GET("Fixed Deposit Type") THEN
                                                                //"FD Maturity Date":=CALCDATE(FDType.Duration,"Registration Date");
                                                                IF "Account Type" = 'FIXED' THEN BEGIN
                                                                TESTFIELD("Registration Date");
                                                                "FD Maturity Date":=CALCDATE("Fixed Duration","Registration Date");
                                                                END;
                                                              END;
                                                               }
    { 68012;  ;BOSA Account No     ;Code20        ;TableRelation="Members Register" }
    { 68013;  ;Signature           ;BLOB          ;CaptionML=ENU=Signature;
                                                   SubType=Bitmap }
    { 68014;  ;Passport No.        ;Code50         }
    { 68015;  ;Company Code        ;Code20        ;TableRelation="Sacco Employers" }
    { 68016;  ;Status              ;Option        ;OnValidate=BEGIN
                                                                IF (Status = Status::Active) OR (Status = Status::New) THEN
                                                                Blocked:=Blocked::" "
                                                                ELSE
                                                                Blocked:=Blocked::All
                                                              END;

                                                   OptionCaptionML=ENU=Active,Frozen,Closed,Archived,New,Dormant,Deceased;
                                                   OptionString=Active,Frozen,Closed,Archived,New,Dormant,Deceased }
    { 68017;  ;Account Type        ;Code20        ;TableRelation="Account Types-Saving Products".Code;
                                                   OnValidate=BEGIN
                                                                IF AccountTypes.GET("Account Type") THEN BEGIN
                                                                AccountTypes.TESTFIELD(AccountTypes."Posting Group");
                                                                "Vendor Posting Group":=AccountTypes."Posting Group";
                                                                "Call Deposit" := FALSE;
                                                                END;
                                                              END;
                                                               }
    { 68018;  ;Account Category    ;Option        ;OptionCaptionML=ENU=Single,Joint,Corporate,Group,Branch,Project;
                                                   OptionString=Single,Joint,Corporate,Group,Branch,Project }
    { 68019;  ;FD Marked for Closure;Boolean       }
    { 68020;  ;Last Withdrawal Date;Date           }
    { 68021;  ;Last Overdraft Date ;Date           }
    { 68022;  ;Last Min. Balance Date;Date         }
    { 68023;  ;Last Deposit Date   ;Date           }
    { 68024;  ;Last Transaction Posting Date;Date  }
    { 68025;  ;Date Closed         ;Date           }
    { 68026;  ;Uncleared Cheques   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum(Transactions.Amount WHERE (Account No=FIELD(No.),
                                                                                              Posted=CONST(Yes),
                                                                                              Cheque Processed=CONST(No),
                                                                                              Type=CONST(Cheque Deposit))) }
    { 68027;  ;Expected Maturity Date;Date         }
    { 68028;  ;ATM Transactions    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("ATM Transactions".Amount WHERE (Account No=FIELD(No.),
                                                                                                    Posted=CONST(No)));
                                                   Editable=No }
    { 68029;  ;Date of Birth       ;Date          ;OnValidate=BEGIN
                                                                 IF "Date of Birth" > TODAY THEN
                                                                 ERROR('Date of birth cannot be greater than today');
                                                              END;
                                                               }
    { 68030;  ;Last Transaction Date;Date         ;FieldClass=FlowField;
                                                   CalcFormula=Max("Detailed Vendor Ledg. Entry"."Posting Date" WHERE (Vendor No.=FIELD(No.)));
                                                   CaptionML=ENU=Last Transaction Date;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 68032;  ;E-Mail (Personal)   ;Text50         }
    { 68033;  ;Section             ;Code20        ;TableRelation=Stations.Code WHERE (Employer Code=FIELD(Company Code)) }
    { 68034;  ;Card No.            ;Code50        ;OnValidate=BEGIN
                                                                   {
                                                                IF (UPPERCASE(USERID) <> 'CYRUS') AND (UPPERCASE(USERID) <> 'MUTHONI') AND (UPPERCASE(USERID) <> 'KANGOGO') AND
                                                                   (UPPERCASE(USERID) <> 'CORETEC') THEN
                                                                ERROR('You do not have permission to link ATMs.');

                                                                IF "Account Type" <> 'SAVINGS' THEN
                                                                ERROR('You can only link a card to a Savings account.');

                                                                IF CONFIRM('Are you sure you want to link/Change ATM Card No?',FALSE) = FALSE THEN
                                                                ERROR('Change of ATM Card terminated.');



                                                                //No linking Charges
                                                                //IF Charges.GET(GenLedgerSetup."COOP CARD REPLACEMENT CHARGE") THEN
                                                                ReplCharge:=550;

                                                                IF CONFIRM('Do you wish to post the card charges?')=FALSE THEN
                                                                EXIT
                                                                ELSE BEGIN
                                                                Vends.RESET;
                                                                Vends.SETRANGE(Vends."No.","No.");
                                                                IF Vends.FIND('-') THEN BEGIN
                                                                Vends.CALCFIELDS(Vends."Balance (LCY)",Vends."ATM Transactions");
                                                                IF (Vends."Balance (LCY)"-Vends."ATM Transactions")<=0 THEN
                                                                ERROR('This Account does not have funds');
                                                                END;

                                                                //Check if this card is a replacement or initial issue
                                                                //IF CONFIRM('Is this card a replacement?',FALSE)=TRUE THEN BEGIN
                                                                IF xRec."ATM No."<>'' THEN BEGIN
                                                                gnljnlLine.RESET;
                                                                gnljnlLine.SETRANGE("Journal Template Name",'GENERAL');
                                                                gnljnlLine.SETRANGE("Journal Batch Name",'SACCOLINK');
                                                                gnljnlLine.DELETEALL;

                                                                gnljnlLine.INIT;
                                                                gnljnlLine."Journal Template Name":='GENERAL';
                                                                gnljnlLine."Journal Batch Name":='SACCOLINK';
                                                                gnljnlLine."Line No.":=gnljnlLine."Line No."+100;
                                                                gnljnlLine."Account Type":=gnljnlLine."Account Type"::Vendor;
                                                                gnljnlLine."Account No.":="No.";
                                                                gnljnlLine."Posting Date":=TODAY;
                                                                gnljnlLine."Document No.":="ATM No.";
                                                                gnljnlLine.Description:='Sacco Link Card Charges' + 'No.'+ "ATM No.";
                                                                gnljnlLine.Amount:=ReplCharge;
                                                                gnljnlLine."Shortcut Dimension 1 Code":='FOSA';
                                                                gnljnlLine.VALIDATE(gnljnlLine."Shortcut Dimension 1 Code");
                                                                IF gnljnlLine.Amount <>0 THEN
                                                                gnljnlLine.INSERT;


                                                                gnljnlLine."Journal Template Name":='GENERAL';
                                                                gnljnlLine."Journal Batch Name":='SACCOLINK';
                                                                gnljnlLine."Line No.":=gnljnlLine."Line No."+100;
                                                                gnljnlLine."Account Type":=gnljnlLine."Account Type"::"Bank Account";
                                                                gnljnlLine."Account No.":='44';
                                                                gnljnlLine."Posting Date":=TODAY;
                                                                gnljnlLine."Document No.":="ATM No.";
                                                                gnljnlLine.Description:='Sacco Link Card Charges' + 'No.'+ "ATM No.";
                                                                gnljnlLine.Amount:=-ReplCharge;
                                                                gnljnlLine."Shortcut Dimension 1 Code":='FOSA';
                                                                gnljnlLine.VALIDATE(gnljnlLine."Shortcut Dimension 1 Code");
                                                                IF gnljnlLine.Amount <>0 THEN
                                                                gnljnlLine.INSERT;
                                                                 //Comms to Commissions account
                                                                gnljnlLine."Journal Template Name":='GENERAL';
                                                                gnljnlLine."Journal Batch Name":='SACCOLINK';
                                                                gnljnlLine."Line No.":=gnljnlLine."Line No."+100;
                                                                //gnljnlLine."Bal. Account Type":=gnljnlLine."Bal. Account Type"::"Bank Account";
                                                                gnljnlLine."Bal. Account Type":=gnljnlLine."Account Type"::"G/L Account";
                                                                gnljnlLine."Bal. Account No.":='1-11-00042';
                                                                gnljnlLine."Posting Date":=TODAY;
                                                                gnljnlLine."Document No.":="ATM No.";
                                                                gnljnlLine.Description:='Sacco Link Card Charges' + 'No.'+ "ATM No.";
                                                                gnljnlLine.Amount:=-50;
                                                                gnljnlLine."Shortcut Dimension 1 Code":='FOSA';
                                                                gnljnlLine.VALIDATE(gnljnlLine."Shortcut Dimension 1 Code");
                                                                IF gnljnlLine.Amount <>0 THEN
                                                                gnljnlLine.INSERT;

                                                                END ELSE BEGIN
                                                                gnljnlLine.RESET;
                                                                gnljnlLine.SETRANGE("Journal Template Name",'GENERAL');
                                                                gnljnlLine.SETRANGE("Journal Batch Name",'SACCOLINK');
                                                                gnljnlLine.DELETEALL;

                                                                gnljnlLine.INIT;
                                                                gnljnlLine."Journal Template Name":='GENERAL';
                                                                gnljnlLine."Journal Batch Name":='SACCOLINK';
                                                                gnljnlLine."Line No.":=gnljnlLine."Line No."+100;
                                                                gnljnlLine."Account Type":=gnljnlLine."Account Type"::Vendor;
                                                                gnljnlLine."Account No.":="No.";
                                                                gnljnlLine."Posting Date":=TODAY;
                                                                gnljnlLine."Document No.":="ATM No.";
                                                                gnljnlLine.Description:='Sacco Link Card Charges' + 'No.'+ "ATM No.";
                                                                gnljnlLine.Amount:=250;
                                                                gnljnlLine."Shortcut Dimension 1 Code":='FOSA';
                                                                gnljnlLine.VALIDATE(gnljnlLine."Shortcut Dimension 1 Code");
                                                                IF gnljnlLine.Amount <>0 THEN
                                                                gnljnlLine.INSERT;


                                                                gnljnlLine."Journal Template Name":='GENERAL';
                                                                gnljnlLine."Journal Batch Name":='SACCOLINK';
                                                                gnljnlLine."Line No.":=gnljnlLine."Line No."+100;
                                                                gnljnlLine."Account Type":=gnljnlLine."Account Type"::"Bank Account";
                                                                gnljnlLine."Account No.":='44';
                                                                gnljnlLine."Posting Date":=TODAY;
                                                                gnljnlLine."Document No.":="ATM No.";
                                                                gnljnlLine.Description:='Sacco Link Card Charges' + 'No.'+ "ATM No.";
                                                                gnljnlLine.Amount:=-200;
                                                                gnljnlLine."Shortcut Dimension 1 Code":='FOSA';
                                                                gnljnlLine.VALIDATE(gnljnlLine."Shortcut Dimension 1 Code");
                                                                IF gnljnlLine.Amount <>0 THEN
                                                                gnljnlLine.INSERT;

                                                                 //Comms to Commissions account
                                                                gnljnlLine."Journal Template Name":='GENERAL';
                                                                gnljnlLine."Journal Batch Name":='SACCOLINK';
                                                                gnljnlLine."Line No.":=gnljnlLine."Line No."+100;
                                                                gnljnlLine."Account Type":=gnljnlLine."Account Type"::"G/L Account";
                                                                gnljnlLine."Account No.":='1-11-00042';
                                                                gnljnlLine."Posting Date":=TODAY;
                                                                gnljnlLine."Document No.":="ATM No.";
                                                                gnljnlLine.Description:='Sacco Link Card Charges' + 'No.'+ "ATM No.";
                                                                gnljnlLine.Amount:=-50;
                                                                gnljnlLine."Shortcut Dimension 1 Code":='FOSA';
                                                                gnljnlLine.VALIDATE(gnljnlLine."Shortcut Dimension 1 Code");
                                                                IF gnljnlLine.Amount <>0 THEN
                                                                gnljnlLine.INSERT;


                                                                END;

                                                                //Post New
                                                                gnljnlLine.RESET;
                                                                gnljnlLine.SETRANGE("Journal Template Name",'GENERAL');
                                                                gnljnlLine.SETRANGE("Journal Batch Name",'SACCOLINK');
                                                                IF gnljnlLine.FIND('-') THEN BEGIN
                                                                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",gnljnlLine);
                                                                END;
                                                                //Post New

                                                                END;


                                                                //No Linking Charges
                                                                    }
                                                              END;
                                                               }
    { 68035;  ;Home Address        ;Text50         }
    { 68036;  ;Location            ;Text50         }
    { 68037;  ;Sub-Location        ;Text50         }
    { 68038;  ;District            ;Text50         }
    { 68039;  ;Resons for Status Change;Text200    }
    { 68040;  ;Closure Notice Date ;Date           }
    { 68041;  ;Fixed Deposit Type  ;Code20        ;TableRelation="Fixed Deposit Type".Code;
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Registration Date");
                                                                IF FDType.GET("Fixed Deposit Type") THEN
                                                                "FD Maturity Date":=CALCDATE(FDType.Duration,"Registration Date");
                                                                 "Fixed Duration":=FDType.Duration;
                                                                 "Fixed duration2":=FDType."No. of Months";
                                                                 "FD Duration":=FDType."No. of Months";
                                                                 "Fixed Deposit Status":="Fixed Deposit Status"::Active;

                                                                 IF interestCalc.GET(interestCalc.Code) THEN
                                                                 "Interest rate":=interestCalc."Interest Rate";
                                                              END;
                                                               }
    { 68042;  ;Interest Earned     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Interest Buffer"."Interest Amount" WHERE (Account No=FIELD(No.)));
                                                   Editable=No }
    { 68043;  ;Untranfered Interest;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Interest Buffer"."Interest Amount" WHERE (Account No=FIELD(No.),
                                                                                                              Transferred=CONST(No)));
                                                   Editable=No }
    { 68044;  ;FD Maturity Date    ;Date          ;OnValidate=BEGIN
                                                                "FD Duration":="FD Maturity Date"-"Registration Date";
                                                                 "FD Duration":=ROUND("FD Duration"/30,1);
                                                                MODIFY;
                                                              END;
                                                               }
    { 68045;  ;Savings Account No. ;Code20         }
    { 68046;  ;Old Account No.     ;Code20         }
    { 68047;  ;Salary Processing   ;Boolean        }
    { 68048;  ;Amount to Transfer  ;Decimal       ;OnValidate=BEGIN
                                                                CALCFIELDS(Balance);
                                                                TESTFIELD("Registration Date");
                                                                {

                                                                IF AccountTypes.GET("Account Type") THEN BEGIN
                                                                IF "Account Type" = 'MUSTARD' THEN BEGIN
                                                                IF "Last Withdrawal Date" = 0D THEN BEGIN
                                                                "Last Withdrawal Date" :="Registration Date";
                                                                MODIFY;
                                                                END;

                                                                IF (CALCDATE(AccountTypes."Savings Duration","Last Withdrawal Date") > TODAY) THEN BEGIN
                                                                ERROR('You can only withdraw from this account once in %1.',AccountTypes."Savings Duration")
                                                                END ELSE BEGIN
                                                                IF "Amount to Transfer" > (Balance*0.25) THEN
                                                                ERROR('Amount cannot be more than 25 Percent of the balance. i.e. %1',(Balance*0.25));

                                                                END;

                                                                END ELSE BEGIN
                                                                IF AccountTypes."Savings Withdrawal penalty" > 0 THEN BEGIN
                                                                IF (CALCDATE(AccountTypes."Savings Duration","Registration Date") > TODAY) THEN BEGIN
                                                                IF ("Amount to Transfer"+ROUND(("Amount to Transfer"*(AccountTypes."Savings Withdrawal penalty")),1,'>')) > Balance THEN
                                                                ERROR('You cannot transfer more than %1.',Balance-ROUND((Balance*(AccountTypes."Savings Withdrawal penalty")),1,'>'));

                                                                END;

                                                                END ELSE BEGIN
                                                                IF "Amount to Transfer" > Balance THEN
                                                                MESSAGE('Amount cannot be more than the balance.');

                                                                END;
                                                                END;
                                                                END;
                                                                  }
                                                              END;
                                                               }
    { 68049;  ;Proffesion          ;Text50         }
    { 68050;  ;Signing Instructions;Text250        }
    { 68051;  ;Hide                ;Boolean        }
    { 68052;  ;Monthly Contribution;Decimal        }
    { 68053;  ;Not Qualify for Interest;Boolean    }
    { 68054;  ;Gender              ;Option        ;OptionString=Male,Female }
    { 68055;  ;Fixed Duration      ;DateFormula   ;OnValidate=BEGIN
                                                                IF "Account Type" = 'FIXED' THEN BEGIN
                                                                TESTFIELD("Registration Date");
                                                                "FD Maturity Date":=CALCDATE("Fixed Duration","Registration Date");
                                                                END;
                                                              END;
                                                               }
    { 68056;  ;System Created      ;Boolean        }
    { 68057;  ;External Account No ;Code50         }
    { 68058;  ;Bank Code           ;Code20        ;TableRelation=Banks.Code }
    { 68059;  ;Enabled             ;Boolean        }
    { 68060;  ;Current Salary      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Salary Processing Lines".Amount WHERE (Account No.=FIELD(No.),
                                                                                                           Date=FIELD(Date Filter),
                                                                                                           Processed=CONST(Yes))) }
    { 68061;  ;Defaulted Loans Recovered;Boolean   }
    { 68062;  ;Document No. Filter ;Code20        ;FieldClass=FlowFilter }
    { 68063;  ;EFT Transactions    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("EFT Details".Amount WHERE (Account No=FIELD(No.),
                                                                                               Not Available=CONST(Yes),
                                                                                               Transferred=CONST(No))) }
    { 68064;  ;Formation/Province  ;Code20        ;OnValidate=BEGIN
                                                                Vend.RESET;
                                                                Vend.SETRANGE(Vend."Staff No","Staff No");
                                                                IF Vend.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                Vend."Formation/Province":="Formation/Province";
                                                                Vend.MODIFY;
                                                                UNTIL Vend.NEXT=0;
                                                                END;
                                                              END;
                                                               }
    { 68065;  ;Division/Department ;Code20        ;TableRelation="Member Departments".No. }
    { 68066;  ;Station/Sections    ;Code20        ;TableRelation="Member Section".No. }
    { 68067;  ;Neg. Interest Rate  ;Decimal        }
    { 68068;  ;Date Renewed        ;Date           }
    { 68069;  ;Last Interest Date  ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Max("Interest Buffer"."Interest Date" WHERE (Account No=FIELD(No.))) }
    { 68070;  ;Don't Transfer to Savings;Boolean   }
    { 68071;  ;Type Of Organisation;Option        ;OptionCaptionML=ENU=" ,Club,Association,Partnership,Investment,Merry go round,Other";
                                                   OptionString=[ ,Club,Association,Partnership,Investment,Merry go round,Other] }
    { 68072;  ;Source Of Funds     ;Option        ;OptionCaptionML=ENU=" ,Business Receipts,Income from Investment,Salary,Other";
                                                   OptionString=[ ,Business Receipts,Income from Investment,Salary,Other] }
    { 68073;  ;MPESA Mobile No     ;Code20         }
    { 68074;  ;FOSA Default Dimension;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Default Dimension" WHERE (Table ID=CONST(23),
                                                                                                No.=FIELD(No.),
                                                                                                Dimension Value Code=CONST(FOSA))) }
    { 68094;  ;ATM Prov. No        ;Code18         }
    { 68095;  ;ATM Approve         ;Boolean       ;OnValidate=BEGIN
                                                                IF "ATM Approve"=TRUE THEN BEGIN
                                                                StatusPermissions.RESET;
                                                                StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                                                                StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"ATM Approval");
                                                                IF StatusPermissions.FIND('-') = FALSE THEN
                                                                ERROR('You do not have permissions to do an Atm card approval');
                                                                "Card No.":="ATM Prov. No";
                                                                "Atm card ready" := FALSE;
                                                                MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 68096;  ;Dividend Paid       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter),
                                                                                                                        Document No.=CONST(DIVIDEND),
                                                                                                                        Posting Date=CONST(03/04/11)));
                                                   CaptionML=ENU=Balance (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 68120;  ;Force No.           ;Code20         }
    { 68121;  ;Card Expiry Date    ;Date           }
    { 68122;  ;Card Valid From     ;Date           }
    { 68123;  ;Card Valid To       ;Date           }
    { 69002;  ;Service             ;Text50         }
    { 69005;  ;Reconciled          ;Boolean        }
    { 69009;  ;FD Duration         ;Integer       ;OnValidate=BEGIN
                                                                  "FD Maturity Date":="Registration Date"+("FD Duration"*30);
                                                                  MODIFY;
                                                              END;
                                                               }
    { 69010;  ;Employer P/F        ;Code20         }
    { 69017;  ;Outstanding Balance ;Decimal        }
    { 69018;  ;Atm card ready      ;Boolean       ;OnValidate=BEGIN
                                                                IF "Atm card ready"=TRUE THEN BEGIN
                                                                StatusPermissions.RESET;
                                                                StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                                                                StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"Atm card ready");
                                                                IF StatusPermissions.FIND('-') = FALSE THEN
                                                                ERROR('You do not have permission to change atm status');
                                                                END;
                                                              END;
                                                               }
    { 69019;  ;Current Shares      ;Decimal        }
    { 69020;  ;Debtor Type         ;Option        ;OptionCaptionML=ENU=,FOSA Account,Micro Finance;
                                                   OptionString=[ ,FOSA Account,Micro Finance] }
    { 69021;  ;Group Code          ;Code30         }
    { 69022;  ;Group Account       ;Boolean        }
    { 69023;  ;Shares Recovered    ;Boolean        }
    { 69024;  ;Group Balance       ;Decimal        }
    { 69025;  ;Old Bosa Acc no     ;Code30         }
    { 69026;  ;Group Loan Balance  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Transaction Type=FILTER(Repayment|Loan|Loan Adjustment),
                                                                                                        Group Code=FIELD(Group Code))) }
    { 69027;  ;ContactPerson Relation;Code20       }
    { 69028;  ;ContactPerson Occupation;Code20     }
    { 69029;  ;ContacPerson Phone  ;Text30         }
    { 69030;  ;Recruited By        ;Code20         }
    { 69031;  ;ClassB Shares       ;Decimal        }
    { 69032;  ;Date ATM Linked     ;Date           }
    { 69033;  ;ATM No.             ;Code50         }
    { 69034;  ;Reason For Blocking Account;Text50  }
    { 69035;  ;Uncleared Loans     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register"."Net Payment to FOSA" WHERE (Account No=FIELD(No.),
                                                                                                                 Posted=FILTER(Yes),
                                                                                                                 Processed Payment=FILTER(No))) }
    { 69036;  ;NetDis              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register"."Net Payment to FOSA" WHERE (Account No=FIELD(No.),
                                                                                                                 Processed Payment=FILTER(No))) }
    { 69037;  ;Transfer Amount to Savings;Decimal  }
    { 69038;  ;Notice Date         ;Date           }
    { 69039;  ;Account Frozen      ;Boolean       ;Editable=No }
    { 69040;  ;Interest rate       ;Decimal        }
    { 69041;  ;Fixed duration2     ;Integer        }
    { 69042;  ;FDR Deposit Status Type;Option     ;OptionCaptionML=ENU=New,Renewed,Terminated;
                                                   OptionString=New,Renewed,Terminated;
                                                   Editable=No }
    { 69043;  ;ATM Expiry Date     ;Date           }
    { 69044;  ;Authorised Over Draft;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Over Draft Authorisation"."Approved Amount" WHERE (Account No.=FIELD(No.),
                                                                                                                       Status=CONST(Approved),
                                                                                                                       Expired=CONST(No),
                                                                                                                       Liquidated=CONST(No),
                                                                                                                       Effective/Start Date=FIELD(Date Filter),
                                                                                                                       Posted=CONST(Yes))) }
    { 69045;  ;Net Salary          ;Decimal        }
    { 69046;  ;FD Maturity Instructions;Option    ;OptionCaptionML=ENU=" ,Transfer to Savings,Transfer Interest & Renew,Renew";
                                                   OptionString=[ ,Transfer to Savings,Transfer Interest & Renew,Renew] }
    { 69047;  ;ATM Card Approved by;Code50         }
    { 69048;  ;Disabled ATM Card No;Code18        ;Editable=No }
    { 69049;  ;Reason For Disabling ATM Card;Text200 }
    { 69050;  ;Disable ATM Card    ;Boolean       ;OnValidate=BEGIN
                                                                IF "Disable ATM Card"=TRUE THEN BEGIN

                                                                StatusPermissions.RESET;
                                                                StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                                                                StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::"29");
                                                                IF StatusPermissions.FIND('-') = FALSE THEN
                                                                ERROR('You do not have permissions to disable Atm cards');


                                                                IF "ATM No."=''THEN
                                                                ERROR('You cannot disable a blank ATM Card');

                                                                IF "Reason For Disabling ATM Card"='' THEN
                                                                ERROR('You must specify reason for disabling this atm');



                                                                "Disabled ATM Card No":="ATM No.";
                                                                "ATM No.":='';
                                                                "ATM Prov. No":='';
                                                                "Atm card ready" := FALSE;
                                                                 "Disabled By":=USERID;
                                                                MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 69051;  ;Disabled By         ;Code50         }
    { 69052;  ;Transfer Type       ;Option        ;OptionCaptionML=ENU=" ,Deposits,Share Capital,Jaza Jaza";
                                                   OptionString=[ ,Deposits,Share Capital,Jaza Jaza] }
    { 69053;  ;ATM Alert Sent      ;Boolean        }
    { 69054;  ;Old Vendor No.      ;Code10         }
    { 69055;  ;Loan No             ;Code20        ;TableRelation="Loans Register"."Loan  No." WHERE (BOSA No=FIELD(BOSA Account No),
                                                                                                     Posted=CONST(Yes),
                                                                                                     Outstanding Balance=FILTER(>0)) }
    { 69056;  ;Principle Amount    ;Decimal        }
    { 69057;  ;Interest Amount     ;Decimal        }
    { 69058;  ;Bankers Cheque Amount;Decimal       }
    { 69059;  ;Change Log          ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Change Log Entry" WHERE (Primary Key Field 1 Value=FIELD(No.))) }
    { 69060;  ;Registered M-Sacco  ;Boolean        }
    { 69061;  ;Sms Notification    ;Boolean        }
    { 69062;  ;Reason for Enabling ATM Card;Text30 }
    { 69063;  ;Enabled By          ;Code20         }
    { 69064;  ;Date Enabled        ;Date           }
    { 69065;  ;Created By          ;Code30        ;Editable=No }
    { 69066;  ;Staff UserID        ;Code25        ;TableRelation=User."User Name" }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      PurchSetup@1120054025 : Record 312;
      CommentLine@1120054024 : Record 97;
      PurchOrderLine@1120054023 : Record 39;
      PostCode@1120054022 : Record 225;
      VendBankAcc@1120054021 : Record 288;
      OrderAddr@1120054020 : Record 224;
      GenBusPostingGrp@1120054019 : Record 250;
      ItemCrossReference@1120054018 : Record 5717;
      RMSetup@1120054017 : Record 5079;
      ServiceItem@1120054016 : Record 5940;
      NoSeriesMgt@1120054015 : Codeunit 396;
      MoveEntries@1120054014 : Codeunit 361;
      UpdateContFromVend@1120054013 : Codeunit 5057;
      DimMgt@1120054012 : Codeunit 408;
      InsertFromContact@1120054011 : Boolean;
      AccountTypes@1120054010 : Record 51516295;
      FDType@1120054009 : Record 51516305;
      ReplCharge@1120054008 : Decimal;
      Vends@1120054007 : Record 23;
      gnljnlLine@1120054006 : Record 81;
      FOSAAccount@1120054005 : Record 23;
      Member@1120054004 : Record 51516223;
      Vend@1120054003 : Record 23;
      Loans@1120054002 : Record 51516230;
      StatusPermissions@1120054001 : Record 51516310;
      interestCalc@1120054000 : Record 51516306;

    BEGIN
    END.
  }
}

OBJECT Table 51516018 Receipts and Payment Types
{
  OBJECT-PROPERTIES
  {
    Date=01/31/19;
    Time=[ 2:50:11 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnDelete=BEGIN
                PayLine.RESET;
                PayLine.SETRANGE(PayLine."Interest Amount",Code);
                IF PayLine.FIND('-') THEN
                   ERROR('This Transaction Code Is Already in Use You Cannot Delete');
             END;

    LookupPageID=Page51516061;
    DrillDownPageID=Page51516061;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text100       ;OnValidate=BEGIN

                                                                  PayLine.RESET;
                                                                 PayLine.SETRANGE(PayLine."Interest Amount",Code);
                                                                 IF PayLine.FIND('-') THEN
                                                                    ERROR('This Transaction Code Is Already in Use You cannot Modify');

                                                                 PayLine.RESET;
                                                                 PayLine.SETRANGE(PayLine."Interest Amount",Code);
                                                                 IF PayLine.FIND('-') THEN
                                                                    ERROR('This Transaction Code Is Already in Use You Cannot Delete');
                                                              END;
                                                               }
    { 3   ;   ;Account Type        ;Option        ;OnValidate=BEGIN
                                                                IF "Account Type"="Account Type"::"G/L Account" THEN
                                                                  "Direct Expense":=TRUE
                                                                 ELSE
                                                                    "Direct Expense":=FALSE;

                                                                  PayLine.RESET;
                                                                 PayLine.SETRANGE(PayLine."Interest Amount",Code);
                                                                 IF PayLine.FIND('-') THEN
                                                                    ERROR('This Transaction Code Is Already in Use You cannot Modify');
                                                              END;

                                                   CaptionML=ENU=Account Type;
                                                   OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,None;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,None }
    { 4   ;   ;Type                ;Option        ;OptionString=[ ,Receipt,Payment,Imprest,Claim,Advance];
                                                   NotBlank=Yes }
    { 5   ;   ;VAT Chargeable      ;Option        ;OptionString=No,Yes }
    { 6   ;   ;Withholding Tax Chargeable;Option  ;OptionString=No,Yes }
    { 7   ;   ;VAT Code            ;Code20        ;TableRelation="Tariff Codes" }
    { 8   ;   ;Withholding Tax Code;Code20        ;TableRelation="Tariff Codes" }
    { 9   ;   ;Default Grouping    ;Code20        ;TableRelation=IF (Account Type=CONST(Customer)) "Customer Posting Group"
                                                                 ELSE IF (Account Type=CONST(Vendor)) "Vendor Posting Group" }
    { 10  ;   ;G/L Account         ;Code20        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account".No.;
                                                   OnValidate=BEGIN
                                                                GLAcc.RESET;
                                                                IF GLAcc.GET("G/L Account") THEN
                                                                BEGIN
                                                                "G/L Account Name":=GLAcc.Name;
                                                                IF Type=Type::Payment THEN
                                                                   GLAcc.TESTFIELD(GLAcc."Budget Controlled",TRUE);

                                                                IF GLAcc."Direct Posting"=FALSE THEN
                                                                  BEGIN
                                                                    ERROR('Direct Posting must be True');
                                                                  END;
                                                                END;

                                                                 PayLine.RESET;
                                                                 PayLine.SETRANGE(PayLine."Interest Amount",Code);
                                                                 IF PayLine.FIND('-') THEN
                                                                    //ERROR('This Transaction Code Is Already in Use You Cannot Delete');
                                                              END;
                                                               }
    { 11  ;   ;Pending Voucher     ;Boolean        }
    { 12  ;   ;Bank Account        ;Code20        ;TableRelation="Bank Account";
                                                   OnValidate=BEGIN
                                                                IF "Account Type"<>"Account Type"::"Bank Account" THEN
                                                                  BEGIN
                                                                    ERROR('You can only enter Bank No where Account Type is Bank Account');
                                                                  END;
                                                              END;
                                                               }
    { 13  ;   ;Transation Remarks  ;Text250       ;NotBlank=Yes }
    { 14  ;   ;Payment Reference   ;Option        ;OptionString=Normal,Farmer Purchase,Grant }
    { 15  ;   ;Customer Payment On Account;Boolean }
    { 16  ;   ;Direct Expense      ;Boolean       ;Editable=No }
    { 17  ;   ;Calculate Retention ;Option        ;OptionString=No,Yes }
    { 18  ;   ;Retention Code      ;Code20        ;TableRelation="Tariff Codes" }
    { 19  ;   ;Blocked             ;Boolean        }
    { 20  ;   ;Based On Travel Rates Table;Boolean }
    { 21  ;   ;VAT Withheld Code   ;Code10        ;TableRelation="Tariff Codes".Code }
    { 22  ;   ;G/L Account Name    ;Text100        }
    { 24  ;   ;code1               ;Code30         }
    { 29  ;   ;Posted              ;Boolean        }
  }
  KEYS
  {
    {    ;Code,Type                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      GLAcc@1102758000 : Record 15;
      PayLine@1102755000 : Record 51516001;

    BEGIN
    END.
  }
}

OBJECT Table 51516019 CheckoffAdvice Product Codes
{
  OBJECT-PROPERTIES
  {
    Date=10/14/20;
    Time=12:44:27 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;EntryNo             ;Integer       ;AutoIncrement=Yes;
                                                   Editable=No }
    { 2   ;   ;CheckoffAdvise Code ;Code10         }
    { 3   ;   ;Product Code        ;Code10        ;TableRelation="Loan Products Setup".Code }
    { 4   ;   ;Monthly Ded or RunningBalance;Option;
                                                   OptionCaptionML=ENU=" ,Monthly Deduction,Running Balance";
                                                   OptionString=[ ,Monthly Deduction,Running Balance] }
    { 5   ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=" ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated";
                                                   OptionString=[ ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated] }
    { 6   ;   ;Employer Code       ;Code20        ;TableRelation="Sacco Employers" }
  }
  KEYS
  {
    {    ;EntryNo                                 ;Clustered=Yes }
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

OBJECT Table 51516020 Checkoff Advise Updates
{
  OBJECT-PROPERTIES
  {
    Date=12/16/20;
    Time=[ 3:04:32 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               "Date Entered":=CURRENTDATETIME;
               "Advice Date":=TODAY;
               "Entered By":=USERID;
             END;

  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer       ;AutoIncrement=Yes }
    { 2   ;   ;Member No           ;Code20        ;TableRelation="Members Register" WHERE (Status=FILTER(Active|Dormant));
                                                   OnValidate=BEGIN
                                                                MembersRegister.GET("Member No");
                                                                "Member Name":=MembersRegister.Name;
                                                                "Staff No":=MembersRegister."Payroll/Staff No";
                                                                "Employer Code":=MembersRegister."Employer Code";
                                                              END;
                                                               }
    { 3   ;   ;Member Name         ;Text100       ;Editable=No }
    { 4   ;   ;Staff No            ;Code30        ;Editable=No }
    { 5   ;   ;Employer Code       ;Code50        ;Editable=No }
    { 6   ;   ;Product Type        ;Code20        ;TableRelation="Loan Products Setup";
                                                   Editable=No }
    { 7   ;   ;Loan Number         ;Code20        ;TableRelation="Loans Register"."Loan  No." WHERE (Client Code=FIELD(Member No),
                                                                                                     Outstanding Balance=FILTER(>0));
                                                   OnValidate=BEGIN
                                                                "Product Type":='';
                                                                Amount:=0;
                                                                IF "Loan Number"<>'' THEN BEGIN
                                                                    TESTFIELD("Member No");
                                                                    TESTFIELD(Rec."Savings Product",Rec."Savings Product"::" ");
                                                                    LoansRegister.GET("Loan Number");
                                                                    "Product Type":=LoansRegister."Loan Product Type";
                                                                    Amount := LoansRegister.Repayment;
                                                                END;
                                                              END;
                                                               }
    { 8   ;   ;Savings Product     ;Option        ;OnValidate=VAR
                                                                err_loan@1120054000 : TextConst 'ENU=Loan numbers must be empty';
                                                              BEGIN
                                                                TESTFIELD("Member No");
                                                                IF "Loan Number"<>'' THEN
                                                                  ERROR(err_loan);
                                                                MembersRegister.GET("Member No");
                                                                Amount:=0;
                                                                CASE "Savings Product" OF
                                                                    Rec."Savings Product"::"Deposit Contribution": Amount := MembersRegister."Monthly Contribution";
                                                                    Rec."Savings Product"::"SchFee Shares": Amount := MembersRegister."School Fees Shares";
                                                                  END;
                                                              END;

                                                   OptionCaptionML=ENU=" ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated";
                                                   OptionString=[ ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated] }
    { 9   ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=EFFECT,VARIATION,ADJUSTMENT LOAN,CEASE,OFFSET;
                                                   OptionString=EFFECT,VARIATION,ADJUSTMENT LOAN,CEASE,OFFSET }
    { 10  ;   ;Advice Date         ;Date           }
    { 11  ;   ;Entered By          ;Code30        ;Editable=No }
    { 12  ;   ;Date Entered        ;DateTime      ;Editable=No }
    { 13  ;   ;Amount              ;Decimal        }
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
    VAR
      MembersRegister@1120054000 : Record 51516223;
      LoansRegister@1120054001 : Record 51516230;

    BEGIN
    END.
  }
}

OBJECT Table 51516022 HR CV Details
{
  OBJECT-PROPERTIES
  {
    Date=10/27/20;
    Time=11:04:59 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer        }
    { 2   ;   ;Employee No         ;Code10         }
    { 3   ;   ;Qualification Code  ;Code10        ;TableRelation=Table51516023 }
    { 4   ;   ;Description         ;Text250        }
    { 5   ;   ;Attachment          ;BLOB          ;SubType=Bitmap }
  }
  KEYS
  {
    {    ;Employee No,Entry No                    ;Clustered=Yes }
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

OBJECT Table 51516024 HR Next Of Kin
{
  OBJECT-PROPERTIES
  {
    Date=10/27/20;
    Time=10:46:32 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Employee Code       ;Code10         }
    { 2   ;   ;Entry No            ;Integer        }
    { 3   ;   ;Name                ;Text100        }
    { 4   ;   ;Contact             ;Code20         }
    { 5   ;   ;Residence           ;Text100        }
    { 6   ;   ;Address             ;Text100        }
  }
  KEYS
  {
    {    ;Employee Code,Entry No                  ;Clustered=Yes }
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

OBJECT Table 51516026 Company Documents
{
  OBJECT-PROPERTIES
  {
    Date=11/02/20;
    Time=12:50:03 PM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "Doc No." = '' THEN BEGIN
                 HRSetup.GET;
                 HRSetup.TESTFIELD("Company Documents");
                 NoSeriesMgt.InitSeries(HRSetup."Company Documents",xRec."No. Series",0D,"Doc No.","No. Series");
               END;
             END;

  }
  FIELDS
  {
    { 1   ;   ;Doc No.             ;Code20         }
    { 2   ;   ;Document Description;Text200       ;OnValidate=BEGIN
                                                                CompanyDocs.RESET;
                                                                CompanyDocs.SETRANGE("Document Description","Document Description");
                                                                IF CompanyDocs.FINDFIRST THEN ERROR('Document already exists');
                                                              END;

                                                   NotBlank=Yes }
    { 3   ;   ;Document Link       ;Text200        }
    { 6   ;   ;Attachment No.      ;Integer       ;AutoIncrement=Yes;
                                                   Editable=No }
    { 7   ;   ;Language Code (Default);Code10     ;TableRelation=Language }
    { 8   ;   ;Attachment          ;Option        ;OptionString=No,Yes;
                                                   Editable=No }
    { 9   ;   ;No. Series          ;Code20         }
    { 10  ;   ;Type                ;Option        ;OptionCaptionML=ENU=Company,Leave;
                                                   OptionString=Company,Leave }
  }
  KEYS
  {
    {    ;Doc No.,Document Description            ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CompanyDocs@1102755000 : Record 51516026;
      HRSetup@1102755001 : Record 51516192;
      NoSeriesMgt@1102755002 : Codeunit 396;

    BEGIN
    END.
  }
}

OBJECT Table 51516027 HR Absence and Holiday
{
  OBJECT-PROPERTIES
  {
    Date=11/03/20;
    Time=12:59:37 PM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    DataCaptionFields=Employee No.,Start Date,End Date,Days Lost,Reason,Cost,% On Cost,Additional Cost,Total Cost;
    OnInsert=BEGIN
                     {OK:= Employee.GET("Employee No.");
                     IF OK THEN BEGIN
                      "Employee First Name":= Employee."First Name";
                      "Employee Last Name":= Employee."Last Name";
                      "Job Title":= Employee."Job Title";
                      Department:= Employee."Department Code";

                     END; }
             END;

  }
  FIELDS
  {
    { 1   ;   ;Employee No.        ;Code20        ;TableRelation="HR Employees".No.;
                                                   OnValidate=BEGIN
                                                                            {
                                                                            OK:= Employee.GET("Employee No.");
                                                                            IF OK THEN BEGIN
                                                                              "Job Title":= Employee.Position;
                                                                              Department:= Employee."Department Code";
                                                                             "Employee First Name":= Employee."First Name";
                                                                              "Employee Last Name":= Employee."Last Name";
                                                                            END;
                                                                            }
                                                              END;
                                                               }
    { 2   ;   ;Start Date          ;Date          ;OnValidate=VAR
                                                                "lRec Employee"@1000000000 : Record 51516160;
                                                                "lRec Job Budget Entry"@1000000001 : Record 96;
                                                              BEGIN
                                                                 {
                                                                   IF (("End Date" <> 0D) AND ("Start Date" <> 0D)) THEN BEGIN
                                                                   IF DifDates.ReservedDates("Start Date","End Date","Employee No.") THEN
                                                                   MESSAGE('The time between %1 and %2 is already scheduled for employee %3',"Start Date","End Date","Employee No.");
                                                                                   "Days Lost":= DifDates.DifferenceStartEnd("Start Date","End Date");
                                                                                 {   CompPayPer.FIND('-');
                                                                                   "Hours Lost":= ("Days Lost") * (CompPayPer."Working Hours Per Day");

                                                                                    Employee.SETFILTER("No.","Employee No.");
                                                                                    Employee.GET("Employee No.");
                                                                                    IF (CompPayPer."Working Days Per Year" = 0) THEN
                                                                                     MESSAGE('Enter the amount of working days per year in the Company Pay Periods Screen! (Setup)')
                                                                                    ELSE IF (Employee."Contracted Hours" = 0) THEN
                                                                                     MESSAGE('Amount of contracted hours must be entered onto the employee details screen!')
                                                                                    ELSE BEGIN
                                                                                    HourlyRate:= (Employee."Per Annum"/CompPayPer."Working Days Per Year")/(Employee."Contracted Hours"/5);
                                                                                    Cost:= ("Hours Lost") * (HourlyRate);
                                                                                    END;
                                                                                    }
                                                                                    "Total Cost":= Cost;

                                                                  END;
                                                                  }
                                                                  //commented by linus
                                                                  {
                                                                  IF "lRec Employee".GET ("Employee No.") THEN BEGIN
                                                                     IF "lRec Employee"."Resource No." <> '' THEN BEGIN
                                                                        "lRec Job Budget Entry".SETRANGE("lRec Job Budget Entry".Type,"lRec Job Budget Entry".Type::Resource);
                                                                        "lRec Job Budget Entry".SETRANGE("lRec Job Budget Entry"."No.","lRec Employee"."Resource No.");
                                                                        "lRec Job Budget Entry".SETRANGE("lRec Job Budget Entry".Date,"Start Date");
                                                                        IF "lRec Job Budget Entry".FIND('-') THEN
                                                                          ERROR ('The employee is already booked for %1 on Job number %2!',"lRec Job Budget Entry".Date,
                                                                                "lRec Job Budget Entry"."Job No.");

                                                                       END;
                                                                    END;
                                                                 }
                                                              END;
                                                               }
    { 3   ;   ;End Date            ;Date          ;OnValidate=VAR
                                                                "lRec Job budget Entry"@1000000000 : Record 96;
                                                                "lRec Employee"@1000000001 : Record 51516160;
                                                              BEGIN
                                                                 {
                                                                  IF DifDates.ReservedDates("Start Date","End Date","Employee No.") THEN
                                                                   MESSAGE('The time between %1 and %2 is already scheduled for employee %3',"Start Date","End Date","Employee No.");
                                                                                   "Days Lost":= DifDates.DifferenceStartEnd("Start Date","End Date");
                                                                                    CompPayPer.FIND('-');
                                                                                                     {

                                                                                 // "Hours Lost":= ("Days Lost") * (CompPayPer."Working Hours Per Day");

                                                                                    Employee.SETFILTER("No.","Employee No.");
                                                                                    Employee.GET("Employee No.");
                                                                                    IF (CompPayPer."Working Days Per Year" = 0) THEN
                                                                                     ERROR('Enter the amount of working days per year in the Company Pay Periods Screen! (Setup)')
                                                                                    ELSE IF (Employee."Contracted Hours" = 0) THEN
                                                                                     ERROR('Amount of contracted hours must be entered onto the employee details screen!')
                                                                                    ELSE BEGIN
                                                                                    HourlyRate:= (Employee."Per Annum"/CompPayPer."Working Days Per Year")/(Employee."Contracted Hours"/5);
                                                                                    Cost:= ("Hours Lost") * (HourlyRate);
                                                                                    END;
                                                                                    }
                                                                                    "Total Cost":= Cost;


                                                                  IF "Start Date" = 0D THEN
                                                                    ERROR ('You must spesify the Start Date!');
                                                                }

                                                                  //commented by linus
                                                                  {
                                                                  IF "lRec Employee".GET ("Employee No.") THEN BEGIN
                                                                     IF "lRec Employee"."Resource No." <> '' THEN BEGIN
                                                                       "lRec Job budget Entry".SETRANGE("lRec Job budget Entry".Type,"lRec Job budget Entry".Type::Resource);
                                                                       "lRec Job budget Entry".SETRANGE("lRec Job budget Entry"."No.","lRec Employee"."Resource No.");
                                                                       "lRec Job budget Entry".SETRANGE("lRec Job budget Entry".Date,"Start Date","End Date");
                                                                       IF "lRec Job budget Entry".FIND('-') THEN
                                                                        ERROR ('The employee is already booked for %1 on Job number %2!',"lRec Job budget Entry".Date,
                                                                               "lRec Job budget Entry"."Job No.");


                                                                     END;
                                                                   END;
                                                                  }


                                                                //"Days Lost":="End Date"-"Start Date" ;
                                                                MESSAGE('%1',"Days Lost");
                                                              END;
                                                               }
    { 4   ;   ;Days Lost           ;Integer       ;OnValidate=BEGIN
                                                                                 {
                                                                                   {  CompPayPer.FIND('-');
                                                                                   "Hours Lost":= ("Days Lost") * (CompPayPer."Working Hours Per Day");

                                                                                    Employee.SETFILTER("No.","Employee No.");
                                                                                    Employee.GET("Employee No.");
                                                                                    IF (CompPayPer."Working Days Per Year" = 0) THEN
                                                                                     MESSAGE('Enter the amount of working days per year in the Company Pay Periods Screen! (Setup)')
                                                                                    ELSE IF (Employee."Contracted Hours" = 0) THEN
                                                                                     MESSAGE('Amount of contracted hours must be entered onto the employee details screen!')
                                                                                    ELSE BEGIN
                                                                                    HourlyRate:= (Employee."Per Annum"/CompPayPer."Working Days Per Year")/(Employee."Contracted Hours"/5);
                                                                                    Cost:= ("Hours Lost") * (HourlyRate);
                                                                                    END;
                                                                                    "Total Cost":= Cost;
                                                                                   }

                                                                                  // companyinfo.FIND('-');
                                                                                   "Hours Lost":= ("Days Lost") * (companyinfo."Working Hours Per Day");
                                                                                    emp.GET("Employee No.");
                                                                //                    Cost:= "Days Lost" * emp."Daily Rate";

                                                                                    "Total Cost":= Cost;
                                                                                    }
                                                              END;
                                                               }
    { 5   ;   ;Reason              ;Option        ;OptionString=Holiday,Sick Leave,Training,Unauthorised,Maternity }
    { 7   ;   ;Cost                ;Decimal       ;OnValidate=BEGIN
                                                                             "Total Cost":= Cost + "% On Cost" + "Additional Cost";
                                                              END;
                                                               }
    { 8   ;   ;% On Cost           ;Decimal       ;OnValidate=BEGIN
                                                                             "Total Cost":= Cost + "% On Cost" + "Additional Cost";
                                                              END;
                                                               }
    { 9   ;   ;Additional Cost     ;Decimal       ;OnValidate=BEGIN
                                                                             "Total Cost":= Cost + "% On Cost" + "Additional Cost";
                                                              END;
                                                               }
    { 10  ;   ;Total Cost          ;Decimal        }
    { 11  ;   ;Hours Lost          ;Integer        }
    { 12  ;   ;Job Title           ;Text30         }
    { 13  ;   ;Department          ;Code10         }
    { 14  ;   ;Employee First Name ;Text30         }
    { 15  ;   ;Employee Last Name  ;Text30         }
    { 16  ;   ;Resource No.        ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("HR Employees"."Resource No." WHERE (No.=FIELD(Employee No.))) }
    { 17  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("HR Human Resource Comments" WHERE (Table Name=CONST(Absence and Holiday),
                                                                                                         No.=FIELD(Employee No.),
                                                                                                         Key Date=FIELD(Start Date)));
                                                   Editable=No }
    { 18  ;   ;Line No             ;Integer        }
  }
  KEYS
  {
    {    ;Employee No.,Line No                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CompPayPer@1000000001 : Record 51516223;
      Employee@1000000002 : Record 51516160;
      HourlyRate@1000000003 : Decimal;
      OK@1000000004 : Boolean;
      emp@1000000005 : Record 51516160;
      companyinfo@1000000006 : Record 79;

    BEGIN
    END.
  }
}

OBJECT Table 51516028 HR Non Working Days & Dates
{
  OBJECT-PROPERTIES
  {
    Date=11/03/20;
    Time=[ 1:07:33 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Non Working Days    ;Code10         }
    { 2   ;   ;Non Working Dates   ;Date           }
    { 3   ;   ;Code                ;Integer       ;AutoIncrement=Yes }
    { 4   ;   ;Reason              ;Text30         }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
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

OBJECT Table 51516030 Funds General Setup
{
  OBJECT-PROPERTIES
  {
    Date=10/02/15;
    Time=12:07:52 PM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Primary Key         ;Integer        }
    { 11  ;   ;Payment Voucher Nos ;Code20        ;TableRelation="No. Series".Code }
    { 12  ;   ;Cash Voucher Nos    ;Code20        ;TableRelation="No. Series".Code }
    { 13  ;   ;PettyCash Nos       ;Code20        ;TableRelation="No. Series".Code }
    { 14  ;   ;Mobile Payment Nos  ;Code20        ;TableRelation="No. Series".Code }
    { 15  ;   ;Receipt Nos         ;Code20        ;TableRelation="No. Series".Code }
    { 16  ;   ;Funds Transfer Nos  ;Code20        ;TableRelation="No. Series".Code }
    { 17  ;   ;Imprest Nos         ;Code20        ;TableRelation="No. Series".Code }
    { 18  ;   ;Imprest Surrender Nos;Code20       ;TableRelation="No. Series".Code }
    { 19  ;   ;Claim Nos           ;Code20        ;TableRelation="No. Series".Code }
    { 20  ;   ;Travel Advance Nos  ;Code20        ;TableRelation="No. Series".Code }
    { 21  ;   ;Travel Surrender Nos;Code20        ;TableRelation="No. Series".Code }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
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

OBJECT Table 51516031 Funds User Setup
{
  OBJECT-PROPERTIES
  {
    Date=05/26/16;
    Time=[ 2:31:12 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;UserID              ;Code50        ;OnValidate=BEGIN
                                                                UserManager.ValidateUserID(UserID);
                                                              END;

                                                   OnLookup=BEGIN
                                                              UserManager.LookupUserID(UserID);
                                                            END;

                                                   NotBlank=Yes }
    { 11  ;   ;Receipt Journal Template;Code20    ;TableRelation="Gen. Journal Template".Name }
    { 12  ;   ;Receipt Journal Batch;Code20       ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Receipt Journal Template));
                                                   OnValidate=BEGIN
                                                                {Check if the batch has been allocated to another user}
                                                                UserTemp.RESET;
                                                                UserTemp.SETRANGE(UserTemp."Receipt Journal Template","Receipt Journal Template");
                                                                UserTemp.SETRANGE(UserTemp."Receipt Journal Batch","Receipt Journal Batch");
                                                                IF UserTemp.FINDFIRST THEN BEGIN
                                                                  REPEAT
                                                                    IF (UserTemp.UserID<>UserID) AND ("Receipt Journal Batch"<>'') THEN BEGIN
                                                                          ERROR(SameBatch,"Receipt Journal Batch");
                                                                    END;
                                                                  UNTIL UserTemp.NEXT=0;
                                                                END;
                                                              END;
                                                               }
    { 13  ;   ;Payment Journal Template;Code20    ;TableRelation="Gen. Journal Template".Name WHERE (Type=CONST(Payments)) }
    { 14  ;   ;Payment Journal Batch;Code20       ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Payment Journal Template));
                                                   OnValidate=BEGIN
                                                                //Check if the batch has been allocated to another user
                                                                UserTemp.RESET;
                                                                UserTemp.SETRANGE(UserTemp."Payment Journal Template","Payment Journal Template");
                                                                UserTemp.SETRANGE(UserTemp."Payment Journal Batch","Payment Journal Batch");
                                                                IF UserTemp.FINDFIRST THEN BEGIN
                                                                   REPEAT
                                                                    IF (UserTemp.UserID<>Rec.UserID) AND ("Payment Journal Batch"<>'') THEN BEGIN
                                                                       ERROR(SameBatch,"Receipt Journal Batch","Payment Journal Batch");
                                                                    END;
                                                                   UNTIL UserTemp.NEXT=0;
                                                                END;
                                                              END;
                                                               }
    { 15  ;   ;Petty Cash Template ;Code20        ;TableRelation="Gen. Journal Template".Name WHERE (Type=CONST(Payments)) }
    { 16  ;   ;Petty Cash Batch    ;Code20        ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Petty Cash Template));
                                                   OnValidate=BEGIN
                                                                //Check if the batch has been allocated to another user
                                                                UserTemp.RESET;
                                                                UserTemp.SETRANGE(UserTemp."Petty Cash Template","Petty Cash Template");
                                                                UserTemp.SETRANGE(UserTemp."Petty Cash Batch","Petty Cash Batch");
                                                                IF UserTemp.FINDFIRST THEN BEGIN
                                                                   REPEAT
                                                                    IF (UserTemp.UserID<>Rec.UserID) AND ("Petty Cash Batch"<>'') THEN BEGIN
                                                                       ERROR(SameBatch,"Receipt Journal Batch","Petty Cash Batch");
                                                                    END;
                                                                   UNTIL UserTemp.NEXT=0;
                                                                END;
                                                              END;
                                                               }
    { 17  ;   ;FundsTransfer Template Name;Code20 ;TableRelation="Gen. Journal Template".Name WHERE (Type=CONST(Payments)) }
    { 18  ;   ;FundsTransfer Batch Name;Code20    ;OnValidate=BEGIN
                                                                //Check if the batch has been allocated to another user
                                                                UserTemp.RESET;
                                                                UserTemp.SETRANGE(UserTemp."FundsTransfer Template Name","FundsTransfer Template Name");
                                                                UserTemp.SETRANGE(UserTemp."FundsTransfer Batch Name","FundsTransfer Batch Name");
                                                                IF UserTemp.FINDFIRST THEN BEGIN
                                                                   REPEAT
                                                                    IF(UserTemp.UserID<>Rec.UserID) AND ("FundsTransfer Batch Name"<>'') THEN BEGIN
                                                                         ERROR(SameBatch,"Receipt Journal Batch","Petty Cash Batch");
                                                                    END;
                                                                   UNTIL UserTemp.NEXT=0;
                                                                END;
                                                              END;
                                                               }
    { 19  ;   ;Default Receipts Bank;Code20       ;TableRelation="Bank Account".No.;
                                                   OnValidate=BEGIN
                                                                {Check if the batch has been allocated to another user}
                                                                {UserTemp.RESET;
                                                                UserTemp.SETRANGE(UserTemp."Default Receipts Bank","Default Receipts Bank");
                                                                IF UserTemp.FINDFIRST THEN
                                                                  BEGIN
                                                                    REPEAT
                                                                      IF UserTemp.UserID<>Rec.UserID THEN
                                                                        BEGIN
                                                                          ERROR('Please note that another user has been assigned the same bank.');
                                                                        END;
                                                                    UNTIL UserTemp.NEXT=0;
                                                                  END;
                                                                 }
                                                              END;
                                                               }
    { 20  ;   ;Default Payment Bank;Code20        ;TableRelation="Bank Account";
                                                   OnValidate=BEGIN
                                                                {Check if the batch has been allocated to another user}
                                                                {UserTemp.RESET;
                                                                UserTemp.SETRANGE(UserTemp."Default Payment Bank","Default Payment Bank");
                                                                IF UserTemp.FINDFIRST THEN
                                                                  BEGIN
                                                                    REPEAT
                                                                      IF UserTemp.UserID<>Rec.UserID THEN
                                                                        BEGIN
                                                                          ERROR('Please note that another user has been assigned the same bank.');
                                                                        END;
                                                                    UNTIL UserTemp.NEXT=0;
                                                                  END;
                                                                 }
                                                              END;
                                                               }
    { 21  ;   ;Default Petty Cash Bank;Code20     ;TableRelation="Bank Account".No.;
                                                   OnValidate=BEGIN
                                                                {Check if the batch has been allocated to another user}
                                                                {UserTemp.RESET;
                                                                UserTemp.SETRANGE(UserTemp."Default Petty Cash Bank","Default Petty Cash Bank");
                                                                IF UserTemp.FINDFIRST THEN
                                                                  BEGIN
                                                                    REPEAT
                                                                      IF UserTemp.UserID<>Rec.UserID THEN
                                                                        BEGIN
                                                                          ERROR('Please note that another user has been assigned the same bank.');
                                                                        END;
                                                                    UNTIL UserTemp.NEXT=0;
                                                                  END;
                                                                 }
                                                              END;
                                                               }
    { 22  ;   ;Max. Cash Collection;Decimal        }
    { 23  ;   ;Max. Cheque Collection;Decimal      }
    { 24  ;   ;Max. Deposit Slip Collection;Decimal }
    { 25  ;   ;Supervisor ID       ;Code50        ;OnValidate=BEGIN
                                                                {LoginMgt.ValidateUserID("Supervisor ID");}
                                                              END;

                                                   OnLookup=BEGIN
                                                              {LoginMgt.LookupUserID("Supervisor ID");}
                                                            END;
                                                             }
    { 26  ;   ;Bank Pay In Journal Template;Code20;TableRelation="Gen. Journal Template".Name WHERE (Type=CONST(General)) }
    { 27  ;   ;Bank Pay In Journal Batch;Code20   ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Bank Pay In Journal Template));
                                                   OnValidate=BEGIN
                                                                {Check if the batch has been allocated to another user}
                                                                {UserTemp.RESET;
                                                                UserTemp.SETRANGE(UserTemp."Bank Pay In Journal Template","Bank Pay In Journal Template");
                                                                UserTemp.SETRANGE(UserTemp."Bank Pay In Journal Batch","Bank Pay In Journal Batch");
                                                                IF UserTemp.FINDFIRST THEN
                                                                  BEGIN
                                                                    REPEAT
                                                                      IF UserTemp.UserID<>Rec.UserID THEN
                                                                        BEGIN
                                                                          ERROR('Please note that another user has been assigned the same batch.');
                                                                        END;
                                                                    UNTIL UserTemp.NEXT=0;
                                                                  END;
                                                                 }
                                                              END;
                                                               }
    { 28  ;   ;Imprest Template    ;Code20        ;TableRelation="Gen. Journal Template" }
    { 29  ;   ;Imprest  Batch      ;Code20        ;TableRelation="Gen. Journal Batch".Name }
    { 30  ;   ;Claim Template      ;Code20        ;TableRelation="Gen. Journal Template" }
    { 31  ;   ;Claim  Batch        ;Code20        ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Claim Template)) }
    { 32  ;   ;Advance Template    ;Code20        ;TableRelation="Gen. Journal Template" }
    { 33  ;   ;Advance  Batch      ;Code20        ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Advance Template)) }
    { 34  ;   ;Advance Surr Template;Code20       ;TableRelation="Gen. Journal Template" }
    { 35  ;   ;Advance Surr Batch  ;Code20        ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Advance Surr Template)) }
    { 36  ;   ;Dim Change Journal Template;Code20 ;TableRelation="Gen. Journal Template".Name WHERE (Type=CONST(General)) }
    { 37  ;   ;Dim Change Journal Batch;Code20    ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Dim Change Journal Template));
                                                   OnValidate=BEGIN
                                                                {Check if the batch has been allocated to another user}
                                                                {UserTemp.RESET;
                                                                UserTemp.SETRANGE(UserTemp."Payment Journal Template","Payment Journal Template");
                                                                UserTemp.SETRANGE(UserTemp."Payment Journal Batch","Payment Journal Batch");
                                                                IF UserTemp.FINDFIRST THEN
                                                                  BEGIN
                                                                    REPEAT
                                                                IF (UserTemp.UserID<>Rec.UserID) AND ("Payment Journal Batch"<>'') THEN
                                                                        BEGIN
                                                                          ERROR('Please note that another user has been assigned the same batch.');
                                                                        END;
                                                                    UNTIL UserTemp.NEXT=0;
                                                                  END;
                                                                 }
                                                              END;
                                                               }
    { 38  ;   ;Journal Voucher Template;Code20    ;TableRelation="Gen. Journal Template".Name WHERE (Type=CONST(General)) }
    { 39  ;   ;Journal Voucher Batch;Code20       ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Journal Voucher Template)) }
    { 40  ;   ;Checkoff Template   ;Code20        ;TableRelation="Gen. Journal Template".Name }
    { 41  ;   ;Checkoff Batch      ;Code20        ;TableRelation="Gen. Journal Batch".Name }
    { 42  ;   ;Payroll Template    ;Code20         }
    { 43  ;   ;Payroll Batch       ;Code20         }
  }
  KEYS
  {
    {    ;UserID                                  ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      UserTemp@1000 : Record 51516031;
      UserManager@1001 : Codeunit 418;
      SameBatch@1002 : TextConst 'ENU=Another User has been assign to the batch:%1';

    BEGIN
    END.
  }
}

OBJECT Table 51516032 Funds Transaction Types
{
  OBJECT-PROPERTIES
  {
    Date=11/05/20;
    Time=12:52:48 PM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Transaction Code    ;Code30         }
    { 11  ;   ;Transaction Description;Text50      }
    { 12  ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=Payment,Receipt,Imprest,Claim;
                                                   OptionString=Payment,Receipt,Imprest,Claim;
                                                   Editable=No }
    { 13  ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor }
    { 14  ;   ;Account No          ;Code20        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Account Type=CONST(Investor)) "Profitability Set up-Micro";
                                                   OnValidate=BEGIN
                                                                   IF "Account Type"="Account Type"::"G/L Account" THEN BEGIN
                                                                      "G/L Account".RESET;
                                                                      "G/L Account".SETRANGE("G/L Account"."No.","Account No");
                                                                      IF "G/L Account".FINDFIRST THEN BEGIN
                                                                        "Account Name":="G/L Account".Name;
                                                                      END;
                                                                   END;
                                                                   IF "Account Type"="Account Type"::Customer THEN BEGIN
                                                                      Customer.RESET;
                                                                      Customer.SETRANGE(Customer."No.","Account No");
                                                                      IF Customer.FINDFIRST THEN BEGIN
                                                                        "Account Name":=Customer.Name;
                                                                      END;
                                                                   END;
                                                                   IF "Account Type"="Account Type"::Vendor THEN BEGIN
                                                                      Vendor.RESET;
                                                                      Vendor.SETRANGE(Vendor."No.","Account No");
                                                                      IF Vendor.FINDFIRST THEN BEGIN
                                                                        "Account Name":=Vendor.Name;
                                                                      END;
                                                                   END;
                                                                   IF "Account Type"="Account Type"::Investor THEN BEGIN
                                                                      Investor.RESET;
                                                                      Investor.SETRANGE(Investor.Code,"Account No");
                                                                      IF Investor.FINDFIRST THEN BEGIN
                                                                        "Account Name":=Investor.Description;
                                                                      END;
                                                                   END;

                                                                   IF "Account No"='' THEN
                                                                    "Account Name":='';
                                                              END;
                                                               }
    { 15  ;   ;Account Name        ;Text50        ;Editable=No }
    { 16  ;   ;Default Grouping    ;Code20        ;TableRelation=IF (Account Type=CONST(Customer)) "Customer Posting Group"
                                                                 ELSE IF (Account Type=CONST(Vendor)) "Vendor Posting Group"
                                                                 ELSE IF (Account Type=CONST(Investor)) "Investor Posting Group"
                                                                 ELSE IF (Account Type=CONST(Bank Account)) "Bank Account Posting Group"
                                                                 ELSE IF (Account Type=CONST(Fixed Asset)) "FA Posting Group" }
    { 17  ;   ;VAT Chargeable      ;Boolean        }
    { 18  ;   ;VAT Code            ;Code20        ;TableRelation="Funds Tax Codes"."Tax Code" WHERE (Type=CONST(VAT)) }
    { 19  ;   ;Withholding Tax Chargeable;Boolean  }
    { 20  ;   ;Withholding Tax Code;Code20        ;TableRelation="Funds Tax Codes"."Tax Code" WHERE (Type=CONST(W/Tax)) }
    { 21  ;   ;Retention Chargeable;Boolean        }
    { 22  ;   ;Retention Code      ;Code20         }
    { 23  ;   ;Legal Fee Chargeable;Boolean        }
    { 24  ;   ;Legal Fee Code      ;Code20        ;TableRelation="Funds Tax Codes"."Tax Code" WHERE (Type=CONST(Legal)) }
    { 25  ;   ;Legal Fee Amount    ;Decimal        }
    { 26  ;   ;Investor Principle/Topup;Boolean    }
    { 27  ;   ;Transaction Category;Option        ;OptionCaptionML=ENU=Normal,Investor,Property;
                                                   OptionString=Normal,Investor,Property }
  }
  KEYS
  {
    {    ;Transaction Code                        ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      "G/L Account"@1000 : Record 15;
      Customer@1001 : Record 18;
      Vendor@1002 : Record 23;
      Investor@1003 : Record 51516433;

    BEGIN
    END.
  }
}

OBJECT Table 51516033 Funds Tax Codes
{
  OBJECT-PROPERTIES
  {
    Date=10/08/15;
    Time=[ 9:25:58 AM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Tax Code            ;Code20         }
    { 11  ;   ;Description         ;Text50         }
    { 12  ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor }
    { 13  ;   ;Account No          ;Code50        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Account Type=CONST(Vendor)) Vendor }
    { 14  ;   ;Percentage          ;Decimal        }
    { 15  ;   ;Type                ;Option        ;OptionCaptionML=ENU=" ,W/Tax,VAT,Excise,Legal,Others,Retention";
                                                   OptionString=[ ,W/Tax,VAT,Excise,Legal,Others,Retention] }
    { 16  ;   ;Account Name        ;Text50         }
    { 17  ;   ;Amount              ;Decimal        }
  }
  KEYS
  {
    {    ;Tax Code                                ;Clustered=Yes }
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

OBJECT Table 51516034 Funds Lookup Values
{
  OBJECT-PROPERTIES
  {
    Date=09/21/15;
    Time=[ 5:21:02 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Code                ;Code20         }
    { 11  ;   ;Type                ;Option        ;OptionCaptionML=ENU=Payment,Receipt;
                                                   OptionString=Payment,Receipt }
    { 12  ;   ;Description         ;Text50         }
    { 13  ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor }
    { 14  ;   ;Account No          ;Code20         }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
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

OBJECT Table 51516035 Destination Rates
{
  OBJECT-PROPERTIES
  {
    Date=01/31/19;
    Time=[ 5:48:04 PM];
    Modified=Yes;
    Version List=FUNDS.;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Advance Code        ;Code20        ;TableRelation="Funds Transaction Types" WHERE (Transaction Type=CONST(Imprest));
                                                   NotBlank=Yes }
    { 2   ;   ;Destination Code    ;Code10        ;NotBlank=Yes }
    { 3   ;   ;Currency            ;Code10        ;TableRelation=Currency;
                                                   NotBlank=No }
    { 4   ;   ;Destination Type    ;Option        ;OptionString=local,Foreign;
                                                   Editable=No }
    { 5   ;   ;Daily Rate (Amount) ;Decimal        }
    { 6   ;   ;Employee Job Group  ;Code10        ;TableRelation="Employee Statistics Group";
                                                   NotBlank=Yes;
                                                   Editable=Yes }
    { 7   ;   ;Destination Name    ;Text50        ;Editable=No }
    { 8   ;   ;Payment Journal Template;Text30     }
  }
  KEYS
  {
    {    ;Advance Code                            ;Clustered=Yes }
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

