OBJECT table 17318 EFT Header Details
{
  OBJECT-PROPERTIES
  {
    Date=08/31/16;
    Time=10:58:37 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF No = '' THEN BEGIN
               NoSetup.GET();
               NoSetup.TESTFIELD(NoSetup."EFT Header Nos.");
               NoSeriesMgt.InitSeries(NoSetup."EFT Header Nos.",xRec."No. Series",0D,No,"No. Series");
               END;


               "Date Entered":=TODAY;
               "Time Entered":=TIME;
               "Entered By":=USERID;
             END;

    OnModify=BEGIN
               IF Transferred = TRUE THEN
               ERROR('You cannot modify an already posted record.');
             END;

    OnDelete=BEGIN
               IF Transferred = TRUE THEN
               ERROR('You cannot delete an already posted record.');
             END;

  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20        ;OnValidate=BEGIN
                                                                IF No <> xRec.No THEN BEGIN
                                                                  NoSetup.GET();
                                                                  NoSeriesMgt.TestManual(NoSetup."EFT Header Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 3   ;   ;Transferred         ;Boolean       ;Editable=Yes }
    { 4   ;   ;Date Transferred    ;Date          ;Editable=No }
    { 5   ;   ;Time Transferred    ;Time          ;Editable=No }
    { 6   ;   ;Transferred By      ;Text20        ;Editable=No }
    { 7   ;   ;Date Entered        ;Date           }
    { 8   ;   ;Time Entered        ;Time           }
    { 9   ;   ;Entered By          ;Text20         }
    { 10  ;   ;Remarks             ;Text150        }
    { 11  ;   ;Payee Bank Name     ;Text50         }
    { 12  ;   ;Bank  No            ;Code20        ;TableRelation="Bank Account";
                                                   OnValidate=BEGIN

                                                                Banks.RESET;
                                                                IF Banks.GET("Bank  No") THEN BEGIN
                                                                "Payee Bank Name":=Banks.Name;
                                                                END;
                                                              END;
                                                               }
    { 13  ;   ;Salary Processing No.;Code20        }
    { 14  ;   ;Salary Options      ;Option        ;OptionString=Add To Existing,Replace Lines }
    { 15  ;   ;Total               ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("EFT Details".Amount WHERE (Header No=FIELD(No)));
                                                   Editable=No }
    { 16  ;   ;Total Count         ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("EFT Details" WHERE (Header No=FIELD(No)));
                                                   Editable=No }
    { 17  ;   ;RTGS                ;Boolean       ;OnValidate=BEGIN
                                                                EFTDetails.RESET;
                                                                EFTDetails.SETRANGE(EFTDetails."Header No",No);
                                                                IF EFTDetails.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                IF Accounts.GET(EFTDetails."Account No") THEN BEGIN
                                                                IF AccountTypes.GET(Accounts."Account Type") THEN BEGIN
                                                                IF EFTDetails."Destination Account Type" = EFTDetails."Destination Account Type"::External THEN
                                                                EFTDetails.Charges:=AccountTypes."External EFT Charges"
                                                                ELSE
                                                                EFTDetails.Charges:=AccountTypes."Internal EFT Charges";

                                                                AccountTypes.TESTFIELD(AccountTypes."EFT Charges Account");
                                                                EFTDetails."EFT Charges Account":=AccountTypes."EFT Charges Account";

                                                                IF RTGS = TRUE THEN BEGIN
                                                                EFTDetails.Charges:=AccountTypes."RTGS Charges";
                                                                AccountTypes.TESTFIELD(AccountTypes."RTGS Charges Account");
                                                                EFTDetails."EFT Charges Account":=AccountTypes."RTGS Charges Account";
                                                                END;

                                                                END;

                                                                END;


                                                                EFTDetails.MODIFY;
                                                                UNTIL EFTDetails.NEXT = 0;
                                                                END;
                                                              END;
                                                               }
    { 18  ;   ;Document No. Filter ;Code250       ;FieldClass=FlowFilter }
    { 19  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter }
    { 20  ;   ;Cheque No           ;Code20         }
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
      NoSetup@1000000001 : Record 51516258;
      NoSeriesMgt@1000000000 : Codeunit 396;
      Accounts@1000000002 : Record 23;
      Members@1000000003 : Record 23;
      AccountHolders@1000000004 : Record 23;
      Banks@1000000005 : Record 270;
      BanksList@1000000008 : Record 51516311;
      EFTDetails@1102760000 : Record 51516315;
      AccountTypes@1102760001 : Record 51516295;

    BEGIN
    END.
  }
}

