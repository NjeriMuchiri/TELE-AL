OBJECT page 50059 Teller & Treasury Trans List1
{
  OBJECT-PROPERTIES
  {
    Date=02/20/20;
    Time=[ 2:19:45 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table51516301;
    SourceTableView=WHERE(requested=FILTER(No));
    PageType=List;
    CardPageID=Teller & Treasury Trans Card2;
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 6   ;2   ;Field     ;
                SourceExpr=No;
                Editable=false }

    { 5   ;2   ;Field     ;
                Name=Teller;
                CaptionML=ENU=Teller;
                SourceExpr="To Account" }

    { 3   ;2   ;Field     ;
                CaptionML=ENU=Amount to Request;
                SourceExpr="Amount to request" }

    { 4   ;2   ;Field     ;
                Name=Date Requested;
                CaptionML=ENU=Date Requested;
                SourceExpr="Requested Date";
                Editable=false }

    { 2   ;2   ;Field     ;
                Name=Time Requested;
                CaptionML=ENU=Time Requested;
                SourceExpr="Requested Time";
                Editable=false }

    { 1   ;2   ;Field     ;
                Name=Requested;
                CaptionML=ENU=Requested;
                SourceExpr=requested;
                Enabled=false;
                Editable=false }

    { 1120054001;2;Field  ;
                SourceExpr="Date Posted" }

    { 1120054000;2;Field  ;
                SourceExpr="Transaction Date" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

