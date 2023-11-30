OBJECT page 172088 Mobile Banking Account List
{
  OBJECT-PROPERTIES
  {
    Date=12/17/20;
    Time=[ 7:06:29 AM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table23;
    SourceTableView=WHERE(Global Dimension 1 Code=CONST(FOSA),
                          Account Type=FILTER(<>FIXED),
                          Transactional Mobile No=FILTER(<>''));
    PageType=List;
    CardPageID=Account Card;
    ActionList=ACTIONS
    {
      { 1102755233;  ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755232;1 ;ActionGroup;
                      Name=Account;
                      CaptionML=ENU=Account }
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
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","BOSA Account No");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516223,TRUE,FALSE,Cust);
                               END;
                                }
      { 1102755222;2 ;Separator  }
      { 1102755220;1 ;ActionGroup }
      { 1102755217;2 ;Separator  }
      { 1102755216;2 ;Action    ;
                      Name=Page Vendor Statement;
                      CaptionML=ENU=Statement;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                   IF Vend."Company Code"='STAFF' THEN BEGIN
                                     IF "Staff UserID"<>USERID THEN
                                       ERROR('You Cannot view your Colleague statement for confidentiality purposes')
                                     ELSE
                                    REPORT.RUN(51516248,TRUE,FALSE,Vend);
                                    END;
                                 {
                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                 REPORT.RUN(,TRUE,FALSE,Vend)
                                 }
                                 {Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                 REPORT.RUN(51516248,TRUE,FALSE,Vend)
                                 }
                               END;
                                }
      { 1120054000;2 ;Action    ;
                      Name=view Statement;
                      CaptionML=ENU=view Statement;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN

                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                 REPORT.RUN(51516201,TRUE,FALSE,Vend)
                               END;
                                }
      { 1000000007;2 ;Action    ;
                      Name=Page Vendor Statement New;
                      CaptionML=ENU=Statement;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN

                                 Vend.RESET;
                                 Vend.SETRANGE(Vend."No.","No.");
                                 IF Vend.FIND('-') THEN
                                 REPORT.RUN(51516248,TRUE,FALSE,Vend)
                               END;
                                }
      { 1000000002;2 ;Action    ;
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
      { 1000000004;2 ;Separator  }
      { 1000000003;2 ;Action    ;
                      Name=Next Of Kin;
                      CaptionML=ENU=Next Of Kin;
                      RunObject=page 17435;
                      RunPageLink=Account No=FIELD(No.);
                      Promoted=Yes;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 1000000005;2 ;Action    ;
                      Name=FOSA Loans;
                      RunObject=page 17391;
                      RunPageLink=Account No=FIELD(No.),
                                  Source=FILTER(FOSA);
                      Promoted=Yes }
      { 1120054003;2 ;Action    ;
                      Name=PIN Reset;
                      RunObject=page 172072;
                      RunPageLink=Mobile No.=FIELD(Transactional Mobile No);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SalesTax;
                      PromotedCategory=Category4 }
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
                SourceExpr="No." }

    { 1000000000;2;Field  ;
                SourceExpr="Staff No" }

    { 1102755003;2;Field  ;
                SourceExpr=Name }

    { 1102755004;2;Field  ;
                SourceExpr="Search Name" }

    { 1102755137;2;Field  ;
                SourceExpr="Account Type" }

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

    { 1120054002;2;Field  ;
                SourceExpr="Transactional Mobile No" }

    { 1102755011;2;Field  ;
                SourceExpr="Mobile Phone No" }

    { 1102755012;2;Field  ;
                SourceExpr="Phone No." }

    { 1000000001;2;Field  ;
                Name=AvailableBal;
                SourceExpr=SFactory.FnGetAccountAvailableBalance("No.");
                Editable=FALSE }

    { 1000000006;2;Field  ;
                SourceExpr=Blocked }

    { 1120054001;2;Field  ;
                SourceExpr="Salary earner" }

    { 1120054004;2;Field  ;
                SourceExpr="Vendor Posting Group" }

  }
  CODE
  {
    VAR
      CalendarMgmt@1000000041 : Codeunit 7600;
      PaymentToleranceMgt@1000000040 : Codeunit 426;
      CustomizedCalEntry@1000000039 : Record 7603;
      CustomizedCalendar@1000000038 : Record 7602;
      PictureExists@1000000037 : Boolean;
      AccountTypes@1000000036 : Record 51516295;
      GenJournalLine@1000000035 : Record 81;
      GLPosting@1000000034 : Codeunit 12;
      StatusPermissions@1000000033 : Record 51516310;
      Charges@1000000032 : Record 51516297;
      ForfeitInterest@1000000031 : Boolean;
      InterestBuffer@1000000030 : Record 51516324;
      FDType@1000000029 : Record 51516305;
      Vend@1000000028 : Record 23;
      Cust@1000000027 : Record 51516223;
      LineNo@1000000026 : Integer;
      UsersID@1000000025 : Record 2000000120;
      DActivity@1000000024 : Code[20];
      DBranch@1000000023 : Code[20];
      MinBalance@1000000022 : Decimal;
      OBalance@1000000021 : Decimal;
      OInterest@1000000020 : Decimal;
      Gnljnline@1000000019 : Record 81;
      TotalRecovered@1000000018 : Decimal;
      LoansR@1000000017 : Record 51516230;
      LoanAllocation@1000000016 : Decimal;
      LGurantors@1000000015 : Record 51516319;
      Loans@1000000014 : Record 51516230;
      DefaulterType@1000000013 : Code[20];
      LastWithdrawalDate@1000000012 : Date;
      AccountType@1000000011 : Record 51516295;
      ReplCharge@1000000010 : Decimal;
      Acc@1000000009 : Record 23;
      SearchAcc@1000000008 : Code[10];
      Searchfee@1000000007 : Decimal;
      Statuschange@1000000006 : Record 51516310;
      UnclearedLoan@1000000005 : Decimal;
      LineN@1000000004 : Integer;
      OBal@1000000003 : Decimal;
      RunBal@1000000002 : Decimal;
      AvailableBal@1000000001 : Decimal;
      GenSetup@1000000000 : Record 51516257;
      SFactory@1120054000 : Codeunit 51516022;

    BEGIN
    END.
  }
}

