OBJECT table 17320 Salary Processing Header
{
  OBJECT-PROPERTIES
  {
    Date=03/21/23;
    Time=[ 2:08:08 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               //
               // IF No = '' THEN BEGIN
               // NoSetup.GET();
               // NoSetup.TESTFIELD(NoSetup.);
               // NoSeriesMgt.InitSeries(NoSetup."Salary Processing Nos",xRec."No. Series",0D,No,"No. Series");
               // END;
               //
               // "Date Entered":=TODAY;
               // "Time Entered":=TIME;
               // "Entered By":=UPPERCASE(USERID);
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

    LookupPageID=Page50222;
    DrillDownPageID=Page50222;
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20        ;OnValidate=BEGIN
                                                                {
                                                                IF No <> xRec.No THEN BEGIN
                                                                  NoSetup.GET();
                                                                  NoSeriesMgt.TestManual(NoSetup."Salary Processing Nos");
                                                                  "No. Series" := '';
                                                                END;
                                                                }
                                                              END;
                                                               }
    { 2   ;   ;No. Series          ;Code20         }
    { 3   ;   ;Posted              ;Boolean       ;Editable=No }
    { 6   ;   ;Posted By           ;Code20        ;Editable=No }
    { 7   ;   ;Date Entered        ;Date           }
    { 9   ;   ;Entered By          ;Text20         }
    { 10  ;   ;Remarks             ;Text150        }
    { 19  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter }
    { 20  ;   ;Time Entered        ;Time           }
    { 21  ;   ;Posting date        ;Date           }
    { 22  ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=G/L Account,Customer/Employer,Vendor,Bank Account,Fixed Asset;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset }
    { 23  ;   ;Account No          ;Code30        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Account Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset";
                                                   OnValidate=BEGIN
                                                                IF "Account Type"="Account Type"::Customer THEN BEGIN
                                                                cust.RESET;
                                                                cust.SETRANGE(cust."No.","Account No");
                                                                IF cust.FIND('-') THEN BEGIN
                                                                "Account Name":=cust.Name;

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
                                                   CalcFormula=Sum("Member Section".Field5 WHERE (Field62003=FIELD(No)));
                                                   Editable=No }
    { 27  ;   ;Total Count         ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Member Section" WHERE (Field62003=FIELD(No))) }
    { 28  ;   ;Account Name        ;Code50         }
    { 29  ;   ;Employer Code       ;Code30        ;TableRelation="HR Leave Application"."Application Code" }
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
      NoSetup@1102755004 : Record 312;
      NoSeriesMgt@1102755003 : Codeunit 396;
      cust@1102755002 : Record 51516223;
      "GL Account"@1102755001 : Record 15;
      BANKACC@1102755000 : Record 270;

    BEGIN
    END.
  }
}

