OBJECT table 20447 Dummy MPESA Nos
{
  OBJECT-PROPERTIES
  {
    Date=11/23/20;
    Time=12:07:11 PM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    OnInsert=BEGIN

               IF COPYSTR("Phone No",1,1)<>'+' THEN
                 "Phone No":='+'+"Phone No";

               IF SkyAuth.GET("Phone No") THEN BEGIN
                   SkyAuth."User Status" := SkyAuth."User Status"::Inactive;
                   SkyAuth.MODIFY;
               END;
             END;

  }
  FIELDS
  {
    { 1   ;   ;Account No.         ;Code20         }
    { 2   ;   ;Phone No            ;Code20         }
    { 3   ;   ;Not Found           ;Boolean        }
    { 4   ;   ;Updated             ;Boolean        }
  }
  KEYS
  {
    {    ;Account No.                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SkyAuth@1000 : Record 51516709;

    BEGIN
    END.
  }
}

