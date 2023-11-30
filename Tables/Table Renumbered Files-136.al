OBJECT table 17254 Interest Due Period
{
  OBJECT-PROPERTIES
  {
    Date=02/18/16;
    Time=11:16:50 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN

               AccountingPeriod2 := Rec;
               IF AccountingPeriod2.FIND('>') THEN
                 AccountingPeriod2.TESTFIELD("Date Locked",FALSE);
               UpdateAvgItems(1);
             END;

    OnModify=BEGIN
               UpdateAvgItems(2);
             END;

    OnDelete=BEGIN
               TESTFIELD("Date Locked",FALSE);
               UpdateAvgItems(3);
             END;

    OnRename=BEGIN

               TESTFIELD("Date Locked",FALSE);
               AccountingPeriod2 := Rec;
               IF AccountingPeriod2.FIND('>') THEN
                 AccountingPeriod2.TESTFIELD("Date Locked",FALSE);
               UpdateAvgItems(4);
             END;

  }
  FIELDS
  {
    { 1   ;   ;Interest Due Date   ;Date          ;OnValidate=BEGIN
                                                                Name := FORMAT("Interest Due Date",0,Text000);
                                                              END;

                                                   CaptionML=ENU=Interest Due Date;
                                                   NotBlank=Yes }
    { 2   ;   ;Name                ;Text10        ;CaptionML=ENU=Name }
    { 3   ;   ;New Fiscal Year     ;Boolean       ;OnValidate=BEGIN
                                                                TESTFIELD("Date Locked",FALSE);
                                                                IF "New Fiscal Year" THEN BEGIN
                                                                  IF NOT InvtSetup.GET THEN
                                                                    EXIT;
                                                                  "Average Cost Calc. Type" := InvtSetup."Average Cost Calc. Type";
                                                                  "Average Cost Period" := InvtSetup."Average Cost Period";
                                                                END ELSE BEGIN
                                                                  "Average Cost Calc. Type" := "Average Cost Calc. Type"::" ";
                                                                  "Average Cost Period" := "Average Cost Period"::" ";
                                                                END;
                                                              END;

                                                   CaptionML=ENU=New Fiscal Year }
    { 4   ;   ;Closed              ;Boolean       ;CaptionML=ENU=Closed;
                                                   Editable=Yes }
    { 5   ;   ;Date Locked         ;Boolean       ;CaptionML=ENU=Date Locked;
                                                   Editable=Yes }
    { 5804;   ;Average Cost Calc. Type;Option     ;CaptionML=ENU=Average Cost Calc. Type;
                                                   OptionCaptionML=ENU=" ,Item,Item & Location & Variant";
                                                   OptionString=[ ,Item,Item & Location & Variant];
                                                   Editable=No }
    { 5805;   ;Average Cost Period ;Option        ;CaptionML=ENU=Average Cost Period;
                                                   OptionCaptionML=ENU=" ,Day,Week,Month,Quarter,Year,Accounting Period";
                                                   OptionString=[ ,Day,Week,Month,Quarter,Year,Accounting Period];
                                                   Editable=No }
    { 50000;  ;Closed by User      ;Code20         }
    { 50001;  ;Closing Date Time   ;DateTime       }
    { 50002;  ;Posting Document No.;Code20         }
    { 50003;  ;Interest Calcuation Date;Date      ;OnValidate=BEGIN
                                                                Name := FORMAT("Interest Due Date",0,Text000);
                                                              END;

                                                   CaptionML=ENU=Interest Calculation Date;
                                                   NotBlank=Yes }
  }
  KEYS
  {
    {    ;Interest Due Date                       ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      AccountingPeriod2@1001 : Record 51516250;
      InvtSetup@1000 : Record 313;
      Text000@1002 : TextConst 'ENU=<Month Text>';

    PROCEDURE UpdateAvgItems@1(UpdateType@1005 : Option);
    VAR
      ChangeAvgCostSetting@1002 : Codeunit 5810;
    BEGIN
      //ChangeAvgCostSetting.UpdateAvgCostFromAccPeriodChg(Rec,xRec,UpdateType);
    END;

    BEGIN
    END.
  }
}

