OBJECT page 20378 Coop ATM Charges
{
  OBJECT-PROPERTIES
  {
    Date=03/18/21;
    Time=[ 4:13:58 PM];
    Modified=Yes;
    Version List=SkyCoop;
  }
  PROPERTIES
  {
    SourceTable=Table170043;
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
                SourceExpr=Minimum }

    { 1120054003;2;Field  ;
                SourceExpr=Maximum }

    { 1120054004;2;Field  ;
                SourceExpr="Bank Commission" }

    { 1120054005;2;Field  ;
                SourceExpr="Sacco Commission" }

    { 1120054006;2;Field  ;
                SourceExpr="Sacco Per Every" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

