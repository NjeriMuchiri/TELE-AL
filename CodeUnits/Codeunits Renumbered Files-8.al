OBJECT CodeUnit 20372 POST ATM Transactions
{
  OBJECT-PROPERTIES
  {
    Date=03/02/23;
    Time=[ 5:38:41 PM];
    Modified=Yes;
    Version List=ATM;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            MESSAGE(FORMAT(PostTrans()));
          END;

  }
  CODE
  {
    VAR
      GenJournalLine@1102755017 : TEMPORARY Record 51516099 SECURITYFILTERING(Ignored);
      ATMTrans@1102755016 : Record 51516323;
      LineNo@1102755015 : Integer;
      Acct@1102755014 : Record 23;
      ATMCharges@1102755013 : Decimal;
      BankCharges@1102755012 : Decimal;
      GenBatches@1102755011 : Record 232;
      GLPosting@1102755010 : Codeunit 12;
      BankCode@1102755009 : Code[20];
      PDate@1102755008 : Date;
      RevFromDate@1102755007 : Date;
      ATMTransR@1102755006 : Record 51516323;
      GLAcc@1102755005 : Code[20];
      BankAcc@1102755004 : Code[20];
      ATMCharge@1102755003 : Record 51516327;
      AtmTrans1@1102755002 : Record 51516323;
      BankChargecode@1102755001 : Code[20];
      DocNo@1102755000 : Code[20];
      Pos@1000 : Record 51516348;
      ExciseDuty@1000000000 : Decimal;
      SaccoGen@1000000001 : Record 51516257;
      ExciseAcNo@1000000002 : Code[30];
      SMSMessage@1000000003 : Record 51516329;
      iEntryNo@1000000004 : Integer;
      TEST@1000000005 : Boolean;
      TrCodeunit@1120054000 : Codeunit 50052;
      SkyMbanking@1120054001 : CodeUnit 20416;

    PROCEDURE PostTrans@1000000000() success : Boolean;
    BEGIN
      //delete journal line
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
      GenJournalLine.SETRANGE("Journal Batch Name",'ATMTRANS');
      GenJournalLine.DELETEALL;
      //end of deletion

      GenBatches.RESET;
      GenBatches.SETRANGE(GenBatches."Journal Template Name",'GENERAL');
      GenBatches.SETRANGE(GenBatches.Name,'ATMTRANS');
      IF GenBatches.FIND('-') = FALSE THEN BEGIN
      GenBatches.INIT;
      GenBatches."Journal Template Name":='GENERAL';
      GenBatches.Name:='ATMTRANS';
      GenBatches.Description:='ATM Transactions';
      GenBatches.VALIDATE(GenBatches."Journal Template Name");
      GenBatches.VALIDATE(GenBatches.Name);
      GenBatches.INSERT;
      END;
      ATMTrans.LOCKTABLE;
      ATMTrans.RESET;
      ATMTrans.SETRANGE(ATMTrans.Posted,FALSE);
      //ATMTrans.SETRANGE(ATMTrans."Trace ID",'817368');
      ATMTrans.SETRANGE(ATMTrans.Source,ATMTrans.Source::"ATM Bridge");
      IF ATMTrans.FIND('-') THEN BEGIN
      //REPEAT
      DocNo:=ATMTrans."Reference No";
      ATMCharges:=0;
      BankCharges:=0;
      ExciseDuty:=0;
      GLAcc:='';
      BankAcc:='';
      BankChargecode:='';
      ExciseAcNo:='';

      IF ATMCharge.GET(ATMTrans."Transaction Type Charges") THEN BEGIN
      ATMCharges:=ATMCharge."Total Amount";
      BankCharges:=ATMCharge."Total Amount"-ATMCharge."Sacco Amount";
      SaccoGen.GET;
      ExciseDuty:=(SaccoGen."Excise Duty(%)"/100)*ATMCharges;

      IF ATMTrans."Transaction Type Charges" = ATMTrans."Transaction Type Charges"::"POS - Cash Withdrawal" THEN BEGIN
      Pos.RESET;
      Pos.SETFILTER(Pos."Lower Limit",'<=%1',ATMTrans.Amount) ;
      Pos.SETFILTER(Pos."Upper Limit",'>=%1',ATMTrans.Amount) ;
      IF Pos.FINDFIRST THEN BEGIN
      ATMCharges:=Pos."Charge Amount";
      BankCharges:=Pos."Bank charge";
      END;
      END;

      IF ATMCharge.Source=ATMCharge.Source::ATM THEN BEGIN
      GLAcc:=ATMCharge."Atm Income A/c";
      BankAcc:=ATMCharge."Atm Bank Settlement A/C";
      BankChargecode:=ATMCharge."Atm Bank Settlement A/C";
      SaccoGen.GET();
      ExciseAcNo:=SaccoGen."Excise Duty Account";
      END ELSE BEGIN
        GLAcc:=ATMCharge."Atm Income A/c";
      BankAcc:=ATMCharge."Atm Bank Settlement A/C";
      BankChargecode:=ATMCharge."Atm Bank Settlement A/C";
      SaccoGen.GET();
      ExciseAcNo:=SaccoGen."Excise Duty Account";


      END;
      END;

      IF ATMTrans.Reversed = TRUE THEN BEGIN
      AtmTrans1.RESET;
      AtmTrans1.SETRANGE(AtmTrans1."Account No",ATMTrans."Account No");
      AtmTrans1.SETRANGE(AtmTrans1.Reversed,FALSE);
      AtmTrans1.SETRANGE(AtmTrans1."Trace ID",ATMTrans."Reversal Trace ID");
      IF AtmTrans1.FIND('-') THEN BEGIN
      ATMCharges:=0;
      BankCharges:=0;
      ExciseDuty:=0;


      IF ATMCharge.GET(AtmTrans1."Transaction Type Charges") THEN BEGIN

      ATMCharges:=-ATMCharge."Total Amount";
      BankCharges:=-(ATMCharge."Total Amount"-ATMCharge."Sacco Amount");
      SaccoGen.GET;
      ExciseDuty:=(SaccoGen."Excise Duty(%)"/100)*ATMCharges;
      IF AtmTrans1."Transaction Type Charges" = AtmTrans1."Transaction Type Charges"::"POS - Cash Withdrawal" THEN BEGIN
      Pos.RESET;
      Pos.SETFILTER(Pos."Lower Limit",'<=%1',AtmTrans1.Amount) ;
      Pos.SETFILTER(Pos."Upper Limit",'>=%1',AtmTrans1.Amount) ;
      IF Pos.FINDFIRST THEN BEGIN
      ATMCharges:=-Pos."Charge Amount";
      BankCharges:=-Pos."Bank charge";
      END;
      END;


      IF ATMCharge.Source=ATMCharge.Source::ATM THEN BEGIN
      GLAcc:=ATMCharge."Atm Income A/c";
      BankAcc:=ATMCharge."Atm Bank Settlement A/C";
      BankChargecode:=ATMCharge."Atm Bank Settlement A/C";
      SaccoGen.GET();
      ExciseAcNo:=SaccoGen."Excise Duty Account";
      END ELSE BEGIN
      SaccoGen.GET();
      GLAcc:=ATMCharge."Atm Income A/c";
      BankAcc:=ATMCharge."Atm Bank Settlement A/C";
      BankChargecode:=ATMCharge."Atm Bank Settlement A/C";
      SaccoGen.GET();
      ExciseAcNo:=SaccoGen."Excise Duty Account";
      END;
      END;
      END;
      END;

      IF Acct.GET(ATMTrans."Account No") THEN BEGIN


          IF Acct.Blocked = Acct.Blocked::" " THEN BEGIN

          LineNo:=LineNo+10000;
        //GenJournalLine.LOCKTABLE;
          GenJournalLine.INIT;
          GenJournalLine."Journal Template Name":='GENERAL';
          GenJournalLine."Journal Batch Name":='ATMTRANS';
          GenJournalLine."Line No.":=LineNo;
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
          GenJournalLine."Account No.":=ATMTrans."Account No";
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Document No.":=DocNo;
          GenJournalLine."Posting Date":=ATMTrans."Posting Date";
          IF ATMTrans."Transaction Description"='' THEN
          GenJournalLine.Description:='ATM Cash W/D'
          ELSE
          GenJournalLine.Description:=ATMTrans."Transaction Description";
          GenJournalLine.Amount:=ATMTrans.Amount;
          GenJournalLine.VALIDATE(GenJournalLine.Amount);
          IF GenJournalLine.Amount<>0 THEN
          GenJournalLine.INSERT;

          LineNo:=LineNo+10000;

          GenJournalLine.INIT;
          GenJournalLine."Journal Template Name":='GENERAL';
          GenJournalLine."Journal Batch Name":='ATMTRANS';
          GenJournalLine."Line No.":=LineNo;
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
          GenJournalLine."Account No.":=BankAcc;
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Document No.":=DocNo;
          GenJournalLine."Posting Date":=ATMTrans."Posting Date";
          GenJournalLine.Description:=Acct.Name;
          GenJournalLine.Amount:=ATMTrans.Amount*-1;
          GenJournalLine.VALIDATE(GenJournalLine.Amount);
          GenJournalLine."Shortcut Dimension 1 Code":=Acct."Global Dimension 1 Code";
          GenJournalLine."Shortcut Dimension 2 Code":=Acct."Global Dimension 2 Code";
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
          IF GenJournalLine.Amount<>0 THEN
          GenJournalLine.INSERT;







          LineNo:=LineNo+10000;

          GenJournalLine.INIT;
          GenJournalLine."Journal Template Name":='GENERAL';
          GenJournalLine."Journal Batch Name":='ATMTRANS';
          GenJournalLine."Line No.":=LineNo;
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
          GenJournalLine."Account No.":=ATMTrans."Account No";
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Document No.":=DocNo;
          GenJournalLine."Posting Date":=ATMTrans."Posting Date";
          IF ATMTrans."Transaction Description"='' THEN
          GenJournalLine.Description:='ATM W/D Charges '
          ELSE
          GenJournalLine.Description:='Trans Charges';
          GenJournalLine.Amount:=ATMCharges+ExciseDuty;
          GenJournalLine.VALIDATE(GenJournalLine.Amount);
          IF GenJournalLine.Amount<>0 THEN
          GenJournalLine.INSERT;

          LineNo:=LineNo+10000;

          GenJournalLine.INIT;
          GenJournalLine."Journal Template Name":='GENERAL';
          GenJournalLine."Journal Batch Name":='ATMTRANS';
          GenJournalLine."Line No.":=LineNo;
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
          GenJournalLine."Account No.":=BankChargecode;
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Document No.":=DocNo;
          GenJournalLine."External Document No.":=Acct."ATM No.";
          GenJournalLine."Posting Date":=ATMTrans."Posting Date";
          GenJournalLine.Description:='Trans. Charges';
          GenJournalLine.Amount:=-BankCharges;
          GenJournalLine.VALIDATE(GenJournalLine.Amount);
          GenJournalLine."Shortcut Dimension 1 Code":=Acct."Global Dimension 1 Code";
          GenJournalLine."Shortcut Dimension 2 Code":=Acct."Global Dimension 2 Code";
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
          IF GenJournalLine.Amount<>0 THEN
          GenJournalLine.INSERT;



          LineNo:=LineNo+10000;

          GenJournalLine.INIT;
          GenJournalLine."Journal Template Name":='GENERAL';
          GenJournalLine."Journal Batch Name":='ATMTRANS';
          GenJournalLine."Line No.":=LineNo;
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
          GenJournalLine."Account No.":=GLAcc;
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Document No.":=DocNo;
          GenJournalLine."External Document No.":=ATMTrans."Account No";
          GenJournalLine."Posting Date":=ATMTrans."Posting Date";
          GenJournalLine.Description:=Acct.Name;
          GenJournalLine.Amount:=-1*(ATMCharges-BankCharges);
          GenJournalLine.VALIDATE(GenJournalLine.Amount);
          GenJournalLine."Shortcut Dimension 1 Code":=Acct."Global Dimension 1 Code";
          GenJournalLine."Shortcut Dimension 2 Code":=Acct."Global Dimension 2 Code";
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
          IF GenJournalLine.Amount<>0 THEN
          GenJournalLine.INSERT;


         //EXCISE DUTY
         LineNo:=LineNo+10000;

          GenJournalLine.INIT;
          GenJournalLine."Journal Template Name":='GENERAL';
          GenJournalLine."Journal Batch Name":='ATMTRANS';
          GenJournalLine."Line No.":=LineNo;
          GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
          GenJournalLine."Account No.":=ExciseAcNo;
          GenJournalLine.VALIDATE(GenJournalLine."Account No.");
          GenJournalLine."Document No.":=DocNo;
          GenJournalLine."External Document No.":=ATMTrans."Account No";
          GenJournalLine."Posting Date":=ATMTrans."Posting Date";
          GenJournalLine.Description:='Excise Duty';
          GenJournalLine.Amount:=-1*ExciseDuty;
          GenJournalLine.VALIDATE(GenJournalLine.Amount);
          GenJournalLine."Shortcut Dimension 1 Code":=Acct."Global Dimension 1 Code";
          GenJournalLine."Shortcut Dimension 2 Code":=Acct."Global Dimension 2 Code";
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
          GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
          IF GenJournalLine.Amount<>0 THEN
          GenJournalLine.INSERT;



      ATMTrans."Customer Names":=Acct.Name;
      ATMTrans.Posted:=TRUE;
      ATMTrans.MODIFY;
      success:=TRUE;
      ///sms

      //SMS MESSAGE
            SMSMessage.RESET;
            IF SMSMessage.FIND('+') THEN BEGIN
            iEntryNo:=SMSMessage."Entry No";
            iEntryNo:=iEntryNo+1;
            END
            ELSE BEGIN
            iEntryNo:=1;
            END;

            SMSMessage.RESET;
            SMSMessage.INIT;
            SMSMessage."Entry No":=iEntryNo;
            SMSMessage."Account No":=ATMTrans."Account No";
            SMSMessage."Date Entered":=TODAY;
            SMSMessage."Time Entered":=TIME;
            SMSMessage.Source:='ATM TRANS';
            SMSMessage."Entered By":=USERID;
            SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
            IF ATMTrans.Amount>0 THEN BEGIN
            SMSMessage."SMS Message":='Dear '+SkyMbanking.FirstName(Acct.Name)+' You have withdrawn KES.'+FORMAT(ATMTrans.Amount)+
                                      ' from ATM Location '+ATMTrans."Withdrawal Location"+
                                      ' on '+FORMAT(TODAY) + ' ' +FORMAT(TIME)+'  From Telepost Sacco';

            SMSMessage."Telephone No":=Acct."Phone No.";
            IF Acct."Phone No."='' THEN
              SMSMessage."Telephone No":=Acct."Mobile Phone No";
            SMSMessage.INSERT;
            END;

            IF ATMTrans.Amount<0 THEN BEGIN
            SMSMessage."SMS Message":='Your withdrawal of KES.'+FORMAT(ATMTrans.Amount)+
                                      ' from ATM Location '+ATMTrans."Withdrawal Location"+
                                      ' has been reversed on '+FORMAT(TODAY) + ' ' +FORMAT(TIME)+' From Telepost Sacco' ;

            SMSMessage."Telephone No":=Acct."Phone No.";
             IF Acct."Phone No."='' THEN
              SMSMessage."Telephone No":=Acct."Mobile Phone No";
            SMSMessage.INSERT;
            END;


      //////////////////////////////

      ///end sms

          END;

      END ELSE BEGIN
      ERROR('%1','Account No. %1 not found.',ATMTrans."Account No");
      END;



      //UNTIL ATMTrans.NEXT = 0;


      //Post
      TrCodeunit.RunPostingGenJnl(GenJournalLine,'GENERAL','ATMTRANS');

      {GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
      GenJournalLine.SETRANGE("Journal Batch Name",'ATMTRANS');
      IF GenJournalLine.FIND('-') THEN BEGIN
      REPEAT
      GLPosting.RUN(GenJournalLine);
      UNTIL GenJournalLine.NEXT = 0;
      END;
      }

      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
      GenJournalLine.SETRANGE("Journal Batch Name",'ATMTRANS');
      GenJournalLine.DELETEALL;
      //Post
      END;
      EXIT(success);
    END;

    PROCEDURE fnGetUnpostedTrans@1000000002() TotalUnposted : Integer;
    BEGIN
      ATMTrans.RESET;
      ATMTrans.SETRANGE(ATMTrans.Posted,FALSE);
      IF ATMTrans.FIND('-') THEN BEGIN
        TotalUnposted:=TotalUnposted;
        END;
        EXIT(TotalUnposted);
    END;

    BEGIN
    END.
  }
}

