OBJECT page 17405 PostedBosa Rcpt HCard-Checkof
{
  OBJECT-PROPERTIES
  {
    Date=10/14/15;
    Time=[ 6:33:37 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DeleteAllowed=No;
    SourceTable=Table51516248;
    SourceTableView=WHERE(Posted=CONST(Yes));
    PageType=Card;
    OnInsertRecord=BEGIN
                        "Posting date":=TODAY;
                        "Date Entered":=TODAY;
                   END;

  }
  CONTROLS
  {
    { 18  ;0   ;Container ;
                ContainerType=ContentArea }

    { 17  ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 16  ;2   ;Field     ;
                SourceExpr=No;
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                SourceExpr="Entered By";
                Enabled=FALSE }

    { 14  ;2   ;Field     ;
                SourceExpr="Date Entered";
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                SourceExpr="Posting date";
                Editable=true }

    { 12  ;2   ;Field     ;
                SourceExpr="Loan CutOff Date" }

    { 11  ;2   ;Field     ;
                SourceExpr=Remarks }

    { 10  ;2   ;Field     ;
                SourceExpr="Total Count" }

    { 9   ;2   ;Field     ;
                SourceExpr="Posted By" }

    { 8   ;2   ;Field     ;
                SourceExpr="Account Type" }

    { 7   ;2   ;Field     ;
                SourceExpr="Account No" }

    { 6   ;2   ;Field     ;
                SourceExpr="Employer Code" }

    { 5   ;2   ;Field     ;
                SourceExpr="Document No" }

    { 4   ;2   ;Field     ;
                SourceExpr=Posted;
                Editable=true }

    { 3   ;2   ;Field     ;
                SourceExpr=Amount }

    { 2   ;2   ;Field     ;
                SourceExpr="Scheduled Amount" }

    { 1   ;1   ;Part      ;
                Name=Bosa receipt lines;
                SubPageLink=Receipt Header No=FIELD(No);
                PagePartID=Page51516265;
                PartType=Page }

  }
  CODE
  {
    VAR
      Gnljnline@1035 : Record 81;
      PDate@1034 : Date;
      DocNo@1033 : Code[20];
      RunBal@1032 : Decimal;
      ReceiptsProcessingLines@1031 : Record 51516249;
      LineNo@1030 : Integer;
      LBatches@1029 : Record 51516236;
      Jtemplate@1028 : Code[30];
      JBatch@1027 : Code[30];
      "Cheque No."@1026 : Code[20];
      DActivityBOSA@1025 : Code[20];
      DBranchBOSA@1024 : Code[20];
      ReptProcHeader@1023 : Record 51516248;
      Cust@1022 : Record 51516223;
      MembPostGroup@1021 : Record 92;
      Loantable@1020 : Record 51516230;
      LRepayment@1019 : Decimal;
      RcptBufLines@1018 : Record 51516249;
      LoanType@1017 : Record 51516240;
      LoanApp@1016 : Record 51516230;
      Interest@1015 : Decimal;
      LineN@1014 : Integer;
      TotalRepay@1013 : Decimal;
      MultipleLoan@1012 : Integer;
      LType@1011 : Text;
      MonthlyAmount@1010 : Decimal;
      ShRec@1009 : Decimal;
      SHARESCAP@1008 : Decimal;
      DIFF@1007 : Decimal;
      DIFFPAID@1006 : Decimal;
      genstup@1005 : Record 51516257;
      Memb@1004 : Record 51516223;
      INSURANCE@1003 : Decimal;
      GenBatches@1002 : Record 232;
      Datefilter@1001 : Text[50];
      ReceiptLine@1000 : Record 51516249;

    BEGIN
    {
      IF Posted=TRUE THEN
      ERROR('This Check Off has already been posted');


      IF "Account No" = '' THEN
      ERROR('You must specify the Account No.');

      IF "Document No" = '' THEN
      ERROR('You must specify the Document No.');


      IF "Posting date" = 0D THEN
      ERROR('You must specify the Posting date.');

      IF Amount = 0 THEN
      ERROR('You must specify the Amount.');

      IF "Employer Code"='' THEN
      ERROR('You must specify Employvber Code');


      PDate:="Posting date";
      DocNo:="Document No";


      "Scheduled Amount":= ROUND("Scheduled Amount");


      IF "Scheduled Amount"<>Amount THEN
      ERROR('The Amount must be equal to the Scheduled Amount');


      //delete journal line
      Gnljnline.RESET;
      Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
      Gnljnline.SETRANGE("Journal Batch Name",No);
      Gnljnline.DELETEALL;
      //end of deletion
      //delete journal line
      Gnljnline.RESET;
      Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
      Gnljnline.SETRANGE("Journal Batch Name",No);
      Gnljnline.INSERT;
      //end of deletion

      RunBal:=0;

      IF DocNo='' THEN
      ERROR('Kindly specify the document no.');

      ReceiptsProcessingLines.RESET;
      ReceiptsProcessingLines.SETRANGE(ReceiptsProcessingLines."Receipt Header No",No);
      ReceiptsProcessingLines.SETRANGE(ReceiptsProcessingLines.Posted,FALSE);
      IF ReceiptsProcessingLines.FIND('-') THEN BEGIN
      REPEAT


      ReceiptsProcessingLines.TESTFIELD(ReceiptsProcessingLines."Member No");
      ReceiptsProcessingLines.TESTFIELD(ReceiptsProcessingLines."Trans Type");
      {
      IF (ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sLoan) OR
      (ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sInterest) OR
      (ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sInsurance) THEN

      ReceiptsProcessingLines.TESTFIELD(ReceiptsProcessingLines."Loan No");
      }

      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sInterest THEN BEGIN

          LineNo:=LineNo+500;
          Gnljnline.INIT;
          Gnljnline."Journal Template Name":='GENERAL';
          Gnljnline."Journal Batch Name":=No;
          Gnljnline."Line No.":=LineNo;
          Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
          Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
          Gnljnline.VALIDATE(Gnljnline."Account No.");
          Gnljnline."Document No.":=DocNo;
          Gnljnline."Posting Date":=PDate;
          Gnljnline.Description:='Interest Paid';
          Gnljnline.Amount:=ROUND(-1*ReceiptsProcessingLines.Amount);
          Gnljnline.VALIDATE(Gnljnline.Amount);
          Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Interest Paid";
          Gnljnline."Shortcut Dimension 1 Code":='BOSA';
          Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
          Gnljnline."Loan No":=ReceiptsProcessingLines."Loan No";
          IF Gnljnline.Amount<>0 THEN
          Gnljnline.INSERT;

          LineNo:=LineNo+1000;
          Gnljnline.INIT;
          Gnljnline."Journal Template Name":='GENERAL';
          Gnljnline."Journal Batch Name":=No;
          Gnljnline."Account Type":=Gnljnline."Account Type"::Customer;
          Gnljnline."Line No.":=LineNo;
          Gnljnline."Account No.":=ReceiptsProcessingLines."Employer Code";
          //Gnljnline.VALIDATE(Gnljnline."Account No.");
          Gnljnline."Document No.":=DocNo;
          Gnljnline."Posting Date":=PDate;
          Gnljnline.Description:='Interest Paid'+' '+ReceiptsProcessingLines."Loan No"+' '+ReceiptsProcessingLines."Staff/Payroll No";
          Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount);
          Gnljnline.VALIDATE(Gnljnline.Amount);
          //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Interest Paid";
          Gnljnline."Shortcut Dimension 1 Code":='BOSA';
          Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
          Gnljnline."Loan No":=ReceiptsProcessingLines."Loan No";
          IF Gnljnline.Amount<>0 THEN
          Gnljnline.INSERT;

          END;

      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sLoan THEN BEGIN

          LineNo:=LineNo+500;
          Gnljnline.INIT;
          Gnljnline."Journal Template Name":='GENERAL';
          Gnljnline."Journal Batch Name":=No;
          Gnljnline."Line No.":=LineNo;
          Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
          Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
          Gnljnline.VALIDATE(Gnljnline."Account No.");
          //Gnljnline."Document No.":=DocNo;
          Gnljnline."Document No.":=DocNo;
          Gnljnline."Posting Date":=PDate;
          Gnljnline.Description:='Loan Repayment';
          Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*-1);
          Gnljnline.VALIDATE(Gnljnline.Amount);
          Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::Repayment;
          Gnljnline."Shortcut Dimension 1 Code":='BOSA';
          Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
          Gnljnline."Loan No":=ReceiptsProcessingLines."Loan No";
          IF Gnljnline.Amount<>0 THEN
          Gnljnline.INSERT;



          LineNo:=LineNo+1000;
          Gnljnline.INIT;
          Gnljnline."Journal Template Name":='GENERAL';
          Gnljnline."Journal Batch Name":=No;
          Gnljnline."Account Type":=Gnljnline."Account Type"::Customer;
          Gnljnline."Line No.":=LineNo;
          Gnljnline."Account No.":=ReceiptsProcessingLines."Employer Code";
          //Gnljnline.VALIDATE(Gnljnline."Account No.");
          //Gnljnline."Document No.":=DocNo;
          Gnljnline."Document No.":=DocNo;
          Gnljnline."Posting Date":=PDate;
          Gnljnline.Description:='Loan Repayment'+' '+ReceiptsProcessingLines."Loan No";
          Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*1);
         // Gnljnline.VALIDATE(Gnljnline.Amount);
          Gnljnline."Shortcut Dimension 1 Code":='BOSA';
          Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
          Gnljnline."Loan No":=ReceiptsProcessingLines."Loan No";

          IF Gnljnline.Amount<>0 THEN
          Gnljnline.INSERT;

           END;

      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sDeposits THEN BEGIN

      LineNo:=LineNo+500;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Account Type"::Member;
      Gnljnline.VALIDATE(Gnljnline."Account Type");
      Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
      //Gnljnline.VALIDATE(Gnljnline."Account No.");
      //Gnljnline."Document No.":=DocNo;
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Deposit Contribution';
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*-1);
      Gnljnline.VALIDATE(Gnljnline.Amount);
      Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Deposit Contribution";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
      //Gnljnline."Bal. Account Type":=Gnljnline."Bal. Account Type"::Customer;
      //Gnljnline.VALIDATE(Gnljnline."Bal. Account Type");
      //Gnljnline."Bal. Account No.":="ReceiptsProcessingLines"."Employer Code";
      //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      LineNo:=LineNo+1000;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Account Type"::Customer;
      Gnljnline.VALIDATE(Gnljnline."Account Type");
      Gnljnline."Account No.":=ReceiptsProcessingLines."Employer Code";
      //Gnljnline.VALIDATE(Gnljnline."Account No.");
      //Gnljnline."Document No.":=DocNo;
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Deposit Contribution'+ '-'+ReceiptsProcessingLines."Member No";
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*1);
      Gnljnline.VALIDATE(Gnljnline.Amount);
      //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Deposit Contribution";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
      //Gnljnline."Bal. Account Type":=Gnljnline."Bal. Account Type"::Customer;
      //Gnljnline.VALIDATE(Gnljnline."Bal. Account Type");
      //Gnljnline."Bal. Account No.":="ReceiptsProcessingLines"."Employer Code";
      //Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      END;



      //Benevolent Fund
      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sBenevolent THEN BEGIN

      LineNo:=LineNo+500;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      //Gnljnline."Document No.":=DocNo;
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Benevolent Fund';
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*-1);
      Gnljnline.VALIDATE(Gnljnline.Amount);
      Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Benevolent Fund";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';

      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;


      LineNo:=LineNo+1000;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Account Type":=Gnljnline."Account Type"::Customer;
      //Gnljnline."Account Type":=Gnljnline."Account Type"::"G/L Account";
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Employer Code";
      //Gnljnline.VALIDATE(Gnljnline."Account No.");
      //Gnljnline."Document No.":=DocNo;
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Benevolent Fund'+ReceiptsProcessingLines."Member No";
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*1);
      //Gnljnline.VALIDATE(Gnljnline.Amount);
      //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Benevolent Fund";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';

      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      END;

      //Loan Insurance
      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sInsurance THEN BEGIN

      LineNo:=LineNo+500;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Loan Insurance 0.02%'+' '+ReceiptsProcessingLines."Loan No";
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*-1);
      Gnljnline.VALIDATE(Gnljnline.Amount);
      Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Insurance Contribution";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';

      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;


      LineNo:=LineNo+1000;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Account Type"::Customer;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Employer Code";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Loan Insurance 0.02%'+' '+ReceiptsProcessingLines."Loan No";
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*1);
      Gnljnline.VALIDATE(Gnljnline.Amount);
      //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Insurance Contribution";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';

      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      END;


      //Share Capital
      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sShare THEN BEGIN

      LineNo:=LineNo+500;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      //Gnljnline."Posting Date":=ReceiptsProcessingLines."Transaction Date";
      Gnljnline.Description:='Shares Contribution';
      Gnljnline.Amount:=ReceiptsProcessingLines.Amount*-1;
      Gnljnline.VALIDATE(Gnljnline.Amount);
      Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Shares Capital";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';

      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      LineNo:=LineNo+1000;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Account Type"::Customer;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Employer Code";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      Gnljnline."Posting Date":=ReceiptsProcessingLines."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Shares Contribution'+' '+ReceiptsProcessingLines."Staff/Payroll No";
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*1);
      Gnljnline.VALIDATE(Gnljnline.Amount);
      //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Insurance Contribution";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';

      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      END;
       {
      //UAP
      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::"9" THEN BEGIN

      LineNo:=LineNo+1000;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline.Description:='UAP Premium';
      Gnljnline.Amount:=ReceiptsProcessingLines.Amount*-1;
      Gnljnline.VALIDATE(Gnljnline.Amount);
      //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"UAP Premiums";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';

      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      END;



      IF ReceiptsProcessingLines."Trans Type"=ReceiptsProcessingLines."Trans Type"::sInsurance THEN BEGIN

      LineNo:=LineNo+1000;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::Member;
      Gnljnline."Account No.":=ReceiptsProcessingLines."Member No";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      //Gnljnline."Document No.":=DocNo;
      //Gnljnline."Posting Date":="ReceiptsProcessingLines"."Transaction Date";
      Gnljnline."Document No.":=DocNo;
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Administration fee paid';
      Gnljnline.Amount:=ROUND(ReceiptsProcessingLines.Amount*-1);
      Gnljnline.VALIDATE(Gnljnline.Amount);
      //Gnljnline."Transaction Type":=Gnljnline."Transaction Type"::"Administration Fee Paid";
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
      Gnljnline."Loan No":=ReceiptsProcessingLines."Loan No";
      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      END;
      }
      UNTIL ReceiptsProcessingLines.NEXT=0;
      END;
       {
      //Bank Entry

      //BOSA Bank Entry
      //IF ("Mode Of Disbursement"="Mode Of Disbursement"::Cheque) THEN BEGIN
      IF(LBatches."Mode Of Disbursement"=LBatches."Mode Of Disbursement"::Cheque) THEN BEGIN
           //("Mode Of Disbursement"="Mode Of Disbursement"::"Transfer to FOSA") THEN BEGIN
      LineNo:=LineNo+10000;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":=Jtemplate;
      Gnljnline."Journal Batch Name":=JBatch;
      Gnljnline."Line No.":=LineNo;
      Gnljnline."Document No.":=DocNo;;
      Gnljnline."Posting Date":="Posting date";
      Gnljnline."External Document No.":=LBatches."Document No.";
      Gnljnline."Account Type":=Gnljnline."Bal. Account Type"::"Bank Account";
      Gnljnline."Account No.":=LBatches."BOSA Bank Account";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      Gnljnline.Description:=ReceiptsProcessingLines.Name;
      Gnljnline.Amount:=ReceiptsProcessingLines.Amount*-1;
      Gnljnline.VALIDATE(Gnljnline.Amount);
      Gnljnline."Shortcut Dimension 1 Code":=DActivityBOSA;
      Gnljnline."Shortcut Dimension 2 Code":=DBranchBOSA;
      Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 1 Code");
      Gnljnline.VALIDATE(Gnljnline."Shortcut Dimension 2 Code");
      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;

      END;
      }
      {
      LineN:=LineN+100;

      Gnljnline.INIT;
      Gnljnline."Journal Template Name":='GENERAL';
      Gnljnline."Journal Batch Name":=No;
      Gnljnline."Document No.":=DocNo;
      Gnljnline."External Document No.":=DocNo;
      Gnljnline."Line No.":=LineN;
      Gnljnline."Account Type":="Account Type";
      Gnljnline."Account No.":="Account No";
      Gnljnline.VALIDATE(Gnljnline."Account No.");
      Gnljnline."Posting Date":=PDate;
      Gnljnline.Description:='Check Off transfer';
      Gnljnline.Amount:=Amount;
      Gnljnline.VALIDATE(Gnljnline.Amount);
      Gnljnline.VALIDATE(Gnljnline."Bal. Account No.");
      Gnljnline."Shortcut Dimension 1 Code":='BOSA';
      Gnljnline."Shortcut Dimension 2 Code":='NAIROBI';
      IF Gnljnline.Amount<>0 THEN
      Gnljnline.INSERT;
      }

      //Post New
      Gnljnline.RESET;
      Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
      Gnljnline.SETRANGE("Journal Batch Name",No);
      IF Gnljnline.FIND('-') THEN BEGIN
      CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post B",Gnljnline);
      END;

      //Post New
      Posted:=TRUE;
      "Posted By":= UPPERCASE(No);
      MODIFY;

      {
      "ReceiptsProcessingLines".RESET;
      "ReceiptsProcessingLines".SETRANGE("ReceiptsProcessingLines"."Receipt Header No",No);
       IF "ReceiptsProcessingLines".FIND('-') THEN BEGIN
       REPEAT
      "ReceiptsProcessingLines".Posted:=TRUE;
      "ReceiptsProcessingLines".MODIFY;
      UNTIL "ReceiptsProcessingLines".NEXT=0;
      END;
      MODIFY;
      }
    }
    END.
  }
}

