OBJECT table 17264 Sacco Employers
{
  OBJECT-PROPERTIES
  {
    Date=11/02/15;
    Time=[ 6:23:22 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page51516282;
    DrillDownPageID=Page51516282;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;OnValidate=BEGIN
                                                                  //Description:=  cust.Name;
                                                                  //MODIFY;
                                                              END;

                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text50         }
    { 3   ;   ;Repayment Method    ;Option        ;OptionString=[ ,Amortised,Reducing Balance,Straight Line,Constants] }
    { 4   ;   ;Check Off           ;Boolean        }
    { 5   ;   ;No. of Members      ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=FILTER(Active|Dormant|Re-instated|Termination|Resigned),
                                                                                               Employer Code=FIELD(Code),
                                                                                               Customer Posting Group=CONST(MEMBER))) }
    { 6   ;   ;Male                ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=FILTER(Active|Dormant|Re-instated|Termination|Resigned),
                                                                                               Employer Code=FIELD(Code),
                                                                                               Customer Posting Group=CONST(MEMBER),
                                                                                               Gender=CONST(" ")));
                                                   Editable=No }
    { 7   ;   ;Female              ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=FILTER(Active|Dormant|Re-instated|Termination|Resigned),
                                                                                               Employer Code=FIELD(Code),
                                                                                               Customer Posting Group=CONST(MEMBER),
                                                                                               Gender=CONST(Male)));
                                                   Editable=No }
    { 8   ;   ;Vote Code           ;Code20         }
    { 9   ;   ;Can Guarantee Loan  ;Boolean        }
    { 10  ;   ;Active Members      ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=FILTER(Active),
                                                                                               Employer Code=FIELD(Code),
                                                                                               Customer Posting Group=CONST(MEMBER)));
                                                   Editable=No }
    { 11  ;   ;Dormant Members     ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=FILTER(Dormant),
                                                                                               Employer Code=FIELD(Code),
                                                                                               Customer Posting Group=CONST(MEMBER)));
                                                   Editable=No }
    { 12  ;   ;Withdrawn           ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=FILTER(Withdrawal),
                                                                                               Employer Code=FIELD(Code),
                                                                                               Customer Posting Group=CONST(MEMBER)));
                                                   Editable=No }
    { 13  ;   ;Deceased            ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=FILTER(Deceased),
                                                                                               Employer Code=FIELD(Code),
                                                                                               Customer Posting Group=CONST(MEMBER)));
                                                   Editable=No }
    { 14  ;   ;Join Date           ;Date           }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Code,Description                         }
  }
  CODE
  {
    VAR
      cust@1102755000 : Record 18;

    BEGIN
    END.
  }
}

