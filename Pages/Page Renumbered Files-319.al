OBJECT page 50010 Account Details-editable
{
  OBJECT-PROPERTIES
  {
    Date=11/15/17;
    Time=[ 7:05:06 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    DeleteAllowed=No;
    SourceTable=Table23;
    PageType=List;
    CardPageID=Account Card-editable;
    OnOpenPage=BEGIN
                 {
                 StatusPermissions.RESET;
                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::Edit);
                 IF StatusPermissions.FIND('-') = FALSE THEN
                 ERROR('You do not have permissions to edit member account,please contact systems administrator');
                 }

                 IF "Company Code"='STAFF' THEN BEGIN

                   IF "Staff UserID"<>USERID THEN
                     ERROR('You do not have permissions to view another Staff account detail.');
                     CurrPage.CLOSE;
                   END;

               END;

    ActionList=ACTIONS
    {
      { 1102755233;  ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755232;1 ;ActionGroup;
                      Name=Account;
                      CaptionML=ENU=Account }
      { 1102755231;2 ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=ENU=Ledger E&ntries;
                      RunObject=20375;
                      RunPageView=SORTING(Vendor No.);
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=VendorLedger }
      { 1102755230;2 ;Action    ;
                      CaptionML=ENU=Co&mments;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Vendor),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1102755229;2 ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=ENU=Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(23),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 1102755228;2 ;Separator  }
      { 1102755226;2 ;Separator  }
      { 1102755225;2 ;Separator  }
      { 1102755224;2 ;Action    ;
                      CaptionML=ENU=Member Page;
                      RunObject=page 17365;
                      RunPageLink=Field1=FIELD(BOSA Account No);
                      Promoted=Yes;
                      Image=Planning;
                      PromotedCategory=Process }
      { 1102755223;2 ;Action    ;
                      Name=<Action11027600800>;
                      CaptionML=ENU=Loans Statements;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 {Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(,TRUE,TRUE,Cust)
                                 }
                               END;
                                }
      { 1102755222;2 ;Separator  }
      { 1102755220;1 ;ActionGroup }
      { 1102755219;2 ;Action    ;
                      Name=Next Of Kin;
                      CaptionML=ENU=Next Of Kin;
                      RunObject=page 17435;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 1102755217;2 ;Separator  }
      { 1102755216;2 ;Action    ;
                      Name=Page Vendor Statement;
                      CaptionML=ENU=Statement;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 {
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                 REPORT.RUN(,TRUE,FALSE,Vend)
                                 }
                               END;
                                }
      { 1102755215;2 ;Action    ;
                      Name=Page Vendor Statistics;
                      ShortCutKey=F7;
                      CaptionML=ENU=Statistics;
                      RunObject=Page 152;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1102755000;0;Container;
                ContainerType=ContentArea }

    { 1102755001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1102755002;2;Field  ;
                SourceExpr="No.";
                Editable=false }

    { 1102755003;2;Field  ;
                SourceExpr=Name }

    { 1102755004;2;Field  ;
                SourceExpr="Search Name" }

    { 1102755137;2;Field  ;
                SourceExpr="Account Type" }

    { 1000000000;2;Field  ;
                SourceExpr="Vendor Posting Group" }

    { 1102755166;2;Field  ;
                SourceExpr="Salary Processing" }

    { 1102755005;2;Field  ;
                SourceExpr="Global Dimension 2 Code" }

    { 1102755006;2;Field  ;
                Name=ATM No.";
                CaptionML=ENU=ATM No.;
                SourceExpr="ATM No." }

    { 1102755007;2;Field  ;
                CaptionML=ENU=Member No.;
                SourceExpr="BOSA Account No" }

    { 1102755008;2;Field  ;
                SourceExpr="ID No." }

    { 1102755009;2;Field  ;
                SourceExpr=Balance }

    { 1102755010;2;Field  ;
                SourceExpr="Company Code" }

    { 1102755011;2;Field  ;
                SourceExpr="Mobile Phone No" }

    { 1102755012;2;Field  ;
                SourceExpr="Phone No." }

    { 1000000001;2;Field  ;
                SourceExpr="Disabled ATM Card No" }

  }
  CODE
  {
    VAR
      Cust@1102755000 : Record 51516223;
      Vend@1102755001 : Record 23;
      StatusPermissions@1000000000 : Record 51516310;

    BEGIN
    END.
  }
}

