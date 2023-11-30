OBJECT page 172091 Ready ATM Cards
{
  OBJECT-PROPERTIES
  {
    Date=02/25/22;
    Time=[ 1:05:45 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516321;
    SourceTableView=WHERE(Status=CONST(Approved),
                          Card Received=CONST(Yes));
    PageType=List;
    CardPageID=Ready ATM Card;
  }
  CONTROLS
  {
    { 16  ;0   ;Container ;
                ContainerType=ContentArea }

    { 15  ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 14  ;2   ;Field     ;
                SourceExpr="No." }

    { 13  ;2   ;Field     ;
                SourceExpr="Request Type" }

    { 12  ;2   ;Field     ;
                SourceExpr="Account No" }

    { 9   ;2   ;Field     ;
                SourceExpr="Account Name" }

    { 1120054014;2;Field  ;
                SourceExpr="Staff No" }

    { 1120054000;2;Field  ;
                SourceExpr="Application Date" }

    { 1120054009;2;Field  ;
                SourceExpr="Card Status" }

    { 1120054008;2;Field  ;
                SourceExpr=Status }

    { 1120054010;2;Field  ;
                SourceExpr="ID No" }

    { 1120054004;2;Field  ;
                SourceExpr="Phone No." }

    { 1120054001;2;Field  ;
                SourceExpr="Card No" }

    { 1120054002;2;Field  ;
                SourceExpr="Date Issued" }

    { 1120054003;2;Field  ;
                SourceExpr=Limit }

    { 1120054006;2;Field  ;
                SourceExpr="Date Collected" }

    { 1120054007;2;Field  ;
                SourceExpr="Card Issued By" }

    { 1120054005;2;Field  ;
                SourceExpr="Replacement For Card No" }

    { 1120054011;2;Field  ;
                SourceExpr="ATM Card Linked" }

    { 1120054012;2;Field  ;
                SourceExpr="ATM Card Linked By" }

    { 1120054013;2;Field  ;
                SourceExpr="ATM Card Linked On" }

    { 1120054015;2;Field  ;
                SourceExpr=Reason }

  }
  CODE
  {

    BEGIN
    END.
  }
}

