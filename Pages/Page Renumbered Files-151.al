OBJECT page 20492 File Request List
{
  OBJECT-PROPERTIES
  {
    Date=07/22/20;
    Time=[ 4:28:29 PM];
    Modified=Yes;
    Version List=File Movement Beta(Suretep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=Yes;
    DeleteAllowed=No;
    ModifyAllowed=Yes;
    SourceTable=Table51516400;
    PageType=List;
    CardPageID=File Request Header;
    OnOpenPage=BEGIN
                 //user.GET(USERID);
                  //FILTERGROUP(10);
                 //SETRANGE("User ID",USERID);
                 //IF user."Member Registration" = TRUE THEN
                  // ERROR('You do not have access to this page please contact the system administration')
                 //ELSE
                 //  EXIT;
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

    { 1000000022;2;Field  ;
                SourceExpr="Issuing File Location" }

  }
  CODE
  {
    VAR
      user@1000 : Record 91;

    BEGIN
    END.
  }
}

