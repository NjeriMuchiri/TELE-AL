OBJECT table 20462 MBanking Receipt Line
{
  OBJECT-PROPERTIES
  {
    Date=11/23/20;
    Time=12:06:04 PM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    LookupPageID=Page52018;
    DrillDownPageID=Page52018;
  }
  FIELDS
  {
    { 1   ;   ;Line No             ;Integer       ;AutoIncrement=Yes }
    { 2   ;   ;Receipt No.         ;Code20         }
    { 3   ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset }
    { 4   ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                 ELSE IF (Account Type=CONST(Bank Account)) "Bank Account";
                                                   OnValidate=BEGIN
                                                                CASE "Account Type" OF
                                                                 "Account Type"::"G/L Account":
                                                                  BEGIN
                                                                   IF GLAccount.GET("Account No.") THEN
                                                                      "Account Name":=GLAccount.Name;
                                                                  END;
                                                                  "Account Type"::Customer:
                                                                  BEGIN
                                                                  IF Cust.GET("Account No.") THEN
                                                                     "Account Name":=Cust.Name;
                                                                  END;
                                                                  "Account Type"::Vendor:
                                                                  BEGIN
                                                                   IF Vendor.GET("Account No.") THEN
                                                                      "Account Name":=Vendor.Name;
                                                                   END;
                                                                 END;
                                                              END;
                                                               }
    { 5   ;   ;Account Name        ;Text50         }
    { 6   ;   ;Description         ;Text70         }
    { 7   ;   ;VAT Code            ;Code20        ;TableRelation="VAT Product Posting Group" }
    { 8   ;   ;W/Tax Code          ;Code20        ;TableRelation="VAT Product Posting Group" }
    { 9   ;   ;VAT Amount          ;Decimal        }
    { 10  ;   ;W/Tax Amount        ;Decimal        }
    { 11  ;   ;Amount              ;Decimal       ;OnValidate=BEGIN

                                                                TESTFIELD("Account No.");
                                                                TESTFIELD(Description);
                                                                IF "Transaction Type" = "Transaction Type"::" " THEN
                                                                  ERROR('Kindly Capture the Transaction Type');

                                                                IF ("Transaction Type"="Transaction Type"::"Interest Paid") OR ("Transaction Type"="Transaction Type"::Repayment) THEN BEGIN
                                                                    TESTFIELD("Loan Type Code");
                                                                    TESTFIELD("Loan No");
                                                                END;
                                                                IF ("Transaction Type"="Transaction Type"::Loan) OR ("Transaction Type"="Transaction Type"::"Interest Due") THEN BEGIN

                                                                  ERROR('Invalid Transaction Type');
                                                                END;
                                                              END;
                                                               }
    { 12  ;   ;Net Amount          ;Decimal        }
    { 13  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionClass='1,1,1' }
    { 14  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionClass='1,1,2' }
    { 15  ;   ;Applies to Doc. No  ;Code20        ;OnValidate=VAR
                                                                CustLedgEntry@1000 : Record 21;
                                                                VendLedgEntry@1003 : Record 25;
                                                                TempGenJnlLine@1001 : TEMPORARY Record 81;
                                                              BEGIN

                                                                CASE "Account Type" OF
                                                                 "Account Type"::Customer:
                                                                  BEGIN
                                                                    CustLedger.RESET;
                                                                    CustLedger.SETRANGE("Customer No.","Account No.");
                                                                    CustLedger.SETRANGE(Open,TRUE);
                                                                    CustLedger.SETRANGE("Document No.","Applies to Doc. No");
                                                                     IF CustLedger.FIND('-') THEN
                                                                      "Applies-to Doc. Type":=CustLedger."Document Type";
                                                                  END;
                                                                 "Account Type"::Vendor:
                                                                  BEGIN
                                                                    VendLedger.RESET;
                                                                    VendLedger.SETRANGE("Vendor No.","Account No.");
                                                                    VendLedger.SETRANGE(Open,TRUE);
                                                                    VendLedger.SETRANGE("Document No.","Applies to Doc. No");
                                                                     IF VendLedger.FIND('-') THEN
                                                                      "Applies-to Doc. Type":=VendLedger."Document Type";

                                                                  END;
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              GenJnlPostLine@1000 : Codeunit 12;
                                                              PaymentToleranceMgt@1001 : Codeunit 426;
                                                            BEGIN
                                                              "Applies to Doc. No":='';
                                                                Amt:=0;
                                                                NetAmount:=0;
                                                                //VATAmount:=0;
                                                               //"W/TAmount":=0;

                                                              CASE "Account Type" OF
                                                              "Account Type"::Customer:
                                                              BEGIN
                                                               CustLedger.RESET;
                                                               CustLedger.SETCURRENTKEY(CustLedger."Customer No.",Open,"Document No.");
                                                               CustLedger.SETRANGE(CustLedger."Customer No.","Account No.");
                                                               CustLedger.SETRANGE(Open,TRUE);
                                                               CustLedger.CALCFIELDS("Remaining Amount");
                                                              IF PAGE.RUNMODAL(0,CustLedger) = ACTION::LookupOK THEN BEGIN

                                                              IF CustLedger."Applies-to ID"<>'' THEN BEGIN
                                                               CustLedger1.RESET;
                                                               CustLedger1.SETCURRENTKEY(CustLedger1."Customer No.",Open,"Applies-to ID");
                                                               CustLedger1.SETRANGE(CustLedger1."Customer No.","Account No.");
                                                               CustLedger1.SETRANGE(Open,TRUE);
                                                               CustLedger1.SETRANGE("Applies-to ID",CustLedger."Applies-to ID");
                                                               IF CustLedger1.FIND('-') THEN BEGIN
                                                                 REPEAT
                                                                   CustLedger1.CALCFIELDS("Remaining Amount");
                                                                   Amt:=Amt+ABS(CustLedger1."Remaining Amount");
                                                                 UNTIL CustLedger1.NEXT=0;
                                                                END;

                                                              IF Amt<>Amt THEN
                                                               //ERROR('Amount is not equal to the amount applied on the application form');
                                                               IF Amount=0 THEN
                                                               Amount:=Amt;
                                                               VALIDATE(Amount);
                                                               "Applies to Doc. No":=CustLedger."Document No.";
                                                              END ELSE BEGIN
                                                              IF Amount<>ABS(CustLedger."Remaining Amount") THEN
                                                              CustLedger.CALCFIELDS(CustLedger."Remaining Amount");
                                                               IF Amount=0 THEN
                                                              Amount:=ABS(CustLedger."Remaining Amount");
                                                              VALIDATE(Amount);
                                                              "Applies to Doc. No":=CustLedger."Document No.";
                                                              END;
                                                              END;
                                                              VALIDATE(Amount);
                                                              END;

                                                              "Account Type"::Vendor:
                                                              BEGIN
                                                               VendLedger.RESET;
                                                               VendLedger.SETCURRENTKEY(VendLedger."Vendor No.",Open,"Document No.");
                                                               VendLedger.SETRANGE(VendLedger."Vendor No.","Account No.");
                                                               VendLedger.SETRANGE(Open,TRUE);
                                                               VendLedger.CALCFIELDS("Remaining Amount");
                                                              IF PAGE.RUNMODAL(0,VendLedger) = ACTION::LookupOK THEN BEGIN

                                                              IF VendLedger."Applies-to ID"<>'' THEN BEGIN
                                                               VendLedger1.RESET;
                                                               VendLedger1.SETCURRENTKEY(VendLedger1."Vendor No.",Open,"Applies-to ID");
                                                               VendLedger1.SETRANGE(VendLedger1."Vendor No.","Account No.");
                                                               VendLedger1.SETRANGE(Open,TRUE);
                                                               VendLedger1.SETRANGE(VendLedger1."Applies-to ID",VendLedger."Applies-to ID");
                                                               IF VendLedger1.FIND('-') THEN BEGIN
                                                                 REPEAT
                                                                   VendLedger1.CALCFIELDS(VendLedger1."Remaining Amount");

                                                                   NetAmount:=NetAmount+ABS(VendLedger1."Remaining Amount");
                                                                 UNTIL VendLedger1.NEXT=0;
                                                                END;

                                                              IF NetAmount<>NetAmount THEN
                                                               //ERROR('Amount is not equal to the amount applied on the application form');
                                                                IF Amount=0 THEN
                                                               Amount:=NetAmount;

                                                               VALIDATE(Amount);
                                                               "Applies to Doc. No":=VendLedger."Document No.";
                                                              END ELSE BEGIN
                                                              IF Amount<>ABS(VendLedger."Remaining Amount") THEN
                                                              VendLedger.CALCFIELDS(VendLedger."Remaining Amount");
                                                               IF Amount=0 THEN
                                                              Amount:=ABS(VendLedger."Remaining Amount");
                                                              VALIDATE(Amount);
                                                              "Applies to Doc. No":=VendLedger."Document No.";
                                                              END;
                                                              END;
                                                              Amount:=ABS(VendLedger."Remaining Amount");
                                                              VALIDATE(Amount);
                                                              END;
                                                              END;
                                                            END;

                                                   CaptionML=ENU=Applies-to Doc. No. }
    { 16  ;   ;Applies-to Doc. Type;Option        ;CaptionML=ENU=Applies-to Doc. Type;
                                                   OptionCaptionML=ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund";
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 17  ;   ;Pay Mode            ;Code20         }
    { 18  ;   ;TDNo                ;Integer       ;Editable=No }
    { 19  ;   ;Date                ;Date           }
    { 20  ;   ;Loan No             ;Code100       ;TableRelation="Loans Register"."Loan  No." WHERE (Loan  No.=FIELD(Loan No),
                                                                                                     Posted=CONST(Yes),
                                                                                                     Client Code=FIELD(Account No.),
                                                                                                     Loan Product Type=FIELD(Loan Type Code));
                                                   OnValidate=BEGIN
                                                                {LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."Loan  No.","Loan No");
                                                                IF LoanApp.FIND('-') THEN BEGIN
                                                                LoanApp.CALCFIELDS(LoanApp."Oustanding Balance",LoanApp."Oustanding Interest");
                                                                IF RHeader."Transaction Type"=RHeader."Transaction Type"::Repayment THEN BEGIN
                                                                IF LoanApp."Oustanding Balance"=0 THEN
                                                                ERROR('This loan does not have a balance');
                                                                END;
                                                                //IF "Transaction Type"="Transaction Type"::"Interest Paid" THEN BEGIN
                                                                //IF LoanApp."Oustanding Interest"=0 THEN
                                                                //ERROR('This loan does not have outstanding Interest');
                                                                //END;

                                                                END;}
                                                              END;
                                                               }
    { 21  ;   ;Transaction Type    ;Option        ;OnValidate=BEGIN
                                                                IF ("Transaction Type"="Transaction Type"::Loan) OR ("Transaction Type"="Transaction Type"::Repayment) THEN
                                                                  TESTFIELD("Loan Type Code");
                                                              END;

                                                   OptionCaptionML=ENU=" ,Junior Account,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Deposit Contribution,Benevolent Fund,Registration Fee,Administration Fee,Appraisal,Dividend,Withholding Tax,Shares Contributions,Welfare Contribution 2,Loan Adjustment,Holiday Savings,Unallocated Funds";
                                                   OptionString=[ ,Junior Account,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Deposit Contribution,Benevolent Fund,Registration Fee,Administration Fee,Appraisal,Dividend,Withholding Tax,Shares Contributions,Welfare Contribution 2,Loan Adjustment,Holiday Savings,Unallocated Funds] }
    { 22  ;   ;Loan Type Code      ;Code10        ;TableRelation="Loan Products Setup";
                                                   OnValidate=BEGIN
                                                                IF LoanProductTypes.GET("Loan Type Code") THEN
                                                                  "Loan Type Name":=LoanProductTypes."Product Description";
                                                              END;
                                                               }
    { 23  ;   ;Loan Type Name      ;Text30         }
    { 24  ;   ;Posted              ;Boolean        }
  }
  KEYS
  {
    {    ;Line No,Receipt No.                     ;SumIndexFields=Amount;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      GLAccount@1000000000 : Record 15;
      Cust@1000000001 : Record 18;
      Vendor@1000000002 : Record 23;
      FixedAsset@1000000003 : Record 5600;
      BankAccount@1000000004 : Record 270;
      CustLedger@1000000008 : Record 21;
      CustLedger1@1000000007 : Record 21;
      VendLedger@1000000006 : Record 25;
      VendLedger1@1000000005 : Record 25;
      Amt@1000000009 : Decimal;
      NetAmount@1000000010 : Decimal;
      RHeader@1000000011 : Record 51516712;
      LoanProductTypes@1001 : Record 51516240;
      LoanApp@1000 : Record 51516230;

    BEGIN
    END.
  }
}

