OBJECT page 50053 HR Shortlisting List
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=12:08:14 PM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516103;
    SourceTableView=WHERE(Status=CONST(Approved),
                          Closed=CONST(No));
    PageType=List;
    CardPageID=HR Shortlisting Card;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000003;2;Field  ;
                SourceExpr="Requisition No." }

    { 1102755007;2;Field  ;
                SourceExpr="Job Description" }

    { 1102755003;2;Field  ;
                SourceExpr="Requisition Date" }

    { 1102755002;2;Field  ;
                SourceExpr=Requestor }

    { 1102755008;2;Field  ;
                SourceExpr="Reason For Request" }

    { 1000000000;2;Field  ;
                SourceExpr=Closed }

    { 1000000001;2;Field  ;
                SourceExpr="Closing Date" }

    { 1102755004;;Container;
                ContainerType=FactBoxArea }

    { 1102755006;1;Part   ;
                SubPageLink=Job ID=FIELD(Job ID);
                PagePartID=Page51516884;
                PartType=Page }

    { 1102755005;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {

    BEGIN
    END.
  }
}

