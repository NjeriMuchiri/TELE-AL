OBJECT page 172151 HR Job Responsiblities Lines
{
  OBJECT-PROPERTIES
  {
    Date=11/21/17;
    Time=11:40:36 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516102;
    PageType=List;
    CardPageID=hr job responsibilities card;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                GroupType=Repeater }

    { 1102755000;2;Field  ;
                SourceExpr="Responsibility Code";
                Editable=false }

    { 1102755002;2;Field  ;
                SourceExpr="Responsibility Description";
                Enabled=false }

    { 1102755001;2;Field  ;
                SourceExpr=Remarks;
                Editable=false }

  }
  CODE
  {

    BEGIN
    END.
  }
}

