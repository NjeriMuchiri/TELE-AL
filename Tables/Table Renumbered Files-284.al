OBJECT table 20428 Checkoff Header-DistributedD
{
  OBJECT-PROPERTIES
  {
    Date=08/04/17;
    Time=[ 3:25:57 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN

               IF No = '' THEN BEGIN
               NoSetup.GET();
               NoSetup.TESTFIELD(NoSetup."Checkoff-Proc Distributed Nos");
               NoSeriesMgt.InitSeries(NoSetup."Checkoff-Proc Distributed Nos",xRec."No. Series",0D,No,"No. Series");
               END;

               "Date Entered":=TODAY;
               "Time Entered":=TIME;
               "Entered By":=UPPERCASE(USERID);
             END;

    OnModify=BEGIN

               IF Posted = TRUE THEN
               ERROR('You cannot modify a Posted Check Off');
             END;

    OnDelete=BEGIN
               IF Posted = TRUE THEN
               ERROR('You cannot delete a Posted Check Off');
             END;

    OnRename=BEGIN
               IF Posted = TRUE THEN
               ERROR('You cannot rename a Posted Check Off');
             END;

  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20        ;OnValidate=BEGIN

                                                                IF No <> xRec.No THEN BEGIN
                                                                  NoSetup.GET();
                                                                  NoSeriesMgt.TestManual(NoSetup."Checkoff-Proc Distributed Nos");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;No. Series          ;Code20         }
    { 3   ;   ;Posted              ;Boolean       ;Editable=Yes }
    { 6   ;   ;Posted By           ;Code60        ;Editable=No }
    { 7   ;   ;Date Entered        ;Date           }
    { 9   ;   ;Entered By          ;Text60         }
    { 10  ;   ;Remarks             ;Text150        }
    { 19  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter }
    { 20  ;   ;Time Entered        ;Time           }
    { 21  ;   ;Posting date        ;Date           }
    { 22  ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset }
    { 23  ;   ;Account No          ;Code30        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account" ELSE IF (Account Type=CONST(Customer)) Customer ELSE IF (Account Type=CONST(Vendor)) Vendor ELSE IF (Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset";
                                                   OnValidate=BEGIN
                                                                IF "Account Type"="Account Type"::Customer THEN BEGIN
                                                                CustDeb.RESET;
                                                                CustDeb.SETRANGE(CustDeb."No.","Account No");
                                                                IF CustDeb.FIND('-') THEN BEGIN
                                                                "Employer Name":=CustDeb.Name;
                                                                "Account No":=CustDeb."No.";
                                                                END;
                                                                END;

                                                                IF "Account Type"="Account Type"::Vendor THEN BEGIN
                                                                Vend.RESET;
                                                                Vend.SETRANGE(Vend."No.","Account No");
                                                                IF Vend.FIND('-') THEN BEGIN
                                                                "Account Name":=Vend.Name;
                                                                "Account No":=Vend."No.";
                                                                END;
                                                                END;

                                                                IF "Account Type"="Account Type"::"G/L Account" THEN BEGIN
                                                                "GL Account".RESET;
                                                                "GL Account".SETRANGE("GL Account"."No.","Account No");
                                                                IF "GL Account".FIND('-') THEN BEGIN
                                                                "Account Name":="GL Account".Name;
                                                                END;
                                                                END;

                                                                IF "Account Type"="Account Type"::"Bank Account" THEN BEGIN
                                                                BANKACC.RESET;
                                                                BANKACC.SETRANGE(BANKACC."No.","Account No");
                                                                IF BANKACC.FIND('-') THEN BEGIN
                                                                "Account Name":=BANKACC.Name;

                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 24  ;   ;Document No         ;Code20         }
    { 25  ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                  {
                                                                IF Amount<>"Scheduled Amount" THEN
                                                                ERROR('The Amount must be equal to the Scheduled Amount');
                                                                    }
                                                              END;
                                                               }
    { 26  ;   ;Scheduled Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Checkoff Lines-Distributed".Amount WHERE (Receipt Header No=FIELD(No)));
                                                   Editable=No }
    { 27  ;   ;Total Count         ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Checkoff Lines-Distributed" WHERE (Receipt Header No=FIELD(No))) }
    { 28  ;   ;Account Name        ;Code50         }
    { 29  ;   ;Employer Code       ;Code30        ;TableRelation="Sacco Employers".Code }
    { 30  ;   ;Un Allocated amount-surplus;Decimal }
    { 31  ;   ;Employer Name       ;Text100        }
    { 32  ;   ;Loan CutOff Date    ;Date           }
    { 33  ;   ;Interest Amount     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Checkoff Lines-Distributed".Amount WHERE (Receipt Header No=FIELD(No), Reference=FILTER(SINTEREST))) }
    { 34  ;   ;Employer No.(Old)   ;Code20        ;TableRelation=IF (Account Type=CONST(Customer)) Customer."Our Account No." }
    { 35  ;   ;Branch              ;Code20        ;TableRelation="Dimension Value".Code }
    { 36  ;   ;Use ID Number       ;Boolean        }
  }
  KEYS
  {
    {    ;No                                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NoSetup@1102755004 : Record 51516399;
      NoSeriesMgt@1102755003 : Codeunit 396;
      cust@1102755002 : Record 51516364;
      "GL Account"@1102755001 : Record 15;
      BANKACC@1102755000 : Record 270;
      CustDeb@1000000000 : Record 18;
      Vend@1000000001 : Record 23;

    BEGIN
    END.
  }
}

