OBJECT page 50066 Imprest Requisition
{
  OBJECT-PROPERTIES
  {
    Date=08/30/16;
    Time=[ 3:17:45 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516006;
    PageType=Card;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN

                 UserSetup.GET(USERID);

                 IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter());
                   FILTERGROUP(0);
                 END;

                  {
                 IF NOT UserMgt.GetDocPermissions THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Requestor ID",USERID);
                   FILTERGROUP(0);
                 END;
                  }

                 UpdateControls;
               END;

    OnAfterGetRecord=BEGIN
                       UpdateControls();
                     END;

    ActionList=ACTIONS
    {
      { 1102755018;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102755019;1 ;ActionGroup;
                      CaptionML=ENU=&Functions }
      { 1102755020;2 ;Action    ;
                      Name=Post Payment and Print;
                      CaptionML=ENU=Post Payment and Print;
                      Promoted=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                      CheckImprestRequiredItems;
                                      PostImprest;

                                       RESET;
                                       SETFILTER("No.","No.");
                                    //  REPORT.RUN(39004276,TRUE,TRUE,Rec);
                                       RESET;
                               END;
                                }
      { 1102755021;2 ;Separator  }
      { 1102755022;2 ;Action    ;
                      Name=Post Payment;
                      CaptionML=ENU=Post Payment;
                      Promoted=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 CheckImprestRequiredItems;
                                      PostImprest;
                               END;
                                }
      { 1102755023;2 ;Separator  }
      { 1102755024;2 ;Action    ;
                      Name=Approvals;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 DocumentType:=DocumentType::Imprest;
                                 ApprovalEntries.Setfilters(DATABASE::"Imprest Header",DocumentType,"No.");
                                 ApprovalEntries.RUN;
                               END;
                                }
      { 1102755025;2 ;Action    ;
                      Name=Send A&pproval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102755000 : Codeunit 439;
                               BEGIN

                                 IF NOT LinesExists THEN
                                    ERROR('There are no Lines created for this Document');

                                 IF NOT AllFieldsEntered THEN
                                 ERROR('Some of the Key Fields on the Header and Lines Have not been Entered please RECHECK your entries');

                                 //Ensure No Items That should be committed that are not
                                 IF LinesCommitmentStatus THEN
                                  ERROR('There are some lines that have not been committed');

                                 //Release the Imprest for Approval
                                  IF ApprovalMgt.SendImprestApprovalRequest(Rec) THEN;
                               END;
                                }
      { 1102755026;2 ;Action    ;
                      Name=Cancel Approval Re&quest;
                      CaptionML=ENU=Cancel Approval Re&quest;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102755000 : Codeunit 439;
                               BEGIN
                                    IF ApprovalMgt.CancelImprestApprovalRequest(Rec,TRUE,TRUE) THEN;
                               END;
                                }
      { 1102755029;2 ;Action    ;
                      Name=Cancel Document;
                      CaptionML=ENU=Cancel Document;
                      Promoted=Yes;
                      Image=cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text000@1102755001 : TextConst 'ENU=Are you sure you want to cancel this document?';
                                 Text001@1102755000 : TextConst 'ENU=You have selected not to cancel this document';
                               BEGIN


                                 TESTFIELD(Status,Status::Approved);
                                 IF CONFIRM(Text000,TRUE) THEN  BEGIN


                                 Doc_Type:=Doc_Type::Imprest;
                                 BudgetControl.ReverseEntries(Doc_Type,"No.");
                                 MESSAGE('Commitments for this document have been reversed succesfully');
                                 Status:=Status::Cancelled;
                                 MODIFY;
                                 END ELSE
                                 ERROR(Text001);
                               END;
                                }
      { 1102755027;2 ;Separator  }
      { 1102755028;2 ;Action    ;
                      Name=Check Budget Availability;
                      CaptionML=ENU=Check Budget Availability;
                      Promoted=Yes;
                      OnAction=VAR
                                 BCSetup@1102755000 : Record 39004327;
                               BEGIN

                                 BCSetup.GET;
                                 IF NOT BCSetup.Mandatory THEN
                                    EXIT;

                                 IF NOT LinesExists THEN
                                    ERROR('There are no Lines created for this Document');

                                   IF NOT AllFieldsEntered THEN
                                      ERROR('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                                    //First Check whether other lines are already committed.
                                   Commitments.RESET;
                                   Commitments.SETRANGE(Commitments."Document Type",Commitments."Document Type"::Imprest);
                                   Commitments.SETRANGE(Commitments."Document No.","No.");
                                   IF Commitments.FIND('-') THEN BEGIN
                                     IF CONFIRM('Lines in this Document appear to be committed do you want to re-commit?',FALSE)=FALSE THEN BEGIN EXIT END;
                                   Commitments.RESET;
                                   Commitments.SETRANGE(Commitments."Document Type",Commitments."Document Type"::Imprest);
                                   Commitments.SETRANGE(Commitments."Document No.","No.");
                                   Commitments.DELETEALL;
                                  END;

                                     CheckBudgetAvail.CheckImprest(Rec);
                               END;
                                }
      { 1102755030;2 ;Action    ;
                      Name=Cancel Budget Commitments;
                      CaptionML=ENU=Cancel Budget Commitments;
                      OnAction=BEGIN

                                   TESTFIELD(Status,Status::Pending);

                                 IF CONFIRM('Are you sure you want to cancel the commitments for this document',FALSE)=FALSE THEN BEGIN EXIT END;

                                  Commitments.RESET;
                                  Commitments.SETRANGE(Commitments."Document Type",Commitments."Document Type"::Imprest);
                                  Commitments.SETRANGE(Commitments."Document No.","No.");
                                  Commitments.DELETEALL;


                                  PayLine.RESET;
                                  PayLine.SETRANGE(PayLine.No,"No.");
                                  IF PayLine.FIND('-') THEN BEGIN
                                    REPEAT
                                      PayLine.Committed:=FALSE;
                                      PayLine.MODIFY;
                                    UNTIL PayLine.NEXT=0;
                                  END;


                                 MESSAGE('Commitments for this document have been cancelled successfully');
                               END;
                                }
      { 1102755031;2 ;Action    ;
                      Name=Print/Preview;
                      CaptionML=ENU=Print/Preview;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Report }
      { 1000000001;2 ;Action    ;
                      Name=Attachements;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=BulletList;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 DMSint.RESET;
                                 DMSint.SETRANGE(DMSint."DMS Link Type",DMSint."DMS Link Type"::Imprest);
                                 IF DMSint.FIND('-') THEN BEGIN
                                  HYPERLINK(DMSint."DMS Link Path"+"No.");
                                  END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1102755002;2;Field  ;
                SourceExpr="No.";
                Editable=FALSE;
                OnValidate=BEGIN
                                "Account Type":="Account Type"::Customer;
                           END;
                            }

    { 1102755003;2;Field  ;
                SourceExpr=Date }

    { 1102755011;2;Field  ;
                SourceExpr="Global Dimension 1 Code" }

    { 1102755032;2;Field  ;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 1102755005;2;Field  ;
                SourceExpr="Account Type";
                Editable=False }

    { 1102755006;2;Field  ;
                SourceExpr="Account No." }

    { 1102755004;2;Field  ;
                SourceExpr=Payee;
                Editable=FALSE }

    { 1000000000;2;Field  ;
                SourceExpr="PF No.";
                Editable=FALSE }

    { 1102755008;2;Field  ;
                SourceExpr="Responsibility Center" }

    { 1102755009;2;Field  ;
                SourceExpr="Paying Bank Account" }

    { 1102755010;2;Field  ;
                SourceExpr=Purpose }

    { 1102755012;2;Field  ;
                SourceExpr=Cashier;
                Editable=fALSE }

    { 1102755013;2;Field  ;
                SourceExpr="Total Net Amount" }

    { 1102755014;2;Field  ;
                SourceExpr="Payment Release Date" }

    { 1102755015;2;Field  ;
                SourceExpr="Pay Mode" }

    { 1102755016;2;Field  ;
                SourceExpr="Cheque No." }

    { 1102755033;2;Field  ;
                SourceExpr=Status;
                Editable=FALSE }

    { 1102755017;1;Part   ;
                Name=Imprest Details;
                SubPageLink=No=FIELD(No.);
                PagePartID=Page51516431;
                PartType=Page }

  }
  CODE
  {
    VAR
      PayLine@1102755005 : Record 51516007;
      PVUsers@1102755004 : Record 51516031;
      strFilter@1102755003 : Text[250];
      IntC@1102755002 : Integer;
      IntCount@1102755001 : Integer;
      Payments@1102755000 : Record 51516000;
      RecPayTypes@1102755017 : Record 51516247;
      TarriffCodes@1102755016 : Record 51516431;
      GenJnlLine@1102755015 : Record 81;
      DefaultBatch@1102755014 : Record 232;
      CashierLinks@1102755013 : Record 51516031;
      LineNo@1102755012 : Integer;
      Temp@1102755011 : Record 51516031;
      JTemplate@1102755010 : Code[10];
      JBatch@1102755009 : Code[10];
      PCheck@1102755008 : Codeunit 51516013;
      Post@1102755007 : Boolean;
      strText@1102755006 : Text[100];
      PVHead@1102755033 : Record 51516000;
      BankAcc@1102755032 : Record 270;
      CheckBudgetAvail@1102755031 : Codeunit 39004247;
      Commitments@1102755030 : Record 51516050;
      UserMgt@1102755029 : Codeunit 51516155;
      JournlPosted@1102755028 : Codeunit 39004241;
      ApprovalEntries@1102755027 : Page 658;
      DocumentType@1102755026 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batch,Payment Voucher,Petty Cash,Requisition,Loan,Interbank,Imprest,Checkoff,FOSA Account Opening,StandingOrder,HRJob,HRLeave,HRTraining,HREmp Requsition,MicroTrans,Account Reactivation,Overdraft,BLA,Benevolent Fund,Staff Claim,TransportRequisition,FuelRequisition,DailyWorkTicket,StaffLoan,HRBatch,Overtime,FTransfer,Edit Member,Loan Officer,HREmp,FuelCard,Appraisal,HRNeed,HRExit,TreasuryTransactions,BSC,LoanType,Delegate,Maint,TellerTransactions,ATMM,GeneralRepair,Saccotransffers,BLoans,FLoans,BL Opening,Risk Closure,Defaulter Recovery';
      HasLines@1102755025 : Boolean;
      AllKeyFieldsEntered@1102755024 : Boolean;
      Doc_Type@1102755023 : 'LPO,Requisition,Imprest,Payment Voucher,PettyCash';
      BudgetControl@1102755022 : Codeunit 5615;
      TravReqHeader@1102755021 : Record 39004344;
      ShortcutDimCode@1102755020 : ARRAY [8] OF Code[20];
      UserSetup@1102755019 : Record 91;
      BCSetup@1102755018 : Record 39004327;
      "Payment Release DateEDITABLE"@1000000000 : Boolean;
      "Paying Bank AccountEDITABLE"@1000000001 : Boolean;
      "Pay ModeEDITABLE"@1000000002 : Boolean;
      "Cheque NoEDITABLE"@1000000003 : Boolean;
      "Global Dimension 1 CodeEDITABLE"@1000000004 : Boolean;
      "Shortcut Dimension 2 CodeEDITABLE"@1000000005 : Boolean;
      "Shortcut Dimension 3 CodeEDITABLE"@1000000006 : Boolean;
      "Shortcut Dimension 4 CodeEDITABLE"@1000000007 : Boolean;
      DateEDITABLE@1000000008 : Boolean;
      DMSint@1000000009 : Record 39006200;

    PROCEDURE LinesCommitmentStatus@1102755005() Exists : Boolean;
    VAR
      BCsetup@1102755000 : Record 39004327;
    BEGIN

      IF BCsetup.GET() THEN  BEGIN
          IF NOT BCsetup.Mandatory THEN BEGIN
             Exists:=FALSE;
             EXIT;
          END;
       END ELSE BEGIN
             Exists:=FALSE;
             EXIT;
       END;
         Exists:=FALSE;
        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No,"No.");
        PayLine.SETRANGE(PayLine.Committed,FALSE);
        PayLine.SETRANGE(PayLine."Budgetary Control A/C",TRUE);
         IF PayLine.FIND('-') THEN
            Exists:=TRUE;
    END;

    PROCEDURE PostImprest@1102755009();
    BEGIN

      IF Temp.GET(USERID) THEN BEGIN
          GenJnlLine.RESET;
          GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
          GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);
          GenJnlLine.DELETEALL;
      END;

      LineNo:=LineNo+1000;
      GenJnlLine.INIT;
      GenJnlLine."Journal Template Name":=JTemplate;
      GenJnlLine."Journal Batch Name":=JBatch;
      GenJnlLine."Line No.":=LineNo;
      GenJnlLine."Source Code":='PAYMENTJNL';
      GenJnlLine."Posting Date":="Payment Release Date";
      GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
      GenJnlLine."Document No.":="No.";
      GenJnlLine."External Document No.":="Cheque No.";
      GenJnlLine."Account Type":=GenJnlLine."Account Type"::Customer;
      GenJnlLine."Account No.":="Account No.";
      GenJnlLine.VALIDATE(GenJnlLine."Account No.");
      GenJnlLine.Description:='Imprest: '+"Account No."+':'+Payee;
      CALCFIELDS("Total Net Amount");
      GenJnlLine.Amount:="Total Net Amount";
      GenJnlLine.VALIDATE(GenJnlLine.Amount);
      GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"Bank Account";
      GenJnlLine."Bal. Account No.":="Paying Bank Account";
      GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
      //Added for Currency Codes
      GenJnlLine."Currency Code":="Currency Code";
      GenJnlLine.VALIDATE("Currency Code");
      GenJnlLine."Currency Factor":="Currency Factor";
      GenJnlLine.VALIDATE("Currency Factor");
      {
      GenJnlLine."Currency Factor":=Payments."Currency Factor";
      GenJnlLine.VALIDATE("Currency Factor");
      }
      GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
      GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
      GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
      GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
      //added
      //GenJnlLine.ValidateShortcutDimCode(5,"Shortcut Dimension 5 Code");
      //GenJnlLine.ValidateShortcutDimCode(6,"Shortcut Dimension 6 Code");


      IF GenJnlLine.Amount<>0 THEN
      GenJnlLine.INSERT;


      GenJnlLine.RESET;
      GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
      GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);
      CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnlLine);

      Post:= FALSE;
      Post:=JournlPosted.PostedSuccessfully();
      IF Post THEN BEGIN
        Posted:=TRUE;
        "Date Posted":=TODAY;
        "Time Posted":=TIME;
        "Posted By":=USERID;
        Status:=Status::Posted;
        MODIFY;
      END;
    END;

    PROCEDURE CheckImprestRequiredItems@1102755010();
    BEGIN

      TESTFIELD("Payment Release Date");
      TESTFIELD("Paying Bank Account");
      TESTFIELD("Account No.");
      TESTFIELD("Account Type","Account Type"::Customer);

      IF Posted THEN BEGIN
          ERROR('The Document has already been posted');
      END;

      TESTFIELD(Status,Status::Approved);

      {Check if the user has selected all the relevant fields}

      Temp.GET(USERID);
      JTemplate:=Temp."Imprest Template";JBatch:=Temp."Imprest  Batch";

      IF JTemplate='' THEN  BEGIN
          ERROR('Ensure the Imprest Template is set up in Cash Office Setup');
      END;

      IF JBatch='' THEN BEGIN
          ERROR('Ensure the Imprest Batch is set up in the Cash Office Setup')
      END;

      IF NOT LinesExists THEN
         ERROR('There are no Lines created for this Document');
    END;

    PROCEDURE UpdateControls@1102755011();
    BEGIN
      {IF Status<>Status::Approved THEN BEGIN
           "Payment Release DateEDITABLE":=FALSE;
           "Paying Bank AccountEDITABLE":=FALSE;
           "Pay ModeEDITABLE":=FALSE;
           //CurrForm."Currency Code".EDITABLE:=FALSE;
           "Cheque NoEDITABLE":=FALSE;
           UpdateControls();
           END ELSE BEGIN
           "Payment Release DateEDITABLE":=TRUE;
           "Paying Bank AccountEDITABLE":=TRUE;
           "Pay ModeEDITABLE":=TRUE;
           "Cheque NoEDITABLE":=TRUE;
           //CurrForm."Currency Code".EDITABLE:=TRUE;
           UpdateControls();
           END;


           IF Status=Status::Pending THEN BEGIN
           "Global Dimension 1 CodeEDITABLE":=TRUE;
           "Shortcut Dimension 2 CodeEDITABLE":=TRUE;
           //CurrForm.Payee.EDITABLE:=TRUE;
           "Shortcut Dimension 3 CodeEDITABLE":=TRUE;
           "Shortcut Dimension 4 CodeEDITABLE":=TRUE;
           //Added
           {CurrForm."Shortcut Dimension 5 Code".EDITABLE:=TRUE;
           CurrForm."Shortcut Dimension 6 Code".EDITABLE:=TRUE;}

           DateEDITABLE:=TRUE;
           //CurrForm."Account No.".EDITABLE:=TRUE;
           //CurrForm."Currency Code".EDITABLE:=TRUE;
           //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
           UpdateControls();
           END ELSE BEGIN
           "Global Dimension 1 CodeEDITABLE":=FALSE;
           "Shortcut Dimension 2 CodeEDITABLE":=FALSE;
           //CurrForm.Payee.EDITABLE:=FALSE;
           "Shortcut Dimension 3 CodeEDITABLE":=FALSE;
           "Shortcut Dimension 4 CodeEDITABLE":=FALSE;
           //added
           {CurrForm."Shortcut Dimension 5 Code".EDITABLE:=FALSE;
           CurrForm."Shortcut Dimension 6 Code".EDITABLE:=FALSE;}

          DateEDITABLE:=FALSE;
           //CurrForm."Account No.".EDITABLE:=FALSE;
           //CurrForm."Currency Code".EDITABLE:=FALSE;
           //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
           UpdateControls();
           END;

      }
    END;

    PROCEDURE LinesExists@1102755013() : Boolean;
    VAR
      PayLines@1102755001 : Record 39004345;
    BEGIN

      HasLines:=FALSE;
       PayLines.RESET;
       PayLines.SETRANGE(PayLines.No,"No.");
        IF PayLines.FIND('-') THEN BEGIN
           HasLines:=TRUE;
           EXIT(HasLines);
        END;
    END;

    PROCEDURE AllFieldsEntered@1102755015() : Boolean;
    VAR
      PayLines@1102755000 : Record 39004345;
      DimMgt@1102755001 : Codeunit 408;
    BEGIN

      AllKeyFieldsEntered:=TRUE;
       PayLines.RESET;
       PayLines.SETRANGE(PayLines.No,"No.");
        IF PayLines.FIND('-') THEN BEGIN
        REPEAT
           IF (PayLines."Account No:"='') OR (PayLines.Amount<=0) THEN
           AllKeyFieldsEntered:=FALSE;
        UNTIL PayLines.NEXT=0;
           EXIT(AllKeyFieldsEntered);
        END;
    END;

    BEGIN
    END.
  }
}

