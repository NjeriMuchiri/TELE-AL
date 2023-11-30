OBJECT table 20439 CloudPESA Pin Reset Logs
{
  OBJECT-PROPERTIES
  {
    Date=11/28/19;
    Time=12:59:22 PM;
    Modified=Yes;
    Version List=CloudPESA;
  }
  PROPERTIES
  {
    OnInsert=BEGIN

               // IF "Entry No" = '' THEN BEGIN
               //   SaccoNoSeries.GET;
               //   SaccoNoSeries.TESTFIELD(SaccoNoSeries."CloudPESA Registration Nos");
               //   NoSeriesMgt.InitSeries(SaccoNoSeries."CloudPESA Registration Nos",xRec.SentToServer,0D,"Entry No",SentToServer);
               // END;
             END;

    LookupPageID=Page51516582;
  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer       ;OnValidate=BEGIN
                                                                // IF "Entry No" <> xRec."Entry No" THEN BEGIN
                                                                //   SaccoNoSeries.GET;
                                                                //   NoSeriesMgt.TestManual(SaccoNoSeries."CloudPESA Registration Nos");
                                                                //   SentToServer := '';
                                                                // END;
                                                              END;

                                                   AutoIncrement=Yes }
    { 2   ;   ;No                  ;Code20         }
    { 3   ;   ;Account No          ;Code30        ;TableRelation=Vendor.No. }
    { 4   ;   ;Account Name        ;Text50         }
    { 5   ;   ;Telephone           ;Code20         }
    { 6   ;   ;ID No               ;Code20         }
    { 8   ;   ;Date                ;DateTime       }
    { 9   ;   ;Sent                ;Boolean        }
    { 10  ;   ;No. Series          ;Code20         }
    { 12  ;   ;Branch              ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2)) }
    { 13  ;   ;Last PIN Reset      ;DateTime       }
    { 14  ;   ;Reset By            ;Text50         }
  }
  KEYS
  {
    {    ;Entry No                                ;Clustered=Yes }
    {    ;Last PIN Reset                           }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SaccoNoSeries@1000000000 : Record 51516258;
      NoSeriesMgt@1000000001 : Codeunit 396;
      Accounts@1000000002 : Record 23;
      Temp@1000000003 : Code[15];

    BEGIN
    END.
  }
}

