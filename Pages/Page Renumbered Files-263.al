OBJECT page 17454 Bankers Cheque Register SetUp
{
  OBJECT-PROPERTIES
  {
    Date=10/12/15;
    Time=[ 3:34:45 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516313;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102760008;1 ;Action    ;
                      CaptionML=ENU=Generate;
                      Promoted=Yes;
                      Image=Grid;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to generate bankers cheque No.?',FALSE) = FALSE THEN
                                 EXIT;

                                 i :=0;

                                 REPEAT
                                 i := i + 1;

                                 BankerR.INIT;
                                 BankerR."Banker Cheque No.":=BankerCh;
                                 BankerR.INSERT;

                                 BankerCh:=INCSTR(BankerCh);
                                 UNTIL i = NoOfLeaves;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 7   ;0   ;Container ;
                ContainerType=ContentArea }

    { 6   ;1   ;Group     ;
                GroupType=Repeater }

    { 5   ;2   ;Field     ;
                SourceExpr="Banker Cheque No." }

    { 4   ;2   ;Field     ;
                SourceExpr=Issued;
                Editable=TRUE }

    { 3   ;2   ;Field     ;
                SourceExpr=Cancelled;
                Editable=TRUE }

    { 2   ;1   ;Field     ;
                SourceExpr=BankerCh }

    { 1   ;1   ;Field     ;
                SourceExpr=NoOfLeaves }

  }
  CODE
  {
    VAR
      BankerCh@1102760000 : Code[20];
      NoOfLeaves@1102760001 : Integer;
      i@1102760002 : Integer;
      BankerR@1102760003 : Record 51516313;

    BEGIN
    END.
  }
}

