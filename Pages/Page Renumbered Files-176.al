OBJECT page 17367 Member Ledger Entries
{
  OBJECT-PROPERTIES
  {
    Date=01/28/21;
    Time=12:03:53 PM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=ENU=Member Ledger Entries;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516224;
    DataCaptionFields=Customer No.;
    PageType=List;
    OnModifyRecord=BEGIN
                     CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",Rec);
                     EXIT(FALSE);
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 24      ;1   ;ActionGroup;
                      CaptionML=ENU=Ent&ry }
      { 25      ;2   ;Action    ;
                      CaptionML=ENU=Reminder/Fin. Charge Entries;
                      RunObject=Page 444;
                      RunPageView=SORTING(Customer Entry No.);
                      RunPageLink=Customer Entry No.=FIELD(Entry No.) }
      { 69      ;2   ;Action    ;
                      CaptionML=ENU=Applied E&ntries;
                      RunObject=page 20466;
                      RunPageOnRec=Yes }
      { 52      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=ENU=Detailed &Ledger Entries;
                      RunObject=Page 573;
                      RunPageView=SORTING(Cust. Ledger Entry No.,Posting Date);
                      RunPageLink=Cust. Ledger Entry No.=FIELD(Entry No.),
                                  Customer No.=FIELD(Customer No.) }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 34      ;1   ;ActionGroup;
                      CaptionML=ENU=F&unctions }
      { 36      ;2   ;Action    ;
                      ShortCutKey=Shift+F11;
                      CaptionML=ENU=Apply Entries;
                      Image=ApplyEntries;
                      OnAction=VAR
                                 CustEntryApplyPostEntries@1001 : Codeunit 51516154;
                               BEGIN
                                 CustEntryApplyPostEntries.ApplyCustEntryformEntry(Rec);
                               END;
                                }
      { 63      ;2   ;Separator  }
      { 64      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=Unapply Entries;
                      OnAction=VAR
                                 CustEntryApplyPostedEntries@1000 : Codeunit 226;
                               BEGIN
                                 CustEntryApplyPostedEntries.UnApplyMembLedgEntry("Entry No.");
                               END;
                                }
      { 65      ;2   ;Separator  }
      { 66      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=ENU=Reverse Transaction;
                      OnAction=VAR
                                 ReversalEntry@1000 : Record 179;
                               BEGIN
                                 Entries.RESET;
                                 Entries.SETRANGE(Entries."Document No.","Document No.");
                                 IF Entries.FIND('-') THEN BEGIN
                                   IF Entries."User ID"=USERID THEN
                                     ERROR('You cant Reverse your own work');
                                   IF Entries."User ID"<> USERID THEN BEGIN


                                   IF  Usersetup.GET(USERID) THEN BEGIN
                                    IF  Usersetup."Reversal Right" = FALSE  THEN
                                      ERROR('You do not have the permission to reverse this transaction. Please contact your system administrator');
                                    END;

                                 CLEAR(ReversalEntry);
                                 IF Reversed THEN
                                   ReversalEntry.AlreadyReversedEntry(TABLECAPTION,"Entry No.");
                                 IF "Journal Batch Name" = '' THEN
                                   ReversalEntry.TestFieldError;
                                 TESTFIELD("Transaction No.");
                                 ReversalEntry.ReverseTransaction("Transaction No.");
                                 END;
                                 END;
                               END;
                                }
      { 37      ;1   ;Action    ;
                      CaptionML=ENU=&Navigate;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
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
                SourceExpr="Posting Date";
                Editable=FALSE }

    { 1102755000;2;Field  ;
                SourceExpr="Transaction Type" }

    { 4   ;2   ;Field     ;
                SourceExpr="Document Type";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                SourceExpr="Document No.";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                SourceExpr="Customer No.";
                Editable=FALSE }

    { 1102755002;2;Field  ;
                SourceExpr="Loan No" }

    { 10  ;2   ;Field     ;
                SourceExpr=Description;
                Editable=FALSE }

    { 1102755008;2;Field  ;
                SourceExpr="Credit Amount" }

    { 1102755006;2;Field  ;
                SourceExpr="Debit Amount" }

    { 1102755004;2;Field  ;
                SourceExpr="Prepayment Date" }

    { 39  ;2   ;Field     ;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE;
                Editable=FALSE }

    { 41  ;2   ;Field     ;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE;
                Editable=FALSE }

    { 67  ;2   ;Field     ;
                SourceExpr="IC Partner Code";
                Visible=FALSE;
                Editable=FALSE }

    { 43  ;2   ;Field     ;
                SourceExpr="Salesperson Code";
                Visible=FALSE;
                Editable=FALSE }

    { 45  ;2   ;Field     ;
                SourceExpr="Currency Code";
                Editable=FALSE }

    { 55  ;2   ;Field     ;
                SourceExpr="Original Amount";
                Editable=FALSE }

    { 1120054000;2;Field  ;
                SourceExpr="Journal Batch Name" }

    { 53  ;2   ;Field     ;
                SourceExpr="Original Amt. (LCY)";
                Visible=FALSE;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                SourceExpr=Amount;
                Editable=FALSE }

    { 83  ;2   ;Field     ;
                SourceExpr="User ID";
                Visible=FALSE;
                Editable=FALSE }

    { 47  ;2   ;Field     ;
                SourceExpr="Amount (LCY)";
                Visible=FALSE;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                SourceExpr="Remaining Amount";
                Editable=FALSE }

    { 49  ;2   ;Field     ;
                SourceExpr="Remaining Amt. (LCY)";
                Visible=FALSE;
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                SourceExpr="Bal. Account Type";
                Visible=FALSE;
                Editable=FALSE }

    { 73  ;2   ;Field     ;
                SourceExpr="Bal. Account No.";
                Visible=FALSE;
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                SourceExpr="Due Date" }

    { 18  ;2   ;Field     ;
                SourceExpr="Pmt. Discount Date" }

    { 59  ;2   ;Field     ;
                SourceExpr="Pmt. Disc. Tolerance Date" }

    { 20  ;2   ;Field     ;
                SourceExpr="Original Pmt. Disc. Possible" }

    { 57  ;2   ;Field     ;
                SourceExpr="Remaining Pmt. Disc. Possible" }

    { 61  ;2   ;Field     ;
                SourceExpr="Max. Payment Tolerance" }

    { 28  ;2   ;Field     ;
                SourceExpr=Open;
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                SourceExpr="On Hold" }

    { 85  ;2   ;Field     ;
                SourceExpr="Source Code";
                Visible=FALSE;
                Editable=FALSE }

    { 87  ;2   ;Field     ;
                SourceExpr="Reason Code";
                Visible=FALSE;
                Editable=FALSE }

    { 35  ;2   ;Field     ;
                SourceExpr=Reversed;
                Visible=FALSE }

    { 71  ;2   ;Field     ;
                SourceExpr="Reversed by Entry No.";
                Visible=FALSE }

    { 75  ;2   ;Field     ;
                SourceExpr="Reversed Entry No.";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                SourceExpr="Entry No.";
                Editable=FALSE }

    { 1102755007;0;Container;
                ContainerType=FactBoxArea }

    { 1102755005;1;Part   ;
                Name=Member Ledger Entry FactBox;
                SubPageLink=Entry No.=FIELD(Entry No.);
                PagePartID=Page51516233;
                Visible=TRUE;
                PartType=Page }

    { 1102755003;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1102755001;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Navigate@1102755000 : Page 344;
      Usersetup@1120054000 : Record 91;
      Entries@1120054001 : Record 51516224;

    BEGIN
    END.
  }
}

