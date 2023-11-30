OBJECT CodeUnit 20367 Coop Processing
{
  OBJECT-PROPERTIES
  {
    Date=03/24/23;
    Time=10:44:56 AM;
    Modified=Yes;
    Version List=SkyCoop;
  }
  PROPERTIES
  {
    OnRun=VAR
            Vendor@1120054000 : Record 23;
            TNo@1120054001 : Code[50];
            TransID@1120054002 : Code[10];
          BEGIN
            {
            Vendor.GET('0502-001-08583');
            Vendor."ATM No." := '4299334874149078';
            Vendor.MODIFY;
            }
            //PostATM('');
            //4299348600580976
            //ReverseTransaction('RVS000001','TR0000003','BALANCE_ENQ',
            //MESSAGE('%1',
            //BalanceEnquiry('TR00r004','BAL_ENQ',CURRENTDATETIME,'TM001','APP','11111','1000002','SIT','YETU SACCO LTD',10,'KES',30,'KES','Balance Enquiry'));

            //MESSAGE(BalanceEnquiry('ServiceName','TRN0001',CURRENTDATETIME,'TM001','ATM',ConnectionMode,'B_A/C_001','4299337600286155','001','Telepost',10,'404',20,'404','',''));


            //MESSAGE(BalanceEnquiryNew('ServiceName','TR0011',CURRENTDATETIME,'TM001','ATM',ConnectionMode,'B_A/C_001','4299337600286155','001','Telepost',10,'404',20,'404','',''));


            //MESSAGE(MiniStatement('ServiceName','TRN0007',10,'TM001','ATM',CURRENTDATETIME,'4299337600286155','+254706405989','B_A/C_001',12,'404',22,'404','Mini Statement','001','',''));


            //MESSAGE(FundsTransfer('ServiceName','TR000000000000000000000000000000000044',CURRENTDATETIME,'TM01','ATM',ConnectionMode,'0011','','001','TELEPOST',500,'KES','4299337600286155','B_A/C_001',15,'404',25,'404','Cash Withdrawal','','',''));

            //Reversal
            //MESSAGE(FundsTransfer('FT','106906004119_CS_POSTFUNDS2',CURRENTDATETIME,'POS03170','0002P001',
            //ConnectionMode,'1420','106906004119_CS_POSTFUNDS','001','TELEPOST',1800,'KES','4299337600286155','B_A/C_001',15,'404',25,'404','Cash Withdrawal','','',''));
            // CoopSetup.GET;
            // CoopTrans.RESET;
            // IF TransID <>'220205823196_CS_POSTFUNDS' THEN BEGIN
            // CoopTrans.SETRANGE(Skipped,FALSE);
            // CoopTrans.SETRANGE(Posted,FALSE);
            // END;
            // CoopTrans.SETRANGE("Transaction ID",'220205823196_CS_POSTFUNDS');
            // IF CoopTrans.FINDFIRST THEN BEGIN

            PostATM('306011985520_CS_BALANCE');

            //MESSAGE('PostATM')
            // END;

            //MESSAGE('%1',GetAccountBalance('0502-001-09366',TODAY));
            MESSAGE('Done');
          END;

  }
  CODE
  {
    VAR
      ExciseDutyGL@1000 : Code[20];
      ExciseDutyRate@1001 : Decimal;
      ExciseDuty@1002 : Decimal;
      CoopSetup@1003 : Record 170040;
      ChargeAmount@1006 : Decimal;
      TransAmount@1007 : Decimal;
      JTemplate@1009 : Code[10];
      JBatch@1010 : Code[10];
      GenLedgerSetup@1011 : Record 98;
      GenSetup@1012 : Record 51516700;
      BUser@1013 : Record 91;
      SaccoTrans@1015 : CodeUnit 20366;
      CoopTrans@1016 : Record 170041;
      DocNo@1017 : Code[20];
      PDate@1018 : Date;
      AcctType@1024 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      BalAccType@1023 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,Investor';
      TransType@1022 : ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal Due,Ledger Fee,Appraisal Paid,Pre-Earned Interest,Penalty Due,Penalty Paid';
      AccNo@1021 : Code[20];
      BalAccNo@1020 : Code[20];
      SourceType@1019 : 'New Member,New Account,Loan Account Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit, Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued';
      ExtDoc@1025 : Code[20];
      LoanNo@1026 : Code[20];
      Dim1@1027 : Code[10];
      Dim2@1028 : Code[10];
      SystCreated@1029 : Boolean;
      SLedger@1030 : Record 25;
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
      CoopCode@1042 : Record 170042;
      Continue@1043 : Boolean;
      LedgerCount@1044 : Integer;
      CurrRecord@1045 : Integer;
      EndRec@1046 : TextConst 'ENU=\::::/';
      SavAcc@1004 : Record 23;
      GenJournalBatch@1120054000 : Record 232;
      SkyMbanking@1120054001 : CodeUnit 20416;
      ConnectionMode@1120054002 : Text;
      xmlLTextWriter@1120054007 : DotNet "'Newtonsoft.Json, Version=6.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed'.Newtonsoft.Json.JsonTextWriter";
      xmlWriter@1120054006 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlTextWriter";
      EncodingText@1120054005 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
      StringBuilder@1120054004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.StringBuilder";
      StringWriter@1120054003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.StringWriter";
      ATM_No@1120054008 : Text;
      BankCharge@1120054009 : Decimal;
      SaccoFee@1120054010 : Decimal;
      ChannelCode@1120054011 : Code[10];
      TerminalCode@1120054012 : Code[10];
      CRate@1120054013 : Decimal;

    PROCEDURE GetAccountBalance@1120054000(Account@1102755000 : Text[30];BDate@1120054000 : Date) AccountBal : Decimal;
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
      savAccList.SETFILTER("Date Filter",'..%1',BDate);
      IF savAccList.FIND('-') THEN BEGIN
          savAccList.CALCFIELDS("Mpesa Withdrawals","Coop Transaction","Balance (LCY)","EFT Transactions","ATM Transactions","Uncleared Cheques",savAccList."Authorised Over Draft");
          IF AccountTypes.GET(savAccList."Account Type") THEN BEGIN
              AccountBal:=(savAccList."Balance (LCY)"+savAccList."Authorised Over Draft")
                            - AccountTypes."Minimum Balance"
                            - savAccList."EFT Transactions"
                            - savAccList."Coop Transaction"
                            - savAccList."Mpesa Withdrawals"
                            - savAccList."Uncleared Cheques"
                            - savAccList."ATM Transactions";

          END;
      END;
      EXIT(AccountBal);
    END;

    PROCEDURE BalanceEnquiry@46(serviceName@1000 : Text;RequestReference@1102755001 : Text;TransactionDate@1011 : DateTime;TerminalID@1012 : Text;Channel@1013 : Text;ConnectionMode@1010 : Text;CreditAccount@1014 : Text;DebitAccount@1015 : Text;InstitutionCode@1016 : Text;InstitutionName@1017 : Text[100];ChargeAmount@1018 : Decimal;ChargeCurrency@1019 : Text;FeeAmount@1020 : Decimal;FeeCurrency@1021 : Text;deviceType@1120054008 : Text;location@1120054007 : Text;conversionRate@1120054006 : Text) Response : Text;
    VAR
      i@1001 : Decimal;
      MemberNo@1002 : Text[30];
      AccBalance@1003 : Decimal;
      thisSavAccNo@1004 : Text[30];
      foundChargeAccount@1006 : Boolean;
      A@1007 : Integer;
      MNo@1008 : Code[20];
      AcctNo@1009 : Code[20];
      TotalCharge@1023 : Decimal;
      AccBal@1024 : Decimal;
      RespTransactionID@1028 : Text;
      RespStatusCode@1025 : Text;
      RespStatusDescription@1026 : Text;
      RespTransactionDate@1027 : DateTime;
      RespTransactionReference@1029 : Text;
      RespInstitutionCode@1030 : Text;
      RespDebitAccount@1031 : Text;
      RespAccountBookBalance@1032 : Decimal;
      RespAccountClearedBalance@1033 : Decimal;
      RespAccountCurrency@1034 : Text;
      xmlLTextWriter@1120054005 : DotNet "'Newtonsoft.Json, Version=6.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed'.Newtonsoft.Json.JsonTextWriter";
      xmlWriter@1120054003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlTextWriter";
      EncodingText@1120054002 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
      StringBuilder@1120054001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.StringBuilder";
      StringWriter@1120054000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.StringWriter";
      TransactionType@1120054004 : Code[10];
    BEGIN



      ChannelCode :='';
      TerminalCode:='';


      IF Channel <> '' THEN
        ChannelCode := COPYSTR(Channel,4,2);

      IF TerminalID <> '' THEN
        TerminalCode := COPYSTR(TerminalID,1,3);

      IF TerminalCode = 'ATM' THEN
        ChannelCode := '';
      IF TerminalCode = 'POS' THEN
        ChannelCode := '';

      TransactionType := '0016';
      IF NOT CoopCode.GET(TransactionType,TerminalCode,ChannelCode) THEN BEGIN
          TerminalCode:='';
          ChannelCode:='';
      END;




      // Get Excise duty G/L
      ExciseDutyGL := GetExciseDutyGL();
      ExciseDutyRate := GetExciseRate();
      ExciseDuty:=0;

      {
      TotalCharge:=ChargeAmount+FeeAmount;
      ExciseDuty:=ROUND(FeeAmount*ExciseDutyRate/100);
      }


      BankCharge:=0;
      SaccoFee:=0;
      GetATMcharges(TransactionType,TerminalCode,ChannelCode,0,BankCharge,SaccoFee);
      TotalCharge:=BankCharge+SaccoFee;
      ExciseDuty:=ROUND(SaccoFee*ExciseDutyRate/100);





      CoopSetup.GET;


      RespTransactionID:=RequestReference;
      RespTransactionDate:=TransactionDate;
      RespTransactionReference:=Null;
      CoopSetup.TESTFIELD("Institution Code");
      RespInstitutionCode:=CoopSetup."Institution Code";
      RespDebitAccount:=DebitAccount;
      RespAccountBookBalance:=0;
      RespAccountClearedBalance:=0;
      RespAccountCurrency:='KES';

      ATM_No := DebitAccount;
      DebitAccount := GetAccountNoFromATMNo(DebitAccount);

      IF SavAcc.GET(DebitAccount) THEN BEGIN

          AccBal := GetAccountBalance(SavAcc."No.",TODAY);
          IF AccBal >= TotalCharge+ExciseDuty THEN BEGIN

              BUser.GET(USERID);

              JTemplate:='GENERAL';
              JBatch:='SKYATM';

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

              CoopTrans.INIT;
              CoopTrans."Transaction ID":=RequestReference;
              CoopTrans."Document No.":=SetDocumentNo(RequestReference);
              CoopTrans."Service Name":=serviceName;
              CoopTrans."Transaction Date":=DT2DATE(TransactionDate);
              CoopTrans."Transaction Time":=DT2TIME(TransactionDate);
              CoopTrans."Terminal ID":=TerminalID;
              CoopTrans.Channel:=Channel;
              CoopTrans."Sacco Account":=CreditAccount;
              CoopTrans."Member Account":=DebitAccount;
              CoopTrans."ATM No." := ATM_No;
              CoopTrans."Institution Code":=InstitutionCode;
              CoopTrans."Institution Name":=InstitutionName;
              CoopTrans.Commission:=ChargeAmount;
              CoopTrans."Commission Currency":=ChargeCurrency;
              CoopTrans."Fee Charged":=FeeAmount;
              CoopTrans."Fee Currency":=FeeCurrency;
              CoopTrans."Description 1":='Coop Balance Enquiry';
              CoopTrans."Description 2":=CoopTrans."Description 1";
              CoopTrans.Activity:=CoopTrans.Activity::"Balance Enquiry";
              CoopTrans."Transaction Type" := TransactionType;
              CoopTrans."Terminal Code" := TerminalCode;
              CoopTrans."Channel Code" := ChannelCode;
              CoopTrans."Total Charges" := TotalCharge;
              CoopTrans."Sacco Fee" := SaccoFee;
              CoopTrans."Coop Fee" := BankCharge;
              CoopTrans."Sacco Excise Duty" := ExciseDuty;
              CoopTrans."Total Account Debit" := CoopTrans.Amount+CoopTrans."Total Charges"+CoopTrans."Sacco Excise Duty";
              CoopTrans.INSERT;

              RespTransactionReference := CoopTrans."Document No.";
              SavAcc.CALCFIELDS("Balance (LCY)");
              RespAccountBookBalance := SavAcc."Balance (LCY)"-CoopTrans."Total Account Debit";
              RespAccountClearedBalance := GetAccountBalance(SavAcc."No.",TODAY)-CoopTrans."Total Account Debit";
              RespStatusCode:=Success;
              RespStatusDescription:='Success';



              CoopTrans.RESET;
              CoopTrans.SETRANGE("Transaction ID",RequestReference);
              //CoopTrans.SETRANGE(Posted,FALSE);
              IF CoopTrans.FINDFIRST THEN BEGIN
                  {
                  DocNo := CoopTrans."Document No.";
                  PDate := CoopTrans."Transaction Date";
                  AcctNo := CoopTrans."Member Account";
                  ExtDoc := '';
                  LoanNo := '';
                  TransType := TransType::" ";
                  Dim1 := SavAcc."Global Dimension 1 Code";
                  Dim2 := SavAcc."Global Dimension 2 Code";
                  SystCreated := TRUE;


                  SaccoTrans.InitJournal(JTemplate,JBatch);

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AcctNo,COPYSTR(CoopTrans."Description 1",1,50),BalAccType::"G/L Account",
                                '',TotalCharge,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AcctNo,COPYSTR('Excise Duty - '+CoopTrans."Description 1",1,50),BalAccType::"G/L Account",
                                ExciseDutyGL,ExciseDuty,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');


                  AcctNo := CoopSetup."Coop Commission Account";
                  ExtDoc := CoopTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";
                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"Bank Account",CoopSetup."Coop Commission Account",COPYSTR('Balance Enquiry Commission',1,50),BalAccType::"G/L Account",
                                '',-BankCharge,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');

                  AcctNo := CoopSetup."Coop Fee Account";
                  ExtDoc := CoopTrans."Member Account";
                  LoanNo := '';
                  TransType := TransType::" ";

                  SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",AcctNo,COPYSTR('Balance Enquiry Fee',1,50),BalAccType::"G/L Account",
                                '',-SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');


                  CoopTrans.Posted:=TRUE;
                  CoopTrans."Posted By":=USERID;
                  CoopTrans."Date Posted":=TODAY;
                  CoopTrans.MODIFY;
                  RespTransactionReference := CoopTrans."Document No.";

                  SaccoTrans.PostJournal(JTemplate,JBatch);


                  {
                  SLedger.RESET;
                  SLedger.SETRANGE("Document No.",CoopTrans."Document No.");
                  SLedger.SETRANGE("Posting Date",CoopTrans."Transaction Date");
                  SLedger.SETRANGE("Vendor No.",CoopTrans."Member Account");
                  IF SLedger.FINDFIRST THEN BEGIN
                      RespTransactionReference := FORMAT(SLedger."Transaction No.");

                  END;
                  }

                  SavAcc.CALCFIELDS("Balance (LCY)");
                  RespAccountBookBalance := SavAcc."Balance (LCY)";

                  RespAccountClearedBalance := GetAccountBalance(SavAcc."No.",TODAY);


                  RespStatusCode:=Success;
                  RespStatusDescription:='Success';
                  }

              END;
          END
          ELSE BEGIN
              RespStatusCode:=Insufficient_Funds;
              RespStatusDescription:='Insufficient Funds';
              //ERROR('Insufficient Funds');
          END;
      END
      ELSE BEGIN
        RespStatusCode:=Account_Does_Not_Exist;
        RespStatusDescription:='Account Does Not Exist';
              //ERROR('Account Does Not Exist');
      END;


      //PostATM(RespTransactionID);
      Response := '<BalanceEnquiryResponse>' +
                      '<Response>' +

                          '<HeaderReply>' +
                              '<RequestReference>'+RespTransactionID+'</RequestReference>' +
                              '<StatusCode>'+RespStatusCode+'</StatusCode>' +
                              '<StatusDescription>'+RespStatusDescription+'</StatusDescription>' +
                          '</HeaderReply>' +

                          '<OperationParameters>' +
                              '<TransactionDate>'+FormatDate(0D,RespTransactionDate)+'</TransactionDate>' +
                              '<TransactionReference>'+RespTransactionReference+'</TransactionReference>' +
                          '</OperationParameters>' +

                          '<Institution>' +
                              '<InstitutionCode>'+RespInstitutionCode+'</InstitutionCode>' +
                              '<InstitutionName>'+InstitutionName+'</InstitutionName>' +
                          '</Institution>' +

                          '<Account>' +
                              '<DebitAccount>'+RespDebitAccount+'</DebitAccount>' +
                              '<BookBalance>'+FormatDecimal(RespAccountBookBalance)+'</BookBalance>' +
                              '<ClearedBalance>'+FormatDecimal(RespAccountClearedBalance)+'</ClearedBalance>' +
                              '<Currency>'+RespAccountCurrency+'</Currency>' +
                          '</Account>' +

                          '<AdditionalInfo>' +
                              '<Key>'+''+'</Key>' +
                              '<Value>'+''+'</Value>' +
                          '</AdditionalInfo>' +

                      '</Response>' +
                  '</BalanceEnquiryResponse>';
    END;

    PROCEDURE GetExciseRate@29() rate : Integer;
    BEGIN


      GenSetup.GET;
      GenSetup.TESTFIELD(GenSetup."Excise Duty (%)");
      rate := GenSetup."Excise Duty (%)";

    END;

    PROCEDURE GetExciseDutyGL@21() account : Text[20];
    BEGIN

      GenSetup.RESET;
      GenSetup.GET;
      GenSetup.TESTFIELD(GenSetup."Excise Duty G/L");
      account := GenSetup."Excise Duty G/L";

    END;

    PROCEDURE ReverseTransaction@85(ReversalID@1000 : Code[50];TransactionID@1064 : Code[50];ServiceName@1063 : Code[50];Channel@1060 : Code[50];AccountNo@1059 : Code[50];Amount@1051 : Decimal) Reversed : Boolean;
    VAR
      Text0001@1017 : TextConst 'ENU=Ensure the Salary  Journal Template is set up in Banking User Setup';
      Text0002@1016 : TextConst 'ENU=Ensure the Salary Journal Batch is set up in Banking User Setup';
      Text0003@1015 : TextConst 'ENU=Ensure the Default Bank is set up in User Setup';
      Text0004@1014 : TextConst 'ENU=The transaction has already been posted.';
      Text0005@1030 : TextConst 'ENU="Your Income of "';
      Text0006@1031 : TextConst 'ENU=" has been credited to your account at "';
      Text0007@1032 : TextConst 'ENU=" on "';
      ReversalEntry@1001 : Record 179;
      GLRegister@1120054000 : Record 45;
      CoopTrans@1120054001 : Record 170041;
    BEGIN
      Reversed:=FALSE;

      //ERROR('TransactionID %1\Channel %2\AccountNo %3\AccountNo %4',TransactionID,Channel,AccountNo,AccountNo);
      CoopTrans.RESET;
      CoopTrans.SETRANGE("Transaction ID",TransactionID);
      CoopTrans.SETFILTER(CoopTrans.Activity,'<>%1',CoopTrans.Activity::Reversal);
      CoopTrans.SETRANGE(Channel,Channel);
      CoopTrans.SETRANGE("Member Account",AccountNo);
      CoopTrans.SETRANGE(Amount,Amount);
      CoopTrans.SETRANGE(Posted,TRUE);
      CoopTrans.SETRANGE(Reversed,FALSE);
      IF CoopTrans.FINDFIRST THEN BEGIN
         //ERROR('t');
          SLedger.RESET;
          SLedger.SETRANGE("Vendor No.",CoopTrans."Member Account");
          //IF CoopTrans.Activity = CoopTrans.Activity::"Balance Enquiry" THEN
          //SLedger.SETRANGE(Amount,CoopTrans.Commission+CoopTrans."Fee Charged");
          SLedger.SETRANGE("Document No.",CoopTrans."Document No.");
          SLedger.SETRANGE("Posting Date",CoopTrans."Transaction Date");
          SLedger.SETRANGE(Reversed,FALSE);
          IF SLedger.FINDFIRST THEN BEGIN

              GLRegister.RESET;
              GLRegister.SETFILTER("From Entry No.",'<=%1',SLedger."Entry No.");
              GLRegister.SETFILTER("To Entry No.",'>=%1',SLedger."Entry No.");
              IF GLRegister.FINDFIRST THEN BEGIN
                  //MESSAGE('t');
                  //Stage 1
                  CLEAR(ReversalEntry);
                  SLedger.TESTFIELD("Transaction No.");

                  //Stage 2
                  ReversalEntry.DELETEALL;
                  ReversalEntry.AutoReverseRegister(GLRegister."No.");
              END;
          END;


          SLedger.RESET;
          SLedger.SETRANGE("Vendor No.",CoopTrans."Member Account");
          IF CoopTrans.Activity = CoopTrans.Activity::"Balance Enquiry" THEN
          SLedger.SETRANGE(Amount,CoopTrans.Commission+CoopTrans."Fee Charged");
          SLedger.SETRANGE("Document No.",CoopTrans."Document No.");
          SLedger.SETRANGE("Posting Date",CoopTrans."Transaction Date");
          SLedger.SETRANGE(Reversed,TRUE);
          IF SLedger.FINDFIRST THEN BEGIN

              CoopTrans.Reversed:=TRUE;
              CoopTrans."Date Reversed":=TODAY;
              CoopTrans."Reversed By":=USERID;
              CoopTrans."Reversal ID":=ReversalID;
              CoopTrans.MODIFY;

              Reversed:=TRUE;
          END;


      END;


    END;

    PROCEDURE FundsTransfer@3(ServiceName@1010 : Text;RequestReference@1000 : Text;TransactionDate@1011 : DateTime;TerminalID@1005 : Text;Channel@1013 : Text;ConnectionMode@1042 : Text;TransactionType@1035 : Text;OriginalMessageID@1036 : Text;InstitutionCode@1016 : Text;InstitutionName@1012 : Text[100];TransactionAmount@1015 : Decimal;Currency@1038 : Text;DebitAccount@1014 : Text;CreditAccount@1037 : Text;ChargeAmount@1018 : Decimal;ChargeCurrency@1019 : Text;FeeAmount@1020 : Decimal;FeeCurrency@1021 : Text;Narrative1@1022 : Text[50];Narrative2@1039 : Text[50];deviceType@1043 : Text;location@1044 : Text;conversionRate@1120054002 : Text) Response : Text[1024];
    VAR
      i@1001 : Decimal;
      MemberNo@1002 : Text[30];
      AccBalance@1003 : Decimal;
      thisSavAccNo@1004 : Text[30];
      foundChargeAccount@1006 : Boolean;
      A@1007 : Integer;
      MNo@1008 : Code[20];
      AcctNo@1009 : Code[50];
      TotalCharge@1023 : Decimal;
      AccBal@1024 : Decimal;
      RespTransactionID@1028 : Text;
      RespStatusCode@1025 : Text;
      RespStatusDescription@1026 : Text;
      RespTransactionDate@1027 : DateTime;
      RespTransactionReference@1029 : Text;
      RespInstitutionCode@1030 : Text;
      RespDebitAccount@1031 : Text;
      RespAccountBookBalance@1032 : Decimal;
      RespAccountClearedBalance@1033 : Decimal;
      RespAccountCurrency@1034 : Text;
      RespTotalAmount@1017 : Decimal;
      RespCreditAccount@1040 : Text;
      Reversal@1041 : Boolean;
      Limit@1120054000 : Decimal;
      LimitReached@1120054001 : Boolean;
      DepRev@1120054003 : Boolean;
      ForeignAmt@1120054004 : Decimal;
    BEGIN


          ForeignAmt := 0;
          IF Currency <> '404' THEN BEGIN
              ForeignAmt := TransactionAmount;
              TransactionAmount := ChargeAmount;
          END;
          IF TransactionAmount = 0 THEN
            TransactionAmount := ForeignAmt;


          // Get Excise duty G/L
          ExciseDutyGL := GetExciseDutyGL();
          ExciseDutyRate := GetExciseRate();
          ExciseDuty:=0;



          ChannelCode :='';
          TerminalCode:='';


          IF Channel <> '' THEN
            ChannelCode := COPYSTR(Channel,4,2);

          IF TerminalID <> '' THEN
            TerminalCode := COPYSTR(TerminalID,1,3);

          IF TerminalCode = 'ATM' THEN
            ChannelCode := '';

          IF CoopCode.GET(TransactionType,TerminalCode,ChannelCode) THEN BEGIN

              Limit := CoopCode."Daily Limit";;
          END
          ELSE BEGIN
              TerminalCode:='';
              ChannelCode:='';
          END;



          TotalCharge:=ChargeAmount+FeeAmount;
          ExciseDuty:=ROUND(FeeAmount*ExciseDutyRate/100);


          BankCharge:=0;
          SaccoFee:=0;
          GetATMcharges(TransactionType,TerminalCode,ChannelCode,TransactionAmount,BankCharge,SaccoFee);
          TotalCharge:=BankCharge+SaccoFee;
          ExciseDuty:=ROUND(SaccoFee*ExciseDutyRate/100);





          CoopSetup.GET;

          CoopSetup.TESTFIELD("Institution Code");

          RespTransactionID:=RequestReference;
          RespTransactionDate:=TransactionDate;
          RespTransactionReference:=Null;


          RespInstitutionCode:=CoopSetup."Institution Code";

          RespDebitAccount:=DebitAccount;
          RespAccountBookBalance:=0;
          RespAccountClearedBalance:=0;
          RespAccountCurrency:='KES';
          RespTotalAmount:=TransactionAmount;
          RespCreditAccount:=CreditAccount;



          ATM_No := DebitAccount;
          DebitAccount := GetAccountNoFromATMNo(DebitAccount);




      CoopTrans.RESET;
      CoopTrans.SETRANGE("Transaction ID",RequestReference);
      CoopTrans.SETRANGE(CoopTrans."Transaction Type",TransactionType);
      IF CoopTrans.FINDFIRST THEN BEGIN

          RespStatusCode:=Severe_problem_Has_Occured;
          RespStatusDescription:='Transaction Already Exists';
      END
      ELSE BEGIN

          Continue := TRUE;
          CRate := 0;
          IF conversionRate <> '' THEN
              IF NOT EVALUATE(CRate,conversionRate) THEN BEGIN
                  Continue := FALSE;

                  RespStatusCode:=Severe_problem_Has_Occured;
                  RespStatusDescription:='Invalid Conversion Rate';
              END;


          IF Continue THEN
          IF SavAcc.GET(DebitAccount) THEN BEGIN

              AccBal := GetAccountBalance(SavAcc."No.",TODAY);


              LimitReached := FALSE;
              IF Limit > 0 THEN BEGIN
                  CoopTrans.RESET;
                  CoopTrans.SETRANGE("Transaction ID",RequestReference);
                  CoopTrans.SETRANGE(CoopTrans."Transaction Type",TransactionType);
                  CoopTrans.SETRANGE(CoopTrans."Transaction Date",DT2DATE(TransactionDate));
                  CoopTrans.SETRANGE(CoopTrans.Activity,CoopTrans.Activity::"Funds Transfer");
                  CoopTrans.SETRANGE(CoopTrans."Terminal Code" , TerminalCode);
                  CoopTrans.SETRANGE(CoopTrans."Channel Code" , ChannelCode);
                  CoopTrans.SETRANGE(CoopTrans.Reversed , FALSE);
                  IF CoopTrans.FINDFIRST THEN BEGIN
                      CoopTrans.CALCSUMS(CoopTrans.Amount);
                      IF (TransactionAmount+CoopTrans.Amount) > Limit THEN
                        LimitReached := TRUE
                  END;
              END;
              DepRev := FALSE;
              IF (TransactionType = '1420') OR (TransactionType = '0010') THEN
                DepRev := TRUE;


              IF (DepRev) OR ((AccBal >= TransactionAmount+TotalCharge+ExciseDuty) AND (NOT LimitReached)) THEN BEGIN


                  JTemplate:='GENERAL';
                  JBatch:='SKYATM';

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

                  IF Narrative1 = '' THEN
                    Narrative1 := 'ATM Funds transfer';

                  IF Narrative2 = '' THEN
                    Narrative2 := 'ATM Funds transfer';

                  CoopTrans.INIT;
                  CoopTrans."Transaction ID":=RequestReference;
                  CoopTrans."Document No.":=SetDocumentNo(RequestReference);
                  CoopTrans."Service Name":=ServiceName;
                  CoopTrans."Foreign Amount" := ForeignAmt;
                  CoopTrans."Transaction Date":=DT2DATE(TransactionDate);
                  CoopTrans."Transaction Time":=DT2TIME(TransactionDate);
                  CoopTrans.Channel:=Channel;
                  CoopTrans."Transaction Type" := TransactionType;
                  CoopTrans."Terminal Code" := TerminalCode;
                  CoopTrans."Channel Code" := ChannelCode;

                  RespTransactionReference := CoopTrans."Document No.";

                  IF CoopCode.GET(TransactionType,TerminalCode,ChannelCode) THEN
                    CoopTrans."Transaction Name" := CoopCode.Description;

                  CoopTrans."Original Transaction ID" := OriginalMessageID;

                  Continue := TRUE;
                  Reversal:=FALSE;
                  IF CoopTrans."Transaction Type" = '1420' THEN BEGIN
                      Reversal := TRUE;
                      IF CoopTrans."Original Transaction ID"='' THEN BEGIN
                          //CoopTrans.TESTFIELD("Original Transaction ID");;

                          RespStatusCode:=Parameters_Not_Valid_Or_Missing;
                          RespStatusDescription:='Original Message ID missing for this Reversal Request';
                          Continue:=FALSE;
                      END;
                  END;

                  IF TransactionType = '0010' THEN
                      TransactionAmount := TransactionAmount*-1;

                  IF Continue THEN BEGIN
                      CoopTrans."Member Account":=DebitAccount;
                      CoopTrans.Amount:=TransactionAmount;
                      CoopTrans."Amount Currency":=Currency;
                      CoopTrans."Sacco Account":=CreditAccount;
                      CoopTrans.Commission:=ChargeAmount;
                      CoopTrans."Commission Currency":=ChargeCurrency;
                      CoopTrans."Fee Charged":=FeeAmount;
                      CoopTrans."Fee Currency":=FeeCurrency;
                      CoopTrans."Description 1":=Narrative1;
                      CoopTrans."Description 2":=Narrative2;
                      CoopTrans."ATM No.":=ATM_No;
                      CoopTrans."Institution Code":=InstitutionCode;
                      CoopTrans."Institution Name":=InstitutionName;
                      CoopTrans.Activity:=CoopTrans.Activity::"Funds Transfer";
                      IF Reversal THEN
                      CoopTrans.Activity:=CoopTrans.Activity::Reversal;
                      CoopTrans."Total Charges" := TotalCharge;
                      CoopTrans."Sacco Fee" := SaccoFee;
                      CoopTrans."Coop Fee" := BankCharge;
                      CoopTrans."Sacco Excise Duty" := ExciseDuty;
                      CoopTrans."Total Account Debit" := CoopTrans.Amount+CoopTrans."Total Charges"+CoopTrans."Sacco Excise Duty";
                      CoopTrans."Device Type" := deviceType;
                      CoopTrans.Location := location;
                      CoopTrans."Conversion Rate" := CRate;
                      CoopTrans.INSERT;

                      RespTransactionReference := CoopTrans."Document No.";
                      RespStatusCode:=Success;
                      RespStatusDescription:='Success';


                      CoopTrans.RESET;
                      CoopTrans.SETRANGE("Transaction ID",RequestReference);
                      //CoopTrans.SETRANGE(Posted,FALSE);
                      IF CoopTrans.FINDFIRST THEN BEGIN
                          {
                          IF Reversal THEN BEGIN
                              IF ReverseTransaction(RequestReference,OriginalMessageID,ServiceName,Channel,DebitAccount,TransactionAmount) THEN BEGIN

                                  CoopTrans.Posted:=TRUE;
                                  CoopTrans."Posted By":=USERID;
                                  CoopTrans."Date Posted":=TODAY;


                                  CoopTrans.Reversed:=TRUE;
                                  CoopTrans."Date Reversed":=TODAY;
                                  CoopTrans."Reversed By":=USERID;
                                  CoopTrans.MODIFY;

                                  RespStatusCode:=Success;
                                  RespStatusDescription:='Success';
                              END
                              ELSE BEGIN
                                  //ERROR('Reversal Failed');
                                  RespStatusCode:=Severe_problem_Has_Occured;
                                  RespStatusDescription:='Reversal Failed';
                              END;
                          END
                          ELSE BEGIN
                              DocNo := CoopTrans."Document No.";
                              PDate := CoopTrans."Transaction Date";
                              AcctNo := CoopTrans."Member Account";
                              ExtDoc := '';
                              LoanNo := '';
                              TransType := TransType::" ";
                              Dim1 := SavAcc."Global Dimension 1 Code";
                              Dim2 := SavAcc."Global Dimension 2 Code";
                              SystCreated := TRUE;

                              SaccoTrans.InitJournal(JTemplate,JBatch);

                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AcctNo,COPYSTR(CoopTrans."Transaction Name",1,50),BalAccType::"Bank Account",
                                            CoopSetup."Coop Bank Account",TransactionAmount,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');



                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AcctNo,COPYSTR(CoopTrans."Transaction Name",1,50),BalAccType::"G/L Account",
                                            '',TotalCharge,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');
                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AcctNo,COPYSTR('Excise Duty - '+CoopTrans."Transaction Name",1,50),BalAccType::"G/L Account",
                                            ExciseDutyGL,ExciseDuty,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');


                              AcctNo := CoopSetup."Coop Commission Account";
                              ExtDoc := CoopTrans."Member Account";
                              LoanNo := '';
                              TransType := TransType::" ";

                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"Bank Account",CoopSetup."Coop Commission Account",COPYSTR(CoopTrans."Transaction Name",1,50),BalAccType::"G/L Account",
                                            '',-BankCharge,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');

                              AcctNo := CoopSetup."Coop Fee Account";
                              ExtDoc := CoopTrans."Member Account";
                              LoanNo := '';
                              TransType := TransType::" ";

                              SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",AcctNo,COPYSTR(CoopTrans."Transaction Name",1,50),BalAccType::"G/L Account",
                                            '',-SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');


                              CoopTrans.Posted:=TRUE;
                              CoopTrans."Posted By":=USERID;
                              CoopTrans."Date Posted":=TODAY;
                              CoopTrans.MODIFY;
                              RespTransactionReference := CoopTrans."Document No.";

                              SaccoTrans.PostJournal(JTemplate,JBatch);


                              {
                              SLedger.RESET;
                              SLedger.SETRANGE("Document No.",CoopTrans."Document No.");
                              SLedger.SETRANGE("Posting Date",CoopTrans."Transaction Date");
                              SLedger.SETRANGE("Vendor No.",CoopTrans."Member Account");
                              IF SLedger.FINDFIRST THEN BEGIN
                                  RespTransactionReference := FORMAT(SLedger."Transaction No.");
                              END;
                              }


                              RespStatusCode:=Success;
                              RespStatusDescription:='Success';
                          END;
                          }

                      END
                      ELSE BEGIN

                          RespStatusCode:=Severe_problem_Has_Occured;
                          RespStatusDescription:='Transaction Missing in NAVISION';
                      END;
                  END;
              END
              ELSE BEGIN
                  IF LimitReached THEN BEGIN
                      RespStatusCode:=Severe_problem_Has_Occured;
                      RespStatusDescription:='Daily Limit Reached';
                  END
                  ELSE BEGIN
                      RespStatusCode:=Insufficient_Funds;
                      RespStatusDescription:='Insufficient Funds';
                  END;
              END;
          END
          ELSE BEGIN
            RespStatusCode:=Account_Does_Not_Exist;
            RespStatusDescription:='Account Does Not Exist';
          END;




      //PostATM(RespTransactionID);
      END;
      Response := '<FundsTransferResponse>' +
                      '<Response>' +

                          '<HeaderReply>' +
                              '<RequestReference>'+RespTransactionID+'</RequestReference>' +
                              '<StatusCode>'+RespStatusCode+'</StatusCode>' +
                              '<StatusDescription>'+RespStatusDescription+'</StatusDescription>' +
                          '</HeaderReply>' +

                          '<OperationParameters>' +
                              '<TransactionDate>'+FormatDate(0D,RespTransactionDate)+'</TransactionDate>' +
                              '<TransactionReference>'+RespTransactionReference+'</TransactionReference>' +
                          '</OperationParameters>' +

                          '<Institution>' +
                              '<InstitutionCode>'+RespInstitutionCode+'</InstitutionCode>' +
                          '</Institution>' +

                          '<Account>' +
                              '<DebitAccount>'+RespDebitAccount+'</DebitAccount>' +
                              '<Amount>'+FormatDecimal(RespTotalAmount)+'</Amount>' +
                              '<ClearedBalance>'+'0'+'</ClearedBalance>' +
                              '<CreditAccount>'+RespCreditAccount+'</CreditAccount>' +
                          '</Account>' +

                          '<AdditionalInfo>' +
                              '<Key>'+''+'</Key>' +
                              '<Value>'+''+'</Value>' +
                          '</AdditionalInfo>' +

                      '</Response>' +
                  '</FundsTransferResponse>';
    END;

    PROCEDURE MiniStatement@4(ServiceName@1000 : Text;RequestReference@1102755001 : Text;MaxNumberRows@1005 : Integer;TerminalID@1010 : Text;Channel@1042 : Text;TransactionDate@1011 : DateTime;DebitAccount@1015 : Text;MobileNo@1043 : Text;CreditAccount@1014 : Text;ChargeAmount@1019 : Decimal;ChargeCurrency@1018 : Text;FeeAmount@1021 : Decimal;FeeCurrency@1020 : Text;Narrative@1022 : Text[50];InstitutionCode@1016 : Text;deviceType@1120054003 : Text;location@1120054002 : Text;conversionRate@1120054001 : Text) Response : Text;
    VAR
      TransactionType@1120054000 : Code[10];
      i@1001 : Decimal;
      MemberNo@1002 : Text[30];
      AccBalance@1003 : Decimal;
      thisSavAccNo@1004 : Text[30];
      foundChargeAccount@1006 : Boolean;
      A@1007 : Integer;
      MNo@1008 : Code[20];
      AcctNo@1009 : Code[20];
      TotalCharge@1023 : Decimal;
      AccBal@1024 : Decimal;
      RespTransactionID@1028 : Text;
      RespStatusCode@1025 : Text;
      RespStatusDescription@1026 : Text;
      RespTransactionDate@1027 : DateTime;
      RespTransactionReference@1029 : Text;
      RespInstitutionCode@1030 : Text;
      RespDebitAccount@1031 : Text;
      RespAccountBookBalance@1032 : Decimal;
      RespAccountClearedBalance@1033 : Decimal;
      RespAccountCurrency@1034 : Text;
      RespTotalAmount@1017 : Decimal;
      RespCreditAccount@1040 : Text;
      Reversal@1041 : Boolean;
      RespDebitCreditFlag@1013 : Text;
      RespTransAmount@1035 : Decimal;
      RespNarration@1036 : Text;
      RespPostingDate@1037 : Date;
      RespChannelID@1038 : Text;
      RespAccountName@1039 : Text;
      RespAccountNumber@1044 : Text;
      Found@1012 : Boolean;
    BEGIN


      Found:=FALSE;


      ChannelCode :='';
      TerminalCode:='';


      IF Channel <> '' THEN
        ChannelCode := COPYSTR(Channel,4,2);

      IF TerminalID <> '' THEN
        TerminalCode := COPYSTR(TerminalID,1,3);

      IF TerminalCode = 'ATM' THEN
        ChannelCode := '';
      IF TerminalCode = 'POS' THEN
        ChannelCode := '';

      TransactionType := '0014';
      IF NOT CoopCode.GET(TransactionType,TerminalCode,ChannelCode) THEN BEGIN
          TerminalCode:='';
          ChannelCode:='';
      END;




      // Get Excise duty G/L
      ExciseDutyGL := GetExciseDutyGL();
      ExciseDutyRate := GetExciseRate();
      ExciseDuty:=0;

      {
      TotalCharge:=ChargeAmount+FeeAmount;
      ExciseDuty:=ROUND(FeeAmount*ExciseDutyRate/100);
      }


      BankCharge:=0;
      SaccoFee:=0;
      GetATMcharges(TransactionType,TerminalCode,ChannelCode,0,BankCharge,SaccoFee);
      TotalCharge:=BankCharge+SaccoFee;
      ExciseDuty:=ROUND(SaccoFee*ExciseDutyRate/100);





      CoopSetup.GET;

      CoopSetup.TESTFIELD("Institution Code");

      RespTransactionID:=RequestReference;
      RespTransactionDate:=TransactionDate;
      RespTransactionReference:=Null;
      RespInstitutionCode:=CoopSetup."Institution Code";
      RespDebitAccount:=DebitAccount;
      RespAccountBookBalance:=0;
      RespAccountClearedBalance:=0;
      RespAccountCurrency:='KES';
      //RespTotalAmount:=TotalAmount;
      RespCreditAccount:=CreditAccount;


      ATM_No := DebitAccount;
      DebitAccount := GetAccountNoFromATMNo(DebitAccount);

      IF SavAcc.GET(DebitAccount) THEN BEGIN

          RespAccountName := SavAcc.Name;
          RespAccountNumber := SavAcc."No.";

          IF MaxNumberRows > 0 THEN BEGIN

              AccBal := GetAccountBalance(SavAcc."No.",TODAY);
              IF AccBal >= TotalCharge+ExciseDuty THEN BEGIN

              BUser.GET(USERID);

              JTemplate:='GENERAL';
              JBatch:='SKYATM';

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

                  IF Narrative = '' THEN
                    Narrative := 'Mini-Statement';
                  CoopTrans.INIT;
                  CoopTrans."Transaction ID":=RequestReference;
                  CoopTrans."Document No.":=SetDocumentNo(RequestReference);
                  CoopTrans."Service Name":=ServiceName;
                  CoopTrans."Transaction Date":=DT2DATE(TransactionDate);
                  CoopTrans."Transaction Time":=DT2TIME(TransactionDate);
                  CoopTrans."Member Account":=DebitAccount;
                  CoopTrans."Sacco Account":=CreditAccount;
                  CoopTrans."ATM No.":=ATM_No;
                  CoopTrans.Commission:=ChargeAmount;
                  CoopTrans."Commission Currency":=ChargeCurrency;
                  CoopTrans."Fee Charged":=FeeAmount;
                  CoopTrans."Fee Currency":=FeeCurrency;
                  CoopTrans."Description 1":=Narrative;
                  CoopTrans."Institution Code":=InstitutionCode;
                  CoopTrans.Activity:=CoopTrans.Activity::MiniStatement;
                  CoopTrans."Transaction Type" := TransactionType;
                  CoopTrans."Terminal Code" := TerminalCode;
                  CoopTrans."Channel Code" := ChannelCode;
                  CoopTrans."Total Charges" := TotalCharge;
                  CoopTrans."Sacco Fee" := SaccoFee;
                  CoopTrans."Coop Fee" := BankCharge;
                  CoopTrans."Sacco Excise Duty" := ExciseDuty;
                  CoopTrans."Total Account Debit" := CoopTrans.Amount+CoopTrans."Total Charges"+CoopTrans."Sacco Excise Duty";
                  CoopTrans."Device Type" := deviceType;
                  CoopTrans.Location := location;
                  CoopTrans."Conversion Rate" := CRate;
                  CoopTrans.INSERT;


                  RespTransactionReference := CoopTrans."Document No.";
                  RespStatusCode:=Success;
                  RespStatusDescription:='Success';

                  CoopTrans.RESET;
                  CoopTrans.SETRANGE("Transaction ID",RequestReference);
                  //CoopTrans.SETRANGE(Posted,FALSE);
                  IF CoopTrans.FINDFIRST THEN BEGIN
                      {
                      DocNo := CoopTrans."Document No.";
                      PDate := CoopTrans."Transaction Date";
                      AcctNo := CoopTrans."Member Account";
                      ExtDoc := '';
                      LoanNo := '';
                      TransType := TransType::" ";
                      Dim1 := SavAcc."Global Dimension 1 Code";
                      Dim2 := SavAcc."Global Dimension 2 Code";
                      SystCreated := TRUE;

                      SaccoTrans.InitJournal(JTemplate,JBatch);


                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AcctNo,COPYSTR(CoopTrans."Description 1",1,50),BalAccType::"G/L Account",
                                    '',TotalCharge,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');
                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AcctNo,COPYSTR('Excise Duty - '+CoopTrans."Description 1",1,50),BalAccType::"G/L Account",
                                    ExciseDutyGL,ExciseDuty,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');


                      AcctNo := CoopSetup."Coop Commission Account";
                      ExtDoc := CoopTrans."Member Account";
                      LoanNo := '';
                      TransType := TransType::" ";

                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"Bank Account",AcctNo,COPYSTR('Balance Enquiry Commission',1,50),BalAccType::"G/L Account",
                                    '',-BankCharge,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');

                      AcctNo := CoopSetup."Coop Fee Account";
                      ExtDoc := CoopTrans."Member Account";
                      LoanNo := '';
                      TransType := TransType::" ";

                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",AcctNo,COPYSTR('Balance Enquiry Fee',1,50),BalAccType::"G/L Account",
                                    '',-SaccoFee,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');


                      CoopTrans.Posted:=TRUE;
                      CoopTrans."Posted By":=USERID;
                      CoopTrans."Date Posted":=TODAY;
                      CoopTrans.MODIFY;
                      RespTransactionReference := CoopTrans."Document No.";

                      SaccoTrans.PostJournal(JTemplate,JBatch);


                      {
                      SLedger.RESET;
                      SLedger.SETRANGE("Document No.",CoopTrans."Document No.");
                      SLedger.SETRANGE("Posting Date",CoopTrans."Transaction Date");
                      SLedger.SETRANGE("Vendor No.",CoopTrans."Member Account");
                      IF SLedger.FINDFIRST THEN BEGIN
                          RespTransactionReference := FORMAT(SLedger."Transaction No.");
                      END;
                      }

                      RespStatusCode:=Success;
                      RespStatusDescription:='Success';
                      }
                  END
                  ELSE BEGIN

                      RespStatusCode:=Severe_problem_Has_Occured;
                      RespStatusDescription:='Transaction Missing in NAVISION';
                  END;

              END
              ELSE BEGIN
                  RespStatusCode:=Insufficient_Funds;
                  RespStatusDescription:='Insufficient Funds';
              END;
          END;


          RespTransAmount:=0;
          RespNarration:='';
          RespPostingDate:=0D;
          RespChannelID:='';
          CoopTrans.RESET;
          CoopTrans.SETRANGE("Transaction ID",RequestReference);
          //CoopTrans.SETRANGE(Posted,TRUE);
          IF CoopTrans.FINDFIRST THEN BEGIN
              SLedger.RESET;
              SLedger.SETRANGE("Vendor No.",CoopTrans."Member Account");
              IF SLedger.FINDFIRST THEN BEGIN


                  Response := '<MinistatementResponse>' +
                      '<Response>';

                          Response += '<HeaderReply>' +

                                          '<RequestReference>'+RespTransactionID+'</RequestReference>' +
                                          '<StatusCode>'+RespStatusCode+'</StatusCode>' +
                                          '<StatusDescription>'+RespStatusDescription+'</StatusDescription>' +
                                      '</HeaderReply>';


                  LedgerCount := 0;


                  CurrRecord:=SLedger.COUNT - MaxNumberRows;

                  IF CurrRecord < 1 THEN
                    CurrRecord:=1;


                  IF CurrRecord > 0 THEN BEGIN
                      RespAccountBookBalance:=0;
                      Response += '<MiniStatement>';
                      REPEAT

                          SLedger.CALCFIELDS("Amount (LCY)");
                          RespAccountBookBalance+=SLedger."Amount (LCY)";
                          LedgerCount+=1;
                          IF LedgerCount >= CurrRecord THEN BEGIN

                              RespAccountClearedBalance := GetAccountBalance(SavAcc."No.",SLedger."Posting Date");
                              RespAccountBookBalance*=-1;

                              Found:=TRUE;
                              RespStatusCode:=Success;
                              RespStatusDescription:='Success';
                              IF SLedger.Amount>0 THEN
                                RespDebitCreditFlag:='DR'
                              ELSE
                                RespDebitCreditFlag:='CR';
                              RespTransAmount := ABS(SLedger."Amount (LCY)");
                              RespNarration := SLedger.Description;
                              RespPostingDate:=SLedger."Posting Date";
                              RespTransactionDate := TransactionDate;
                              RespChannelID := CoopTrans.Channel;




                              Response += '<AccountTransactions>' +

                                              '<RequestReference>'+RespTransactionID+'</RequestReference>' +
                                              '<StatusCode>'+RespStatusCode+'</StatusCode>' +
                                              '<StatusDescription>'+RespStatusDescription+'</StatusDescription>' +

                                              '<TransactionDate>'+FormatDate(0D,RespTransactionDate)+'</TransactionDate>' +
                                              '<TransactionReference>'+RespTransactionReference+'</TransactionReference>' +
                                              '<DebitCreditFlag>'+RespDebitCreditFlag+'</DebitCreditFlag>' +
                                              '<Amount>'+FormatDecimal(RespTransAmount)+'</Amount>' +
                                              '<Narration>'+RespNarration+'</Narration>' +
                                              '<PostingDate>'+FormatDate(RespPostingDate,0DT)+'</PostingDate>' +
                                              '<BookBalance>'+FormatDecimal(RespAccountBookBalance)+'</BookBalance>' +
                                              '<ClearedRunningBalance>'+FormatDecimal(RespAccountClearedBalance)+'</ClearedRunningBalance>' +
                                              '<ChannelID>'+RespChannelID+'</ChannelID>' +
                                              '<AccountName>'+RespAccountName+'</AccountName>' +
                                              '<AccountNumber>'+RespAccountNumber+'</AccountNumber>' +
                                          '</AccountTransactions>';


                          END;
                      UNTIL (SLedger.NEXT=0);

                      Response += '</MiniStatement>';

                      Response += '</Response>' +
                            '</MinistatementResponse>';
                  END
                  ELSE BEGIN
                      RespStatusCode:=Severe_problem_Has_Occured;
                      RespStatusDescription:='Invalid Maximum Number of Rows or Record Transaction';
                  END;
              END
              ELSE BEGIN
                  RespStatusCode:=Severe_problem_Has_Occured;
                  RespStatusDescription:='No transactions Exist for this Member';
              END;
          END
          ELSE BEGIN
              RespStatusCode:=Operation_Does_Not_Exist;
              RespStatusDescription:='Operation Does Not Exist';
          END;
      END
      ELSE BEGIN
        RespStatusCode:=Account_Does_Not_Exist;
        RespStatusDescription:='Account Does Not Exist';
      END;



      IF NOT Found THEN BEGIN

      CoopSetup.GET;


      RespTransactionID:=RequestReference;
      RespTransactionDate:=TransactionDate;
      RespTransactionReference:=Null;
      CoopSetup.TESTFIELD("Institution Code");
      RespInstitutionCode:=CoopSetup."Institution Code";
      RespDebitAccount:=DebitAccount;
      RespAccountBookBalance:=0;
      RespAccountClearedBalance:=0;
      RespAccountCurrency:='KES';




      //PostATM(RespTransactionID);
      Response := '<MinistatementResponse>' +
                      '<Response>' +

                          '<HeaderReply>' +
                              '<RequestReference>'+RespTransactionID+'</RequestReference>' +
                              '<StatusCode>'+RespStatusCode+'</StatusCode>' +
                              '<StatusDescription>'+RespStatusDescription+'</StatusDescription>' +
                          '</HeaderReply>' +


                          '<MiniStatement/>'+

                      '</Response>' +
                  '</MinistatementResponse>';
      END;
    END;

    PROCEDURE FormatDecimal@1120054022(Amount@1120054000 : Decimal) TextValue : Text;
    BEGIN

      TextValue := DELCHR(FORMAT(Amount),'=',',')
    END;

    PROCEDURE FormatDate@1120054035(Date@1120054000 : Date;DateTime@1120054001 : DateTime) DateFormat : Text;
    VAR
      DatePart@1120054002 : Date;
      TimePart@1120054003 : Time;
      Milliseconds@1120054007 : Integer;
      Hours@1120054006 : Integer;
      Seconds@1120054005 : Integer;
      Minutes@1120054004 : Integer;
      D@1120054008 : Integer;
      M@1120054009 : Integer;
      Y@1120054010 : Integer;
      dd@1120054011 : Text;
      mm@1120054012 : Text;
      yyyy@1120054013 : Text;
      DateString@1120054014 : Text;
      TimeString@1120054015 : Text;
      hh@1120054016 : Text;
      ss@1120054017 : Text;
    BEGIN
      TimePart := 0T;
      DatePart := 0D;


      Milliseconds := 0;
      Seconds := 0;
      Minutes := 0;
      Hours := 0;

      DateString := '';
      TimeString := '';


      DatePart := Date;

      IF DatePart = 0D THEN
          DatePart := DT2DATE(DateTime);

      D := DATE2DMY(DatePart,1);
      M := DATE2DMY(DatePart,2);
      Y := DATE2DMY(DatePart,3);

      dd:=FORMAT(D);
      mm:=FORMAT(M);
      yyyy:=FORMAT(Y);

      IF STRLEN(dd)=1 THEN
        dd:='0'+dd;
      IF STRLEN(mm)=1 THEN
        mm:='0'+mm;

      DateString := yyyy+'-'+mm+'-'+dd;

      IF DateTime <> 0DT THEN BEGIN
          TimePart := DT2TIME(DateTime);


          Milliseconds := TimePart - 000000T;

          Hours := Milliseconds DIV 1000 DIV 60 DIV 60;
          Milliseconds -= Hours * 1000 * 60 * 60;

          Minutes := Milliseconds DIV 1000 DIV 60;
          Milliseconds -= Minutes * 1000 * 60;

          Seconds := Milliseconds DIV 1000;
          Milliseconds -= Seconds * 1000;

          //MESSAGE('%1 \%2 \%3', Hours, Minutes, Milliseconds);

      END;


      hh:=FORMAT(Hours);
      mm:=FORMAT(Minutes);
      ss:=FORMAT(Seconds);


      IF STRLEN(hh)=1 THEN
        hh:='0'+hh;
      IF STRLEN(mm)=1 THEN
        mm:='0'+mm;
      IF STRLEN(ss)=1 THEN
        ss:='0'+ss;

      TimeString := hh+':'+mm+':'+ss;


      DateFormat := DateString+'T'+TimeString;
    END;

    PROCEDURE GetAccountNoFromATMNo@1120054002(ATMNo@1120054000 : Code[20]) : Text;
    VAR
      Vendor@1120054001 : Record 23;
    BEGIN
      Vendor.RESET;
      Vendor.SETRANGE(Vendor."ATM No.",ATMNo);
      Vendor.SETRANGE(Vendor.Blocked,Vendor.Blocked::" ");
      IF Vendor.FINDFIRST THEN BEGIN

          IF Vendor.COUNT <> 1 THEN
              ERROR('ATM No. not linked to one account');

          EXIT(Vendor."No.");
      END;
    END;

    LOCAL PROCEDURE SetDocumentNo@1120054007(TransNo@1120054001 : Code[50]) : Code[20];
    VAR
      TNo@1120054000 : Text;
    BEGIN

      TNo := CREATEGUID;
      TNo := DELCHR(TNo,'=','{|}|-');
      TNo := COPYSTR(TNo,1,15);
      MESSAGE('%1',STRLEN(TNo));


      TNo := COPYSTR(TransNo,1,12);

      EXIT(TNo);
    END;

    PROCEDURE GetATMcharges@1120054009(TransCode@1120054000 : Code[10];Terminal@1120054005 : Code[10];Channel@1120054006 : Code[10];Amount@1120054001 : Decimal;VAR BankCharge@1120054002 : Decimal;VAR SaccoFee@1120054003 : Decimal);
    VAR
      Charge@1120054004 : Record 170043;
      Counter@1120054007 : Integer;
    BEGIN

      BankCharge := 0;
      SaccoFee := 0;
      Charge.RESET;
      Charge.SETRANGE(Charge.Code,TransCode);
      Charge.SETRANGE(Charge.Terminal,Terminal);
      Charge.SETRANGE(Charge.Channel,Channel);
      Charge.SETFILTER(Charge.Minimum,'<=%1',Amount);
      Charge.SETFILTER(Charge.Maximum,'>=%1',Amount);
      IF Charge.FINDFIRST THEN BEGIN
          BankCharge := Charge."Bank Commission";
          SaccoFee := Charge."Sacco Commission";

          IF Charge."Sacco Per Every" > 0 THEN BEGIN
              Counter := ROUND(Amount/Charge."Sacco Per Every",1,'>');
              SaccoFee := SaccoFee*Counter;
          END;

      END;
    END;

    PROCEDURE PostATM@1120054006(TransID@1120054003 : Code[50]) Response : Text;
    VAR
      i@1001 : Decimal;
      MemberNo@1002 : Text[30];
      AccBalance@1003 : Decimal;
      thisSavAccNo@1004 : Text[30];
      foundChargeAccount@1006 : Boolean;
      A@1007 : Integer;
      MNo@1008 : Code[20];
      AcctNo@1009 : Code[20];
      TotalCharge@1023 : Decimal;
      AccBal@1024 : Decimal;
      RespTransactionID@1028 : Text;
      RespStatusCode@1025 : Text;
      RespStatusDescription@1026 : Text;
      RespTransactionDate@1027 : DateTime;
      RespTransactionReference@1029 : Text;
      RespInstitutionCode@1030 : Text;
      RespDebitAccount@1031 : Text;
      RespAccountBookBalance@1032 : Decimal;
      RespAccountClearedBalance@1033 : Decimal;
      RespAccountCurrency@1034 : Text;
      TransactionType@1120054004 : Code[10];
      Source@1120054006 : 'NEW_MEMBER,NEW_ACCOUNT,LOAN_ACCOUNT_APPROVAL,DEPOSIT_CONFIRMATION,CASH_WITHDRAWAL_CONFIRM,LOAN_APPLICATION,LOAN_APPRAISAL,LOAN_GUARANTORS,LOAN_REJECTED,LOAN_POSTED,LOAN_DEFAULTED,SALARY_PROCESSING,TELLER_CASH_DEPOSIT,TELLER_CASH_WITHDRAWAL,TELLER_CHEQUE_DEPOSIT,FIXED_DEPOSIT_MATURITY,INTERACCOUNT_TRANSFER,ACCOUNT_STATUS,STATUS_ORDER,EFT_EFFECTED,ATM_APPLICATION_FAILED,ATM_COLLECTION,MBANKING,MEMBER_CHANGES,CASHIER_BELOW_LIMIT,CASHIER_ABOVE_LIMIT,INTERNETBANKING,CRM,MOBILE_PIN,WITHDRAWAL';
      PhoneNo@1120054000 : Code[20];
      Msg@1120054001 : Text;
      Reversal@1120054002 : Boolean;
      Vendor@1120054005 : Record 23;
      Continue@1120054007 : Boolean;
    BEGIN

      //ERROR('test');
      BUser.GET(USERID);

      JTemplate:='GENERAL';
      JBatch:='SKYATM';

      GenJournalBatch.RESET;
      GenJournalBatch.SETRANGE("Journal Template Name",JTemplate);
      GenJournalBatch.SETRANGE(Name,JBatch);
      IF NOT GenJournalBatch.FINDFIRST THEN BEGIN
          GenJournalBatch.INIT;
          GenJournalBatch."Journal Template Name" := JTemplate;
          GenJournalBatch.Name:=JBatch;
          GenJournalBatch.Description:='Sky World ATM Batch';
          GenJournalBatch.INSERT;
      END;


      // Get Excise duty G/L
      ExciseDutyGL := GetExciseDutyGL();
      ExciseDutyRate := GetExciseRate();
      ExciseDuty:=0;


      CoopSetup.GET;
      CoopTrans.RESET;
      IF TransID <>'220205823196_CS_POSTFUNDS' THEN BEGIN
      CoopTrans.SETRANGE(Skipped,FALSE);
      CoopTrans.SETRANGE(Posted,FALSE);
      END;
      CoopTrans.SETRANGE("Transaction ID",TransID);
      IF CoopTrans.FINDFIRST THEN BEGIN
          REPEAT
              CoopTrans.Skipped := TRUE;

              DocNo := CoopTrans."Document No.";
              PDate := CoopTrans."Transaction Date";
              AcctNo := CoopTrans."Member Account";
              ExtDoc := '';
              LoanNo := '';
              TransType := TransType::" ";
              Dim1 := SavAcc."Global Dimension 1 Code";
              Dim2 := SavAcc."Global Dimension 2 Code";
              SystCreated := TRUE;
              Continue := TRUE;
              IF Vendor.GET(AcctNo) THEN
                  IF Vendor.Blocked <> Vendor.Blocked::" " THEN
                      Continue := FALSE;



              IF Continue THEN BEGIN

                  IF CoopTrans.Activity <>CoopTrans.Activity::Reversal THEN BEGIN
                      SaccoTrans.InitJournal(JTemplate,JBatch);



                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AcctNo,COPYSTR(CoopTrans."Transaction Name",1,50),BalAccType::"Bank Account",
                                    CoopSetup."Coop Bank Account",CoopTrans.Amount,ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');


                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AcctNo,COPYSTR(CoopTrans."Transaction Name",1,50),BalAccType::"G/L Account",
                                    '',CoopTrans."Total Charges",ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');
                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::Vendor,AcctNo,COPYSTR('Excise Duty - '+CoopTrans."Transaction Name",1,50),BalAccType::"G/L Account",
                                    ExciseDutyGL,CoopTrans."Sacco Excise Duty",ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');


                      AcctNo := CoopSetup."Coop Commission Account";
                      ExtDoc := CoopTrans."Member Account";
                      LoanNo := '';
                      TransType := TransType::" ";
                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"Bank Account",CoopSetup."Coop Commission Account",COPYSTR(CoopTrans."Transaction Name"+': '+CoopTrans."Member Account",1,50),BalAccType::"G/L Account",
                                    '',-CoopTrans."Coop Fee",ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');

                      AcctNo := CoopSetup."Coop Fee Account";
                      ExtDoc := CoopTrans."Member Account";
                      LoanNo := '';
                      TransType := TransType::" ";

                      SaccoTrans.JournalInsert(JTemplate,JBatch,DocNo,PDate,AcctType::"G/L Account",AcctNo,COPYSTR(CoopTrans."Transaction Name"+': '+CoopTrans."Member Account",1,50),BalAccType::"G/L Account",
                                    '',-CoopTrans."Sacco Fee",ExtDoc,LoanNo,TransType,Dim1,Dim2,SystCreated,'');

                      CoopTrans.Posted:=TRUE;
                      CoopTrans.Skipped := FALSE;
                      CoopTrans."Posted By":=USERID;
                      CoopTrans."Date Posted":=TODAY;
                      CoopTrans.MODIFY;

                      IF CoopTrans.Activity = CoopTrans.Activity::"Funds Transfer" THEN BEGIN
                          IF SavAcc.GET(CoopTrans."Member Account") THEN BEGIN
                              PhoneNo := SavAcc."Transactional Mobile No";
                              IF PhoneNo = '' THEN
                                  PhoneNo := SavAcc."Mobile Phone No";


                              Msg := 'Dear '+SkyMbanking.FirstName(SavAcc.Name)+', You have withdrawn KES '+FORMAT(CoopTrans.Amount)+' from your FOSA A/C  on '+FORMAT(CoopTrans."Transaction Date")+' at '+CoopTrans.Location;
                              SkyMbanking.SendSms(Source::CASH_WITHDRAWAL_CONFIRM,PhoneNo,Msg,CoopTrans."Transaction ID",CoopTrans."Member Account",TRUE,211,TRUE);

                          END;
                      END;

                      SaccoTrans.PostJournal(JTemplate,JBatch);
                  END
                  ELSE IF CoopTrans.Activity = CoopTrans.Activity::Reversal THEN BEGIN

                      IF CoopTrans."Transaction Type" = '1420' THEN BEGIN
                          IF CoopTrans."Original Transaction ID"<>'' THEN BEGIN

                              IF ReverseTransaction(CoopTrans."Transaction ID",CoopTrans."Original Transaction ID",CoopTrans."Service Name",CoopTrans.Channel,CoopTrans."Member Account",CoopTrans.Amount) THEN BEGIN
                                  IF SavAcc.GET(CoopTrans."Member Account") THEN BEGIN
                                      PhoneNo := SavAcc."Transactional Mobile No";
                                      IF PhoneNo = '' THEN
                                          PhoneNo := SavAcc."Mobile Phone No";


                                      Msg := 'Dear '+SkyMbanking.FirstName(SavAcc.Name)+', your transaction of KES '+FORMAT(ABS(CoopTrans.Amount))+' has been reversed';
                                      SkyMbanking.SendSms(Source::CASH_WITHDRAWAL_CONFIRM,PhoneNo,Msg,CoopTrans."Transaction ID",CoopTrans."Member Account",TRUE,211,TRUE);
                                  END;

                                  CoopTrans.Posted:=TRUE;
                                  CoopTrans."Posted By":=USERID;
                                  CoopTrans."Date Posted":=TODAY;


                                  CoopTrans.Reversed:=TRUE;
                                  CoopTrans."Date Reversed":=TODAY;
                                  CoopTrans."Reversed By":=USERID;
                                  CoopTrans.MODIFY;

                                  RespStatusCode:=Success;
                                  RespStatusDescription:='Success';
                              END
                              ELSE BEGIN
                                  CoopTrans.Remarks := 'Reversal Failed';
                              END;

                          END
                          ELSE
                              CoopTrans.Remarks := 'Original Transaction ID Missing';
                      END
                      ELSE
                          CoopTrans.Remarks := 'Invalid Transaction Code. Expected Code is 1420';

                  END;
                  CoopTrans.MODIFY;
              END;
          UNTIL CoopTrans.NEXT=0;
      END;
    END;

    BEGIN
    {
4.29935E+15
    }
    END.
  }
}

