OBJECT table 17255 Check-Off Advice Buffer
{
  OBJECT-PROPERTIES
  {
    Date=10/05/15;
    Time=[ 5:44:26 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer        }
    { 2   ;   ;Member No.          ;Code20         }
    { 3   ;   ;Personal No.        ;Code20         }
    { 4   ;   ;Names               ;Text250        }
    { 5   ;   ;New Amount          ;Decimal        }
    { 6   ;   ;Non Rec             ;Decimal        }
    { 7   ;   ;Current Amount      ;Decimal        }
    { 8   ;   ;New Balance         ;Decimal        }
    { 9   ;   ;EDCode              ;Code20         }
    { 10  ;   ;Employer            ;Code20        ;TableRelation="HR Leave Application"."Application Code" }
    { 11  ;   ;Refference          ;Code20         }
    { 12  ;   ;Month               ;Integer        }
    { 13  ;   ;Remarks             ;Text30         }
    { 14  ;   ;Station             ;Code20         }
    { 15  ;   ;NR Code             ;Code20         }
    { 16  ;   ;Sacco Code          ;Code20         }
    { 17  ;   ;Vote Code           ;Code20         }
    { 18  ;   ;Account No.         ;Code20         }
    { 19  ;   ;Current Balance     ;Decimal        }
    { 20  ;   ;Transaction Type    ;Code10         }
    { 21  ;   ;Transaction Name    ;Text30         }
    { 22  ;   ;Interest            ;Integer        }
    { 23  ;   ;Action              ;Integer        }
    { 24  ;   ;Old Account No      ;Text30         }
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

