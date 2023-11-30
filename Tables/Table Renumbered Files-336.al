OBJECT table 20481 Project User Setup
{
  OBJECT-PROPERTIES
  {
    Date=10/18/15;
    Time=12:26:46 PM;
    Modified=Yes;
    Version List=Project ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;User ID             ;Code20        ;OnValidate=BEGIN
                                                                 UserManager.ValidateUserID(USERID);
                                                              END;

                                                   OnLookup=BEGIN
                                                                UserManager.LookupUserID("User ID");
                                                            END;
                                                             }
    { 11  ;   ;Reclassification Template;Code20   ;TableRelation="FA Reclass. Journal Template".Name }
    { 12  ;   ;Reclassification Batch;Code20      ;TableRelation="FA Reclass. Journal Batch".Name WHERE (Journal Template Name=FIELD(Reclassification Template)) }
    { 13  ;   ;General Journal Template;Code20     }
    { 14  ;   ;General Journal Batch;Code20        }
  }
  KEYS
  {
    {    ;User ID                                 ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      UserManager@1000 : Codeunit 418;

    BEGIN
    END.
  }
}

