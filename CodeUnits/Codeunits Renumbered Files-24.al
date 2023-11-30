OBJECT CodeUnit 20388 CloudPESABulkSMS
{
  OBJECT-PROPERTIES
  {
    Date=10/14/20;
    Time=[ 2:32:29 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            ChargeSMS();
          END;

  }
  CODE
  {
    VAR
      SMSMessages@1000000001 : Record 51516329;
      SMSCharges@1000000000 : Record 51516554;
      SMSCharge@1000000002 : Decimal;
      ExDuty@1000000003 : Decimal;
      Vendor@1000000004 : Record 23;
      GenJournalLine@1000000005 : TEMPORARY Record 51516099;
      GenBatches@1000000006 : Record 232;
      LineNo@1000000007 : Integer;
      GLPosting@1000000009 : Codeunit 12;
      ExDutyGLAcc@1000000008 : TextConst 'ENU=200-000-168';
      TrCodeunit@1120054000 : Codeunit 50052;

    PROCEDURE PollPendingSMS@1000000001() MessageDetails : Text[500];
    BEGIN
      BEGIN
             SMSMessages.RESET;
         SMSMessages.SETRANGE(SMSMessages."Date Entered",TODAY);
              SMSMessages.SETRANGE(SMSMessages."Sent To Server", SMSMessages."Sent To Server"::No);
              IF SMSMessages.FIND('-') THEN
                BEGIN

                  IF (SMSMessages."Telephone No"='')OR(SMSMessages."Telephone No"='+')OR (SMSMessages."SMS Message"='') THEN
                    BEGIN
                      SMSMessages."Sent To Server":=SMSMessages."Sent To Server"::Failed;
                      SMSMessages."Entry No.":='FAILED';
                      SMSMessages.MODIFY;
                    END
                  ELSE BEGIN
                      MessageDetails:=SMSMessages."Telephone No"+':::'+SMSMessages."SMS Message"+':::'+FORMAT(SMSMessages."Entry No");
                  END;
             END;
          END;
    END;

    PROCEDURE ConfirmSent@1000000004(TelephoneNo@1000000000 : Text[20];Status@1000000001 : Integer);
    BEGIN

              SMSMessages.RESET;
              SMSMessages.SETRANGE(SMSMessages."Sent To Server", SMSMessages."Sent To Server"::No);
                     // SMSMessages.SETRANGE(SMSMessages."Telephone No", TelephoneNo);
              SMSMessages.SETRANGE(SMSMessages."Entry No", Status);
              IF SMSMessages.FINDFIRST THEN
                BEGIN
                     SMSMessages."Sent To Server":=SMSMessages."Sent To Server"::Yes;
                     SMSMessages."Entry No.":='SUCCESS';
                     SMSMessages.MODIFY;
                     ChargeSMS;
                     //result:='TRUE';
                END
    END;

    PROCEDURE ChargeSMS@1000000002();
    BEGIN

      {  SMSMessages.RESET;
       // SMSMessages.LOCKTABLE;
        SMSMessages.SETCURRENTKEY(SMSMessages."Entry No");
        SMSMessages.SETASCENDING(SMSMessages."Entry No",FALSE);
        SMSMessages.SETRANGE(SMSMessages."Date Entered",TODAY);
        SMSMessages.SETRANGE(SMSMessages."Sent To Server", SMSMessages."Sent To Server"::Yes);
        SMSMessages.SETRANGE(SMSMessages."Entry No.",'SUCCESS');
        SMSMessages.SETFILTER(SMSMessages."Telephone No",'<>%1','');
        SMSMessages.SETRANGE(SMSMessages.Charged,FALSE);
        IF SMSMessages.FINDFIRST THEN
         // REPEAT
              BEGIN
           }

               SMSCharges.RESET;
               SMSCharges.SETRANGE(SMSCharges.Source,SMSMessages.Source);
              IF SMSCharges.FIND('-') THEN BEGIN
              //  SMSCharges.TESTFIELD(SMSCharges."Charge Account");
                SMSCharge:=SMSCharges.Amount;
                ExDuty:=(20/100)*SMSCharges.Amount;
               END;
                Vendor.RESET;
                Vendor.SETRANGE(Vendor."No.", getAccounts(SMSMessages."Account No"));
                IF Vendor.FIND('-') THEN BEGIN
                    GenJournalLine.RESET;
                    GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                    GenJournalLine.SETRANGE("Journal Batch Name",'SMSCHARGE');
                    GenJournalLine.DELETEALL;
                    //end of deletion

                    GenBatches.RESET;
                    GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
                    GenBatches.SETRANGE(GenBatches.Name,'SMSCHARGE');

                    IF GenBatches.FIND('-') = FALSE THEN BEGIN
                    GenBatches.INIT;
                    GenBatches."Journal Template Name":='GENERAL';
                    GenBatches.Name:='SMSCHARGE';
                    GenBatches.Description:='SMS Charges';
                    GenBatches.VALIDATE(GenBatches."Journal Template Name");
                    GenBatches.VALIDATE(GenBatches.Name);
                    GenBatches.INSERT;
                    END;
                    GenJournalLine.LOCKTABLE;

                    //DR Member Account
                            LineNo:=LineNo+10000;
                            GenJournalLine.INIT;
                            GenJournalLine."Journal Template Name":='GENERAL';
                            GenJournalLine."Journal Batch Name":='SMSCHARGE';
                            GenJournalLine."Line No.":=LineNo;
                            GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                            GenJournalLine."Account No.":=Vendor."No.";
                            GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                            GenJournalLine."Document No.":=FORMAT(SMSMessages."Entry No");
                            GenJournalLine."External Document No.":=SMSMessages.Source;
                            GenJournalLine."Posting Date":=TODAY;
                            GenJournalLine.Description:='SMS Charges';
                            GenJournalLine.Amount:=SMSCharges.Amount;
                            GenJournalLine.VALIDATE(GenJournalLine.Amount);
                            IF GenJournalLine.Amount<>0 THEN
                            GenJournalLine.INSERT;

                            //Cr SMS Charges Acc
                            LineNo:=LineNo+10000;
                            GenJournalLine.INIT;
                            GenJournalLine."Journal Template Name":='GENERAL';
                            GenJournalLine."Journal Batch Name":='SMSCHARGE';
                            GenJournalLine."Line No.":=LineNo;
                            GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                            GenJournalLine."Account No.":=SMSCharges."Charge Account";
                            GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                            GenJournalLine."Document No.":=FORMAT(SMSMessages."Entry No");
                            GenJournalLine."External Document No.":=SMSMessages.Source;
                            GenJournalLine."Posting Date":=TODAY;
                            GenJournalLine."Source No.":=Vendor."No.";
                            GenJournalLine.Description:='SMS Charge';
                            GenJournalLine.Amount:=-SMSCharges.Amount;
                            GenJournalLine.VALIDATE(GenJournalLine.Amount);
                            IF GenJournalLine.Amount<>0 THEN
                            GenJournalLine.INSERT;

                           LineNo:=LineNo+10000;
                            GenJournalLine.INIT;
                            GenJournalLine."Journal Template Name":='GENERAL';
                            GenJournalLine."Journal Batch Name":='SMSCHARGE';
                            GenJournalLine."Line No.":=LineNo;
                            GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                            GenJournalLine."Account No.":=Vendor."No.";
                            GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                            GenJournalLine."Document No.":=FORMAT(SMSMessages."Entry No");
                            GenJournalLine."External Document No.":=SMSMessages.Source;
                            GenJournalLine."Posting Date":=TODAY;
                            GenJournalLine.Description:='Excise duty-SMS Notification';
                            GenJournalLine.Amount:=ExDuty;
                            GenJournalLine.VALIDATE(GenJournalLine.Amount);
                            IF GenJournalLine.Amount<>0 THEN
                            GenJournalLine.INSERT;

                            //Cr Ex Acc
                            LineNo:=LineNo+10000;
                            GenJournalLine.INIT;
                            GenJournalLine."Journal Template Name":='GENERAL';
                            GenJournalLine."Journal Batch Name":='SMSCHARGE';
                            GenJournalLine."Line No.":=LineNo;
                            GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                            GenJournalLine."Account No.":=ExDutyGLAcc;
                            GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                            GenJournalLine."Document No.":=FORMAT(SMSMessages."Entry No");
                            GenJournalLine."External Document No.":=SMSMessages.Source;
                            GenJournalLine."Posting Date":=TODAY;
                            GenJournalLine."Source No.":=Vendor."No.";
                           GenJournalLine.Description:='Excise duty-SMS Notification';
                            GenJournalLine.Amount:=ExDuty*-1;
                            GenJournalLine.VALIDATE(GenJournalLine.Amount);
                            IF GenJournalLine.Amount<>0 THEN
                            GenJournalLine.INSERT;


                            //Post
                            {
                            GenJournalLine.RESET;
                            GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                            GenJournalLine.SETRANGE("Journal Batch Name",'SMSCHARGE');
                            IF GenJournalLine.FIND('-') THEN BEGIN
                            REPEAT
                            GLPosting.RUN(GenJournalLine);
                           UNTIL GenJournalLine.NEXT = 0;
                            END;
                            }

                      TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL','SMSCHARGE');

                        GenJournalLine.RESET;
                        GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                        GenJournalLine.SETRANGE("Journal Batch Name",'SMSCHARGE');
                        GenJournalLine.DELETEALL;
                        //end of deletion


                          END;
                           SMSMessages.Charged:=TRUE;
                            SMSMessages.MODIFY;
                           COMMIT;
                    //      END;


                   // UNTIL SMSMessages.NEXT=0;
    END;

    LOCAL PROCEDURE getAccounts@1000000003(accountNo@1000000000 : Code[100]) fosaAccountNo : Code[100];
    BEGIN
      Vendor.RESET;
      Vendor.SETRANGE(Vendor."No.",accountNo);
      IF Vendor.FIND('-') THEN BEGIN
        fosaAccountNo:=Vendor."No.";
        END ELSE BEGIN
      Vendor.RESET;
      Vendor.SETRANGE(Vendor."BOSA Account No",accountNo);
      IF Vendor.FIND('-') THEN BEGIN
        fosaAccountNo:=Vendor."No.";
        END;
          END;
    END;

    BEGIN
    END.
  }
}

