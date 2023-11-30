OBJECT page 20429 PRF Lists
{
  OBJECT-PROPERTIES
  {
    Date=02/05/16;
    Time=10:03:30 AM;
    Modified=Yes;
    Version List=Supply Chain Management;
  }
  PROPERTIES
  {
    SourceTable=Table39;
    SourceTableView=WHERE(Document Type=CONST(Quote));
    PageType=List;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr="Document No." }

    { 1000000003;2;Field  ;
                SourceExpr=Type }

    { 1000000004;2;Field  ;
                SourceExpr="No." }

    { 1000000005;2;Field  ;
                SourceExpr=Description }

    { 1000000006;2;Field  ;
                SourceExpr="Description 2" }

    { 1000000007;2;Field  ;
                SourceExpr="Unit of Measure" }

    { 1000000008;2;Field  ;
                SourceExpr=Quantity }

    { 1000000009;2;Field  ;
                SourceExpr="Direct Unit Cost" }

  }
  CODE
  {

    PROCEDURE SetSelection@1(VAR Collection@1000 : Record 39);
    BEGIN
      CurrPage.SETSELECTIONFILTER(Collection);
    END;

    BEGIN
    END.
  }
}

