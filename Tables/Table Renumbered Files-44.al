OBJECT table 50063 Bid Analysis
{
  OBJECT-PROPERTIES
  {
    Date=04/13/18;
    Time=[ 1:01:07 PM];
    Modified=Yes;
    Version List=Supply Chain Management;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;RFQ No.             ;Code20         }
    { 2   ;   ;RFQ Line No.        ;Integer        }
    { 3   ;   ;Quote No.           ;Code20         }
    { 4   ;   ;Vendor No.          ;Code20         }
    { 5   ;   ;Item No.            ;Code20         }
    { 6   ;   ;Description         ;Text100        }
    { 7   ;   ;Quantity            ;Decimal        }
    { 8   ;   ;Unit Of Measure     ;Code20         }
    { 9   ;   ;Amount              ;Decimal        }
    { 10  ;   ;Line Amount         ;Decimal        }
    { 11  ;   ;Total               ;Decimal        }
    { 12  ;   ;Last Direct Cost    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Item."Last Direct Cost" WHERE (No.=FIELD(Item No.))) }
    { 13  ;   ;Remarks             ;Text50        ;OnValidate=BEGIN
                                                                PurchLine.RESET;
                                                                PurchLine.SETRANGE(PurchLine."Document Type",PurchLine."Document Type"::Quote);
                                                                PurchLine.SETRANGE(PurchLine."Document No.","Quote No.");
                                                                PurchLine.SETRANGE(PurchLine."Line No.","RFQ Line No.");
                                                                IF PurchLine.FINDSET THEN
                                                                BEGIN
                                                                 PurchLine."RFQ Remarks" := Remarks;
                                                                 PurchLine.MODIFY;
                                                                END
                                                              END;
                                                               }
  }
  KEYS
  {
    {    ;RFQ No.,RFQ Line No.,Quote No.,Vendor No.;
                                                   Clustered=Yes }
    {    ;Item No.                                 }
    {    ;Vendor No.                               }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      PurchLine@1000 : Record 39;

    BEGIN
    END.
  }
}

