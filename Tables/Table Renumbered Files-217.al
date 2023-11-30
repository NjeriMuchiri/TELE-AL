OBJECT table 17338 MPESA Transactions
{
  OBJECT-PROPERTIES
  {
    Date=11/18/19;
    Time=11:58:06 AM;
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnModify=BEGIN
               IF Posted=TRUE THEN BEGIN
               ERROR('You cannot modify posted MPESA transactions.');
               END;
             END;

    OnDelete=BEGIN
               ERROR('You cannot delete MPESA transactions.');
             END;

    LookupPageID=Page39004062;
    DrillDownPageID=Page39004062;
  }
  FIELDS
  {
    { 1   ;   ;Document No.        ;Code20         }
    { 2   ;   ;Transaction Date    ;Date           }
    { 3   ;   ;Account No.         ;Code50         }
    { 4   ;   ;Description         ;Text220        }
    { 5   ;   ;Amount              ;Decimal        }
    { 6   ;   ;Posted              ;Boolean        }
    { 7   ;   ;Transaction Type    ;Text30         }
    { 8   ;   ;Transaction Time    ;Date           }
    { 9   ;   ;Bal. Account No.    ;Code30         }
    { 10  ;   ;Document Date       ;Date           }
    { 11  ;   ;Date Posted         ;Date           }
    { 12  ;   ;Time Posted         ;Time           }
    { 13  ;   ;Account Status      ;Text30         }
    { 14  ;   ;Messages            ;Text200        }
    { 15  ;   ;Needs Change        ;Boolean        }
    { 16  ;   ;Change Transaction No;Code20       ;TableRelation="Member Monthly Contributions".No. }
    { 17  ;   ;Old Account No      ;Code50         }
    { 18  ;   ;Changed             ;Boolean        }
    { 19  ;   ;Date Changed        ;Date           }
    { 20  ;   ;Time Changed        ;Time           }
    { 21  ;   ;Changed By          ;Code30         }
    { 22  ;   ;Approved By         ;Code30         }
    { 23  ;   ;Original Account No ;Code50         }
    { 24  ;   ;Account Balance     ;Decimal        }
    { 25  ;   ;Key Word            ;Text30         }
    { 26  ;   ;TelephoneNo         ;Text30         }
  }
  KEYS
  {
    {    ;Document No.,Description                ;Clustered=Yes }
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

