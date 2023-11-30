OBJECT table 20488 Portal
{
  OBJECT-PROPERTIES
  {
    Date=06/17/18;
    Time=[ 2:52:28 PM];
    Modified=Yes;
    Version List=PortalCloudPesa;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry               ;Integer        }
    { 2   ;   ;Portalfeedback      ;Text250        }
    { 3   ;   ;PortalNotifications ;Text250        }
    { 4   ;   ;DatePosted          ;Date           }
    { 5   ;   ;PostedBy            ;Text30         }
    { 6   ;   ;No                  ;Code20         }
    { 7   ;   ;Reply               ;Text250        }
    { 8   ;   ;LoanNo              ;Code40         }
    { 9   ;   ;Guarantor           ;Code30         }
    { 10  ;   ;Accepted            ;Integer        }
    { 11  ;   ;Rejected            ;Integer        }
    { 12  ;   ;Amount              ;Decimal        }
    { 13  ;   ;RequestedAmount     ;Decimal        }
    { 14  ;   ;Purpose             ;Code20         }
    { 15  ;   ;LoanConsolidation   ;Boolean        }
    { 16  ;   ;LoanRefinaincing    ;Boolean        }
    { 17  ;   ;LoanBridging        ;Boolean        }
    { 18  ;   ;LoanDuration        ;Integer        }
    { 19  ;   ;LoanProducttype     ;Code20         }
    { 20  ;   ;RemainingAmount     ;Decimal        }
    { 21  ;   ;AmountGuranteedTotal;Decimal        }
  }
  KEYS
  {
    {    ;Entry                                   ;Clustered=Yes }
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

