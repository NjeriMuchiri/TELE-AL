OBJECT page 172074 Sky Paybil Transactions
{
  OBJECT-PROPERTIES
  {
    Date=11/23/20;
    Time=12:49:12 PM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516712;
    SourceTableView=SORTING(Date Captured)
                    ORDER(Descending)
                    WHERE(Transaction Type=FILTER(Paybill));
    PageType=List;
    ActionList=ACTIONS
    {
      { 32      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 33      ;1   ;Action    ;
                      Name=Update Paybill;
                      RunObject=Page 63020;
                      RunPageLink=Field40=FIELD(Entry No.) }
      { 34      ;1   ;Action    ;
                      Name=Needs Change;
                      OnAction=VAR
                                 StatusChangePermissions@1000 : Record 51516702;
                               BEGIN
                                 StatusChangePermissions.RESET;
                                 StatusChangePermissions.SETRANGE("User ID",USERID);
                                 StatusChangePermissions.SETRANGE("Update Paybill Transaction",TRUE);
                                 IF NOT StatusChangePermissions.FINDFIRST THEN
                                   ERROR('You do not have the following permission: "Update Paybill Transaction"');

                                 TESTFIELD(Posted,FALSE);
                                 IF CONFIRM('Are you sure you want to mark this transaction as needs change?') THEN BEGIN
                                     "Needs Change" := TRUE;
                                     MODIFY;
                                 END;
                               END;
                                }
      { 40      ;1   ;Action    ;
                      Name=Receipt;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 BLedger.RESET;
                                 BLedger.SETRANGE("Document No.",Rec."Transaction ID");
                                 IF BLedger.FINDFIRST THEN
                                     REPORT.RUN(71003,TRUE,FALSE,BLedger);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 38  ;2   ;Field     ;
                SourceExpr="Date Captured" }

    { 3   ;2   ;Field     ;
                SourceExpr="Transaction ID" }

    { 4   ;2   ;Field     ;
                SourceExpr="Transaction Date" }

    { 5   ;2   ;Field     ;
                SourceExpr="Transaction Time" }

    { 6   ;2   ;Field     ;
                SourceExpr="Member Account" }

    { 30  ;2   ;Field     ;
                SourceExpr="Paybill Member ID" }

    { 7   ;2   ;Field     ;
                SourceExpr="Vendor Commission" }

    { 8   ;2   ;Field     ;
                SourceExpr="Sacco Fee" }

    { 9   ;2   ;Field     ;
                SourceExpr=Description }

    { 10  ;2   ;Field     ;
                SourceExpr=Amount }

    { 31  ;2   ;Field     ;
                SourceExpr="Needs Change" }

    { 11  ;2   ;Field     ;
                SourceExpr=Posted }

    { 12  ;2   ;Field     ;
                SourceExpr="Date Posted" }

    { 13  ;2   ;Field     ;
                SourceExpr="Time Posted" }

    { 14  ;2   ;Field     ;
                SourceExpr="Posted By" }

    { 39  ;2   ;Field     ;
                SourceExpr="Paybill Account Entered" }

    { 35  ;2   ;Field     ;
                SourceExpr="Old Transaction Date" }

    { 15  ;2   ;Field     ;
                SourceExpr=Reversed }

    { 16  ;2   ;Field     ;
                SourceExpr="Date Reversed" }

    { 17  ;2   ;Field     ;
                SourceExpr="Time Reversed" }

    { 18  ;2   ;Field     ;
                SourceExpr="Reversed By" }

    { 19  ;2   ;Field     ;
                SourceExpr="Reversal ID" }

    { 20  ;2   ;Field     ;
                SourceExpr="Transaction Type" }

    { 21  ;2   ;Field     ;
                SourceExpr="Transaction Name" }

    { 22  ;2   ;Field     ;
                SourceExpr="Session ID" }

    { 23  ;2   ;Field     ;
                SourceExpr="Loan No." }

    { 24  ;2   ;Field     ;
                SourceExpr=Keyword }

    { 25  ;2   ;Field     ;
                SourceExpr="Mobile No." }

    { 26  ;2   ;Field     ;
                SourceExpr="Statement Max Rows" }

    { 27  ;2   ;Field     ;
                SourceExpr="Statement Start Date" }

    { 28  ;2   ;Field     ;
                SourceExpr="Statement End Date" }

    { 29  ;2   ;Field     ;
                SourceExpr="Account to Check" }

    { 1000000000;2;Field  ;
                SourceExpr="Changed By" }

    { 1000000001;2;Field  ;
                SourceExpr="Date Changed" }

    { 36  ;2   ;Field     ;
                SourceExpr="Savings Product" }

    { 37  ;2   ;Field     ;
                SourceExpr="Loan Product" }

  }
  CODE
  {
    VAR
      BLedger@1000 : Record 271;

    BEGIN
    END.
  }
}

