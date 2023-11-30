OBJECT page 17427 Appraisal Salary Set-up
{
  OBJECT-PROPERTIES
  {
    Date=08/02/16;
    Time=12:47:46 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=Yes;
    InsertAllowed=Yes;
    ModifyAllowed=Yes;
    SourceTable=Table51516255;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 1102755000;2;Field  ;
                SourceExpr=Code }

    { 1102755002;2;Field  ;
                SourceExpr=Description }

    { 1102755004;2;Field  ;
                OptionCaptionML=ENG=" ,Earnings,Deductions,Basic,Asset,Liability,Rental,Farming";
                SourceExpr=Type }

  }
  CODE
  {

    BEGIN
    END.
  }
}

