OBJECT table 17323 Loan GuarantorsFOSA
{
  OBJECT-PROPERTIES
  {
    Date=06/16/22;
    Time=[ 8:15:21 AM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan No             ;Code20        ;TableRelation="Absence Preferences"."Include Weekends";
                                                   NotBlank=Yes }
    { 2   ;   ;Account No.         ;Code20        ;TableRelation=Vendor;
                                                   OnValidate=BEGIN
                                                                {TotalGuaranted := 0;

                                                                Date:=TODAY;

                                                                Members.RESET;
                                                                Members.SETRANGE(Members."No.","Account No.");
                                                                IF Members.FIND('-') THEN BEGIN
                                                                Members.CALCFIELDS(Members."Current Shares");
                                                                "Amount Guaranted":=Members."Current Shares";
                                                                Names:=Members.Name;
                                                                "Staff/Payroll No.":=Cust."Staff No";


                                                                END;


                                                                Cust.RESET;
                                                                IF Cust.GET("Account No.") THEN BEGIN
                                                                //IF Cust."Salary Processing" = FALSE THEN
                                                                //ERROR('You can only select guarantors whose salary is processed throught the SACCO.');



                                                                {IF LoanApp.GET("Loan No") THEN BEGIN
                                                                IF (LoanApp."Loan Product Type" = 'FH LOAN') OR (LoanApp."Loan Product Type" = 'FH INST') THEN BEGIN
                                                                GroupMember.RESET;
                                                                GroupMember.SETRANGE(GroupMember."Account No.",LoanApp."BOSA No");
                                                                GroupMember.SETRANGE(GroupMember."Member No.",Cust."BOSA Account No");
                                                                IF GroupMember.FIND('-') = FALSE THEN BEGIN
                                                                ERROR('Guarantors must be members of the group.');
                                                                END;
                                                                END;
                                                                END;
                                                                }


                                                                END;

                                                                //Check Max garantors
                                                                LoansG:=0;
                                                                LoanGuarantors.RESET;
                                                                LoanGuarantors.SETRANGE(LoanGuarantors."Account No.","Account No.");
                                                                IF LoanGuarantors.FIND('-') THEN BEGIN
                                                                IF LoanGuarantors.COUNT > 4 THEN BEGIN
                                                                REPEAT
                                                                IF Loans.GET(LoanGuarantors."Loan No") THEN BEGIN
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance");
                                                                IF Loans."Outstanding Balance" > 0 THEN
                                                                LoansG:=LoansG+1;

                                                                END;
                                                                UNTIL LoanGuarantors.NEXT = 0;
                                                                END;
                                                                END;

                                                                IF LoansG > 4 THEN BEGIN
                                                                IF CONFIRM('Member has guaranteed more than 4 active loans. Do you wish to continue?',FALSE) = FALSE THEN BEGIN
                                                                "Account No.":='';
                                                                "Staff/Payroll No.":='';
                                                                Names:='';
                                                                EXIT;
                                                                END;
                                                                END;
                                                                //Check Max garantors
                                                                }
                                                              END;

                                                   NotBlank=Yes }
    { 3   ;   ;Names               ;Text200        }
    { 4   ;   ;Signed              ;Boolean        }
    { 5   ;   ;Amount Guaranted    ;Decimal        }
    { 6   ;   ;Distribution (%)    ;Decimal        }
    { 7   ;   ;Distribution (Amount);Decimal       }
    { 8   ;   ;Staff/Payroll No.   ;Code20        ;OnValidate=BEGIN
                                                                {Cust.RESET;
                                                                Cust.SETFILTER(Cust."Account Type",'PRIME|OMEGA|FAHARI');
                                                                Cust.SETRANGE(Cust."Staff No","Staff/Payroll No.");
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                "Account No.":=Cust."No.";
                                                                VALIDATE("Account No.");
                                                                END
                                                                ELSE
                                                                ERROR('Record not found.')
                                                                 }
                                                              END;
                                                               }
    { 9   ;   ;Substituted         ;Boolean       ;OnValidate=BEGIN
                                                                Date:=TODAY;
                                                              END;
                                                               }
    { 10  ;   ;Line No             ;Integer        }
    { 11  ;   ;Date                ;Date           }
    { 12  ;   ;Self Guarantee      ;Boolean        }
  }
  KEYS
  {
    {    ;Loan No,Staff/Payroll No.,Account No.,Signed,Line No;
                                                   SumIndexFields=Amount Guaranted;
                                                   Clustered=Yes }
    {    ;Loan No,Signed                          ;SumIndexFields=Amount Guaranted }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Cust@1000000000 : Record 23;
      LoanGuarantor@1000000001 : Record 51516230;
      LoanApp@1000000002 : Record 51516230;
      TotalGuaranted@1000000003 : Decimal;
      LoansG@1102760001 : Integer;
      LoanGuarantors@1102760002 : Record 51516230;
      Loans@1102760003 : Record 51516230;
      Members@1102756000 : Record 51516223;

    BEGIN
    END.
  }
}

