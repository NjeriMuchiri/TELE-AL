OBJECT page 20420 RFQ List
{
  OBJECT-PROPERTIES
  {
    Date=04/12/18;
    Time=[ 7:39:28 PM];
    Modified=Yes;
    Version List=SureStep Procurement Module v1.0;
  }
  PROPERTIES
  {
    SourceTable=Table51516054;
    SourceTableView=WHERE(Status=FILTER(Open|Released));
    PageType=List;
    CardPageID=RFQ Header;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=General;
                GroupType=Repeater }

    { 1102755002;2;Field   }

    { 1102755003;2;Field  ;
                SourceExpr="Posting Description" }

    { 1102755008;2;Field  ;
                SourceExpr="Expected Closing Date" }

    { 1102755009;2;Field  ;
                SourceExpr="Location Code" }

    { 1102755010;2;Field  ;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 1102755011;2;Field  ;
                SourceExpr="Shortcut Dimension 2 Code" }

  }
  CODE
  {

    PROCEDURE GetSelectionFilter@3() : Text;
    VAR
      RFQ@1001 : Record 51516052;
      SelectionFilterManagement@1002 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(RFQ);
      //EXIT(SelectionFilterManagement.GetSelectionFilterForItem(Item));
      EXIT(RFQ."Branch Code");
    END;

    PROCEDURE SetSelection@1(VAR RFQ@1000 : Record 51516052);
    BEGIN
      CurrPage.SETSELECTIONFILTER(RFQ);
    END;

    BEGIN
    END.
  }
}

