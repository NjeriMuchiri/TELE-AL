OBJECT table 20487 HR Insurance Scheme Members
{
  OBJECT-PROPERTIES
  {
    Date=04/22/20;
    Time=10:48:47 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Scheme No           ;Code10        ;TableRelation="HR Medical Schemes"."Scheme No";
                                                   OnValidate=BEGIN

                                                                         Medscheme.RESET;
                                                                         Medscheme.SETRANGE(Medscheme."Scheme No","Scheme No");
                                                                          IF Medscheme.FIND('-') THEN BEGIN
                                                                         "Out-Patient Limit":=Medscheme."Out-patient limit";
                                                                         "In-patient Limit":=Medscheme."In-patient limit";
                                                                         "Balance In- Patient":="In-patient Limit"-"Cumm.Amount Spent";
                                                                         "Balance Out- Patient":="Out-Patient Limit"-"Cumm.Amount Spent Out";
                                                                          END;
                                                              END;
                                                               }
    { 2   ;   ;Employee No         ;Code10        ;TableRelation="HR Employees".No.;
                                                   OnValidate=BEGIN
                                                                         Emp.RESET;
                                                                         Emp.SETRANGE(Emp."No.","Employee No");
                                                                         IF Emp.FIND('-') THEN BEGIN
                                                                         "First Name":=Emp."First Name"+' '+Emp."Middle Name";
                                                                         "Last Name":=Emp."Last Name";
                                                                         Designation:=Emp."Job Title";
                                                                         Department:=Emp."Department Code";
                                                                         "Scheme Join Date":=Emp."Medical Scheme Join Date";

                                                                         //"In-patient Limit":=Medscheme."In-patient limit";
                                                                          END;
                                                              END;
                                                               }
    { 3   ;   ;First Name          ;Text30         }
    { 4   ;   ;Last Name           ;Text30         }
    { 5   ;   ;Designation         ;Text50         }
    { 6   ;   ;Department          ;Text100        }
    { 7   ;   ;Scheme Join Date    ;Date           }
    { 8   ;   ;Scheme Anniversary  ;Date           }
    { 9   ;   ;Cumm.Amount Spent   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Medical Claims"."Amount Charged" WHERE (Member No=FIELD(Employee No),
                                                                                                               Claim Type=CONST(Inpatient))) }
    { 10  ;   ;Out-Patient Limit   ;Decimal        }
    { 11  ;   ;In-patient Limit    ;Decimal        }
    { 12  ;   ;Maximum Cover       ;Decimal       ;Description=S }
    { 13  ;   ;Cumm.Amount Spent Out;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Medical Claims"."Amount Charged" WHERE (Member No=FIELD(Employee No),
                                                                                                               Claim Type=CONST(Outpatient))) }
    { 14  ;   ;Balance Out- Patient;Decimal        }
    { 15  ;   ;Balance In- Patient ;Decimal        }
    { 16  ;   ;No Of Dependants    ;Code10         }
  }
  KEYS
  {
    {    ;Scheme No,Employee No                   ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Medscheme@1102755001 : Record 51516109;
      Emp@1102755000 : Record 51516160;
    ;

    BEGIN
    END.
  }
}

