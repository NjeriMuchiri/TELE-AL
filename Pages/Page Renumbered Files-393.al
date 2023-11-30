OBJECT page 50089 Investor Amounts
{
  OBJECT-PROPERTIES
  {
    Date=11/16/15;
    Time=[ 9:09:17 AM];
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516440;
    PageType=List;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 7   ;2   ;Field     ;
                SourceExpr="Investor No" }

    { 3   ;2   ;Field     ;
                SourceExpr="Interest Code" }

    { 4   ;2   ;Field     ;
                SourceExpr="Investment Date" }

    { 11  ;2   ;Field     ;
                SourceExpr=Amount }

    { 8   ;2   ;Field     ;
                CaptionML=ENU=Last Updated By;
                SourceExpr="Last Update User" }

    { 9   ;2   ;Field     ;
                SourceExpr="Last Update Date" }

    { 10  ;2   ;Field     ;
                SourceExpr="Last Update Time" }

    { 5   ;2   ;Field     ;
                SourceExpr="Closure Date" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

