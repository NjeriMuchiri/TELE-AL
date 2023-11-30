OBJECT table 20399 HR Medical Claim Entries
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=[ 3:14:26 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    LookupPageID=Page51516580;
    DrillDownPageID=Page51516580;
  }
  FIELDS
  {
    { 10  ;   ;Entry No            ;Integer       ;AutoIncrement=Yes }
    { 11  ;   ;Document No.        ;Code30         }
    { 12  ;   ;Employee No         ;Code30         }
    { 13  ;   ;Employee Name       ;Text80         }
    { 14  ;   ;Claim Date          ;Date           }
    { 15  ;   ;Hospital Visit Date ;Date           }
    { 16  ;   ;Claim Limit         ;Decimal        }
    { 17  ;   ;Balance Claim Amount;Decimal        }
    { 18  ;   ;Amount Claimed      ;Decimal        }
    { 19  ;   ;Amount Charged      ;Decimal        }
    { 20  ;   ;Comments            ;Text100        }
    { 21  ;   ;USER ID             ;Code30         }
    { 22  ;   ;Claim No            ;Code30         }
    { 23  ;   ;Date Posted         ;Date           }
    { 24  ;   ;Time Posted         ;Time           }
    { 25  ;   ;Posted              ;Boolean        }
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

    BEGIN
    END.
  }
}

