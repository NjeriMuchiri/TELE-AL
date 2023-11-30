OBJECT table 50067 HR Medical Claims
{
  OBJECT-PROPERTIES
  {
    Date=11/04/20;
    Time=[ 4:55:01 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "Claim No" = '' THEN BEGIN
                 HRSetup.GET;
                 HRSetup.TESTFIELD(HRSetup."Medical Claims Nos");
                 NoSeriesMgt.InitSeries(HRSetup."Medical Claims Nos",xRec."No. Series",0D,"Claim No","No. Series");
               END;

               {HREmp.RESET;
               HREmp.SETRANGE(HREmp."User ID",USERID);

               //populate employee  details

               "Member No":=HREmp."No.";
                  // Gender:=HREmp.Gender;
                  // "Application Date":=TODAY;
                   "User ID":=USERID;
                  // "Job Tittle":=HREmp."Job Title";
                  // HREmp.CALCFIELDS(HREmp.Picture);
                   //Picture:=HREmp.Picture;}

                   HREmp.RESET;
                   HREmp.SETRANGE(HREmp."User ID",USERID);
                   IF HREmp.FIND('-') THEN BEGIN
                   "Patient Name":=HREmp.County+' '+HREmp."Home Phone Number";
                   "Member No":=HREmp.City;
                   "Claim Limit":=HREmp."Claim Limit";
                   "User ID":=USERID;
                   "FOSA Account":=HREmp."Fosa Account"
                   END;



               "Claim Date":=TODAY;

               IF "Claim Limit"=0 THEN
               ERROR('Your Claim Limit is Exhausted');
             END;

  }
  FIELDS
  {
    { 1   ;   ;Member No           ;Code10        ;TableRelation="HR Employees";
                                                   OnValidate=BEGIN
                                                                BankAcc.RESET;
                                                                 BankAcc.SETRANGE(BankAcc.City,"Member No");
                                                                 IF BankAcc.FINDFIRST THEN BEGIN
                                                                  "Patient Name":=BankAcc.County;
                                                                 END;
                                                              END;

                                                   Editable=No }
    { 2   ;   ;Claim Type          ;Option        ;OptionString=Inpatient,Outpatient }
    { 3   ;   ;Claim Date          ;Date          ;Editable=No }
    { 4   ;   ;Patient Name        ;Text100       ;Editable=No }
    { 5   ;   ;Document Ref        ;Text50         }
    { 6   ;   ;Date of Service     ;Date          ;OnValidate=BEGIN
                                                                 IF "Date of Service">"Claim Date"THEN
                                                                ERROR('Visit Date must be before or on the claim Date');
                                                              END;
                                                               }
    { 7   ;   ;Attended By         ;Code10        ;TableRelation=Vendor.No. }
    { 8   ;   ;Amount Charged      ;Decimal        }
    { 9   ;   ;Comments            ;Text250        }
    { 10  ;   ;Claim No            ;Code10        ;OnValidate=BEGIN

                                                                IF "Claim No" <> xRec."Claim No" THEN BEGIN
                                                                  HRSetup.GET;
                                                                  NoSeriesMgt.TestManual(HRSetup."Medical Claims Nos");
                                                                  "No. Series":= '';
                                                                END;
                                                              END;

                                                   Editable=No }
    { 11  ;   ;Dependants          ;Code50        ;TableRelation="HR Employee Kin"."Other Names" WHERE (Employee Code=FIELD(Member No));
                                                   OnValidate=BEGIN
                                                                         MDependants.RESET;
                                                                         MDependants.SETRANGE(MDependants."Employee Code",Dependants);
                                                                          IF MDependants.FIND('-') THEN BEGIN
                                                                         "Patient Name":=MDependants.SurName+' '+MDependants."Other Names";
                                                                          END;
                                                              END;
                                                               }
    { 12  ;   ;Status              ;Option        ;OnValidate=BEGIN
                                                                IF Status=Status::Approved THEN
                                                                 BEGIN
                                                                  intEntryNo:=0;

                                                                  HRLeaveEntries.RESET;
                                                                  HRLeaveEntries.SETRANGE(HRLeaveEntries."Entry No.");
                                                                   IF HRLeaveEntries.FIND('-') THEN intEntryNo:=HRLeaveEntries."Entry No.";

                                                                  intEntryNo:=intEntryNo+1;

                                                                  HRLeaveEntries.INIT;
                                                                  HRLeaveEntries."Entry No.":=intEntryNo;
                                                                  HRLeaveEntries."Staff No.":="Member No";
                                                                  HRLeaveEntries."Staff Name":="Patient Name";
                                                                  HRLeaveEntries."Posting Date":=TODAY;
                                                                  HRLeaveEntries."Leave Entry Type":=HRLeaveEntries."Leave Entry Type"::Negative;
                                                                  HRLeaveEntries."Leave Approval Date":="Claim Date";
                                                                  HRLeaveEntries."Document No.":="Claim No";
                                                                  HRLeaveEntries."External Document No.":="Member No";
                                                                  //HRLeaveEntries."Job ID":="Job Tittle";
                                                                  HRLeaveEntries.Amount:="Amount Claimed";
                                                                  //HRLeaveEntries."Leave Start Date":="Start Date";
                                                                  HRLeaveEntries."Leave Posting Description":='Medical Purpose Claim';
                                                                 // HRLeaveEntries."Leave End Date":="End Date";
                                                                 // HRLeaveEntries."Leave Return Date":="Return Date";
                                                                  HRLeaveEntries."User ID" :="User ID";
                                                                  HRLeaveEntries."Claim Type":="Claim Type";
                                                                  HRLeaveEntries.INSERT;
                                                                END;
                                                              END;

                                                   OptionCaptionML=ENU=New,Pending Approval,HOD Approval,HR Approval,Final Approval,Rejected,Canceled,Approved,On leave,Resumed,Posted;
                                                   OptionString=New,Pending Approval,HOD Approval,HR Approval,MDApproval,Rejected,Canceled,Approved,On leave,Resumed,Posted;
                                                   Editable=No }
    { 3967;   ;No. Series          ;Code10         }
    { 3968;   ;Amount Claimed      ;Decimal       ;OnValidate=BEGIN
                                                                 IF "Amount Claimed">"Claim Limit"THEN
                                                                ERROR('You cannot claim More than your Limit');
                                                                 Balance:= "Claim Limit"-"Amount Claimed";
                                                              END;
                                                               }
    { 3969;   ;Hospital/Medical Centre;Text70      }
    { 3970;   ;Claim Limit         ;Decimal        }
    { 3971;   ;User ID             ;Code50        ;Editable=No }
    { 3972;   ;Balance             ;Decimal        }
    { 3973;   ;FOSA Account        ;Code20        ;Editable=No }
    { 3974;   ;Bank Account        ;Code20        ;TableRelation="Bank Account".No.;
                                                   OnValidate=BEGIN
                                                                Bank.RESET;
                                                                Bank.SETRANGE(Bank."No.","Bank Account");
                                                                IF Bank.FIND('-') THEN BEGIN
                                                                  "Bank Name":=Bank.Name;
                                                                END;
                                                              END;
                                                               }
    { 3975;   ;Bank Name           ;Text50        ;Editable=No }
    { 3976;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[ENU=Shortcut Dimension 1 Code;
                                                              ESM=C d. dim. acceso dir. 1;
                                                              FRC=Code raccourci de dimension 1;
                                                              ENC=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 3977;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[ENU=Shortcut Dimension 2 Code;
                                                              ESM=C d. dim. acceso dir. 2;
                                                              FRC=Code raccourci de dimension 2;
                                                              ENC=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 3978;   ;Posted              ;Boolean       ;Editable=No }
  }
  KEYS
  {
    {    ;Member No,Claim No                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      MDependants@1102755000 : Record 51516110;
      NoSeriesMgt@1102755001 : Codeunit 396;
      HRSetup@1102755002 : Record 51516192;
      BankAcc@1000000000 : Record 51516160;
      HREmp@1000000001 : Record 51516160;
      HRLeaveEntries@1000000002 : Record 51516201;
      intEntryNo@1000000003 : Integer;
      "LineNo."@1000000004 : Integer;
      MedGjline@1000000005 : Record 81;
      Bank@1000000006 : Record 270;

    LOCAL PROCEDURE CreateLeaveLedgerEntries@1000000000();
    BEGIN
      // TESTFIELD("Amount Claimed");
      // HRSetup.RESET;
      // IF HRSetup.FIND('-') THEN BEGIN
      //
      // // MedGjline.RESET;
      // // MedGjline.SETRANGE("Journal Template Name",HRSetup."Leave Template");
      // // MedGjline.SETRANGE("Journal Batch Name",HRSetup."Leave Batch");
      // // MedGjline.DELETEALL;
      //   //Dave
      // //HRSetup.TESTFIELD(HRSetup."Leave Template");
      // //HRSetup.TESTFIELD(HRSetup."Leave Batch");
      //
      // HREmp.GET("Member No");
      // //HREmp.TESTFIELD(HREmp."Company E-Mail");
      //
      // //POPULATE JOURNAL LINES
      //
      // "LineNo.":=10000;
      // MedGjline.INIT;
      // MedGjline."Journal Template Name":=HRSetup."Leave Template";
      // MedGjline."Journal Batch Name":=HRSetup."Leave Batch";
      // MedGjline."Line No.":="LineNo.";
      // //MedGjline."Leave Period":='2014';
      // MedGjline."Document No.":="Claim No";
      // MedGjline."Staff No.":="Member No";
      // MedGjline.VALIDATE(MedGjline."Staff No.");
      // MedGjline."Posting Date":=TODAY;
      // MedGjline."Leave Entry Type":=MedGjline."Leave Entry Type"::Negative;
      // MedGjline."Leave Approval Date":=TODAY;
      // MedGjline.Description:='Medical Claim Purpose';
      // MedGjline."Claim Type":="Claim Type";
      // MedGjline.Amount:="Amount Claimed";
      // //------------------------------------------------------------
      // //HRSetup.RESET;
      // //HRSetup.FIND('-');
      // HRSetup.TESTFIELD(HRSetup."Leave Posting Period[FROM]");
      // HRSetup.TESTFIELD(HRSetup."Leave Posting Period[TO]");
      // //------------------------------------------------------------
      // //MedGjline."Leave Period Start Date":=HRSetup."Leave Posting Period[FROM]";
      // //MedGjline."Leave Period End Date":=HRSetup."Leave Posting Period[TO]";
      // //MedGjline."No. of Days":="Approved days";
      // IF MedGjline.Amount<>0 THEN
      // MedGjline.INSERT(TRUE);
      //
      // //Post Journal
      // MedGjline.RESET;
      // MedGjline.SETRANGE("Journal Template Name",HRSetup."Leave Template");
      // MedGjline.SETRANGE("Journal Batch Name",HRSetup."Leave Batch");
      // IF MedGjline.FIND('-') THEN BEGIN
      // CODEUNIT.RUN(CODEUNIT::Codeunit55560,MedGjline);
      // END;
      // Status:=Status::Posted;
      // MODIFY;
      // END;
    END;

    BEGIN
    END.
  }
}

