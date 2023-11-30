OBJECT page 17401 Bosa Receipts H List-Checkoff
{
  OBJECT-PROPERTIES
  {
    Date=10/14/15;
    Time=[ 6:09:47 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516248;
    SourceTableView=WHERE(Posted=FILTER(No));
    PageType=List;
    CardPageID=Bosa Receipts H Card-Checkoff;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr=No }

    { 1102755003;2;Field  ;
                SourceExpr="Posted By" }

    { 1102755004;2;Field  ;
                SourceExpr="Account No" }

    { 1102755005;2;Field  ;
                SourceExpr="Document No" }

    { 1102755006;2;Field  ;
                SourceExpr=Amount }

    { 1102755007;2;Field  ;
                SourceExpr="Scheduled Amount" }

    { 1102755008;2;Field  ;
                SourceExpr="Account Name" }

    { 1102755009;2;Field  ;
                SourceExpr="Employer Code" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

