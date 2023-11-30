OBJECT table 17355 Change Debt Collector
{
  OBJECT-PROPERTIES
  {
    Date=09/23/22;
    Time=12:47:13 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "Change No" = '' THEN BEGIN
                 NoSetup.GET;
                 NoSetup.TESTFIELD(NoSetup."Collector Change Nos");
                 NoSeriesMgt.InitSeries(NoSetup."Collector Change Nos",xRec."No. Series",0D,"Change No","No. Series");
                 END;
             END;

  }
  FIELDS
  {
    { 1   ;   ;Change No           ;Code20        ;OnValidate=BEGIN
                                                                IF "Change No" <> xRec."Change No" THEN BEGIN
                                                                  NoSetup.GET(0);
                                                                  NoSeriesMgt.TestManual("Change No");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   Editable=No }
    { 2   ;   ;Collector Code      ;Code20        ;TableRelation="Debt Collectors Details".Code;
                                                   OnValidate=BEGIN
                                                                Collectors.RESET;
                                                                Collectors.SETRANGE(Collectors."Change No","Change No");
                                                                IF Collectors.FINDSET THEN
                                                                Collectors.DELETEALL;

                                                                DebtCollectors.RESET;
                                                                DebtCollectors.SETRANGE(DebtCollectors.Code,"Collector Code");
                                                                IF DebtCollectors.FINDFIRST THEN BEGIN
                                                                "Collector Name":=DebtCollectors."Collectors Name";
                                                                END;

                                                                EntryNo:=0;
                                                                IF Collectors.FINDLAST THEN
                                                                EntryNo:=EntryNo+1
                                                                ELSE
                                                                EntryNo:=1;

                                                                LoanRegister.RESET;
                                                                LoanRegister.SETRANGE(LoanRegister."Debt Collectors Name","Collector Name");
                                                                IF LoanRegister.FINDFIRST THEN BEGIN
                                                                REPEAT
                                                                LoanRegister.CALCFIELDS(LoanRegister."Outstanding Balance",LoanRegister."Oustanding Interest");
                                                                Collectors.INIT;
                                                                Collectors."Entry No":=EntryNo;
                                                                Collectors."Loan Number":=LoanRegister."Loan  No.";
                                                                Collectors."Client Code":=LoanRegister."Client Code";
                                                                Collectors."CLient Name":=LoanRegister."Client Name";
                                                                Collectors."Debt Collector":="Collector Name";
                                                                Collectors."Change No":="Change No";
                                                                Collectors.INSERT(TRUE);
                                                                EntryNo:=EntryNo+1;
                                                                UNTIL LoanRegister.NEXT=0;
                                                                END;
                                                              END;
                                                               }
    { 3   ;   ;Collector Name      ;Text120       ;Editable=No }
    { 4   ;   ;New Collector Code  ;Code20        ;TableRelation="Debt Collectors Details".Code;
                                                   OnValidate=BEGIN
                                                                DebtCollectors.RESET;
                                                                DebtCollectors.SETRANGE(DebtCollectors.Code,"New Collector Code");
                                                                IF DebtCollectors.FINDFIRST THEN BEGIN
                                                                "New Colllector Name":=DebtCollectors."Collectors Name";
                                                                END;
                                                              END;
                                                               }
    { 5   ;   ;New Colllector Name ;Text120       ;Editable=No }
    { 6   ;   ;No. Series          ;Code20         }
    { 7   ;   ;Posted              ;Boolean        }
  }
  KEYS
  {
    {    ;Change No                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NoSeriesMgt@1120054000 : Codeunit 396;
      NoSetup@1120054001 : Record 51516258;
      LoanRegister@1120054002 : Record 51516230;
      Collectors@1120054003 : Record 51516924;
      EntryNo@1120054004 : Integer;
      DebtCollectors@1120054005 : Record 51516918;

    BEGIN
    END.
  }
}

