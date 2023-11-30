OBJECT page 20428 Store Requisition Lines
{
  OBJECT-PROPERTIES
  {
    Date=08/19/16;
    Time=10:39:41 AM;
    Modified=Yes;
    Version List=SureStep Procurement Module v1.0;
  }
  PROPERTIES
  {
    SourceTable=Table51516064;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1000000012;0;Container;
                ContainerType=ContentArea }

    { 1000000011;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000010;2;Field  ;
                SourceExpr=Type }

    { 1000000009;2;Field  ;
                SourceExpr="No." }

    { 1000000008;2;Field  ;
                SourceExpr=Description }

    { 1000000006;2;Field  ;
                SourceExpr="Qty in store" }

    { 1000000007;2;Field  ;
                SourceExpr="Unit of Measure" }

    { 1000000005;2;Field  ;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 1000000004;2;Field  ;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 1000000003;2;Field  ;
                SourceExpr="Quantity Requested" }

    { 1000000002;2;Field  ;
                SourceExpr="Unit Cost";
                Editable=FALSE }

    { 1000000001;2;Field  ;
                SourceExpr="Line Amount" }

    { 1000000000;2;Field  ;
                SourceExpr=Quantity;
                Visible=FALSE }

    { 1000000013;2;Field  ;
                SourceExpr="Issuing Store" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

