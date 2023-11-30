OBJECT page 20424 Payment Voucher-Director
{
  OBJECT-PROPERTIES
  {
    Date=08/30/16;
    Time=[ 2:21:26 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516000;
    PageType=Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnInit=BEGIN

             PVLinesEditable := TRUE;
             DateEditable := TRUE;
             PayeeEditable := TRUE;
             "Payment NarrationEditable" := TRUE;
             GlobalDimension1CodeEditable := TRUE;
             CurrencyCodeEditable := TRUE;
             "Invoice Currency CodeEditable" := TRUE;
             "Cheque TypeEditable" := TRUE;
             "Payment Release DateEditable" := TRUE;
             "Cheque No.Editable" := TRUE;
           END;

    OnOpenPage=BEGIN

                 IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center" ,UserMgt.GetPurchasesFilter());
                   FILTERGROUP(0);
                 END;
               END;

    OnNewRecord=BEGIN
                  {
                  "Responsibility Center" := UserMgt.GetSalesFilter();
                   //Add dimensions if set by default here
                   //"Global Dimension 1 Code":=UserMgt.GetSetDimensions(USERID,1);
                   //"Shortcut Dimension 2 Code":=UserMgt.GetSetDimensions(USERID,2);
                   //"Shortcut Dimension 3 Code":=UserMgt.GetSetDimensions(USERID,3);
                   VALIDATE("Shortcut Dimension 3 Code");
                   "Shortcut Dimension 4 Code":=UserMgt.GetSetDimensions(USERID,4);
                   VALIDATE("Shortcut Dimension 4 Code");
                   }
                END;

    OnInsertRecord=BEGIN

                     "Payment Type":="Payment Type"::Normal;
                     "Payments Type":="Payments Type"::Delegates;
                     "Responsibility Center":=UserMgt.GetPurchasesFilter;
                      "Payment Mode":="Payment Mode"::Cheque;






                      //"Paying Type":="Paying Type"::Bank;
                      "Cheque Type":="Cheque Type"::"Manual Cheque";
                       //"Expense Type":="Expense Type"::Director;
                   END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateControls();
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102755006;1 ;ActionGroup;
                      CaptionML=ENU=&Functions }
      { 1102755024;2 ;Action    ;
                      Name=Post;
                      CaptionML=ENU=Post Payment and Print;
                      Promoted=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CheckPVRequiredItems;
                                 PostPaymentVoucher();
                               END;
                                }
      { 1102755026;2 ;Separator  }
      { 1102755034;2 ;Action    ;
                      Name=Approval;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=Approval;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalEntries@1102755000 : Page 658;
                               BEGIN
                                 {DocumentType:=DocumentType::"Payment Voucher";
                                 ApprovalEntries.Setfilters(DATABASE::"Payments Header",DocumentType,"No.");
                                 ApprovalEntries.RUN;
                                 }
                               END;
                                }
      { 1102755007;2 ;Action    ;
                      Name=Send Approval Request;
                      CaptionML=ENU=Send A&pproval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102756001 : Codeunit 439;
                                 Text001@1102755001 : TextConst 'ENU=This transaction is already pending approval';
                               BEGIN

                                 {IF "Paying Type"="Paying Type"::" " THEN
                                 ERROR('Kindly spceify the paying type')

                                 ELSE IF ("Paying Vendor Account"<>'') AND ("Paying Bank Account"<>'') THEN
                                 ERROR('You cannot have both paying bank and paying vendor, choose one')

                                 ELSE IF ("Paying Type"="Paying Type"::Vendor) AND ("Paying Vendor Account"='') THEN
                                 ERROR('Kindly spceify the paying vendor account')

                                 ELSE IF ("Paying Type"="Paying Type"::Bank) AND ("Paying Bank Account"='') THEN
                                 ERROR('Kindly spceify the paying bank account');
                                 }

                                 IF NOT LinesExists THEN
                                    ERROR('There are no Lines created for this Document');
                                 //Ensure No Items That should be committed that are not
                                 IF LinesCommitmentStatus THEN
                                    ERROR('There are some lines that have not been committed');

                                 PayLine.RESET;
                                 PayLine.SETRANGE(PayLine.No,"No.");
                                 PayLine.SETRANGE(PayLine."Payment Type",'MEMBER');
                                 IF PayLine.FIND('-') THEN BEGIN
                                 IF PayLine."Transaction Type"=PayLine."Transaction Type"::" " THEN
                                 ERROR('Transaction Type cannot be blank in payment lines');
                                 END;

                                 TESTFIELD(Payee);
                                 //TESTFIELD("Fosa Bank Account") ;
                                 //TESTFIELD("Expense Account") ;

                                 //Release the PV for Approval
                                 //ApprovalMgt.SendPVApprovalRequest(Rec) ;
                               END;
                                }
      { 1102755028;2 ;Action    ;
                      Name=Cancel Approval REquest;
                      CaptionML=ENU=Cancel Approval Re&quest;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalMgt@1102756001 : Codeunit 439;
                               BEGIN
                                 //IF ApprovalMgt.CancelMICROApprovalRequest(Rec,TRUE,TRUE) THEN;
                                 //IF ApprovalMgt.CancelPVApprovalrequest(Rec,TRUE,TRUE) THEN;
                               END;
                                }
      { 1102755009;2 ;Separator  }
      { 1102755010;2 ;Action    ;
                      Name=Print;
                      CaptionML=ENU=Print/Preview;
                      Promoted=Yes;
                      Visible=true;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=BEGIN

                                  //IF Status<>Status::Approved THEN
                                     //ERROR('You can only print a Payment Voucher after it is fully Approved');

                                 //IF Status=Status::Pending THEN
                                    //ERROR('You cannot Print until the document is released for approval');

                                 RESET;
                                 SETFILTER("No.","No.");
                                 REPORT.RUN(39004246,TRUE,TRUE,Rec);
                                 RESET;

                                 //Print Cheque
                                 RESET;
                                 SETFILTER("No.","No.");
                                 IF CONFIRM(Text003,TRUE) THEN  BEGIN

                                 REPORT.RUN(39003907,TRUE,TRUE,Rec);
                                 RESET;
                                 END;
                                 CurrPage.UPDATE;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 1102756005;2 ;Separator  }
      { 1102756006;2 ;Action    ;
                      Name=Cancel Document;
                      CaptionML=ENU=Cancel Document;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Text000@1102756000 : TextConst 'ENU=Are you sure you want to cancel this Document?';
                                 Text001@1102756001 : TextConst 'ENU=You have selected not to Cancel the Document';
                               BEGIN

                                 TESTFIELD(Status,Status::Approved);
                                 IF CONFIRM(Text000,TRUE) THEN  BEGIN
                                 //Post Reversal Entries for Commitments
                                 Doc_Type:=Doc_Type::"Payment Voucher";
                                 CheckBudgetAvail.ReverseEntries(Doc_Type,"No.");
                                 Status:=Status::Cancelled;
                                 MODIFY;
                                 END ELSE
                                   ERROR(Text001);
                               END;
                                }
      { 1102755030;2 ;Separator  }
      { 1102755031;2 ;Action    ;
                      Name=Check Budgetary Availability;
                      Image=Balance;
                      OnAction=BEGIN

                                 BCSetup.GET;
                                 IF NOT BCSetup.Mandatory THEN
                                    EXIT;

                                     IF NOT AllFieldsEntered THEN
                                      ERROR('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');
                                   //First Check whether other lines are already committed.
                                   Commitments.RESET;
                                   Commitments.SETRANGE(Commitments."Document Type",Commitments."Document Type"::"Payment Voucher");
                                   Commitments.SETRANGE(Commitments."Document No.","No.");
                                   IF Commitments.FIND('-') THEN BEGIN
                                     IF CONFIRM('Lines in this Document appear to be committed do you want to re-commit?',FALSE)=FALSE THEN BEGIN EXIT END;
                                   Commitments.RESET;
                                   Commitments.SETRANGE(Commitments."Document Type",Commitments."Document Type"::"Payment Voucher");
                                   Commitments.SETRANGE(Commitments."Document No.","No.");
                                   Commitments.DELETEALL;
                                  END;

                                     CheckBudgetAvail.CheckPayments(Rec);
                               END;
                                }
      { 1102755032;2 ;Action    ;
                      Name=Cancel Budget Commitment;
                      Image=CancelAllLines;
                      OnAction=BEGIN

                                  TESTFIELD(Status,Status::Pending);
                                     IF CONFIRM('Do you Wish to Cancel the Commitment entries for this document',FALSE)=FALSE THEN BEGIN EXIT END;

                                   Commitments.RESET;
                                   Commitments.SETRANGE(Commitments."Document Type",Commitments."Document Type"::"Payment Voucher");
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
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group      }

    { 2   ;2   ;Field     ;
                SourceExpr="No.";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                SourceExpr="Document Date";
                Editable=DateEditable }

    { 1102755001;2;Field  ;
                SourceExpr="Global Dimension 1 Code";
                Editable=GlobalDimension1CodeEditable }

    { 1102755003;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                Visible=TRUE;
                Editable=ShortcutDimension2CodeEditable }

    { 1102755017;2;Field  ;
                SourceExpr="Responsibility Center";
                Visible=TRUE }

    { 1102755013;2;Field  ;
                SourceExpr="Payment Mode";
                Editable=PaymentModeEditable }

    { 1000000002;2;Field  ;
                SourceExpr="Payment Type" }

    { 1102755014;2;Field  ;
                CaptionML=ENU=Cheque Type;
                SourceExpr="Cheque Type";
                Editable="Cheque TypeEditable" }

    { 1102755027;2;Field  ;
                SourceExpr="Paying Type" }

    { 1102755015;2;Field  ;
                SourceExpr="Currency Code";
                Editable=CurrencyCodeEditable }

    { 18  ;2   ;Field     ;
                CaptionML=ENU=Payment to;
                SourceExpr=Payee;
                Editable=PayeeEditable }

    { 1000000001;2;Field  ;
                SourceExpr="Expense Account" }

    { 20  ;2   ;Field     ;
                SourceExpr="On Behalf Of";
                Editable=OnBehalfEditable }

    { 1102756007;2;Field  ;
                SourceExpr="Payment Description";
                Editable="Payment NarrationEditable" }

    { 22  ;2   ;Field     ;
                SourceExpr=Cashier;
                Editable=FALSE }

    { 1102755022;2;Field  ;
                SourceExpr=Status;
                Editable=False }

    { 1102755035;2;Field  ;
                CaptionML=ENU=Total Net Amount LCY;
                SourceExpr="Total Payment Amount";
                Editable=FALSE }

    { 1102755008;2;Field  ;
                CaptionML=ENU=Cheque/EFT No.;
                SourceExpr="Cheque No";
                Editable="Cheque No.Editable";
                OnValidate=BEGIN

                             //check if the cheque has been inserted
                             TESTFIELD("Bank Account");
                             PVHead.RESET;
                             PVHead.SETRANGE(PVHead."Bank Account","Bank Account");
                             PVHead.SETRANGE(PVHead."PayMENT Mode",PVHead."PayMENT Mode"::Cheque);
                             IF PVHead.FINDFIRST THEN
                               BEGIN
                                 REPEAT
                                   IF PVHead."Cheque No"="Cheque No" THEN
                                     BEGIN
                                       IF PVHead."No."<>"No." THEN
                                         BEGIN
                                          ERROR('The Cheque Number has already been utilised');
                                         END;
                                     END;
                                 UNTIL PVHead.NEXT=0;
                               END;

                             IF "PayMENT Mode"="PayMENT Mode"::Cheque THEN BEGIN
                              IF STRLEN("Cheque No") <> 6 THEN
                               ERROR('Document No. cannot contain More than 6 Characters.');
                             END;
                           END;
                            }

    { 1102755016;2;Field  ;
                SourceExpr="Posting Date";
                Editable="Payment Release DateEditable" }

    { 1102760001;1;Part   ;
                Name=PVLines;
                SubPageLink=No=FIELD(No.);
                PagePartID=Page39004406;
                Editable=PVLinesEditable }

  }
  CODE
  {
    VAR
      PayLine@1102760000 : Record 51516001;
      PVUsers@1102755000 : Record 51516031;
      strFilter@1102755001 : Text[250];
      IntC@1102755002 : Integer;
      IntCount@1102755003 : Integer;
      Payments@1102755014 : Record 51516000;
      RecPayTypes@1102755013 : Record 51516247;
      TarriffCodes@1102755012 : Record 51516431;
      GenJnlLine@1102755011 : Record 81;
      DefaultBatch@1102755010 : Record 232;
      CashierLinks@1102755009 : Record 51516052;
      LineNo@1102755008 : Integer;
      Temp@1102755007 : Record 51516031;
      JTemplate@1102755006 : Code[10];
      JBatch@1102755005 : Code[10];
      PCheck@1102755004 : Codeunit 51516013;
      Post@1102755015 : Boolean;
      strText@1102755016 : Text[100];
      PVHead@1102755017 : Record 51516000;
      BankAcc@1102755018 : Record 270;
      CheckBudgetAvail@1102755020 : Codeunit 51516015;
      Commitments@1102755021 : Record 51516050;
      UserMgt@1102755022 : Codeunit 5700;
      JournlPosted@1102755023 : Codeunit 51516156;
      Doc_Type@1102755024 : 'LPO,Requisition,Imprest,Payment Voucher';
      DocumentType@1102755026 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Imprest,ImprestSurrender,Interbank';
      DocPrint@1102755027 : Codeunit 229;
      CheckLedger@1102755028 : Record 272;
      Text001@1102755029 : TextConst 'ENU=This Document no %1 has printed Cheque No %2 which will have to be voided first before reposting.';
      CheckManagement@1102755030 : Codeunit 367;
      Text000@1102755031 : TextConst 'ENU=Do you want to Void Check No %1';
      Text002@1102755032 : TextConst 'ENU=You have selected post and generate a computer cheque ensure that your cheque printer is ready do you want to continue?';
      HasLines@1102756000 : Boolean;
      AllKeyFieldsEntered@1102756001 : Boolean;
      AdjustGenJnl@1102756002 : Codeunit 407;
      OnBehalfEditable@1102755034 : Boolean;
      "Cheque No.Editable"@19058368 : Boolean INDATASET;
      "Payment Release DateEditable"@19054976 : Boolean INDATASET;
      "Cheque TypeEditable"@19037271 : Boolean INDATASET;
      "Invoice Currency CodeEditable"@19003397 : Boolean INDATASET;
      CurrencyCodeEditable@19053147 : Boolean INDATASET;
      GlobalDimension1CodeEditable@19073685 : Boolean INDATASET;
      "Payment NarrationEditable"@19044409 : Boolean INDATASET;
      PayeeEditable@19050058 : Boolean INDATASET;
      DateEditable@19044717 : Boolean INDATASET;
      PVLinesEditable@19068455 : Boolean INDATASET;
      ShortcutDimension2CodeEditable@1102755033 : Boolean INDATASET;
      ShortcutDimension3CodeEditable@1102755025 : Boolean INDATASET;
      ShortcutDimension4CodeEditable@1102755019 : Boolean INDATASET;
      PaymentModeEditable@1102755035 : Boolean;
      BCSetup@1102755036 : Record 51516051;
      Text003@1102755037 : TextConst 'ENU=Are you sure you want to print a cheque for this Payment.';

    PROCEDURE PostPaymentVoucher@1102755005();
    BEGIN

       // DELETE ANY LINE ITEM THAT MAY BE PRESENT
       GenJnlLine.RESET;
       GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
       GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);
       IF GenJnlLine.FIND('+') THEN
         BEGIN
           LineNo:=GenJnlLine."Line No."+1000;
         END
       ELSE
         BEGIN
           LineNo:=1000;
         END;
       GenJnlLine.DELETEALL;
       GenJnlLine.RESET;

      Payments.RESET;
      Payments.SETRANGE(Payments."No.","No.");
      IF Payments.FIND('-') THEN BEGIN
        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No,Payments."No.");
        IF PayLine.FIND('-') THEN
          BEGIN
            REPEAT
              PostHeader(Payments);
            UNTIL PayLine.NEXT=0;
          END;

      Post:=FALSE;
      Post:=JournlPosted.PostedSuccessfully();
      IF Post THEN  BEGIN
          Posted:=TRUE;
          Status:=Payments.Status::Posted;
          "Posted By":=USERID;
          "Date Posted":=TODAY;
          "Time Posted":=TIME;
         MODIFY;

        //Post Reversal Entries for Commitments
        Doc_Type:=Doc_Type::"Payment Voucher";
        CheckBudgetAvail.ReverseEntries(Doc_Type,"No.");
        END;

      END;
    END;

    PROCEDURE PostHeader@1000000001(VAR Payment@1000000000 : Record 51516000);
    BEGIN

      //IF (Payments."Pay Mode"=Payments."Pay Mode"::Cheque) AND ("Cheque Type"="Cheque Type"::" ") THEN
        // ERROR('Cheque type has to be specified');

      {IF Payments."Pay Mode"=Payments."Pay Mode"::Cheque THEN BEGIN
          IF (Payments."Cheque No."='') AND ("Cheque Type"="Cheque Type"::"Manual Check") THEN
            BEGIN
              ERROR('Please ensure that the cheque number is inserted');
            END;
      END;
       }

      IF Payments."Payment mode"=Payments."Payment mode"::EFT THEN
        BEGIN
          IF Payments."Cheque No"='' THEN
            BEGIN
              ERROR ('Please ensure that the EFT number is inserted');
            END;
        END;

      IF Payments."Payment mode"=Payments."Payment mode"::"Letter of Credit" THEN
        BEGIN
          IF Payments."Cheque No"='' THEN
            BEGIN
              ERROR('Please ensure that the Letter of Credit ref no. is entered.');
            END;
        END;


      GenJnlLine.RESET;
      GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
      GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);

        IF GenJnlLine.FIND('+') THEN
          BEGIN
            LineNo:=GenJnlLine."Line No."+1000;
          END
        ELSE
          BEGIN
            LineNo:=1000;
          END;

      // end of posting to fosa
      // post to g/l account
      GenJnlLine.RESET;
      GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
      GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);

        IF GenJnlLine.FIND('+') THEN
          BEGIN
            LineNo:=GenJnlLine."Line No."+1000;
          END
        ELSE
          BEGIN
            LineNo:=1000;
          END;


      LineNo:=LineNo+1000;
      GenJnlLine.INIT;
      GenJnlLine."Journal Template Name":=JTemplate;
      GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
      GenJnlLine."Journal Batch Name":=JBatch;
      GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
      GenJnlLine."Line No.":=LineNo;
      GenJnlLine."Source Code":='PAYMENTJNL';
      GenJnlLine."Posting Date":=Payment."Posting date";
      IF CustomerPayLinesExist THEN
       GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
      ELSE
        GenJnlLine."Document Type":=GenJnlLine."Document Type"::" ";
      GenJnlLine."Document No.":=Payments."No.";
      GenJnlLine."External Document No.":=Payments."Cheque No";


      GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
      GenJnlLine."Account No.":=Payment."Expense Account";
      GenJnlLine.VALIDATE(GenJnlLine."Account No.");

      GenJnlLine."Currency Code":=Payments."Currency Code";
      GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
      //CurrFactor
      GenJnlLine."Currency Factor":=Payments."Currency Factor";
      GenJnlLine.VALIDATE("Currency Factor");

      Payments.CALCFIELDS(Payments."Net Amount",Payments."VAT Amount",Payments."Total Payment Amount");
      GenJnlLine.Amount:=(Payments."Total Payment Amount"+Payments."VAT Amount");
      GenJnlLine.VALIDATE(GenJnlLine.Amount);
      GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
      GenJnlLine."Bal. Account No.":='';

      GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
      GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
      //GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
      //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
      //GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
      //GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");

      GenJnlLine.Description:=COPYSTR('Pay To:' + Payments.Payee,1,50);
      GenJnlLine.VALIDATE(GenJnlLine.Description);

      IF "Payment Mode"<>"Payment Mode"::Cheque THEN  BEGIN
      GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::" "
      END ELSE BEGIN
      IF "Cheque Type"="Cheque Type"::"Computer Cheque" THEN
       GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::"Computer Check"
      ELSE
         GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::" "

      END;
      IF GenJnlLine.Amount<>0 THEN
      GenJnlLine.INSERT;

      // end post to g/l account
      //Post Other Payment Journal Entries
      PostPV(Payments);
    END;

    PROCEDURE GetAppliedEntries@1102755000(VAR LineNo@1102755001 : Integer) InvText : Text[100];
    VAR
      Appl@1102755000 : Record 51516053;
    BEGIN

      InvText:='';
      Appl.RESET;
      Appl.SETRANGE(Appl."Document Type",Appl."Document Type"::PV);
      Appl.SETRANGE(Appl."Document No.","No.");
      Appl.SETRANGE(Appl."Line No.",LineNo);
      IF Appl.FINDFIRST THEN
        BEGIN
          REPEAT
            InvText:=COPYSTR(InvText + ',' + Appl."Appl. Doc. No",1,50);
          UNTIL Appl.NEXT=0;
        END;
    END;

    PROCEDURE InsertApproval@1102755002();
    VAR
      Appl@1102755000 : Record 51516053;
      LineNo@1102755001 : Integer;
    BEGIN

      LineNo:=0;
      Appl.RESET;
      IF Appl.FINDLAST THEN
        BEGIN
          LineNo:=Appl."Line No.";
        END;

      LineNo:=LineNo +1;

      Appl.RESET;
      Appl.INIT;
        {Appl."Line No.":=LineNo;
        Appl."Document Type":=Appl."Document Type"::PV;
        Appl."Document No.":="No.";
        //Appl."Appl. Doc Date":=DATE;
        Appl."Process Date":=TODAY;
        Appl."Process Time":=TIME;
        Appl."Process User ID":=USERID;
        Appl."Process Name":="Current Status";
       // Appl."Process Machine":=ENVIRON('COMPUTERNAME');
      Appl.INSERT;
      }
    END;

    PROCEDURE LinesCommitmentStatus@1102755001() Exists : Boolean;
    VAR
      BCSetup@1102756000 : Record 51516051;
    BEGIN

       { IF BCSetup.GET() THEN  BEGIN
          IF NOT BCSetup.Mandatory THEN  BEGIN
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
             }
    END;

    PROCEDURE CheckPVRequiredItems@1102755004();
    BEGIN

      IF Posted THEN  BEGIN
          ERROR('The Document has already been posted');
      END;

      TESTFIELD(Status,Status::Approved);
      IF "Paying type"="Paying Type"::Bank THEN
      //TESTFIELD("Paying Bank Account")
      //ELSE IF "Paying Type"="Paying Type"::Vendor THEN
      //TESTFIELD("Paying Vendor Account");

      TESTFIELD("Payment Mode");
      TESTFIELD("Posting date");
      //Confirm whether Bank Has the Cash
      IF "Payment Mode"="Payment Mode"::Cash THEN
      // CheckBudgetAvail.CheckFundsAvailability(Rec);

       //Confirm Payment Release Date is today);
      IF "Payment Mode"="Payment Mode"::Cash THEN
        TESTFIELD("Posting date",WORKDATE);

      {Check if the user has selected all the relevant fields}
      Temp.GET(USERID);

      JTemplate:=Temp."Payment Journal Template";JBatch:=Temp."Payment Journal Batch";

      IF JTemplate='' THEN
        BEGIN
          ERROR('Ensure the PV Template is set up in Cash Office Setup');
        END;
      IF JBatch='' THEN
        BEGIN
          ERROR('Ensure the PV Batch is set up in the Cash Office Setup')
        END;

      IF ("Payment Mode"="Payment Mode"::Cheque) AND ("Cheque Type"="Cheque Type"::"Computer Cheque") THEN BEGIN
         IF NOT CONFIRM(Text002,FALSE) THEN
            ERROR('You have selected to Abort PV Posting');
      END;
      //Check whether there is any printed cheques and lines not posted
      CheckLedger.RESET;
      CheckLedger.SETRANGE(CheckLedger."Document No.","No.");
      CheckLedger.SETRANGE(CheckLedger."Entry Status",CheckLedger."Entry Status"::Printed);
      IF CheckLedger.FIND('-') THEN BEGIN
      //Ask whether to void the printed cheque
      GenJnlLine.RESET;
      GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
      GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);
      GenJnlLine.FINDFIRST;
      IF CONFIRM(Text000,FALSE,CheckLedger."Check No.") THEN
        CheckManagement.VoidCheck(GenJnlLine)
        ELSE
         ERROR(Text001,"No.",CheckLedger."Check No.");
      END;
    END;

    PROCEDURE PostPV@1000000002(VAR Payment@1000000000 : Record 51516000);
    BEGIN

      PayLine.RESET;
      PayLine.SETRANGE(PayLine.No,Payments."No.");
      IF PayLine.FIND('-') THEN BEGIN

      REPEAT
          strText:=GetAppliedEntries(Payline."Line No");
          Payment.TESTFIELD(Payment.Payee);
          PayLine.TESTFIELD(PayLine.Amount);
         // PayLine.TESTFIELD(PayLine."Global Dimension 1 Code");

          //BANK
          {IF PayLine."Payment Mode"=PayLine."Payment Mode"::Cash THEN BEGIN
            CashierLinks.RESET;
            CashierLinks.SETRANGE(CashierLinks.UserID,USERID);
          END;}

          //CHEQUE
          LineNo:=LineNo+1000;
          GenJnlLine.INIT;
          GenJnlLine."Journal Template Name":=JTemplate;
          GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
          GenJnlLine."Journal Batch Name":=JBatch;
          GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
          GenJnlLine."Source Code":='PAYMENTJNL';
          GenJnlLine."Line No.":=LineNo;
          GenJnlLine."Posting Date":=Payment."Posting Date";
          GenJnlLine."Document No.":=PayLine.No;

          //Bett
          IF PayLine."Account Type"=PayLine."Account Type"::Member THEN BEGIN
          GenJnlLine."Document Type":=GenJnlLine."Document Type"::" ";
          GenJnlLine."Transaction Type":=PayLine."Transaction Type";
          GenJnlLine."Loan No":=PayLine."Loan No.";
          END ELSE
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;

          IF PayLine."Account Type"=PayLine."Account Type"::Customer THEN
          GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
          ELSE
          GenJnlLine."Document Type":=GenJnlLine."Document Type"::" ";
          GenJnlLine."Account Type":=PayLine."Account Type";
          GenJnlLine."Account No.":=PayLine."Account No.";
          GenJnlLine.VALIDATE(GenJnlLine."Account No.");
          GenJnlLine."External Document No.":=Payments."Cheque No";
          GenJnlLine.Description:=COPYSTR(PayLine."Transaction Type Description" + ':' + Payment.Payee,1,50);
          GenJnlLine."Currency Code":=Payments."Currency Code";
          GenJnlLine.VALIDATE("Currency Code");
          GenJnlLine."Currency Factor":=Payments."Currency Factor";
          GenJnlLine.VALIDATE("Currency Factor");
          IF PayLine."VAT Code"='' THEN
            BEGIN
                    GenJnlLine.Amount:= -PayLine.Amount+PayLine."VAT Amount" ;
            END
          ELSE
            BEGIN
              GenJnlLine.Amount:=-PayLine.Amount+PayLine."VAT Amount";
            END;
          GenJnlLine.VALIDATE(GenJnlLine.Amount);
          GenJnlLine."VAT Prod. Posting Group":=PayLine."VAT Prod. Posting Group";
          GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
          //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
          GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
          GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
          //GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
          //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
          //GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
          //GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
          GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
          GenJnlLine."Applies-to Doc. No.":=PayLine."Applies-to Doc. No.";
          GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
          GenJnlLine."Applies-to ID":=PayLine."Applies-to ID";

          IF GenJnlLine.Amount<>0 THEN GenJnlLine.INSERT;
          //POST W/TAX to Respective W/TAX GL Account
          TarriffCodes.RESET;
          TarriffCodes.SETRANGE(TarriffCodes.Code,PayLine."Withholding Tax Code");
          IF TarriffCodes.FIND('-') THEN BEGIN
          TarriffCodes.TESTFIELD(TarriffCodes."Account No.");
          LineNo:=LineNo+1000;
          GenJnlLine.INIT;
          GenJnlLine."Journal Template Name":=JTemplate;
          GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
          GenJnlLine."Journal Batch Name":=JBatch;
          GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
          GenJnlLine."Source Code":='PAYMENTJNL';
          GenJnlLine."Line No.":=LineNo;
          GenJnlLine."Posting Date":=Payment."Posting Date";
          GenJnlLine."Document Type":=GenJnlLine."Document Type"::" ";
          GenJnlLine."Document No.":=PayLine.No;
          GenJnlLine."External Document No.":=Payments."Cheque No";
          GenJnlLine."Account Type":=TarriffCodes."Account Type";
          GenJnlLine."Account No.":=TarriffCodes."Account No.";
          GenJnlLine.VALIDATE(GenJnlLine."Account No.");
          GenJnlLine."Currency Code":=Payments."Currency Code";
          GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
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
          GenJnlLine.Amount:=PayLine."W/TAX Amount"-1;
          GenJnlLine.VALIDATE(GenJnlLine.Amount);
          GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
          GenJnlLine."Bal. Account No.":='';
          GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
          GenJnlLine.Description:=COPYSTR('W/Tax:' + FORMAT(PayLine."Account Name") +'::' + strText,1,50);
          GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
          //GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
          //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
          GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
          //GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
          //GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
          IF GenJnlLine.Amount<>0 THEN
          GenJnlLine.INSERT;
          END;

          //POST retention to Respective retention GL Account
          TarriffCodes.RESET;
          TarriffCodes.SETRANGE(TarriffCodes.Code,PayLine."Retention Code");
          IF TarriffCodes.FIND('-') THEN BEGIN
          TarriffCodes.TESTFIELD(TarriffCodes."Account No.");
          LineNo:=LineNo+1000;
          GenJnlLine.INIT;
          GenJnlLine."Journal Template Name":=JTemplate;
          GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
          GenJnlLine."Journal Batch Name":=JBatch;
          GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
          GenJnlLine."Source Code":='PAYMENTJNL';
          GenJnlLine."Line No.":=LineNo;
          GenJnlLine."Posting Date":=Payment."Posting date";
          GenJnlLine."Document Type":=GenJnlLine."Document Type"::" ";
          GenJnlLine."Document No.":=PayLine.No;
          GenJnlLine."External Document No.":=Payments."Cheque No";
          GenJnlLine."Account Type":=TarriffCodes."Account Type";
          GenJnlLine."Account No.":=TarriffCodes."Account No.";
          GenJnlLine.VALIDATE(GenJnlLine."Account No.");
          GenJnlLine."Currency Code":=Payments."Currency Code";
          GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
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
          GenJnlLine.Amount:=-PayLine."Retention Amount";
          GenJnlLine.VALIDATE(GenJnlLine.Amount);
          //GenJnlLine."Bal. Account Type":=PayLine."Account Type";
          //GenJnlLine."Bal. Account No.":=PayLine."Account No.";
          //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
          GenJnlLine.Description:=COPYSTR('Retention:' + FORMAT(PayLine."Account Name") +'::' + strText,1,50);
          GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
          //GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
          //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
          GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
          //GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
          //GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
          IF GenJnlLine.Amount<>0 THEN
          GenJnlLine.INSERT;
          END;

         //Retention balancing account
          LineNo:=LineNo+1000;
          GenJnlLine.INIT;
          GenJnlLine."Journal Template Name":=JTemplate;
          GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
          GenJnlLine."Journal Batch Name":=JBatch;
          GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
          GenJnlLine."Source Code":='PAYMENTJNL';
          GenJnlLine."Line No.":=LineNo;
          GenJnlLine."Posting Date":=Payment."Posting date";
          GenJnlLine."Document Type":=GenJnlLine."Document Type"::" ";
          GenJnlLine."Document No.":=PayLine.No;
          GenJnlLine."External Document No.":=Payments."Cheque No";
          GenJnlLine."Account Type":=PayLine."Account Type";
          GenJnlLine."Account No.":=PayLine."Account No.";
          GenJnlLine.VALIDATE(GenJnlLine."Account No.");
          GenJnlLine."Currency Code":=Payments."Currency Code";
          GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
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
          GenJnlLine.Amount:=PayLine."Retention Amount";
          GenJnlLine.VALIDATE(GenJnlLine.Amount);
          //GenJnlLine."Bal. Account Type":=PayLine."Account Type";
          // GenJnlLine."Bal. Account No.":=PayLine."Account No.";
          // GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
          GenJnlLine.Description:=COPYSTR('Retention:' + FORMAT(PayLine."Account Name") +'::' + strText,1,50);
          GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
          //GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
          //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
          GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
          //GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
          //GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
          IF GenJnlLine.Amount<>0 THEN
          GenJnlLine.INSERT;
         //END POSTING RETENTION

          //Post W/TAX Balancing Entry Goes to Vendor
          LineNo:=LineNo+1000;
          GenJnlLine.INIT;
          GenJnlLine."Journal Template Name":=JTemplate;
          GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
          GenJnlLine."Journal Batch Name":=JBatch;
          GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
          GenJnlLine."Source Code":='PAYMENTJNL';
          GenJnlLine."Line No.":=LineNo;
          GenJnlLine."Posting Date":=Payment."Posting Date";
          GenJnlLine."Document Type":=GenJnlLine."Document Type"::" ";
          GenJnlLine."Document No.":=PayLine.No;
          GenJnlLine."External Document No.":=Payments."Cheque No";
          GenJnlLine."Account Type":=PayLine."Account Type";
          GenJnlLine."Account No.":=PayLine."Account No.";
          GenJnlLine.VALIDATE(GenJnlLine."Account No.");
          GenJnlLine."Currency Code":=Payments."Currency Code";
          GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
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
          //***//
          GenJnlLine.Amount:=PayLine."W/TAX Amount";
          GenJnlLine.VALIDATE(GenJnlLine.Amount);
          GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
          GenJnlLine."Bal. Account No.":='';
          GenJnlLine.Description:=COPYSTR('W/Tax:' + strText ,1,50);
          GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
          GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
          GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
          //GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
          //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
          //GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
          //GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
          GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
          GenJnlLine."Applies-to Doc. No.":=PayLine."Applies-to Doc. No.";
          GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
          GenJnlLine."Applies-to ID":=PayLine."Applies-to ID";
          IF GenJnlLine.Amount<>0 THEN
          GenJnlLine.INSERT;
      UNTIL PayLine.NEXT=0;

      COMMIT;

      //Post the Journal Lines
      GenJnlLine.RESET;
      GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
      GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);
      //Adjust Gen Jnl Exchange Rate Rounding Balances
      AdjustGenJnl.RUN(GenJnlLine);
      //End Adjust Gen Jnl Exchange Rate Rounding Balances

      //Before posting if paymode is cheque print the cheque
      IF ("Payment Mode"="Payment Mode"::Cheque) AND ("Cheque Type"="Cheque Type"::"Computer Cheque") THEN BEGIN
      DocPrint.PrintCheck(GenJnlLine);
      CODEUNIT.RUN(CODEUNIT::"Adjust Gen. Journal Balance",GenJnlLine);
      //Confirm Cheque printed //Not necessary.
      END;


      CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnlLine);
      Post:=FALSE;
      Post:=JournlPosted.PostedSuccessfully();
      IF Post THEN
        BEGIN
          IF PayLine.FINDFIRST THEN
            BEGIN
              REPEAT
                PayLine."Date Posted":=TODAY;
                PayLine."Time Posted":=TIME;
                PayLine."Posted By":=USERID;
                PayLine.Status:=PayLine.Status::Posted;
                PayLine.MODIFY;
             UNTIL PayLine.NEXT=0;
           END;
        END;

      END;
    END;

    PROCEDURE UpdateControls@1102755003();
    BEGIN

           IF Status<>Status::Approved THEN BEGIN
           "Payment Release DateEditable" :=FALSE;
           //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
           //CurrForm."Pay Mode".EDITABLE:=FALSE;
           //CurrForm."Currency Code".EDITABLE:=TRUE;
           "Cheque No.Editable" :=FALSE;
           "Cheque TypeEditable" :=FALSE;
           "Invoice Currency CodeEditable" :=TRUE;
           OnBehalfEditable:=TRUE;
           PaymentModeEditable:=TRUE;
           GlobalDimension1CodeEditable:=TRUE;
           END ELSE BEGIN
           "Payment Release DateEditable" :=TRUE;
           //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
           //CurrForm."Pay Mode".EDITABLE:=TRUE;
           IF "Payment Mode"="Payment Mode"::Cheque THEN
             "Cheque TypeEditable" :=TRUE;
           //CurrForm."Currency Code".EDITABLE:=FALSE;
           IF "Cheque Type"<>"Cheque Type"::"Computer Cheque" THEN
              "Cheque No.Editable" :=TRUE;
           "Invoice Currency CodeEditable" :=FALSE;
           END;

           IF Status=Status::Pending THEN BEGIN
           CurrencyCodeEditable :=TRUE;
           GlobalDimension1CodeEditable :=TRUE;
           "Payment NarrationEditable" :=TRUE;
           ShortcutDimension2CodeEditable :=TRUE;
           PayeeEditable :=TRUE;
           OnBehalfEditable:=TRUE;
           PaymentModeEditable:=TRUE;
           ShortcutDimension3CodeEditable :=TRUE;
           ShortcutDimension4CodeEditable :=TRUE;
           "Cheque TypeEditable":=TRUE;
           DateEditable :=TRUE;
           PVLinesEditable :=TRUE;

           END ELSE BEGIN
           CurrencyCodeEditable:=FALSE;
           GlobalDimension1CodeEditable :=FALSE;
           "Payment NarrationEditable" :=FALSE;
           ShortcutDimension2CodeEditable :=FALSE;
           PayeeEditable :=FALSE;
           OnBehalfEditable:=FALSE;
           PaymentModeEditable:=TRUE;
           ShortcutDimension3CodeEditable :=FALSE;
           ShortcutDimension4CodeEditable :=FALSE;
           DateEditable :=FALSE;
           PVLinesEditable :=FALSE;
           "Cheque TypeEditable":=TRUE;
           END
    END;

    PROCEDURE LinesExists@1102756000() : Boolean;
    VAR
      PayLines@1102756000 : Record 51516001;
    BEGIN

       HasLines:=FALSE;
       PayLines.RESET;
       PayLines.SETRANGE(PayLines.No,"No.");
        IF PayLines.FIND('-') THEN BEGIN
           HasLines:=TRUE;
           EXIT(HasLines);
        END;
    END;

    PROCEDURE AllFieldsEntered@1102756004() : Boolean;
    VAR
      PayLines@1102756000 : Record 51516001;
    BEGIN

      AllKeyFieldsEntered:=TRUE;
       PayLines.RESET;
       PayLines.SETRANGE(PayLines.No,"No.");
        IF PayLines.FIND('-') THEN BEGIN
          REPEAT
           IF (PayLines."Account No."='') OR (PayLines.Amount<=0) THEN
           AllKeyFieldsEntered:=FALSE;
          UNTIL PayLines.NEXT=0;
           EXIT(AllKeyFieldsEntered);
        END;
    END;

    PROCEDURE CustomerPayLinesExist@3() : Boolean;
    VAR
      PayLine@1102756000 : Record 51516001;
    BEGIN

       PayLine.RESET;
      PayLine.SETRANGE(PayLine.No,"No.");
      PayLine.SETRANGE(PayLine."Account Type",PayLine."Account Type"::Customer);
      EXIT(PayLine.FINDFIRST);
    END;

    BEGIN
    {
      xRec := Rec;
      UpdateControls();
      //Set the filters here
      SETRANGE(Posted,FALSE);
      SETRANGE("Payment Type","Payment Type"::Delegates);
      SETFILTER(Status,'<>Cancelled');
    }
    END.
  }
}

