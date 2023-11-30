OBJECT page 20494 File Movement List
{
  OBJECT-PROPERTIES
  {
    Date=07/22/20;
    Time=[ 4:28:07 PM];
    Modified=Yes;
    Version List=File Movement Beta(Suretep Systems);
  }
  PROPERTIES
  {
    InsertAllowed=Yes;
    DeleteAllowed=No;
    ModifyAllowed=Yes;
    SourceTable=Table51516400;
    SourceTableView=WHERE(Posted=FILTER(No));
    PageType=List;
    CardPageID=File Movement Header;
    OnOpenPage=BEGIN
                 //userset.GET(USERID);
                 //IF userset."Member Registration" = FALSE THEN
                   //ERROR('You do not have access to this page please contact system admin')
                 //ELSE
                  // EXIT;
               END;

  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr="No." }

    { 1   ;2   ;Field     ;
                SourceExpr="Member No" }

    { 1000000007;2;Field  ;
                SourceExpr="Date Requested" }

    { 1000000008;2;Field  ;
                SourceExpr="Requested By" }

    { 1000000009;2;Field  ;
                SourceExpr="Date Retrieved" }

    { 1000000010;2;Field  ;
                SourceExpr="Responsiblity Center" }

    { 1000000011;2;Field  ;
                SourceExpr="Expected Return Date" }

    { 1000000012;2;Field  ;
                SourceExpr="Duration Requested" }

    { 1000000013;2;Field  ;
                SourceExpr="Date Returned" }

    { 1000000014;2;Field  ;
                SourceExpr="File Location" }

    { 1000000015;2;Field  ;
                SourceExpr="Current File Location" }

    { 1000000016;2;Field  ;
                SourceExpr="Retrieved By" }

    { 1000000017;2;Field  ;
                SourceExpr="Returned By" }

    { 1000000018;2;Field  ;
                SourceExpr="Global Dimension 1 Code" }

    { 1000000019;2;Field  ;
                SourceExpr="Global Dimension 2 Code" }

    { 1000000021;2;Field  ;
                SourceExpr="User ID" }

  }
  CODE
  {
    VAR
      userset@1000 : Record 91;

    BEGIN
    END.
  }
}

