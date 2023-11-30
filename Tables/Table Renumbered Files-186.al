OBJECT table 17304 Transaction Charges
{
  OBJECT-PROPERTIES
  {
    Date=08/17/20;
    Time=10:52:36 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Transaction Type    ;Code20        ;TableRelation="Transaction Types" }
    { 2   ;   ;Charge Code         ;Code20        ;TableRelation=Charges;
                                                   OnValidate=BEGIN
                                                                IF Charges.GET("Charge Code") THEN BEGIN
                                                                Description:=Charges.Description;
                                                                "Charge Amount":=Charges."Charge Amount";
                                                                "Percentage of Amount":=Charges."Percentage of Amount";
                                                                "Use Percentage":=Charges."Use Percentage";
                                                                //"Minimum Amount":=Charges."Minimum Amount";
                                                                //"Maximum Amount":=Charges."Maximum Amount";
                                                                "G/L Account":=Charges."GL Account";
                                                                END;
                                                              END;

                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text150        }
    { 4   ;   ;Charge Amount       ;Decimal        }
    { 5   ;   ;Percentage of Amount;Decimal       ;OnValidate=BEGIN
                                                                IF "Percentage of Amount">100 THEN
                                                                ERROR('You cannot exceed 100. Please enter a valid number.');
                                                              END;
                                                               }
    { 6   ;   ;Use Percentage      ;Boolean        }
    { 7   ;   ;G/L Account         ;Code20        ;TableRelation="G/L Account".No. }
    { 8   ;   ;Minimum Amount      ;Decimal        }
    { 9   ;   ;Maximum Amount      ;Decimal        }
    { 10  ;   ;Due Amount          ;Decimal        }
    { 11  ;   ;Due to Account      ;Code20        ;TableRelation="G/L Account".No. }
    { 12  ;   ;Charge Type         ;Option        ;OptionCaptionML=ENU=Flat Amount,Percentage of Amount,Staggered;
                                                   OptionString=Flat Amount,Percentage of Amount,Staggered }
    { 13  ;   ;Staggered Charge Code;Code20       ;TableRelation="Tarrif Header".Code }
    { 14  ;   ;Stamp Duty          ;Boolean        }
    { 15  ;   ;Charges 50000-99999 ;Decimal        }
    { 16  ;   ;Charges 100000      ;Decimal        }
    { 17  ;   ;PayOut 50-100       ;Decimal        }
    { 18  ;   ;PayOut 100-200      ;Decimal        }
    { 19  ;   ;PayOut 201-300      ;Decimal        }
    { 20  ;   ;PayOut 301-400      ;Decimal        }
    { 21  ;   ;PayOut 401-500      ;Decimal        }
    { 22  ;   ;PayOut 501-600      ;Decimal        }
    { 23  ;   ;PayOut 601  &  Above;Decimal        }
    { 24  ;   ;Charges 1-999       ;Decimal        }
    { 25  ;   ;Charges 1000-19999  ;Decimal        }
    { 26  ;   ;Charges 20000-49999 ;Decimal        }
    { 27  ;   ;Between 100 and 5000;Decimal        }
    { 28  ;   ;Between 5001 - 10000;Decimal        }
    { 30  ;   ;Between 30001 - 50000;Decimal       }
    { 31  ;   ;Between 50001 - 100000;Decimal      }
    { 32  ;   ;Between 100001 - 200000;Decimal     }
    { 33  ;   ;Between 200001 - 500000;Decimal     }
    { 34  ;   ;Between 500001 Above;Decimal        }
    { 35  ;   ;Between 10001 - 30001;Decimal       }
  }
  KEYS
  {
    {    ;Transaction Type,Charge Code            ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Charges@1000000000 : Record 51516297;

    BEGIN
    END.
  }
}

