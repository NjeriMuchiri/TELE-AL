OBJECT page 172150 HR Lookup Values List
{
  OBJECT-PROPERTIES
  {
    Date=11/21/17;
    Time=10:46:14 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516163;
    PageType=List;
    CardPageID=HR Lookup Values Card;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                Editable=TRUE;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr=Type;
                Enabled=false }

    { 1102755003;2;Field  ;
                SourceExpr=Code;
                Enabled=false }

    { 1102755005;2;Field  ;
                SourceExpr=Description;
                Editable=false }

  }
  CODE
  {

    BEGIN
    END.
  }
}

