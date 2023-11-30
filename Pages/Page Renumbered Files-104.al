OBJECT page 20445 HR Medical Claim Card
{
  OBJECT-PROPERTIES
  {
    Date=02/26/18;
    Time=[ 9:42:49 AM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516278;
    PageType=Card;
    OnAfterGetRecord=BEGIN
                        //TO PREVENT USER FROM SEEING OTHER PEOPLES LEAVE APPLICATIONS
                                                 SETFILTER("User ID",USERID);
                     END;

    OnNewRecord=BEGIN
                  //"Claim Type"='Outpatient';
                END;

    ActionList=ACTIONS
    {
      { 1000000027;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1000000026;1 ;ActionGroup;
                      CaptionML=ENU=&Functions }
      { 1000000025;2 ;Action    ;
                      Name=Post;
                      CaptionML=ENU=Post Claim;
                      Promoted=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 {//Post PV Entries
                                 CurrPage.SAVERECORD;
                                 CheckPVRequiredItems;
                                 //post pv
                                  // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                                  GenJnlLine.RESET;
                                  GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
                                  GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);
                                  IF GenJnlLine.FIND('+') THEN
                                    BEGIN
                                      LineNo:=GenJnlLine."Line No."+1000;
                                    END
                                  ELSE
                                    BEGIN
                                      LineNo:=1000;
                                    END;
                                  GenJnlLine.DELETEALL;
                                  GenJnlLine.RESET;

                                 Payments.RESET;
                                 Payments.SETRANGE(Payments."No.","No.");
                                 IF Payments.FIND('-') THEN BEGIN
                                   PayLine.RESET;
                                   PayLine.SETRANGE(PayLine.No,Payments."No.");
                                   IF PayLine.FIND('-') THEN
                                     BEGIN
                                       REPEAT
                                         PostHeader(Payments);

                                       UNTIL PayLine.NEXT=0;
                                     END;

                                 Post:=FALSE;
                                 Post:=JournlPosted.PostedSuccessfully();
                                 //IF Post THEN  BEGIN
                                     Posted:=TRUE;
                                     Status:=Payments.Status::Posted;
                                     "Posted By":=USERID;
                                     "Date Posted":=TODAY;
                                     "Time Posted":=TIME;
                                     MODIFY;

                                   //Post Reversal Entries for Commitments
                                  // Doc_Type:=Doc_Type::"Payment Voucher";
                                   //CheckBudgetAvail.ReverseEntries(Doc_Type,"No.");
                                  // END;
                                 END;

                                 COMMIT;
                                 //end of post pv
                                 //{
                                 //Print Here
                                 RESET;
                                 SETFILTER("No.","No.");
                                 REPORT.RUN(51516004,TRUE,TRUE,Rec);
                                 RESET;
                                 //End Print Here
                                 //}
                                 }
                               END;
                                }
      { 1000000024;2 ;Separator  }
      { 1000000018;2 ;Action    ;
                      Name=PrintNew;
                      CaptionML=ENU=Print/Preview;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 //TESTFIELD(Status,Status::Approved);
                                 {IF (Status=Status::Pending) OR  (Status=Status::"Pending Approval") THEN
                                    ERROR('You cannot Print until the document is Approved'); }

                                 PHeader2.RESET;
                                 PHeader2.SETRANGE(PHeader2."Member No","Member No");
                                 IF PHeader2.FINDFIRST THEN
                                    REPORT.RUN(51516198,TRUE,TRUE,PHeader2);

                                 {RESET;
                                 SETRANGE("No.","No.");
                                 IF "No." = '' THEN
                                   REPORT.RUNMODAL(51516000,TRUE,TRUE,Rec)
                                 ELSE
                                   REPORT.RUNMODAL(51516344,TRUE,TRUE,Rec);
                                 RESET;
                                 }
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1000000013;2;Field  ;
                SourceExpr="Claim No";
                OnValidate=BEGIN
                             CurrPage.UPDATE;
                           END;
                            }

    { 1000000002;2;Field  ;
                CaptionML=ENU=Employee No.;
                SourceExpr="Member No" }

    { 1000000003;2;Field  ;
                SourceExpr="Claim Type" }

    { 1000000004;2;Field  ;
                SourceExpr="Claim Date" }

    { 1000000005;2;Field  ;
                SourceExpr="Patient Name" }

    { 1000000006;2;Field  ;
                CaptionML=ENU=Document No.(From Hospital);
                SourceExpr="Document Ref" }

    { 1000000007;2;Field  ;
                CaptionML=ENU=Visit Date(Hospital);
                SourceExpr="Date of Service" }

    { 1000000008;2;Field  ;
                SourceExpr="Attended By";
                Visible=false }

    { 1000000010;2;Field  ;
                SourceExpr=Comments }

    { 1000000012;2;Field  ;
                SourceExpr=Dependants }

    { 1000000016;2;Field  ;
                SourceExpr="Amount Charged" }

    { 1000000011;2;Field  ;
                SourceExpr="Amount Claimed" }

    { 1000000014;2;Field  ;
                SourceExpr="Hospital/Medical Centre" }

    { 1000000015;2;Field  ;
                SourceExpr="Claim Limit";
                Editable=false }

    { 1000000009;2;Field  ;
                SourceExpr="User ID" }

  }
  CODE
  {
    VAR
      PHeader2@1000000000 : Record 51516278;
      HREmp@1000000001 : Record 51516160;
      EmpName@1000000002 : Text;
      EmpDept@1000000003 : Text;

    LOCAL PROCEDURE FillVariables@1000000000();
    BEGIN
      //GET THE APPLICANT DETAILS

                                  HREmp.RESET;
                                  IF HREmp.GET("Member No") THEN
                                  BEGIN
                                  EmpName:=HREmp.FullName;
                                  EmpDept:=HREmp."Global Dimension 2 Code";
                                  END ELSE BEGIN
                                  EmpDept:='';
                                  END;
    END;

    BEGIN
    END.
  }
}

