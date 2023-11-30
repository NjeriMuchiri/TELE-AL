OBJECT table 50020 Recovery Notes
{
  OBJECT-PROPERTIES
  {
    Date=11/10/22;
    Time=10:30:33 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF RecoveryNotes.FINDLAST THEN
               "Entry No":=RecoveryNotes."Entry No"+1
               ELSE
               "Entry No":=1;
               Date:=TODAY;
               Times:=TIME;
             END;

  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer        }
    { 2   ;   ;Loan No             ;Code40        ;TableRelation="Loans Register"."Loan  No." WHERE (Posted=CONST(Yes)) }
    { 3   ;   ;Recovery Notes      ;Text200        }
    { 4   ;   ;Date                ;Date          ;Editable=No }
    { 5   ;   ;Times               ;Time          ;Editable=No }
  }
  KEYS
  {
    {    ;Entry No,Loan No                        ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      RecoveryNotes@1120054000 : Record 50697;

    BEGIN
    END.
  }
}

