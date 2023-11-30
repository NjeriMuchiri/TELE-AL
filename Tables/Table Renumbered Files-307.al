OBJECT table 20451 Sky Black-Listed Phone Nos
{
  OBJECT-PROPERTIES
  {
    Date=11/23/20;
    Time=12:08:55 PM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               StatusPermission.RESET;
               StatusPermission.SETRANGE("User ID",USERID);
               StatusPermission.SETRANGE("Black-List Accounts",TRUE);
               IF NOT StatusPermission.FIND('-') THEN BEGIN
                   ERROR('You do not have the following permission: "Black-List Accounts"');
               END;

               "Black-Listed By" := USERID;
               "Date Black-Listed" := TODAY;
             END;

    OnModify=BEGIN

               StatusPermission.RESET;
               StatusPermission.SETRANGE("User ID",USERID);
               StatusPermission.SETRANGE("Black-List Accounts",TRUE);
               IF NOT StatusPermission.FIND('-') THEN BEGIN
                   ERROR('You do not have the following permission: "Black-List Accounts"');
               END;


               "Black-Listed By" := USERID;
               "Date Black-Listed" := TODAY;
             END;

    OnDelete=BEGIN

               ERROR('Action not Allowed');
             END;

  }
  FIELDS
  {
    { 1   ;   ;Transactional Phone No.;Code20      }
    { 2   ;   ;Black-Listed        ;Boolean       ;OnValidate=BEGIN
                                                                TESTFIELD(Reason);
                                                                "Black-Listed By":=USERID;
                                                                "Date Black-Listed":=TODAY;
                                                              END;
                                                               }
    { 3   ;   ;Black-Listed By     ;Code50        ;Editable=No }
    { 4   ;   ;Date Black-Listed   ;Date          ;Editable=No }
    { 5   ;   ;Reason              ;Text50         }
  }
  KEYS
  {
    {    ;Transactional Phone No.                 ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      StatusPermission@1000 : Record 51516702;

    BEGIN
    END.
  }
}

