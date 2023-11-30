OBJECT table 17209 HR Leave Register
{
  OBJECT-PROPERTIES
  {
    Date=09/06/17;
    Time=[ 4:50:58 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    CaptionML=ENU=Leave Register;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Integer       ;CaptionML=ENU=No. }
    { 2   ;   ;From Entry No.      ;Integer       ;CaptionML=ENU=From Entry No. }
    { 3   ;   ;To Entry No.        ;Integer       ;CaptionML=ENU=To Entry No. }
    { 4   ;   ;Creation Date       ;Date          ;CaptionML=ENU=Creation Date }
    { 5   ;   ;Source Code         ;Code20        ;TableRelation="Source Code";
                                                   CaptionML=ENU=Source Code }
    { 6   ;   ;User ID             ;Code50        ;TableRelation=User;
                                                   OnLookup=VAR
                                                              LoginMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              LoginMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   CaptionML=ENU=User ID }
    { 7   ;   ;Journal Batch Name  ;Code20        ;CaptionML=ENU=Journal Batch Name }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Creation Date                            }
    {    ;Source Code,Journal Batch Name,Creation Date }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

