OBJECT page 17441 Teller Till Card
{
  OBJECT-PROPERTIES
  {
    Date=03/31/16;
    Time=11:27:24 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=ENU=Teller Till Card;
    SourceTable=Table270;
    SourceTableView=WHERE(Account Type=FILTER(Cashier));
    PageType=Card;
    OnAfterGetRecord=BEGIN
                       CALCFIELDS("Check Report Name");
                     END;

    OnInsertRecord=BEGIN
                     "Account Type":="Account Type"::Cashier;
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 40      ;1   ;ActionGroup;
                      CaptionML=ENU=&Bank Acc. }
      { 42      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=ENU=Statistics;
                      RunObject=Page 375;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 43      ;2   ;Action    ;
                      CaptionML=ENU=Co&mments;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Bank Account),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 84      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=ENU=Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(270),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 52      ;2   ;Action    ;
                      CaptionML=ENU=Balance;
                      RunObject=Page 377;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Image=Balance }
      { 53      ;2   ;Action    ;
                      CaptionML=ENU=St&atements;
                      RunObject=Page 383;
                      RunPageLink=Bank Account No.=FIELD(No.) }
      { 44      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=ENU=Ledger E&ntries;
                      RunObject=Page 372;
                      RunPageView=SORTING(Bank Account No.);
                      RunPageLink=Bank Account No.=FIELD(No.) }
      { 46      ;2   ;Action    ;
                      CaptionML=ENU=Chec&k Ledger Entries;
                      RunObject=Page 374;
                      RunPageView=SORTING(Bank Account No.);
                      RunPageLink=Bank Account No.=FIELD(No.);
                      Image=CheckLedger }
      { 56      ;2   ;Action    ;
                      CaptionML=ENU=C&ontact;
                      OnAction=BEGIN
                                 ShowContact;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=ENU=General }

    { 2   ;2   ;Field     ;
                SourceExpr="No.";
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                SourceExpr=Address }

    { 8   ;2   ;Field     ;
                SourceExpr="Address 2" }

    { 11  ;2   ;Field     ;
                CaptionML=ENU=Post Code/City;
                SourceExpr="Post Code" }

    { 10  ;2   ;Field     ;
                SourceExpr=City }

    { 12  ;2   ;Field     ;
                SourceExpr="Country/Region Code" }

    { 14  ;2   ;Field     ;
                SourceExpr="Phone No." }

    { 18  ;2   ;Field     ;
                SourceExpr=Contact }

    { 64  ;2   ;Field     ;
                SourceExpr="Bank Branch No." }

    { 36  ;2   ;Field     ;
                SourceExpr="Bank Account No." }

    { 20  ;2   ;Field     ;
                SourceExpr="Search Name" }

    { 22  ;2   ;Field     ;
                SourceExpr=Balance }

    { 54  ;2   ;Field     ;
                SourceExpr="Balance (LCY)" }

    { 24  ;2   ;Field     ;
                SourceExpr="Min. Balance" }

    { 26  ;2   ;Field     ;
                SourceExpr="Our Contact Code" }

    { 28  ;2   ;Field     ;
                SourceExpr=Blocked }

    { 30  ;2   ;Field     ;
                SourceExpr="Last Date Modified" }

    { 1102760000;2;Field  ;
                SourceExpr=CashierID;
                Editable=TRUE }

    { 1102760002;2;Field  ;
                SourceExpr="Maximum Teller Withholding" }

    { 1102760004;2;Field  ;
                SourceExpr="Max Withdrawal Limit" }

    { 1102760006;2;Field  ;
                SourceExpr="Max Deposit Limit" }

    { 1102756000;2;Field  ;
                SourceExpr="Global Dimension 1 Code" }

    { 1102756002;2;Field  ;
                SourceExpr="Global Dimension 2 Code" }

    { 1902768601;1;Group  ;
                CaptionML=ENU=Communication }

    { 66  ;2   ;Field     ;
                SourceExpr="Fax No." }

    { 68  ;2   ;Field     ;
                SourceExpr="E-Mail" }

    { 70  ;2   ;Field     ;
                SourceExpr="Home Page" }

    { 1904784501;1;Group  ;
                CaptionML=ENU=Posting }

    { 34  ;2   ;Field     ;
                SourceExpr="Currency Code" }

    { 48  ;2   ;Field     ;
                SourceExpr="Last Check No." }

    { 50  ;2   ;Field     ;
                SourceExpr="Transit No." }

    { 60  ;2   ;Field     ;
                SourceExpr="Last Statement No." }

    { 62  ;2   ;Field     ;
                SourceExpr="Balance Last Statement" }

    { 32  ;2   ;Field     ;
                SourceExpr="Bank Acc. Posting Group";
                Editable=TRUE }

    { 1905090301;1;Group  ;
                CaptionML=ENU=Transfer }

    { 78  ;2   ;Field     ;
                SourceExpr="SWIFT Code" }

    { 82  ;2   ;Field     ;
                SourceExpr=IBAN }

  }
  CODE
  {
    VAR
      UsersID@1102760000 : Record 2000000120;

    BEGIN
    END.
  }
}

