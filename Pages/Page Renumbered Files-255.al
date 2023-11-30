OBJECT page 17446 Standing Order Register
{
  OBJECT-PROPERTIES
  {
    Date=05/16/16;
    Time=[ 3:37:39 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516308;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102760023;1 ;Action    ;
                      Name=Statement;
                      CaptionML=ENU=Print;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 //REPORT.RUN(,TRUE,TRUE)
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 16  ;2   ;Field     ;
                SourceExpr="Register No." }

    { 15  ;2   ;Field     ;
                SourceExpr=Date }

    { 14  ;2   ;Field     ;
                SourceExpr="Source Account No." }

    { 13  ;2   ;Field     ;
                SourceExpr="Account Name" }

    { 12  ;2   ;Field     ;
                SourceExpr="Destination Account Type" }

    { 11  ;2   ;Field     ;
                SourceExpr="Destination Account No." }

    { 10  ;2   ;Field     ;
                SourceExpr="Destination Account Name" }

    { 9   ;2   ;Field     ;
                SourceExpr="Don't Allow Partial Deduction" }

    { 8   ;2   ;Field     ;
                SourceExpr="Deduction Status" }

    { 7   ;2   ;Field     ;
                SourceExpr=Amount }

    { 6   ;2   ;Field     ;
                SourceExpr="Amount Deducted" }

    { 5   ;2   ;Field     ;
                CaptionML=ENU=Balance;
                SourceExpr=Amount-"Amount Deducted" }

    { 4   ;2   ;Field     ;
                SourceExpr=Remarks }

    { 3   ;2   ;Field     ;
                SourceExpr=EFT }

    { 2   ;2   ;Field     ;
                SourceExpr="Transfered to EFT" }

    { 1   ;2   ;Field     ;
                SourceExpr="Standing Order No." }

  }
  CODE
  {

    BEGIN
    END.
  }
}

