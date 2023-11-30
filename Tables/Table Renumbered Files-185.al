OBJECT table 17303 Transactions
{
  OBJECT-PROPERTIES
  {
    Date=08/10/23;
    Time=[ 4:41:36 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN

               IF No = '' THEN BEGIN
               NoSetup.GET();
               NoSetup.TESTFIELD(NoSetup."Transaction Nos.");
               NoSeriesMgt.InitSeries(NoSetup."Transaction Nos.",xRec."No. Series",0D,No,"No. Series");
               END;

               Cashier:=USERID;
               "Transaction Date":=TODAY;
               "Transaction Time":=TIME;
               Status:=Status::Pending;
               "Needs Approval":="Needs Approval"::Yes;
               "Frequency Needs Approval":="Frequency Needs Approval"::Yes;

               //IF UsersID.GET(USERID) THEN
               //"Transacting Branch":=UsersID.Branch;
             END;

    OnModify=BEGIN
                 {
               //Cyrus
               IF Cashier <> UPPERCASE(USERID) THEN
               ERROR('Cannot modify a Transaction being processed by %1',Cashier);
                     }
             END;

    OnDelete=BEGIN
               IF Posted = TRUE THEN
               ERROR('The transaction has been posted and therefore cannot be deleted.');

               {IF Deposited THEN BEGIN
               ERROR('The cheque has already been deposited and therefore cannot be deleted.');
               END;}
             END;

    OnRename=BEGIN
               IF Type<>'Cheque Deposit' THEN BEGIN
               IF Posted THEN BEGIN
               ERROR('The transaction has been posted and therefore cannot be modified.');
               END;
               END;

               IF Deposited THEN BEGIN
               ERROR('The cheque has already been deposited and therefore cannot be modified.');
               END;
                  {
               //Cyrus
               IF Cashier <> UPPERCASE(USERID) THEN
               ERROR('Cannot rename a Transaction being processed by %1',Cashier);
                 }
             END;

    LookupPageID=Page51516301;
    DrillDownPageID=Page51516301;
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20        ;OnValidate=BEGIN
                                                                IF No <> xRec.No THEN BEGIN
                                                                  NoSetup.GET();
                                                                  NoSeriesMgt.TestManual(NoSetup."Transaction Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   Editable=Yes }
    { 2   ;   ;Account No          ;Code20        ;TableRelation=Vendor WHERE (Status=FILTER(<>Closed),
                                                                               Account Type=FILTER(ORDINARY));
                                                   OnValidate=VAR
                                                                Charges@1120054000 : Record 51516297;
                                                              BEGIN
                                                                //CLEAR("Front Side ID");
                                                                //INSERT IMAGE & SIGNATURE
                                                                //CustM.RESET;
                                                                //CustM.SETRANGE(CustM."No.","Account No");
                                                                //IF CustM.FIND('-') THEN BEGIN
                                                                Customers.RESET;
                                                                Customers.SETRANGE(Customers."FOSA Account","Account No");
                                                                IF Customers.FINDFIRST THEN BEGIN
                                                                Customers.CALCFIELDS(Customers.Picture,Customers."Back Side ID",Customers."Front Side ID",Customers.Signature);
                                                                Picture:=Customers.Picture;
                                                                "Back Side ID":=Customers."Back Side ID";
                                                                "Front Side ID":=Customers."Front Side ID";
                                                                Signature:=Customers.Signature;
                                                                "Signature 2":=Customers.Signature;
                                                                "Front ID":=Customers."Front Side ID";
                                                                END;

                                                                Cust.RESET;
                                                                Cust.SETRANGE(Cust."FOSA Account","Account No");
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                     Cust.ValidateDateOfBirth;
                                                                    Cust.CALCFIELDS(Cust.Picture,Cust.Signature,Cust."Back Side ID",Cust."Front Side ID");
                                                                    Picture:=Cust.Picture;
                                                                    "Back Side ID":=Cust."Back Side ID";
                                                                    "Front Side ID":=Cust."Front Side ID";
                                                                    Cust.CALCFIELDS(Cust.Signature);
                                                                    "Signature 2":=Cust.Signature;
                                                                    "Front ID":=Cust."Front Side ID";
                                                                END;
                                                                {
                                                                //CHECK ACCOUNT ACTIVITY
                                                                Account.RESET;
                                                                IF Account.GET("Account No") THEN BEGIN
                                                                IF Account.Status=Account.Status::Dormant THEN BEGIN
                                                                Account.Status:=Account.Status::Active;
                                                                Account.MODIFY;
                                                                END;
                                                                IF Account.Status=Account.Status::New THEN BEGIN
                                                                END
                                                                ELSE BEGIN
                                                                IF Account.Status<>Account.Status::Active THEN
                                                                ERROR('The account is not active and therefore cannot be transacted upon.');
                                                                END;

                                                                Account.CALCFIELDS(Account.Balance,Account.Picture,Account.Signature);
                                                                "Account Name":=Account.Name;
                                                                Payee:=Account.Name;
                                                                "Account Type":=Account."Account Type";
                                                                "Currency Code":=Account."Currency Code";
                                                                "Staff/Payroll No":=Account."Staff No";
                                                                "ID No":=Account."ID No.";
                                                                Picture:=Account.Picture;
                                                                Signature:=Account.Signature;
                                                                IF (Account.Balance <> 0) AND (Account.Status = Account.Status::New) THEN BEGIN
                                                                Account.Status:=Account.Status::Active;
                                                                Account.MODIFY;
                                                                END;

                                                                "Book Balance":=Account.Balance;

                                                                IF Account."Account Category" = Account."Account Category"::Branch THEN
                                                                "Branch Transaction":=TRUE;

                                                                //END;


                                                                IF AccountTypes.GET("Account Type") THEN BEGIN
                                                                Account.CALCFIELDS(Account.Balance,Account.Picture,Account.Signature);

                                                                "Account Description":=AccountTypes.Description;
                                                                "Minimum Account Balance":=AccountTypes."Minimum Balance";
                                                                "Fee Below Minimum Balance":=AccountTypes."Fee Below Minimum Balance";
                                                                "Fee on Withdrawal Interval":=AccountTypes."Withdrawal Penalty";
                                                                Picture:=Account.Picture;
                                                                Signature:=Account.Signature;

                                                                END;
                                                                ATMApp.RESET;
                                                                ATMApp.SETRANGE(ATMApp."Account No","Account No");
                                                                IF ATMApp.FIND('-') THEN BEGIN
                                                                IF ATMApp.Collected=TRUE THEN
                                                                MESSAGE('The ATM card for this Memer is ready for collection');
                                                                END;
                                                                //END;
                                                                }
                                                                //CHECK ACCOUNT ACTIVITY
                                                                Account.RESET;
                                                                IF Account.GET("Account No") THEN BEGIN
                                                                IF Account.Status=Account.Status::Dormant THEN BEGIN
                                                                Account.Status:=Account.Status::Active;
                                                                Account.MODIFY;
                                                                END;
                                                                IF Account.Status=Account.Status::New THEN BEGIN
                                                                END

                                                                ELSE BEGIN
                                                                IF Account.Status<>Account.Status::Active THEN
                                                                ERROR('The account is not active and therefore cannot be transacted upon.');
                                                                END;

                                                                Account.CALCFIELDS(Account.Balance);
                                                                "Account Name":=Account.Name;
                                                                Payee:=Account.Name;
                                                                "Account Type":=Account."Account Type";
                                                                "Currency Code":=Account."Currency Code";
                                                                "Staff/Payroll No":=Account."Staff No";
                                                                "ID No":=Account."ID No.";
                                                                "Atm Number":=Account."ATM No.";
                                                                CustM.Picture:=Account.Picture;
                                                                CustM.Signature:=Account.Signature;
                                                                CustM."Front Side ID":=Account."Front Side ID";
                                                                CustM."Back Side ID":=Account."Back Side ID";
                                                                IF (Account.Balance <> 0) AND (Account.Status = Account.Status::New) THEN BEGIN
                                                                Account.Status:=Account.Status::Active;
                                                                Account.MODIFY;
                                                                END;

                                                                "Book Balance":=Account.Balance;

                                                                // IF Vendor.GET("Account No") THEN BEGIN
                                                                // AccTypes.RESET;
                                                                // AccTypes.SETRANGE(AccTypes.Code,Vendor."Account Type");
                                                                // IF AccTypes.FINDFIRST THEN
                                                                // MinimumBal:=AccTypes."Minimum Balance";
                                                                // IF "Book Balance"<0 THEN BEGIN
                                                                // "Available Balance":="Book Balance";
                                                                // MESSAGE('Here%1',"Available Balance");
                                                                // END ELSE BEGIN
                                                                // MESSAGE('Here  %1',"Available Balance");
                                                                // "Available Balance":="Book Balance"-MinimumBal;
                                                                // END;
                                                                // END;


                                                                IF Account."Account Category" = Account."Account Category"::Branch THEN
                                                                "Branch Transaction":=TRUE;

                                                                END;


                                                                IF AccountTypes.GET("Account Type") THEN BEGIN
                                                                "Account Description":=AccountTypes.Description;
                                                                "Minimum Account Balance":=AccountTypes."Minimum Balance";
                                                                "Fee Below Minimum Balance":=AccountTypes."Fee Below Minimum Balance";
                                                                "Fee on Withdrawal Interval":=AccountTypes."Withdrawal Penalty";
                                                                END;

                                                                //IF Account."Atm card ready"=TRUE THEN
                                                                //MESSAGE('Atm card is ready for collection');

                                                                IF "ID No"='' THEN
                                                                ERROR('Please update ID No.');

                                                                CALCFIELDS(Picture);
                                                                PictureExists:=Picture.HASVALUE;
                                                                IF (PictureExists=TRUE)  THEN BEGIN
                                                                Cust.Picture:=Picture;
                                                                END ELSE
                                                                ERROR('Kindly upload a Picture ');

                                                                CALCFIELDS(Signature);
                                                                SignatureExists:=Signature.HASVALUE;
                                                                IF (SignatureExists=TRUE) THEN BEGIN
                                                                Cust.Signature:=Signature;
                                                                END ELSE
                                                                ERROR('Kindly upload signature');

                                                                CALCFIELDS("Front Side ID");
                                                                FrontSideIDExist:="Front Side ID".HASVALUE;
                                                                IF (FrontSideIDExist=TRUE) THEN BEGIN
                                                                Cust."Front Side ID":="Front Side ID";
                                                                END ELSE
                                                                ERROR('Kindly upload Front Side ID');


                                                                CALCFIELDS("Front Side ID");
                                                                BackSideIDExist:="Back Side ID".HASVALUE;
                                                                IF (BackSideIDExist=TRUE) THEN BEGIN
                                                                Cust."Back Side ID":="Back Side ID";
                                                                END ELSE
                                                                ERROR('Kindly upload Back Side ID');
                                                              END;

                                                   NotBlank=Yes }
    { 3   ;   ;Account Name        ;Text200        }
    { 4   ;   ;Transaction Type    ;Code20        ;TableRelation="Transaction Types" WHERE (Account Type=FIELD(Account Type));
                                                   OnValidate=BEGIN
                                                                VarAmtHolder:=0;
                                                                IF TransactionTypes.GET("Transaction Type") THEN BEGIN
                                                                "Transaction Description":=TransactionTypes.Description;
                                                                "Transaction Mode":=TransactionTypes."Default Mode";
                                                                "Transaction Span":=TransactionTypes."Transaction Span";
                                                                EVALUATE(Type,FORMAT(TransactionTypes.Type));
                                                                {
                                                                IF (TransactionTypes.Type = TransactionTypes.Type::Withdrawal) OR
                                                                   (TransactionTypes.Type = TransactionTypes.Type::"Bankers Cheque") THEN BEGIN
                                                                IF Account.GET("Account No") THEN BEGIN
                                                                IF Account.Blocked <> Account.Blocked::" " THEN
                                                                ERROR('Account holder blocked from doing this transaction. %1',"Account No")
                                                                END;
                                                                END;
                                                                }

                                                                END;

                                                                IF "Transaction Category"='BANKERS CHEQUE' THEN BEGIN
                                                                IF "Bankers Cheque Type"="Bankers Cheque Type"::Company THEN BEGIN
                                                                  TransactionCharges.RESET;
                                                                  TransactionCharges.SETRANGE(TransactionCharges."Transaction Type","Transaction Type");
                                                                  IF TransactionCharges.FIND('-') THEN BEGIN
                                                                  ////////
                                                                  REPEAT
                                                                  IF TransactionCharges."Use Percentage"=TRUE THEN BEGIN
                                                                  IF TransactionCharges."Percentage of Amount"=0 THEN
                                                                  ERROR('Percentage of amount cannot be zero.');
                                                                  VarAmtHolder:=VarAmtHolder+(TransactionCharges."Percentage of Amount"/100)*"Suspended Amount";
                                                                  END
                                                                  ELSE BEGIN
                                                                  VarAmtHolder:=VarAmtHolder+TransactionCharges."Charge Amount";
                                                                  END;
                                                                  /////////
                                                                  UNTIL TransactionCharges.NEXT=0;
                                                                  END;

                                                                IF "Suspended Amount"<>0 THEN BEGIN
                                                                 Amount:="Suspended Amount"-VarAmtHolder;
                                                                END
                                                                ELSE BEGIN
                                                                 Amount:=0;
                                                                END;

                                                                END;
                                                                END;

                                                                //If Branch account - Use BOSA Receipt
                                                                {
                                                                IF Account.GET("Account No") THEN BEGIN
                                                                IF Account."Account Category" = Account."Account Category"::Project THEN BEGIN
                                                                IF "Transaction Type" = 'DEP' THEN
                                                                ERROR('Please use BOSA Receipt for project account.');

                                                                END;
                                                                END;
                                                                }
                                                                //If Branch account - Use BOSA Receipt
                                                              END;

                                                   NotBlank=Yes }
    { 5   ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                IF "Transaction Category"='BANKERS CHEQUE' THEN BEGIN
                                                                IF "Bankers Cheque Type"="Bankers Cheque Type"::Company THEN BEGIN

                                                                END;
                                                                END;


                                                                IF Type='Withdrawal' THEN BEGIN
                                                                Charges.RESET;
                                                                Charges.SETRANGE(Charges.Description,'Cash Withdrawal Charges');
                                                                IF Charges.FIND('-') THEN BEGIN
                                                                IF (Amount>=100)  AND (Amount<=5000) THEN
                                                                ChargeAmount:=Charges."Between 100 and 5000";

                                                                 IF  (Amount>=5001) AND (Amount<=10000) THEN
                                                                ChargeAmount:=Charges."Between 5001 - 10000";

                                                                IF (Amount>=10001) AND (Amount<=30000) THEN
                                                                  ChargeAmount:=Charges."Between 10001 - 30000";

                                                                IF (Amount>=30001) AND (Amount<=50000) THEN
                                                                ChargeAmount:=Charges."Between 30001 - 50000";

                                                                 IF (Amount>=50001) AND (Amount<=100000) THEN
                                                                ChargeAmount:=Charges."Between 50001 - 100000";

                                                                 IF (Amount>=100001) AND (Amount<=200000) THEN
                                                                   ChargeAmount:=Charges."Between 100001 - 200000";

                                                                IF (Amount>=200001) AND (Amount<=500000) THEN
                                                                 ChargeAmount:=Charges."Between 200001 - 500000";

                                                                IF (Amount>=500001) AND (Amount<=100000000.0) THEN
                                                                  ChargeAmount:=Charges."Between 500001 Above";
                                                                END;
                                                                END;
                                                                ExciseD:=0.2*ChargeAmount;
                                                                TotalDeduction:=ExciseD+ChargeAmount;
                                                                "Amount Plus Charges":=Amount+TotalDeduction;
                                                                Charges.GET('SMS');
                                                                TotalSMSCharge:=(20/100*10)+Charges."Charge Amount"+ChargeAmount;
                                                              END;

                                                   NotBlank=Yes }
    { 6   ;   ;Cashier             ;Code60        ;Editable=No }
    { 7   ;   ;Transaction Date    ;Date          ;OnValidate=BEGIN
                                                                IF "Transaction Mode" = "Transaction Mode"::Cheque THEN BEGIN
                                                                IF ChequeTypes.GET("Cheque Type") THEN BEGIN
                                                                CDays:=ChequeTypes."Clearing  Days"+1;

                                                                EMaturity:="Transaction Date";
                                                                IF i < CDays THEN BEGIN
                                                                REPEAT
                                                                EMaturity:=CALCDATE('1D',EMaturity);
                                                                IF (DATE2DWY(EMaturity,1) <> 6) AND (DATE2DWY(EMaturity,1) <> 7) THEN
                                                                i := i + 1;

                                                                UNTIL i = CDays;
                                                                END;

                                                                "Expected Maturity Date":=EMaturity;

                                                                END;
                                                                END;
                                                              END;

                                                   Editable=Yes }
    { 8   ;   ;Transaction Time    ;Time          ;Editable=No }
    { 9   ;   ;Posted              ;Boolean       ;Editable=Yes }
    { 10  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 11  ;   ;Account Type        ;Code20        ;TableRelation="Account Types-Saving Products".Code }
    { 12  ;   ;Account Description ;Text50         }
    { 13  ;   ;Denomination Total  ;Decimal        }
    { 14  ;   ;Cheque Type         ;Code20        ;TableRelation="Cheque Types";
                                                   OnValidate=BEGIN
                                                                IF ChequeTypes.GET("Cheque Type") THEN BEGIN
                                                                Description:=ChequeTypes.Description;
                                                                "Clearing Charges":=ChequeTypes."Clearing Charges";
                                                                "Clearing Days":=ChequeTypes."Clearing Days";

                                                                CDays:=ChequeTypes."Clearing  Days"; //+1;

                                                                EMaturity:="Transaction Date";
                                                                IF i < CDays THEN BEGIN
                                                                REPEAT
                                                                EMaturity:=CALCDATE('1D',EMaturity);
                                                                IF (DATE2DWY(EMaturity,1) <> 6) AND (DATE2DWY(EMaturity,1) <> 7) THEN
                                                                i := i + 1;

                                                                UNTIL i = CDays;
                                                                END;

                                                                "Expected Maturity Date":=EMaturity;

                                                                END;
                                                              END;
                                                               }
    { 15  ;   ;Cheque No           ;Code20        ;OnValidate=BEGIN
                                                                IF "Cheque No" <> '' THEN BEGIN
                                                                Trans.RESET;
                                                                Trans.SETCURRENTKEY(Trans."Cheque No");
                                                                Trans.SETRANGE(Trans."Cheque No","Cheque No");
                                                                Trans.SETRANGE(Trans.Posted,TRUE);
                                                                //IF Trans.FIND('-') THEN
                                                                //ERROR('There is an existing posted cheque No. %1',Trans.No);

                                                                END;
                                                              END;
                                                               }
    { 16  ;   ;Cheque Date         ;Date          ;OnValidate=BEGIN
                                                                IF "Cheque Date" > TODAY THEN
                                                                ERROR('Post dated cheques not allowed.');

                                                                IF CALCDATE('6M',"Cheque Date") < TODAY THEN
                                                                ERROR('Cheque stale therefore cannot be accepted.');
                                                              END;
                                                               }
    { 17  ;   ;Payee               ;Text100        }
    { 19  ;   ;Bank No             ;Code20        ;TableRelation="Bank Account";
                                                   OnLookup=BEGIN
                                                              "Bank No":=BanksList.Code;

                                                              BanksList.RESET;

                                                              IF BanksList.GET("Bank No") THEN BEGIN
                                                              "Bank Name":=BanksList."Bank Name";
                                                              END;

                                                              BanksList.RESET;
                                                            END;
                                                             }
    { 20  ;   ;Branch No           ;Code20        ;OnValidate=BEGIN
                                                                BanksList.RESET;
                                                                IF BanksList.GET("Branch No") THEN BEGIN
                                                                "Branch Name":=BanksList."Bank Name";
                                                                END;
                                                              END;
                                                               }
    { 21  ;   ;Clearing Charges    ;Decimal        }
    { 22  ;   ;Clearing Days       ;DateFormula    }
    { 23  ;   ;Description         ;Text150        }
    { 24  ;   ;Bank Name           ;Text150        }
    { 25  ;   ;Branch Name         ;Text150        }
    { 26  ;   ;Transaction Mode    ;Option        ;TableRelation="Transaction Type";
                                                   CaptionML=ENU=Payment Mode;
                                                   OptionCaptionML=ENU=Cash,Cheque;
                                                   OptionString=Cash,Cheque }
    { 27  ;   ;Type                ;Text50         }
    { 31  ;   ;Transaction Description;Text100     }
    { 32  ;   ;Minimum Account Balance;Decimal    ;FieldClass=Normal }
    { 33  ;   ;Fee Below Minimum Balance;Decimal   }
    { 34  ;   ;Normal Withdrawal Charge;Decimal    }
    { 36  ;   ;Authorised          ;Option        ;OnValidate=BEGIN
                                                                "Withdrawal FrequencyAuthorised" := Authorised;
                                                              END;

                                                   OptionString=No,Yes,Rejected,No Charges;
                                                   Editable=Yes }
    { 39  ;   ;Checked By          ;Text50         }
    { 40  ;   ;Fee on Withdrawal Interval;Decimal  }
    { 41  ;   ;Remarks             ;Text250        }
    { 42  ;   ;Status              ;Option        ;OptionString=Pending,Honoured,Stopped,Bounced }
    { 43  ;   ;Date Posted         ;Date           }
    { 44  ;   ;Time Posted         ;Time           }
    { 45  ;   ;Posted By           ;Text50         }
    { 46  ;   ;Expected Maturity Date;Date         }
    { 47  ;   ;Picture             ;BLOB          ;CaptionML=ENU=Picture;
                                                   SubType=Bitmap }
    { 48  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=ENU=Currency Code }
    { 49  ;   ;Transaction Category;Code20         }
    { 50  ;   ;Deposited           ;Boolean        }
    { 51  ;   ;Date Deposited      ;Date           }
    { 52  ;   ;Time Deposited      ;Time           }
    { 53  ;   ;Deposited By        ;Text20         }
    { 54  ;   ;Post Dated          ;Boolean        }
    { 55  ;   ;Select              ;Boolean        }
    { 56  ;   ;Status Date         ;Date           }
    { 57  ;   ;Status Time         ;Time           }
    { 58  ;   ;Supervisor Checked  ;Boolean        }
    { 59  ;   ;Book Balance        ;Decimal       ;FieldClass=Normal;
                                                   Editable=No }
    { 60  ;   ;Notice No           ;Code20         }
    { 61  ;   ;Notice Cleared      ;Option        ;OptionString=Pending,No,Yes,No Charges }
    { 62  ;   ;Schedule Amount     ;Decimal       ;DecimalPlaces=2:2 }
    { 63  ;   ;Has Schedule        ;Boolean        }
    { 64  ;   ;Requested           ;Boolean        }
    { 65  ;   ;Date Requested      ;Date           }
    { 66  ;   ;Time Requested      ;Time           }
    { 67  ;   ;Requested By        ;Text20         }
    { 68  ;   ;Overdraft           ;Boolean        }
    { 69  ;   ;Cheque Processed    ;Boolean        }
    { 70  ;   ;Staff/Payroll No    ;Text20        ;OnValidate=BEGIN
                                                                {Account.RESET;
                                                                Account.SETRANGE(Account."Staff/Payroll No","Staff/Payroll No");

                                                                IF Account.FIND('-')THEN BEGIN
                                                                MESSAGE('its there');
                                                                IF Account.Status=Account.Status::Dormant THEN BEGIN
                                                                Account.Status:=Account.Status::Active;
                                                                Account.MODIFY;
                                                                END;
                                                                IF Account.Status=Account.Status::New THEN BEGIN
                                                                END
                                                                ELSE BEGIN
                                                                IF Account.Status<>Account.Status::Active THEN
                                                                ERROR('The account is not active and therefore cannot be transacted upon.');
                                                                END;
                                                                END;


                                                                IF Account.GET("Staff/Payroll No") THEN BEGIN
                                                                "Account No":=Account."No.";
                                                                "Account Name":=Account.Name;
                                                                "Account Type":=Account."Account Type";
                                                                "Currency Code":=Account."Currency Code";

                                                                END;

                                                                IF AccountTypes.GET("Account Type") THEN BEGIN
                                                                "Account Description":=AccountTypes.Description;
                                                                "Minimum Account Balance":=AccountTypes."Minimum Balance";
                                                                "Fee Below Minimum Balance":=AccountTypes."Fee Below Minimum Balance";
                                                                //"Normal Withdrawal Charge":=AccountTypes."Withdrawal Charge";
                                                                "Fee on Withdrawal > Interval":=AccountTypes."Withdrawal Penalty";
                                                                END;

                                                                 }
                                                              END;
                                                               }
    { 71  ;   ;Cheque Transferred  ;Option        ;OptionString=No,Yes }
    { 72  ;   ;Expected Amount     ;Decimal        }
    { 73  ;   ;Line Totals         ;Decimal        }
    { 74  ;   ;Transfer Date       ;Date           }
    { 75  ;   ;BIH No              ;Code20         }
    { 76  ;   ;Transfer No         ;Code20         }
    { 77  ;   ;Attached            ;Boolean        }
    { 78  ;   ;BOSA Account No     ;Code20        ;TableRelation="Members Register".No. WHERE (Customer Type=FILTER(Member|MicroFinance),
                                                                                               Status=CONST(Active));
                                                   OnValidate=BEGIN
                                                                {Cust.RESET;
                                                                Cust.SETRANGE(Cust."No.","BOSA Account No");
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                Payee:=Cust.Name;
                                                                "Reference No":=Cust."Payroll/Staff No";
                                                                "Staff/Payroll No":=Cust."Payroll/Staff No";
                                                                "ID No":=Cust."ID No.";

                                                                END;
                                                                  }
                                                              END;

                                                   ValidateTableRelation=No }
    { 79  ;   ;Salary Processing   ;Option        ;OptionString=[ ,No,Yes] }
    { 80  ;   ;Expense Account     ;Code30         }
    { 81  ;   ;Expense Description ;Text150        }
    { 82  ;   ;Company Code        ;Code30        ;TableRelation="Sacco Employers".Code }
    { 83  ;   ;Schedule Type       ;Option        ;OptionString=,Salary Processing,Contributions,ATM EFT Transactions,Savings Loan Recoveries }
    { 84  ;   ;Banked By           ;Code20         }
    { 85  ;   ;Date Banked         ;Date           }
    { 86  ;   ;Time Banked         ;Time           }
    { 87  ;   ;Banking Posted      ;Boolean        }
    { 88  ;   ;Cleared By          ;Code20         }
    { 89  ;   ;Date Cleared        ;Date           }
    { 90  ;   ;Time Cleared        ;Time           }
    { 91  ;   ;Clearing Posted     ;Boolean        }
    { 92  ;   ;Needs Approval      ;Option        ;OptionString=Yes,No }
    { 93  ;   ;ID Type             ;Code20         }
    { 94  ;   ;ID No               ;Code50        ;OnValidate=BEGIN
                                                                IF "Transaction Type"='' THEN
                                                                ERROR('Please select the transaction type.');

                                                                {IF ("Account No"<>'00-0000003000') OR ("Account No"<>'00-0000000000')  THEN
                                                                ERROR('THIS ID. NO CANNOT BE MODIFIED');}
                                                                 "N.A.H Balance":=0;
                                                                VendLedg.RESET;
                                                                VendLedg.SETCURRENTKEY(VendLedg."External Document No.");
                                                                VendLedg.SETRANGE(VendLedg."External Document No.","ID No");
                                                                IF VendLedg.FIND('-') THEN BEGIN
                                                                VendLedg.CALCFIELDS(VendLedg.Amount);
                                                                 REPEAT
                                                                 "N.A.H Balance":=("N.A.H Balance"+VendLedg.Amount)*-1;
                                                                 MODIFY;
                                                                UNTIL VendLedg.NEXT=0;
                                                                END;
                                                              END;
                                                               }
    { 95  ;   ;Reference No        ;Code20         }
    { 96  ;   ;Refund Cheque       ;Boolean        }
    { 97  ;   ;Imported            ;Boolean        }
    { 98  ;   ;External Account No ;Code30         }
    { 99  ;   ;BOSA Transactions   ;Decimal       ;FieldClass=Normal;
                                                   Editable=No }
    { 100 ;   ;Bank Account        ;Code20        ;TableRelation="Bank Account".No. }
    { 101 ;   ;Savers Total        ;Decimal       ;FieldClass=Normal }
    { 102 ;   ;Mustaafu Total      ;Decimal       ;FieldClass=Normal }
    { 103 ;   ;Junior Star Total   ;Decimal       ;FieldClass=Normal }
    { 104 ;   ;Printed             ;Boolean        }
    { 105 ;   ;Account Type.       ;Option        ;CaptionML=ENU=Account Type;
                                                   OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner }
    { 106 ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type.=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Account Type.=CONST(Customer)) Customer
                                                                 ELSE IF (Account Type.=CONST(Vendor)) Vendor
                                                                 ELSE IF (Account Type.=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Account Type.=CONST(Fixed Asset)) "Fixed Asset"
                                                                 ELSE IF (Account Type.=CONST(IC Partner)) "IC Partner";
                                                   OnValidate=BEGIN

                                                                IF "Account Type." IN ["Account Type."::Customer,"Account Type."::Vendor,"Account Type."::
                                                                "IC Partner"] THEN


                                                                CASE "Account Type." OF
                                                                  "Account Type."::"G/L Account":
                                                                    BEGIN
                                                                      GLAcc.GET("Account No.");


                                                                END;


                                                                  "Account Type."::Customer:
                                                                    BEGIN
                                                                      Cust.GET("Account No.");

                                                                    END;
                                                                  "Account Type."::Vendor:
                                                                    BEGIN
                                                                      Vend.GET("Account No.");
                                                                    END;
                                                                  "Account Type."::"Bank Account":
                                                                    BEGIN
                                                                      BankAcc.GET("Account No.");
                                                                    END;
                                                                  "Account Type."::"Fixed Asset":
                                                                    BEGIN
                                                                      FA.GET("Account No.");
                                                                    END;
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Account No. }
    { 107 ;   ;Withdrawal FrequencyAuthorised;Option;
                                                   OptionString=No,Yes,Rejected }
    { 108 ;   ;Frequency Needs Approval;Option    ;OptionString=[ ,No,Yes] }
    { 109 ;   ;Special Advance No  ;Code20         }
    { 110 ;   ;Bankers Cheque Type ;Option        ;OnValidate=BEGIN
                                                                IF "Bankers Cheque Type"="Bankers Cheque Type"::Company THEN BEGIN
                                                                   GenLedgerSetup.GET;
                                                                  // GenLedgerSetup.TESTFIELD(GenLedgerSetup."Company Bankers Cheque Account");
                                                                  "Account Type.":="Account Type."::"G/L Account";
                                                                  //"Account No.":=GenLedgerSetup."Company Bankers Cheque Account";

                                                                END ELSE BEGIN
                                                                  "Account No.":='';
                                                                END;
                                                              END;

                                                   OptionString=Normal,Company }
    { 111 ;   ;Suspended Amount    ;Decimal        }
    { 112 ;   ;Transferred By EFT  ;Boolean        }
    { 113 ;   ;Banking User        ;Code20         }
    { 114 ;   ;Company Text Name   ;Code20         }
    { 115 ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter }
    { 116 ;   ;Total Salaries      ;Integer       ;FieldClass=Normal }
    { 117 ;   ;EFT Transferred     ;Boolean        }
    { 118 ;   ;ATM Transactions Total;Decimal     ;FieldClass=Normal }
    { 119 ;   ;Bank Code           ;Code20        ;TableRelation="Bank Account".No.;
                                                   OnValidate=BEGIN
                                                                IF BanksList.GET("Bank Code") THEN BEGIN
                                                                "Bank Name":=BanksList."Bank Name";
                                                                "Branch Name":=BanksList.Branch;
                                                                END;
                                                              END;
                                                               }
    { 120 ;   ;External Account Name;Text50        }
    { 121 ;   ;Overdraft Limit     ;Decimal        }
    { 122 ;   ;Overdraft Allowed   ;Boolean        }
    { 123 ;   ;Available Balance   ;Decimal        }
    { 124 ;   ;Authorisation Requirement;Text50    }
    { 125 ;   ;Bankers Cheque No   ;Code20        ;TableRelation="Banker Cheque Register"."Banker Cheque No." WHERE (Issued=CONST(No),
                                                                                                                     Cancelled=CONST(No));
                                                   OnValidate=BEGIN
                                                                IF BRegister.GET("Bankers Cheque No") THEN BEGIN
                                                                BRegister.Issued:=TRUE;
                                                                BRegister.MODIFY;
                                                                END;
                                                              END;

                                                   ValidateTableRelation=No }
    { 126 ;   ;Transaction Span    ;Option        ;OptionCaptionML=ENU=FOSA,BOSA;
                                                   OptionString=FOSA,BOSA }
    { 127 ;   ;Uncleared Cheques   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum(Transactions.Amount WHERE (Account No=FIELD(Account No),
                                                                                              Posted=CONST(Yes),
                                                                                              Cheque Processed=CONST(No),
                                                                                              Type=CONST(Cheque Deposit)));
                                                   Editable=No }
    { 128 ;   ;Transaction Available Balance;Decimal }
    { 129 ;   ;Branch Account      ;Code20        ;TableRelation=Vendor.No. WHERE (Creditor Type=CONST(Account),
                                                                                   Account Category=CONST(Branch));
                                                   OnValidate=BEGIN
                                                                IF Acc.GET("Branch Account") THEN
                                                                "FOSA Branch Name":=Acc.Name;
                                                              END;
                                                               }
    { 130 ;   ;Branch Transaction  ;Boolean        }
    { 131 ;   ;FOSA Branch Name    ;Text30         }
    { 133 ;   ;Branch Refference   ;Text30         }
    { 134 ;   ;Branch Account No   ;Code20         }
    { 135 ;   ;Branch Transaction Date;Date        }
    { 136 ;   ;Post Attempted      ;Boolean        }
    { 137 ;   ;Transacting Branch  ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2)) }
    { 138 ;   ;Signature           ;BLOB          ;SubType=Bitmap }
    { 139 ;   ;Allocated Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Receipt Allocation"."Total Amount" WHERE (Document No=FIELD(No),
                                                                                                              Member No=FIELD(BOSA Account No)));
                                                   Editable=No }
    { 140 ;   ;Amount Discounted   ;Decimal        }
    { 141 ;   ;Dont Clear          ;Boolean        }
    { 142 ;   ;Other Bankers No.   ;Code100        }
    { 62000;  ;N.A.H Balance       ;Decimal        }
    { 62001;  ;Cheque Deposit Remarks;Text50       }
    { 62002;  ;Balancing Account   ;Code20        ;TableRelation=Vendor.No. }
    { 62003;  ;Balancing Account Name;Text50      ;OnValidate=BEGIN
                                                                Vend.RESET;

                                                                IF Vend.GET(No) THEN BEGIN
                                                                "Balancing Account Name":=Vend.Name;
                                                                END;
                                                              END;
                                                               }
    { 62004;  ;Bankers Cheque Payee;Text80         }
    { 62005;  ;Atm Number          ;Text30         }
    { 62006;  ;Member Name         ;Text50         }
    { 62007;  ;Savings Product     ;Code20        ;TableRelation="Account Types-Saving Products".Code }
    { 62008;  ;Member No           ;Code20        ;TableRelation="Members Register".No.;
                                                   OnValidate=BEGIN
                                                                  Cust.RESET;
                                                                  Cust.SETRANGE(Cust."No.","Member No");
                                                                  IF Cust.FIND('-') THEN BEGIN
                                                                    "Member Name":=Cust.Name;
                                                                    END;
                                                              END;
                                                               }
    { 62009;  ;Withdarawal         ;Boolean        }
    { 62010;  ;Payee Bank No       ;Code15         }
    { 62011;  ;Cheque Drawer       ;Text30         }
    { 62012;  ;ChargeTransfer      ;Boolean       ;OnValidate=BEGIN
                                                                 { {Trans.RESET;
                                                                  Trans.SETRANGE(Trans.No,No);
                                                                   IF Trans.FIND('-') THEN BEGIN

                                                                   IF Trans.ChargeTransfer=FALSE THEN BEGIN

                                                                    Trans.ChargeTransfer:=TRUE;
                                                                   //Trans.MODIFY;
                                                                      EXIT;
                                                                    END;



                                                                     IF Trans.ChargeTransfer=TRUE THEN BEGIN

                                                                     Trans.ChargeTransfer:=FALSE;
                                                                    // Trans.MODIFY;

                                                                     END;
                                                                     EXIT;
                                                                     END;
                                                                   //END;
                                                                {
                                                                    ELSE IF ChargeTransfer=FALSE THEN BEGIN
                                                                      Trans.RESET;
                                                                      Trans.SETRANGE(Trans.No,No);
                                                                     IF Trans.FIND('-') THEN
                                                                      MESSAGE('yes false 100%');
                                                                      Trans.ChargeTransfer:=FALSE;
                                                                       END;
                                                                       }
                                                                       //}
                                                                  }
                                                              END;
                                                               }
    { 62013;  ;Signature 2         ;BLOB          ;CaptionML=ENU=Signature;
                                                   SubType=Bitmap }
    { 62014;  ;Front Side ID       ;BLOB          ;CaptionML=ENU=Front Side ID;
                                                   SubType=Bitmap }
    { 62015;  ;Back Side ID        ;BLOB          ;CaptionML=ENU=Back Side ID;
                                                   SubType=Bitmap }
    { 62016;  ;Cheque Status       ;Option        ;OptionCaptionML=ENU=" ,Open,Approved,Rejected,Pending";
                                                   OptionString=[ ,Open,Approved,Rejected,Pending] }
    { 62017;  ;Amount Plus Charges ;Decimal       ;Editable=No }
    { 62018;  ;Clear Cheque        ;Boolean       ;Editable=Yes }
    { 62019;  ;Reason For Approving/Bouncing;Text100 }
    { 62020;  ;Customer Bank       ;Code40        ;TableRelation="KBA Bank Names"."Bank Code" }
    { 62021;  ;Bank Branch         ;Text60         }
    { 62022;  ;Drawer Name         ;Text100        }
    { 62023;  ;Cheque Status.      ;Option        ;OptionCaptionML=ENU=Pending,Matured,Bounced;
                                                   OptionString=Pending,Matured,Bounced }
    { 62024;  ;Front ID            ;BLOB          ;SubType=Bitmap }
    { 62025;  ;Account TO Channel Funds;Decimal    }
  }
  KEYS
  {
    {    ;No                                      ;Clustered=Yes }
    {    ;Transfer No                             ;SumIndexFields=Amount }
    {    ;Type,Transaction Date,Posted,Transaction Category;
                                                   SumIndexFields=Amount }
    {    ;Account No,Cheque Processed,Deposited,Transaction Category;
                                                   SumIndexFields=Amount }
    {    ;Deposited,Posted,Transaction Category,Transaction Date,Has Schedule;
                                                   SumIndexFields=Amount }
    {    ;Requested,Transaction Category,Transaction Date;
                                                   SumIndexFields=Amount }
    {    ;Account No,Cheque Processed,Posted,Type ;SumIndexFields=Amount }
    {    ;Cheque No                                }
    {    ;Transaction Type,Transaction Date,Posted;SumIndexFields=Amount }
    {    ;Bankers Cheque No                        }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NoSetup@1031 : Record 51516258;
      NoSeriesMgt@1030 : Codeunit 396;
      Account@1029 : Record 23;
      AccountTypes@1028 : Record 51516295;
      ChequeTypes@1027 : Record 51516304;
      Banks@1026 : Record 270;
      BankBranches@1025 : Record 51516312;
      PaymentMethod@1024 : Record 289;
      TransactionTypes@1023 : Record 51516298;
      Denominations@1022 : Record 51516303;
      Cust@1021 : Record 51516223;
      i@1020 : Integer;
      PublicHoliday@1019 : Integer;
      weekday@1018 : Integer;
      CDays@1017 : Integer;
      BanksList@1016 : Record 51516311;
      GLAcc@1015 : Record 15;
      Vend@1014 : Record 23;
      BankAcc@1013 : Record 270;
      FA@1012 : Record 5600;
      GenLedgerSetup@1011 : Record 98;
      TransactionCharges@1010 : Record 51516300;
      VarAmtHolder@1009 : Decimal;
      DimValue@1008 : Record 349;
      EMaturity@1007 : Date;
      BRegister@1006 : Record 51516313;
      Acc@1005 : Record 23;
      UsersID@1004 : Record 2000000120;
      Trans@1003 : Record 51516299;
      VendLedg@1002 : Record 25;
      ATMApp@1001 : Record 51516321;
      CustM@1000 : Record 23;
      PictureExists@1120054000 : Boolean;
      SignatureExists@1120054001 : Boolean;
      FrontSideIDExist@1120054002 : Boolean;
      BackSideIDExist@1120054003 : Boolean;
      Charges@1120054004 : Record 51516297;
      ChargeAmount@1120054005 : Decimal;
      ExciseD@1120054006 : Decimal;
      TotalDeduction@1120054007 : Decimal;
      TotalSMSCharge@1120054008 : Decimal;
      Vendor@1120054011 : Record 23;
      AccTypes@1120054010 : Record 51516295;
      MinimumBal@1120054009 : Decimal;
      Customer@1120054012 : Record 23;
      Customers@1120054013 : Record 51516223;

    BEGIN
    END.
  }
}

