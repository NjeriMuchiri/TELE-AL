OBJECT table 50068 HR Medical Schemes
{
  OBJECT-PROPERTIES
  {
    Date=04/22/20;
    Time=10:33:44 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Scheme No           ;Code10         }
    { 2   ;   ;Medical Insurer     ;Code10        ;TableRelation=Vendor.No.;
                                                   OnValidate=BEGIN

                                                                         Insurer.RESET;
                                                                         Insurer.SETRANGE(Insurer."No.","Medical Insurer");
                                                                          IF Insurer.FIND('-') THEN BEGIN
                                                                         "Insurer Name":=Insurer.Name;

                                                                          END;
                                                              END;
                                                               }
    { 3   ;   ;Scheme Name         ;Text250        }
    { 4   ;   ;In-patient limit    ;Decimal        }
    { 5   ;   ;Out-patient limit   ;Decimal        }
    { 6   ;   ;Area Covered        ;Text30         }
    { 7   ;   ;Dependants Included ;Boolean        }
    { 8   ;   ;Comments            ;Text100        }
    { 9   ;   ;Insurer Name        ;Text250        }
    { 10  ;   ;Employee No         ;Code20         }
    { 11  ;   ;First Name          ;Text30         }
    { 12  ;   ;Last Name           ;Text30         }
    { 13  ;   ;Designation         ;Text30         }
    { 14  ;   ;Scheme Join Date    ;Date           }
  }
  KEYS
  {
    {    ;Scheme No                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Insurer@1102755000 : Record 23;

    BEGIN
    END.
  }
}

