OBJECT page 172043 Add Mbanking Numbers
{
  OBJECT-PROPERTIES
  {
    Date=12/06/21;
    Time=[ 4:52:43 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516727;
    PageType=List;
    OnInit=BEGIN
             Permission.RESET;
             Permission.SETRANGE("User ID",USERID);
             Permission.SETRANGE("T-Kash Accounts",TRUE);
             IF NOT Permission.FINDFIRST THEN
               ERROR('You do not have the following permission to View or Edit this Page');
           END;

  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Account No." }

    { 1120054003;2;Field  ;
                SourceExpr="Phone No." }

    { 1120054004;2;Field  ;
                SourceExpr=Operator }

  }
  CODE
  {
    VAR
      Permission@1120054000 : Record 51516702;

    BEGIN
    END.
  }
}

