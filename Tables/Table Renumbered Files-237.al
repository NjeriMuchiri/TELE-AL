OBJECT table 20378 HR Employment History
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=10:09:18 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Employee No.        ;Code20        ;TableRelation="HR Employees".No.;
                                                   NotBlank=No }
    { 2   ;   ;From                ;Date          ;NotBlank=No }
    { 3   ;   ;To Date             ;Date          ;NotBlank=No }
    { 4   ;   ;Company Name        ;Text150       ;NotBlank=No }
    { 5   ;   ;Postal Address      ;Text40         }
    { 6   ;   ;Address 2           ;Text40         }
    { 7   ;   ;Job Title           ;Text150        }
    { 8   ;   ;Key Experience      ;Text150        }
    { 9   ;   ;Salary On Leaving   ;Decimal        }
    { 10  ;   ;Reason For Leaving  ;Text150        }
    { 16  ;   ;Comment             ;Text200       ;FieldClass=Normal;
                                                   Editable=Yes }
  }
  KEYS
  {
    {    ;Employee No.,Company Name               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Employee@1000000000 : Record 51516160;
      OK@1000000001 : Boolean;

    BEGIN
    END.
  }
}

