OBJECT table 20483 SMS Groups
{
  OBJECT-PROPERTIES
  {
    Date=07/02/20;
    Time=[ 3:51:26 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Member Name         ;Text60         }
    { 2   ;   ;Phone Number        ;Code40         }
    { 3   ;   ;Board               ;Boolean        }
    { 4   ;   ;Delegate            ;Boolean        }
    { 5   ;   ;Member No           ;Code40        ;TableRelation="Members Register".No.;
                                                   OnValidate=BEGIN
                                                                IF Members.GET("Member No") THEN
                                                                BEGIN
                                                                "Member Name":=Members.Name;
                                                                END;
                                                              END;
                                                               }
  }
  KEYS
  {
    {    ;Member Name                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Members@1120054000 : Record 51516223;

    BEGIN
    END.
  }
}

