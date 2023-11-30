OBJECT table 17328 Interest Buffer
{
  OBJECT-PROPERTIES
  {
    Date=02/25/20;
    Time=[ 6:06:07 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               {
                 IF No = '' THEN BEGIN
                 NoSetup.GET(0);
                 NoSetup.TESTFIELD(NoSetup."Interest Buffer No");
                 NoSeriesMgt.InitSeries(NoSetup."Interest Buffer No",xRec."No. Series",0D,No,"No. Series");
                 END;
               }
             END;

    LookupPageID=Page51516866;
    DrillDownPageID=Page51516866;
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Integer       ;AutoIncrement=No }
    { 2   ;   ;Account No          ;Code20        ;TableRelation=Vendor.No. }
    { 3   ;   ;Account Type        ;Code20         }
    { 4   ;   ;Interest Date       ;Date           }
    { 5   ;   ;Interest Amount     ;Decimal        }
    { 6   ;   ;User ID             ;Code50         }
    { 8   ;   ;Account Matured     ;Boolean        }
    { 9   ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 10  ;   ;Late Interest       ;Boolean        }
    { 11  ;   ;Transferred         ;Boolean        }
    { 12  ;   ;Mark For Deletion   ;Boolean        }
    { 13  ;   ;Description         ;Text80         }
  }
  KEYS
  {
    {    ;No,Account No                           ;Clustered=Yes }
    {    ;Account No,Transferred                  ;SumIndexFields=Interest Amount }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NoSetup@1000000001 : Record 312;
      NoSeriesMgt@1000000000 : Codeunit 396;

    BEGIN
    END.
  }
}

