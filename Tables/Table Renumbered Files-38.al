OBJECT table 50057 CloudPESA MPESA Trans
{
  OBJECT-PROPERTIES
  {
    Date=08/07/19;
    Time=[ 4:38:57 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnModify=BEGIN
                 //ERROR('You are permitted to edit this transaction');
             END;

  }
  FIELDS
  {
    { 1   ;   ;Document No         ;Code20         }
    { 2   ;   ;Transaction Date    ;Date           }
    { 3   ;   ;Account No          ;Code50         }
    { 4   ;   ;Description         ;Text220        }
    { 5   ;   ;Amount              ;Decimal        }
    { 6   ;   ;Posted              ;Boolean        }
    { 7   ;   ;Transaction Type    ;Text30         }
    { 8   ;   ;Transaction Time    ;Date           }
    { 9   ;   ;Paybill Acc Balance ;Decimal        }
    { 10  ;   ;Document Date       ;Date           }
    { 11  ;   ;Date Posted         ;Date           }
    { 12  ;   ;Time Posted         ;Date           }
    { 13  ;   ;Changed             ;Boolean        }
    { 14  ;   ;Date Changed        ;Date           }
    { 15  ;   ;Time Changed        ;Date           }
    { 16  ;   ;Changed By          ;Code30         }
    { 17  ;   ;Approved By         ;Code30         }
    { 18  ;   ;Key Word            ;Text30         }
    { 19  ;   ;Telephone           ;Text30         }
    { 20  ;   ;Account Name        ;Text100        }
    { 21  ;   ;Needs Manual Posting;Boolean        }
    { 22  ;   ;Imported By         ;Code100        }
    { 23  ;   ;Imported On         ;DateTime       }
  }
  KEYS
  {
    {    ;Document No                             ;Clustered=Yes }
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

