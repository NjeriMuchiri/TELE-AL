OBJECT page 20495 File Movement Line
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=[ 3:12:43 PM];
    Modified=Yes;
    Version List=File Movement Beta(Suretep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516401;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=General;
                GroupType=Repeater }

    { 1000000003;2;Field  ;
                SourceExpr="File Type" }

    { 1000000010;2;Field  ;
                SourceExpr="File Number";
                ShowMandatory=TRUE }

    { 1000000002;2;Field  ;
                SourceExpr="Destination File Location";
                ShowMandatory=TRUE }

    { 1000000004;2;Field  ;
                SourceExpr="Account Type" }

    { 1000000005;2;Field  ;
                SourceExpr="Account No." }

    { 1000000009;2;Field  ;
                SourceExpr="Account Name" }

    { 1000000006;2;Field  ;
                SourceExpr="Purpose/Description";
                ShowMandatory=TRUE }

    { 1000000007;2;Field  ;
                SourceExpr="Global Dimension 1 Code";
                ShowMandatory=TRUE }

    { 1000000008;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                ShowMandatory=TRUE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

