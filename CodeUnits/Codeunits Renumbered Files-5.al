OBJECT CodeUnit 20369 Funds Management
{
  OBJECT-PROPERTIES
  {
    Date=07/06/23;
    Time=10:54:08 AM;
    Modified=Yes;
    Version List=Funds ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnRun=VAR
            GenJournalLine@1120054000 : Record 81;
            OverDraftAuthorisation@1120054001 : Record 51516328;
            MembersRegister@1120054002 : Record 51516223;
            Customer@1120054003 : Record 18;
            GenJnlPostLine@1120054004 : Codeunit 12;
            VenLedger@1120054005 : Record 25;
            SalaryProcessingHeader@1120054006 : Record 51516459;
          BEGIN
            SalaryProcessingHeader.GET('SAL0001');
            SalaryProcessingHeader.Posted:=FALSE;
            SalaryProcessingHeader.MODIFY;
            MESSAGE('Done');
          END;

  }
  CODE
  {
    VAR
      TaxCodes@1000 : Record 51516033;
      AdjustGenJnl@1001 : Codeunit 407;
      DocPrint@1002 : Codeunit 229;
      AuditTrail@1120054002 : CodeUnit 20399;
      Trail@1120054001 : Record 51516655;
      EntryNo@1120054000 : Integer;

    PROCEDURE PostPayment@1("Payment Header"@1000 : Record 51516000;"Journal Template"@1005 : Code[20];"Journal Batch"@1006 : Code[20]);
    VAR
      GenJnlLine@1001 : Record 81;
      LineNo@1002 : Integer;
      PaymentLine@1003 : Record 51516001;
      PaymentHeader@1004 : Record 51516000;
      SourceCode@1007 : Code[20];
      BankLedgers@1008 : Record 271;
      PaymentLine2@1010 : Record 51516001;
      PaymentHeader2@1009 : Record 51516000;
    BEGIN
          //Check if Document Already Posted
          BankLedgers.RESET;
          BankLedgers.SETRANGE(BankLedgers."Document No.","Payment Header"."No.");
          BankLedgers.SETRANGE(BankLedgers.Reversed,FALSE);
          IF BankLedgers.FINDFIRST THEN
            ERROR('Document No:'+FORMAT("Payment Header"."No.")+' already exists in Bank No:'+FORMAT("Payment Header"."Bank Account"));
          //end check

        IF ("Payment Header"."Cheque No"<>'') AND ("Payment Header"."Payment Mode"="Payment Header"."Payment Mode"::Cheque) THEN BEGIN
          BankLedgers.RESET;
          BankLedgers.SETRANGE(BankLedgers."Document No.","Payment Header"."Cheque No");
          BankLedgers.SETRANGE(BankLedgers.Reversed,FALSE);
          IF BankLedgers.FINDFIRST THEN
            ERROR('Document No:'+FORMAT("Payment Header"."Cheque No")+' already exists in Bank No:'+FORMAT("Payment Header"."Bank Account"));
        END;

          PaymentHeader.TRANSFERFIELDS("Payment Header",TRUE);
          SourceCode:='PAYMENTJNL';

          //Delete Journal Lines if Exist
          GenJnlLine.RESET;
          GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name","Journal Template");
          GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name","Journal Batch");
          IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
          END;
          //End Delete

          LineNo:=1000;
          //********************************************Add to Bank(Payment Header)*******************************************************//
          PaymentHeader.CALCFIELDS(PaymentHeader."Net Amount");
          GenJnlLine.INIT;
          GenJnlLine."Journal Template Name":="Journal Template";
          GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
          GenJnlLine."Journal Batch Name":="Journal Batch";
          GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
          GenJnlLine."Line No.":=LineNo;
          GenJnlLine."Source Code":=SourceCode;
          GenJnlLine."Posting Date":=PaymentHeader."Posting Date";
          IF CustomerLinesExist(PaymentHeader) THEN
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
          ELSE
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
          GenJnlLine."Document No.":=PaymentHeader."No.";
          GenJnlLine."External Document No.":=PaymentHeader."Cheque No";
          IF PaymentHeader."Payment Mode"=PaymentHeader."Payment Mode"::Cheque THEN BEGIN
               GenJnlLine."Document No.":=PaymentHeader."Cheque No";
               GenJnlLine."External Document No.":=PaymentHeader."No.";
            END;
          GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Bank Account";
          GenJnlLine."Account No.":=PaymentHeader."Bank Account";
          GenJnlLine.VALIDATE(GenJnlLine."Account No.");
          GenJnlLine."Currency Code":=PaymentHeader."Currency Code";
          GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
          //GenJnlLine."Transaction Type":=//
          GenJnlLine."Currency Factor":=PaymentHeader."Currency Factor";
          GenJnlLine.VALIDATE("Currency Factor");
          GenJnlLine.Amount:=-(PaymentHeader."Net Amount");  //Credit Amount
          GenJnlLine.VALIDATE(GenJnlLine.Amount);
          GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
          GenJnlLine."Bal. Account No.":='';
          GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
          GenJnlLine."Shortcut Dimension 1 Code":=PaymentHeader."Global Dimension 1 Code";
          GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
          GenJnlLine."Shortcut Dimension 2 Code":=PaymentHeader."Global Dimension 2 Code";
          GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
          GenJnlLine.ValidateShortcutDimCode(3,PaymentHeader."Shortcut Dimension 3 Code");
          GenJnlLine.ValidateShortcutDimCode(4,PaymentHeader."Shortcut Dimension 4 Code");
          GenJnlLine.ValidateShortcutDimCode(5,PaymentHeader."Shortcut Dimension 5 Code");
          GenJnlLine.ValidateShortcutDimCode(6,PaymentHeader."Shortcut Dimension 6 Code");
          GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
          GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
          GenJnlLine.Description:=COPYSTR(PaymentHeader."Payment Description",1,50);
          GenJnlLine.VALIDATE(GenJnlLine.Description);
          IF PaymentHeader."Payment Mode"<>PaymentHeader."Payment Mode"::Cheque THEN  BEGIN
            GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::" "
          END ELSE BEGIN
            IF PaymentHeader."Cheque Type"=PaymentHeader."Cheque Type"::"Computer Cheque" THEN
             GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::"Computer Check"
            ELSE
               GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::" "
          END;
          IF GenJnlLine.Amount<>0 THEN
             GenJnlLine.INSERT;
          //************************************************End Add to Bank***************************************************************//

          //***********************************************Add Payment Lines**************************************************************//
                 PaymentLine.RESET;
                 PaymentLine.SETRANGE(PaymentLine."Document No",PaymentHeader."No.");
                 PaymentLine.SETFILTER(PaymentLine.Amount,'<>%1',0);
                 IF PaymentLine.FINDSET THEN BEGIN
                   REPEAT
                  //****************************************Add Line NetAmounts***********************************************************//
                      LineNo:=LineNo+1;
                      GenJnlLine.INIT;
                      GenJnlLine."Journal Template Name":="Journal Template";
                      GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                      GenJnlLine."Journal Batch Name":="Journal Batch";
                      GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                      GenJnlLine."Source Code":=SourceCode;
                      GenJnlLine."Line No.":=LineNo;
                      GenJnlLine."Posting Date":=PaymentHeader."Posting Date";
                      GenJnlLine."Document No.":=PaymentLine."Document No";
                      GenJnlLine."Posting Group":=PaymentLine."Default Grouping";    //Posting Group
                      IF CustomerLinesExist(PaymentHeader) THEN
                       GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
                      ELSE
                        GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                      GenJnlLine."Account Type":=PaymentLine."Account Type";
                      GenJnlLine."Account No.":=PaymentLine."Account No.";
                      GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                      GenJnlLine."External Document No.":=PaymentHeader."Cheque No";
                      IF PaymentHeader."Payment Mode"=PaymentHeader."Payment Mode"::Cheque THEN BEGIN
                         GenJnlLine."Document No.":=PaymentHeader."Cheque No";
                         GenJnlLine."External Document No.":=PaymentHeader."No.";
                      END;
                      GenJnlLine."Currency Code":=PaymentHeader."Currency Code";
                      GenJnlLine.VALIDATE("Currency Code");
                      GenJnlLine."Currency Factor":=PaymentHeader."Currency Factor";
                      GenJnlLine.VALIDATE("Currency Factor");
                      GenJnlLine.Amount:=PaymentLine."Net Amount";  //Debit Amount
                      GenJnlLine.VALIDATE(GenJnlLine.Amount);
                      GenJnlLine."Transaction Type":=PaymentLine."Transaction Type";
                      GenJnlLine."Loan No":=PaymentLine."Loan No.";
                      GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                      GenJnlLine."Bal. Account No.":='';
                      GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                      GenJnlLine."Gen. Bus. Posting Group":=PaymentLine."Gen. Bus. Posting Group";
                      GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                      GenJnlLine."Gen. Prod. Posting Group":=PaymentLine."Gen. Prod. Posting Group";
                      GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                      GenJnlLine."VAT Bus. Posting Group":=PaymentLine."VAT Bus. Posting Group";
                      GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                      GenJnlLine."VAT Prod. Posting Group":=PaymentLine."VAT Prod. Posting Group";
                      GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                      GenJnlLine."Shortcut Dimension 1 Code":=PaymentHeader."Global Dimension 1 Code";
                      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                      GenJnlLine."Shortcut Dimension 2 Code":=PaymentHeader."Global Dimension 2 Code";
                      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                      GenJnlLine.ValidateShortcutDimCode(3,PaymentHeader."Shortcut Dimension 3 Code");
                      GenJnlLine.ValidateShortcutDimCode(4,PaymentHeader."Shortcut Dimension 4 Code");
                      GenJnlLine.ValidateShortcutDimCode(5,PaymentHeader."Shortcut Dimension 5 Code");
                      GenJnlLine.ValidateShortcutDimCode(6,PaymentHeader."Shortcut Dimension 6 Code");
                      GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
                      GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
                      GenJnlLine.Description:=COPYSTR(PaymentHeader."Payment Description",1,50);
                      GenJnlLine.VALIDATE(GenJnlLine.Description);
                      GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                      GenJnlLine."Applies-to Doc. No.":=PaymentLine."Applies-to Doc. No.";
                      GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                      GenJnlLine."Applies-to ID":=PaymentLine."Applies-to ID";

                      IF GenJnlLine.Amount<>0 THEN
                         GenJnlLine.INSERT;
                 //*************************************End add Line NetAmounts**********************************************************//

                 //****************************************Add VAT Amounts***************************************************************//
                   IF PaymentLine."VAT Code"<>'' THEN BEGIN
                     TaxCodes.RESET;
                     TaxCodes.SETRANGE(TaxCodes."Tax Code",PaymentLine."VAT Code");
                     IF TaxCodes.FINDFIRST THEN BEGIN
                        TaxCodes.TESTFIELD(TaxCodes."Account No");
                        LineNo:=LineNo+1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name":="Journal Template";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name":="Journal Batch";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine."Source Code":=SourceCode;
                        GenJnlLine."Posting Date":=TODAY;//PaymentHeader."Posting Date";
                        IF CustomerLinesExist(PaymentHeader) THEN
                         GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
                        ELSE
                         GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                        GenJnlLine."Document No.":=PaymentLine."Document No";
                        //GenJnlLine."Posting Group":=PaymentLine."Default Grouping";    //Posting Group
                        GenJnlLine."External Document No.":=PaymentHeader."Cheque No";
                         IF PaymentHeader."Payment Mode"=PaymentHeader."Payment Mode"::Cheque THEN BEGIN
                              GenJnlLine."Document No.":=PaymentHeader."Cheque No";
                              GenJnlLine."External Document No.":=PaymentHeader."No.";
                         END;
                        GenJnlLine."Account Type":=TaxCodes."Account Type";
                        GenJnlLine."Account No.":=TaxCodes."Account No";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code":=PaymentHeader."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor":=PaymentHeader."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");
                        GenJnlLine."Loan No":=PaymentLine."Loan No.";
                        GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine.Amount:=-(PaymentLine."VAT Amount");   //Credit Amount
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Transaction Type":=PaymentLine."Transaction Type";
                        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No.":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code":=PaymentHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=PaymentHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3,PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4,PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5,PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6,PaymentHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description:=COPYSTR('VAT:' + FORMAT(PaymentLine."Account Type") + '::' + FORMAT(PaymentLine."Account Name"),1,50);
                        IF GenJnlLine.Amount<>0 THEN
                          GenJnlLine.INSERT;

                        //VAT Balancing goes to Vendor
                        LineNo:=LineNo+1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name":="Journal Template";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name":="Journal Batch";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine."Source Code":=SourceCode;
                        GenJnlLine."Posting Date":=PaymentHeader."Posting Date";
                        IF CustomerLinesExist(PaymentHeader) THEN
                         GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
                        ELSE
                          GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                        GenJnlLine."Document No.":=PaymentLine."Document No";
                        GenJnlLine."Posting Group":=PaymentLine."Default Grouping";    //Posting Group
                        GenJnlLine."External Document No.":=PaymentHeader."Cheque No";
                        IF PaymentHeader."Payment Mode"=PaymentHeader."Payment Mode"::Cheque THEN BEGIN
                            GenJnlLine."Document No.":=PaymentHeader."Cheque No";
                            GenJnlLine."External Document No.":=PaymentHeader."No.";
                        END;
                        GenJnlLine."Account Type":=PaymentLine."Account Type";
                        GenJnlLine."Account No.":=PaymentLine."Account No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                          GenJnlLine."Transaction Type":=PaymentLine."Transaction Type";
                          GenJnlLine."Loan No":=PaymentLine."Loan No.";
                        GenJnlLine."Currency Code":=PaymentHeader."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor":=PaymentHeader."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");
                        GenJnlLine.Amount:=PaymentLine."VAT Amount";   //Debit Amount
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No.":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code":=PaymentHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=PaymentHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3,PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4,PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5,PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6,PaymentHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description:=COPYSTR('VAT:' + FORMAT(PaymentLine."Account Type") + '::' + FORMAT(PaymentLine."Account Name"),1,50) ;
                        GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                        GenJnlLine."Applies-to Doc. No.":=PaymentLine."Applies-to Doc. No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID":=PaymentLine."Applies-to ID";
                        IF GenJnlLine.Amount<>0 THEN
                           GenJnlLine.INSERT;

                     END;
                   END;
                 //*************************************End Add VAT Amounts**************************************************************//

                 //****************************************Add W/TAX Amounts*************************************************************//
                   IF PaymentLine."W/TAX Code"<>'' THEN BEGIN
                     TaxCodes.RESET;
                     TaxCodes.SETRANGE(TaxCodes."Tax Code",PaymentLine."W/TAX Code");
                     IF TaxCodes.FINDFIRST THEN BEGIN
                        TaxCodes.TESTFIELD(TaxCodes."Account No");
                        LineNo:=LineNo+1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name":="Journal Template";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name":="Journal Batch";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine."Source Code":=SourceCode;
                        GenJnlLine."Posting Date":=PaymentHeader."Posting Date";
                        IF CustomerLinesExist(PaymentHeader) THEN
                         GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
                        ELSE
                         GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                        GenJnlLine."Document No.":=PaymentLine."Document No";
                        //GenJnlLine."Posting Group":=PaymentLine."Default Grouping";    //Posting Group
                        GenJnlLine."External Document No.":=PaymentHeader."Cheque No";
                        IF PaymentHeader."Payment Mode"=PaymentHeader."Payment Mode"::Cheque THEN BEGIN
                            GenJnlLine."Document No.":=PaymentHeader."Cheque No";
                            GenJnlLine."External Document No.":=PaymentHeader."No.";
                        END;
                        GenJnlLine."Account Type":=TaxCodes."Account Type";
                        GenJnlLine."Account No.":=TaxCodes."Account No";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Loan No":=PaymentLine."Loan No.";
                        GenJnlLine."Currency Code":=PaymentHeader."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor":=PaymentHeader."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");
                        GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine.Amount:=-(PaymentLine."W/TAX Amount");   //Credit Amount
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No.":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code":=PaymentHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=PaymentHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3,PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4,PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5,PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6,PaymentHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description:=COPYSTR('W/TAX:' + FORMAT(PaymentLine."Account Type") + '::' + FORMAT(PaymentLine."Account Name"),1,50);
                        IF GenJnlLine.Amount<>0 THEN
                          GenJnlLine.INSERT;

                        //W/TAX Balancing goes to Vendor
                        LineNo:=LineNo+1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name":="Journal Template";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name":="Journal Batch";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine."Source Code":=SourceCode;
                        GenJnlLine."Posting Date":=PaymentHeader."Posting Date";
                        IF CustomerLinesExist(PaymentHeader) THEN
                         GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
                        ELSE
                          GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                        GenJnlLine."Document No.":=PaymentLine."Document No";
                        GenJnlLine."Posting Group":=PaymentLine."Default Grouping";    //Posting Group
                        GenJnlLine."External Document No.":=PaymentHeader."Cheque No";
                        IF PaymentHeader."Payment Mode"=PaymentHeader."Payment Mode"::Cheque THEN BEGIN
                            GenJnlLine."Document No.":=PaymentHeader."Cheque No";
                            GenJnlLine."External Document No.":=PaymentHeader."No.";
                        END;
                        GenJnlLine."Account Type":=PaymentLine."Account Type";
                        GenJnlLine."Loan No":=PaymentLine."Loan No.";
                        GenJnlLine."Account No.":=PaymentLine."Account No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code":=PaymentHeader."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor":=PaymentHeader."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");
                        GenJnlLine.Amount:=PaymentLine."W/TAX Amount";   //Debit Amount
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No.":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                          GenJnlLine."Transaction Type":=PaymentLine."Transaction Type";
                        GenJnlLine."Shortcut Dimension 1 Code":=PaymentHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=PaymentHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3,PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4,PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5,PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6,PaymentHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description:=COPYSTR('W/TAX:' + FORMAT(PaymentLine."Account Type") + '::' + FORMAT(PaymentLine."Account Name"),1,50) ;
                        GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                        GenJnlLine."Applies-to Doc. No.":=PaymentLine."Applies-to Doc. No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID":=PaymentLine."Applies-to ID";
                        IF GenJnlLine.Amount<>0 THEN
                           GenJnlLine.INSERT;

                     END;
                   END;

                 //*************************************End Add W/TAX Amounts************************************************************//

                 //*************************************Add Retention Amounts************************************************************//
                 //***********************************End Add Retention Amounts**********************************************************//

                 //Create Audit Entry
              AuditTrail.FnGetLastEntry();
              AuditTrail.FnGetComputerName();
              AuditTrail.FnInsertAuditRecords(EntryNo,USERID,PaymentLine."Transaction Type Description",PaymentLine.Amount,'FINANCE,',TODAY,TIME,'',PaymentLine."Document No",PaymentLine."Account No.",'');
              //End Create Audit Entry

                    UNTIL PaymentLine.NEXT=0;
                 END;

          //*********************************************End Add Payment Lines************************************************************//
          COMMIT;
          //********************************************Post the Journal Lines************************************************************//
          GenJnlLine.RESET;
          GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name","Journal Template");
          GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name","Journal Batch");
          //Adjust GenJnlLine Exchange Rate Rounding Balances
             AdjustGenJnl.RUN(GenJnlLine);
          //End Adjust GenJnlLine Exchange Rate Rounding Balances


          //Before posting if its computer cheque,print the cheque
          IF (PaymentHeader."Payment Mode"=PaymentHeader."Payment Mode"::Cheque) AND
          (PaymentHeader."Cheque Type"=PaymentHeader."Cheque Type"::"Computer Cheque") THEN BEGIN
            DocPrint.PrintCheck(GenJnlLine);
            CODEUNIT.RUN(CODEUNIT::"Adjust Gen. Journal Balance",GenJnlLine);
          END;

          //Now Post the Journal Lines
         CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnlLine);
          //***************************************************End Posting****************************************************************//
          COMMIT;
          //*************************************************Update Document**************************************************************//
            PaymentHeader2.RESET;
            PaymentHeader2.SETRANGE(PaymentHeader2."No.",PaymentHeader."No.");
            IF PaymentHeader2.FINDFIRST THEN BEGIN
              PaymentHeader2.Status:=PaymentHeader2.Status::Posted;
              PaymentHeader2.Posted:=TRUE;
              PaymentHeader2."Posted By":=USERID;
              PaymentHeader2."Date Posted":=TODAY;
              PaymentHeader2."Time Posted":=TIME;
              PaymentHeader2.MODIFY;

              PaymentLine2.RESET;
              PaymentLine2.SETRANGE(PaymentLine2."Document No",PaymentHeader2."No.");
              IF PaymentLine2.FINDSET THEN BEGIN
                REPEAT
                    PaymentLine2.Status:=PaymentLine2.Status::Posted;
                    PaymentLine2.Posted:=TRUE;
                    PaymentLine2."Posted By":=USERID;
                    PaymentLine2."Date Posted":=TODAY;
                    PaymentLine2."Time Posted":=TIME;
                    PaymentLine2.MODIFY;
                UNTIL PaymentLine2.NEXT=0;
              END;
            END;


          //***********************************************End Update Document************************************************************//
    END;

    PROCEDURE PostReceipt@8("Receipt Header"@1000 : Record 51516002;"Journal Template"@1005 : Code[20];"Journal Batch"@1006 : Code[20]);
    VAR
      GenJnlLine@1001 : Record 81;
      LineNo@1002 : Integer;
      ReceiptLine@1003 : Record 51516003;
      ReceiptHeader@1004 : Record 51516002;
      SourceCode@1007 : Code[20];
      BankLedgers@1008 : Record 271;
      ReceiptLine2@1010 : Record 51516003;
      ReceiptHeader2@1009 : Record 51516002;
    BEGIN
          ReceiptHeader.TRANSFERFIELDS("Receipt Header",TRUE);
          SourceCode:='RECEIPTJNL';

          //Delete Journal Lines if Exist
          GenJnlLine.RESET;
          GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name","Journal Template");
          GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name","Journal Batch");
          IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
          END;
          //End Delete

          LineNo:=1000;
          //********************************************Add to Bank(Payment Header)*******************************************************//
          ReceiptHeader.CALCFIELDS(ReceiptHeader."Total Amount");
          GenJnlLine.INIT;
          GenJnlLine."Journal Template Name":="Journal Template";
          GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
          GenJnlLine."Journal Batch Name":="Journal Batch";
          GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
          GenJnlLine."Line No.":=LineNo;
          GenJnlLine."Source Code":=SourceCode;
          GenJnlLine."Posting Date":=ReceiptHeader."Posting Date";
          //IF CustomerLinesExist(ReceiptHeader) THEN
            //GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
          //ELSE
            //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
          GenJnlLine."Document No.":=ReceiptHeader."No.";
          GenJnlLine."Document Type":=GenJnlLine."Document Type"::" ";
          GenJnlLine."External Document No.":=ReceiptHeader."Cheque No";
          GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Bank Account";
          GenJnlLine."Account No.":=ReceiptHeader."Bank Code";
          GenJnlLine.VALIDATE(GenJnlLine."Account No.");
          GenJnlLine."Currency Code":=ReceiptHeader."Currency Code";
          GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
          GenJnlLine."Currency Factor":=ReceiptHeader."Currency Factor";
          GenJnlLine.VALIDATE("Currency Factor");
          GenJnlLine.Amount:=ReceiptHeader."Total Amount";  //Debit Amount
          GenJnlLine.VALIDATE(GenJnlLine.Amount);
          GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
          GenJnlLine."Bal. Account No.":='';
          GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
          GenJnlLine."Shortcut Dimension 1 Code":=ReceiptHeader."Global Dimension 1 Code";
          GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
          GenJnlLine."Shortcut Dimension 2 Code":=ReceiptHeader."Global Dimension 2 Code";
          GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
          GenJnlLine.ValidateShortcutDimCode(3,ReceiptHeader."Shortcut Dimension 3 Code");
          GenJnlLine.ValidateShortcutDimCode(4,ReceiptHeader."Shortcut Dimension 4 Code");
          GenJnlLine.ValidateShortcutDimCode(5,ReceiptHeader."Shortcut Dimension 5 Code");
          GenJnlLine.ValidateShortcutDimCode(6,ReceiptHeader."Shortcut Dimension 6 Code");
          GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
          GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
          GenJnlLine.Description:=COPYSTR(ReceiptHeader.Description,1,50);
          GenJnlLine.VALIDATE(GenJnlLine.Description);
          IF GenJnlLine.Amount<>0 THEN
             GenJnlLine.INSERT;
          //************************************************End Add to Bank***************************************************************//

          //***********************************************Add Receipt Lines**************************************************************//
                 ReceiptLine.RESET;
                 ReceiptLine.SETRANGE(ReceiptLine."Document No",ReceiptHeader."No.");
                 ReceiptLine.SETFILTER(ReceiptLine.Amount,'<>%1',0);
                 IF ReceiptLine.FINDSET THEN BEGIN
                   REPEAT
                  //****************************************Add Line NetAmounts***********************************************************//
                      LineNo:=LineNo+1;
                      GenJnlLine.INIT;
                      GenJnlLine."Journal Template Name":="Journal Template";
                      GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                      GenJnlLine."Journal Batch Name":="Journal Batch";
                      GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                      GenJnlLine."Source Code":=SourceCode;
                      GenJnlLine."Line No.":=LineNo;
                      GenJnlLine."Posting Date":=ReceiptHeader."Posting Date";
                      GenJnlLine."Document No.":=ReceiptLine."Document No";
                      GenJnlLine."Document Type":=GenJnlLine."Document Type"::" ";
                      GenJnlLine."Account Type":=ReceiptLine."Account Type";
                      GenJnlLine."Account No.":=ReceiptLine."Account Code";
                      GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                      GenJnlLine."Transaction Type":=ReceiptLine."BOSATransaction Type";
                      GenJnlLine."Loan No":=ReceiptLine."Loan No";
                       GenJnlLine."Currency Code":=ReceiptHeader."Currency Code";
                      GenJnlLine.VALIDATE("Currency Code");
                      GenJnlLine."Currency Factor":=ReceiptHeader."Currency Factor";
                      GenJnlLine.VALIDATE("Currency Factor");
                      GenJnlLine.Amount:=-(ReceiptLine.Amount);  //Credit Amount
                      GenJnlLine.VALIDATE(GenJnlLine.Amount);
                      GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                      GenJnlLine."Bal. Account No.":='';
                      GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                      GenJnlLine."Gen. Bus. Posting Group":=ReceiptLine."Gen. Bus. Posting Group";
                      GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                      GenJnlLine."Gen. Prod. Posting Group":=ReceiptLine."Gen. Prod. Posting Group";
                      GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                      GenJnlLine."VAT Bus. Posting Group":=ReceiptLine."VAT Bus. Posting Group";
                      GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                      GenJnlLine."VAT Prod. Posting Group":=ReceiptLine."VAT Prod. Posting Group";
                      GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                      GenJnlLine."Shortcut Dimension 1 Code":=ReceiptHeader."Global Dimension 1 Code";
                      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                      GenJnlLine."Shortcut Dimension 2 Code":=ReceiptHeader."Global Dimension 2 Code";
                      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                      GenJnlLine.ValidateShortcutDimCode(3,ReceiptHeader."Shortcut Dimension 3 Code");
                      GenJnlLine.ValidateShortcutDimCode(4,ReceiptHeader."Shortcut Dimension 4 Code");
                      GenJnlLine.ValidateShortcutDimCode(5,ReceiptHeader."Shortcut Dimension 5 Code");
                      GenJnlLine.ValidateShortcutDimCode(6,ReceiptHeader."Shortcut Dimension 6 Code");
                      GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
                      GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
                      GenJnlLine.Description:=COPYSTR(ReceiptHeader.Description,1,50);
                      GenJnlLine.VALIDATE(GenJnlLine.Description);
                      GenJnlLine."Interest Code":=ReceiptHeader."Interest Code";
                      {GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                      GenJnlLine."Applies-to Doc. No.":=PaymentLine."Applies-to Doc. No.";
                      GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                      GenJnlLine."Applies-to ID":=PaymentLine."Applies-to ID"; }

                      IF GenJnlLine.Amount<>0 THEN
                         GenJnlLine.INSERT;
                 //*************************************End add Line NetAmounts**********************************************************//

                 //****************************************Add VAT Amounts***************************************************************//
                   IF ReceiptLine."VAT Code"<>'' THEN BEGIN
                     TaxCodes.RESET;
                     TaxCodes.SETRANGE(TaxCodes."Tax Code",ReceiptLine."VAT Code");
                     IF TaxCodes.FINDFIRST THEN BEGIN
                        TaxCodes.TESTFIELD(TaxCodes."Account No");
                        LineNo:=LineNo+1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name":="Journal Template";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name":="Journal Batch";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine."Source Code":=SourceCode;
                        GenJnlLine."Posting Date":=ReceiptHeader."Posting Date";
                        GenJnlLine."Document No.":=ReceiptLine."Document No";
                        GenJnlLine."Document Type":=GenJnlLine."Document Type"::"7";
                        GenJnlLine."External Document No.":=ReceiptHeader."Cheque No";
                        GenJnlLine."Account Type":=TaxCodes."Account Type";
                        GenJnlLine."Account No.":=TaxCodes."Account No";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code":=ReceiptHeader."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor":=ReceiptHeader."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");
                        GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine.Amount:=-(ReceiptLine."VAT Amount");   //Credit Amount
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No.":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code":=ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3,ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4,ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5,ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6,ReceiptHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description:=COPYSTR('VAT:' + FORMAT(ReceiptLine."Account Type") + '::' + FORMAT(ReceiptLine."Account Name"),1,50);
                        IF GenJnlLine.Amount<>0 THEN
                          GenJnlLine.INSERT;

                        //VAT Balancing goes to Vendor
                        LineNo:=LineNo+1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name":="Journal Template";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name":="Journal Batch";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine."Source Code":=SourceCode;
                        GenJnlLine."Posting Date":=ReceiptHeader."Posting Date";
                        GenJnlLine."Document No.":=ReceiptLine."Document No";
                        GenJnlLine."Document Type":=GenJnlLine."Document Type"::"7";
                        GenJnlLine."External Document No.":=ReceiptHeader."Cheque No";
                        GenJnlLine."Account Type":=ReceiptLine."Account Type";
                        GenJnlLine."Account No.":=ReceiptLine."Account Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code":=ReceiptHeader."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor":=ReceiptHeader."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");
                        GenJnlLine.Amount:=ReceiptLine."VAT Amount";   //Debit Amount
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No.":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code":=ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3,ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4,ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5,ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6,ReceiptHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description:=COPYSTR('VAT:' + FORMAT(ReceiptLine."Account Type") + '::' + FORMAT(ReceiptLine."Account Name"),1,50) ;
                        GenJnlLine."Interest Code":=ReceiptHeader."Interest Code";
                        {GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                        GenJnlLine."Applies-to Doc. No.":=PaymentLine."Applies-to Doc. No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID":=PaymentLine."Applies-to ID";}
                        IF GenJnlLine.Amount<>0 THEN
                           GenJnlLine.INSERT;

                     END;
                   END;
                 //*************************************End Add VAT Amounts**************************************************************//

                 //****************************************Add W/TAX Amounts*************************************************************//
                   IF ReceiptLine."W/TAX Code"<>'' THEN BEGIN
                     TaxCodes.RESET;
                     TaxCodes.SETRANGE(TaxCodes."Tax Code",ReceiptLine."W/TAX Code");
                     IF TaxCodes.FINDFIRST THEN BEGIN
                        TaxCodes.TESTFIELD(TaxCodes."Account No");
                        LineNo:=LineNo+1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name":="Journal Template";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name":="Journal Batch";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine."Source Code":=SourceCode;
                        GenJnlLine."Posting Date":=ReceiptHeader."Posting Date";
                        GenJnlLine."Document No.":=ReceiptLine."Document No";
                        GenJnlLine."Document Type":=GenJnlLine."Document Type"::"7";
                        GenJnlLine."External Document No.":=ReceiptHeader."Cheque No";
                        GenJnlLine."Account Type":=TaxCodes."Account Type";
                        GenJnlLine."Account No.":=TaxCodes."Account No";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code":=ReceiptHeader."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor":=ReceiptHeader."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");
                        GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine.Amount:=-(ReceiptLine."W/TAX Amount");   //Credit Amount
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No.":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code":=ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3,ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4,ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5,ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6,ReceiptHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description:=COPYSTR('W/TAX:' + FORMAT(ReceiptLine."Account Type") + '::' + FORMAT(ReceiptLine."Account Name"),1,50);
                        IF GenJnlLine.Amount<>0 THEN
                          GenJnlLine.INSERT;

                        //W/TAX Balancing goes to Vendor
                        LineNo:=LineNo+1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name":="Journal Template";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name":="Journal Batch";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine."Source Code":=SourceCode;
                        GenJnlLine."Posting Date":=ReceiptHeader."Posting Date";
                        GenJnlLine."Document No.":=ReceiptLine."Document No";
                        GenJnlLine."Document Type":=GenJnlLine."Document Type"::"7";
                        GenJnlLine."External Document No.":=ReceiptHeader."Cheque No";
                        GenJnlLine."Account Type":=ReceiptLine."Account Type";
                        GenJnlLine."Account No.":=ReceiptLine."Account Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code":=ReceiptHeader."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor":=ReceiptHeader."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");
                        GenJnlLine.Amount:=ReceiptLine."W/TAX Amount";   //Debit Amount
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No.":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code":=ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3,ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4,ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5,ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6,ReceiptHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description:=COPYSTR('W/TAX:' + FORMAT(ReceiptLine."Account Type") + '::' + FORMAT(ReceiptLine."Account Name"),1,50);
                        GenJnlLine."Interest Code":=ReceiptHeader."Interest Code";
                        {GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                        GenJnlLine."Applies-to Doc. No.":=PaymentLine."Applies-to Doc. No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID":=PaymentLine."Applies-to ID";}
                        IF GenJnlLine.Amount<>0 THEN
                           GenJnlLine.INSERT;

                     END;
                   END;

                 //*************************************End Add W/TAX Amounts************************************************************//

                 //*************************************Add Retention Amounts************************************************************//
                 //***********************************End Add Retention Amounts**********************************************************//

                 //****************************************Add Legal Amounts***************************************************************//
                   IF ReceiptLine."Legal Fee Code"<>'' THEN BEGIN
                     ReceiptLine.TESTFIELD(ReceiptLine."Account Type",ReceiptLine."Account Type"::Investor);//Applies to investor Accounts only
                     TaxCodes.RESET;
                     TaxCodes.SETRANGE(TaxCodes."Tax Code",ReceiptLine."Legal Fee Code");
                     IF TaxCodes.FINDFIRST THEN BEGIN
                        TaxCodes.TESTFIELD(TaxCodes."Account No");
                        LineNo:=LineNo+1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name":="Journal Template";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name":="Journal Batch";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine."Source Code":=SourceCode;
                        GenJnlLine."Posting Date":=ReceiptHeader."Posting Date";
                        //IF CustomerLinesExist(ReceiptHeader) THEN
                         //GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
                        //ELSE
                         //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                        GenJnlLine."Document No.":=ReceiptLine."Document No";
                        GenJnlLine."External Document No.":=ReceiptHeader."Cheque No";
                        GenJnlLine."Account Type":=TaxCodes."Account Type";
                        GenJnlLine."Account No.":=TaxCodes."Account No";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code":=ReceiptHeader."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor":=ReceiptHeader."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");
                        GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group":='';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                        ReceiptLine.TESTFIELD(ReceiptLine."Legal Fee Amount");
                        GenJnlLine.Amount:=-(ReceiptLine."Legal Fee Amount");   //Credit Amount
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No.":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code":=ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3,ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4,ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5,ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6,ReceiptHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description:=COPYSTR('LEGAL FEE:' + FORMAT(ReceiptLine."Account Type") + '::' + FORMAT(ReceiptLine."Account Name"),1,50);
                        IF GenJnlLine.Amount<>0 THEN
                          GenJnlLine.INSERT;

                        //Legal Balancing goes to Investor
                        LineNo:=LineNo+1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name":="Journal Template";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name":="Journal Batch";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine."Source Code":=SourceCode;
                        GenJnlLine."Posting Date":=ReceiptHeader."Posting Date";
                        //IF CustomerLinesExist(ReceiptHeader) THEN
                         //GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
                        //ELSE
                         //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                        GenJnlLine."Document No.":=ReceiptLine."Document No";
                        GenJnlLine."External Document No.":=ReceiptHeader."Cheque No";
                        GenJnlLine."Account Type":=ReceiptLine."Account Type";
                        GenJnlLine."Account No.":=ReceiptLine."Account Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code":=ReceiptHeader."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor":=ReceiptHeader."Currency Factor";
                        GenJnlLine.VALIDATE("Currency Factor");
                        GenJnlLine.Amount:=ReceiptLine."Legal Fee Amount";   //Debit Amount
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No.":='';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code":=ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3,ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4,ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5,ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6,ReceiptHeader."Shortcut Dimension 6 Code");
                        GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
                        GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description:=COPYSTR('LEGAL FEE:' + FORMAT(ReceiptLine."Account Type") + '::' + FORMAT(ReceiptLine."Account Name"),1,50) ;
                        GenJnlLine."Interest Code":=ReceiptHeader."Interest Code";
                        {GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                        GenJnlLine."Applies-to Doc. No.":=PaymentLine."Applies-to Doc. No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID":=PaymentLine."Applies-to ID";}
                        IF GenJnlLine.Amount<>0 THEN
                           GenJnlLine.INSERT;

                     END;
                   END;
                 //*************************************End Add Legal Amounts**************************************************************//

                    UNTIL ReceiptLine.NEXT=0;
                 END;

          //*********************************************End Add Payment Lines************************************************************//
          COMMIT;
          //********************************************Post the Journal Lines************************************************************//
          GenJnlLine.RESET;
          GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name","Journal Template");
          GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name","Journal Batch");
          //Adjust GenJnlLine Exchange Rate Rounding Balances
             AdjustGenJnl.RUN(GenJnlLine);
          //End Adjust GenJnlLine Exchange Rate Rounding Balances

          //Now Post the Journal Lines
          CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnlLine);
          //***************************************************End Posting****************************************************************//
          COMMIT;
          //*************************************************Update Document**************************************************************//
          BankLedgers.RESET;
          BankLedgers.SETRANGE(BankLedgers."Document No.",ReceiptHeader."No.");
          IF BankLedgers.FINDFIRST THEN BEGIN
            ReceiptHeader2.RESET;
            ReceiptHeader2.SETRANGE(ReceiptHeader2."No.",ReceiptHeader."No.");
            IF ReceiptHeader2.FINDFIRST THEN BEGIN
              ReceiptHeader2.Status:=ReceiptHeader2.Status::Posted;
              ReceiptHeader2.Posted:=TRUE;
              ReceiptHeader2."Posted By":=USERID;
              ReceiptHeader2."Date Posted":=TODAY;
              ReceiptHeader2."Time Posted":=TIME;
              ReceiptHeader2.MODIFY;
              ReceiptLine2.RESET;
              ReceiptLine2.SETRANGE(ReceiptLine2."Document No",ReceiptHeader2."No.");
              IF ReceiptLine2.FINDSET THEN BEGIN
                REPEAT
                    ReceiptLine2.Status:=ReceiptLine2.Status::Posted;
                    ReceiptLine2.Posted:=TRUE;
                    ReceiptLine2."Posted By":=USERID;
                    ReceiptLine2."User ID":=USERID;
                    ReceiptLine2."Date Posted":=TODAY;
                    ReceiptLine2."Time Posted":=TIME;
                    ReceiptLine2.MODIFY;
                UNTIL ReceiptLine2.NEXT=0;
              END;
            END;
          END;

          //***********************************************End Update Document************************************************************//
    END;

    PROCEDURE PostInvestorReceipt@6("Receipt Header"@1002 : Record 51516002;"Journal Template"@1001 : Code[20];"Journal Batch"@1000 : Code[20]) : Boolean;
    VAR
      ReceiptLine@1006 : Record 51516003;
      ReceiptHeader@1005 : Record 51516002;
      ReceiptLine2@1004 : Record 51516003;
      ReceiptHeader2@1003 : Record 51516002;
    BEGIN
       //Post the Receipt
       PostReceipt("Receipt Header","Journal Template","Journal Batch");
       COMMIT;
       //Update investor Amounts
       ReceiptHeader.RESET;
       ReceiptHeader.SETRANGE(ReceiptHeader."No.","Receipt Header"."No.");
       ReceiptHeader.SETRANGE(ReceiptHeader.Posted,TRUE);
       IF ReceiptHeader.FINDFIRST THEN BEGIN
          ReceiptHeader.CALCFIELDS(ReceiptHeader."Investor Net Amount",ReceiptHeader."Investor Net Amount(LCY)");
          InsertInvestorLedger(ReceiptHeader."Investor No.",ReceiptHeader."Interest Code",
          ReceiptHeader."Investor Net Amount",ReceiptHeader."Investor Net Amount(LCY)",ReceiptHeader."No.",ReceiptHeader."Posting Date");
          ReceiptLine.RESET;
          ReceiptLine.SETRANGE(ReceiptLine."Document No",ReceiptHeader."No.");
          IF ReceiptLine.FINDSET THEN BEGIN
            REPEAT
              IF (ReceiptLine."Account Type"=ReceiptLine."Account Type"::Investor) AND (ReceiptLine."Account Code"<>'') THEN
                UpdateInvestorAmounts(ReceiptLine."Account Code",ReceiptHeader."Interest Code",ReceiptHeader."Posting Date",
                                      ReceiptHeader."Investor Net Amount",ReceiptHeader."Investor Net Amount(LCY)");
            UNTIL ReceiptLine.NEXT=0;
          END;
          EXIT(TRUE);
       END ELSE BEGIN
        EXIT(FALSE);
       END;
    END;

    PROCEDURE PostPropertyReceipt@11("Receipt Header"@1002 : Record 51516002;"Journal Template"@1001 : Code[20];"Journal Batch"@1000 : Code[20];"Property No"@1007 : Code[20];Receipt@1008 : Code[20];Cust@1009 : Code[20];CustName@1010 : Text[50];Amount@1011 : Decimal) : Boolean;
    VAR
      ReceiptLine@1006 : Record 51516003;
      ReceiptHeader@1005 : Record 51516002;
      ReceiptLine2@1004 : Record 51516003;
      ReceiptHeader2@1003 : Record 51516002;
    BEGIN
       //Post the Receipt
       PostReceipt("Receipt Header","Journal Template","Journal Batch");
       COMMIT;
       //Update Property
       IF UpdateProperty("Property No",Receipt,Cust,CustName,Amount) THEN BEGIN
         EXIT(TRUE);
       END ELSE BEGIN
         EXIT(FALSE);
       END;
    END;

    PROCEDURE PostFundsTransfer@7();
    BEGIN
    END;

    PROCEDURE PostImprest@3();
    BEGIN
    END;

    PROCEDURE PostImprestAccounting@4();
    BEGIN
    END;

    PROCEDURE PostFundsClaim@5();
    BEGIN
    END;

    LOCAL PROCEDURE CustomerLinesExist@9("Payment Header"@1000 : Record 51516000) : Boolean;
    VAR
      "Payment Line"@1001 : Record 51516001;
      "Payment Line2"@1002 : Record 51516001;
    BEGIN
         "Payment Line".RESET;
         "Payment Line".SETRANGE("Payment Line"."Document No","Payment Header"."No.");
         IF "Payment Line".FINDFIRST THEN BEGIN
            IF "Payment Line"."Account Type"="Payment Line"."Account Type"::Customer THEN BEGIN
              EXIT(TRUE);
            END ELSE BEGIN
              "Payment Line2".RESET;
              "Payment Line2".SETRANGE("Payment Line2"."Document No","Payment Header"."No.");
              "Payment Line2".SETFILTER("Payment Line2"."Net Amount",'<%1',0);
              IF "Payment Line2".FINDFIRST THEN
                EXIT(TRUE)
              ELSE
                EXIT(FALSE)
            END;
         END;
    END;

    LOCAL PROCEDURE UpdateInvestorAmounts@2("Investor No"@1002 : Code[20];"Interest Code"@1000 : Code[50];"Posting Date"@1006 : Date;Amount@1004 : Decimal;"Amount(LCY)"@1005 : Decimal);
    VAR
      InvestorAmounts@1001 : Record 51516440;
      InvestorAmounts2@1003 : Record 51516440;
    BEGIN
        InvestorAmounts.RESET;
        InvestorAmounts.SETRANGE(InvestorAmounts."Investor No","Investor No");
        InvestorAmounts.SETRANGE(InvestorAmounts."Interest Code","Interest Code");
        InvestorAmounts.SETRANGE(InvestorAmounts."Investment Date","Posting Date");
        IF InvestorAmounts.FINDFIRST=FALSE THEN BEGIN
          InvestorAmounts2.RESET;
          InvestorAmounts2."Investor No":="Investor No";
          InvestorAmounts2."Interest Code":="Interest Code";
          InvestorAmounts2."Investment Date":="Posting Date";
          InvestorAmounts2.Amount:=Amount;
          InvestorAmounts2."Amount(LCY)":="Amount(LCY)";
          InvestorAmounts2.Description:='Investor Topup,Interest Rate:'+FORMAT("Interest Code");
          InvestorAmounts2."Last Update Date":=TODAY;
          InvestorAmounts2."Last Update Time":=TIME;
          InvestorAmounts2."Last Update User":=USERID;
          InvestorAmounts2.INSERT;
        END ELSE BEGIN
          InvestorAmounts.Amount:=InvestorAmounts.Amount+Amount;
          InvestorAmounts."Amount(LCY)":=InvestorAmounts."Amount(LCY)"+"Amount(LCY)";
          InvestorAmounts."Last Update Date":=TODAY;
          InvestorAmounts."Last Update Time":=TIME;
          InvestorAmounts."Last Update User":=USERID;
          InvestorAmounts.MODIFY;
        END;
    END;

    LOCAL PROCEDURE InsertInvestorLedger@10(InvestorNo@1000 : Code[20];InterestCode@1001 : Code[20];Amount@1002 : Decimal;"Amount(LCY)"@1003 : Decimal;ReceiptNo@1004 : Code[20];PostingDate@1005 : Date);
    VAR
      InvestorLedger@1006 : Record 51516442;
    BEGIN
        InvestorLedger.RESET;
        InvestorLedger."Investor No":=InvestorNo;
        InvestorLedger."Principle Amount":=Amount;
        InvestorLedger."Principle Amount(LCY)":="Amount(LCY)";
        InvestorLedger.Date:=PostingDate;
        InvestorLedger.Day:=DATE2DMY(PostingDate,1);
        InvestorLedger.Month:=DATE2DMY(PostingDate,2);
        InvestorLedger.Year:=DATE2DMY(PostingDate,3);
        InvestorLedger."Receipt No":=ReceiptNo;
        InvestorLedger."Interest Rate":=InterestCode;
        InvestorLedger.INSERT;
    END;

    LOCAL PROCEDURE UpdateProperty@13(PropertyCode@1000 : Code[20];"Receipt No"@1001 : Code[20];"Customer No"@1002 : Code[20];"Customer Name"@1003 : Text[50];Amount@1005 : Decimal) : Boolean;
    VAR
      FA@1004 : Record 5600;
    BEGIN
       FA.RESET;
       FA.SETRANGE(FA."No.",PropertyCode);
       IF FA.FINDFIRST THEN BEGIN
        FA.Receipted:=TRUE;
        FA."Receipt No":="Receipt No";
        FA."Customer No":="Customer No";
        FA."Customer Name":="Customer Name";
        FA."Customer Balance":=FA."Customer Balance"-Amount;
        IF FA.MODIFY THEN BEGIN
          MESSAGE('Property Payment Successfull. Customer:'+FORMAT("Customer Name"));
          EXIT(TRUE);
        END ELSE BEGIN
          EXIT(FALSE);
        END;
       END;
    END;

    PROCEDURE CommitPurchase@1102755000(VAR PurchHeader@1102755000 : Record 38);
    VAR
      PurchLine@1102755013 : Record 39;
      Commitments@1102755012 : Record 51516050;
      Amount@1102755011 : Decimal;
      GLAcc@1102755010 : Record 15;
      Item@1102755009 : Record 27;
      FirstDay@1102755008 : Date;
      LastDay@1102755007 : Date;
      CurrMonth@1102755006 : Integer;
      Budget@1102755005 : Record 96;
      BudgetAmount@1102755004 : Decimal;
      Actuals@1102755003 : Record 365;
      ActualsAmount@1102755002 : Decimal;
      CommitmentAmount@1102755001 : Decimal;
      FixedAssetsDet@1102755014 : Record 5600;
      FAPostingGRP@1102755015 : Record 5606;
      EntryNo@1102755016 : Integer;
      GLAccount@1000000000 : Record 15;
      dimSetEntry@1000000001 : Record 480;
    BEGIN
      //First Update Analysis View
      //UpdateAnalysisView();

      //get the budget control setup first to determine if it mandatory or not
      {BCSetup.RESET;
      BCSetup.GET();
      IF BCSetup.Mandatory THEN//budgetary control is mandatory
        BEGIN
          //check if the dates are within the specified range in relation to the payment header table
          IF (PurchHeader."Document Date"< BCSetup."Current Budget Start Date") THEN
            BEGIN
              ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
            END
          ELSE IF (PurchHeader."Document Date">BCSetup."Current Budget End Date") THEN
            BEGIN
              ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

            END;
          //Is budget Available
          CheckIfBlocked(BCSetup."Current Budget Code");
          //Get Commitment Lines
               IF Commitments.FIND('+') THEN
              EntryNo:=Commitments."Line No.";

          //get the lines related to the payment header
            PurchLine.RESET;
            PurchLine.SETRANGE(PurchLine."Document Type",PurchHeader."Document Type");
            PurchLine.SETRANGE(PurchLine."Document No.",PurchHeader."No.");
            IF PurchLine.FINDFIRST THEN
              BEGIN
                REPEAT

               //Get the Dimension Here
                 IF PurchLine."Line No." <> 0 THEN
                      DimMgt.ShowDocDim(
                        DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Dimension Set ID",
                        PurchLine."Line No.",ShortcutDimCode)
                    ELSE
                     DimMgt.ShowTempDim(ShortcutDimCode);
               //Had to be put here for the sake of Calculating Individual Line Entries

                  //check the type of account in the payments line
                  //Item
                    IF PurchLine.Type=PurchLine.Type::Item THEN BEGIN
                        Item.RESET;
                        IF NOT Item.GET(PurchLine."No.") THEN
                           ERROR('Item Does not Exist');

                        Item.TESTFIELD("Item G/L Budget Account");
                        BudgetGL:=Item."Item G/L Budget Account";
                     END;
                    //  MESSAGE('FOUND');
                     IF PurchLine.Type=PurchLine.Type::"Fixed Asset" THEN BEGIN
                             FixedAssetsDet.RESET;
                             FixedAssetsDet.SETRANGE(FixedAssetsDet."No.",PurchLine."No.");
                               IF FixedAssetsDet.FIND('-') THEN BEGIN
                               FixedAssetsDet.CALCFIELDS(FixedAssetsDet."FA Posting Group");
                                   FAPostingGRP.RESET;
                                   FAPostingGRP.SETRANGE(FAPostingGRP.Code,FixedAssetsDet."FA Posting Group");
                                   IF FAPostingGRP.FIND('-') THEN
                                     IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::Maintenance THEN
                                      BEGIN
                                         BudgetGL:=FAPostingGRP."Maintenance Expense Account";
                                           IF BudgetGL ='' THEN
                                             ERROR('Ensure Fixed Asset No %1 has the Maintenance G/L Account',PurchLine."No.");
                                     END ELSE BEGIN
                                         BudgetGL:=FAPostingGRP."Acquisition Cost Account";
                                            IF BudgetGL ='' THEN
                                               ERROR('Ensure Fixed Asset No %1 has the Acquisition G/L Account',PurchLine."No.");
                                      END;
                               END;
                     END;

                     IF PurchLine.Type=PurchLine.Type::"G/L Account" THEN BEGIN
                        BudgetGL:=PurchLine."No.";
                        IF GLAcc.GET(PurchLine."No.") THEN
                           GLAcc.TESTFIELD(GLAcc."Budget Controlled",TRUE);
                     END;

                  //End Checking Account in Payment Line

                             //check the votebook now
                             FirstDay:=DMY2DATE(1,DATE2DMY(PurchHeader."Document Date",2),DATE2DMY(PurchHeader."Document Date",3));
                             CurrMonth:=DATE2DMY(PurchHeader."Document Date",2);
                             IF CurrMonth=12 THEN
                              BEGIN
                                LastDay:=DMY2DATE(1,1,DATE2DMY(PurchHeader."Document Date",3) +1);
                                LastDay:=CALCDATE('-1D',LastDay);
                              END
                             ELSE
                              BEGIN
                                CurrMonth:=CurrMonth +1;
                                LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(PurchHeader."Document Date",3));
                                LastDay:=CALCDATE('-1D',LastDay);
                              END;
                             //check the summation of the budget in the database
                             BudgetAmount:=0;
                             Budget.RESET;
                             Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                             Budget.SETFILTER(Budget.Date,'%1..%2',BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
                             Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                             Budget.SETRANGE(Budget."Global Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
                            // IF PurchHeader."Purchase Type"<>PurchHeader."Purchase Type"::"2" THEN
                             Budget.SETRANGE(Budget."Global Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                             Budget.SETRANGE(Budget."Budget Dimension 1 Code",ShortcutDimCode[3]);
                             Budget.SETRANGE(Budget."Budget Dimension 2 Code",ShortcutDimCode[4]);
                               IF Budget.FIND('-') THEN BEGIN
                               REPEAT
                                BudgetAmount:=BudgetAmount+Budget.Amount;
                               UNTIL Budget.NEXT=0;
                               END;

                                 {
                        //get the summation on the actuals
                          ActualsAmount:=0;
                          "G/L Entry".RESET;
                          "G/L Entry".SETRANGE("G/L Entry"."G/L Account No.",BudgetGL);
                          "G/L Entry".SETRANGE("G/L Entry"."Posting Date",BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
                          "G/L Entry".SETRANGE("G/L Entry"."Global Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
                          IF PurchHeader."Purchase Type"<>PurchHeader."Purchase Type"::"2" THEN
                          "G/L Entry".SETRANGE("G/L Entry"."Global Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                          IF "G/L Entry".FIND('-') THEN BEGIN
                          REPEAT
                          ActualsAmount:=ActualsAmount+"G/L Entry".Amount;
                          UNTIL "G/L Entry".NEXT=0;
                          END;
                         // error(format(ActualsAmount));
                                }

                        //get the summation on the actuals
                          ActualsAmount:=0;
                          Actuals.RESET;
                          Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                          Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                          Actuals."Posting Date",Actuals."Account No.");
                          Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                          Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                         // IF PurchHeader."Purchase Type"<>PurchHeader."Purchase Type"::Global THEN
                          Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                          Actuals.SETRANGE(Actuals."Dimension 3 Value Code",ShortcutDimCode[3]);
                          Actuals.SETRANGE(Actuals."Dimension 4 Value Code",ShortcutDimCode[4]);
                          Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                             Actuals.CALCSUMS(Actuals.Amount);
                             ActualsAmount:= Actuals.Amount;

                        //get the committments
                          CommitmentAmount:=0;
                          Commitments.RESET;
                          Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                          Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                          Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                          Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                          Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                          Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
      //                    IF PurchHeader."Purchase Type"<>PurchHeader."Purchase Type"::"2" THEN
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",ShortcutDimCode[3]);
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",ShortcutDimCode[4]);
                             Commitments.CALCSUMS(Commitments.Amount);
                             CommitmentAmount:= Commitments.Amount;
                         //check if there is any budget
                         IF (BudgetAmount<=0) THEN
                          BEGIN
                            ERROR('No Budget To Check Against');
                          END;

                         //check if the actuals plus the amount is greater then the budget amount
                         IF ((CommitmentAmount + PurchLine."Outstanding Amount (LCY)")>BudgetAmount) AND
                         (BCSetup."Allow OverExpenditure"=FALSE) THEN
                          BEGIN
                            ERROR('The Amount On Order No %1  %2 %3  Exceeds The Budget By %4',
                            PurchLine."Document No.",PurchLine.Type ,PurchLine."No.",
                              FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PurchLine."Outstanding Amount (LCY)"))));
                          END ELSE BEGIN
                              Commitments.RESET;
                              Commitments.INIT;
                              EntryNo+=1;
                              Commitments."Line No.":=EntryNo;
                              Commitments.Date:=TODAY;
                              Commitments."Posting Date":=PurchHeader."Document Date";
                              IF PurchHeader.DocApprovalType=PurchHeader.DocApprovalType::Purchase THEN
                                  Commitments."Document Type":=Commitments."Document Type"::LPO
                              ELSE
                                  Commitments."Document Type":=Commitments."Document Type"::Requisition;

                              IF PurchHeader."Document Type"=PurchHeader."Document Type"::Invoice THEN
                                  Commitments."Document Type":=Commitments."Document Type"::PurchInvoice;

                              Commitments."Document No.":=PurchHeader."No.";
                              Commitments.Amount:=PurchLine."Outstanding Amount (LCY)";
                              Commitments."Month Budget":=BudgetAmount;
                              Commitments."Month Actual":=ActualsAmount;
                              Commitments.Committed:=TRUE;
                              Commitments."Committed By":=USERID;
                              Commitments."Committed Date":=PurchHeader."Document Date";
                              Commitments."G/L Account No.":=BudgetGL;
                              Commitments."Committed Time":=TIME;
                              //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                              Commitments."Shortcut Dimension 1 Code":=PurchLine."Shortcut Dimension 1 Code";
                              Commitments."Shortcut Dimension 2 Code":=PurchLine."Shortcut Dimension 2 Code";
                              Commitments."Shortcut Dimension 3 Code":=ShortcutDimCode[3];
                              Commitments."Shortcut Dimension 4 Code":=ShortcutDimCode[4];
                              Commitments.Committed:=TRUE;
                              Commitments.Budget:=BCSetup."Current Budget Code";
                              Commitments.Type:=Commitments.Type::Vendor;
                              Commitments."Vendor/Cust No.":=PurchHeader."Buy-from Vendor No.";
                              Commitments.INSERT;
                              //Tag the Purchase Line as Committed
                                PurchLine.Committed:=TRUE;
                                PurchLine.MODIFY;
                              //End Tagging PurchLines as Committed
                          END;

                UNTIL PurchLine.NEXT=0;
              END;
        END
      ELSE//budget control not mandatory
        BEGIN

        END;
        {****III
      //  error(format(BudgetAmount));
      PurchHeader.RESET;
      PurchHeader.SETRANGE(PurchHeader."No.",PurchLine."Document No.");
      IF PurchHeader.FIND('-') THEN BEGIN
      PurchHeader."Budgeted Amount":=BudgetAmount;
      PurchHeader."Actual Expenditure":=ActualsAmount;
      PurchHeader."Committed Amount":=CommitmentAmount;
      PurchHeader."Budget Balance":=BudgetAmount-(ActualsAmount+CommitmentAmount+PurchHeader."Order Amount");
      PurchHeader.MODIFY;
      END;
                ********III}


      {****************************************************************
      //First Update Analysis View
      UpdateAnalysisView();

      //get the budget control setup first to determine if it mandatory or not
      BCSetup.RESET;
      BCSetup.GET();
      IF BCSetup.Mandatory THEN//budgetary control is mandatory
        BEGIN
          //check if the dates are within the specified range in relation to the payment header table
          IF (PurchHeader."Document Date"< BCSetup."Current Budget Start Date") THEN
            BEGIN
              ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
            END
          ELSE IF (PurchHeader."Document Date">BCSetup."Current Budget End Date") THEN
            BEGIN
              ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

            END;
          //Is budget Available
          CheckIfBlocked(BCSetup."Current Budget Code");
          //Get Commitment Lines
               IF Commitments.FIND('+') THEN
              EntryNo:=Commitments."Line No.";

          //get the lines related to the payment header
            PurchLine.RESET;
            PurchLine.SETRANGE(PurchLine."Document Type",PurchHeader."Document Type");
            PurchLine.SETRANGE(PurchLine."Document No.",PurchHeader."No.");
            IF PurchLine.FINDFIRST THEN
              BEGIN
                REPEAT

               //Get the Dimension Here
                 IF PurchLine."Line No." <> 0 THEN
                     DimMgt.GetShortcutDimensions(PurchLine."Dimension Set ID",ShortcutDimCode);

                  //    DimMgt.ShowDocDim(
                   //     DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",
                  //      PurchLine."Line No.",ShortcutDimCode)
                  //  ELSE
                  //    DimMgt.ClearDimSetFilter(ShortcutDimCode);
               //Had to be put here for the sake of Calculating Individual Line Entries

                  //check the type of account in the payments line
                //Item
                    IF PurchLine.Type=PurchLine.Type::Item THEN BEGIN
                        Item.RESET;
                        IF NOT Item.GET(PurchLine."No.") THEN
                           ERROR('Item Does not Exist');

                        Item.TESTFIELD("Item G/L Budget Account");
                        BudgetGL:=Item."Item G/L Budget Account";
                     END;

                     IF PurchLine.Type=PurchLine.Type::"Fixed Asset" THEN BEGIN
                             FixedAssetsDet.RESET;
                             FixedAssetsDet.SETRANGE(FixedAssetsDet."No.",PurchLine."No.");
                               IF FixedAssetsDet.FIND('-') THEN BEGIN
                                   FAPostingGRP.RESET;
                                   FAPostingGRP.SETRANGE(FAPostingGRP.Code,FixedAssetsDet."FA Posting Group");
                                   IF FAPostingGRP.FIND('-') THEN
                                     IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::Maintenance THEN
                                      BEGIN
                                         BudgetGL:=FAPostingGRP."Maintenance Expense Account";
                                           IF BudgetGL ='' THEN
                                             ERROR('Ensure Fixed Asset No %1 has the Maintenance G/L Account',PurchLine."No.");
                                     END ELSE BEGIN
                                       IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::"Acquisition Cost" THEN BEGIN
                                         BudgetGL:=FAPostingGRP."Acquisition Cost Account";
                                            IF BudgetGL ='' THEN
                                               ERROR('Ensure Fixed Asset No %1 has the Acquisition G/L Account',PurchLine."No.");
                                       END;
                                       //To Accomodate any Additional Item under Custom 1 and Custom 2
                                       IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::"Custom 1" THEN BEGIN
                                         BudgetGL:=FAPostingGRP."Custom 2 Account";
                                            IF BudgetGL ='' THEN
                                               ERROR('Ensure Fixed Asset No %1 has the %2 G/L Account',PurchLine."No.",
                                               FAPostingGRP."Custom 1 Account");
                                       END;

                                       IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::"Custom 2" THEN BEGIN
                                         BudgetGL:=FAPostingGRP."Custom 2 Account";
                                            IF BudgetGL ='' THEN
                                               ERROR('Ensure Fixed Asset No %1 has the %2 G/L Account',PurchLine."No.",
                                               FAPostingGRP."Custom 1 Account");
                                       END;
                                       //To Accomodate any Additional Item under Custom 1 and Custom 2

                                      END;
                               END;
                     END;

                     IF PurchLine.Type=PurchLine.Type::"G/L Account" THEN BEGIN
                        BudgetGL:=PurchLine."No.";
                        IF GLAcc.GET(PurchLine."No.") THEN
                           GLAcc.TESTFIELD("Budget Controlled",TRUE);
                     END;

                  //End Checking Account in Payment Line

                             //check the votebook now
                             FirstDay:=DMY2DATE(1,DATE2DMY(PurchHeader."Document Date",2),DATE2DMY(PurchHeader."Document Date",3));
                             CurrMonth:=DATE2DMY(PurchHeader."Document Date",2);
                             IF CurrMonth=12 THEN
                              BEGIN
                                LastDay:=DMY2DATE(1,1,DATE2DMY(PurchHeader."Document Date",3) +1);
                                LastDay:=CALCDATE('-1D',LastDay);
                              END
                             ELSE
                              BEGIN
                                CurrMonth:=CurrMonth +1;
                                LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(PurchHeader."Document Date",3));
                                LastDay:=CALCDATE('-1D',LastDay);
                              END;

                            //--ADDED Denno for AMPATH Projects obligated---------------------------------
                            objJobs.RESET;
                            objJobs.SETRANGE(objJobs."No.",PurchHeader."Shortcut Dimension 2 Code");
                            IF objJobs.FIND('-') THEN BEGIN
                             BudgetAmount:=0;
                             IF objJobs."Obligated Amount">0 THEN BudgetAmount:=objJobs."Obligated Amount";

                            END ELSE BEGIN
                             //---------------------------------------------------------------------------

                             //check the summation of the budget in the database
                             BudgetAmount:=0;
                             Budget.RESET;
                             Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                             Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                             Budget."Dimension 4 Value Code");
                             Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                             Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                             Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                             Budget.SETRANGE(Budget."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                             Budget.SETRANGE(Budget."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                             Budget.SETRANGE(Budget."Dimension 3 Value Code",ShortcutDimCode[3]);
                             Budget.SETRANGE(Budget."Dimension 4 Value Code",ShortcutDimCode[4]);
                                 Budget.CALCSUMS(Budget.Amount);
                                 BudgetAmount:= Budget.Amount;

                          END; // Denno  Added--------------------------------

                        //get the summation on the actuals
                          ActualsAmount:=0;
                          Actuals.RESET;
                          Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                          Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                          Actuals."Posting Date",Actuals."G/L Account No.");
                          Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                          Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                          Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                          Actuals.SETRANGE(Actuals."Dimension 3 Value Code",ShortcutDimCode[3]);
                          Actuals.SETRANGE(Actuals."Dimension 4 Value Code",ShortcutDimCode[4]);
                          Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Actuals.SETRANGE(Actuals."G/L Account No.",BudgetGL);
                             Actuals.CALCSUMS(Actuals.Amount);
                             ActualsAmount:= Actuals.Amount;

                        //get the committments
                          CommitmentAmount:=0;
                          Commitments.RESET;
                          Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                          Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                          Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                          Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                          Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                          Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",ShortcutDimCode[3]);
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",ShortcutDimCode[4]);
                             Commitments.CALCSUMS(Commitments.Amount);
                             CommitmentAmount:= Commitments.Amount;

                         //check if there is any budget
                         IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('No Budget To Check Against');
                         END ELSE BEGIN
                          IF (BudgetAmount<=0) THEN BEGIN
                           IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                              ERROR('Budgetary Checking Process Aborted');
                           END;
                          END;
                         END;

                         //check if the actuals plus the amount is greater then the budget amount
                         IF ((CommitmentAmount + PurchLine."Outstanding Amount (LCY)")+ ActualsAmount>BudgetAmount)
                         AND NOT (BCSetup."Allow OverExpenditure") THEN
                          BEGIN
                            ERROR('The Amount On Order No %1  %2 %3  Exceeds The Budget By %4',
                            PurchLine."Document No.",PurchLine.Type ,PurchLine."No.",
                              FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PurchLine."Outstanding Amount (LCY)"))));
                          END ELSE BEGIN
                              //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                              IF ((CommitmentAmount + PurchLine."Outstanding Amount (LCY)")+ ActualsAmount>BudgetAmount) THEN BEGIN
                                  IF NOT CONFIRM(Text0001+
                                  FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PurchLine."Outstanding Amount (LCY)")))
                                  +Text0002,TRUE) THEN BEGIN
                                     ERROR('Budgetary Checking Process Aborted');
                                  END;
                              END;
                              //END ADDING CONFIRMATION
                              Commitments.RESET;
                              Commitments.INIT;
                              EntryNo+=1;
                              Commitments."Line No.":=EntryNo;
                              Commitments.Date:=TODAY;
                              Commitments."Posting Date":=PurchHeader."Document Date";
                              IF PurchHeader.DocApprovalType=PurchHeader.DocApprovalType::Purchase THEN
                                  Commitments."Document Type":=Commitments."Document Type"::LPO
                              ELSE
                                  Commitments."Document Type":=Commitments."Document Type"::Requisition;

                              IF PurchHeader."Document Type"=PurchHeader."Document Type"::Invoice THEN
                                  Commitments."Document Type":=Commitments."Document Type"::PurchInvoice;

                              Commitments."Document No.":=PurchHeader."No.";
                              Commitments.Amount:=PurchLine."Outstanding Amount (LCY)";
                              Commitments."Month Budget":=BudgetAmount;
                              Commitments."Month Actual":=ActualsAmount;
                              Commitments.Committed:=TRUE;
                              Commitments."Committed By":=USERID;
                              Commitments."Committed Date":=PurchHeader."Document Date";
                              Commitments."G/L Account No.":=BudgetGL;
                              Commitments."Committed Time":=TIME;
      //                        Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                              Commitments."Shortcut Dimension 1 Code":=PurchLine."Shortcut Dimension 1 Code";
                              Commitments."Shortcut Dimension 2 Code":=PurchLine."Shortcut Dimension 2 Code";
                              Commitments."Shortcut Dimension 3 Code":=ShortcutDimCode[3];
                              Commitments."Shortcut Dimension 4 Code":=ShortcutDimCode[4];
                              Commitments.Budget:=BCSetup."Current Budget Code";
                              Commitments.Type:=Commitments.Type::Vendor;
                              Commitments."Vendor/Cust No.":=PurchHeader."Buy-from Vendor No.";
                              Commitments.INSERT;
                              //Tag the Purchase Line as Committed
                                PurchLine.Committed:=TRUE;
                                PurchLine.MODIFY;
                              //End Tagging PurchLines as Committed
                          END;
                UNTIL PurchLine.NEXT=0;
              END;
        END
      ELSE//budget control not mandatory
        BEGIN

        END;
      *******************************************************************}
        }
    END;

    PROCEDURE CommitPayments@1102755001(VAR PaymentHeader@1102755000 : Record 51516000);
    VAR
      PayLine@1102755013 : Record 51516001;
      Commitments@1102755012 : Record 51516050;
      Amount@1102755011 : Decimal;
      GLAcc@1102755010 : Record 15;
      Item@1102755009 : Record 27;
      FirstDay@1102755008 : Date;
      LastDay@1102755007 : Date;
      CurrMonth@1102755006 : Integer;
      Budget@1102755005 : Record 366;
      BudgetAmount@1102755004 : Decimal;
      Actuals@1102755003 : Record 365;
      ActualsAmount@1102755002 : Decimal;
      CommitmentAmount@1102755001 : Decimal;
      FixedAssetsDet@1102755014 : Record 5600;
      FAPostingGRP@1102755015 : Record 5606;
      EntryNo@1102755016 : Integer;
    BEGIN

      //First Update Analysis View
      {UpdateAnalysisView();

      //get the budget control setup first to determine if it mandatory or not
      BCSetup.RESET;
      BCSetup.GET();
      IF BCSetup.Mandatory THEN//budgetary control is mandatory
        BEGIN
          //check if the dates are within the specified range in relation to the payment header table
          IF (PaymentHeader.Date< BCSetup."Current Budget Start Date") THEN
            BEGIN
              ERROR('The Current Date %1 In The Payment Voucher Does Not Fall Within Budget Dates %2 - %3',PaymentHeader.Date,
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
            END
          ELSE IF (PaymentHeader.Date>BCSetup."Current Budget End Date") THEN
            BEGIN
              ERROR('The Current Date %1 In The Payment Voucher Does Not Fall Within Budget Dates %2 - %3',PaymentHeader.Date,
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
            END;
          //Is budget Available
          CheckIfBlocked(BCSetup."Current Budget Code");


          //Get Commitment Lines
           IF Commitments.FIND('+') THEN
              EntryNo:=Commitments."Line No.";

          //get the lines related to the payment header
            PayLine.RESET;
            PayLine.SETRANGE(PayLine.No,PaymentHeader."No.");
            PayLine.SETRANGE(PayLine."Account Type",PayLine."Account Type"::"G/L Account");
            //PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
            IF PayLine.FINDFIRST THEN
              BEGIN
                REPEAT
                             //check the votebook now
                             FirstDay:=DMY2DATE(1,DATE2DMY(PaymentHeader.Date,2),DATE2DMY(PaymentHeader.Date,3));
                             CurrMonth:=DATE2DMY(PaymentHeader.Date,2);
                             IF CurrMonth=12 THEN
                              BEGIN
                                LastDay:=DMY2DATE(1,1,DATE2DMY(PaymentHeader.Date,3) +1);
                                LastDay:=CALCDATE('-1D',LastDay);
                              END
                             ELSE
                              BEGIN
                                CurrMonth:=CurrMonth +1;
                                LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(PaymentHeader.Date,3));
                                LastDay:=CALCDATE('-1D',LastDay);
                              END;

                             BudgetGL:=PayLine."Account No.";
                             //check the summation of the budget in the database
                             BudgetAmount:=0;
                             Budget.RESET;
                             Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                             Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                             Budget."Dimension 4 Value Code");
                             Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                             Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
                             Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                            { Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                             Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                             Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                             Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code"); }
                                 Budget.CALCSUMS(Budget.Amount);
                                 BudgetAmount:= Budget.Amount;
                             MESSAGE(FORMAT(BudgetAmount));
                        //get the summation on the actuals
                          ActualsAmount:=0;
                          Actuals.RESET;
                          Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                          Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                          Actuals."Posting Date",Actuals."Account No.");
                          Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                          Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                          Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                          //Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                          //Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                          Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                             Actuals.CALCSUMS(Actuals.Amount);
                             ActualsAmount:= Actuals.Amount;

                        //get the committments
                          CommitmentAmount:=0;
                          Commitments.RESET;
                          Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                          Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                          Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                          Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                          Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                          Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                             Commitments.CALCSUMS(Commitments.Amount);
                             CommitmentAmount:= Commitments.Amount;

                         //check if there is any budget
                         IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('No Budget To Check Against');
                         END ELSE BEGIN
                          IF (BudgetAmount<=0) THEN BEGIN
                           IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                              ERROR('Budgetary Checking Process Aborted');
                           END;
                          END;
                         END;

                         //check if the actuals plus the amount is greater then the budget amount
                         IF ((CommitmentAmount + PayLine."NetAmount LCY"+ActualsAmount)>BudgetAmount )
                         AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                            PayLine.No,PayLine.Type ,PayLine.No,
                              FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."NetAmount LCY"))));
                          END ELSE BEGIN
                          //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                              IF ((CommitmentAmount + PayLine."NetAmount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                  IF NOT CONFIRM(Text0001+
                                  FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."NetAmount LCY")))
                                  +Text0002,TRUE) THEN BEGIN
                                     ERROR('Budgetary Checking Process Aborted');
                                  END;
                              END;

                              Commitments.RESET;
                              Commitments.INIT;
                              EntryNo+=1;
                              Commitments."Line No.":=EntryNo;
                              Commitments.Date:=TODAY;
                              Commitments."Posting Date":=PaymentHeader.Date;
                              IF PaymentHeader."Payment Type"=PaymentHeader."Payment Type"::Normal THEN
                               Commitments."Document Type":=Commitments."Document Type"::"Payment Voucher"
                              ELSE
                                Commitments."Document Type":=Commitments."Document Type"::PettyCash;
                              Commitments."Document No.":=PaymentHeader."No.";
                              Commitments.Amount:=PayLine."NetAmount LCY";
                              Commitments."Month Budget":=BudgetAmount;
                              Commitments."Month Actual":=ActualsAmount;
                              Commitments.Committed:=TRUE;
                              Commitments."Committed By":=USERID;
                              Commitments."Committed Date":=PaymentHeader.Date;
                              Commitments."G/L Account No.":=BudgetGL;
                              Commitments."Committed Time":=TIME;
      //                        Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                              Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                              Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                              Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                              Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                              Commitments.Budget:=BCSetup."Current Budget Code";
                              Commitments.INSERT;
                             // MESSAGE('Done');
                              //Tag the Payment Line as Committed
                                PayLine.Committed:=TRUE;
                                PayLine.MODIFY;
                              //End Tagging Payment Lines as Committed
                          END;

                UNTIL PayLine.NEXT=0;
              END;
        END
      ELSE//budget control not mandatory
        BEGIN

        END;
      MESSAGE('Budgetary Checking Completed Successfully');
       }
    END;

    PROCEDURE CommitImprest@1102755002(VAR ImprestHeader@1102755000 : Record 51516006);
    VAR
      PayLine@1102755013 : Record 51516007;
      Commitments@1102755012 : Record 51516050;
      Amount@1102755011 : Decimal;
      GLAcc@1102755010 : Record 15;
      Item@1102755009 : Record 27;
      FirstDay@1102755008 : Date;
      LastDay@1102755007 : Date;
      CurrMonth@1102755006 : Integer;
      Budget@1102755005 : Record 366;
      BudgetAmount@1102755004 : Decimal;
      Actuals@1102755003 : Record 365;
      ActualsAmount@1102755002 : Decimal;
      CommitmentAmount@1102755001 : Decimal;
      FixedAssetsDet@1102755014 : Record 5600;
      FAPostingGRP@1102755015 : Record 5606;
      EntryNo@1102755016 : Integer;
    BEGIN
      //First Update Analysis View
      {UpdateAnalysisView();

      //get the budget control setup first to determine if it mandatory or not
      BCSetup.RESET;
      BCSetup.GET();
      IF BCSetup.Mandatory THEN//budgetary control is mandatory
        BEGIN
          //check if the dates are within the specified range in relation to the payment header table
          IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
            BEGIN
              ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
            END
          ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
            BEGIN
              ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

            END;
          //Is budget Available
          CheckIfBlocked(BCSetup."Current Budget Code");

          //Get Commitment Lines
           IF Commitments.FIND('+') THEN
              EntryNo:=Commitments."Line No.";

          //get the lines related to the payment header
            PayLine.RESET;
            PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
            PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
            IF PayLine.FINDFIRST THEN
              BEGIN
                REPEAT
                             //check the votebook now
                             FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
                             CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
                             IF CurrMonth=12 THEN
                              BEGIN
                                LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
                                LastDay:=CALCDATE('-1D',LastDay);
                              END
                             ELSE
                              BEGIN
                                CurrMonth:=CurrMonth +1;
                                LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
                                LastDay:=CALCDATE('-1D',LastDay);
                              END;

                             //The GL Account
                              BudgetGL:=PayLine."Account No:";

                             //check the summation of the budget in the database
                             BudgetAmount:=0;
                             Budget.RESET;
                             Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                             Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                             Budget."Dimension 4 Value Code");
                             Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                             Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                             Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                             Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                             Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                             Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                             Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                             IF Budget.FIND('-') THEN BEGIN
                                 Budget.CALCSUMS(Budget.Amount);
                                 BudgetAmount:= Budget.Amount;
                             END;

                        //get the summation on the actuals
                          ActualsAmount:=0;
                          Actuals.RESET;
                          Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                          Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                          Actuals."Posting Date",Actuals."Account No.");
                          Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                          Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                          Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                          Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                          Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                          Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                             Actuals.CALCSUMS(Actuals.Amount);
                             ActualsAmount:= Actuals.Amount;

                        //get the committments
                          CommitmentAmount:=0;
                          Commitments.RESET;
                          Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                          Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                          Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                          Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                          Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                          Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                             Commitments.CALCSUMS(Commitments.Amount);
                             CommitmentAmount:= Commitments.Amount;

                         //check if there is any budget
                         IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('No Budget To Check Against');
                         END ELSE BEGIN
                          IF (BudgetAmount<=0) THEN BEGIN
                           IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                              ERROR('Budgetary Checking Process Aborted');
                           END;
                          END;
                         END;

                         //check if the actuals plus the amount is greater then the budget amount
                         IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                         AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                            PayLine.No,'Staff Imprest' ,PayLine.No,
                              FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                          END ELSE BEGIN
                          //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                              IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                  IF NOT CONFIRM(Text0001+
                                  FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                  +Text0002,TRUE) THEN BEGIN
                                     ERROR('Budgetary Checking Process Aborted');
                                  END;
                              END;

                              Commitments.RESET;
                              Commitments.INIT;
                              EntryNo+=1;
                              Commitments."Line No.":=EntryNo;
                              Commitments.Date:=TODAY;
                              Commitments."Posting Date":=ImprestHeader.Date;
                              Commitments."Document Type":=Commitments."Document Type"::Imprest;
                              Commitments."Document No.":=ImprestHeader."No.";
                              Commitments.Amount:=PayLine."Amount LCY";
                              Commitments."Month Budget":=BudgetAmount;
                              Commitments."Month Actual":=ActualsAmount;
                              Commitments.Committed:=TRUE;
                              Commitments."Committed By":=USERID;
                              Commitments."Committed Date":=ImprestHeader.Date;
                              Commitments."G/L Account No.":=BudgetGL;
                              Commitments."Committed Time":=TIME;
      //                        Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                              Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                              Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                              Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                              Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                              Commitments.Budget:=BCSetup."Current Budget Code";
                              Commitments.Type:=ImprestHeader."Account Type";
                              Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
                              Commitments.INSERT;
                              //Tag the Imprest Line as Committed
                                PayLine.Committed:=TRUE;
                                PayLine.MODIFY;
                              //End Tagging Imprest Lines as Committed
                          END;

                UNTIL PayLine.NEXT=0;
              END;
        END
      ELSE//budget control not mandatory
        BEGIN

        END;
      MESSAGE('Budgetary Checking Completed Successfully');
        }
    END;

    PROCEDURE ReverseEntries@1102755003(DocumentType@1102755000 : 'LPO,Requisition,Imprest,Payment Voucher,PettyCash,PurchInvoice,StaffClaim,StaffAdvance';DocNo@1102755001 : Code[20]);
    VAR
      Commitments@1102755002 : Record 51516050;
      EntryNo@1102755003 : Integer;
      CommittedLines@1102755004 : Record 51516050;
    BEGIN
      //Get Commitment Lines
      {Commitments.RESET;
       IF Commitments.FIND('+') THEN
          EntryNo:=Commitments."Line No.";

      CommittedLines.RESET;
      CommittedLines.SETRANGE(CommittedLines."Document Type",DocumentType);
      CommittedLines.SETRANGE(CommittedLines."Document No.",DocNo);
      CommittedLines.SETRANGE(CommittedLines.Committed,TRUE);
      IF CommittedLines.FIND('-') THEN BEGIN
         REPEAT
           Commitments.RESET;
           Commitments.INIT;
           EntryNo+=1;
           Commitments."Line No.":=EntryNo;
           Commitments.Date:=TODAY;
           Commitments."Posting Date":=CommittedLines."Posting Date";
           Commitments."Document Type":=CommittedLines."Document Type";
           Commitments."Document No.":=CommittedLines."Document No.";
           Commitments.Amount:=-CommittedLines.Amount;
           Commitments."Month Budget":=CommittedLines."Month Budget";
           Commitments."Month Actual":=CommittedLines."Month Actual";
           Commitments.Committed:=FALSE;
           Commitments."Committed By":=USERID;
           Commitments."Committed Date":=CommittedLines."Committed Date";
           Commitments."G/L Account No.":=CommittedLines."G/L Account No.";
           Commitments."Committed Time":=TIME;
      //     Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
           Commitments."Shortcut Dimension 1 Code":= CommittedLines."Shortcut Dimension 1 Code";
           Commitments."Shortcut Dimension 2 Code":=CommittedLines."Shortcut Dimension 2 Code";
           Commitments."Shortcut Dimension 3 Code":=CommittedLines."Shortcut Dimension 3 Code";
           Commitments."Shortcut Dimension 4 Code":=CommittedLines."Shortcut Dimension 4 Code";
           Commitments.Budget:=CommittedLines.Budget;
           Commitments.INSERT;

         UNTIL CommittedLines.NEXT=0;
      END;
      }
    END;

    PROCEDURE CommitFundsAvailability@1102755004(Payments@1102755000 : Record 51516000);
    VAR
      BankAcc@1102755001 : Record 270;
      "Current Source A/C Bal."@1102755002 : Decimal;
    BEGIN
      //get the source account balance from the database table
      {Payments.CALCFIELDS(Payments."Total Net Amount");
      BankAcc.RESET;
      BankAcc.SETRANGE(BankAcc."No.",Payments."Paying Bank Account");
      BankAcc.SETRANGE(BankAcc."Bank Type",BankAcc."Bank Type"::Cash);
      IF BankAcc.FINDFIRST THEN
        BEGIN
          BankAcc.CALCFIELDS(BankAcc.Balance);
          "Current Source A/C Bal.":=BankAcc.Balance;
          IF ("Current Source A/C Bal."-Payments."Total Net Amount")<0 THEN
            BEGIN
              ERROR('The transaction will result in a negative balance in the BANK ACCOUNT. %1:%2',BankAcc."No.",
              BankAcc.Name);
            END;
        END;
      }
    END;

    PROCEDURE UpdateAnalysisView@1102755005();
    VAR
      UpdateAnalysisView@1102755002 : Codeunit 410;
      BudgetaryControl@1102755001 : Record 51516051;
      AnalysisView@1102755000 : Record 363;
    BEGIN
      {//Update Budget Lines
      IF BudgetaryControl.GET THEN BEGIN
        IF BudgetaryControl."Analysis View Code"<>'' THEN BEGIN
         AnalysisView.RESET;
         AnalysisView.SETRANGE(AnalysisView.Code,BudgetaryControl."Analysis View Code");
         IF AnalysisView.FIND('-') THEN
           UpdateAnalysisView.UpdateAnalysisView_Budget(AnalysisView);
        END;
      END;  }

      //Update Budget Lines
      {IF BudgetaryControl.GET THEN BEGIN
        IF BudgetaryControl."Actual Source"=BudgetaryControl."Actual Source"::"Analysis View Entry" THEN BEGIN
           IF BudgetaryControl."Analysis View Code"='' THEN
              ERROR('The Analysis view code can not be blank in the budgetary control setup');
        END;
        IF BudgetaryControl."Analysis View Code"<>''  THEN BEGIN
         AnalysisView.RESET;
         AnalysisView.SETRANGE(AnalysisView.Code,BudgetaryControl."Analysis View Code");
         IF AnalysisView.FIND('-') THEN
           UpdateAnalysisView.UpdateAnalysisView_Budget(AnalysisView);
        END;
      END; }
    END;

    PROCEDURE UpdateDim@14(DimCode@1000 : Code[20];DimValueCode@1001 : Code[20]);
    VAR
      GLBudgetDim@1002 : Integer;
    BEGIN
      //In 2013 this is not applicable table 361 not supported
      {IF DimCode = '' THEN
        EXIT;
      WITH GLBudgetDim DO BEGIN
        IF GET(Rec."Entry No.",DimCode) THEN
          DELETE;
        IF DimValueCode <> '' THEN BEGIN
          INIT;
          "Entry No." := Rec."Entry No.";
          "Dimension Code" := DimCode;
          "Dimension Value Code" := DimValueCode;
          INSERT;
        END;
      END; }
    END;

    PROCEDURE CheckIfBlocked@12(BudgetName@1102755001 : Code[20]);
    VAR
      GLBudgetName@1102755000 : Record 95;
    BEGIN
      GLBudgetName.GET(BudgetName);
      GLBudgetName.TESTFIELD(Blocked,FALSE);
    END;

    PROCEDURE CommitStaffClaim@1102755006(VAR ImprestHeader@1102755000 : Record 51516006);
    VAR
      PayLine@1102755013 : Record 51516007;
      Commitments@1102755012 : Record 51516050;
      Amount@1102755011 : Decimal;
      GLAcc@1102755010 : Record 15;
      Item@1102755009 : Record 27;
      FirstDay@1102755008 : Date;
      LastDay@1102755007 : Date;
      CurrMonth@1102755006 : Integer;
      Budget@1102755005 : Record 366;
      BudgetAmount@1102755004 : Decimal;
      Actuals@1102755003 : Record 365;
      ActualsAmount@1102755002 : Decimal;
      CommitmentAmount@1102755001 : Decimal;
      FixedAssetsDet@1102755014 : Record 5600;
      FAPostingGRP@1102755015 : Record 5606;
      EntryNo@1102755016 : Integer;
      GLAccount@1000000000 : Record 15;
    BEGIN
       {
      UpdateAnalysisView();

      //get the budget control setup first to determine if it mandatory or not
      BCSetup.RESET;
      BCSetup.GET();
      IF BCSetup.Mandatory THEN//budgetary control is mandatory
        BEGIN
          //check if the dates are within the specified range in relation to the payment header table
          IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
            BEGIN
              ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
            END
          ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
            BEGIN
              ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

            END;
          //Is budget Available
          CheckIfBlocked(BCSetup."Current Budget Code");

          //Get Commitment Lines
           IF Commitments.FIND('+') THEN
              EntryNo:=Commitments."Line No.";

          //get the lines related to the payment header
            PayLine.RESET;
            PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
            PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
            IF PayLine.FINDFIRST THEN
              BEGIN
                REPEAT
                             //check the votebook now
                             FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
                             CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
                             IF CurrMonth=12 THEN
                              BEGIN
                                LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
                                LastDay:=CALCDATE('-1D',LastDay);
                              END
                             ELSE
                              BEGIN
                                CurrMonth:=CurrMonth +1;
                                LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
                                LastDay:=CALCDATE('-1D',LastDay);
                              END;

                             //If Budget is annual then change the Last day
                             IF BCSetup."Budget Check Criteria"=BCSetup."Budget Check Criteria"::"Whole Year" THEN
                                 LastDay:=BCSetup."Current Budget End Date";

                             //The GL Account
                              BudgetGL:=PayLine."Account No:";

                             //check the summation of the budget in the database
                             BudgetAmount:=0;
                             Budget.RESET;
                             Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                             Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                             Budget."Dimension 4 Value Code");
                             Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                             Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                             Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                             Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                             Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                             Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                             Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                 Budget.CALCSUMS(Budget.Amount);
                                 BudgetAmount:= Budget.Amount;

                        //get the summation on the actuals
                        //Separate Analysis View and G/L Entry
                          IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                          ActualsAmount:=0;
                          Actuals.RESET;
                          Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                          Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                          Actuals."Posting Date",Actuals."Account No.");
                          Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                          Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                          Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                          Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                          Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                          Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                             Actuals.CALCSUMS(Actuals.Amount);
                             ActualsAmount:= Actuals.Amount;
                          END ELSE BEGIN
                              GLAccount.RESET;
                              GLAccount.SETRANGE(GLAccount."No.",BudgetGL);
                              GLAccount.SETRANGE(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                              IF PayLine."Global Dimension 1 Code" <> '' THEN
                                GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter",PayLine."Global Dimension 1 Code");
                              IF PayLine."Shortcut Dimension 2 Code" <> '' THEN
                                GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter",PayLine."Shortcut Dimension 2 Code");
                              IF GLAccount.FIND('-') THEN BEGIN
                               GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                               ActualsAmount:=GLAccount."Net Change";
                              END;
                          END;
                        //get the committments
                          CommitmentAmount:=0;
                          Commitments.RESET;
                          Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                          Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                          Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                          Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                          Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                          Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                             Commitments.CALCSUMS(Commitments.Amount);
                             CommitmentAmount:= Commitments.Amount;

                         //check if there is any budget
                         IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('No Budget To Check Against');
                         END ELSE BEGIN
                          IF (BudgetAmount<=0) THEN BEGIN
                           IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                              ERROR('Budgetary Checking Process Aborted');
                           END;
                          END;
                         END;

                         //check if the actuals plus the amount is greater then the budget amount
                         IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                         AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                            PayLine.No,'Staff Imprest' ,PayLine.No,
                              FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                          END ELSE BEGIN
                          //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                              IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                  IF NOT CONFIRM(Text0001+
                                  FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                  +Text0002,TRUE) THEN BEGIN
                                     ERROR('Budgetary Checking Process Aborted');
                                  END;
                              END;

                              Commitments.RESET;
                              Commitments.INIT;
                              EntryNo+=1;
                              Commitments."Line No.":=EntryNo;
                              Commitments.Date:=TODAY;
                              Commitments."Posting Date":=ImprestHeader.Date;
                              Commitments."Document Type":=Commitments."Document Type"::StaffAdvance;
                              Commitments."Document No.":=ImprestHeader."No.";
                              Commitments.Amount:=PayLine."Amount LCY";
                              Commitments."Month Budget":=BudgetAmount;
                              Commitments."Month Actual":=ActualsAmount;
                              Commitments.Committed:=TRUE;
                              Commitments."Committed By":=USERID;
                              Commitments."Committed Date":=ImprestHeader.Date;
                              Commitments."G/L Account No.":=BudgetGL;
                              Commitments."Committed Time":=TIME;
                             // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                              Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                              Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                              Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                              Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                              Commitments.Budget:=BCSetup."Current Budget Code";
                              Commitments.Type:=ImprestHeader."Account Type";
                              Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
      //                        Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
      //                        Commitments."Actual Source":=BCSetup."Actual Source";
                              Commitments.INSERT;
                              //Tag the Imprest Line as Committed
                                PayLine.Committed:=TRUE;
                                PayLine.MODIFY;
                              //End Tagging Imprest Lines as Committed
                          END;

                UNTIL PayLine.NEXT=0;
              END;
        END
      ELSE//budget control not mandatory
        BEGIN

        END;
      MESSAGE('Budgetary Checking Completed Successfully');






      {*********************************************************
      //First Update Analysis View
      UpdateAnalysisView();

      //get the budget control setup first to determine if it mandatory or not
      BCSetup.RESET;
      BCSetup.GET();
      IF BCSetup.Mandatory THEN//budgetary control is mandatory
        BEGIN
          //check if the dates are within the specified range in relation to the payment header table
          IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
            BEGIN
              ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
            END
          ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
            BEGIN
              ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

            END;
          //Is budget Available
          CheckIfBlocked(BCSetup."Current Budget Code");

          //Get Commitment Lines
           IF Commitments.FIND('+') THEN
              EntryNo:=Commitments."Line No.";

          //get the lines related to the payment header
            PayLine.RESET;
            PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
            PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
            IF PayLine.FINDFIRST THEN
              BEGIN
                REPEAT
                             //check the votebook now
                             FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
                             CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
                             IF CurrMonth=12 THEN
                              BEGIN
                                LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
                                LastDay:=CALCDATE('-1D',LastDay);
                              END
                             ELSE
                              BEGIN
                                CurrMonth:=CurrMonth +1;
                                LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
                                LastDay:=CALCDATE('-1D',LastDay);
                              END;

                             //The GL Account
                              BudgetGL:=PayLine."Account No:";

                             //check the summation of the budget in the database
                             BudgetAmount:=0;
                             Budget.RESET;
                             Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                             Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                             Budget."Dimension 4 Value Code");
                             Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                             Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                             Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                             Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                             Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                             Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                             Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                 Budget.CALCSUMS(Budget.Amount);
                                 BudgetAmount:= Budget.Amount;

                        //get the summation on the actuals
                          ActualsAmount:=0;
                          Actuals.RESET;
                          Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                          Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                          Actuals."Posting Date",Actuals."G/L Account No.");
                          Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                          Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                          Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                          Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                          Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                          Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Actuals.SETRANGE(Actuals."G/L Account No.",BudgetGL);
                             Actuals.CALCSUMS(Actuals.Amount);
                             ActualsAmount:= Actuals.Amount;

                        //get the committments
                          CommitmentAmount:=0;
                          Commitments.RESET;
                          Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                          Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                          Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                          Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                          Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                          Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                             Commitments.CALCSUMS(Commitments.Amount);
                             CommitmentAmount:= Commitments.Amount;

                         //check if there is any budget
                         IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('No Budget To Check Against');
                         END ELSE BEGIN
                          IF (BudgetAmount<=0) THEN BEGIN
                           IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                              ERROR('Budgetary Checking Process Aborted');
                           END;
                          END;
                         END;

                         //check if the actuals plus the amount is greater then the budget amount
                         IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                         AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                            PayLine.No,'Staff Imprest' ,PayLine.No,
                              FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                          END ELSE BEGIN
                          //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                              IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                  IF NOT CONFIRM(Text0001+
                                  FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                  +Text0002,TRUE) THEN BEGIN
                                     ERROR('Budgetary Checking Process Aborted');
                                  END;
                              END;

                              Commitments.RESET;
                              Commitments.INIT;
                              EntryNo+=1;
                              Commitments."Line No.":=EntryNo;
                              Commitments.Date:=TODAY;
                              Commitments."Posting Date":=ImprestHeader.Date;
                              Commitments."Document Type":=Commitments."Document Type"::StaffClaim;
                              Commitments."Document No.":=ImprestHeader."No.";
                              Commitments.Amount:=PayLine."Amount LCY";
                              Commitments."Month Budget":=BudgetAmount;
                              Commitments."Month Actual":=ActualsAmount;
                              Commitments.Committed:=TRUE;
                              Commitments."Committed By":=USERID;
                              Commitments."Committed Date":=ImprestHeader.Date;
                              Commitments."G/L Account No.":=BudgetGL;
                              Commitments."Committed Time":=TIME;
      //                        Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                              Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                              Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                              Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                              Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                              Commitments.Budget:=BCSetup."Current Budget Code";
                              Commitments.Type:=ImprestHeader."Account Type";
                              Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
                              Commitments.INSERT;
                              //Tag the Imprest Line as Committed
                                PayLine.Committed:=TRUE;
                                PayLine.MODIFY;
                              //End Tagging Imprest Lines as Committed
                          END;

                UNTIL PayLine.NEXT=0;
              END;
        END
      ELSE//budget control not mandatory
        BEGIN

        END;
      MESSAGE('Budgetary Checking Completed Successfully');
      ***************************************}
       }
    END;

    PROCEDURE CommitStaffAdvance@1102755007(VAR ImprestHeader@1102755000 : Record 51516006);
    VAR
      PayLine@1102755013 : Record 51516007;
      Commitments@1102755012 : Record 51516050;
      Amount@1102755011 : Decimal;
      GLAcc@1102755010 : Record 15;
      Item@1102755009 : Record 27;
      FirstDay@1102755008 : Date;
      LastDay@1102755007 : Date;
      CurrMonth@1102755006 : Integer;
      Budget@1102755005 : Record 366;
      BudgetAmount@1102755004 : Decimal;
      Actuals@1102755003 : Record 365;
      ActualsAmount@1102755002 : Decimal;
      CommitmentAmount@1102755001 : Decimal;
      FixedAssetsDet@1102755014 : Record 5600;
      FAPostingGRP@1102755015 : Record 5606;
      EntryNo@1102755016 : Integer;
      GLAccount@1000000000 : Record 15;
    BEGIN

      //First Update Analysis View
      {UpdateAnalysisView();

      //get the budget control setup first to determine if it mandatory or not
      BCSetup.RESET;
      BCSetup.GET();
      IF BCSetup.Mandatory THEN//budgetary control is mandatory
        BEGIN
          //check if the dates are within the specified range in relation to the payment header table
          IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
            BEGIN
              ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
            END
          ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
            BEGIN
              ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

            END;
          //Is budget Available
          CheckIfBlocked(BCSetup."Current Budget Code");

          //Get Commitment Lines
           IF Commitments.FIND('+') THEN
              EntryNo:=Commitments."Line No.";

          //get the lines related to the payment header
            PayLine.RESET;
            PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
            PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
            IF PayLine.FINDFIRST THEN
              BEGIN
                REPEAT
                             //check the votebook now
                             FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
                             CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
                             IF CurrMonth=12 THEN
                              BEGIN
                                LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
                                LastDay:=CALCDATE('-1D',LastDay);
                              END
                             ELSE
                              BEGIN
                                CurrMonth:=CurrMonth +1;
                                LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
                                LastDay:=CALCDATE('-1D',LastDay);
                              END;

                             //If Budget is annual then change the Last day
                             IF BCSetup."Budget Check Criteria"=BCSetup."Budget Check Criteria"::"Whole Year" THEN
                                 LastDay:=BCSetup."Current Budget End Date";

                             //The GL Account
                              BudgetGL:=PayLine."Account No:";

                             //check the summation of the budget in the database
                             BudgetAmount:=0;
                             Budget.RESET;
                             Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                             Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                             Budget."Dimension 4 Value Code");
                             Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                             Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                             Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                             Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                             Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                             Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                             Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                 Budget.CALCSUMS(Budget.Amount);
                                 BudgetAmount:= Budget.Amount;

                        //get the summation on the actuals
                        //Separate Analysis View and G/L Entry
                          IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                          ActualsAmount:=0;
                          Actuals.RESET;
                          Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                          Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                          Actuals."Posting Date",Actuals."Account No.");
                          Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                          Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                          Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                          Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                          Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                          Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                             Actuals.CALCSUMS(Actuals.Amount);
                             ActualsAmount:= Actuals.Amount;
                          END ELSE BEGIN
                              GLAccount.RESET;
                              GLAccount.SETRANGE(GLAccount."No.",BudgetGL);
                              GLAccount.SETRANGE(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                              IF PayLine."Global Dimension 1 Code" <> '' THEN
                                GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter",PayLine."Global Dimension 1 Code");
                              IF PayLine."Shortcut Dimension 2 Code" <> '' THEN
                                GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter",PayLine."Shortcut Dimension 2 Code");
                              IF GLAccount.FIND('-') THEN BEGIN
                               GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                               ActualsAmount:=GLAccount."Net Change";
                              END;
                          END;
                        //get the committments
                          CommitmentAmount:=0;
                          Commitments.RESET;
                          Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                          Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                          Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                          Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                          Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                          Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                             Commitments.CALCSUMS(Commitments.Amount);
                             CommitmentAmount:= Commitments.Amount;

                         //check if there is any budget
                         IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('No Budget To Check Against');
                         END ELSE BEGIN
                          IF (BudgetAmount<=0) THEN BEGIN
                           IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                              ERROR('Budgetary Checking Process Aborted');
                           END;
                          END;
                         END;

                         //check if the actuals plus the amount is greater then the budget amount
                         IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                         AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                            PayLine.No,'Staff Imprest' ,PayLine.No,
                              FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                          END ELSE BEGIN
                          //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                              IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                  IF NOT CONFIRM(Text0001+
                                  FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                  +Text0002,TRUE) THEN BEGIN
                                     ERROR('Budgetary Checking Process Aborted');
                                  END;
                              END;

                              Commitments.RESET;
                              Commitments.INIT;
                              EntryNo+=1;
                              Commitments."Line No.":=EntryNo;
                              Commitments.Date:=TODAY;
                              Commitments."Posting Date":=ImprestHeader.Date;
                              Commitments."Document Type":=Commitments."Document Type"::StaffAdvance;
                              Commitments."Document No.":=ImprestHeader."No.";
                              Commitments.Amount:=PayLine."Amount LCY";
                              Commitments."Month Budget":=BudgetAmount;
                              Commitments."Month Actual":=ActualsAmount;
                              Commitments.Committed:=TRUE;
                              Commitments."Committed By":=USERID;
                              Commitments."Committed Date":=ImprestHeader.Date;
                              Commitments."G/L Account No.":=BudgetGL;
                              Commitments."Committed Time":=TIME;
                           //   Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                              Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                              Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                              Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                              Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                              Commitments.Budget:=BCSetup."Current Budget Code";
                              Commitments.Type:=ImprestHeader."Account Type";
                              Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
      //                        Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
      //                        Commitments."Actual Source":=BCSetup."Actual Source";
                              Commitments.INSERT;
                              //Tag the Imprest Line as Committed
                                PayLine.Committed:=TRUE;
                                PayLine.MODIFY;
                              //End Tagging Imprest Lines as Committed
                          END;

                UNTIL PayLine.NEXT=0;
              END;
        END
      ELSE//budget control not mandatory
        BEGIN

        END;
      MESSAGE('Budgetary Checking Completed Successfully');



      {********************
      //First Update Analysis View
      UpdateAnalysisView();

      //get the budget control setup first to determine if it mandatory or not
      BCSetup.RESET;
      BCSetup.GET();
      IF BCSetup.Mandatory THEN//budgetary control is mandatory
        BEGIN
          //check if the dates are within the specified range in relation to the payment header table
          IF (ImprestHeader.Date< BCSetup."Current Budget Start Date") THEN
            BEGIN
              ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
            END
          ELSE IF (ImprestHeader.Date>BCSetup."Current Budget End Date") THEN
            BEGIN
              ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

            END;
          //Is budget Available
          CheckIfBlocked(BCSetup."Current Budget Code");

          //Get Commitment Lines
           IF Commitments.FIND('+') THEN
              EntryNo:=Commitments."Line No.";

          //get the lines related to the payment header
            PayLine.RESET;
            PayLine.SETRANGE(PayLine.No,ImprestHeader."No.");
            PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
            IF PayLine.FINDFIRST THEN
              BEGIN
                REPEAT
                             //check the votebook now
                             FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader.Date,2),DATE2DMY(ImprestHeader.Date,3));
                             CurrMonth:=DATE2DMY(ImprestHeader.Date,2);
                             IF CurrMonth=12 THEN
                              BEGIN
                                LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader.Date,3) +1);
                                LastDay:=CALCDATE('-1D',LastDay);
                              END
                             ELSE
                              BEGIN
                                CurrMonth:=CurrMonth +1;
                                LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader.Date,3));
                                LastDay:=CALCDATE('-1D',LastDay);
                              END;

                             //The GL Account
                              BudgetGL:=PayLine."Account No:";

                             //check the summation of the budget in the database
                             BudgetAmount:=0;
                             Budget.RESET;
                             Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                             Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                             Budget."Dimension 4 Value Code");
                             Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                             Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                             Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                             Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                             Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                             Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                             Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                 Budget.CALCSUMS(Budget.Amount);
                                 BudgetAmount:= Budget.Amount;

                        //get the summation on the actuals
                          ActualsAmount:=0;
                          Actuals.RESET;
                          Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                          Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                          Actuals."Posting Date",Actuals."G/L Account No.");
                          Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                          Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                          Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                          Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                          Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                          Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Actuals.SETRANGE(Actuals."G/L Account No.",BudgetGL);
                             Actuals.CALCSUMS(Actuals.Amount);
                             ActualsAmount:= Actuals.Amount;

                        //get the committments
                          CommitmentAmount:=0;
                          Commitments.RESET;
                          Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                          Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                          Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                          Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                          Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                          Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                             Commitments.CALCSUMS(Commitments.Amount);
                             CommitmentAmount:= Commitments.Amount;

                         //check if there is any budget
                         IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('No Budget To Check Against');
                         END ELSE BEGIN
                          IF (BudgetAmount<=0) THEN BEGIN
                           IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                              ERROR('Budgetary Checking Process Aborted');
                           END;
                          END;
                         END;

                         //check if the actuals plus the amount is greater then the budget amount
                         IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                         AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                            PayLine.No,'Staff Imprest' ,PayLine.No,
                              FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                          END ELSE BEGIN
                          //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                              IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                  IF NOT CONFIRM(Text0001+
                                  FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                  +Text0002,TRUE) THEN BEGIN
                                     ERROR('Budgetary Checking Process Aborted');
                                  END;
                              END;

                              Commitments.RESET;
                              Commitments.INIT;
                              EntryNo+=1;
                              Commitments."Line No.":=EntryNo;
                              Commitments.Date:=TODAY;
                              Commitments."Posting Date":=ImprestHeader.Date;
                              Commitments."Document Type":=Commitments."Document Type"::StaffAdvance;
                              Commitments."Document No.":=ImprestHeader."No.";
                              Commitments.Amount:=PayLine."Amount LCY";
                              Commitments."Month Budget":=BudgetAmount;
                              Commitments."Month Actual":=ActualsAmount;
                              Commitments.Committed:=TRUE;
                              Commitments."Committed By":=USERID;
                              Commitments."Committed Date":=ImprestHeader.Date;
                              Commitments."G/L Account No.":=BudgetGL;
                              Commitments."Committed Time":=TIME;
      //                       // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                              Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                              Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                              Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                              Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                              Commitments.Budget:=BCSetup."Current Budget Code";
                              Commitments.Type:=ImprestHeader."Account Type";
                              Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
                              Commitments.INSERT;
                              //Tag the Imprest Line as Committed
                                PayLine.Committed:=TRUE;
                                PayLine.MODIFY;
                              //End Tagging Imprest Lines as Committed
                          END;

                UNTIL PayLine.NEXT=0;
              END;
        END
      ELSE//budget control not mandatory
        BEGIN

        END;
      MESSAGE('Budgetary Checking Completed Successfully');
      ******************************}
       }
    END;

    PROCEDURE CommitStaffAdvSurr@1102755008(VAR ImprestHeader@1102755000 : Record 51516006);
    VAR
      PayLine@1102755013 : Record 51516007;
      Commitments@1102755012 : Record 51516050;
      Amount@1102755011 : Decimal;
      GLAcc@1102755010 : Record 15;
      Item@1102755009 : Record 27;
      FirstDay@1102755008 : Date;
      LastDay@1102755007 : Date;
      CurrMonth@1102755006 : Integer;
      Budget@1102755005 : Record 366;
      BudgetAmount@1102755004 : Decimal;
      Actuals@1102755003 : Record 365;
      ActualsAmount@1102755002 : Decimal;
      CommitmentAmount@1102755001 : Decimal;
      FixedAssetsDet@1102755014 : Record 5600;
      FAPostingGRP@1102755015 : Record 5606;
      EntryNo@1102755016 : Integer;
    BEGIN
      //First Update Analysis View
      {UpdateAnalysisView();

      //get the budget control setup first to determine if it mandatory or not
      BCSetup.RESET;
      BCSetup.GET();
      IF BCSetup.Mandatory THEN//budgetary control is mandatory
        BEGIN
          //check if the dates are within the specified range in relation to the payment header table
          IF (ImprestHeader."Surrender Date"< BCSetup."Current Budget Start Date") THEN
            BEGIN
              ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader."Surrender Date",
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
            END
          ELSE IF (ImprestHeader."Surrender Date">BCSetup."Current Budget End Date") THEN
            BEGIN
              ERROR('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader."Surrender Date",
              BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

            END;
          //Is budget Available
          CheckIfBlocked(BCSetup."Current Budget Code");

          //Get Commitment Lines
           IF Commitments.FIND('+') THEN
              EntryNo:=Commitments."Line No.";

          //get the lines related to the payment header
            PayLine.RESET;
            PayLine.SETRANGE(PayLine."Surrender Doc No.",ImprestHeader.No);
            PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
            IF PayLine.FINDFIRST THEN
              BEGIN
                REPEAT
                             //check the votebook now
                             FirstDay:=DMY2DATE(1,DATE2DMY(ImprestHeader."Surrender Date",2),DATE2DMY(ImprestHeader."Surrender Date",3));
                             CurrMonth:=DATE2DMY(ImprestHeader."Surrender Date",2);
                             IF CurrMonth=12 THEN
                              BEGIN
                                LastDay:=DMY2DATE(1,1,DATE2DMY(ImprestHeader."Surrender Date",3) +1);
                                LastDay:=CALCDATE('-1D',LastDay);
                              END
                             ELSE
                              BEGIN
                                CurrMonth:=CurrMonth +1;
                                LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(ImprestHeader."Surrender Date",3));
                                LastDay:=CALCDATE('-1D',LastDay);
                              END;

                             //The GL Account
                              BudgetGL:=PayLine."Account No:";

                             //check the summation of the budget in the database
                             BudgetAmount:=0;
                             Budget.RESET;
                             Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                             Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                             Budget."Dimension 4 Value Code");
                             Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                             Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                             Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                             Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Shortcut Dimension 1 Code");
                             Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                             Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                             Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                 Budget.CALCSUMS(Budget.Amount);
                                 BudgetAmount:= Budget.Amount;

                        //get the summation on the actuals
                          ActualsAmount:=0;
                          Actuals.RESET;
                          Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                          Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                          Actuals."Posting Date",Actuals."Account No.");
                          Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                          Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Shortcut Dimension 1 Code");
                          Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                          Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                          Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                          Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                             Actuals.CALCSUMS(Actuals.Amount);
                             ActualsAmount:= Actuals.Amount;

                        //get the committments
                          CommitmentAmount:=0;
                          Commitments.RESET;
                          Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                          Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                          Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                          Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                          Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                          Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PayLine."Shortcut Dimension 1 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                          Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                             Commitments.CALCSUMS(Commitments.Amount);
                             CommitmentAmount:= Commitments.Amount;

                         //check if there is any budget
                         IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('No Budget To Check Against');
                         END ELSE BEGIN
                          IF (BudgetAmount<=0) THEN BEGIN
                           IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                              ERROR('Budgetary Checking Process Aborted');
                           END;
                          END;
                         END;

                         //check if the actuals plus the amount is greater then the budget amount
                         IF ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                         AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                            ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                            PayLine."Surrender Doc No.",'Staff Imprest' ,PayLine."Surrender Doc No.",
                              FORMAT(ABS(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                          END ELSE BEGIN
                          //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                              IF ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                  IF NOT CONFIRM(Text0001+
                                  FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                  +Text0002,TRUE) THEN BEGIN
                                     ERROR('Budgetary Checking Process Aborted');
                                  END;
                              END;

                              Commitments.RESET;
                              Commitments.INIT;
                              EntryNo+=1;
                              Commitments."Line No.":=EntryNo;
                              Commitments.Date:=TODAY;
                              Commitments."Posting Date":=ImprestHeader."Surrender Date";
                              Commitments."Document Type":=Commitments."Document Type"::StaffSurrender;
                              Commitments."Document No.":=ImprestHeader.No;
                              Commitments.Amount:=PayLine."Amount LCY";
                              Commitments."Month Budget":=BudgetAmount;
                              Commitments."Month Actual":=ActualsAmount;
                              Commitments.Committed:=TRUE;
                              Commitments."Committed By":=USERID;
                              Commitments."Committed Date":=ImprestHeader."Surrender Date";
                              Commitments."G/L Account No.":=BudgetGL;
                              Commitments."Committed Time":=TIME;
      //                        Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                              Commitments."Shortcut Dimension 1 Code":=PayLine."Shortcut Dimension 1 Code";
                              Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                              Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                              Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                              Commitments.Budget:=BCSetup."Current Budget Code";
                              Commitments.Type:=ImprestHeader."Account Type";
                              Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
                              Commitments.INSERT;
                              //Tag the Imprest Line as Committed
                                PayLine.Committed:=TRUE;
                                PayLine.MODIFY;
                              //End Tagging Imprest Lines as Committed
                          END;

                UNTIL PayLine.NEXT=0;
              END;
        END
      ELSE//budget control not mandatory
        BEGIN

        END;
      MESSAGE('Budgetary Checking Completed Successfully');
       }
    END;

    BEGIN
    END.
  }
}

