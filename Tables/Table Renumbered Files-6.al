OBJECT table 50025 SMS Messages Buffer
{
  OBJECT-PROPERTIES
  {
    Date=03/27/23;
    Time=[ 4:51:46 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer       ;AutoIncrement=Yes;
                                                   NotBlank=Yes }
    { 2   ;   ;Source              ;Code100        }
    { 3   ;   ;Telephone No        ;Code20         }
    { 4   ;   ;Date Entered        ;Date           }
    { 5   ;   ;Time Entered        ;Time           }
    { 6   ;   ;Entered By          ;Code100        }
    { 7   ;   ;SMS Message         ;Text250        }
    { 8   ;   ;Sent To Server      ;Option        ;OptionCaptionML=ENU=No,Yes,Failed,Redirected;
                                                   OptionString=No,Yes,Failed,Redirected }
    { 9   ;   ;Date Sent to Server ;Date           }
    { 10  ;   ;Time Sent To Server ;Date           }
    { 11  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 12  ;   ;Entry No.           ;Code20         }
    { 13  ;   ;Account No          ;Code30         }
    { 14  ;   ;Batch No            ;Code30         }
    { 15  ;   ;Document No         ;Code30         }
    { 16  ;   ;System Created Entry;Boolean        }
    { 17  ;   ;Bulk SMS Balance    ;Decimal        }
    { 18  ;   ;Rate                ;Decimal        }
    { 19  ;   ;Charged             ;Boolean        }
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
      NoSetup@1102756000 : Record 98;
      NoSeriesMgt@1102756001 : Codeunit 396;

    BEGIN
    END.
  }
}

