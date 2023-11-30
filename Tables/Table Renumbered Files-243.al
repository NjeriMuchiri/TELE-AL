OBJECT table 20385 File Movement Line
{
  OBJECT-PROPERTIES
  {
    Date=07/22/20;
    Time=[ 3:14:41 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Document No.        ;Code20         }
    { 2   ;   ;File Type           ;Code20        ;TableRelation="File Types SetUp".Code }
    { 3   ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=Member Account,FOSA Account;
                                                   OptionString=Member Account,FOSA Account }
    { 4   ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type=CONST(Member Account)) "Members Register".No.
                                                                 ELSE IF (Account Type=CONST(FOSA Account)) Vendor.No.;
                                                   OnValidate=BEGIN
                                                                IF "Account Type"="Account Type"::"FOSA Account" THEN BEGIN
                                                                Vendor.RESET;
                                                                Vendor.SETRANGE(Vendor."No.","Account No.");
                                                                IF Vendor.FIND('-') THEN
                                                                  "Account Name":=Vendor.Name;
                                                                "Global Dimension 1 Code":='FOSA';
                                                                "Global Dimension 2 Code":='NAIROBI';
                                                                END ELSE IF "Account Type"="Account Type"::"Member Account" THEN BEGIN
                                                                IF Members.GET("Account No.") THEN BEGIN
                                                                "Account Name":=Members.Name;
                                                                 "Global Dimension 1 Code":='BOSA';
                                                                "Global Dimension 2 Code":='NAIROBI';
                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 5   ;   ;Purpose/Description ;Text100        }
    { 6   ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=FILTER(1)) }
    { 7   ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=FILTER(2)) }
    { 8   ;   ;Account Name        ;Text100       ;Editable=No }
    { 9   ;   ;File Number         ;Code50         }
    { 10  ;   ;Line No.            ;Integer       ;AutoIncrement=Yes }
    { 11  ;   ;Destination File Location;Code40   ;TableRelation="File Locations Setup".Location }
  }
  KEYS
  {
    {    ;Document No.                            ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Vendor@1120054000 : Record 23;
      Members@1120054001 : Record 51516223;

    BEGIN
    END.
  }
}

