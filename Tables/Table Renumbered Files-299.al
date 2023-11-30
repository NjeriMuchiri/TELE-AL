OBJECT table 20443 Audit Trail
{
  OBJECT-PROPERTIES
  {
    Date=02/14/23;
    Time=11:14:27 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnModify=BEGIN
               ERROR(Text1);
             END;

    OnDelete=BEGIN
               ERROR(Text1);
             END;

  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer       ;AutoIncrement=Yes }
    { 2   ;   ;User Id             ;Code60        ;TableRelation="User Setup"."User ID" }
    { 3   ;   ;Transaction Type    ;Text150        }
    { 4   ;   ;Amount              ;Decimal        }
    { 5   ;   ;Source              ;Code80         }
    { 6   ;   ;Date                ;Date           }
    { 7   ;   ;Time                ;Time           }
    { 8   ;   ;Loan Number         ;Code80         }
    { 9   ;   ;Document Number     ;Code80         }
    { 10  ;   ;Account Number      ;Code80         }
    { 11  ;   ;ATM Card            ;Code80         }
    { 12  ;   ;Computer Name       ;Text250        }
    { 13  ;   ;IP Address          ;Code200        }
    { 14  ;   ;MAC Address         ;Code200        }
    { 15  ;   ;User Name           ;Code60         }
  }
  KEYS
  {
    {    ;Entry No                                ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text1@1120054000 : TextConst 'ENU=Invalid Input';

    BEGIN
    END.
  }
}

