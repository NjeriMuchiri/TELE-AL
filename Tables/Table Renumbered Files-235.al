OBJECT table 20376 Next of Kin/Account Sign
{
  OBJECT-PROPERTIES
  {
    Date=09/06/17;
    Time=12:35:37 PM;
    Modified=Yes;
    Version List=ChangeRequestV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page51516364;
    DrillDownPageID=Page51516364;
  }
  FIELDS
  {
    { 1   ;   ;Account No          ;Code30         }
    { 2   ;   ;Name                ;Text150       ;NotBlank=Yes }
    { 3   ;   ;Relationship        ;Text30        ;TableRelation=Table51516461;
                                                   NotBlank=Yes }
    { 4   ;   ;Beneficiary         ;Boolean        }
    { 5   ;   ;Date of Birth       ;Date          ;OnValidate=BEGIN
                                                                Age:=Dates.DetermineAge("Date of Birth",TODAY);
                                                              END;
                                                               }
    { 6   ;   ;Address             ;Text80         }
    { 7   ;   ;Telephone           ;Code50         }
    { 8   ;   ;Fax                 ;Code10         }
    { 9   ;   ;Email               ;Text30         }
    { 11  ;   ;ID No.              ;Code50         }
    { 12  ;   ;%Allocation         ;Decimal       ;OnValidate=BEGIN
                                                                 NomineeApp.RESET;
                                                                 NomineeApp.SETRANGE(NomineeApp."Account No","Account No");
                                                                 IF NomineeApp.FIND('-') THEN BEGIN
                                                                   REPEAT
                                                                     TotalAllocation:=TotalAllocation+"%Allocation";
                                                                          //IF TotalAllocation>100 THEN
                                                                       //
                                                                     UNTIL NomineeApp.NEXT=0;
                                                                   END;
                                                                  //MESSAGE('Kindly Ensure Allocation does not Exceed 100,TotalAllocation IS %1',TotalAllocation);
                                                                  IF (TotalAllocation>100) THEN
                                                                   ERROR('% Allocation Can not be more than 100');
                                                              END;
                                                               }
    { 13  ;   ;Total Allocation    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum(Table51516361.Field12 WHERE (Field1=FIELD(Account No))) }
    { 14  ;   ;Maximun Allocation %;Decimal        }
    { 15  ;   ;Age                 ;Text50         }
    { 16  ;   ;No                  ;Code30         }
  }
  KEYS
  {
    {    ;Account No,Name                         ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NomineeApp@1000000000 : Record 51516225;
      TotalAllocation@1000000001 : Decimal;
      Dates@1000000003 : Codeunit 51516005;
      DAge@1000000002 : DateFormula;

    BEGIN
    END.
  }
}

