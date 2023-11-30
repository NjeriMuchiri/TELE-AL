OBJECT page 50080 Investor Active Account Card
{
  OBJECT-PROPERTIES
  {
    Date=11/16/15;
    Time=[ 9:46:33 AM];
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516433;
    PageType=Card;
    OnOpenPage=BEGIN

                    IF "Account Type"="Account Type"::"1" THEN BEGIN
                      GroupEnabled:=TRUE;
                    END ELSE BEGIN
                     GroupEnabled:=FALSE;
                    END;
               END;

    ActionList=ACTIONS
    {
      { 31      ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 29      ;1   ;ActionGroup;
                      ActionContainerType=ActionItems }
      { 30      ;2   ;Action    ;
                      Name=Group Members;
                      RunObject=page 50071;
                      RunPageLink=Investor No.=FIELD(Field7602);
                      Promoted=Yes;
                      Enabled=GroupEnabled;
                      PromotedIsBig=Yes;
                      Image=Group;
                      PromotedCategory=Process }
      { 33      ;2   ;Action    ;
                      Name=Investor Principle and Topups;
                      RunObject=page 50089;
                      RunPageLink=Investor No=FIELD(Code);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=BarChart;
                      PromotedCategory=Process }
      { 32      ;2   ;Action    ;
                      Name=Investor Card;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Card;
                      PromotedCategory=New;
                      OnAction=BEGIN
                                  Investor.RESET;
                                  Investor.SETRANGE(Investor.Code,Code);
                                  IF Investor.FINDFIRST THEN BEGIN
                                   REPORT.RUN(REPORT::"Manage Fixed Deposit",TRUE,FALSE,Investor);
                                  END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                SourceExpr=Description }

    { 5   ;2   ;Field     ;
                CaptionML=ENU=ID Number/Reg No.;
                SourceExpr="ID Number" }

    { 6   ;2   ;Field     ;
                SourceExpr="Pin Number" }

    { 7   ;2   ;Field     ;
                SourceExpr="Passport No." }

    { 8   ;2   ;Field     ;
                SourceExpr="Investor Posting Group" }

    { 9   ;2   ;Field     ;
                SourceExpr="Account Type" }

    { 10  ;2   ;Field     ;
                SourceExpr="Group Type";
                Enabled=GroupEnabled }

    { 11  ;2   ;Field     ;
                SourceExpr="Account Creation Date" }

    { 12  ;2   ;Field     ;
                SourceExpr="Account Creation Time" }

    { 13  ;2   ;Field     ;
                SourceExpr="Account Creation Officer" }

    { 14  ;2   ;Field     ;
                SourceExpr=Picture }

    { 15  ;2   ;Field     ;
                SourceExpr=Signature }

    { 16  ;1   ;Group     ;
                Name=Contact Information;
                GroupType=Group }

    { 17  ;2   ;Field     ;
                SourceExpr="Post Code" }

    { 18  ;2   ;Field     ;
                SourceExpr="Code Type" }

    { 19  ;2   ;Field     ;
                SourceExpr=City }

    { 20  ;2   ;Field     ;
                SourceExpr="E-Mail" }

    { 21  ;2   ;Field     ;
                SourceExpr="Mobile No." }

    { 22  ;2   ;Field     ;
                SourceExpr="Mobile No2." }

    { 23  ;1   ;Group     ;
                Name=Payment Information;
                GroupType=Group }

    { 24  ;2   ;Field     ;
                SourceExpr="Payment Mode" }

    { 25  ;2   ;Field     ;
                SourceExpr="Bank Name" }

    { 27  ;2   ;Field     ;
                SourceExpr="Branch Name" }

    { 28  ;2   ;Field     ;
                SourceExpr="Bank Account No." }

    { 26  ;2   ;Field     ;
                SourceExpr="Payment Mobile No" }

    { 34  ;2   ;Field     ;
                SourceExpr="Sacco No" }

    { 36  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 35  ;1   ;Part      ;
                SubPageLink=Code=FIELD(Code);
                PagePartID=Page51516446;
                PartType=Page }

  }
  CODE
  {
    VAR
      GroupEnabled@1000 : Boolean;
      Investor@1001 : Record 51516433;

    BEGIN
    END.
  }
}

