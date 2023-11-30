OBJECT table 50081 Co-operative Shares Transfer
{
  OBJECT-PROPERTIES
  {
    Date=06/07/21;
    Time=12:28:28 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnInsert=VAR
               C_Op@1120054000 : Record 51516169;
               Err_Utlize@1120054001 : TextConst 'ENU=Please utilize open code number %1  before creating a new record!';
             BEGIN
               C_Op.RESET;
               C_Op.SETRANGE(C_Op.Status,C_Op.Status::Open);
               C_Op.SETRANGE("Created By",USERID);
               IF C_Op.FINDLAST THEN
                 ERROR(Err_Utlize,C_Op.Code);

               TestFields;
               "Price Per Share":=SaccoGeneralSetUp."Price Per Share";

               SalesSetup.GET;
               SalesSetup.TESTFIELD(SalesSetup."Shares Transfer Nos");
               NoSeriesMgt.InitSeries(SalesSetup."Shares Transfer Nos",xRec."No. Series",0D,Code,"No. Series");

               "Created By":=USERID;
               "Created On":=CURRENTDATETIME;
               "Posting Date":=TODAY;
             END;

    OnModify=BEGIN
               "Last Updated By":=USERID;
               "Last Updated On":=CURRENTDATETIME;
             END;

    LookupPageID=Page51516472;
    DrillDownPageID=Page51516472;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;OnValidate=BEGIN
                                                                IF Code <> xRec.Code THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."Shares Transfer Nos");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   Editable=No }
    { 2   ;   ;Type                ;Option        ;OnValidate=VAR
                                                                CoopSMemReg@1120054000 : Record 51516223;
                                                              BEGIN
                                                                IF Type<>xRec.Type THEN BEGIN
                                                                  TESTFIELD("Member No.");
                                                                  "Trade To Member No":='';
                                                                  "No Of Shares":=0;
                                                                  "Total Amount":=0;
                                                                  "Amount Charged":=0;
                                                                  IF Type=Rec.Type::"Buy From Member" THEN BEGIN
                                                                     SaccoGeneralSetUp.GET;
                                                                     SaccoGeneralSetUp.TESTFIELD(SaccoGeneralSetUp."Members Cutoff Period");
                                                                     CoopSMemReg.RESET;
                                                                     CoopSMemReg.SETRANGE(CoopSMemReg."No.","Member No.");
                                                                     CoopSMemReg.SETFILTER(CoopSMemReg."Date Filter",'..%1',CALCDATE('-'+FORMAT(SaccoGeneralSetUp."Members Cutoff Period"),TODAY));
                                                                     CoopSMemReg.SETAUTOCALCFIELDS(CoopSMemReg."Co-operative Shares");
                                                                     IF CoopSMemReg.FINDFIRST THEN
                                                                        Rec."Co-operative Shares Balance":=CoopSMemReg."Co-operative Shares";
                                                                    END;
                                                                END;
                                                              END;

                                                   OptionCaptionML=ENU=" ,Transfer From Fosa,Transfer From Bosa,Trade,Buy From Member";
                                                   OptionString=[ ,Transfer From Fosa,Transfer From Bosa,Trade,Buy From Member] }
    { 3   ;   ;Member No.          ;Code20        ;TableRelation="Members Register" WHERE (Status=FILTER(Active|Dormant));
                                                   OnValidate=BEGIN

                                                                IF xRec."Member No."<>"Member No." THEN BEGIN
                                                                    "Trade To Member No":='';
                                                                    "No Of Shares":=0;
                                                                    "Total Amount":=0;
                                                                    "Amount Charged":=0;
                                                                    "Fosa Account No.":='';
                                                                    "Fosa Account Name":='';
                                                                    "Fosa Available Balance":=0;
                                                                    "Deposit Contribution":=0;
                                                                    "Co-operative Shares Balance":=0;
                                                                    "Employer code":='';
                                                                    "Staff No":='';
                                                                  END;


                                                                MembersRegister.GET("Member No.");
                                                                MembersRegister.CALCFIELDS(MembersRegister."Co-operative Shares",MembersRegister."Current Shares",MembersRegister."Shares Retained");
                                                                SaccoGeneralSetUp.GET;
                                                                IF MembersRegister."Shares Retained" < SaccoGeneralSetUp."Minimum Share Capital" THEN
                                                                   ERROR(Err_MinSc,SaccoGeneralSetUp."Minimum Share Capital",MembersRegister."Shares Retained");
                                                                "Member Name":=MembersRegister.Name;
                                                                "Staff No":=MembersRegister."Payroll/Staff No";
                                                                "Employer code":=MembersRegister."Employer Code";
                                                                VALIDATE("Fosa Account No.",MembersRegister."FOSA Account");
                                                                "Co-operative Shares Balance":=MembersRegister."Co-operative Shares";
                                                                "Deposit Contribution":=MembersRegister."Current Shares";
                                                              END;
                                                               }
    { 4   ;   ;Member Name         ;Text100       ;FieldClass=Normal;
                                                   Editable=No }
    { 5   ;   ;Fosa Account No.    ;Code50        ;OnValidate=VAR
                                                                FosaAcc@1120054000 : Record 23;
                                                              BEGIN
                                                                FosaAcc.GET("Fosa Account No.");
                                                                "Fosa Account Name":=FosaAcc.Name;
                                                                "Fosa Available Balance":=SFactory.FnGetAccountAvailableBalance("Fosa Account No.");
                                                              END;

                                                   Editable=No }
    { 6   ;   ;Fosa Account Name   ;Text100       ;Editable=No }
    { 7   ;   ;Co-operative Shares Balance;Decimal;Editable=No }
    { 8   ;   ;Fosa Available Balance;Decimal     ;Editable=No }
    { 9   ;   ;Staff No            ;Code20        ;Editable=No }
    { 10  ;   ;Employer code       ;Code20        ;Editable=No }
    { 11  ;   ;Price Per Share     ;Decimal       ;Editable=No }
    { 12  ;   ;No Of Shares        ;Decimal       ;OnValidate=VAR
                                                                CSharesTrans@1120054000 : Record 51516169;
                                                                Error_Shares@1120054001 : TextConst 'ENU=The %1 number of shares purchasable/transferrable is %2.';
                                                              BEGIN
                                                                IF xRec."No Of Shares"<>"No Of Shares" THEN BEGIN
                                                                   SaccoGeneralSetUp.GET;
                                                                  "Price Per Share":=SaccoGeneralSetUp."Price Per Share";
                                                                  VALIDATE("Total Amount","No Of Shares"*"Price Per Share");

                                                                  IF "No Of Shares"<SaccoGeneralSetUp."Minimum Purchasable Shares" THEN
                                                                    ERROR(Error_Shares,'Minimum',SaccoGeneralSetUp."Minimum Purchasable Shares");
                                                                  IF "No Of Shares">SaccoGeneralSetUp."Maximum Purchasable Shares" THEN
                                                                    ERROR(Error_Shares,'Maximum',SaccoGeneralSetUp."Maximum Purchasable Shares");

                                                                  {CSharesTrans.RESET;
                                                                  IF Type=Rec.Type::"Trasfer From Bosa" THEN
                                                                    CSharesTrans.SETRANGE("Member No.","Destination Member No")
                                                                  ELSE
                                                                    CSharesTrans.SETRANGE("Member No.","Member No.");
                                                                  CSharesTrans.SETRANGE(Status,Rec.Status::Posted);
                                                                  IF CSharesTrans.FINDFIRST THEN BEGIN
                                                                     CSharesTrans.CALCSUMS("No Of Shares");
                                                                     IF CSharesTrans."No Of Shares" > 1000000 THEN
                                                                       ERROR('Member no %1, is not allowed to by more than 1,000,000 shares at a time');
                                                                       END;}
                                                                END;
                                                              END;
                                                               }
    { 13  ;   ;Status              ;Option        ;OnValidate=BEGIN
                                                                CASE Status OF
                                                                  Rec.Status::Approved:BEGIN
                                                                      Rec."Approved On":=CURRENTDATETIME;
                                                                      Rec."Approved By":=USERID;
                                                                    END;
                                                                  END;
                                                              END;

                                                   OptionCaptionML=ENU=Open,Pending,Approved,Posted,Cancelled;
                                                   OptionString=Open,Pending,Approved,Posted,Cancelled;
                                                   Editable=No }
    { 14  ;   ;Trade To Member No  ;Code20        ;TableRelation="Members Register" WHERE (Status=CONST(Active));
                                                   OnValidate=BEGIN
                                                                IF xRec."Trade To Member No"<>"Trade To Member No" THEN BEGIN
                                                                  TESTFIELD("Member No.");
                                                                  IF "Trade To Member No"="Member No." THEN
                                                                     FIELDERROR("Trade To Member No");
                                                                   MembersRegister.GET("Trade To Member No");
                                                                   MembersRegister.CALCFIELDS(MembersRegister."Co-operative Shares",MembersRegister."Shares Retained");
                                                                   SaccoGeneralSetUp.GET;
                                                                   IF MembersRegister."Shares Retained" < SaccoGeneralSetUp."Minimum Share Capital" THEN
                                                                      ERROR(Err_MinSc,SaccoGeneralSetUp."Minimum Share Capital",MembersRegister."Shares Retained");
                                                                   "Trade To Staff No":=MembersRegister."Payroll/Staff No";
                                                                   "Trade To Employer Code":=MembersRegister."Employer Code";
                                                                   "Trade To Shares Balance":=MembersRegister."Co-operative Shares";
                                                                  END;
                                                              END;
                                                               }
    { 15  ;   ;Total Amount        ;Decimal       ;OnValidate=BEGIN
                                                                ValidateAmount;
                                                              END;

                                                   Editable=No }
    { 16  ;   ;Trade To Member Name;Text100       ;Editable=No }
    { 17  ;   ;Trade To Staff No   ;Code20        ;Editable=No }
    { 18  ;   ;Trade To Employer Code;Code10      ;Editable=No }
    { 19  ;   ;Trade To Shares Balance;Decimal    ;Editable=No }
    { 20  ;   ;Amount Charged      ;Decimal       ;Editable=No }
    { 21  ;   ;Created By          ;Code50        ;Editable=No }
    { 22  ;   ;Created On          ;DateTime      ;Editable=No }
    { 23  ;   ;Last Updated On     ;DateTime      ;Editable=No }
    { 24  ;   ;Last Updated By     ;Code50        ;Editable=No }
    { 25  ;   ;Posted By           ;Code50        ;Editable=No }
    { 26  ;   ;Posted On           ;DateTime      ;Editable=No }
    { 27  ;   ;No. Series          ;Code10        ;TableRelation="No. Series" }
    { 28  ;   ;Deposit Contribution;Decimal       ;Editable=No }
    { 29  ;   ;Posting Date        ;Date          ;Editable=Yes }
    { 30  ;   ;Approved By         ;Code30        ;Editable=No }
    { 31  ;   ;Approved On         ;DateTime      ;Editable=No }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SFactory@1120054000 : Codeunit 51516022;
      MembersRegister@1120054001 : Record 51516223;
      SalesSetup@1120054002 : Record 51516258;
      NoSeriesMgt@1120054003 : Codeunit 396;
      SaccoGeneralSetUp@1120054004 : Record 51516257;
      Err_MinSc@1120054005 : TextConst 'ENU=The minimum share capital that a member should have is %1, the current is %2.';

    PROCEDURE PostSharesTransfer@1120054003();
    VAR
      GenJournalLine@1120054000 : Record 81;
      LineNo@1120054001 : Integer;
      FosaAcc@1120054002 : Record 23;
      MembersRegister@1120054003 : Record 51516223;
      DestMemb@1120054004 : Record 51516223;
      DActivity@1120054005 : Code[20];
      DBranch@1120054006 : Code[20];
      DestActivityCode@1120054007 : Code[20];
      DestBranchCode@1120054008 : Code[20];
      PostedMsg@1120054009 : TextConst 'ENU=Shares Transfer %1 has been posted successfully.';
    BEGIN
      IF NOT CONFIRM('Post this %1 transaction?',FALSE,Type) THEN EXIT;

      TESTFIELD("Member No.");
      TESTFIELD("Posting Date");
      TESTFIELD(Status,Status::Approved);
      TESTFIELD("Price Per Share");
      TESTFIELD("No Of Shares");

      TestFields;
      ValidateAmount;


      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
      GenJournalLine.SETRANGE("Journal Batch Name",'COOPSHARES');
      IF GenJournalLine.FINDFIRST THEN
         GenJournalLine.DELETEALL;

      FosaAcc.GET("Fosa Account No.");
      "Fosa Available Balance":=SFactory.FnGetAccountAvailableBalance(FosaAcc."No.");
      MembersRegister.GET("Member No.");
      DActivity:=MembersRegister."Global Dimension 1 Code";
      DBranch:=MembersRegister."Global Dimension 2 Code";

      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='COOPSHARES';
      GenJournalLine."Document No.":=Code;
      GenJournalLine."External Document No.":="Member No.";
      GenJournalLine."Line No.":=LineNo;
      CASE Type OF
          Rec.Type::"Transfer From Fosa": BEGIN
            GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
            GenJournalLine."Account No.":="Fosa Account No.";
          END;
         Rec.Type::"Transfer From Bosa",Rec.Type::Trade,Rec.Type::"Buy From Member": BEGIN
            GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
            GenJournalLine."Account No.":="Member No.";
          END;
        END;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Posting Date";
      GenJournalLine.Description:='Transfer to Co-operative Shares';
      IF Rec.Type IN [Rec.Type::"Buy From Member",Rec.Type::Trade] THEN
        GenJournalLine.Description:='Buy Co-operative Shares';
      GenJournalLine.Amount:="Total Amount";
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::" ";
      CASE Rec.Type OF
         Rec.Type::"Transfer From Bosa":GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
         Rec.Type::Trade,Rec.Type::"Buy From Member":GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Co-op Shares";
        END;
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='COOPSHARES';
      GenJournalLine."Document No.":=Code;
      GenJournalLine."External Document No.":="Member No.";
      GenJournalLine."Line No.":=LineNo;
      GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
      GenJournalLine."Account No.":="Member No.";
      CASE Rec.Type OF
        Rec.Type::Trade:BEGIN
          DestMemb.GET("Trade To Member No");
          GenJournalLine."Account No.":="Trade To Member No";
          DestActivityCode:=DestMemb."Global Dimension 1 Code";
          DestBranchCode:=DestMemb."Global Dimension 2 Code";
          END;
        Rec.Type::"Buy From Member":BEGIN
           GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
           GenJournalLine."Account No.":=SaccoGeneralSetUp."Co-op Shares Control Acc";
         END;
        END;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Posting Date";
      GenJournalLine.Description:='Buy Co-operative Shares';
      GenJournalLine.Amount:=-"Total Amount";
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Co-op Shares";
      GenJournalLine."Shortcut Dimension 1 Code":=DestActivityCode;
      GenJournalLine."Shortcut Dimension 2 Code":=DestBranchCode;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      // Transfer Charges;

      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='COOPSHARES';
      GenJournalLine."Document No.":=Code;
      GenJournalLine."External Document No.":="Member No.";
      GenJournalLine."Line No.":=LineNo;
      CASE Type OF
          Rec.Type::"Transfer From Fosa": BEGIN
            GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
            GenJournalLine."Account No.":="Fosa Account No.";
          END;
         Rec.Type::"Transfer From Bosa",Rec.Type::Trade,Rec.Type::"Buy From Member": BEGIN
            GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
            GenJournalLine."Account No.":="Member No.";
          END;
        END;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Posting Date";
      GenJournalLine.Description:='Co-operative Shares transfer charges';
      IF "Amount Charged">0 THEN
      GenJournalLine.Amount:=SaccoGeneralSetUp."Co-op Share Transfer Charge";
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::" ";
      CASE Rec.Type OF
         Rec.Type::"Transfer From Bosa":GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
         Rec.Type::Trade,Rec.Type::"Buy From Member":GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Co-op Shares";
        END;
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":=SaccoGeneralSetUp."Co-op Shares Charge G/L";
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;

      // Transfer Excise Duty;

      LineNo:=LineNo+10000;

      GenJournalLine.INIT;
      GenJournalLine."Journal Template Name":='GENERAL';
      GenJournalLine."Journal Batch Name":='COOPSHARES';
      GenJournalLine."Document No.":=Code;
      GenJournalLine."External Document No.":="Member No.";
      GenJournalLine."Line No.":=LineNo;
      CASE Type OF
          Rec.Type::"Transfer From Fosa": BEGIN
            GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
            GenJournalLine."Account No.":="Fosa Account No.";
          END;
         Rec.Type::"Transfer From Bosa",Rec.Type::Trade,Rec.Type::"Buy From Member": BEGIN
            GenJournalLine."Account Type":=GenJournalLine."Account Type"::Member;
            GenJournalLine."Account No.":="Member No.";
          END;
        END;
      GenJournalLine.VALIDATE(GenJournalLine."Account No.");
      GenJournalLine."Posting Date":="Posting Date";
      GenJournalLine.Description:='Co-operative Shares transfer charges excise duty';
      IF "Amount Charged">0 THEN
      GenJournalLine.Amount:=SaccoGeneralSetUp."Co-op Share Transfer Charge"*0.01*SaccoGeneralSetUp."Excise Duty(%)";
      GenJournalLine.VALIDATE(GenJournalLine.Amount);
      GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::" ";
      CASE Rec.Type OF
         Rec.Type::"Transfer From Bosa":GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
         Rec.Type::Trade,Rec.Type::"Buy From Member":GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Co-op Shares";
        END;
      GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
      GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
      GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
      GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No.":=SaccoGeneralSetUp."Excise Duty Account";
      IF GenJournalLine.Amount<>0 THEN
      GenJournalLine.INSERT;


      //Post New
      GenJournalLine.RESET;
      GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
      GenJournalLine.SETRANGE("Journal Batch Name",'COOPSHARES');
      IF GenJournalLine.FIND('-') THEN BEGIN
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Sacco",GenJournalLine); //commented post on 7th june 2021
      END;

      //Post New

      Rec.Status:=Rec.Status::Posted;
      Rec."Posted By":=USERID;
      Rec."Posted On":=CURRENTDATETIME;
      MODIFY;


      MESSAGE('Posted successfully');
    END;

    LOCAL PROCEDURE TestFields@1120054001();
    BEGIN
      SaccoGeneralSetUp.GET;
      SaccoGeneralSetUp.TESTFIELD(SaccoGeneralSetUp."Price Per Share");
      SaccoGeneralSetUp.TESTFIELD(SaccoGeneralSetUp."Co-op Share Transfer Charge");
      SaccoGeneralSetUp.TESTFIELD(SaccoGeneralSetUp."Co-op Shares Charge G/L");
      SaccoGeneralSetUp.TESTFIELD(SaccoGeneralSetUp."Co-op Shares Control Acc");
      SaccoGeneralSetUp.TESTFIELD(SaccoGeneralSetUp."Excise Duty Account");
      SaccoGeneralSetUp.TESTFIELD(SaccoGeneralSetUp."Excise Duty(%)");
      SaccoGeneralSetUp.TESTFIELD(SaccoGeneralSetUp."Minimum Purchasable Shares");
      SaccoGeneralSetUp.TESTFIELD(SaccoGeneralSetUp."Maximum Purchasable Shares");
    END;

    LOCAL PROCEDURE ValidateAmount@1120054006();
    BEGIN
      VALIDATE("Member No.");
      SaccoGeneralSetUp.GET;
      IF ("Total Amount" MOD 100) <> 0 THEN
        ERROR('Shares must only be bought in multiples of 100');
      IF Type IN [Rec.Type::Trade,Rec.Type::"Buy From Member"] THEN
      "Amount Charged":=SaccoGeneralSetUp."Co-op Share Transfer Charge"+(SaccoGeneralSetUp."Excise Duty(%)"*0.01*SaccoGeneralSetUp."Co-op Share Transfer Charge");

      CASE Type OF
         Rec.Type::"Transfer From Fosa":
                IF "Total Amount">("Fosa Available Balance"+"Amount Charged") THEN
                    ERROR('The total amount exceeds the FOSA available balance!');
         Rec.Type::"Transfer From Bosa":
                IF "Total Amount">("Deposit Contribution"+"Amount Charged") THEN
                    ERROR('The total amount cannot exceed the BOSA balance!');
         Rec.Type::Trade,Rec.Type::"Buy From Member":
           BEGIN
                 IF "Total Amount">("Co-operative Shares Balance"+"Amount Charged") THEN
                    ERROR('Total amount cannot exceed the cooperative shares balance!');
             END;
        END;
    END;

    PROCEDURE ApprovalsRequest@1120054002(TheOption@1120054000 : 'Send,Cancel');
    VAR
      ApprovalsMgmt@1120054001 : Codeunit 1535;
      err_type@1120054002 : TextConst 'ENU=Type must have a value!';
    BEGIN
      CASE TheOption OF
         TheOption::Send:BEGIN

              TESTFIELD("Member No.");
              TESTFIELD("Posting Date");
              TESTFIELD(Status,Status::Open);
              TESTFIELD("Price Per Share");
              TESTFIELD("No Of Shares");
              IF Rec.Type=Rec.Type::" " THEN
                ERROR(err_type);
              ValidateAmount;

              TESTFIELD(Status,Status::Open);
              IF ApprovalsMgmt.CheckCoopSharesTransferWorkflowEnabled(Rec) THEN
                 ApprovalsMgmt.OnSendCooperativeSharesForApproval(Rec);
           END;
         TheOption::Cancel:BEGIN
              TESTFIELD(Status,Status::Pending);
              TESTFIELD("Created By",USERID);
              ApprovalsMgmt.OnCancelCooperativeSharesApprovalRequest(Rec);
              END;
        END;
    END;

    BEGIN
    END.
  }
}

