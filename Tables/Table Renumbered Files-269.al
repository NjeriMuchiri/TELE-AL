OBJECT table 20412 Investor Group Members
{
  OBJECT-PROPERTIES
  {
    Date=09/13/15;
    Time=[ 5:15:18 PM];
    Modified=Yes;
    Version List=Investment ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Investor No.        ;Code20         }
    { 11  ;   ;ID/Passport No      ;Code20         }
    { 12  ;   ;Name                ;Text100        }
    { 13  ;   ;Photo               ;BLOB          ;SubType=Bitmap }
    { 14  ;   ;Sgnature            ;BLOB          ;SubType=Bitmap }
    { 15  ;   ;Postal Code         ;Code20         }
    { 16  ;   ;Address             ;Code20         }
    { 17  ;   ;City                ;Code20         }
    { 18  ;   ;County              ;Code20         }
    { 19  ;   ;Mobile No.          ;Code20         }
    { 20  ;   ;Home Phone No.      ;Code20         }
    { 21  ;   ;Email Address       ;Text50         }
    { 22  ;   ;Pin Number          ;Code20         }
  }
  KEYS
  {
    {    ;Investor No.,ID/Passport No             ;Clustered=Yes }
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

