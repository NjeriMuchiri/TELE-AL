OBJECT table 20417 Penalty Counter
{
  OBJECT-PROPERTIES
  {
    Date=10/13/22;
    Time=[ 4:12:03 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan Number         ;Code30        ;TableRelation="Loans Register"."Loan  No." WHERE (Posted=CONST(Yes),
                                                                                                     Loan Product Type=CONST(A03));
                                                   OnValidate=BEGIN
                                                                IF LoansRegister.GET("Loan Number") THEN BEGIN
                                                                  "Member Number" := LoansRegister."Client Code";
                                                                  "Member Name" := LoansRegister."Client Name";
                                                                  "Product Type" := LoansRegister."Loan Product Type";
                                                                  "Date Entered" := TODAY;
                                                                END;
                                                                "Created By" := USERID;
                                                              END;
                                                               }
    { 2   ;   ;Penalty Number      ;Integer        }
    { 3   ;   ;Next Penalty Date   ;Date           }
    { 4   ;   ;Member Number       ;Code30        ;TableRelation="Members Register".No. }
    { 5   ;   ;Product Type        ;Code30        ;TableRelation="Loan Products Setup".Code WHERE (AvailableOnMobile=CONST(Yes)) }
    { 6   ;   ;Added Manually      ;Boolean        }
    { 7   ;   ;Date Entered        ;Date           }
    { 8   ;   ;Date Penalty Paid   ;Date           }
    { 9   ;   ;Created By          ;Code50        ;Editable=No }
    { 10  ;   ;Member Name         ;Text30        ;OnValidate=VAR
                                                                Member@1120054000 : Record 51516220;
                                                              BEGIN

                                                                IF LoansRegister.GET("Loan Number") THEN BEGIN
                                                                "Member Name" := LoansRegister."Client Name";
                                                                END;
                                                              END;
                                                               }
    { 11  ;   ;Personal Number     ;Code30        ;OnValidate=VAR
                                                                MembershipApplications@1120054000 : Record 51516220;
                                                              BEGIN
                                                                // MembershipApplications.RESET;
                                                                // MembershipApplications.SETRANGE("No.","Member Number");
                                                                // IF MembershipApplications.FINDFIRST THEN BEGIN
                                                                //   "Personal Number":=MembershipApplications."Payroll/Staff No";
                                                                // END;
                                                                "Personal Number":=LoansRegister."Staff No";
                                                              END;
                                                               }
  }
  KEYS
  {
    {    ;Loan Number                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      LoansRegister@1120054000 : Record 51516230;

    BEGIN
    END.
  }
}

