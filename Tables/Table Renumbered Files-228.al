OBJECT table 20369 Members Cues
{
  OBJECT-PROPERTIES
  {
    Date=08/10/23;
    Time=10:27:01 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code20         }
    { 2   ;   ;Active Members      ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active))) }
    { 3   ;   ;Non-Active Members  ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Non-Active))) }
    { 4   ;   ;Dormant Members     ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Dormant))) }
    { 5   ;   ;Blocked Members     ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Blocked))) }
    { 6   ;   ;Reinstated Members  ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Re-instated))) }
    { 7   ;   ;Defaulted members   ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Defaulter))) }
    { 8   ;   ;Active Members(Postal Corp);Integer;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active),
                                                                                               Employer Code=FILTER(POSTAL CORP))) }
    { 9   ;   ;Active Members(Kenya Postal);Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active),
                                                                                               Employer Code=FILTER(KENYA POSTAL))) }
    { 10  ;   ;Active Members(Human Capital);Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active),
                                                                                               Employer Code=FILTER(HUMAN CAPITAL))) }
    { 11  ;   ;Active Members(Staff);Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active),
                                                                                               Employer Code=FILTER(STAFF))) }
    { 12  ;   ;Active Members(Telkom);Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active),
                                                                                               Employer Code=FILTER(TELKOM))) }
    { 13  ;   ;Active Members(Rea Vipingo);Integer;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active),
                                                                                               Employer Code=FILTER(REA VIPINGO))) }
    { 14  ;   ;Active Members(COWU);Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active),
                                                                                               Employer Code=FILTER(COWU))) }
    { 15  ;   ;Active Members(Phoenix);Integer    ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active),
                                                                                               Employer Code=FILTER(PHOENIX))) }
    { 16  ;   ;Active Members(Multimedia);Integer ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active),
                                                                                               Employer Code=FILTER(MULTIMEDIA))) }
    { 17  ;   ;Active Members(KEWL);Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active),
                                                                                               Employer Code=FILTER(KEWL))) }
    { 18  ;   ;Active Members(RSL) ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active),
                                                                                               Employer Code=FILTER(RSL))) }
    { 19  ;   ;Active Members(NYANDO);Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active),
                                                                                               Employer Code=FILTER(NYANDO))) }
    { 20  ;   ;New Members Monthly ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Members Register" WHERE (Status=CONST(Active))) }
    { 21  ;   ;Total Deposits      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Transaction Type=CONST(Deposit Contribution))) }
    { 22  ;   ;Total School Fees   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Transaction Type=CONST(SchFee Shares))) }
    { 23  ;   ;Chamaa Savings      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FILTER(0504-001-*))) }
    { 24  ;   ;Fixed Savings       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FILTER(0508-001-*))) }
    { 25  ;   ;FOSA Savings        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FILTER(0503-001-*))) }
    { 26  ;   ;Jibambe Holiday Savings;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FILTER(0505-001-*))) }
    { 27  ;   ;Mdosi Junior Savings;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FILTER(0506-001-*))) }
    { 28  ;   ;Ordinary Savings    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FILTER(0502-001-*))) }
    { 29  ;   ;Pension Akiba  Savings;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FILTER(0507-001-*))) }
    { 30  ;   ;Registered Loans    ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Approval Status=CONST(Open),
                                                                                             Loan Status=CONST(Application))) }
    { 31  ;   ;Appraised Loans     ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Approval Status=CONST(Open),
                                                                                             Loan Status=CONST(Appraisal),
                                                                                             Loan Product Type=FILTER(<>M_OD),
                                                                                             Posted=FILTER(No))) }
    { 32  ;   ;Approved Loans      ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Approval Status=CONST(Approved),
                                                                                             Loan Status=CONST(Appraisal))) }
    { 33  ;   ;Loans Pending Approval;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Approval Status=CONST(Pending),
                                                                                             Loan Status=CONST(Appraisal))) }
    { 34  ;   ;Loans Posted        ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Approval Status=CONST(Approved),
                                                                                             Loan Status=CONST(Issued),
                                                                                             Posted=CONST(Yes))) }
    { 35  ;   ;Registered Loans Amount;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register"."Requested Amount" WHERE (Approval Status=CONST(Open),
                                                                                                              Loan Status=CONST(Application))) }
    { 36  ;   ;Appraised Loans Amount;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register"."Requested Amount" WHERE (Approval Status=CONST(Open),
                                                                                                              Loan Status=CONST(Appraisal))) }
    { 37  ;   ;Approved Loans Amount;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register"."Approved Amount" WHERE (Approval Status=CONST(Approved),
                                                                                                             Loan Status=CONST(Appraisal))) }
    { 38  ;   ;Loans Posted Amount ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register"."Approved Amount" WHERE (Approval Status=CONST(Approved),
                                                                                                             Loan Status=CONST(Issued),
                                                                                                             Posted=CONST(Yes))) }
    { 39  ;   ;Performing Loans    ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Loans Category-SASRA=CONST(Perfoming),
                                                                                             Outstanding Balance=FILTER(>0))) }
    { 40  ;   ;Watch Loans         ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Loans Category-SASRA=CONST(Watch),
                                                                                             Outstanding Balance=FILTER(>0))) }
    { 41  ;   ;Substandard Loans   ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Loans Category-SASRA=CONST(Substandard),
                                                                                             Outstanding Balance=FILTER(>0))) }
    { 42  ;No ;Doubtful Loans      ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Loans Category-SASRA=CONST(Doubtful),
                                                                                             Outstanding Balance=FILTER(>0))) }
    { 43  ;   ;Loss Loans          ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Loans Category-SASRA=CONST(Loss),
                                                                                             Outstanding Balance=FILTER(>0))) }
    { 44  ;   ;Outstanding Loans   ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Outstanding Balance=FILTER(>0))) }
    { 45  ;   ;Outstanding Loans Amount;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register"."Approved Amount" WHERE (Outstanding Balance=FILTER(>0))) }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

