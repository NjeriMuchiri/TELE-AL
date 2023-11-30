OBJECT table 20394 HR Journal Line
{
  OBJECT-PROPERTIES
  {
    Date=02/09/21;
    Time=[ 9:55:17 AM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               {//JnlLineDim.LOCKTABLE;
               //LOCKTABLE;
               InsuranceJnlTempl.GET("Journal Template Name");
               "Source Code" := InsuranceJnlTempl."Source Code";
               InsuranceJnlBatch.GET("Journal Template Name","Journal Batch Name");
               "Reason Code" := InsuranceJnlBatch."Reason Code";

               ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
               ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");

               DimMgt.InsertJnlLineDim(
                 DATABASE::"HR Journal Line",
                 "Journal Template Name","Journal Batch Name","Line No.",0,
                 "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");  }



               {HR.RESET;
               IF HR.FIND('-') THEN BEGIN
               "Leave Period Start Date":=HR."Leave Posting Period[FROM]";
               "Leave Period End Date":=HR."Leave Posting Period[TO]";
               END;
               VALIDATE("Leave Period Start Date");
               VALIDATE("Leave Period End Date");  }
             END;

    OnDelete=BEGIN
               {DimMgt.DeleteJnlLineDim(
                 DATABASE::"HR Journal Line",
                 "Journal Template Name","Journal Batch Name","Line No.",0);
                   }
             END;

    CaptionML=ENU=HR Journal Line;
  }
  FIELDS
  {
    { 1   ;   ;Journal Template Name;Code10       ;TableRelation="HR Leave Journal Template".Name }
    { 2   ;   ;Journal Batch Name  ;Code10        ;TableRelation="HR Leave Journal Batch".Name WHERE (Journal Template Name=FIELD(Journal Batch Name));
                                                   CaptionML=ENU=Journal Batch Name }
    { 3   ;   ;Line No.            ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=ENU=Line No. }
    { 4   ;   ;Leave Period        ;Code20        ;TableRelation="HR Leave Periods"."Period Code" WHERE (Closed=CONST(No));
                                                   OnValidate=BEGIN
                                                                {IF "Leave Application No." = '' THEN BEGIN
                                                                  CreateDim(DATABASE::Table5628,"Leave Application No.");
                                                                  EXIT;
                                                                END;

                                                                Insurance.GET("Leave Application No.");
                                                                //Insurance.TESTFIELD(Blocked,FALSE);
                                                                Description := Insurance.Description;
                                                                "Leave Approval Date":=Insurance."HOD Start Date";
                                                                "No. of Days":=Insurance."HOD Approved Days";
                                                                "Leave Type Code":=Insurance."Leave Code";
                                                                CreateDim(DATABASE::Table5628,"Leave Application No.");
                                                                  }
                                                              END;

                                                   CaptionML=ENU=Leave Period }
    { 6   ;   ;Staff No.           ;Code20        ;TableRelation="HR Employees";
                                                   OnValidate=BEGIN
                                                                IF "Staff No." = '' THEN BEGIN
                                                                  "Staff Name" := '';
                                                                  EXIT;
                                                                END;
                                                                FA.GET("Staff No.");
                                                                "Staff Name" := FA.FullName;
                                                              END;

                                                   CaptionML=ENU=Staff No. }
    { 7   ;   ;Staff Name          ;Text120       ;CaptionML=ENU=Staff Name;
                                                   Editable=No }
    { 8   ;   ;Posting Date        ;Date          ;CaptionML=ENU=Posting Date }
    { 9   ;   ;Leave Entry Type    ;Option        ;CaptionML=ENU=Leave Entry Type;
                                                   OptionCaptionML=ENU=Positive,Negative,Reimbursement;
                                                   OptionString=Positive,Negative,Reimbursement;
                                                   Editable=Yes }
    { 10  ;   ;Leave Approval Date ;Date          ;CaptionML=ENU=Leave Approval Date;
                                                   Editable=No }
    { 11  ;   ;Document No.        ;Code20        ;CaptionML=ENU=Document No. }
    { 12  ;   ;External Document No.;Code20       ;CaptionML=ENU=External Document No. }
    { 13  ;   ;No. of Days         ;Decimal       ;OnValidate=BEGIN
                                                                IF LeaveType.GET("Leave Type") THEN BEGIN
                                                                IF (LeaveType."Fixed Days"=TRUE) THEN BEGIN
                                                                IF "No. of Days">LeaveType.Days THEN
                                                                ERROR(Text001,"Leave Type");

                                                                END;
                                                                END;
                                                              END;

                                                   CaptionML=ENU=No. of Days;
                                                   Editable=Yes;
                                                   AutoFormatType=1 }
    { 14  ;   ;Description         ;Text50        ;CaptionML=ENU=Description }
    { 15  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                {ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                                MODIFY;
                                                                }
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 1 Code;
                                                   CaptionClass='1,2,1' }
    { 16  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                {ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                                MODIFY;}
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 2 Code;
                                                   CaptionClass='1,2,2' }
    { 17  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=ENU=Reason Code }
    { 18  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=ENU=Source Code }
    { 20  ;   ;Index Entry         ;Boolean       ;CaptionML=ENU=Index Entry }
    { 21  ;   ;Posting No. Series  ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=Posting No. Series }
    { 22  ;   ;Leave Type          ;Code20        ;TableRelation="HR Leave Types".Code;
                                                   OnValidate=BEGIN
                                                                       //   IF HRLeaveTypes.GET("Leave Type") THEN
                                                                        //  "No. of Days":=HRLeaveTypes.Days;
                                                              END;

                                                   Editable=Yes }
    { 23  ;   ;Leave Recalled No.  ;Code20        ;OnValidate=BEGIN
                                                                {IF "Document No." = '' THEN BEGIN
                                                                  CreateDim(DATABASE::Table5628,"Leave Application No.");
                                                                  EXIT;
                                                                END;

                                                                Insurance.GET("Leave Application No.");
                                                                //Insurance.TESTFIELD(Blocked,FALSE);
                                                                Description := Insurance.Description;
                                                                "Leave Approval Date":=Insurance."HOD Start Date";
                                                                "No. of Days":=Insurance."HOD Approved Days";
                                                                "Leave Type Code":=Insurance."Leave Code";
                                                                CreateDim(DATABASE::Table5628,"Leave Application No.");
                                                                }
                                                              END;

                                                   CaptionML=ENU=Leave Application No. }
    { 26  ;   ;Leave Period Start Date;Date       ;TableRelation="HR Leave Periods"."Starting Date";
                                                   OnValidate=BEGIN


                                                                //"Leave Period End Date":=CALCDATE('-1D',CALCDATE('12M',"Leave Period Start Date"));
                                                              END;
                                                               }
    { 27  ;   ;Leave Period End Date;Date          }
    { 28  ;   ;Positive Transaction Type;Option   ;OptionCaptionML=ENU=" ,Leave Allocation,Leave Recall,OverTime";
                                                   OptionString=[ ,Leave Allocation,Leave Recall,OverTime] }
    { 29  ;   ;Negative Transaction Type;Option   ;OptionCaptionML=ENU=" ,Leave Taken,Leave Forfeited ";
                                                   OptionString=[ ,Leave Taken,Leave Forfeited ] }
    { 30  ;   ;Leave Application No.;Code20       ;TableRelation="HR Leave Application"."Application Code";
                                                   OnValidate=BEGIN
                                                                IF "Leave Application No." = '' THEN BEGIN
                                                                  CreateDim(DATABASE::Insurance,"Leave Application No.");
                                                                  EXIT;
                                                                END;
                                                                Insurance.RESET;
                                                                Insurance.SETRANGE(Insurance."Application Code","Leave Application No.");
                                                                IF Insurance.FIND('-')THEN BEGIN
                                                                //Insurance.GET("Leave Application No.");
                                                                //Insurance.TESTFIELD(Blocked,FALSE);
                                                                Description := Insurance."Applicant Comments";
                                                                "Leave Approval Date":=Insurance."Start Date";
                                                                "No. of Days":=Insurance."Approved days";
                                                                "Leave Type":=Insurance."Leave Type";
                                                                END;
                                                                CreateDim(DATABASE::Insurance,"Leave Application No.");
                                                              END;

                                                   CaptionML=ENU=Leave Application No. }
    { 31  ;   ;Claim Type          ;Option        ;OptionString=Inpatient,Outpatient }
    { 32  ;   ;Amount              ;Integer        }
  }
  KEYS
  {
    {    ;Journal Template Name,Journal Batch Name,Line No.;
                                                   Clustered=Yes }
    {    ;Journal Template Name,Journal Batch Name,Posting Date;
                                                   MaintainSQLIndex=No }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Insurance@1000 : Record 51516191;
      FA@1001 : Record 51516160;
      InsuranceJnlTempl@1002 : Record 51516195;
      InsuranceJnlBatch@1003 : Record 51516196;
      InsuranceJnlLine@1004 : Record 51516410;
      NoSeriesMgt@1005 : Codeunit 396;
      DimMgt@1006 : Codeunit 408;
      LeaveType@1102755000 : Record 51516193;
      Text001@1102755001 : TextConst 'ENU=You can not post more than maximum days allowed for this leave type %1';
      LeavePeriod@1102755002 : Record 51516198;
      HRLeaveTypes@1102755003 : Record 51516193;
      HR@1102755004 : Record 51516192;

    PROCEDURE SetUpNewLine@8(LastInsuranceJnlLine@1000 : Record 51516410);
    BEGIN
      {InsuranceJnlTempl.GET("Journal Template Name");
      InsuranceJnlBatch.GET("Journal Template Name","Journal Batch Name");
      InsuranceJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
      InsuranceJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
      IF InsuranceJnlLine.FIND('-') THEN BEGIN
        "Posting Date" := LastInsuranceJnlLine."Posting Date";
        "Document No." := LastInsuranceJnlLine."Document No.";
      END ELSE BEGIN
        "Posting Date" := WORKDATE;
        IF InsuranceJnlBatch."No. Series" <> '' THEN BEGIN
          CLEAR(NoSeriesMgt);
          "Document No." := NoSeriesMgt.TryGetNextNo(InsuranceJnlBatch."No. Series","Posting Date");
        END;
      END;
      "Source Code" := InsuranceJnlTempl."Source Code";
      "Reason Code" := InsuranceJnlBatch."Reason Code";
      "Posting No. Series" := InsuranceJnlBatch."Posting No. Series";
      }
    END;

    PROCEDURE CreateDim@13(Type1@1000 : Integer;No1@1001 : Code[20]);
    VAR
      TableID@1002 : ARRAY [10] OF Integer;
      No@1003 : ARRAY [10] OF Code[20];
    BEGIN
      {TableID[1] := Type1;
      No[1] := No1;
      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      DimMgt.GetDefaultDim(
        TableID,No,"Source Code",
        "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      IF "Line No." <> 0 THEN
        DimMgt.UpdateJnlLineDefaultDim(
          DATABASE::Table5635,
          "Journal Template Name","Journal Batch Name","Line No.",0,
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        }
    END;

    PROCEDURE ValidateShortcutDimCode@14(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      {DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      IF "Line No." <> 0 THEN BEGIN
        DimMgt.SaveJnlLineDim(
          DATABASE::Table5635,"Journal Template Name",
          "Journal Batch Name","Line No.",0,FieldNumber,ShortcutDimCode);
        IF MODIFY THEN;
      END ELSE
        DimMgt.SaveTempDim(FieldNumber,ShortcutDimCode);
       }
    END;

    PROCEDURE LookupShortcutDimCode@18(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      {DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      IF "Line No." <> 0 THEN BEGIN
        DimMgt.SaveJnlLineDim(
          DATABASE::Table5635,"Journal Template Name",
          "Journal Batch Name","Line No.",0,FieldNumber,ShortcutDimCode);
        MODIFY;
      END ELSE
        DimMgt.SaveTempDim(FieldNumber,ShortcutDimCode);
      }
    END;

    PROCEDURE ShowShortcutDimCode@15(VAR ShortcutDimCode@1000 : ARRAY [8] OF Code[20]);
    BEGIN
      {IF "Line No." <> 0 THEN
        DimMgt.ShowJnlLineDim(
          DATABASE::Table5635,"Journal Template Name",
          "Journal Batch Name","Line No.",0,ShortcutDimCode)
      ELSE
        DimMgt.ShowTempDim(ShortcutDimCode);
      }
    END;

    PROCEDURE ValidateOpenPeriod@1102755000(LeavePeriod@1102755000 : Record 51516228);
    VAR
      Rec1@1102755001 : Record 51516189;
    BEGIN
      {WITH LeavePeriod DO
      BEGIN
       Rec1.RESET;
      IF Rec1.FIND('-')THEN BEGIN
      "Leave Period Start Date":=Rec1."Starting Date";
      VALIDATE("Leave Period Start Date");    `
      END;
      END;}
    END;

    BEGIN
    END.
  }
}

