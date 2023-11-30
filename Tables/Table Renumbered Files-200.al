OBJECT table 17319 EFT Details
{
  OBJECT-PROPERTIES
  {
    Date=08/18/16;
    Time=10:45:55 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN

               IF No = '' THEN BEGIN
               NoSetup.GET();
               NoSetup.TESTFIELD(NoSetup."EFT Details Nos.");
               NoSeriesMgt.InitSeries(NoSetup."EFT Details Nos.",xRec."No. Series",0D,No,"No. Series");
               END;

               "Date Entered":=TODAY;
               "Time Entered":=TIME;
               "Entered By":=USERID;
             END;

    OnModify=BEGIN
               IF Transferred = TRUE THEN
               ERROR('You cannot modify an already posted record.');
             END;

    OnDelete=BEGIN
               IF Transferred = TRUE THEN
               ERROR('You cannot modify an already posted record.');

               Transactions.RESET;
               Transactions.SETRANGE(Transactions."Cheque No",No);
               //Transactions.SETRANGE(Transactions."Transaction Type",'EFT');
               //Transactions.SETRANGE(Transactions."Account No","Account No");
               IF Transactions.FIND('-') THEN
               Transactions.DELETEALL;

               Transactions.RESET;
               Transactions.SETRANGE(Transactions."Cheque No",No);
               //Transactions.SETRANGE(Transactions."Transaction Type",'EFTT');
               //Transactions.SETRANGE(Transactions."Account No","Account No");
               IF Transactions.FIND('-') THEN
               Transactions.DELETEALL;
             END;

  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20        ;OnValidate=BEGIN


                                                                IF No <> xRec.No THEN BEGIN
                                                                  NoSetup.GET();
                                                                  NoSeriesMgt.TestManual(NoSetup."EFT Details Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Account No          ;Code20        ;TableRelation=Vendor.No.;
                                                   OnValidate=BEGIN
                                                                IF Accounts.GET("Account No") THEN BEGIN
                                                                //Block Payments
                                                                IF (Accounts.Blocked = Accounts.Blocked::Payment) OR
                                                                   (Accounts.Blocked = Accounts.Blocked::All) THEN
                                                                ERROR('This account has been blocked from receiving payments. %1',"Account No");


                                                                "Account Name":=Accounts.Name;
                                                                "Destination Account Name":=COPYSTR(Accounts.Name,1,28);
                                                                "Account Type":=Accounts."Account Type";
                                                                "Member No":=Accounts."BOSA Account No";
                                                                "Staff No":=Accounts."Staff No";
                                                                Amount:=0;
                                                                //Remarks:='STIMA';
                                                                {IF AccountTypes.GET(Accounts."Account Type") THEN BEGIN
                                                                IF "Destination Account Type" = "Destination Account Type"::External THEN
                                                                Charges:=AccountTypes."External EFT Charges"
                                                                ELSE
                                                                Charges:=AccountTypes."Internal EFT Charges";

                                                                AccountTypes.TESTFIELD(AccountTypes."EFT Charges Account");
                                                                "EFT Charges Account":=AccountTypes."EFT Charges Account";

                                                                IF EFTHeader.GET("Header No") THEN BEGIN
                                                                IF EFTHeader.RTGS = TRUE THEN BEGIN
                                                                Charges:=AccountTypes."RTGS Charges";
                                                                AccountTypes.TESTFIELD(AccountTypes."RTGS Charges Account");
                                                                "EFT Charges Account":=AccountTypes."RTGS Charges Account";
                                                                END;
                                                                END;

                                                                END;}

                                                                END;




                                                                VALIDATE("Destination Account Type");
                                                              END;

                                                   NotBlank=Yes }
    { 3   ;   ;Account Name        ;Code100        }
    { 4   ;   ;Account Type        ;Code20         }
    { 7   ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                {AvailableBal:=0;


                                                                //Available Bal
                                                                IF Accounts.GET("Account No") THEN BEGIN
                                                                Accounts.CALCFIELDS(Accounts.Balance,Accounts."Uncleared Cheques",Accounts."ATM Transactions");
                                                                IF AccountTypes.GET(Accounts."Account Type") THEN BEGIN
                                                                AvailableBal:=Accounts.Balance-(Accounts."Uncleared Cheques"+Accounts."ATM Transactions"+Charges+AccountTypes."Minimum Balance");

                                                                //Other EFT's
                                                                {//PKK
                                                                OtherEFT:=0;
                                                                EFTDetails.RESET;
                                                                EFTDetails.SETRANGE(EFTDetails."Header No","Header No");
                                                                EFTDetails.SETRANGE(EFTDetails."Account No","Account No");
                                                                IF EFTDetails.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                IF EFTDetails.No <> No THEN
                                                                OtherEFT:=OtherEFT+EFTDetails.Amount+EFTDetails.Charges;

                                                                UNTIL EFTDetails.NEXT = 0;
                                                                END;
                                                                }//PKK

                                                                AvailableBal:=AvailableBal-OtherEFT;


                                                                IF Amount > AvailableBal THEN
                                                                ERROR('EFT Amount cannot be more than the availble balance. %1 - %2',AvailableBal,"Account No");
                                                                //Available Bal


                                                                //Make EFT unavailable
                                                                //{//PLEASE UNCOMMENT
                                                                Transactions.RESET;
                                                                Transactions.SETRANGE(Transactions."Cheque No",No);
                                                                IF Transactions.FIND('-') THEN
                                                                Transactions.DELETEALL;

                                                                Transactions.No:='';
                                                                Transactions."Account No":="Account No";
                                                                Transactions.VALIDATE(Transactions."Account No");
                                                                IF Accounts."Account Type" = 'TWIGA' THEN
                                                                Transactions."Transaction Type":='EFTT'
                                                                ELSE IF Accounts."Account Type" = 'OMEGA' THEN
                                                                Transactions."Transaction Type":='EFTMGA'
                                                                ELSE
                                                                Transactions."Transaction Type":='EFT';
                                                                //Transactions.VALIDATE(Transactions."Transaction Type");
                                                                Transactions."Cheque No":=No;
                                                                Transactions.Amount:=Amount;
                                                                Transactions.Posted:=TRUE;
                                                                Transactions.INSERT(TRUE);
                                                                //}//PLEASE UNCOMMENT
                                                                //Make EFT unavailable

                                                                END ELSE
                                                                ERROR('Account type not found.');
                                                                END ELSE
                                                                ERROR('Account No. not found.');
                                                                 }
                                                              END;
                                                               }
    { 8   ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 11  ;   ;Destination Account No;Code20      ;TableRelation=IF (Destination Account Type=CONST(Internal)) Vendor.No. WHERE (Creditor Type=CONST(Account));
                                                   OnValidate=BEGIN
                                                                IF AccountHolders.GET("Destination Account No") THEN BEGIN
                                                                "Destination Account Name":=AccountHolders.Name;
                                                                END;
                                                              END;
                                                               }
    { 12  ;   ;Destination Account Name;Text30    ;OnValidate=BEGIN
                                                                IF STRLEN("Destination Account Name") > 28 THEN
                                                                ERROR('Destintion account name cannot be more than 28 characters.');
                                                              END;
                                                               }
    { 13  ;   ;Destination Account Type;Option    ;OnValidate=BEGIN
                                                                {
                                                                IF Accounts.GET("Account No") THEN BEGIN
                                                                IF AccountTypes.GET(Accounts."Account Type") THEN BEGIN
                                                                IF "Destination Account Type" = "Destination Account Type"::External THEN
                                                                Charges:=AccountTypes."External EFT Charges"
                                                                ELSE
                                                                Charges:=AccountTypes."Internal EFT Charges";
                                                                AccountTypes.TESTFIELD(AccountTypes."EFT Charges Account");
                                                                "EFT Charges Account":=AccountTypes."EFT Charges Account";


                                                                IF EFTHeader.GET("Header No") THEN BEGIN
                                                                IF EFTHeader.RTGS = TRUE THEN BEGIN
                                                                Charges:=AccountTypes."RTGS Charges";
                                                                AccountTypes.TESTFIELD(AccountTypes."RTGS Charges Account");
                                                                "EFT Charges Account":=AccountTypes."RTGS Charges Account";
                                                                END;
                                                                END;

                                                                END;
                                                                END;
                                                                }
                                                              END;

                                                   OptionString=External,Internal }
    { 14  ;   ;Transferred         ;Boolean        }
    { 15  ;   ;Date Transferred    ;Date           }
    { 16  ;   ;Time Transferred    ;Time           }
    { 17  ;   ;Transferred By      ;Text20         }
    { 18  ;   ;Date Entered        ;Date           }
    { 19  ;   ;Time Entered        ;Time           }
    { 20  ;   ;Entered By          ;Text20         }
    { 21  ;   ;Remarks             ;Text150        }
    { 22  ;   ;Payee Bank Name     ;Text200        }
    { 23  ;   ;Bank No             ;Code20        ;TableRelation="Member App Signatories"."Account No";
                                                   OnValidate=BEGIN
                                                                BanksList.RESET;
                                                                BanksList.SETRANGE(BanksList.Code,"Bank No");
                                                                IF BanksList.FIND('-') THEN BEGIN
                                                                "Payee Bank Name":=BanksList."Bank Name";
                                                                END;
                                                              END;
                                                               }
    { 24  ;   ;Charges             ;Decimal        }
    { 25  ;   ;Header No           ;Code20        ;TableRelation="Members Next Kin Details".Field1 }
    { 26  ;   ;Member No           ;Code20         }
    { 27  ;   ;Amount Text         ;Text20         }
    { 28  ;   ;ExportFormat        ;Text78         }
    { 29  ;   ;EAccNo              ;Text20         }
    { 30  ;   ;EBankCode           ;Text6          }
    { 31  ;   ;EAccName            ;Text32         }
    { 32  ;   ;EAmount             ;Text10         }
    { 33  ;   ;EReff               ;Text5          }
    { 34  ;   ;Staff No            ;Code20         }
    { 35  ;   ;Over Drawn          ;Boolean        }
    { 37  ;   ;Primary             ;Decimal        }
    { 38  ;   ;Standing Order No   ;Code20         }
    { 39  ;   ;EFT Type            ;Option        ;OptionString=Normal,ATM EFT }
    { 40  ;   ;EFT Charges Account ;Code20        ;TableRelation="G/L Account".No. }
    { 41  ;   ;Standing Order Register No;Code20   }
    { 42  ;   ;Don't Charge        ;Boolean        }
    { 43  ;   ;Phone No.           ;Text50         }
    { 44  ;   ;Not Available       ;Boolean        }
  }
  KEYS
  {
    {    ;Header No,Account No,Destination Account No,No;
                                                   SumIndexFields=Amount;
                                                   Clustered=Yes }
    {    ;Header No,No                             }
    {    ;Staff No                                 }
    {    ;Account No,Not Available,Transferred    ;SumIndexFields=Amount }
    {    ;Date Entered                            ;SumIndexFields=Amount }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NoSetup@1000000001 : Record 51516258;
      NoSeriesMgt@1000000000 : Codeunit 396;
      Accounts@1000000002 : Record 23;
      Members@1000000003 : Record 23;
      AccountHolders@1000000004 : Record 23;
      Banks@1000000005 : Record 270;
      BanksList@1000000008 : Record 51516311;
      StLen@1000000009 : Integer;
      GenAmount@1000000010 : Text[50];
      FundsTransferDetails@1000000011 : Record 51516315;
      AccountTypes@1000000012 : Record 51516295;
      MinimumAccBal@1000000013 : Decimal;
      EFTCHG@1000000014 : Decimal;
      GenLedgerSetup@1000000015 : Record 98;
      ATMBalance@1000000016 : Decimal;
      TotalUnprocessed@1000000017 : Decimal;
      chqtransactions@1000000018 : Record 51516299;
      AccBal@1000000019 : Decimal;
      AvailableBal@1102760000 : Decimal;
      Transactions@1102760001 : Record 51516299;
      EFTDetails@1102760002 : Record 51516315;
      OtherEFT@1102760003 : Decimal;
      EFTHeader@1102760004 : Record 51516314;

    BEGIN
    END.
  }
}

