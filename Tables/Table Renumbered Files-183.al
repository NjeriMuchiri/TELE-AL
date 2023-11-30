OBJECT table 17301 Charges
{
  OBJECT-PROPERTIES
  {
    Date=08/10/23;
    Time=[ 2:51:21 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnModify=BEGIN
               TransactionCharges.RESET;
               TransactionCharges.SETFILTER(TransactionCharges."Charge Code",Code);
               IF TransactionCharges.FIND('-') THEN BEGIN
               TransactionCharges."Charge Code":=Code;
               TransactionCharges.Description:=Description;
               TransactionCharges."Charge Amount":="Charge Amount";
               TransactionCharges."Percentage of Amount":="Percentage of Amount";
               TransactionCharges."Use Percentage":="Use Percentage";
               TransactionCharges."G/L Account":="GL Account";
               TransactionCharges."Minimum Amount":=Minimum;
               TransactionCharges."Maximum Amount":=Maximum;
               TransactionCharges.MODIFY;
               END;
             END;

  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text150        }
    { 3   ;   ;Charge Amount       ;Decimal        }
    { 5   ;   ;Percentage of Amount;Decimal       ;OnValidate=BEGIN
                                                                IF "Percentage of Amount">100 THEN
                                                                ERROR('You cannot exceed 100. Please enter a valid number.');
                                                              END;
                                                               }
    { 6   ;   ;Use Percentage      ;Boolean        }
    { 7   ;   ;GL Account          ;Code20        ;TableRelation="G/L Account" }
    { 8   ;   ;Minimum             ;Decimal       ;OnValidate=BEGIN
                                                                IF Maximum<>0 THEN BEGIN
                                                                IF Maximum<Minimum THEN
                                                                ERROR('The maximum amount cannot be less than the minimum amount.');
                                                                END;
                                                              END;
                                                               }
    { 9   ;   ;Maximum             ;Decimal       ;OnValidate=BEGIN
                                                                IF Minimum<>0 THEN BEGIN
                                                                IF Minimum>Maximum THEN
                                                                ERROR('The minimum amount cannot be more than the maximum amount.');
                                                                END;
                                                              END;
                                                               }
    { 10  ;   ;Charge Type         ;Option        ;OptionCaptionML=ENU=" ,Loans,Special Advance,Discounting,Standing Order Fee,Failed Standing Order Fee,External Standing Order Fee";
                                                   OptionString=[ ,Loans,Special Advance,Discounting,Standing Order Fee,Failed Standing Order Fee,External Standing Order Fee] }
    { 11  ;   ;between 10000 and 50000;Decimal     }
    { 12  ;   ;between 50001 and 100000;Decimal    }
    { 13  ;   ;between 100001 and 200000;Decimal   }
    { 14  ;   ;between 200001 and  500000;Decimal  }
    { 15  ;   ;greater than 500001 ;Decimal        }
    { 16  ;   ;Between 100 and 5000;Decimal        }
    { 17  ;   ;Between 5001 - 10000;Decimal        }
    { 19  ;   ;Between 30001 - 50000;Decimal       }
    { 20  ;   ;Between 50001 - 100000;Decimal      }
    { 21  ;   ;Between 100001 - 200000;Decimal     }
    { 22  ;   ;Between 200001 - 500000;Decimal     }
    { 23  ;   ;Between 500001 Above;Decimal        }
    { 24  ;   ;Between 10001 - 30000;Decimal       }
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
      TransactionCharges@1000000000 : Record 51516300;

    BEGIN
    END.
  }
}

