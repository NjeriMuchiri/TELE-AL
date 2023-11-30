OBJECT page 17479 ATM Log Entries
{
  OBJECT-PROPERTIES
  {
    Date=02/25/22;
    Time=12:02:38 PM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516322;
    PageType=List;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054005;2;Field  ;
                SourceExpr="Entry No" }

    { 1120054000;2;Field  ;
                SourceExpr="Trace ID" }

    { 1120054001;2;Field  ;
                SourceExpr="Account No." }

    { 1120054002;2;Field  ;
                SourceExpr="Card No." }

    { 1120054004;2;Field  ;
                SourceExpr=Amount }

    { 1120054003;2;Field  ;
                SourceExpr="ATM Amount" }

    { 1000000003;2;Field  ;
                SourceExpr="Date Time" }

    { 1000000006;2;Field  ;
                SourceExpr="ATM No" }

    { 1000000007;2;Field  ;
                SourceExpr="ATM Location" }

    { 1000000008;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1000000009;2;Field  ;
                SourceExpr="Return Code" }

    { 1000000014;2;Field  ;
                SourceExpr="Withdrawal Location" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

