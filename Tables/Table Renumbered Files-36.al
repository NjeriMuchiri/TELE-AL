OBJECT table 50055 Mobile Loans
{
  OBJECT-PROPERTIES
  {
    Date=05/04/20;
    Time=[ 2:04:51 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnDelete=BEGIN
               //ERROR('You cannot delete M-KAHAWA transactions.');
             END;

  }
  FIELDS
  {
    { 1   ;   ;Document No         ;Code20         }
    { 2   ;   ;Document Date       ;Date           }
    { 3   ;   ;Loan Amount         ;Decimal        }
    { 4   ;   ;Batch No            ;Code20         }
    { 5   ;   ;Date Entered        ;Date           }
    { 6   ;   ;Time Entered        ;Time           }
    { 7   ;   ;Entered By          ;Code100        }
    { 8   ;   ;Sent To Server      ;Option        ;OptionString=No,Yes }
    { 9   ;   ;Date Sent To Server ;Date           }
    { 10  ;   ;Time Sent To Server ;Time           }
    { 11  ;   ;Account No          ;Code20         }
    { 12  ;   ;Member No           ;Code20         }
    { 13  ;   ;Telephone No        ;Code20         }
    { 14  ;   ;Corporate No        ;Code10         }
    { 15  ;   ;Delivery Center     ;Code10         }
    { 16  ;   ;Customer Name       ;Text150        }
    { 17  ;   ;Purpose             ;Text250        }
    { 18  ;   ;MPESA Doc No.       ;Code30         }
    { 19  ;   ;Comments            ;Text250        }
    { 20  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Pending,Completed,Failed,Waiting;
                                                   OptionString=Pending,Completed,Failed,Waiting }
    { 21  ;   ;Entry No            ;Integer       ;AutoIncrement=Yes }
    { 22  ;   ;Ist Notification    ;Boolean        }
    { 23  ;   ;2nd Notification    ;Boolean        }
    { 24  ;   ;3rd Notification    ;Boolean        }
    { 25  ;   ;Penalty Date        ;Date           }
    { 26  ;   ;4th Notification    ;Boolean        }
    { 27  ;   ;5th Notification    ;Boolean        }
    { 28  ;   ;Deposit bal         ;Decimal        }
    { 29  ;   ;Penalized           ;Boolean        }
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
    VAR
      ObjCustomers@1000000000 : Record 18;

    BEGIN
    END.
  }
}

