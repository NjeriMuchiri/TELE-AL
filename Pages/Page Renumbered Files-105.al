OBJECT page 20446 HR Medical Scheme Members List
{
  OBJECT-PROPERTIES
  {
    Date=02/26/18;
    Time=[ 3:32:48 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516109;
    PageType=List;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr="Scheme No" }

    { 1102755003;2;Field  ;
                SourceExpr="Employee No" }

    { 1102755004;2;Field  ;
                SourceExpr="First Name" }

    { 1102755005;2;Field  ;
                SourceExpr="Last Name" }

    { 1102755006;2;Field  ;
                SourceExpr=Designation }

    { 1102755007;2;Field  ;
                SourceExpr=Department;
                Visible=false }

    { 1102755008;2;Field  ;
                SourceExpr="Scheme Join Date" }

    { 1000000000;2;Field  ;
                SourceExpr="Out-Patient Limit" }

    { 1000000001;2;Field  ;
                SourceExpr="In-patient Limit" }

    { 1000000002;2;Field  ;
                SourceExpr="Maximum Cover" }

    { 1102755009;2;Field  ;
                SourceExpr="Cumm.Amount Spent" }

    { 1000000003;2;Field  ;
                SourceExpr="No Of Dependants" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

