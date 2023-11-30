OBJECT table 20379 Member Defaulter Notifications
{
  OBJECT-PROPERTIES
  {
    Date=10/06/21;
    Time=12:58:16 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               "Entered By":=USERID;
               "Date Entered":=CURRENTDATETIME;
             END;

    OnDelete=BEGIN
               ERROR('Deletion is not allowed on this submodule!');
             END;

  }
  FIELDS
  {
    { 1   ;   ;Member No           ;Code20        ;TableRelation="Members Register";
                                                   OnValidate=VAR
                                                                Memba@1120054000 : Record 51516223;
                                                              BEGIN
                                                                Memba.GET("Member No");
                                                                Memba.CALCFIELDS("Outstanding Balance");
                                                                "Outstanding Balance" := Memba."Outstanding Balance";
                                                              END;
                                                               }
    { 2   ;   ;Member Name         ;Text100       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Members Register".Name WHERE (No.=FIELD(Member No))) }
    { 3   ;   ;ID No               ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Members Register"."ID No." WHERE (No.=FIELD(Member No))) }
    { 4   ;   ;Phone No            ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Members Register"."Phone No." WHERE (No.=FIELD(Member No))) }
    { 5   ;   ;Outstanding Balance ;Decimal       ;Editable=No }
    { 6   ;   ;Entered By          ;Code30        ;Editable=No }
    { 7   ;   ;Date Entered        ;DateTime      ;Editable=No }
    { 8   ;   ;Marked By           ;Code30        ;Editable=No }
    { 9   ;   ;Date Marked         ;DateTime      ;Editable=No }
    { 10  ;   ;Marked              ;Boolean       ;Editable=No }
    { 11  ;   ;Stopped             ;Boolean       ;Editable=No }
    { 12  ;   ;Date Stopped        ;DateTime      ;Editable=No }
    { 13  ;   ;Stopped By          ;Code30        ;Editable=No }
    { 14  ;   ;Date Remarked       ;DateTime      ;Editable=No }
    { 15  ;   ;Remarked By         ;Code30        ;Editable=No }
    { 16  ;   ;Remarks             ;Text250        }
    { 17  ;   ;Payroll No          ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Members Register"."Payroll/Staff No" WHERE (No.=FIELD(Member No))) }
    { 18  ;   ;Defaulter Grouping  ;Option        ;OptionCaptionML=ENU=" ,Debt Collectors,Lawyers,Office";
                                                   OptionString=[ ,Debt Collectors,Lawyers,Office] }
    { 19  ;   ;SendMessage         ;Boolean        }
  }
  KEYS
  {
    {    ;Member No                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    PROCEDURE MarkForNotification@1120054001();
    BEGIN
      TESTFIELD("Outstanding Balance");
      TESTFIELD(Remarks);
      CALCFIELDS("Member Name");

      IF NOT CONFIRM('Mark %1 for notification?',FALSE,"Member Name") THEN EXIT;

      Marked:=TRUE;
      "Marked By":=USERID;
      "Date Marked":=CURRENTDATETIME;
      MODIFY;

      CALCFIELDS("Member Name");
      MESSAGE('%1 Marked for notification successfully',"Member Name");
    END;

    PROCEDURE StopNotification@1120054002();
    BEGIN
      TESTFIELD(Marked,TRUE);
      CALCFIELDS("Member Name");
      IF NOT CONFIRM('Stop notification for %1?',FALSE,"Member Name") THEN EXIT;

      Stopped:=NOT Stopped;

      IF Stopped THEN BEGIN
        "Stopped By":=USERID;
        "Date Stopped":=CURRENTDATETIME;

      END ELSE BEGIN
          "Remarked By":=USERID;
           "Date Remarked":=CURRENTDATETIME;
        END;

      MODIFY;
      MESSAGE('Operation successful!');
    END;

    BEGIN
    END.
  }
}

