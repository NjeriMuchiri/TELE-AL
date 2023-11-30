OBJECT table 20442 CloudPESA Paybill Buffer
{
  OBJECT-PROPERTIES
  {
    Date=11/09/18;
    Time=[ 3:14:43 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Receipt No.         ;Code20         }
    { 2   ;   ;Completion Time     ;Text30         }
    { 3   ;   ;Initiation Time     ;Text50         }
    { 4   ;   ;Details             ;Text250        }
    { 5   ;   ;Transaction Status  ;Text250        }
    { 6   ;   ;Paid In             ;Decimal        }
    { 7   ;   ;Withdrawn           ;Text250        }
    { 8   ;   ;Balance             ;Decimal        }
    { 9   ;   ;Balance Confirmed   ;Text30         }
    { 10  ;   ;Reason Type         ;Text250        }
    { 11  ;   ;Other Party Info    ;Text250        }
    { 12  ;   ;Linked Transaction ID;Text250       }
    { 13  ;   ;A/C No.             ;Text250        }
  }
  KEYS
  {
    {    ;Receipt No.                             ;Clustered=Yes }
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

