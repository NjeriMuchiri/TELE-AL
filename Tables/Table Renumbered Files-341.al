OBJECT table 20486 Sms Header
{
  OBJECT-PROPERTIES
  {
    Date=10/06/20;
    Time=10:38:21 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               "Inserted By":=USERID;
               "Inserted On":=CURRENTDATETIME;
             END;

    OnModify=BEGIN
               TESTFIELD(Sent,FALSE);
             END;

  }
  FIELDS
  {
    { 1   ;   ;SMS Message         ;Text160        }
    { 2   ;   ;Individual Member No;Code50        ;TableRelation="Members Register".No. }
    { 3   ;   ;Employer            ;Code100       ;TableRelation="Sacco Employers" }
    { 4   ;   ;Sent                ;Boolean       ;Editable=No }
    { 5   ;   ;Message Date        ;Date           }
    { 6   ;   ;Send to All members ;Boolean        }
    { 7   ;   ;SMS MessageTwo      ;Text160        }
    { 8   ;   ;Inserted By         ;Code50        ;Editable=No }
    { 9   ;   ;Inserted On         ;DateTime      ;Editable=No }
    { 10  ;   ;Entry No            ;Integer       ;AutoIncrement=Yes;
                                                   Editable=No }
    { 11  ;   ;Sent By             ;Code30        ;Editable=No }
    { 12  ;   ;Sent On             ;DateTime      ;Editable=No }
    { 13  ;   ;Imported            ;Boolean       ;Editable=No }
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

