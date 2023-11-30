OBJECT page 20437 Item Groups
{
  OBJECT-PROPERTIES
  {
    Date=04/07/16;
    Time=12:20:12 PM;
    Modified=Yes;
    Version List=Supply cchain Management;
  }
  PROPERTIES
  {
    SourceTable=Table51516066;
    PageType=List;
    ActionList=ACTIONS
    {
      { 5       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 6       ;1   ;Action    ;
                      CaptionML=ENU=&Item Category Code;
                      RunObject=Page 5730;
                      RunPageLink=Item Group Code=FIELD(Code);
                      Promoted=Yes;
                      Image=ItemGroup;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 13  ;0   ;Container ;
                ContainerType=ContentArea }

    { 12  ;1   ;Group     ;
                GroupType=Repeater }

    { 11  ;2   ;Field     ;
                SourceExpr=Code }

    { 10  ;2   ;Field     ;
                SourceExpr=Description }

    { 9   ;2   ;Field     ;
                SourceExpr="Def. Gen. Prod. Posting Group";
                Visible=False }

    { 8   ;2   ;Field     ;
                SourceExpr="Def. Inventory Posting Group";
                Visible=false }

    { 7   ;2   ;Field     ;
                SourceExpr="Def. VAT Prod. Posting Group";
                Visible=false }

    { 4   ;2   ;Field     ;
                SourceExpr="Def. Costing Method";
                Visible=false }

    { 3   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 2   ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1   ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

