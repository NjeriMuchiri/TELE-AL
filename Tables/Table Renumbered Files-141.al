OBJECT table 17259 Appraisal Salary Set-up
{
  OBJECT-PROPERTIES
  {
    Date=08/02/16;
    Time=12:35:16 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page51516289;
    DrillDownPageID=Page51516289;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text30         }
    { 3   ;   ;Type                ;Option        ;OptionCaptionML=ENG=" ,Earnings,Deductions,Basic,Asset,Liability,Rental,Farming";
                                                   OptionString=[ ,Earnings,Deductions,Basic,Asset,Liability,Rental,Farming] }
    { 4   ;   ;Statutory Ded       ;Boolean       ;OnValidate=BEGIN
                                                                //"AppraisalSDetails`".RESET;
                                                                //"AppraisalSDetails`".SETRANGE("AppraisalSDetails`".Code,)
                                                                AppraisalSDetails.Statutory:="Statutory Ded";
                                                              END;
                                                               }
    { 5   ;   ;Statutory Amount    ;Decimal        }
    { 6   ;   ;Statutory(%)        ;Decimal        }
    { 7   ;   ;Long Term Deductions;Boolean        }
    { 8   ;   ;bASIC               ;Boolean        }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      AppraisalSDetails@1102755000 : Record 51516232;

    BEGIN
    END.
  }
}

