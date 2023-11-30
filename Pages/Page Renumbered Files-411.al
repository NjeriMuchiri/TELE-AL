OBJECT page 172006 Posted Co-Operative Dividends
{
  OBJECT-PROPERTIES
  {
    Date=12/08/20;
    Time=12:34:50 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516913;
    SourceTableView=SORTING(Member No,Start Date,Year)
                    WHERE(Posted=CONST(Yes));
    PageType=List;
    ActionList=ACTIONS
    {
      { 1120054014;  ;ActionContainer;
                      CaptionML=ENU=New;
                      ActionContainerType=NewDocumentItems }
      { 1120054015;1 ;ActionGroup }
      { 1120054016;2 ;Action    ;
                      Name=Dividend Slip;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MembersRegister@1120054000 : Record 51516223;
                               BEGIN
                                 MembersRegister.RESET;
                                 MembersRegister.SETRANGE(MembersRegister."No.","Member No");
                                 IF MembersRegister.FINDFIRST THEN
                                   REPORT.RUN(51516024,TRUE,FALSE,MembersRegister);
                               END;
                                }
      { 1120054022;2 ;Action    ;
                      Name=Dividend Register;
                      RunObject=Report 51516023;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MembersRegister@1120054000 : Record 51516223;
                               BEGIN
                               END;
                                }
      { 1120054018;2 ;Action    ;
                      Name=Generate Dividends;
                      RunObject=Report 51516019;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=GetEntries;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MembersRegister@1120054000 : Record 51516223;
                               BEGIN
                               END;
                                }
      { 1120054017;2 ;Action    ;
                      Name=Post Dividends;
                      RunObject=Report 51516020;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostBatch;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MembersRegister@1120054000 : Record 51516223;
                               BEGIN
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Member No" }

    { 1120054013;2;Field  ;
                SourceExpr="Member Name" }

    { 1120054003;2;Field  ;
                SourceExpr="Start Date" }

    { 1120054004;2;Field  ;
                SourceExpr="End Date" }

    { 1120054005;2;Field  ;
                SourceExpr=Year }

    { 1120054010;2;Field  ;
                SourceExpr=Shares }

    { 1120054009;2;Field  ;
                SourceExpr="Qualifying Shares" }

    { 1120054006;2;Field  ;
                SourceExpr="Gross Dividends" }

    { 1120054007;2;Field  ;
                SourceExpr="Witholding Tax" }

    { 1120054008;2;Field  ;
                SourceExpr="Net Dividends" }

    { 1120054011;2;Field  ;
                SourceExpr="Date Entered" }

    { 1120054012;2;Field  ;
                SourceExpr="Processed By" }

    { 1120054019;2;Field  ;
                SourceExpr=Posted }

    { 1120054020;2;Field  ;
                SourceExpr="Posted By" }

    { 1120054021;2;Field  ;
                SourceExpr="Posted On" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

