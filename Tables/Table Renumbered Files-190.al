OBJECT table 17308 Cheque Types
{
  OBJECT-PROPERTIES
  {
    Date=08/10/23;
    Time=[ 2:51:29 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text50         }
    { 3   ;   ;Clearing Days       ;DateFormula    }
    { 4   ;   ;Clearing Charges    ;Decimal        }
    { 5   ;   ;Special Clearing Days;DateFormula   }
    { 6   ;   ;Special Clearing Charges;Decimal    }
    { 7   ;   ;Bounced Charges     ;Decimal        }
    { 8   ;   ;Clearing Bank Account;Code20       ;TableRelation="Bank Account".No.;
                                                   OnValidate=BEGIN
                                                                IF Banks.GET("Clearing Bank Account") THEN BEGIN
                                                                "Bank Name":=Banks.Name;
                                                                END;
                                                              END;
                                                               }
    { 9   ;   ;Bank Name           ;Text150        }
    { 10  ;   ;Bounced Charges GL Account;Code20  ;TableRelation="G/L Account" }
    { 11  ;   ;Clearing Charges GL Account;Code20 ;TableRelation="G/L Account" }
    { 12  ;   ;Clearing  Days      ;Integer        }
    { 13  ;   ;Percentage          ;Decimal        }
    { 14  ;   ;Clearing Charge Code;Code20        ;TableRelation="HR Shortlisted Applicants" }
    { 15  ;   ;Type                ;Option        ;OptionCaptionML=ENU=Local,Inhouse,Upcountry;
                                                   OptionString=Local,Inhouse,Upcountry }
    { 16  ;   ;Use %               ;Boolean        }
    { 17  ;   ;% Of Amount         ;Decimal        }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Banks@1000000000 : Record 270;

    BEGIN
    END.
  }
}

