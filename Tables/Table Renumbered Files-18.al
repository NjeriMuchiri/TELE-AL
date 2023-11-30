OBJECT table 50037 Cash Payment Line
{
  OBJECT-PROPERTIES
  {
    Date=09/03/14;
    Time=[ 2:06:59 PM];
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
               CHead.RESET;
               CHead.SETRANGE(CHead."No.",No);
               IF CHead.FINDFIRST THEN
                 BEGIN
                   "Global Dimension 1 Code":=CHead."Global Dimension 1 Code";
                   "Shortcut Dimension 2 Code":=CHead."Shortcut Dimension 2 Code";
                 END;
             END;

    LookupPageID=Page50032;
    DrillDownPageID=Page50032;
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20        ;OnValidate=BEGIN
                                                                {
                                                                IF No <> xRec.No THEN BEGIN
                                                                  GenLedgerSetup.GET;
                                                                  IF "Payment Type"="Payment Type"::Normal THEN BEGIN
                                                                    NoSeriesMgt.TestManual(GenLedgerSetup."Normal Payments No");
                                                                  END
                                                                  ELSE BEGIN
                                                                    NoSeriesMgt.TestManual(GenLedgerSetup."Petty Cash Payments No");
                                                                  END;
                                                                  "No. Series" := '';
                                                                END;
                                                                }
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

                                                                IF RecPayTypes.FIND('-') THEN
                                                                  BEGIN
                                                                    Grouping:=RecPayTypes."Default Grouping";
                                                                    "Require Surrender":=RecPayTypes."Pending Voucher";
                                                                  END;

                                                                IF RecPayTypes.FIND('-') THEN
                                                                  BEGIN
                                                                    "Account Type":=RecPayTypes."Account Type";
                                                                    "Transaction Name":=RecPayTypes.Description;
                                                                      IF RecPayTypes."Account Type"=RecPayTypes."Account Type"::"G/L Account" THEN
                                                                        BEGIN
                                                                          RecPayTypes.TESTFIELD(RecPayTypes."G/L Account");
                                                                          "Account No.":=RecPayTypes."G/L Account";
                                                                          VALIDATE("Account No.");
                                                                        END;

                                                                //Banks
                                                                IF RecPayTypes."Account Type"=RecPayTypes."Account Type"::"Bank Account" THEN
                                                                  BEGIN
                                                                    "Account No.":=RecPayTypes."Bank Account";
                                                                //    VALIDATE("Account No.");
                                                                  END;
                                                                END;
                                                              END;
                                                               }
    { 4   ;   ;Pay Mode            ;Option        ;OptionString=[ ,Cash,Cheque,EFT,Custom 2,Custom 3,Custom 4,Custom 5] }
    { 5   ;   ;Cheque No           ;Code20         }
    { 6   ;   ;Cheque Date         ;Date           }
    { 7   ;   ;Cheque Type         ;Option        ;TableRelation="Member Cue";
                                                   OptionString=[ , Local,Up Country] }
    { 8   ;   ;Bank Code           ;Code20        ;TableRelation="Cash Payments Header" }
    { 9   ;   ;Received From       ;Text100        }
    { 10  ;   ;On Behalf Of        ;Text100        }
    { 11  ;   ;Cashier             ;Code50         }
    { 12  ;   ;Account Type        ;Option        ;CaptionML=ENU=Account Type;
                                                   OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Staff;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Staff }
    { 13  ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account" WHERE (Direct Posting=CONST(Yes)) ELSE IF (Account Type=CONST(Customer)) Customer WHERE (Customer Posting Group=FIELD(Grouping)) ELSE IF (Account Type=CONST(Vendor)) Vendor ELSE IF (Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Account Type=CONST(IC Partner)) "IC Partner" ELSE IF (Account Type=CONST(Staff)) Table55883.Field1;
                                                   OnValidate=BEGIN
                                                                HeaderC.RESET;
                                                                HeaderC.GET(No);
                                                                "Account Name":='';
                                                                RecPayTypes.RESET;
                                                                RecPayTypes.SETRANGE(RecPayTypes.Code,Type);
                                                                RecPayTypes.SETRANGE(RecPayTypes.Type,RecPayTypes.Type::Payment);

                                                                IF "Account Type" IN ["Account Type"::"G/L Account","Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"IC Partner"
                                                                ,"Account Type"::Staff]
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
                                                                      "VAT Code":=RecPayTypes."VAT Code";
                                                                      "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                                                                      IF "Global Dimension 1 Code"='' THEN
                                                                        BEGIN
                                                                          "Global Dimension 1 Code":=Cust."Global Dimension 1 Code";
                                                                        END;
                                                                    END;
                                                                  "Account Type"::Vendor:
                                                                    BEGIN
                                                                      Vend.GET("Account No.");
                                                                      "Account Name":=Vend.Name;
                                                                      "VAT Code":=RecPayTypes."VAT Code";
                                                                      "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                                                                      IF "Global Dimension 1 Code"='' THEN
                                                                        BEGIN
                                                                          "Global Dimension 1 Code":=Vend."Global Dimension 1 Code";
                                                                        END;
                                                                      IF HeaderC.Payee='' THEN
                                                                        BEGIN
                                                                          HeaderC.Payee:="Account Name";
                                                                          HeaderC.MODIFY;
                                                                        END;
                                                                      IF HeaderC."On Behalf Of"='' THEN
                                                                        BEGIN
                                                                          HeaderC."On Behalf Of":="Account Name";
                                                                          HeaderC.MODIFY;
                                                                        END;
                                                                    END;
                                                                  "Account Type"::"Bank Account":
                                                                    BEGIN
                                                                      BankAcc.GET("Account No.");
                                                                      "Account Name":=BankAcc.Name;
                                                                      "VAT Code":=RecPayTypes."VAT Code";
                                                                      "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                                                                      IF "Global Dimension 1 Code"='' THEN
                                                                        BEGIN
                                                                          "Global Dimension 1 Code":=BankAcc."Global Dimension 1 Code";
                                                                        END;
                                                                    END;
                                                                  "Account Type"::Staff:
                                                                    BEGIN
                                                                      Emp.RESET;
                                                                      Emp.GET("Account No.");
                                                                      "Account Name":=Emp."First Name" + ' ' + Emp."Middle Name" + Emp."Last Name";
                                                                      "VAT Code":=RecPayTypes."VAT Code";
                                                                      "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                                                                    END;
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
    { 19  ;   ;Posted By           ;Code50         }
    { 20  ;   ;Amount              ;Decimal        }
    { 21  ;   ;Remarks             ;Text250        }
    { 22  ;   ;Transaction Name    ;Text100        }
    { 23  ;   ;VAT Code            ;Code20        ;TableRelation="Tariff Codes".Code WHERE (Type=CONST(VAT)) }
    { 24  ;   ;Withholding Tax Code;Code20        ;TableRelation="Tariff Codes".Code WHERE (Type=CONST(W/Tax)) }
    { 25  ;   ;VAT Amount          ;Decimal        }
    { 26  ;   ;Withholding Tax Amount;Decimal      }
    { 27  ;   ;Net Amount          ;Decimal        }
    { 28  ;   ;Paying Bank Account ;Code20        ;TableRelation="Bank Account".No. }
    { 29  ;   ;Payee               ;Text100        }
    { 30  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN

                                                                DimVal.RESET;
                                                                DimVal.SETRANGE(DimVal."Global Dimension No.",1);
                                                                DimVal.SETRANGE(DimVal.Code,"Global Dimension 1 Code");
                                                                 IF DimVal.FIND('-') THEN
                                                                    "Function Name":=DimVal.Name
                                                              END;

                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   CaptionClass='1,1,1' }
    { 31  ;   ;Branch Code         ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN

                                                                DimVal.RESET;
                                                                DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                                                                DimVal.SETRANGE(DimVal.Code,"Branch Code");
                                                                 IF DimVal.FIND('-') THEN
                                                                    "Budget Center Name":=DimVal.Name
                                                              END;
                                                               }
    { 32  ;   ;PO/INV No           ;Code20         }
    { 33  ;   ;Bank Account No     ;Code20         }
    { 34  ;   ;Cashier Bank Account;Code20         }
    { 35  ;   ;Status              ;Option        ;OptionString=Pending,1st Approval,2nd Approval,Cheque Printing,Posted,Cancelled,Checking,VoteBook }
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
    { 47  ;   ;Vote Book           ;Code10        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                {
                                                                          IF Amount<=0 THEN
                                                                        ERROR('Please enter the Amount');

                                                                       //Confirm the Amount to be issued doesnot exceed the budget and amount Committed
                                                                        EVALUATE(CurrMonth,FORMAT(DATE2DMY(Date,2)));
                                                                        EVALUATE(CurrYR,FORMAT(DATE2DMY(Date,3)));
                                                                        EVALUATE(BudgetDate,FORMAT('01'+'/'+CurrMonth+'/'+CurrYR));

                                                                          //Get the last day of the month

                                                                          LastDay:=CALCDATE('1M', BudgetDate);
                                                                          LastDay:=CALCDATE('-1D',LastDay);


                                                                        //Get Budget for the G/L
                                                                      IF GenLedSetup.GET THEN BEGIN
                                                                        GLAccount.SETFILTER(GLAccount."Budget Filter",GenLedSetup."Current Budget");
                                                                        GLAccount.SETRANGE(GLAccount."No.","Vote Book");
                                                                        GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                                                        {Get the exact Monthly Budget}
                                                                        //Start from first date of the budget.//BudgetDate
                                                                        GLAccount.SETRANGE(GLAccount."Date Filter",GenLedSetup."Current Budget Start Date",LastDay);

                                                                        IF GLAccount.FIND('-') THEN BEGIN
                                                                         GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                                                         MonthBudget:=GLAccount."Budgeted Amount";
                                                                         Expenses:=GLAccount."Net Change";
                                                                         BudgetAvailable:=GLAccount."Budgeted Amount"-GLAccount."Net Change";
                                                                         "Total Allocation":=MonthBudget;
                                                                         "Total Expenditure":=Expenses;
                                                                         END;


                                                                     END;

                                                                     CommitmentEntries.RESET;
                                                                     CommitmentEntries.SETCURRENTKEY(CommitmentEntries.Account);
                                                                     CommitmentEntries.SETRANGE(CommitmentEntries.Account,"Vote Book");
                                                                     CommitmentEntries.SETRANGE(CommitmentEntries."Commitment Date",GenLedSetup."Current Budget Start Date",LastDay);
                                                                     CommitmentEntries.CALCSUMS(CommitmentEntries."Committed Amount");
                                                                     CommittedAmount:=CommitmentEntries."Committed Amount";

                                                                     "Total Commitments":=CommittedAmount;
                                                                     Balance:=BudgetAvailable-CommittedAmount;
                                                                     "Balance Less this Entry":=BudgetAvailable-CommittedAmount-Amount;
                                                                     MODIFY;
                                                                     {
                                                                     IF CommittedAmount+Amount>BudgetAvailable THEN
                                                                        ERROR('%1,%2,%3,%4','You have Exceeded Budget for G/L Account No',"Vote Book",'by',
                                                                        ABS(BudgetAvailable-(CommittedAmount+Amount)));
                                                                      }
                                                                     //End of Confirming whether Budget Allows Posting
                                                                }
                                                              END;
                                                               }
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
    { 57  ;   ;Imprest Request No  ;Code20        ;TableRelation=Payments-Users WHERE (Posted=CONST(No));
                                                   OnValidate=BEGIN
                                                                   {
                                                                          TotAmt:=0;
                                                                     //On Delete/Change of Request No. then Clear from Imprest Details
                                                                     IF ("Imprest Request No"='') OR ("Imprest Request No"<>xRec."Imprest Request No") THEN
                                                                        LoadImprestDetails.RESET;
                                                                        LoadImprestDetails.SETRANGE(LoadImprestDetails.No,No);
                                                                        IF LoadImprestDetails.FIND('-') THEN BEGIN
                                                                           LoadImprestDetails.DELETEALL;
                                                                           Amount:=TotAmt;
                                                                           "Net Amount":=Amount;
                                                                           MODIFY;

                                                                        END;
                                                                     //New Imprest Details
                                                                     ImprestReqDet.RESET;
                                                                     ImprestReqDet.SETRANGE(ImprestReqDet.No,"Imprest Request No");
                                                                     IF ImprestReqDet.FIND('-') THEN BEGIN
                                                                     REPEAT
                                                                         LoadImprestDetails.INIT;
                                                                         LoadImprestDetails.No:=No;
                                                                         LoadImprestDetails.Date:=ImprestReqDet."Account No:";
                                                                         LoadImprestDetails.Type:=ImprestReqDet."Account Name";
                                                                         LoadImprestDetails."Pay Mode":=ImprestReqDet.Amount;
                                                                         LoadImprestDetails."Cheque No":=ImprestReqDet."Due Date";
                                                                         LoadImprestDetails."Cheque Date":=ImprestReqDet."Imprest Holder";
                                                                         LoadImprestDetails.INSERT;
                                                                         TotAmt:=TotAmt+ImprestReqDet.Amount;
                                                                     UNTIL ImprestReqDet.NEXT=0;
                                                                         Amount:=TotAmt;
                                                                         "Account No.":=ImprestReqDet."Imprest Holder";
                                                                         "Net Amount":=Amount;
                                                                         MODIFY;
                                                                     END;
                                                                {
                                                                       //ImprestDetForm.GETRECORD(LoadImprestDetails);
                                                                }
                                                                    }
                                                              END;
                                                               }
    { 58  ;   ;Batched Imprest Tot ;Decimal       ;FieldClass=Normal }
    { 59  ;   ;Function Name       ;Text30         }
    { 60  ;   ;Budget Center Name  ;Text30         }
    { 61  ;   ;Farmer Purchase No  ;Code20         }
    { 62  ;   ;Transporter Ananlysis No;Code20     }
    { 63  ;   ;User ID             ;Code20        ;TableRelation=Table2000000002.Field1 }
    { 64  ;   ;Journal Template    ;Code20         }
    { 65  ;   ;Journal Batch       ;Code20         }
    { 66  ;   ;Line No.            ;Integer       ;AutoIncrement=Yes }
    { 67  ;   ;Require Surrender   ;Boolean       ;Editable=No }
    { 68  ;   ;Committed Ammount   ;Decimal       ;TableRelation="Imprest Details".Amount }
    { 69  ;   ;Select to Surrender ;Boolean        }
    { 70  ;   ;Temp Surr Doc       ;Code20         }
    { 71  ;   ;Document No.        ;Code20         }
    { 72  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group".Code }
    { 73  ;   ;VAT Registration No.;Code20         }
    { 74  ;   ;VAT Entity Name     ;Text30         }
  }
  KEYS
  {
    {    ;Line No.,No                             ;SumIndexFields=Amount;
                                                   Clustered=Yes }
    {    ;No,Account Type                         ;SumIndexFields=Amount,VAT Amount,Withholding Tax Amount,Net Amount }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      HeaderC@1102755002 : Record 51516448;
      Emp@1102755000 : Record 51516316;
      GLAcc@1102758038 : Record 15;
      Cust@1102758037 : Record 18;
      Vend@1102758036 : Record 23;
      FA@1102758035 : Record 5600;
      BankAcc@1102758034 : Record 270;
      NoSeriesMgt@1102758033 : Codeunit 396;
      GenLedgerSetup@1102758032 : Record 51516460;
      RecPayTypes@1102758031 : Record 51516447;
      CashierLinks@1102758030 : Record 51516446;
      GLAccount@1102758029 : Record 15;
      EntryNo@1102758028 : Integer;
      SingleMonth@1102758026 : Boolean;
      DateFrom@1102758025 : Date;
      DateTo@1102758024 : Date;
      Budget@1102758023 : Decimal;
      CurrMonth@1102758022 : Code[10];
      CurrYR@1102758021 : Code[10];
      BudgDate@1102758020 : Text[30];
      BudgetDate@1102758019 : Date;
      YrBudget@1102758018 : Decimal;
      BudgetDateTo@1102758017 : Date;
      BudgetAvailable@1102758016 : Decimal;
      GenLedSetup@1102758015 : Record 51516460;
      "Total Budget"@1102758014 : Decimal;
      MonthBudget@1102758011 : Decimal;
      Expenses@1102758010 : Decimal;
      Header@1102758009 : Text[250];
      "Date From"@1102758008 : Text[30];
      "Date To"@1102758007 : Text[30];
      LastDay@1102758006 : Date;
      ImprestReqDet@1102758005 : Record 51516452;
      LoadImprestDetails@1102758004 : Record 51516453;
      TotAmt@1102758003 : Decimal;
      DimVal@1102758000 : Record 349;
      CHead@1102755001 : Record 51516448;

    BEGIN
    END.
  }
}

