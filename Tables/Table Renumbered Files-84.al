OBJECT table 17202 HR Leave Periods
{
  OBJECT-PROPERTIES
  {
    Date=11/05/20;
    Time=[ 1:58:18 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               {
               AccountingPeriod2 := Rec;
               IF AccountingPeriod2.FIND('>') THEN
                 AccountingPeriod2.TESTFIELD(Description,FALSE);
               //UpdateAvgItems(1);
               }
             END;

    OnModify=BEGIN
               //UpdateAvgItems(2);
             END;

    OnDelete=BEGIN
               //TESTFIELD(Description,FALSE);
               //UpdateAvgItems(3);
             END;

    OnRename=BEGIN
               {
               TESTFIELD(Description,FALSE);
               AccountingPeriod2 := Rec;
               IF AccountingPeriod2.FIND('>') THEN
                 AccountingPeriod2.TESTFIELD(Description,FALSE);
               //UpdateAvgItems(4);
               }
             END;

    CaptionML=ENU=Leave Periods;
  }
  FIELDS
  {
    { 1   ;   ;Starting Date       ;Date          ;OnValidate=BEGIN
                                                                Name := FORMAT("Starting Date",0,Text000);
                                                              END;

                                                   CaptionML=ENU=Starting Date;
                                                   NotBlank=Yes }
    { 2   ;   ;Name                ;Text10        ;CaptionML=ENU=Name;
                                                   Editable=No }
    { 3   ;   ;New Fiscal Year     ;Boolean       ;OnValidate=BEGIN
                                                                TESTFIELD("Date Locked",FALSE);
                                                              END;

                                                   CaptionML=ENU=New Fiscal Year }
    { 4   ;   ;Closed              ;Boolean       ;CaptionML=ENU=Closed;
                                                   Editable=No }
    { 5   ;   ;Date Locked         ;Boolean       ;CaptionML=ENU=Date Locked;
                                                   Editable=No }
    { 6   ;   ;Reimbursement Clossing Date;Boolean }
    { 7   ;   ;Period Description  ;Text150        }
    { 8   ;   ;Period Code         ;Code10         }
    { 9   ;   ;End Date            ;Date           }
    { 10  ;   ;Date Opened         ;DateTime       }
    { 11  ;   ;Opened By           ;Code30         }
    { 12  ;   ;Date Closed         ;DateTime       }
    { 13  ;   ;Closed By           ;Code30         }
  }
  KEYS
  {
    {    ;Starting Date,Period Code               ;Clustered=Yes }
    {    ;New Fiscal Year,Date Locked              }
    {    ;Closed                                   }
    {    ;Period Code                              }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=<Month Text>';
      AccountingPeriod2@1001 : Record 51516198;
      InvtSetup@1002 : Record 313;

    PROCEDURE UpdateAvgItems@1();
    BEGIN
    END;

    BEGIN
    END.
  }
}

