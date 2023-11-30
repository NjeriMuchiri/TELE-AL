OBJECT page 17424 Posted Member Withdrawal List
{
  OBJECT-PROPERTIES
  {
    Date=03/25/22;
    Time=[ 1:07:18 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516259;
    SourceTableView=WHERE(Posted=FILTER(Yes),
                          Registered=CONST(Yes),
                          Withdrawal Status=FILTER(Posted));
    PageType=List;
    CardPageID=Posted Member Withdrawal Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption;
    ActionList=ACTIONS
    {
      { 1102755012;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755010;1 ;ActionGroup;
                      CaptionML=ENU=Function }
      { 1102755008;2 ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Visible=false;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 DocumentType:=DocumentType::"Member Closure";
                                 ApprovalEntries.Setfilters(DATABASE::"Payroll Employer Deductions",DocumentType,"No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755006;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Visible=false;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 text001@1102755000 : TextConst 'ENU=This batch is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 439;
                               BEGIN
                                    IF Status<>Status::Open THEN
                                       ERROR(text001);

                                   //End allocate batch number
                                    //IF ApprovalMgt.SendClosurelRequest(Rec) THEN;
                               END;
                                }
      { 1102755004;2 ;Action    ;
                      Name=Cancel Approval Request;
                      CaptionML=ENU=Cancel A&pproval Request;
                      Promoted=Yes;
                      Visible=false;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 text001@1102755000 : TextConst 'ENU=This batch is already pending approval';
                                 ApprovalMgt@1102755001 : Codeunit 439;
                               BEGIN
                                   //End allocate batch number
                                    //ApprovalMgt.CancelClosureApprovalRequest(Rec)
                               END;
                                }
      { 1102755011;2 ;Action    ;
                      Name=Post;
                      CaptionML=ENU=Post;
                      Promoted=Yes;
                      Visible=false;
                      PromotedIsBig=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF Cust.GET("Member No.") THEN BEGIN
                                 {
                                 IF Cust."Status - Withdrawal App." <> Cust."Status - Withdrawal App."::Approved THEN
                                 ERROR('Withdrawal application must be approved before posting.');
                                 }
                                 IF CONFIRM('Are you sure you want to recover the loans from the members shares?') = FALSE THEN
                                 EXIT;

                                 Generalsetup.GET(0);

                                 //delete journal line
                                 Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",'ACC CLOSED');
                                 Gnljnline.DELETEALL;
                                 //end of deletion

                                 Totalrecovered:=0;

                                 Cust.CALCFIELDS(Cust."Outstanding Balance",Cust."Accrued Interest",Cust."Current Shares");

                                 Totalavailable:=(Cust."Current Shares"+Generalsetup."Withdrawal Fee");

                                 AvailableShares:=Cust."Current Shares"*-1;

                                 IF Cust."Defaulted Loans Recovered" <> TRUE THEN BEGIN
                                 IF Cust."Closing Deposit Balance" = 0 THEN
                                 Cust."Closing Deposit Balance":=Cust."Current Shares"*-1;
                                 IF Cust."Closing Loan Balance" = 0 THEN
                                 Cust."Closing Loan Balance":=Cust."Outstanding Balance"+Cust."FOSA Outstanding Balance";
                                 IF Cust."Closing Insurance Balance" = 0 THEN
                                 Cust."Closing Insurance Balance":=Cust."Insurance Fund"*-1;
                                 END;

                                 Cust."Withdrawal Posted":=TRUE;
                                 Advice:=TRUE;
                                 Cust."Last Advice Date":=TODAY;
                                 MODIFY;

                                 TotalOustanding:=(Cust."Outstanding Balance"+Cust."Accrued Interest");

                                 Loans.RESET;
                                 Loans.SETRANGE(Loans."Client Code","Member No.");
                                 Loans.SETRANGE(Loans.Source,Loans.Source::BOSA);
                                 IF Loans.FIND('-') THEN BEGIN
                                  REPEAT
                                   Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Oustanding Interest");
                                    //Recover Interest
                                     IF Loans."Oustanding Interest" > 0 THEN BEGIN
                                      //**Interest:=0;
                                      Interest:=Loans."Oustanding Interest";
                                      LRepayment:=Loans."Outstanding Balance";
                                       IF (AvailableShares> 0) AND (Interest > 0) THEN BEGIN
                                        LineN:=LineN+10000;
                                        Gnljnline.INIT;
                                        Gnljnline."Journal Template Name":='GENERAL';
                                        Gnljnline."Journal Batch Name":='ACC CLOSED';
                                        Gnljnline."Line No.":=LineN;
                                        Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
                                        Gnljnline."Account No.":=Cust."No.";
                                        Gnljnline.VALIDATE(Gnljnline."Account No.");
                                        Gnljnline."Document No.":='LR-'+"No.";
                                        Gnljnline."Posting Date":=TODAY;
                                        Gnljnline.Description:='Interest Recovery from deposits';
                                         IF AvailableShares < Interest THEN
                                          Gnljnline.Amount:=-1*AvailableShares
                                         ELSE
                                          Gnljnline.Amount:=-1*Interest;
                                        Gnljnline.VALIDATE(Gnljnline.Amount);
                                        Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Interest Paid";
                                        Gnljnline."Loan No":=Loans."Loan  No.";
                                        IF Gnljnline.Amount<>0 THEN
                                        Gnljnline.INSERT;

                                     AvailableShares:=AvailableShares-(Gnljnline.Amount*-1);
                                     Totalrecovered:=Totalrecovered+(Gnljnline.Amount*-1);

                                    //Recover Repayment
                                      //**LRepayment:=0;
                                       LRepayment:=Loans."Outstanding Balance";
                                       IF (AvailableShares > 0) AND (LRepayment > 0) THEN BEGIN
                                        LineN:=LineN+10000;
                                        Gnljnline.INIT;
                                        Gnljnline."Journal Template Name":='GENERAL';
                                        Gnljnline."Journal Batch Name":='ACC CLOSED';
                                        Gnljnline."Line No.":=LineN;
                                        Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
                                        Gnljnline."Account No.":=Cust."No.";
                                        Gnljnline.VALIDATE(Gnljnline."Account No.");
                                        Gnljnline."Document No.":='LR-'+"No.";
                                        Gnljnline."Posting Date":=TODAY;
                                        Gnljnline.Description:='Interest Recovery from deposits';
                                         IF AvailableShares < LRepayment THEN
                                          Gnljnline.Amount:=-1*AvailableShares
                                         ELSE
                                          Gnljnline.Amount:=-1*LRepayment;
                                        Gnljnline.VALIDATE(Gnljnline.Amount);
                                        Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::Repayment;
                                        Gnljnline."Loan No":=Loans."Loan  No.";
                                        IF Gnljnline.Amount<>0 THEN
                                        Gnljnline.INSERT;

                                     AvailableShares:=AvailableShares-(Gnljnline.Amount*-1);
                                     Totalrecovered:=Totalrecovered+(Gnljnline.Amount*-1);

                                     END;
                                   END;
                                     Loans."Recovered Balance":=Loans."Outstanding Balance";
                                     Loans.MODIFY;
                                 END;
                                 UNTIL Loans.NEXT = 0;
                                 END;

                                 //Withdrawal Fee
                                 IF Generalsetup."Withdrawal Fee" > 0 THEN BEGIN
                                     LineN:=LineN+10000;
                                     Gnljnline.INIT;
                                     Gnljnline."Journal Template Name":='GENERAL';
                                     Gnljnline."Journal Batch Name":='ACC CLOSED';
                                     Gnljnline."Line No.":=LineN;
                                     Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
                                     Gnljnline."Account No.":=Cust."No.";
                                     Gnljnline.VALIDATE(Gnljnline."Account No.");
                                     Gnljnline."Document No.":='LR-'+"No.";
                                     Gnljnline."Posting Date":=TODAY;
                                     Gnljnline.Description:='Withdrawal Fee';
                                     Gnljnline.Amount:=-Generalsetup."Withdrawal Fee";
                                     Gnljnline.VALIDATE(Gnljnline.Amount);
                                     Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::Withdrawal;
                                     Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
                                     IF Gnljnline.Amount<>0 THEN
                                     Gnljnline.INSERT;
                                 END;

                                 //Reduce Shares
                                     LineN:=LineN+10000;
                                     Gnljnline.INIT;
                                     Gnljnline."Journal Template Name":='GENERAL';
                                     Gnljnline."Journal Batch Name":='ACC CLOSED';
                                     Gnljnline."Line No.":=LineN;
                                     Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
                                     Gnljnline."Account No.":=Cust."No.";
                                     Gnljnline.VALIDATE(Gnljnline."Account No.");
                                     Gnljnline."Document No.":='LR-'+"No.";
                                     Gnljnline."Posting Date":=TODAY;
                                     Gnljnline.Description:='Deposit Refundable';
                                     IF Cust.Status = Cust.Status::Deceased THEN
                                     Gnljnline.Amount:=Totalrecovered+Generalsetup."Withdrawal Fee"
                                     ELSE
                                     Gnljnline.Amount:=Totalrecovered+Generalsetup."Withdrawal Fee"; //+"Insurance Fund"
                                     Gnljnline.VALIDATE(Gnljnline.Amount);
                                     Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Deposit Contribution";
                                     IF Gnljnline.Amount<>0 THEN
                                     Gnljnline.INSERT;



                                 //Post New
                                 Gnljnline.RESET;
                                 Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                                 Gnljnline.SETRANGE("Journal Batch Name",'ACC CLOSED');
                                 IF Gnljnline.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",Gnljnline);
                                 END;

                                 //Block account if status deceased
                                 IF Cust.Status=Cust.Status::Deceased THEN BEGIN
                                 Cust.Blocked:=Cust.Blocked::All;
                                 END;

                                 Cust.Status:=Cust.Status:: Withdrawal;
                                 Cust.MODIFY;

                                 MESSAGE('Closure posted successfully.');
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                GroupType=Repeater }

    { 1102755001;2;Field  ;
                SourceExpr="No." }

    { 1102755003;2;Field  ;
                SourceExpr="Member No.";
                Editable=FALSE }

    { 1102755005;2;Field  ;
                SourceExpr="Member Name" }

    { 1120054000;2;Field  ;
                SourceExpr="Payroll/Staff No" }

    { 1120054001;2;Field  ;
                SourceExpr="ID No." }

    { 1102755007;2;Field  ;
                SourceExpr="Closing Date" }

    { 1102755009;2;Field  ;
                SourceExpr=Status }

    { 1102755013;2;Field  ;
                SourceExpr="Total Loan" }

    { 1102755015;2;Field  ;
                SourceExpr="Total Interest" }

    { 1102755017;2;Field  ;
                SourceExpr="Member Deposits" }

    { 1120054003;2;Field  ;
                SourceExpr="Current Deposits" }

    { 1120054002;2;Field  ;
                SourceExpr="Posted By" }

  }
  CODE
  {
    VAR
      Closure@1102755020 : Integer;
      Cust@1102755019 : Record 51516223;
      UBFRefund@1102755018 : Decimal;
      Generalsetup@1102755017 : Record 51516257;
      Totalavailable@1102755016 : Decimal;
      UnpaidDividends@1102755015 : Decimal;
      TotalOustanding@1102755014 : Decimal;
      Vend@1102755013 : Record 23;
      value2@1102755012 : Decimal;
      Gnljnline@1102755011 : Record 81;
      Totalrecovered@1102755010 : Decimal;
      Advice@1102755009 : Boolean;
      TotalDefaulterR@1102755008 : Decimal;
      AvailableShares@1102755007 : Decimal;
      Loans@1102755006 : Record 51516230;
      Value1@1102755005 : Decimal;
      Interest@1102755004 : Decimal;
      LineN@1102755003 : Integer;
      LRepayment@1102755002 : Decimal;
      Vendno@1102755001 : Code[20];
      DocumentType@1102755000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Interbank,Imprest,Checkoff';

    BEGIN
    END.
  }
}

