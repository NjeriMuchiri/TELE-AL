OBJECT page 17400 Posted BOSA Receipt Card
{
  OBJECT-PROPERTIES
  {
    Date=03/21/17;
    Time=[ 1:22:58 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516247;
    SourceTableView=WHERE(Posted=FILTER(Yes));
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102760028;1 ;ActionGroup;
                      CaptionML=ENU=Suggest }
      { 1102760029;2 ;Action    ;
                      Name=Cash/Cheque Clearance;
                      CaptionML=ENU=Cash/Cheque Clearance;
                      OnAction=BEGIN
                                 Cheque := FALSE;
                                 //SuggestBOSAEntries();
                               END;
                                }
      { 1102760032;2 ;Separator  }
      { 1102760033;2 ;Action    ;
                      Name=Suggest Payments;
                      CaptionML=ENU=Suggest Monthy Repayments;
                      OnAction=BEGIN

                                 TESTFIELD(Posted,FALSE);
                                 TESTFIELD("Account No.");
                                 TESTFIELD(Amount);
                                 //Cust.CALCFIELDS(Cust."Registration Fee Paid");

                                 ReceiptAllocations.RESET;
                                 ReceiptAllocations.SETRANGE(ReceiptAllocations."Document No","Transaction No.");
                                 ReceiptAllocations.DELETEALL;


                                 IF "Account Type"="Account Type"::Member THEN  BEGIN

                                 BosaSetUp.GET();
                                 RunBal:=Amount;

                                 IF RunBal>0 THEN BEGIN

                                 IF Cust.GET("Account No.") THEN BEGIN
                                 Cust.CALCFIELDS(Cust."Registration Fee Paid");
                                 IF Cust."Registration Fee Paid"=0 THEN BEGIN
                                 IF Cust."Registration Date" >030114D THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Transaction No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Registration Fee";
                                 ReceiptAllocations."Loan No.":='';
                                 ReceiptAllocations.Amount:=BosaSetUp."Registration Fee";
                                 //ReceiptAllocations."Interest Amount":=Loans."Interest Due";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount;
                                 ReceiptAllocations."Global Dimension 1 Code":='BOSA';
                                 ReceiptAllocations."Global Dimension 2 Code":='NAIROBI';
                                 ReceiptAllocations.INSERT;
                                 RunBal:=RunBal-ReceiptAllocations.Amount;
                                 END;
                                 END;
                                 END;
                                 //********** Mpesa Charges
                                 IF "Mode of Payment"= "Mode of Payment"::Mpesa THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Transaction No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"M Pesa Charge ";
                                 ReceiptAllocations."Loan No.":='';

                                  // M Pesa Tarriff

                                 IF Amount<= 2499 THEN
                                 ReceiptAllocations."Total Amount":=55
                                 ELSE IF Amount <= 4999 THEN
                                 ReceiptAllocations."Total Amount":=75
                                 ELSE IF Amount <= 9999 THEN
                                 ReceiptAllocations."Total Amount":=105
                                 ELSE IF Amount <= 19999 THEN
                                 ReceiptAllocations."Total Amount":=130
                                 ELSE IF Amount <= 34999 THEN
                                 ReceiptAllocations."Total Amount":=185
                                 ELSE IF Amount <= 49999 THEN
                                 ReceiptAllocations."Total Amount":=220
                                 ELSE IF Amount <= 70000 THEN
                                 ReceiptAllocations."Total Amount":=240
                                 ELSE IF Amount > 70000 THEN
                                 ERROR ('Sorry the Maximum M - Pesa transaction Amount is Ksha. 70,000');


                                 ReceiptAllocations.Amount:=ReceiptAllocations."Total Amount";
                                 ReceiptAllocations."Global Dimension 1 Code":='BOSA';
                                 ReceiptAllocations."Global Dimension 2 Code":='NAIROBI';
                                 ReceiptAllocations.INSERT;
                                 END;
                                 //********** END Mpesa Charges

                                 IF RunBal >0 THEN BEGIN
                                 //Loan Repayments
                                 Loans.RESET;
                                 Loans.SETCURRENTKEY(Loans.Source,Loans."Client Code");
                                 Loans.SETRANGE(Loans."Client Code","Account No.");
                                 Loans.SETRANGE(Loans.Source,Loans.Source::BOSA);
                                 IF Loans.FIND('-') THEN BEGIN
                                 REPEAT

                                 //Insurance Charge
                                 Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Interest Due",Loans."Loans Insurance",Loans."Oustanding Interest");
                                 IF (Loans."Outstanding Balance" > 0 ) AND  (Loans."Approved Amount" > 100000) AND
                                 (Loans."Loans Insurance">0) THEN BEGIN



                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Transaction No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Insurance Paid";
                                 ReceiptAllocations."Loan No.":=Loans."Loan  No.";
                                 ReceiptAllocations."Loan ID":=Loans."Loan Product Type";
                                 ReceiptAllocations.Amount:=Loans."Loans Insurance";
                                 //MESSAGE('ReceiptAllocations.Amount is %1',ReceiptAllocations.Amount);
                                 ReceiptAllocations."Amount Balance":=Loans."Outstanding Balance";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount;
                                 ReceiptAllocations."Global Dimension 1 Code":='BOSA';
                                 ReceiptAllocations."Global Dimension 2 Code":='NAIROBI';
                                 ReceiptAllocations.INSERT;
                                 END;


                                 IF (Loans."Outstanding Balance") > 0 THEN BEGIN
                                 LOustanding:=0;
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Transaction No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::Repayment;
                                 ReceiptAllocations."Loan No.":=Loans."Loan  No.";
                                 ReceiptAllocations."Loan ID":=Loans."Loan Product Type";
                                 //ReceiptAllocations.Amount:=Loans.Repayment-Loans."Loans Insurance"-Loans."Oustanding Interest";
                                 ReceiptAllocations.Amount:=Loans."Loan Principle Repayment";
                                 ReceiptAllocations."Amount Balance":=Loans."Outstanding Balance";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
                                 ReceiptAllocations."Global Dimension 1 Code":='BOSA';
                                 ReceiptAllocations."Global Dimension 2 Code":='NAIROBI';
                                 ReceiptAllocations.INSERT;
                                 END;

                                 IF (Loans."Oustanding Interest" > 0 )THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Transaction No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Interest Paid";
                                 ReceiptAllocations."Loan No.":=Loans."Loan  No.";
                                 ReceiptAllocations.Amount:=Loans."Oustanding Interest";
                                 //ReceiptAllocations.Amount:=Loans."Loan Interest Repayment";
                                 //ReceiptAllocations.Amount:=Loans."Interest Due";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount+ReceiptAllocations."Interest Amount";
                                 ReceiptAllocations."Global Dimension 1 Code":='BOSA';
                                 ReceiptAllocations."Global Dimension 2 Code":='NAIROBI';
                                 ReceiptAllocations.INSERT;
                                 END;

                                 RunBal:=RunBal-ReceiptAllocations.Amount;
                                 MESSAGE('RunBal is %1',RunBal);

                                 UNTIL Loans.NEXT = 0;
                                 END;
                                 END;
                                 END;
                                 BosaSetUp.GET();
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Transaction No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Benevolent Fund";
                                 ReceiptAllocations."Loan No.":=' ';
                                 ReceiptAllocations.Amount:=BosaSetUp."Welfare Contribution";
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount;
                                 ReceiptAllocations."Global Dimension 1 Code":='BOSA';
                                 ReceiptAllocations."Global Dimension 2 Code":='NAIROBI';
                                 ReceiptAllocations.INSERT;

                                 //Deposits Contribution
                                 IF Cust.GET("Account No.") THEN BEGIN
                                 IF Cust."Monthly Contribution">0 THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Transaction No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Deposit Contribution";
                                 ReceiptAllocations."Loan No.":='';
                                 ReceiptAllocations.Amount:=ROUND(Cust."Monthly Contribution",0.01);;
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount;
                                 ReceiptAllocations."Global Dimension 1 Code":='BOSA';
                                 ReceiptAllocations."Global Dimension 2 Code":='NAIROBI';
                                 ReceiptAllocations.INSERT;
                                 END;
                                 END;

                                 //Shares Contribution
                                 IF Cust.GET("Account No.") THEN BEGIN
                                 Cust.CALCFIELDS(Cust."Shares Retained");

                                 IF Cust."Shares Retained"<5000  THEN BEGIN
                                 BosaSetUp.GET();
                                 IF BosaSetUp."Monthly Share Contributions">0 THEN BEGIN
                                 //IF CONFIRM('This member has reached a maximum share contribution of Kshs. 5,000/=. Do you want to post this transaction as shares contribution?',TRUE)=TRUE THEN
                                 //IF CONFIRM(Text001,TRUE) THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Transaction No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"Shares Capital";
                                 ReceiptAllocations."Loan No.":='';
                                 ReceiptAllocations.Amount:=ROUND(BosaSetUp."Monthly Share Contributions",0.01);
                                 ReceiptAllocations."Total Amount":=ReceiptAllocations.Amount;
                                 ReceiptAllocations."Global Dimension 1 Code":='BOSA';
                                 ReceiptAllocations."Global Dimension 2 Code":='NAIROBI';
                                 ReceiptAllocations.INSERT;
                                 END;
                                 END;
                                 END;
                                 END;

                                 IF "Account Type"="Account Type"::Vendor THEN  BEGIN
                                 IF "Mode of Payment"= "Mode of Payment"::Mpesa THEN BEGIN
                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Transaction No.";
                                 ReceiptAllocations."Member No":="Account No.";

                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"M Pesa Charge ";
                                 ReceiptAllocations."Total Amount":= Amount ;
                                 ReceiptAllocations."Loan No.":='';


                                  // M Pesa Tarriff
                                 MpesaCharge:=0;
                                 IF Amount<= 2499 THEN
                                 ReceiptAllocations."Total Amount":=55
                                 ELSE IF Amount <= 4999 THEN
                                 ReceiptAllocations."Total Amount":=75
                                 ELSE IF Amount <= 9999 THEN
                                 ReceiptAllocations."Total Amount":=105
                                 ELSE IF Amount <= 19999 THEN
                                 ReceiptAllocations."Total Amount":=130
                                 ELSE IF Amount <= 34999 THEN
                                 ReceiptAllocations."Total Amount":=185
                                 ELSE IF Amount <= 49999 THEN
                                 ReceiptAllocations."Total Amount":=220
                                 ELSE IF Amount <= 70000 THEN
                                 ReceiptAllocations."Total Amount":=240
                                 ELSE IF Amount > 70000 THEN
                                 ERROR ('Sorry the Maximum M - Pesa transaction Amount is Ksha. 70,000');
                                 MpesaCharge:=ReceiptAllocations."Total Amount";
                                 ReceiptAllocations.Amount:=ReceiptAllocations."Total Amount";

                                 //ReceiptAllocations."Total Amount":=Amount;
                                 ReceiptAllocations."Global Dimension 1 Code":='BOSA';
                                 ReceiptAllocations."Global Dimension 2 Code":='NAIROBI';
                                 ReceiptAllocations.INSERT;
                                 END;

                                 //********** END Mpesa Charges


                                 ReceiptAllocations.INIT;
                                 ReceiptAllocations."Document No":="Transaction No.";
                                 ReceiptAllocations."Member No":="Account No.";
                                 ReceiptAllocations."Transaction Type":=ReceiptAllocations."Transaction Type"::"FOSA Account";
                                 //GenJournalLine.Description:= 'BT'+'-'+Remarks+'-'+FORMAT("Mode of Payment")+'-'+"Cheque No.";
                                 ReceiptAllocations."Loan No.":=' ';
                                 ReceiptAllocations."Total Amount":=Amount;
                                 ReceiptAllocations."Global Dimension 1 Code":='FOSA';
                                 ReceiptAllocations."Global Dimension 2 Code":='NAIROBI';
                                 ReceiptAllocations.Amount:= ReceiptAllocations."Total Amount";
                                 ReceiptAllocations.INSERT;



                                 END;
                                 //VALIDATE("Allocated Amount");
                                 CALCFIELDS("Allocated Amount");
                                 "Un allocated Amount":=(Amount-"Allocated Amount");
                                 MODIFY;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102760026;1 ;Action    ;
                      Name=Reprint Frecipt;
                      CaptionML=ENU=Reprint Receipt;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TESTFIELD(Posted);

                                 BOSARcpt.RESET;
                                 BOSARcpt.SETRANGE(BOSARcpt."Transaction No.","Transaction No.");
                                 IF BOSARcpt.FIND('-') THEN
                                 //REPORT.RUN(51516247,TRUE,TRUE,BOSARcpt)
                                   //
                                   REPORT.RUN(51516836,TRUE,TRUE,BOSARcpt)
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                CaptionML=ENU=Transaction }

    { 1102760001;2;Field  ;
                SourceExpr="Transaction No.";
                Editable=FALSE }

    { 1102755005;2;Field  ;
                SourceExpr="Account Type" }

    { 1102755002;2;Field  ;
                SourceExpr=Source }

    { 1102760003;2;Field  ;
                SourceExpr="Account No." }

    { 1102760005;2;Field  ;
                SourceExpr=Name;
                Editable=TRUE }

    { 1102760007;2;Field  ;
                SourceExpr=Amount }

    { 1102755004;2;Field  ;
                SourceExpr="Mode of Payment" }

    { 1102755003;2;Field  ;
                SourceExpr=Remarks }

    { 1102760019;2;Field  ;
                SourceExpr="Allocated Amount" }

    { 1102755001;2;Field  ;
                SourceExpr="Un allocated Amount" }

    { 1102755000;2;Field  ;
                CaptionML=ENU=Teller Till / Bank  No.;
                SourceExpr="Employer No." }

    { 1102760009;2;Field  ;
                CaptionML=ENU=Cheque / Slip  No.;
                SourceExpr="Cheque No." }

    { 1102760011;2;Field  ;
                CaptionML=ENU=Cheque / Slip  Date;
                SourceExpr="Cheque Date" }

    { 1102760013;2;Field  ;
                SourceExpr=Posted;
                Editable=FALSE }

    { 1102760017;2;Field  ;
                SourceExpr="User ID" }

    { 1102760021;2;Field  ;
                SourceExpr="Transaction Date";
                Editable=True }

    { 1102760023;2;Field  ;
                SourceExpr="Transaction Time";
                Editable=True }

  }
  CODE
  {
    VAR
      Text001@1102755001 : TextConst 'ENU="This member has reached a maximum share contribution of Kshs. 5,000/=. Do you want to post this transaction as shares contribution?"';
      GenJournalLine@1024 : Record 81;
      InterestPaid@1023 : Decimal;
      PaymentAmount@1022 : Decimal;
      RunBal@1021 : Decimal;
      Recover@1020 : Boolean;
      Cheque@1019 : Boolean;
      ReceiptAllocations@1018 : Record 51516246;
      Loans@1017 : Record 51516230;
      Commision@1016 : Decimal;
      LOustanding@1015 : Decimal;
      TotalCommision@1014 : Decimal;
      TotalOustanding@1013 : Decimal;
      Cust@1012 : Record 51516223;
      BOSABank@1011 : Code[20];
      LineNo@1010 : Integer;
      BOSARcpt@1009 : Record 51516247;
      TellerTill@1008 : Record 270;
      CurrentTellerAmount@1007 : Decimal;
      TransType@1006 : Text[30];
      RCPintdue@1005 : Decimal;
      BosaSetUp@1004 : Record 51516257;
      MpesaCharge@1003 : Decimal;
      CustPostingGrp@1002 : Record 92;
      MpesaAc@1001 : Code[30];
      GenSetup@1000 : Record 51516257;

    LOCAL PROCEDURE AllocatedAmountOnDeactivate@19031695();
    BEGIN
      CurrPage.UPDATE:=TRUE;
    END;

    BEGIN
    END.
  }
}

