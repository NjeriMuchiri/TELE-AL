OBJECT table 50039 Payments-Users
{
  OBJECT-PROPERTIES
  {
    Date=01/31/19;
    Time=[ 3:19:10 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF No = '' THEN BEGIN
                 GenLedgerSetup.GET;
                 GenLedgerSetup.TESTFIELD(GenLedgerSetup."Normal Payments No");
                 NoSeriesMgt.InitSeries(GenLedgerSetup."Normal Payments No",xRec."No. Series",0D,No,"No. Series");
               END;
             END;

    LookupPageID=Page50029;
    DrillDownPageID=Page50029;
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20        ;OnValidate=BEGIN

                                                                IF No <> xRec.No THEN BEGIN
                                                                  GenLedgerSetup.GET;
                                                                  IF "Payment Type"="Payment Type"::Normal THEN BEGIN
                                                                      NoSeriesMgt.TestManual(GenLedgerSetup."Normal Payments No");
                                                                  END
                                                                  ELSE BEGIN
                                                                    NoSeriesMgt.TestManual(GenLedgerSetup."Imprest Req No");
                                                                  END;
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Date                ;Date           }
    { 3   ;   ;Type                ;Code20        ;TableRelation="Receipts and Payment Types".Code WHERE (Type=FILTER(Payment));
                                                   OnValidate=BEGIN

                                                                "Account No.":='';
                                                                "Account Name":='';
                                                                Remarks:='';
                                                                RecPayTypes.RESET;
                                                                RecPayTypes.SETRANGE(RecPayTypes.Code,Type);
                                                                RecPayTypes.SETRANGE(RecPayTypes.Type,RecPayTypes.Type::Payment);

                                                                IF RecPayTypes.FIND('-') THEN BEGIN
                                                                Grouping:=RecPayTypes."Default Grouping";
                                                                END;

                                                                IF RecPayTypes.FIND('-') THEN BEGIN
                                                                "Account Type":=RecPayTypes."Account Type";
                                                                "Transaction Name":=RecPayTypes.Description;

                                                                IF RecPayTypes."Account Type"=RecPayTypes."Account Type"::"G/L Account" THEN BEGIN
                                                                RecPayTypes.TESTFIELD(RecPayTypes."G/L Account");
                                                                "Account No.":=RecPayTypes."G/L Account";
                                                                VALIDATE("Account No.");
                                                                END;


                                                                END;

                                                                //VALIDATE("Account No.");
                                                              END;

                                                   NotBlank=Yes }
    { 4   ;   ;Pay Mode            ;Option        ;OptionString=,Cash,Cheque,EFT,Custom 1,Custom 2,Custom 3,Custom 4,Custom 5 }
    { 5   ;   ;Cheque No           ;Code20         }
    { 6   ;   ;Cheque Date         ;Date           }
    { 7   ;   ;Cheque Type         ;Code20         }
    { 8   ;   ;Bank Code           ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2)) }
    { 9   ;   ;Received From       ;Text100        }
    { 10  ;   ;On Behalf Of        ;Text100        }
    { 11  ;   ;Cashier             ;Code20        ;TableRelation=Table2000000002.Field1 }
    { 12  ;   ;Account Type        ;Option        ;CaptionML=ENU=Account Type;
                                                   OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner }
    { 13  ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Account Type=CONST(Customer)) Customer WHERE (Customer Posting Group=FIELD(Grouping))
                                                                 ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Account Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                 ELSE IF (Account Type=CONST(IC Partner)) "IC Partner";
                                                   OnValidate=BEGIN

                                                                "Account Name":='';
                                                                RecPayTypes.RESET;
                                                                RecPayTypes.SETRANGE(RecPayTypes.Code,Type);
                                                                RecPayTypes.SETRANGE(RecPayTypes.Type,RecPayTypes.Type::Payment);

                                                                IF "Account Type" IN ["Account Type"::"G/L Account","Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"IC Partner"]
                                                                THEN

                                                                CASE "Account Type" OF
                                                                  "Account Type"::"G/L Account":
                                                                    BEGIN
                                                                      GLAcc.GET("Account No.");
                                                                      "Account Name":=GLAcc.Name;
                                                                      "VAT Code":=RecPayTypes."VAT Code";
                                                                      "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                                                                      "Global Dimension 1 Code":='';
                                                                    END;
                                                                  "Account Type"::Customer:
                                                                    BEGIN
                                                                      Cust.GET("Account No.");
                                                                      "Account Name":=Cust.Name;
                                                                //      "VAT Code":=Cust."Default Withholding Tax Code";
                                                                      //"Withholding Tax Code":=Cust.Province;
                                                                      "Global Dimension 1 Code":=Cust."Global Dimension 1 Code";
                                                                    END;
                                                                  "Account Type"::Vendor:
                                                                    BEGIN
                                                                      Vend.GET("Account No.");
                                                                      "Account Name":=Vend.Name;
                                                                //      "VAT Code":=Vend."Default VAT Code";
                                                                //      "Withholding Tax Code":=Vend."Default Withholding Tax Code";
                                                                      "Global Dimension 1 Code":=Vend."Global Dimension 1 Code";
                                                                    END;
                                                                  "Account Type"::"Bank Account":
                                                                    BEGIN
                                                                      BankAcc.GET("Account No.");
                                                                      "Account Name":=BankAcc.Name;
                                                                      "VAT Code":=RecPayTypes."VAT Code";
                                                                      "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                                                                      "Global Dimension 1 Code":=BankAcc."Global Dimension 1 Code";

                                                                    END;
                                                                    {
                                                                  "Account Type"::"Fixed Asset":
                                                                    BEGIN
                                                                      FA.GET("Account No.");
                                                                      "Account Name":=FA.Description;
                                                                      "VAT Code":=FA."Default VAT Code";
                                                                      "Withholding Tax Code":=FA."Default Withholding Tax Code";
                                                                       "Global Dimension 1 Code":=FA."Global Dimension 1 Code";
                                                                    END;
                                                                    }
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Account No. }
    { 14  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 15  ;   ;Account Name        ;Text150        }
    { 16  ;   ;Posted              ;Boolean        }
    { 17  ;   ;Date Posted         ;Date           }
    { 18  ;   ;Time Posted         ;Time           }
    { 19  ;   ;Posted By           ;Code20         }
    { 20  ;   ;Amount              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Imprest Details-User".Amount WHERE (No=FIELD(No))) }
    { 21  ;   ;Remarks             ;Text250        }
    { 22  ;   ;Transaction Name    ;Text100        }
    { 23  ;   ;VAT Code            ;Code20        ;TableRelation="Tariff Codes" }
    { 24  ;   ;Withholding Tax Code;Code20        ;TableRelation="Tariff Codes" }
    { 25  ;   ;VAT Amount          ;Decimal        }
    { 26  ;   ;Withholding Tax Amount;Decimal      }
    { 27  ;   ;Net Amount          ;Decimal        }
    { 28  ;   ;Paying Bank Account ;Code20        ;TableRelation="Bank Account".No. WHERE (Bank Type=CONST(Normal)) }
    { 29  ;   ;Payee               ;Text100        }
    { 30  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   CaptionClass='1,1,1' }
    { 31  ;   ;Branch Code         ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2)) }
    { 32  ;   ;PO/INV No           ;Code20         }
    { 33  ;   ;Bank Account No     ;Code20         }
    { 34  ;   ;Cashier Bank Account;Code20         }
    { 35  ;   ;Status              ;Option        ;OptionString=Pending,1st Approval,2nd Approval,3rd Approval,Fully Approved,Cancelled }
    { 36  ;   ;Select              ;Boolean        }
    { 37  ;   ;Grouping            ;Code20        ;TableRelation="Customer Posting Group".Code }
    { 38  ;   ;Payment Type        ;Option        ;OptionString=Normal,Petty Cash }
    { 39  ;   ;Bank Type           ;Option        ;OptionString=Normal,Petty Cash }
    { 40  ;   ;PV Type             ;Option        ;OptionString=Normal,Other }
    { 41  ;   ;Apply to            ;Code20        ;TableRelation="Vendor Ledger Entry"."Vendor No." WHERE (Vendor No.=FIELD(Account No.)) }
    { 42  ;   ;Apply to ID         ;Code20         }
    { 43  ;   ;No of Units         ;Decimal        }
    { 44  ;   ;Surrender Date      ;Date           }
    { 45  ;   ;Surrendered         ;Boolean        }
    { 46  ;   ;Surrender Doc. No   ;Code20         }
    { 47  ;   ;Vote Book           ;Code10        ;TableRelation="G/L Account" }
    { 48  ;   ;Total Allocation    ;Decimal        }
    { 49  ;   ;Total Expenditure   ;Decimal        }
    { 50  ;   ;Total Commitments   ;Decimal        }
    { 51  ;   ;Balance             ;Decimal        }
    { 52  ;   ;Balance Less this Entry;Decimal     }
    { 53  ;   ;Applicant Designation;Text100       }
    { 54  ;   ;Petty Cash          ;Boolean        }
    { 55  ;   ;Supplier Invoice No.;Code30         }
    { 56  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=ENU=Shortcut Dimension 2 Code;
                                                   CaptionClass='1,2,2' }
    { 57  ;   ;LineMGERID          ;Code20        ;TableRelation=Table2000000002.Field1 }
    { 58  ;   ;User ID             ;Code20         }
  }
  KEYS
  {
    {    ;No                                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      GLAcc@1102758034 : Record 15;
      Cust@1102758033 : Record 18;
      Vend@1102758032 : Record 23;
      FA@1102758031 : Record 5600;
      BankAcc@1102758030 : Record 270;
      NoSeriesMgt@1102758029 : Codeunit 396;
      GenLedgerSetup@1102758028 : Record 51516049;
      RecPayTypes@1102758027 : Record 51516018;
      CashierLinks@1102758026 : Record 51516035;
      GLAccount@1102758025 : Record 15;
      EntryNo@1102758024 : Integer;
      SingleMonth@1102758022 : Boolean;
      DateFrom@1102758021 : Date;
      DateTo@1102758020 : Date;
      Budget@1102758019 : Decimal;
      CurrMonth@1102758018 : Code[10];
      CurrYR@1102758017 : Code[10];
      BudgDate@1102758016 : Text[30];
      BudgetDate@1102758015 : Date;
      YrBudget@1102758014 : Decimal;
      BudgetDateTo@1102758013 : Date;
      BudgetAvailable@1102758012 : Decimal;
      GenLedSetup@1102758011 : Record 51516049;
      "Total Budget"@1102758010 : Decimal;
      CommittedAmount@1102758008 : Decimal;
      MonthBudget@1102758007 : Decimal;
      Expenses@1102758006 : Decimal;
      Header@1102758005 : Text[250];
      "Date From"@1102758004 : Text[30];
      "Date To"@1102758003 : Text[30];
      LastDay@1102758002 : Date;

    BEGIN
    END.
  }
}

