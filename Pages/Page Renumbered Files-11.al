OBJECT page 20375 Coop ATM Setup
{
  OBJECT-PROPERTIES
  {
    Date=03/17/21;
    Time=[ 7:29:11 AM];
    Modified=Yes;
    Version List=SkyCoop;
  }
  PROPERTIES
  {
    SourceTable=Table170040;
    PageType=Card;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1120054002;2;Field  ;
                SourceExpr="Coop Commission Account" }

    { 1120054003;2;Field  ;
                SourceExpr="Coop Fee Account" }

    { 1120054004;2;Field  ;
                SourceExpr="Coop Bank Account" }

    { 1120054005;2;Field  ;
                SourceExpr="Daily Withdrawal Limit" }

    { 1120054006;2;Field  ;
                SourceExpr="Transactional Withdrawal Limit" }

    { 1120054007;2;Field  ;
                SourceExpr="Institution Code" }

    { 1120054008;2;Field  ;
                SourceExpr="Institutio Name" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

