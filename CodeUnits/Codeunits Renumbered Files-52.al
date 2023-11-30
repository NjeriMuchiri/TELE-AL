OBJECT CodeUnit 20416 Sky Mbanking
{
  OBJECT-PROPERTIES
  {
    Date=11/03/23;
    Time=[ 8:23:32 AM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    OnRun=VAR
            Pin@1120054000 : Text;
            msg@1120054001 : Text;
            Success@1120054002 : Boolean;
            Amt@1120054003 : Decimal;
            Limit@1120054004 : Decimal;
            LoansRegister@1120054005 : Record 51516230;
            SalStart@1120054006 : ARRAY [3] OF Date;
            SalEnd@1120054007 : ARRAY [3] OF Date;
            Number@1120054008 : GUID;
            NumberOfMonths@1120054009 : Integer;
            DayLoanPaid@1120054010 : Date;
            Text001@1120054011 : Code[10];
            POSTATMTransactions@1120054012 : CodeUnit 20372;
            SkyTransactions@1120054013 : Record 51516712;
          BEGIN
            // IF Members.GET('012061') THEN BEGIN
            //   Members."Loan Defaulter" := FALSE;
            //   Members.MODIFY;
            // END;
            //GetSalaryLoanQualifiedAmount('0502-001-09454','A01',Limit,msg);
            //GetReloadedLoanQualifiedAmount('0502-001-09454','A10',Limit,msg);
            //GetLoanQualifiedAmount('0502-001-09454','A16',msg,Limit);
            //GetOverdraftLoanQualifiedAmount('0502-001-09454','M_OD',Limit,msg);


            //GetSalaryLoanQualifiedAmount('0502-001-08721','A01',Limit,msg);
            //GetReloadedLoanQualifiedAmount('0502-001-08721','A10',Limit,msg);
            //GetLoanQualifiedAmount('0502-001-08721','A16',msg,Limit);
            //GetOverdraftLoanQualifiedAmount('0502-001-08721','M_OD',Limit,msg);

            MESSAGE('Done');
          END;

  }
  CODE
  {
    VAR
      Sep@1032 : TextConst 'ENU=\::/';
      Null@1031 : TextConst 'ENU=NULL';
      Success@1033 : TextConst 'ENU=200';
      Account_Does_Not_Exist@1034 : TextConst 'ENU=300';
      Parameters_Not_Valid_Or_Missing@1035 : TextConst 'ENU=400';
      Caller_Not_Authorized_For_This_Request@1036 : TextConst 'ENU=401';
      Insufficient_Funds@1037 : TextConst 'ENU=402';
      Daily_Amount_Limit_Reached@1038 : TextConst 'ENU=403';
      Operation_Does_Not_Exist@1039 : TextConst 'ENU=404';
      Daily_Frequency_Limit_Reached@1040 : TextConst 'ENU=405';
      Severe_problem_Has_Occured@1041 : TextConst 'ENU=500';
      StatusOK@1050 : TextConst 'ENU=200';
      StatusNotFound@1049 : TextConst 'ENU=404';
      ExciseDutyGL@1003 : Code[20];
      ExciseDutyRate@1002 : Decimal;
      ExciseDuty@1001 : Decimal;
      CoopSetup@1000 : Record 51516704;
      SaccoTrans@1004 : CodeUnit 20366;
      Source@1006 : 'NEW_MEMBER,NEW_ACCOUNT,LOAN_ACCOUNT_APPROVAL,DEPOSIT_CONFIRMATION,CASH_WITHDRAWAL_CONFIRM,LOAN_APPLICATION,LOAN_APPRAISAL,LOAN_GUARANTORS,LOAN_REJECTED,LOAN_POSTED,LOAN_DEFAULTED,SALARY_PROCESSING,TELLER_CASH_DEPOSIT,TELLER_CASH_WITHDRAWAL,TELLER_CHEQUE_DEPOSIT,FIXED_DEPOSIT_MATURITY,INTERACCOUNT_TRANSFER,ACCOUNT_STATUS,STATUS_ORDER,EFT_EFFECTED,ATM_APPLICATION_FAILED,ATM_COLLECTION,MBANKING,MEMBER_CHANGES,CASHIER_BELOW_LIMIT,CASHIER_ABOVE_LIMIT,INTERNETBANKING,CRM,MOBILE_PIN';
      Account@1007 : Record 23;
      Auth@1009 : Record 51516709;
      Priority@1011 : Integer;
      SMSCharge@1012 : Decimal;
      SMSAccount@1013 : Code[20];
      GenJournalBatch@1000000000 : Record 232;
      LGCount@1005 : Integer;
      CheckDate@1014 : Date;
      RemInst@1015 : Integer;
      LoaneeDepAcc@1016 : Code[20];
      STOFound@1017 : Boolean;
      Members@1019 : Record 51516223;
      CreditLimit@1020 : Decimal;
      TestDate@1021 : Date;
      GeneralLedgerSetup@1008 : Record 51516700;
      RcptLine@1010 : Record 51516716;
      FosaProducts@1120054000 : Record 51516295;
      CreditRating@1120054001 : Record 51516718;
      Schedule@1120054002 : CodeUnit 20412;
      SaccoSetup@1120054003 : Record 51516700;
      Safcom@1120054004 : Decimal;
      PenaltyCounter@1120054005 : Record 51516443;
      LoansRegister@1120054006 : Record 51516230;
      UssdCode@1120054007 : TextConst 'ENU=*882#';
      InsiderLendings2@1120054008 : Record 50002;
      LoanProductsSetup@1120054009 : Record 51516240;

    PROCEDURE GetExciseRate@29() rate : Integer;
    VAR
      GenSetup@1000 : Record 51516700;
    BEGIN


      GenSetup.GET;
      //GenSetup.TESTFIELD(GenSetup."Excise Duty (%)");
      rate := GenSetup."Excise Duty (%)";
    END;

    PROCEDURE GetExciseDutyGL@21() account : Text[20];
    VAR
      GenSetup@1000 : Record 51516700;
    BEGIN

      GenSetup.RESET;
      GenSetup.GET;
      IF GenSetup."Excise Duty (%)" > 0 THEN
      GenSetup.TESTFIELD(GenSetup."Excise Duty G/L");
      account := GenSetup."Excise Duty G/L";
    END;

    PROCEDURE GetSavingsAccountTypes@7() Response : Text;
    VAR
      PFact@1000 : Record 51516717;
      FosaProducts@1120054000 : Record 51516295;
    BEGIN

      Response:='';


      PFact.RESET;
      PFact.SETRANGE("Product Class Type",PFact."Product Class Type"::Savings);
      PFact.SETFILTER("Mobile Transaction",'<>%1',PFact."Mobile Transaction"::" ");
      IF PFact.FINDFIRST THEN BEGIN
          Response:='<SavingsProducts>';
          REPEAT
              Response+='<Product>';
                  Response+='<ProductID>'+PFact."Product ID"+'</ProductID>';
                  Response+='<ProductName>'+PFact."USSD Product Name"+'</ProductName>';
              Response+='</Product>';

              FosaProducts.RESET;
              FosaProducts.SETFILTER("Mobile Transaction",'<>%1',FosaProducts."Mobile Transaction"::" ");
              IF FosaProducts.FINDFIRST THEN BEGIN
                  REPEAT
                      IF FosaProducts."USSD Product Name" = '' THEN
                          FosaProducts."USSD Product Name" := FosaProducts.Description;
                      Response+='<Product>';
                          Response+='<ProductID>'+FosaProducts.Code+'</ProductID>';
                          Response+='<ProductName>'+FosaProducts."USSD Product Name"+'</ProductName>';
                      Response+='</Product>';
                  UNTIL FosaProducts.NEXT = 0;
              END;
          UNTIL PFact.NEXT = 0;
          Response+='</SavingsProducts>';
      END;
    END;

    PROCEDURE GetSingleAccount@5(PhoneNo@1102755000 : Text[30];AccountType@1001 : Code[20]) Response : Text;
    VAR
      SavAcc@1000 : Record 23;
      PFact@1002 : Record 51516717;
      xmlWriter@1008 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlTextWriter";
      EncodingText@1007 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
      XMLDOMMgt@1006 : Codeunit 6224;
      BodyContentXmlDoc@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      EnvelopeXmlNode@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      CreatedXmlNode@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN

      Response:='';
      PhoneNo := '+'+PhoneNo;

      IF PFact.GET(AccountType) THEN BEGIN
          SavAcc.RESET;
          SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
          SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
          IF SavAcc.FINDFIRST THEN BEGIN
              Response:=' <SavAcc>';
              REPEAT
                  SavAcc.TESTFIELD("BOSA Account No");
                  Members.GET(SavAcc."BOSA Account No");
                  Response+='<Account>';
                      Response+='<AccNo>'+PFact."Product ID"+Members."No."+'</AccNo>';
                      Response+='<AccName>'+PFact."USSD Product Name"+'</AccName>';
                  Response+='</Account>';
              UNTIL SavAcc.NEXT = 0;
              Response+='</SavAcc>';
          END;
      END
      ELSE BEGIN

          IF FosaProducts.GET(AccountType) THEN BEGIN

              IF FosaProducts."USSD Product Name" = '' THEN
                  FosaProducts."USSD Product Name" := FosaProducts.Description;
              SavAcc.RESET;
              SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
              SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
              IF SavAcc.FINDFIRST THEN BEGIN
                  Response:=' <SavAcc>';
                  REPEAT

                      Response+='<Account>';
                          Response+='<AccNo>'+FosaProducts.Code+SavAcc."No."+'</AccNo>';
                          Response+='<AccName>'+FosaProducts."USSD Product Name"+'</AccName>';
                      Response+='</Account>';
                  UNTIL SavAcc.NEXT = 0;
                  Response+='</SavAcc>';
              END;
          END;
      END;
    END;

    PROCEDURE GetAccountList@2(PhoneNo@1102755000 : Text[30]) Response : Text;
    VAR
      SavAcc@1000 : Record 23;
      PFact@1001 : Record 51516717;
      Found@1002 : Boolean;
      MNo@1120054000 : Code[20];
    BEGIN

      PhoneNo := '+'+PhoneNo;
      Response:='';
      Found:=FALSE;

      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FINDFIRST THEN BEGIN
          Response:='<Accounts>';
          REPEAT
              MNo := SavAcc."BOSA Account No";
              PFact.RESET;
              PFact.SETRANGE("Product Class Type",PFact."Product Class Type"::Savings);
              IF PFact.FINDFIRST THEN BEGIN
                  REPEAT
                      IF PFact."Mobile Transaction"<>PFact."Mobile Transaction"::" " THEN BEGIN
                          SavAcc.TESTFIELD("BOSA Account No");
                          Found:=TRUE;
                          Response+='<Account>';
                              Response+='<AccNo>'+PFact."Product ID"+SavAcc."BOSA Account No"+'</AccNo>';
                              Response+='<AccName>'+PFact."USSD Product Name"+'</AccName>';
                          Response+='</Account>';
                      END;
                  UNTIL PFact.NEXT = 0;
              END;
              FosaProducts.RESET;
              IF FosaProducts.FINDFIRST THEN BEGIN
                  REPEAT
                      IF FosaProducts."Mobile Transaction"<>PFact."Mobile Transaction"::" " THEN BEGIN
                          SavAcc.RESET;
                          SavAcc.SETRANGE(SavAcc."Account Type",FosaProducts.Code);
                          SavAcc.SETRANGE(SavAcc."BOSA Account No",MNo);
                          IF SavAcc.FINDFIRST THEN BEGIN
                              Found:=TRUE;

                              Response+='<Account>';
                                  Response+='<AccNo>'+SavAcc."No."+'</AccNo>';
                                  Response+='<AccName>'+FosaProducts."USSD Product Name"+'</AccName>';
                              Response+='</Account>';
                          END;
                      END;
                  UNTIL FosaProducts.NEXT = 0;
              END;

          UNTIL SavAcc.NEXT = 0;
          Response+='</Accounts>';
      END;

      IF NOT Found THEN
        Response:='';
    END;

    PROCEDURE GetSavingsAccountList@1(PhoneNo@1102755000 : Text[30];Withdrawable@1004 : Boolean) Response : Text;
    VAR
      SavAcc@1000 : Record 23;
      ProdFact@1001 : Record 51516717;
      Found@1002 : Boolean;
      MemberNo@1003 : Code[20];
    BEGIN

      PhoneNo := '+'+PhoneNo;
      Response:='';
      Found:=FALSE;



      MemberNo:='';
      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
      IF SavAcc.FINDFIRST THEN
         MemberNo := SavAcc."No.";

      IF MemberNo='' THEN
          EXIT;



      SavAcc.RESET;
      SavAcc.SETRANGE("No.",MemberNo);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FIND('-') THEN BEGIN
          Response:='<Accounts>';
          REPEAT
              ProdFact.RESET;
              ProdFact.SETRANGE("Product Class Type",ProdFact."Product Class Type"::Savings);
              IF ProdFact.FINDFIRST THEN BEGIN
                  REPEAT

                      IF Withdrawable THEN BEGIN
                          IF (ProdFact."Mobile Transaction" = ProdFact."Mobile Transaction"::"Deposits & Withdrawals") OR (ProdFact."Mobile Transaction" = ProdFact."Mobile Transaction"::"Withdrawals Only") THEN BEGIN

                              Found:=TRUE;
                              Response+='<Account>';
                                  Response+='<AccNo>'+ProdFact."Product ID"+SavAcc."BOSA Account No"+'</AccNo>';
                                  Response+='<AccName>'+ProdFact."USSD Product Name"+'</AccName>';
                              Response+='</Account>';
                          END;

                      END
                      ELSE BEGIN
                          IF ProdFact."Mobile Transaction" <> ProdFact."Mobile Transaction"::" " THEN BEGIN
                              Found:=TRUE;
                              Response+='<Account>';
                                  Response+='<AccNo>'+ProdFact."Product ID"+SavAcc."BOSA Account No"+'</AccNo>';
                                  Response+='<AccName>'+ProdFact."USSD Product Name"+'</AccName>';
                              Response+='</Account>';
                          END;
                      END;
                  UNTIL ProdFact.NEXT = 0;
              END;

              IF FosaProducts.GET(SavAcc."Account Type") THEN BEGIN

                  IF Withdrawable THEN BEGIN
                      IF (FosaProducts."Mobile Transaction" = FosaProducts."Mobile Transaction"::"Deposits & Withdrawals") OR (FosaProducts."Mobile Transaction" = FosaProducts."Mobile Transaction"::"Withdrawals Only") THEN BEGIN
                          Found:=TRUE;
                          Response+='<Account>';
                              Response+='<AccNo>'+SavAcc."No."+'</AccNo>';
                              Response+='<AccName>'+FosaProducts."USSD Product Name"+'</AccName>';
                          Response+='</Account>';
                      END;

                  END
                  ELSE BEGIN
                      IF FosaProducts."Mobile Transaction" <> FosaProducts."Mobile Transaction"::" " THEN BEGIN
                          Found:=TRUE;
                          Response+='<Account>';
                              Response+='<AccNo>'+SavAcc."No."+'</AccNo>';
                              Response+='<AccName>'+FosaProducts."USSD Product Name"+'</AccName>';
                          Response+='</Account>';
                      END;
                  END;
              END;
          UNTIL SavAcc.NEXT = 0;
          Response+='</Accounts>';

      END;


      IF NOT Found THEN
        Response:='';
    END;

    PROCEDURE InsertMpesaTransaction@3(EntryCode@1017 : GUID;TransactionID@1102755001 : Code[20];Transaction@1019 : Text;Description@1020 : Text[100];AccountNo@1021 : Code[20];Amount@1015 : Decimal;PhoneNo@1036 : Code[20];PIN@1012 : Text;RequestApplication@1038 : Text;RequestCorrelationID@1037 : Text;SourceApplication@1035 : Text;NetworkServiceProvider@1120054002 : Text;BeneficiaryMobileNumber@1120054008 : Text;BeneficiaryName@1120054009 : Text;OtherNumber@1120054010 : Boolean) Response : Text[1024];
    VAR
      SaccoFee@1000 : Decimal;
      VendorCommission@1001 : Decimal;
      TransactionType@1002 : ' ,Withdrawal,Deposit,Utility Payment,Loan Repayment,Balance Enquiry,Mini-Statement,Loan Disbursement,Account Transfer,Pay Loan From Account,Paybill,Mobile App Login,Bank Transfer,Airtime,T-Kash Loan Repayment,T-Kash Paybill,CoopDeposit';
      TotalCharge@1003 : Decimal;
      SavAcc@1004 : Record 23;
      MpesaTrans@1005 : Record 51516712;
      Continue@1008 : Boolean;
      MobileWithdrawalsBuffer@1009 : Record 51516714;
      AccBal@1010 : Decimal;
      SafcomCharges@1013 : Record 51516708;
      SafcomAcc@1014 : Code[20];
      SafcomFee@1016 : Decimal;
      TransactionDate@1011 : DateTime;
      MemberID@1006 : Code[20];
      PrePaymentGL@1018 : Code[20];
      Loans@1022 : Record 51516230;
      LoanNo@1007 : Code[20];
      MemberNo@1023 : Code[20];
      Type@1024 : 'Daily,Weekly,Monthly';
      Limit@1025 : Decimal;
      msg@1026 : Text;
      SavingsProduct@1027 : Code[20];
      LoanProduct@1028 : Code[20];
      ProductFactory@1029 : Record 51516717;
      KeyWord@1030 : Code[10];
      KeyFound@1031 : Boolean;
      ProductID@1032 : Code[20];
      MNo@1033 : Code[20];
      AccEntered@1034 : Code[20];
      ATMTransactions@1120054000 : Record 51516323;
      ServiceProvider@1120054001 : 'Safaricom,Telkom';
      FilterWithProvider@1120054003 : Boolean;
      SkyBlackListedAccountNos@1120054004 : Record 51516706;
      SavingsAccountType@1120054005 : Code[30];
      SkyProductSetup@1120054006 : Record 51516717;
      MembersRegister@1120054007 : Record 51516223;
    BEGIN
      ServiceProvider := ServiceProvider::Safaricom;
      IF NetworkServiceProvider = 'TELKOM' THEN
        ServiceProvider := ServiceProvider::Telkom;


      FilterWithProvider := FALSE;
      PhoneNo := '+'+PhoneNo;
      AccEntered := AccountNo;

          MpesaTrans.LOCKTABLE(TRUE);
          MpesaTrans.RESET;
          MpesaTrans.SETRANGE("Transaction ID", TransactionID);
          IF MpesaTrans.FINDFIRST THEN BEGIN
              Response:='<Response>';
                Response+='<Status>TRANSACTION_EXISTS</Status>';
                Response+='<StatusDescription>Transaction Already Exists</StatusDescription>';
                Response+='<Reference>'+FORMAT(TransactionID)+'</Reference>';
              Response+='</Response>';
              EXIT;
          END;

      //END;

      SavingsProduct := '';
      LoanProduct := '';


      IF AccountNo='' THEN BEGIN
          SavAcc.RESET;
          SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
          IF SavAcc.FINDFIRST THEN BEGIN

              AccountNo:=SavAcc."No.";
              MemberNo:=SavAcc."No.";
              SavingsProduct := SavAcc."Account Type";
          END
      END;

      TransactionDate:=CURRENTDATETIME;

      Response:='ERROR';

      SkyProductSetup.RESET;
      SkyProductSetup.SETRANGE(SkyProductSetup."Product Class Type",SkyProductSetup."Product Class Type"::Loan);
      SkyProductSetup.SETRANGE(SkyProductSetup."Key Word",COPYSTR(AccountNo,1,2));
      IF SkyProductSetup.FINDFIRST THEN BEGIN
        Transaction := 'Loan Repayment';
        Description := 'Loan Repayment';
        MembersRegister.RESET;
        MembersRegister.SETRANGE(MembersRegister."ID No.",COPYSTR(AccountNo,3,STRLEN(AccountNo)));
        IF MembersRegister.FINDFIRST THEN BEGIN
          Loans.RESET;
          Loans.SETRANGE(Loans."BOSA No",MembersRegister."No.");
          Loans.SETRANGE(Loans."Loan Product Type",SkyProductSetup."Product ID");
          Loans.SETFILTER(Loans."Outstanding Balance",'>0');
          IF Loans.FINDFIRST THEN BEGIN
            AccountNo := 'LOAN'+Loans."Loan  No.";
          END;
        END;
      END;


      IF (COPYSTR(AccountNo,1,4) = 'LOAN') OR (Loans.GET(AccountNo)) THEN BEGIN
          Transaction := 'Loan Repayment';
          Description := 'Loan Repayment';

          LoanNo := COPYSTR(AccountNo,5,STRLEN(AccountNo));
          IF Loans.GET(LoanNo) THEN
              AccountNo := LoanNo;
      END;


      IF Transaction = 'Balance Enquiry' THEN
        TransactionType:=TransactionType::"Balance Enquiry";

      IF Transaction = 'Loan Repayment' THEN
        TransactionType:=TransactionType::"Loan Repayment";

      IF Transaction = 'Mini-Statement' THEN
        TransactionType:=TransactionType::"Mini-Statement";

      IF Transaction = 'Deposit' THEN
        TransactionType:=TransactionType::Deposit;

      IF Transaction = 'Withdrawal' THEN
        TransactionType:=TransactionType::Withdrawal;


      IF Transaction = 'Utility Request' THEN
        TransactionType:=TransactionType::"Utility Payment";

      IF Transaction = 'Utility Payment' THEN
        TransactionType:=TransactionType::"Utility Payment";

      IF Transaction = 'Airtime Request' THEN
        TransactionType:=TransactionType::Airtime;

      IF Transaction = 'Airtime Purchase' THEN
        TransactionType:=TransactionType::Airtime;

      IF Transaction = 'Withdrawal Request' THEN
        TransactionType:=TransactionType::Withdrawal;

      IF Transaction = 'Paybill' THEN
        TransactionType:=TransactionType::Paybill;


      IF Transaction = 'Bank Transfer' THEN
        TransactionType:=TransactionType::"Bank Transfer";


      IF Transaction = 'Bank Transfer Request' THEN
        TransactionType:=TransactionType::"Bank Transfer";

      IF Transaction = 'CoopDeposit' THEN
        TransactionType:=TransactionType::CoopDeposit;

      IF (Transaction = 'Withdrawal') OR (Transaction = 'Utility Payment') OR
        (Transaction = 'Bank Transfer') OR (Transaction = 'Paybill') THEN FilterWithProvider:=TRUE;
      // Get Excise duty G/L
      ExciseDutyGL := GetExciseDutyGL();
      ExciseDutyRate := GetExciseRate();
      ExciseDuty:=0;


      IF (Transaction = 'Withdrawal') OR (Transaction = 'Utility Payment')  OR (Transaction = 'Airtime Purchase') OR (Transaction = 'Bank Transfer') THEN BEGIN

          MobileWithdrawalsBuffer.RESET;
          MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer."Trace ID",EntryCode);
          MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer.Source,MobileWithdrawalsBuffer.Source::"M-PESA");
          IF MobileWithdrawalsBuffer.FIND('-') THEN BEGIN
              AccountNo:=MobileWithdrawalsBuffer."Account No";
              Amount:=MobileWithdrawalsBuffer.Amount;
              IF Description = '' THEN
              Description := MobileWithdrawalsBuffer.Description;
          END;
      END;

      IF TransactionType = TransactionType::"Loan Repayment" THEN BEGIN
          IF Loans.GET(AccountNo) THEN BEGIN
              LoanNo := Loans."Loan  No.";
          END
          ELSE
              LoanNo := COPYSTR(AccountNo,5,STRLEN(AccountNo));

          IF Loans.GET(LoanNo) THEN BEGIN
              SavAcc.RESET;
              SavAcc.SETRANGE("No.",Loans."Account No");
              IF SavAcc.FINDFIRST THEN BEGIN
                  AccountNo:=SavAcc."No.";
                  LoanNo := Loans."Loan  No.";
                  LoanProduct := Loans."Loan Product Type";
              END;
          END;
      END;

      //ERROR('%1',LoanNo);

      SafcomFee:=0;
      SaccoFee:=0;
      VendorCommission:=0;
      PrePaymentGL:='';
      SMSAccount:='';
      SMSCharge:=0;

      CoopSetup.RESET;
      IF FilterWithProvider THEN
      CoopSetup.SETRANGE(CoopSetup."Network Service Provider",ServiceProvider);
      CoopSetup.SETRANGE("Transaction Type",TransactionType);
      IF CoopSetup.FINDFIRST THEN BEGIN
          IF CoopSetup.Disable THEN
              ERROR('Temporarily Unavailable');

          IF (Transaction = 'Withdrawal Request') OR (Transaction = 'Utility Request') OR (Transaction = 'CoopDeposit') OR (Transaction = 'Airtime Request') OR (Transaction = 'Bank Transfer Request')  THEN BEGIN
              IF CoopSetup."Transaction Limit" > 0 THEN BEGIN
                  IF Amount > CoopSetup."Transaction Limit"THEN BEGIN
                      Response:='<Response>';
                      Response+='<Status>TRANSACTION_LIMIT_EXCEEDED</Status>';
                      Response+='<StatusDescription>Transaction Amount Exceeds the Set Limit</StatusDescription>';
                      Response+='<Reference>'+FORMAT(EntryCode)+'</Reference>';
                      Response+='</Response>';
                      EXIT;
                  END;
              END;
              IF CoopSetup."Daily Limit" > 0 THEN BEGIN
                  Limit := CoopSetup."Daily Limit" - GetAmountTransacted(Transaction,AccountNo,DT2DATE(TransactionDate),Type::Daily);

                  IF Limit < 0 THEN
                      Limit := 0;

                  IF  Limit < Amount THEN BEGIN
                      IF SavAcc.GET(AccountNo) THEN BEGIN
                          Priority := 205;
                          msg := 'Dear member, your withdrawal request on '+DateTimeToText(CURRENTDATETIME)+' could not be processed because the amount exceeds the set daily limit. '+
                          'You can only withdraw up to KES '+FORMAT(Limit);
                          SendSmsWithID(Source::MBANKING,SavAcc."Transactional Mobile No",msg,AccountNo,'',TRUE,Priority,TRUE,RequestApplication, RequestCorrelationID, SourceApplication);
                      END;
                      Response:='DAILY_LIMIT_EXCEEDED';
                      EXIT;
                  END;
              END;
              IF CoopSetup."Weekly Limit" > 0 THEN BEGIN
                  Limit := CoopSetup."Weekly Limit" - GetAmountTransacted(Transaction,AccountNo,DT2DATE(TransactionDate),Type::Weekly);

                  IF Limit < 0 THEN
                      Limit := 0;

                  IF  Limit < Amount THEN BEGIN
                      IF SavAcc.GET(AccountNo) THEN BEGIN
                          Priority := 205;
                          msg := 'Dear member, your withdrawal request on '+DateTimeToText(CURRENTDATETIME)+' could not be processed because the amount exceeds the set weekly limit. You can only withdraw up to KES '+FORMAT(Limit);
                          SendSmsWithID(Source::MBANKING,SavAcc."Transactional Mobile No",msg,AccountNo,SavAcc."No.",TRUE,Priority,TRUE,RequestApplication, RequestCorrelationID, SourceApplication);
                      END;
                      Response:='WEEKLY_LIMIT_EXCEEDED';
                      EXIT;
                  END;

              END;
              IF CoopSetup."Monthly Limit" > 0 THEN BEGIN
                  Limit := CoopSetup."Daily Limit" - GetAmountTransacted(Transaction,AccountNo,DT2DATE(TransactionDate),Type::Monthly);

                  IF Limit < 0 THEN
                      Limit := 0;

                  IF  Limit < Amount THEN BEGIN
                      IF SavAcc.GET(AccountNo) THEN BEGIN
                          Priority := 205;
                          msg := 'Dear member, your withdrawal request on ' +DateTimeToText(CURRENTDATETIME)+'could not be processed because the amount exceeds the set monthly limit. You can only withdraw up to KES '+FORMAT(Limit);
                          SendSmsWithID(Source::MBANKING,SavAcc."Transactional Mobile No",msg,AccountNo,SavAcc."No.",TRUE,Priority,TRUE,RequestApplication, RequestCorrelationID, SourceApplication);
                      END;
                      Response:='DAILY_LIMIT_EXCEEDED';
                      EXIT;
                  END;
              END;

          END;

          SMSAccount := CoopSetup."SMS Account";
          SMSCharge := CoopSetup."SMS Charge";

          GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,SafcomFee,Amount);
          PrePaymentGL := CoopSetup."Pre-Payment Account";
          TotalCharge:=SaccoFee+VendorCommission+SafcomFee+SMSCharge;
          ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);

      END
      ELSE BEGIN
          ERROR('Setup Missing for %1',Transaction);
      END;


      MemberID:='';

      IF (Transaction = 'Withdrawal Request') OR (Transaction = 'Utility Request')  OR (Transaction = 'Airtime Request')  OR (Transaction = 'Bank Transfer Request')   THEN BEGIN

          IF NOT CorrectPin(PhoneNo,PIN) THEN BEGIN
              Response := 'INCORRECT_PIN';
              EXIT;
          END;

      END;




      IF TransactionType = TransactionType::Paybill THEN BEGIN

          ProductID := '';
          MNo:='';
          IF SavAcc.GET(AccountNo) THEN BEGIN
              MNo := SavAcc."BOSA Account No";
              ProductID := SavAcc."Account Type";
              MemberID := SavAcc."ID No.";
              SavingsProduct := ProductID;
          END
          ELSE BEGIN
              SplitAccount(AccountNo,ProductID,MNo);

              IF MNo <> '' THEN BEGIN
                  IF Members.GET(MNo) THEN BEGIN
                      IF SavAcc.GET(Members."FOSA Account") THEN BEGIN
                          MemberID := SavAcc."ID No.";
                          AccountNo := Members."FOSA Account";
                          SavingsProduct := ProductID;
                      END;
                  END ELSE MNo := '';//cater for fosa deposits
              END;

          END;

          IF MNo = '' THEN BEGIN

              SavAcc.RESET;
              SavAcc.SETRANGE("ID No.",AccountNo);
              SavAcc.SETRANGE("Account Type",'ORDINARY');
              IF SavAcc.FINDFIRST THEN BEGIN
                  MemberID := SavAcc."ID No.";
                  AccountNo := SavAcc."No.";
                  SavingsProduct := SavAcc."Account Type";

              END
              ELSE BEGIN

                  KeyWord := '';
                  KeyFound := FALSE;
                  ProductFactory.RESET;
                  ProductFactory.SETRANGE("Product Class Type",ProductFactory."Product Class Type"::Savings);
                  ProductFactory.SETFILTER("Key Word",'<>%1','');
                  IF ProductFactory.FINDFIRST THEN BEGIN
                      REPEAT
                          KeyWord := ProductFactory."Key Word";

                          IF COPYSTR(AccountNo,1,STRLEN(KeyWord)) = KeyWord THEN BEGIN
                              AccountNo := COPYSTR(AccountNo,(STRLEN(KeyWord)+1),STRLEN(AccountNo));
                              KeyFound := TRUE;
                              SavingsProduct := ProductFactory."Product ID";
                              SavingsAccountType := ProductFactory."Account Type";
                              IF SavingsAccountType = '' THEN SavingsAccountType := 'ORDINARY';
                          END;

                      UNTIL (ProductFactory.NEXT = 0) OR (KeyFound);
                  END;

                  SavAcc.RESET;
                  SavAcc.SETRANGE("Account Type",SavingsAccountType);
                  SavAcc.SETRANGE("ID No.",AccountNo);
                  IF SavAcc.FINDFIRST THEN BEGIN
                      MemberID := SavAcc."ID No.";
                      AccountNo := SavAcc."No.";
                      IF PhoneNo = '' THEN
                      PhoneNo := SavAcc."Transactional Mobile No";
                  END
                  ELSE BEGIN

                      MpesaTrans.INIT;
                      MpesaTrans."Entry No.":=EntryCode;
                      MpesaTrans."Transaction ID":=TransactionID;
                      MpesaTrans."Session ID":=TransactionID;
                      MpesaTrans."Paybill Account Entered" := AccEntered;
                      MpesaTrans."Transaction Type" := TransactionType;
                      MpesaTrans."Transaction Name" := Transaction;
                      MpesaTrans.Description:=COPYSTR(Description,1,50);;
                      MpesaTrans."Transaction Date":=DT2DATE(TransactionDate);
                      MpesaTrans."Transaction Time":=DT2TIME(TransactionDate);
                      MpesaTrans."Date Captured" := TransactionDate;
                      MpesaTrans."Member Account":=AccountNo;
                      MpesaTrans.Amount:=Amount;
                      MpesaTrans."Loan No." := LoanNo;
                      MpesaTrans."Mobile No." := PhoneNo;
                      MpesaTrans."Vendor Commission":=VendorCommission;
                      MpesaTrans."Sacco Fee":=SaccoFee;
                      MpesaTrans."Paybill Member ID" := MemberID;
                      MpesaTrans."Savings Product" := SavingsProduct;
                      MpesaTrans."Loan Product" := LoanProduct;
                      MpesaTrans."Network Service Provider" := ServiceProvider;
                      MpesaTrans."Beneficiary Mobile Number" := BeneficiaryMobileNumber;
                      MpesaTrans."Beneficiary Name" := BeneficiaryName;
                      MpesaTrans."Other Number" := OtherNumber;
                      MpesaTrans.INSERT;



                      Response:='<Response>';
                        Response+='<Status>SUCCESS</Status>';
                        Response+='<StatusDescription>Success</StatusDescription>';
                        Response+='<Reference>'+FORMAT(EntryCode)+'</Reference>';
                      Response+='</Response>';
                      //PostMpesaTransaction(TransactionID);
                      EXIT;
                  END;
              END;
          END;
      END
      ELSE BEGIN

          IF NOT  SavAcc.GET(AccountNo) THEN BEGIN
              ProductID := '';
              MNo:='';
              SplitAccount(AccountNo,ProductID,MNo);
              IF MNo <> '' THEN BEGIN

                  Members.GET(MNo);
                  IF SavAcc.GET(Members."FOSA Account") THEN BEGIN
                      MemberID := SavAcc."ID No.";
                      AccountNo := SavAcc."No.";
                      SavingsProduct := ProductID;
                  END;

              END
          END;
      END;

      IF SavAcc.GET(AccountNo) THEN BEGIN
          IF PhoneNo = '' THEN
          PhoneNo := SavAcc."Transactional Mobile No";

          IF (Transaction = 'Withdrawal Request')  OR (Transaction = 'Utility Request')  OR (Transaction = 'Airtime Request')  OR (Transaction = 'Bank Transfer Request')  THEN BEGIN

              IF (SavAcc.Status <> SavAcc.Status::Active) OR (SavAcc.Blocked <> SavAcc.Blocked::" ") THEN BEGIN
                  Response:='ACCOUNT_NOT_ACTIVE';
                  EXIT;
              END;

              AccBal := GetAccountBalance(SavingsProduct+SavAcc."No.");
              IF (AccBal >= Amount+TotalCharge+ExciseDuty) THEN BEGIN

                  MobileWithdrawalsBuffer.INIT;
                  MobileWithdrawalsBuffer."Session ID" := TransactionID;
                  MobileWithdrawalsBuffer."Withdrawal Type" := Transaction;
                  MobileWithdrawalsBuffer."Trace ID" := EntryCode;
                  MobileWithdrawalsBuffer."Transaction Date" := DT2DATE(TransactionDate);;
                  MobileWithdrawalsBuffer."Account No" := AccountNo;
                  MobileWithdrawalsBuffer.Description := COPYSTR(Description,1,50);
                  MobileWithdrawalsBuffer.Amount := Amount;
                  MobileWithdrawalsBuffer."Unit ID" := 'M-PESA';
                  MobileWithdrawalsBuffer."Transaction Type" := 'Withdrawal';
                  MobileWithdrawalsBuffer."Transaction Date" := DT2DATE(TransactionDate);
                  MobileWithdrawalsBuffer.Source := MobileWithdrawalsBuffer.Source::"M-PESA";
                  MobileWithdrawalsBuffer."Beneficiary Mobile Number" := BeneficiaryMobileNumber;
                  MobileWithdrawalsBuffer."Beneficiary Name" := BeneficiaryName;
                  MobileWithdrawalsBuffer."Other Number" := OtherNumber;
                  MobileWithdrawalsBuffer.INSERT;



                  Response:='SUCCESS%&:'+SavAcc.Name;
              END
              ELSE BEGIN
                  Response:='INSUFFICIENT_BAL';
              END;
          END
          ELSE BEGIN

              MpesaTrans.INIT;
              MpesaTrans."Entry No.":=EntryCode;
              MpesaTrans."Transaction ID":=TransactionID;
              MpesaTrans."Session ID":=TransactionID;

              MpesaTrans."Paybill Account Entered" := AccEntered;

              MpesaTrans."Transaction Type" := TransactionType;
              MpesaTrans."Transaction Name" := Transaction;
              MpesaTrans.Description:=COPYSTR(Description,1,50);;
              MpesaTrans."Transaction Date":=DT2DATE(TransactionDate);
              MpesaTrans."Transaction Time":=DT2TIME(TransactionDate);
              MpesaTrans."Date Captured" := TransactionDate;
              MpesaTrans."Member Account":=AccountNo;
              MpesaTrans.Amount:=Amount;
              MpesaTrans."Fosa Account" := SavAcc."No.";
              MpesaTrans."Bosa Account" := SavAcc."BOSA Account No";
              MpesaTrans."Loan No." := LoanNo;
              MpesaTrans."Mobile No." := PhoneNo;
              MpesaTrans."Vendor Commission":=VendorCommission;
              MpesaTrans."Sacco Fee":=SaccoFee;
              MpesaTrans."Paybill Member ID" := MemberID;
              MpesaTrans."Beneficiary Mobile Number" := BeneficiaryMobileNumber;
              MpesaTrans."Beneficiary Name" := BeneficiaryName;
              MpesaTrans."Other Number" := OtherNumber;

              MpesaTrans."Savings Product" := SavingsProduct;

              MpesaTrans."Loan Product" := LoanProduct;
              MpesaTrans."Network Service Provider" := ServiceProvider;
              MpesaTrans.INSERT;

              Response:='SUCCESS';

              Response:='<Response>';
                Response+='<Status>SUCCESS</Status>';
                Response+='<StatusDescription>Success</StatusDescription>';
                Response+='<Reference>'+FORMAT(EntryCode)+'</Reference>';
              Response+='</Response>';

              //PostMpesaTransaction(TransactionID);
          END;

      END
      ELSE BEGIN
          IF TransactionType = TransactionType::"Loan Repayment" THEN BEGIN

              MpesaTrans.INIT;
              MpesaTrans."Entry No.":=EntryCode;
              MpesaTrans."Transaction ID":=TransactionID;
              MpesaTrans."Session ID":=TransactionID;
              MpesaTrans."Paybill Account Entered" := AccEntered;
              MpesaTrans."Transaction Type" := TransactionType;
              MpesaTrans."Transaction Name" := Transaction;
              MpesaTrans.Description:=COPYSTR(Description,1,50);;
              MpesaTrans."Transaction Date":=DT2DATE(TransactionDate);
              MpesaTrans."Transaction Time":=DT2TIME(TransactionDate);
              MpesaTrans."Date Captured" := TransactionDate;
              MpesaTrans."Member Account":=AccountNo;
              MpesaTrans.Amount:=Amount;
              MpesaTrans."Loan No." := LoanNo;
              MpesaTrans."Mobile No." := PhoneNo;
              MpesaTrans."Vendor Commission":=VendorCommission;
              MpesaTrans."Sacco Fee":=SaccoFee;
              MpesaTrans."Paybill Member ID" := MemberID;
              MpesaTrans."Savings Product" := SavingsProduct;
              MpesaTrans."Loan Product" := LoanProduct;
              MpesaTrans."Network Service Provider" := ServiceProvider;
              MpesaTrans."Beneficiary Mobile Number" := BeneficiaryMobileNumber;
              MpesaTrans."Beneficiary Name" := BeneficiaryName;
              MpesaTrans."Other Number" := OtherNumber;
              MpesaTrans.INSERT;

              Response:='SUCCESS';

              Response:='<Response>';
                Response+='<Status>SUCCESS</Status>';
                Response+='<StatusDescription>Success</StatusDescription>';
                Response+='<Reference>'+FORMAT(EntryCode)+'</Reference>';
              Response+='</Response>';
      //
          END
          ELSE
              ERROR('Account Not Found: %1',AccountNo);

      END;
    END;

    PROCEDURE PostMpesaTransaction@13(DocumentNo@1007 : Code[20]) Response : Text;
    VAR
      SaccoFee@1006 : Decimal;
      VendorCommission@1005 : Decimal;
      TotalCharge@1003 : Decimal;
      SavAcc@1002 : Record 23;
      SaccoAccount@1000 : Code[20];
      VendorAccount@1001 : Code[20];
      MpesaTrans@1004 : Record 51516712;
      TransAmt@1009 : Decimal;
      JTemplate@1008 : Code[10];
      JBatch@1011 : Code[10];
      DocNo@1012 : Code[20];
      PDate@1013 : Date;
      AcctType@1045 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      BalAccType@1010 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      TransType@1020 : ' ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated';
      AccNo@1019 : Code[20];
      BalAccNo@1018 : Code[20];
      SourceType@1017 : 'New Member,New Account,Loan Account Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit, Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued';
      ExtDoc@1016 : Code[20];
      LoanNo@1015 : Code[20];
      Dim1@1014 : Code[20];
      Dim2@1023 : Code[20];
      SystCreated@1024 : Boolean;
      RunBal@1025 : Decimal;
      AccBal@1026 : Decimal;
      Loans@1027 : Record 51516230;
      IntAmt@1028 : Decimal;
      PrAmt@1029 : Decimal;
      ATMTrans@1030 : Record 51516323;
      SafcomCharges@1033 : Record 51516708;
      SafcomAcc@1032 : Code[20];
      SafcomFee@1031 : Decimal;
      MobileWithdrawalsBuffer@1034 : Record 51516714;
      msg@1035 : Text;
      PrePaymentGL@1036 : Code[20];
      NewLoanBal@1037 : Decimal;
      LoanType@1038 : Record 51516240;
      LT@1039 : Text;
      AccountToCharge@1040 : Code[20];
      BillAcc@1041 : Record 23;
      IntRate@1000000000 : Decimal;
      MemberName@1042 : Text;
      Depositor@1043 : Text;
      GenSetup@1044 : Record 51516700;
      KeyW@1021 : Code[10];
      NewAcc@1022 : Code[20];
      ProdID@1046 : Code[10];
      ProdFact@1047 : Record 51516717;
      PaybillType@1048 : ' ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated';
      PhoneNo@1049 : Code[20];
      MemberAcc@1050 : Record 51516223;
      GenJournalLine@1120054000 : Record 81;
      BosaEntry@1120054001 : Boolean;
      InterestVendComm@1120054002 : Decimal;
      AccTypeName@1120054003 : Text;
      VAcc@1120054004 : Record 23;
      SkyProductSetup@1120054005 : Record 51516717;
      FilterWithProvider@1120054006 : Boolean;
      BankAccount@1120054007 : Code[30];
      MPesatransactions@1120054008 : Record 51516712;
      CreditFosa@1120054009 : Boolean;
      PenaltyAmount@1120054010 : Decimal;
      TransactionDateTime@1120054011 : DateTime;
      SendPaybillToGLAccount@1120054012 : Boolean;
      GLAccount@1120054013 : Record 15;
    BEGIN
      GenSetup.GET;
      MpesaTrans.LOCKTABLE(TRUE);
      MpesaTrans.RESET;
      MpesaTrans.SETRANGE("Transaction ID",DocumentNo);
      MpesaTrans.SETRANGE("Needs Change",FALSE);
      MpesaTrans.SETRANGE(MpesaTrans.Posted,FALSE);


      IF MpesaTrans.FINDFIRST THEN BEGIN
          GenSetup.GET;
          FilterWithProvider := FALSE;
          IF (MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::Withdrawal) OR
             (MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::"Utility Payment")  OR
             (MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::"Loan Repayment") OR
             (MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::"Bank Transfer") OR
             (MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::Paybill) THEN FilterWithProvider:=TRUE;
          // Get Excise duty G/L
          ExciseDutyGL := GetExciseDutyGL();
          ExciseDutyRate := GetExciseRate();
          ExciseDuty:=0;

          SaccoAccount:='';
          SaccoFee:=0;
          VendorAccount:='';
          VendorCommission:=0;
          SafcomAcc:='';
          SafcomFee:=0;
          PrePaymentGL := '';
          SMSAccount:='';
          SMSCharge:=0;
          AccTypeName := '';
          SendPaybillToGLAccount := FALSE;
          IF GLAccount.GET(MpesaTrans."Member Account") THEN
            SendPaybillToGLAccount := TRUE;


          CoopSetup.RESET;
          IF FilterWithProvider THEN
          CoopSetup.SETRANGE(CoopSetup."Network Service Provider",MpesaTrans."Network Service Provider");
          CoopSetup.SETRANGE("Transaction Type",MpesaTrans."Transaction Type");
          IF CoopSetup.FINDFIRST THEN BEGIN
              BankAccount := CoopSetup."Bank Account";

              SMSAccount := CoopSetup."SMS Account";
              SMSCharge := CoopSetup."SMS Charge";

              IF MpesaTrans.MobileApp THEN
                SMSCharge:=0;

              {
              IF MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::"Mpesa Withdrawal" THEN BEGIN
                  SafcomCharges.RESET;
                  SafcomCharges.SETFILTER(Charge,'>0');
                  SafcomCharges.SETFILTER(Minimum,'<%1',MpesaTrans.Amount);
                  SafcomCharges.SETFILTER(Maximum,'>%1',MpesaTrans.Amount);
                  IF SafcomCharges.FINDFIRST THEN BEGIN
                      SafcomFee:=SafcomCharges.Charge;
                  END;
              END;
              }

              PrePaymentGL := CoopSetup."Pre-Payment Account";
              SafcomAcc:=CoopSetup."Safaricom Account";
              SaccoAccount := CoopSetup."Sacco Fee Account";
              SaccoFee := CoopSetup."Sacco Fee";
              VendorAccount:=CoopSetup."Vendor Commission Account";
              VendorCommission:=CoopSetup."Vendor Commission";


              GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,SafcomFee,MpesaTrans.Amount);
              TotalCharge:=SaccoFee+VendorCommission+SafcomFee+SMSCharge;
              ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);
          END
          ELSE BEGIN
              IF MpesaTrans."Transaction Type"<>MpesaTrans."Transaction Type"::"Pay Loan From Account" THEN
              ERROR('Setup Missing for %1',MpesaTrans."Transaction Type");
          END;

          IF SavAcc.GET(MpesaTrans."Member Account") THEN BEGIN

              IF MpesaTrans."Fosa Account" = '' THEN
                  MpesaTrans."Fosa Account" := SavAcc."No.";
              IF MpesaTrans."Bosa Account" = '' THEN
                  MpesaTrans."Bosa Account" := SavAcc."BOSA Account No";

              MemberName := SavAcc.Name;
              TransAmt := MpesaTrans.Amount;
              AccountToCharge := '';

              BillAcc.RESET;
              BillAcc.SETRANGE("No.",SavAcc."No.");
              BillAcc.SETRANGE("Account Type",'ORDINARY');
              IF BillAcc.FINDFIRST THEN
                  AccountToCharge := BillAcc."No."
              ELSE BEGIN
                BillAcc.RESET;
                BillAcc.SETRANGE(BillAcc."ID No.",MpesaTrans."Paybill Member ID");
                BillAcc.SETRANGE("Account Type",'ORDINARY');
                IF BillAcc.FINDFIRST THEN
                    AccountToCharge := BillAcc."No."
              END;

              IF (MpesaTrans."Transaction Type"=MpesaTrans."Transaction Type"::"Loan Repayment") OR
                  (MpesaTrans."Transaction Type"=MpesaTrans."Transaction Type"::Paybill) OR
                  (MpesaTrans."Transaction Type"=MpesaTrans."Transaction Type"::Deposit) OR
                  (MpesaTrans."Transaction Type"=MpesaTrans."Transaction Type"::"Pay Loan From Account") OR
                  (MpesaTrans."Transaction Type"=MpesaTrans."Transaction Type"::CoopDeposit) OR
                  (MpesaTrans."Transaction Type"=MpesaTrans."Transaction Type"::"T-Kash Loan Repayment")
                  THEN
                  TransAmt:=TransAmt*-1;

              IF TransAmt >= 0 THEN BEGIN
                  IF SavAcc.Blocked = SavAcc.Blocked::All THEN BEGIN
                      MpesaTrans."Needs Change":=TRUE;
                      MpesaTrans.MODIFY;
                      EXIT;
                  END;
              END;

              IF TransAmt < 0 THEN BEGIN
                  IF (SavAcc.Blocked <> SavAcc.Blocked::" ")  THEN BEGIN
                      MpesaTrans."Needs Change":=TRUE;
                      MpesaTrans.MODIFY;
                      EXIT;
                  END;
              END;

              IF (SavAcc.Blocked = SavAcc.Blocked::All)  THEN BEGIN
                  MpesaTrans."Needs Change":=TRUE;
                  MpesaTrans.MODIFY;
                  EXIT;
              END;

      //        IF MpesaTrans."Transaction ID" = 'REH1RDHCJ3' THEN
      //             MpesaTrans."Needs Change":=TRUE;
      //             MpesaTrans.MODIFY;
      //             EXIT;

              //BUser.GET(USERID);

              //BUser.TESTFIELD("Cashier Journal Template");
              //BUser.TESTFIELD("Cashier Journal Batch");

              JTemplate:='GENERAL';
              JBatch:='SKYWORLD';

              GenJournalBatch.RESET;
              GenJournalBatch.SETRANGE("Journal Template Name",JTemplate);
              GenJournalBatch.SETRANGE(Name,JBatch);
              IF NOT GenJournalBatch.FINDFIRST THEN BEGIN
                  GenJournalBatch.INIT;
                  GenJournalBatch."Journal Template Name" := JTemplate;
                  GenJournalBatch.Name:=JBatch;
                  GenJournalBatch.Description:='Sky World Batch';
                  GenJournalBatch.INSERT;
              END;

              DocNo := MpesaTrans."Transaction ID";
              PDate := MpesaTrans."Transaction Date";
              IF PDate = 0D THEN BEGIN
                TransactionDateTime := CURRENTDATETIME;
                PDate := DT2DATE(TransactionDateTime);
                IF MpesaTrans."Date Captured" = 0DT THEN MpesaTrans."Date Captured" := TransactionDateTime;
                IF MpesaTrans."Transaction Date" = 0D THEN MpesaTrans."Transaction Date" := DT2DATE(TransactionDateTime);
                IF MpesaTrans."Transaction Time" = 0T THEN MpesaTrans."Transaction Time" := DT2TIME(TransactionDateTime);
              END;

              ;
              ExtDoc := '';
              LoanNo := '';
              TransType := TransType::" ";
              Dim1 := SavAcc."Global Dimension 1 Code";
              Dim2 := SavAcc."Global Dimension 2 Code";
              SystCreated := TRUE;
              PaybillType := PaybillType::" ";

              AccNo := MpesaTrans."Member Account";

              IF NOT SendPaybillToGLAccount THEN
              IF MpesaTrans."Transaction Type"  = MpesaTrans."Transaction Type"::Paybill THEN BEGIN
                  IF MpesaTrans."Savings Product" = '' THEN BEGIN
                      MpesaTrans."Needs Change":=TRUE;
                      MpesaTrans.MODIFY;
                      EXIT;
                  END;
                  ProdFact.RESET;
                  ProdFact.SETRANGE("Product ID",MpesaTrans."Savings Product");
                  IF ProdFact.FINDFIRST THEN BEGIN
                      PaybillType := ProdFact."Product Category";
                      MpesaTrans."Member Account" := MpesaTrans."Bosa Account";
                      MpesaTrans."Bosa Entry" := TRUE;

                      IF PaybillType = PaybillType::" " THEN
                      CreditFosa :=TRUE;//fosa deposits
                  END
                  ELSE BEGIN
                      IF NOT FosaProducts.GET(MpesaTrans."Savings Product") THEN BEGIN
                          MpesaTrans."Needs Change":=TRUE;
                          MpesaTrans.MODIFY;
                          EXIT;
                      END;
                  END;

              END;


              SaccoTrans.InitJournal(JTemplate,JBatch);


              IF MpesaTrans."Transaction Type"  = MpesaTrans."Transaction Type"::Airtime THEN BEGIN

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(MpesaTrans.Description,1,50),BalAccType::"G/L Account",
                                '',TransAmt,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,VendorAccount,COPYSTR(MpesaTrans.Description,1,50),BalAccType::"G/L Account",
                                '',-TransAmt,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");


              END
              ELSE BEGIN
                {
                  IF (MpesaTrans."Transaction Type"  = MpesaTrans."Transaction Type"::Paybill)
                    OR (MpesaTrans."Transaction Type"  = MpesaTrans."Transaction Type"::"Loan Repayment") THEN BEGIN
                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"Bank Account",CoopSetup."Bank Account",COPYSTR(MpesaTrans.Description,1,50),BalAccType::"G/L Account",
                                    '',TransAmt*-1,ExtDoc,LoanNo,PaybillType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR(MpesaTrans.Description,1,50),BalAccType::"G/L Account",
                                    '',TransAmt+VendorCommission,ExtDoc,LoanNo,PaybillType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");
                  END
                  ELSE BEGIN
                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR(MpesaTrans.Description,1,50),BalAccType::"Bank Account",
                                    CoopSetup."Bank Account",TransAmt,ExtDoc,LoanNo,PaybillType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");
                  END;
                  }

                  IF MpesaTrans."Bosa Entry" THEN BEGIN
                      IF (MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::Paybill) OR (MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::"Loan Repayment") THEN BEGIN
                         {msangi cyprian: to cater for fosa deposits}
                          IF CreditFosa THEN BEGIN
                              AcctType := AcctType::Vendor;
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType,MpesaTrans."Fosa Account",COPYSTR(MpesaTrans.Description,1,50),BalAccType::"Bank Account",
                                  BankAccount,TransAmt,ExtDoc,LoanNo,PaybillType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");
                          END ELSE BEGIN
                              AcctType := AcctType::Vendor;
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType,MpesaTrans."Fosa Account",COPYSTR(MpesaTrans.Description,1,50),BalAccType::"Bank Account",
                                  BankAccount,TransAmt,ExtDoc,LoanNo,PaybillType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                              AcctType := AcctType::Vendor;
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType,MpesaTrans."Fosa Account",COPYSTR(MpesaTrans.Description+' Transfer',1,50),BalAccType::"Bank Account",
                                  '',(TransAmt)*-1,ExtDoc,LoanNo,PaybillType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                              AcctType := AcctType::Member;
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType,MpesaTrans."Bosa Account",COPYSTR(MpesaTrans.Description,1,50),BalAccType::"Bank Account",
                                  '',(TransAmt),ExtDoc,LoanNo,PaybillType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");
                          END;

                          SkyProductSetup.RESET;
                          SkyProductSetup.SETRANGE(SkyProductSetup."Product Category",PaybillType);
                          IF SkyProductSetup.FINDFIRST THEN BEGIN
                              AccTypeName := SkyProductSetup."USSD Product Name";
                          END;

                      END
                      ELSE BEGIN
                          AcctType := AcctType::Member;
                          SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType,AccNo,COPYSTR(MpesaTrans.Description,1,50),BalAccType::"Bank Account",
                              '',TransAmt,ExtDoc,LoanNo,PaybillType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                          SkyProductSetup.RESET;
                          SkyProductSetup.SETRANGE(SkyProductSetup."Product Category",PaybillType);
                          IF SkyProductSetup.FINDFIRST THEN BEGIN
                              AccTypeName := SkyProductSetup."USSD Product Name";
                          END;
                      END;
                  END
                  ELSE BEGIN
                      AcctType := AcctType::Vendor;
                      IF VAcc.GET(AccNo) THEN
                        AccTypeName := VAcc."Account Type";

                      IF MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::"Bank Transfer" THEN BEGIN
                          //MARK BUFFER AS POSTED
                          MobileWithdrawalsBuffer.RESET;
                          MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer."Trace ID",MpesaTrans."Entry No.");
                          MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer.Source,MobileWithdrawalsBuffer.Source::"M-PESA");
                          MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer."Account No",MpesaTrans."Member Account");
                          MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer.Amount,MpesaTrans.Amount);
                          IF MobileWithdrawalsBuffer.FIND('-') THEN BEGIN
                              MpesaTrans.Description := MobileWithdrawalsBuffer.Description;
                          END;

                      END;

                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType,AccNo,COPYSTR(MpesaTrans.Description,1,50),BalAccType::"Bank Account",
                          BankAccount,TransAmt,ExtDoc,LoanNo,PaybillType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");
                  END;



                  //ERROR('PaybillType: %1',MpesaTrans."Bosa Entry");
              END;

              IF TotalCharge > 0 THEN BEGIN

                      IF (MpesaTrans."Transaction Type"  = MpesaTrans."Transaction Type"::Withdrawal)
                      OR (MpesaTrans."Transaction Type"  = MpesaTrans."Transaction Type"::"Bank Transfer") THEN
                          AccountToCharge := MpesaTrans."Fosa Account";

                  //IF (MpesaTrans."Transaction Type"  <> MpesaTrans."Transaction Type"::Paybill) AND (MpesaTrans."Transaction Type"  <> MpesaTrans."Transaction Type"::"Mpesa Deposit")
                   //   AND (MpesaTrans."Transaction Type" <> MpesaTrans."Transaction Type"::"Loan Repayment") THEN BEGIN


                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccountToCharge,COPYSTR(FORMAT(MpesaTrans."Transaction Type")+' Charge',1,50),BalAccType::"G/L Account",
                                    '',TotalCharge-SMSCharge,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccountToCharge,COPYSTR('Excise Duty '+FORMAT(MpesaTrans."Transaction Type"),1,50),BalAccType::"G/L Account",
                                    ExciseDutyGL,ROUND((SaccoFee)*ExciseDutyRate/100,1,'>'),ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                      {
                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccountToCharge,COPYSTR('Corporate Charge',1,50),BalAccType::"Bank Account",
                                    SafcomAcc,SafcomFee,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");
                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccountToCharge,COPYSTR('Transaction Charge',1,50),BalAccType::"G/L Account",
                                    SaccoAccount,SaccoFee,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");
                      }

                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"Bank Account",SafcomAcc,COPYSTR(MpesaTrans.Description+' Corporate Charge',1,50),BalAccType::"G/L Account",
                                    '',-SafcomFee,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");
                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",SaccoAccount,COPYSTR(MpesaTrans.Description+' Transaction Charge',1,50),BalAccType::"G/L Account",
                                    '',-SaccoFee,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccountToCharge,COPYSTR('SMS Charge',1,50),BalAccType::"G/L Account",
                                    SMSAccount,SMSCharge,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");
                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccountToCharge,COPYSTR('Excise Duty on SMS Charge ',1,50),BalAccType::"G/L Account",
                                    ExciseDutyGL,ROUND((SMSCharge)*ExciseDutyRate/100,1,'>'),ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");
                 // END
                 // ELSE BEGIN
                      {
                      CoopSetup.TESTFIELD("Non-Member Debit Account");
                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",CoopSetup."Non-Member Debit Account",COPYSTR('C2B Mpesa Deposit',1,50),BalAccType::"G/L Account",
                            '',VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");
                            }

      {
                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,MpesaTrans."Fosa Account",COPYSTR('C2B Mpesa Deposit',1,50),BalAccType::"G/L Account",
                            '',VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");
                            }

                  //END;


                  AccNo := VendorAccount;
                  ExtDoc := MpesaTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR('Fee on '+MpesaTrans.Description,1,50),BalAccType::"G/L Account",
                                '',-VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");



              END;

              IF MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::Paybill THEN BEGIN
                  MpesaTrans.CALCFIELDS("Line Amount");
                  IF (MpesaTrans."Line Amount" > 0) THEN BEGIN
                      IF (MpesaTrans."Line Amount" = MpesaTrans.Amount) THEN BEGIN
                          //ReceiptLine
                          RcptLine.RESET;
                          RcptLine.SETRANGE("Receipt No.",MpesaTrans."Transaction ID");
                          RcptLine.SETRANGE(Posted,FALSE);
                          IF RcptLine.FINDFIRST THEN BEGIN
                              REPEAT
                                  IF MpesaTrans."Bosa Entry" THEN
                                      AcctType := AcctType::Member
                                  ELSE
                                      AcctType := AcctType::Vendor;

                                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType,MpesaTrans."Member Account",COPYSTR(RcptLine.Description,1,50),BalAccType::"G/L Account",
                                                '',RcptLine.Amount,ExtDoc,LoanNo,PaybillType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,RcptLine."Account Type",RcptLine."Account No.",COPYSTR(RcptLine.Description,1,50),BalAccType::"G/L Account",
                                                '',-RcptLine.Amount,ExtDoc,RcptLine."Loan No",RcptLine."Transaction Type",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");
                                  RcptLine.Posted := TRUE;
                                  RcptLine.MODIFY;

                              UNTIL RcptLine.NEXT=0;
                          END;
                      END;
                  END;
              END;
              IF MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::"Loan Repayment" THEN BEGIN

                  AccBal := GetAccountBalance(SavAcc."No.");
                  AccBal := 0;
                  RunBal := AccBal + MpesaTrans.Amount;// - (TotalCharge+ExciseDuty);

                  IF RunBal>0 THEN BEGIN
                      RunBal := MpesaTrans.Amount;//-(TotalCharge+ExciseDuty);
                      Loans.RESET;
                      Loans.SETRANGE("Loan  No.",MpesaTrans."Loan No.");
                      Loans.SETRANGE("Client Code",SavAcc."BOSA Account No");
                      IF Loans.FINDFIRST THEN BEGIN
                      //kuja hapa
                          Loans.CALCFIELDS("Outstanding Balance","Oustanding Interest","Oustanding Penalty");
                          IntAmt := Loans."Oustanding Interest";
                          IF IntAmt < 0 THEN
                              IntAmt := 0;

                          PenaltyAmount := Loans."Oustanding Penalty";
                          IF PenaltyAmount < 0 THEN
                              PenaltyAmount := 0;


                          IF IntAmt > 0 THEN BEGIN


                              IF IntAmt > RunBal THEN
                                  IntAmt := RunBal;


                              InterestVendComm := 0;

                              CoopSetup.RESET;
                              IF FilterWithProvider THEN
                              CoopSetup.SETRANGE(CoopSetup."Network Service Provider",MpesaTrans."Network Service Provider");
                              CoopSetup.SETRANGE("Transaction Type",MpesaTrans."Transaction Type"::"Loan Disbursement");
                              IF CoopSetup.FINDFIRST THEN BEGIN
                                  VendorAccount:=CoopSetup."Vendor Commission Account";
                                  GetCharges(CoopSetup."Transaction Type",InterestVendComm,SaccoFee,SafcomFee,IntAmt);
                              END;

                              AccNo := MpesaTrans."Member Account";
                              ExtDoc := '';
                              LoanNo := Loans."Loan  No.";
                              TransType := TransType::"Interest Paid";
                              SystCreated := TRUE;

                              MpesaTrans."Interest Paid" := IntAmt;
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(MpesaTrans.Description,1,50),BalAccType::"G/L Account",
                                            '',IntAmt,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                              AccNo := Loans."Client Code";
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."Client Code",COPYSTR(MpesaTrans.Description,1,50),BalAccType::"G/L Account",
                                            '',-IntAmt,ExtDoc,LoanNo,TransType::"Interest Paid",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");



                              IF Loans."Mobile Loan" THEN BEGIN
                                  GenSetup.GET;
                                  GenSetup.TESTFIELD("Loan Interest Expense GL");

                                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,VendorAccount,COPYSTR('Comm. on '+MpesaTrans.Description,1,50),BalAccType::"G/L Account",
                                            '',-InterestVendComm,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",GenSetup."Loan Interest Expense GL",COPYSTR('Comm. on '+MpesaTrans.Description,1,50),BalAccType::"G/L Account",
                                                '',InterestVendComm,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                              END;

                              RunBal -= IntAmt;

                          END;

                          //PenaltyAmount paid
                          IF PenaltyAmount >0  THEN BEGIN

                              AccNo := MpesaTrans."Member Account";
                              ExtDoc := '';
                              LoanNo := Loans."Loan  No.";
                              TransType := TransType::"Penalty Paid";
                              SystCreated := TRUE;

                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(MpesaTrans.Description,1,50),BalAccType::"G/L Account",
                                            '',PenaltyAmount,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                              AccNo := Loans."Client Code";
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."Client Code",COPYSTR(MpesaTrans.Description,1,50),BalAccType::"G/L Account",
                                            '',-PenaltyAmount,ExtDoc,LoanNo,TransType::"Penalty Paid",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                          RunBal -= PenaltyAmount;
                          END;



                          IF Loans."Outstanding Balance" > 0 THEN BEGIN
                              PrAmt:=Loans."Outstanding Balance";
                              IF PrAmt > RunBal THEN
                                  PrAmt := RunBal;

                              AccNo := MpesaTrans."Member Account";
                              ExtDoc := '';
                              LoanNo := Loans."Loan  No.";
                              TransType := TransType::Repayment;
                              SystCreated := TRUE;

                              MpesaTrans."Principal Paid" := PrAmt;

                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(MpesaTrans.Description,1,50),BalAccType::"G/L Account",
                                            '',PrAmt,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                              AccNo := Loans."Client Code";
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."Client Code",COPYSTR(MpesaTrans.Description,1,50),BalAccType::"G/L Account",
                                            '',-PrAmt,ExtDoc,LoanNo,TransType::Repayment,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                              RunBal -= PrAmt;

                          END;
                          IF RunBal > 0 THEN BEGIN
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,SavAcc."No.",COPYSTR('Excess of Loan Repayment',1,50),BalAccType::"G/L Account",
                                            '',RunBal,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                              AccNo := Loans."Client Code";
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,SavAcc."BOSA Account No",COPYSTR('Excess of Loan Repayment',1,50),BalAccType::"G/L Account",
                                            '',-RunBal,ExtDoc,LoanNo,TransType::"Deposit Contribution",Dim1,Dim2,SystCreated,MpesaTrans."Client Name");
                          END;
                      END;
                  END;
              END;



              //MARK BUFFER AS POSTED
              MobileWithdrawalsBuffer.RESET;
              MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer."Trace ID",MpesaTrans."Entry No.");
              MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer.Source,MobileWithdrawalsBuffer.Source::"M-PESA");
              MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer."Account No",MpesaTrans."Member Account");
              MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer.Amount,MpesaTrans.Amount);
              IF MobileWithdrawalsBuffer.FIND('-') THEN BEGIN

                  MobileWithdrawalsBuffer.Posted:=TRUE;
                  MobileWithdrawalsBuffer."Posting Date":=TODAY;
                  MobileWithdrawalsBuffer.MODIFY;
              END;


              MpesaTrans.Posted:=TRUE;
              MpesaTrans."Posted By":=USERID;
              MpesaTrans."Date Posted":=TODAY;
              MpesaTrans.MODIFY;


              Priority:=201;
              SaccoTrans.PostJournal(JTemplate,JBatch);
              IF MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::Withdrawal THEN
                  Priority := 200;
              IF MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::"Utility Payment" THEN
                  Priority := 200;


              IF MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::"Loan Repayment" THEN BEGIN
                  IF Loans.GET(LoanNo) THEN BEGIN
                      Loans.CALCFIELDS("Outstanding Balance",Loans."Oustanding Interest","Penalty Charged");
                      LT:='';
                      IF LoanType.GET(Loans."Loan Product Type") THEN
                        LT := LoanType."USSD Product Name";
                      IF LT = '' THEN
                        LT := LoanType."Product Description";

                      NewLoanBal := ROUND(Loans."Outstanding Balance"+Loans."Oustanding Interest"+Loans."Oustanding Penalty",1,'>');
                      //NewLoanBal := 0;
                     // GetLoanNoFromProduct(Loans."Client Code",Loans."Loan Product Type",NewLoanBal);
                      msg := FORMAT(MpesaTrans."Transaction Type")+' of KES '+FORMAT(MpesaTrans.Amount)+' has been processed successfully on '+DateTimeToText(CURRENTDATETIME)+'. New '
                      +LT+' Balance is '+FORMAT(NewLoanBal)+'. REF:'+MpesaTrans."Transaction ID"
                  END;
              END
              ELSE BEGIN
                  IF MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::Paybill THEN BEGIN
                      Depositor := COPYSTR(MpesaTrans.Description,24,STRLEN(MpesaTrans.Description));
                      //MemberName
                      msg :='Dear Member, '+Depositor+' has deposited KES '+FORMAT(MpesaTrans.Amount)+
                                ' to your '+AccTypeName+' account on '+FORMAT(TODAY)+' at '+FORMAT(TIME)+'. REF:'+MpesaTrans."Transaction ID";
                  END
                  ELSE BEGIN
                      IF MpesaTrans."Other Number" THEN BEGIN
                        msg := FORMAT(MpesaTrans."Transaction Type")+' of KES '+FORMAT(MpesaTrans.Amount)+' to ' + MpesaTrans."Beneficiary Name" +' ('+ MpesaTrans."Beneficiary Mobile Number" +') has been processed successfully. ';
                        msg += 'Date '+ DateTimeToText(CURRENTDATETIME)+'. REF: '+MpesaTrans."Transaction ID"
                      END ELSE BEGIN
                        msg := FORMAT(MpesaTrans."Transaction Type")+' of KES '+FORMAT(MpesaTrans.Amount)+' has been processed successfully on '+DateTimeToText(CURRENTDATETIME)+'. REF:'+MpesaTrans."Transaction ID"
                      END;
                  END;
              END;

              PhoneNo := SavAcc."Transactional Mobile No";
              IF PhoneNo = '' THEN
                  PhoneNo := SavAcc."Mobile Phone No";

              IF PhoneNo = '' THEN PhoneNo := MpesaTrans."Mobile No.";
              //MESSAGE('TransNo: %1\ PhoneNo %2\No: %3',SavAcc."Transactional Mobile No",PhoneNo,SavAcc."No.");

              IF (MpesaTrans."Transaction Type" <> MpesaTrans."Transaction Type"::"Mini-Statement") AND (MpesaTrans."Transaction Type" <> MpesaTrans."Transaction Type"::"Balance Enquiry") THEN
                  IF (MpesaTrans."Transaction Type" <> MpesaTrans."Transaction Type"::"Mobile App Login") THEN
                      SendSms(Source::MBANKING,PhoneNo,msg,FORMAT(MpesaTrans."Transaction ID"),'',FALSE,Priority,FALSE);

          END
          ELSE BEGIN

              IF MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::Paybill THEN BEGIN

                IF (MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::Paybill) AND (SendPaybillToGLAccount)  THEN BEGIN
                  JTemplate:='GENERAL';
                  JBatch:='SKYWORLD';

                  GenJournalBatch.RESET;
                  GenJournalBatch.SETRANGE("Journal Template Name",JTemplate);
                  GenJournalBatch.SETRANGE(Name,JBatch);
                  IF NOT GenJournalBatch.FINDFIRST THEN BEGIN
                      GenJournalBatch.INIT;
                      GenJournalBatch."Journal Template Name" := JTemplate;
                      GenJournalBatch.Name:=JBatch;
                      GenJournalBatch.Description:='Sky World Batch';
                      GenJournalBatch.INSERT;
                  END;
                  PDate := MpesaTrans."Transaction Date";
                  AcctType := AcctType::"G/L Account";
                  DocNo := MpesaTrans."Transaction ID";
                  ExtDoc := MpesaTrans."Transaction ID";
                  LoanNo := '';
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType,MpesaTrans."Member Account",COPYSTR(MpesaTrans.Description,1,50),BalAccType::"Bank Account",
                    BankAccount,-MpesaTrans.Amount,ExtDoc,LoanNo,PaybillType,Dim1,Dim2,SystCreated,MpesaTrans."Client Name");

                  IF DocumentNo <> 'BAL002' THEN BEGIN
                    SaccoTrans.PostJournal(JTemplate,JBatch);
                  END;

                  MpesaTrans.Posted:=TRUE;
                  MpesaTrans."Posted By":=USERID;
                  MpesaTrans."Date Posted":=TODAY;
                  MpesaTrans.MODIFY;

                EXIT;
              END;

                  SavAcc.RESET;
                  SavAcc.SETRANGE("ID No.",MpesaTrans."Member Account");
                  SavAcc.SETRANGE("Account Type",'ORDINARY');
                  IF SavAcc.FINDFIRST THEN BEGIN
                      MpesaTrans."Member Account" := SavAcc."No.";
                      MpesaTrans."Paybill Member ID" := SavAcc."ID No.";
                      MpesaTrans.MODIFY;

                  END
                  ELSE BEGIN
                      KeyW := '';
                      NewAcc := '';
                      ProdID := '';
                      SplitKeyWord(MpesaTrans."Member Account",KeyW,ProdID,NewAcc);
                      IF NewAcc <> '' THEN BEGIN
                          Members.GET(NewAcc);
                          SavAcc.GET(Members."FOSA Account");
                          MpesaTrans."Member Account" := SavAcc."No.";
                          MpesaTrans."Paybill Member ID" := SavAcc."ID No.";
                          MpesaTrans."Savings Product" := ProdID;
                          MpesaTrans.MODIFY;

                      END
                      ELSE BEGIN
                          MpesaTrans."Needs Change":=TRUE;
                          MpesaTrans.MODIFY;

                      END;
                  END;
              END
              ELSE IF MpesaTrans."Transaction Type" = MpesaTrans."Transaction Type"::"Loan Repayment" THEN BEGIN


                  IF (COPYSTR(MpesaTrans."Member Account",1,4) = 'LOAN') OR Loans.GET(MpesaTrans."Member Account") THEN BEGIN


                      IF Loans.GET(MpesaTrans."Member Account") THEN
                          LoanNo := Loans."Loan  No."
                      ELSE
                          LoanNo := COPYSTR(MpesaTrans."Member Account",5,STRLEN(MpesaTrans."Member Account"));



                      IF Loans.GET(LoanNo) THEN BEGIN



                          MpesaTrans."Needs Change" := FALSE;
                          MpesaTrans."Transaction Type" := MpesaTrans."Transaction Type"::"Loan Repayment";
                          MpesaTrans.Description := 'Loan Repayment';
                          MpesaTrans."Member Account":=Loans."Account No";

                          IF NOT SavAcc.GET(Loans."Account No") THEN
                              IF Members.GET(Loans."Account No") THEN
                                  MpesaTrans."Member Account" := Members."FOSA Account";

                          MpesaTrans."Loan No." := Loans."Loan  No.";
                          MpesaTrans."Loan Product" := Loans."Loan Product Type";
                          MpesaTrans.MODIFY;

                      END
                      ELSE BEGIN
                          MpesaTrans."Needs Change":=TRUE;
                          MpesaTrans.MODIFY;
                      END;
                  END

                  ELSE BEGIN
                      MpesaTrans."Needs Change":=TRUE;
                      MpesaTrans.MODIFY;
                  END;
              END
              ELSE BEGIN
                  MpesaTrans."Needs Change":=TRUE;
                  MpesaTrans.MODIFY;
              END;
          END;
      END;
    END;

    PROCEDURE GetAccountBalance@1102755001(Account@1102755000 : Text[30]) AccountBal : Decimal;
    VAR
      savAccList@1000 : Record 23;
      AccountTypes@1002 : Record 51516295;
      MNo@1003 : Code[20];
      AccLength@1004 : Integer;
      ProductID@1005 : Code[20];
    BEGIN

      AccountBal:=0;

      AccountBal:=0;
      savAccList.RESET;
      savAccList.SETRANGE("No.",Account);
      IF savAccList.FIND('-') THEN BEGIN
          savAccList.CALCFIELDS("Mpesa Withdrawals","Balance (LCY)","EFT Transactions","ATM Transactions","Uncleared Cheques",savAccList."Authorised Over Draft",savAccList."Coop Transaction");
          IF AccountTypes.GET(savAccList."Account Type") THEN BEGIN
              AccountBal:=(savAccList."Balance (LCY)"+savAccList."Authorised Over Draft")
                            - AccountTypes."Minimum Balance"
                            - savAccList."EFT Transactions"
                            - savAccList."Uncleared Cheques"
                            - savAccList."Mpesa Withdrawals"
                            - savAccList."Coop Transaction"
                            - savAccList."ATM Transactions";

          END;
      END;
      EXIT(AccountBal);
    END;

    PROCEDURE AccountMiniStatement@4(EntryCode@1010 : GUID;TransactionID@1102755001 : Code[20];MaxNumberRows@1042 : Integer;StatementAccount@1038 : Code[20];MobileNo@1039 : Code[20];Pin@1040 : Text) Response : Text;
    VAR
      SaccoFee@1005 : Decimal;
      VendorCommission@1004 : Decimal;
      TotalCharge@1003 : Decimal;
      SavAcc@1002 : Record 23;
      SaccoAccount@1001 : Code[20];
      VendorAccount@1000 : Code[20];
      PhoneNo@1006 : Code[20];
      AccBal@1007 : Decimal;
      JTemplate@1009 : Code[10];
      JBatch@1012 : Code[10];
      MobileTrans@1013 : Record 51516712;
      DocNo@1027 : Code[20];
      PDate@1026 : Date;
      AcctType@1025 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      BalAccType@1024 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      TransType@1023 : ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal';
      AccNo@1022 : Code[20];
      BalAccNo@1021 : Code[20];
      SourceType@1020 : 'New Member,New Account,Loan Account Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit, Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued';
      ExtDoc@1019 : Code[20];
      LoanNo@1018 : Code[20];
      Dim1@1017 : Code[10];
      Dim2@1016 : Code[10];
      SystCreated@1014 : Boolean;
      SLedger@1028 : Record 25;
      LedgerCount@1029 : Integer;
      CurrRecord@1030 : Integer;
      DFilter@1031 : Text;
      DebitCreditFlag@1032 : Code[10];
      FirstEntry@1033 : Boolean;
      ProdFact@1036 : Record 51516717;
      TransactionDate@1011 : DateTime;
      Msg@1015 : Text;
      Stmt@1037 : Text;
      AccountToCharge@1034 : Code[20];
      MemberNo@1041 : Code[20];
      StmtProduct@1008 : Code[20];
      StmtMemberNo@1035 : Code[20];
      BosaEntry@1120054000 : Boolean;
      MLedger@1120054001 : Record 51516224;
      SafCom@1120054002 : Decimal;
    BEGIN

      TransactionDate:=CURRENTDATETIME;
      MobileNo:='+'+MobileNo;

      Response:='ERROR';

      IF NOT CorrectPin(MobileNo,Pin) THEN BEGIN
          Response := 'INCORRECT_PIN';
          EXIT;
      END;


      // Get Excise duty G/L
      ExciseDutyGL := GetExciseDutyGL();
      ExciseDutyRate := GetExciseRate();
      ExciseDuty:=0;

      SaccoAccount:='';
      SaccoFee:=0;
      VendorAccount:='';
      VendorCommission:=0;

      MemberNo:='';

      AccountToCharge:='';


      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
      IF SavAcc.FINDFIRST THEN BEGIN
        MemberNo := SavAcc."BOSA Account No";
        AccountToCharge := SavAcc."No.";
      END;


      IF SavAcc.Blocked<>SavAcc.Blocked::" " THEN
        EXIT;

      StmtProduct := '';
      StmtMemberNo := '';

      IF SavAcc.GET(StatementAccount) THEN BEGIN
          StmtProduct := SavAcc."Account Type";
          StmtMemberNo := SavAcc."BOSA Account No";
          BosaEntry := FALSE;
      END
      ELSE BEGIN


          SplitAccount(StatementAccount,StmtProduct,StmtMemberNo);
          BosaEntry := TRUE;
      END;

      IF StmtMemberNo <> MemberNo THEN
          ERROR('Invalid Statement Account: %1-%2',StmtProduct,StmtMemberNo);


      IF StmtProduct = '' THEN
          ERROR('Invalid Statement Product');




      SMSAccount:='';
      SMSCharge:=0;

      CoopSetup.RESET;
      CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Mini-Statement");
      IF CoopSetup.FINDFIRST THEN BEGIN

          SMSAccount := CoopSetup."SMS Account";
          SMSCharge := CoopSetup."SMS Charge";


          SaccoAccount := CoopSetup."Sacco Fee Account";
          SaccoFee := CoopSetup."Sacco Fee";
          VendorAccount:=CoopSetup."Vendor Commission Account";
          VendorCommission:=CoopSetup."Vendor Commission";

          GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,SafCom,0);
          TotalCharge:=SaccoFee+VendorCommission+SMSCharge;
          ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);
      END
      ELSE BEGIN
          ERROR('Setup Missing for %1',CoopSetup."Transaction Type");
      END;


      //PhoneNo:='+'+MobileNo;

      SavAcc.RESET;
      SavAcc.SETRANGE("No.",AccountToCharge);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FINDFIRST THEN BEGIN



         {
          IF (ProdFact."Mobile Transaction" = ProdFact."Mobile Transaction"::"Deposits Only") OR
              (ProdFact."Mobile Transaction" = ProdFact."Mobile Transaction"::" ") THEN BEGIN
              ERROR('The Account to Charge is not a Withdrawable Account');
          END;
          }


          AccBal := GetAccountBalance(SavAcc."No.");

          IF AccBal >= TotalCharge+ExciseDuty THEN BEGIN

              //BUser.GET(USERID);

              //BUser.TESTFIELD("Cashier Journal Template");
              //BUser.TESTFIELD("Cashier Journal Batch");

              JTemplate:='GENERAL';
              JBatch:='SKYWORLD';

              GenJournalBatch.RESET;
              GenJournalBatch.SETRANGE("Journal Template Name",JTemplate);
              GenJournalBatch.SETRANGE(Name,JBatch);
              IF NOT GenJournalBatch.FINDFIRST THEN BEGIN
                  GenJournalBatch.INIT;
                  GenJournalBatch."Journal Template Name" := JTemplate;
                  GenJournalBatch.Name:=JBatch;
                  GenJournalBatch.Description:='Sky World Batch';
                  GenJournalBatch.INSERT;
              END;


              MobileTrans.INIT;
              MobileTrans."Entry No." := EntryCode;
              MobileTrans."Transaction ID":=TransactionID;
              MobileTrans."Session ID":=TransactionID;
              MobileTrans."Transaction Date":=DT2DATE(TransactionDate);
              MobileTrans."Transaction Time":=DT2TIME(TransactionDate);
              MobileTrans."Date Captured" := TransactionDate;
              MobileTrans."Member Account":=SavAcc."No.";
              MobileTrans."Vendor Commission" := VendorCommission;
              MobileTrans."Sacco Fee":=SaccoFee;
              MobileTrans."Statement Max Rows":=MaxNumberRows;
              //MobileTrans."Statement Start Date":=StartDate;
              //MobileTrans."Statement End Date":=EndDate;
              MobileTrans."Account to Check":=StatementAccount;
              MobileTrans."Transaction Type":=MobileTrans."Transaction Type"::"Mini-Statement";
              MobileTrans."Savings Product" := StmtProduct;
              MobileTrans."Bosa Entry" := FALSE;
              MobileTrans.Description:=FORMAT(MobileTrans."Transaction Type");
              MobileTrans.INSERT;
              //MESSAGE('%1',BosaEntry);
              {
              MobileTrans.RESET;
              MobileTrans.SETRANGE("Transaction ID",TransactionID);
              MobileTrans.SETRANGE(Posted,FALSE);
              IF MobileTrans.FINDFIRST THEN BEGIN

                  DocNo := MobileTrans."Transaction ID";
                  PDate := MobileTrans."Transaction Date";
                  AccNo := MobileTrans."Member Account";
                  ExtDoc := '';
                  LoanNo := '';
                  TransType := TransType::" ";
                  Dim1 := SavAcc."Global Dimension 1 Code";
                  Dim2 := SavAcc."Global Dimension 2 Code";
                  SystCreated := TRUE;

                  SaccoTrans.InitJournal(JTemplate,JBatch);


                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                '',VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccountToCharge,COPYSTR('SMS Charge',1,50),BalAccType::"G/L Account",
                                SMSAccount,SMSCharge,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR('Sacco Fee ',1,50),BalAccType::"G/L Account",
                                '',SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR('Excise Duty ',1,50),BalAccType::"G/L Account",
                                ExciseDutyGL,ExciseDuty,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  AccNo := VendorAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(MobileTrans.Description+' Commission',1,50),BalAccType::"G/L Account",
                                '',-VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  AccNo := SaccoAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",AccNo,COPYSTR(MobileTrans.Description+' Fee',1,50),BalAccType::"G/L Account",
                                '',-SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  MobileTrans.Posted:=TRUE;
                  MobileTrans."Posted By":=USERID;
                  MobileTrans."Date Posted":=TODAY;
                  MobileTrans.MODIFY;

                  SaccoTrans.PostJournal(JTemplate,JBatch);

              END
              ELSE BEGIN
                  ERROR('Transaction Not Found');
              END;
              }

          END
          ELSE BEGIN
              Response:='INSUFFICIENT_BAL';
          END;


          IF Response='ERROR' THEN BEGIN

              MobileTrans.RESET;
              MobileTrans.SETRANGE("Transaction ID",TransactionID);
              //MobileTrans.SETRANGE(Posted,TRUE);
              IF MobileTrans.FINDFIRST THEN BEGIN
                  IF BosaEntry THEN BEGIN
                      MLedger.RESET;
                      MLedger.SETCURRENTKEY("Posting Date");
                      MLedger.ASCENDING(FALSE);
                      MLedger.SETRANGE("Customer No.",StmtMemberNo);
                      MLedger.SETRANGE(Reversed,FALSE);
                      IF MLedger.FINDFIRST THEN BEGIN
                          AccBal:=0;
                          Msg := '';
                          REPEAT
                              LedgerCount+=1;

                              Stmt := '['+FORMAT(MLedger."Posting Date")+';'+MLedger.Description+';'+FORMAT(MLedger."Amount (LCY)"*-1)+']';
                              IF STRLEN(Msg+Stmt)<150 THEN BEGIN
                                  Msg+=Stmt;
                              END;

                          UNTIL (MLedger.NEXT=0) OR (MLedger.COUNT=MaxNumberRows);

                          Priority:=203;
                          SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",Msg,AccountToCharge,'',TRUE,Priority,FALSE);

                          Response:='SUCCESS';
                      END;

                  END
                  ELSE BEGIN
                      SLedger.RESET;
                      SLedger.SETCURRENTKEY("Posting Date");
                      SLedger.ASCENDING(FALSE);
                      SLedger.SETRANGE("Vendor No.",StatementAccount);
                      SLedger.SETRANGE(Reversed,FALSE);
                      IF SLedger.FINDFIRST THEN BEGIN
                          AccBal:=0;
                          Msg := '';
                          REPEAT
                              LedgerCount+=1;
                              SLedger.CALCFIELDS("Amount (LCY)");
                              Stmt := '['+FORMAT(SLedger."Posting Date")+';'+SLedger.Description+';'+FORMAT(SLedger."Amount (LCY)"*-1)+']';
                              IF STRLEN(Msg+Stmt)<150 THEN BEGIN
                                  Msg+=Stmt;
                              END;

                          UNTIL (SLedger.NEXT=0) OR (SLedger.COUNT=MaxNumberRows);

                          Priority:=203;
                          SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",Msg,StatementAccount,'',TRUE,Priority,FALSE);

                          Response:='SUCCESS';
                      END;
                  END;
              END;
          END;
      END
      ELSE BEGIN
          Response := 'INVALID_ACCOUNT';
      END;
    END;

    PROCEDURE AccountBalanceAsAt@14(Account@1102755000 : Text[30];AsAt@1004 : Date) AccountBal : Decimal;
    VAR
      savAccList@1000 : Record 23;
      AccountTypes@1002 : Record 51516295;
      MNo@1003 : Code[20];
      AccLength@1005 : Integer;
      ProductID@1001 : Code[20];
    BEGIN

      AccountBal:=0;
      savAccList.RESET;
      savAccList.SETRANGE("No.",Account);
      savAccList.SETFILTER("Date Filter",'..%1',AsAt);
      IF savAccList.FIND('-') THEN BEGIN
      //    savAccList.CALCFIELDS("Balance (LCY)","Mobile Withdrawals");
          IF AccountTypes.GET(savAccList."Account Type") THEN BEGIN
              AccountBal:=(savAccList."Balance (LCY)"+savAccList."Authorised Over Draft")
                            - AccountTypes."Minimum Balance"
                            - savAccList."Uncleared Cheques"
                            - savAccList."ATM Transactions";

          END;
      END;
      EXIT(AccountBal);
    END;

    PROCEDURE GetAllLoansList@39() Response : Text;
    VAR
      MobileNo@1001 : Code[20];
      Loans@1002 : Record 51516230;
      LoanProduct@1003 : Record 51516240;
      SavAcc@1004 : Record 23;
      MemberNo@1005 : Code[20];
      MaxLoan@1006 : Decimal;
    BEGIN
      Response:='';
      LoanProduct.RESET;
      IF LoanProduct.FIND('-') THEN BEGIN
          Response:='<Loans>';
          REPEAT
              Response += '<Product>';
                Response += '<Code>'+LoanProduct.Code+'</Code>';
                Response += '<ProductType>'+LoanProduct."USSD Product Name"+'</ProductType>';
              Response += '</Product>';
          UNTIL LoanProduct.NEXT=0;
          Response+='</Loans>';
      END;
    END;

    PROCEDURE GetMobileLoanList@8(Phone@1000 : Code[20];Category@1120054006 : Code[30]) Response : Text;
    VAR
      MobileNo@1001 : Code[20];
      Loans@1002 : Record 51516230;
      LoanProduct@1003 : Record 51516240;
      SavAcc@1004 : Record 23;
      MemberNo@1005 : Code[20];
      MaxLoan@1006 : Decimal;
      Cust@1007 : Record 51516223;
      SkipLoan@1120054001 : Boolean;
      Msg@1120054002 : Text;
      MobileLoanInstallments@1120054003 : Record 51516832;
      MinLoan@1120054004 : Decimal;
      "Mobile Max. Guarantors"@1120054005 : Integer;
      LoanType@1120054000 : Code[30];
      LoanLimit@1120054007 : Decimal;
      Runcode@1120054008 : Boolean;
    BEGIN

      MobileNo:='+'+Phone;

      Response:='';
      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FINDFIRST THEN BEGIN



          MemberNo := SavAcc."BOSA Account No";

          LoanProduct.RESET;
          LoanProduct.SETRANGE(AvailableOnMobile,TRUE);
          IF LoanProduct.FIND('-') THEN BEGIN
              Response+='<Loans>';
              REPEAT

                  MaxLoan := ROUND(MaxLoan,1000,'<');
                  MinLoan := ROUND(MinLoan,1000,'<');
                  IF MaxLoan > LoanProduct."Max. Loan Amount" THEN
                   MaxLoan :=  LoanProduct."Min. Loan Amount";

      //           Cust.GET(MemberNo);
      //
      //               SkipLoan:=TRUE;
      //               InsiderLendings2.RESET;
      //               InsiderLendings2.SETRANGE(InsiderLendings2."Product Code",LoanProduct.Code);
      //               IF InsiderLendings2.FINDFIRST THEN BEGIN
      //                 REPEAT
      //                   IF Cust."Insider Classification" = InsiderLendings2."Insider Classifications" THEN
      //                     SkipLoan:=FALSE;
      //                 UNTIL (InsiderLendings2.NEXT=0) OR (SkipLoan=FALSE);
      //               END ELSE BEGIN
      //                 SkipLoan := FALSE;
      //               END;

                    IF (NOT SkipLoan){ OR ((LoanProduct."Restrict to Insider Classif." = LoanProduct."Restrict to Insider Classif."::"  ") OR (LoanProduct."Restrict to Insider Classif." = Cust."Insider Classification"))} THEN BEGIN
                      Response += '<Product>';
                      Response += '<Code>'+LoanProduct.Code+'</Code>';
                      Response += '<Type>'+LoanProduct."USSD Product Name"+'</Type>';

                      IF LoanProduct."salary Earner" THEN BEGIN

                            Response += '<UserCanApply>'+'TRUE'+'</UserCanApply>'
                        //END;
                        END
                        ELSE BEGIN
                           // IF Msg = ChannelThroughFosa THEN
                              Response += '<UserCanApply>'+'TRUE'+'</UserCanApply>'
                          //  ELSE
                           //   Response += '<UserCanApply>'+'TRUE'+'</UserCanApply>'

                        END;


                        Response += '<Message>'+Msg+'</Message>';

                        IF LoanProduct.Source = LoanProduct.Source::BOSA THEN
                          Response += '<Source>'+'BOSA'+'</Source>'
                        ELSE IF LoanProduct.Source = LoanProduct.Source::FOSA THEN
                          Response += '<Source>'+'FOSA'+'</Source>';


                        IF LoanProduct."Mobile Loan Req. Guar." THEN
                          Response += '<RequiresGuarantors>'+'TRUE'+'</RequiresGuarantors>'
                        ELSE
                          Response += '<RequiresGuarantors>'+'FALSE'+'</RequiresGuarantors>';


                        IF LoanProduct."Requires Purpose" THEN
                          Response += '<RequiresPurpose>'+'TRUE'+'</RequiresPurpose>'
                        ELSE
                          Response += '<RequiresPurpose>'+'FALSE'+'</RequiresPurpose>';


                        IF LoanProduct."Requires Branch" THEN
                          Response += '<RequiresBranch>'+'TRUE'+'</RequiresBranch>'
                        ELSE
                          Response += '<RequiresBranch>'+'FALSE'+'</RequiresBranch>';

                        IF LoanProduct."Mobile Installments Type" = LoanProduct."Mobile Installments Type"::None THEN
                          Response += '<InstallmentsType>'+'NONE'+'</InstallmentsType>'
                        ELSE IF LoanProduct."Mobile Installments Type" = LoanProduct."Mobile Installments Type"::Input THEN
                          Response += '<InstallmentsType>'+'INPUT'+'</InstallmentsType>'
                        ELSE IF LoanProduct."Mobile Installments Type" = LoanProduct."Mobile Installments Type"::Preset THEN
                          Response += '<InstallmentsType>'+'PRESET'+'</InstallmentsType>';



                        IF LoanProduct."Mobile Installments Type" = LoanProduct."Mobile Installments Type"::None THEN BEGIN
                          Response += '<InputInstallments>';
                              Response += '<Minimum>'+FORMAT(LoanProduct."Ordinary Default Intallments")+'</Minimum>';
                              Response += '<Maximum>'+FORMAT(LoanProduct."Ordinary Default Intallments")+'</Maximum>';
                          Response += '</InputInstallments>';
                        END;

                        IF LoanProduct."Mobile Installments Type" = LoanProduct."Mobile Installments Type"::Input THEN BEGIN
                          Response += '<InputInstallments>';
                              Response += '<Minimum>'+FORMAT(LoanProduct."Min. Mobile Installments")+'</Minimum>';
                              Response += '<Maximum>'+FORMAT(LoanProduct."Max. Mobile Installments")+'</Maximum>';
                          Response += '</InputInstallments>';
                        END;

                        IF LoanProduct."Mobile Installments Type" = LoanProduct."Mobile Installments Type"::Preset THEN BEGIN

                              MobileLoanInstallments.RESET;
                              MobileLoanInstallments.SETRANGE(Product,LoanProduct.Code);
                              IF MobileLoanInstallments.FINDFIRST THEN BEGIN
                                  Response += '<PresetInstallments>';
                                  REPEAT

                                      Response += '<Installment Id="'+FORMAT(MobileLoanInstallments.Installments)+'" Label="'+FORMAT(MobileLoanInstallments.Caption)+'">';

                                          Response += '<Qualification>';
                                              Response += '<Minimum>'+FORMAT(MinLoan)+'</Minimum>';
                                              IF LoanProduct.Source = LoanProduct.Source::BOSA THEN
                                                  Response += '<Maximum>'+FORMAT(MaxLoan)+'</Maximum>'
                                              ELSE
                                                  Response += '<Maximum>'+FORMAT(MaxLoan)+'</Maximum>';
                                          Response += '</Qualification>';

                                      Response += '</Installment>';

                                  UNTIL MobileLoanInstallments.NEXT=0;
                                  Response += '</PresetInstallments>';
                              END;

                        END;
                        Response += '<NumberOfGuarantors>';
                            Response += '<Minimum>'+FORMAT(LoanProduct."Mobile Min. Guarantors")+'</Minimum>';
                            Response += '<Maximum>'+FORMAT(LoanProduct."Mobile Max. Guarantors")+'</Maximum>';
                        Response += '</NumberOfGuarantors>';


                        Response += '<DefaultQualification>';
                            Response += '<Minimum>'+FORMAT(MinLoan)+'</Minimum>';
                            Response += '<Maximum>'+FORMAT(MaxLoan)+'</Maximum>';
                        Response += '</DefaultQualification>';

                        IF LoanProduct."Requires TnC" THEN
                          Response += '<RequiresTnC>'+'TRUE'+'</RequiresTnC>'
                        ELSE
                          Response += '<RequiresTnC>'+'FALSE'+'</RequiresTnC>';

                        IF LoanProduct."Shows Mobile Qualification" THEN
                          Response += '<ShowsQualification>'+'TRUE'+'</ShowsQualification>'
                        ELSE
                          Response += '<ShowsQualification>'+'FALSE'+'</ShowsQualification>';

                        IF LoanProduct."Requires Payslip PIN" THEN
                          Response += '<RequiresPayslipPIN>'+'TRUE'+'</RequiresPayslipPIN>'
                        ELSE
                          Response += '<RequiresPayslipPIN>'+'FALSE'+'</RequiresPayslipPIN>';



                      Response += '</Product>';
                  //END;
                  END;

              UNTIL LoanProduct.NEXT=0;
              Response+='</Loans>';

      //             IF (LoanProduct."Restrict to Emp. Code" = '') OR (LoanProduct."Restrict to Emp. Code" = Cust."Employer Code") THEN BEGIN
      //                 IF LoanProduct."salary Earner" THEN BEGIN
      //                     IF (SavAcc."Salary earner")  OR (Cust."Employer Code" = 'STAFF') THEN BEGIN
      //                         Response += '<Product>';
      //                           Response += '<Code>'+LoanProduct.Code+'</Code>';
      //                           Response += '<ProductType>'+LoanProduct."USSD Product Name"+'</ProductType>';
      //                         Response += '</Product>';
      //                     END;
      //                 END ELSE BEGIN
      //                     Response += '<Product>';
      //                       Response += '<Code>'+LoanProduct.Code+'</Code>';
      //                       Response += '<ProductType>'+LoanProduct."USSD Product Name"+'</ProductType>';
      //                     Response += '</Product>';
      //                 END;
      //             END;
      //
      //
      //
      //         UNTIL LoanProduct.NEXT=0;
      //
      //         Response += '<Product>';
      //           Response += '<Code>'+'M_OD'+'</Code>';
      //           Response += '<ProductType>'+'Overdraft'+'</ProductType>';
      //         Response += '</Product>';
      //         Response+='</Loans>';
          END;

      END;
    END;

    PROCEDURE ApplyLoan@22(EntryCode@1014 : Text;TransactionID@1013 : Code[20];Phone@1000 : Code[20];LoanType@1006 : Code[20];LoanAmount@1007 : Decimal;Duration@1120054000 : Integer;PIN@1015 : Text;LoanPeriod@1120054013 : Integer;LoanPurpose@1120054014 : Code[30];Password@1120054015 : Text;Branch@1120054016 : Text) Response : Text;
    VAR
      MobileNo@1001 : Code[20];
      Loans@1002 : Record 51516230;
      LoanProduct@1003 : Record 51516240;
      SavAcc@1004 : Record 23;
      MemberNo@1005 : Code[20];
      MaxLoan@1008 : Decimal;
      LoanAccountNo@1010 : Code[20];
      MobileLoans@1012 : Record 51516713;
      Members@1017 : Record 51516223;
      SkyBlackListedAccountNos@1120054001 : Record 51516706;
      AccountNo@1120054002 : Code[30];
      SalaryLoans@1120054003 : Record 51516230;
      SameLoanOutstandingBal@1120054004 : Decimal;
      VendorCommission@1120054005 : Decimal;
      SaccoFee@1120054006 : Decimal;
      Safcom@1120054007 : Decimal;
      TotalCharge@1120054008 : Decimal;
      UpfrontInterest@1120054009 : Decimal;
      LoanLimit@1120054010 : Decimal;
      SaccoEmployers@1120054011 : Record 51516260;
      employercode@1120054012 : Code[30];
    BEGIN
      MobileNo:='+'+Phone;

      Response:='ERROR';

      IF NOT CorrectPin(MobileNo,PIN) THEN BEGIN
          Response := 'INCORRECT_PIN';
          EXIT;
      END;

      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);

      IF SavAcc.FINDFIRST THEN BEGIN

          MemberNo := SavAcc."BOSA Account No";

          Members.GET(MemberNo);

          SalaryLoans.RESET;
          SalaryLoans.SETRANGE(SalaryLoans."Client Code",Members."No.");
          SalaryLoans.SETRANGE(SalaryLoans."Loan Product Type",LoanType);
          SalaryLoans.SETFILTER(SalaryLoans."Outstanding Balance",'>0');
          IF SalaryLoans.FINDFIRST THEN  BEGIN
            REPEAT
              SalaryLoans.CALCFIELDS(SalaryLoans."Outstanding Balance");
              SameLoanOutstandingBal += SalaryLoans."Outstanding Balance";
            UNTIL SalaryLoans.NEXT = 0;
          END;

          CoopSetup.RESET;
          CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Loan Disbursement");
          IF CoopSetup.FINDFIRST THEN BEGIN
              GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,Safcom,0);
              TotalCharge:=SaccoFee+VendorCommission;
          END;
          IF LoanProduct."Interest Recovered Upfront" = TRUE THEN BEGIN
          IF LoanProduct.GET(LoanType) THEN
          UpfrontInterest:=ROUND(Duration * LoanAmount*LoanProduct."Interest rate"/1200,1,'>');

           IF (LoanAmount - (UpfrontInterest+SameLoanOutstandingBal+TotalCharge)) < LoanProduct."Min. Loan Amount" THEN BEGIN
              Response := 'Net take home of KES '+FORMAT(LoanAmount - (UpfrontInterest+SameLoanOutstandingBal+TotalCharge))+
              ' is less than minimum loan limit of KES '+FORMAT(LoanProduct."Min. Loan Amount");
              EXIT;
          END;
          END;
          IF LoanProduct.Code = 'A03' THEN BEGIN
          GetLoanQualifiedAmount(SavAcc."No.",LoanType,Response,LoanLimit);
            END
            ELSE IF LoanProduct.Code = 'A01' THEN BEGIN
          GetSalaryLoanQualifiedAmount(SavAcc."No.",LoanType,LoanLimit,Response);
            END
            ELSE IF LoanProduct.Code = 'A10' THEN BEGIN
          GetReloadedLoanQualifiedAmount(SavAcc."No.",LoanType,LoanLimit,Response);
            END
            ELSE IF LoanProduct.Code = 'M_OD' THEN BEGIN
          GetOverdraftLoanQualifiedAmount(SavAcc."No.",LoanType,LoanLimit,Response);
            END;

          IF (LoanProduct.GET(LoanType)) AND ((LoanType = 'A16') OR (LoanType = 'A01') OR (LoanType = 'A10')OR(LoanType = 'M_OD')) THEN BEGIN
             IF LoanAmount < LoanProduct."Min. Loan Amount" THEN BEGIN
                Response := 'Applied amount is less than the loan limit of KES '+ FORMAT(LoanProduct."Min. Loan Amount");
                EXIT;
              END;

              IF LoanAmount <= (SameLoanOutstandingBal+TotalCharge+UpfrontInterest) THEN BEGIN
                  Response := 'The loan applied amount can''t offset your outstanding loan balance of KES '+ FORMAT(SameLoanOutstandingBal);
                  EXIT;
              END;
          END;

          IF (SavAcc.Status <> SavAcc.Status::Active) THEN BEGIN
              Response:='ACCOUNT_NOT_ACTIVE';
              EXIT;
          END;

          IF NOT (SaccoTrans.ActiveMobileMember(MemberNo)) THEN BEGIN
              Response := 'ACCOUNT_NOT_ACTIVE';
              EXIT;
          END;

          Members.CALCFIELDS(Members."Shares Retained",Members."Current Shares");
          IF Members."Registration Date" = 0D THEN BEGIN

              Response := 'MEMBER_LESS_THAN_6_MONTHS';
              EXIT;
          END;

          IF CALCDATE('6M',Members."Registration Date") > TODAY THEN BEGIN
              Response := 'MEMBER_LESS_THAN_6_MONTHS';
              EXIT;
          END;

          IF Members.Status <>Members.Status::Active THEN BEGIN
            Response := 'Member account is not active';
            EXIT;

          END;

          IF Members."Loan Defaulter" = TRUE THEN BEGIN
              Response := 'You are a Defaulter';
              EXIT;
          END;
      //........................Defaulted Loan check.........................

          Loans.RESET;
          Loans.SETRANGE("Client Code",MemberNo);
          Loans.SETFILTER("Loans Category-SASRA",'%1|%2|%3|%4',Loans."Loans Category-SASRA"::Watch,Loans."Loans Category-SASRA"::Substandard,
          Loans."Loans Category-SASRA"::Doubtful,Loans."Loans Category-SASRA"::Loss);
          Loans.SETFILTER("Outstanding Balance",'>0');
          IF Loans.FINDFIRST THEN BEGIN
              LoanProduct.GET(Loans."Loan Product Type");
              Response:='Your '+LoanProduct."USSD Product Name"+' request on '+DateTimeToText(CURRENTDATETIME)+' has failed, You have defaulted '+LoanProductsSetup."Product Description";
          END;


          IF SkyBlackListedAccountNos.GET(SavAcc."No.") THEN BEGIN
              IF  SkyBlackListedAccountNos."BlackList on Loan" THEN BEGIN
                  Response := 'You have been suspended temporarily from mobile loans application processes ';
                  EXIT;
              END;
          END;

          IF Members."Current Shares" <= 0 THEN BEGIN

              Response := 'INSUFFICIENT_CURRENT_SHARES';
              EXIT;
          END;

          IF SavAcc."Outstanding Balance"< MobileLoans."Requested Amount" THEN BEGIN
            Response := 'Amount You are Applying for is less than your Outstanding deposit Amount';
            EXIT;
          END;

          IF SaccoSetup."Minimum Share Capital" > Members."Shares Retained" THEN BEGIN
              Response := 'INSUFFICIENT_RETAINED_SHARES';
              EXIT;
          END;


          LoanProduct.RESET;
          LoanProduct.SETRANGE(Code,LoanType);
          LoanProduct.SETRANGE(AvailableOnMobile,TRUE);
          IF LoanProduct.FIND('-') THEN BEGIN

            IF LoanProduct."Mobile Loan Req. Guar." THEN BEGIN

              MobileLoans.RESET;
              MobileLoans.SETRANGE("Account No",SavAcc."No.");
              MobileLoans.SETRANGE(Status,MobileLoans.Status::"Pending Guarantors");
              MobileLoans.SETRANGE("Loan Product Type",LoanProduct.Code);
              IF MobileLoans.FINDLAST  THEN BEGIN
                  Response:='LOAN_APPLICATION_EXISTS';

              END
              ELSE BEGIN

                  MobileLoans.INIT;
                  MobileLoans."Entry No":=0;
                  MobileLoans."Account No":=SavAcc."No.";
                  MobileLoans.Name := SavAcc.Name;
                  MobileLoans.Date:=CURRENTDATETIME;
                  MobileLoans."Requested Amount":=LoanAmount;
                  MobileLoans.Status:=MobileLoans.Status::"Pending Guarantors";
                  MobileLoans."Loan Product Type":=LoanProduct.Code;
                  MobileLoans.Amount:=LoanAmount;
                  MobileLoans."Entry Code" := EntryCode;
                  MobileLoans."Session ID":=TransactionID;
                  MobileLoans."Date Entered":=TODAY;
                  MobileLoans."Time Entered":=TIME;
                  MobileLoans."Telephone No":=SavAcc."Transactional Mobile No";
                  MobileLoans."Staff No." := SavAcc."Staff No";
                  MobileLoans.Installments := Duration;
                  MobileLoans."Loan Name" := LoanProduct."Product Description";
                  MobileLoans."Account Name" := SavAcc.Name;
                  MobileLoans."Member No." := Members."No.";
                  IF LoanProduct."Mobile Loan Req. Guar." = TRUE THEN BEGIN
                  MobileLoans.PendingAmount := LoanAmount;
                  IF MobileLoans.PendingAmount <=0 THEN BEGIN
                  MobileLoans.PendingAmount := LoanAmount;
                  MobileLoans."Qualified Amount":=LoanAmount;
                  MobileLoans.MODIFY
                  END;
                  END;
                  IF MobileLoans."Requested Amount" <= 450000 THEN
                  MobileLoans."Expected Guarantors" := LoanProduct."Min No. Of Guarantors";
                  IF (MobileLoans."Requested Amount" > 450000) AND (MobileLoans."Requested Amount" < 1000000)THEN
                  MobileLoans."Expected Guarantors" := LoanProduct."Mobile Min. Guarantors";
                  IF (MobileLoans."Requested Amount" >= 1000000) AND (MobileLoans."Requested Amount" < 1000000)THEN
                  MobileLoans."Expected Guarantors" := LoanProduct."Mobile Max. Guarantors";

                  IF (LoanProduct.Code = 'A16') OR (LoanProduct.Code = 'A01') OR (LoanProduct.Code = 'A10')OR (LoanType = 'A10') OR (LoanType = 'M_OD') THEN
                    MobileLoans.Installments := LoanProduct."No of Installment";
                  MobileLoans.INSERT;

                  Response:='SUCCESS';
              END;
            END
            ELSE BEGIN
              //''here
              MobileLoans.RESET;
              MobileLoans.SETRANGE("Account No",SavAcc."No.");
              MobileLoans.SETRANGE(Status,MobileLoans.Status::Pending);
              MobileLoans.SETRANGE("Loan Product Type",LoanProduct.Code);
              IF MobileLoans.FINDLAST THEN BEGIN
                  Response:='LOAN_APPLICATION_EXISTS';
              END
              ELSE BEGIN

                  MobileLoans.INIT;
                  MobileLoans."Entry No":=0;
                  MobileLoans."Account No":=SavAcc."No.";
                  MobileLoans.Name := SavAcc.Name;
                  MobileLoans.Date:=CURRENTDATETIME;
                  MobileLoans."Requested Amount":=LoanAmount;
                  MobileLoans.Status:=MobileLoans.Status::Pending;
                  MobileLoans."Loan Product Type":=LoanProduct.Code;
                  MobileLoans.Amount:=LoanAmount;
                  MobileLoans."Entry Code" := EntryCode;
                  MobileLoans."Session ID":=TransactionID;
                  MobileLoans."Date Entered":=TODAY;
                  MobileLoans."Time Entered":=TIME;
                  MobileLoans."Telephone No":=SavAcc."Transactional Mobile No";
                  MobileLoans."Staff No." := SavAcc."Staff No";
                  MobileLoans.Installments := Duration;
                  IF LoanProduct."Mobile Loan Req. Guar." = TRUE THEN
                  MobileLoans.PendingAmount := LoanAmount;
                  MobileLoans."Qualified Amount":=LoanAmount;

                  MobileLoans."Member No." := Members."No.";
                  MobileLoans."Loan Name" := LoanProduct."Product Description";
                  IF (LoanProduct.Code = 'A16') OR (LoanProduct.Code = 'A01') OR (LoanProduct.Code = 'A10')OR (LoanType = 'A10') OR (LoanType = 'M_OD') THEN
                    MobileLoans.Installments := LoanProduct."No of Installment";
                  MobileLoans.INSERT;

                  Response:='SUCCESS';

                  END;
              END;
            END
            ELSE BEGIN

              MobileLoans.RESET;
              MobileLoans.SETRANGE("Account No",SavAcc."No.");
              MobileLoans.SETRANGE(Status,MobileLoans.Status::Pending);
              MobileLoans.SETRANGE("Loan Product Type",LoanType);
              IF MobileLoans.FINDFIRST THEN BEGIN
                  Response:='LOAN_APPLICATION_EXISTS';
              END
              ELSE BEGIN

                  MobileLoans.INIT;
                  MobileLoans."Entry No":=0;
                  MobileLoans."Account No":=SavAcc."No.";
                  MobileLoans.Name := SavAcc.Name;
                  MobileLoans.Date:=CURRENTDATETIME;
                  MobileLoans."Requested Amount":=LoanAmount;
                  MobileLoans.Status:=MobileLoans.Status::Pending;
                  MobileLoans."Loan Product Type":=LoanType;
                  MobileLoans.Amount:=LoanAmount;
                  MobileLoans."Entry Code" := EntryCode;
                  MobileLoans."Session ID":=TransactionID;
                  MobileLoans."Date Entered":=TODAY;
                  MobileLoans."Time Entered":=TIME;
                  MobileLoans."Telephone No":=SavAcc."Transactional Mobile No";
                  MobileLoans."Staff No." := SavAcc."Staff No";
                  MobileLoans."Loan Name" := LoanProduct."Product Description";
                  IF LoanProduct."Mobile Loan Req. Guar." = TRUE THEN
                  MobileLoans.PendingAmount := LoanAmount;
                  MobileLoans."Qualified Amount":=LoanAmount;
                  MobileLoans.Overdraft := TRUE;



                  MobileLoans.INSERT;
                  IF (LoanProduct.Code = 'A01') OR (LoanProduct.Code = 'A10') THEN BEGIN
                  Response := 'Loan application submitted succesfully, kindly add the required number of Guarantors';
                    END
                    ELSE
                  Response:='SUCCESS';

              END;
          END;
      END
      ELSE BEGIN
          ERROR('Member account not found');
      END;
    END;

    PROCEDURE ProcessMobileLoan@30(EntryNo@1000 : Integer);
    VAR
      MobileNo@1001 : Code[20];
      Loans@1002 : Record 51516230;
      LoanProduct@1003 : Record 51516240;
      SavAcc@1004 : Record 23;
      MemberNo@1005 : Code[20];
      MaxLoan@1008 : Decimal;
      LoanAccountNo@1010 : Code[20];
      LoanType@1007 : Code[20];
      LoanAmount@1006 : Decimal;
      MobileLoan@1012 : Record 51516713;
      Continue@1013 : Boolean;
      msg@1014 : Text;
      Product@1015 : Record 51516717;
      nDays@1016 : Integer;
      SavingsAccounts@1017 : Record 23;
      ShareCap@1018 : Decimal;
      Members@1019 : Record 51516223;
      LoanNo@1020 : Code[20];
      JTemplate@1035 : Code[10];
      JBatch@1034 : Code[10];
      DocNo@1033 : Code[20];
      PDate@1032 : Date;
      AcctType@1031 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      BalAccType@1030 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      TransType@1029 : ' ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated';
      AccNo@1028 : Code[20];
      BalAccNo@1027 : Code[20];
      SourceType@1026 : 'New Member,New Account,Loan Account Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit, Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued';
      ExtDoc@1025 : Code[20];
      Dim1@1023 : Code[20];
      Dim2@1022 : Code[20];
      SystCreated@1021 : Boolean;
      TransactionType@1024 : ' ,Mpesa Withdrawal,Mpesa Deposit,Utility Payment,Loan Repayment,Balance Enquiry,Mini-Statement,Loan Disbursement';
      SaccoFee@1042 : Decimal;
      VendorCommission@1041 : Decimal;
      TotalCharge@1040 : Decimal;
      SaccoAccount@1038 : Code[20];
      VendorAccount@1037 : Code[20];
      UpfrontInterest@1039 : Decimal;
      Amt@1044 : Decimal;
      LoanRec@1046 : Record 5913;
      LoanBalance@1009 : Decimal;
      SaccoSetup@1120054000 : Record 51516700;
      LoanProductsSetup@1120054001 : Record 51516240;
      CreditRating@1120054002 : Record 51516718;
      FosaAcc@1120054003 : Record 23;
      LoanLimit@1120054004 : Decimal;
      SalaryProcessingLines@1120054005 : Record 51516317;
      SameLoan@1120054006 : Record 51516230;
      SalesSetup@1120054007 : Record 51516258;
      NoSeriesMgt@1120054008 : Codeunit 396;
      RecomAmt@1120054009 : Decimal;
      SuccessLocal@1120054010 : Boolean;
      LoanProductCharges@1120054011 : Record 51516242;
      ChargeAmount@1120054012 : Decimal;
    BEGIN
      SaccoSetup.GET;
      MobileLoan.RESET;
      MobileLoan.SETRANGE("Entry No",EntryNo);
      MobileLoan.SETRANGE(Status,MobileLoan.Status::"Pending Guarantors");
      MobileLoan.SETRANGE(Posted,FALSE);
      IF MobileLoan.FINDFIRST THEN BEGIN
          IF GetRemainingGuarantorCount(EntryNo) <=0 THEN BEGIN

              UpdateAmountGuaranteed(EntryNo);
              IF MobileGuarantorsAccepted(EntryNo) THEN BEGIN
                  MobileLoan.Status := MobileLoan.Status::Pending;
                  MobileLoan.MODIFY;
              END;
          END;
      END;

      MobileLoan.RESET;

        MobileLoan.SETRANGE("Entry No",EntryNo);
        MobileLoan.SETRANGE(Status,MobileLoan.Status::Pending);
        MobileLoan.SETRANGE(Posted,FALSE);
        MobileLoan.SETRANGE(Overdraft,FALSE);
        IF MobileLoan.FINDFIRST THEN BEGIN

          SavAcc.RESET;
          SavAcc.SETRANGE("No.",MobileLoan."Account No");
          IF SavAcc.FINDFIRST THEN BEGIN

              MemberNo := SavAcc."BOSA Account No";
              Continue:=TRUE;

              Members.GET(MemberNo);

              IF Continue THEN BEGIN
      ;            IF NOT (SaccoTrans.ActiveMobileMember(MemberNo)) THEN BEGIN
                      msg:='Your '+LoanProduct."USSD Product Name"+' request on '+DateTimeToText(CURRENTDATETIME)+' has failed, Your Account is not Active.';
                      MobileLoan.Remarks:='Member is not Active';
                      MobileLoan.Status:=MobileLoan.Status::Failed;
                      MobileLoan.Posted:=TRUE;
                      MobileLoan."Date Posted":=CURRENTDATETIME;
                      MobileLoan.Message:=msg;
                      SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
                      MobileLoan.MODIFY;
                      Continue:=FALSE;
                  END;
              END;


              Members.CALCFIELDS(Members."Shares Retained",Members."Current Shares");
              IF Members."Registration Date" = 0D THEN BEGIN
                  IF Continue THEN BEGIN
                      msg:='Your '+LoanProduct."USSD Product Name"+' request on '+DateTimeToText(CURRENTDATETIME)+' has failed, You are less than 6 Months Old in the Sacco.';
                      MobileLoan.Remarks:='Member is less than 6 months old in the SACCO';
                      MobileLoan.Status:=MobileLoan.Status::Failed;
                      MobileLoan.Posted:=TRUE;
                      MobileLoan."Date Posted":=CURRENTDATETIME;
                      MobileLoan.Message:=msg;
                      SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
                      MobileLoan.MODIFY;
                      Continue:=FALSE;
                  END;
              END;

              IF CALCDATE('6M',Members."Registration Date") > TODAY THEN BEGIN
                  IF Continue THEN BEGIN
                      msg:='Your '+LoanProduct."USSD Product Name"+' request on '+DateTimeToText(CURRENTDATETIME)+' has failed, You are less than 6 Months Old in the Sacco.';
                      MobileLoan.Remarks:='Member is less than 6 months old in the SACCO';
                      MobileLoan.Status:=MobileLoan.Status::Failed;
                      MobileLoan.Posted:=TRUE;
                      MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                      MobileLoan.Message:=msg;
                      SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
                      MobileLoan.MODIFY;
                      Continue:=FALSE;
                  END;
              END;


              IF Members."Current Shares" <= 0 THEN BEGIN
                  IF Continue THEN BEGIN
                      msg:='Your '+LoanProduct."USSD Product Name"+' request on '+DateTimeToText(CURRENTDATETIME)+' has failed, You have not contributed any share deposits';
                      MobileLoan.Remarks:='Member has not contributed any share deposits';
                      MobileLoan.Status:=MobileLoan.Status::Failed;
                      MobileLoan.Posted:=TRUE;
                      MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                      MobileLoan.Message:=msg;
                      SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
                      MobileLoan.MODIFY;
                      Continue:=FALSE;
                  END;
              END;




              IF SaccoSetup."Minimum Share Capital" > Members."Shares Retained" THEN BEGIN
                  IF Continue THEN BEGIN
                      msg:='Your '+LoanProduct."USSD Product Name"+' request on '+DateTimeToText(CURRENTDATETIME)+' has failed, You have not contributed enough share capital';
                      MobileLoan.Remarks:='Minimum Share Capital Expected';
                      MobileLoan.Status:=MobileLoan.Status::Failed;
                      MobileLoan.Posted:=TRUE;
                      MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                      MobileLoan.Message:=msg;
                      SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
                      MobileLoan.MODIFY;
                      Continue:=FALSE;
                  END;
              END;

      {
              IF Continue THEN BEGIN
                  IF MobileLoan."Loan Product Type" = 'M_OD' THEN BEGIN
                        SalaryProcessingLines.RESET;
                        //SalBuffer.SETCURRENTKEY(SalBuffer."Member No.",SalBuffer.Date);
                        SalaryProcessingLines.SETRANGE(SalaryProcessingLines.Date,CALCDATE('-1M-CM',TODAY),TODAY);
                        SalaryProcessingLines.SETRANGE(SalaryProcessingLines."Account No.",MobileLoan."Account No");
                        IF NOT SalaryProcessingLines.FINDFIRST THEN BEGIN
                            msg:='You do not qualify for salary advance on '+DateTimeToText(CURRENTDATETIME);
                            MobileLoan.Remarks:='No salary processing history';
                            MobileLoan.Status:=MobileLoan.Status::Failed;
                            MobileLoan.Posted:=TRUE;
                            MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                            MobileLoan.Message:=msg;
                            SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
                            MobileLoan.MODIFY;
                            Continue:=FALSE;
                        END;
                  END;
              END;
      }

              //Check Share Capital
              IF Continue THEN BEGIN
                      ShareCap:=0;
                      Members.GET(MemberNo);
                      Members.CALCFIELDS("Shares Retained");
                      ShareCap := Members."Shares Retained";
                      SaccoSetup.GET;
                      SaccoSetup.TESTFIELD("Minimum Share Capital");

                      IF (ShareCap < SaccoSetup."Minimum Share Capital") THEN BEGIN
                          msg:='Your '+LoanProduct."USSD Product Name"+' request on '+DateTimeToText(CURRENTDATETIME)+' was rejected, you do not have enough share capital';
                          MobileLoan.Remarks:='Share capital should be at least '+FORMAT(SaccoSetup."Minimum Share Capital");
                          MobileLoan.Status:=MobileLoan.Status::Failed;
                          MobileLoan.Posted:=TRUE;
                          MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                          MobileLoan.Message:=msg;
                          SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
                          MobileLoan.MODIFY;
                          Continue:=FALSE;
                      END;
              END;

              //Check Defaulter
              IF Continue THEN BEGIN
                  Loans.RESET;
                  Loans.SETRANGE("Client Code",MemberNo);
                  Loans.SETFILTER("Loans Category-SASRA",'%1|%2|%3|%4',Loans."Loans Category-SASRA"::Watch,Loans."Loans Category-SASRA"::Substandard,
                  Loans."Loans Category-SASRA"::Doubtful,Loans."Loans Category-SASRA"::Loss);
                  Loans.SETFILTER("Outstanding Balance",'>0');
                  IF Loans.FINDFIRST THEN BEGIN
                      LoanProductsSetup.GET(Loans."Loan Product Type");

                      msg:='Your '+LoanProduct."USSD Product Name"+' request on '+DateTimeToText(CURRENTDATETIME)+' has failed, You have defaulted '+LoanProductsSetup."Product Description";
                      MobileLoan.Remarks:='Member has defaulted Loan No. '+Loans."Loan  No."+' - '+LoanProductsSetup."Product Description";
                      MobileLoan.Status:=MobileLoan.Status::Failed;
                      MobileLoan.Posted:=TRUE;
                      MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                      MobileLoan.Message:=msg;
                      SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
                      MobileLoan.MODIFY;
                      Continue:=FALSE;
                  END;
              END;


              IF Continue THEN BEGIN
                  LoanLimit := 0;
                  RecomAmt:=0;
                  LoanProduct.RESET;
                  LoanProduct.SETRANGE(Code,MobileLoan."Loan Product Type");
                  LoanProduct.SETRANGE(AvailableOnMobile,TRUE);
                  IF LoanProduct.FIND('-') THEN BEGIN
                    IF (LoanProduct.Code = 'A03') OR (LoanProduct.Code = 'A16') THEN BEGIN
                      GetLoanQualifiedAmount(SavAcc."No.",LoanProduct.Code,msg, LoanLimit);
                      MaxLoan := LoanLimit;
                    END
                    ELSE IF LoanProduct.Code ='A01' THEN BEGIN
                      GetSalaryLoanQualifiedAmount(SavAcc."No.",LoanProduct.Code,LoanLimit,msg);
                      MaxLoan := LoanLimit;
                    END
                    ELSE IF LoanProduct.Code = 'A10' THEN BEGIN
                      GetReloadedLoanQualifiedAmount(SavAcc."No.",LoanProduct.Code,LoanLimit,msg);
                      MaxLoan := LoanLimit;
                    END
                    ELSE IF LoanProduct.Code = 'M_OD' THEN BEGIN
                      GetOverdraftLoanQualifiedAmount(SavAcc."No.",LoanProduct.Code,LoanLimit,msg);
                      MaxLoan := LoanLimit;
                    END;

                      //here
                IF MobileLoan."Loan Product Type" <> 'A16' THEN BEGIN
                    Loans.RESET;
                    Loans.SETRANGE("Client Code",MemberNo);
                    Loans.SETFILTER(Loans."Loan Product Type",MobileLoan."Loan Product Type");
                    Loans.SETFILTER("Outstanding Balance",'>0');
                    IF Loans.FINDFIRST THEN BEGIN
                        LoanProductsSetup.GET(Loans."Loan Product Type");

                        msg:='Your '+LoanProduct."Product Description"+' request on '+DateTimeToText(CURRENTDATETIME)+' has failed, You have an active '+LoanProduct."USSD Product Name";
                        MobileLoan.Remarks:='Member has active Loan No. '+Loans."Loan  No."+' - '+LoanProduct."Product Description";
                        MobileLoan.Status:=MobileLoan.Status::Failed;
                        MobileLoan.Posted:=TRUE;
                        MobileLoan."Date Posted":=CURRENTDATETIME;
                        MobileLoan.Message:=msg;
                        SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
                        MobileLoan.MODIFY;
                        Continue:=FALSE;
                    END;
                END;

                      IF Continue THEN BEGIN
                          IF MobileLoan."Requested Amount" > MaxLoan THEN BEGIN

                              msg:='Your '+LoanProduct."USSD Product Name"+' request on '+DateTimeToText(CURRENTDATETIME)+' has failed, your eligibility is KES '+FORMAT(MaxLoan);
                              MobileLoan.Remarks:='Member eligibility is '+FORMAT(MaxLoan);
                              MobileLoan.Status:=MobileLoan.Status::Failed;
                              MobileLoan.Posted:=TRUE;
                              MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                              MobileLoan.Message:=msg;
                              SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
                              MobileLoan.MODIFY;
                              Continue:=FALSE;
                          END;
                      END;




                      IF Continue THEN BEGIN


              JTemplate:='GENERAL';
              JBatch:='SKYWORLD';

              GenJournalBatch.RESET;
              GenJournalBatch.SETRANGE("Journal Template Name",JTemplate);
              GenJournalBatch.SETRANGE(Name,JBatch);
              IF NOT GenJournalBatch.FINDFIRST THEN BEGIN
                  GenJournalBatch.INIT;
                  GenJournalBatch."Journal Template Name" := JTemplate;
                  GenJournalBatch.Name:=JBatch;
                  GenJournalBatch.Description:='Sky World Batch';
                  GenJournalBatch.INSERT;
              END;


                          SaccoTrans.InitJournal(JTemplate,JBatch);




                          // Get Excise duty G/L
                          ExciseDutyGL := GetExciseDutyGL();
                          ExciseDutyRate := GetExciseRate();
                          ExciseDuty:=0;

                          SaccoAccount:='';
                          SaccoFee:=0;
                          VendorAccount:='';
                          VendorCommission:=0;

                          SMSAccount:='';
                          SMSCharge:=0;

                          CoopSetup.RESET;
                          CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Loan Disbursement");
                          IF CoopSetup.FINDFIRST THEN BEGIN

                              SMSAccount := CoopSetup."SMS Account";
                              SMSCharge := CoopSetup."SMS Charge";


                              SaccoAccount := CoopSetup."Sacco Fee Account";
                              SaccoFee := CoopSetup."Sacco Fee";
                              VendorAccount:=CoopSetup."Vendor Commission Account";
                              //VendorCommission:=CoopSetup."Vendor Commission";

                              GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,Safcom,0);
                              TotalCharge:=SaccoFee+VendorCommission+SMSCharge;
                              ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);
                          END
                          ELSE BEGIN
                              ERROR('Setup Missing for %1',CoopSetup."Transaction Type"::"Loan Disbursement");
                          END;


                          Members.GET(MemberNo);
                          VendorCommission := 0;

                          Loans.RESET;
                          Loans.SETRANGE("Client Code",MemberNo);
                          Loans.SETFILTER("Loan Product Type",'=%1&<>%2',LoanProduct.Code,'A16 ');
                          Loans.SETFILTER("Outstanding Balance",'>0');
                          IF (Loans.FINDFIRST) THEN BEGIN


                              Loans."Mobile Loan":=TRUE;
                              Loans."Requested Amount"+=MobileLoan.Amount;
                              Loans."Approved Amount"+=MobileLoan.Amount;
                              Loans.VALIDATE("Approved Amount");
                              Loans.MODIFY;
                          END
                          ELSE BEGIN

                              Loans.INIT;
                              Loans."Mobile Loan":=TRUE;
                              Loans."Main Sector" := '8000';
                              Loans."Sub-Sector" := '8200';
                              Loans."Specific Sector" := '8210';
                              Loans."Loan  No."  :='';
                              //Loans."Loan  No."  :='ML' + FORMAT(MobileLoan."Entry No");
                              Loans."Application Date":=MobileLoan."Date Entered";
                              Loans."Loan Product Type":=LoanProduct.Code;
                              Loans."Loan Product Type Name":=LoanProduct."Product Description" ;
                              Loans."Client Code":=MemberNo;
                              Loans."BOSA No":=MemberNo;
                              Loans."Staff No":=Members."Payroll/Staff No";
                              Loans."Client Name":=Members.Name;
                              Loans."Employer Code" := Members."Employer Code";
                              Loans."Account No":=MobileLoan."Account No";
                              Loans."Employer Name" := Members."Employer Name";
                              Loans."Requested Amount":=MobileLoan.Amount;
                              Loans."Approved Amount":=MobileLoan.Amount;
                              Loans."Approval Status":=Loans."Approval Status"::Approved;
                              Loans."Loan Status":=Loans."Loan Status"::Issued;
                              Loans."Issued Date":=TODAY;
                              Loans."Loan Disbursement Date" := TODAY;
                              Loans.Installments:=MobileLoan.Installments;
                              Loans."Repayment Start Date" := CALCDATE('29D',Loans."Loan Disbursement Date");
                              //Loans."Installment Period":=LoanProduct."Installment Repayment Interval";
                              Loans."Repayment Method":=LoanProduct."Repayment Method";
                              Loans."Loan Disbursement Date" := TODAY;
                              Loans."Global Dimension 1 Code":=SavAcc."Global Dimension 1 Code";
                              Loans."Captured By" := USERID;
                              Loans.Source:=Loans.Source::BOSA;
                              Loans."Repayment Frequency":=LoanProduct."Repayment Frequency";
                              Loans.Interest:=LoanProduct."Interest rate";
      //                         Loans."Loan Interest Repayment":=ROUND(MobileLoan.Installments * MobileLoan.Amount * ((LoanProduct."Interest rate"/12) / 100),1,'>');
                              IF (MobileLoan."Loan Product Type" = 'A01') OR (MobileLoan."Loan Product Type" = 'A10')THEN BEGIN
                                  Loans."Loan Interest Repayment":=ROUND(MobileLoan.Amount * ((LoanProduct."Interest rate"/12) / 100),1,'>');
                                  END
                                  ELSE BEGIN
                                  Loans."Loan Interest Repayment":=ROUND(MobileLoan.Installments * MobileLoan.Amount * ((LoanProduct."Interest rate"/12) / 100),1,'>');
                              END;
                              IF MobileLoan."Loan Product Type" = 'M_OD' THEN
                              Loans."Loan Principle Repayment":=ROUND(Loans."Approved Amount",1,'>');
                              IF MobileLoan."Loan Product Type" <> 'M_OD' THEN
                              Loans."Loan Principle Repayment":=ROUND(Loans."Approved Amount"/Loans.Installments,1,'>');
                              Loans.Repayment:=Loans."Loan Interest Repayment"+Loans."Loan Principle Repayment";
                              IF (MobileLoan."Loan Product Type" = 'A16') OR (MobileLoan."Loan Product Type" = 'M_OD')THEN
                              Loans.Repayment:=Loans."Loan Principle Repayment";
                               IF (MobileLoan."Loan Product Type" = 'A16')OR(MobileLoan."Loan Product Type" = 'A01') OR (MobileLoan."Loan Product Type" = 'A10') OR (MobileLoan."Loan Product Type" = 'M_OD') THEN
                               Loans."Recovery Mode" := Loans."Recovery Mode"::Salary;
                              Loans."Expected Date of Completion" := CALCDATE(FORMAT(Loans.Installments)+'M+2D',Loans."Loan Disbursement Date");
                              Loans.INSERT(TRUE);
                              LoanNo := Loans."Loan  No.";



                              FosaAcc.GET(Loans."Account No");
                              CreditRating.INIT;
                              CreditRating."Loan No." := LoanNo;
                              CreditRating."Document Date"  := TODAY;
                              CreditRating."Loan Amount" := Loans."Approved Amount";
                              CreditRating."Date Entered" := TODAY;
                              CreditRating."Time Entered" := TIME;
                              CreditRating."Entered By" := USERID;
                              CreditRating."Account No" := Loans."Account No";
                              CreditRating."Member No" := Loans."Client Code";
                              CreditRating."Telephone No" := FosaAcc."Transactional Mobile No";
                              CreditRating."Customer Name" := Loans."Client Name";
                              CreditRating."Loan Product Type" := Loans."Loan Product Type";
                              CreditRating."Loan Limit" := LoanLimit;
                              CreditRating."Staff No.":=FosaAcc."Staff No";
                              CreditRating.INSERT;

                          END;


                          Loans.RESET;
                          Loans.SETRANGE("Loan  No.",LoanNo);
                          Loans.SETRANGE("Client Code",MemberNo);
                          Loans.SETRANGE("Loan Product Type",LoanProduct.Code);
                          IF Loans.FINDFIRST THEN BEGIN

                              UpfrontInterest := 0;
                              UpfrontInterest:=ROUND(MobileLoan.Installments * MobileLoan.Amount*LoanProduct."Interest rate"/1200,1,'>');

                              DocNo := Loans."Loan  No.";
                              PDate := TODAY;

                              Dim1:=Loans."Global Dimension 1 Code";
                              Dim2:=Loans."Branch Code";

                              AccNo := Loans."Client Code";
                              ExtDoc := '';
                              LoanNo := Loans."Loan  No.";
                              TransType := TransType::Loan;
                              SystCreated := TRUE;

                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,MobileLoan."Account No",COPYSTR(LoanProduct."Product Description"+' Disbursement',1,50),BalAccType::"G/L Account",
                                            '',-MobileLoan.Amount,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,Loans."Client Name");


                              //Offset
                              IF (MobileLoan."Loan Product Type" = 'A16')OR(MobileLoan."Loan Product Type" = 'A01') OR (MobileLoan."Loan Product Type" = 'A10') OR (MobileLoan."Loan Product Type" = 'M_OD') THEN BEGIN
                                  SameLoan.RESET;
                                  SameLoan.SETRANGE(SameLoan."Loan Product Type",MobileLoan."Loan Product Type");
                                  SameLoan.SETFILTER(SameLoan."Outstanding Balance",'>0');
                                  SameLoan.SETFILTER(SameLoan."Loan  No.",'<>%1',Loans."Loan  No.");
                                  SameLoan.SETRANGE(SameLoan."Client Code",Loans."Client Code");
                                  IF SameLoan.FINDFIRST THEN BEGIN
                                    REPEAT
                                      SameLoan.CALCFIELDS(SameLoan."Outstanding Balance");
                                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,MobileLoan."Account No",COPYSTR('Offset by : '+Loans."Loan  No.",1,50),BalAccType::"G/L Account",
                                                    '',SameLoan."Outstanding Balance",ExtDoc,Loans."Loan  No.",TransType::" ",Dim1,Dim2,SystCreated,Loans."Client Name");

                                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."Client Code",COPYSTR('Offset by : '+Loans."Loan  No.",1,50),BalAccType::"G/L Account",
                                                    '',-SameLoan."Outstanding Balance",ExtDoc,SameLoan."Loan  No.",TransType::Repayment,Dim1,Dim2,SystCreated,Loans."Client Name");
                                    UNTIL SameLoan.NEXT = 0;
                                  END;
                              END;


                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,MobileLoan."Account No",COPYSTR('Processing Fee',1,50),BalAccType::"G/L Account",
                                            '',VendorCommission+SaccoFee,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,Loans."Client Name");

                              LoanProductCharges.RESET;
                              LoanProductCharges.SETRANGE(LoanProductCharges."Product Code",LoanProduct.Code);
                              LoanProductCharges.SETFILTER(LoanProductCharges.Code,'<>%1','');
                              LoanProductCharges.SETFILTER(LoanProductCharges."G/L Account",'<>%1','');
                              IF LoanProductCharges.FINDFIRST THEN BEGIN
                                REPEAT
                                  ChargeAmount := 0;
                                  IF LoanProductCharges."Use Perc" THEN
                                    ChargeAmount := ROUND(MobileLoan.Amount * LoanProductCharges.Percentage,1,'>')
                                  ELSE
                                    ChargeAmount := LoanProductCharges.Amount;

                                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,MobileLoan."Account No",
                                            COPYSTR(LoanProductCharges.Description +': LNo. '+Loans."Loan  No.",1,50),BalAccType::"G/L Account",
                                            LoanProductCharges."G/L Account",VendorCommission+SaccoFee,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,
                                            Loans."Client Name");

                                UNTIL LoanProductCharges.NEXT = 0;
                              END;

                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,MobileLoan."Account No",COPYSTR('SMS Charge',1,50),BalAccType::"G/L Account",
                                SMSAccount,SMSCharge,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,Loans."Client Name");


                              AccNo := Loans."Client Code";
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,AccNo,COPYSTR(LoanProduct."Product Description"+' Disbursement',1,50),BalAccType::"G/L Account",
                                            '',MobileLoan.Amount,ExtDoc,LoanNo,TransType::Loan,Dim1,Dim2,SystCreated,Loans."Client Name");

                              IF LoanProduct."Interest Charged Upfront" THEN BEGIN
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,AccNo,COPYSTR(LoanProduct."Product Description"+' Interest',1,50),BalAccType::"G/L Account",
                                            LoanProduct."Loan Interest Account",UpfrontInterest,ExtDoc,LoanNo,TransType::"Interest Due",Dim1,Dim2,SystCreated,Loans."Client Name");
                              END;
                              IF LoanProduct."Interest Recovered Upfront" THEN BEGIN
                                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,MobileLoan."Account No",COPYSTR(LoanProduct."Product Description"+' Interest',1,50),BalAccType::"G/L Account",
                                                '',UpfrontInterest,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,Loans."Client Name");


                                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."Client Code",COPYSTR(LoanProduct."Product Description"+' Interest',1,50),BalAccType::"G/L Account",
                                                '',-UpfrontInterest,ExtDoc,LoanNo,TransType::"Interest Paid",Dim1,Dim2,SystCreated,Loans."Client Name");
                              END;


                              AccNo := SaccoAccount;
                              ExtDoc := Loans."Client Code";
                              LoanNo := '';
                              TransType := TransType::" ";

                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",AccNo,COPYSTR(LoanProduct."Product Description"+' Disbursement Commission',1,50),BalAccType::"G/L Account",
                                            '',-SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,Loans."Client Name");


                              AccNo := VendorAccount;
                              ExtDoc := Loans."Client Code";
                              LoanNo := '';
                              TransType := TransType::" ";

                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(LoanProduct."Product Description"+' Disbursement Commission',1,50),BalAccType::"G/L Account",
                                            '',-VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,Loans."Client Name");




                              MobileLoan.Remarks:='Successful';
                              MobileLoan."Approved Amount":=Loans."Approved Amount";
                              MobileLoan.Status:=MobileLoan.Status::Successful;
                              MobileLoan.Posted:=TRUE;
                              MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                              MobileLoan.Message:=msg;
                              MobileLoan.MODIFY;


                              Loans.Posted:=TRUE;
                              Loans.MODIFY;
                              LoanNo:=Loans."Loan  No.";


                              SaccoTrans.PostJournal(JTemplate,JBatch);

                              IF (LoanType <> 'A16') OR (LoanType <> 'A01') OR (LoanType <> 'A10') THEN BEGIN
                                Loans.GET(LoanNo);
                                Loans.CALCFIELDS("Outstanding Balance",Loans."Oustanding Interest");
                                LoanBalance := Loans."Outstanding Balance";
                                msg:='Dear '+FirstName(Loans."Client Name")+
                                ', your '+LoanProduct."USSD Product Name"+' of KES '+FORMAT(MobileLoan."Requested Amount")+' has been disbursed to your Account on '+FORMAT(TODAY)+' at '+FORMAT(TIME)+'. '+
                                'Amount due is KES '+FORMAT(LoanBalance+Loans."Oustanding Interest")+' payable by '+ddMMyyyy(CALCDATE(FORMAT(Loans.Installments)+'M',Loans."Loan Disbursement Date"));
                                SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
                                COMMIT;
                                Schedule.Autogenerateschedule(LoanNo);

                              END ELSE IF (LoanType = 'A16') OR (LoanType = 'A01') OR (LoanType = 'A10') THEN BEGIN
                                Loans.GET(LoanNo);
                                Loans.CALCFIELDS("Outstanding Balance");
                                LoanBalance := Loans."Outstanding Balance";
                                msg:='Dear '+FirstName(Loans."Client Name")+
                                ', your '+LoanProduct."USSD Product Name"+' of KES '+FORMAT(MobileLoan."Requested Amount")+' has been disbursed to your Account on '+FORMAT(TODAY)+' at '+FORMAT(TIME)+'.'+
                                'Amount due is KES '+FORMAT(LoanBalance)+' payable by '+ddMMyyyy((CALCDATE(FORMAT(Loans.Installments)+'3M',Loans."Loan Disbursement Date")));
                                SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
                                COMMIT;
                                Schedule.Autogenerateschedule(LoanNo);
                              END;

                          END;

                      END;
                  END;
               END;


          END;


      END;
    END;

    PROCEDURE AccountTransfer@19(EntryCode@1044 : Text;TransactionID@1102755001 : Text;MobileNo@1015 : Code[20];ToAccount@1018 : Code[20];Destination@1053 : Text;TransAmount@1037 : Decimal;PIN@1051 : Text;PayLoan@1038 : Boolean;ToBOSA@1056 : Boolean) Response : Text;
    VAR
      SaccoFee@1033 : Decimal;
      VendorCommission@1032 : Decimal;
      TotalCharge@1031 : Decimal;
      SavAcc@1030 : Record 23;
      SaccoAccount@1029 : Code[20];
      VendorAccount@1028 : Code[20];
      AccBal@1026 : Decimal;
      JTemplate@1024 : Code[10];
      JBatch@1023 : Code[10];
      MobileTrans@1022 : Record 51516712;
      DocNo@1021 : Code[20];
      PDate@1020 : Date;
      AcctType@1019 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      BalAccType@1017 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      TransType@1027 : ' ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated';
      AccNo@1014 : Code[20];
      BalAccNo@1013 : Code[20];
      SourceType@1012 : 'New Member,New Account,Loan Account Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit, Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued';
      ExtDoc@1010 : Code[20];
      LoanNo@1009 : Code[20];
      Dim1@1008 : Code[20];
      Dim2@1007 : Code[20];
      SystCreated@1006 : Boolean;
      SLedger@1005 : Record 25;
      LedgerCount@1004 : Integer;
      CurrRecord@1003 : Integer;
      DFilter@1002 : Text;
      DebitCreditFlag@1001 : Code[10];
      FirstEntry@1000 : Boolean;
      ProdFact@1034 : Record 51516717;
      AccountBookBalance@1035 : Decimal;
      AccountAvailableBalance@1036 : Decimal;
      Loans@1039 : Record 51516230;
      IntAmt@1041 : Decimal;
      PrAmt@1040 : Decimal;
      RunBal@1042 : Decimal;
      DrAmt@1043 : Decimal;
      TransactionDate@1011 : DateTime;
      IntRate@1045 : Decimal;
      msg@1046 : Text;
      NewLoanBal@1047 : Decimal;
      LoanType@1049 : Record 51516240;
      LT@1048 : Text;
      FromAccount@1050 : Code[20];
      MemberNo@1052 : Code[20];
      RecMemberNo@1054 : Code[20];
      RecMobileNo@1055 : Code[20];
      MemberName@1000000000 : Text;
      RecMemberName@1000000001 : Text;
      RecProduct@1025 : Code[20];
      RecTransType@1016 : ' ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated';
      RecAccNAme@1057 : Text;
      AccountType@1120054000 : Record 51516295;
      BosaEntry@1120054001 : Boolean;
      RecAcctNo@1120054002 : Code[20];
      GenSetup@1120054003 : Record 51516700;
      InterestVendComm@1120054004 : Decimal;
      PenaltyAmount@1120054005 : Decimal;
    BEGIN
      MobileTrans.RESET;
      MobileTrans.SETRANGE(MobileTrans."Transaction ID",TransactionID);
      IF MobileTrans.FINDFIRST THEN BEGIN
        Response := 'TRANSACTION_EXISTS';
        EXIT;
      END;
      TransactionDate := CURRENTDATETIME;
      Response := 'ERROR';

      IF (ToBOSA <> TRUE) AND (NOT PayLoan) THEN BEGIN
          IF NOT PayLoan THEN BEGIN
              ToAccount := GetAccountTransferRecipient(ToAccount,Destination);

              IF ToAccount = '' THEN BEGIN
                  ERROR('Destination Account Not Found');
              END;
          END;
      END;


      MobileNo := '+'+MobileNo;

      IF NOT CorrectPin(MobileNo,PIN) THEN BEGIN
          Response := 'INCORRECT_PIN';
          EXIT;
      END;


      MemberNo:='';
      FromAccount:='';
      RecMemberNo:='';

      MemberName:='';
      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
      IF SavAcc.FINDFIRST THEN BEGIN
          FromAccount:=SavAcc."No.";
          MemberNo:=SavAcc."No.";
          MemberName := SavAcc.Name;
      END;


      // Get Excise duty G/L
      ExciseDutyGL := GetExciseDutyGL();
      ExciseDutyRate := GetExciseRate();
      ExciseDuty:=0;

      SaccoAccount:='';
      SaccoFee:=0;
      VendorAccount:='';
      VendorCommission:=0;
      RecMobileNo:='';
      RecAccNAme := '';

      IF PayLoan THEN
          Loans.GET(ToAccount)
      ELSE BEGIN

          RecProduct := '';
          RecMemberNo := '';
          IF SavAcc.GET(ToAccount) THEN BEGIN
              AccountType.GET(SavAcc."Account Type");

              RecAccNAme := AccountType."USSD Product Name";
              RecAcctNo := SavAcc."No.";
              IF AccountType."USSD Product Name" <> '' THEN
                RecAccNAme := AccountType."USSD Product Name";

              RecMemberNo := SavAcc."BOSA Account No";
              RecMemberName := SavAcc.Name;
              RecMobileNo := SavAcc."Transactional Mobile No";
              IF RecMobileNo = '' THEN
                RecMobileNo := SavAcc."Mobile Phone No";

              BosaEntry := FALSE;

          END
          ELSE BEGIN
              SplitAccount(ToAccount,RecProduct,RecMemberNo);
              ProdFact.GET(RecProduct);
              Members.GET(RecMemberNo);
              RecAccNAme := ProdFact."Product Description";
              IF ProdFact."USSD Product Name" <> '' THEN
                RecAccNAme := ProdFact."USSD Product Name";

              RecMemberNo := Members."No.";
              RecAcctNo := Members."No.";
              RecMemberName := Members.Name;
              RecMobileNo := Members."Mobile Phone No";

              RecTransType := ProdFact."Product Category";
              BosaEntry:=TRUE;
          END;


      END;

      SMSAccount:='';
      SMSCharge:=0;

      CoopSetup.RESET;
      IF PayLoan THEN
      CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Pay Loan From Account")
      ELSE
      CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Account Transfer");
      IF CoopSetup.FINDFIRST THEN BEGIN

          SMSAccount := CoopSetup."SMS Account";
          SMSCharge := CoopSetup."SMS Charge";


          SaccoAccount := CoopSetup."Sacco Fee Account";
          SaccoFee := CoopSetup."Sacco Fee";
          VendorAccount:=CoopSetup."Vendor Commission Account";
          VendorCommission:=CoopSetup."Vendor Commission";


          GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,Safcom,0);
          TotalCharge:=SaccoFee+VendorCommission+SMSCharge;
          ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);
      END
      ELSE BEGIN
          IF PayLoan THEN
          ERROR('Setup Missing for %1',CoopSetup."Transaction Type"::"Pay Loan From Account")
          ELSE
          ERROR('Setup Missing for %1',CoopSetup."Transaction Type"::"Account Transfer");
      END;


      IF SavAcc.GET(FromAccount) THEN BEGIN
          AccountType.GET(SavAcc."Account Type");


          IF (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::"Deposits Only") OR
              (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::" ") THEN BEGIN
              ERROR('The Account to Charge is not a Withdrawable Account');

          END;

          RunBal :=TransAmount;
          AccBal := GetAccountBalance(SavAcc."No.");
          IF AccBal >= TransAmount+TotalCharge+ExciseDuty THEN BEGIN

              //RunBal := RunBal - (TotalCharge+ExciseDuty);

              //BUser.GET(USERID);

              //BUser.TESTFIELD("Cashier Journal Template");
              //BUser.TESTFIELD("Cashier Journal Batch");

              JTemplate:='GENERAL';
              JBatch:='SKYWORLD';

              GenJournalBatch.RESET;
              GenJournalBatch.SETRANGE("Journal Template Name",JTemplate);
              GenJournalBatch.SETRANGE(Name,JBatch);
              IF NOT GenJournalBatch.FINDFIRST THEN BEGIN
                  GenJournalBatch.INIT;
                  GenJournalBatch."Journal Template Name" := JTemplate;
                  GenJournalBatch.Name:=JBatch;
                  GenJournalBatch.Description:='Sky World Batch';
                  GenJournalBatch.INSERT;
              END;


              MobileTrans.INIT;
              //MobileTrans."Entry No." := EntryCode;
              MobileTrans."Entry No.":=CREATEGUID;
              MobileTrans."Mobile No.":= MobileNo;
              MobileTrans."Transaction ID":=TransactionID;
              MobileTrans."Session ID":=TransactionID;
              MobileTrans."Transaction Date":=DT2DATE(TransactionDate);
              MobileTrans."Transaction Time":=DT2TIME(TransactionDate);
              MobileTrans."Date Captured" := TransactionDate;
              MobileTrans."Member Account":=SavAcc."No.";
              MobileTrans."Vendor Commission" := VendorCommission;
              MobileTrans."Sacco Fee" := SaccoFee;
              MobileTrans.Amount:=TransAmount;
              MobileTrans."Transaction Type":=MobileTrans."Transaction Type"::"Account Transfer";
              MobileTrans.Description:=COPYSTR('Acc Trans. '+FromAccount+' -> '+ToAccount,1,50);
              MobileTrans."Account to Check":=ToAccount;
              MobileTrans."Savings Product":=ProdFact."Product ID";
              MobileTrans."Bosa Entry" := BosaEntry;
              MobileTrans.INSERT;


              MobileTrans.RESET;
              MobileTrans.SETRANGE("Transaction ID",TransactionID);
              MobileTrans.SETRANGE(Posted,FALSE);
              IF MobileTrans.FINDFIRST THEN BEGIN

                  DocNo := MobileTrans."Transaction ID";
                  PDate := MobileTrans."Transaction Date";
                  AccNo := MobileTrans."Member Account";
                  ExtDoc := '';
                  LoanNo := '';
                  TransType := TransType::" ";
                  Dim1 := SavAcc."Global Dimension 1 Code";
                  Dim2 := SavAcc."Global Dimension 2 Code";
                  SystCreated := TRUE;

                  SaccoTrans.InitJournal(JTemplate,JBatch);

                  DrAmt:=MobileTrans.Amount;

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                '',DrAmt,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  IF PayLoan THEN BEGIN
                      IF Loans.GET(ToAccount) THEN BEGIN
                          Loans.CALCFIELDS("Outstanding Balance","Oustanding Interest","Oustanding Penalty");
                          IntAmt := Loans."Oustanding Interest";
                          PenaltyAmount := Loans."Oustanding Penalty";
                          IF IntAmt > 0 THEN BEGIN

                              IF IntAmt > RunBal THEN
                                  IntAmt := RunBal;


                              InterestVendComm := 0;

                              CoopSetup.RESET;
                              CoopSetup.SETRANGE("Transaction Type",MobileTrans."Transaction Type"::"Loan Disbursement");
                              IF CoopSetup.FINDFIRST THEN BEGIN
                                  VendorAccount:=CoopSetup."Vendor Commission Account";

                                  GetCharges(CoopSetup."Transaction Type",InterestVendComm,SaccoFee,Safcom,0);
                              END;

                              MobileTrans."Interest Paid" := IntAmt;
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."Client Code",COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                            '',-IntAmt,ExtDoc,Loans."Loan  No.",TransType::"Interest Paid",Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                              RunBal -= IntAmt;





                              IF Loans."Mobile Loan" THEN BEGIN
                                  GenSetup.GET;
                                  GenSetup.TESTFIELD("Loan Interest Expense GL");



                                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,VendorAccount,COPYSTR('Comm. on '+MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                            '',-InterestVendComm,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",GenSetup."Loan Interest Expense GL",COPYSTR('Comm. on '+MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                                '',InterestVendComm,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                              END;

                          END;

                          IF PenaltyAmount > 0 THEN BEGIN
                              IF PenaltyAmount > RunBal THEN
                                      PenaltyAmount := RunBal;

                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."Client Code",COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                                '',-PenaltyAmount,ExtDoc,Loans."Loan  No.",TransType::"Penalty Paid",Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                              RunBal -= PenaltyAmount;
                          END;

                          IF Loans."Outstanding Balance" > 0 THEN BEGIN
                              PrAmt:=Loans."Outstanding Balance";
                              IF PrAmt > RunBal THEN
                                  PrAmt := RunBal;


                              MobileTrans."Principal Paid" := PrAmt;
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."Client Code",COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                            '',-PrAmt,ExtDoc,Loans."Loan  No.",TransType::Repayment,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                              RunBal -= PrAmt;

                          END;

                          IF RunBal > 0 THEN BEGIN

                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR('Excess - '+MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                            '',-RunBal,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                          END;

                      END;
                  END
                  ELSE BEGIN
                      IF MobileTrans."Bosa Entry" THEN BEGIN
                          AcctType := AcctType::Member;

                      END
                      ELSE BEGIN
                          AcctType := AcctType::Vendor;

                      END;
                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType,RecAcctNo,COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                    '',-MobileTrans.Amount,ExtDoc,LoanNo,RecTransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  END;

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(FORMAT(MobileTrans."Transaction Type")+' Charge',1,50),BalAccType::"G/L Account",
                                '',TotalCharge-SMSCharge,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR('Excise Duty on SMS Charge',1,50),BalAccType::"G/L Account",
                                ExciseDutyGL,ROUND((SaccoFee)*ExciseDutyRate/100,1,'>'),ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  {
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR('Transfer Charge',1,50),BalAccType::"G/L Account",
                                '',SaccoFee,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  }
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR('SMS Charge',1,50),BalAccType::"G/L Account",
                                SMSAccount,SMSCharge,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR('Excise Duty on SMS Charge',1,50),BalAccType::"G/L Account",
                                ExciseDutyGL,ROUND((SMSCharge)*ExciseDutyRate/100,1,'>'),ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  AccNo := VendorAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(MobileTrans.Description+' Commission',1,50),BalAccType::"G/L Account",
                                '',-VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  AccNo := SaccoAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",AccNo,COPYSTR(MobileTrans.Description+' Fee',1,50),BalAccType::"G/L Account",
                                '',-SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  MobileTrans.Posted:=TRUE;
                  MobileTrans."Posted By":=USERID;
                  MobileTrans."Date Posted":=TODAY;
                  MobileTrans.MODIFY;

                  SaccoTrans.PostJournal(JTemplate,JBatch);

                  Priority:=200;
                  IF PayLoan THEN BEGIN
                      IF Loans.GET(ToAccount) THEN BEGIN
                          Loans.CALCFIELDS("Outstanding Balance",Loans."Oustanding Interest","Penalty Charged");

                          IF LoanType.GET(Loans."Loan Product Type") THEN
                            LT := LoanType."USSD Product Name";

                          IF LT = '' THEN
                            LT := LoanType."Product Description";

                          NewLoanBal := ROUND(Loans."Outstanding Balance"+Loans."Oustanding Interest"+Loans."Oustanding Penalty",1,'>');
                          msg := FORMAT(MobileTrans."Transaction Type")+' of KES '+FORMAT(MobileTrans.Amount)+' has been processed successfully on '+DateTimeToText(CURRENTDATETIME)+'. New '+LT+' Balance is '+FORMAT(NewLoanBal);
                      END;
                  END
                  ELSE BEGIN

                      IF RecMemberNo<>MemberNo THEN BEGIN
                          IF RecMobileNo<>'' THEN BEGIN
                              msg := SavAcc.Name+' has transfered KES '+FORMAT(MobileTrans.Amount)+' to your '+RecAccNAme+' on '+DateTimeToText(CURRENTDATETIME)+'.';

                              SendSms(Source::MBANKING,RecMobileNo,msg,FORMAT(MobileTrans."Transaction ID"),'',FALSE,Priority,FALSE);

                          END;

                          msg :='Dear '+MemberName+', Your transaction on KES '+FORMAT(MobileTrans.Amount)+
                            ' has been deposited to '+RecAccNAme+' on '+DateTimeToText(CURRENTDATETIME)+' in favor of '+RecMemberName+'. ';
                      END
                      ELSE BEGIN
                          msg :='Dear '+MemberName+', Your transaction on KES '+FORMAT(MobileTrans.Amount)+
                                ' has been deposited to '+RecAccNAme+' on '+DateTimeToText(CURRENTDATETIME)+'.';
                      END;

                  END;


                  SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileTrans."Transaction ID"),'',TRUE,Priority,FALSE);


                  Response:='SUCCESS';
              END;
          END
          ELSE BEGIN


              Priority:=200;
              msg := FORMAT(MobileTrans."Transaction Type")+' of KES '+FORMAT(MobileTrans.Amount)+' has failed because you have insufficient balance.';
              SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileTrans."Transaction ID"),SavAcc."No.",TRUE,Priority,TRUE);

              Response:='INSUFFICIENT_BAL';

          END;
      END
      ELSE BEGIN
          ERROR('Account not found');
      END;
    END;

    PROCEDURE GetLoanGuarantors@23(TransactionID@1009 : Code[20];LoanNo@1000 : Code[20]) Response : Text;
    VAR
      MobileNo@1001 : Code[20];
      Loans@1002 : Record 51516230;
      LoanProduct@1003 : Record 51516240;
      SavAcc@1004 : Record 23;
      MemberNo@1005 : Code[20];
      MaxLoan@1006 : Decimal;
      LoanGuarantors@1007 : Record 51516231;
      Members@1008 : Record 18;
    BEGIN

      Response:='';

      Loans.RESET;
      Loans.SETRANGE("Loan  No.",LoanNo);
      IF Loans.FINDFIRST THEN BEGIN
          Loans.CALCFIELDS("Outstanding Balance");
          CheckDate := TODAY;
          RemInst := 0;
          WHILE CheckDate < Loans."Expected Date of Completion" DO BEGIN
              RemInst+=1;
              CheckDate:=CALCDATE('1M',CheckDate);
          END;

          LoanGuarantors.RESET;
          LoanGuarantors.SETRANGE("Loan No",Loans."Loan  No.");
          LoanGuarantors.SETRANGE(Substituted,FALSE);
          IF LoanGuarantors.FIND('-') THEN BEGIN
              Response:='<Loan>';
              LGCount := LoanGuarantors.COUNT;
              IF(LGCount = 0) THEN
                  LGCount := 1;
              REPEAT

                  Response += '<Security>';
                    Response += '<LoanNo>'+Loans."Loan  No."+'</LoanNo>';
                    //Response += '<Type>'+FORMAT(LoanGuarantors."Guarantor Type")+'</Type>';
                    Response += '<RemainingInstallment>'+FORMAT(RemInst)+' Month(s)</RemainingInstallment>';
                    Response += '<Name>'+LoanGuarantors.Name+'</Name>';
                    MobileNo:='';
                    IF Members.GET(LoanGuarantors."Member No") THEN BEGIN
                      MobileNo := Members."Phone No.";
                    END;

                    Response += '<MobileNo>'+MobileNo+'</MobileNo>';
                    Response += '<AmountGuaranteed>'+FORMAT(ROUND(LoanGuarantors."Amont Guaranteed"))+'</AmountGuaranteed>';
                    Response += '<CurrentCommitment>'+FORMAT(ROUND(LoanGuarantors."Amount Committed"))+'</CurrentCommitment>';

                  Response += '</Security>';

              UNTIL LoanGuarantors.NEXT=0;
              Response+='</Loan>';
          END;
      END
      ELSE BEGIN
          Response:='<Response>';
            Response+='<Status>LOAN_NOT_FOUND</Status>';
            Response+='<StatusDescription>Member Loan not found</StatusDescription>';
            Response+='<Reference>'+TransactionID+'</Reference>';
          Response+='</Response>';
      END;
    END;

    PROCEDURE GetMemberLoanList@9(Phone@1000 : Code[20]) Response : Text;
    VAR
      MobileNo@1001 : Code[20];
      Loans@1002 : Record 51516230;
      LoanProduct@1003 : Record 51516240;
      SavAcc@1004 : Record 23;
      MemberNo@1005 : Code[20];
      MaxLoan@1006 : Decimal;
      Found@1008 : Boolean;
      LoanNo@1007 : Code[20];
      LoanBal@1009 : Decimal;
      ProductName@1010 : Text;
    BEGIN

      MobileNo:='+'+Phone;


      Response:='';
      Found:=FALSE;
      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FINDFIRST THEN BEGIN

          MemberNo := SavAcc."No.";

          Loans.RESET;
          Loans.SETRANGE("Client Code",SavAcc."BOSA Account No");
          Loans.SETFILTER("Outstanding Balance",'>0');
          IF Loans.FIND('-') THEN BEGIN
              Response:='<Loans>';
              REPEAT
                  LoanProduct.GET(Loans."Loan Product Type");
                  ProductName := LoanProduct."Product Description";
                  IF LoanProduct."USSD Product Name" <> '' THEN
                    ProductName := LoanProduct."USSD Product Name";

                  Found:=TRUE;

                  Response += '<Product>';
                    Response += '<LoanNo>'+Loans."Loan  No."+'</LoanNo>';
                    Response += '<Type>'+ProductName+'</Type>';

                  Response += '</Product>';
              UNTIL Loans.NEXT=0;
              Response+='</Loans>';

          END;

      END;
      IF NOT Found THEN
        Response:='';
    END;

    PROCEDURE GetBosaAccountList@68(PhoneNo@1102755000 : Text[30];Withdrawable@1004 : Boolean) Response : Text;
    VAR
      SavAcc@1000 : Record 23;
      ProdFact@1001 : Record 51516717;
      Found@1002 : Boolean;
      MemberNo@1003 : Code[20];
    BEGIN

      PhoneNo := '+'+PhoneNo;
      Response:='';
      Found:=FALSE;



      MemberNo:='';
      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
      IF SavAcc.FINDFIRST THEN
         MemberNo := SavAcc."No.";

      IF MemberNo='' THEN
          EXIT;



      SavAcc.RESET;
      SavAcc.SETRANGE("No.",MemberNo);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FIND('-') THEN BEGIN
          Response:='<Accounts>';
          REPEAT
              ProdFact.RESET;
              ProdFact.SETRANGE("Product Class Type",ProdFact."Product Class Type"::Savings);
              IF ProdFact.FINDFIRST THEN BEGIN
                  REPEAT

                      IF Withdrawable THEN BEGIN
                          IF (ProdFact."Mobile Transaction" = ProdFact."Mobile Transaction"::"Deposits & Withdrawals") OR (ProdFact."Mobile Transaction" = ProdFact."Mobile Transaction"::"Withdrawals Only") THEN BEGIN
                              Found:=TRUE;
                              Response+='<Account>';
                                  Response+='<AccNo>'+ProdFact."Product ID"+SavAcc."No."+'</AccNo>';
                                  Response+='<AccName>'+ProdFact."USSD Product Name"+'</AccName>';
                              Response+='</Account>';
                          END;

                      END
                      ELSE BEGIN
                          IF ProdFact."Mobile Transaction" <> ProdFact."Mobile Transaction"::" " THEN BEGIN
                              Found:=TRUE;
                              Response+='<Account>';
                                  Response+='<AccNo>'+ProdFact."Product ID"+SavAcc."No."+'</AccNo>';
                                  Response+='<AccName>'+ProdFact."USSD Product Name"+'</AccName>';
                              Response+='</Account>';
                          END;
                      END;
                  UNTIL ProdFact.NEXT = 0;
              END;
          UNTIL SavAcc.NEXT = 0;
          Response+='</Accounts>';

      END;


      IF NOT Found THEN
        Response:='';
    END;

    PROCEDURE GetReloadedLoanQualifiedAmount@1120054067(AccountNo@1000 : Code[20];LoanProductType@1004 : Code[20];VAR LoanLimit@1120054003 : Decimal;VAR Remark@1120054044 : Text[250]) : Decimal;
    VAR
      LoanBalance@1001 : Decimal;
      MaxLoanAmount@1002 : Decimal;
      saccoAccount@1003 : Record 23;
      LoanType@1005 : Record 51516240;
      LoanRep@1006 : Decimal;
      nDays@1007 : Decimal;
      DepAmt@1008 : Decimal;
      Loans@1120054000 : Record 51516230;
      SaccoSetup@1120054001 : Record 51516700;
      RatingLoanLimit@1120054002 : Decimal;
      PenaltyCounter@1120054009 : Record 51516443;
      LoansRegister@1120054008 : Record 51516230;
      MemberLedgerEntry@1120054007 : Record 51516224;
      NumberOfMonths@1120054006 : Integer;
      DayLoanPaid@1120054005 : Date;
      Continue@1120054004 : Boolean;
      SalaryProcessingLines@1120054010 : Record 51516317;
      PayrollMonthlyTransactions@1120054011 : Record 51516183;
      MaxLoanAmtPossible@1120054012 : Decimal;
      SalBuffer@1120054013 : Record 51516317;
      StandingOrders@1120054014 : Record 51516307;
      DepAcc@1120054015 : Record 51516223;
      Salary1@1120054016 : Decimal;
      Salary2@1120054017 : Decimal;
      Salary3@1120054018 : Decimal;
      SalEnd@1120054019 : ARRAY [5] OF Date;
      SalStart@1120054020 : ARRAY [5] OF Date;
      NetSal@1120054024 : Decimal;
      IntAmt@1120054025 : Decimal;
      ProdFac@1120054026 : Record 51516240;
      GrossSalaryAmount@1120054027 : Decimal;
      NetSalaryAmount@1120054028 : Decimal;
      SalaryLoans@1120054029 : Record 51516230;
      STO@1120054030 : Record 51516307;
      LoanRepayments@1120054031 : Decimal;
      STODeductions@1120054032 : Decimal;
      SameLoanRepayments@1120054033 : Decimal;
      SameLoanOutstandingBal@1120054034 : Decimal;
      CoopSetup@1120054035 : Record 51516704;
      TotalCharge@1120054036 : Decimal;
      SaccoFee@1120054037 : Decimal;
      VendorCommission@1120054038 : Decimal;
      SMSCharge@1120054039 : Decimal;
      Members@1120054040 : Record 51516223;
      SaccoAcc@1120054042 : Record 23;
      i@1120054021 : Integer;
      SalaryAmount@1120054022 : ARRAY [5] OF Decimal;
      LoanTypes@1120054041 : Record 51516240;
      LoanProduct@1120054043 : Code[30];
      EmployerCode@1120054023 : Code[30];
      LoanRepaymentRecFromSal@1120054045 : Decimal;
      SalaryPostingCharge@1120054046 : Decimal;
    BEGIN
      MaxLoanAmount := 0;
      Remark := '';
      GrossSalaryAmount :=0;
      saccoAccount.RESET;
      saccoAccount.SETRANGE("No.",AccountNo);
      IF saccoAccount.FIND('-') THEN BEGIN
        Members.GET(saccoAccount."BOSA Account No");
        IF Members.Status<>Members.Status::Active THEN BEGIN
          LoanLimit :=0;
          Remark := 'Your Bosa Account is not active';
          EXIT;
        END;

        IF Members."Loan Defaulter" = TRUE THEN BEGIN
          LoanLimit:=0;
          Remark := 'You are not eligible for this product because you are listed as a defaulter';
          EXIT;
        END;

        SaccoAcc.RESET;
        SaccoAcc.SETRANGE("No.",AccountNo);
        IF SaccoAcc.FINDFIRST THEN BEGIN
          IF SaccoAcc.Status <> SaccoAcc.Status::Active THEN BEGIN
            LoanLimit :=0;
            Remark := 'Your membership status is not Active';
            EXIT;
          END;
        END;

        IF LoanType.GET(LoanProductType) THEN BEGIN
          LoanRepayments:=0;
          LoanTypes.RESET;
          LoanTypes.SETRANGE("Salary Loans",TRUE);
          LoanTypes.SETFILTER(Code,'<>%1',LoanProduct);
          IF LoanTypes.FINDFIRST THEN BEGIN
            REPEAT
              Loans.RESET;
              Loans.SETRANGE(Loans."Loan Status",Loans."Loan Status"::Approved);
              Loans.SETRANGE(Loans."Client Code",Members."No.");
              Loans.SETFILTER(Loans."Loan Product Type",LoanTypes.Code);
              Loans.SETFILTER("Outstanding Balance",'>0');
              IF Loans.FIND('-') THEN BEGIN
                REPEAT
                  Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Oustanding Interest");
                  IF(Loans."Outstanding Balance" + Loans."Oustanding Interest")>0 THEN BEGIN
                    IF (Loans."Outstanding Balance" + Loans."Oustanding Interest")>Loans.Repayment THEN BEGIN
                      LoanRepayments += Loans.Repayment;
                    END ELSE BEGIN
                      LoanRepayments+=(Loans."Outstanding Balance" + Loans."Oustanding Interest");
                    END;
                  END;
                UNTIL Loans.NEXT = 0
              END;
            UNTIL LoanTypes.NEXT = 0;
          END;

          LoanBalance := 0;

          LoanRepayments:=0;
          LoanRepaymentRecFromSal:=0;
          Loans.RESET;
          Loans.SETRANGE("Client Code",saccoAccount."BOSA Account No");
          Loans.SETRANGE("Loan Product Type",LoanProductType);
          Loans.SETFILTER(Loans."Loan Product Type",'A01');
          Loans.SETFILTER("Outstanding Balance",'>0');
          IF Loans.FINDFIRST THEN BEGIN
              REPEAT
                  Loans.CALCFIELDS("Outstanding Balance");
                  LoanBalance += Loans."Outstanding Balance";
              UNTIL Loans.NEXT = 0;
              IF LoanBalance > 0 THEN BEGIN

              END;
          END;

          MaxLoanAmount := GetGrossSalary(AccountNo,LoanProductType);

          LoanLimit := 0;
          SalaryLoans.RESET;
          SalaryLoans.SETRANGE(SalaryLoans."Client Code",saccoAccount."BOSA Account No");
          SalaryLoans.SETRANGE(SalaryLoans."Recovery Mode",SalaryLoans."Recovery Mode"::Salary);
          SalaryLoans.SETFILTER(SalaryLoans."Outstanding Balance",'>0');
          IF SalaryLoans.FINDFIRST THEN  BEGIN
            REPEAT
              SalaryLoans.CALCFIELDS(SalaryLoans."Outstanding Balance");
              LoanRepaymentRecFromSal += SalaryLoans.Repayment;
              IF SalaryLoans."Loan Product Type" = LoanType.Code  THEN BEGIN
                SameLoanRepayments += SalaryLoans.Repayment;
                SameLoanOutstandingBal += SalaryLoans."Outstanding Balance";
              END;
            UNTIL SalaryLoans.NEXT = 0;
          END;

          STO.RESET;
          STO.SETRANGE(STO."Source Account No.",saccoAccount."No.");
          STO.SETRANGE(STO.Status,STO.Status::Approved);
          IF STO.FINDFIRST THEN BEGIN
            REPEAT
              STO.CALCFIELDS(STO."Allocated Amount");
              STODeductions += STO."Allocated Amount";
            UNTIL STO.NEXT = 0;
          END;

          IF Members."Employer Code" <> 'STAFF' THEN SalaryPostingCharge := 144;
          NetSalaryAmount := ((MaxLoanAmount*0.72)-((LoanRepaymentRecFromSal)+(STODeductions)+(SalaryPostingCharge)));

          CoopSetup.RESET;
          CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Loan Disbursement");
          IF CoopSetup.FINDFIRST THEN BEGIN
              GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,Safcom,0);
              TotalCharge:=SaccoFee+VendorCommission;
          END;

          LoanLimit := ROUND(NetSalaryAmount / ((LoanType."Interest rate"/12/100) / (1 - POWER((1 + (LoanType."Interest rate"/12/100)),- LoanType."Default Installements"))),1000,'<');

          IF (LoanLimit-TotalCharge) < LoanType."Min. Loan Amount" THEN
            LoanLimit := 0;

          IF LoanLimit > LoanType."Max. Loan Amount" THEN
            LoanLimit := LoanType."Max. Loan Amount";

          MaxLoanAmount := LoanLimit;

          END;
      END;

      EXIT(ROUND(MaxLoanAmount,1,'<'));
    END;

    PROCEDURE GetSalaryLoanQualifiedAmount@1120054028(AccountNo@1000 : Code[20];LoanProductType@1004 : Code[20];VAR LoanLimit@1120054003 : Decimal;VAR Remark@1120054041 : Text[250]) : Decimal;
    VAR
      LoanBalance@1001 : Decimal;
      MaxLoanAmount@1002 : Decimal;
      saccoAccount@1003 : Record 23;
      LoanType@1005 : Record 51516240;
      LoanRep@1006 : Decimal;
      nDays@1007 : Decimal;
      DepAmt@1008 : Decimal;
      Loans@1120054000 : Record 51516230;
      SaccoSetup@1120054001 : Record 51516700;
      RatingLoanLimit@1120054002 : Decimal;
      PenaltyCounter@1120054009 : Record 51516443;
      LoansRegister@1120054008 : Record 51516230;
      MemberLedgerEntry@1120054007 : Record 51516224;
      NumberOfMonths@1120054006 : Integer;
      DayLoanPaid@1120054005 : Date;
      Continue@1120054004 : Boolean;
      SalaryProcessingLines@1120054010 : Record 51516317;
      PayrollMonthlyTransactions@1120054011 : Record 51516183;
      MaxLoanAmtPossible@1120054012 : Decimal;
      SalBuffer@1120054013 : Record 51516317;
      StandingOrders@1120054014 : Record 51516307;
      DepAcc@1120054015 : Record 51516223;
      Salary1@1120054016 : Decimal;
      Salary2@1120054017 : Decimal;
      Salary3@1120054018 : Decimal;
      SalEnd@1120054019 : ARRAY [5] OF Date;
      SalStart@1120054020 : ARRAY [5] OF Date;
      NetSal@1120054024 : Decimal;
      IntAmt@1120054025 : Decimal;
      ProdFac@1120054026 : Record 51516240;
      GrossSalaryAmount@1120054027 : Decimal;
      NetSalaryAmount@1120054028 : Decimal;
      SalaryLoans@1120054029 : Record 51516230;
      STO@1120054030 : Record 51516307;
      LoanRepayments@1120054031 : Decimal;
      STODeductions@1120054032 : Decimal;
      SameLoanRepayments@1120054033 : Decimal;
      SameLoanOutstandingBal@1120054034 : Decimal;
      CoopSetup@1120054035 : Record 51516704;
      TotalCharge@1120054036 : Decimal;
      SaccoFee@1120054037 : Decimal;
      VendorCommission@1120054038 : Decimal;
      SMSCharge@1120054039 : Decimal;
      Members@1120054040 : Record 51516223;
      SaccoAcc@1120054042 : Record 23;
      i@1120054021 : Integer;
      SalaryAmount@1120054022 : ARRAY [5] OF Decimal;
      EmployerCode@1120054023 : Code[30];
      LoanRepaymentRecFromSal@1120054043 : Decimal;
      SalaryPostingCharge@1120054044 : Decimal;
    BEGIN
      MaxLoanAmount := 0;
      Remark := '';
      GrossSalaryAmount :=0;
      saccoAccount.RESET;
      saccoAccount.SETRANGE("No.",AccountNo);
      IF saccoAccount.FIND('-') THEN BEGIN

        Members.GET(saccoAccount."BOSA Account No");
        IF Members.Status<>Members.Status::Active THEN BEGIN
          LoanLimit:=0;
          Remark := 'Your Member Account is not active';
          EXIT;
        END;

        IF Members."Loan Defaulter" = TRUE THEN BEGIN
          LoanLimit:=0;
          Remark := 'You are not eligible for this product because you are listed as a defaulter';
          EXIT;
        END;


        SaccoAcc.RESET;
        SaccoAcc.SETRANGE("No.",AccountNo);
        IF SaccoAcc.FINDFIRST THEN BEGIN
          IF SaccoAcc.Status <> SaccoAcc.Status::Active THEN BEGIN
            LoanLimit :=0;
            Remark := 'Your depopsit contribution is inactive';
            EXIT;
          END;
        END;


        IF LoanType.GET(LoanProductType) THEN BEGIN
          LoanBalance := 0;

          Loans.RESET;
          Loans.SETRANGE("Client Code",saccoAccount."BOSA Account No");
          Loans.SETRANGE("Loan Product Type",LoanProductType);
          Loans.SETFILTER(Loans."Loan Product Type",'A01');
          Loans.SETFILTER("Outstanding Balance",'>0');
          IF Loans.FINDFIRST THEN BEGIN
            REPEAT
              Loans.CALCFIELDS("Outstanding Balance");
              LoanBalance += Loans."Outstanding Balance";
            UNTIL Loans.NEXT = 0;
            IF LoanBalance > 0 THEN BEGIN
              MaxLoanAmount := 0;
              Remark:= 'You already have an existing loan';
              EXIT;
            END;
          END;

          MaxLoanAmount := 0;

          EmployerCode:=Members."Employer Code";

          MaxLoanAmount := GetGrossSalary(AccountNo,LoanProductType);

          LoanLimit := 0;
          LoanRepaymentRecFromSal:=0;
          SalaryLoans.RESET;
          SalaryLoans.SETRANGE(SalaryLoans."Client Code",saccoAccount."BOSA Account No");
          SalaryLoans.SETRANGE(SalaryLoans."Recovery Mode",SalaryLoans."Recovery Mode"::Salary);
          SalaryLoans.SETFILTER(SalaryLoans."Outstanding Balance",'>0');
          IF SalaryLoans.FINDFIRST THEN  BEGIN
            REPEAT
              SalaryLoans.CALCFIELDS(SalaryLoans."Outstanding Balance");
              LoanRepaymentRecFromSal += SalaryLoans.Repayment;
              IF SalaryLoans."Loan Product Type" = LoanType.Code  THEN BEGIN
                SameLoanRepayments += SalaryLoans.Repayment;
                SameLoanOutstandingBal += SalaryLoans."Outstanding Balance";
              END;
            UNTIL SalaryLoans.NEXT = 0;
          END;

          STO.RESET;
          STO.SETRANGE(STO."Source Account No.",saccoAccount."No.");
          STO.SETRANGE(STO.Status,STO.Status::Approved);
          IF STO.FINDFIRST THEN BEGIN
            REPEAT
              STO.CALCFIELDS(STO."Allocated Amount");
              STODeductions += STO."Allocated Amount";
            UNTIL STO.NEXT = 0;
          END;
          IF Members."Employer Code" <> 'STAFF' THEN SalaryPostingCharge := 144;
          NetSalaryAmount := ((MaxLoanAmount*0.72)-((LoanRepaymentRecFromSal)+(STODeductions)+(SalaryPostingCharge)));

          CoopSetup.RESET;
          CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Loan Disbursement");
          IF CoopSetup.FINDFIRST THEN BEGIN
            GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,Safcom,0);
            TotalCharge:=SaccoFee+VendorCommission;
          END;

          LoanLimit := ROUND(NetSalaryAmount / ((LoanType."Interest rate"/12/100) / (1 - POWER((1 + (LoanType."Interest rate"/12/100)),- LoanType."Default Installements"))),100,'<');

          IF (LoanLimit-TotalCharge) < LoanType."Min. Loan Amount" THEN BEGIN
            LoanLimit := 0;
            Remark:= 'You qualify for ' + FORMAT(LoanLimit) + ' which is less than the minimum amount';
            EXIT;
          END;

          IF LoanLimit > LoanType."Max. Loan Amount" THEN
            LoanLimit := LoanType."Max. Loan Amount";

          MaxLoanAmount := LoanLimit;
        END;
      END;

      EXIT(ROUND(MaxLoanAmount,1,'<'));
    END;

    PROCEDURE GetLoanQualifiedAmount@10(AccountNo@1000 : Code[20];LoanProductType@1004 : Code[20];VAR Msg@1120054043 : Text[250];VAR LoanLimit@1120054003 : Decimal) : Decimal;
    VAR
      LoanBalance@1001 : Decimal;
      MaxLoanAmount@1002 : Decimal;
      saccoAccount@1003 : Record 23;
      LoanType@1005 : Record 51516240;
      LoanRep@1006 : Decimal;
      nDays@1007 : Decimal;
      DepAmt@1008 : Decimal;
      Loans@1120054000 : Record 51516230;
      SaccoSetup@1120054001 : Record 51516700;
      RatingLoanLimit@1120054002 : Decimal;
      PenaltyCounter@1120054009 : Record 51516443;
      LoansRegister@1120054008 : Record 51516230;
      MemberLedgerEntry@1120054007 : Record 51516224;
      NumberOfMonths@1120054006 : Integer;
      DayLoanPaid@1120054005 : Date;
      Continue@1120054004 : Boolean;
      SalaryProcessingLines@1120054010 : Record 51516317;
      PayrollMonthlyTransactions@1120054011 : Record 51516183;
      MaxLoanAmtPossible@1120054012 : Decimal;
      SalBuffer@1120054013 : Record 51516317;
      StandingOrders@1120054014 : Record 51516307;
      DepAcc@1120054015 : Record 51516223;
      Salary1@1120054016 : Decimal;
      Salary2@1120054017 : Decimal;
      Salary3@1120054018 : Decimal;
      SalEnd@1120054019 : ARRAY [5] OF Date;
      SalStart@1120054020 : ARRAY [5] OF Date;
      Date3@1120054021 : Date;
      Date1@1120054022 : Date;
      Date2@1120054023 : Date;
      NetSal@1120054024 : Decimal;
      IntAmt@1120054025 : Decimal;
      ProdFac@1120054026 : Record 51516240;
      GrossSalaryAmount@1120054027 : Decimal;
      NetSalaryAmount@1120054028 : Decimal;
      SalaryLoans@1120054029 : Record 51516230;
      STO@1120054030 : Record 51516307;
      LoanRepayments@1120054031 : Decimal;
      STODeductions@1120054032 : Decimal;
      SameLoanRepayments@1120054033 : Decimal;
      SameLoanOutstandingBal@1120054034 : Decimal;
      CoopSetup@1120054035 : Record 51516704;
      TotalCharge@1120054036 : Decimal;
      SaccoFee@1120054037 : Decimal;
      VendorCommission@1120054038 : Decimal;
      SMSCharge@1120054039 : Decimal;
      MemberNo@1120054040 : Code[30];
      MobileLoan@1120054041 : Record 51516713;
      LoanProductsSetup@1120054042 : Record 51516240;
      LoanProduct@1120054044 : Record 51516240;
      SavAcc@1120054045 : Record 23;
      Repaymentdiff@1120054046 : Decimal;
      Fromdate@1120054047 : Date;
      Todate@1120054048 : Date;
      Customers@1120054049 : Record 51516223;
      i@1120054051 : Integer;
      SalaryAmount@1120054050 : ARRAY [5] OF Decimal;
      EmployerCode@1120054053 : Code[30];
      SalaryPostingCharge@1120054052 : Decimal;
    BEGIN
      MaxLoanAmount := 0;
      saccoAccount.RESET;
      saccoAccount.SETRANGE("No.",AccountNo);
      IF saccoAccount.FIND('-') THEN BEGIN
        IF LoanType.GET(LoanProductType) THEN BEGIN
          LoanBalance := 0;
          LoanRep := 0;

          Loans.RESET;
          Loans.SETRANGE("Client Code",saccoAccount."BOSA Account No");
          Loans.SETRANGE("Loan Product Type",LoanProductType);
          Loans.SETFILTER("Outstanding Balance",'>0');
          IF Loans.FINDFIRST THEN BEGIN
            REPEAT
              Loans.CALCFIELDS("Outstanding Balance");
              LoanBalance += Loans."Outstanding Balance";
            UNTIL Loans.NEXT = 0;
          END;

          LoanRep += LoanBalance;

          MaxLoanAmount := LoanType."Max. Loan Amount";

          Loans.RESET;
          Loans.SETRANGE("Client Code",MemberNo);
          Loans.SETFILTER(Loans."Loan Product Type",MobileLoan."Loan Product Type");
          Loans.SETFILTER("Outstanding Balance",'>0');
          IF Loans.FINDFIRST THEN BEGIN
            LoanProductsSetup.GET(Loans."Loan Product Type");

            Msg:='Your '+LoanProduct."Product Description"+' request on '+DateTimeToText(CURRENTDATETIME)+' has failed, You have an active '+LoanProduct."USSD Product Name";
            MobileLoan.Remarks:='Member has active Loan No. '+Loans."Loan  No."+' - '+LoanProduct."Product Description";
            MobileLoan.Status:=MobileLoan.Status::Failed;
            MobileLoan.Posted:=TRUE;
            MobileLoan."Date Posted":=CURRENTDATETIME;
            MobileLoan.Message:=Msg;
            SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",Msg,FORMAT(MobileLoan."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
            MobileLoan.MODIFY;
            Continue:=FALSE;
          END;
          Fromdate := CALCDATE('-1M-CM',TODAY);

          IF Customers.GET(saccoAccount."BOSA Account No") THEN BEGIN
            IF Customers."Employer Code" = 'POSTAL CORP' THEN
              Fromdate :=CALCDATE('-3M-CM',TODAY);
          END;


          SalaryProcessingLines.RESET;
          SalaryProcessingLines.SETRANGE(SalaryProcessingLines.Date,Fromdate,TODAY);
          SalaryProcessingLines.SETRANGE(SalaryProcessingLines."Account No.",AccountNo);
          IF SalaryProcessingLines.FINDFIRST THEN BEGIN
            MaxLoanAmount := LoanType."Salaried Max Loan Amount";
          END;

          PayrollMonthlyTransactions.RESET;
          PayrollMonthlyTransactions.SETRANGE(PayrollMonthlyTransactions."No.",saccoAccount."Staff No");
          PayrollMonthlyTransactions.SETRANGE(PayrollMonthlyTransactions."Payroll Period",CALCDATE('-1M-CM',TODAY),TODAY);
          PayrollMonthlyTransactions.SETRANGE(PayrollMonthlyTransactions."Transaction Code",'NPAY');
          IF PayrollMonthlyTransactions.FINDFIRST THEN
            MaxLoanAmount := LoanType."Salaried Max Loan Amount";

          MaxLoanAmtPossible := MaxLoanAmount;
          SaccoSetup.GET;
          RatingLoanLimit := 0;

          SaccoSetup.TESTFIELD("Initial Loan Limit");
          SaccoSetup.TESTFIELD("Maximum Mobile Loan Limit");
          //1st Loan
          CreditRating.RESET;
          CreditRating.SETCURRENTKEY("Date Entered");
          CreditRating.SETRANGE("Member No",saccoAccount."BOSA Account No");
          CreditRating.SETRANGE("Loan Product Type",LoanProductType);
          IF NOT CreditRating.FINDFIRST THEN BEGIN
            RatingLoanLimit := SaccoSetup."Initial Loan Limit";
          END ELSE BEGIN
            //Subsequent Loan
            CreditRating.RESET;
            CreditRating.SETCURRENTKEY("Date Entered");
            CreditRating.SETRANGE("Member No",saccoAccount."BOSA Account No");
            CreditRating.SETRANGE("Loan Product Type",LoanProductType);
            IF CreditRating.FINDLAST THEN BEGIN
              IF CreditRating."Loan Limit" <= 0 THEN
                CreditRating."Loan Limit" := SaccoSetup."Initial Loan Limit";

              RatingLoanLimit := CreditRating."Loan Limit";
              IF CALCDATE('1M',CreditRating."Date Entered") <= TODAY THEN
                RatingLoanLimit := CreditRating."Loan Limit"+SaccoSetup."Loan Increment";

            END;
          END;

          PenaltyCounter.RESET;
          PenaltyCounter.SETCURRENTKEY(PenaltyCounter."Date Entered");
          PenaltyCounter.SETRANGE(PenaltyCounter."Member Number",saccoAccount."BOSA Account No");
          PenaltyCounter.SETRANGE(PenaltyCounter."Product Type",LoanProductType);
          IF PenaltyCounter.FINDLAST THEN BEGIN
            LoansRegister.GET(PenaltyCounter."Loan Number");
            LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest",LoansRegister."Oustanding Penalty");
            IF (LoansRegister."Outstanding Balance"+LoansRegister."Oustanding Interest"+LoansRegister."Oustanding Penalty") > 0 THEN BEGIN
              RatingLoanLimit := 0;
            END ELSE BEGIN
              IF PenaltyCounter."Date Penalty Paid" = 0D THEN BEGIN
                RatingLoanLimit := 0;
              END ELSE BEGIN
                DayLoanPaid := PenaltyCounter."Date Penalty Paid";

                NumberOfMonths:=0;
                RatingLoanLimit := SaccoSetup."Defaulter Initial Limit";
                IF TODAY > CALCDATE('3M',DayLoanPaid) THEN BEGIN
                  //count the number of moths from month 7
                  NumberOfMonths := ROUND(((TODAY - CALCDATE('3M',DayLoanPaid))/30),1,'<');
                  //each month is equivalent a 1000 untill its about to surpass the max loan
                  RatingLoanLimit := SaccoSetup."Defaulter Initial Limit"+(SaccoSetup."Defaulter Loan Increment"*NumberOfMonths)
                END;
              END;
            END;
          END;

          LoanLimit := RatingLoanLimit;

          IF MaxLoanAmount > RatingLoanLimit THEN
            MaxLoanAmount := RatingLoanLimit;

          IF MaxLoanAmount > GetMaximumMobileLoanLimit THEN
            MaxLoanAmount := GetMaximumMobileLoanLimit;

          IF LoanLimit > MaxLoanAmount THEN
            LoanLimit := MaxLoanAmount;

          IF Loans."Loan Product Type" <> 'A16' THEN BEGIN
            IF LoanBalance > 0 THEN BEGIN
              MaxLoanAmount := 0;
              Msg := 'You have an existing loan of this type, kindly offset the loan and try again.';
            END;
          END;

          IF MaxLoanAmount > MaxLoanAmtPossible THEN
            MaxLoanAmount := MaxLoanAmtPossible;

          IF LoanBalance > 0 THEN
            MaxLoanAmount := 0;

          IF MaxLoanAmount < 0 THEN
            MaxLoanAmount := 0;

          IF LoanProductType = 'A16' THEN BEGIN
            saccoAccount.RESET;
            saccoAccount.SETRANGE(saccoAccount."No.", AccountNo);
            IF saccoAccount.FINDFIRST THEN BEGIN
              GrossSalaryAmount:=0;
              GrossSalaryAmount := saccoAccount."Net Salary";
            END;

            GrossSalaryAmount := GetGrossSalary(AccountNo,LoanProductType);

            MaxLoanAmount := 0;
            LoanLimit := 0;
            SalaryLoans.RESET;
            SalaryLoans.SETRANGE(SalaryLoans."Client Code",saccoAccount."BOSA Account No");
            SalaryLoans.SETRANGE(SalaryLoans."Recovery Mode",SalaryLoans."Recovery Mode"::Salary);
            SalaryLoans.SETFILTER(SalaryLoans."Outstanding Balance",'>0');
            SalaryLoans.SETFILTER(SalaryLoans."Loan Product Type" ,'<> A16');
            IF SalaryLoans.FINDFIRST THEN  BEGIN
              REPEAT
                SalaryLoans.CALCFIELDS(SalaryLoans."Outstanding Balance");
                LoanRepayments += SalaryLoans.Repayment;
                IF SalaryLoans."Loan Product Type" = LoanType.Code  THEN BEGIN
                  SameLoanRepayments += SalaryLoans.Repayment;
                END;
              UNTIL SalaryLoans.NEXT = 0;
            END;
            SameLoanOutstandingBal:=0;

            Loans.RESET;
            Loans.SETRANGE(Loans."Client Code",saccoAccount."BOSA Account No");
            Loans.SETRANGE(Loans."Recovery Mode",Loans."Recovery Mode"::Salary);
            Loans.SETFILTER(Loans."Loan Product Type" ,'A16');
            IF Loans.FINDFIRST THEN BEGIN
              REPEAT
                Loans.CALCFIELDS(Loans."Outstanding Balance");
                SameLoanOutstandingBal+= Loans."Outstanding Balance";
              UNTIL Loans.NEXT=0;
            END;

            STO.RESET;
            STO.SETRANGE(STO."Source Account No.",saccoAccount."No.");
            STO.SETRANGE(STO.Status,STO.Status::Approved);
            IF STO.FINDFIRST THEN BEGIN
              REPEAT
                STO.CALCFIELDS(STO."Allocated Amount");
                STODeductions += STO."Allocated Amount";
              UNTIL STO.NEXT = 0;
            END;
            IF Members."Employer Code" <> 'STAFF' THEN SalaryPostingCharge := 144;
            NetSalaryAmount := (GrossSalaryAmount*0.72) -(((LoanRepayments-Repaymentdiff)+SameLoanOutstandingBal)+STODeductions+SalaryPostingCharge);
            IF NetSalaryAmount < 0 THEN
              NetSalaryAmount:=0;

            CoopSetup.RESET;
            CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Loan Disbursement");
            IF CoopSetup.FINDFIRST THEN BEGIN
                GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,Safcom,0);
                TotalCharge:=SaccoFee+VendorCommission;
            END;

            LoanLimit := ROUND(NetSalaryAmount / ((LoanType."Interest rate"/12/100) / (1 - POWER((1 + (LoanType."Interest rate"/12/100)),- LoanType."Default Installements"))),1000,'<');

            IF (LoanLimit-TotalCharge) < LoanType."Min. Loan Amount" THEN
              LoanLimit := 0;

            IF (LoanLimit-(SameLoanOutstandingBal-TotalCharge)) < LoanType."Min. Loan Amount" THEN
              LoanLimit := 0;

            IF LoanLimit > LoanType."Max. Loan Amount" THEN
              LoanLimit := LoanType."Max. Loan Amount";
          END;
        END;
      END;
    END;

    PROCEDURE GetOverdraftLoanQualifiedAmount@1120054034(AccountNo@1000 : Code[20];LoanProductType@1004 : Code[20];VAR LoanLimit@1120054003 : Decimal;VAR Remark@1120054041 : Text[250]) : Decimal;
    VAR
      LoanBalance@1001 : Decimal;
      MaxLoanAmount@1002 : Decimal;
      saccoAccount@1003 : Record 23;
      LoanType@1005 : Record 51516240;
      LoanRep@1006 : Decimal;
      nDays@1007 : Decimal;
      DepAmt@1008 : Decimal;
      Loans@1120054000 : Record 51516230;
      SaccoSetup@1120054001 : Record 51516700;
      RatingLoanLimit@1120054002 : Decimal;
      PenaltyCounter@1120054009 : Record 51516443;
      LoansRegister@1120054008 : Record 51516230;
      MemberLedgerEntry@1120054007 : Record 51516224;
      NumberOfMonths@1120054006 : Integer;
      DayLoanPaid@1120054005 : Date;
      Continue@1120054004 : Boolean;
      SalaryProcessingLines@1120054010 : Record 51516317;
      PayrollMonthlyTransactions@1120054011 : Record 51516183;
      MaxLoanAmtPossible@1120054012 : Decimal;
      SalBuffer@1120054013 : Record 51516317;
      StandingOrders@1120054014 : Record 51516307;
      DepAcc@1120054015 : Record 51516223;
      Salary1@1120054016 : Decimal;
      Salary2@1120054017 : Decimal;
      Salary3@1120054018 : Decimal;
      Salary4@1120054023 : Decimal;
      Salary5@1120054043 : Decimal;
      SalEnd@1120054019 : ARRAY [5] OF Date;
      SalStart@1120054020 : ARRAY [5] OF Date;
      NetSal@1120054024 : Decimal;
      IntAmt@1120054025 : Decimal;
      ProdFac@1120054026 : Record 51516240;
      GrossSalaryAmount@1120054027 : Decimal;
      NetSalaryAmount@1120054028 : Decimal;
      SalaryLoans@1120054029 : Record 51516230;
      STO@1120054030 : Record 51516307;
      LoanRepayments@1120054031 : Decimal;
      STODeductions@1120054032 : Decimal;
      SameLoanRepayments@1120054033 : Decimal;
      SameLoanOutstandingBal@1120054034 : Decimal;
      CoopSetup@1120054035 : Record 51516704;
      TotalCharge@1120054036 : Decimal;
      SaccoFee@1120054037 : Decimal;
      VendorCommission@1120054038 : Decimal;
      SMSCharge@1120054039 : Decimal;
      Members@1120054040 : Record 51516223;
      SaccoAcc@1120054042 : Record 23;
      i@1120054021 : Integer;
      SalaryAmount@1120054022 : ARRAY [5] OF Decimal;
      SaccoEmployers@1120054044 : Record 51516260;
      EmployerCode@1120054045 : Code[30];
      MemberNo@1120054046 : Code[30];
    BEGIN
      MaxLoanAmount := 0;
      Remark := '';
      EmployerCode := '';
      GrossSalaryAmount :=0;
      saccoAccount.RESET;
      saccoAccount.SETRANGE("No.",AccountNo);
      IF saccoAccount.FIND('-') THEN BEGIN
        MemberNo := saccoAccount."BOSA Account No";
        Members.GET(MemberNo);

        IF Members.Status<>Members.Status::Active THEN BEGIN
          LoanLimit:=0;
          Remark := 'Your Member Account is not active';
          EXIT;
        END;

        IF Members."Loan Defaulter" = TRUE THEN BEGIN
          LoanLimit:=0;
          Remark := 'You are not eligible for this product because you are listed as a defaulter';
          EXIT;
        END;

        SaccoAcc.RESET;
        SaccoAcc.SETRANGE("No.",AccountNo);
        IF SaccoAcc.FINDFIRST THEN BEGIN
          IF SaccoAcc.Status <> SaccoAcc.Status::Active THEN BEGIN
            LoanLimit :=0;
            Remark := 'Your depopsit contribution is inactive';
            EXIT;
          END;
        END;

        IF LoanType.GET(LoanProductType) THEN BEGIN
          LoanBalance := 0;

          Loans.RESET;
          Loans.SETRANGE("Client Code",saccoAccount."BOSA Account No");
          Loans.SETRANGE("Loan Product Type",LoanProductType);
          Loans.SETFILTER(Loans."Loan Product Type",'M_OD');
          Loans.SETFILTER("Outstanding Balance",'>0');
          IF Loans.FINDFIRST THEN BEGIN
            REPEAT
              Loans.CALCFIELDS("Outstanding Balance");
              LoanBalance += Loans."Outstanding Balance";
            UNTIL Loans.NEXT = 0;
            IF LoanBalance > 0 THEN BEGIN
              MaxLoanAmount := 0;
              Remark:= 'You already have an existing loan';
              EXIT;
            END;
          END;

          MaxLoanAmount := GetGrossSalary(AccountNo,LoanProductType);

          LoanLimit := 0;
          SalaryLoans.RESET;
          SalaryLoans.SETRANGE(SalaryLoans."Client Code",saccoAccount."BOSA Account No");
          SalaryLoans.SETRANGE(SalaryLoans."Recovery Mode",SalaryLoans."Recovery Mode"::Salary);
          SalaryLoans.SETFILTER(SalaryLoans."Outstanding Balance",'>0');
          IF SalaryLoans.FINDFIRST THEN  BEGIN
            REPEAT
              SalaryLoans.CALCFIELDS(SalaryLoans."Outstanding Balance");
              LoanRepayments += SalaryLoans.Repayment;
              IF SalaryLoans."Loan Product Type" = LoanType.Code  THEN BEGIN
                SameLoanRepayments += SalaryLoans.Repayment;
                SameLoanOutstandingBal += SalaryLoans."Outstanding Balance";
              END;
            UNTIL SalaryLoans.NEXT = 0;
          END;

          STO.RESET;
          STO.SETRANGE(STO."Source Account No.",saccoAccount."No.");
          STO.SETRANGE(STO.Status,STO.Status::Approved);
          IF STO.FINDFIRST THEN BEGIN
            REPEAT
              STO.CALCFIELDS(STO."Allocated Amount");
              STODeductions += STO."Allocated Amount";
            UNTIL STO.NEXT = 0;
          END;

          NetSalaryAmount := ROUND((0.82*MaxLoanAmount),100,'<');

          IF NetSalaryAmount < 0 THEN
            NetSalaryAmount:=0;

          CoopSetup.RESET;
          CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Loan Disbursement");
          IF CoopSetup.FINDFIRST THEN BEGIN
              GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,Safcom,0);
              TotalCharge:=SaccoFee+VendorCommission;
          END;

          LoanLimit := ROUND(((NetSalaryAmount)-((LoanRepayments)+(STODeductions))),100,'<');

          IF (LoanLimit-TotalCharge) < LoanType."Min. Loan Amount" THEN BEGIN
            LoanLimit := 0;
            Remark:= 'You qualify for ' + FORMAT(LoanLimit) + ' which is less than the minimum amount';
            EXIT;
          END;

          IF LoanLimit > LoanType."Max. Loan Amount" THEN
            LoanLimit := LoanType."Max. Loan Amount";
          MaxLoanAmount := LoanLimit;
          END;
      END;

      EXIT(ROUND(MaxLoanAmount,1,'<'));
    END;

    PROCEDURE GetGrossSalary@1120054036(AccountNo@1000 : Code[20];ProductType@1120054000 : Code[10]) GrossSalary : Decimal;
    VAR
      saccoAccount@1003 : Record 23;
      SalaryProcessingLines@1120054010 : Record 51516317;
      PayrollMonthlyTransactions@1120054011 : Record 51516183;
      SalBuffer@1120054013 : Record 51516317;
      SalEnd@1120054019 : ARRAY [5] OF Date;
      SalStart@1120054020 : ARRAY [5] OF Date;
      i@1120054021 : Integer;
      SalaryAmount@1120054022 : ARRAY [5] OF Decimal;
      EmployerCode@1120054023 : Code[30];
    BEGIN

      saccoAccount.RESET;
      saccoAccount.SETRANGE("No.",AccountNo);
      IF saccoAccount.FIND('-') THEN BEGIN
        Members.GET(saccoAccount."BOSA Account No");
        EmployerCode:=Members."Employer Code";
        GrossSalary := 0;
        FOR i := 5 DOWNTO 1 DO BEGIN
          SalStart[i] := 0D; SalStart[i] := CALCDATE('-'+FORMAT(i)+'M-CM',TODAY);
          SalEnd[i]:= 0D; SalEnd[i]:= CALCDATE('CM',SalStart[i]);
          SalaryAmount[i] := 0;
          SalaryProcessingLines.RESET;
          SalaryProcessingLines.SETRANGE(SalaryProcessingLines.Date,SalStart[i],SalEnd[i]);
          SalaryProcessingLines.SETRANGE(SalaryProcessingLines."Account No.",AccountNo);
          SalaryProcessingLines.SETFILTER(SalaryProcessingLines.Type,'%1|%2',SalaryProcessingLines.Type::Salary,SalaryProcessingLines.Type::Pension);
          IF ProductType = 'M_OD' THEN
            SalaryProcessingLines.SETFILTER(SalaryProcessingLines."Document No.",'<> STAFF WELFARE MAY-23' );//overdraft
          IF SalaryProcessingLines.FINDFIRST THEN BEGIN
            SalaryAmount[i] := SalaryProcessingLines.Amount;
          END ELSE BEGIN
            PayrollMonthlyTransactions.RESET;
            PayrollMonthlyTransactions.SETRANGE(PayrollMonthlyTransactions."No.",saccoAccount."Staff No");
            PayrollMonthlyTransactions.SETRANGE(PayrollMonthlyTransactions."Payroll Period",SalStart[i],SalEnd[i]);
            PayrollMonthlyTransactions.SETRANGE(PayrollMonthlyTransactions."Transaction Code",'NPAY');
            IF PayrollMonthlyTransactions.FINDFIRST THEN
              SalaryAmount[i] := PayrollMonthlyTransactions.Amount;
          END;
        END;


        IF Members."Employer Code" ='POSTAL CORP' THEN BEGIN
          GrossSalary := SalaryAmount[1]; //initialising with one sal
          FOR i:= 2 TO 5 DO BEGIN //starting loop with the second salary
            IF SalaryAmount[i] > 0 THEN BEGIN //if the second or any of sal is present thats when we compare
              IF GrossSalary = 0 THEN GrossSalary := SalaryAmount[i]; //if the first sal was 0, we reinitialize before comparing
              IF SalaryAmount[i] <  GrossSalary THEN
                GrossSalary := SalaryAmount[i];
            END;
          END;
        END ELSE BEGIN
          IF (SalaryAmount[1] = 0) OR (SalaryAmount[2] = 0) OR (SalaryAmount[3] = 0) THEN BEGIN
            GrossSalary := 0;
          END;

          GrossSalary := SalaryAmount[1];
          FOR i:= 2 TO 3 DO BEGIN
            IF SalaryAmount[i] <  GrossSalary THEN
              GrossSalary := SalaryAmount[i];
          END;
        END;
      END;

      EXIT(GrossSalary);
    END;

    PROCEDURE GenerateNewPin@36(MobileNo@1005 : Code[20]) PinSent : Boolean;
    VAR
      SkyworldUSSDAuth@1003 : Record 51516709;
      NewPin@1000 : Text;
      NewIntPin@1001 : Integer;
      SavAcc@1002 : Record 23;
      Msg@1004 : Text;
    BEGIN
      MobileNo:='+'+MobileNo;

      SaccoSetup.GET;
      SaccoSetup.TESTFIELD("Mbanking Application Name");
      SaccoSetup.TESTFIELD("USSD Code");

      PinSent:=FALSE;
      SkyworldUSSDAuth.RESET;
      SkyworldUSSDAuth.SETRANGE("Mobile No.",MobileNo);
      IF SkyworldUSSDAuth.FINDFIRST THEN BEGIN
          Priority := 200;
          NewPin := RandomPIN;

          SavAcc.RESET;
          SavAcc.SETRANGE("Transactional Mobile No",SkyworldUSSDAuth."Mobile No.");
          IF SavAcc.FINDFIRST THEN BEGIN
              IF NOT CheckBlackList(SavAcc."Transactional Mobile No",SavAcc."No.",SavAcc.Name) THEN BEGIN
                  Msg := 'Dear '+SavAcc.Name+' your '+SaccoSetup."Mbanking Application Name"+' PIN is '+NewPin+'. Dial '+SaccoSetup."USSD Code"+' to access this service.';
                  SendSms(Source::MOBILE_PIN,SkyworldUSSDAuth."Mobile No.",Msg,SavAcc."No.",SavAcc."No.",TRUE,Priority,TRUE);

                  SkyworldUSSDAuth."PIN No.":=NewPin;
                  SkyworldUSSDAuth."Pin Sent":=TRUE;
                  SkyworldUSSDAuth."Reset PIN":=FALSE;
                  SkyworldUSSDAuth."Initial PIN Sent":=TRUE;
                  SkyworldUSSDAuth."Force PIN":=TRUE;
                      SkyworldUSSDAuth."PIN Encrypted":=FALSE;
                  SkyworldUSSDAuth.MODIFY;
                  PinSent := TRUE;
              END;
          END;

      END;
    END;

    PROCEDURE PinReset@35() CurrentUSSDPIN : Text;
    VAR
      SkyworldUSSDAuth@1003 : Record 51516709;
      NewPin@1000 : Text;
      NewIntPin@1001 : Integer;
      SavAcc@1002 : Record 23;
      Msg@1004 : Text;
    BEGIN

      SaccoSetup.GET;
      SaccoSetup.TESTFIELD("Mbanking Application Name");
      SaccoSetup.TESTFIELD("USSD Code");

      SkyworldUSSDAuth.RESET;
      SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."Reset PIN",TRUE);
      IF SkyworldUSSDAuth.FINDFIRST THEN BEGIN
          Priority:=200;
          REPEAT
              NewPin:=RandomPIN;
              SavAcc.RESET;
              SavAcc.SETRANGE("Transactional Mobile No",SkyworldUSSDAuth."Mobile No.");
              IF SavAcc.FINDFIRST THEN BEGIN
                  Msg := 'Dear '+SavAcc.Name+' your '+SaccoSetup."Mbanking Application Name"+' PIN is '+NewPin+'. Dial '+SaccoSetup."USSD Code"+' to access this service.';
                  SendSms(Source::MOBILE_PIN,SkyworldUSSDAuth."Mobile No.",Msg,SavAcc."No.",SavAcc."No.",TRUE,Priority,TRUE);

                  SkyworldUSSDAuth."PIN No.":=NewPin;
                  SkyworldUSSDAuth."Pin Sent":=TRUE;
                  SkyworldUSSDAuth."Reset PIN":=FALSE;
                  SkyworldUSSDAuth."Initial PIN Sent":=FALSE;
                  SkyworldUSSDAuth."Force PIN":=TRUE;
                  SkyworldUSSDAuth."PIN Encrypted":=FALSE;
                  SkyworldUSSDAuth.MODIFY;
              END;
          UNTIL SkyworldUSSDAuth.NEXT=0;
      END;
    END;

    PROCEDURE GetCurrentUSSDPIN@15("MobileNo."@1000 : Code[30]) CurrentUSSDPIN : Text;
    VAR
      SkyworldUSSDAuth@1003 : Record 51516709;
    BEGIN
      "MobileNo." := '+'+ "MobileNo.";

      CurrentUSSDPIN:='';

      SkyworldUSSDAuth.RESET;
      SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."Mobile No.","MobileNo.");
      IF SkyworldUSSDAuth.FINDFIRST THEN BEGIN
          CurrentUSSDPIN:=SkyworldUSSDAuth."PIN No.";
      END;
    END;

    PROCEDURE UpdateCurrentUSSDPIN@12("MobileNo."@1000 : Code[30];"NewPINNo."@1001 : Text) USSDPINUpdated : Boolean;
    VAR
      SkyworldUSSDAuth@1003 : Record 51516709;
    BEGIN
      "MobileNo." := '+'+ "MobileNo.";
      USSDPINUpdated:=FALSE;

      SkyworldUSSDAuth.RESET;
      SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."Mobile No.","MobileNo.");
      IF SkyworldUSSDAuth.FINDFIRST THEN BEGIN
          SkyworldUSSDAuth."PIN No.":="NewPINNo.";
          SkyworldUSSDAuth."Force PIN":=FALSE;
          SkyworldUSSDAuth."Initial PIN Sent":=FALSE;
          SkyworldUSSDAuth."Reset PIN":=FALSE;
          SkyworldUSSDAuth.MODIFY;
          USSDPINUpdated:=TRUE;
      END;
    END;

    PROCEDURE CheckKYCByAccountNo@28(PhoneNo@1102755000 : Text[30];AccountNo@1000 : Code[20]) KYCValid : Boolean;
    VAR
      SavAcc@1001 : Record 23;
    BEGIN
      PhoneNo := '+'+ PhoneNo;

      KYCValid:=FALSE;

      SavAcc.RESET;
      SavAcc.SETRANGE("No.",AccountNo);
      SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      SavAcc.SETRANGE(Blocked, SavAcc.Blocked::" ");
      IF SavAcc.FINDFIRST THEN BEGIN
          KYCValid:=TRUE;
      END
    END;

    PROCEDURE GetMemberName@55(PhoneNo@1102755000 : Text[30]) Name : Text;
    VAR
      SavAcc@1001 : Record 23;
      SkyworldUSSDAuth@1000 : Record 51516709;
    BEGIN
      PhoneNo := '+'+ PhoneNo;

      Name:='';
      SavAcc.RESET;
      SavAcc.SETRANGE(SavAcc."Transactional Mobile No",PhoneNo);
      IF SavAcc.FINDFIRST THEN BEGIN
          Name:=SavAcc.Name;
      END;
    END;

    PROCEDURE ActiveMobileMember@26(PhoneNo@1102755000 : Text[30]) AccNo : Text;
    VAR
      SavAcc@1001 : Record 23;
      SkyworldUSSDAuth@1000 : Record 51516709;
    BEGIN
      PhoneNo := '+'+ PhoneNo;

      AccNo:='';
      SkyworldUSSDAuth.RESET;
      SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."Mobile No.",PhoneNo);
      SkyworldUSSDAuth.SETRANGE("User Status",SkyworldUSSDAuth."User Status"::Active);
      IF SkyworldUSSDAuth.FINDFIRST THEN BEGIN
          AccNo:=SkyworldUSSDAuth."Account No.";
      END;
    END;

    PROCEDURE CheckKYCByNationalIDNo@27("PhoneNo."@1102755000 : Text[30];"NationalIDNo."@1000 : Code[20];CurrentPIN@1001 : Text) KYCValid : Boolean;
    VAR
      SkyworldUSSDAuth@1003 : Record 51516709;
      SavAcc@1002 : Record 23;
    BEGIN
      "PhoneNo." := '+'+ "PhoneNo.";

      KYCValid:=FALSE;

      SavAcc.RESET;
      SavAcc.SETRANGE(SavAcc."ID No.","NationalIDNo.");
      SavAcc.SETRANGE("Transactional Mobile No","PhoneNo.");
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      SavAcc.SETRANGE(SavAcc.Blocked, SavAcc.Blocked::" ");
      IF SavAcc.FINDFIRST THEN BEGIN
          SkyworldUSSDAuth.RESET;
          SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."Mobile No.","PhoneNo.");
          SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."PIN No.",CurrentPIN);
          IF SkyworldUSSDAuth.FINDFIRST THEN
              KYCValid:=TRUE;
      END
    END;

    PROCEDURE CheckForcePin@44(Phone@1000 : Text) ForcePin : Boolean;
    VAR
      PinAuth@1001 : Record 51516709;
    BEGIN
      Phone:='+'+Phone;
      ForcePin:=FALSE;

      PinAuth.RESET;
      PinAuth.SETRANGE(PinAuth."Mobile No.",Phone);
      PinAuth.SETRANGE(PinAuth."Force PIN",TRUE);
      PinAuth.SETRANGE(PinAuth."Reset PIN",FALSE);
      IF PinAuth.FINDFIRST THEN BEGIN
          ForcePin := TRUE;
      END;
    END;

    PROCEDURE GetUnsetPin@32() Phone : Text;
    VAR
      PinAuth@1001 : Record 51516709;
    BEGIN
      Phone:='';

      PinAuth.RESET;
      PinAuth.SETRANGE(PinAuth."Reset PIN",TRUE);
      PinAuth.SETRANGE(PinAuth."Force PIN",FALSE);
      IF PinAuth.FINDFIRST THEN BEGIN
          Phone := PinAuth."Mobile No.";
          EXIT(Phone);

      END;
    END;

    PROCEDURE GetForcePin@47() Phone : Text;
    VAR
      PinAuth@1001 : Record 51516709;
    BEGIN
      Phone:='';

      PinAuth.RESET;
      PinAuth.SETRANGE(PinAuth."Reset PIN",TRUE);
      PinAuth.SETRANGE(PinAuth."Force PIN",TRUE);
      IF PinAuth.FINDFIRST THEN BEGIN
          Phone := PinAuth."Mobile No.";
          EXIT(Phone);
      END;
    END;

    PROCEDURE SetNewPin@38(PhoneNo@1001 : Text;OldPin@1002 : Text;NewPin@1003 : Text) Response : Text;
    VAR
      SkyworldUSSDAuth@1000 : Record 51516709;
    BEGIN
      PhoneNo:='+'+PhoneNo;

      Response := 'ERROR';

      SkyworldUSSDAuth.RESET;
      SkyworldUSSDAuth.SETRANGE("Mobile No.",PhoneNo);
      IF SkyworldUSSDAuth.FINDFIRST THEN BEGIN
          IF SkyworldUSSDAuth."PIN No." = OldPin THEN BEGIN
              IF NewPin = '' THEN BEGIN
                  Response := 'INVALID_NEW_PIN';
              END
              ELSE BEGIN
                  SkyworldUSSDAuth."PIN No." := NewPin;
                  SkyworldUSSDAuth.MODIFY;
                  COMMIT;
                  Response := 'SUCCESS';
              END;
          END
          ELSE BEGIN
              Response := 'INCORRECT_PIN';
          END;
      END
      ELSE BEGIN
          Response := 'INVALID_ACCOUNT';
      END;
    END;

    PROCEDURE SetForcePin@33(PhoneNo@1001 : Text;PIN@1002 : Text) Response : Boolean;
    VAR
      SkyworldUSSDAuth@1000 : Record 51516709;
    BEGIN
      PhoneNo := '+'+PhoneNo;

      Response := FALSE;

      SkyworldUSSDAuth.RESET;
      SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."Mobile No.",PhoneNo);
      IF SkyworldUSSDAuth.FINDFIRST THEN BEGIN
          SkyworldUSSDAuth."PIN No." := PIN;
          SkyworldUSSDAuth."Reset PIN" := FALSE;
          SkyworldUSSDAuth."Force PIN" := TRUE;
          IF SkyworldUSSDAuth.MODIFY THEN
              Response := TRUE;
      END;
    END;

    PROCEDURE GetPinStatus@31(PhoneNo@1001 : Text) Response : Boolean;
    VAR
      SkyworldUSSDAuth@1000 : Record 51516709;
    BEGIN
      PhoneNo := '+'+PhoneNo;

      Response:=FALSE;

      SkyworldUSSDAuth.RESET;
      SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."Mobile No.",PhoneNo);
      IF SkyworldUSSDAuth.FINDFIRST THEN BEGIN
          Response := SkyworldUSSDAuth."Reset PIN";
      END;
    END;

    PROCEDURE ResendCurrentPin@34() Pin : Text;
    VAR
      SkyworldUSSDAuth@1000 : Record 51516709;
    BEGIN

      Pin:='';

      SkyworldUSSDAuth.RESET;
      SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."Pin Sent",FALSE);
      SkyworldUSSDAuth.SETFILTER(SkyworldUSSDAuth."PIN No.",'<>%1','');
      IF SkyworldUSSDAuth.FINDFIRST THEN BEGIN
          Pin:=SkyworldUSSDAuth."Mobile No."+':::'+SkyworldUSSDAuth."PIN No.";
          SkyworldUSSDAuth."Pin Sent" := TRUE;
          SkyworldUSSDAuth.MODIFY;
      END;
    END;

    PROCEDURE AccountBalanceEnquiry@24(EntryCode@1041 : GUID;TransactionID@1102755001 : Code[20];PhoneNo@1015 : Code[20];PIN@1042 : Text;AccType@1018 : Text) Response : Text[1024];
    VAR
      SaccoFee@1033 : Decimal;
      VendorCommission@1032 : Decimal;
      TotalCharge@1031 : Decimal;
      SavAcc@1030 : Record 23;
      SaccoAccount@1029 : Code[20];
      VendorAccount@1028 : Code[20];
      AccBal@1026 : Decimal;
      JTemplate@1024 : Code[10];
      JBatch@1023 : Code[10];
      MobileTrans@1022 : Record 51516712;
      DocNo@1021 : Code[20];
      PDate@1020 : Date;
      AcctType@1019 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      BalAccType@1017 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      TransType@1016 : ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal';
      AccNo@1014 : Code[20];
      BalAccNo@1013 : Code[20];
      SourceType@1012 : 'New Member,New Account,Loan Account Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit, Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued';
      ExtDoc@1010 : Code[20];
      LoanNo@1009 : Code[20];
      Dim1@1008 : Code[20];
      Dim2@1007 : Code[20];
      SystCreated@1006 : Boolean;
      SLedger@1005 : Record 25;
      LedgerCount@1004 : Integer;
      CurrRecord@1003 : Integer;
      DFilter@1002 : Text;
      DebitCreditFlag@1001 : Code[10];
      FirstEntry@1000 : Boolean;
      ProdFact@1034 : Record 51516717;
      AccountBookBalance@1035 : Decimal;
      AccountAvailableBalance@1036 : Decimal;
      AccountToCharge@1037 : Code[20];
      Found@1027 : Boolean;
      MemberNo@1038 : Code[20];
      TransactionDate@1011 : DateTime;
      Loans@1039 : Record 51516230;
      LoanType@1040 : Text;
      BalStmt@1043 : Text;
      msg@1044 : Text;
      SafcomCharges@1045 : Record 51516708;
      SafcomFee@1046 : Decimal;
      BalEnqCharge@1047 : Decimal;
      AccountBal@1025 : Decimal;
      LoanProductTypes@1048 : Record 51516240;
      LBal@1049 : Decimal;
      AccountType@1120054000 : Record 51516295;
      VendorAccounts@1120054001 : Record 23;
      DateandTime@1120054002 : Text;
      msgprefix@1120054003 : Text;
    BEGIN
      TransactionDate := CURRENTDATETIME;

      Response:='ERROR';
      Found:=FALSE;

      DateandTime :=DateTimeToText(CURRENTDATETIME);

      PhoneNo := '+'+PhoneNo;

      IF NOT CorrectPin(PhoneNo,PIN) THEN BEGIN
          Response := 'INCORRECT_PIN';
          EXIT;
      END;


      AccountToCharge:='';
      MemberNo:='';
      SavAcc.LOCKTABLE(TRUE);
      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
      SavAcc.SETRANGE("Account Type",'ORDINARY');
      IF SavAcc.FINDFIRST THEN BEGIN
          AccountToCharge:=SavAcc."No.";
          MemberNo:=SavAcc."BOSA Account No";
          IF SavAcc.Blocked<>SavAcc.Blocked::" " THEN
            EXIT;
      END;


      IF MemberNo='' THEN
          EXIT('Member No. Missing');

      IF AccountToCharge='' THEN
          EXIT('Account to charge missing');


      // Get Excise duty G/L
      ExciseDutyGL := GetExciseDutyGL();
      ExciseDutyRate := GetExciseRate();
      ExciseDuty:=0;

      SaccoAccount:='';
      SaccoFee:=0;
      VendorAccount:='';
      VendorCommission:=0;


      SMSAccount:='';
      SMSCharge:=0;

      CoopSetup.RESET;
      CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Balance Enquiry");
      IF CoopSetup.FINDFIRST THEN BEGIN

          SMSAccount := CoopSetup."SMS Account";
          SMSCharge := CoopSetup."SMS Charge";


          SaccoAccount := CoopSetup."Sacco Fee Account";
          SaccoFee := CoopSetup."Sacco Fee";
          VendorAccount:=CoopSetup."Vendor Commission Account";
          VendorCommission:=CoopSetup."Vendor Commission";


          GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,SafcomFee,0);
          TotalCharge:=SaccoFee+VendorCommission+SMSCharge;
          ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);
          ExciseDuty:=0;
      END
      ELSE BEGIN
          ERROR('Setup Missing for %1',CoopSetup."Transaction Type");
      END;



      IF SavAcc.GET(AccountToCharge) THEN BEGIN


          AccountType.GET(SavAcc."Account Type");


          IF (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::"Deposits Only") OR
              (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::" ") THEN BEGIN
              ERROR('The Account to Charge is not a Withdrawable Account');

          END;



          BalEnqCharge:=0;
          AccBal := GetAccountBalance(SavAcc."No.");
          IF AccBal >= TotalCharge+ExciseDuty THEN BEGIN
              BalEnqCharge := TotalCharge+ExciseDuty;
              //BUser.GET(USERID);

              //BUser.TESTFIELD("Cashier Journal Template");
              //BUser.TESTFIELD("Cashier Journal Batch");

              JTemplate:='GENERAL';
              JBatch:='SKYWORLD';

              GenJournalBatch.RESET;
              GenJournalBatch.SETRANGE("Journal Template Name",JTemplate);
              GenJournalBatch.SETRANGE(Name,JBatch);
              IF NOT GenJournalBatch.FINDFIRST THEN BEGIN
                  GenJournalBatch.INIT;
                  GenJournalBatch."Journal Template Name" := JTemplate;
                  GenJournalBatch.Name:=JBatch;
                  GenJournalBatch.Description:='Sky World Batch';
                  GenJournalBatch.INSERT;
              END;


              MobileTrans.INIT;
              MobileTrans."Entry No." := EntryCode;
              MobileTrans."Transaction ID":=TransactionID;
              MobileTrans."Session ID":=TransactionID;
              MobileTrans."Vendor Commission":=VendorCommission;
              MobileTrans."Sacco Fee":=SaccoFee;
              MobileTrans."Transaction Date":=DT2DATE(TransactionDate);
              MobileTrans."Transaction Time":=DT2TIME(TransactionDate);
              MobileTrans."Date Captured" := TransactionDate;
              MobileTrans."Member Account":=SavAcc."No.";
              MobileTrans."Transaction Type":=MobileTrans."Transaction Type"::"Balance Enquiry";
              MobileTrans.Description:=FORMAT(MobileTrans."Transaction Type");
              MobileTrans."Savings Product" := ProdFact."Product ID";
              MobileTrans.INSERT;

              {
              MobileTrans.RESET;
              MobileTrans.SETRANGE("Transaction ID",TransactionID);
              MobileTrans.SETRANGE(Posted,FALSE);
              IF MobileTrans.FINDFIRST THEN BEGIN

                  DocNo := MobileTrans."Transaction ID";
                  PDate := MobileTrans."Transaction Date";
                  AccNo := MobileTrans."Member Account";
                  ExtDoc := '';
                  LoanNo := '';
                  TransType := TransType::" ";
                  Dim1 := SavAcc."Global Dimension 1 Code";
                  Dim2 := SavAcc."Global Dimension 2 Code";
                  SystCreated := TRUE;

                  SaccoTrans.InitJournal(JTemplate,JBatch);

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                '',VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                '',SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccountToCharge,COPYSTR('SMS Charges ',1,50),BalAccType::"G/L Account",
                                SMSAccount,SMSCharge,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR('Excise Duty',1,50),BalAccType::"G/L Account",
                                ExciseDutyGL,ExciseDuty,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  AccNo := VendorAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(MobileTrans.Description+' Commission',1,50),BalAccType::"G/L Account",
                                '',-VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  AccNo := SaccoAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",AccNo,COPYSTR(MobileTrans.Description+' Fee',1,50),BalAccType::"G/L Account",
                                '',-SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  MobileTrans.Posted:=TRUE;
                  MobileTrans."Posted By":=USERID;
                  MobileTrans."Date Posted":=TODAY;
                  MobileTrans.MODIFY;

                  SaccoTrans.PostJournal(JTemplate,JBatch);

              END;
              }
          END
          ELSE BEGIN
              Response:='INSUFFICIENT_BAL';
          END;
      END
      ELSE BEGIN
          Response:='INVALID_ACCOUNT';
      END;


      IF (Response='ERROR') THEN BEGIN

          IF (AccType = 'FOSA') OR (AccType = 'BOSA') THEN BEGIN
              msg := '';

              SavAcc.RESET;
              SavAcc.SETRANGE("BOSA Account No",MemberNo);
              SavAcc.SETFILTER(SavAcc."Account Type",'<>FIXED');
              IF SavAcc.FIND('-') THEN BEGIN
                  msgprefix:='Bal. as '+DateandTime+':';
                  REPEAT

                      IF AccountType.GET(SavAcc."Account Type") THEN BEGIN

                          SavAcc.CALCFIELDS("Balance (LCY)");
                          AccountBal := SavAcc."Balance (LCY)";

                          AccountBookBalance := AccountBal;
                          AccountAvailableBalance := GetAccountBalance(SavAcc."No.");


                          IF AccountType.Code = 'ORDINARY' THEN BEGIN

                              SMSCharge:=0;

                              CoopSetup.RESET;
                              CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::Withdrawal);
                              IF CoopSetup.FINDFIRST THEN BEGIN

                                  SMSCharge := CoopSetup."SMS Charge";

                                  SafcomCharges.RESET;
                                  SafcomCharges.SETFILTER(Charge,'>0');
                                  SafcomCharges.SETFILTER(Minimum,'<%1',AccountAvailableBalance);
                                  SafcomCharges.SETFILTER(Maximum,'>%1',AccountAvailableBalance);
                                  IF SafcomCharges.FINDFIRST THEN BEGIN
                                      SafcomFee:=SafcomCharges.Charge;
                                  END;
                                  SaccoFee := CoopSetup."Sacco Fee";
                                  VendorCommission:=CoopSetup."Vendor Commission";

                                  GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,SafcomFee,AccountAvailableBalance);
                                  TotalCharge:=SaccoFee+VendorCommission+SafcomFee+SMSCharge;
                                  ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);

                                  //AccountBookBalance -= BalEnqCharge;
                                  AccountBookBalance -= (BalEnqCharge+TotalCharge+ExciseDuty);
                                  AccountAvailableBalance -= (BalEnqCharge+TotalCharge+ExciseDuty);

                              END;
                          END;


                          BalStmt:=AccountType."USSD Product Name"+' : '+FORMAT(AccountAvailableBalance)+', ';
                          msg += BalStmt;

                      END;
                  UNTIL SavAcc.NEXT = 0;

              END;

              ProdFact.RESET;
              ProdFact.SETRANGE("Product Class Type",ProdFact."Product Class Type"::Savings);
              ProdFact.SETRANGE(ProdFact."Table Present",ProdFact."Table Present"::Members);
              ProdFact.SETFILTER(ProdFact."Product ID", '<>BF' );
              IF ProdFact.FIND('-') THEN BEGIN
                  IF msg = '' THEN
                  msgprefix:='Bal. as '+DateandTime+':';
                  REPEAT
                      AccountBookBalance := 0;
                      IF Members.GET(MemberNo) THEN BEGIN

                          IF ProdFact."Product Category" = ProdFact."Product Category"::"Deposit Contribution" THEN BEGIN
                              Members.CALCFIELDS("Current Shares");
                              AccountBookBalance := Members."Current Shares";
                          END;

                          IF ProdFact."Product Category" = ProdFact."Product Category"::"Shares Capital" THEN BEGIN
                              Members.CALCFIELDS("Shares Retained");
                              AccountBookBalance := Members."Shares Retained";
                          END;
                          IF ProdFact."Product Category" = ProdFact."Product Category"::"SchFee Shares" THEN BEGIN
                              Members.CALCFIELDS("School Fees Shares");
                              AccountBookBalance := Members."School Fees Shares";
                          END;


                          AccountAvailableBalance := AccountBookBalance;
                          //RUN THAT
                          IF AccountAvailableBalance > 0 THEN BEGIN
                          BalStmt:=ProdFact."USSD Product Name"+' : '+FORMAT(AccountAvailableBalance)+',';
                          msg += BalStmt;
                          END;

                      END;
                  UNTIL ProdFact.NEXT = 0;

                  msg :=msgprefix+msg;
                  MESSAGE(msg);

                  Response:='SUCCESS';
                  Priority:=200;
                  SendSms(Source::MBANKING,PhoneNo,msg,'ACC_BAL','',FALSE,Priority,FALSE);

              END;
          END
          ELSE IF AccType = 'LOAN' THEN BEGIN



              Loans.RESET;
              Loans.SETRANGE("Client Code",MemberNo);
              Loans.SETFILTER("Outstanding Balance",'>0');
              IF Loans.FIND('-') THEN BEGIN

      //             msg:='Loan Balances: ';
                  msgprefix:='Your Loan Balances as at '+DateandTime+': ';


                  MESSAGE('Loans %1: %2',Loans."Loan Product Type",LBal);

                  REPEAT
                      LoanProductTypes.GET(Loans."Loan Product Type");
                      LoanType:=LoanProductTypes."Product Description";
                      IF LoanProductTypes."USSD Product Name"<>'' THEN
                        LoanType:=LoanProductTypes."USSD Product Name";
                      LBal := 0;

                      Loans.CALCFIELDS("Outstanding Balance",Loans."Oustanding Interest",Loans."Penalty Charged");
                      LBal := ROUND(Loans."Outstanding Balance"+Loans."Oustanding Interest"+Loans."Penalty Charged",1,'>');




                      IF LBal > 0 THEN BEGIN

                          BalStmt:=LoanType+' : '+FORMAT(LBal)+', ';
                          msg += BalStmt;
                      END;
                  UNTIL Loans.NEXT=0;
                  msg := msgprefix+msg;

              END
              ELSE BEGIN
                  msg := 'Dear Member, You have no outstanding loan';
              END;
              Response:='SUCCESS';
              Priority:=200;
              SendSms(Source::MBANKING,PhoneNo,msg,'LOAN_BAL','',FALSE,Priority,FALSE);


       {
      xxxxxxxxxxxxxxxxxxxxxx
              Loans.RESET;
              Loans.SETRANGE("Member Code",MemberNo);
              Loans.SETFILTER("Outstanding Balance",'>0');
              IF Loans.FIND('-') THEN BEGIN
                  msg:='Loan Balances: ';
                  REPEAT
                      LoanType:=Loans."Loan Product Type";

                      IF ProdFact.GET(Loans."Loan Product Type") THEN
                        LoanType:=ProdFact."USSD Product Name";

                      Loans.CALCFIELDS("Outstanding Balance");



                      BalStmt:=ProdFact."USSD Product Name"+' : '+FORMAT(Loans."Outstanding Balance")+', ';
                      msg += BalStmt;


                  UNTIL Loans.NEXT = 0;

                  Response:='SUCCESS';
                  Priority:=200;
                  SendSms(Source::MBANKING,PhoneNo,msg,'LOAN_BAL','',TRUE,Priority,FALSE);

              END;
      }



          END;
      END;
    END;

    PROCEDURE RandomPIN@37() : Text;
    VAR
      NewPin@1001 : Text;
      NewIntPin@1000 : Integer;
    BEGIN


      NewPin:='';
      NewIntPin := RANDOM(9);
      NewPin += FORMAT(NewIntPin);
      NewIntPin := RANDOM(9);
      NewPin += FORMAT(NewIntPin);
      NewIntPin := RANDOM(9);
      NewPin += FORMAT(NewIntPin);
      NewIntPin := RANDOM(9);
      NewPin += FORMAT(NewIntPin);


      EXIT(NewPin);
    END;

    PROCEDURE GetAccounts@40(PhoneNo@1015 : Code[20];Source@1018 : Text) Response : Text[1024];
    VAR
      SaccoFee@1033 : Decimal;
      VendorCommission@1032 : Decimal;
      TotalCharge@1031 : Decimal;
      SavAcc@1030 : Record 23;
      SaccoAccount@1029 : Code[20];
      VendorAccount@1028 : Code[20];
      AccBal@1026 : Decimal;
      JTemplate@1024 : Code[10];
      JBatch@1023 : Code[10];
      MobileTrans@1022 : Record 51516712;
      DocNo@1021 : Code[20];
      PDate@1020 : Date;
      AcctType@1019 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      BalAccType@1017 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      TransType@1016 : ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal';
      AccNo@1014 : Code[20];
      BalAccNo@1013 : Code[20];
      SourceType@1012 : 'New Member,New Account,Loan Account Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit, Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued';
      ExtDoc@1010 : Code[20];
      LoanNo@1009 : Code[20];
      Dim1@1008 : Code[10];
      Dim2@1007 : Code[10];
      SystCreated@1006 : Boolean;
      SLedger@1005 : Record 25;
      LedgerCount@1004 : Integer;
      CurrRecord@1003 : Integer;
      DFilter@1002 : Text;
      DebitCreditFlag@1001 : Code[10];
      FirstEntry@1000 : Boolean;
      ProdFact@1034 : Record 51516717;
      AccountBookBalance@1035 : Decimal;
      AccountAvailableBalance@1036 : Decimal;
      AccountToCharge@1037 : Code[20];
      Found@1027 : Boolean;
      MemberNo@1038 : Code[20];
      TransactionDate@1011 : DateTime;
      Loans@1039 : Record 51516230;
      LoanType@1040 : Text;
      LoanProductTypes@1025 : Record 51516240;
      LBal@1041 : Decimal;
    BEGIN
      PhoneNo := '+'+PhoneNo;
      Response:='';
      Found:=FALSE;

      MemberNo:='';
      AccountToCharge := '';
      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
      IF SavAcc.FINDFIRST THEN BEGIN
          MemberNo := SavAcc."No.";
          AccountToCharge := SavAcc."No.";
      END;

      IF MemberNo='' THEN
          EXIT('Member No. Missing');


      IF (Source = 'FOSA') OR (Source = 'BOSA') OR (Source = 'ALL') THEN BEGIN

          SavAcc.RESET;
          SavAcc.SETRANGE("No.",MemberNo);
          IF SavAcc.FIND('-') THEN BEGIN
              Response:='<Accounts>';
              REPEAT
                  ProdFact.RESET;
                  ProdFact.SETRANGE("Product Class Type",ProdFact."Product Class Type"::Savings);
                  IF ProdFact.FINDFIRST THEN BEGIN
                      REPEAT

                          IF ProdFact."Mobile Transaction"<>ProdFact."Mobile Transaction"::" " THEN BEGIN
                              Found:=TRUE;
                              Response+='<Account>';
                                Response+='<ProductID>'+ProdFact."Product ID"+'</ProductID>';
                                Response+='<ProductName>'+ProdFact."USSD Product Name"+'</ProductName>';
                                Response+='<AccountNo>'+ProdFact."Product ID"+SavAcc."No."+'</AccountNo>';
                              Response+='</Account>';
                          END;
                      UNTIL ProdFact.NEXT = 0;
                  END;
              UNTIL SavAcc.NEXT = 0;
              Response+='</Accounts>';
          END;

      END
      ELSE IF Source = 'LOAN' THEN BEGIN

          Loans.RESET;
          Loans.SETRANGE("Client Code",MemberNo);
          Loans.SETFILTER("Outstanding Balance",'<>0');
          IF Loans.FIND('-') THEN BEGIN
              Response+='<Accounts>';
              LoanProductTypes.RESET;
              LoanProductTypes.SETRANGE(Code,'<>%1','DEFAULTER');
              IF LoanProductTypes.FINDFIRST THEN BEGIN
                  REPEAT

                      Loans.RESET;
                      Loans.SETRANGE("Client Code",MemberNo);
                      Loans.SETRANGE("Loan Product Type",LoanProductTypes.Code);
                      Loans.SETFILTER("Outstanding Balance",'<>0');
                      IF Loans.FIND('-') THEN BEGIN

                          LoanType:=LoanProductTypes."Product Description";
                          IF LoanProductTypes."USSD Product Name"<>'' THEN
                            LoanType:=LoanProductTypes."USSD Product Name";
                          LBal := 0;

                          REPEAT
                              Loans.CALCFIELDS("Outstanding Balance");
                              LBal += Loans."Outstanding Balance";

                          UNTIL Loans.NEXT = 0;


                          IF LBal > 0 THEN BEGIN
                              Response+='<Account>';
                                Response+='<ProductID>'+LoanProductTypes.Code+'</ProductID>';
                                Response+='<ProductName>'+LoanType+'</ProductName>';
                                Response+='<AccountNo>'+Loans."Loan  No."+'</AccountNo>';
                              Response+='</Account>';
                          END;

                      END;
                  UNTIL LoanProductTypes.NEXT = 0;
              END;
              Response+='</Accounts>';
          END;
      END;


      IF NOT Found THEN
        Response:='';
    END;

    PROCEDURE GetAccountTransferRecipient@54(Criteria@1102755000 : Code[20];Source@1001 : Text) Response : Text;
    VAR
      SavAcc@1000 : Record 23;
      PFact@1002 : Record 51516717;
      xmlWriter@1008 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlTextWriter";
      EncodingText@1007 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
      XMLDOMMgt@1006 : Codeunit 6224;
      BodyContentXmlDoc@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      EnvelopeXmlNode@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      CreatedXmlNode@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      ProdFact@1009 : Record 51516717;
      AccLength@1010 : Integer;
      RecMemberNo@1014 : Code[20];
      RecMobileNo@1013 : Code[20];
      RecProduct@1012 : Code[20];
      RecTransType@1011 : ' ,Junior Account,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Deposit Contribution,Benevolent Fund,Registration Fee,Administration Fee,Appraisal,Dividend,Withholding Tax,Shares Contributions,Welfare Contribution 2,Loan Adjustment,Holiday Savings,Unallocated Funds,Partial Disbursement,Wallet Account';
    BEGIN

      Response:='';


      IF Source = 'Mobile' THEN BEGIN

          IF STRLEN(Criteria) = 10 THEN
            IF COPYSTR(Criteria,1,1) = '0' THEN
               Criteria := COPYSTR(Criteria,2,9);

          SavAcc.RESET;
          SavAcc.SETFILTER("Transactional Mobile No",'*'+Criteria);
          SavAcc.SETFILTER(Blocked,'<>%1',SavAcc.Blocked::All);
          IF SavAcc.FINDFIRST THEN BEGIN
              Response:=SavAcc."No.";
          END
          ELSE BEGIN

              SavAcc.RESET;
              SavAcc.SETFILTER("Mobile Phone No",'*%1','*'+Criteria);
              SavAcc.SETFILTER(Blocked,'<>%1',SavAcc.Blocked::All);
              IF SavAcc.FINDFIRST THEN BEGIN
                  Response:=SavAcc."No.";
              END;
          END
      END
      ELSE IF Source = 'ID' THEN BEGIN
          SavAcc.RESET;
          SavAcc.SETRANGE("ID No.",Criteria);
          SavAcc.SETFILTER(Blocked,'<>%1',SavAcc.Blocked::All);
          IF SavAcc.FINDFIRST THEN BEGIN
              Response:=SavAcc."No.";
          END
      END
      ELSE IF Source = 'ACCOUNT' THEN BEGIN

          SavAcc.RESET;
          SavAcc.SETRANGE("No.",Criteria);
          IF SavAcc.FINDFIRST THEN BEGIN
              Response:=SavAcc."No.";
          END
          ELSE BEGIN

              ProdFact.RESET;
              IF ProdFact.FINDFIRST THEN BEGIN
                  REPEAT

                      RecProduct := '';
                      RecMemberNo := '';
                      SplitAccount(Criteria,RecProduct,RecMemberNo);

                      IF RecProduct = ProdFact."Product ID" THEN BEGIN

                          IF Members.GET(RecMemberNo) THEN BEGIN
                              Response:=Criteria;
                          END
                      END

                  UNTIL ProdFact.NEXT = 0;
              END;
          END;

      END
      //Response:='';
    END;

    PROCEDURE ReverseWithdrawalRequest@45(EntryCode@1007 : GUID) : Boolean;
    VAR
      SaccoFee@1006 : Decimal;
      VendorCommission@1005 : Decimal;
      TotalCharge@1003 : Decimal;
      SavAcc@1002 : Record 23;
      SaccoAccount@1000 : Code[20];
      VendorAccount@1001 : Code[20];
      MpesaTrans@1004 : Record 51516712;
      TransAmt@1009 : Decimal;
      JTemplate@1008 : Code[10];
      JBatch@1011 : Code[10];
      DocNo@1012 : Code[20];
      PDate@1013 : Date;
      AcctType@1022 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      BalAccType@1021 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      TransType@1020 : ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal';
      AccNo@1019 : Code[20];
      BalAccNo@1018 : Code[20];
      SourceType@1017 : 'New Member,New Account,Loan Account Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit, Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued';
      ExtDoc@1016 : Code[20];
      LoanNo@1015 : Code[20];
      Dim1@1014 : Code[10];
      Dim2@1023 : Code[10];
      SystCreated@1024 : Boolean;
      RunBal@1025 : Decimal;
      AccBal@1026 : Decimal;
      Loans@1027 : Record 51516230;
      IntAmt@1028 : Decimal;
      PrAmt@1029 : Decimal;
      ATMTrans@1030 : Record 51516323;
      SafcomCharges@1033 : Record 51516708;
      SafcomAcc@1032 : Code[20];
      SafcomFee@1031 : Decimal;
      MobileWithdrawalsBuffer@1034 : Record 51516714;
      Msg@1035 : Text;
    BEGIN
      MobileWithdrawalsBuffer.RESET;
      MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer."Trace ID",EntryCode);
      MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer.Source,MobileWithdrawalsBuffer.Source::"M-PESA");
      //MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer."Account No",SavAcc."No.");
      //MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer.Amount,Amount);
      MobileWithdrawalsBuffer.SETRANGE(Posted,FALSE);
      MobileWithdrawalsBuffer.SETRANGE(Reversed,FALSE);
      IF MobileWithdrawalsBuffer.FIND('-') THEN BEGIN
          MobileWithdrawalsBuffer.Posted:=TRUE;
          MobileWithdrawalsBuffer."Posting Date":=TODAY;
          MobileWithdrawalsBuffer.Reversed:=TRUE;
          MobileWithdrawalsBuffer."Date Reversed":=TODAY;
          MobileWithdrawalsBuffer."Reversed By":=USERID;
          MobileWithdrawalsBuffer.MODIFY;

          Msg := 'Dear Member, Your '+MobileWithdrawalsBuffer."Withdrawal Type"+' of KES '+FORMAT(MobileWithdrawalsBuffer.Amount)+' has been reversed on '+DateTimeToText(CURRENTDATETIME);
          IF SavAcc.GET(MobileWithdrawalsBuffer."Account No") THEN
              SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",Msg,SavAcc."No.",SavAcc."No.",TRUE,Priority,TRUE);

          EXIT(TRUE);
      END
      ELSE BEGIN
          MobileWithdrawalsBuffer.RESET;
          MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer."Trace ID",EntryCode);
          MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer.Source,MobileWithdrawalsBuffer.Source::"M-PESA");
          //MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer."Account No",SavAcc."No.");
          //MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer.Amount,Amount);
          MobileWithdrawalsBuffer.SETRANGE(Posted,TRUE);
          MobileWithdrawalsBuffer.SETRANGE(Reversed,TRUE);
          IF MobileWithdrawalsBuffer.FIND('-') THEN BEGIN

              Msg := 'Dear Member, Your '+MobileWithdrawalsBuffer."Withdrawal Type"+' of KES '+FORMAT(MobileWithdrawalsBuffer.Amount)+' has been reversed on '+DateTimeToText(CURRENTDATETIME);
              IF SavAcc.GET(MobileWithdrawalsBuffer."Account No") THEN
                  SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",Msg,SavAcc."No.",SavAcc."No.",TRUE,Priority,TRUE);

              EXIT(TRUE);
          END
      END;


      EXIT(FALSE);
    END;

    PROCEDURE CreateMobileLoanAccount@50(MemberNo@1003 : Code[20];ProdType@1004 : Code[20]) LoanAcc : Code[20];
    VAR
      ProdFac@1000 : Record 51516717;
      Loans@1001 : Record 51516230;
      Accounts@1002 : Record 23;
      Member@1005 : Record 51516223;
      AcctNo@1006 : Code[20];
    BEGIN
      {
      IF ProdFac.GET(ProdType) THEN BEGIN

      AcctNo:=ProdFac."Account No. Prefix"+MemberNo+ProdFac."Account No. Suffix";



      IF Accounts.GET(AcctNo) THEN
      EXIT(AcctNo);

      IF Member.GET(MemberNo) THEN BEGIN

      Accounts.INIT;
      Accounts."No.":=AcctNo;
      Accounts."Date of Birth":=Member."Date of Birth";
      Accounts.Name:=Member."First Name"+' '+Member."Second Name"+' '+Member."Last Name";
      Accounts.VALIDATE(Accounts.Name);
      Accounts."ID No.":=Member."ID No.";
      Accounts."Mobile Phone No":=Member."Mobile Phone No";
      Accounts."Member No.":=MemberNo;
      Accounts."Payroll/Staff No.":=Member."Payroll/Staff No.";
      Accounts."Passport No.":=Member."Passport No.";
      Accounts."Employer Code":=Member."Employer Code";
      Accounts.Status:=Accounts.Status::"1";
      Accounts."Account Category":=Member."Account Category";
      Accounts."Date of Birth":=Member."Date of Birth";
      Accounts."Current Address":=Member."Current Address";
      Accounts.City:=Member.City;
      Accounts."Phone No.":=Member."Phone No.";
      Accounts."Post Code":=Member."Post Code";
      Accounts.County:=Member.County;
      Accounts."E-Mail":=Member."E-Mail";
      Accounts."Product Type":=ProdFac."Product ID";
      Accounts."Product Name":=ProdFac.Description;
      Accounts."Customer Posting Group":=ProdFac."Product Posting Group";
      Accounts.INSERT(TRUE);
      END;
      EXIT(AcctNo);
      END;
      }
    END;

    PROCEDURE GetLoanLimit@51(PhoneNo@1009 : Code[20];LoanProductType@1001 : Code[20]) Response : Text;
    VAR
      SavAcc@1000 : Record 23;
      PFact@1002 : Record 51516717;
      xmlWriter@1008 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlTextWriter";
      EncodingText@1007 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
      XMLDOMMgt@1006 : Codeunit 6224;
      BodyContentXmlDoc@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      EnvelopeXmlNode@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      CreatedXmlNode@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      MaxLoan@1010 : Decimal;
      msg@1011 : Text;
      LoanType@1120054000 : Record 51516240;
      LoanLimit@1120054001 : Decimal;
      K@1120054002 : Boolean;
    BEGIN

      PhoneNo := '+'+PhoneNo;

      Response:='ERROR';
      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FINDFIRST THEN BEGIN


          IF LoanType.GET(LoanProductType) THEN BEGIN

              LoanLimit :=0;
              IF (LoanType.Code = 'A03') OR (LoanType.Code = 'A16') THEN

              MaxLoan:=GetLoanQualifiedAmount(SavAcc."No.",LoanProductType,msg,LoanLimit);
              IF LoanType.Code = 'A01' THEN

               MaxLoan:=GetSalaryLoanQualifiedAmount(SavAcc."No.",LoanProductType,LoanLimit,msg);
              IF LoanType.Code = 'A10' THEN
               MaxLoan:=GetReloadedLoanQualifiedAmount(SavAcc."No.",LoanProductType,LoanLimit,msg);

              msg := 'Dear '+SavAcc.Name+', your Loan Limit for '+PFact."USSD Product Name"+' as at '+DateTimeToText(CURRENTDATETIME)+' is KES '+FORMAT(LoanLimit)+'. You qualify for'+'  KES '+FORMAT(MaxLoan);

              MESSAGE(msg);
              SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,LoanProductType,SavAcc."No.",TRUE,Priority,FALSE);
             Response:='SUCCESS';
          END
          ELSE BEGIN

              IF LoanProductType = 'M_OD' THEN BEGIN
                  MaxLoan := 0;
                  LoanLimit :=0;
                  OverdraftLimit(SavAcc."No.",K,msg,MaxLoan,LoanLimit);
                  //MESSAGE(msg);
                  msg := 'Dear '+SavAcc.Name+', your Overdraft Limit as at '+DateTimeToText(CURRENTDATETIME)+' is KES '+FORMAT(LoanLimit)+'. You qualify for'+' is KES '+FORMAT(MaxLoan);

                  SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,LoanProductType,SavAcc."No.",TRUE,Priority,FALSE);
                  Response:='SUCCESS';

              END;
          END;
          MESSAGE(msg);
      END;
    END;

    PROCEDURE IMSIConfirm@46(PhoneNo@1102755000 : Text[30];IMSI@1002 : Text) : Boolean;
    VAR
      SavAcc@1001 : Record 23;
      SkyworldUSSDAuth@1000 : Record 51516709;
      msg@1003 : Text;
    BEGIN
      PhoneNo := '+'+ PhoneNo;

      //IMSI
      IF IMSI<>'' THEN BEGIN
          SkyworldUSSDAuth.RESET;
          SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."Mobile No.",PhoneNo);
          IF SkyworldUSSDAuth.FINDFIRST THEN BEGIN
              IF SkyworldUSSDAuth.IMSI = '' THEN BEGIN
                  SkyworldUSSDAuth.IMSI := IMSI;
                  SkyworldUSSDAuth.MODIFY;
                  EXIT(TRUE);
              END
              ELSE BEGIN
                  IF SkyworldUSSDAuth.IMSI = IMSI THEN
                     EXIT(TRUE);
              END;
          END;
      END;

      msg := 'Dear Member, please note that you have changed your sim card. Please visit one of our branches or contact us for assistance';

      Priority:=201;
      SendSms(Source::MBANKING,PhoneNo,msg,'IMSI','',TRUE,Priority,FALSE);

      EXIT(FALSE);
    END;

    PROCEDURE UpdateIMSI@66(PhoneNo@1102755000 : Text[30];IMSI@1002 : Text) : Boolean;
    VAR
      SavAcc@1001 : Record 23;
      SkyworldUSSDAuth@1000 : Record 51516709;
      msg@1003 : Text;
    BEGIN
      PhoneNo := '+'+ PhoneNo;

      //IMSI
      SkyworldUSSDAuth.RESET;
      SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."Mobile No.",PhoneNo);
      IF SkyworldUSSDAuth.FINDFIRST THEN BEGIN
          SkyworldUSSDAuth.IMSI := IMSI;
          SkyworldUSSDAuth.MODIFY;
          EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    PROCEDURE TestLogin@83(MobileNo@1000 : Code[30]) Response : Text;
    VAR
      SkyAuth@1003 : Record 51516709;
    BEGIN
      MobileNo := '+'+ MobileNo;

      SkyAuth.RESET;
      SkyAuth.SETRANGE(SkyAuth."Mobile No.",MobileNo);
      IF SkyAuth.FINDFIRST THEN BEGIN

          Response:='<Login>';

                  Response+='<MobileNo>'+SkyAuth."Mobile No."+'</MobileNo>';
                  Response+='<AccountNo>'+SkyAuth."Account No."+'</AccountNo>';
                  Response+='<PIN>'+SkyAuth."PIN No."+'</PIN>';
                  Response+='<ResetPin>'+FORMAT(SkyAuth."Reset PIN")+'</ResetPin>';
                  Response+='<Status>'+FORMAT(SkyAuth."User Status")+'</Status>';
                  Response+='<ForcePin>'+FORMAT(SkyAuth."Force PIN")+'</ForcePin>';
                  Response+='<IMSI>'+SkyAuth.IMSI+'</IMSI>';
                  Response+='<IMEI>'+SkyAuth.IMEI+'</IMEI>';

          Response+='</Login>';

      END;
    END;

    PROCEDURE UpdateAuthAttempts@93(MobileNo@1000 : Code[30];Type@1002 : Text;Count@1004 : Integer;Tag@1001 : Text;Action@1005 : Text;Validity@1006 : DateTime;ClearValidity@1007 : Boolean) Response : Text;
    VAR
      SkyAuth@1003 : Record 51516709;
      SavAcc@1000000000 : Record 23;
    BEGIN
      MobileNo := '+'+ MobileNo;

      Response := 'ERROR';

      SkyAuth.RESET;
      SkyAuth.SETRANGE(SkyAuth."Mobile No.",MobileNo);
      IF SkyAuth.FINDFIRST THEN BEGIN
          IF(Type = 'LOGIN') THEN BEGIN
              SkyAuth."Login Attempts Action" := Action;
              SkyAuth."Login Attempts Count" := Count;
              SkyAuth."Login Attempts Tag" := Tag;
              IF(ClearValidity) THEN BEGIN
                  CLEAR(SkyAuth."Login Attempts Action Expiry");
              END
              ELSE BEGIN
                  SkyAuth."Login Attempts Action Expiry" := Validity;
              END;
              SkyAuth.MODIFY;
              Response := 'SUCCESS';
          END;
          IF(Type = 'OTP') THEN BEGIN
              SkyAuth."OTP Attempts Action" := Action;
              SkyAuth."OTP Attempts Count" := Count;
              SkyAuth."OTP Attempts Tag" := Tag;
              IF(ClearValidity) THEN BEGIN
                  CLEAR(SkyAuth."OTP Attempts Action Expiry");
              END
              ELSE BEGIN
                  SkyAuth."OTP Attempts Action Expiry" := Validity;
              END;
              SkyAuth.MODIFY;
              Response := 'SUCCESS';
          END;
      END
      ELSE BEGIN
          Response := 'NOT_FOUND';
      END;
    END;

    PROCEDURE GetUserLoginAttemptExpiry@92(MobileNo@1000 : Code[30];Type@1002 : Text) Response : DateTime;
    VAR
      SkyAuth@1003 : Record 51516709;
      CurrentTime@1001 : DateTime;
    BEGIN
      MobileNo := '+'+ MobileNo;

      Response := CURRENTDATETIME;

      SkyAuth.RESET;
      SkyAuth.SETRANGE(SkyAuth."Mobile No.",MobileNo);
      IF SkyAuth.FINDFIRST THEN BEGIN
          IF(Type = 'LOGIN') THEN BEGIN
              Response := SkyAuth."Login Attempts Action Expiry";
          END;
          IF(Type = 'OTP') THEN BEGIN
              Response := SkyAuth."OTP Attempts Action Expiry";
          END;
      END;
    END;

    PROCEDURE GetUserLoginAttemptAction@103(MobileNo@1000 : Code[30];Type@1002 : Text) Response : Code[10];
    VAR
      SkyAuth@1003 : Record 51516709;
    BEGIN
      MobileNo := '+'+ MobileNo;

      Response := '';

      SkyAuth.RESET;
      SkyAuth.SETRANGE(SkyAuth."Mobile No.",MobileNo);
      IF SkyAuth.FINDFIRST THEN BEGIN
          IF(Type = 'LOGIN') THEN BEGIN
              IF(SkyAuth."Login Attempts Action" = 'SUSPEND') THEN BEGIN
                  IF(SkyAuth."Login Attempts Action Expiry" > CURRENTDATETIME) THEN BEGIN
                      Response := 'SUSPENDED'
                  END;
              END;
          END;
          IF(Type = 'OTP') THEN BEGIN
              IF(SkyAuth."OTP Attempts Action" = 'SUSPEND') THEN BEGIN
                  IF(SkyAuth."OTP Attempts Action Expiry" > CURRENTDATETIME) THEN BEGIN
                      Response := 'SUSPENDED'
                  END;
              END;
          END;
      END;
    END;

    PROCEDURE GetUserLoginAttemptCount@91(MobileNo@1000 : Code[30];Type@1002 : Text) Response : Integer;
    VAR
      SkyAuth@1003 : Record 51516709;
    BEGIN
      MobileNo := '+'+ MobileNo;

      Response := 0;

      SkyAuth.RESET;
      SkyAuth.SETRANGE(SkyAuth."Mobile No.",MobileNo);
      IF SkyAuth.FINDFIRST THEN BEGIN
          IF(Type = 'LOGIN') THEN BEGIN
              Response := SkyAuth."Login Attempts Count";
          END;
          IF(Type = 'OTP') THEN BEGIN
              Response := SkyAuth."OTP Attempts Count";
          END;
      END
      ELSE BEGIN
          Response := 0;
      END;
    END;

    PROCEDURE UserCheck@18(MobileNo@1000 : Code[30];IMSI_IMEI@1001 : Code[50];USSD@1002 : Boolean;SessionID@1004 : Code[20]) Response : Text;
    VAR
      SkyAuth@1003 : Record 51516709;
      SavAcc@1000000000 : Record 23;
    BEGIN
      MobileNo := '+'+ MobileNo;

      Response := 'ERROR';



      SkyAuth.RESET;
      SkyAuth.SETRANGE(SkyAuth."Mobile No.",MobileNo);
      IF SkyAuth.FINDFIRST THEN BEGIN
          // OR (SkyAuth."Login Attempts Action" = 'SUSPEND') OR (SkyAuth."OTP Attempts Action" = 'SUSPEND')
          IF (SkyAuth."User Status" = SkyAuth."User Status"::Inactive) OR (SkyAuth."User Status" = SkyAuth."User Status"::" ") THEN
              Response := 'BLOCKED'
          ELSE BEGIN
              IF USSD THEN BEGIN
                  IF (IMSI_IMEI='') THEN BEGIN
                      Response := 'INVALID_IMSI';
                      EXIT;
                  END;
                  IF (SkyAuth.IMSI='') OR (SkyAuth.IMSI=IMSI_IMEI) THEN BEGIN
                      Response := 'ACTIVE';
                  END
                  ELSE BEGIN
                      Response := 'INVALID_IMSI';
                  END;
              END
              ELSE BEGIN
                  IF (IMSI_IMEI='') THEN BEGIN
                      Response := 'INVALID_IMEI';
                      EXIT;
                  END;
                  IF NOT SkyAuth."Mobile App Activated" THEN BEGIN
                      Response := 'MOBILEAPP_INACTIVE';
                      EXIT;
                  END;

                  IF (SkyAuth.IMEI=IMSI_IMEI) THEN BEGIN
                      Response := 'ACTIVE';
                  END
                  ELSE BEGIN
                      Response := 'INVALID_IMEI';
                  END;
              END;
          END;


          SavAcc.RESET;
          SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
          IF SavAcc.FINDFIRST THEN
              IF SavAcc.Blocked <> SavAcc.Blocked::" " THEN
                  Response := 'BLOCKED';

          SavAcc.RESET;
          SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
          SavAcc.SETRANGE(Status,SavAcc.Status::Deceased);
          IF SavAcc.FINDFIRST THEN
              Response := 'DECEASED';


          SavAcc.RESET;
          SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
          IF SavAcc.FINDFIRST THEN BEGIN
              IF CheckBlackList(SavAcc."Transactional Mobile No",SavAcc."No.",SavAcc.Name) THEN
                  Response := 'BLOCKED';
          END;


      END
      ELSE BEGIN
          Response := 'NOT_FOUND';
      END;

      IF NOT USSD THEN BEGIN
          IF Response = 'ACTIVE' THEN BEGIN
              Response := MobileAppLogin(SessionID,MobileNo);
          END;
      END;
    END;

    PROCEDURE MAPPSetIMEI@42(MobileNo@1000 : Code[30];IMEI@1004 : Text) Response : Text;
    VAR
      SkyAuth@1003 : Record 51516709;
    BEGIN
      MobileNo := '+'+ MobileNo;

      Response := 'ERROR';

      SkyAuth.RESET;
      SkyAuth.SETRANGE(SkyAuth."Mobile No.",MobileNo);

      IF SkyAuth.FINDFIRST THEN BEGIN
          IF NOT (IMEI = '') THEN BEGIN
              SkyAuth.IMEI := IMEI;
              SkyAuth."Mobile App Activated":=TRUE;
              SkyAuth.MODIFY;
              Response := 'SUCCESS';
          END;

      END
      ELSE BEGIN
          Response := 'NOT_FOUND';
      END;
    END;

    PROCEDURE USSDLogin@63(MobileNo@1000 : Code[30];PIN@1001 : Text;IMSI_IMEI@1004 : Text;USSD@1002 : Boolean;SessionID@1005 : Code[20]) Response : Text;
    VAR
      SkyAuth@1003 : Record 51516709;
      Name@1006 : Text;
      SavAcc@1007 : Record 23;
      AttemptsCount@1008 : Integer;
    BEGIN
      MobileNo := '+'+ MobileNo;

      Response := 'ERROR';
      Name := ' ';

      SkyAuth.RESET;
      SkyAuth.SETRANGE(SkyAuth."Mobile No.",MobileNo);
      IF SkyAuth.FINDFIRST THEN BEGIN
          SavAcc.RESET;
          SavAcc.SETRANGE(SavAcc."No.", SkyAuth."Account No.");
          IF(SavAcc.FINDFIRST) THEN BEGIN
              Name := SavAcc.Name;
          END;

          IF((SkyAuth."Login Attempts Action" = 'SUSPEND') OR (SkyAuth."OTP Attempts Action" = 'SUSPEND')) THEN BEGIN
              IF((SkyAuth."Login Attempts Action" = 'SUSPEND') AND (SkyAuth."OTP Attempts Action" <> 'SUSPEND')) THEN BEGIN
                  IF(SkyAuth."Login Attempts Action Expiry" > CURRENTDATETIME) THEN BEGIN
                      Response := 'SUSPENDED'+':::'+Name+':::'+FORMAT(SkyAuth."Login Attempts Action Expiry")+':::'+FORMAT(SkyAuth."Login Attempts Count");
                      EXIT(Response);
                  END;
              END;
              IF((SkyAuth."Login Attempts Action" <> 'SUSPEND') AND (SkyAuth."OTP Attempts Action" = 'SUSPEND')) THEN BEGIN
                  IF(SkyAuth."OTP Attempts Action Expiry" > CURRENTDATETIME) THEN BEGIN
                      Response := 'SUSPENDED'+':::'+Name+':::'+FORMAT(SkyAuth."OTP Attempts Action Expiry")+':::'+FORMAT(SkyAuth."OTP Attempts Count");
                      EXIT(Response);
                  END;
              END;
              IF((SkyAuth."Login Attempts Action" = 'SUSPEND') AND (SkyAuth."OTP Attempts Action" = 'SUSPEND')) THEN BEGIN
                  IF(SkyAuth."Login Attempts Action Expiry" > SkyAuth."OTP Attempts Action Expiry") THEN BEGIN
                      IF(SkyAuth."Login Attempts Action Expiry" > CURRENTDATETIME) THEN BEGIN
                          Response := 'SUSPENDED'+':::'+Name+':::'+FORMAT(SkyAuth."Login Attempts Action Expiry")+':::'+FORMAT(SkyAuth."Login Attempts Count");
                          EXIT(Response);
                      END;
                  END
                  ELSE BEGIN
                      IF(SkyAuth."OTP Attempts Action Expiry" > CURRENTDATETIME) THEN BEGIN
                          Response := 'SUSPENDED'+':::'+Name+':::'+FORMAT(SkyAuth."OTP Attempts Action Expiry")+':::'+FORMAT(SkyAuth."OTP Attempts Count");
                          EXIT(Response);
                      END;
                  END;
              END;
          END;

          IF USSD AND (SkyAuth."Force PIN") THEN BEGIN
              Response := 'SET_PIN';
          END
          ELSE BEGIN

              IF USSD THEN BEGIN
                  IF (SkyAuth."PIN No."=PIN) AND ((SkyAuth.IMSI='')OR(SkyAuth.IMSI=IMSI_IMEI)) THEN BEGIN
                      Response := 'SUCCESS';
                      IF (SkyAuth.IMSI='') THEN BEGIN
                          SkyAuth.IMSI := IMSI_IMEI;
                          SkyAuth.MODIFY;
                      END;
                  END
                  ELSE BEGIN
                      IF (SkyAuth."PIN No."<>PIN) THEN BEGIN
                          Response := 'INCORRECT_PIN';
                      END;
                  END;
              END
              ELSE BEGIN
                  IF (SkyAuth."User Status" = SkyAuth."User Status"::Inactive) OR (SkyAuth."User Status" = SkyAuth."User Status"::" ")  THEN BEGIN
                      Response := 'BLOCKED';
                      EXIT;
                  END;

                  IF (SkyAuth."PIN No."=PIN) THEN BEGIN
                      Response := 'SUCCESS';
                      IF(SkyAuth."Mobile App KYC Login Enabled") THEN BEGIN
                          IF NOT (SkyAuth."Mobile App Activated" = TRUE) THEN BEGIN
                              Response := 'MOBILEAPP_INACTIVE_WITH_KYC';
                          END
                          ELSE IF NOT (SkyAuth.IMEI = IMSI_IMEI) THEN BEGIN
                              Response := 'INVALID_IMEI_WITH_KYC';
                          END;
                      END
                      ELSE BEGIN
                          IF NOT (SkyAuth."Mobile App Activated" = TRUE) THEN BEGIN
                              Response := 'MOBILEAPP_INACTIVE';
                          END
                          ELSE IF NOT (SkyAuth.IMEI = IMSI_IMEI) THEN BEGIN
                              Response := 'INVALID_IMEI';
                          END;
                      END;
                  END
                  ELSE IF(IMSI_IMEI='') THEN BEGIN
                      Response := 'INVALID_IMEI';
                  END
                  ELSE BEGIN
                      IF NOT SkyAuth."Mobile App Activated" THEN
                        Response := 'MOBILEAPP_INACTIVE'
                      ELSE
                        Response := 'INCORRECT_PIN';

                  END;
                  IF (SkyAuth."PIN No." <> PIN) THEN BEGIN
                      Response := 'INCORRECT_PIN';
                  END;
              END;
          END;
      END
      ELSE BEGIN
          Response := 'NOT_FOUND';
      END;

      IF NOT USSD THEN BEGIN
          IF Response = 'SUCCESS' THEN BEGIN
              MobileAppLogin(SessionID,MobileNo);
          END;
      END;

      IF(Response = 'SUCCESS') THEN BEGIN
          SkyAuth."Login Attempts Action" := 'NONE';
          SkyAuth."Login Attempts Tag" := '';
          CLEAR(SkyAuth."Login Attempts Action Expiry");
          SkyAuth."Login Attempts Count" := 0;
          SkyAuth.MODIFY;
      END;

      IF(Response = 'INCORRECT_PIN') THEN BEGIN
        SkyAuth."Login Attempts Count" := SkyAuth."Login Attempts Count" + 1;
        SkyAuth.MODIFY;
        AttemptsCount := SkyAuth."Login Attempts Count";
        Response := Response+':::'+FORMAT(AttemptsCount)+':::'+Name;
      END;
    END;

    PROCEDURE ValidateKYCdetails@75(MobileNo@1000 : Code[30];IDNo@1001 : Code[50];NewPIN@1007 : Text;OTCPIN@1004 : Text;IMEI_IMSI@1005 : Text;USSD@1002 : Boolean) Response : Text;
    VAR
      SkyAuth@1003 : Record 51516709;
      SavAcc@1006 : Record 23;
      NewIMEI_IMSI@1008 : Code[20];
    BEGIN
      MobileNo := '+'+ MobileNo;

      Response := 'ERROR';

      SavAcc.RESET;
      SavAcc.SETRANGE("ID No.",IDNo);
      SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
      IF SavAcc.FINDFIRST THEN BEGIN

          SkyAuth.RESET;
          SkyAuth.SETRANGE("Mobile No.",MobileNo);
          IF SkyAuth.FINDFIRST THEN BEGIN
              IF SkyAuth."PIN No." <> OTCPIN THEN
                  Response := 'INCORRECT_PIN'
              ELSE BEGIN

                  IF NewPIN = '' THEN
                      Response := 'INVALID_NEW_PIN'
                  ELSE BEGIN
                      SkyAuth."PIN No." := NewPIN;
                      SkyAuth."Force PIN" := FALSE;

                      IF USSD THEN BEGIN
                          IF SkyAuth.IMSI = '' THEN
                              SkyAuth.IMSI := IMEI_IMSI;
                      END
                      ELSE BEGIN
                          IF SkyAuth.IMEI = '' THEN
                              SkyAuth.IMEI := IMEI_IMSI;
                      END;
                      SkyAuth.MODIFY;
                      Response := 'SUCCESS';
                  END;
              END;
          END
          ELSE BEGIN
              Response := 'INVALID_ACCOUNT';
          END;

      END
      ELSE BEGIN
          Response := 'INVALID_ACCOUNT';
      END;
    END;

    PROCEDURE CorrectPin@102(MobileNo@1000 : Code[30];PIN@1001 : Text) Response : Boolean;
    VAR
      SkyAuth@1003 : Record 51516709;
    BEGIN


      Response := FALSE;

      SkyAuth.RESET;
      SkyAuth.SETRANGE(SkyAuth."Mobile No.",MobileNo);
      IF SkyAuth.FINDFIRST THEN BEGIN
          IF SkyAuth."PIN No." = PIN THEN
            Response:=TRUE
          ELSE
            Response:=FALSE;
      END;
    END;

    PROCEDURE LoanMiniStatement@126(EntryCode@1010 : GUID;TransactionID@1102755001 : Code[20];MaxNumberRows@1042 : Integer;LoanNo@1038 : Code[20];MobileNo@1039 : Code[20];Pin@1040 : Text) Response : Text;
    VAR
      SaccoFee@1005 : Decimal;
      VendorCommission@1004 : Decimal;
      TotalCharge@1003 : Decimal;
      SavAcc@1002 : Record 23;
      SaccoAccount@1001 : Code[20];
      VendorAccount@1000 : Code[20];
      PhoneNo@1006 : Code[20];
      AccBal@1007 : Decimal;
      JTemplate@1009 : Code[10];
      JBatch@1012 : Code[10];
      MobileTrans@1013 : Record 51516712;
      DocNo@1027 : Code[20];
      PDate@1026 : Date;
      AcctType@1025 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      BalAccType@1024 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      TransType@1023 : ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal';
      AccNo@1022 : Code[20];
      BalAccNo@1021 : Code[20];
      SourceType@1020 : 'New Member,New Account,Loan Account Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit, Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued';
      ExtDoc@1019 : Code[20];
      Dim1@1017 : Code[20];
      Dim2@1016 : Code[20];
      SystCreated@1014 : Boolean;
      CLedger@1028 : Record 51516224;
      LedgerCount@1029 : Integer;
      CurrRecord@1030 : Integer;
      DFilter@1031 : Text;
      DebitCreditFlag@1032 : Code[10];
      FirstEntry@1033 : Boolean;
      ProdFact@1036 : Record 51516717;
      TransactionDate@1011 : DateTime;
      Msg@1015 : Text;
      Stmt@1037 : Text;
      StatementAccount@1035 : Code[20];
      AccountToCharge@1034 : Code[20];
      MemberNo@1041 : Code[20];
      Loans@1043 : Record 51516230;
      LProduct@1008 : Code[20];
      AccountType@1120054000 : Record 51516295;
    BEGIN

      TransactionDate:=CURRENTDATETIME;
      MobileNo:='+'+MobileNo;

      Response:='ERROR';

      IF NOT CorrectPin(MobileNo,Pin) THEN BEGIN
          Response := 'INCORRECT_PIN';
          EXIT;
      END;


      // Get Excise duty G/L
      ExciseDutyGL := GetExciseDutyGL();
      ExciseDutyRate := GetExciseRate();
      ExciseDuty:=0;

      SaccoAccount:='';
      SaccoFee:=0;
      VendorAccount:='';
      VendorCommission:=0;
      AccountToCharge:='';

      MemberNo:='';
      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
      IF SavAcc.FINDFIRST THEN BEGIN
        MemberNo := SavAcc."BOSA Account No";
        AccountToCharge := SavAcc."No.";
      END;

      IF SavAcc.Blocked<>SavAcc.Blocked::" " THEN
        EXIT;

      StatementAccount:='';

      LProduct := '';
      IF Loans.GET(LoanNo) THEN BEGIN
        StatementAccount := Loans."Loan  No.";
        LProduct := Loans."Loan Product Type";
      END;



      SMSAccount:='';
      SMSCharge:=0;

      CoopSetup.RESET;
      CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Mini-Statement");
      IF CoopSetup.FINDFIRST THEN BEGIN

          SMSAccount := CoopSetup."SMS Account";
          SMSCharge := CoopSetup."SMS Charge";


          SaccoAccount := CoopSetup."Sacco Fee Account";
          SaccoFee := CoopSetup."Sacco Fee";
          VendorAccount:=CoopSetup."Vendor Commission Account";
          VendorCommission:=CoopSetup."Vendor Commission";

          GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,Safcom,0);
          TotalCharge:=SaccoFee+VendorCommission+SMSCharge;
          ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);
      END
      ELSE BEGIN
          ERROR('Setup Missing for %1',CoopSetup."Transaction Type");
      END;


      //PhoneNo:='+'+MobileNo;

      SavAcc.RESET;
      SavAcc.SETRANGE("No.",AccountToCharge);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FINDFIRST THEN BEGIN

          AccountType.GET(SavAcc."Account Type");

          IF (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::"Deposits Only") OR
              (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::" ") THEN BEGIN
              ERROR('The Account to Charge is not a Withdrawable Account');
          END;



          AccBal := GetAccountBalance(SavAcc."No.");
          IF AccBal >= TotalCharge+ExciseDuty THEN BEGIN

              //BUser.GET(USERID);

              //BUser.TESTFIELD("Cashier Journal Template");
              //BUser.TESTFIELD("Cashier Journal Batch");

              JTemplate:='GENERAL';
              JBatch:='SKYWORLD';

              GenJournalBatch.RESET;
              GenJournalBatch.SETRANGE("Journal Template Name",JTemplate);
              GenJournalBatch.SETRANGE(Name,JBatch);
              IF NOT GenJournalBatch.FINDFIRST THEN BEGIN
                  GenJournalBatch.INIT;
                  GenJournalBatch."Journal Template Name" := JTemplate;
                  GenJournalBatch.Name:=JBatch;
                  GenJournalBatch.Description:='Sky World Batch';
                  GenJournalBatch.INSERT;
              END;

              MobileTrans.INIT;
              MobileTrans."Entry No." := EntryCode;
              MobileTrans."Transaction ID":=TransactionID;
              MobileTrans."Session ID":=TransactionID;
              MobileTrans."Transaction Date":=DT2DATE(TransactionDate);
              MobileTrans."Transaction Time":=DT2TIME(TransactionDate);
              MobileTrans."Date Captured" := TransactionDate;
              MobileTrans."Vendor Commission":=VendorCommission;
              MobileTrans."Sacco Fee":=SaccoFee;
              MobileTrans."Member Account":=SavAcc."No.";
              MobileTrans."Statement Max Rows":=MaxNumberRows;
              //MobileTrans."Statement Start Date":=StartDate;
              //MobileTrans."Statement End Date":=EndDate;
              MobileTrans."Account to Check":=StatementAccount;
              MobileTrans."Transaction Type":=MobileTrans."Transaction Type"::"Mini-Statement";
              MobileTrans.Description:=FORMAT(MobileTrans."Transaction Type");
              MobileTrans."Savings Product" := ProdFact."Product ID";
              MobileTrans.INSERT;

              {
              MobileTrans.RESET;
              MobileTrans.SETRANGE("Transaction ID",TransactionID);
              MobileTrans.SETRANGE(Posted,FALSE);
              IF MobileTrans.FINDFIRST THEN BEGIN

                  DocNo := MobileTrans."Transaction ID";
                  PDate := MobileTrans."Transaction Date";
                  AccNo := MobileTrans."Member Account";
                  ExtDoc := '';
                  LoanNo := '';
                  TransType := TransType::" ";
                  Dim1 := SavAcc."Global Dimension 1 Code";
                  Dim2 := SavAcc."Global Dimension 2 Code";
                  SystCreated := TRUE;

                  SaccoTrans.InitJournal(JTemplate,JBatch);


                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                '',VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                '',SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccountToCharge,COPYSTR('SMS Charges',1,50),BalAccType::"G/L Account",
                                SMSAccount,SMSCharge,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR('Excise Duty',1,50),BalAccType::"G/L Account",
                                ExciseDutyGL,ExciseDuty,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  AccNo := VendorAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(MobileTrans.Description+' Commission',1,50),BalAccType::"G/L Account",
                                '',-VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  AccNo := SaccoAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",AccNo,COPYSTR(MobileTrans.Description+' Fee',1,50),BalAccType::"G/L Account",
                                '',-SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  MobileTrans.Posted:=TRUE;
                  MobileTrans."Posted By":=USERID;
                  MobileTrans."Date Posted":=TODAY;
                  MobileTrans.MODIFY;

                  SaccoTrans.PostJournal(JTemplate,JBatch);

              END
              ELSE BEGIN
                  ERROR('Transaction Not Found');
              END;
              }
          END
          ELSE BEGIN
              Response:='INSUFFICIENT_BAL';
          END;


          IF Response='ERROR' THEN BEGIN
              MobileTrans.RESET;
              MobileTrans.SETRANGE("Transaction ID",TransactionID);
              //MobileTrans.SETRANGE(Posted,TRUE);
              IF MobileTrans.FINDFIRST THEN BEGIN
                  Loans.GET(StatementAccount);

                  CLedger.RESET;
                  CLedger.SETCURRENTKEY("Posting Date");
                  CLedger.ASCENDING(FALSE);
                  CLedger.SETRANGE("Customer No.",Loans."Client Code");
                  CLedger.SETRANGE("Loan No",Loans."Loan  No.");
                  CLedger.SETRANGE(Reversed,FALSE);
                  IF CLedger.FINDFIRST THEN BEGIN
                      AccBal:=0;
                      Msg := '';
                      REPEAT
                          LedgerCount+=1;

                          Stmt := '['+FORMAT(CLedger."Posting Date")+';'+FORMAT(CLedger."Transaction Type")+';'+FORMAT(CLedger."Amount (LCY)"*-1)+']';
                          IF STRLEN(Msg+Stmt)<150 THEN BEGIN
                              Msg+=Stmt;
                          END;

                      UNTIL (CLedger.NEXT=0) OR (CLedger.COUNT=MaxNumberRows);

                      Priority:=203;
                      SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",Msg,StatementAccount,'',TRUE,Priority,FALSE);

                      Response:='SUCCESS';
                  END;
              END;
          END;
      END
      ELSE BEGIN
          Response := 'INVALID_ACCOUNT';
      END;
    END;

    PROCEDURE SendSms@1102755000(Source@1102755000 : 'NEW_MEMBER,NEW_ACCOUNT,LOAN_ACCOUNT_APPROVAL,DEPOSIT_CONFIRMATION,CASH_WITHDRAWAL_CONFIRM,LOAN_APPLICATION,LOAN_APPRAISAL,LOAN_GUARANTORS,LOAN_REJECTED,LOAN_POSTED,LOAN_DEFAULTED,SALARY_PROCESSING,TELLER_CASH_DEPOSIT,TELLER_CASH_WITHDRAWAL,TELLER_CHEQUE_DEPOSIT,FIXED_DEPOSIT_MATURITY,INTERACCOUNT_TRANSFER,ACCOUNT_STATUS,STATUS_ORDER,EFT_EFFECTED,ATM_APPLICATION_FAILED,ATM_COLLECTION,MBANKING,MEMBER_CHANGES,CASHIER_BELOW_LIMIT,CASHIER_ABOVE_LIMIT,INTERNETBANKING,CRM,MOBILE_PIN,WITHDRAWAL';Telephone@1102755001 : Text[200];Textsms@1102755002 : Text[250];Reference@1102755003 : Text[50];AccNo@1000 : Text[50];Chargeable@1001 : Boolean;Priority@1004 : Integer;ChargeMember@1006 : Boolean) Inserted : Boolean;
    VAR
      EntryNo@1002 : Integer;
      SkySMS@1003 : Record 51516711;
      Category@1005 : Code[100];
    BEGIN

      EntryNo:=EntryNo+1;


      IF STRLEN(Telephone) = 13 THEN BEGIN
          Telephone := COPYSTR(Telephone,2,12);
      END;

      IF STRLEN(Telephone) = 10 THEN BEGIN
          IF COPYSTR(Telephone,1,1) = '0' THEN
              Telephone := '254'+COPYSTR(Telephone,2,9);
      END;

      IF STRLEN(Telephone) = 9 THEN BEGIN
          IF COPYSTR(Telephone,1,1) = '7' THEN
              Telephone := '254'+Telephone
      END;




      Category:=FORMAT(Source);
      Priority := GetSMSPriority(Category);
      IF Priority = 0 THEN
        Priority := 250;




      GeneralLedgerSetup.GET;

      GeneralLedgerSetup.TESTFIELD("SMS Sender ID");
      GeneralLedgerSetup.TESTFIELD("SMS Sender Name");

      Inserted := FALSE;

      IF STRLEN(Telephone) = 12 THEN BEGIN
          SkySMS.INIT;
          SkySMS.originator_id := CREATEGUID;
          SkySMS.msg_id:=0;
          SkySMS.msg_product_id:=GeneralLedgerSetup."SMS Sender ID";
          SkySMS.msg_provider_code:='0';
          SkySMS.msg_charge:='';
          SkySMS.msg_status_code:=10;
          SkySMS.msg_status_description:='New MSG';
          SkySMS.msg_status_date:=CURRENTDATETIME;
          SkySMS.sender:=GeneralLedgerSetup."SMS Sender Name";
          SkySMS.receiver:=Telephone;
          SkySMS.msg:=Textsms;
          SkySMS.msg_type:='MT';
          SkySMS.msg_source_reference:='';
          SkySMS.msg_destination_reference:='';
          SkySMS.msg_xml_data:='<OTHER_DETAILS/>';
          SkySMS.msg_category:=Category;
          SkySMS.msg_priority:=Priority;
          SkySMS.msg_send_count:=0;
          SkySMS.schedule_msg:='NO';
          SkySMS.date_scheduled:=CURRENTDATETIME;
          SkySMS.msg_send_integrity_hash:='';
          //SkySMS.msg_response_date:=CURRENTDATETIME;
          //SkySMS.msg_response_xml_data:='';
          //SkySMS.msg_response_integrity_hash:='';
          SkySMS.transaction_date:=CURRENTDATETIME;
          SkySMS.date_created:=CURRENTDATETIME;
          SkySMS."SMS Date":=TODAY;
          IF Chargeable THEN
            SkySMS."Account To Charge" := AccNo;

          SkySMS.transaction_id := 0;
          SkySMS.server_id := 0;
          SkySMS.msg_charge_applied:='';
          SkySMS.msg_format := 'TEXT';
          SkySMS.msg_command := 'BulkSMS';
          SkySMS.msg_sensitivity := 'NORMAL';
          SkySMS.msg_response_description := '';
          SkySMS.msg_result_description := '';
          SkySMS.msg_result_xml_data := '';
          SkySMS.msg_result_date := CURRENTDATETIME;
          SkySMS.msg_result_integrity_hash := '';
          SkySMS.msg_result_submit_count := 0;
          SkySMS.msg_result_submit_status := 'PENDING';
          SkySMS.msg_result_submit_description := '';
          SkySMS.msg_result_submit_date:=CURRENTDATETIME;
          SkySMS.sender_type := 'SENDER_ID';
          SkySMS.receiver_type := 'MSISDN';
          SkySMS.msg_mode := 'SAF';
          IF Source = Source::MOBILE_PIN THEN BEGIN
              SkySMS.msg_general_flag := 'NOT_MASKED';
          END;
          SkySMS."Charge Member" := ChargeMember;

          SkySMS.INSERT;
          Inserted := TRUE;
      END;
    END;

    PROCEDURE SendSmsWithID@85(Source@1102755000 : 'NEW_MEMBER,NEW_ACCOUNT,LOAN_ACCOUNT_APPROVAL,DEPOSIT_CONFIRMATION,CASH_WITHDRAWAL_CONFIRM,LOAN_APPLICATION,LOAN_APPRAISAL,LOAN_GUARANTORS,LOAN_REJECTED,LOAN_POSTED,LOAN_DEFAULTED,SALARY_PROCESSING,TELLER_CASH_DEPOSIT,TELLER_CASH_WITHDRAWAL,TELLER_CHEQUE_DEPOSIT,FIXED_DEPOSIT_MATURITY,INTERACCOUNT_TRANSFER,ACCOUNT_STATUS,STATUS_ORDER,EFT_EFFECTED,ATM_APPLICATION_FAILED,ATM_COLLECTION,MBANKING,MEMBER_CHANGES,CASHIER_BELOW_LIMIT,CASHIER_ABOVE_LIMIT,INTERNETBANKING,CRM,MOBILE_PIN,WITHDRAWAL';Telephone@1102755001 : Text[200];Textsms@1102755002 : Text[250];Reference@1102755003 : Text[30];AccNo@1000 : Text[30];Chargeable@1001 : Boolean;Priority@1004 : Integer;ChargeMember@1006 : Boolean;RequestApplication@1007 : Text[30];RequestCorrelationID@1008 : Text[50];SourceApplication@1009 : Text[30]) Inserted : Boolean;
    VAR
      EntryNo@1002 : Integer;
      SkySMS@1003 : Record 51516711;
      Category@1005 : Code[100];
    BEGIN

      EntryNo:=EntryNo+1;


      IF STRLEN(Telephone) = 13 THEN BEGIN
          Telephone := COPYSTR(Telephone,2,12);
      END;

      IF STRLEN(Telephone) = 10 THEN BEGIN
          IF COPYSTR(Telephone,1,1) = '0' THEN
              Telephone := '254'+COPYSTR(Telephone,2,9);
      END;

      IF STRLEN(Telephone) = 9 THEN BEGIN
          IF COPYSTR(Telephone,1,1) = '7' THEN
              Telephone := '254'+Telephone
      END;


      Category:=FORMAT(Source);
      Priority := GetSMSPriority(Category);
      IF Priority = 0 THEN
        Priority := 250;

      Inserted := FALSE;

      GeneralLedgerSetup.GET;

      GeneralLedgerSetup.TESTFIELD("SMS Sender ID");
      GeneralLedgerSetup.TESTFIELD("SMS Sender Name");
      Inserted := FALSE;
      IF STRLEN(Telephone) = 12 THEN BEGIN
          SkySMS.INIT;
          SkySMS.originator_id := CREATEGUID;
          SkySMS.msg_id:=0;
          SkySMS.msg_product_id:=GeneralLedgerSetup."SMS Sender ID";
          SkySMS.msg_provider_code:='0';
          SkySMS.msg_charge:='';
          SkySMS.msg_status_code:=10;
          SkySMS.msg_status_description:='New MSG';
          SkySMS.msg_status_date:=CURRENTDATETIME;
          SkySMS.sender:=GeneralLedgerSetup."SMS Sender Name";
          SkySMS.receiver:=Telephone;
          SkySMS.msg:=Textsms;
          SkySMS.msg_type:='MT';
          SkySMS.msg_source_reference:='';
          SkySMS.msg_destination_reference:='';
          SkySMS.msg_xml_data:='<OTHER_DETAILS/>';
          SkySMS.msg_category:=Category;
          SkySMS.msg_priority:=Priority;

          SkySMS.msg_send_count:=0;
          SkySMS.schedule_msg:='NO';
          SkySMS.date_scheduled:=CURRENTDATETIME;
          SkySMS.msg_send_integrity_hash:='';
          //SkySMS.msg_response_date:=CURRENTDATETIME;
          //SkySMS.msg_response_xml_data:='';
          //SkySMS.msg_response_integrity_hash:='';
          SkySMS.transaction_date:=CURRENTDATETIME;
          SkySMS.date_created:=CURRENTDATETIME;
          SkySMS."SMS Date":=TODAY;
          IF Chargeable THEN
            SkySMS."Account To Charge" := AccNo;

          SkySMS.msg_request_application := RequestApplication;
          SkySMS.msg_request_correlation_id := RequestCorrelationID;
          SkySMS.msg_source_application := SourceApplication;

          SkySMS.transaction_id := 0;
          SkySMS.server_id := 0;
          SkySMS.msg_charge_applied:='';
          SkySMS.msg_format := 'TEXT';
          SkySMS.msg_command := 'BulkSMS';
          SkySMS.msg_sensitivity := 'NORMAL';
          SkySMS.msg_response_description := '';
          SkySMS.msg_result_description := '';
          SkySMS.msg_result_xml_data := '';
          SkySMS.msg_result_date := CURRENTDATETIME;
          SkySMS.msg_result_integrity_hash := '';
          SkySMS.msg_result_submit_count := 0;
          SkySMS.msg_result_submit_status := 'PENDING';
          SkySMS.msg_result_submit_description := '';
          SkySMS.msg_result_submit_date:=CURRENTDATETIME;
          SkySMS.sender_type := 'SENDER_ID';
          SkySMS.receiver_type := 'MSISDN';
          SkySMS.msg_mode := 'SAF';
          IF Source = Source::MOBILE_PIN THEN BEGIN
              SkySMS.msg_general_flag := 'NOT_MASKED';
          END;
          SkySMS."Charge Member" := ChargeMember;

          SkySMS.INSERT;
          Inserted := TRUE;
      END;
    END;

    PROCEDURE GetAccountTransferRecipientXML@1000000000(Criteria@1102755000 : Code[20];Source@1001 : Text) Response : Text;
    VAR
      SavAcc@1000 : Record 23;
      PFact@1002 : Record 51516717;
      xmlWriter@1008 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlTextWriter";
      EncodingText@1007 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
      XMLDOMMgt@1006 : Codeunit 6224;
      BodyContentXmlDoc@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      EnvelopeXmlNode@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      CreatedXmlNode@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN

      Response:='';


      IF Source = 'Mobile' THEN BEGIN

          IF STRLEN(Criteria) = 10 THEN
            IF COPYSTR(Criteria,1,1) = '0' THEN
               Criteria := COPYSTR(Criteria,2,9);

          SavAcc.RESET;
          SavAcc.SETFILTER("Transactional Mobile No",'*'+Criteria);
          SavAcc.SETFILTER(Blocked,'<>%1',SavAcc.Blocked::All);
          IF SavAcc.FINDFIRST THEN BEGIN
              Response:=SavAcc."No.";
              Response := '<Account>';
              Response += '<AccountNo>'+SavAcc."No."+'</AccountNo>';
              Response += '<AccountName>'+SavAcc.Name+'</AccountName>';
              Response += '<Name>'+SavAcc.Name+'</Name>';
              Response += '<MemberNo>'+SavAcc."BOSA Account No"+'</MemberNo>';
              Response += '<PhoneNo>'+SavAcc."Transactional Mobile No"+'</PhoneNo>';
              Response += '</Account>';

          END
          ELSE BEGIN

              SavAcc.RESET;
              SavAcc.SETFILTER("Mobile Phone No",'*%1','*'+Criteria);
              SavAcc.SETFILTER(Blocked,'<>%1',SavAcc.Blocked::All);
              IF SavAcc.FINDFIRST THEN BEGIN
              Response:=SavAcc."No.";
              Response := '<Account>';
              Response += '<AccountNo>'+SavAcc."No."+'</AccountNo>';
              Response += '<AccountName>'+SavAcc.Name+'</AccountName>';
              Response += '<Name>'+SavAcc.Name+'</Name>';
              Response += '<MemberNo>'+SavAcc."BOSA Account No"+'</MemberNo>';
              Response += '<PhoneNo>'+SavAcc."Transactional Mobile No"+'</PhoneNo>';
              Response += '</Account>';

              END;
          END
      END
      ELSE IF Source = 'ID' THEN BEGIN
          SavAcc.RESET;
          SavAcc.SETRANGE("ID No.",Criteria);
          SavAcc.SETFILTER(Blocked,'<>%1',SavAcc.Blocked::All);
          IF SavAcc.FINDFIRST THEN BEGIN
              Response:=SavAcc."No.";
              Response := '<Account>';
              Response += '<AccountNo>'+SavAcc."No."+'</AccountNo>';
              Response += '<AccountName>'+SavAcc.Name+'</AccountName>';
              Response += '<Name>'+SavAcc.Name+'</Name>';
              Response += '<MemberNo>'+SavAcc."BOSA Account No"+'</MemberNo>';
              Response += '<PhoneNo>'+SavAcc."Transactional Mobile No"+'</PhoneNo>';
              Response += '</Account>';

          END
      END
      ELSE IF Source = 'ACCOUNT' THEN BEGIN
          SavAcc.RESET;
          SavAcc.SETRANGE("No.",Criteria);
          IF SavAcc.FINDFIRST THEN BEGIN
              Response:=SavAcc."No.";
              Response := '<Account>';
              Response += '<AccountNo>'+SavAcc."No."+'</AccountNo>';
              Response += '<AccountName>'+SavAcc.Name+'</AccountName>';
              Response += '<Name>'+SavAcc.Name+'</Name>';
              Response += '<MemberNo>'+SavAcc."BOSA Account No"+'</MemberNo>';
              Response += '<PhoneNo>'+SavAcc."Transactional Mobile No"+'</PhoneNo>';
              Response += '</Account>';

          END
      END
    END;

    PROCEDURE AccountBalanceEnquiryMobileApp@1000000001(EntryCode@1041 : GUID;TransactionID@1102755001 : Code[20];PhoneNo@1015 : Code[20];PIN@1000000000 : Text;AccountToCheck@1000000001 : Code[20]) Response : Text[1024];
    VAR
      SaccoFee@1033 : Decimal;
      VendorCommission@1032 : Decimal;
      TotalCharge@1031 : Decimal;
      SavAcc@1030 : Record 23;
      SaccoAccount@1029 : Code[20];
      VendorAccount@1028 : Code[20];
      AccBal@1026 : Decimal;
      JTemplate@1024 : Code[10];
      JBatch@1023 : Code[10];
      MobileTrans@1022 : Record 51516712;
      DocNo@1021 : Code[20];
      PDate@1020 : Date;
      AcctType@1019 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      BalAccType@1017 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      TransType@1016 : ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal';
      AccNo@1014 : Code[20];
      BalAccNo@1013 : Code[20];
      SourceType@1012 : 'New Member,New Account,Loan Account Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit, Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued';
      ExtDoc@1010 : Code[20];
      LoanNo@1009 : Code[20];
      Dim1@1008 : Code[20];
      Dim2@1007 : Code[20];
      SystCreated@1006 : Boolean;
      SLedger@1005 : Record 25;
      LedgerCount@1004 : Integer;
      CurrRecord@1003 : Integer;
      DFilter@1002 : Text;
      DebitCreditFlag@1001 : Code[10];
      FirstEntry@1000 : Boolean;
      ProdFact@1034 : Record 51516717;
      AccountBookBalance@1035 : Decimal;
      AccountAvailableBalance@1036 : Decimal;
      AccountToCharge@1037 : Code[20];
      Found@1027 : Boolean;
      MemberNo@1038 : Code[20];
      TransactionDate@1011 : DateTime;
      Loans@1039 : Record 51516230;
      LoanType@1040 : Text;
      BalStmt@1043 : Text;
      msg@1044 : Text;
      SafcomCharges@1045 : Record 51516708;
      SafcomFee@1046 : Decimal;
      BalEnqCharge@1018 : Decimal;
      StmtProduct@1042 : Code[20];
      StmtMemberNo@1025 : Code[20];
      AccountType@1120054000 : Record 51516295;
    BEGIN
      TransactionDate := CURRENTDATETIME;

      Response:='';
      Found:=FALSE;


      PhoneNo := '+'+PhoneNo;

      IF NOT CorrectPin(PhoneNo,PIN) THEN BEGIN

          Response:='<Response>';
            Response+='<Status>INCORRECT_PIN</Status>';
            Response+='<StatusDescription>Incorrect PIN</StatusDescription>';
            Response+='<Reference>'+TransactionID+'</Reference>';
          Response+='</Response>';

          EXIT;
      END;



      AccountToCharge:='';
      MemberNo:='';

      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
      IF SavAcc.FINDFIRST THEN BEGIN
          AccountToCharge:=SavAcc."No.";
          MemberNo:=SavAcc."BOSA Account No";
          IF SavAcc.Blocked<>SavAcc.Blocked::" " THEN
            EXIT;
      END;

      //MESSAGE(MemberNo);

      IF MemberNo='' THEN
          ERROR('Member No. Missing');

      IF AccountToCharge='' THEN
          ERROR('Account to charge missing');


      // Get Excise duty G/L
      ExciseDutyGL := GetExciseDutyGL();
      ExciseDutyRate := GetExciseRate();
      ExciseDuty:=0;

      SaccoAccount:='';
      SaccoFee:=0;
      VendorAccount:='';
      VendorCommission:=0;


      SMSAccount:='';
      SMSCharge:=0;

      CoopSetup.RESET;
      CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Balance Enquiry");
      IF CoopSetup.FINDFIRST THEN BEGIN

          SMSAccount := CoopSetup."SMS Account";
          SMSCharge := CoopSetup."SMS Charge";


          SaccoAccount := CoopSetup."Sacco Fee Account";
          SaccoFee := CoopSetup."Sacco Fee";
          VendorAccount:=CoopSetup."Vendor Commission Account";
          VendorCommission:=CoopSetup."Vendor Commission";


          GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,Safcom,0);
          TotalCharge:=SaccoFee+VendorCommission+SMSCharge;
          ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);
          ExciseDuty:=0;
      END
      ELSE BEGIN
          ERROR('Setup Missing for %1',CoopSetup."Transaction Type");
      END;



      IF SavAcc.GET(AccountToCharge) THEN BEGIN

          AccountType.GET(SavAcc."Account Type");


          IF (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::"Deposits Only") OR
              (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::" ") THEN BEGIN
              ERROR('The Account to Charge is not a Withdrawable Account');

          END;

          BalEnqCharge:=0;

          AccBal := GetAccountBalance(SavAcc."No.");
          IF AccBal >= TotalCharge+ExciseDuty THEN BEGIN
              BalEnqCharge := TotalCharge+ExciseDuty;
              //BUser.GET(USERID);

              //BUser.TESTFIELD("Cashier Journal Template");
              //BUser.TESTFIELD("Cashier Journal Batch");

              JTemplate:='GENERAL';
              JBatch:='SKYWORLD';

              GenJournalBatch.RESET;
              GenJournalBatch.SETRANGE("Journal Template Name",JTemplate);
              GenJournalBatch.SETRANGE(Name,JBatch);
              IF NOT GenJournalBatch.FINDFIRST THEN BEGIN
                  GenJournalBatch.INIT;
                  GenJournalBatch."Journal Template Name" := JTemplate;
                  GenJournalBatch.Name:=JBatch;
                  GenJournalBatch.Description:='Sky World Batch';
                  GenJournalBatch.INSERT;
              END;

              {
              MobileTrans.INIT;
              MobileTrans."Entry No." := EntryCode;
              MobileTrans."Transaction ID":=TransactionID;
              MobileTrans."Session ID":=TransactionID;
              MobileTrans."Transaction Date":=DT2DATE(TransactionDate);
              MobileTrans."Transaction Time":=DT2TIME(TransactionDate);
              MobileTrans."Member Account":=SavAcc."No.";
              MobileTrans.MobileApp := TRUE;
              MobileTrans."Transaction Type":=MobileTrans."Transaction Type"::"Balance Enquiry";
              MobileTrans.Description:=FORMAT(MobileTrans."Transaction Type");
              MobileTrans.Posted:=TRUE;
              MobileTrans.INSERT;
              }

              {
              MobileTrans.RESET;
              MobileTrans.SETRANGE("Transaction ID",TransactionID);
              MobileTrans.SETRANGE(Posted,FALSE);
              IF MobileTrans.FINDFIRST THEN BEGIN

                  DocNo := MobileTrans."Transaction ID";
                  PDate := MobileTrans."Transaction Date";
                  AccNo := MobileTrans."Member Account";
                  ExtDoc := '';
                  LoanNo := '';
                  TransType := TransType::" ";
                  Dim1 := SavAcc."Global Dimension 1 Code";
                  Dim2 := SavAcc."Global Dimension 2 Code";
                  SystCreated := TRUE;

                  SaccoTrans.InitJournal(JTemplate,JBatch);

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                '',VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                '',SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccountToCharge,COPYSTR('SMS Charges ',1,50),BalAccType::"G/L Account",
                                SMSAccount,SMSCharge,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR('Excise Duty',1,50),BalAccType::"G/L Account",
                                ExciseDutyGL,ExciseDuty,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  AccNo := VendorAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(MobileTrans.Description+' Commission',1,50),BalAccType::"G/L Account",
                                '',-VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  AccNo := SaccoAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",AccNo,COPYSTR(MobileTrans.Description+' Fee',1,50),BalAccType::"G/L Account",
                                '',-SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  MobileTrans.Posted:=TRUE;
                  MobileTrans."Posted By":=USERID;
                  MobileTrans."Date Posted":=TODAY;
                  MobileTrans.MODIFY;

                  SaccoTrans.PostJournal(JTemplate,JBatch);

              END;
              }
          END
          ELSE BEGIN
              Response:='INSUFFICIENT_BAL';

              Response:='<Response>';
                Response+='<Status>INSUFFICIENT_BAL</Status>';
                Response+='<StatusDescription>Insufficient Balance</StatusDescription>';
                Response+='<Reference>'+TransactionID+'</Reference>';
              Response+='</Response>';

          END;
      END
      ELSE BEGIN
          Response:='<Response>';
            Response+='<Status>INVALID_ACCOUNT</Status>';
            Response+='<StatusDescription>Invalid Account</StatusDescription>';
            Response+='<Reference>'+TransactionID+'</Reference>';
          Response+='</Response>';
      END;


      IF (Response='') THEN BEGIN

          BalEnqCharge:=0;
          SavAcc.RESET;
          SavAcc.SETRANGE("No.",AccountToCheck);
          IF SavAcc.FIND('-') THEN BEGIN
              Response:='<Balances>';
              REPEAT


                  AccountType.GET(SavAcc."Account Type");
                  SavAcc.CALCFIELDS("Balance (LCY)");
                  AccountBookBalance := SavAcc."Balance (LCY)";
                  AccountAvailableBalance := GetAccountBalance(SavAcc."No.");

                  IF AccountType.Code = 'ORDINARY' THEN BEGIN

                      SMSCharge:=0;

                      CoopSetup.RESET;
                      CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::Withdrawal);
                      IF CoopSetup.FINDFIRST THEN BEGIN

                          SMSCharge := CoopSetup."SMS Charge";

                          SafcomCharges.RESET;
                          SafcomCharges.SETFILTER(Charge,'>0');
                          SafcomCharges.SETFILTER(Minimum,'<%1',AccountAvailableBalance);
                          SafcomCharges.SETFILTER(Maximum,'>%1',AccountAvailableBalance);
                          IF SafcomCharges.FINDFIRST THEN BEGIN
                              SafcomFee:=SafcomCharges.Charge;
                          END;
                          SaccoFee := CoopSetup."Sacco Fee";
                          VendorCommission:=CoopSetup."Vendor Commission";

                          GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,SafcomFee,AccountAvailableBalance);
                          TotalCharge:=SaccoFee+VendorCommission+SafcomFee+SMSCharge;
                          ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);

                          AccountBookBalance -= (BalEnqCharge+TotalCharge+ExciseDuty);
                          //AccountBookBalance -= BalEnqCharge;
                          AccountAvailableBalance -= (BalEnqCharge+TotalCharge+ExciseDuty);
                      END;
                  END;




                  Response+='<Account>';
                    Response+='<Product>'+AccountType.Description+'</Product>';
                    Response+='<Date>'+FORMAT(TransactionDate)+'</Date>';
                    Response+='<BookBalance>'+FORMAT(AccountBookBalance)+'</BookBalance>';
                    IF (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::"Withdrawals Only") OR (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::"Deposits & Withdrawals") THEN
                    Response+='<AvailableBalance>'+FORMAT(AccountAvailableBalance)+'</AvailableBalance>'
                    ELSE
                    Response+='<AvailableBalance>'+''+'</AvailableBalance>';

                  Response+='</Account>';


              UNTIL SavAcc.NEXT = 0;

              Response+='</Balances>';
          END
          ELSE BEGIN

              Response:='<Balances>';

              ProdFact.RESET;
              ProdFact.SETRANGE("Product Class Type",ProdFact."Product Class Type"::Savings);
              IF ProdFact.FIND('-') THEN BEGIN
                  REPEAT

                      IF Members.GET(MemberNo) THEN BEGIN
                          //MESSAGE('%1\%2',AccountToCheck,ProdFact."Key Word"+MemberNo);

                          IF AccountToCheck = ProdFact."Key Word"+MemberNo THEN BEGIN
                              IF ProdFact."Product Category" = ProdFact."Product Category"::"Deposit Contribution" THEN BEGIN
                                  Members.CALCFIELDS("Current Shares");
                                  AccountBookBalance := Members."Current Shares";
                              END;

                              IF ProdFact."Product Category" = ProdFact."Product Category"::"Shares Capital" THEN BEGIN
                                  Members.CALCFIELDS("Shares Retained");
                                  AccountBookBalance := Members."Shares Retained";
                              END;
                              IF ProdFact."Product Category" = ProdFact."Product Category"::"SchFee Shares" THEN BEGIN
                                  Members.CALCFIELDS("School Fees Shares");
                                  AccountBookBalance := Members."School Fees Shares";
                              END;


                              AccountAvailableBalance := AccountBookBalance;


                              Response+='<Account>';
                                Response+='<Product>'+ProdFact."USSD Product Name"+'</Product>';
                                Response+='<Date>'+FORMAT(TransactionDate)+'</Date>';
                                Response+='<BookBalance>'+FORMAT(AccountBookBalance)+'</BookBalance>';
                                IF (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::"Withdrawals Only") OR (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::"Deposits & Withdrawals") THEN
                                Response+='<AvailableBalance>'+FORMAT(AccountAvailableBalance)+'</AvailableBalance>'
                                ELSE
                                Response+='<AvailableBalance>'+''+'</AvailableBalance>';

                              Response+='</Account>';
                          END;
                      END;
                  UNTIL ProdFact.NEXT = 0;

              END;


              Response+='</Balances>';
          END;
      END;
    END;

    PROCEDURE GetMemberLoanListMobileApp@1000000002(Phone@1000 : Code[20];WithPrefix@1011 : Boolean) Response : Text;
    VAR
      MobileNo@1001 : Code[20];
      Loans@1002 : Record 51516230;
      LoanProduct@1003 : Record 51516240;
      SavAcc@1004 : Record 23;
      MemberNo@1005 : Code[20];
      MaxLoan@1006 : Decimal;
      Found@1008 : Boolean;
      LoanNo@1010 : Code[20];
      LoanBal@1009 : Decimal;
      ProductName@1007 : Text;
    BEGIN

      MobileNo:='+'+Phone;


      Response:='';
      Found:=FALSE;
      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FINDFIRST THEN BEGIN

          MemberNo := SavAcc."BOSA Account No";

          Loans.RESET;
          Loans.SETRANGE("Client Code",MemberNo);
          Loans.SETFILTER("Outstanding Balance",'>0');
          IF Loans.FIND('-') THEN BEGIN
              Response:='<Loans>';
              REPEAT

                  LoanBal := 0;
                  Loans.CALCFIELDS("Outstanding Balance","Oustanding Interest","Oustanding Penalty");
                  LoanBal := ROUND(Loans."Outstanding Balance"+Loans."Oustanding Interest"+Loans."Oustanding Penalty",1,'>');
                  LoanNo := Loans."Loan  No.";

                  IF LoanProduct.GET(Loans."Loan Product Type") THEN BEGIN

                      ProductName := LoanProduct."Product Description";
                      IF LoanProduct."USSD Product Name" <> '' THEN
                        ProductName := LoanProduct."USSD Product Name";

                      Found:=TRUE;
                      IF WithPrefix THEN
                          LoanNo := 'LOAN'+LoanNo;

                      Response += '<Product>';
                        Response += '<LoanNo>'+LoanNo+'</LoanNo>';
                        Response += '<ProductType>'+ProductName+'</ProductType>';
                        Response += '<LoanBalance>'+FORMAT(LoanBal)+'</LoanBalance>';

                      Response += '</Product>';
                  END;
              UNTIL Loans.NEXT=0;
              Response+='</Loans>';

          END;

      END;

      IF NOT Found THEN
        Response:='';
    END;

    PROCEDURE AccountMiniStatementMobileApp@17(EntryCode@1010 : GUID;TransactionID@1102755001 : Code[20];MaxNumberRows@1042 : Integer;StartDate@1035 : Date;EndDate@1043 : Date;StatementAccount@1038 : Code[20];MobileNo@1039 : Code[20];Pin@1040 : Text) Response : Text;
    VAR
      SaccoFee@1005 : Decimal;
      VendorCommission@1004 : Decimal;
      TotalCharge@1003 : Decimal;
      SavAcc@1002 : Record 23;
      SaccoAccount@1001 : Code[20];
      VendorAccount@1000 : Code[20];
      PhoneNo@1006 : Code[20];
      AccBal@1007 : Decimal;
      JTemplate@1009 : Code[10];
      JBatch@1012 : Code[10];
      MobileTrans@1013 : Record 51516712;
      DocNo@1027 : Code[20];
      PDate@1026 : Date;
      AcctType@1025 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      BalAccType@1024 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      TransType@1023 : ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal';
      AccNo@1022 : Code[20];
      BalAccNo@1021 : Code[20];
      SourceType@1020 : 'New Member,New Account,Loan Account Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit, Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued';
      ExtDoc@1019 : Code[20];
      LoanNo@1018 : Code[20];
      Dim1@1017 : Code[10];
      Dim2@1016 : Code[10];
      SystCreated@1014 : Boolean;
      SLedger@1028 : Record 25;
      LedgerCount@1029 : Integer;
      CurrRecord@1030 : Integer;
      DFilter@1031 : Text;
      DebitCreditFlag@1032 : Code[10];
      FirstEntry@1033 : Boolean;
      ProdFact@1036 : Record 51516717;
      TransactionDate@1011 : DateTime;
      Msg@1015 : Text;
      Stmt@1037 : Text;
      AccountToCharge@1034 : Code[20];
      MemberNo@1041 : Code[20];
      RCount@1044 : Integer;
      StmtProduct@1045 : Code[20];
      StmtMemberNo@1008 : Code[20];
      AccountType@1120054000 : Record 51516295;
      MLedger@1120054001 : Record 51516224;
    BEGIN
      TransactionDate:=CURRENTDATETIME;
      MobileNo:='+'+MobileNo;

      Response:='';


      IF NOT CorrectPin(MobileNo,Pin) THEN BEGIN
          Response := 'INCORRECT_PIN';
          Response:='<Response>';
            Response+='<Status>INCORRECT_PIN</Status>';
            Response+='<StatusDescription>Incorrect PIN</StatusDescription>';
            Response+='<Reference>'+TransactionID+'</Reference>';
          Response+='</Response>';
          EXIT;
      END;



      // Get Excise duty G/L
      ExciseDutyGL := GetExciseDutyGL();
      ExciseDutyRate := GetExciseRate();
      ExciseDuty:=0;

      SaccoAccount:='';
      SaccoFee:=0;
      VendorAccount:='';
      VendorCommission:=0;

      MemberNo:='';
      AccountToCharge:='';


      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",MobileNo);

      IF SavAcc.FINDFIRST THEN BEGIN
        MemberNo := SavAcc."BOSA Account No";
        AccountToCharge := SavAcc."No.";
      END;

      IF SavAcc.Blocked<>SavAcc.Blocked::" " THEN
        EXIT;


      StmtProduct := '';

      StmtProduct := '';
      StmtMemberNo := '';

      IF SavAcc.GET(StatementAccount) THEN BEGIN
          StmtProduct := SavAcc."Account Type";
          StmtMemberNo := SavAcc."BOSA Account No";
      END
      ELSE BEGIN

          SplitAccount(StatementAccount,StmtProduct,StmtMemberNo);

          StatementAccount := MemberNo;
      END;



      SMSAccount:='';
      SMSCharge:=0;

      CoopSetup.RESET;
      CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Mini-Statement");
      IF CoopSetup.FINDFIRST THEN BEGIN

          SMSAccount := CoopSetup."SMS Account";
          SMSCharge := CoopSetup."SMS Charge";

          SaccoAccount := CoopSetup."Sacco Fee Account";
          SaccoFee := CoopSetup."Sacco Fee";
          VendorAccount:=CoopSetup."Vendor Commission Account";
          VendorCommission:=CoopSetup."Vendor Commission";

          GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,Safcom,0);
          TotalCharge:=SaccoFee+VendorCommission+SMSCharge;
          ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);
      END
      ELSE BEGIN
          ERROR('Setup Missing for %1',CoopSetup."Transaction Type");
      END;


      //PhoneNo:='+'+MobileNo;

      SavAcc.RESET;
      SavAcc.SETRANGE("No.",AccountToCharge);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FINDFIRST THEN BEGIN
          AccountType.GET(SavAcc."Account Type");



          IF (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::"Deposits Only") OR
              (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::" ") THEN BEGIN
              ERROR('The Account to Charge is not a Withdrawable Account');
          END;



          AccBal := GetAccountBalance(SavAcc."No.");
          IF AccBal >= TotalCharge+ExciseDuty THEN BEGIN

              //BUser.GET(USERID);

              //BUser.TESTFIELD("Cashier Journal Template");
              //BUser.TESTFIELD("Cashier Journal Batch");

              JTemplate:='GENERAL';
              JBatch:='SKYWORLD';

              GenJournalBatch.RESET;
              GenJournalBatch.SETRANGE("Journal Template Name",JTemplate);
              GenJournalBatch.SETRANGE(Name,JBatch);
              IF NOT GenJournalBatch.FINDFIRST THEN BEGIN
                  GenJournalBatch.INIT;
                  GenJournalBatch."Journal Template Name" := JTemplate;
                  GenJournalBatch.Name:=JBatch;
                  GenJournalBatch.Description:='Sky World Batch';
                  GenJournalBatch.INSERT;
              END;


              MobileTrans.INIT;
              MobileTrans."Entry No." := EntryCode;
              MobileTrans."Transaction ID":=TransactionID;
              MobileTrans."Session ID":=TransactionID;
              MobileTrans."Transaction Date":=DT2DATE(TransactionDate);
              MobileTrans."Transaction Time":=DT2TIME(TransactionDate);
              MobileTrans."Date Captured" := TransactionDate;
              MobileTrans."Member Account":=SavAcc."No.";
              MobileTrans."Statement Max Rows":=MaxNumberRows;
              MobileTrans."Statement Start Date":=StartDate;
              MobileTrans."Statement End Date":=EndDate;
              MobileTrans.MobileApp:=TRUE;
              MobileTrans."Account to Check":=StatementAccount;
              MobileTrans."Transaction Type":=MobileTrans."Transaction Type"::"Mini-Statement";
              MobileTrans.Description:=FORMAT(MobileTrans."Transaction Type");
              MobileTrans.Posted:=TRUE;
              MobileTrans.INSERT;
              COMMIT;


              {
              MobileTrans.RESET;
              MobileTrans.SETRANGE("Transaction ID",TransactionID);
              MobileTrans.SETRANGE(Posted,FALSE);
              IF MobileTrans.FINDFIRST THEN BEGIN

                  DocNo := MobileTrans."Transaction ID";
                  PDate := MobileTrans."Transaction Date";
                  AccNo := MobileTrans."Member Account";
                  ExtDoc := '';
                  LoanNo := '';
                  TransType := TransType::" ";
                  Dim1 := SavAcc."Global Dimension 1 Code";
                  Dim2 := SavAcc."Global Dimension 2 Code";
                  SystCreated := TRUE;


                  SaccoTrans.InitJournal(JTemplate,JBatch);


                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                '',VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccountToCharge,COPYSTR('SMS Charge',1,50),BalAccType::"G/L Account",
                                SMSAccount,SMSCharge,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR('Sacco Fee ',1,50),BalAccType::"G/L Account",
                                '',SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR('Excise Duty ',1,50),BalAccType::"G/L Account",
                                ExciseDutyGL,ExciseDuty,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  AccNo := VendorAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(MobileTrans.Description+' Commission',1,50),BalAccType::"G/L Account",
                                '',-VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  AccNo := SaccoAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",AccNo,COPYSTR(MobileTrans.Description+' Fee',1,50),BalAccType::"G/L Account",
                                '',-SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  MobileTrans.Posted:=TRUE;
                  MobileTrans."Posted By":=USERID;
                  MobileTrans."Date Posted":=TODAY;
                  MobileTrans.MODIFY;

                  SaccoTrans.PostJournal(JTemplate,JBatch);

              END
              ELSE BEGIN
                  ERROR('Transaction Not Found');
              END;
              }
          END
          ELSE BEGIN
              Response:='INSUFFICIENT_BAL';

              Response:='<Response>';
                Response+='<Status>INSUFFICIENT_BAL</Status>';
                Response+='<StatusDescription>Insufficient Balance</StatusDescription>';
                Response+='<Reference>'+TransactionID+'</Reference>';
              Response+='</Response>';
              EXIT;
          END;


          IF Response='' THEN BEGIN

              MobileTrans.RESET;
              MobileTrans.SETRANGE("Transaction ID",TransactionID);
              MobileTrans.SETRANGE(Posted,TRUE);
              IF MobileTrans.FINDFIRST THEN BEGIN
                  SLedger.RESET;
                  SLedger.SETCURRENTKEY("Entry No.");
                  SLedger.ASCENDING(TRUE);
                  SLedger.SETRANGE("Vendor No.",StatementAccount);
                  SLedger.SETRANGE("Posting Date",StartDate,EndDate);
                  SLedger.SETRANGE(Reversed,FALSE);
                  IF SLedger.FINDFIRST THEN BEGIN
                      RCount := 0;
                      AccBal:=0;
                      SavAcc.RESET;
                      SavAcc.SETRANGE("No.",StatementAccount);
                      SavAcc.SETRANGE("Date Filter",0D,CALCDATE('-1D',StartDate));
                      IF SavAcc.FINDFIRST THEN BEGIN

                          SavAcc.CALCFIELDS("Balance (LCY)");
                          AccBal := SavAcc."Balance (LCY)";

                      END;
                      MESSAGE('OpenBal %1',AccBal);
                      Response := '<Response>';
                      REPEAT
                          SLedger.CALCFIELDS(Amount);
                          RCount += 1;
                          LedgerCount+=1;
                          AccBal+=(SLedger.Amount*-1);
                          Response += '<Transaction>';
                            Response += '<Date>'+FORMAT(SLedger."Posting Date")+'</Date>';
                            Response += '<Desc>'+SLedger.Description+'</Desc>';
                            Response += '<Amount>'+FORMAT(SLedger.Amount*-1)+'</Amount>';
                            Response += '<Reference>'+FORMAT(SLedger."Entry No.")+'</Reference>';
                            Response += '<RunningBalance>'+FORMAT(AccBal)+'</RunningBalance>';
                          Response += '</Transaction>';


                      UNTIL (SLedger.NEXT=0) OR (RCount=MaxNumberRows);

                      Response += '</Response>';
                  END
                  ELSE BEGIN


                      ProdFact.RESET;
                      ProdFact.SETRANGE("Product ID",StmtProduct);
                      IF ProdFact.FIND('-') THEN BEGIN
                          IF Members.GET(StatementAccount) THEN BEGIN

                              MLedger.RESET;
                              MLedger.SETCURRENTKEY("Entry No.");
                              MLedger.ASCENDING(TRUE);
                              MLedger.SETRANGE("Customer No.",StatementAccount);
                              MLedger.SETRANGE("Posting Date",StartDate,EndDate);
                              MLedger.SETRANGE("Transaction Type",ProdFact."Product Category");
                              MLedger.SETRANGE(Reversed,FALSE);
                              IF MLedger.FINDFIRST THEN BEGIN


                                  RCount := 0;
                                  AccBal:=0;

                                  IF ProdFact."Product Category" = ProdFact."Product Category"::"Deposit Contribution" THEN BEGIN
                                      Members.SETFILTER("Date Filter",'%1..%2',0D,CALCDATE('-1D',StartDate));
                                      Members.CALCFIELDS("Current Shares");
                                      AccBal := Members."Current Shares";
                                  END;

                                  IF ProdFact."Product Category" = ProdFact."Product Category"::"Shares Capital" THEN BEGIN
                                      Members.SETFILTER("Date Filter",'%1..%2',0D,CALCDATE('-1D',StartDate));
                                      Members.CALCFIELDS("Shares Retained");
                                      AccBal := Members."Shares Retained";
                                  END;
                                  IF ProdFact."Product Category" = ProdFact."Product Category"::"SchFee Shares" THEN BEGIN
                                      Members.SETFILTER("Date Filter",'%1..%2',0D,CALCDATE('-1D',StartDate));
                                      Members.CALCFIELDS("School Fees Shares");
                                      AccBal := Members."School Fees Shares";
                                  END;



                                  Response := '<Response>';
                                  REPEAT
                                      RCount += 1;
                                      LedgerCount+=1;
                                      AccBal+=(MLedger.Amount*-1);
                                      Response += '<Transaction>';
                                        Response += '<Date>'+FORMAT(MLedger."Posting Date")+'</Date>';
                                        Response += '<Desc>'+MLedger.Description+'</Desc>';
                                        Response += '<Amount>'+FORMAT(MLedger.Amount*-1)+'</Amount>';
                                        Response += '<Reference>'+FORMAT(MLedger."Entry No.")+'</Reference>';
                                        Response += '<RunningBalance>'+FORMAT(AccBal)+'</RunningBalance>';
                                      Response += '</Transaction>';


                                  UNTIL (MLedger.NEXT=0) OR (RCount=MaxNumberRows);

                                  Response += '</Response>';
                              END;

                          END;
                      END
                  END;
              END;
          END;
      END
      ELSE BEGIN

          Response:='<Response>';
            Response+='<Status>INVALID_ACCOUNT</Status>';
            Response+='<StatusDescription>Invalid Account</StatusDescription>';
            Response+='<Reference>'+TransactionID+'</Reference>';
          Response+='</Response>';
      END;
    END;

    PROCEDURE GetLoanLimitMobileApp@20(PhoneNo@1009 : Code[20];LoanProductType@1001 : Code[20]) Response : Text;
    VAR
      SavAcc@1000 : Record 23;
      PFact@1002 : Record 51516717;
      xmlWriter@1008 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlTextWriter";
      EncodingText@1007 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
      XMLDOMMgt@1006 : Codeunit 6224;
      BodyContentXmlDoc@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      EnvelopeXmlNode@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      CreatedXmlNode@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      MaxLoan@1010 : Decimal;
      msg@1011 : Text;
      LoanType@1120054000 : Record 51516240;
      LoanLimit@1120054001 : Decimal;
      k@1120054002 : Boolean;
    BEGIN

      PhoneNo := '+'+PhoneNo;

      Response:='ERROR';
      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FINDFIRST THEN BEGIN

          MESSAGE(SavAcc.Name);
          LoanLimit := 0;
          IF (LoanType.Code ='A03') OR (LoanType.Code ='A16') THEN
          MaxLoan := GetLoanQualifiedAmount(SavAcc."No.",LoanProductType,msg,LoanLimit);//here2

          IF LoanType.Code = 'A01' THEN
            MaxLoan := GetSalaryLoanQualifiedAmount(SavAcc."No.",LoanProductType,LoanLimit,msg);

          IF LoanType.Code = 'A10' THEN
            MaxLoan := GetReloadedLoanQualifiedAmount(SavAcc."No.",LoanProductType,LoanLimit,msg);

          IF LoanType.GET(LoanProductType) THEN BEGIN


          //msg := 'Dear '+SavAcc.Name+', your Loan Limit for '+LoanType."Product Description"+' is KES '+FORMAT(MaxLoan);
          msg := 'Dear '+SavAcc.Name+', your Loan Limit for '+LoanType."Product Description"+' as at '+DateTimeToText(CURRENTDATETIME)+' is KES '+FORMAT(LoanLimit)+'. You qualify for'+' is KES '+FORMAT(MaxLoan);

          //SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,LoanProductType,SavAcc."No.",FALSE,Priority);
          END
          ELSE BEGIN


              IF LoanProductType = 'M_OD' THEN BEGIN
                  MaxLoan := 0;
                  LoanLimit :=0;
                  OverdraftLimit(SavAcc."No.",k,msg,MaxLoan,LoanLimit);

                  msg := 'Dear '+SavAcc.Name+', your Overdraft Limit as at '+DateTimeToText(CURRENTDATETIME)+' is KES '+FORMAT(LoanLimit)+'. You qualify for'+' is KES '+FORMAT(MaxLoan);

                  //SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,LoanProductType,SavAcc."No.",TRUE,Priority,FALSE);
                 // Response:='SUCCESS';

              END;
          END;
          Response:=msg;

      END;
    END;

    PROCEDURE LoanMiniStatementMobileApp@43(EntryCode@1010 : GUID;TransactionID@1102755001 : Code[20];MaxNumberRows@1042 : Integer;SDate@1044 : Date;EDate@1045 : Date;LoanAccount@1038 : Code[20];MobileNo@1039 : Code[20];Pin@1040 : Text) Response : Text;
    VAR
      SaccoFee@1005 : Decimal;
      VendorCommission@1004 : Decimal;
      TotalCharge@1003 : Decimal;
      SavAcc@1002 : Record 23;
      SaccoAccount@1001 : Code[20];
      VendorAccount@1000 : Code[20];
      PhoneNo@1006 : Code[20];
      AccBal@1007 : Decimal;
      JTemplate@1009 : Code[10];
      JBatch@1012 : Code[10];
      MobileTrans@1013 : Record 51516712;
      DocNo@1027 : Code[20];
      PDate@1026 : Date;
      AcctType@1025 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      BalAccType@1024 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      TransType@1023 : ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal';
      AccNo@1022 : Code[20];
      BalAccNo@1021 : Code[20];
      SourceType@1020 : 'New Member,New Account,Loan Account Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit, Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued';
      ExtDoc@1019 : Code[20];
      LoanNo@1018 : Code[20];
      Dim1@1017 : Code[10];
      Dim2@1016 : Code[10];
      SystCreated@1014 : Boolean;
      CLedger@1028 : Record 51516224;
      LedgerCount@1029 : Integer;
      CurrRecord@1030 : Integer;
      DFilter@1031 : Text;
      DebitCreditFlag@1032 : Code[10];
      FirstEntry@1033 : Boolean;
      ProdFact@1036 : Record 51516717;
      TransactionDate@1011 : DateTime;
      Msg@1015 : Text;
      Stmt@1037 : Text;
      StatementAccount@1035 : Code[20];
      AccountToCharge@1034 : Code[20];
      MemberNo@1041 : Code[20];
      Loans@1043 : Record 51516230;
      AccountType@1120054000 : Record 51516295;
    BEGIN

      TransactionDate:=CURRENTDATETIME;
      MobileNo:='+'+MobileNo;

      Response:='';

      IF NOT CorrectPin(MobileNo,Pin) THEN BEGIN
          Response := 'INCORRECT_PIN';
          Response:='<Response>';
            Response+='<Status>INCORRECT_PIN</Status>';
            Response+='<StatusDescription>Insufficient Balance</StatusDescription>';
            Response+='<Reference>'+TransactionID+'</Reference>';
          Response+='</Response>';
          EXIT;
      END;


      // Get Excise duty G/L
      ExciseDutyGL := GetExciseDutyGL();
      ExciseDutyRate := GetExciseRate();
      ExciseDuty:=0;

      SaccoAccount:='';
      SaccoFee:=0;
      VendorAccount:='';
      VendorCommission:=0;
      AccountToCharge:='';

      MemberNo:='';
      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
      IF SavAcc.FINDFIRST THEN BEGIN
        MemberNo := SavAcc."BOSA Account No";
        AccountToCharge := SavAcc."No.";
      END;


      IF SavAcc.Blocked<>SavAcc.Blocked::" " THEN
        EXIT;

      StatementAccount:='';

      Loans.RESET;
      Loans.SETRANGE("Loan  No.",LoanAccount);
      IF Loans.FINDFIRST THEN
        StatementAccount := Loans."Loan  No.";



      SMSAccount:='';
      SMSCharge:=0;

      CoopSetup.RESET;
      CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Mini-Statement");
      IF CoopSetup.FINDFIRST THEN BEGIN

          SMSAccount := CoopSetup."SMS Account";
          SMSCharge := CoopSetup."SMS Charge";


          SaccoAccount := CoopSetup."Sacco Fee Account";
          SaccoFee := CoopSetup."Sacco Fee";
          VendorAccount:=CoopSetup."Vendor Commission Account";
          VendorCommission:=CoopSetup."Vendor Commission";

          GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,Safcom,0);
          TotalCharge:=SaccoFee+VendorCommission+SMSCharge;
          ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);
      END
      ELSE BEGIN
          ERROR('Setup Missing for %1',CoopSetup."Transaction Type");
      END;


      //PhoneNo:='+'+MobileNo;

      SavAcc.RESET;
      SavAcc.SETRANGE("No.",AccountToCharge);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FINDFIRST THEN BEGIN
          AccountType.GET(SavAcc."Account Type");

          IF (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::"Deposits Only") OR
              (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::" ") THEN BEGIN
              ERROR('The Account to Charge is not a Withdrawable Account');
          END;



          AccBal := GetAccountBalance(SavAcc."No.");
          IF AccBal >= TotalCharge+ExciseDuty THEN BEGIN

              //BUser.GET(USERID);

              //BUser.TESTFIELD("Cashier Journal Template");
              //BUser.TESTFIELD("Cashier Journal Batch");

              JTemplate:='GENERAL';
              JBatch:='SKYWORLD';

              GenJournalBatch.RESET;
              GenJournalBatch.SETRANGE("Journal Template Name",JTemplate);
              GenJournalBatch.SETRANGE(Name,JBatch);
              IF NOT GenJournalBatch.FINDFIRST THEN BEGIN
                  GenJournalBatch.INIT;
                  GenJournalBatch."Journal Template Name" := JTemplate;
                  GenJournalBatch.Name:=JBatch;
                  GenJournalBatch.Description:='Sky World Batch';
                  GenJournalBatch.INSERT;
              END;

              MobileTrans.INIT;
              MobileTrans."Entry No." := EntryCode;
              MobileTrans."Transaction ID":=TransactionID;
              MobileTrans."Session ID":=TransactionID;
              MobileTrans."Transaction Date":=DT2DATE(TransactionDate);
              MobileTrans."Transaction Time":=DT2TIME(TransactionDate);
              MobileTrans."Date Captured" := TransactionDate;
              MobileTrans."Member Account":=SavAcc."No.";
              MobileTrans."Statement Max Rows":=MaxNumberRows;
              //MobileTrans."Statement Start Date":=StartDate;
              //MobileTrans."Statement End Date":=EndDate;
              MobileTrans."Account to Check":=StatementAccount;
              MobileTrans.MobileApp := TRUE;
              MobileTrans.Posted:=TRUE;
              MobileTrans."Transaction Type":=MobileTrans."Transaction Type"::"Mini-Statement";
              MobileTrans.Description:=FORMAT(MobileTrans."Transaction Type");
              MobileTrans.INSERT;

              {
              MobileTrans.RESET;
              MobileTrans.SETRANGE("Transaction ID",TransactionID);
              MobileTrans.SETRANGE(Posted,FALSE);
              IF MobileTrans.FINDFIRST THEN BEGIN

                  DocNo := MobileTrans."Transaction ID";
                  PDate := MobileTrans."Transaction Date";
                  AccNo := MobileTrans."Member Account";
                  ExtDoc := '';
                  LoanNo := '';
                  TransType := TransType::" ";
                  Dim1 := SavAcc."Global Dimension 1 Code";
                  Dim2 := SavAcc."Global Dimension 2 Code";
                  SystCreated := TRUE;

                  SaccoTrans.InitJournal(JTemplate,JBatch);


                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                '',VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                '',SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccountToCharge,COPYSTR('SMS Charges',1,50),BalAccType::"G/L Account",
                                SMSAccount,SMSCharge,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR('Excise Duty',1,50),BalAccType::"G/L Account",
                                ExciseDutyGL,ExciseDuty,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  AccNo := VendorAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(MobileTrans.Description+' Commission',1,50),BalAccType::"G/L Account",
                                '',-VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  AccNo := SaccoAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",AccNo,COPYSTR(MobileTrans.Description+' Fee',1,50),BalAccType::"G/L Account",
                                '',-SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  MobileTrans.Posted:=TRUE;
                  MobileTrans."Posted By":=USERID;
                  MobileTrans."Date Posted":=TODAY;
                  MobileTrans.MODIFY;

                  SaccoTrans.PostJournal(JTemplate,JBatch);

              END
              ELSE BEGIN
                  ERROR('Transaction Not Found');
              END;
              }
          END
          ELSE BEGIN
              Response:='INSUFFICIENT_BAL';

              Response:='<Response>';
                Response+='<Status>INSUFFICIENT_BAL</Status>';
                Response+='<StatusDescription>Insufficient Balance</StatusDescription>';
                Response+='<Reference>'+TransactionID+'</Reference>';
              Response+='</Response>';
              EXIT;

          END;


          IF Response='' THEN BEGIN
              MobileTrans.RESET;
              MobileTrans.SETRANGE("Transaction ID",TransactionID);
              MobileTrans.SETRANGE(Posted,TRUE);
              IF MobileTrans.FINDFIRST THEN BEGIN
                  Loans.GET(StatementAccount);

                  CLedger.RESET;
                  CLedger.SETCURRENTKEY("Entry No.");
                  CLedger.ASCENDING(FALSE);
                  CLedger.SETRANGE("Customer No.",Loans."Client Code");
                  CLedger.SETRANGE("Loan No",Loans."Loan  No.");
                  CLedger.SETRANGE(Reversed,FALSE);
                  IF CLedger.FINDFIRST THEN BEGIN
                      AccBal:=0;
                      Loans.RESET;
                      Loans.SETRANGE("Loan  No.",StatementAccount);
                      Loans.SETRANGE("Date filter",0D,CALCDATE('-1D',SDate));
                      IF Loans.FINDFIRST THEN BEGIN
                          Loans.CALCFIELDS("Outstanding Balance",Loans."Oustanding Interest","Penalty Charged");
                          AccBal := ROUND(Loans."Outstanding Balance"+Loans."Oustanding Interest"+Loans."Penalty Charged",1,'>');
                      END;

                      Response:='<Response>';

                      REPEAT

                          LedgerCount+=1;
                          //IF (CLedger."Transaction Type" = CLedger."Transaction Type"::Loan) OR (CLedger."Transaction Type" = CLedger."Transaction Type"::Repayment) THEN
                          AccBal+=(CLedger.Amount);

                          Response += '<Transaction>';
                            Response += '<Date>'+FORMAT(CLedger."Posting Date")+'</Date>';
                            Response += '<Desc>'+CLedger.Description+'</Desc>';
                            Response += '<Amount>'+FORMAT(CLedger.Amount)+'</Amount>';
                            Response += '<Reference>'+FORMAT(CLedger."Entry No.")+'</Reference>';
                            Response += '<RunningBalance>'+FORMAT(AccBal)+'</RunningBalance>';
                          Response += '</Transaction>';

                      UNTIL (CLedger.NEXT=0) OR (CLedger.COUNT=MaxNumberRows);
                      Response += '</Response>';

                      Priority:=203;
                  END;
              END;
          END;
      END
      ELSE BEGIN
          Response := 'INVALID_ACCOUNT';

          Response:='<Response>';
            Response+='<Status>INVALID_ACCOUNT</Status>';
            Response+='<StatusDescription>Insufficient Balance</StatusDescription>';
            Response+='<Reference>'+TransactionID+'</Reference>';
          Response+='</Response>';

      END;
    END;

    PROCEDURE ShowQualifiedAmount@41(AccountNo@1000 : Code[20]) : Decimal;
    BEGIN
      {
      LoanProductType:='';
      ProdFac.RESET;
      ProdFac.SETRANGE(AvailableOnMobile,TRUE);
      IF ProdFac.FINDFIRST THEN
          LoanProductType:= ProdFac."Product ID";

      IF LoanProductType = '' THEN
        EXIT;

      saccoAccount.RESET;
      saccoAccount.SETRANGE("No.",AccountNo);
      IF saccoAccount.FIND('-') THEN BEGIN

          IF LoanType.GET(LoanProductType) THEN BEGIN

              Salary1:=0;
              Salary2:=0;
              Salary3:=0;

              SalEnd := TODAY;
              SalStart := CALCDATE('-45D',SalEnd);




              SalBuffer.RESET;
              SalBuffer.SETCURRENTKEY(SalBuffer."Member No.",SalBuffer.Date);
              SalBuffer.SETRANGE(SalBuffer."Account No.",AccountNo);
              IF SalBuffer.FINDLAST THEN BEGIN
                  Date3:=SalBuffer."Posting Date";
                  Salary3:=SalBuffer.Amount;
                  IF SalBuffer.COUNT = 2 THEN BEGIN

                      SalBuffer.RESET;
                      SalBuffer.SETCURRENTKEY(SalBuffer."Member No.",SalBuffer.Date);
                      SalBuffer.SETRANGE(SalBuffer."Account No.",AccountNo);
                      IF SalBuffer.FINDFIRST THEN BEGIN
                          Date2:=SalBuffer."Posting Date";
                          Salary2:=SalBuffer.Amount;
                      END
                  END;
              END
              ELSE
                  EXIT(0);


              MESSAGE('Salary 3 - %1\Date 3 - %2',Salary3,Date3);


              SalEnd := CALCDATE('-1M+CM',Date3);
              SalStart := CALCDATE('-45D',SalEnd);

              IF Salary2=0 THEN BEGIN
                  SalBuffer.RESET;
                  SalBuffer.SETCURRENTKEY(SalBuffer."Member No.",SalBuffer.Date);
                  SalBuffer.SETRANGE(SalBuffer."Account No.",AccountNo);
                  SalBuffer.SETFILTER("Posting Date",'%1..%2',SalStart,SalEnd);
                  IF SalBuffer.FINDLAST THEN BEGIN
                      Date2:=SalBuffer."Posting Date";
                      Salary2:=SalBuffer.Amount;
                      IF SalBuffer.COUNT = 2 THEN BEGIN
                          SalBuffer.RESET;
                          SalBuffer.SETCURRENTKEY(SalBuffer."Member No.",SalBuffer.Date);
                          SalBuffer.SETRANGE(SalBuffer."Account No.",AccountNo);
                          SalBuffer.SETFILTER("Posting Date",'%1..%2',SalStart,SalEnd);
                          IF SalBuffer.FINDFIRST THEN BEGIN
                              Date1:=SalBuffer."Posting Date";
                              Salary1:=SalBuffer.Amount;
                          END
                      END;
                  END
                  ELSE
                      EXIT(0);
              END;


              MESSAGE('Salary 2 - %1\Date 2 - %2',Salary2,Date2);


              SalEnd := CALCDATE('-1M+CM',Date2);
              SalStart := CALCDATE('-45D',SalEnd);


              IF Salary1 = 0 THEN BEGIN
                  SalBuffer.RESET;
                  SalBuffer.SETCURRENTKEY(SalBuffer."Member No.",SalBuffer.Date);
                  SalBuffer.SETRANGE(SalBuffer."Account No.",AccountNo);
                  SalBuffer.SETFILTER("Posting Date",'%1..%2',SalStart,SalEnd);
                  IF SalBuffer.FINDLAST THEN BEGIN
                      Date1:=SalBuffer."Posting Date";
                      Salary1:=SalBuffer.Amount;
                  END
                  ELSE
                      EXIT(0);
              END;

              MESSAGE('Salary 1 - %1\Date 1 - %2',Salary1,Date1);

              IF Salary1 = 0 THEN
                  EXIT(0);
              IF Salary2 = 0 THEN
                  EXIT(0);
              IF Salary3 = 0 THEN
                  EXIT(0);


              IF Date3 < CALCDATE('-CM',TODAY) THEN
                  IF Date3 < CALCDATE('-1M-CM',TODAY) THEN
                      EXIT(0);



              NetSal := Salary1;
              IF NetSal > Salary2 THEN
                NetSal := Salary2;

              IF NetSal > Salary3 THEN
                NetSal := Salary3;


              MESSAGE('Net Salary %1',NetSal);

              LoanRep := 0;
              Loans.RESET;
              Loans.SETRANGE("Member No.",saccoAccount."Member No.");
              Loans.SETRANGE("Recovery Mode",Loans."Recovery Mode"::"2");
              Loans.SETRANGE("Issued Date",0D,DMY2DATE(20,DATE2DMY(TODAY,2),DATE2DMY(TODAY,3)));
              Loans.SETRANGE("Mobile Loan",FALSE);
              Loans.SETFILTER("Outstanding Balance",'>0');
              IF Loans.FINDFIRST THEN BEGIN
                  REPEAT
                      Loans.CALCFIELDS("Outstanding Balance");


                      IntAmt := 0;
                      CASE Loans."Interest Calculation Method" OF
                          Loans."Interest Calculation Method"::"3":
                          BEGIN

                              IF ProdFac.GET(Loans."Loan Product Type") THEN BEGIN
                                  IF ProdFac."Flat Rate[ 1 %]"=TRUE THEN
                                      IntAmt:=ROUND((Loans."Approved Amount"*0.5)*(Loans.Installments+1)/(Loans.Installments*100),1,'=')
                                  ELSE
                                      IntAmt:=ROUND((Loans."Approved Amount"*0.6)*(Loans.Installments+1)/(Loans.Installments*100),1,'=');
                              END;
                          END;

                          Loans."Interest Calculation Method"::"1":
                          BEGIN
                              IntAmt:=ROUND(Loans."Outstanding Balance"*(Loans.Interest/1200),1,'=');
                          END;

                          Loans."Interest Calculation Method"::"2":
                          BEGIN
                              IntAmt:=ROUND(Loans."Approved Amount"*(Loans.Interest/1200),1,'=');
                          END
                          ELSE
                          BEGIN
                              IntAmt:=ROUND(Loans."Outstanding Balance"*(Loans.Interest/1200),1,'=');
                          END;
                      END;

                      PrAmt:=Loans."Loan Principle Repayment";

                      CASE Loans."Interest Calculation Method" OF
                           Loans."Interest Calculation Method"::"3",
                           Loans."Interest Calculation Method"::"1",
                           Loans."Interest Calculation Method"::"2":
                          BEGIN
                              PrAmt:=(Loans."Approved Amount"/Loans.Installments);
                          END ELSE BEGIN
                              PrAmt:=(Loans.Repayment-IntAmt);
                          END;
                      END;


                      IF Loans."Adjusted Amount">0 THEN BEGIN
                          IF Loans."Adjusted Amount" > PrAmt THEN
                              PrAmt:=Loans."Adjusted Amount";

                      END;



                      IF PrAmt > Loans."Outstanding Balance" THEN
                          PrAmt := Loans."Outstanding Balance";


                      LoanRep+=PrAmt+IntAmt;

                  UNTIL Loans.NEXT=0;
              END;



              Loans.RESET;
              Loans.SETRANGE("Member No.",saccoAccount."Member No.");
              Loans.SETRANGE("Recovery Mode",Loans."Recovery Mode"::"2");
              Loans.SETRANGE("Mobile Loan",TRUE);
              Loans.SETFILTER("Outstanding Balance",'>0');
              IF Loans.FINDFIRST THEN BEGIN
                  REPEAT
                      Loans.CALCFIELDS("Outstanding Balance");
                      LoanRep+=Loans."Outstanding Balance";
                  UNTIL Loans.NEXT=0;
              END;


              STODed:=0;
              StandingOrders.RESET;
              StandingOrders.SETRANGE(StandingOrders."Source Account No.",saccoAccount."No.");
              StandingOrders.SETRANGE(StandingOrders.Status , StandingOrders.Status::"2");
              StandingOrders.SETFILTER("End Date" ,'>%1',TODAY);
              IF StandingOrders.FIND('-') THEN BEGIN
                  REPEAT
                      STODed := STODed + StandingOrders.Amount;
                  UNTIL StandingOrders.NEXT = 0;
              END;

              MESSAGE('Net Sal: %1\Loan Rep: %2 \STO Ded: %3',NetSal,LoanRep,STODed);

              NetSal := NetSal-LoanRep-STODed;

              MESSAGE('New Net after Deductions: %1',NetSal);

              IF NetSal < 0 THEN
                NetSal:=0;

              NetSal := ROUND(LoanType."Net Salary Multiplier %"/100*NetSal);


              MESSAGE('90% NetSal %1 ',NetSal);

              DepAcc.RESET;
              DepAcc.SETRANGE("Member No.",saccoAccount."Member No.");
              DepAcc.SETRANGE("Product Category",DepAcc."Product Category"::"2");
              IF DepAcc.FINDFIRST THEN BEGIN
                  DepAcc.CALCFIELDS("Balance (LCY)");
                  IF NetSal > DepAcc."Balance (LCY)" THEN
                      NetSal := DepAcc."Balance (LCY)";

                  IF NetSal < 0 THEN
                    NetSal := 0;
              END
              ELSE BEGIN
                  NetSal := 0;
              END;


              MESSAGE('NetSal: %1 \Member Deposits: %2 ',NetSal,DepAcc."Balance (LCY)");


      {
              ExpInt := ROUND(ProdFac."Interest Rate (Max.)"/1200 * NetSal);

              NetSal -= ExpInt;
      }


              MaxLoanAmount := LoanType."Maximum Loan Amount";

              IF NetSal > MaxLoanAmount THEN
                  NetSal := MaxLoanAmount;



              Loans.RESET;
              Loans.SETRANGE("Member No.",saccoAccount."Member No.");
              Loans.SETRANGE("Recovery Mode",Loans."Recovery Mode"::"2");
              Loans.SETRANGE("Mobile Loan",TRUE);
              Loans.SETFILTER("Outstanding Balance",'>0');
              IF Loans.FINDFIRST THEN BEGIN
                  LoanRep:=0;
                  REPEAT
                      Loans.CALCFIELDS("Outstanding Balance");
                      LoanRep+=Loans."Outstanding Balance";
                  UNTIL Loans.NEXT=0;
                  IF LoanRep+NetSal > MaxLoanAmount THEN
                      NetSal := 0;
              END;


              MESSAGE('NetSal %1 \Max Loan Amount as per Setup: %2 ',NetSal,MaxLoanAmount);


              EXIT(ROUND(NetSal,1,'<'));
          END;
      END;

      EXIT(0);
      }
    END;

    PROCEDURE PostSMSAlertCharges@6();
    VAR
      Blocked@1000 : ' ,All,Credit,Debit';
      SMSALERTS@1001 : Record 51516711;
      saccoAccount@1002 : Record 23;
      Bal@1003 : Decimal;
      Docno@1004 : Code[20];
      TotalCharges@1006 : Decimal;
      SMSAlertsAccount@1007 : Code[20];
      JTemplate@1009 : Code[10];
      JBatch@1008 : Code[10];
      AcctType@1014 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      BalAccType@1013 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      TransType@1012 : ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal';
      AccNo@1011 : Code[20];
      BalAccNo@1010 : Code[20];
      ExtDoc@1015 : Code[20];
      SystCreated@1016 : Boolean;
      RCount@1017 : Integer;
      GenSetup@1018 : Record 51516700;
      SaccoIncomeAcc@1019 : Code[20];
      Charges@1005 : Record 51516297;
      Duty@1120054000 : Decimal;
      Members@1120054001 : Record 51516223;
    BEGIN

          TotalCharges := 0;
          Duty := 0;

      SMSALERTS.RESET;
      SMSALERTS.SETRANGE(Posted,TRUE);
      SMSALERTS.SETRANGE(Finalized,FALSE);
      SMSALERTS.SETFILTER("Account To Charge",'<>%1','');
      SMSALERTS.SETFILTER(msg_status_code,'102');
      IF SMSALERTS.FIND('-') THEN BEGIN
          SMSALERTS.MODIFYALL(Finalized,TRUE);
      END;


      // Get SMS G/L and Charge Amount
      Charges.RESET;
      Charges.SETRANGE(Charges.Code,'SMS');
      IF Charges.FIND('-') THEN BEGIN
          Charges.TESTFIELD(Charges."GL Account");
          TotalCharges:=Charges."Charge Amount";
      END;

      SMSALERTS.RESET;
      SMSALERTS.SETCURRENTKEY(date_created);
      SMSALERTS.SETRANGE(Finalized,FALSE);
      SMSALERTS.SETFILTER(msg_status_code,'102');
      SMSALERTS.SETRANGE(SMSALERTS."Insufficient Balance",FALSE);
      SMSALERTS.SETRANGE(SMSALERTS."Charge Member",TRUE);
      //SMSALERTS.SETFILTER(SMSALERTS.receiver,'254720135216|254715480810|254711272238|254711305595|254710733567|254710316942|254721951520|254718907110|254720233402|254722523647|254723371081|254722670611|254725166728|254721642818|254728744331');
      //SMSALERTS.SETFILTER(SMSALERTS.receiver,'254715480810');

      IF SMSALERTS.FIND('+') THEN BEGIN
          RCount := 0;
          GenSetup.GET;
          //REPEAT
          RCount+=1;


          Docno :=FORMAT(SMSALERTS.msg_id);
          SaccoIncomeAcc := '';

          // Get SMS G/L and Charge Amount
          Charges.RESET;
          Charges.SETRANGE(Charges.Code,'SMS');
          IF Charges.FIND('-') THEN BEGIN
              Charges.TESTFIELD(Charges."GL Account");
              TotalCharges:=Charges."Charge Amount";
              SMSAlertsAccount := Charges."GL Account";
              Duty := ROUND(TotalCharges*GetExciseRate/100);

          END;

          //GenSetup.TESTFIELD("Sacco SMS Expense GL");
          GenSetup.TESTFIELD("Sacco SMS Income GL");
          SaccoIncomeAcc := GenSetup."Sacco SMS Income GL";

          IF SMSALERTS."Charge Member" THEN BEGIN




              saccoAccount.RESET;
              saccoAccount.SETRANGE(saccoAccount."No.",SMSALERTS."Account To Charge");
              IF saccoAccount.FIND('-') THEN BEGIN

                  Bal := GetAccountBalance(saccoAccount."No.");

                  IF Bal >= TotalCharges+Duty THEN BEGIN

                      Blocked:=Blocked::" ";
                      IF saccoAccount.Blocked<>saccoAccount.Blocked::" " THEN BEGIN
                          Blocked:=saccoAccount.Blocked;
                          saccoAccount.Blocked:=saccoAccount.Blocked::" ";
                          saccoAccount.MODIFY;
                      END;


                      JTemplate:='GENERAL';
                      JBatch:='SKYWORLD';
                      ExtDoc := '';

                      GenJournalBatch.RESET;
                      GenJournalBatch.SETRANGE("Journal Template Name",JTemplate);
                      GenJournalBatch.SETRANGE(Name,JBatch);
                      IF NOT GenJournalBatch.FINDFIRST THEN BEGIN
                          GenJournalBatch.INIT;
                          GenJournalBatch."Journal Template Name" := JTemplate;
                          GenJournalBatch.Name:=JBatch;
                          GenJournalBatch.Description:='Sky World Batch';
                          GenJournalBatch.INSERT;
                      END;

                      SaccoTrans.InitJournal(JTemplate,JBatch);
                      SystCreated:=TRUE;



                      SaccoTrans.JournalInsert(JTemplate,JBatch,Docno,TODAY,AcctType::Vendor,saccoAccount."No.",COPYSTR('SMS Alert: '+FORMAT(SMSALERTS."SMS Date"),1,50),BalAccType::"G/L Account",
                            SMSAlertsAccount,TotalCharges,ExtDoc,'',TransType,saccoAccount."Global Dimension 1 Code",saccoAccount."Global Dimension 2 Code",SystCreated,saccoAccount.Name);

                      SaccoTrans.JournalInsert(JTemplate,JBatch,Docno,TODAY,AcctType::Vendor,saccoAccount."No.",COPYSTR('Excise Duty on SMS Alert',1,50),BalAccType::"G/L Account",
                            GetExciseDutyGL,Duty,ExtDoc,'',TransType,saccoAccount."Global Dimension 1 Code",saccoAccount."Global Dimension 2 Code",SystCreated,saccoAccount.Name);


                      SMSALERTS.Posted:=TRUE;
                      SMSALERTS.Finalized := TRUE;
                      SMSALERTS.MODIFY;

                      SaccoTrans.PostJournal(JTemplate,JBatch);



                  //ERROR('%1\%2',Bal,(TotalCharges+Duty));
                      IF Blocked<>saccoAccount.Blocked THEN BEGIN
                          saccoAccount.Blocked:=Blocked;
                          saccoAccount.MODIFY;
                      END;
                  END
                  ELSE BEGIN

                      SMSALERTS."Insufficient Balance":=TRUE;
                      SMSALERTS.MODIFY;
                  END;
              END
              ELSE BEGIN
                  IF SMSALERTS."Account To Charge" = '' THEN BEGIN
                      SMSALERTS.Finalized := TRUE;
                      SMSALERTS.MODIFY;
                  END
                  ELSE BEGIN
                      IF Members.GET(SMSALERTS."Account To Charge") THEN BEGIN
                          IF saccoAccount.GET(Members."FOSA Account") THEN BEGIN
                              SMSALERTS."Account To Charge" := saccoAccount."No.";
                              SMSALERTS.MODIFY;
                          END
                          ELSE BEGIN
                              SMSALERTS.Finalized := TRUE;
                              SMSALERTS.MODIFY;
                          END;
                      END
                      ELSE BEGIN
                          SMSALERTS.Finalized := TRUE;
                          SMSALERTS.MODIFY;
                      END;
                  END;
              END;
          END;
      END;
    END;

    PROCEDURE CallServiceFunction@48(i@1000 : Integer);
    VAR
      SkyTransactions@1001 : Record 51516712;
      MobileLoan@1002 : Record 51516713;
      RandNo@1003 : Integer;
      Loans@1004 : Record 51516230;
      SavAcc@1005 : Record 23;
      j@1120054000 : Integer;
      PostATM@1120054001 : CodeUnit 20372;
      GeneralLedgerSetup@1120054002 : Record 98;
      LoansRegister@1120054003 : Record 51516230;
      msg@1120054004 : Text;
      MobileNo@1120054005 : Text;
      CoopATMTransaction@1120054006 : Record 170041;
      CoopProcessing@1120054007 : CodeUnit 20367;
    BEGIN
      // PostCoopATM();
      //
      // PostATM.PostTrans;
      //
      // MobileLoan.RESET;
      // MobileLoan.SETRANGE(Status,MobileLoan.Status::"Pending Guarantors");
      // MobileLoan.SETRANGE(Posted,FALSE);
      // MobileLoan.SETRANGE(Deactivated,FALSE);
      // IF MobileLoan.FIND('-') THEN BEGIN
      //     REPEAT
      //       ProcessMobileLoan(MobileLoan."Entry No");
      //     UNTIL  MobileLoan.NEXT = 0;
      // END;

      RandNo:=RANDOM(9);
      CASE i OF
          1:
          BEGIN
              SkyTransactions.RESET;
              IF RandNo MOD 2 = 0 THEN
                SkyTransactions.ASCENDING(FALSE)
              ELSE
                SkyTransactions.ASCENDING(FALSE);
              SkyTransactions.SETRANGE(Posted,FALSE);
              SkyTransactions.SETRANGE("Needs Change",TRUE);
              IF SkyTransactions.FIND('-') THEN BEGIN
                  REPEAT

                      IF SkyTransactions."Transaction Type" = SkyTransactions."Transaction Type"::Paybill THEN BEGIN

                          IF Loans.GET(SkyTransactions."Member Account") THEN BEGIN
                              SavAcc.RESET;
                              SavAcc.SETRANGE("No.",Loans."Account No");
                              SavAcc.SETRANGE("Account Type",'ORDINARY');
                              IF SavAcc.FINDFIRST THEN BEGIN
                                  SkyTransactions.Description := 'Loan Repayment '+SkyTransactions."Member Account";
                                  SkyTransactions."Member Account":=SavAcc."No.";
                                  SkyTransactions."Loan No." := Loans."Loan  No.";
                                  SkyTransactions."Transaction Type" := SkyTransactions."Transaction Type"::"Loan Repayment";
                                  SkyTransactions."Needs Change" := FALSE;
                                  SkyTransactions.MODIFY;
      //                         END ELSE BEGIN
      //                           SkyTransactions."Needs Change":=TRUE;
      //                           SkyTransactions.MODIFY;
                              END;
                          END;
                      END;


                  UNTIL SkyTransactions.NEXT=0;
              END;


              SkyTransactions.RESET;
              IF RandNo MOD 2 = 0 THEN
                SkyTransactions.ASCENDING(FALSE)
              ELSE
                SkyTransactions.ASCENDING(FALSE);
              SkyTransactions.SETRANGE(Posted,FALSE);
              SkyTransactions.SETRANGE("Needs Change",FALSE);
              IF SkyTransactions.FIND('-') THEN BEGIN
                  REPEAT
                      PostMpesaTransaction(SkyTransactions."Transaction ID");
                  UNTIL SkyTransactions.NEXT=0;
              END;
          END;
          2:
          BEGIN

              MobileLoan.RESET;
              IF RandNo MOD 2 = 0 THEN
                MobileLoan.ASCENDING(FALSE)
              ELSE
               MobileLoan.ASCENDING(FALSE);
              MobileLoan.SETRANGE(Status,MobileLoan.Status::Pending);
              MobileLoan.SETRANGE(Posted,FALSE);
              MobileLoan.SETRANGE(Deactivated,FALSE);
              IF MobileLoan.FIND('-') THEN BEGIN
                  REPEAT
                      ProcessMobileLoan(MobileLoan."Entry No");
                  UNTIL MobileLoan.NEXT = 0;
              END;
              ProcessOverdraft;

          END;
          3:
          BEGIN
            GeneralLedgerSetup.GET;
            IF GeneralLedgerSetup."Last M-Loan Recovery Date" < TODAY THEN BEGIN
              LoansRegister.RESET;
              IF LoansRegister.FINDFIRST THEN
                REPORT.RUN(51516034,FALSE,FALSE,LoansRegister);
              GeneralLedgerSetup."Last M-Loan Recovery Date" := TODAY;
              GeneralLedgerSetup.MODIFY;
            END;

            FOR j := 1 TO 200 DO BEGIN
                PostSMSAlertCharges;
                COMMIT;
                PostCoopATM();
                COMMIT;
                PostATM.PostTrans;
                COMMIT;
            END;
          END;
          4:
          BEGIN
            UpdatePenaltyCounter;
            UpdateDefaulterMembers;
            LoanReminders('',TRUE);
            COMMIT;
            RedirectSMS;
            COMMIT;
            LoanPenalty('');
            CheckDefaultedMobileLoan('');
            InsertMemberPenaltyCounter();
            UpdateOD;
          END;
      END;
    END;

    PROCEDURE PortalPinReset@49(MobileNo@1000 : Code[30]) Response : Text;
    VAR
      SkyAuth@1003 : Record 51516709;
      SavAcc@1000000000 : Record 23;
    BEGIN
      MobileNo := '+'+ MobileNo;

      Response := 'ERROR';

      SkyAuth.RESET;
      SkyAuth.SETRANGE(SkyAuth."Mobile No.",MobileNo);
      IF SkyAuth.FINDFIRST THEN BEGIN

          SavAcc.RESET;
          SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
          SavAcc.SETRANGE(Blocked,SavAcc.Blocked::" ");
          IF NOT SavAcc.FINDFIRST THEN BEGIN
              Response := 'BLOCKED';
              EXIT;
          END;

          SavAcc.RESET;
          SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
          SavAcc.SETRANGE(Status,SavAcc.Status::Deceased);
          IF SavAcc.FINDFIRST THEN BEGIN
              Response := 'DECEASED';
              EXIT;
          END;

          IF (SkyAuth."User Status" = SkyAuth."User Status"::Inactive) OR (SkyAuth."User Status" = SkyAuth."User Status"::" ") THEN
              Response := 'BLOCKED'
          ELSE BEGIN

              SkyAuth."Reset PIN" := TRUE;
              SkyAuth.MODIFY;
              COMMIT;
              PinReset;
              Response := 'SUCCESS'
          END;


      END
      ELSE BEGIN
          Response := 'NOT_FOUND';
      END;
    END;

    PROCEDURE DeactivateMobileApp@52(MobileNo@1000 : Code[30]) Response : Text;
    VAR
      SkyAuth@1003 : Record 51516709;
      SavAcc@1000000000 : Record 18;
    BEGIN
      MobileNo := '+'+ MobileNo;

      Response := 'ERROR';

      SkyAuth.RESET;
      SkyAuth.SETRANGE(SkyAuth."Mobile No.",MobileNo);
      IF SkyAuth.FINDFIRST THEN BEGIN

          SkyAuth.IMEI := '';
          SkyAuth."Mobile App Activated":=FALSE;
          SkyAuth.MODIFY;
          Response := 'SUCCESS';

      END
      ELSE BEGIN
          Response := 'NOT_FOUND';
      END;
    END;

    PROCEDURE CheckBlackList@53(PhoneNo@1003 : Code[20];AcctNo@1004 : Code[20];Name@1005 : Text) : Boolean;
    VAR
      BPhoneNos@1000 : Record 51516705;
      BAccountNos@1001 : Record 51516706;
      BNames@1002 : Record 51516707;
    BEGIN

      IF PhoneNo<>'' THEN BEGIN
          IF BPhoneNos.GET(PhoneNo) THEN
              IF BPhoneNos."Black-Listed" THEN
                  EXIT(TRUE);
      END;


      IF AcctNo<>'' THEN BEGIN
          IF BAccountNos.GET(AcctNo) THEN
              IF BAccountNos."Black-Listed" THEN
                  EXIT(TRUE);

      END;

      IF Name<>'' THEN BEGIN
          IF BNames.GET(Name) THEN
              IF BNames."Black-Listed" THEN
                  EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    PROCEDURE CheckLinkHealth@61() Response : Text;
    BEGIN
      Response := 'OK';
    END;

    PROCEDURE MobileAppLogin@57(TransactionID@1102755001 : Code[20];MobileNo@1039 : Code[20]) Response : Text;
    VAR
      SaccoFee@1005 : Decimal;
      VendorCommission@1004 : Decimal;
      TotalCharge@1003 : Decimal;
      SavAcc@1002 : Record 23;
      SaccoAccount@1001 : Code[20];
      VendorAccount@1000 : Code[20];
      PhoneNo@1006 : Code[20];
      AccBal@1007 : Decimal;
      JTemplate@1009 : Code[10];
      JBatch@1012 : Code[10];
      MobileTrans@1013 : Record 51516712;
      DocNo@1027 : Code[20];
      PDate@1026 : Date;
      AcctType@1025 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      BalAccType@1024 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      TransType@1023 : ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal';
      AccNo@1022 : Code[20];
      BalAccNo@1021 : Code[20];
      SourceType@1020 : 'New Member,New Account,Loan Account Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit, Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued';
      ExtDoc@1019 : Code[20];
      LoanNo@1018 : Code[20];
      Dim1@1017 : Code[10];
      Dim2@1016 : Code[10];
      SystCreated@1014 : Boolean;
      LedgerCount@1029 : Integer;
      CurrRecord@1030 : Integer;
      DFilter@1031 : Text;
      DebitCreditFlag@1032 : Code[10];
      FirstEntry@1033 : Boolean;
      ProdFact@1036 : Record 51516717;
      TransactionDate@1011 : DateTime;
      Msg@1015 : Text;
      Stmt@1037 : Text;
      AccountToCharge@1034 : Code[20];
      MemberNo@1041 : Code[20];
      EntryCode@1010 : GUID;
      AccountType@1120054000 : Record 51516295;
    BEGIN

      EntryCode := CREATEGUID;
      TransactionDate:=CURRENTDATETIME;

      Response:='ERROR';








      // Get Excise duty G/L
      ExciseDutyGL := GetExciseDutyGL();
      ExciseDutyRate := GetExciseRate();
      ExciseDuty:=0;

      SaccoAccount:='';
      SaccoFee:=0;
      VendorAccount:='';
      VendorCommission:=0;

      MemberNo:='';

      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
      IF SavAcc.FINDFIRST THEN BEGIN
        MemberNo := SavAcc."BOSA Account No";

        AccountToCharge := SavAcc."No.";
      END;



      MobileTrans.RESET;
      MobileTrans.SETRANGE("Transaction Date",DT2DATE(TransactionDate));
      MobileTrans.SETRANGE("Member Account",AccountToCharge);
      MobileTrans.SETRANGE("Transaction Type",MobileTrans."Transaction Type"::"Mobile App Login");
      IF MobileTrans.FINDFIRST THEN BEGIN
          Response := 'ACTIVE';
          EXIT;
      END;






      //MESSAGE(MemberNo);
      IF SavAcc.Blocked<>SavAcc.Blocked::" " THEN
        EXIT;



      //MESSAGE(AccountToCharge);
      SMSAccount:='';
      SMSCharge:=0;

      CoopSetup.RESET;
      CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Mobile App Login");
      IF CoopSetup.FINDFIRST THEN BEGIN

          SMSAccount := CoopSetup."SMS Account";
          SMSCharge := CoopSetup."SMS Charge";


          SaccoAccount := CoopSetup."Sacco Fee Account";
          SaccoFee := CoopSetup."Sacco Fee";
          VendorAccount:=CoopSetup."Vendor Commission Account";
          VendorCommission:=CoopSetup."Vendor Commission";

          GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,Safcom,0);
          TotalCharge:=SaccoFee+VendorCommission+SMSCharge;
          ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);
      END
      ELSE BEGIN
          ERROR('Setup Missing for %1',CoopSetup."Transaction Type");
      END;


      //PhoneNo:='+'+MobileNo;

      SavAcc.RESET;
      SavAcc.SETRANGE("No.",AccountToCharge);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FINDFIRST THEN BEGIN
          AccountType.GET(SavAcc."Account Type");


          IF (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::"Deposits Only") OR
              (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::" ") THEN BEGIN
              ERROR('The Account to Charge is not a Withdrawable Account');
          END;



          AccBal := GetAccountBalance(SavAcc."No.");
          IF AccBal >= TotalCharge+ExciseDuty THEN BEGIN

              //BUser.GET(USERID);

              //BUser.TESTFIELD("Cashier Journal Template");
              //BUser.TESTFIELD("Cashier Journal Batch");

              JTemplate:='GENERAL';
              JBatch:='SKYWORLD';

              GenJournalBatch.RESET;
              GenJournalBatch.SETRANGE("Journal Template Name",JTemplate);
              GenJournalBatch.SETRANGE(Name,JBatch);
              IF NOT GenJournalBatch.FINDFIRST THEN BEGIN
                  GenJournalBatch.INIT;
                  GenJournalBatch."Journal Template Name" := JTemplate;
                  GenJournalBatch.Name:=JBatch;
                  GenJournalBatch.Description:='Sky World Batch';
                  GenJournalBatch.INSERT;
              END;


              MobileTrans.INIT;
              MobileTrans."Entry No." := EntryCode;
              MobileTrans."Transaction ID":='L_'+TransactionID;
              MobileTrans."Session ID":=TransactionID;
              MobileTrans."Transaction Date":=DT2DATE(TransactionDate);
              MobileTrans."Transaction Time":=DT2TIME(TransactionDate);
              MobileTrans."Date Captured" := TransactionDate;
              MobileTrans."Member Account":=SavAcc."No.";
              MobileTrans."Vendor Commission":=VendorCommission;
              //MobileTrans."Statement Start Date":=StartDate;
              //MobileTrans."Statement End Date":=EndDate;
              //MobileTrans."Account to Check":=StatementAccount;
              MobileTrans."Transaction Type":=MobileTrans."Transaction Type"::"Mobile App Login";
              MobileTrans.Description:=FORMAT(MobileTrans."Transaction Type");
              MobileTrans.INSERT;
              Response := 'ACTIVE';
              {
              MobileTrans.RESET;
              MobileTrans.SETRANGE("Transaction ID",TransactionID);
              MobileTrans.SETRANGE(Posted,FALSE);
              IF MobileTrans.FINDFIRST THEN BEGIN

                  DocNo := MobileTrans."Transaction ID";
                  PDate := MobileTrans."Transaction Date";
                  AccNo := MobileTrans."Member Account";
                  ExtDoc := '';
                  LoanNo := '';
                  TransType := TransType::" ";
                  Dim1 := SavAcc."Global Dimension 1 Code";
                  Dim2 := SavAcc."Global Dimension 2 Code";
                  SystCreated := TRUE;

                  SaccoTrans.InitJournal(JTemplate,JBatch);


                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR(MobileTrans.Description,1,50),BalAccType::"G/L Account",
                                '',VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccountToCharge,COPYSTR('SMS Charge',1,50),BalAccType::"G/L Account",
                                SMSAccount,SMSCharge,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR('Sacco Fee ',1,50),BalAccType::"G/L Account",
                                '',SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Customer,AccNo,COPYSTR('Excise Duty ',1,50),BalAccType::"G/L Account",
                                ExciseDutyGL,ExciseDuty,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  AccNo := VendorAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AccNo,COPYSTR(MobileTrans.Description+' Commission',1,50),BalAccType::"G/L Account",
                                '',-VendorCommission,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");

                  AccNo := SaccoAccount;
                  ExtDoc := MobileTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",AccNo,COPYSTR(MobileTrans.Description+' Fee',1,50),BalAccType::"G/L Account",
                                '',-SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,MobileTrans."Client Name");


                  MobileTrans.Posted:=TRUE;
                  MobileTrans."Posted By":=USERID;
                  MobileTrans."Date Posted":=TODAY;
                  MobileTrans.MODIFY;

                  SaccoTrans.PostJournal(JTemplate,JBatch);

              END
              ELSE BEGIN
                  ERROR('Transaction Not Found');
              END;
              }

          END
          ELSE BEGIN
              Response:='INSUFFICIENT_BAL';
          END;

      END
      ELSE BEGIN
          Response := 'INVALID_ACCOUNT';
      END;
    END;

    PROCEDURE GetAmountTransacted@56(Transaction@1019 : Text;AccountNo@1021 : Code[20];Date@1012 : Date;Type@1015 : 'Daily,Weekly,Monthly') Amt : Decimal;
    VAR
      SaccoFee@1000 : Decimal;
      VendorCommission@1001 : Decimal;
      TransactionType@1002 : ' ,Mpesa Withdrawal,Mpesa Deposit,Utility Payment,Loan Repayment,Balance Enquiry,Mini-Statement,Loan Disbursement,Account Transfer,Pay Loan From Account,Paybill,Mobile App Login,Bank Transfer';
      TotalCharge@1003 : Decimal;
      SavAcc@1004 : Record 23;
      MpesaTrans@1005 : Record 51516712;
      Continue@1008 : Boolean;
      MobileWithdrawalsBuffer@1009 : Record 51516714;
      AccBal@1010 : Decimal;
      SafcomAcc@1014 : Code[20];
      SafcomFee@1016 : Decimal;
      TransactionDate@1011 : DateTime;
      MemberID@1006 : Code[20];
      PrePaymentGL@1018 : Code[20];
      LoanNo@1007 : Code[20];
      MemberNo@1023 : Code[20];
    BEGIN
      Amt := 0;

      IF (Transaction = 'Withdrawal Request') OR (Transaction = 'Utility Request') OR (Transaction = 'Bank Transfer Request')  THEN BEGIN
          MobileWithdrawalsBuffer.RESET;
          MobileWithdrawalsBuffer.SETRANGE("Withdrawal Type",Transaction);
          MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer.Reversed,FALSE);
          MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer."Account No",AccountNo);
          MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer.Source,MobileWithdrawalsBuffer.Source::"M-PESA");
          IF Type = Type::Daily THEN
          MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer."Transaction Date",Date);
          IF Type = Type::Weekly THEN
          MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer."Transaction Date",CALCDATE('-CW',Date),CALCDATE('CW',Date));
          IF Type = Type::Monthly THEN
          MobileWithdrawalsBuffer.SETRANGE(MobileWithdrawalsBuffer."Transaction Date",CALCDATE('-CM',Date),CALCDATE('CM',Date));
          IF MobileWithdrawalsBuffer.FIND('-') THEN BEGIN
              MobileWithdrawalsBuffer.CALCSUMS(Amount);
              Amt := MobileWithdrawalsBuffer.Amount;
          END;
      END;
    END;

    PROCEDURE GetMaximumMobileLoanLimit@62() : Decimal;
    VAR
      GenSetup@1000 : Record 51516700;
    BEGIN

      GenSetup.GET;
      EXIT(GenSetup."Maximum Mobile Loan Limit");
    END;

    PROCEDURE GetDividendLoanQualifiedAmount@64(AccountNo@1000 : Code[20];LoanProductType@1004 : Code[20]) : Decimal;
    VAR
      DefaultedAmount@1002 : Integer;
      saccoAccount@1001 : Record 23;
      ProdFac@1003 : Record 51516717;
      salStartString@1005 : Text;
      SalStart@1006 : Date;
      SalEnd@1007 : Date;
      DividendProgression@1008 : Record 51516252;
      Salary1@1009 : Decimal;
      Salary2@1010 : Decimal;
      Date1@1011 : Date;
      Date2@1012 : Date;
      NetSal@1013 : Decimal;
      Loans@1014 : Record 51516230;
      LoanRep@1015 : Decimal;
      IntAmt@1016 : Decimal;
      PrAmt@1017 : Decimal;
      STODed@1018 : Decimal;
      MaxLoanAmount@1020 : Decimal;
      ExpInt@1021 : Decimal;
      LoanType@1022 : Record 51516240;
      Salary3@1024 : Decimal;
      Date3@1025 : Date;
      Cust@1026 : Record 51516223;
    BEGIN

      saccoAccount.RESET;
      saccoAccount.SETRANGE("No.",AccountNo);
      IF saccoAccount.FIND('-') THEN BEGIN

          IF LoanType.GET(LoanProductType) THEN BEGIN


      //         InsiderLendings2.RESET;
      //         InsiderLendings2.SETRANGE(InsiderLendings2."Product Code",LoanType.Code);
      //         IF NOT InsiderLendings2.FINDFIRST THEN

              IF (LoanType."Restrict to Insider Classif." <> LoanType."Restrict to Insider Classif."::"  ") AND (LoanType."Restrict to Insider Classif." <> Cust."Insider Classification") THEN
                EXIT(0);

              DividendProgression.RESET;
              DividendProgression.SETRANGE("Member No",saccoAccount."No.");
              DividendProgression.SETRANGE(Date,CALCDATE('-1Y+CY',TODAY));
              IF DividendProgression.FINDFIRST THEN BEGIN
                  DividendProgression.CALCSUMS("Net Dividends");
      //            MaxLoanAmount := ROUND(DividendProgression."Net Dividends"*LoanType."Net Salary Multiplier %"/100);
              END
              ELSE
                  MaxLoanAmount := 0;


              LoanRep := 0;


              Loans.RESET;
              Loans.SETRANGE("Client Code",saccoAccount."BOSA Account No");
              Loans.SETRANGE("Recovery Mode",Loans."Recovery Mode"::Salary);
              Loans.SETFILTER("Outstanding Balance",'>0');
              IF Loans.FINDFIRST THEN BEGIN
                  REPEAT
                      Loans.CALCFIELDS("Outstanding Balance");
                      LoanRep+=Loans."Outstanding Balance";
                  UNTIL Loans.NEXT=0;
              END
              ELSE BEGIN

                  Loans.RESET;
                  Loans.SETRANGE("Client Code",saccoAccount."BOSA Account No");
                  Loans.SETRANGE("Loan Product Type",LoanType.Code);
                  Loans.SETFILTER("Outstanding Balance",'>0');
                  IF Loans.FINDFIRST THEN BEGIN
                      REPEAT
                          Loans.CALCFIELDS("Outstanding Balance");
                          LoanRep+=Loans."Outstanding Balance";
                      UNTIL Loans.NEXT=0;
                  END
              END;


              MaxLoanAmount := MaxLoanAmount-LoanRep;
              //MESSAGE('MaxLoanAmount %1',MaxLoanAmount);

              IF MaxLoanAmount < 0 THEN
                MaxLoanAmount:=0;


              //MESSAGE('NetSal %1 DepAcc."Balance (LCY)" %2 ',NetSal,DepAcc."Balance (LCY)")

              IF MaxLoanAmount > LoanType."Max. Loan Amount" THEN
                  MaxLoanAmount := LoanType."Max. Loan Amount";


              //MESSAGE('NetSal %1 MaxLoanAmount %2 ',NetSal,MaxLoanAmount);


              EXIT(ROUND(MaxLoanAmount,1,'<'));
          END;
      END;

      EXIT(0);
    END;

    PROCEDURE CheckDividendLoanMobileStatus@65() Response : Text;
    VAR
      DefaultedAmount@1002 : Integer;
      saccoAccount@1001 : Record 23;
      ProdFac@1003 : Record 51516717;
      salStartString@1005 : Text;
      SalStart@1006 : Date;
      SalEnd@1007 : Date;
      Salary1@1009 : Decimal;
      Salary2@1010 : Decimal;
      Date1@1011 : Date;
      Date2@1012 : Date;
      NetSal@1013 : Decimal;
      Loans@1014 : Record 51516230;
      LoanRep@1015 : Decimal;
      IntAmt@1016 : Decimal;
      PrAmt@1017 : Decimal;
      STODed@1018 : Decimal;
      MaxLoanAmount@1020 : Decimal;
      ExpInt@1021 : Decimal;
      LoanType@1022 : Record 51516240;
    BEGIN
      LoanType.RESET;
      LoanType.SETFILTER(Code,'416');
      IF LoanType.FIND('-') THEN BEGIN
          IF(LoanType.AvailableOnMobile = TRUE) THEN BEGIN
            Response := 'TRUE';
          END
          ELSE BEGIN
            Response := 'FALSE';
          END
      END
      ELSE BEGIN
          Response := 'FALSE';
      END;
    END;

    PROCEDURE GetNonSalariedLoanQualifiedAmount@67(AccountNo@1000 : Code[20];LoanProductType@1004 : Code[20]) : Decimal;
    BEGIN

             {
      saccoAccount.RESET;
      saccoAccount.SETRANGE("No.",AccountNo);
      IF saccoAccount.FIND('-') THEN BEGIN

          IF LoanType.GET(LoanProductType) THEN BEGIN
              MaxLoanAmount := 0;

              IF LoanType."Restrict to Emp. Code" <> '' THEN BEGIN
                  IF saccoAccount."Employer Code" <> LoanType."Restrict to Emp. Code" THEN
                      EXIT;

                  IF saccoAccount."Employer Code" = '' THEN
                      EXIT;
              END;

              IF LoanType."Available To Member" <> '' THEN BEGIN
                  IF saccoAccount."Member No." <> LoanType."Available To Member" THEN
                      EXIT;

              END;

              Members.GET(saccoAccount."Member No.");
              IF Members."Next Mahitaji Date" <> 0D THEN BEGIN

                  Rating.RESET;
                  Rating.SETRANGE("Loan Product",LoanProductType);
                  Rating.SETRANGE("Member No.",saccoAccount."Member No.");
                  IF Rating.FINDLAST THEN
                      Rating.DELETEALL;

                  IF Members."Next Mahitaji Date" > TODAY THEN BEGIN

                      msg:='Your '+LoanType."USSD Product Name"+' request has failed, your account has been blacklisted for 3 months up to '+FORMAT(Members."Next Mahitaji Date");
                      MobileLoan.Remarks:='Member account has been blacklisted for 3 months up to '+FORMAT(Members."Next Mahitaji Date");
                      MobileLoan.Status:=MobileLoan.Status::"2";
                      MobileLoan.Posted:=TRUE;
                      MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                      MobileLoan.Message:=msg;
                      SendSms(Source::MBANKING,saccoAccount."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),'',TRUE,Priority,FALSE);
                      MobileLoan.MODIFY;
                      EXIT;

                  END
                  ELSE BEGIN
                      Members."Next Mahitaji Date" := 0D;
                      Members."Mahitaji Defaulter" := FALSE;
                      Members.MODIFY;
                  END;
              END;

              DepAcc.RESET;
              DepAcc.SETRANGE("Member No.",saccoAccount."Member No.");
              DepAcc.SETRANGE("Product Category",DepAcc."Product Category"::"2");
              IF DepAcc.FINDFIRST THEN BEGIN
                  DepAcc.CALCFIELDS("Balance (LCY)");
                  IF DepAcc."Balance (LCY)" < LoanType."Non-Salaried Min. Deposits" THEN BEGIN

                      msg:='Your '+LoanType."USSD Product Name"+' request has failed, your deposit contribution is below the minimum of KES. '+FORMAT(LoanType."Non-Salaried Min. Deposits");
                      MobileLoan.Remarks:='Member Deposits are below minimum of KES'+FORMAT(LoanType."Non-Salaried Min. Deposits");
                      MobileLoan.Status:=MobileLoan.Status::"2";
                      MobileLoan.Posted:=TRUE;
                      MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                      MobileLoan.Message:=msg;
                      SendSms(Source::MBANKING,saccoAccount."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),'',TRUE,Priority,FALSE);
                      MobileLoan.MODIFY;
                      EXIT;
                  END;
              END
              ELSE
                  EXIT(0);

              DepAcc.RESET;
              DepAcc.SETRANGE("Member No.",saccoAccount."Member No.");
              DepAcc.SETRANGE("Product Category",DepAcc."Product Category"::"1");
              IF DepAcc.FINDFIRST THEN BEGIN
                  DepAcc.CALCFIELDS("Balance (LCY)");
                  IF DepAcc."Balance (LCY)" < LoanType."Non-Salaried Min. Share Cap" THEN BEGIN

                      msg:='Your '+LoanType."USSD Product Name"+' request has failed, your Share Capital is below the minimum of KES. '+FORMAT(LoanType."Non-Salaried Min. Share Cap");
                      MobileLoan.Remarks:='Member Share Capital are below minimum of KES'+FORMAT(LoanType."Non-Salaried Min. Share Cap");
                      MobileLoan.Status:=MobileLoan.Status::"2";
                      MobileLoan.Posted:=TRUE;
                      MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                      MobileLoan.Message:=msg;
                      SendSms(Source::MBANKING,saccoAccount."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),'',TRUE,Priority,FALSE);
                      MobileLoan.MODIFY;
                      EXIT;
                  END;
              END
              ELSE
                  EXIT(0);

              DepAcc.RESET;
              DepAcc.SETRANGE("Member No.",saccoAccount."Member No.");
              DepAcc.SETRANGE("Product Category",DepAcc."Product Category"::"2");
              IF DepAcc.FINDFIRST THEN BEGIN
                  DepAcc.SETRANGE("Date Filter",CALCDATE('-180D',TODAY),TODAY);
                  DepAcc.CALCFIELDS("Balance (LCY)");
                  IF DepAcc."Balance (LCY)" < 12500 THEN BEGIN

                      STOFound := FALSE;
                      StandingOrders.RESET;
                      StandingOrders.SETRANGE(StandingOrders."Source Account No.",saccoAccount."No.");
                      StandingOrders.SETRANGE(StandingOrders.Status , StandingOrders.Status::"2");
                      StandingOrders.SETFILTER("End Date" ,'>%1',TODAY);
                      IF StandingOrders.FIND('-') THEN BEGIN
                          REPEAT
                              STOLines.RESET;
                              STOLines.SETRANGE("Document No.",StandingOrders."No.");
                              STOLines.SETRANGE("Destination Account No.",DepAcc."No.");
                              STOLines.SETRANGE(Amount,500);
                              IF STOLines.FINDFIRST THEN
                                STOFound := TRUE;
                          UNTIL StandingOrders.NEXT = 0;
                      END;

                      IF (NOT STOFound) OR ((STOFound)AND(DepAcc."Balance (LCY)"<2500)) THEN BEGIN
                          msg:='Your '+LoanType."USSD Product Name"+' request has failed, You are not upto date in your Deposit contribution.';
                          MobileLoan.Remarks:='Member not upto date in Deposit contribution. Amount Contributed in 180Days is '+FORMAT(DepAcc."Balance (LCY)");
                          MobileLoan.Status:=MobileLoan.Status::"2";
                          MobileLoan.Posted:=TRUE;
                          MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                          MobileLoan.Message:=msg;
                          SendSms(Source::MBANKING,saccoAccount."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),'',TRUE,Priority,FALSE);
                          MobileLoan.MODIFY;
                          EXIT;
                      END;
                  END;
                  DepAcc.SETRANGE("Date Filter",CALCDATE('-60D',TODAY),TODAY);
                  DepAcc.CALCFIELDS("Balance (LCY)");
                  IF DepAcc."Balance (LCY)" < 2500 THEN BEGIN

                      STOFound := FALSE;
                      StandingOrders.RESET;
                      StandingOrders.SETRANGE(StandingOrders."Source Account No.",saccoAccount."No.");
                      StandingOrders.SETRANGE(StandingOrders.Status , StandingOrders.Status::"2");
                      StandingOrders.SETFILTER("End Date" ,'>%1',TODAY);
                      IF StandingOrders.FIND('-') THEN BEGIN
                          REPEAT
                              STOLines.RESET;
                              STOLines.SETRANGE("Document No.",StandingOrders."No.");
                              STOLines.SETRANGE("Destination Account No.",DepAcc."No.");
                              STOLines.SETRANGE(Amount,500);
                              IF STOLines.FINDFIRST THEN
                                STOFound := TRUE;
                          UNTIL StandingOrders.NEXT = 0;
                      END;

                      IF (NOT STOFound) OR ((STOFound)AND(DepAcc."Balance (LCY)"<500)) THEN BEGIN
                          msg:='Your '+LoanType."USSD Product Name"+' request has failed, You are not upto date in your Deposit contribution.';
                          MobileLoan.Remarks:='Member not upto date in Deposit contribution. Amount Contributed in 60Days is '+FORMAT(DepAcc."Balance (LCY)");
                          MobileLoan.Status:=MobileLoan.Status::"2";
                          MobileLoan.Posted:=TRUE;
                          MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                          MobileLoan.Message:=msg;
                          SendSms(Source::MBANKING,saccoAccount."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),'',TRUE,Priority,FALSE);
                          MobileLoan.MODIFY;
                          EXIT;
                      END;
                  END;
              END
              ELSE
                  EXIT(0);


              DepAcc.RESET;
              DepAcc.SETRANGE("Member No.",saccoAccount."Member No.");
              DepAcc.SETRANGE("Product Category",DepAcc."Product Category"::"4");
              IF DepAcc.FINDFIRST THEN BEGIN
                  DepAcc.SETRANGE("Date Filter",CALCDATE('-180D',TODAY),TODAY);
                  DepAcc.CALCFIELDS("Balance (LCY)");
                  IF DepAcc."Balance (LCY)" < 1500 THEN BEGIN
                      msg:='Your '+LoanType."USSD Product Name"+' request has failed, You are not upto date in your benevolent contribution.';
                      MobileLoan.Remarks:='Member not upto date in benevolent contribution. Amount Contributed in 180Days is '+FORMAT(DepAcc."Balance (LCY)");
                      MobileLoan.Status:=MobileLoan.Status::"2";
                      MobileLoan.Posted:=TRUE;
                      MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                      MobileLoan.Message:=msg;
                      SendSms(Source::MBANKING,saccoAccount."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),'',TRUE,Priority,FALSE);
                      MobileLoan.MODIFY;
                      EXIT;
                  END;
                  DepAcc.SETRANGE("Date Filter",CALCDATE('-60D',TODAY),TODAY);
                  DepAcc.CALCFIELDS("Balance (LCY)");
                  IF DepAcc."Balance (LCY)" < 300 THEN BEGIN
                      msg:='Your '+LoanType."USSD Product Name"+' request has failed, You are not upto date in your benevolent contribution.';
                      MobileLoan.Remarks:='Member not upto date in benevolent contribution. Amount Contributed in 60Days is '+FORMAT(DepAcc."Balance (LCY)");
                      MobileLoan.Status:=MobileLoan.Status::"2";
                      MobileLoan.Posted:=TRUE;
                      MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                      MobileLoan.Message:=msg;
                      SendSms(Source::MBANKING,saccoAccount."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),'',TRUE,Priority,FALSE);
                      MobileLoan.MODIFY;
                      EXIT;
                  END;
              END
              ELSE
                  EXIT(0);


              MaxLoanAmount := LoanType."Non-Salaried Max Loan Amt";
              CreditLimit := LoanCreditRating(saccoAccount."Member No.",LoanType."Product ID");
              CreditLimit := LoanCreditRating(saccoAccount."Member No.",LoanType."Product ID");

              IF MaxLoanAmount > CreditLimit THEN
                MaxLoanAmount := CreditLimit;

              Loans.RESET;
              Loans.SETRANGE("Member No.",saccoAccount."Member No.");
              Loans.SETRANGE("Loan Product Type",LoanType."Product ID");
              Loans.SETRANGE("Non-Salaried",TRUE);
              Loans.SETRANGE("Mobile Loan",TRUE);
              Loans.SETFILTER("Outstanding Balance",'>0');
              IF Loans.FINDFIRST THEN BEGIN
                REPEAT
                    Loans.CALCFIELDS("Outstanding Balance","Outstanding Penalty");
                    LBal := Loans."Outstanding Balance"+Loans."Outstanding Penalty";
                    MaxLoanAmount -= LBal;

                    IF MaxLoanAmount <= 0 THEN BEGIN
                        msg:='Your '+LoanType."USSD Product Name"+' request has failed, You have exceeded your loan limit';
                        MobileLoan.Remarks:='Member has exceeded loan limit';
                        MobileLoan.Status:=MobileLoan.Status::"2";
                        MobileLoan.Posted:=TRUE;
                        MobileLoan."Date Posted":=CURRENTDATETIME;//TODAY;
                        MobileLoan.Message:=msg;
                        SendSms(Source::MBANKING,saccoAccount."Transactional Mobile No",msg,FORMAT(MobileLoan."Entry No"),'',TRUE,Priority,FALSE);
                        MobileLoan.MODIFY;
                        EXIT;
                    END;

                UNTIL Loans.NEXT = 0;
              END;

              IF MaxLoanAmount < 0 THEN
                MaxLoanAmount := 0;





              EXIT(ROUND(MaxLoanAmount,1,'<'));
          END;
      END;

      EXIT(0);
      }
    END;

    PROCEDURE LoanReminders@78(LoanNo@1120054001 : Code[20];UpdateDate@1120054002 : Boolean);
    VAR
      Loans@1000 : Record 51516230;
      msg@1001 : Text;
      SavAcc@1002 : Record 23;
      LBal@1003 : Decimal;
      OldLoanNo@1120054000 : Code[20];
      ODAuth@1120054003 : Record 51516328;
      Vendor@1120054004 : Record 23;
    BEGIN


      Loans.RESET;
      IF LoanNo <> '' THEN
          Loans.SETRANGE("Loan  No.",LoanNo);
      Loans.SETRANGE("Mobile Loan",TRUE);
      Loans.SETFILTER("Outstanding Balance",'>0');
      IF Loans.FINDFIRST THEN BEGIN
          REPEAT
            IF (Loans."Loan Product Type" ='A16') OR (Loans."Loan Product Type" ='A01') OR (Loans."Loan Product Type" ='A10') OR (Loans."Loan Product Type" ='M_OD') THEN
              Loans."Recovery Mode" := Loans."Recovery Mode"::Salary
            ELSE
              Loans."Recovery Mode" := Loans."Recovery Mode"::Mobile;
              Loans.MODIFY;

      //         IF Loans."Recovery Mode" <> Loans."Recovery Mode"::Salary THEN BEGIN
      //             Loans."Recovery Mode" := Loans."Recovery Mode"::Mobile;
      //             Loans.MODIFY;
      //         END;
          UNTIL Loans.NEXT=0;
      END;


      SaccoSetup.GET;
      SaccoSetup.TESTFIELD("Mbanking Application Name");
      SaccoSetup.TESTFIELD("USSD Code");



      Loans.RESET;
      IF LoanNo <> '' THEN
          Loans.SETRANGE("Loan  No.",LoanNo);
      Loans.SETRANGE("Mobile Loan",TRUE);
      Loans.SETFILTER("Outstanding Balance",'>0');
      //Loans.SETFILTER("Issued Date",'<%1',CALCDATE('-10D',TODAY));
      Loans.SETFILTER("Last Mobile Loan Rem. Date",'<%1',TODAY);
      IF Loans.FINDFIRST THEN BEGIN
          REPEAT
              OldLoanNo := '';
              IF NOT CreditRating.GET(Loans."Loan  No.") THEN BEGIN
                  CreditRating.RESET;
                  CreditRating.SETCURRENTKEY("Date Entered");
                  CreditRating.SETRANGE("Member No",Loans."Client Code");
                  CreditRating.SETRANGE("Loan Product Type",Loans."Loan Product Type");
                  IF CreditRating.FINDFIRST THEN BEGIN
                       OldLoanNo := CreditRating."Loan No.";
                  END;
              END;

              IF (CreditRating.GET(Loans."Loan  No.")) OR ((OldLoanNo<>'')AND(CreditRating.GET(OldLoanNo))) THEN BEGIN
                  Loans."Repayment Start Date" := CALCDATE('30D',Loans."Issued Date");
                  Loans.CALCFIELDS("Outstanding Balance","Oustanding Interest","Oustanding Penalty");
                  LBal := ROUND(Loans."Outstanding Balance"+Loans."Oustanding Interest"+Loans."Oustanding Penalty",1,'>');
                  Priority := 210;
                  Loans."Last Mobile Loan Rem. Date" := TODAY;
                  IF (SavAcc.GET(Loans."Account No")) AND (LBal>0) THEN BEGIN

                      IF CreditRating."Last Notification" = CreditRating."Last Notification"::" " THEN BEGIN
                          IF LoanNo <> '' THEN
                              MESSAGE('Next SMS Date: %1\%2',CALCDATE('15D',Loans."Issued Date"),FORMAT(CreditRating."Next Notification") );

                          IF CALCDATE('15D',Loans."Issued Date") < TODAY THEN BEGIN

                              msg:='Dear '+FirstName(Loans."Client Name")+', your '+Loans."Loan Product Type Name"+' of Kshs '+FORMAT(LBal)+' is due on '+ddMMyyyy(CALCDATE(FORMAT(Loans.Installments)+'M',Loans."Issued Date"))+'. To pay, Dial '
                              + SaccoSetup."USSD Code"+' or go to  '+SaccoSetup."Mbanking Application Name"+'  App';
                              SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,Loans."Loan  No.",SavAcc."No.",TRUE,Priority,TRUE);
                              CreditRating."Last Notification" := CreditRating."Last Notification"::"1";
                              CreditRating."Next Notification" := CreditRating."Next Notification"::"2";
                              CreditRating.MODIFY;
                              COMMIT;
                          END;
                      END
                      ELSE IF (CreditRating."Last Notification" = CreditRating."Last Notification"::"1") AND (CreditRating."Next Notification" = CreditRating."Next Notification"::"2") THEN BEGIN

                          IF LoanNo <> '' THEN
                              MESSAGE('Next SMS Date: %1\%2',CALCDATE('21D',Loans."Issued Date"),FORMAT(CreditRating."Next Notification") );

                          IF CALCDATE('21D',Loans."Issued Date") < TODAY THEN BEGIN
                              msg:='Dear '+FirstName(Loans."Client Name")+', your '+Loans."Loan Product Type Name"+' of Kshs '+FORMAT(LBal)+' is due on '+ddMMyyyy(CALCDATE(FORMAT(Loans.Installments)+'M',Loans."Issued Date"))
                            +'. Save promtly Borrow Wisely';
                              SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,Loans."Loan  No.",SavAcc."No.",TRUE,Priority,TRUE);
                              CreditRating."Last Notification" := CreditRating."Last Notification"::"2";
                              CreditRating."Next Notification" := CreditRating."Next Notification"::"3";
                              CreditRating.MODIFY;
                              COMMIT;
                          END;
                      END
                      ELSE IF (CreditRating."Last Notification" = CreditRating."Last Notification"::"2") AND (CreditRating."Next Notification" = CreditRating."Next Notification"::"3") THEN BEGIN

                          IF LoanNo <> '' THEN
                              MESSAGE('Next SMS Date: %1\%2',CALCDATE('27D',Loans."Issued Date"),FORMAT(CreditRating."Next Notification") );
                          IF CALCDATE('27D',Loans."Issued Date") < TODAY THEN BEGIN
                              msg:='Dear '+FirstName(Loans."Client Name")+', your '+Loans."Loan Product Type Name"+' of Kshs '+FORMAT(LBal)+' is due on '+ddMMyyyy(CALCDATE(FORMAT(Loans.Installments)+'M',Loans."Issued Date"))
                            +'. Save promtly Borrow Wisely';
                              SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,Loans."Loan  No.",SavAcc."No.",TRUE,Priority,TRUE);
                              CreditRating."Last Notification" := CreditRating."Last Notification"::"3";
                              CreditRating."Next Notification" := CreditRating."Next Notification"::"4";
                              CreditRating.MODIFY;
                              COMMIT;
                          END;
                      END
                      ELSE IF (CreditRating."Last Notification" = CreditRating."Last Notification"::"3") AND (CreditRating."Next Notification" = CreditRating."Next Notification"::"4") THEN BEGIN

                          IF LoanNo <> '' THEN
                              MESSAGE('Next SMS Date: %1\%2',CALCDATE('28D',Loans."Issued Date"),FORMAT(CreditRating."Next Notification") );
                          IF CALCDATE('28D',Loans."Issued Date") <= TODAY THEN BEGIN
                              msg:='Dear '+FirstName(Loans."Client Name")+', your '+Loans."Loan Product Type Name"+' of Kshs '+FORMAT(LBal)+' is due on '+ddMMyyyy(CALCDATE(FORMAT(Loans.Installments)+'M',Loans."Issued Date"))
                            +'. Save promtly Borrow Wisely';
                              SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,Loans."Loan  No.",SavAcc."No.",TRUE,Priority,TRUE);
                              CreditRating."Last Notification" := CreditRating."Last Notification"::"4";
                              CreditRating."Next Notification" := CreditRating."Next Notification"::"5";
                              CreditRating.MODIFY;
                              COMMIT;
                          END;
                      END
                      ELSE IF (CreditRating."Last Notification" = CreditRating."Last Notification"::"4") AND (CreditRating."Next Notification" = CreditRating."Next Notification"::"5") THEN BEGIN

                          IF LoanNo <> '' THEN
                              MESSAGE('Next SMS Date: %1\%2',CALCDATE(Loans."Instalment Period",Loans."Issued Date"),FORMAT(CreditRating."Next Notification") );
                          IF CALCDATE('1M',Loans."Issued Date") <= TODAY THEN BEGIN

                              msg:='Dear '+FirstName(Loans."Client Name")+', your '+Loans."Loan Product Type Name"+' of Kshs '+FORMAT(LBal)+' is due - '+ddMMyyyy(CALCDATE(FORMAT(Loans.Installments)+'M',Loans."Issued Date"))+
                              '. Kindly pay to avoid recovery  and being barred from future transactions.';
                              SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,Loans."Loan  No.",SavAcc."No.",TRUE,Priority,TRUE);
                              CreditRating."Last Notification" := CreditRating."Last Notification"::"5";
                              CreditRating."Next Notification" := CreditRating."Next Notification"::"6";
                              CreditRating.MODIFY;
                              COMMIT;
                          END;
                      END;

                  END;
                  Loans."Last Mobile Loan Rem. Date" := TODAY;
                  IF UpdateDate THEN
                  Loans.MODIFY;


                  IF Loans."Repayment Start Date" <> CALCDATE('1M',Loans."Issued Date") THEN BEGIN
                      Loans."Repayment Start Date" := CALCDATE('1M',Loans."Issued Date");
                      Loans.MODIFY;
                  END
                  ELSE IF  Loans."Repayment Start Date"<>CALCDATE('2M', Loans."Issued Date") THEN BEGIN
                    Loans."Repayment Start Date" := CALCDATE('2M-2D',Loans."Issued Date");
                  END;
              END;
          UNTIL Loans.NEXT = 0;
      END;



      Vendor.RESET;
      Vendor.SETFILTER(Vendor."Authorised Over Draft",'>0');
      IF Vendor.FINDFIRST THEN BEGIN
          REPEAT


              ODAuth.RESET;
              ODAuth.SETRANGE(ODAuth.Status,ODAuth.Status::Approved);
              ODAuth.SETRANGE(ODAuth.Expired,FALSE);
              ODAuth.SETRANGE(ODAuth.Liquidated,FALSE);
              ODAuth.SETRANGE(ODAuth.Posted,TRUE);
              ODAuth.SETRANGE(ODAuth.Mobile,TRUE);
              ODAuth.SETRANGE(ODAuth."Account No.",Vendor."No.");
              IF ODAuth.FINDFIRST THEN BEGIN
                  REPEAT
                      BEGIN
                          IF (SavAcc.GET(ODAuth."Account No.")) THEN BEGIN

                              IF ODAuth."Last Notification" = ODAuth."Last Notification"::" " THEN BEGIN

                                  IF CALCDATE('15D',ODAuth."Effective/Start Date") < TODAY THEN BEGIN

                                      msg:='Dear '+FirstName(SavAcc."No.")+', your overdraft facility of Kshs '+FORMAT(ODAuth."Approved Amount")+' is due on '+ddMMyyyy(ODAuth."Expiry Date")+'. To pay, Dial '
                                      +SaccoSetup."USSD Code"+' or go to  '+
                                      SaccoSetup."Mbanking Application Name"+'  App';
                                      SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,ODAuth."No.",SavAcc."No.",TRUE,Priority,TRUE);
                                      ODAuth."Last Notification" := ODAuth."Last Notification"::"1";
                                      ODAuth."Next Notification" := ODAuth."Next Notification"::"2";
                                      ODAuth.MODIFY;
                                      COMMIT;
                                  END;
                              END
                              ELSE IF (ODAuth."Last Notification" = ODAuth."Last Notification"::"1") AND (ODAuth."Next Notification" = ODAuth."Next Notification"::"2") THEN BEGIN

                                  IF CALCDATE('20D',ODAuth."Effective/Start Date") < TODAY THEN BEGIN
                                      msg:='Dear '+FirstName(SavAcc."No.")+', your overdraft facility of Kshs '+FORMAT(ODAuth."Approved Amount")+' is due on '+ddMMyyyy(ODAuth."Expiry Date")+
                                  '. To pay, Dial '+SaccoSetup."USSD Code"+' or go to  '+SaccoSetup."Mbanking Application Name"+'  App';
                                      SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,ODAuth."No.",SavAcc."No.",TRUE,Priority,TRUE);
                                      ODAuth."Last Notification" := ODAuth."Last Notification"::"2";
                                      ODAuth."Next Notification" := ODAuth."Next Notification"::"3";
                                      ODAuth.MODIFY;
                                      COMMIT;
                                  END;
                              END
                              ELSE IF (ODAuth."Last Notification" = ODAuth."Last Notification"::"2") AND (ODAuth."Next Notification" = ODAuth."Next Notification"::"3") THEN BEGIN

                                  IF CALCDATE('27D',ODAuth."Effective/Start Date") < TODAY THEN BEGIN
                                      msg:='Dear '+FirstName(SavAcc."No.")+', your overdraft facility of Kshs '+FORMAT(ODAuth."Approved Amount")+' is due on '+ddMMyyyy(ODAuth."Expiry Date")+'. To pay, Dial '+SaccoSetup."USSD Code"+' or go to  '
                                    +SaccoSetup."Mbanking Application Name"+'  App';
                                      SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,ODAuth."No.",SavAcc."No.",TRUE,Priority,TRUE);
                                      ODAuth."Last Notification" := ODAuth."Last Notification"::"3";
                                      ODAuth."Next Notification" := ODAuth."Next Notification"::"4";
                                      ODAuth.MODIFY;
                                      COMMIT;
                                  END;
                              END
                              ELSE IF (ODAuth."Last Notification" = ODAuth."Last Notification"::"3") AND (ODAuth."Next Notification" = ODAuth."Next Notification"::"4") THEN BEGIN

                                  IF CALCDATE('28D',ODAuth."Effective/Start Date") <= TODAY THEN BEGIN
                                      msg:='Dear '+FirstName(SavAcc."No.")+', your overdraft facility of Kshs '+FORMAT(ODAuth."Approved Amount")+' is due on '+ddMMyyyy(ODAuth."Expiry Date")+'. To pay, Dial '+SaccoSetup."USSD Code"+' or go to  '
                                    +SaccoSetup."Mbanking Application Name"+'  App';
                                      SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,ODAuth."No.",SavAcc."No.",TRUE,Priority,TRUE);
                                      ODAuth."Last Notification" := ODAuth."Last Notification"::"4";
                                      ODAuth."Next Notification" := ODAuth."Next Notification"::"5";
                                      ODAuth.MODIFY;
                                      COMMIT;
                                  END;
                              END
                              ELSE IF (ODAuth."Last Notification" = ODAuth."Last Notification"::"4") AND (ODAuth."Next Notification" = ODAuth."Next Notification"::"5") THEN BEGIN

                                  IF ODAuth."Expiry Date" <= TODAY THEN BEGIN

                                      msg:='Dear '+FirstName(SavAcc."No.")+', your overdraft facility of Kshs '+FORMAT(ODAuth."Approved Amount")+' is due today. To pay, Dial '+SaccoSetup."USSD Code"+' or go to  '
                                      +SaccoSetup."Mbanking Application Name"+'  App';
                                      SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,ODAuth."No.",SavAcc."No.",TRUE,Priority,TRUE);
                                      ODAuth."Last Notification" := ODAuth."Last Notification"::"5";
                                      ODAuth."Next Notification" := ODAuth."Next Notification"::"6";
                                      ODAuth.MODIFY;
                                      COMMIT;
                                  END;
                              END;

                          END;
                          ODAuth."Last Mobile Loan Rem. Date" := TODAY;
                          IF UpdateDate THEN
                          ODAuth.MODIFY;


                      END;
                  UNTIL ODAuth.NEXT = 0;
              END;
          UNTIL Vendor.NEXT=0;
      END;
    END;

    PROCEDURE LoanPenalty@71(LoanNo@1120054011 : Code[20]);
    VAR
      msg@1001 : Text;
      SavAcc@1002 : Record 23;
      Loans@1000 : Record 51516230;
      LoanType@1004 : Record 51516240;
      CLedger@1005 : Record 51516224;
      PenaltyAmt@1006 : Decimal;
      JTemplate@1010 : Code[10];
      JBatch@1009 : Code[10];
      DocNo@1008 : Code[20];
      PDate@1007 : Date;
      AccNo@1011 : Code[20];
      AcctType@1014 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      BalAccType@1013 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      TransType@1012 : ' ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated';
      Dim1@1015 : Code[10];
      Dim2@1016 : Code[10];
      SystCreated@1017 : Boolean;
      FullyRecovered@1018 : Integer;
      LBal@1019 : Decimal;
      Members@1020 : Record 51516223;
      SaccoSetup@1120054000 : Record 51516700;
      FosaBal@1120054001 : Decimal;
      amtToRecover@1120054002 : Decimal;
      RunBal@1120054003 : Decimal;
      DedAmt@1120054004 : Decimal;
      AmtDeducted@1120054005 : Decimal;
      RecoveredFromFosa@1120054006 : Decimal;
      RecoveredFromBosa@1120054007 : Decimal;
      ExtDoc@1120054008 : Code[10];
      TotalRecovered@1120054009 : Decimal;
      CreditRating@1120054010 : Record 51516718;
      FullyRec@1120054012 : Boolean;
      NewBal@1120054013 : Decimal;
      NextLoanNo@1120054014 : Code[20];
      Continue@1120054015 : Boolean;
      Interest@1120054016 : Decimal;
      Repayment@1120054017 : Decimal;
      Penalty@1120054018 : Decimal;
      AmountRecovered@1120054019 : Decimal;
    BEGIN

      Loans.RESET;
      Loans.SETFILTER(Loans."Loan Product Type",'=%1|=%2','A03','A16');
      Loans.SETCURRENTKEY(Loans."Loan Product Type");
      Loans.ASCENDING(FALSE);

      Loans.SETFILTER("Outstanding Balance",'>0');
      IF Loans.FINDFIRST THEN BEGIN
          REPEAT
              IF Loans."Repayment Start Date" <> CALCDATE('30D',Loans."Issued Date") THEN BEGIN
                  Loans."Repayment Start Date" := CALCDATE('30D',Loans."Issued Date");
                  Loans.MODIFY;
              END;
              IF Loans."Expected Date of Completion" <> CALCDATE(FORMAT(Loans.Installments)+'M+2D',Loans."Issued Date") THEN BEGIN
                  Loans."Expected Date of Completion" := CALCDATE(FORMAT(Loans.Installments)+'M+2D',Loans."Issued Date");
                  Loans.MODIFY;
              END;
      //         IF TODAY > Loans."Expected Date of Completion" THEN
      //           Continue:=TRUE;

          UNTIL Loans.NEXT = 0;
      END;


      //Recover From FOSA if on due date without charging penalty

      Loans.RESET;
      Loans.SETFILTER(Loans."Loan Product Type",'=%1|=%2','A03','A16');
      Loans.SETCURRENTKEY(Loans."Loan Product Type");
      Loans.ASCENDING(FALSE);
      IF LoanNo <> '' THEN
        Loans.SETRANGE("Loan  No.",LoanNo );
      Loans.SETFILTER("Outstanding Balance",'>=0');
      Loans.SETFILTER(Loans."Oustanding Penalty",'>=0');
      Loans.SETFILTER(Loans."Expected Date of Completion",'<%1',TODAY);
      IF Loans.FINDFIRST THEN BEGIN
          SaccoSetup.GET;
          SaccoSetup.TESTFIELD("Loan Penalty %");

          REPEAT
            LBal :=0;
            FosaBal:=0;
            NewBal:= 0;
            Penalty:=0;
            Repayment:=0;
            Interest:=0;

              LoanNo := Loans."Loan  No.";
              IF SavAcc.GET(Loans."Account No") THEN BEGIN

                  JTemplate:='GENERAL';
                  JBatch:='SKYWORLD';
                  Continue := FALSE;

                      Loans.CALCFIELDS("Outstanding Balance","Oustanding Interest","Oustanding Penalty");
                      LBal :=Loans."Outstanding Balance"+Loans."Oustanding Interest"+Loans."Oustanding Penalty";


                   IF Loans."Issued Date" <> 0D THEN BEGIN
                     IF CALCDATE(FORMAT(Loans.Installments)+'M',Loans."Issued Date")< TODAY THEN BEGIN
          //            IF Loans."Expected Date of Completion" < TODAY THEN BEGIN

                      DocNo:='RECOVER-'+Loans."Loan  No.";
                      PDate:=TODAY;
                      SaccoTrans.InitJournal(JTemplate,JBatch);

                      FosaBal:= GetAccountBalance(Loans."Account No");


                      IF FosaBal > 0 THEN BEGIN

                             Interest :=Loans."Oustanding Interest";
                             IF Interest <= 0 THEN Interest :=0;
                             IF Interest > FosaBal THEN Interest := FosaBal;

                              IF Interest > 0 THEN BEGIN
                                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."Client Code",COPYSTR(Loans."Loan Product Type Name"+': Offset',1,50),BalAccType::"G/L Account",
                                                '',-Interest,ExtDoc,LoanNo,TransType::"Interest Paid",Dim1,Dim2,SystCreated,Loans."Client Name");

                              END;


                              NewBal := FosaBal-Interest;
                              IF NewBal < 0 THEN NewBal :=0;
                              Penalty :=Loans."Oustanding Penalty";
                              IF Penalty <= 0 THEN Penalty :=0;
                              IF Penalty > NewBal THEN Penalty := NewBal;

                              IF Penalty > 0 THEN BEGIN
                                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."Client Code",COPYSTR(Loans."Loan Product Type Name"+': Offset',1,50),BalAccType::"G/L Account",
                                                '',-Penalty,ExtDoc,LoanNo,TransType::"Penalty Paid",Dim1,Dim2,SystCreated,Loans."Client Name");
                              END;

                              NewBal := FosaBal-Interest-Penalty;
                              IF NewBal < 0 THEN NewBal :=0;
                              Repayment := Loans."Outstanding Balance";
                              IF Repayment <= 0 THEN Repayment :=0;
                              IF NewBal < Repayment THEN Repayment := NewBal;

                              IF Repayment > 0 THEN BEGIN
                                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."Client Code",COPYSTR(Loans."Loan Product Type Name"+': Offset',1,50),BalAccType::"G/L Account",
                                                '',-Repayment,ExtDoc,LoanNo,TransType::Repayment,Dim1,Dim2,SystCreated,Loans."Client Name");
                              END;
                      END;

                      IF (Interest+Repayment+Penalty) >0 THEN BEGIN
                          SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,Loans."Account No",COPYSTR(Loans."Loan Product Type Name"+': Offset',1,50),BalAccType::"G/L Account",
                                        '',(Interest+Repayment+Penalty),ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,Loans."Client Name");
                      END;
          //             AmountRecovered :=0;
          //             AmountRecovered :=(LBal-NewBal);

                      IF (Interest+Repayment+Penalty) > 0  THEN BEGIN

                           IF (LBal-(Interest+Repayment+Penalty)) <= 0 THEN
                             msg:='Dear '+FirstName(Loans."Client Name")+', your '+Loans."Loan Product Type Name"+' of Kshs '+FORMAT(LBal)+
                                        ' has been recovered from your FOSA Account on '+DateTimeToText(CURRENTDATETIME)
                            ELSE

                             msg:='Dear '+FirstName(Loans."Client Name")+' Kshs '+FORMAT(ROUND((Interest+Repayment+Penalty),1,'>'))+
                                        ' from your FOSA Account has been used to partially ofset '+Loans."Loan Product Type Name"+ ' on '+DateTimeToText(CURRENTDATETIME)+
                                        '. Your new loan Bal. is Kshs '+FORMAT(ROUND(LBal-(Interest+Repayment+Penalty),1,'>'));


                           SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,Loans."Loan  No.",SavAcc."No.",TRUE,Priority,TRUE);

                      END;

                      SaccoTrans.PostJournal(JTemplate,JBatch);
                    END;

                  END;


              END;

          UNTIL Loans.NEXT = 0;
      END;



      Loans.RESET;
      Loans.SETRANGE("Loan  No.",'');//Disabling this code
      Loans.SETRANGE("Mobile Loan",TRUE);
      Loans.SETFILTER("Outstanding Balance",'>0');
      Loans.SETFILTER(Loans."Expected Date of Completion",'<%1',TODAY);
      IF Loans.FINDFIRST THEN BEGIN

          SaccoSetup.GET;
          SaccoSetup.TESTFIELD("Loan Penalty %");
          REPEAT
              LoanNo := Loans."Loan  No.";
              SavAcc.GET(Loans."Account No");

              JTemplate:='GENERAL';
              JBatch:='SKYWORLD';

              IF Loans."Issued Date" <> 0D THEN BEGIN

                  Loans.CALCFIELDS("Outstanding Balance","Oustanding Interest","Penalty Charged");
                  LBal := Loans."Outstanding Balance"+Loans."Oustanding Interest"+Loans."Penalty Charged";

                  DocNo:='RECOVER-'+Loans."Loan  No.";
                  PDate:=TODAY;
                  SaccoTrans.InitJournal(JTemplate,JBatch);

                  FosaBal:= GetAccountBalance(Loans."Account No");
                  IF FosaBal < 0 THEN
                    FosaBal := 0;
                  PenaltyAmt := ROUND(LBal * SaccoSetup."Loan Penalty %"/100);

                  amtToRecover:=LBal+PenaltyAmt;

                  IF FosaBal <= 0 THEN
                      RecoveredFromFosa := 0
                  ELSE BEGIN
                      RecoveredFromFosa := amtToRecover;
                      IF RecoveredFromFosa > FosaBal THEN
                          RecoveredFromFosa := FosaBal;
                  END;

                  RecoveredFromBosa := amtToRecover - RecoveredFromFosa;
                  IF RecoveredFromBosa < 0 THEN
                      RecoveredFromBosa := 0;

                  RunBal := 0;
                  ExtDoc := '';

                  TotalRecovered := 0;
                  IF RecoveredFromFosa>0 THEN BEGIN
                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,Loans."Account No",COPYSTR(Loans."Loan Product Type Name"+': Offset',1,50),BalAccType::"G/L Account",
                                    '',RecoveredFromFosa,ExtDoc,LoanNo,TransType::" ",Dim1,Dim2,SystCreated,Loans."Client Name");
                      TotalRecovered += RecoveredFromFosa;
                  END;
                  IF RecoveredFromBosa>0 THEN BEGIN
                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."BOSA No",COPYSTR(Loans."Loan Product Type Name"+': Offset',1,50),BalAccType::"G/L Account",
                                    '',RecoveredFromBosa,ExtDoc,LoanNo,TransType::"Deposit Contribution",Dim1,Dim2,SystCreated,Loans."Client Name");
                      TotalRecovered += RecoveredFromBosa;
                  END
                  ELSE BEGIN

                      amtToRecover:=LBal+PenaltyAmt;
                      PenaltyAmt := 0;

                  END;


                  IF TotalRecovered > 0 THEN BEGIN

                      RunBal := TotalRecovered;

                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."Client Code",COPYSTR(Loans."Loan Product Type Name"+': Offset Penalty',1,50),BalAccType::"G/L Account",
                                    '',-PenaltyAmt,ExtDoc,LoanNo,TransType::"Penalty Paid",Dim1,Dim2,SystCreated,Loans."Client Name");
                      RunBal -= PenaltyAmt;


                      IF RunBal > 0 THEN BEGIN

                          DedAmt := Loans."Oustanding Interest";
                          IF DedAmt > RunBal THEN
                              DedAmt := RunBal;

                          IF DedAmt > 0 THEN BEGIN
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."Client Code",COPYSTR(Loans."Loan Product Type Name"+': Offset',1,50),BalAccType::"G/L Account",
                                            '',-DedAmt,ExtDoc,LoanNo,TransType::"Interest Paid",Dim1,Dim2,SystCreated,Loans."Client Name");
                            RunBal -= DedAmt;
                          END;

                          DedAmt := Loans."Outstanding Balance";
                          IF DedAmt > RunBal THEN
                              DedAmt := RunBal;

                          IF DedAmt > 0 THEN BEGIN
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,Loans."Client Code",COPYSTR(Loans."Loan Product Type Name"+': Offset',1,50),BalAccType::"G/L Account",
                                            '',-DedAmt,ExtDoc,LoanNo,TransType::Repayment,Dim1,Dim2,SystCreated,Loans."Client Name");
                            RunBal -= DedAmt;
                          END;
                      END;
                  END;
                  IF (RecoveredFromFosa > 0)  THEN BEGIN

                       msg:='Dear '+FirstName(Loans."Client Name")+', your '+Loans."Loan Product Type Name"+' of Kshs '+FORMAT(LBal)+
                                  ' has been recovered from your Fosa Account on '+DateTimeToText(CURRENTDATETIME)+'. REF: '+Loans."Loan  No.";
                                  SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,Loans."Loan  No.",SavAcc."No.",TRUE,Priority,TRUE);
                  END;
                  IF (RecoveredFromBosa > 0)  THEN BEGIN

                      IF CreditRating.GET(Loans."Loan  No.") THEN BEGIN
                          CreditRating."Penalty Date" := TODAY;
                          CreditRating."Next Loan Application Date" := CALCDATE('3M',TODAY);
                          CreditRating.Penalized := TRUE;
                          CreditRating."Amount  Recovered From FOSA" += RecoveredFromFosa;
                          CreditRating."Amount Recovered From BOSA" += RecoveredFromBosa;
                          CreditRating.MODIFY;
                      END
                      ELSE BEGIN

                          CreditRating.RESET;
                          CreditRating.SETCURRENTKEY("Date Entered");
                          CreditRating.SETRANGE("Member No",Loans."Client Code");
                          CreditRating.SETRANGE("Loan Product Type",Loans."Loan Product Type");
                          IF CreditRating.FINDLAST THEN BEGIN
                              CreditRating."Penalty Date" := TODAY;
                              CreditRating."Next Loan Application Date" := CALCDATE('2Y',TODAY);
                              CreditRating.Penalized := TRUE;
                              CreditRating."Amount  Recovered From FOSA" += RecoveredFromFosa;
                              CreditRating."Amount Recovered From BOSA" += RecoveredFromBosa;
                              CreditRating.MODIFY;
                          END;
                      END;

                      Members.GET(Loans."Client Code");
                      Members."Loan Defaulter":=TRUE;
                      Members."Loans Defaulter Status":=Members."Loans Defaulter Status"::Loss;
                      Members.MODIFY;

                      Loans.Defaulter:=TRUE;
                      Loans."Defaulted install":=LBal;
                      Loans.MODIFY;

                      msg:='Dear '+FirstName(Loans."Client Name")+', your '+Loans."Loan Product Type Name"+' of Kshs '+FORMAT(LBal)+
                            ' has been recovered from your Deposits on '+DateTimeToText(CURRENTDATETIME)+' and your have been barred from using this service until '+FORMAT(CALCDATE('2Y',TODAY));
                            SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,Loans."Loan  No.",SavAcc."No.",TRUE,Priority,TRUE);

                  END;

                  SaccoTrans.PostJournal(JTemplate,JBatch);


              END;
          UNTIL Loans.NEXT = 0;
      END;
    END;

    PROCEDURE FirstName@1000000004(Text@1000000000 : Text[100]) FName : Text[100];
    VAR
      Pos@1000000003 : Integer;
    BEGIN
      Pos := STRPOS(Text,' ');

      IF Pos > 0 THEN BEGIN
        FName := COPYSTR(Text,1,Pos-1);
      END ELSE BEGIN
        FName := Text;
      END;

      Pos := STRPOS(Text,' ');
    END;

    PROCEDURE ddMMyyyy@80(Date@1000 : Date) NewDate : Text;
    VAR
      d@1001 : Text;
      m@1002 : Text;
      y@1003 : Text;
    BEGIN

      d := FORMAT(DATE2DMY(Date,1));
      m := FORMAT(DATE2DMY(Date,2));
      y := FORMAT(DATE2DMY(Date,3));

      IF STRLEN(d) = 1 THEN
        d := '0'+d;

      IF STRLEN(m) = 1 THEN
        m := '0'+m;

      NewDate := d+'/'+m+'/'+y;
    END;

    PROCEDURE SplitAccount@58(AccountNo@1001 : Code[20];VAR ProductID@1002 : Code[20];VAR MNo@1003 : Code[20]);
    VAR
      ProdFact@1000 : Record 51516717;
      ProdLength@1004 : Integer;
    BEGIN

      ProductID := '';
      MNo := '';

      ProdFact.RESET;
      ProdFact.SETRANGE("Product Class Type",ProdFact."Product Class Type"::Savings);
      IF ProdFact.FINDFIRST THEN BEGIN
          REPEAT
              ProdLength := STRLEN(ProdFact."Product ID");
              ProductID := COPYSTR(AccountNo,1,ProdLength);
              IF ProductID = ProdFact."Product ID" THEN BEGIN
                  MNo := COPYSTR(AccountNo,ProdLength+1,STRLEN(AccountNo));
              END;
          UNTIL (ProdFact.NEXT = 0) OR (MNo<>'');
      END;
    END;

    PROCEDURE GetLoanPendingGuarantor@88(PhoneNo@1000 : Code[20]) Response : Text;
    VAR
      SkyMobileLoans@1002 : Record 51516713;
      Members@1003 : Record 51516223;
      SavingsAccounts@1004 : Record 23;
      MobileLoanGuarantors@1005 : Record 51516722;
      LoanType@1006 : Record 51516240;
      RemGuar@1007 : Integer;
      ProductName@1008 : Text;
    BEGIN
      PhoneNo := '+'+PhoneNo;
      Response := 'NULL';


      SkyMobileLoans.RESET;
      SkyMobileLoans.SETRANGE("Telephone No",PhoneNo);
      SkyMobileLoans.SETRANGE(Status,SkyMobileLoans.Status::"Pending Guarantors");
      IF SkyMobileLoans.FINDFIRST THEN BEGIN

          LoanType.GET(SkyMobileLoans."Loan Product Type");
          ProductName := LoanType."USSD Product Name";
          IF ProductName = '' THEN
            ProductName := LoanType."Product Description";

          Response := '<Loan>';
              Response += '<EntryNo>'+FORMAT(SkyMobileLoans."Entry No")+'</EntryNo>';
              Response += '<ProductName>'+ProductName+'</ProductName>';
              Response += '<RequestedAmount>'+FORMAT(SkyMobileLoans."Requested Amount")+'</RequestedAmount>';
              Response += '<LoanStatus>'+FORMAT(SkyMobileLoans.Status)+'</LoanStatus>';
              Response += '<Guarantors>';
                  MobileLoanGuarantors.RESET;
                  MobileLoanGuarantors.SETRANGE("Loan Entry No.",SkyMobileLoans."Entry No");
                  IF MobileLoanGuarantors.FINDFIRST THEN BEGIN
                      REPEAT
                          Response += '<GuarantorDetail>';
                          Response += '<GuarantorName>'+FORMAT(MobileLoanGuarantors."Guarantor Name")+'</GuarantorName>';
                          Response += '<MemberNo>'+MobileLoanGuarantors."Guarantor Member No."+'</MemberNo>';
                          Response += '<PhoneNo>'+MobileLoanGuarantors."Guarantor Mobile No."+'</PhoneNo>';
                          Response += '<LoanStatus>'+FORMAT(MobileLoanGuarantors.Status)+'</LoanStatus>';
                          Response += '</GuarantorDetail>';
                      UNTIL MobileLoanGuarantors.NEXT = 0;

                  END;
              Response += '</Guarantors>';
          Response += '</Loan>';
      END;
    END;

    PROCEDURE GetUnhashedPINs@84() Response : Text;
    VAR
      SkyAuth@1003 : Record 51516709;
      SavAcc@1000000000 : Record 23;
    BEGIN
      Response := 'ERROR';

      SkyAuth.RESET;
      SkyAuth.SETRANGE(SkyAuth."PIN Encrypted", FALSE);
      IF SkyAuth.FINDFIRST THEN BEGIN
          Response := '<ACCOUNTS>';
          REPEAT
              Response += '<ACCOUNT ACCOUNT_NUMBER="'+SkyAuth."Account No."+'" PHONE_NUMBER="'+SkyAuth."Mobile No."+'" PIN="'+SkyAuth."PIN No."+'"/>'
          UNTIL SkyAuth.NEXT=0;
          Response += '</ACCOUNTS>';
      END
      ELSE BEGIN
        Response := '<ACCOUNTS/>';
      END;
    END;

    PROCEDURE SetHashedPIN@82("Account Number"@1000 : Text;"Phone Number"@1001 : Text;"PIN Number"@1002 : Text) Response : Text;
    VAR
      SkyAuth@1003 : Record 51516709;
      SavAcc@1000000000 : Record 23;
      MobileNo@1004 : Text;
    BEGIN
      Response := 'ERROR';
      MobileNo := "Phone Number";
      SkyAuth.RESET;
      //SkyAuth.SETRANGE(SkyAuth."PIN Encrypted",FALSE);
      SkyAuth.SETRANGE(SkyAuth."Account No.","Account Number");
      //SkyAuth.SETRANGE(SkyAuth."Mobile No.",MobileNo);
      IF SkyAuth.FIND('-') THEN BEGIN
        SkyAuth."PIN No." := "PIN Number";
        SkyAuth."PIN Encrypted" := TRUE;
        SkyAuth.MODIFY;
        Response := 'SUCCESS';
      END
      ELSE BEGIN
        Response := 'NOT_FOUND';
      END;
    END;

    LOCAL PROCEDURE GetGuarantorMobileNo@87(MobileNo@1000 : Code[20]) : Text;
    BEGIN
      //
      // IF STRLEN(MobileNo) = 10 THEN BEGIN
      //   IF COPYSTR(MobileNo,1,1) = '0' THEN
      //       MobileNo := COPYSTR(MobileNo,2,9);
      // END
      // ELSE IF STRLEN(MobileNo) = 12 THEN BEGIN
      //   IF COPYSTR(MobileNo,1,3) = '254' THEN
      //       MobileNo := COPYSTR(MobileNo,4,9);
      // END
      // ELSE IF STRLEN(MobileNo) = 13 THEN BEGIN
      //   IF COPYSTR(MobileNo,1,4) = '+254' THEN
      //       MobileNo := COPYSTR(MobileNo,5,9);
      // END;
      //
      // EXIT(MobileNo);


      IF STRLEN(MobileNo) = 10 THEN BEGIN
        IF COPYSTR(MobileNo,1,1) = '0' THEN
            MobileNo := '+254'+COPYSTR(MobileNo,2,9);
      END
      ELSE IF STRLEN(MobileNo) = 12 THEN BEGIN
        IF COPYSTR(MobileNo,1,3) = '254' THEN
            MobileNo := '+'+MobileNo;
      END
      ELSE IF STRLEN(MobileNo) = 13 THEN BEGIN
        IF COPYSTR(MobileNo,1,4) = '+254' THEN
            MobileNo := MobileNo;
      END;

      EXIT(MobileNo);
    END;

    PROCEDURE GetLoanToConfirmGuarantoship@95(PhoneNo@1000 : Code[20]) Response : Text;
    VAR
      SkyMobileLoans@1002 : Record 51516713;
      Members@1003 : Record 51516223;
      SavingsAccounts@1004 : Record 23;
      MobileLoanGuarantors@1005 : Record 51516722;
      LoanType@1006 : Record 51516240;
      RemGuar@1007 : Integer;
      ProductName@1008 : Text;
      LoanFound@1009 : Boolean;
    BEGIN
      Response := 'NULL';

      PhoneNo := GetGuarantorMobileNo(PhoneNo);

      LoanFound := FALSE;

      MobileLoanGuarantors.RESET;
      MobileLoanGuarantors.SETRANGE("Guarantor Mobile No.",PhoneNo);
      MobileLoanGuarantors.SETRANGE("Guarantor Accepted",MobileLoanGuarantors."Guarantor Accepted"::Pending);
      IF MobileLoanGuarantors.FINDFIRST THEN BEGIN
          Response := '<Loans>';
          REPEAT
              SkyMobileLoans.RESET;
              SkyMobileLoans.SETRANGE("Entry No",MobileLoanGuarantors."Loan Entry No.");
              SkyMobileLoans.SETRANGE(Status,SkyMobileLoans.Status::"Pending Guarantors");
              IF SkyMobileLoans.FINDFIRST THEN BEGIN
                  LoanFound := TRUE;
                  LoanType.GET(SkyMobileLoans."Loan Product Type");
                  ProductName := LoanType."USSD Product Name";
                  IF ProductName = '' THEN
                    ProductName := LoanType."Product Description";

                  SavingsAccounts.GET(SkyMobileLoans."Account No");
                  Response += '<Loan>';
                  Response += '<LoaneeName>'+SavingsAccounts.Name+'</LoaneeName>';
                  Response += '<EntryNo>'+FORMAT(SkyMobileLoans."Entry No")+'</EntryNo>';
                  Response += '<LoaneePhoneNo>'+SavingsAccounts."Transactional Mobile No"+'</LoaneePhoneNo>';
                  Response += '<ProductName>'+ProductName+'</ProductName>';
                  Response += '<RequestedAmount>'+FORMAT(SkyMobileLoans."Requested Amount")+'</RequestedAmount>';
                  Response += '<LoanStatus>'+FORMAT(SkyMobileLoans.Status)+'</LoanStatus>';
                  Response += '</Loan>';
              END;
          UNTIL MobileLoanGuarantors.NEXT=0;
          Response += '</Loans>';
      END;

      IF NOT LoanFound THEN
        Response := 'NULL';
    END;

    PROCEDURE UpdateGuarantorResponse@60(LoanEntryNo@1000 : Integer;MobileNo@1009 : Code[20];Accepted@1010 : Boolean) Return : Text;
    VAR
      SkyMobileLoans@1120054000 : Record 51516713;
      MobileLoanGuarantors@1120054001 : Record 51516722;
    BEGIN
      IF COPYSTR(MobileNo,1,1) <> '+' THEN
        MobileNo := '+'+MobileNo;


      SkyMobileLoans.GET(LoanEntryNo);


      MobileLoanGuarantors.RESET;
      MobileLoanGuarantors.SETRANGE("Loan Entry No.",LoanEntryNo);
      MobileLoanGuarantors.SETRANGE("Guarantor Mobile No.",MobileNo);
      IF MobileLoanGuarantors.FINDFIRST THEN BEGIN
          IF Accepted THEN
              MobileLoanGuarantors."Guarantor Accepted" := MobileLoanGuarantors."Guarantor Accepted"::Yes
          ELSE
              MobileLoanGuarantors."Guarantor Accepted" := MobileLoanGuarantors."Guarantor Accepted"::No;

          MobileLoanGuarantors.MODIFY;
      END
      ELSE
          ERROR('Guarantor Not Found');

    END;

    PROCEDURE addRemoveMobileLoanGuarantor@74(LoanEntryNo@1000 : Integer;MobileNo@1001 : Code[20];Action@1120054002 : Code[30]) Return : Text;
    VAR
      SkyMobileLoans@1120054000 : Record 51516713;
      LoanType@1120054001 : Record 51516240;
      HMember@1120054003 : Record 51516223;
      FName@1120054004 : Text;
      Salute@1120054005 : Text;
      msg@1120054006 : Text;
      successText@1120054007 : Text;
      DepAc@1120054008 : Code[20];
      SavAcc@1120054009 : Record 23;
      Vendoracc@1120054010 : Record 23;
      MobileLoanGuarantors@1120054011 : Record 51516722;
      MemberLedgerEntry@1120054012 : Record 51516224;
      Loans@1120054013 : Record 51516230;
      MaximumAmountToCommit@1120054014 : Decimal;
      AmountCommitted@1120054015 : Decimal;
      BalanceToCommit@1120054016 : Decimal;
      DepositAmount@1120054017 : Decimal;
      MemberNo@1120054018 : Code[30];
      LoanProductsSetup@1120054019 : Record 51516240;
      LoanProduct@1120054020 : Record 51516240;
      MobileLoan@1120054021 : Record 51516704;
      GuarantorsDetails@1120054022 : Record 51516722;
      LoanApp@1120054023 : Record 51516713;
      Members@1120054024 : Record 51516223;
    BEGIN

      Return :='ERROR';

      MobileNo := GetGuarantorMobileNo(MobileNo);

      IF STRLEN(MobileNo) <> 13 THEN BEGIN
          Return := 'ERROR::::Invalid Phone No.';
          EXIT;
      END;


      Members.RESET;
      Members.SETFILTER("Mobile Phone No",'*'+MobileNo);
      IF Members.FINDFIRST THEN BEGIN

          IF Members.Status<>Members.Status::Active THEN BEGIN
              Return := 'ERROR::::1.'+Members.Name+' Account is not active hence not qualified to Guarantee';
              EXIT;
          END;

         IF Members."Loan Defaulter" = TRUE THEN BEGIN
           Return := 'ERROR::::'+Members.Name+' is a defaulter hence cannot guarantee';
           EXIT;
         END;

          AmountCommitted:=0;
          GuarantorsDetails.RESET;
          GuarantorsDetails.SETRANGE(GuarantorsDetails."Guarantor Member No.",MemberNo);
          IF GuarantorsDetails.FINDFIRST THEN BEGIN

          REPEAT
          LoanApp.RESET;
          LoanApp.SETRANGE(LoanApp."Entry No",GuarantorsDetails."Loan Entry No.");
            IF LoanApp.FINDFIRST THEN BEGIN
             AmountCommitted:=GuarantorsDetails."Amount Guaranteed"+AmountCommitted;
            END;
          UNTIL GuarantorsDetails.NEXT=0;

          IF Members.GET(Members."No.") THEN
          Members.CALCFIELDS(Members."Current Shares");
          MaximumAmountToCommit:=0;
          MaximumAmountToCommit:=Members."Current Shares"*6;
          IF AmountCommitted>MaximumAmountToCommit THEN BEGIN
            Return := 'ERROR:::: You can only guarantee shares up to %1.Your current guaranteed amount is %2' +FORMAT(MaximumAmountToCommit) +FORMAT(AmountCommitted);
          END ELSE BEGIN
            BalanceToCommit:=MaximumAmountToCommit-AmountCommitted;
            Return :='ERROR:::: Maximum shares to guarantee is %1.Committed amount is %2 .Shares balance to guarantee is %3.'+FORMAT(MaximumAmountToCommit) +FORMAT(AmountCommitted) +FORMAT(BalanceToCommit);
          END;
          END;

          IF SkyMobileLoans."Approved Amount" > BalanceToCommit THEN BEGIN
             SkyMobileLoans."Approved Amount":= BalanceToCommit;
            Return := 'ERROR:::: Your guarantorship amount is less than the Approved amount';
            EXIT;
          END;


          Loans.RESET;
          Loans.SETRANGE("Client Code",MemberNo);
          Loans.SETFILTER("Loans Category-SASRA",'%1|%2|%3|%4',Loans."Loans Category-SASRA"::Watch,Loans."Loans Category-SASRA"::Substandard,
          Loans."Loans Category-SASRA"::Doubtful,Loans."Loans Category-SASRA"::Loss);
          Loans.SETFILTER("Outstanding Balance",'>0');
          IF Loans.FINDFIRST THEN BEGIN
              LoanProductsSetup.GET(Loans."Loan Product Type");

              Return:='ERROR::::Your '+LoanProduct."USSD Product Name"+' request on '+DateTimeToText(CURRENTDATETIME)+' has failed, You have defaulted '+LoanProductsSetup."Product Description";
              SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileLoan.No),SavAcc."No.",TRUE,Priority,TRUE);


          END;

              Members.CALCFIELDS("Shares Retained");
              SaccoSetup.GET;
              SaccoSetup.TESTFIELD("Minimum Share Capital");
              IF SaccoSetup."Minimum Share Capital" > Members."Shares Retained" THEN BEGIN

                Return :='ERROR::::Your '+LoanProduct."USSD Product Name"+' request on '+DateTimeToText(CURRENTDATETIME)+' has failed, You have not contributed enough share capital';
                SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,FORMAT(MobileLoan.No),SavAcc."No.",TRUE,Priority,TRUE);
                EXIT;
              END;


            END
            ELSE BEGIN
                Return := 'ERROR::::Members Not Found';
                EXIT;
            END;



      IF SkyMobileLoans.GET(LoanEntryNo) THEN BEGIN
          LoanType.GET(SkyMobileLoans."Loan Product Type");

          IF Action = 'DISCARD' THEN BEGIN

              HMember.GET(SkyMobileLoans."Member No.");
              FName:=HMember.Name;
              IF FName='' THEN
              FName := HMember.Name;
              Salute:='Dear '+FirstName(FName)+','+NewLine;

              msg:=Salute+'Your '+LoanType."USSD Product Name"+' request on '+DateTimeToText(CURRENTDATETIME)+' has been cancelled.';
              SkyMobileLoans.Remarks:='Loan Discarded';
              SkyMobileLoans.Status:=SkyMobileLoans.Status::Failed;
              SkyMobileLoans.Posted:=TRUE;
              SkyMobileLoans."Date Posted":=CURRENTDATETIME;//TODAY;
              SkyMobileLoans.Message:=msg;
              SendSms(Source::MBANKING,SkyMobileLoans."Telephone No",msg,FORMAT(SkyMobileLoans."Entry No"),'',TRUE,Priority,FALSE);
              SkyMobileLoans.MODIFY;
              Return := 'SUCCESS::::'+msg;
              EXIT;
          END;

          IF SkyMobileLoans."Member No." = Members."No." THEN BEGIN
              Return := 'ERROR::::You are not allowed to guarantee your own loan';
              EXIT;
          END;
          //
          DepAc := '';
          IF LoanType."Minimum Guarantor Deposits" > 0 THEN BEGIN
              MemberLedgerEntry.RESET;
              MemberLedgerEntry.SETRANGE("Customer No.",Members."No.");
              MemberLedgerEntry.SETRANGE("Transaction Type",MemberLedgerEntry."Transaction Type"::"Deposit Contribution");
              IF MemberLedgerEntry.FINDFIRST THEN BEGIN
              END;
                  //MemberLedgerEntry.CALCFIELDS("Amount (LCY)");
      //             DepositAmount := (MemberLedgerEntry.Amount)*-1;
      //             IF DepositAmount < LoanType."Minimum Guarantor Deposits" THEN BEGIN
      //                 Return := 'ERROR::::5'+Members.Name+' is not qualified to Guarantee';
      //                 EXIT;
      //             END;

          END;



          successText := 'Your Request to add '+Members.Name+' has been received successfully';

          MobileLoanGuarantors.RESET;
          MobileLoanGuarantors.SETRANGE("Loan Entry No.",LoanEntryNo);
          MobileLoanGuarantors.SETRANGE("Guarantor Member No.",Members."No.");
          IF MobileLoanGuarantors.FINDFIRST THEN BEGIN
              IF Action = 'REMOVE' THEN BEGIN
                  MobileLoanGuarantors.DELETE;
                  Return := 'SUCCESS::::'+'Your Request to Remove '+Members.Name+' has been received successfully';


                  IF SavAcc.GET(SkyMobileLoans."Account No") THEN BEGIN
                      Priority := 211;
                      msg := 'Dear '+FORMAT(SkyMobileLoans."Account Name")+NewLine+'You have removed '+MobileLoanGuarantors."Guarantor Name"+
                      ' from your guarantorship request on '+SkyMobileLoans."Loan Name"+' loan amounting to KES '+FORMAT(SkyMobileLoans.Amount)+' on '+FORMAT(ddMMyyyy(TODAY))+' at '+FORMAT(TIME) +
                      NewLine+'REF: '+FORMAT(SkyMobileLoans."Entry No");
                      SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,SavAcc."No.",'',TRUE,Priority,FALSE);



                      Priority := 211;
                      msg := 'Dear '+FORMAT(MobileLoanGuarantors."Guarantor Name")+NewLine+SkyMobileLoans."Account Name"+
                      ' has cancelled your guarantorship request on '+SkyMobileLoans."Loan Name"+' loan amounting to KES '+FORMAT(SkyMobileLoans.Amount)+' on '+FORMAT(ddMMyyyy(TODAY))+' at '+FORMAT(TIME) +
                      ' Please Accept/Decline By dialing '+UssdCode+'.'+NewLine+'REF: '+FORMAT(SkyMobileLoans."Entry No");
                      SendSms(Source::MBANKING,MobileLoanGuarantors."Guarantor Mobile No.",msg,SavAcc."No.",'',TRUE,Priority,FALSE);

                   END;


              END
              ELSE IF Action = 'ADD' THEN BEGIN
                  MobileLoanGuarantors."Loan Entry No." := LoanEntryNo;
                  MobileLoanGuarantors."Guarantor Mobile No." := MobileNo;
                  MobileLoanGuarantors."Guarantor Dep. A/C":=DepAc;
                  MobileLoanGuarantors.VALIDATE("Guarantor Member No.",Members."No.");
                  MobileLoanGuarantors."Loan Product" := SkyMobileLoans."Loan Product Type";
                  MobileLoanGuarantors."Loan Product Name" := '';
                  MobileLoanGuarantors."Guarantor Name" := Members.Name;
                  MobileLoanGuarantors."Date Created":=CURRENTDATETIME;
                  MobileLoanGuarantors.MODIFY;

                  IF MobileLoanGuarantors."Guarantor Accepted" = MobileLoanGuarantors."Guarantor Accepted"::Pending THEN
                      Return := 'SUCCESS::::'+successText;
                  IF MobileLoanGuarantors."Guarantor Accepted" = MobileLoanGuarantors."Guarantor Accepted"::No THEN BEGIN
                      MobileLoanGuarantors."Guarantor Accepted" := MobileLoanGuarantors."Guarantor Accepted"::Pending;
                      MobileLoanGuarantors.MODIFY;
                      Return := 'SUCCESS::::'+successText;
                  END;
                  IF MobileLoanGuarantors."Guarantor Accepted" = MobileLoanGuarantors."Guarantor Accepted"::Yes THEN BEGIN
                      Return := 'SUCCESS::::'+successText;
                  END;


                  IF SavAcc.GET(SkyMobileLoans."Account No") THEN BEGIN
                      Priority := 211;
                      msg := 'Dear '+FORMAT(SkyMobileLoans."Account Name")+NewLine+'You have Requested '+MobileLoanGuarantors."Guarantor Name"+
                      ' to be your Guarantor on '+SkyMobileLoans."Loan Name"+' amounting to KES '+FORMAT(SkyMobileLoans.Amount)+' on '+FORMAT(ddMMyyyy(TODAY))+' '+FORMAT(TIME) +
                      ' Please notify them to Accept By dialing '+UssdCode+'.'+NewLine+'REF: '+FORMAT(SkyMobileLoans."Entry No");
                      SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,SavAcc."No.",'',TRUE,Priority,FALSE);



                      Priority := 211;
                      msg := 'Dear '+FORMAT(MobileLoanGuarantors."Guarantor Name")+NewLine+', '+SkyMobileLoans."Account Name"+
                      ' is Requesting your Guarantorship on '+SkyMobileLoans."Loan Name"+' amounting to KES '+FORMAT(SkyMobileLoans.Amount)+' on '+FORMAT(ddMMyyyy(TODAY))+' '+FORMAT(TIME) +
                      ' Please Accept by dialing '+UssdCode+', Select Loans Option.'+NewLine+'REF: '+FORMAT(SkyMobileLoans."Entry No");
                      SendSms(Source::MBANKING,MobileLoanGuarantors."Guarantor Mobile No.",msg,SavAcc."No.",'',TRUE,Priority,FALSE);

                   END;


              END;
          END
          ELSE BEGIN
              MobileLoanGuarantors.INIT;
              MobileLoanGuarantors."Loan Entry No." := LoanEntryNo;
              MobileLoanGuarantors."Guarantor Mobile No." := MobileNo;
              MobileLoanGuarantors.VALIDATE("Guarantor Member No.",Members."No.");
              MobileLoanGuarantors."Loan Product" := SkyMobileLoans."Loan Product Type";
              MobileLoanGuarantors."Loan Product Name" := SkyMobileLoans."Loan Name";
              MobileLoanGuarantors."Guarantor Name" := Members.Name;
              MobileLoanGuarantors."Date Created":=CURRENTDATETIME;
              MobileLoanGuarantors.INSERT;
              Return := 'SUCCESS::::'+successText;


              IF SavAcc.GET(SkyMobileLoans."Account No") THEN BEGIN
                  Priority := 211;
                  msg := 'Dear '+FORMAT(SkyMobileLoans."Account Name")+NewLine+'You have Requested '+MobileLoanGuarantors."Guarantor Name"+
                  ' to be your Guarantor on '+SkyMobileLoans."Loan Name"+' amounting to KES '+FORMAT(SkyMobileLoans.Amount)+' on '+FORMAT(ddMMyyyy(TODAY))+' at '+FORMAT(TIME) +
                  ' Please notify them to Accept By dialing '+UssdCode+'.'+NewLine+'REF: '+FORMAT(SkyMobileLoans."Entry No");
                  SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,SavAcc."No.",'',TRUE,Priority,FALSE);



                  Priority := 211;
                  msg := 'Dear '+FORMAT(MobileLoanGuarantors."Guarantor Name")+NewLine+SkyMobileLoans."Account Name"+
                  ' is Requesting your Guarantorship on '+SkyMobileLoans."Loan Name"+' amounting to KES '+FORMAT(SkyMobileLoans.Amount)+' on '+FORMAT(ddMMyyyy(TODAY))+' at '+FORMAT(TIME) +
                  ' Please Accept/Decline By dialing '+UssdCode+'.'+NewLine+'REF: '+FORMAT(SkyMobileLoans."Entry No");
                  SendSms(Source::MBANKING,MobileLoanGuarantors."Guarantor Mobile No.",msg,SavAcc."No.",'',TRUE,Priority,FALSE);

               END;

          END;
      END;

      //END;

      {
      IF SkyMobileLoans.GET(LoanEntryNo) THEN BEGIN
          LoanType.GET(SkyMobileLoans."Loan Product Type");
          LoanCat.GET(LoanType."Product ID",SkyMobileLoans."Micro Loan Category");

          MobileLoanGuarantors.RESET;
          MobileLoanGuarantors.SETRANGE("Loan Entry No.",LoanEntryNo);
          MobileLoanGuarantors.SETRANGE("Guarantor Mobile No.",MobileNo);
          IF MobileLoanGuarantors.FINDFIRST THEN BEGIN
              MobileLoanGuarantors."Loan Entry No." := LoanEntryNo;
              MobileLoanGuarantors."Guarantor Mobile No." := MobileNo;
              MobileLoanGuarantors."Appraisal Deposit Products" := LoanCat."Appraisal Account";
              MobileLoanGuarantors.VALIDATE("Guarantor Member No.",Members."No.");
              MobileLoanGuarantors."Loan Product" := SkyMobileLoans."Loan Product Type";
              MobileLoanGuarantors."Loan Product Name" := '';
              MobileLoanGuarantors."Guarantor Name" := Members.Name;
              MobileLoanGuarantors.MODIFY;

              IF MobileLoanGuarantors."Guarantor Accepted" = MobileLoanGuarantors."Guarantor Accepted"::Pending THEN
                  Return := 'SUCCESS';
              IF MobileLoanGuarantors."Guarantor Accepted" = MobileLoanGuarantors."Guarantor Accepted"::No THEN BEGIN
                  MobileLoanGuarantors."Guarantor Accepted" := MobileLoanGuarantors."Guarantor Accepted"::Pending;
                  MobileLoanGuarantors.MODIFY;
                  Return := 'SUCCESS';
              END;
              IF MobileLoanGuarantors."Guarantor Accepted" = MobileLoanGuarantors."Guarantor Accepted"::Yes THEN BEGIN
                  Return := 'SUCCESS';
              END;
          END
          ELSE BEGIN
              MobileLoanGuarantors.INIT;
              MobileLoanGuarantors."Loan Entry No." := LoanEntryNo;
              MobileLoanGuarantors."Guarantor Mobile No." := MobileNo;
              MobileLoanGuarantors."Appraisal Deposit Products" := LoanCat."Appraisal Account";
              MobileLoanGuarantors.VALIDATE("Guarantor Member No.",Members."No.");
              MobileLoanGuarantors."Loan Product" := SkyMobileLoans."Loan Product Type";
              MobileLoanGuarantors."Loan Product Name" := '';
              MobileLoanGuarantors."Guarantor Name" := Members.Name;
              MobileLoanGuarantors.INSERT;
              Return := 'SUCCESS';
          END;
      END;
      }
    END;

    LOCAL PROCEDURE GetLoanNoFromProduct@160(MemberNo@1000 : Code[20];LoanProduct@1001 : Code[20];VAR LoanBalance@1004 : Decimal) LoanNo : Code[20];
    VAR
      LoanType@1002 : Record 51516240;
      Loans@1003 : Record 51516230;
    BEGIN
      LoanBalance := 0;
      LoanNo := '';

      LoanType.GET(LoanProduct);

      Loans.RESET;
      Loans.SETRANGE("Client Code",MemberNo);
      Loans.SETRANGE("Loan Product Type",LoanProduct);
      Loans.SETFILTER("Outstanding Balance",'<>0');
      IF Loans.FINDFIRST THEN BEGIN
          REPEAT
              Loans.CALCFIELDS("Outstanding Balance");
              LoanBalance += Loans."Outstanding Balance";
              LoanNo := Loans."Loan  No.";
          UNTIL Loans.NEXT = 0;
      END;

      IF LoanBalance <= 0 THEN BEGIN
          LoanBalance := 0;
          LoanNo := '';
      END;
    END;

    PROCEDURE SplitKeyWord@194(AccountNo@1001 : Code[20];VAR KeyWord@1005 : Code[20];VAR ProductID@1002 : Code[20];VAR MNo@1003 : Code[20]);
    VAR
      ProdFact@1000 : Record 51516717;
      ProdLength@1004 : Integer;
      Savings@1006 : Record 23;
    BEGIN

      ProductID := '';
      MNo := '';

      ProdFact.RESET;
      ProdFact.SETRANGE("Product Class Type",ProdFact."Product Class Type"::Savings);
      IF ProdFact.FINDFIRST THEN BEGIN
          REPEAT
              ProdLength := STRLEN(ProdFact."Key Word");
              KeyWord := COPYSTR(AccountNo,1,ProdLength);
              IF KeyWord = ProdFact."Key Word" THEN BEGIN
                  MNo := COPYSTR(AccountNo,ProdLength+1,STRLEN(AccountNo));
                  ProductID := ProdFact."Product ID";


                  Savings.RESET;
                  Savings.SETRANGE("ID No.",MNo);
                  IF Savings.FINDFIRST THEN BEGIN

                      MNo := Savings."BOSA Account No";
                  END
                  ELSE
                      MNo := '';

              END;
          UNTIL (ProdFact.NEXT = 0) OR (MNo<>'');
      END;
    END;

    PROCEDURE EmployerRestriction@94(PhoneNo@1015 : Code[20];Transaction@1000000000 : Text) Restricted : Boolean;
    VAR
      TransactionType@1000 : ' ,Withdrawal,Deposit,Utility Payment,Loan Repayment,Balance Enquiry,Mini-Statement,Loan Disbursement,Account Transfer,Pay Loan From Account,Paybill,Mobile App Login,Bank Transfer,Airtime';
      SavAcc@1001 : Record 23;
    BEGIN
      Restricted := TRUE;
      PhoneNo := '+'+PhoneNo;


      IF Transaction = 'Balance Enquiry' THEN
        TransactionType:=TransactionType::"Balance Enquiry";

      IF Transaction = 'Loan Repayment' THEN
        TransactionType:=TransactionType::"Loan Repayment";

      IF Transaction = 'Mini-Statement' THEN
        TransactionType:=TransactionType::"Mini-Statement";

      IF Transaction = 'Deposit' THEN
        TransactionType:=TransactionType::Deposit;

      IF Transaction = 'Withdrawal' THEN
        TransactionType:=TransactionType::Withdrawal;


      IF Transaction = 'Utility Request' THEN
        TransactionType:=TransactionType::"Utility Payment";

      IF Transaction = 'Utility Payment' THEN
        TransactionType:=TransactionType::"Utility Payment";

      IF Transaction = 'Withdrawal Request' THEN
        TransactionType:=TransactionType::Withdrawal;

      IF Transaction = 'Paybill' THEN
        TransactionType:=TransactionType::Paybill;


      IF Transaction = 'Bank Transfer' THEN
        TransactionType:=TransactionType::"Bank Transfer";


      IF Transaction = 'Bank Transfer Request' THEN
        TransactionType:=TransactionType::"Bank Transfer";

      CoopSetup.RESET;
      CoopSetup.SETRANGE("Transaction Type",TransactionType);
      IF CoopSetup.FINDFIRST THEN BEGIN
          SavAcc.RESET;
          SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
          IF SavAcc.FINDFIRST THEN BEGIN
              IF CoopSetup."Restrict to Employer" = '' THEN
                  Restricted := FALSE
              ELSE BEGIN
                  IF SavAcc."Company Code" = CoopSetup."Restrict to Employer" THEN
                      Restricted := FALSE;
              END;
          END;
      END;
    END;

    PROCEDURE SufficientBalance@25(Transaction@1018 : Text;PhoneNo@1015 : Code[20];PIN@1042 : Text) Response : Text;
    VAR
      SaccoFee@1033 : Decimal;
      VendorCommission@1032 : Decimal;
      TotalCharge@1031 : Decimal;
      SavAcc@1030 : Record 23;
      SaccoAccount@1029 : Code[20];
      VendorAccount@1028 : Code[20];
      AccBal@1026 : Decimal;
      JTemplate@1024 : Code[10];
      JBatch@1023 : Code[10];
      MobileTrans@1022 : Record 51516712;
      DocNo@1021 : Code[20];
      PDate@1020 : Date;
      AcctType@1019 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      BalAccType@1017 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
      TransType@1016 : ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal';
      TransactionType@1041 : ' ,Withdrawal,Deposit,Utility Payment,Loan Repayment,Balance Enquiry,Mini-Statement,Loan Disbursement,Account Transfer,Pay Loan From Account,Paybill,Mobile App Login,Bank Transfer,Airtime';
      AccNo@1014 : Code[20];
      BalAccNo@1013 : Code[20];
      SourceType@1012 : 'New Member,New Account,Loan Account Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit, Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued';
      ExtDoc@1010 : Code[20];
      LoanNo@1009 : Code[20];
      Dim1@1008 : Code[20];
      Dim2@1007 : Code[20];
      SystCreated@1006 : Boolean;
      SLedger@1005 : Record 25;
      LedgerCount@1004 : Integer;
      CurrRecord@1003 : Integer;
      DFilter@1002 : Text;
      DebitCreditFlag@1001 : Code[10];
      FirstEntry@1000 : Boolean;
      ProdFact@1034 : Record 51516717;
      AccountBookBalance@1035 : Decimal;
      AccountAvailableBalance@1036 : Decimal;
      AccountToCharge@1037 : Code[20];
      Found@1027 : Boolean;
      MemberNo@1038 : Code[20];
      TransactionDate@1011 : DateTime;
      Loans@1039 : Record 51516230;
      LoanType@1040 : Text;
      BalStmt@1043 : Text;
      msg@1044 : Text;
      SafcomCharges@1045 : Record 51516708;
      SafcomFee@1046 : Decimal;
      BalEnqCharge@1047 : Decimal;
      AccountBal@1025 : Decimal;
      LoanProductTypes@1048 : Record 51516240;
      LBal@1049 : Decimal;
      AccountType@1120054000 : Record 51516295;
    BEGIN

      IF Transaction = 'Balance Enquiry' THEN
        TransactionType:=TransactionType::"Balance Enquiry";

      IF Transaction = 'Loan Repayment' THEN
        TransactionType:=TransactionType::"Loan Repayment";

      IF Transaction = 'Mini-Statement' THEN
        TransactionType:=TransactionType::"Mini-Statement";

      IF Transaction = 'Deposit' THEN
        TransactionType:=TransactionType::Deposit;

      IF Transaction = 'Withdrawal' THEN
        TransactionType:=TransactionType::Withdrawal;


      IF Transaction = 'Utility Request' THEN
        TransactionType:=TransactionType::"Utility Payment";

      IF Transaction = 'Utility Payment' THEN
        TransactionType:=TransactionType::"Utility Payment";

      IF Transaction = 'Airtime Request' THEN
        TransactionType:=TransactionType::Airtime;

      IF Transaction = 'Airtime Purchase' THEN
        TransactionType:=TransactionType::Airtime;

      IF Transaction = 'Withdrawal Request' THEN
        TransactionType:=TransactionType::Withdrawal;

      IF Transaction = 'Paybill' THEN
        TransactionType:=TransactionType::Paybill;


      IF Transaction = 'Bank Transfer' THEN
        TransactionType:=TransactionType::"Bank Transfer";


      IF Transaction = 'Bank Transfer Request' THEN
        TransactionType:=TransactionType::"Bank Transfer";


      TransactionDate := CURRENTDATETIME;

      Response:='ERROR';
      Found:=FALSE;


      PhoneNo := '+'+PhoneNo;

      IF NOT CorrectPin(PhoneNo,PIN) THEN BEGIN
          Response := 'INCORRECT_PIN';
          EXIT;
      END;


      AccountToCharge:='';
      MemberNo:='';

      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
      SavAcc.SETRANGE("Account Type",'ORDINARY');
      IF SavAcc.FINDFIRST THEN BEGIN
          AccountToCharge:=SavAcc."No.";
          MemberNo:=SavAcc."BOSA Account No";
          IF SavAcc.Blocked<>SavAcc.Blocked::" " THEN
            EXIT;
      END;


      IF MemberNo='' THEN
          EXIT('Member No. Missing');

      IF AccountToCharge='' THEN
          EXIT('Account to charge missing');


      // Get Excise duty G/L
      ExciseDutyGL := GetExciseDutyGL();
      ExciseDutyRate := GetExciseRate();
      ExciseDuty:=0;

      SaccoAccount:='';
      SaccoFee:=0;
      VendorAccount:='';
      VendorCommission:=0;


      SMSAccount:='';
      SMSCharge:=0;


      CoopSetup.RESET;
      CoopSetup.SETRANGE("Transaction Type",CoopSetup."Transaction Type"::"Balance Enquiry");
      IF CoopSetup.FINDFIRST THEN BEGIN

          SMSAccount := CoopSetup."SMS Account";
          SMSCharge := CoopSetup."SMS Charge";


          SaccoAccount := CoopSetup."Sacco Fee Account";
          SaccoFee := CoopSetup."Sacco Fee";
          VendorAccount:=CoopSetup."Vendor Commission Account";
          VendorCommission:=CoopSetup."Vendor Commission";

          GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,Safcom,0);
          TotalCharge:=SaccoFee+VendorCommission+SMSCharge;
          ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);
          ExciseDuty:=0;
      END
      ELSE BEGIN
          ERROR('Setup Missing for %1',CoopSetup."Transaction Type");
      END;



      IF SavAcc.GET(AccountToCharge) THEN BEGIN
          AccountType.GET(SavAcc."Account Type");


          IF (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::"Deposits Only") OR
              (AccountType."Mobile Transaction" = AccountType."Mobile Transaction"::" ") THEN BEGIN
              ERROR('The Account to Charge is not a Withdrawable Account');

          END;



          BalEnqCharge:=0;
          AccBal := GetAccountBalance(SavAcc."No.");
          IF AccBal >= TotalCharge+ExciseDuty THEN BEGIN
              Response:='SUCCESS';

          END
          ELSE BEGIN
              Response:='INSUFFICIENT_BAL';
          END;
      END
      ELSE BEGIN
          Response:='INVALID_ACCOUNT';
      END;
    END;

    LOCAL PROCEDURE GetSMSPriority@11(Category@1000 : Text) Priority : Integer;
    BEGIN
      IF(Category = 'ATM_COLLECTION') THEN
          Priority := 211
      ELSE IF(Category = 'B2B_WITHDRAWAL') THEN
          Priority := 211
      ELSE IF(Category = 'CASH_WITHDRAWAL_CONFIRM') THEN
          Priority := 211
      ELSE IF(Category = 'DEPOSIT_CONFIRMATION') THEN
          Priority := 220
      ELSE IF(Category = 'FIXED_DEPOSIT_MATURITY') THEN
          Priority := 240
      ELSE IF(Category = 'LOAN_APPLICATION') THEN
          Priority := 230
      ELSE IF(Category = 'LOAN_DEFAULTED') THEN
          Priority := 240
      ELSE IF(Category = 'LOAN_GUARANTORS') THEN
          Priority := 240
      ELSE IF(Category = 'LOAN_POSTED') THEN
          Priority := 240
      ELSE IF(Category = 'LOW_FLOAT_ALERT') THEN
          Priority := 203
      ELSE IF(Category = 'LOW_FLOAT_INFO') THEN
          Priority := 202
      ELSE IF(Category = 'LOW_FLOAT_MIN') THEN
          Priority := 200
      ELSE IF(Category = 'LOW_FLOAT_WARNING') THEN
          Priority := 204
      ELSE IF(Category = 'MAPP_ACTIVATION') THEN
          Priority := 200
      ELSE IF(Category = 'MAPP_DEACTIVATION') THEN
          Priority := 205
      ELSE IF(Category = 'MBANKING') THEN
          Priority := 220
      ELSE IF(Category = 'MEMBER_CHANGES') THEN
          Priority := 240
      ELSE IF(Category = 'BULK') THEN
          Priority := 240
      ELSE IF(Category = 'MOBILE_PIN') THEN
          Priority := 208
      ELSE IF(Category = 'NEW_ACCOUNT') THEN
          Priority := 230
      ELSE IF(Category = 'NEW_MEMBER') THEN
          Priority := 230
      ELSE IF(Category = 'ONE_TIME_PASSWORD') THEN
          Priority := 200
      ELSE IF(Category = 'MOBILE_PIN') THEN
          Priority := 200
      ELSE IF(Category = 'SALARY_PROCESSING') THEN
          Priority := 245
      ELSE IF(Category = 'WITHDRAWAL') THEN
          Priority := 214
      ELSE IF(Category = 'LOAN_ACCOUNT_APPROVAL') THEN
          Priority := 245
      ELSE IF(Category = 'LOAN_APPRAISAL') THEN
          Priority := 230
      ELSE IF(Category = 'LOAN_REJECTED') THEN
          Priority := 225
      ELSE IF(Category = 'TELLER_CASH_DEPOSIT') THEN
          Priority := 215
      ELSE IF(Category = 'TELLER_CAS') THEN
          Priority := 225
      ELSE
          Priority := 250;
    END;

    PROCEDURE CheckAvailableBalance@59(AccountNo@1021 : Code[20];Amount@1015 : Decimal) Response : Text[1024];
    VAR
      SaccoFee@1000 : Decimal;
      VendorCommission@1001 : Decimal;
      TransactionType@1002 : ' ,Withdrawal,Deposit,Utility Payment,Loan Repayment,Balance Enquiry,Mini-Statement,Loan Disbursement,Account Transfer,Pay Loan From Account,Paybill,Mobile App Login,Bank Transfer,Airtime';
      TotalCharge@1003 : Decimal;
      SavAcc@1004 : Record 23;
      MpesaTrans@1005 : Record 51516712;
      Continue@1008 : Boolean;
      MobileWithdrawalsBuffer@1009 : Record 51516714;
      AccBal@1010 : Decimal;
      SafcomCharges@1013 : Record 51516708;
      SafcomAcc@1014 : Code[20];
      SafcomFee@1016 : Decimal;
      TransactionDate@1011 : DateTime;
      MemberID@1006 : Code[20];
      PrePaymentGL@1018 : Code[20];
      Loans@1022 : Record 51516230;
      LoanNo@1007 : Code[20];
      MemberNo@1023 : Code[20];
      Type@1024 : 'Daily,Weekly,Monthly';
      Limit@1025 : Decimal;
      msg@1026 : Text;
      SavingsProduct@1027 : Code[20];
      LoanProduct@1028 : Code[20];
      ProductFactory@1029 : Record 51516717;
      KeyWord@1030 : Code[10];
      KeyFound@1031 : Boolean;
      ProductID@1032 : Code[20];
      MNo@1033 : Code[20];
    BEGIN


      TransactionType:=TransactionType::Withdrawal;

      // Get Excise duty G/L
      ExciseDutyGL := GetExciseDutyGL();
      ExciseDutyRate := GetExciseRate();
      ExciseDuty:=0;

      SafcomFee:=0;
      SaccoFee:=0;
      VendorCommission:=0;
      PrePaymentGL:='';
      SMSAccount:='';
      SMSCharge:=0;

      CoopSetup.RESET;
      CoopSetup.SETRANGE("Transaction Type",TransactionType);
      IF CoopSetup.FINDFIRST THEN BEGIN


          SMSAccount := CoopSetup."SMS Account";
          SMSCharge := CoopSetup."SMS Charge";

          IF TransactionType = TransactionType::Withdrawal THEN BEGIN
              SafcomCharges.RESET;
              SafcomCharges.SETFILTER(Charge,'>0');
              SafcomCharges.SETFILTER(Minimum,'<%1',Amount);
              SafcomCharges.SETFILTER(Maximum,'>%1',Amount);
              IF SafcomCharges.FINDFIRST THEN BEGIN
                  SafcomFee:=SafcomCharges.Charge;
              END;
          END;

          PrePaymentGL := CoopSetup."Pre-Payment Account";
          SaccoFee := CoopSetup."Sacco Fee";
          VendorCommission:=CoopSetup."Vendor Commission";

          GetCharges(CoopSetup."Transaction Type",VendorCommission,SaccoFee,SafcomFee,Amount);
          MESSAGE('SaccoFee %1\VendorCommission %2\SafcomFee %3\SMSCharge  %4\',SaccoFee,VendorCommission,SafcomFee,SMSCharge);
          TotalCharge:=SaccoFee+VendorCommission+SafcomFee+SMSCharge;
          ExciseDuty:=ROUND((SaccoFee+SMSCharge)*ExciseDutyRate/100);

      END
      ELSE BEGIN
          ERROR('Setup Missing for %1');
      END;


      MemberID:='';


      IF NOT  SavAcc.GET(AccountNo) THEN BEGIN
          ProductID := '';
          MNo:='';
          SplitAccount(AccountNo,ProductID,MNo);
          IF MNo <> '' THEN BEGIN

              SavAcc.GET(MNo);
              MemberID := SavAcc."ID No.";
              AccountNo := SavAcc."No.";
              SavingsProduct := ProductID;

          END
      END;

      MESSAGE(AccountNo);


      IF SavAcc.GET(AccountNo) THEN BEGIN

          IF (SavAcc.Status <> SavAcc.Status::Active) OR (SavAcc.Blocked <> SavAcc.Blocked::" ") THEN BEGIN
              Response:='ACCOUNT_NOT_ACTIVE';
              EXIT;
          END;

          AccBal := GetAccountBalance(SavingsProduct+SavAcc."No.");
          MESSAGE('TotalCharge %1 ExciseDuty %2',TotalCharge,ExciseDuty);
          IF (AccBal >= Amount+TotalCharge+ExciseDuty) THEN BEGIN

              Response:='SUCCESS%&:'+SavAcc.Name;
          END
          ELSE BEGIN
              Response:='INSUFFICIENT_BAL';
          END;


      END
      ELSE
        ERROR('Account Not Found');
    END;

    PROCEDURE GetLoansGuaranteed@16(TransactionID@1009 : Code[20];Phone@1000 : Code[20]) Response : Text;
    VAR
      MobileNo@1001 : Code[20];
      Loans@1002 : Record 51516230;
      LoanProduct@1003 : Record 51516240;
      SavAcc@1004 : Record 23;
      MemberNo@1005 : Code[20];
      MaxLoan@1006 : Decimal;
      LoanGuarantors@1007 : Record 51516231;
      Members@1008 : Record 51516223;
      DefAmt@1010 : Decimal;
    BEGIN
      MobileNo := '+'+Phone;

      Response:='';

      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FINDFIRST THEN BEGIN
          MemberNo := SavAcc."No.";

          LoanGuarantors.RESET;
          LoanGuarantors.SETRANGE("Member No",MemberNo);
      //    LoanGuarantors.SETFILTER("Outstanding Balance",'>0');
          IF LoanGuarantors.FIND('-') THEN BEGIN
              Response:='<Security>';
              CheckDate := TODAY;
              RemInst := 0;
              {WHILE CheckDate < Loans."Expected Date of Completion" DO BEGIN
                  RemInst+=1;
                  CheckDate:=CALCDATE('1M',CheckDate);
              END;}
              LGCount := LoanGuarantors.COUNT;
              IF(LGCount = 0) THEN
                  LGCount := 1;
              REPEAT
                  IF Loans.GET(LoanGuarantors."Loan No") THEN BEGIN

                      Loans.CALCFIELDS("Outstanding Balance");
                      IF Loans."Outstanding Balance" > 0 THEN BEGIN
                          LoanProduct.GET(Loans."Loan Product Type");
                          DefAmt:=0;

                          Response += '<Loan>';
                            Response += '<Loanee>'+Loans."Client Name"+'</Loanee>';
                            Response += '<LoanNo>'+Loans."Loan  No."+'</LoanNo>';
                            Response += '<LoanType>'+LoanProduct."USSD Product Name"+'</LoanType>';
                            //Response += '<RemainingInstallment>'+FORMAT(Loans."Expected Date of Completion")+'</RemainingInstallment>';
                            MobileNo:='';
                            IF Members.GET(LoanGuarantors."Member No") THEN BEGIN
                              MobileNo := Members."Mobile Phone No";
                            END;
                            Response += '<MobileNo>'+MobileNo+'</MobileNo>';
                            //Response += '<GuarantorType>'+FORMAT(LoanGuarantors."Guarantor Type")+'</GuarantorType>';
                            Response += '<IssuedDate>'+FORMAT(Loans."Issued Date")+'</IssuedDate>';
                            Response += '<EndDate>'+FORMAT(Loans."Expected Date of Completion")+'</EndDate>';
                            Loans.CALCFIELDS({"Loans Category-SASRA",}"Outstanding Balance");
                            IF (Loans."Loans Category-SASRA" = Loans."Loans Category-SASRA"::Perfoming) OR
                                (Loans."Loans Category-SASRA" = Loans."Loans Category-SASRA"::Watch) THEN
                                Response += '<Status>Performing</Status>'
                            ELSE
                                Response += '<Status>Defaulter</Status>';
                            Response += '<LoanAmount>'+FORMAT(Loans."Approved Amount")+'</LoanAmount>';
                            Response += '<Installments>'+FORMAT(Loans.Installments)+'</Installments>';
                            Response += '<LoanBalance>'+FORMAT(Loans."Outstanding Balance")+'</LoanBalance>';
                            //Response += '<DefaultedAmount>'+FORMAT(Loans."Amount in Arrears")+'</DefaultedAmount>';

                            Response += '<AmountGuaranteed>'+FORMAT(ROUND(LoanGuarantors."Amont Guaranteed"))+'</AmountGuaranteed>';
                            Response += '<CurrentCommitment>'+FORMAT(ROUND(LoanGuarantors."Amount Committed"))+'</CurrentCommitment>';

                          Response += '</Loan>';
                      END;
                  END;

              UNTIL LoanGuarantors.NEXT=0;
              Response+='</Security>';

          END;

      END
      ELSE BEGIN
          Response:='<Response>';
            Response+='<Status>ACC_NOT_FOUND</Status>';
            Response+='<StatusDescription>Member Account not found</StatusDescription>';
            Response+='<Reference>'+TransactionID+'</Reference>';
          Response+='</Response>';
      END;
    END;

    PROCEDURE MoveCreditRatingEnries@1120054004();
    VAR
      CreditRating@1120054000 : Record 51516718;
      MobileLoans@1120054001 : Record 51516094;
      LoansRegister@1120054002 : Record 51516230;
    BEGIN

      MobileLoans.RESET;
      IF MobileLoans.FINDFIRST THEN BEGIN
          REPEAT
              IF NOT CreditRating.GET(MobileLoans."Document No") THEN BEGIN
                  CreditRating.INIT;
                  CreditRating."Loan No." := MobileLoans."Document No";
                  CreditRating."Document Date"  := MobileLoans."Document Date";
                  CreditRating."Loan Amount" := MobileLoans."Loan Amount";
                  CreditRating."Date Entered" := MobileLoans."Date Entered";
                  CreditRating."Time Entered" := MobileLoans."Time Entered";
                  CreditRating."Entered By" := MobileLoans."Entered By";
                  CreditRating."Account No" := MobileLoans."Account No";
                  CreditRating."Member No" := MobileLoans."Member No";
                  CreditRating."Telephone No" := MobileLoans."Telephone No";
                  CreditRating."Customer Name" := MobileLoans."Customer Name";
                  CreditRating.Comments := MobileLoans.Comments;
                  CreditRating."Entry No" := MobileLoans."Entry No";
                  CreditRating."Next Loan Application Date" := MobileLoans."Penalty Date";
                  CreditRating.Penalized := MobileLoans.Penalized;
                  IF MobileLoans."Penalty Date" <> 0D THEN
                  CreditRating."Penalty Date" := CALCDATE('-2Y',MobileLoans."Penalty Date");
                  IF MobileLoans."Ist Notification" THEN BEGIN
                  CreditRating."Last Notification" := CreditRating."Last Notification"::"1";
                      CreditRating."Next Notification" := CreditRating."Next Notification"::"2";
                  END;
                  IF MobileLoans."2nd Notification" THEN BEGIN
                  CreditRating."Last Notification" := CreditRating."Last Notification"::"2";
                      CreditRating."Next Notification" := CreditRating."Next Notification"::"3";
                  END;
                  IF MobileLoans."3rd Notification" THEN BEGIN
                  CreditRating."Last Notification" := CreditRating."Last Notification"::"3";
                      CreditRating."Next Notification" := CreditRating."Next Notification"::"4";
                  END;
                  IF MobileLoans."4th Notification" THEN BEGIN
                  CreditRating."Last Notification" := CreditRating."Last Notification"::"4";
                      CreditRating."Next Notification" := CreditRating."Next Notification"::"5";
                  END;
                  IF MobileLoans."5th Notification" THEN BEGIN
                  CreditRating."Last Notification" := CreditRating."Last Notification"::"5";
                      CreditRating."Next Notification" := CreditRating."Next Notification"::"6";
                  END;

                  IF LoansRegister.GET(CreditRating."Loan No.") THEN
                      CreditRating."Loan Product Type" := LoansRegister."Loan Product Type";


                  CreditRating."Loan Limit" := MobileLoans."Loan Amount";
                  IF CreditRating."Loan Product Type" = '' THEN
                    CreditRating."Loan Product Type" := 'A03';
                  CreditRating.INSERT;
              END;
          UNTIL MobileLoans.NEXT=0;
      END;
    END;

    PROCEDURE RegisterVirtualMember@1120054000(Name@1000 : Text;"National ID Number"@1001 : Text;"Mobile Number"@1002 : Text;"Date of Birth"@1005 : Date;Referee@1006 : Text;"Entry Number"@1010 : Text) Response : Text;
    VAR
      SkyAuth@1003 : Record 51516709;
      SavAcc@1000000000 : Record 23;
      MobileNo@1004 : Text;
      VirtualMemberRegBuffer@1007 : Record 51516719;
      RefereeMobileNo@1008 : Text;
    ;
    BEGIN
      Response := 'ERROR';
      MobileNo := '+'+"Mobile Number";
      RefereeMobileNo := '+'+Referee;
      VirtualMemberRegBuffer.RESET;
      VirtualMemberRegBuffer.SETRANGE(VirtualMemberRegBuffer."Mobile Number", MobileNo);
      IF NOT VirtualMemberRegBuffer.FIND('-') THEN BEGIN
        SavAcc.RESET;
        SavAcc.SETRANGE(SavAcc."Mobile Phone No", MobileNo);
        IF NOT VirtualMemberRegBuffer.FIND('-') THEN BEGIN
          VirtualMemberRegBuffer.RESET;
          VirtualMemberRegBuffer."Entry Number" := "Entry Number";
          VirtualMemberRegBuffer."Date Created" := CURRENTDATETIME;
          VirtualMemberRegBuffer.Name := Name;
          VirtualMemberRegBuffer."Mobile Number" := MobileNo;
          VirtualMemberRegBuffer."National ID Number" := "National ID Number";
          VirtualMemberRegBuffer."Date of Birth" := "Date of Birth";

          SavAcc.RESET;
          SavAcc.SETRANGE(SavAcc."Mobile Phone No", RefereeMobileNo);
          IF SavAcc.FIND('-') THEN BEGIN
            VirtualMemberRegBuffer."Referee Name" := SavAcc.Name;
            VirtualMemberRegBuffer."Referee Member Number" := SavAcc."BOSA Account No";
          END
          ELSE BEGIN
            VirtualMemberRegBuffer."Referee Name" := '';
            VirtualMemberRegBuffer."Referee Member Number" := '';
          END;

          VirtualMemberRegBuffer.INSERT;
          Response := 'SUCCESS';
        END
        ELSE BEGIN
          Response := 'MEMBER_EXISTS';
        END;
      END
      ELSE BEGIN
        Response := 'ENTRY_EXISTS';
      END;
    END;

    PROCEDURE UpdateVirtualMemberRegistration@99("Image Entry Number"@1002 : Text;"Image Path"@1000 : Text;"Registration Entry Number"@1001 : Text;"Image Type"@1003 : Text) Response : Text;
    VAR
      VirtualMemberRegImages@1000000000 : Record 51516720;
      MobileNo@1004 : Text;
      VirtualMemberRegBuffer@1007 : Record 51516719;
      RefereeMobileNo@1008 : Text;
    BEGIN
      Response := 'ERROR';
      VirtualMemberRegBuffer.RESET;
      VirtualMemberRegBuffer.SETRANGE(VirtualMemberRegBuffer."Entry Number", "Registration Entry Number");
      IF VirtualMemberRegBuffer.FIND('-') THEN BEGIN
        VirtualMemberRegImages.RESET;
        VirtualMemberRegImages."Image Entry Number" := "Image Entry Number";
        VirtualMemberRegImages."Image Path" := "Image Path";
        VirtualMemberRegImages.Type := "Image Type";

        VirtualMemberRegImages."Registration Entry Number" := "Registration Entry Number";
        VirtualMemberRegImages.INSERT;
      END
      ELSE BEGIN
        Response := 'ENTRY_DOES_NOT_EXIST';
      END;
    END;

    PROCEDURE GetVirtualMemberRegistrationImagesPath@101() Response : Text;
    BEGIN
      GeneralLedgerSetup.GET;
      GeneralLedgerSetup.TESTFIELD("Virtual Members Images Path");
      Response := GeneralLedgerSetup."Virtual Members Images Path";
    END;

    PROCEDURE GetLoanLimitValue@1120054001(PhoneNo@1009 : Code[20];LoanProductType@1001 : Code[20]) Response : Text;
    VAR
      SavAcc@1000 : Record 23;
      PFact@1002 : Record 51516717;
      xmlWriter@1008 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlTextWriter";
      EncodingText@1007 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
      XMLDOMMgt@1006 : Codeunit 6224;
      BodyContentXmlDoc@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      EnvelopeXmlNode@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      CreatedXmlNode@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      MaxLoan@1010 : Decimal;
      msg@1011 : Text;
      LoanType@1120054000 : Record 51516240;
      LoanLimit@1120054001 : Decimal;
      Status@1120054002 : Text;
      K@1120054003 : Boolean;
      PenaltyCounter@1120054004 : Record 51516443;
      LoansRegister@1120054005 : Record 51516230;
      MemberLedgerEntry@1120054006 : Record 51516224;
      NumberOfMonths@1120054007 : Integer;
      DayLoanPaid@1120054008 : Date;
      Continue@1120054009 : Boolean;
    BEGIN

      PhoneNo := '+'+PhoneNo;


      Response:='<Response>';


      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FINDFIRST THEN BEGIN
              LoanLimit :=0;
        MaxLoan:=0;
          IF LoanType.GET(LoanProductType) THEN BEGIN
            IF (LoanType.Code = 'A03') OR (LoanType.Code = 'A16') THEN
              MaxLoan:=GetLoanQualifiedAmount(SavAcc."No.",LoanProductType,msg,LoanLimit);//here

            IF LoanType.Code = 'A01' THEN
             MaxLoan:=GetSalaryLoanQualifiedAmount(SavAcc."No.",LoanProductType,LoanLimit,msg);

            IF LoanType.Code = 'A10' THEN
             MaxLoan:=GetReloadedLoanQualifiedAmount(SavAcc."No.",LoanProductType,LoanLimit,msg);

              IF MaxLoan > 0 THEN
                Status := 'QUALIFIED'
              ELSE
                Status := 'NOT_QUALIFIED';
              /////////


              Response+='<Status>'+Status+'</Status>';
              Response+='<LoanLimit>'+FORMAT(LoanLimit)+'</LoanLimit>';
              Response+='<QualifiedAmount>'+FORMAT(MaxLoan)+'</QualifiedAmount>';
              Response+='<Message>LoanLimit: '+FORMAT(LoanLimit)+' Qualified Amount: '+FORMAT(MaxLoan)+'</Message>';
              /////////
          END
          ELSE BEGIN
              IF LoanProductType = 'M_OD' THEN BEGIN
                  OverdraftLimit(SavAcc."No.",K,msg,MaxLoan,LoanLimit);

                  IF MaxLoan > 0 THEN
                    Status := 'QUALIFIED'
                  ELSE
                    Status := 'NOT_QUALIFIED';



                  Response+='<Status>'+Status+'</Status>';
                  Response+='<LoanLimit>'+FORMAT(LoanLimit)+'</LoanLimit>';
                  Response+='<QualifiedAmount>'+FORMAT(MaxLoan)+'</QualifiedAmount>';
                  Response+='<Message>OverdraftLimit: '+FORMAT(LoanLimit)+' Qualified Amount: '+FORMAT(MaxLoan)+'</Message>';
              END;
          END;
      END;//***
      Response+='</Response>';
    END;

    LOCAL PROCEDURE UploadMbankingMembers@1120054002();
    VAR
      SurePESAApplications@1120054000 : Record 51516521;
      Vend@1120054001 : Record 23;
      Auth@1120054002 : Record 51516709;
    BEGIN
      SurePESAApplications.RESET;
      SurePESAApplications.SETRANGE(SentToServer,TRUE);
      IF SurePESAApplications.FINDFIRST THEN BEGIN
          REPEAT
          IF Vend.GET(SurePESAApplications."Account No") THEN BEGIN
              Vend."Transactional Mobile No" := SurePESAApplications.Telephone;
              Vend.MODIFY;
              IF NOT Auth.GET(Vend."Transactional Mobile No") THEN BEGIN
                  Auth.INIT;
                  Auth."Mobile No." := Vend."Transactional Mobile No";
                  Auth."Account No." := Vend."No.";
                  Auth."User Status" := Auth."User Status"::Active;
                  Auth.INSERT;
              END;
          END;
          UNTIL SurePESAApplications.NEXT=0;
      END;
    END;

    LOCAL PROCEDURE GetCharges@1120054007(TransType@1120054000 : ' ,Withdrawal,Deposit,Utility Payment,Loan Repayment,Balance Enquiry,Mini-Statement,Loan Disbursement,Account Transfer,Pay Loan From Account,Paybill,Mobile App Login,Bank Transfer,Airtime';VAR VendAmt@1120054001 : Decimal;VAR SaccoAmt@1120054002 : Decimal;VAR ThirdParty@1120054003 : Decimal;TransAmt@1120054004 : Decimal);
    VAR
      StagHeader@1120054005 : Record 51516721;
      StagLines@1120054006 : Record 51516708;
    BEGIN

      CoopSetup.RESET;
      CoopSetup.SETRANGE("Transaction Type",TransType);
      IF CoopSetup.FINDFIRST THEN BEGIN

          IF CoopSetup."Vendor Charge Type" = CoopSetup."Vendor Charge Type"::"Flat Amount" THEN BEGIN
              VendAmt:=CoopSetup."Vendor Commission";
          END
          ELSE IF CoopSetup."Vendor Charge Type" = CoopSetup."Vendor Charge Type"::Percentage THEN BEGIN
              VendAmt:=ROUND(CoopSetup."Vendor Commission"/100*TransAmt,1,'>');
          END
          ELSE IF CoopSetup."Vendor Charge Type" = CoopSetup."Vendor Charge Type"::Staggered THEN BEGIN
              StagHeader.RESET;
              StagHeader.SETRANGE(Code,CoopSetup."Vendor Staggered Code");
              IF StagHeader.FINDFIRST THEN BEGIN

                  StagLines.RESET;
                  StagLines.SETRANGE(Code,StagHeader.Code);
                  StagLines.SETFILTER(Charge,'>0');
                  StagLines.SETFILTER(Minimum,'<=%1',TransAmt);
                  StagLines.SETFILTER(Maximum,'>=%1',TransAmt);
                  IF StagLines.FINDFIRST THEN BEGIN
                      VendAmt:=StagLines.Charge;
                  END;
              END
          END;



          IF CoopSetup."Sacco Charge Type" = CoopSetup."Sacco Charge Type"::"Flat Amount" THEN BEGIN
              SaccoAmt:=CoopSetup."Sacco Fee";
          END
          ELSE IF CoopSetup."Sacco Charge Type" = CoopSetup."Sacco Charge Type"::Percentage THEN BEGIN
              SaccoAmt:=ROUND(CoopSetup."Sacco Fee"/100*TransAmt,1,'>');
          END
          ELSE IF CoopSetup."Sacco Charge Type" = CoopSetup."Sacco Charge Type"::Staggered THEN BEGIN
              StagHeader.RESET;
              StagHeader.SETRANGE(Code,CoopSetup."Sacco Staggered Code");
              IF StagHeader.FINDFIRST THEN BEGIN

                  StagLines.RESET;
                  StagLines.SETRANGE(Code,StagHeader.Code);
                  StagLines.SETFILTER(Charge,'>0');
                  StagLines.SETFILTER(Minimum,'<=%1',TransAmt);
                  StagLines.SETFILTER(Maximum,'>=%1',TransAmt);
                  IF StagLines.FINDFIRST THEN BEGIN
                      SaccoAmt:=StagLines.Charge;
                  END;
              END
          END;




          IF CoopSetup."3rd Party Charge Type" = CoopSetup."3rd Party Charge Type"::"Flat Amount" THEN BEGIN
              ThirdParty:=CoopSetup."Safaricom Fee";
          END
          ELSE IF CoopSetup."3rd Party Charge Type" = CoopSetup."3rd Party Charge Type"::Percentage THEN BEGIN
              ThirdParty:=ROUND(CoopSetup."Safaricom Fee"/100*TransAmt,1,'>');
          END
          ELSE IF CoopSetup."3rd Party Charge Type" = CoopSetup."3rd Party Charge Type"::Staggered THEN BEGIN
              StagHeader.RESET;
              StagHeader.SETRANGE(Code,CoopSetup."3rd Party Staggered Code");
              IF StagHeader.FINDFIRST THEN BEGIN

                  StagLines.RESET;
                  StagLines.SETRANGE(Code,StagHeader.Code);
                  StagLines.SETFILTER(Charge,'>0');
                  StagLines.SETFILTER(Minimum,'<=%1',TransAmt);
                  StagLines.SETFILTER(Maximum,'>=%1',TransAmt);
                  IF StagLines.FINDFIRST THEN BEGIN
                      ThirdParty:=StagLines.Charge;
                  END;
              END
          END;

      END;
    END;

    LOCAL PROCEDURE SendOnboardingSMS@1120054003();
    VAR
      Vendor@1120054000 : Record 23;
      Msg@1120054001 : Text;
      SkyBlackListedAccountNos@1120054002 : Record 51516706;
    BEGIN
      Vendor.RESET;
      Vendor.SETRANGE(Vendor."Transactional Mobile No",'<>%1','');
      IF Vendor.FINDFIRST THEN BEGIN
          REPEAT
              IF NOT CheckBlackList(Vendor."Transactional Mobile No",Vendor."No.",Vendor.Name) THEN BEGIN

              END;
          UNTIL Vendor.NEXT=0;
      END;
    END;

    PROCEDURE SMSAlreadySent@1120054005(Telephone@1102755001 : Text[200];Textsms@1102755002 : Text[250]) Found : Boolean;
    VAR
      EntryNo@1002 : Integer;
      SkySMS@1003 : Record 51516711;
      Category@1005 : Code[100];
    BEGIN
      Found:=FALSE;
      EntryNo:=EntryNo+1;


      IF STRLEN(Telephone) = 13 THEN BEGIN
          Telephone := COPYSTR(Telephone,2,12);
      END;

      IF STRLEN(Telephone) = 10 THEN BEGIN
          IF COPYSTR(Telephone,1,1) = '0' THEN
              Telephone := '254'+COPYSTR(Telephone,2,9);
      END;

      IF STRLEN(Telephone) = 9 THEN BEGIN
          IF COPYSTR(Telephone,1,1) = '7' THEN
              Telephone := '254'+Telephone
      END;


      IF STRLEN(Telephone) = 12 THEN BEGIN

          SkySMS.RESET;
          SkySMS.SETRANGE(receiver,Telephone);
          SkySMS.SETRANGE(msg,Textsms);
          SkySMS.SETRANGE("SMS Date",TODAY);
          IF SkySMS.FINDFIRST THEN
            Found := TRUE;
      END;
    END;

    PROCEDURE SendOnBoardingPIN@1120054012() CurrentUSSDPIN : Text;
    VAR
      SkyworldUSSDAuth@1003 : Record 51516709;
      NewPin@1000 : Text;
      NewIntPin@1001 : Integer;
      SavAcc@1002 : Record 23;
      Msg@1004 : Text;
      Vendor@1120054000 : Record 23;
      J@1120054001 : Integer;
    BEGIN
      {
      SaccoSetup.GET;
      SaccoSetup.TESTFIELD("Mbanking Application Name");
      SaccoSetup.TESTFIELD("USSD Code");

      J:=0;
      Vendor.RESET;
      Vendor.SETFILTER(Vendor."Transactional Mobile No",'<>%1','');
      //Vendor.SETRANGE(Vendor."Company Code",'STAFF');
      //Vendor.SETRANGE(Vendor."No.",'0502-001-08721');
      IF Vendor.FINDFIRST THEN BEGIN
          REPEAT
              IF NOT CheckBlackList(Vendor."Transactional Mobile No",Vendor."No.",Vendor.Name) THEN BEGIN

                  SkyworldUSSDAuth.RESET;
                  SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."Mobile No.",Vendor."Transactional Mobile No");
                  SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."Account No.",Vendor."No.");
                  SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."Pin Sent",FALSE);
                  IF SkyworldUSSDAuth.FINDFIRST THEN BEGIN
                      Priority:=200;
                      REPEAT
                          NewPin:=RandomPIN;
                          SavAcc.RESET;
                          SavAcc.SETRANGE("Transactional Mobile No",SkyworldUSSDAuth."Mobile No.");
                          IF SavAcc.FINDFIRST THEN BEGIN
                              Msg := 'Dear '+SavAcc.Name+' your '+SaccoSetup."Mbanking Application Name"+' PIN is '+NewPin+'. Dial '+SaccoSetup."USSD Code"+' to access this service.';

                              IF NOT SMSAlreadySent(SavAcc."Transactional Mobile No",Msg) THEN BEGIN
                                SendSms(Source::MOBILE_PIN,SkyworldUSSDAuth."Mobile No.",Msg,SavAcc."No.",'',TRUE,Priority,FALSE);

                                SkyworldUSSDAuth."PIN No.":=NewPin;
                                SkyworldUSSDAuth."Pin Sent":=TRUE;
                                SkyworldUSSDAuth."Reset PIN":=FALSE;
                                SkyworldUSSDAuth."Initial PIN Sent":=FALSE;
                                SkyworldUSSDAuth."Force PIN":=TRUE;
                                SkyworldUSSDAuth."PIN Encrypted":=FALSE;
                                SkyworldUSSDAuth.MODIFY;
                                J+=1;
                              END;
                          END;
                      UNTIL SkyworldUSSDAuth.NEXT=0;
                  END;

              END;
          UNTIL Vendor.NEXT=0;
      END;

      MESSAGE('%1 Messages Sent',J);
      }
    END;

    PROCEDURE UpdateLoanAccountNos@1120054011();
    VAR
      Loans@1000 : Record 51516230;
      msg@1001 : Text;
      SavAcc@1002 : Record 23;
      LBal@1003 : Decimal;
      OldLoanNo@1120054000 : Code[20];
      Dummy@1120054003 : Record 51516723;
    BEGIN

      Loans.RESET;
      Loans.SETRANGE(Loans."Loan Product Type",'A03');
      Loans.SETFILTER("Outstanding Balance",'>0');
      IF Loans.FINDFIRST THEN BEGIN
          REPEAT
              IF NOT SavAcc.GET(Loans."Account No") THEN BEGIN
                  IF Members.GET(Loans."Account No") THEN BEGIN
                      Loans."Account No" := Members."FOSA Account";
                      Loans.MODIFY;
                  END;
              END;

              IF Loans."BOSA No" <> Loans."Client Code" THEN BEGIN
                  Loans."BOSA No" := Loans."Client Code";
                  Loans.MODIFY;
              END;

              IF Loans."Loan Status" <> Loans."Loan Status"::Issued THEN BEGIN
                  Loans."Loan Status" := Loans."Loan Status"::Issued;
                  Loans.MODIFY;
              END;

              IF NOT Loans."Mobile Loan" THEN BEGIN
                  Loans."Mobile Loan" := TRUE;
                  Loans.MODIFY;
              END;

          UNTIL Loans.NEXT = 0;
      END;
    END;

    PROCEDURE TestLoanReminders@1120054019(LoanNo@1120054001 : Code[20];UpdateDate@1120054002 : Boolean);
    VAR
      Loans@1000 : Record 51516230;
      msg@1001 : Text;
      SavAcc@1002 : Record 23;
      LBal@1003 : Decimal;
      OldLoanNo@1120054000 : Code[20];
      Dummy@1120054003 : Record 51516723;
    BEGIN

      SaccoSetup.GET;
      SaccoSetup.TESTFIELD("Mbanking Application Name");
      SaccoSetup.TESTFIELD("USSD Code");

      Loans.RESET;
      IF LoanNo <> '' THEN
          Loans.SETRANGE("Loan  No.",LoanNo);
      Loans.SETRANGE(Loans."Loan Product Type",'A03');
      Loans.SETFILTER("Outstanding Balance",'>0');
      //Loans.SETFILTER("Issued Date",'<%1',CALCDATE('-10D',TODAY));
      Loans.SETFILTER("Last Mobile Loan Rem. Date",'<%1',TODAY);
      IF Loans.FINDFIRST THEN BEGIN

          REPEAT

              OldLoanNo := '';
              IF NOT CreditRating.GET(Loans."Loan  No.") THEN BEGIN
                  CreditRating.RESET;
                  CreditRating.SETCURRENTKEY("Date Entered");
                  CreditRating.SETRANGE("Member No",Loans."Client Code");
                  CreditRating.SETRANGE("Loan Product Type",Loans."Loan Product Type");
                  IF CreditRating.FINDLAST THEN BEGIN
                       OldLoanNo := CreditRating."Loan No.";
                  END;
              END;


              IF (CreditRating.GET(Loans."Loan  No.")) OR ((OldLoanNo<>'')AND(CreditRating.GET(OldLoanNo))) THEN BEGIN
                  Loans."Repayment Start Date" := CALCDATE(FORMAT(Loans.Installments)+'M-1D',Loans."Loan Disbursement Date");
                  Loans.CALCFIELDS("Outstanding Balance","Oustanding Interest","Penalty Charged");
                  LBal := ROUND(Loans."Outstanding Balance"+Loans."Oustanding Interest"+Loans."Penalty Charged",1,'>');
                  Priority := 210;
                  Loans."Last Mobile Loan Rem. Date" := TODAY;
                  IF SavAcc.GET(Loans."Account No") THEN BEGIN


                      msg := '';
                      IF CreditRating."Last Notification" = CreditRating."Last Notification"::" " THEN BEGIN
                          IF LoanNo <> '' THEN
                              MESSAGE('Next SMS Date: %1\%2',CALCDATE('15D',Loans."Issued Date"),FORMAT(CreditRating."Next Notification") );

                          IF CALCDATE('15D',Loans."Issued Date") < TODAY THEN BEGIN

                              msg:='Dear '+FirstName(Loans."Client Name")+', your '+Loans."Loan Product Type Name"+' of Kshs '+FORMAT(LBal)+' is due on '+ddMMyyyy(Loans."Repayment Start Date")+'. To pay, Dial '+SaccoSetup."USSD Code"+' or go to  '+
                              SaccoSetup."Mbanking Application Name"+'  App';
                              CreditRating."Last Notification" := CreditRating."Last Notification"::"1";
                              CreditRating."Next Notification" := CreditRating."Next Notification"::"2";

                          END;
                      END
                      ELSE IF (CreditRating."Last Notification" = CreditRating."Last Notification"::"1") AND (CreditRating."Next Notification" = CreditRating."Next Notification"::"2") THEN BEGIN

                          IF LoanNo <> '' THEN
                              MESSAGE('Next SMS Date: %1\%2',CALCDATE('21D',Loans."Issued Date"),FORMAT(CreditRating."Next Notification") );

                          IF CALCDATE('21D',Loans."Issued Date") < TODAY THEN BEGIN
                              msg:='Dear '+FirstName(Loans."Client Name")+', your '+Loans."Loan Product Type Name"+' of Kshs '+FORMAT(LBal)+' is due on '+ddMMyyyy(Loans."Repayment Start Date")+'. Save promtly Borrow Wisely';
                              CreditRating."Last Notification" := CreditRating."Last Notification"::"2";
                              CreditRating."Next Notification" := CreditRating."Next Notification"::"3";
                          END;
                      END
                      ELSE IF (CreditRating."Last Notification" = CreditRating."Last Notification"::"2") AND (CreditRating."Next Notification" = CreditRating."Next Notification"::"3") THEN BEGIN

                          IF LoanNo <> '' THEN
                              MESSAGE('Next SMS Date: %1\%2',CALCDATE('27D',Loans."Issued Date"),FORMAT(CreditRating."Next Notification") );
                          IF CALCDATE('27D',Loans."Issued Date") < TODAY THEN BEGIN
                              msg:='Dear '+FirstName(Loans."Client Name")+', your '+Loans."Loan Product Type Name"+' of Kshs '+FORMAT(LBal)+' is due on '+ddMMyyyy(Loans."Repayment Start Date")+'. Save promtly Borrow Wisely';
                              CreditRating."Last Notification" := CreditRating."Last Notification"::"3";
                              CreditRating."Next Notification" := CreditRating."Next Notification"::"4";
                          END;
                      END
                      ELSE IF (CreditRating."Last Notification" = CreditRating."Last Notification"::"3") AND (CreditRating."Next Notification" = CreditRating."Next Notification"::"4") THEN BEGIN

                          IF LoanNo <> '' THEN
                              MESSAGE('Next SMS Date: %1\%2',CALCDATE('28D',Loans."Issued Date"),FORMAT(CreditRating."Next Notification") );
                          IF CALCDATE('28D',Loans."Issued Date") <= TODAY THEN BEGIN
                              msg:='Dear '+FirstName(Loans."Client Name")+', your '+Loans."Loan Product Type Name"+' of Kshs '+FORMAT(LBal)+' is due on '+ddMMyyyy(Loans."Repayment Start Date")+'. Save promtly Borrow Wisely';
                              CreditRating."Last Notification" := CreditRating."Last Notification"::"4";
                              CreditRating."Next Notification" := CreditRating."Next Notification"::"5";
                          END;
                      END
                      ELSE IF (CreditRating."Last Notification" = CreditRating."Last Notification"::"4") AND (CreditRating."Next Notification" = CreditRating."Next Notification"::"5") THEN BEGIN

                          IF LoanNo <> '' THEN
                              MESSAGE('Next SMS Date: %1\%2',CALCDATE('1M',Loans."Issued Date"),FORMAT(CreditRating."Next Notification") );
                          IF CALCDATE('1M',Loans."Issued Date") <= TODAY THEN BEGIN

                              msg:='Dear '+FirstName(Loans."Client Name")+', your '+Loans."Loan Product Type Name"+' of Kshs '+FORMAT(LBal)+' is due today - '+ddMMyyyy(Loans."Repayment Start Date")+
                              '. Kindly pay to avoid recovery from your salary and being barred from future transactions.';
                              CreditRating."Last Notification" := CreditRating."Last Notification"::"5";
                              CreditRating."Next Notification" := CreditRating."Next Notification"::"6";
                          END;
                      END;

                      IF msg <>'' THEN BEGIN
                          Dummy.INIT;
                          Dummy.GUID := CREATEGUID;
                          Dummy."Loan No." := Loans."Loan  No.";
                          Dummy.Msg := msg;
                          Dummy.INSERT;
                      END;
                  END;



                  IF Loans."Repayment Start Date" <> CALCDATE('1M',Loans."Issued Date") THEN BEGIN
                      Loans."Repayment Start Date" := CALCDATE('1M',Loans."Issued Date");
                      Loans.MODIFY;
                  END;
              END;
          UNTIL Loans.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE RedirectSMS@1120054006();
    VAR
      Source@1120054002 : 'NEW_MEMBER,NEW_ACCOUNT,LOAN_ACCOUNT_APPROVAL,DEPOSIT_CONFIRMATION,CASH_WITHDRAWAL_CONFIRM,LOAN_APPLICATION,LOAN_APPRAISAL,LOAN_GUARANTORS,LOAN_REJECTED,LOAN_POSTED,LOAN_DEFAULTED,SALARY_PROCESSING,TELLER_CASH_DEPOSIT,TELLER_CASH_WITHDRAWAL,TELLER_CHEQUE_DEPOSIT,FIXED_DEPOSIT_MATURITY,INTERACCOUNT_TRANSFER,ACCOUNT_STATUS,STATUS_ORDER,EFT_EFFECTED,ATM_APPLICATION_FAILED,ATM_COLLECTION,MBANKING,MEMBER_CHANGES,CASHIER_BELOW_LIMIT,CASHIER_ABOVE_LIMIT,INTERNETBANKING,CRM,MOBILE_PIN,WITHDRAWAL,BULK';
      SMSMessages@1120054000 : Record 51516329;
      SkySMS@1120054001 : Record 51516711;
      ChargeSMS@1120054003 : Boolean;
      Vend@1120054004 : Record 23;
      Members@1120054005 : Record 51516223;
      Charges@1120054006 : Record 51516297;
      TotalCharges@1120054007 : Decimal;
      Duty@1120054008 : Decimal;
    BEGIN

      SMSMessages.RESET;
      SMSMessages.SETFILTER(SMSMessages."Date Entered",'>=%1',DMY2DATE(15,12,2020));
      SMSMessages.SETRANGE(SMSMessages."Sent To Server",SMSMessages."Sent To Server"::No);
      IF SMSMessages.FINDFIRST THEN BEGIN
          REPEAT
             Source := Source::MBANKING;

             IF SMSMessages.Source = 'OTC SMS' THEN
                Source := Source::CASH_WITHDRAWAL_CONFIRM
             ELSE IF SMSMessages.Source = 'BULK' THEN
               Source := Source::BULK
             ELSE IF SMSMessages.Source = 'LOAN GUARANTORS' THEN
               Source := Source::LOAN_GUARANTORS
             ELSE IF SMSMessages.Source = 'LOAN APPL' THEN
               Source := Source::LOAN_APPLICATION
             ELSE IF SMSMessages.Source = 'ATM TRANS' THEN
               Source := Source::CASH_WITHDRAWAL_CONFIRM
             ELSE IF SMSMessages.Source = 'SALARY' THEN
               Source := Source::SALARY_PROCESSING
             ELSE IF SMSMessages.Source = 'DEFAULTER' THEN
               Source := Source::LOAN_DEFAULTED
             ELSE IF SMSMessages.Source = 'DEFAULTERS' THEN
               Source := Source::LOAN_DEFAULTED
             ELSE IF SMSMessages.Source = 'FIXED' THEN
               Source := Source::FIXED_DEPOSIT_MATURITY
             ELSE IF SMSMessages.Source = 'MOBILETRAN' THEN
               Source := Source::MBANKING
             ELSE IF SMSMessages.Source = 'WEBPORTAL' THEN
               Source := Source::MBANKING
             ELSE IF SMSMessages.Source = 'SAL PROCESSING' THEN
               Source := Source::SALARY_PROCESSING
             ELSE IF SMSMessages.Source = 'NAV SMS' THEN
               Source := Source::BULK;

             IF Source = Source::BULK THEN
                ChargeSMS := FALSE
             ELSE
                ChargeSMS := TRUE;

             IF SendSmsWithID(Source,SMSMessages."Telephone No",SMSMessages."SMS Message",SMSMessages."Document No",SMSMessages."Account No",
                ChargeSMS,Priority,ChargeSMS,'',FORMAT(SMSMessages."Entry No"),SMSMessages.Source) THEN

             SMSMessages."Sent To Server" := SMSMessages."Sent To Server"::Redirected
             ELSE
             SMSMessages."Sent To Server" := SMSMessages."Sent To Server"::Failed;

             SMSMessages.MODIFY;

          UNTIL SMSMessages.NEXT = 0;
      END;




      SMSMessages.RESET;
      SMSMessages.SETFILTER(SMSMessages."Date Entered",'>=%1',DMY2DATE(15,12,2020));
      SMSMessages.SETRANGE(SMSMessages."Sent To Server",SMSMessages."Sent To Server"::Redirected);
      IF SMSMessages.FINDFIRST THEN BEGIN
          REPEAT

             SkySMS.RESET;
             SkySMS.SETRANGE(SkySMS.msg_request_correlation_id,FORMAT(SMSMessages."Entry No"));
             IF SkySMS.FINDFIRST THEN BEGIN
                  IF SkySMS.msg_status_code = 102 THEN BEGIN
                      SMSMessages."Sent To Server" := SMSMessages."Sent To Server"::Yes;
                      SMSMessages.MODIFY;
                  END;
             END;

          UNTIL SMSMessages.NEXT = 0;
      END;



      SMSMessages.RESET;
      SMSMessages.SETFILTER(SMSMessages."Date Entered",'>=%1',DMY2DATE(15,12,2020));
      SMSMessages.SETRANGE(SMSMessages."Sent To Server",SMSMessages."Sent To Server"::Yes);
      IF SMSMessages.FINDFIRST THEN BEGIN
          REPEAT

             SkySMS.RESET;
             SkySMS.SETRANGE(SkySMS.msg_request_correlation_id,FORMAT(SMSMessages."Entry No"));
             SkySMS.SETFILTER(SkySMS."Account To Charge",'');
             IF SkySMS.FINDFIRST THEN BEGIN
                SkySMS."Account To Charge" := SMSMessages."Account No";
                SkySMS.MODIFY;
             END;

          UNTIL SMSMessages.NEXT = 0;
      END;



      SkySMS.RESET;
      SkySMS.SETRANGE(SkySMS."Charge Member",FALSE);
      SkySMS.SETFILTER(SkySMS."Account To Charge",'<>%1','');
      IF SkySMS.FINDFIRST THEN BEGIN
          REPEAT
              IF Vend.GET(SkySMS."Account To Charge") THEN BEGIN
                  SkySMS."Charge Member" := TRUE;
                  SkySMS.MODIFY;
              END;
          UNTIL SkySMS.NEXT = 0;
      END;


      SkySMS.RESET;
      SkySMS.SETFILTER(SkySMS."Account To Charge",'<>%1','');
      IF SkySMS.FINDFIRST THEN BEGIN
          REPEAT
              IF NOT Vend.GET(SkySMS."Account To Charge") THEN BEGIN
                  IF Members.GET(SkySMS."Account To Charge") THEN BEGIN
                      IF Members."FOSA Account" <> '' THEN BEGIN
                          IF Vend.GET(Members."FOSA Account") THEN BEGIN
                              SkySMS."Account To Charge" := Vend."No.";
                              SkySMS."Charge Member" := TRUE;
                              SkySMS.MODIFY;
                          END;
                      END;
                  END;
              END;
          UNTIL SkySMS.NEXT = 0;
      END;





      TotalCharges:=0;
      Duty := 0;


      // Get SMS G/L and Charge Amount
      Charges.RESET;
      Charges.SETRANGE(Charges.Code,'SMS');
      IF Charges.FIND('-') THEN BEGIN

          TotalCharges:=Charges."Charge Amount";
          Duty := ROUND(TotalCharges*GetExciseRate/100);

      END;


       {
      SkySMS.RESET;
      SkySMS.SETRANGE(SkySMS."Insufficient Balance",TRUE);
      IF SkySMS.FINDFIRST THEN BEGIN
          REPEAT
              IF Vend.GET(SkySMS."Account To Charge") THEN BEGIN
                  IF GetAccountBalance(Vend."No.") >= TotalCharges+Duty THEN BEGIN

                      SkySMS."Insufficient Balance" := FALSE;
                      SkySMS.MODIFY;
                  END;
              END;
          UNTIL SkySMS.NEXT = 0;
      END;
      }
    END;

    LOCAL PROCEDURE DefaulterDepositRecovery@1120054008();
    VAR
      Loans@1120054000 : Record 51516230;
      CreditRating@1120054001 : Record 51516718;
      AmountToRecover@1120054002 : Decimal;
      FosaBal@1120054003 : Decimal;
      AcctType@1120054004 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      TransType@1120054005 : ' ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated';
      SavAcc@1120054006 : Record 23;
      JTemplate@1120054007 : Code[10];
      JBatch@1120054008 : Code[10];
      LBal@1120054009 : Decimal;
      DocNo@1120054010 : Code[20];
      PDate@1120054011 : Date;
      BalAccType@1120054012 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      DepRec@1120054013 : Record 51516726;
      LNo@1120054014 : Integer;
      msg@1120054015 : Text;
    BEGIN

      CreditRating.RESET;
      CreditRating.SETFILTER(CreditRating."Amount Recovered From BOSA",'>0');
      CreditRating.SETFILTER(CreditRating."FOSA Balance",'>0');
      CreditRating.SETRANGE(CreditRating."Deposit Balance Cleared",FALSE);
      IF CreditRating.FINDFIRST THEN BEGIN
          REPEAT
              IF Loans.GET(CreditRating."Loan No.") THEN BEGIN
                  CreditRating.CALCFIELDS("Deposits Recovered");

                  AmountToRecover := CreditRating."Amount Recovered From BOSA" - CreditRating."Deposits Recovered" ;

                  IF AmountToRecover > 0 THEN BEGIN

                      SavAcc.GET(Loans."Account No");
                      JTemplate:='GENERAL';
                      JBatch:='SKYWORLD';


                      Loans.CALCFIELDS("Outstanding Balance","Oustanding Interest","Penalty Charged");
                      LBal := Loans."Outstanding Balance"+Loans."Oustanding Interest"+Loans."Penalty Charged";


                      DocNo:='DEP_REC-'+Loans."Loan  No.";
                      PDate:=TODAY;
                      SaccoTrans.InitJournal(JTemplate,JBatch);

                      FosaBal:= GetAccountBalance(Loans."Account No");

                        MESSAGE('FosaBal 1: %1',FosaBal);
                      IF FosaBal > 0 THEN BEGIN

                        MESSAGE('AmountToRecover 1: %1',AmountToRecover);
                          IF FosaBal < AmountToRecover THEN
                            AmountToRecover := FosaBal;


                        MESSAGE('AmountToRecover 2: %1',AmountToRecover);
                          IF AmountToRecover > 0 THEN BEGIN

                              Loans.TESTFIELD("Account No");

                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,CreditRating."Account No",COPYSTR(Loans."Loan Product Type Name"+': Deposit Recovery',1,50),BalAccType::"G/L Account",
                                            '',AmountToRecover,Loans."Loan  No.",Loans."Loan  No.",TransType::" ",SavAcc."Global Dimension 1 Code",SavAcc."Global Dimension 2 Code",TRUE,Loans."Client Name");


                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Member,CreditRating."Member No",COPYSTR(Loans."Loan Product Type Name"+': Deposit Recovery',1,50),BalAccType::"G/L Account",
                                            '',-AmountToRecover,Loans."Loan  No.",Loans."Loan  No.",TransType::"Deposit Contribution",SavAcc."Global Dimension 1 Code",SavAcc."Global Dimension 2 Code",TRUE,Loans."Client Name");

                              LNo := 0;
                              DepRec.RESET;
                              IF DepRec.FINDLAST THEN
                                LNo := DepRec."Entry No.";

                              LNo += 1;
                              DepRec.INIT;
                              DepRec."Entry No." := LNo;
                              DepRec."Loan No." := Loans."Loan  No.";
                              DepRec."Member No." := Loans."BOSA No";
                              DepRec.Name := Loans."Client Name";
                              DepRec."Date Recovered" := TODAY;
                              DepRec."Deposits Recovered" := AmountToRecover;
                              DepRec."Recovered By":=USERID;
                              DepRec.INSERT  ;


                              msg:='Dear '+FirstName(Loans."Client Name")+', Kshs '+FORMAT(AmountToRecover)+
                                        ' has been transfered from your FOSA Account on '+DateTimeToText(CURRENTDATETIME)+' to replenish your Deposits';


                               SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,Loans."Loan  No.",SavAcc."No.",TRUE,Priority,TRUE);

                                IF LBal <=0 THEN BEGIN
                                    CreditRating."Deposit Balance Cleared" := TRUE;
                                    CreditRating.MODIFY;
                                END;

                               SaccoTrans.PostJournal(JTemplate,JBatch);

                          END;
                      END;
                  END;
              END;
          UNTIL CreditRating.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE UpdateSavingsLedger@1120054009();
    VAR
      VLedger@1120054000 : Record 25;
      DetVLedger@1120054001 : Record 380;
      SkyTransactions@1120054002 : Record 51516712;
      Vendor@1120054003 : Record 23;
      SkyMobileLoans@1120054004 : Record 51516713;
      CreditRating@1120054005 : Record 51516718;
    BEGIN
      {
      VLedger.RESET;
      //VLedger.SETRANGE(VLedger."Vendor No.",'VEND00244');
      VLedger.SETRANGE(VLedger.Description,'Loan Repayment: Correction');
      VLedger.SETFILTER(VLedger.Amount,'>0');
      IF VLedger.FINDFIRST THEN BEGIN
          //ERROR('%1',VLedger.COUNT);
          REPEAT

              SkyTransactions.RESET;
              SkyTransactions.SETRANGE(SkyTransactions."Transaction ID",VLedger."Document No.");
              IF SkyTransactions.FINDFIRST THEN BEGIN
                  {
                  DetVLedger.RESET;
                  DetVLedger.SETRANGE(DetVLedger."Transaction No.",VLedger."Transaction No.");
                  DetVLedger.SETRANGE(DetVLedger."Vendor No.",'VEND00244');
                  DetVLedger.SETFILTER(DetVLedger.Amount,'>0');
                  IF DetVLedger.FINDFIRST THEN BEGIN
                      DetVLedger."Vendor No." := SkyTransactions."Member Account";
                      DetVLedger.MODIFY;
                  END;
                  }
                  VLedger.Description := VLedger.Description+'-'+FORMAT(VLedger."Posting Date");
                  //VLedger.MODIFY;
              END;
          UNTIL VLedger.NEXT = 0;
      END;
      }


      CreditRating.RESET;
      CreditRating.SETFILTER(CreditRating."Staff No.",'%1','');
      IF CreditRating.FINDFIRST THEN BEGIN
          REPEAT
              IF Vendor.GET(CreditRating."Account No") THEN BEGIN
                  CreditRating."Staff No." := Vendor."Staff No";
                  CreditRating.MODIFY;
              END;
          UNTIL CreditRating.NEXT=0;
      END;


      SkyMobileLoans.RESET;
      SkyMobileLoans.SETFILTER(SkyMobileLoans."Staff No.",'%1','');
      IF SkyMobileLoans.FINDFIRST THEN BEGIN
          REPEAT
              IF Vendor.GET(SkyMobileLoans."Account No") THEN BEGIN
                  SkyMobileLoans."Staff No." := Vendor."Staff No";
                  SkyMobileLoans.MODIFY;
              END;
          UNTIL SkyMobileLoans.NEXT=0;
      END;
    END;

    PROCEDURE PostCoopATM@1120054010();
    VAR
      Cooptrans@1120054000 : Record 170041;
      CoopProcessing@1120054001 : CodeUnit 20367;
      msg@1120054002 : Text;
      MobileNo@1120054003 : Text;
    BEGIN
      Cooptrans.RESET;
      Cooptrans.ASCENDING(TRUE);
      Cooptrans.SETRANGE(Skipped,FALSE);
      Cooptrans.SETRANGE(Posted,FALSE);
      IF Cooptrans.FINDFIRST THEN BEGIN
          REPEAT
            CoopProcessing.PostATM(Cooptrans."Transaction ID");
          UNTIL Cooptrans.NEXT=0;
      END;
    END;

    PROCEDURE OverdraftLimit@1120054013(AccNo@1120054020 : Code[20];VAR Success@1120054022 : Boolean;VAR Msg@1120054023 : Text;VAR RecomAmt@1120054025 : Decimal;VAR LoanLimit@1120054028 : Decimal);
    VAR
      ODAuth@1120054000 : Record 51516328;
      NoSetup@1120054019 : Record 51516257;
      NoSeriesMgt@1120054018 : Codeunit 396;
      Account@1120054017 : Record 23;
      UsersID@1120054016 : Record 2000000120;
      BanksList@1120054015 : Record 51516311;
      "Bank Name"@1120054014 : Text[30];
      ChequeNo@1120054013 : Code[20];
      i@1120054012 : Integer;
      Bank@1120054011 : Record 270;
      AccountTypes@1120054010 : Record 51516295;
      OverDraftAuth@1120054009 : Record 51516328;
      AllowMultipleOD@1120054008 : Boolean;
      SalaryPro@1120054007 : Record 51516317;
      ApperovedAmount@1120054006 : Decimal;
      RequestedAmount@1120054005 : Decimal;
      OnSacco@1120054004 : Record 51516257;
      USetup@1120054003 : Record 91;
      IsStaff@1120054002 : Boolean;
      Acc@1120054001 : Record 23;
      DefLoan@1120054021 : Record 51516230;
      WDAmt@1120054024 : Decimal;
      ODIntRate@1120054026 : Decimal;
      NetSal@1120054027 : Decimal;
      AccBal@1120054029 : Decimal;
    BEGIN
      // //ODAuth
      // RecomAmt := 0;
      // LoanLimit := 0;
      // Success := FALSE;
      // Msg := 'You do not have the ability to get this product';
      //
      // IF Account.GET(AccNo) THEN BEGIN
      //  /
      //     ODIntRate := 0;
      //     IF AccountTypes.GET(Account."Account Type") THEN BEGIN
      //         //MESSAGE(AccountTypes.Code);
      //
      //         Account.CALCFIELDS(Account."Authorised Over Draft",Account."Balance (LCY)");
      //         AccBal := GetAccountBalance(Account."No.");
      //
      //         IF (Account."Balance (LCY)" < 0) OR (AccBal < 0) THEN BEGIN
      //             Success:= FALSE;
      //             Msg := 'Your account balance as at '+DateTimeToText(CURRENTDATETIME)+' is negative.';
      //             EXIT;
      //         END;
      //
      //         IF Account."Authorised Over Draft" > 0 THEN BEGIN
      //             Success:= FALSE;
      //             Msg := 'You already have an existing overdraft facility.';
      //             EXIT;
      //         END;
      //
      //         IF AccountTypes."Allow Over Draft" = FALSE THEN BEGIN
      //
      //             Success:= FALSE;
      //             Msg := 'Overdraft not allowed for this account type.';
      //             EXIT;
      //         END;
      //
      //         AccountTypes.TESTFIELD(AccountTypes."Over Draft Interest Account");
      //         ODIntRate:=AccountTypes."Over Draft Interest %";
      //
      //
      //         DefLoan.RESET;
      //         DefLoan.SETRANGE(DefLoan."Client Code",Account."BOSA Account No");
      //         DefLoan.SETFILTER(DefLoan."Outstanding Balance",'>0');
      //         DefLoan.SETFILTER(DefLoan."Loans Category-SASRA",'%1|%2|%3',
      //         DefLoan."Loans Category-SASRA"::Substandard,DefLoan."Loans Category-SASRA"::Doubtful,
      //         DefLoan."Loans Category-SASRA"::Loss);
      //         IF DefLoan.FINDSET THEN BEGIN
      //             Success:= FALSE;
      //             Msg := 'You have a non-performing loan: '+DefLoan."Loan Product Type Name";
      //             EXIT;
      //         END;
      //
      //         CalculateODReccommededAmount(AccNo,NetSal,RecomAmt,LoanLimit);
      //         MESSAGE('RecomAmt %1\LoanLimit %2',RecomAmt,LoanLimit);
      //         //LoanLimit -= ((LoanLimit*0.01*ODIntRate) + GetODCharges(LoanLimit));
      //         //WDAmt := RecomAmt - ((RecomAmt*0.01*ODIntRate) + GetODCharges(RecomAmt));
      //
      //         //RecomAmt := WDAmt;
      //
      //
      //         RecomAmt := ROUND(RecomAmt,1,'<');
      //         LoanLimit := ROUND(LoanLimit,1,'<');
      //
      //         IF AccountTypes."Max. Overdraft Amount" > 0 THEN BEGIN
      //             IF RecomAmt > AccountTypes."Max. Overdraft Amount" THEN
      //                 RecomAmt := AccountTypes."Max. Overdraft Amount";
      //             IF LoanLimit > AccountTypes."Max. Overdraft Amount" THEN
      //                 LoanLimit := AccountTypes."Max. Overdraft Amount";
      //         END;
      //
      //         Success := TRUE;
      //         //Msg := 'You Qualify for '+FORMAT(LoanLimit);
      //     END;
      // END;
    END;

    LOCAL PROCEDURE CalculateODReccommededAmount@1120054015(AccNo@1120054009 : Code[20];VAR NetSal@1120054012 : Decimal;VAR RecommAmt@1120054013 : Decimal;VAR Limit@1120054014 : Decimal);
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
      IsStaff@1120054010 : Boolean;
      Acc@1120054011 : Record 23;
      StandingOrders@1120054015 : Record 51516307;
      STOAmt@1120054016 : Decimal;
      PrevSalaryAmount@1120054017 : Decimal;
    BEGIN
      // IF Charges.GET('SAL') THEN BEGIN
      //    SalFee:=Charges."Charge Amount";
      //    SaccoGeneralSetUp.GET;
      //    SaccoGeneralSetUp.TESTFIELD(SaccoGeneralSetUp."Excise Duty(%)");
      //    SalFee+=(SaccoGeneralSetUp."Excise Duty(%)"*0.01*SalFee);
      // END;
      //
      // SalaryAmount := 0;
      //
      // SalLines.RESET;
      // SalLines.SETRANGE(SalLines."Account No.",AccNo);
      // SalLines.SETRANGE(SalLines.Processed,TRUE);
      // IF SalLines.FINDLAST THEN
      //    SalaryAmount := SalLines.Amount;
      //
      // PrevSalaryAmount := 0;
      //
      // SalLines.RESET;
      // SalLines.SETRANGE(SalLines."Account No.",AccNo);
      // SalLines.SETRANGE(SalLines.Processed,TRUE);
      // SalLines.SETRANGE(SalLines.Type,SalLines.Type::Salary,SalLines.Type::Pension);
      // IF SalLines.FINDLAST THEN BEGIN
      //    SalaryAmount := SalLines.Amount;
      //    IF SalLines.FIND('<') THEN
      //       PrevSalaryAmount := SalLines.Amount;
      // END;
      //
      //
      //
      // IsStaff:=FALSE;
      // VendorLedger.RESET;
      // VendorLedger.SETRANGE(VendorLedger."Vendor No.",AccNo);
      // VendorLedger.SETRANGE(VendorLedger.Reversed,FALSE);
      // VendorLedger.SETFILTER(VendorLedger."External Document No.",'SALARY*');
      // VendorLedger.SETFILTER(VendorLedger.Amount,'<0');
      // VendorLedger.SETAUTOCALCFIELDS(VendorLedger.Amount);
      // IF VendorLedger.FINDLAST THEN BEGIN
      //    SalaryAmount := VendorLedger.Amount*-1;
      //    IsStaff:=TRUE;
      // END;
      //
      // //New salary
      // Acc.GET(AccNo);
      // //SalaryAmount:=Acc."Net Salary";
      //
      //
      // IF PrevSalaryAmount>0 THEN BEGIN
      //    IF SalaryAmount>PrevSalaryAmount THEN
      //       SalaryAmount := PrevSalaryAmount;
      // END;
      //
      // IF Acc."Company Code" = 'STAFF' THEN BEGIN
      //
      //     VendorLedger.RESET;
      //     VendorLedger.SETRANGE(VendorLedger."Vendor No.",AccNo);
      //     VendorLedger.SETRANGE(VendorLedger.Reversed,FALSE);
      //     VendorLedger.SETFILTER(VendorLedger."External Document No.",'SALARY*');
      //     VendorLedger.SETFILTER(VendorLedger.Amount,'<0');
      //     VendorLedger.SETAUTOCALCFIELDS(VendorLedger.Amount);
      //     IF VendorLedger.FINDLAST THEN BEGIN
      //        SalaryAmount := VendorLedger.Amount*-1;
      //        IsStaff:=TRUE;
      //     END;
      // END;
      //
      // //end of new
      //
      //
      // STOAmt := 0;
      // StandingOrders.RESET;
      // StandingOrders.SETRANGE(StandingOrders."Source Account No.",AccNo);
      // StandingOrders.SETRANGE(StandingOrders.Status,StandingOrders.Status::Approved);
      // StandingOrders.SETFILTER(StandingOrders."Income Type",'%1|%2',StandingOrders."Income Type"::Pension,StandingOrders."Income Type"::Salary);
      // StandingOrders.SETRANGE(StandingOrders."End Date",0D,TODAY);
      // IF StandingOrders.FINDSET THEN
      //   REPEAT
      //       STOAmt+=StandingOrders.Amount;
      //  UNTIL StandingOrders.NEXT = 0;
      //
      // NetSal:=SalaryAmount;
      // RecommAmt := 0;
      // IF SalaryAmount>0 THEN BEGIN
      //     "95%OfSalary" := (SalaryAmount*0.95);
      //     SalaryLoansBal := GetODSalaryLoansBalance(AccNo,IsStaff);
      //     ExistingOds := GetExistingODs(AccNo);
      //     Limit  := ROUND("95%OfSalary"-(SalFee+SalaryLoansBal+STOAmt),1,'<');
      //     RecommAmt  := ROUND("95%OfSalary"-(SalFee+SalaryLoansBal+ExistingOds+STOAmt),1,'<');
      //     IF RecommAmt<0 THEN
      //       RecommAmt:=0;
      //
      //     IF Limit <0 THEN
      //       Limit:=0;
      //
      //     IF ExistingOds > 0 THEN
      //       RecommAmt := 0;
      // END;
      //
      // //MESSAGE('SalFee %1\SalaryLoansBal %2\ExistingOds %3\STOAmt %4',SalFee,SalaryLoansBal,ExistingOds,STOAmt);
    END;

    LOCAL PROCEDURE GetODCharges@1120054016(Amount@1120054000 : Decimal) : Decimal;
    VAR
      Charges@1120054001 : Record 51516297;
      ChargeAmount@1120054002 : Decimal;
      SaccoGeneralSetUp@1120054003 : Record 51516257;
    BEGIN
      // Charges.RESET;
      // Charges.SETRANGE(Charges.Description,'Cash Withdrawal Charges');
      // IF Charges.FIND('-') THEN BEGIN
      // IF (Amount>=100)  AND (Amount<=5000) THEN
      // ChargeAmount:=Charges."Between 100 and 5000";
      //
      //  IF  (Amount>=5001) AND (Amount<=10000) THEN
      // ChargeAmount:=Charges."Between 5001 - 10000";
      //
      // IF (Amount>=10001) AND (Amount<=30000) THEN
      //   ChargeAmount:=Charges."Between 10001 - 30000";
      //
      // IF (Amount>=30001) AND (Amount<=50000) THEN
      // ChargeAmount:=Charges."Between 30001 - 50000";
      //
      //  IF (Amount>=50001) AND (Amount<=100000) THEN
      // ChargeAmount:=Charges."Between 50001 - 100000";
      //
      //  IF (Amount>=100001) AND (Amount<=200000) THEN
      //    ChargeAmount:=Charges."Between 100001 - 200000";
      //
      // IF (Amount>=200001) AND (Amount<=500000) THEN
      //  ChargeAmount:=Charges."Between 200001 - 500000";
      //
      // IF (Amount>=500001) AND (Amount<=100000000.0) THEN
      //   ChargeAmount:=Charges."Between 500001 Above";
      // END;
      // SaccoGeneralSetUp.GET;
      // EXIT(ChargeAmount+(SaccoGeneralSetUp."Excise Duty(%)"*0.01*ChargeAmount));
    END;

    LOCAL PROCEDURE GetODSalaryLoansBalance@1120054018(AccNo@1120054006 : Code[20];VAR IsStaff@1120054007 : Boolean) : Decimal;
    VAR
      SalLoan@1120054000 : Record 51516230;
      SalLoanBal@1120054001 : Decimal;
      StandingOrders@1120054002 : Record 51516307;
      ReceiptAllocation@1120054003 : Record 51516246;
      MembLedger@1120054004 : Record 51516224;
      IntDue@1120054005 : Decimal;
    BEGIN
      // SalLoanBal:=0;
      // SalLoan.RESET;
      // SalLoan.SETCURRENTKEY(Source,"Client Code","Loan Product Type","Issued Date");
      // SalLoan.SETRANGE(SalLoan."Account No",AccNo);
      // SalLoan.SETRANGE(SalLoan."Recovery Mode",SalLoan."Recovery Mode"::Salary,SalLoan."Recovery Mode"::Pension);
      // SalLoan.SETFILTER(SalLoan."Outstanding Balance",'>0');
      // SalLoan.SETAUTOCALCFIELDS(SalLoan."Outstanding Balance");
      // IF SalLoan.FINDSET THEN REPEAT
      //
      //    IF SalLoan."Issued Date"<=081519D THEN BEGIN
      //
      //          MembLedger.RESET;
      //          MembLedger.SETRANGE(MembLedger."Loan No",SalLoan."Loan  No.");
      //          MembLedger.SETRANGE(MembLedger."Transaction Type",MembLedger."Transaction Type"::"Interest Due");
      //          MembLedger.SETRANGE(MembLedger.Reversed,FALSE);
      //          MembLedger.SETFILTER(MembLedger.Amount,'0');
      //          IF MembLedger.FINDLAST THEN
      //            IntDue :=MembLedger.Amount;
      //          SalLoan.Repayment := (SalLoan."Approved Amount"/SalLoan.Installments) + IntDue;
      //
      //      END ELSE
      //
      //          SalLoan.Repayment:=SalLoan.GetLoanExpectedRepayment(0,CALCDATE('CM',TODAY));
      //
      //    IF SalLoan.Repayment>SalLoan."Outstanding Balance" THEN
      //      SalLoan.Repayment:=SalLoan."Outstanding Balance";
      //
      //    IF IsStaff AND (SalLoan.Source=SalLoan.Source::BOSA) THEN
      //      SalLoan.Repayment := 0;
      //
      //    SalLoanBal+=SalLoan.Repayment;
      //
      //   UNTIL SalLoan.NEXT = 0;
      //
      // StandingOrders.RESET;
      // StandingOrders.SETRANGE(StandingOrders."Source Account No.",AccNo);
      // StandingOrders.SETRANGE(StandingOrders.Status,StandingOrders.Status::Approved);
      // StandingOrders.SETFILTER(StandingOrders."Income Type",'%1|%2',StandingOrders."Income Type"::Pension,StandingOrders."Income Type"::Salary);
      // StandingOrders.SETRANGE(StandingOrders."End Date",0D,TODAY);
      // IF StandingOrders.FINDSET THEN
      //   REPEAT
      //     ReceiptAllocation.RESET;
      //     ReceiptAllocation.SETRANGE(ReceiptAllocation."Document No",StandingOrders."No.");
      //     ReceiptAllocation.SETFILTER(ReceiptAllocation."Loan No.",'<>%1','');
      //     IF ReceiptAllocation.FINDFIRST THEN BEGIN
      //         SalLoan.GET(ReceiptAllocation."Loan No.");
      //         SalLoan.CALCFIELDS(SalLoan."Outstanding Balance");
      //         IF SalLoan."Outstanding Balance">0 THEN BEGIN
      //               SalLoan.Repayment:=SalLoan.GetLoanExpectedRepayment(0,CALCDATE('CM',TODAY));
      //               IF SalLoan.Repayment>SalLoan."Outstanding Balance" THEN
      //                  SalLoan.Repayment:=SalLoan."Outstanding Balance";
      //                SalLoanBal += SalLoan.Repayment;
      //           END;
      //       END;
      //  UNTIL StandingOrders.NEXT = 0;
      // EXIT(SalLoanBal);
    END;

    LOCAL PROCEDURE GetExistingODs@1120054017(AccNo@1120054001 : Code[20]) : Decimal;
    VAR
      ExistingOds@1120054000 : Record 51516328;
    BEGIN
      // ExistingOds.RESET;
      // ExistingOds.SETRANGE(ExistingOds."Account No.",AccNo);
      // ExistingOds.SETRANGE(ExistingOds.Status,ExistingOds.Status::Approved);
      // ExistingOds.SETRANGE(ExistingOds.Posted,TRUE);
      // ExistingOds.SETRANGE(ExistingOds.Liquidated,FALSE);
      // ExistingOds.SETRANGE(ExistingOds.Expired,FALSE);
      // IF ExistingOds.FINDFIRST THEN BEGIN
      //      ExistingOds.CALCSUMS(ExistingOds."Approved Amount");
      //      EXIT(ExistingOds."Approved Amount");
      //   END;
    END;

    PROCEDURE ProcessOverdraft@1120054024();
    VAR
      ODAuth@1120054000 : Record 51516328;
      MobileLoans@1120054002 : Record 51516713;
      Success@1120054003 : Boolean;
      Msg@1120054004 : Text;
      ODNo@1120054005 : Code[20];
      SavAcc@1120054001 : Record 23;
      QualAmt@1120054006 : Decimal;
      Limit@1120054007 : Decimal;
      Loans@1120054008 : Record 51516230;
      LoanNo@1120054009 : Code[10];
      LoanBalance@1120054010 : Decimal;
    BEGIN
      //
      // MobileLoans.RESET;
      // //MobileLoans.SETRANGE(MobileLoans."Entry No",2165);
      // MobileLoans.SETRANGE(MobileLoans."Loan Product Type",'M_OD');
      // MobileLoans.SETRANGE(MobileLoans.Posted,FALSE);
      // MobileLoans.SETRANGE(MobileLoans.Overdraft,TRUE);
      // MobileLoans.SETRANGE(MobileLoans.Status,MobileLoans.Status::Pending);
      // IF MobileLoans.FINDFIRST THEN BEGIN
      //     REPEAT
      //         Success := FALSE;
      //         QualAmt := 0;
      //         SavAcc.GET(MobileLoans."Account No");
      //
      //         OverdraftLimit(MobileLoans."Account No",Success,Msg,QualAmt,Limit);
      //         IF MobileLoans."Requested Amount" > QualAmt THEN BEGIN
      //
      //             Msg:='Your overdraft request on '+DateTimeToText(CURRENTDATETIME)+' has failed, your eligibility is KES '+FORMAT(QualAmt);
      //             MobileLoans.Remarks:='Member eligibility is '+FORMAT(QualAmt);
      //             MobileLoans.Status:=MobileLoans.Status::Failed;
      //             MobileLoans.Posted:=TRUE;
      //             MobileLoans."Date Posted":=CURRENTDATETIME;//TODAY;
      //             MobileLoans.Message:=Msg;
      //             SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",Msg,FORMAT(MobileLoans."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
      //             MobileLoans.MODIFY;
      //         END
      //         ELSE IF Success THEN BEGIN
      //
      //             IF CreateOD(MobileLoans."Account No",ODNo,MobileLoans."Requested Amount",QualAmt) THEN BEGIN
      //                 //MESSAGE(ODNo);
      //                 ODAuth.RESET;
      //                 ODAuth.SETRANGE("No.",ODNo);
      //                 ODAuth.SETRANGE("Account No.",MobileLoans."Account No");
      //                 ODAuth.SETRANGE(ODAuth.Posted,FALSE);
      //                 IF ODAuth.FINDFIRST THEN BEGIN
      //                     IF PostOverDraft(ODAuth."No.") THEN BEGIN
      //
      //                         MobileLoans.Remarks:='Successful';
      //                         MobileLoans."Approved Amount":=ODAuth."Requested Amount";
      //                         MobileLoans.Status:=MobileLoans.Status::Successful;
      //                         MobileLoans.Posted:=TRUE;
      //                         MobileLoans."Date Posted":=CURRENTDATETIME;//TODAY;
      //                         MobileLoans.Message:='Successful';
      //                         MobileLoans.MODIFY;
      //
      //
      //                         Msg:='Dear '+FirstName(ODAuth."Account Name")+
      //                         ', your overdraft of KES '+FORMAT(MobileLoans."Requested Amount")+' has been approved and processed on '+DateTimeToText(CURRENTDATETIME)+'.';
      //                         SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",Msg,FORMAT(MobileLoans."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
      //
      //
      //                     END;
      //                 END;
      //             END
      //             ELSE BEGIN
      //                 ERROR(GETLASTERRORTEXT);
      //             END;
      //         END
      //         ELSE BEGIN
      //
      //             Msg:='Your overdraft request on '+DateTimeToText(CURRENTDATETIME)+' has failed, your eligibility is KES '+FORMAT(QualAmt);
      //             MobileLoans.Remarks:='Member eligibility is '+FORMAT(QualAmt);
      //             MobileLoans.Status:=MobileLoans.Status::Failed;
      //             MobileLoans.Posted:=TRUE;
      //             MobileLoans."Date Posted":=CURRENTDATETIME;//TODAY;
      //             MobileLoans.Message:=Msg;
      //             SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",Msg,FORMAT(MobileLoans."Entry No"),SavAcc."No.",TRUE,Priority,TRUE);
      //             MobileLoans.MODIFY;
      //         END;
      //
      //     UNTIL MobileLoans.NEXT=0;
      // END;
    END;

    [TryFunction]
    PROCEDURE CreateOD@1120054035(AccountNo@1120054001 : Code[20];VAR ODNo@1120054005 : Code[20];ReqAmt@1120054006 : Decimal;QualAmt@1120054007 : Decimal);
    VAR
      ODAuth@1120054000 : Record 51516328;
      MobileLoans@1120054002 : Record 51516713;
      Success@1120054003 : Boolean;
      Msg@1120054004 : Text;
    BEGIN

      //
      // ODAuth.INIT;
      // ODAuth."No." := '';
      // ODAuth.VALIDATE(ODAuth."Account No.",AccountNo);
      // ODAuth.VALIDATE(ODAuth."Effective/Start Date",TODAY);
      // ODAuth.VALIDATE("Requested Amount",ReqAmt);
      // ODAuth."Approved Amount" := ReqAmt;
      // ODAuth."Withdrawal Amount":=ReqAmt;
      //
      // ODAuth."Overdraft Fee":=ROUND(ODAuth."Overdraft Interest %"*0.01*ODAuth."Approved Amount");
      // EVALUATE(ODAuth.Duration,'30D');
      // ODAuth.VALIDATE(ODAuth.Duration);
      // ODAuth.Mobile:=TRUE;
      // ODAuth.INSERT(TRUE);
      //
      // ODNo := ODAuth."No.";
    END;

    PROCEDURE PostOverDraft@1120054041(OD@1120054027 : Code[20]) ODPosted : Boolean;
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
      ODAuth@1120054028 : Record 51516328;
    BEGIN
      // ODAuth.GET(OD);
      //
      //  ODPosted := FALSE;
      //
      // WITH ODAuth DO BEGIN
      //
      //     IF Posted=TRUE THEN BEGIN
      //         ODPosted := TRUE;
      //     END
      //     ELSE BEGIN
      //
      //         Status := Status::Approved;
      //
      //         ValidateOverDraft;
      //         //Overdraft Issue Fee
      //         AccountTypes.RESET;
      //         AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
      //         IF AccountTypes.FIND('-') THEN  BEGIN
      //
      //             UsersID.RESET;
      //             UsersID.SETRANGE(UsersID."User Name",UPPERCASE(USERID));
      //             IF UsersID.FIND('-') THEN BEGIN
      //                 DBranch:=UsersID.Branch;
      //                 DActivity:='FOSA';
      //                 //MESSAGE('%1,%2',Branch,Activity);
      //             END;
      //
      //             TESTFIELD("Overdraft Fee");
      //
      //             IF "Overdraft Fee" > 0 THEN BEGIN
      //                 //AccountTypes.TESTFIELD("Over Draft Issue Charge %");
      //
      //                 GenJournalLine.RESET;
      //                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'PURCHASES');
      //                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'FTRANS');
      //                 IF GenJournalLine.FIND('-') THEN
      //                 GenJournalLine.DELETEALL;
      //
      //                 LineNo:=LineNo+10000;
      //
      //                 GenJournalLine.INIT;
      //                 GenJournalLine."Journal Template Name":='PURCHASES';
      //                 GenJournalLine."Journal Batch Name":='FTRANS';
      //                 GenJournalLine."Line No.":=LineNo;
      //                 GenJournalLine."Document No.":="No.";
      //                 GenJournalLine."Posting Date":=TODAY;
      //                 GenJournalLine."External Document No.":="No.";
      //                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
      //                 GenJournalLine."Account No.":="Account No.";
      //                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      //                 GenJournalLine.Description:='Overdraft Issue Charges';
      //                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      //                 GenJournalLine.Amount:="Overdraft Fee";
      //                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
      //                 IF GenJournalLine.Amount<>0 THEN
      //                 GenJournalLine.INSERT;
      //
      //
      //                 LineNo:=LineNo+10000;
      //                 AccountTypes.TESTFIELD("Over Draft Issue Charge A/C");
      //
      //                 GenJournalLine.INIT;
      //                 GenJournalLine."Journal Template Name":='PURCHASES';
      //                 GenJournalLine."Journal Batch Name":='FTRANS';
      //                 GenJournalLine."Line No.":=LineNo;
      //                 GenJournalLine."Document No.":="No.";
      //                 GenJournalLine."Posting Date":=TODAY;
      //                 GenJournalLine."External Document No.":="No.";
      //                 GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      //                 GenJournalLine."Account No.":=AccountTypes."Over Draft Issue Charge A/C";
      //                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      //                 GenJournalLine.Description:=PADSTR('Overdraft issue charge for: '+ "Account No.",50);
      //                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      //                 GenJournalLine.Amount:=-"Overdraft Fee";
      //                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
      //                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      //                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      //                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      //                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      //                 IF GenJournalLine.Amount<>0 THEN
      //                 GenJournalLine.INSERT;
      //
      //
      //                 ODPosted := TRUE;
      //
      //
      //                 //Post New
      //                  GenJournalLine.RESET;
      //                  GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
      //                  GenJournalLine.SETRANGE("Journal Batch Name",'FTRANS');
      //                  IF GenJournalLine.FIND('-') THEN BEGIN
      //                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Sacco",GenJournalLine);
      //                  END;
      //
      //                 //Post New
      //
      //             END;
      //         END;
      //
      //         Posted:=TRUE;
      //         "Date Posted":=CURRENTDATETIME;
      //         "Posted By":=USERID;
      //         MODIFY;
      //     END;
      // END;
    END;

    LOCAL PROCEDURE UpdateOD@1120054014() : Decimal;
    VAR
      ExistingOds@1120054000 : Record 51516328;
    BEGIN
      ExistingOds.RESET;
      ExistingOds.SETRANGE(ExistingOds.Status,ExistingOds.Status::Approved);
      ExistingOds.SETRANGE(ExistingOds.Posted,TRUE);
      ExistingOds.SETRANGE(ExistingOds.Liquidated,FALSE);
      ExistingOds.SETFILTER(ExistingOds."Liquidated By",'<>%1','');
      IF ExistingOds.FINDFIRST THEN BEGIN
          ExistingOds.MODIFYALL(ExistingOds.Liquidated,TRUE);
      END;
    END;

    PROCEDURE GetLoanPeriods@1120054020(PhoneNumber@1120054000 : Text;ProductCode@1120054001 : Code[30]) Response : Text;
    BEGIN
      Response := '';
      IF ProductCode = 'A03' THEN BEGIN
        Response += '<Periods>';
            Response += '<Period>';
                Response += '<No>1</No>';
                Response += '<Name></Name>';
            Response += '</Period>';
            Response += '<Period>';
                Response += '<No>2</No>';
                Response += '<Name></Name>';
            Response += '</Period>';
        Response += '</Periods>';
      END;
    END;

    PROCEDURE CheckMobileBankingFunctionality@1120054021(Phone@1120054000 : Text;TransactionType@1120054001 : Code[40]) Response : Boolean;
    VAR
      SavAcc@1120054002 : Record 23;
      Continue@1120054003 : Boolean;
      ATMCardApplications@1120054004 : Record 51516321;
      LoansRegister@1120054005 : Record 51516230;
      LoanRepaymentSchedule@1120054006 : Record 51516234;
      ExpectedDateOfCompletion@1120054007 : Date;
    BEGIN
      Response:=TRUE;
      IF (TransactionType = 'CASH_WITHDRAWAL') OR (TransactionType = 'LOAN_APPLICATION') OR (TransactionType = 'PAY_BILL') OR (TransactionType = 'BANK_TRANSFER') THEN BEGIN
          Continue := TRUE;
          Phone := '+'+Phone;
          SavAcc.RESET;
          SavAcc.SETRANGE("Transactional Mobile No",Phone);
          SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
          IF SavAcc.FINDFIRST THEN BEGIN

            //check blocked account
            IF (SavAcc.Status <> SavAcc.Status::Active) AND (SavAcc.Blocked <> SavAcc.Blocked::" ") THEN BEGIN
              Response := FALSE;
              Continue := FALSE;
            END;
            //check ATM Card
      //       IF Continue THEN BEGIN
      //
      //         ATMCardApplications.RESET;
      //         ATMCardApplications.SETRANGE(ATMCardApplications."Account No",SavAcc."No.");
      //         ATMCardApplications.SETRANGE(ATMCardApplications.Status,ATMCardApplications.Status::Approved);
      //         IF ATMCardApplications.FINDFIRST THEN BEGIN
      //           IF ATMCardApplications."Card Status" <> ATMCardApplications."Card Status"::Active THEN BEGIN
      //             Response := FALSE;
      //             Continue := FALSE;
      //           END;
      //         END;
      //       END;

            //check defaulter
            IF Continue THEN BEGIN
              LoansRegister.RESET;
              LoansRegister.SETRANGE(LoansRegister."BOSA No",SavAcc."BOSA Account No");
              LoansRegister.SETRANGE(LoansRegister."Loan Product Type",'A03');
              LoansRegister.SETFILTER(LoansRegister."Outstanding Balance",'>%1',0);
              IF LoansRegister.FINDFIRST THEN BEGIN
                REPEAT
                  ExpectedDateOfCompletion := CALCDATE(FORMAT(LoansRegister.Installments)+'M',LoansRegister."Issued Date");
                  IF LoansRegister.Installments = 1 THEN
                    ExpectedDateOfCompletion := CALCDATE('10D',ExpectedDateOfCompletion);
      //             LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest");
      //             LoanRepaymentSchedule.RESET;
      //             LoanRepaymentSchedule.SETRANGE(LoanRepaymentSchedule."Loan No.",LoansRegister."Loan  No.");
      //             IF LoanRepaymentSchedule.FINDLAST THEN BEGIN
                    IF ExpectedDateOfCompletion < TODAY THEN BEGIN
                      //MESSAGE(FORMAT(LoanRepaymentSchedule."Repayment Date"));
                      //this is a defaulter
                      Response := FALSE;
                      Continue := FALSE;
                      LoansRegister.CALCFIELDS("Outstanding Balance");
           //MESSAGE('tEST \%1\%2\%3',LoansRegister."Loan  No.",LoansRegister."Expected Date of Completion",LoansRegister."Outstanding Balance");
                    END;
                  //END;
                UNTIL LoansRegister.NEXT = 0;
              END;
            END;
            //MESSAGE(FORMAT(Response));
            //Add new check here if continue is true

          END;
      END;
    END;

    LOCAL PROCEDURE CheckDefaultedMobileLoan@1120054022(LoanNo@1120054011 : Code[20]);
    VAR
      msg@1001 : Text;
      SavAcc@1002 : Record 23;
      Loans@1000 : Record 51516230;
      LoanType@1004 : Record 51516240;
      CLedger@1005 : Record 51516224;
      PenaltyAmt@1006 : Decimal;
      JTemplate@1010 : Code[10];
      JBatch@1009 : Code[10];
      DocNo@1008 : Code[20];
      PDate@1007 : Date;
      AccNo@1011 : Code[20];
      AcctType@1014 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      BalAccType@1013 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      TransType@1012 : ' ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated';
      Dim1@1015 : Code[10];
      Dim2@1016 : Code[10];
      SystCreated@1017 : Boolean;
      FullyRecovered@1018 : Integer;
      LBal@1019 : Decimal;
      Members@1020 : Record 51516223;
      SaccoSetup@1120054000 : Record 51516700;
      FosaBal@1120054001 : Decimal;
      amtToRecover@1120054002 : Decimal;
      RunBal@1120054003 : Decimal;
      DedAmt@1120054004 : Decimal;
      AmtDeducted@1120054005 : Decimal;
      RecoveredFromFosa@1120054006 : Decimal;
      RecoveredFromBosa@1120054007 : Decimal;
      ExtDoc@1120054008 : Code[10];
      TotalRecovered@1120054009 : Decimal;
      CreditRating@1120054010 : Record 51516718;
      FullyRec@1120054012 : Boolean;
      NewBal@1120054013 : Decimal;
      NextLoanNo@1120054014 : Code[20];
    BEGIN

      NextLoanNo := LoanNo;
      Loans.RESET;
      IF LoanNo <> '' THEN
          Loans.SETRANGE("Loan  No.",LoanNo);
      Loans.SETRANGE("Mobile Loan",TRUE);
      Loans.SETFILTER("Outstanding Balance",'>0');
      IF Loans.FINDFIRST THEN BEGIN
          REPEAT
              IF Loans."Repayment Start Date" <> CALCDATE('1M',Loans."Issued Date") THEN BEGIN
                  Loans."Repayment Start Date" := CALCDATE('1M',Loans."Issued Date");
                  Loans.MODIFY;
              END;
              IF Loans."Expected Date of Completion" <> CALCDATE(FORMAT(Loans.Installments)+'M',Loans."Issued Date") THEN BEGIN
                  Loans."Expected Date of Completion" := CALCDATE(FORMAT(Loans.Installments)+'M',Loans."Issued Date");
                  Loans.MODIFY;
              END;
          UNTIL Loans.NEXT = 0;
      END;




      // Loans.RESET;
      // IF LoanNo <> '' THEN
      //     Loans.SETRANGE("Loan  No.",LoanNo);
      // Loans.SETRANGE("Mobile Loan",TRUE);
      // Loans.SETFILTER("Outstanding Balance",'>0');
      // Loans.SETRANGE(Installments,1);
      // Loans.SETFILTER(Loans."Expected Date of Completion",'%1',TODAY);
      // IF Loans.FINDFIRST THEN BEGIN
      //     REPEAT
      //         LoanPenalty(Loans."Loan  No.");
      //     UNTIL Loans.NEXT = 0;
      // END;




      // Loans.RESET;
      // IF LoanNo <> '' THEN
      //     Loans.SETRANGE("Loan  No.",LoanNo);
      // Loans.SETRANGE("Mobile Loan",TRUE);
      // Loans.SETFILTER("Outstanding Balance",'>0');
      // Loans.SETRANGE(Installments,1);
      // Loans.SETFILTER(Loans."Expected Date of Completion",'<%1',CALCDATE('-10D',TODAY));  //ten days grace period
      // IF Loans.FINDFIRST THEN BEGIN
      //     //ERROR('%1',Loans.COUNT);
      //     REPEAT
      //         LoanPenalty(Loans."Loan  No.");
      //     UNTIL Loans.NEXT = 0;
      // END;



      // Loans.RESET;
      // IF LoanNo <> '' THEN
      //     Loans.SETRANGE("Loan  No.",LoanNo);
      // Loans.SETRANGE("Mobile Loan",TRUE);
      // Loans.SETFILTER("Outstanding Balance",'>0');
      // Loans.SETRANGE(Installments,2);
      // Loans.SETFILTER(Loans."Expected Date of Completion",'<%1',TODAY);
      // IF Loans.FINDFIRST THEN BEGIN
      //     //ERROR('%1',Loans.COUNT);
      //     REPEAT
      //         LoanPenalty(Loans."Loan  No.");
      //     UNTIL Loans.NEXT = 0;
      // END;
    END;

    LOCAL PROCEDURE ReverseRecoveredLoans@1120054027(LoanNo@1120054011 : Code[20]);
    VAR
      msg@1001 : Text;
      SavAcc@1002 : Record 23;
      Loans@1000 : Record 51516230;
      LoanType@1004 : Record 51516240;
      CLedger@1005 : Record 51516224;
      PenaltyAmt@1006 : Decimal;
      JTemplate@1010 : Code[10];
      JBatch@1009 : Code[10];
      DocNo@1008 : Code[20];
      PDate@1007 : Date;
      AccNo@1011 : Code[20];
      AcctType@1014 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      BalAccType@1013 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      TransType@1012 : ' ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated';
      Dim1@1015 : Code[10];
      Dim2@1016 : Code[10];
      SystCreated@1017 : Boolean;
      FullyRecovered@1018 : Integer;
      LBal@1019 : Decimal;
      Members@1020 : Record 51516223;
      SaccoSetup@1120054000 : Record 51516700;
      FosaBal@1120054001 : Decimal;
      amtToRecover@1120054002 : Decimal;
      RunBal@1120054003 : Decimal;
      DedAmt@1120054004 : Decimal;
      AmtDeducted@1120054005 : Decimal;
      RecoveredFromFosa@1120054006 : Decimal;
      RecoveredFromBosa@1120054007 : Decimal;
      ExtDoc@1120054008 : Code[10];
      TotalRecovered@1120054009 : Decimal;
      CreditRating@1120054010 : Record 51516718;
      FullyRec@1120054012 : Boolean;
      NewBal@1120054013 : Decimal;
      NextLoanNo@1120054014 : Code[20];
    BEGIN


      Loans.RESET;
      IF LoanNo <> '' THEN
          Loans.SETRANGE("Loan  No.",LoanNo);
      Loans.SETRANGE(Defaulter,TRUE);
      Loans.SETRANGE("Mobile Loan",TRUE);
      Loans.SETRANGE(Loans.Installments,2);
      Loans.SETFILTER("Outstanding Balance",'<=0');
      Loans.SETFILTER(Loans."Expected Date of Completion",'>%1',TODAY);
      IF Loans.FINDFIRST THEN
          ERROR('%1',Loans.COUNT);


      {
      Loans.RESET;
      IF LoanNo <> '' THEN
          Loans.SETRANGE("Loan  No.",LoanNo);
      Loans.SETRANGE(Defaulter,TRUE);
      Loans.SETRANGE("Mobile Loan",TRUE);
      Loans.SETFILTER("Outstanding Balance",'<=0');
      Loans.SETFILTER(Loans."Expected Date of Completion",'>%1',TODAY);
      IF Loans.FINDFIRST THEN BEGIN
          //ERROR('%1',Loans.COUNT);
          REPEAT




              CreditRating.RESET;
              CreditRating.SETRANGE(CreditRating."Loan No.",Loans."Loan  No.");
              CreditRating.SETRANGE(Penalized,TRUE);
              CreditRating.SETRANGE("Member No",Loans."Client Code");
              CreditRating.SETRANGE("Loan Product Type",Loans."Loan Product Type");
              IF CreditRating.FINDFIRST THEN BEGIN
                  CreditRating."Penalty Date" := 0D;
                  CreditRating."Next Loan Application Date" := 0D;
                  CreditRating.Reversed := TRUE;
                  CreditRating.Penalized := FALSE;
                  CreditRating."Amount  Recovered From FOSA" := 0;
                  CreditRating."Amount Recovered From BOSA" := 0;
                  CreditRating.MODIFY;


                  Members.GET(Loans."Client Code");
                  Members."Loan Defaulter":=FALSE;
                  Members."Loans Defaulter Status":=Members."Loans Defaulter Status"::Perfoming;
                  Members.MODIFY;

                  Loans.Defaulter:=FALSE;
                  Loans."Defaulted install":=0;
                  Loans.MODIFY;
              END;


          UNTIL Loans.NEXT = 0;
      END;
      }
    END;

    PROCEDURE GetRecepientMobileNos@1120054023(PhoneNo@1102755000 : Text[30]) Response : Text;
    VAR
      SavAcc@1000 : Record 23;
      PFact@1002 : Record 51516717;
      xmlWriter@1008 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlTextWriter";
      EncodingText@1007 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
      XMLDOMMgt@1006 : Codeunit 6224;
      BodyContentXmlDoc@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      EnvelopeXmlNode@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      CreatedXmlNode@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      MbankingPhoneNos@1120054000 : Record 51516727;
    BEGIN

      Response:='';
      PhoneNo := '+'+PhoneNo;

          SavAcc.RESET;
          SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
          SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
          IF SavAcc.FINDFIRST THEN BEGIN
              MbankingPhoneNos.RESET;
              MbankingPhoneNos.SETRANGE(MbankingPhoneNos."Account No.",SavAcc."No.");
              IF MbankingPhoneNos.FINDFIRST THEN BEGIN
                  Response:=' <PhoneNos>';
                  REPEAT
                      Response+='<MobileNo>';
                          Response+='<Number>'+MbankingPhoneNos."Phone No."+'</Number>';
                          Response+='<Operator>'+FORMAT(MbankingPhoneNos.Operator)+'</Operator>';
                      Response+='</MobileNo>';
                  UNTIL MbankingPhoneNos.NEXT = 0;
                  Response+='</PhoneNos>';
              END;
          END;
      //D;
    END;

    LOCAL PROCEDURE UpdatePenaltyCounter@1120054025();
    VAR
      PenaltyCounter@1120054000 : Record 51516443;
      MemberLedgerEntry@1120054001 : Record 51516224;
      LoansRegister@1120054002 : Record 51516230;
      MaximumLoanLimit@1120054003 : Integer;
      DayLoanPaid@1120054004 : Date;
      NumberOfMonths@1120054005 : Decimal;
      TotaLoanBalance@1120054006 : Decimal;
    BEGIN
      PenaltyCounter.RESET;
      //PenaltyCounter.SETFILTER(PenaltyCounter."Loan Number",'LN016404');
      IF PenaltyCounter.FINDFIRST THEN BEGIN
        REPEAT
          IF LoansRegister.GET(PenaltyCounter."Loan Number") THEN BEGIN
            LoansRegister.CALCFIELDS(LoansRegister."Outstanding Balance",LoansRegister."Oustanding Interest",LoansRegister."Oustanding Penalty");
            TotaLoanBalance:=LoansRegister."Outstanding Balance"+LoansRegister."Oustanding Interest"+LoansRegister."Oustanding Penalty";
            IF TotaLoanBalance >0 THEN BEGIN
              PenaltyCounter."Date Penalty Paid" := 0D;
              PenaltyCounter.MODIFY;
            END ELSE BEGIN
              MemberLedgerEntry.RESET;
              MemberLedgerEntry.SETCURRENTKEY("Entry No.");
              MemberLedgerEntry.ASCENDING(FALSE);
              MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Loan No",LoansRegister."Loan  No.");
              MemberLedgerEntry.SETFILTER(MemberLedgerEntry."Transaction Type",'=%1|=%2',
              MemberLedgerEntry."Transaction Type"::"Penalty Paid",MemberLedgerEntry."Transaction Type"::"Interest Paid");
              IF MemberLedgerEntry.FINDFIRST THEN
                PenaltyCounter."Date Penalty Paid":=MemberLedgerEntry."Posting Date";
              PenaltyCounter.MODIFY;
            END;
          END;
        UNTIL PenaltyCounter.NEXT = 0;
      END;
    END;

    PROCEDURE UpdateDefaulterMembers@1120054026();
    BEGIN
      PenaltyCounter.RESET;
      IF PenaltyCounter.FINDFIRST THEN BEGIN
        REPEAT
          IF PenaltyCounter."Date Penalty Paid" =0D THEN BEGIN
              IF Members.GET(PenaltyCounter."Member Number") THEN
              Members."Loan Defaulter":=TRUE;
              Members.MODIFY(TRUE);
          END
        UNTIL PenaltyCounter.NEXT=0;
      END;




    END;

    PROCEDURE InsertMemberPenaltyCounter@1120054029();
    BEGIN
      PenaltyCounter.RESET;
      IF PenaltyCounter.FINDFIRST THEN BEGIN
        REPEAT
          IF PenaltyCounter."Date Penalty Paid" =0D THEN BEGIN
              IF Members.GET(PenaltyCounter."Member Number") THEN
              Members."Loan Defaulter":=TRUE;
              Members.MODIFY(TRUE);
          END
        UNTIL PenaltyCounter.NEXT=0;
      END;
    END;

    PROCEDURE GetMobileGuarantor@1120054037(Phone@1000 : Code[20]) Response : Text;
    VAR
      MobileNo@1001 : Code[20];
      Loans@1002 : Record 51516230;
      LoanProduct@1003 : Record 51516240;
      SavAcc@1004 : Record 23;
      MemberNo@1005 : Code[20];
      MaxLoan@1006 : Decimal;
      Cust@1007 : Record 51516223;
    BEGIN

      MobileNo:='+'+Phone;

      Response:='';
      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",MobileNo);
      SavAcc.SETFILTER(Status,'<>%1',SavAcc.Status::Deceased);
      IF SavAcc.FINDFIRST THEN BEGIN



          MemberNo := SavAcc."BOSA Account No";

      END;
    END;

    PROCEDURE NewLine@1120054031() NewLine : Text;
    VAR
      nL@1120054000 : Char;
    BEGIN

      nL := 13;
      NewLine := FORMAT(nL,0,'<CHAR>');
    END;

    PROCEDURE MobileGuarantorsAccepted@1120054030(LoanEntryNo@1120054000 : Integer) : Boolean;
    VAR
      SkyMobileLoans@1120054001 : Record 51516713;
      LoanType@1120054002 : Record 51516240;
      GCount@1120054003 : Integer;
      TotalGuaranteed@1120054004 : Decimal;
      MobileLoanGuarantors@1120054005 : Record 51516722;
      SavingsAccounts@1120054006 : Record 23;
      LoaneeDeposits@1120054007 : Decimal;
      MNo@1120054008 : Code[20];
      msg@1120054009 : Text;
      HMember@1120054010 : Record 51516223;
      FName@1120054011 : Text;
      Salute@1120054012 : Text;
    BEGIN
      SkyMobileLoans.GET(LoanEntryNo);

      LoanType.GET(SkyMobileLoans."Loan Product Type");
      GCount := SkyMobileLoans."Expected Guarantors";
      TotalGuaranteed := 0;

      MobileLoanGuarantors.RESET;
      MobileLoanGuarantors.SETRANGE("Loan Entry No.",LoanEntryNo);
      MobileLoanGuarantors.SETRANGE("Guarantor Accepted",MobileLoanGuarantors."Guarantor Accepted"::Yes);
      IF MobileLoanGuarantors.FINDFIRST THEN BEGIN
          MobileLoanGuarantors.CALCSUMS("Amount Guaranteed");
          TotalGuaranteed := MobileLoanGuarantors."Amount Guaranteed";
      END;

      LoaneeDepAcc := '';
      LoaneeDeposits := 0;
      SavingsAccounts.RESET;
      SavingsAccounts.SETRANGE("No.",SkyMobileLoans."Account No");
      IF SavingsAccounts.FINDFIRST THEN BEGIN
          MNo := SavingsAccounts."BOSA Account No";
          SavingsAccounts.RESET;
          SavingsAccounts.SETRANGE("BOSA Account No",MNo);
          SavingsAccounts.SETRANGE("Account Type",LoanType.Code);
          IF SavingsAccounts.FINDFIRST THEN
              LoaneeDepAcc := SavingsAccounts."No.";

      END;

      IF LoaneeDepAcc <> '' THEN
          LoaneeDeposits := GetAccountBalance(LoaneeDepAcc);


      //ERROR('%1\%2\%3',SkyMobileLoans."Requested Amount",TotalGuaranteed,LoaneeDeposits);

      IF SkyMobileLoans."Requested Amount" > (TotalGuaranteed+LoaneeDeposits) THEN BEGIN
        //Add Expected Guarantors
        SkyMobileLoans."Expected Guarantors" +=1;
        SkyMobileLoans.MODIFY;
        //Message the Lonee
              HMember.GET(SkyMobileLoans."Member No.");
              FName:=HMember.Name;
              IF FName='' THEN
              FName := HMember.Name;
              Salute:='Dear '+FirstName(FName)+','+NewLine;

        msg := Salute+
              NewLine+'The guarantors to your '+SkyMobileLoans."Loan Name"+' request of KES '+FORMAT(SkyMobileLoans.Amount)+', are insufficient. Please add one'
              +' more.'+NewLine+'REF: '+SkyMobileLoans."Entry Code";
        SendSms(Source::MBANKING,SkyMobileLoans."Telephone No",msg,FORMAT(SkyMobileLoans."Entry Code"),'',TRUE,205,FALSE);
        EXIT(FALSE);
      END ELSE BEGIN

          MobileLoanGuarantors.RESET;
          MobileLoanGuarantors.SETRANGE("Loan Entry No.",LoanEntryNo);
          MobileLoanGuarantors.SETRANGE("Guarantor Accepted",MobileLoanGuarantors."Guarantor Accepted"::Yes);
          IF MobileLoanGuarantors.FINDFIRST THEN BEGIN
              MobileLoanGuarantors.MODIFYALL(Status,MobileLoanGuarantors.Status::Approved);
          END;

          EXIT(TRUE);
      END;
    END;

    PROCEDURE UpdateAmountGuaranteed@1120054033(LoanEntryNo@1120054000 : Integer);
    VAR
      SkyMobileLoans@1120054001 : Record 51516713;
      MobileLoanGuarantors@1120054002 : Record 51516722;
    BEGIN
      SkyMobileLoans.GET(LoanEntryNo);

      IF SkyMobileLoans."Expected Guarantors" > 0 THEN BEGIN
          MobileLoanGuarantors.RESET;
          MobileLoanGuarantors.SETRANGE("Loan Entry No.",LoanEntryNo);
          MobileLoanGuarantors.SETRANGE("Guarantor Accepted",MobileLoanGuarantors."Guarantor Accepted"::Yes);
          //MobileLoanGuarantors.SETRANGE(Status,MobileLoanGuarantors.Status::Approved);
          IF MobileLoanGuarantors.FINDFIRST THEN BEGIN
              REPEAT
                  MobileLoanGuarantors.VALIDATE("Guarantor Member No.");
                  //MobileLoanGuarantors."Amount Guaranteed" := ROUND(SkyMobileLoans."Requested Amount"/SkyMobileLoans."Expected Guarantors",0.01,'>');
                  MobileLoanGuarantors.MODIFY;
                  COMMIT;
              UNTIL MobileLoanGuarantors.NEXT = 0;
          END;
      END;
    END;

    PROCEDURE GetRemainingGuarantorCount@1120054064(LoanEntryNo@1120054000 : Integer) : Integer;
    VAR
      SkyMobileLoans@1120054001 : Record 51516713;
      LoanType@1120054002 : Record 51516240;
      RemGuar@1120054003 : Integer;
      MobileLoanGuarantors@1120054004 : Record 51516722;
      TotalGuaranteed@1120054005 : Decimal;
    BEGIN
      SkyMobileLoans.GET(LoanEntryNo);

      LoanType.GET(SkyMobileLoans."Loan Product Type");
      RemGuar := SkyMobileLoans."Expected Guarantors";

      MobileLoanGuarantors.RESET;
      MobileLoanGuarantors.SETRANGE("Loan Entry No.",LoanEntryNo);
      MobileLoanGuarantors.SETRANGE("Guarantor Accepted",MobileLoanGuarantors."Guarantor Accepted"::Yes);
      IF MobileLoanGuarantors.FINDFIRST THEN BEGIN
          RemGuar -= MobileLoanGuarantors.COUNT;
          IF RemGuar < 0 THEN BEGIN
            RemGuar := 0;
            END
            ELSE BEGIN
              MobileLoanGuarantors.CALCSUMS("Amount Guaranteed");
              TotalGuaranteed := MobileLoanGuarantors."Amount Guaranteed";
              IF SkyMobileLoans.PendingAmount<0 THEN BEGIN
                  SkyMobileLoans.PendingAmount:=0;
                  SkyMobileLoans.MODIFY;
              END;
              IF (SkyMobileLoans."Requested Amount" <= TotalGuaranteed) OR (SkyMobileLoans."Requested Amount" < TotalGuaranteed) THEN
              RemGuar :=0;
              END;


      END;
      EXIT(RemGuar);

      // SkyMobileLoans.GET(LoanEntryNo);
      //
      // LoanType.GET(SkyMobileLoans."Loan Product Type");
      // RemGuar := SkyMobileLoans."Expected Guarantors";
      //
      // MobileLoanGuarantors.RESET;
      // MobileLoanGuarantors.SETRANGE("Loan Entry No.",LoanEntryNo);
      // MobileLoanGuarantors.SETRANGE("Guarantor Accepted",MobileLoanGuarantors."Guarantor Accepted"::Yes);
      // IF MobileLoanGuarantors.FINDFIRST THEN BEGIN
      //     RemGuar -= MobileLoanGuarantors.COUNT;
      //     IF RemGuar < 0 THEN
      //       RemGuar := 0;
      // END;
      // EXIT(RemGuar);
    END;

    PROCEDURE getLoansWithGuarantors@1120054032(PhoneNo@1120054000 : Code[30]) Response : Text;
    VAR
      SavingsAccounts@1120054001 : Record 23;
      SkyMobileLoans@1120054002 : Record 51516713;
    BEGIN
      PhoneNo := '+'+PhoneNo;
      Response := '';

      SavingsAccounts.RESET;
      SavingsAccounts.SETRANGE(SavingsAccounts."Transactional Mobile No",PhoneNo);
      IF SavingsAccounts.FIND('-') THEN BEGIN

          SkyMobileLoans.RESET;
          SkyMobileLoans.SETRANGE("Account No",SavingsAccounts."No.");
          SkyMobileLoans.SETRANGE(Status,SkyMobileLoans.Status::"Pending Guarantors");
          IF SkyMobileLoans.FINDFIRST THEN BEGIN
              Response += '<Loans>';
              REPEAT

                  Response += '<Loan>';
                      Response += '<EntryCode>'+FORMAT(SkyMobileLoans."Entry No")+'</EntryCode>';
                      Response += '<Name>'+SkyMobileLoans."Loan Name"+'</Name>';
                  Response += '</Loan>';

              UNTIL SkyMobileLoans.NEXT=0;
              Response += '</Loans>';
          END;

      END;
    END;

    PROCEDURE getLoanWithGuarantorDetails@1120054039(LoanEntryNo@1120054000 : Integer) Response : Text;
    VAR
      SkyMobileLoans@1120054001 : Record 51516713;
      Members@1120054002 : Record 51516223;
      SavingsAccounts@1120054003 : Record 23;
      LoanType@1120054004 : Record 51516240;
      MobileLoanGuarantors@1120054005 : Record 51516722;
      RemGuar@1120054006 : Integer;
      TotalGuaranteed@1120054007 : Decimal;
      LoaneeDeposits@1120054008 : Decimal;
      MNo@1120054009 : Code[30];
      A_R@1120054010 : Text;
    BEGIN

      SkyMobileLoans.GET(LoanEntryNo);

      Response := '';

      Response += '<Loan>';
          Response += '<EntryCode>'+FORMAT(SkyMobileLoans."Entry No")+'</EntryCode>';
          Response += '<Name>'+SkyMobileLoans."Loan Name"+'</Name>';
          Response += '<Amount>'+FORMAT(SkyMobileLoans.Amount)+'</Amount>';
          Response += '<PendingAmount>'+FORMAT(SkyMobileLoans.PendingAmount)+'</PendingAmount>';

          MobileLoanGuarantors.RESET;
          MobileLoanGuarantors.SETRANGE("Loan Entry No.",LoanEntryNo);
          MobileLoanGuarantors.SETFILTER("Guarantor Accepted",'<>%1',MobileLoanGuarantors."Guarantor Accepted"::No);
          //MobileLoanGuarantors.SETRANGE("Guarantor Mobile No.",PhoneNo);
          IF MobileLoanGuarantors.FINDFIRST THEN BEGIN
              Response += '<Guarantors Current="'+FORMAT(MobileLoanGuarantors.COUNT)+'" Required="'+FORMAT(SkyMobileLoans."Expected Guarantors")+'">';

              REPEAT
                  A_R:='';
                  IF MobileLoanGuarantors."Guarantor Accepted" = MobileLoanGuarantors."Guarantor Accepted"::No THEN
                    A_R:='(R)';
                  IF MobileLoanGuarantors."Guarantor Accepted" = MobileLoanGuarantors."Guarantor Accepted"::Yes THEN
                    A_R:='(A)';

                  Response += '<Guarantor>';
                    Response += '<Name>'+MobileLoanGuarantors."Guarantor Name"+' '+A_R+'</Name>';
                    Response += '<Mobile>'+MobileLoanGuarantors."Guarantor Mobile No."+'</Mobile>';
                    Response += '<MemberNumber>'+MobileLoanGuarantors."Guarantor Member No."+'</MemberNumber>';
                    Response += '<Accepted>'+FORMAT(MobileLoanGuarantors."Guarantor Accepted")+'</Accepted>';
                    Response += '<AmountGuaranteed>'+FORMAT(MobileLoanGuarantors."Amount Guaranteed")+'</AmountGuaranteed>';
                  Response += '</Guarantor>';

              UNTIL MobileLoanGuarantors.NEXT=0;
          END
          ELSE
              Response += '<Guarantors Current="'+FORMAT(0)+'" Required="'+FORMAT(SkyMobileLoans."Expected Guarantors")+'">';

          Response += '</Guarantors>';
      Response += '</Loan>';
    END;

    PROCEDURE GetBranches@1120054045() Response : Text;
    BEGIN

      Response := '';
      //
      // DimensionValue.RESET;
      // DimensionValue.SETRANGE("Dimension Code",'BRANCH');
      // IF DimensionValue.FINDFIRST THEN BEGIN
          Response += '<Branches>';
          //REPEAT

              Response += '<Branch>';
      //             Response += '<Code>'+DimensionValue.Code+'</Code>';
      //             Response += '<Name>'+DimensionValue.Name+'</Name>';
              Response += '</Branch>';

          //UNTIL DimensionValue.NEXT=0;
          Response += '</Branches>';
      //END;
    END;

    PROCEDURE getLoaneesAwaitingGuarantorship@1120054048(PhoneNo@1120054000 : Code[30];Status@1120054001 : Code[30]) Response : Text;
    VAR
      SkyMobileLoans@1120054002 : Record 51516713;
      Members@1120054003 : Record 51516223;
      SavingsAccounts@1120054004 : Record 23;
      LoanType@1120054005 : Record 51516240;
      MobileLoanGuarantors@1120054006 : Record 51516722;
      RemGuar@1120054007 : Integer;
      TotalGuaranteed@1120054008 : Decimal;
      LoaneeDeposits@1120054009 : Decimal;
      GMNo@1120054010 : Code[30];
      SavAcc@1120054011 : Record 23;
    BEGIN
      PhoneNo := '+'+PhoneNo;

      Response := '';

      GMNo := '';
      SavAcc.RESET;
      SavAcc.SETRANGE("Phone No.",PhoneNo);
      //SavAcc.SETRANGE(SavAcc."Account Type",'505');
      IF SavAcc.FINDFIRST THEN BEGIN
          GMNo := SavAcc."BOSA Account No";
      END;

      MobileLoanGuarantors.RESET;
      IF Status = 'ACCEPTED' THEN
      MobileLoanGuarantors.SETRANGE("Guarantor Accepted",MobileLoanGuarantors."Guarantor Accepted"::Yes);
      IF Status = 'PENDING' THEN
      MobileLoanGuarantors.SETRANGE("Guarantor Accepted",MobileLoanGuarantors."Guarantor Accepted"::Pending);
      IF Status = 'REJECTED' THEN
      MobileLoanGuarantors.SETRANGE("Guarantor Accepted",MobileLoanGuarantors."Guarantor Accepted"::No);
      MobileLoanGuarantors.SETRANGE("Guarantor Member No.",GMNo);
      MobileLoanGuarantors.SETRANGE("Loan Status",MobileLoanGuarantors."Loan Status"::"Pending Guarantors");
      IF MobileLoanGuarantors.FINDFIRST THEN BEGIN
          Response += '<Loanees>';
          REPEAT
              SkyMobileLoans.GET(MobileLoanGuarantors."Loan Entry No.");
              Response += '<Loanee Id="'+FORMAT(MobileLoanGuarantors."Loan Entry No.")+'" Name="'+SkyMobileLoans."Account Name"+'"/>';

          UNTIL MobileLoanGuarantors.NEXT=0;
          Response += '</Loanees>';

      END;
    END;

    PROCEDURE getDetailsForSpecificLoanGuaranteed@1120054038(PhoneNo@1120054013 : Code[30];LoanEntryNo@1120054001 : Integer) Response : Text;
    VAR
      SkyMobileLoans@1120054002 : Record 51516713;
      Members@1120054003 : Record 51516223;
      SavingsAccounts@1120054004 : Record 23;
      LoanType@1120054005 : Record 51516240;
      MobileLoanGuarantors@1120054006 : Record 51516722;
      RemGuar@1120054007 : Integer;
      TotalGuaranteed@1120054008 : Decimal;
      LoaneeDeposits@1120054009 : Decimal;
      MNo@1120054010 : Code[30];
      GMNo@1120054011 : Code[30];
      SavAcc@1120054012 : Record 23;
    BEGIN
      PhoneNo := '+'+PhoneNo;
      SkyMobileLoans.GET(LoanEntryNo);


      GMNo := '';
      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No",PhoneNo);
      //SavAcc.SETRANGE("Product Type",'505');//here
      IF SavAcc.FINDFIRST THEN BEGIN
          GMNo := SavAcc."BOSA Account No";
      END;


      Response := '';
      MobileLoanGuarantors.RESET;
      MobileLoanGuarantors.SETRANGE("Loan Entry No.",LoanEntryNo);
      //MobileLoanGuarantors.SETRANGE("Guarantor Accepted",MobileLoanGuarantors."Guarantor Accepted"::Pending);
      MobileLoanGuarantors.SETRANGE("Guarantor Member No.",GMNo);
      IF MobileLoanGuarantors.FINDFIRST THEN BEGIN

              Response += '<LoanGuaranteed>';
                Response += '<MemberName>'+SkyMobileLoans."Account Name"+'</MemberName>';
                Response += '<LoanName>'+SkyMobileLoans."Loan Name"+'</LoanName>';
                Response += '<Number>'+FORMAT(SkyMobileLoans."Entry No")+'</Number>';
                Response += '<Amount>'+FORMAT(SkyMobileLoans.Amount)+'</Amount>';
                Response += '<Date>'+FORMAT(SkyMobileLoans.Date)+'</Date>';
                Response += '<Mobile>'+FORMAT(SkyMobileLoans."Telephone No")+'</Mobile>';
              Response += '</LoanGuaranteed>';

      END;
    END;

    PROCEDURE getLoanAccessSetup@1120054040(PhoneNo@1120054000 : Code[30]) Response : Text;
    VAR
      SavingsAccounts@1120054001 : Record 23;
      MobileLoanGuarantors@1120054002 : Record 51516722;
    BEGIN
      PhoneNo := '+'+PhoneNo;
      Response := '';

      SavingsAccounts.RESET;
      SavingsAccounts.SETRANGE(SavingsAccounts."Transactional Mobile No",PhoneNo);
      IF SavingsAccounts.FIND('-') THEN BEGIN

          Members.GET(SavingsAccounts."BOSA Account No");

          IF (Members."Employer Code"='9901') OR (Members."Employer Code"='9902') THEN BEGIN
              Response += '<LoansSetup>';
                  Response += '<CanAccessLoans>'+'FALSE'+'</CanAccessLoans>';
                  Response += '<AccessMessage>'+'Sorry, kindly visit your nearest branch or contact us to access loan services'+'</AccessMessage>';

                  MobileLoanGuarantors.RESET;
                  MobileLoanGuarantors.SETFILTER("Guarantor Accepted",'%1',MobileLoanGuarantors."Guarantor Accepted"::Pending);
                  MobileLoanGuarantors.SETRANGE("Guarantor Member No.",Members."No.");
                  MobileLoanGuarantors.SETRANGE("Loan Status",MobileLoanGuarantors."Loan Status"::"Pending Guarantors");
                  IF MobileLoanGuarantors.FINDFIRST THEN
                      Response += '<HasPendingGuarantorship>'+'TRUE'+'</HasPendingGuarantorship>'
                  ELSE
                      Response += '<HasPendingGuarantorship>'+'FALSE'+'</HasPendingGuarantorship>';

              Response += '</LoansSetup>';
          END
          ELSE BEGIN

              Response += '<LoansSetup>';
                  Response += '<CanAccessLoans>'+'TRUE'+'</CanAccessLoans>';
                  Response += '<AccessMessage>'+'Success'+'</AccessMessage>';

                  MobileLoanGuarantors.RESET;
                  MobileLoanGuarantors.SETFILTER("Guarantor Accepted",'%1',MobileLoanGuarantors."Guarantor Accepted"::Pending);
                  MobileLoanGuarantors.SETRANGE("Guarantor Member No.",Members."No.");
                  MobileLoanGuarantors.SETRANGE("Loan Status",MobileLoanGuarantors."Loan Status"::"Pending Guarantors");
                  IF MobileLoanGuarantors.FINDFIRST THEN
                      Response += '<HasPendingGuarantorship>'+'TRUE'+'</HasPendingGuarantorship>'
                  ELSE
                      Response += '<HasPendingGuarantorship>'+'FALSE'+'</HasPendingGuarantorship>';

              Response += '</LoansSetup>';
          END;
      END;
    END;

    PROCEDURE getLoanBalance@1120054044(LoanNo@1120054000 : Code[30]) Bal : Text;
    VAR
      Loans@1120054001 : Record 51516230;
      arrears@1120054002 : Decimal;
      balance@1120054003 : Decimal;
    BEGIN

      Bal := '';

      Loans.RESET;
      Loans.SETRANGE("Loan  No.",LoanNo);
      IF Loans.FINDFIRST THEN BEGIN

          Loans.CALCFIELDS("Outstanding Balance","Oustanding Interest");
      //     IF Loans."Outstanding Bills" < 0 THEN
      //       Loans."Outstanding Bills" := 0;
          IF Loans."Oustanding Interest" < 0 THEN
            Loans."Oustanding Interest" := 0;

          arrears := (Loans."Oustanding Interest");
          balance := (Loans."Outstanding Balance"+Loans."Oustanding Interest");

          //Bal := 'Loan Arrears: KES '+FORMAT(arrears)+NewLine+'Loan Balance: KES '+FORMAT(balance);
          Bal := 'Loan Balance: KSH '+FORMAT(balance);
      END;
    END;

    PROCEDURE actionLoanGuarantorship@1120054047(MobileNo@1120054000 : Code[30];LoanEntryNo@1120054001 : Integer;PIN@1120054002 : Text;Action@1120054003 : Code[30];Amount@1120054009 : Decimal) Response : Text;
    VAR
      GMNo@1120054004 : Code[30];
      SavAcc@1120054005 : Record 23;
      SkyMobileLoans@1120054006 : Record 51516713;
      MobileLoanGuarantors@1120054007 : Record 51516722;
      msg@1120054008 : Text;
      RemAmount@1120054010 : Decimal;
      LoanAmount@1120054011 : Decimal;
      DeductionAmount@1120054012 : Decimal;
    BEGIN
      Response := 'ERROR';


      IF COPYSTR(MobileNo,1,1) <> '+' THEN
        MobileNo := '+'+MobileNo;

      // IF NOT CorrectPin(MobileNo,PIN) THEN BEGIN
      //     Response := 'INCORRECT_PIN';
      //     EXIT;
      // END;

      GMNo:='';

      SavAcc.RESET;
      SavAcc.SETRANGE("Phone No.",MobileNo);
      //SavAcc.SETRANGE("Product Type",'505');//here
      IF SavAcc.FINDFIRST THEN
          GMNo := SavAcc."BOSA Account No";

      SkyMobileLoans.GET(LoanEntryNo);


      MobileLoanGuarantors.RESET;
      MobileLoanGuarantors.SETRANGE("Loan Entry No.",LoanEntryNo);
      MobileLoanGuarantors.SETRANGE("Guarantor Member No.",GMNo);
      // SkyMobileLoans.SETRANGE(Amount);

      IF MobileLoanGuarantors.FINDFIRST THEN BEGIN
          IF Action = 'ACCEPT' THEN BEGIN

              MobileLoanGuarantors."Guarantor Accepted" := MobileLoanGuarantors."Guarantor Accepted"::Yes;
              MobileLoanGuarantors."Amount Guaranteed" := Amount;


      //         IF SkyMobileLoans.PendingAmount <= 0 THEN
      //         EXIT(SkyMobileLoans.PendingAmount);
              SkyMobileLoans.PendingAmount:=SkyMobileLoans.PendingAmount-MobileLoanGuarantors."Amount Guaranteed";
              SkyMobileLoans.MODIFY;

      //         MobileLoanGuarantors.CALCSUMS("Amount Guaranteed");
      //         SkyMobileLoans."Amount Guaranteed" := MobileLoanGuarantors."Amount Guaranteed";
      //         SkyMobileLoans.MODIFY;

              IF SavAcc.GET(SkyMobileLoans."Account No") THEN BEGIN
                IF SkyMobileLoans.PendingAmount <= 0 THEN BEGIN
                  Priority := 211;
                  msg := 'Dear '+GetSMSSalutation(SkyMobileLoans."Member No.")+GetSMSSalutation(MobileLoanGuarantors."Guarantor Member No.")+
                  ' has guarantee your '+SkyMobileLoans."Loan Name"+' with KES '+FORMAT(MobileLoanGuarantors."Amount Guaranteed")+' of her shares'+' on '+FORMAT(ddMMyyyy(TODAY))+' at '+FORMAT(TIME) +
                  NewLine+'your have been fully guaranteed ' +' REF: '+FORMAT(SkyMobileLoans."Entry No");
                  SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,SavAcc."No.",'',TRUE,Priority,FALSE);

                  Priority := 211;
                  msg := 'Dear '+GetSMSSalutation(MobileLoanGuarantors."Guarantor Member No.")+'you have guaranteed '+GetSMSSalutation(SkyMobileLoans."Member No.")+' '+SkyMobileLoans."Loan Name"+' with KES '+
                  FORMAT(MobileLoanGuarantors."Amount Guaranteed")+' on '+FORMAT(ddMMyyyy(TODAY))+' at '+FORMAT(TIME) +'.'+NewLine+'REF: '+FORMAT(SkyMobileLoans."Entry No");
                  SendSms(Source::MBANKING,MobileLoanGuarantors."Guarantor Mobile No.",msg,SavAcc."No.",'',TRUE,Priority,FALSE);
                  Response := 'SUCCESS';
                  END
                  ELSE BEGIN
                  Priority := 211;
      //               Dear GERISHOM, NELLY has guarantee your Reloaded Plus with KESXXXX of her shares on 16/03/2023 at  4:03:29 PM; balance to be guaranted is 500 REF: 23178
                  msg := 'Dear '+GetSMSSalutation(SkyMobileLoans."Member No.")+GetSMSSalutation(MobileLoanGuarantors."Guarantor Member No.")+
                  ' has guarantee your '+SkyMobileLoans."Loan Name"+' with KES '+FORMAT(MobileLoanGuarantors."Amount Guaranteed")+' of her shares'+' on '+FORMAT(ddMMyyyy(TODAY))+' at '+FORMAT(TIME) +
                  NewLine+'balance to be guaranted '+FORMAT(SkyMobileLoans.PendingAmount) +' REF: '+FORMAT(SkyMobileLoans."Entry No");
                  SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,SavAcc."No.",'',TRUE,Priority,FALSE);

                  Priority := 211;
      //             Dear NELLY, you have guaranteed GERISHOM Reloaded Plus loan with KES.xxxx of your shares on 16/03/2023 at  4:03:29 PM. REF: 23178
                  msg := 'Dear '+GetSMSSalutation(MobileLoanGuarantors."Guarantor Member No.")+'you have guaranteed '+GetSMSSalutation(SkyMobileLoans."Member No.")+''+SkyMobileLoans."Loan Name"+' with KES '+
                  FORMAT(MobileLoanGuarantors."Amount Guaranteed")
                +' on '+FORMAT(ddMMyyyy(TODAY))+' at '+FORMAT(TIME) +'.'+NewLine+'REF: '+FORMAT(SkyMobileLoans."Entry No");
                  SendSms(Source::MBANKING,MobileLoanGuarantors."Guarantor Mobile No.",msg,SavAcc."No.",'',TRUE,Priority,FALSE);
                  Response := 'SUCCESS';
                END;

              END;

          END
          ELSE IF Action = 'REJECT' THEN BEGIN
              MobileLoanGuarantors."Guarantor Accepted" := MobileLoanGuarantors."Guarantor Accepted"::No;
              IF SavAcc.GET(SkyMobileLoans."Account No") THEN BEGIN
                  Priority := 211;
                  msg := 'Dear '+GetSMSSalutation(SkyMobileLoans."Member No.")+', '+GetSMSSalutation(MobileLoanGuarantors."Guarantor Member No.")+
                  ' has rejected your request to guarantee your '+SkyMobileLoans."Loan Name"+' on '+FORMAT(ddMMyyyy(TODAY))+' at '+FORMAT(TIME) +
                  ' Kindly add a new guarantor.'+NewLine+'REF: '+FORMAT(SkyMobileLoans."Entry No");
                  SendSms(Source::MBANKING,SavAcc."Transactional Mobile No",msg,SavAcc."No.",'',TRUE,Priority,FALSE);

                  Priority := 211;
                  msg := 'Dear '+GetSMSSalutation(MobileLoanGuarantors."Guarantor Member No.")+', you have rejected '+GetSMSSalutation(SkyMobileLoans."Member No.")+'''s request to guarantee '+
                  ' '+SkyMobileLoans."Loan Name"+' on '+FORMAT(ddMMyyyy(TODAY))+' at '+FORMAT(TIME) +'.'+NewLine+'REF: '+FORMAT(SkyMobileLoans."Entry No");
                  SendSms(Source::MBANKING,MobileLoanGuarantors."Guarantor Mobile No.",msg,SavAcc."No.",'',TRUE,Priority,FALSE);
                  Response := 'SUCCESS';
              END;
          END;
          MobileLoanGuarantors.MODIFY;
      END
      ELSE
          ERROR('Guarantor Not Found');

      COMMIT;
      ProcessMobileLoan(LoanEntryNo);
    END;

    PROCEDURE GetLoanPurpose@1120054053() Response : Text;
    BEGIN
      Response:='';


      Response:='<LoanApplicationPurposes>';
          Response += '<Purpose Id="1180" Title="Agriculture"/>';
          Response += '<Purpose Id="2220" Title="Trade"/>';
          Response += '<Purpose Id="3120" Title="Manufacturing and Services Industries"/>';
          Response += '<Purpose Id="4120" Title="Education"/>';
          Response += '<Purpose Id="5110" Title="Human Health"/>';
          Response += '<Purpose Id="6110" Title="Land and Housing"/>';
          Response += '<Purpose Id="7210" Title="Finance Investment and Insurance"/>';
          Response += '<Purpose Id="8210" Title="Consumption and Social activities"/>';
      Response+='</LoanApplicationPurposes>';
    END;

    PROCEDURE GetLoanQualification@1120054062(PhoneNo@1120054000 : Code[30];LoanType@1120054001 : Code[30]) Response : Text;
    VAR
      LoanProduct@1120054002 : Record 51516240;
      SavAcc@1120054003 : Record 23;
      LoanLimit@1120054004 : Decimal;
      Amount@1120054005 : Decimal;
      MaxLoanAmount@1120054006 : Decimal;
      saccoAccount@1120054007 : Record 23;
      AccountNo@1120054008 : Code[30];
      Msg@1120054009 : Text;
      Success@1120054010 : Boolean;
      ShareCap@1120054011 : Decimal;
      Loans@1120054012 : Record 51516230;
    BEGIN
      MaxLoanAmount := 0;
      Response:= '';
      LoanLimit := 0;
      Amount := 0;
      Msg := '';
      Success := TRUE;

      SavAcc.RESET;
      SavAcc.SETRANGE("Transactional Mobile No", '+'+PhoneNo);
      IF SavAcc.FINDFIRST THEN BEGIN
        Members.GET(SavAcc."BOSA Account No");
        LoanProduct.RESET;
        LoanProduct.SETRANGE(Code, LoanType);
        IF LoanProduct.FIND('-') THEN BEGIN
          IF (LoanProduct.Code = 'A03') OR (LoanProduct.Code = 'A16') THEN BEGIN
            GetLoanQualifiedAmount(SavAcc."No.",LoanType,Msg,LoanLimit);
          END
          ELSE IF LoanProduct.Code = 'A01' THEN BEGIN
            GetSalaryLoanQualifiedAmount(SavAcc."No.",LoanType,LoanLimit,Msg);
          END
          ELSE IF LoanProduct.Code = 'A10' THEN BEGIN
            GetReloadedLoanQualifiedAmount(SavAcc."No.",LoanType,LoanLimit,Msg);
          END
          ELSE IF LoanProduct.Code = 'M_OD' THEN BEGIN
           GetOverdraftLoanQualifiedAmount(SavAcc."No.",LoanType,LoanLimit,Msg);
          END;
        END;
        Amount := LoanLimit;

        IF Msg = '' THEN BEGIN
          Msg := 'Your qualified amount is '+FORMAT(LoanLimit)+'';
        END;

        IF NOT (SaccoTrans.ActiveMobileMember(SavAcc."BOSA Account No")) THEN BEGIN
            LoanLimit := 0;
            Msg := 'Your qualified amount is '+FORMAT(LoanLimit)+'';
        END;

        Members.CALCFIELDS(Members."Shares Retained",Members."Current Shares");
        IF Members."Registration Date" = 0D THEN BEGIN
            LoanLimit := 0;
            Msg := 'Your qualified amount is '+FORMAT(LoanLimit)+'';
        END;

        IF CALCDATE('6M',Members."Registration Date") > TODAY THEN BEGIN
          LoanLimit := 0;
          Msg := 'Your qualified amount is '+FORMAT(LoanLimit)+'';
        END;

        IF Members."Current Shares" <= 0 THEN BEGIN
          LoanLimit := 0;
          Msg := 'Your qualified amount is '+FORMAT(LoanLimit)+'';
        END;

        IF SaccoSetup."Minimum Share Capital" > Members."Shares Retained" THEN BEGIN
           LoanLimit := 0;
           Msg := 'Your qualified amount is '+FORMAT(LoanLimit)+'';
        END;

       //Check Share Capital
        ShareCap:=0;
        Members.CALCFIELDS("Shares Retained");
        ShareCap := Members."Shares Retained";
        SaccoSetup.GET;
        SaccoSetup.TESTFIELD("Minimum Share Capital");

        IF (ShareCap < SaccoSetup."Minimum Share Capital") THEN BEGIN
          LoanLimit := 0;
          Msg := 'Your qualified amount is '+FORMAT(LoanLimit)+'';
        END;

        //Check Defaulter
        Loans.RESET;
        Loans.SETRANGE("Client Code",Members."No.");
        Loans.SETFILTER("Loans Category-SASRA",'%1|%2|%3|%4',Loans."Loans Category-SASRA"::Watch,Loans."Loans Category-SASRA"::Substandard,
        Loans."Loans Category-SASRA"::Doubtful,Loans."Loans Category-SASRA"::Loss);
        Loans.SETFILTER("Outstanding Balance",'>0');
        IF Loans.FINDFIRST THEN BEGIN
          LoanLimit := 0;
          Msg := 'Your qualified amount is '+FORMAT(LoanLimit)+' Loan Type:'+Loans."Loan Product Type Name";
        END;

        IF LoanType <> 'A16' THEN BEGIN
            Loans.RESET;
            Loans.SETRANGE("Client Code",Members."No.");
            Loans.SETFILTER(Loans."Loan Product Type",LoanType);
            Loans.SETFILTER("Outstanding Balance",'>0');
            IF Loans.FINDFIRST THEN BEGIN
              LoanLimit := 0;
              Msg := 'Your qualified amount is '+FORMAT(LoanLimit)+'';
            END;
        END;

        Response += '<Qualification>';
          Response += '<Amount>'+FORMAT(LoanLimit)+'</Amount>';
          Response += '<Message>'+Msg+'</Message>';
        Response += '</Qualification>';
      END;
    END;

    LOCAL PROCEDURE DateTimeToText@1120054056(RealDateTime@1120054000 : DateTime) : Text;
    BEGIN
      IF RealDateTime = 0DT THEN EXIT('');
      EXIT(FORMAT(DATE2DMY(DT2DATE(RealDateTime),1))+'-'+FORMAT(DATE2DMY(DT2DATE(RealDateTime),2))+'-'+FORMAT(DATE2DMY(DT2DATE(RealDateTime),3))+' '+FORMAT(DT2TIME(RealDateTime)));
    END;

    PROCEDURE getBooleanLoansWithGuarantors@1120054049(PhoneNo@1120054000 : Code[30]) Response : Boolean;
    VAR
      SavingsAccounts@1120054001 : Record 23;
      SkyMobileLoans@1120054002 : Record 51516713;
    BEGIN
      PhoneNo := '+'+PhoneNo;
      Response := FALSE;

      SavingsAccounts.RESET;
      SavingsAccounts.SETRANGE(SavingsAccounts."Transactional Mobile No",PhoneNo);
      IF SavingsAccounts.FIND('-') THEN BEGIN

          SkyMobileLoans.RESET;
          SkyMobileLoans.SETRANGE("Account No",SavingsAccounts."No.");
          SkyMobileLoans.SETRANGE(Status,SkyMobileLoans.Status::"Pending Guarantors");
          IF SkyMobileLoans.FINDFIRST THEN BEGIN
      //         Response += '<Loans>';
      //         REPEAT
      //
      //             Response += '<Loan>';
      //                 Response += '<EntryCode>'+FORMAT(SkyMobileLoans."Entry No")+'</EntryCode>';
      //                 Response += '<Name>'+SkyMobileLoans."Loan Name"+'</Name>';
      //             Response += '</Loan>';
      //
      //         UNTIL SkyMobileLoans.NEXT=0;
      //         Response += '</Loans>';

      Response := TRUE;
          END;

      END;
    END;

    PROCEDURE GetRemainingAmountCount@1120054043(LoanEntryNo@1120054000 : Integer) : Integer;
    VAR
      SkyMobileLoans@1120054001 : Record 51516713;
      LoanType@1120054002 : Record 51516240;
      RemAmount@1120054003 : Decimal;
      MobileLoanGuarantors@1120054004 : Record 51516722;
      MobileLoan@1120054005 : Decimal;
      LoanAmount@1120054006 : Decimal;
      DeductionAmount@1120054007 : Decimal;
    BEGIN

      // SkyMobileLoans.GET(LoanEntryNo);
      //
      // LoanType.GET(SkyMobileLoans."Loan Product Type");
      // RemAmount := SkyMobileLoans.PendingAmount;
      // LoaNAmount := SkyMobileLoans.Amount;
      //
      //
      // MobileLoanGuarantors.RESET;
      // MobileLoanGuarantors.SETRANGE("Loan Entry No.",LoanEntryNo);
      // MobileLoanGuarantors.SETRANGE("Guarantor Accepted",MobileLoanGuarantors."Guarantor Accepted"::Yes);
      // MobileLoanGuarantors.CALCFIELDS("Guarantor Accepted",MobileLoanGuarantors."Guarantor Accepted"::Yes);
      // IF MobileLoanGuarantors.FINDFIRST THEN BEGIN
      //     RemGuar -= MobileLoanGuarantors.COUNT;
      //     IF RemGuar < 0 THEN
      //       RemGuar := 0;
      // END;
      // EXIT(RemGuar);
    END;

    LOCAL PROCEDURE GetSMSSalutation@1120054051(MemberNo@1120054000 : Code[20]) Salute : Text;
    VAR
      TMember@1120054001 : Record 51516223;
      FName@1120054002 : Text;
    BEGIN
      TMember.GET(MemberNo);
      FName:=TMember.Name;
      IF FName='' THEN
      FName := TMember.Name;
      Salute:=FirstName(FName)+','+NewLine;
    END;

    BEGIN
    {
      //    IF SkyMobileLoans."Approved Amount" > BalanceToCommit THEN BEGIN
      //     SkyMobileLoans."Approved Amount" := BalanceToCommit;
      //     END;
    }
    END.
  }
}

