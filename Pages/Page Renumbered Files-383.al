OBJECT page 50079 Investor Active Account List
{
  OBJECT-PROPERTIES
  {
    Date=11/16/15;
    Time=[ 9:47:01 AM];
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516433;
    PageType=List;
    CardPageID=Investor Active Account Card;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                SourceExpr="ID Number" }

    { 5   ;2   ;Field     ;
                SourceExpr="Mobile No." }

    { 7   ;2   ;Field     ;
                SourceExpr="Pin Number" }

    { 9   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 8   ;1   ;Part      ;
                SubPageLink=Code=FIELD(Code);
                PagePartID=Page51516446;
                PartType=Page }

  }
  CODE
  {

    BEGIN
    END.
  }
}

