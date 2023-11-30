OBJECT table 17332 Over Draft Authorisation
{
  OBJECT-PROPERTIES
  {
    Date=10/24/22;
    Time=10:44:43 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=VAR
               ODAuth@1120054000 : Record 51516328;
             BEGIN

               IF NOT Mobile THEN BEGIN
                   ODAuth.RESET;
                   ODAuth.SETRANGE(Status,ODAuth.Status::Open);
                   IF ODAuth.FINDLAST THEN
                     ERROR('Please utilize overdraft %1, before proceeding!',ODAuth."No.");
               END;

               IF "No." = '' THEN BEGIN
                 NoSetup.GET;
                 NoSetup.TESTFIELD(NoSetup."Overdraft App Nos.");
                 NoSeriesMgt.InitSeries(NoSetup."Overdraft App Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;


               "Created By":=UPPERCASE(USERID);
               "Date Created":=CURRENTDATETIME;
             END;

    OnDelete=BEGIN
               ERROR('Deletion diallowed!');
             END;

    LookupPageID=Page51516466;
    DrillDownPageID=Page51516466;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  NoSetup.GET();
                                                                  NoSeriesMgt.TestManual(NoSetup."Overdraft App Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Account No.         ;Code20        ;TableRelation=Vendor.No. WHERE (Vendor Posting Group=CONST(ORDINARY));
                                                   OnValidate=VAR
                                                                DefLoan@1120054000 : Record 51516230;
                                                                Err_defloan@1120054001 : TextConst 'ENU=Selected member has a Loan %1 which is in %2 category, member cannot access overdraft!';
                                                                err_acc@1120054002 : TextConst 'ENU=%1, does not qualify since the account balance is %2';
                                                              BEGIN
                                                                IF Account.GET("Account No.") THEN BEGIN
                                                                    "Account Name":=Account.Name;
                                                                    "Account Type":=Account."Account Type";
                                                                    "Staff No." := Account."Staff No";
                                                                    "Employer Code" := Account."Company Code";

                                                                    Account.CALCFIELDS(Account."Balance (LCY)");
                                                                    IF Account."Balance (LCY)"<0 THEN
                                                                      ERROR(err_acc,Account.Name,Account."Balance (LCY)");

                                                                    IF AccountTypes.GET("Account Type") THEN BEGIN
                                                                        IF AccountTypes."Allow Over Draft" = FALSE THEN
                                                                            ERROR('Overdraft not allowed for this account type.');

                                                                        AccountTypes.TESTFIELD(AccountTypes."Over Draft Interest Account");

                                                                        "Overdraft Interest %":=AccountTypes."Over Draft Interest %";
                                                                    END;

                                                                    DefLoan.RESET;
                                                                    DefLoan.SETRANGE(DefLoan."Client Code",Account."BOSA Account No");
                                                                    DefLoan.SETFILTER(DefLoan."Outstanding Balance",'>0');
                                                                    DefLoan.SETFILTER(DefLoan."Loans Category-SASRA",'%1|%2|%3',
                                                                    DefLoan."Loans Category-SASRA"::Substandard,DefLoan."Loans Category-SASRA"::Doubtful,
                                                                    DefLoan."Loans Category-SASRA"::Loss);
                                                                    IF DefLoan.FINDSET THEN
                                                                        REPEAT
                                                                            ERROR(Err_defloan,DefLoan."Loan  No."+ ' : '+ DefLoan."Loan Product Type"+ ' '+DefLoan."Loan Product Type Name",DefLoan."Loans Category-SASRA");
                                                                        UNTIL DefLoan.NEXT =0;

                                                                    CalculateReccommededAmount;
                                                                    VALIDATE("Withdrawal Amount","Recommended Amount" -
                                                                    (("Recommended Amount"*0.01*"Overdraft Interest %") + GetCharges("Recommended Amount")));
                                                                    "Requested Amount":="Withdrawal Amount";

                                                                END
                                                                ELSE BEGIN
                                                                    IF Bank.GET("Account No.") THEN BEGIN
                                                                        "Account Name":=Bank.Name;
                                                                    END;
                                                                END;
                                                              END;
                                                               }
    { 3   ;   ;Cheque Book No.     ;Code20         }
    { 4   ;   ;Account Name        ;Text50         }
    { 8   ;   ;Client No.          ;Code20        ;CaptionML=ENU=Client No. }
    { 9   ;   ;Effective/Start Date;Date          ;OnValidate=BEGIN
                                                                "Expiry Date":=CALCDATE(Duration,"Effective/Start Date");
                                                                VALIDATE("Expiry Date");
                                                              END;
                                                               }
    { 10  ;   ;Expiry Date         ;Date          ;OnValidate=BEGIN

                                                                AllowMultipleOD := FALSE;

                                                                IF ("Effective/Start Date" <> 0D) AND ("Expiry Date" <> 0D) THEN BEGIN

                                                                  IF Account.GET("Account No.") THEN BEGIN
                                                                    IF AccountTypes.GET("Account Type") THEN BEGIN
                                                                       AllowMultipleOD:=AccountTypes."Allow Multiple Over Draft";
                                                                    END;
                                                                  END;


                                                                {OverDraftAuth.RESET;
                                                                OverDraftAuth.SETCURRENTKEY(OverDraftAuth."Account No.",OverDraftAuth.Status,OverDraftAuth.Expired);
                                                                OverDraftAuth.SETRANGE(OverDraftAuth."Account No.","Account No.");
                                                                OverDraftAuth.SETRANGE(OverDraftAuth.Status,OverDraftAuth.Status::Approved);
                                                                OverDraftAuth.SETRANGE(OverDraftAuth.Expired,FALSE);
                                                                OverDraftAuth.SETRANGE(OverDraftAuth.Liquidated,FALSE);
                                                                OverDraftAuth.SETRANGE(Posted,TRUE);
                                                                IF OverDraftAuth.FIND('-') THEN BEGIN
                                                                REPEAT

                                                                    IF ("Effective/Start Date" >= OverDraftAuth."Effective/Start Date") AND ("Effective/Start Date" <= OverDraftAuth."Expiry Date") THEN
                                                                    BEGIN
                                                                        IF AllowMultipleOD = TRUE THEN BEGIN
                                                                            IF CONFIRM('There is an already approved Over Draft within the specified period. - %1. Do you wish to issue another one?' +
                                                                               '',FALSE,OverDraftAuth."No.") = FALSE THEN
                                                                            ERROR('Process Terminated.');
                                                                            END ELSE
                                                                            ERROR('There is an already approved Over Draft within the specified period. - %1. Cancel an existing one if you' +
                                                                                   ' want to issue another one.',OverDraftAuth."No.");
                                                                            END;

                                                                            IF ("Expiry Date" >= OverDraftAuth."Effective/Start Date") AND ("Expiry Date" <= OverDraftAuth."Expiry Date") THEN BEGIN
                                                                            IF AllowMultipleOD = TRUE THEN BEGIN
                                                                            IF CONFIRM('There is an already approved Over Draft within the specified period. - %1. Do you wish to issue another one?' +
                                                                               '',FALSE,OverDraftAuth."No.") = FALSE THEN
                                                                            ERROR('Process Terminated.');
                                                                        END ELSE
                                                                            ERROR('There is an already approved Over Draft within the specified period. - %1. Cancel an existing one if you' +
                                                                               ' want to issue another one.',OverDraftAuth."No.");

                                                                    END;

                                                                UNTIL OverDraftAuth.NEXT = 0;
                                                                END;}
                                                                END;
                                                              END;
                                                               }
    { 11  ;   ;Duration            ;DateFormula   ;OnValidate=BEGIN
                                                                TESTFIELD("Effective/Start Date");
                                                                TESTFIELD(Duration);

                                                                IF "Effective/Start Date" < TODAY THEN
                                                                ERROR('Effective date cannot be in the past.');

                                                                "Expiry Date":=CALCDATE(Duration,"Effective/Start Date");
                                                                VALIDATE("Expiry Date");
                                                              END;
                                                               }
    { 14  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected;
                                                   Editable=Yes }
    { 15  ;   ;Remarks             ;Text50         }
    { 16  ;   ;Approved Amount     ;Decimal       ;OnValidate=VAR
                                                                Err_Appr@1120054000 : TextConst 'ENU=Approved amount cannot exceed %1';
                                                              BEGIN
                                                                {CalculateReccommededAmount;
                                                                IF "Approved Amount">"Recommended Amount" THEN
                                                                  ERROR(Err_Appr,"Recommended Amount");

                                                                IF Status<>Status::Open THEN
                                                                  ValidateIfUserHasPermission;}
                                                              END;

                                                   Editable=No }
    { 17  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 19  ;   ;Transacting Branch  ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   Editable=No }
    { 20  ;   ;Created By          ;Code60        ;Editable=No }
    { 21  ;   ;Approved By         ;Code20        ;Editable=No }
    { 22  ;   ;Canceled By         ;Code20        ;Editable=No }
    { 23  ;   ;Overdraft Interest %;Decimal       ;Editable=No }
    { 26  ;   ;Finished            ;Boolean        }
    { 27  ;   ;Application Date    ;Date           }
    { 28  ;   ;Account Type        ;Code20         }
    { 29  ;   ;Issue to            ;Option        ;OptionCaptionML=ENU=Account,Cashier;
                                                   OptionString=Account,Cashier }
    { 30  ;   ;Requested Amount    ;Decimal       ;OnValidate=VAR
                                                                Err_req@1120054000 : TextConst 'ENU=Requested amount cannot exceed %1';
                                                              BEGIN
                                                              END;
                                                               }
    { 31  ;   ;Expired             ;Boolean        }
    { 32  ;   ;Date Approved       ;Date          ;Editable=No }
    { 33  ;   ;Overdraft Fee       ;Decimal       ;Editable=No }
    { 34  ;   ;Liquidated          ;Boolean        }
    { 35  ;   ;Date Liquidated     ;Date          ;Editable=No }
    { 36  ;   ;Liquidated By       ;Code30        ;Editable=No }
    { 37  ;   ;1st Approval        ;Code20         }
    { 38  ;   ;1st Approval Date   ;Date           }
    { 39  ;   ;Posted              ;Boolean       ;Editable=No }
    { 40  ;   ;Net Salary          ;Decimal       ;OnValidate=BEGIN
                                                                {"Approved Amount":="Net Salary"*0.7;
                                                                //"Overdraft Fee":="Requested Amount"*0.05;
                                                                "Overdraft Fee":="Requested Amount"*0.07;
                                                                //"Amount Available":="Requested Amount"+"Overdraft Fee";
                                                                //"Amount Available":="Requested Amount"+"Overdraft Fee";
                                                                //IF "Requested Amount">"Approved Amount" THEN
                                                                  //ERROR('error');

                                                                 }
                                                              END;

                                                   Editable=No }
    { 41  ;   ;Amount Available    ;Decimal       ;Editable=No }
    { 42  ;   ;Date Created        ;DateTime      ;Editable=No }
    { 43  ;   ;Date Posted         ;DateTime      ;Editable=No }
    { 44  ;   ;Posted By           ;Code20        ;Editable=No }
    { 45  ;   ;Recommended Amount  ;Decimal       ;Editable=No }
    { 46  ;   ;Withdrawal Amount   ;Decimal       ;OnValidate=BEGIN

                                                                //IF Mobile THEN BEGIN
                                                                IF Status<>Status::Open THEN
                                                                  ValidateIfUserHasPermission;
                                                                CalculateReccommededAmount;


                                                                IF "Withdrawal Amount" > "Requested Amount" THEN
                                                                  "Withdrawal Amount" := "Requested Amount";

                                                                CalculateApprovedAmount;

                                                                {END
                                                                ELSE BEGIN
                                                                    CalculateReccommededAmount;

                                                                    "Approved Amount" := "Withdrawal Amount";

                                                                END;}


                                                                "Overdraft Fee":="Overdraft Interest %"*0.01*"Withdrawal Amount";
                                                              END;
                                                               }
    { 47  ;   ;Mobile              ;Boolean        }
    { 48  ;   ;Last Notification   ;Option        ;OptionString=[ ,1,2,3,4,5,6,7,8,9,10] }
    { 49  ;   ;Next Notification   ;Option        ;OptionString=[ ,1,2,3,4,5,6,7,8,9,10] }
    { 50  ;   ;Last Mobile Loan Rem. Date;Date     }
    { 51  ;   ;Staff No.           ;Code20         }
    { 52  ;   ;Employer Code       ;Code20         }
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
      NoSetup@1102755011 : Record 51516257;
      NoSeriesMgt@1102755010 : Codeunit 396;
      Account@1102755009 : Record 23;
      UsersID@1102755008 : Record 2000000120;
      BanksList@1102755007 : Record 51516311;
      "Bank Name"@1102755006 : Text[30];
      ChequeNo@1102755005 : Code[20];
      i@1102755004 : Integer;
      Bank@1102755003 : Record 270;
      AccountTypes@1102755002 : Record 51516295;
      OverDraftAuth@1102755001 : Record 51516328;
      AllowMultipleOD@1102755000 : Boolean;
      SalaryPro@1120054000 : Record 51516317;
      ApperovedAmount@1120054001 : Decimal;
      RequestedAmount@1120054002 : Decimal;
      OnSacco@1120054004 : Record 51516257;
      USetup@1120054003 : Record 91;
      IsStaff@1120054005 : Boolean;
      Acc@1120054006 : Record 23;

    PROCEDURE Liquidate@1120054000();
    VAR
      UserSetup@1120054000 : Record 91;
    BEGIN
      USetup.GET(USERID);
      TESTFIELD(Posted,TRUE);
      ValidateIfUserHasPermission;


      IF NOT CONFIRM('Liquidate overdraft %1?',FALSE,Rec."No."+' - '+"Account No."+' - '+ "Account Name" + ': '+ FORMAT("Approved Amount")) THEN EXIT;
      TESTFIELD(Expired,FALSE);
      TESTFIELD(Liquidated,FALSE);

      Liquidated:=TRUE;
      "Date Liquidated":=TODAY;
      "Liquidated By":=USERID;
      MODIFY;

      MESSAGE('Overdraft liquidated successfully!');
    END;

    PROCEDURE Approve@1120054005();
    VAR
      UserSetup@1120054000 : Record 91;
    BEGIN
      ValidateOverDraft;
      USetup.GET(USERID);
      IF NOT USetup.OverDraft THEN
        ERROR('You do not have the permission to approve overdraft, please contact the systems admin!');

      IF NOT CONFIRM('Approve overdraft %1?',FALSE,Rec."No."+' - '+"Account No."+' - '+ "Account Name" + ': '+ FORMAT("Approved Amount")) THEN EXIT;

      TESTFIELD(Status,Status::Pending);

      Status:=Status::Approved;
      "Date Approved":=TODAY;
      "Approved By":=USERID;
      MODIFY;

      MESSAGE('Overdraft approved successfully!');
    END;

    PROCEDURE ValidateOverDraft@1120054009();
    BEGIN
      TESTFIELD("Account No.");
      TESTFIELD("Effective/Start Date");
      TESTFIELD(Duration);
      TESTFIELD("Expiry Date");
      TESTFIELD("Requested Amount");
      TESTFIELD("Approved Amount");
      TESTFIELD("Withdrawal Amount");
    END;

    PROCEDURE PostOverDraft@1120054007();
    VAR
      ApprovalEntries@1120054026 : Page 658;
      DocumentType@1120054025 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Interbank,Imprest,Checkoff,FOSA Account Opening,StandingOrder,HRJob,HRLeave,HRTransport Request,HRTraining,HREmp Requsition,MicroTrans,Account Reactivation,Overdraft';
      AvailableBalance@1120054024 : Decimal;
      MinAccBal@1120054023 : Decimal;
      StatusPermissions@1120054022 : Record 51516310;
      BankName@1120054021 : Text[200];
      Banks@1120054020 : Record 51516311;
      UsersID@1120054019 : Record 2000000120;
      AccP@1120054018 : Record 23;
      AccountTypes@1120054017 : Record 51516295;
      GenJournalLine@1120054016 : Record 81;
      LineNo@1120054015 : Integer;
      Account@1120054014 : Record 23;
      i@1120054013 : Integer;
      DActivity@1120054012 : Code[20];
      DBranch@1120054011 : Code[20];
      ODCharge@1120054010 : Decimal;
      AccNo@1120054009 : Boolean;
      ReqAmount@1120054008 : Boolean;
      AppAmount@1120054007 : Boolean;
      ODInt@1120054006 : Boolean;
      EstartDate@1120054005 : Boolean;
      Durationn@1120054004 : Boolean;
      ODFee@1120054003 : Boolean;
      Remmarks@1120054002 : Boolean;
      ApprovedAmount@1120054001 : Decimal;
      Benki@1120054000 : Record 270;
    BEGIN
      IF Posted=TRUE THEN
         ERROR('This Overdraft has already been issued');

      IF Status <> Status::Approved THEN
         ERROR('You cannot post an application being processed.');

      ValidateOverDraft;


      IF CONFIRM('Are you sure you want to authorise this overdraft? This will charge overdraft issue fee.',FALSE) = FALSE THEN
      EXIT;

      //Overdraft Issue Fee
      AccountTypes.RESET;
      AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
      IF AccountTypes.FIND('-') THEN  BEGIN



      UsersID.RESET;
      UsersID.SETRANGE(UsersID."User Name",UPPERCASE(USERID));
      IF UsersID.FIND('-') THEN BEGIN
      DBranch:=UsersID.Branch;
      DActivity:='FOSA';
      //MESSAGE('%1,%2',Branch,Activity);
      END;
      TESTFIELD("Overdraft Fee");

      IF "Overdraft Fee" > 0 THEN BEGIN
              //AccountTypes.TESTFIELD("Over Draft Issue Charge %");

              GenJournalLine.RESET;
              GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'PURCHASES');
              GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
              IF GenJournalLine.FIND('-') THEN
              GenJournalLine.DELETEALL;

              LineNo:=LineNo+10000;

              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='PURCHASES';
              GenJournalLine."Journal Batch Name":='FTRANS';
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Document No.":="No.";
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine."External Document No.":="No.";
              GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
              GenJournalLine."Account No.":="Account No.";
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine.Description:='Overdraft Issue Charges';
              GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
              GenJournalLine.Amount:="Overdraft Fee";
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;


              LineNo:=LineNo+10000;
              AccountTypes.TESTFIELD("Over Draft Issue Charge A/C");

              GenJournalLine.INIT;
              GenJournalLine."Journal Template Name":='PURCHASES';
              GenJournalLine."Journal Batch Name":='FTRANS';
              GenJournalLine."Line No.":=LineNo;
              GenJournalLine."Document No.":="No.";
              GenJournalLine."Posting Date":=TODAY;
              GenJournalLine."External Document No.":="No.";
              GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
              GenJournalLine."Account No.":=AccountTypes."Over Draft Issue Charge A/C";
              GenJournalLine.VALIDATE(GenJournalLine."Account No.");
              GenJournalLine.Description:=PADSTR('Overdraft issue charge for: '+ "Account No.",50);
              GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
              GenJournalLine.Amount:=-"Overdraft Fee";
              GenJournalLine.VALIDATE(GenJournalLine.Amount);
              GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
              GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
              GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
              GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
              IF GenJournalLine.Amount<>0 THEN
              GenJournalLine.INSERT;



            //Post New
             GenJournalLine.RESET;
             GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
             GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
             IF GenJournalLine.FIND('-') THEN BEGIN
               CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Sacco",GenJournalLine);
             END;

            //Post New

      END;
      END;
      //Overdraft Fee

       Posted:=TRUE;
       "Date Posted":=CURRENTDATETIME;
       "Posted By":=USERID;
       MODIFY;

      MESSAGE('Overdraft authorised and charges posted successfully.');
    END;

    PROCEDURE RejectOverDraft@1120054001();
    VAR
      UserSetup@1120054000 : Record 91;
    BEGIN
      ValidateOverDraft;

      USetup.GET(USERID);
      IF NOT USetup.OverDraft THEN
        ERROR('You do not have the permission to reject overdraft, please contact the systems admin!');

      IF NOT CONFIRM('Reject overdraft %1?',FALSE,Rec."No."+' - '+"Account No."+' - '+ "Account Name" + ': '+ FORMAT("Approved Amount")) THEN EXIT;

      TESTFIELD(Status,Status::Pending);

      Status:=Status::Rejected;
      "Canceled By":=USERID;
      MODIFY;

      MESSAGE('Overdraft rejected successfully!');
    END;

    LOCAL PROCEDURE CalculateReccommededAmount@1120054003();
    VAR
      Charges@1120054000 : Record 51516297;
      SalFee@1120054001 : Decimal;
      SalLines@1120054002 : Record 51516317;
      SaccoGeneralSetUp@1120054003 : Record 51516257;
      "95%OfSalary"@1120054004 : Decimal;
      SalaryLoansBal@1120054005 : Decimal;
      ExistingOds@1120054006 : Decimal;
      VendorLedger@1120054007 : Record 25;
      SalaryAmount@1120054008 : Decimal;
      PrevSalaryAmount@1120054009 : Decimal;
      "80%OfSalary"@1120054010 : Decimal;
    BEGIN
      IF Charges.GET('SAL') THEN BEGIN
         SalFee:=Charges."Charge Amount";
         SaccoGeneralSetUp.GET;
         SaccoGeneralSetUp.TESTFIELD(SaccoGeneralSetUp."Excise Duty(%)");
         SalFee+=(SaccoGeneralSetUp."Excise Duty(%)"*0.01*SalFee);
      END;

      SalaryAmount := 0;
      PrevSalaryAmount := 0;

      SalLines.RESET;
      SalLines.SETRANGE(SalLines."Account No.",Rec."Account No.");
      SalLines.SETRANGE(SalLines.Processed,TRUE);
      SalLines.SETRANGE(SalLines.Type,SalLines.Type::Salary,SalLines.Type::Pension);
      IF SalLines.FINDLAST THEN BEGIN
         SalaryAmount := SalLines.Amount;
         IF SalLines.FIND('<') THEN
            PrevSalaryAmount := SalLines.Amount;
      END;

      IsStaff:=FALSE;
      VendorLedger.RESET;
      VendorLedger.SETRANGE(VendorLedger."Vendor No.","Account No.");
      VendorLedger.SETRANGE(VendorLedger.Reversed,FALSE);
      VendorLedger.SETFILTER(VendorLedger."External Document No.",'SALARY*');
      VendorLedger.SETFILTER(VendorLedger.Amount,'<0');
      VendorLedger.SETAUTOCALCFIELDS(VendorLedger.Amount);
      IF VendorLedger.FINDLAST THEN BEGIN
         SalaryAmount := VendorLedger.Amount*-1;
         IsStaff:=TRUE;
      END;

      //New salary
      Acc.GET("Account No.");
      //SalaryAmount:=Acc."Net Salary";
      //end of new

      IF PrevSalaryAmount>0 THEN BEGIN
         IF SalaryAmount>PrevSalaryAmount THEN
            SalaryAmount := PrevSalaryAmount;
      END;

      IF Acc."Company Code" = 'STAFF' THEN BEGIN

          VendorLedger.RESET;
          VendorLedger.SETRANGE(VendorLedger."Vendor No.","Account No.");
          VendorLedger.SETRANGE(VendorLedger.Reversed,FALSE);
          VendorLedger.SETFILTER(VendorLedger."External Document No.",'SALARY*');
          VendorLedger.SETFILTER(VendorLedger.Amount,'<0');
          VendorLedger.SETAUTOCALCFIELDS(VendorLedger.Amount);
          IF VendorLedger.FINDLAST THEN BEGIN
             SalaryAmount := VendorLedger.Amount*-1;
             IsStaff:=TRUE;
          END;
      END;

      "Net Salary":=SalaryAmount;

      IF SalaryAmount>0 THEN BEGIN
          "95%OfSalary" := (SalaryAmount*0.95);
          //"80%OfSalary" := (SalaryAmount*0.8);
          SalaryLoansBal := GetSalaryLoansBalance;
          ExistingOds := GetExistingODs;
          "Recommended Amount"  := "95%OfSalary"-(SalFee+SalaryLoansBal+ExistingOds);
          IF "Recommended Amount"<0 THEN "Recommended Amount":=0;
          IF "Recommended Amount">50000 THEN "Recommended Amount":=53500;
          //sMESSAGE('SalFee %1\SalaryLoansBal %2\ExistingOds %3\STOAmt %4',SalFee,SalaryLoansBal,ExistingOds,0);
          IF GetExistingODs > 0 THEN
            "Recommended Amount" := 0;
      END
    END;

    LOCAL PROCEDURE GetSalaryLoansBalance@1120054011() : Decimal;
    VAR
      SalLoan@1120054000 : Record 51516230;
      SalLoanBal@1120054001 : Decimal;
      StandingOrders@1120054002 : Record 51516307;
      ReceiptAllocation@1120054003 : Record 51516246;
      MembLedger@1120054004 : Record 51516224;
      IntDue@1120054005 : Decimal;
    BEGIN
      SalLoanBal:=0;
      SalLoan.RESET;
      SalLoan.SETCURRENTKEY(Source,"Client Code","Loan Product Type","Issued Date");
      SalLoan.SETRANGE(SalLoan."Account No",Rec."Account No.");
      SalLoan.SETRANGE(SalLoan."Recovery Mode",SalLoan."Recovery Mode"::Salary,SalLoan."Recovery Mode"::Pension);
      SalLoan.SETFILTER(SalLoan."Outstanding Balance",'>0');
      SalLoan.SETAUTOCALCFIELDS(SalLoan."Outstanding Balance");
      IF SalLoan.FINDSET THEN REPEAT

         IF SalLoan."Issued Date"<=081519D THEN BEGIN

               MembLedger.RESET;
               MembLedger.SETRANGE(MembLedger."Loan No",SalLoan."Loan  No.");
               MembLedger.SETRANGE(MembLedger."Transaction Type",MembLedger."Transaction Type"::"Interest Due");
               MembLedger.SETRANGE(MembLedger.Reversed,FALSE);
               MembLedger.SETFILTER(MembLedger.Amount,'0');
               IF MembLedger.FINDLAST THEN
                 IntDue :=MembLedger.Amount;
               SalLoan.Repayment := (SalLoan."Approved Amount"/SalLoan.Installments) + IntDue;

           END ELSE

               SalLoan.Repayment:=SalLoan.GetLoanExpectedRepayment(0,CALCDATE('CM',TODAY));

         IF SalLoan.Repayment>SalLoan."Outstanding Balance" THEN
           SalLoan.Repayment:=SalLoan."Outstanding Balance";

         IF IsStaff AND (SalLoan.Source=SalLoan.Source::BOSA) THEN
           SalLoan.Repayment := 0;

         SalLoanBal+=SalLoan.Repayment;

        UNTIL SalLoan.NEXT = 0;

      StandingOrders.RESET;
      StandingOrders.SETRANGE(StandingOrders."Source Account No.","Account No.");
      StandingOrders.SETRANGE(StandingOrders.Status,StandingOrders.Status::Approved);
      StandingOrders.SETFILTER(StandingOrders."Income Type",'%1|%2',StandingOrders."Income Type"::Pension,StandingOrders."Income Type"::Salary);
      StandingOrders.SETRANGE(StandingOrders."End Date",0D,TODAY);
      IF StandingOrders.FINDSET THEN
        REPEAT
          ReceiptAllocation.RESET;
          ReceiptAllocation.SETRANGE(ReceiptAllocation."Document No",StandingOrders."No.");
          ReceiptAllocation.SETFILTER(ReceiptAllocation."Loan No.",'<>%1','');
          IF ReceiptAllocation.FINDFIRST THEN BEGIN
              SalLoan.GET(ReceiptAllocation."Loan No.");
              SalLoan.CALCFIELDS(SalLoan."Outstanding Balance");
              IF SalLoan."Outstanding Balance">0 THEN BEGIN
                    SalLoan.Repayment:=SalLoan.GetLoanExpectedRepayment(0,CALCDATE('CM',TODAY));
                    IF SalLoan.Repayment>SalLoan."Outstanding Balance" THEN
                       SalLoan.Repayment:=SalLoan."Outstanding Balance";
                     SalLoanBal += SalLoan.Repayment;
                END;
            END;
       UNTIL StandingOrders.NEXT = 0;
      EXIT(SalLoanBal);
    END;

    LOCAL PROCEDURE GetExistingODs@1120054010() : Decimal;
    VAR
      ExistingOds@1120054000 : Record 51516328;
    BEGIN
      ExistingOds.RESET;
      ExistingOds.SETRANGE(ExistingOds."Account No.",Rec."Account No.");
      ExistingOds.SETRANGE(ExistingOds.Status,ExistingOds.Status::Approved);
      ExistingOds.SETRANGE(ExistingOds.Posted,TRUE);
      ExistingOds.SETRANGE(ExistingOds.Liquidated,FALSE);
      ExistingOds.SETRANGE(ExistingOds.Expired,FALSE);
      IF ExistingOds.FINDFIRST THEN BEGIN
           ExistingOds.CALCSUMS(ExistingOds."Approved Amount");
           EXIT(ExistingOds."Approved Amount");
        END;
    END;

    PROCEDURE ValidateIfUserHasPermission@1120054039();
    BEGIN
      USetup.GET(USERID);
      IF NOT USetup.OverDraft THEN
        ERROR('You do not have the permission to approve overdraft, please contact the systems admin!');
    END;

    LOCAL PROCEDURE CalculateApprovedAmount@1120054002();
    VAR
      ErrAppr@1120054000 : TextConst 'ENU=The approved amount cannot exceed %1';
    BEGIN
      "Approved Amount" := "Withdrawal Amount"+("Withdrawal Amount"*0.01*"Overdraft Interest %") + GetCharges("Withdrawal Amount");
      IF "Approved Amount">"Recommended Amount" THEN
        ERROR(ErrAppr,"Recommended Amount");
    END;

    PROCEDURE GetCharges@1120054004(Amount@1120054000 : Decimal) : Decimal;
    VAR
      Charges@1120054001 : Record 51516297;
      ChargeAmount@1120054002 : Decimal;
      SaccoGeneralSetUp@1120054003 : Record 51516257;
    BEGIN
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
      SaccoGeneralSetUp.GET;
      EXIT(ChargeAmount+(SaccoGeneralSetUp."Excise Duty(%)"*0.01*ChargeAmount));
    END;

    BEGIN
    END.
  }
}

