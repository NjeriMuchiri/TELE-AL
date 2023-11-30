OBJECT page 50006 Checkoff Processing Header-D
{
  OBJECT-PROPERTIES
  {
    Date=04/05/18;
    Time=10:44:39 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516281;
    ActionList=ACTIONS
    {
      { 1000000023;  ;ActionContainer;
                      Name=Actions;
                      ActionContainerType=ActionItems }
      { 1000000022;1 ;Action    ;
                      Name=Import Checkoff Distributed;
                      CaptionML=ENU=Import Checkoff Distributed;
                      RunObject=XMLport 51516003;
                      Promoted=Yes;
                      Image=Import;
                      PromotedCategory=Report }
      { 1000000020;1 ;Action    ;
                      Name=Validate Checkoff;
                      CaptionML=ENU=Validate Checkoff;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 ReceiptLine.RESET;
                                 ReceiptLine.SETRANGE(ReceiptLine."Receipt Header No",No);
                                 IF ReceiptLine.FIND('-') THEN
                                 REPORT.RUN(51516288,TRUE,FALSE,ReceiptLine);

                                 {
                                 ReptProcHeader.RESET;
                                 ReptProcHeader.SETRANGE(ReptProcHeader.No,ReceiptsProcessingLines."Receipt Header No");
                                 IF  ReptProcHeader.FIND('-') THEN BEGIN
                                   REPEAT
                                     Cust.RESET;
                                     Cust.SETRANGE(Cust."Payroll/Staff No",ReceiptsProcessingLines."Staff/Payroll No");
                                     //Cust.SETRANGE(Cust."Employer Code",DEPT);
                                     //Cust.SETRANGE(Cust."Date Filter",ASATDATE);
                                     IF Cust.FIND('-') THEN BEGIN
                                      REPEAT
                                       Cust.CALCFIELDS(Cust."Current Shares");
                                       ReceiptsProcessingLines."Member No.":=Cust."No.";
                                       ReceiptsProcessingLines.Name:=Cust.Name;
                                       ReceiptsProcessingLines."Expected Amount":=Cust."Monthly Contribution";
                                       ReceiptsProcessingLines.Variance:=Amount+ReceiptsProcessingLines."Expected Amount";
                                       ReceiptsProcessingLines.MODIFY;

                                      UNTIL Cust.NEXT=0;
                                   END;

                                     Cust.RESET;
                                     Cust.SETRANGE(Cust."Payroll/Staff No",ReceiptsProcessingLines."Staff/Payroll No");
                                     //Cust.SETRANGE(Cust."Employer Code",DEPT);
                                     //Cust.SETRANGE(Cust."Date Filter",ASATDATE);
                                     IF Cust.FIND('-') THEN BEGIN
                                      REPEAT
                                       IF ReceiptsProcessingLines."Account type"='WCONT' THEN BEGIN
                                       IF Amount=200 THEN
                                       ReceiptsProcessingLines."Account type":='BBF';
                                       ReceiptsProcessingLines.MODIFY;
                                       END;


                                        UNTIL Cust.NEXT=0;
                                   END;

                                   Cust.RESET;
                                     Cust.SETRANGE(Cust."Payroll/Staff No",ReceiptsProcessingLines."Staff/Payroll No");
                                     //Cust.SETRANGE(Cust."Employer Code",DEPT);
                                     //Cust.SETRANGE(Cust."Date Filter",ASATDATE);
                                     IF Cust.FIND('-') THEN BEGIN
                                     REPEAT
                                     BBF:=0;
                                     RcptHeader.RESET;
                                     RcptHeader.SETRANGE(RcptHeader."Account type",'BBF');
                                     IF RcptHeader.FIND('-')=FALSE THEN BEGIN

                                     IF ReceiptsProcessingLines."Account type"='WCONT' THEN BEGIN
                                     BBF:=Amount;
                                     INIT;
                                     ReceiptsProcessingLines."Receipt Header No":=ReceiptsProcessingLines."Receipt Header No";
                                     ReceiptsProcessingLines."Entry No":=ReceiptsProcessingLines."Entry No"+10000;
                                     ReceiptsProcessingLines."Account type":='BBF';
                                     ReceiptsProcessingLines.Amount:=200;
                                     ReceiptsProcessingLines.Reference:=ReceiptsProcessingLines.Reference;
                                     ReceiptsProcessingLines."Member No.":=ReceiptsProcessingLines."Member No.";
                                     ReceiptsProcessingLines.INSERT;

                                    ReceiptsProcessingLines.Amount:=BBF-200;
                                     ReceiptsProcessingLines.MODIFY;

                                      END;

                                      END;

                                        UNTIL Cust.NEXT=0;
                                   END;
                                     //Num:=0;
                                     BaldateTXT:='01/01/10..'+FORMAT(ASATDATE);

                                  //IF "Checkoff Lines-Distributed"."Account type"='SLOAN' THEN BEGIN
                                     Loans.RESET;

                                     Loans.SETRANGE(Loans."Staff No",ReceiptsProcessingLines."Staff/Payroll No");
                                     //Loans.SETRANGE(Loans."Employer Code",DEPT);
                                     //Loans.SETRANGE(Loans."Loan Product Type","Loan Type");
                                     Loans.SETRANGE(Loans.Source,Loans.Source::BOSA);
                                      IF Loans.FIND('-') THEN BEGIN
                                       REPEAT
                                         //Num:=Num+1;
                                        Checkoff.RESET;
                                        Checkoff.SETRANGE(Checkoff."Staff/Payroll No",ReceiptsProcessingLines."Staff/Payroll No");
                                        Checkoff.SETRANGE(Checkoff."Account type",'SLOAN');
                                        IF Checkoff.FIND('-') THEN BEGIN



                                         Loans.CALCFIELDS(Loans."Outstanding Balance");

                                         IF Loans."Outstanding Balance" = (ReceiptsProcessingLines."Loan Balance"+ReceiptsProcessingLines.Amount) THEN BEGIN
                                           ReceiptsProcessingLines."Loan No.":=Loans."Loan  No.";
                                           ReceiptsProcessingLines."Loan Type":=Loans."Loan Product Type";
                                           ReceiptsProcessingLines.adviced:=TRUE;

                                           ReceiptsProcessingLines.  MODIFY;
                                         END ;
                                         END;
                                         {
                                         Checkoff.RESET;
                                        Checkoff.SETRANGE(Checkoff."Staff/Payroll No","Staff/Payroll No");
                                        Checkoff.SETRANGE(Checkoff."Account type",'SINTEREST');
                                        IF Checkoff.FIND('-') THEN BEGIN

                                          Loans.CALCFIELDS(Loans."Outstanding Balance");
                                          Interest:=0.01*Loans."Outstanding Balance";
                                          IF Interest = "Checkoff Lines-Distributed".Amount THEN BEGIN
                                          Checkoff."Loan No.":=Loans."Loan  No.";
                                           Checkoff."Loan Type":=Loans."Loan Product Type";
                                           Checkoff.adviced:=TRUE;
                                           Checkoff.MODIFY;
                                           END;
                                          END;
                                          }


                                          UNTIL Loans.NEXT=0;




                                         END;



                                       Loans.RESET;

                                     Loans.SETRANGE(Loans."Staff No",ReceiptsProcessingLines."Staff/Payroll No");
                                     //Loans.SETRANGE(Loans."Employer Code",DEPT);
                                     //Loans.SETRANGE(Loans."Loan Product Type","Loan Type");
                                     Loans.SETRANGE(Loans.Source,Loans.Source::BOSA);
                                      IF Loans.FIND('-') THEN BEGIN
                                       REPEAT
                                           Checkoff.RESET;
                                        Checkoff.SETRANGE(Checkoff."Staff/Payroll No",ReceiptsProcessingLines."Staff/Payroll No");
                                        Checkoff.SETRANGE(Checkoff."Account type",'SINTEREST');
                                        IF Checkoff.FIND('-') THEN BEGIN

                                          Loans.CALCFIELDS(Loans."Outstanding Balance");
                                          Interest:=0.01*Loans."Outstanding Balance";
                                          IF Interest = ReceiptsProcessingLines.Amount THEN BEGIN
                                          Checkoff."Loan No.":=Loans."Loan  No.";
                                           Checkoff."Loan Type":=Loans."Loan Product Type";
                                           Checkoff.adviced:=TRUE;
                                           Checkoff.MODIFY;
                                           END;
                                          END;
                                 UNTIL Loans.NEXT=0;




                                         END;
                                       //END;
                                                Num:=0;
                                          Checkoff.RESET;
                                        Checkoff.SETRANGE(Checkoff."Staff/Payroll No",ReceiptsProcessingLines."Staff/Payroll No");
                                        Checkoff.SETRANGE(Checkoff."Account type",'SINTEREST');
                                        IF Checkoff.FIND('-') THEN BEGIN

                                          REPEAT
                                          Num:=Num+1;
                                           //IF Checkoff.COUNT=1 THEN BEGIN

                                           //END;
                                           UNTIL Checkoff.NEXT=0;
                                           END;
                                           MESSAGE('%1',Num);

                                       Loans.RESET;
                                     Loans.SETRANGE(Loans."Staff No",ReceiptsProcessingLines."Staff/Payroll No");
                                     Loans.SETRANGE(Loans.Source,Loans.Source::BOSA);
                                     IF Loans.FIND('-') THEN BEGIN

                                       Num1:=0;


                                          IF Num =1 THEN BEGIN
                                            IF Checkoff."Loan No."='' THEN BEGIN
                                              IF Checkoff."Account type"='SINTEREST' THEN BEGIN
                                           ReceiptsProcessingLines."Loan No.":=Loans."Loan  No.";
                                           ReceiptsProcessingLines."Loan Type":=Loans."Loan Product Type";
                                           Checkoff.adviced:=TRUE;
                                           ReceiptsProcessingLines.MODIFY;
                                           END;
                                           END;
                                           END;


                                           Checkoff.RESET;
                                          Checkoff.SETRANGE(Checkoff."Staff/Payroll No",ReceiptsProcessingLines."Staff/Payroll No");
                                          // Checkoff.SETRANGE(Checkoff."Staff/Payroll No",'2002000129');
                                           Checkoff.SETRANGE(Checkoff."Account type",'SLOAN');
                                            IF Checkoff.FIND('-') THEN BEGIN
                                          REPEAT
                                          Num1:=Num1+1;

                                           UNTIL Checkoff.NEXT=0;
                                           END;

                                            IF Num1 =1 THEN  BEGIN
                                            IF Checkoff."Loan No."='' THEN BEGIN
                                              IF Checkoff."Account type"='SLOAN' THEN BEGIN
                                           ReceiptsProcessingLines."Loan No.":=Loans."Loan  No.";
                                           ReceiptsProcessingLines."Loan Type":=Loans."Loan Product Type";
                                           ReceiptsProcessingLines.adviced:=TRUE;
                                           ReceiptsProcessingLines.MODIFY;
                                            END;
                                           END;
                                           END;
                                         END;
                                         UNTIL ReptProcHeader.NEXT=0;
                                 END;
                                 }
                               END;
                                }
      { 1000000018;1 ;Action    ;
                      Name=Process Checkoff Distributed;
                      CaptionML=ENU=Process Checkoff Distributed;
                      Promoted=Yes;
                      Image=post;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ReceiptLine.RESET;
                                 ReceiptLine.SETRANGE(ReceiptLine."Receipt Header No",No);
                                 IF ReceiptLine.FIND('-') THEN
                                 REPORT.RUN(51516289,TRUE,FALSE,ReceiptLine);
                               END;
                                }
      { 1       ;1   ;Action    ;
                      Name=Mark as Posted;
                      Promoted=Yes;
                      Enabled=NOT ActionEnabled;
                      Image=PostBatch;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to mark this Checkoff as Posted ?',FALSE)=TRUE THEN BEGIN
                                 MembLedg.RESET;
                                 MembLedg.SETRANGE(MembLedg."Document No.",Remarks);
                                 IF MembLedg.FIND('-')= FALSE THEN
                                 ERROR('Sorry,You can only do this process on already posted Checkoffs');
                                 Posted:=TRUE;
                                 "Posted By":=USERID;
                                 "Posting date":=TODAY;
                                 MODIFY;
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1000000017;0;Container;
                ContainerType=ContentArea }

    { 1000000016;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1000000015;2;Field  ;
                SourceExpr=No;
                Editable=FALSE }

    { 1000000014;2;Field  ;
                SourceExpr="Entered By";
                Enabled=FALSE }

    { 1000000013;2;Field  ;
                SourceExpr="Date Entered";
                Editable=FALSE }

    { 1000000012;2;Field  ;
                SourceExpr="Posting date";
                Editable=true }

    { 1000000011;2;Field  ;
                SourceExpr="Loan CutOff Date" }

    { 1000000010;2;Field  ;
                SourceExpr=Remarks }

    { 1000000009;2;Field  ;
                SourceExpr="Total Count" }

    { 1000000024;2;Field  ;
                SourceExpr="Emp Not Fount" }

    { 1000000008;2;Field  ;
                SourceExpr="Posted By" }

    { 1000000007;2;Field  ;
                SourceExpr="Account Type" }

    { 1000000006;2;Field  ;
                SourceExpr="Account No" }

    { 1000000005;2;Field  ;
                SourceExpr="Employer Code" }

    { 1000000004;2;Field  ;
                SourceExpr="Document No" }

    { 1000000003;2;Field  ;
                SourceExpr=Posted;
                Editable=true }

    { 1000000002;2;Field  ;
                SourceExpr=Amount }

    { 1000000001;2;Field  ;
                SourceExpr="Scheduled Amount" }

    { 1000000000;1;Part   ;
                Name=Checkoff Lines-Distributed;
                CaptionML=ENU=Checkoff Lines-Distributed;
                SubPageLink=Receipt Header No=FIELD(No);
                PagePartID=Page51516367;
                PartType=Page }

  }
  CODE
  {
    VAR
      Gnljnline@1000000035 : Record 81;
      PDate@1000000034 : Date;
      DocNo@1000000033 : Code[20];
      RunBal@1000000032 : Decimal;
      ReceiptsProcessingLines@1000000031 : Record 51516282;
      LineNo@1000000030 : Integer;
      LBatches@1000000029 : Record 51516236;
      Jtemplate@1000000028 : Code[30];
      JBatch@1000000027 : Code[30];
      "Cheque No."@1000000026 : Code[20];
      DActivityBOSA@1000000025 : Code[20];
      DBranchBOSA@1000000024 : Code[20];
      ReptProcHeader@1000000023 : Record 51516281;
      Cust@1000000022 : Record 51516223;
      MembPostGroup@1000000021 : Record 92;
      Loantable@1000000020 : Record 51516230;
      LRepayment@1000000019 : Decimal;
      RcptBufLines@1000000018 : Record 51516282;
      LoanType@1000000017 : Record 51516240;
      LoanApp@1000000016 : Record 51516230;
      Interest@1000000015 : Decimal;
      LineN@1000000014 : Integer;
      TotalRepay@1000000013 : Decimal;
      MultipleLoan@1000000012 : Integer;
      LType@1000000011 : Text;
      MonthlyAmount@1000000010 : Decimal;
      ShRec@1000000009 : Decimal;
      SHARESCAP@1000000008 : Decimal;
      DIFF@1000000007 : Decimal;
      DIFFPAID@1000000006 : Decimal;
      genstup@1000000005 : Record 51516257;
      Memb@1000000004 : Record 51516223;
      INSURANCE@1000000003 : Decimal;
      GenBatches@1000000002 : Record 232;
      Datefilter@1000000001 : Text[50];
      ReceiptLine@1000000000 : Record 51516282;
      BBF@1000000036 : Decimal;
      RcptHeader@1000000041 : Record 51516282;
      Checkoff@1000000040 : Record 51516282;
      Num@1000000039 : Integer;
      Num1@1000000037 : Integer;
      ASATDATE@1000000042 : Date;
      BaldateTXT@1000000038 : Text[30];
      Loans@1000000043 : Record 51516230;
      ActionEnabled@1000000044 : Boolean;
      MembLedg@1000000045 : Record 51516224;

    BEGIN
    END.
  }
}

