OBJECT page 20385 Coop Trans Out.
{
  OBJECT-PROPERTIES
  {
    Date=03/24/23;
    Time=[ 3:21:44 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table170066;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054003;2;Field  ;
                SourceExpr="Member Account" }

    { 1120054004;2;Field  ;
                SourceExpr="Document No." }

    { 1120054005;2;Field  ;
                SourceExpr="Transaction Date" }

    { 1120054006;2;Field  ;
                SourceExpr="ATM No." }

    { 1120054007;2;Field  ;
                SourceExpr="Description 1" }

    { 1120054008;2;Field  ;
                SourceExpr=Amount }

    { 1120054009;2;Field  ;
                SourceExpr=Reconcilled }

    { 1120054010;2;Field  ;
                SourceExpr="Reconcillation Header" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

