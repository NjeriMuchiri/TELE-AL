OBJECT page 17484 BOSA Transfer
{
  OBJECT-PROPERTIES
  {
    Date=08/24/23;
    Time=11:30:50 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516264;
    PageType=Card;
    OnDeleteRecord=BEGIN
                     ERROR('Not Allowed!');
                   END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102760017;1 ;ActionGroup;
                      CaptionML=ENU=Posting }
      { 1102760019;2 ;Action    ;
                      CaptionML=ENU=Post;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SourceName@1120054001 : Text;
                                 DestinationName@1120054002 : Text;
                                 SourceMemb@1120054003 : Record 51516223;
                                 DestinationMemb@1120054004 : Record 51516223;
                                 SFac@1120054005 : Codeunit 51516022;
                                 SkyMbanking@1120054000 : Codeunit 51516701;
                                 msg_to_send@1120054006 : TextConst 'ENU=Dear %1, You have %2 shares of %3 %4 %5.';
                                 TransferTxt@1120054007 : Text[200];
                                 ReceivedTxt@1120054008 : Text[200];
                               BEGIN
                                 {IF UsersID.GET(USERID) THEN BEGIN
                                 //PKKSUsersID.TESTFIELD(UsersID.Branch);
                                 //DActivity:='FOSA';
                                 DBranch:=UsersID.Branch;
                                 END;}
                                 TESTFIELD(Status,Rec.Status::Approved);
                                 IF FundsUSer.GET(USERID) THEN BEGIN
                                   Jtemplate:=FundsUSer."Payment Journal Template";
                                   Jbatch:=FundsUSer."Payment Journal Batch";
                                 END;
                                 IF Posted = TRUE THEN
                                     ERROR('This Shedule is already posted');


                                 IF CONFIRM('Are you sure you want to transfer schedule?',FALSE)=TRUE THEN BEGIN

                                 //IF Approved=FALSE THEN
                                 //ERROR('This schedule is not approved');


                                 // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",Jtemplate);
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",Jbatch);
                                 GenJournalLine.DELETEALL;




                                 //POSTING MAIN TRANSACTION

                                 //window.OPEN('Posting:,#1######################');



                                 BSched.RESET;
                                 BSched.SETRANGE(BSched."No.",No);
                                 IF BSched.FIND('-') THEN BEGIN
                                 REPEAT

                                 IF BSched."Source Type"=BSched."Source Type"::Vendor THEN BEGIN
                                 VendorS.RESET;
                                 VendorS.SETRANGE(VendorS."No.",BSched."Source Account No.");
                                 IF VendorS.FINDFIRST THEN BEGIN
                                 IF (VendorS."Account Type"<>'ORDINARY') AND (BSched."Destination Account Type"=BSched."Destination Account Type"::MEMBER) THEN
                                 ERROR('Only ordinary accounts can transact directly.');
                                 END;
                                 END;

                                 // UPDATE Source Account
                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":=Jtemplate;
                                 GenJournalLine."Journal Batch Name":=Jbatch;
                                 GenJournalLine."Document No.":=No;
                                 GenJournalLine."Line No.":=GenJournalLine."Line No."+10000;
                                 IF BSched."Source Type"=BSched."Source Type"::Customer THEN BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Customer;
                                 GenJournalLine."Transaction Type":=BSched."Transaction Type";
                                 GenJournalLine."Account No.":=BSched."Source Account No.";
                                 GenJournalLine."Loan No":=BSched.Loan;
                                 END ELSE
                                 IF BSched."Source Type"=BSched."Source Type"::MEMBER   THEN BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Transaction Type":=BSched."Transaction Type";
                                 GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                 GenJournalLine."Account No.":=BSched."Source Account No.";
                                 GenJournalLine."Loan No":=BSched.Loan;
                                 END ELSE

                                 IF BSched."Source Type"=BSched."Source Type"::Vendor THEN BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Transaction Type":=BSched."Transaction Type";
                                 GenJournalLine."Shortcut Dimension 1 Code":='fOSA';
                                 GenJournalLine."Account No.":=BSched."Source Account No.";
                                 END ELSE
                                 IF BSched."Source Type"=BSched."Source Type"::"G/L ACCOUNT" THEN BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Transaction Type":=BSched."Transaction Type";
                                 GenJournalLine."Account No.":=BSched."Source Account No.";
                                 END ELSE
                                 IF BSched."Source Type"=BSched."Source Type"::Bank THEN BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                 GenJournalLine."Shortcut Dimension 1 Code":='BOSA';
                                 GenJournalLine."Account No.":=BSched."Source Account No.";
                                 END;
                                 GenJournalLine."Posting Date":="Transaction Date";
                                 GenJournalLine.Description:=BSched."Source Account Name";
                                 GenJournalLine.Amount:=BSched.Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine.INSERT;




                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":=Jtemplate;
                                 GenJournalLine."Journal Batch Name":=Jbatch;
                                 GenJournalLine."Document No.":=No;
                                 GenJournalLine."Line No.":=GenJournalLine."Line No."+10000;
                                 IF BSched."Destination Account Type"=BSched."Destination Account Type"::CUSTOMER THEN BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Customer;
                                 GenJournalLine."Transaction Type":=BSched."Transaction Type";
                                 GenJournalLine."Account No.":=BSched."Destination Account No.";
                                 END ELSE
                                 IF BSched."Destination Account Type"=BSched."Destination Account Type"::MEMBER THEN BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
                                 GenJournalLine."Transaction Type":=BSched."Destination Type";
                                 GenJournalLine."Account No.":=BSched."Destination Account No.";
                                 END ELSE

                                 IF BSched."Destination Account Type"=BSched."Destination Account Type"::FOSA THEN BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Transaction Type":=BSched."Transaction Type";
                                 GenJournalLine."Account No.":=BSched."Destination Account No.";
                                 END ELSE
                                 IF BSched."Destination Account Type"=BSched."Destination Account Type"::"G/L ACCOUNT" THEN BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=BSched."Destination Account No.";

                                 END ELSE
                                 IF BSched."Destination Account Type"=BSched."Destination Account Type"::BANK THEN BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":=BSched."Destination Account No.";
                                 END;
                                 GenJournalLine."Loan No":=BSched."Destination Loan";
                                 GenJournalLine.VALIDATE(GenJournalLine."Loan No");
                                 //GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":="Transaction Date";
                                 GenJournalLine.Description:=BSched."Destination Account Name";
                                 GenJournalLine.Amount:=-BSched.Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine.INSERT;
                                 UNTIL BSched.NEXT=0;
                                 END;



                                 //Post
                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",Jtemplate);
                                 GenJournalLine.SETRANGE("Journal Batch Name",Jbatch);
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                                 END;
                                 //Post
                                 Posted:=TRUE;
                                 MODIFY;
                                 CALCFIELDS("Schedule Total");

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'Bosa Transfer',"Schedule Total",
                                 'FINANCE',TODAY,TIME,'',No,'','');
                                 //End Create Audit Entry

                                 BSched.RESET;
                                 BSched.SETRANGE(BSched."No.",No);
                                 BSched.SETRANGE(BSched."Transaction Type",BSched."Transaction Type"::"Deposit Contribution");
                                 IF BSched.FINDSET THEN
                                 REPEAT
                                    IF BSched."Destination Type"=BSched."Destination Type"::"Deposit Contribution" THEN BEGIN
                                         SourceName:=BSched."Source Account Name";DestinationName:=BSched."Destination Account Name";
                                         SourceName:=SFac.FnSplitThisSpringAndReturnValueAtPosition(SourceName,0);
                                         DestinationName:=SFac.FnSplitThisSpringAndReturnValueAtPosition(DestinationName,0);
                                         IF SourceMemb.GET(BSched."Source Account No.") THEN BEGIN
                                         //SkyMbanking.SendSms(0,SourceMemb."Phone No.",STRSUBSTNO(msg_to_send,SourceName,'transferred',BSched.Amount,'to',DestinationName),SourceMemb."No.",SourceMemb."No.",TRUE,0,TRUE);
                                          TransferTxt:='Dear '+SourceName+',you have transferred shares of Ksh,'+FORMAT(BSched.Amount)+' to '+DestinationName;
                                          SendSMSNotification(BSched.Amount,TransferTxt,SourceMemb."Phone No.",SourceMemb."No.");
                                         END;
                                         IF DestinationMemb.GET(BSched."Destination Account No.") THEN BEGIN
                                          // SkyMbanking.SendSms(0,DestinationMemb."Phone No.",STRSUBSTNO(msg_to_send,DestinationName,'received',BSched.Amount,'from',SourceName),DestinationMemb."No.",DestinationMemb."No.",TRUE,0,TRUE);
                                          ReceivedTxt:='Dear '+DestinationName+',you have received shares of Ksh,'+FORMAT(BSched.Amount)+' from '+SourceName;
                                          SendSMSNotification(BSched.Amount,ReceivedTxt,DestinationMemb."Phone No.",DestinationMemb."No.");
                                         END;
                                    END;
                                 UNTIL BSched.NEXT = 0;

                                 END;
                               END;
                                }
      { 1102760015;2 ;Action    ;
                      CaptionML=ENU=Print;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                  BTRANS.RESET;
                                  BTRANS.SETRANGE(BTRANS.No,No);
                                  IF BTRANS.FIND('-') THEN BEGIN
                                  REPORT.RUN(51516293,TRUE,TRUE,BTRANS);
                                  END;
                               END;
                                }
      { 1120054000;2 ;ActionGroup;
                      ActionContainerType=NewDocumentItems }
      { 1120054002;1 ;Action    ;
                      Name=Send Approval Request;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 Rec.ApprovalsRequest(0);
                               END;
                                }
      { 1120054001;1 ;Action    ;
                      Name=Cancel Approval Request;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 Rec.ApprovalsRequest(1);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                CaptionML=ENU=General }

    { 1102760001;2;Field  ;
                SourceExpr=No;
                Editable=FALSE }

    { 1102760003;2;Field  ;
                SourceExpr="Transaction Date";
                Editable=TRUE }

    { 1000000000;2;Field  ;
                SourceExpr="Transaction Time" }

    { 1102755002;2;Field  ;
                SourceExpr=Remarks }

    { 1102760009;2;Field  ;
                SourceExpr="Schedule Total";
                Editable=FALSE }

    { 1120054007;2;Field  ;
                SourceExpr="Mode of Payment" }

    { 1120054006;2;Field  ;
                SourceExpr="Approved By" }

    { 1120054005;2;Field  ;
                SourceExpr="Approved On" }

    { 1120054003;2;Field  ;
                SourceExpr="Created By" }

    { 1120054004;2;Field  ;
                SourceExpr="Created On" }

    { 1102760005;2;Field  ;
                SourceExpr=Approved;
                Editable=FALSE }

    { 1102760014;1;Part   ;
                SubPageLink=No.=FIELD(No);
                PagePartID=Page51516347 }

  }
  CODE
  {
    VAR
      users@1102760000 : Record 2000000120;
      GenJournalLine@1102760001 : Record 81;
      DefaultBatch@1102760002 : Record 232;
      BSched@1102760003 : Record 51516265;
      BTRANS@1102760004 : Record 51516264;
      DActivity@1102755003 : Code[20];
      DBranch@1102755002 : Code[20];
      UsersID@1102755001 : Record 2000000120;
      FundsUSer@1000000000 : Record 51516031;
      Jtemplate@1000000001 : Code[10];
      Jbatch@1000000002 : Code[10];
      ApprovalMgt@1120054002 : Codeunit 439;
      ApprovalsMgmt@1120054000 : Codeunit 1535;
      SMSMessages@1120054004 : Record 51516329;
      iEntryNo@1120054003 : Integer;
      VendorS@1120054005 : Record 23;
      AuditTrail@1120054007 : Codeunit 51516107;
      Trail@1120054006 : Record 51516655;
      EntryNo@1120054001 : Integer;

    PROCEDURE SendSMSNotification@1000000008(Amount@1120054001 : Decimal;SMStext@1120054002 : Text[200];PhoneNo@1120054003 : Code[40];Source@1120054004 : Code[20]);
    BEGIN
            SMSMessages.RESET;
            IF SMSMessages.FIND('+') THEN BEGIN
            iEntryNo:=SMSMessages."Entry No";
            iEntryNo:=iEntryNo+1;
            END
            ELSE BEGIN
            iEntryNo:=1;
            END;

            SMSMessages.RESET;
            SMSMessages.INIT;
            SMSMessages."Entry No":=iEntryNo;
            SMSMessages."Account No":=Source;
            SMSMessages."Date Entered":=TODAY;
            SMSMessages."Time Entered":=TIME;
            SMSMessages.Source:='Transfer';
            SMSMessages."Entered By":=USERID;
            SMSMessages."Sent To Server":=SMSMessages."Sent To Server"::No;
            SMSMessages."SMS Message":=SMStext;

            SMSMessages."Telephone No":=PhoneNo;
            SMSMessages.INSERT;

    END;

    BEGIN
    END.
  }
}

