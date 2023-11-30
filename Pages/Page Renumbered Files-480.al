OBJECT page 172075 Virtual Member Reg Buffer
{
  OBJECT-PROPERTIES
  {
    Date=12/02/20;
    Time=[ 5:29:06 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    SourceTable=Table51516719;
    PageType=List;
    ActionList=ACTIONS
    {
      { 10      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 11      ;1   ;Action    ;
                      Name=View Referee;
                      OnAction=VAR
                                 Members@1000 : Record 51516223;
                               BEGIN
                                 Members.RESET;
                                 Members.SETRANGE(Members."No.", "Referee Member Number");
                                 PAGE.RUNMODAL(PAGE::"Member Account Card",Members);
                               END;
                                }
      { 4       ;1   ;Action    ;
                      Name=Show Report;
                      OnAction=BEGIN

                                 //50061
                                 VMember.RESET;
                                 VMember.SETRANGE("Entry Number","Entry Number");
                                 IF VMember.FINDFIRST THEN
                                     REPORT.RUN(50061,TRUE,FALSE,VMember);
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

    { 12  ;2   ;Field     ;
                SourceExpr=Name }

    { 5   ;2   ;Field     ;
                SourceExpr="Mobile Number" }

    { 6   ;2   ;Field     ;
                SourceExpr="National ID Number" }

    { 8   ;2   ;Field     ;
                SourceExpr="Date of Birth" }

    { 7   ;2   ;Field     ;
                SourceExpr="Date Created" }

    { 9   ;2   ;Field     ;
                SourceExpr="Referee Name" }

    { 3   ;2   ;Field     ;
                SourceExpr="Referee Member Number" }

  }
  CODE
  {
    VAR
      VMember@1000 : Record 51516719;

    BEGIN
    END.
  }
}

