OBJECT CodeUnit 20383 FixedDepositManagement
{
  OBJECT-PROPERTIES
  {
    Date=11/20/17;
    Time=[ 3:14:59 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    TableNo=23;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      AccountTypes@1102760000 : Record 51516295;
      FDType@1102760001 : Record 51516305;
      GenJournalLine@1102760002 : Record 81;
      LineNo@1102760003 : Integer;
      InterestBuffer@1102760011 : Record 51516324;
      Vend@1102760010 : Record 23;
      GLEntries@1102760009 : Record 17;
      FDInterestCalc@1102760008 : Record 51516306;
      IntRate@1102760007 : Decimal;
      InterestAmount@1102760006 : Decimal;
      FixedDepType@1102760005 : Record 51516305;
      FDDays@1102760004 : Integer;
      IntBufferNo@1000000000 : Integer;
      IntRate2@1000000001 : Decimal;
      IntRate3@1000000002 : Decimal;

    PROCEDURE RollOver@1102760001(Account@1102760000 : Record 23;RunDate@1102760001 : Date);
    BEGIN


      IF Account.Blocked <> Account.Blocked::All THEN BEGIN
      Account.CALCFIELDS(Account."Balance (LCY)");
      IF AccountTypes.GET(Account."Account Type") THEN BEGIN
        IF AccountTypes."Fixed Deposit" = TRUE THEN BEGIN
        IF AccountTypes."Earns Interest" = TRUE THEN
          Account.TESTFIELD(Account."FD Maturity Date");
          IF Account."FD Maturity Date" <= RunDate THEN BEGIN
            IF FDType.GET(Account."Fixed Deposit Type") THEN BEGIN
              CalculateFDInterest(Account,RunDate);

              AccountTypes.RESET;
              AccountTypes.SETRANGE(AccountTypes.Code,Account."Account Type");
              IF AccountTypes.FIND('-') THEN  BEGIN

                LineNo:=LineNo+10000;
                Account.CALCFIELDS("Untranfered Interest");

                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='PURCHASES';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Journal Batch Name":='FXDEP';
                GenJournalLine."Document No.":='FD INTEREST';
                GenJournalLine."External Document No.":=Account."No.";
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No.":=Account."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date":=RunDate;
                GenJournalLine.Description:='FD Interest - '+FORMAT(Account."FD Maturity Date",0,' <Day,2>-<Month Text,3>-<Year4> ');
                GenJournalLine.Description:=UPPERCASE(GenJournalLine.Description);
                GenJournalLine.Amount:=-Account."Untranfered Interest";
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                GenJournalLine."Bal. Account No.":=AccountTypes."Interest Expense Account";
               GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

                //Withholding tax
                LineNo:=LineNo+10000;

                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='PURCHASES';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Journal Batch Name":='FXDEP';
                GenJournalLine."Document No.":='FD INTEREST';
                GenJournalLine."External Document No.":=Account."No.";
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No.":=Account."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date":=RunDate;
                GenJournalLine.Description:='Withholding Tax';
                GenJournalLine.Description:=UPPERCASE(GenJournalLine.Description);
                GenJournalLine.Amount:=Account."Untranfered Interest"*(AccountTypes."Tax On Interest"/100);
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                GenJournalLine."Bal. Account No.":=AccountTypes."Interest Tax Account";
               GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

                //Withholding tax

                //Transfer to savings
                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='PURCHASES';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Journal Batch Name":='FXDEP';
                GenJournalLine."Document No.":='FD INTEREST';
                GenJournalLine."External Document No.":=Account."No.";
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No.":=Account."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date":=RunDate;
                GenJournalLine.Description:='Transfer to Savings';
                GenJournalLine.Description:=UPPERCASE(GenJournalLine.Description);
                GenJournalLine.Amount:=(Account."Balance (LCY)"+Account."Untranfered Interest")-(Account."Untranfered Interest"*(AccountTypes."Tax On Interest"/100));
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                //GenJournalLine."Bal. Account No.":=AccountTypes."Interest Tax Account";
               //GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;


                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='PURCHASES';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Journal Batch Name":='FXDEP';
                GenJournalLine."Document No.":='FD INTEREST';
                GenJournalLine."External Document No.":=Account."No.";
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No.":=Account."Savings Account No.";//Account."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date":=RunDate;
                GenJournalLine.Description:='Transfer from fixed';
                GenJournalLine.Description:=UPPERCASE(GenJournalLine.Description);
                GenJournalLine.Amount:=((Account."Balance (LCY)"+Account."Untranfered Interest")-(Account."Untranfered Interest"*(AccountTypes."Tax On Interest"/100)))*-1;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                //GenJournalLine."Bal. Account No.":=AccountTypes."Interest Tax Account";
               //GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

                //Transfer to savings


                //Post New
                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                GenJournalLine.SETRANGE("Journal Batch Name",'FXDEP');
                IF GenJournalLine.FIND('-') THEN BEGIN
                //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournalLine);
                END;

                //Post New


                InterestBuffer.RESET;
                InterestBuffer.SETRANGE(InterestBuffer."Account No",Account."No.");
                IF InterestBuffer.FIND('-') THEN
                InterestBuffer.MODIFYALL(InterestBuffer.Transferred,TRUE);

                Account."FD Maturity Date":=CALCDATE(FDType.Duration,Account."FD Maturity Date");
                //Account."FD Maturity Instructions" := Account."FD Maturity Instructions"::"Transfer to Savings";
                Account."Fixed Deposit Status":=Account."Fixed Deposit Status"::Closed;
               Account.MODIFY;
              END;
            END;
          END;
        END;
      END;
      END;
    END;

    PROCEDURE Renew@1102760002(Account@1102760000 : Record 23;RunDate@1102760001 : Date);
    BEGIN

      IF Account.Blocked <> Account.Blocked::All THEN   BEGIN
      IF AccountTypes.GET(Account."Account Type") THEN BEGIN
        IF AccountTypes."Fixed Deposit" = TRUE THEN BEGIN
        IF AccountTypes."Earns Interest" = TRUE THEN
          Account.TESTFIELD("FD Maturity Date");
          IF Account."FD Maturity Date" <= RunDate THEN BEGIN
            IF FDType.GET(Account."Fixed Deposit Type") THEN BEGIN
              CalculateFDInterest(Account,RunDate);
              AccountTypes.RESET;
              AccountTypes.SETRANGE(AccountTypes.Code,Account."Account Type");
              IF AccountTypes.FIND('-') THEN  BEGIN
                Account.TESTFIELD("Savings Account No.");


                  LineNo:=LineNo+10000;
                Account.CALCFIELDS("Untranfered Interest");

                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='PURCHASES';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Journal Batch Name":='FXDEP';
                GenJournalLine."Document No.":='FD INTEREST';
                GenJournalLine."External Document No.":=Account."No.";
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No.":=Account."No.";
                //GenJournalLine."Account No.":=Account."Savings Account No.";
               GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date":=RunDate;
                GenJournalLine.Description:='FD Interest - '+FORMAT(Account."FD Maturity Date",0,' <Day,2>-<Month Text,3>-<Year4> ');
                GenJournalLine.Description:=UPPERCASE(GenJournalLine.Description);
                GenJournalLine.Amount:=-Account."Untranfered Interest";
               GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                GenJournalLine."Bal. Account No.":=AccountTypes."Interest Expense Account";
               GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                IF GenJournalLine.Amount<>0 THEN
                  GenJournalLine.INSERT;


                //Withholding tax
                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='PURCHASES';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Journal Batch Name":='FXDEP';
                GenJournalLine."Document No.":='FD INTEREST';
                GenJournalLine."External Document No.":=Account."No.";
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No.":=Account."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date":=RunDate;
                GenJournalLine.Description:='Withholding Tax';
                GenJournalLine.Description:=UPPERCASE(GenJournalLine.Description);
                GenJournalLine.Amount:=Account."Untranfered Interest"*(AccountTypes."Tax On Interest"/100);
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                GenJournalLine."Bal. Account No.":=AccountTypes."Interest Tax Account";
               GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

                //Withholding tax

                //Transfer to savings
                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='PURCHASES';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Journal Batch Name":='FXDEP';
                GenJournalLine."Document No.":='FD INTEREST';
                GenJournalLine."External Document No.":=Account."No.";
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No.":=Account."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date":=RunDate;
                GenJournalLine.Description:='Transfer to Savings';
                GenJournalLine.Description:=UPPERCASE(GenJournalLine.Description);
                GenJournalLine.Amount:=Account."Untranfered Interest"-(Account."Untranfered Interest"*(AccountTypes."Tax On Interest"/100));
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                //GenJournalLine."Bal. Account No.":=AccountTypes."Interest Tax Account";
               //GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;


                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='PURCHASES';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Journal Batch Name":='FXDEP';
                GenJournalLine."Document No.":='FD INTEREST';
                GenJournalLine."External Document No.":=Account."No.";
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No.":=Account."Savings Account No.";//Account."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date":=RunDate;
                GenJournalLine.Description:='Transfer from fixed';
                GenJournalLine.Description:=UPPERCASE(GenJournalLine.Description);
                GenJournalLine.Amount:=(Account."Untranfered Interest"-(Account."Untranfered Interest"*(AccountTypes."Tax On Interest"/100)))*-1;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                //GenJournalLine."Bal. Account No.":=AccountTypes."Interest Tax Account";
               //GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

                //Transfer to savings


                //Post New
                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                GenJournalLine.SETRANGE("Journal Batch Name",'FXDEP');
                IF GenJournalLine.FIND('-') THEN BEGIN
                //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournalLine);
                END;

                //Post New
                InterestBuffer.RESET;
                InterestBuffer.SETRANGE(InterestBuffer."Account No",Account."No.");
                IF InterestBuffer.FIND('-') THEN
                InterestBuffer.MODIFYALL(InterestBuffer.Transferred,TRUE);

                Account."FD Maturity Date":=CALCDATE(FDType.Duration,Account."FD Maturity Date");
                Account."Fixed Deposit Status" := Account."Fixed Deposit Status"::Active;      //mutinda
                Account.MODIFY;
              END;
            END;
          END;
        END;
      END;
      END;
    END;

    PROCEDURE CloseNonRenewable@1102760003(Account@1102760000 : Record 23;RunDate@1102760001 : Date);
    BEGIN

      IF Account.Blocked <> Account.Blocked::All THEN   BEGIN

      IF AccountTypes.GET(Account."Account Type") THEN BEGIN
        IF AccountTypes."Fixed Deposit" = TRUE THEN BEGIN
        IF AccountTypes."Earns Interest" = TRUE THEN
          Account.TESTFIELD("FD Maturity Date");
          IF Account."FD Maturity Date" <= RunDate THEN BEGIN
            IF FDType.GET(Account."Fixed Deposit Type") THEN BEGIN
              CalculateFDInterest(Account,RunDate);

              AccountTypes.RESET;
              AccountTypes.SETRANGE(AccountTypes.Code,Account."Account Type");
              IF AccountTypes.FIND('-') THEN  BEGIN
                Account.TESTFIELD("Savings Account No.");

                  LineNo:=LineNo+10000;
                Account.CALCFIELDS("Untranfered Interest");

                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='PURCHASES';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Journal Batch Name":='FXDEP';
                GenJournalLine."Document No.":='FD INTEREST';
                GenJournalLine."External Document No.":=Account."No.";
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No.":=Account."No.";
               // GenJournalLine."Account No.":=Account."Savings Account No.";
               GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date":=RunDate;
                GenJournalLine.Description:='FD Interest - '+FORMAT(Account."FD Maturity Date",0,' <Day,2>-<Month Text,3>-<Year4> ');
                GenJournalLine.Description:=UPPERCASE(GenJournalLine.Description);
                GenJournalLine.Amount:=-Account."Untranfered Interest";
               GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                GenJournalLine."Bal. Account No.":=AccountTypes."Interest Expense Account";
               GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                IF GenJournalLine.Amount<>0 THEN
                  GenJournalLine.INSERT;


                //Withholding tax
                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='PURCHASES';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Journal Batch Name":='FXDEP';
                GenJournalLine."Document No.":='FD INTEREST';
                GenJournalLine."External Document No.":=Account."No.";
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No.":=Account."No.";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date":=RunDate;
                GenJournalLine.Description:='Withholding Tax';
                GenJournalLine.Description:=UPPERCASE(GenJournalLine.Description);
                GenJournalLine.Amount:=Account."Untranfered Interest"*(AccountTypes."Tax On Interest"/100);
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                GenJournalLine."Bal. Account No.":=AccountTypes."Interest Tax Account";
               GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                IF GenJournalLine.Amount<>0 THEN
                GenJournalLine.INSERT;

                //Withholding tax


                  LineNo:=LineNo+10000;
                Account.CALCFIELDS("Untranfered Interest");

                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='PURCHASES';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Journal Batch Name":='FXDEP';
                GenJournalLine."Document No.":='FD INTEREST';
                GenJournalLine."External Document No.":=Account."No.";
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No.":=Account."No.";
                //GenJournalLine."Account No.":=Account."Savings Account No.";
               GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date":=RunDate;
                GenJournalLine.Description:='Interest rebate on fixed';
                GenJournalLine.Description:=UPPERCASE(GenJournalLine.Description);
                GenJournalLine.Amount:=(Account."Untranfered Interest")*-0.01;
               GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                GenJournalLine."Bal. Account No.":=AccountTypes."Interest Expense Account";
               GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                IF GenJournalLine.Amount<>0 THEN
                  GenJournalLine.INSERT;


                 {
                LineNo:=LineNo+10000;
                Account.CALCFIELDS("Untranfered Interest");

                //Transfer Interest
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='PURCHASES';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Journal Batch Name":='FXDEP';
                GenJournalLine."Document No.":='FD MATURITY';
                GenJournalLine."External Document No.":=Account."No.";
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                IF  Vend.GET (Account."Savings Account No.") THEN BEGIN
                IF Vend.Blocked <> Vend.Blocked::All  THEN BEGIN
                GenJournalLine."Account No.":=Account."Savings Account No.";
                END;
                END;
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date":=RunDate;
                GenJournalLine.Description:='FD Interest - '+ FORMAT(Account."FD Maturity Date",0,' <Day,2>-<Month Text,3>-<Year4> ');
                GenJournalLine.Description:=UPPERCASE(GenJournalLine.Description);
                GenJournalLine.Amount:=-Account."Untranfered Interest";
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                GenJournalLine."Bal. Account No.":=AccountTypes."Interest Expense Account";
               GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                IF GenJournalLine.Amount<>0 THEN
                  GenJournalLine.INSERT;

                //Transfer Amount
                LineNo:=LineNo+10000;
                Account.CALCFIELDS(Account."Balance (LCY)");
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='PURCHASES';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Journal Batch Name":='FXDEP';
                GenJournalLine."Document No.":='FD MATURITY';
                GenJournalLine."External Document No.":=Account."Savings Account No.";
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No.":=Account."No.";
               GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date":=RunDate;
                GenJournalLine.Description:='FD MATURITY - Transfer To Savings';
                GenJournalLine.Amount:=Account."Balance (LCY)";
               GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                IF GenJournalLine.Amount<>0 THEN
                  GenJournalLine.INSERT;

                LineNo:=LineNo+10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name":='PURCHASES';
                GenJournalLine."Line No.":=LineNo;
                GenJournalLine."Journal Batch Name":='FXDEP';
                GenJournalLine."Document No.":='FD MATURITY';
                GenJournalLine."External Document No.":=Account."No.";
                GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;

                IF  Vend.GET (Account."Savings Account No.") THEN BEGIN

                IF Vend.Blocked <> Vend.Blocked::All  THEN BEGIN
                GenJournalLine."Account No.":=Account."Savings Account No.";
                END;
                END;


               GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Posting Date":=RunDate;
                GenJournalLine.Description:='FD MATURITY - Transfer To Savings';
                GenJournalLine.Amount:=-Account."Balance (LCY)";
               GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Shortcut Dimension 1 Code":=Account."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code":=Account."Global Dimension 2 Code";
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
               GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                IF GenJournalLine.Amount<>0 THEN
                  GenJournalLine.INSERT;

               }


                //Post New
                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                GenJournalLine.SETRANGE("Journal Batch Name",'FXDEP');
                IF GenJournalLine.FIND('-') THEN BEGIN
               // CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournalLine);
                END;

                //Post New



                InterestBuffer.RESET;
                InterestBuffer.SETRANGE(InterestBuffer."Account No",Account."No.");
                IF InterestBuffer.FIND('-') THEN
                InterestBuffer.MODIFYALL(InterestBuffer.Transferred,TRUE);

                //Account."FD Maturity Date":=Account."FD Maturity Date";
                Account."FD Maturity Date":=CALCDATE(FDType.Duration,Account."FD Maturity Date");
                Account."Fixed Deposit Status" := Account."Fixed Deposit Status"::Closed;
                Account.MODIFY;
              END;
            END;
          END;
        END;
      END;
      END;
    END;

    PROCEDURE CalculateFDInterest@1102760004(Account@1102760000 : Record 23;RunDate@1102760001 : Date);
    BEGIN
      InterestAmount:=0;
      //IntRate:=0;
                    //MESSAGE(FORMAT(Account."Fixed Deposit Type"));

      //IntRate:=Account."Neg. Interest Rate"; use bands
      InterestBuffer.RESET;
      IF InterestBuffer.FIND('+') THEN
      IntBufferNo:=InterestBuffer.No;


      IF AccountTypes.GET(Account."Account Type") THEN BEGIN
        IF AccountTypes."Fixed Deposit" = TRUE THEN BEGIN
           IF FixedDepType.GET(Account."Fixed Deposit Type") THEN BEGIN
              FDInterestCalc.RESET;
              FDInterestCalc.SETRANGE(FDInterestCalc.Code,Account."Fixed Deposit Type");
              IF FDInterestCalc.FIND('-') THEN BEGIN
                Account.CALCFIELDS("Balance (LCY)");
                REPEAT
                  IF (FDInterestCalc."Minimum Amount" <= Account."Balance (LCY)") AND
                  (Account."Balance (LCY)" <= FDInterestCalc."Maximum Amount") THEN
                    IntRate:=FDInterestCalc."Interest Rate";


                UNTIL FDInterestCalc.NEXT = 0;
              END;

              //MESSAGE(FORMAT(Account."Balance (LCY)"));
              FDDays := CALCDATE(FixedDepType.Duration,RunDate)-RunDate;
             // InterestAmount := Account."Balance (LCY)"*IntRate*0.01*(FDDays/365); //commended upon request by mutinda

              InterestAmount:=ROUND((IntRate*0.01)*(1/12),0.0001,'>')*(Account."FD Duration")*Account."Balance (LCY)";

             // ERROR('interet amount is %1',InterestAmount);
              //InterestAmount := ROUND(InterestAmount,2.0,'>');



              IntBufferNo:=IntBufferNo+1;

              InterestBuffer.INIT;
              InterestBuffer."Account No":=Account."No.";
              InterestBuffer.No:= IntBufferNo;
              InterestBuffer."Account Type":=Account."Account Type";
              InterestBuffer."Interest Date":=RunDate;
              InterestBuffer."Interest Amount":=InterestAmount;
              //InterestBuffer."Interest Earning Balance" := Account."Balance (LCY)"; mutinda
              InterestBuffer.Description:='FD INT - '+FORMAT(Account."FD Maturity Date",0,' <Day,2>-<Month Text,3>-<Year4> ');      //mutinda
              InterestBuffer.Description:=UPPERCASE(InterestBuffer.Description);
              InterestBuffer."User ID":=USERID;
              IF InterestBuffer."Interest Amount" <> 0 THEN
              InterestBuffer.INSERT(TRUE);
           END;
        END;
      END;
    END;

    BEGIN
    END.
  }
}

