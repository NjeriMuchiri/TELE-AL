OBJECT page 172135 HR Leave Types
{
  OBJECT-PROPERTIES
  {
    Date=11/16/17;
    Time=10:37:11 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516193;
    PageType=List;
    CardPageID=HR Leave Types Card;
    OnInit=BEGIN
             CurrPage.LOOKUPMODE := TRUE;
           END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                Editable=FALSE;
                GroupType=Repeater }

    { 1000000001;2;Field  ;
                SourceExpr=Code;
                Style=StandardAccent;
                StyleExpr=TRUE }

    { 1000000003;2;Field  ;
                SourceExpr=Description }

    { 1000000005;2;Field  ;
                SourceExpr=Days }

    { 1102755002;2;Field  ;
                SourceExpr=Gender }

    { 1102755000;2;Field  ;
                SourceExpr="Max Carry Forward Days" }

    { 1000000007;2;Field  ;
                SourceExpr="Inclusive of Non Working Days" }

    { 1000000006;2;Field  ;
                SourceExpr="Inclusive of Saturday" }

    { 1000000004;2;Field  ;
                SourceExpr="Inclusive of Sunday" }

    { 1000000002;2;Field  ;
                SourceExpr="Inclusive of Holidays" }

    { 1102755001;;Container;
                ContainerType=FactBoxArea }

    { 1102755003;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

    { 1102755004;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

