OBJECT page 172082 Salaries Buffer - Posted
{
  OBJECT-PROPERTIES
  {
    Date=12/11/20;
    Time=12:56:23 PM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=Yes;
    SourceTable=Table51516317;
    SourceTableView=WHERE(Processed=CONST(Yes));
    PageType=List;
    OnOpenPage=BEGIN

                 SETRANGE(USER,USERID);
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102760016;1 ;ActionGroup;
                      CaptionML=ENU=Salaries }
      { 1120054001;2 ;Action    ;
                      Name=Get No to use;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Allocate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SaccoNoSeries.GET;
                                 CLEAR(NoSeriesManagement);
                                 Notouse:=NoSeriesManagement.GetNextNo(SaccoNoSeries."Salaries Upload Nos.",TODAY,FALSE);
                                 MESSAGE('%1',Notouse);
                               END;
                                }
      { 1102760017;2 ;Action    ;
                      CaptionML=ENU=Import;
                      RunObject=XMLport 51516009;
                      Promoted=Yes;
                      Image=Import;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //CurrPage.UPDATE;
                               END;
                                }
      { 1102756000;2 ;Action    ;
                      CaptionML=ENU=Import - OMEGA;
                      Visible=false }
      { 1102760018;2 ;Separator  }
      { 1102760031;2 ;Action    ;
                      CaptionML=ENU=Confirm Account Names;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SalaryProcessingLines2.RESET;
                                 SalaryProcessingLines2.SETRANGE(SalaryProcessingLines2."Salary No","Salary No");
                                 REPORT.RUN(51516284,TRUE,FALSE,SalaryProcessingLines2);
                               END;
                                }
      { 1000000002;2 ;Action    ;
                      Name=Check for Multiple Salaries;
                      RunObject=Report 51516283;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Process }
      { 1102755000;2 ;Action    ;
                      Name=Report Unblock Accounts for Salaries;
                      CaptionML=ENU=Unblock Accounts for Salaries;
                      RunObject=Report 51516285;
                      Promoted=Yes;
                      Visible=TRUE;
                      Image=Report;
                      PromotedCategory=Process }
      { 1102760028;2 ;Action    ;
                      CaptionML=ENU=Check for Multiple Salary;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Process }
      { 1102760032;2 ;Separator  }
      { 1102760019;2 ;Action    ;
                      CaptionML=ENU=Generate Salaries Batch;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 SalaryProcessingLines2.RESET;
                                 SalaryProcessingLines2.SETRANGE(SalaryProcessingLines2."Salary No","Salary No");
                                 REPORT.RUN(51516286,TRUE,FALSE,SalaryProcessingLines2);
                               END;
                                }
      { 1102760024;2 ;Separator  }
      { 1102760041;2 ;Action    ;
                      CaptionML=ENU=Generate ATM Charges;
                      RunObject=Report 39004335;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Report;
                      PromotedCategory=Report }
      { 1102760042;2 ;Separator  }
      { 1102760025;2 ;Action    ;
                      CaptionML=ENU=Mark as processed;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SalaryProcessingLines2.RESET;
                                 SalaryProcessingLines2.SETRANGE(SalaryProcessingLines2."Salary No","Salary No");
                                 REPORT.RUN(51516268,TRUE,FALSE,SalaryProcessingLines2);
                               END;
                                }
      { 1120054002;2 ;Action    ;
                      Name=Mark As Delegates Allowance;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostMail;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SalaryProcessingLines2.RESET;
                                 SalaryProcessingLines2.SETRANGE(SalaryProcessingLines2."Salary No","Salary No");
                                 IF SalaryProcessingLines2.FINDFIRST THEN
                                 BEGIN
                                 REPEAT
                                 SalaryProcessingLines2."Delegates Allowance":=TRUE;
                                 SalaryProcessingLines2.MODIFY;
                                 UNTIL SalaryProcessingLines2.NEXT=0;
                                 END;
                               END;
                                }
      { 1102760043;2 ;Separator  }
      { 1102760044;2 ;Action    ;
                      CaptionML=ENU=Processed Salaries;
                      RunObject=Page 39004344;
                      Promoted=Yes;
                      Image=ListPage;
                      PromotedCategory=Process }
      { 1000000000;2 ;Action    ;
                      Name=Generate Dividends Batch;
                      RunObject=Report 39004339;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //39004339
                               END;
                                }
      { 1000000003;2 ;Action    ;
                      Name=Generate Dividends Loans Batch;
                      RunObject=Report 39004340;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //39004339
                               END;
                                }
      { 1120054000;2 ;Action    ;
                      Name=Charge standing orders;
                      OnAction=BEGIN

                                 AmountDed:=0;
                                 StandingOrders.Effected:=FALSE;
                                 StandingOrders.Unsuccessfull:=FALSE;
                                 StandingOrders.Balance:=0;



                                 IF AccountS.GET(StandingOrders."Source Account No.") THEN BEGIN
                                 DActivity3:=AccountS."Global Dimension 1 Code";
                                 DBranch3:=AccountS."Global Dimension 2 Code";

                                 //AccountS.CALCFIELDS(AccountS.Balance,AccountS."Uncleared Cheques");
                                 //MESSAGE('your run balance  is %1',AccountS.Balance);
                                 AvailableBal:=(AccountS.Balance-AccountS."Uncleared Cheques");

                                 IF AccountTypeS.GET(AccountS."Account Type") THEN BEGIN

                                 //AvailableBal:=AvailableBal-AccountTypeS."Minimum Balance";
                                 //Charges.GET('standingorder');//commed for now since standing orders are not charged here
                                 Charges.RESET;
                                 //IF "Destination Account Type" = "Destination Account Type"::External THEN
                                 Charges.SETRANGE(Charges."Charge Type",Charges."Charge Type"::"External Standing Order Fee");
                                 //ELSE
                                 Charges.SETRANGE(Charges."Charge Type",Charges."Charge Type"::"Standing Order Fee");
                                 IF Charges.FIND('-') THEN BEGIN
                                 AvailableBal:=AvailableBal-Charges."Charge Amount";
                                 END;

                                 IF StandingOrders."Next Run Date" = 0D THEN
                                 StandingOrders."Next Run Date":=StandingOrders."Effective/Start Date";

                                 IF AvailableBal >= StandingOrders.Amount THEN BEGIN
                                 AmountDed:=StandingOrders.Amount;
                                 //DedStatus:=DedStatus::Successfull;............uncomment
                                 IF StandingOrders.Amount >= StandingOrders.Balance THEN BEGIN
                                 StandingOrders.Balance:=0;
                                 //"Standing Orders"."Next Run Date":=CALCDATE("Standing Orders".Frequency,"Standing Orders"."Next Run Date");
                                 StandingOrders.Unsuccessfull:=FALSE;
                                 END ELSE BEGIN
                                 StandingOrders.Balance:=StandingOrders.Balance-StandingOrders.Amount;
                                 StandingOrders.Unsuccessfull:=TRUE;
                                 END;


                                 END ELSE BEGIN
                                 IF StandingOrders."Don't Allow Partial Deduction" = TRUE THEN BEGIN
                                 AmountDed:=0;
                                 DedStatus:=DedStatus::Failed;
                                 StandingOrders.Balance:=StandingOrders.Amount;
                                 StandingOrders.Unsuccessfull:=TRUE;

                                 END ELSE BEGIN
                                 AmountDed:=AvailableBal;
                                 DedStatus:=DedStatus::"Partial Deduction";
                                 StandingOrders.Balance:=StandingOrders.Amount-AmountDed;
                                 StandingOrders.Unsuccessfull:=TRUE;

                                 END;
                                 END;

                                 IF AmountDed < 0 THEN BEGIN
                                 AmountDed:=0;
                                 DedStatus:=DedStatus::Failed;

                                 StandingOrders.Balance:=StandingOrders.Amount;
                                 StandingOrders.Unsuccessfull:=TRUE;


                                 END;

                                 MESSAGE('amount ded ia %1',AmountDed);
                                 IF AmountDed > 0 THEN BEGIN
                                 ActualSTO:=0;
                                 IF StandingOrders."Destination Account Type" = StandingOrders."Destination Account Type"::BOSA THEN BEGIN
                                 PostBOSAEntries();
                                 AmountDed:=ActualSTO;
                                 END;

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='SALARIES';
                                 GenJournalLine."Document No.":=DocNo;
                                 GenJournalLine."External Document No.":=StandingOrders."Destination Account No.";
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=StandingOrders."Source Account No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:=StandingOrders."Account Name"+''+StandingOrders."Staff/Payroll No."+' ' +COPYSTR(StandingOrders.Remarks,1,14);
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=AmountDed;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity3;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch3;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //Added SURESTEP
                                 RunBal:=RunBal-AmountDed;

                                 IF StandingOrders."Destination Account Type" <> StandingOrders."Destination Account Type"::BOSA THEN BEGIN

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='SALARIES';
                                 GenJournalLine."Document No.":=DocNo;
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."External Document No.":=StandingOrders."Source Account No.";
                                 IF StandingOrders."Destination Account Type" = StandingOrders."Destination Account Type"::Internal THEN BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=StandingOrders."Destination Account No.";
                                 END ELSE BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=AccountTypeS."Standing Orders Suspense";
                                 END;
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:=StandingOrders."Account Name"+''+StandingOrders."Staff/Payroll No."+' ' +COPYSTR(StandingOrders.Remarks,1,14);//'Standing Order ' + "Standing Orders"."No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=-AmountDed;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity3;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch3;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 END;

                                 END;
                                 MESSAGE('success');
                                 //Standing Order Charges
                                 IF AmountDed > 0 THEN BEGIN
                                 Charges.RESET;
                                 //IF "Destination Account Type" = "Destination Account Type"::External THEN
                                 //Charges.SETRANGE(Charges."Charge Type",Charges."Charge Type"::"External Standing Order Fee")
                                 //ELSE
                                 ChargeAmount:=0;
                                 Charges.GET('STO');
                                 Charges.RESET;
                                 IF StandingOrders."Destination Account Type" = StandingOrders."Destination Account Type"::External THEN
                                 Charges.SETRANGE(Charges."Charge Type",Charges."Charge Type"::"External Standing Order Fee")
                                 ELSE
                                 Charges.SETRANGE(Charges."Charge Type",Charges."Charge Type"::"Standing Order Fee");
                                 IF Charges.FIND('-') THEN BEGIN
                                 ChargeAmount:=Charges."Charge Amount";
                                 END;
                                 IF (Charges."Charge Type"=Charges."Charge Type"::"Standing Order Fee" ) OR (Charges."Charge Type"=Charges."Charge Type"::"External Standing Order Fee")
                                 THEN BEGIN
                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='SALARIES';
                                 GenJournalLine."Document No.":=DocNo;
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=StandingOrders."Source Account No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:=Charges.Description;
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=ChargeAmount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Bal. Account No.":=Charges."GL Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity3;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch3;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 END;

                                 END ELSE BEGIN
                                 IF AccountTypeS.Code <> 'WSS' THEN BEGIN
                                 Charges.RESET;
                                 Charges.SETRANGE(Charges."Charge Type",Charges."Charge Type"::"Failed Standing Order Fee");
                                 IF Charges.FIND('-') THEN BEGIN
                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='GENERAL';
                                 GenJournalLine."Journal Batch Name":='SALARIES';
                                 GenJournalLine."Document No.":=DocNo;
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=StandingOrders."Source Account No.";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:=Charges.Description;
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=ChargeAmount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Bal. Account No.":=Charges."GL Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 GenJournalLine."Shortcut Dimension 1 Code":=DActivity3;
                                 GenJournalLine."Shortcut Dimension 2 Code":=DBranch3;
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 END;
                                 END;
                                 END;

                                 //Standing Order Charges

                                 //PostBOSAEntries();

                                 StandingOrders.Effected:=TRUE;
                                 StandingOrders."Date Reset":=TODAY;
                                 StandingOrders.MODIFY;


                                 STORegister.INIT;
                                 STORegister."Register No.":='';
                                 STORegister.VALIDATE(STORegister."Register No.");
                                 STORegister."Standing Order No.":=StandingOrders."No.";
                                 STORegister."Source Account No.":=StandingOrders."Source Account No.";
                                 STORegister."Staff/Payroll No.":=StandingOrders."Staff/Payroll No.";
                                 STORegister.Date:=TODAY;
                                 STORegister."Account Name":=StandingOrders."Account Name";
                                 STORegister."Destination Account Type":=StandingOrders."Destination Account Type";
                                 STORegister."Destination Account No.":=StandingOrders."Destination Account No.";
                                 STORegister."Destination Account Name":=StandingOrders."Destination Account Name";
                                 STORegister."BOSA Account No.":=StandingOrders."BOSA Account No.";
                                 STORegister."Effective/Start Date":=StandingOrders."Effective/Start Date";
                                 STORegister."End Date":=StandingOrders."End Date";
                                 STORegister.Duration:=StandingOrders.Duration;
                                 STORegister.Frequency:=StandingOrders.Frequency;
                                 STORegister."Don't Allow Partial Deduction":=StandingOrders."Don't Allow Partial Deduction";
                                 STORegister."Deduction Status":=DedStatus;
                                 STORegister.Remarks:=StandingOrders.Remarks;
                                 STORegister.Amount:=StandingOrders.Amount;
                                 STORegister."Amount Deducted":=AmountDed;
                                 IF StandingOrders."Destination Account Type" = StandingOrders."Destination Account Type"::External THEN
                                 STORegister.EFT:=TRUE;
                                 STORegister."Document No.":=DocNo;
                                 STORegister.INSERT(TRUE);


                                 END;
                                 END;

                                 //END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                Editable=TRUE;
                GroupType=Repeater }

    { 1102760001;2;Field  ;
                SourceExpr="No.";
                Editable=TRUE }

    { 1102760045;2;Field  ;
                SourceExpr="Staff No." }

    { 1102760003;2;Field  ;
                SourceExpr="Account No." }

    { 1000000004;2;Field  ;
                SourceExpr="Client Code" }

    { 1102760047;2;Field  ;
                SourceExpr="Account Name" }

    { 1102760049;2;Field  ;
                SourceExpr=Name;
                Visible=FALSE }

    { 1102760009;2;Field  ;
                SourceExpr=Amount }

    { 1102760029;2;Field  ;
                SourceExpr="Branch Reff.";
                Visible=FALSE }

    { 1102760035;2;Field  ;
                SourceExpr="ID No.";
                Visible=FALSE }

    { 1102760037;2;Field  ;
                SourceExpr="Original Account No.";
                Visible=FALSE }

    { 1102760011;2;Field  ;
                SourceExpr="Account Not Found";
                Visible=TRUE;
                Editable=FALSE }

    { 1102760020;2;Field  ;
                SourceExpr="Document No.";
                Visible=FALSE;
                Editable=FALSE }

    { 1102760022;2;Field  ;
                SourceExpr=Date;
                Visible=FALSE;
                Editable=FALSE }

    { 1102760039;2;Field  ;
                CaptionML=ENU=Blocked Accounts;
                SourceExpr="Blocked Accounts 0";
                Visible=TRUE;
                Editable=FALSE }

    { 1102760026;2;Field  ;
                SourceExpr="Multiple Salary";
                Visible=TRUE;
                Editable=FALSE }

    { 1000000001;2;Field  ;
                SourceExpr=USER;
                Editable=FALSE }

    { 1120054003;2;Field  ;
                SourceExpr="Delegates Allowance" }

  }
  CODE
  {
    VAR
      Charges@1120054007 : Record 51516297;
      GenJournalLine@1120054062 : Record 81;
      GLPosting@1120054061 : Codeunit 12;
      Account@1120054060 : Record 23;
      AccountType@1120054059 : Record 51516295;
      AvailableBal@1120054058 : Decimal;
      STORegister@1120054057 : Record 51516308;
      AmountDed@1120054056 : Decimal;
      DedStatus@1120054055 : 'Successfull,Partial Deduction,Failed';
      LineNo@1120054053 : Integer;
      DocNo@1120054052 : Code[20];
      PDate@1120054051 : Date;
      SalFee@1120054050 : Decimal;
      SalGLAccount@1120054049 : Code[20];
      Loans@1120054048 : Record 51516230;
      LRepayment@1120054047 : Decimal;
      RunBal@1120054046 : Decimal;
      Interest@1120054045 : Decimal;
      SittingAll@1120054044 : Boolean;
      UsersID@1120054043 : Record 2000000120;
      DActivity@1120054042 : Code[20];
      DBranch@1120054041 : Code[20];
      AccountS@1120054040 : Record 23;
      AccountTypeS@1120054039 : Record 51516295;
      IssueDate@1120054038 : Date;
      DActivity2@1120054037 : Code[20];
      DBranch2@1120054036 : Code[20];
      DActivity3@1120054035 : Code[20];
      DBranch3@1120054034 : Code[20];
      BOSABank@1120054033 : Code[20];
      ReceiptAllocations@1120054032 : Record 51516246;
      STORunBal@1120054031 : Decimal;
      ReceiptAmount@1120054030 : Decimal;
      StandingOrders@1120054029 : Record 51516307;
      AccountCard@1120054028 : Record 23;
      AccountCard2@1120054027 : Record 23;
      FlexContribution@1120054026 : Decimal;
      FlexAccountNo@1120054025 : Code[20];
      ActualSTO@1120054024 : Decimal;
      InsCont@1120054023 : Decimal;
      LoanType@1120054022 : Record 51516240;
      Remarks@1120054021 : Text[50];
      Trans@1120054020 : Record 51516299;
      TotSal@1120054019 : Decimal;
      Gensetup@1120054018 : Record 51516257;
      ProcessingUser@1120054017 : Code[50];
      SalBuffer@1120054016 : Record 51516317;
      DontChargeProcFee@1120054015 : Boolean;
      startDate@1120054014 : Date;
      SDATE@1120054013 : Text;
      ChargeAmount@1120054012 : Decimal;
      SMSCharges@1120054011 : Record 51516554;
      MembersRegister@1120054010 : Record 51516223;
      SMSMessages@1120054009 : Record 51516329;
      SMSMessages2@1120054008 : Record 51516329;
      SalaryProcessingLines2@1120054000 : Record 51516317;
      NoSeriesManagement@1120054001 : Codeunit 396;
      SaccoNoSeries@1120054002 : Record 51516258;
      Notouse@1120054003 : Code[100];

    PROCEDURE PostBOSAEntries@1102760002();
    VAR
      ReceiptAllocation@1102760000 : Record 51516246;
    BEGIN
      //BOSA Cash Book Entrys
      IF StandingOrders."Destination Account No." = '502-00-000300-00' THEN
      BOSABank:='13865'
      ELSE IF StandingOrders."Destination Account No." = '502-00-000303-00' THEN
      BOSABank:='070006';

      IF AmountDed > 0 THEN BEGIN
      STORunBal:=AmountDed;


      ReceiptAllocations.RESET;
      ReceiptAllocations.SETRANGE(ReceiptAllocations."Document No",StandingOrders."No.");
      ReceiptAllocations.SETRANGE(ReceiptAllocations."Member No",StandingOrders."BOSA Account No.");
      IF ReceiptAllocations.FIND('-') THEN BEGIN
      REPEAT
      ReceiptAllocations."Amount Balance":=0;
      ReceiptAllocations."Interest Balance":=0;

      ReceiptAmount:=ReceiptAllocations.Amount;//-ReceiptAllocations."Amount Balance";

      //Check Loan Balances
      IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Repayment THEN BEGIN
      Loans.RESET;
      Loans.SETRANGE(Loans."Loan  No.",ReceiptAllocations."Loan No.");
      IF Loans.FIND('-') THEN BEGIN
      Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Oustanding Interest");

      {
      IF (Loans."Recovery Mode"=Loans."Recovery Mode"::CheckOff) OR (Loans."Recovery Mode"=Loans."Recovery Mode"::"Standing Order")
      OR (Loans."Recovery Mode"=Loans."Recovery Mode"::"Checkoff/Standing Order") THEN
      }

      IF ReceiptAmount > Loans."Outstanding Balance" THEN
      ReceiptAmount := Loans."Outstanding Balance";

      IF Loans."Oustanding Interest">0 THEN
      ReceiptAmount:=ReceiptAmount-Loans."Oustanding Interest";

      END ELSE
      ERROR('Loan No. %1 not Found. :- %2',ReceiptAllocations."Loan No.",ReceiptAllocations."Document No");
      END;

      IF ReceiptAmount < 0 THEN
      ReceiptAmount:=0;

      IF STORunBal < 0 THEN
      STORunBal:=0;

      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='SALARIES';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":=DocNo;
      GenJournalLine."External Document No.":=StandingOrders."No.";
      GenJournalLine."Posting Date":=TODAY;
      GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
      GenJournalLine."Account No.":=ReceiptAllocations."Member No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:=FORMAT(ReceiptAllocations."Transaction Type")+'-'+StandingOrders."No.";
      IF STORunBal > ReceiptAmount THEN
      GenJournalLine.Amount:=-ReceiptAmount
      ELSE
      GenJournalLine.Amount:=-STORunBal;
      //PKK
      {
      IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Insurance Contribution" THEN BEGIN
      IF ABS(GenJournalLine.Amount) = 100 THEN
      InsCont:=100;
      GenJournalLine.Amount:=-25;
      END;
      }
      //PKK
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Deposit Contribution" THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution"
      ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Repayment THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment
      ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Benevolent Fund" THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Benevolent Fund"
      ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Registration Fee" THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Registration Fee"
      ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Shares Capital" THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Shares Capital";

      {
      ELSE IF ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Withdrawal THEN
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Registration Fee";
      }
      GenJournalLine."Loan No":=ReceiptAllocations."Loan No.";
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity3;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch3;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      ReceiptAllocations."Amount Balance":=ReceiptAllocations."Amount Balance" + (GenJournalLine.Amount * -1);

      STORunBal:=STORunBal+GenJournalLine.Amount;
      ActualSTO:=ActualSTO+(GenJournalLine.Amount*-1);

      //PKK
      {
      IF (ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::"Insurance Contribution")
         AND (InsCont = 100) THEN BEGIN
      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='SALARIES';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":=DocNo;
      GenJournalLine."External Document No.":="Standing Orders"."No.";
      GenJournalLine."Posting Date":=TODAY;
      GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
      GenJournalLine."Account No.":=ReceiptAllocations."Member No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:=FORMAT(ReceiptAllocations."Transaction Type");
      GenJournalLine.Amount:=-75;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Welfare Contribution 2";
      GenJournalLine."Loan No":=ReceiptAllocations."Loan No.";
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity3;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch3;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      ReceiptAllocations."Amount Balance":=ReceiptAllocations."Amount Balance" + (GenJournalLine.Amount * -1);

      STORunBal:=STORunBal+GenJournalLine.Amount;
      ActualSTO:=ActualSTO+(GenJournalLine.Amount*-1);

      END;
      }
      //PKK

      IF STORunBal < 0 THEN
      STORunBal:=0;


      IF (ReceiptAllocations."Transaction Type" = ReceiptAllocations."Transaction Type"::Repayment) THEN BEGIN // AND
        // (ReceiptAllocations."Interest Amount" > 0) THEN BEGIN
      LineNo:=LineNo+10000;

      //ReceiptAmount:=ReceiptAllocations."Interest Amount";

      //Check Outstanding Interest
      Loans.RESET;
      Loans.SETRANGE(Loans."Loan  No.",ReceiptAllocations."Loan No.");
      //Loans.SETRANGE(Loans."Recovery Mode",Loans."Recovery Mode"::"Standing Order");
      IF Loans.FIND('-') THEN BEGIN
      Loans.CALCFIELDS(Loans."Oustanding Interest");
        {
      IF (Loans."Recovery Mode"=Loans."Recovery Mode"::CheckOff) OR (Loans."Recovery Mode"=Loans."Recovery Mode"::"Standing Order")
      OR (Loans."Recovery Mode"=Loans."Recovery Mode"::"Checkoff/Standing Order") THEN
             }
      //IF (ReceiptAmount > Loans."Oustanding Interest") AND (Loans."Oustanding Interest">0) THEN
      ReceiptAmount := Loans."Oustanding Interest";
      END ELSE
      ERROR('Loan No. %1 not Found. :- %2',ReceiptAllocations."Loan No.",ReceiptAllocations."Document No");


      IF ReceiptAmount < 0 THEN
      ReceiptAmount:=0;

      IF ReceiptAmount > 0 THEN BEGIN

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='SALARIES';
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Document No.":=DocNo;
      GenJournalLine."External Document No.":=StandingOrders."No.";
      GenJournalLine."Posting Date":=TODAY;
      GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
      GenJournalLine."Account No.":=ReceiptAllocations."Member No";
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine.Description:='Interest Paid '+StandingOrders."No.";
      IF STORunBal > ReceiptAmount THEN
      GenJournalLine.Amount:=-ReceiptAmount
      ELSE
      GenJournalLine.Amount:=-STORunBal;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
      GenJournalLine."Loan No":=ReceiptAllocations."Loan No.";
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity3;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch3;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      ReceiptAllocations."Interest Balance":=ReceiptAllocations."Interest Balance" + (GenJournalLine.Amount * -1);

      STORunBal:=STORunBal+GenJournalLine.Amount;
      ActualSTO:=ActualSTO+(GenJournalLine.Amount*-1);


      END;
      END;

      ReceiptAllocations.MODIFY;

      UNTIL ReceiptAllocations.NEXT = 0;
      END;

      {//STIMA
      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='SALARIES';
      GenJournalLine."Document No.":=DocNo;
      GenJournalLine."External Document No.":="Standing Orders"."No.";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
      GenJournalLine."Account No.":=BOSABank;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":=TODAY;
      GenJournalLine.Description:="Standing Orders"."Account Name";
      GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
      GenJournalLine.Amount:=AmountDed-STORunBal;
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      }

      END;
    END;

    BEGIN
    END.
  }
}

