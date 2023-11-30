OBJECT page 17374 Member List-Editable
{
  OBJECT-PROPERTIES
  {
    Date=12/20/18;
    Time=[ 9:25:27 AM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=ENU=Member List;
    InsertAllowed=No;
    SourceTable=Table51516223;
    SourceTableView=WHERE(Customer Type=FILTER(Member|MicroFinance));
    PageType=List;
    CardPageID=Member Account Card - Editable;
    OnOpenPage=BEGIN
                 StatusPermissions.RESET;
                 StatusPermissions.SETRANGE(StatusPermissions."User Id",USERID);
                 StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::Edit);
                 IF StatusPermissions.FIND('-') = FALSE THEN
                 ERROR('You do not have permissions to edit member information.');
               END;

    ActionList=ACTIONS
    {
      { 20      ;    ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 19      ;1   ;ActionGroup }
      { 18      ;2   ;Action    ;
                      Name=Member Ledger Entries;
                      CaptionML=ENU=Member Ledger Entries;
                      RunObject=Page 51516160;
                      RunPageView=SORTING(Field3);
                      RunPageLink=Field3=FIELD(No.);
                      Promoted=Yes;
                      Image=CustomerLedger;
                      PromotedCategory=Process }
      { 17      ;2   ;Action    ;
                      Name=Dimensions;
                      RunObject=Page 540;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process }
      { 16      ;2   ;Action    ;
                      Name=Bank Account;
                      RunObject=Page 423;
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=Yes;
                      Image=BankAccount;
                      PromotedCategory=Process }
      { 15      ;2   ;Action    ;
                      Name=Contacts;
                      Promoted=Yes;
                      Image=SendTo;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowContact;
                               END;
                                }
      { 14      ;1   ;ActionGroup;
                      CaptionML=ENU=Issued Documents;
                      Visible=FALSE }
      { 13      ;2   ;Action    ;
                      Name=Loans Guaranteed;
                      CaptionML=ENU=Loans Guarantors;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN

                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516155,TRUE,FALSE,Cust);
                               END;
                                }
      { 12      ;2   ;Action    ;
                      Name=Loans Guarantors;
                      CaptionML=ENU=Loans Guaranteed;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(51516156,TRUE,FALSE,Cust);
                               END;
                                }
      { 11      ;1   ;ActionGroup }
      { 10      ;2   ;Action    ;
                      CaptionML=ENU=Next Of Kin;
                      RunObject=Page 51516161;
                      RunPageLink=Field10=FIELD(No.);
                      Promoted=Yes;
                      Image=Relationship;
                      PromotedCategory=Process }
      { 9       ;2   ;Action    ;
                      Name=Members Statistics;
                      RunObject=page 17366;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 8       ;2   ;Action    ;
                      Name=Members Guaranteed;
                      RunObject=page 20470;
                      RunPageLink=Middle Name=FIELD(Name);
                      Promoted=Yes;
                      PromotedCategory=Process;
                      RunPageMode=View;
                      OnAction=BEGIN
                                 LGurantors.RESET;
                                 LGurantors.SETRANGE(LGurantors."Loan No","No.");
                                 IF LGurantors.FIND('-') THEN
                               END;
                                }
      { 7       ;2   ;Separator  }
      { 6       ;1   ;ActionGroup }
      { 5       ;2   ;Action    ;
                      Name=Statement;
                      CaptionML=ENU=Detailed Statement;
                      Promoted=Yes;
                      Image=Customer;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(50031,TRUE,FALSE,Cust);
                               END;
                                }
      { 3       ;2   ;Action    ;
                      Name=Account Closure Slip;
                      CaptionML=ENU=Account Closure Slip;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Report;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Cust.RESET;
                                 Cust.SETRANGE(Cust."No.","No.");
                                 IF Cust.FIND('-') THEN
                                 REPORT.RUN(50033,TRUE,FALSE,Cust);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                SourceExpr="No." }

    { 1000000000;2;Field  ;
                SourceExpr="Old Account No." }

    { 4   ;2   ;Field     ;
                SourceExpr=Name }

    { 1102755026;2;Field  ;
                SourceExpr="ID No." }

    { 21  ;2   ;Field     ;
                SourceExpr="Mobile Phone No" }

    { 22  ;2   ;Field     ;
                SourceExpr="Payroll/Staff No" }

    { 1000000001;2;Field  ;
                SourceExpr="FOSA Account" }

    { 1000000002;2;Field  ;
                SourceExpr="Employer Code" }

  }
  CODE
  {
    VAR
      Cust@1021 : Record 51516223;
      GeneralSetup@1020 : Record 51516257;
      Gnljnline@1019 : Record 81;
      TotalRecovered@1018 : Decimal;
      TotalAvailable@1017 : Integer;
      Loans@1016 : Record 51516230;
      TotalFOSALoan@1015 : Decimal;
      TotalOustanding@1014 : Decimal;
      Vend@1013 : Record 23;
      TotalDefaulterR@1012 : Decimal;
      Value2@1011 : Decimal;
      AvailableShares@1010 : Decimal;
      Value1@1009 : Decimal;
      Interest@1008 : Decimal;
      LineN@1007 : Integer;
      LRepayment@1006 : Decimal;
      RoundingDiff@1005 : Decimal;
      DActivity@1004 : Code[20];
      DBranch@1003 : Code[20];
      LoansR@1002 : Record 51516230;
      LoanAllocation@1001 : Decimal;
      LGurantors@1000 : Record 51516231;
      StatusPermissions@1000000000 : Record 51516310;

    PROCEDURE GetSelectionFilter@2() : Code[80];
    VAR
      Cust@1000 : Record 51516223;
      FirstCust@1001 : Code[30];
      LastCust@1002 : Code[30];
      SelectionFilter@1003 : Code[250];
      CustCount@1004 : Integer;
      More@1005 : Boolean;
    BEGIN
      {CurrPage.SETSELECTIONFILTER(Cust);
      CustCount := Cust.COUNT;
      IF CustCount > 0 THEN BEGIN
        Cust.FIND('-');
        WHILE CustCount > 0 DO BEGIN
          CustCount := CustCount - 1;
          Cust.MARKEDONLY(FALSE);
          FirstCust := Cust."No.";
          LastCust := FirstCust;
          More := (CustCount > 0);
          WHILE More DO
            IF Cust.NEXT = 0 THEN
              More := FALSE
            ELSE
              IF NOT Cust.MARK THEN
                More := FALSE
              ELSE BEGIN
                LastCust := Cust."No.";
                CustCount := CustCount - 1;
                IF CustCount = 0 THEN
                  More := FALSE;
              END;
          IF SelectionFilter <> '' THEN
            SelectionFilter := SelectionFilter + '|';
          IF FirstCust = LastCust THEN
            SelectionFilter := SelectionFilter + FirstCust
          ELSE
            SelectionFilter := SelectionFilter + FirstCust + '..' + LastCust;
          IF CustCount > 0 THEN BEGIN
            Cust.MARKEDONLY(TRUE);
            Cust.NEXT;
          END;
        END;
      END;
      EXIT(SelectionFilter);
      }
    END;

    PROCEDURE SetSelection@1(VAR Cust@1000 : Record 51516223);
    BEGIN
      //CurrPage.SETSELECTIONFILTER(Cust);
    END;

    BEGIN
    END.
  }
}

