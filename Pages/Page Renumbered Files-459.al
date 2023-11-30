OBJECT page 172054 Tranche List
{
  OBJECT-PROPERTIES
  {
    Date=02/18/22;
    Time=10:36:13 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516259;
    SourceTableView=WHERE(Disbursement Type=FILTER(Tranches),
                          Posted=FILTER(Yes));
    PageType=List;
    CardPageID=Tranche Card;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="No." }

    { 1120054003;2;Field  ;
                SourceExpr="Member Name" }

    { 1120054004;2;Field  ;
                SourceExpr="Amount to Refund" }

    { 1120054005;2;Field  ;
                SourceExpr="Total Amount Disbursed" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

