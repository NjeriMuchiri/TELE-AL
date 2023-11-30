OBJECT table 17205 HR Leave Ledger Entries
{
  OBJECT-PROPERTIES
  {
    Date=02/09/21;
    Time=10:12:11 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    CaptionML=ENU=Leave Ledger Entry;
    LookupPageID=Page51516197;
    DrillDownPageID=Page51516197;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=ENU=Entry No. }
    { 2   ;   ;Leave Period        ;Code20        ;CaptionML=ENU=Leave Period }
    { 3   ;   ;Closed              ;Boolean       ;CaptionML=ENU=Closed }
    { 4   ;   ;Staff No.           ;Code20        ;CaptionML=ENU=Staff No. }
    { 5   ;   ;Staff Name          ;Text70        ;CaptionML=ENU=Staff Name }
    { 6   ;   ;Posting Date        ;Date          ;CaptionML=ENU=Posting Date }
    { 7   ;   ;Leave Entry Type    ;Option        ;CaptionML=ENU=Leave Entry Type;
                                                   OptionCaptionML=ENU=Positive,Negative,Reimbursement;
                                                   OptionString=Positive,Negative,Reimbursement }
    { 8   ;   ;Leave Approval Date ;Date          ;CaptionML=ENU=Leave Approval Date }
    { 9   ;   ;Document No.        ;Code20        ;CaptionML=ENU=Document No. }
    { 10  ;   ;External Document No.;Code20       ;CaptionML=ENU=External Document No. }
    { 11  ;   ;Job ID              ;Code20        ;TableRelation=Table0.Field4 }
    { 12  ;   ;Job Group           ;Code20        ;TableRelation=Table55622.Field23 }
    { 13  ;   ;Contract Type       ;Code20         }
    { 14  ;   ;No. of days         ;Decimal       ;CaptionML=ENU=No. of days;
                                                   AutoFormatType=1 }
    { 15  ;   ;Leave Start Date    ;Date           }
    { 16  ;   ;Leave Posting Description;Text50   ;CaptionML=ENU=Leave Posting Description }
    { 17  ;   ;Leave End Date      ;Date           }
    { 18  ;   ;Leave Return Date   ;Date           }
    { 20  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   CaptionClass='1,1,1' }
    { 21  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=ENU=Global Dimension 2 Code;
                                                   CaptionClass='1,1,2' }
    { 22  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=ENU=Location Code }
    { 23  ;   ;User ID             ;Code50        ;TableRelation=User;
                                                   OnLookup=VAR
                                                              LoginMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              LoginMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   CaptionML=ENU=User ID }
    { 24  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=ENU=Source Code }
    { 25  ;   ;Journal Batch Name  ;Code10        ;CaptionML=ENU=Journal Batch Name }
    { 26  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=ENU=Reason Code }
    { 27  ;   ;Index Entry         ;Boolean       ;CaptionML=ENU=Index Entry }
    { 28  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series }
    { 29  ;   ;Leave Recalled No.  ;Code20        ;TableRelation="HR Leave Application"."Application Code" WHERE (Employee No=FIELD(Staff No.),
                                                                                                                  Status=CONST(Approved));
                                                   CaptionML=ENU=Leave Application No. }
    { 30  ;   ;Leave Type          ;Code20        ;TableRelation="HR Leave Types".Code }
    { 31  ;   ;Medical Date        ;Date           }
    { 32  ;   ;Amount              ;Decimal        }
    { 33  ;   ;Claim Type          ;Option        ;OptionString=Inpatient,Outpatient }
    { 34  ;   ;Period Closed       ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("HR Leave Periods".Closed WHERE (Period Code=FIELD(Leave Period)));
                                                   CaptionML=ENU=Closed }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Leave Period,Posting Date               ;SumIndexFields=No. of days }
    {    ;Leave Period,Closed,Posting Date        ;SumIndexFields=No. of days }
    {    ;Staff No.,Leave Period,Closed,Posting Date;
                                                   SumIndexFields=No. of days }
    {    ;Staff No.,Closed,Posting Date            }
    {    ;Posting Date,Leave Entry Type,Staff No. ;SumIndexFields=No. of days }
    {    ;Staff No.                               ;SumIndexFields=No. of days }
    {    ;Leave Entry Type,Staff No.,Leave Type,Closed;
                                                   SumIndexFields=No. of days }
    { No ;Leave Entry Type,Staff No.,Closed       ;SumIndexFields=No. of days }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Leave Period,Staff No.,Staff Name,Posting Date }
  }
  CODE
  {

    BEGIN
    END.
  }
}

