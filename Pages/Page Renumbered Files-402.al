OBJECT page 50098 Posted OverDraft List
{
  OBJECT-PROPERTIES
  {
    Date=06/15/21;
    Time=11:53:04 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516328;
    SourceTableView=SORTING(No.)
                    ORDER(Ascending)
                    WHERE(Posted=CONST(Yes),
                          Liquidated=CONST(No),
                          Expired=CONST(No),
                          Status=CONST(Approved));
    PageType=List;
    CardPageID=Over Draft Authorisation;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    OnAfterGetRecord=BEGIN
                       ExpectedInterest := ROUND("Overdraft Interest %"/100*"Withdrawal Amount");
                     END;

    ActionList=ACTIONS
    {
      { 1102755017;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755016;1 ;ActionGroup;
                      CaptionML=ENU=Function }
      { 1102755011;2 ;Action    ;
                      Name=Account;
                      RunObject=page 17434;
                      RunPageLink=No.=FIELD(Account No.);
                      Promoted=Yes;
                      Image=Planning;
                      PromotedCategory=Process }
      { 1102755018;2 ;Action    ;
                      Name=Liquidate;
                      Promoted=Yes;
                      Image=PutawayLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Liquidate;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr="No." }

    { 1102755003;2;Field  ;
                SourceExpr="Account No." }

    { 1102755004;2;Field  ;
                SourceExpr="Account Name" }

    { 1102755005;2;Field  ;
                SourceExpr="Effective/Start Date" }

    { 1102755006;2;Field  ;
                SourceExpr=Duration }

    { 1102755007;2;Field  ;
                SourceExpr="Expiry Date" }

    { 1102755008;2;Field  ;
                SourceExpr="Transacting Branch" }

    { 1102755009;2;Field  ;
                SourceExpr="Created By" }

    { 1120054005;2;Field  ;
                SourceExpr="Requested Amount" }

    { 1120054006;2;Field  ;
                SourceExpr="Withdrawal Amount" }

    { 1120054004;2;Field  ;
                SourceExpr="Approved Amount" }

    { 1102755010;2;Field  ;
                SourceExpr=Expired }

    { 1120054003;2;Field  ;
                SourceExpr=Mobile }

    { 1120054000;2;Field  ;
                SourceExpr="Overdraft Fee" }

    { 1120054001;2;Field  ;
                SourceExpr="Overdraft Interest %" }

    { 1120054002;2;Field  ;
                Name=ExpectedInterest;
                SourceExpr=ExpectedInterest }

  }
  CODE
  {
    VAR
      ApprovalEntries@1102755024 : Page 658;
      DocumentType@1102755023 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Closure,Account Opening,Batches,Payment Voucher,Petty Cash,Requisition,Loan,Interbank,Imprest,Checkoff,FOSA Account Opening,StandingOrder,HRJob,HRLeave,HRTransport Request,HRTraining,HREmp Requsition,MicroTrans,Account Reactivation,Overdraft';
      MinAccBal@1102755021 : Decimal;
      BankName@1102755019 : Text[200];
      Banks@1102755018 : Record 51516311;
      UsersID@1102755017 : Record 2000000120;
      AccP@1102755016 : Record 23;
      i@1102755011 : Integer;
      DActivity@1102755010 : Code[20];
      DBranch@1102755009 : Code[20];
      ODCharge@1102755008 : Decimal;
      AccNo@1102755007 : Boolean;
      ReqAmount@1102755006 : Boolean;
      AppAmount@1102755005 : Boolean;
      ODInt@1102755004 : Boolean;
      EstartDate@1102755003 : Boolean;
      Durationn@1102755002 : Boolean;
      ODFee@1102755001 : Boolean;
      Remmarks@1102755000 : Boolean;
      GenJournalLine@1102755061 : Record 81;
      GLPosting@1102755060 : Codeunit 12;
      Account@1102755059 : Record 23;
      AccountType@1102755058 : Record 51516295;
      LineNo@1102755057 : Integer;
      ChequeType@1102755056 : Record 51516304;
      FDInterestCalc@1102755055 : Record 51516306;
      InterestBuffer@1102755054 : Record 51516324;
      IntRate@1102755053 : Decimal;
      DocNo@1102755052 : Code[10];
      PDate@1102755051 : Date;
      IntBufferNo@1102755050 : Integer;
      MidMonthFactor@1102755049 : Decimal;
      DaysInMonth@1102755048 : Integer;
      StartDate@1102755047 : Date;
      IntDays@1102755046 : Integer;
      AsAt@1102755045 : Date;
      MinBal@1102755044 : Boolean;
      AccruedInt@1102755043 : Decimal;
      RIntDays@1102755042 : Integer;
      Bal@1102755041 : Decimal;
      DFilter@1102755040 : Text[50];
      FixedDtype@1102755039 : Record 51516305;
      DURATION@1102755038 : Integer;
      Charges@1102755037 : Record 51516297;
      ODAccount@1102755036 : Code[20];
      ODRate@1102755035 : Decimal;
      MinAmount@1102755034 : Decimal;
      MaxAmount@1102755033 : Decimal;
      OverDraftAmount@1102755032 : Decimal;
      OverDraftAuth@1102755031 : Record 51516299;
      GenBatch@1102755030 : Record 232;
      Vendor@1102755029 : Record 23;
      EndMonth@1102755028 : Date;
      StatusPermissions@1102755027 : Record 51516310;
      AvailableBalance@1102755026 : Decimal;
      AccountTypes@1102755025 : Record 51516295;
      ExpectedInterest@1120054000 : Decimal;

    PROCEDURE CalcAvailableBal@1102760000();
    BEGIN
      AvailableBalance:=0;
      MinAccBal:=0;

      IF Account.GET("Account No.") THEN BEGIN
      Account.CALCFIELDS(Account.Balance,Account."Uncleared Cheques",Account."ATM Transactions",
                         Account."Authorised Over Draft");

      AccountTypes.RESET;
      AccountTypes.SETRANGE(AccountTypes.Code,"Account Type");
      IF AccountTypes.FIND('-') THEN BEGIN
      MinAccBal:=AccountTypes."Minimum Balance";

      AvailableBalance:=(Account.Balance+Account."Authorised Over Draft") - MinAccBal - Account."Uncleared Cheques" -
                        Account."EFT Transactions"-Account."ATM Transactions";


      END;
      END;
    END;

    BEGIN
    END.
  }
}

