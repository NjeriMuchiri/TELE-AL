OBJECT page 17410 Interest Due Periods
{
  OBJECT-PROPERTIES
  {
    Date=02/18/16;
    Time=11:13:32 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516250;
    PageType=List;
    ActionList=ACTIONS
    {
      { 14      ;    ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 15      ;1   ;Separator  }
      { 16      ;1   ;Action    ;
                      Name=Create Period;
                      Promoted=Yes;
                      Image=AccountingPeriods;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //InterestPeriod.RESET;
                                 //InterestPeriod.SETRANGE(BOSARcpt."Transaction No.","Transaction No.");
                                 //IF InterestPeriod.FIND('-') THEN
                                 REPORT.RUN(51516252)
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="Interest Due Date";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                SourceExpr=Name;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                SourceExpr="New Fiscal Year";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                SourceExpr=Closed;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                SourceExpr="Date Locked";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                SourceExpr="Closed by User";
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                SourceExpr="Closing Date Time";
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                SourceExpr="Interest Calcuation Date";
                Editable=FALSE }

  }
  CODE
  {
    VAR
      InvtPeriod@1001 : Record 5814;
      date@1000 : DateFormula;
      InterestPeriod@1002 : Record 51516250;

    BEGIN
    END.
  }
}

