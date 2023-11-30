OBJECT page 17467 Supervisor Approvals Levels
{
  OBJECT-PROPERTIES
  {
    Date=05/09/16;
    Time=11:52:19 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516309;
    PageType=List;
  }
  CONTROLS
  {
    { 5   ;0   ;Container ;
                ContainerType=ContentArea }

    { 4   ;1   ;Group     ;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                CaptionML=[ENU=User ID;
                           ESM=Id. usuario;
                           FRC=Code utilisateur;
                           ENC=User ID];
                SourceExpr=SupervisorID }

    { 2   ;2   ;Field     ;
                SourceExpr="Transaction Type" }

    { 1   ;2   ;Field     ;
                SourceExpr="Maximum Approval Amount" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

