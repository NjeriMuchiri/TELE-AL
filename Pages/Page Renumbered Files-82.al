OBJECT page 20423 Imprest List
{
  OBJECT-PROPERTIES
  {
    Date=03/17/22;
    Time=[ 5:58:28 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=ENU=Staff Travel  List;
    SourceTable=Table51516006;
    SourceTableView=WHERE(Payee=CONST(No));
    PageType=List;
    CardPageID=DIvidends Progression;
    OnOpenPage=BEGIN
                 //SETRANGE("Document Type",USERID );
               END;

    ActionList=ACTIONS
    {
      { 1000000000;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1000000001;1 ;Action    ;
                      Name=Print/Preview;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 ImprestHeader.RESET;
                                 ImprestHeader.SETRANGE(ImprestHeader."No.","No.");
                                 REPORT.RUN(51516130,TRUE,FALSE, ImprestHeader);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                GroupType=Repeater }

  }
  CODE
  {
    VAR
      ImprestHeader@1000000000 : Record 51516006;

    BEGIN
    END.
  }
}

