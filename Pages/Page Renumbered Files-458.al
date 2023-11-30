OBJECT page 172053 Audit Trail Entries
{
  OBJECT-PROPERTIES
  {
    Date=02/14/23;
    Time=11:16:54 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516655;
    SourceTableView=SORTING(Entry No)
                    ORDER(Descending);
    PageType=List;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Entry No" }

    { 1120054003;2;Field  ;
                SourceExpr="User Id" }

    { 1120054015;2;Field  ;
                SourceExpr="User Name" }

    { 1120054004;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1120054005;2;Field  ;
                SourceExpr=Amount }

    { 1120054006;2;Field  ;
                SourceExpr=Source }

    { 1120054007;2;Field  ;
                SourceExpr=Date }

    { 1120054008;2;Field  ;
                SourceExpr=Time }

    { 1120054009;2;Field  ;
                SourceExpr="Loan Number" }

    { 1120054010;2;Field  ;
                SourceExpr="Document Number" }

    { 1120054011;2;Field  ;
                SourceExpr="Account Number" }

    { 1120054012;2;Field  ;
                SourceExpr="ATM Card" }

    { 1120054013;2;Field  ;
                SourceExpr="Computer Name" }

    { 1120054014;2;Field  ;
                SourceExpr="IP Address" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

