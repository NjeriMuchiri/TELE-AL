OBJECT page 172076 Rejecected Mobile ODs
{
  OBJECT-PROPERTIES
  {
    Date=07/02/21;
    Time=11:03:19 AM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516713;
    SourceTableView=WHERE(Status=CONST(Failed),
                          Loan Product Type=CONST(M_OD));
    PageType=List;
    ActionList=ACTIONS
    {
      { 13      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 14      ;1   ;Action    ;
                      Name=Activate/Deactivate Application;
                      OnAction=BEGIN

                                 TESTFIELD(Posted,FALSE);
                                 IF Deactivated THEN BEGIN
                                     IF CONFIRM('Are you sure you want to deactivate this application') THEN BEGIN
                                         Deactivated := FALSE;
                                         "Deactivated By":=USERID;
                                         "Date Deactivated":=TODAY;
                                         MODIFY;
                                     END;
                                 END
                                 ELSE BEGIN
                                     IF CONFIRM('Are you sure you want to activate this application') THEN BEGIN
                                         Deactivated := TRUE;
                                         "Deactivated By":=USERID;
                                         "Date Deactivated":=TODAY;
                                         MODIFY;
                                     END;
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                SourceExpr="Entry No" }

    { 4   ;2   ;Field     ;
                SourceExpr="Account No" }

    { 1120054000;2;Field  ;
                SourceExpr="Staff No." }

    { 12  ;2   ;Field     ;
                SourceExpr=Name }

    { 5   ;2   ;Field     ;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                SourceExpr="Requested Amount" }

    { 7   ;2   ;Field     ;
                SourceExpr=Posted }

    { 8   ;2   ;Field     ;
                SourceExpr=Status }

    { 9   ;2   ;Field     ;
                SourceExpr="Date Posted" }

    { 10  ;2   ;Field     ;
                SourceExpr=Remarks }

    { 11  ;2   ;Field     ;
                SourceExpr=DocumentNo }

    { 16  ;2   ;Field     ;
                SourceExpr="Approved Amount" }

    { 18  ;2   ;Field     ;
                SourceExpr="Loan Product Type" }

    { 19  ;2   ;Field     ;
                SourceExpr=Amount }

    { 20  ;2   ;Field     ;
                SourceExpr="Session ID" }

    { 21  ;2   ;Field     ;
                SourceExpr="Date Entered" }

    { 22  ;2   ;Field     ;
                SourceExpr="Time Entered" }

    { 23  ;2   ;Field     ;
                SourceExpr="Telephone No" }

    { 24  ;2   ;Field     ;
                SourceExpr=Message }

    { 25  ;2   ;Field     ;
                SourceExpr="Member No." }

    { 15  ;2   ;Field     ;
                SourceExpr=Deactivated }

    { 17  ;2   ;Field     ;
                SourceExpr="Deactivated By" }

    { 26  ;2   ;Field     ;
                SourceExpr="Date Deactivated" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

