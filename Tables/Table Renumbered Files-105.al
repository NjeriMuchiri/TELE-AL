OBJECT table 17223 Payroll General Setup
{
  OBJECT-PROPERTIES
  {
    Date=02/25/22;
    Time=12:00:08 PM;
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 10  ;   ;Primary Key         ;Code10         }
    { 11  ;   ;Tax Relief          ;Decimal       ;Description=[[Relief]]] }
    { 12  ;   ;Insurance Relief    ;Decimal       ;Description=[[Relief]]] }
    { 13  ;   ;Max Relief          ;Decimal       ;Description=[[Relief]]] }
    { 14  ;   ;Mortgage Relief     ;Decimal       ;Description=[[Relief]]] }
    { 15  ;   ;Max Pension Contribution;Decimal   ;Description=[[Pension]]] }
    { 16  ;   ;Tax On Excess Pension;Decimal      ;Description=[[Pension]]] }
    { 17  ;   ;Loan Market Rate    ;Decimal       ;Description=[[Loans]]] }
    { 18  ;   ;Loan Corporate Rate ;Decimal       ;Description=[[Loans]]] }
    { 19  ;   ;Taxable Pay (Normal);Decimal       ;Description=[[Housing]]] }
    { 20  ;   ;Taxable Pay (Agricultural);Decimal ;Description=[[Housing]]] }
    { 21  ;   ;NHIF Based on       ;Option        ;OptionString=Gross,Basic,Taxable Pay;
                                                   Description=[[NHIF]] - Gross,Basic,Taxable Pay] }
    { 22  ;   ;NSSF Employee       ;Decimal       ;Description=[[NSSF]]] }
    { 23  ;   ;NSSF Employer Factor;Decimal       ;Description=[[NSSF]]] }
    { 24  ;   ;OOI Deduction       ;Decimal       ;Description=[[OOI]]] }
    { 25  ;   ;OOI December        ;Decimal       ;Description=[[OOI]]] }
    { 26  ;   ;Security Day (U)    ;Decimal       ;Description=[[Servant]]] }
    { 27  ;   ;Security Night (U)  ;Decimal       ;Description=[[Servant]]] }
    { 28  ;   ;Ayah (U)            ;Decimal       ;Description=[[Servant]]] }
    { 29  ;   ;Gardener (U)        ;Decimal       ;Description=[[Servant]]] }
    { 30  ;   ;Security Day (R)    ;Decimal       ;Description=[[Servant]]] }
    { 31  ;   ;Security Night (R)  ;Decimal       ;Description=[[Servant]]] }
    { 32  ;   ;Ayah (R)            ;Decimal       ;Description=[[Servant]]] }
    { 33  ;   ;Gardener (R)        ;Decimal       ;Description=[[Servant]]] }
    { 34  ;   ;Benefit Threshold   ;Decimal       ;Description=[[Servant]]] }
    { 35  ;   ;NSSF Based on       ;Option        ;OptionString=Gross,Basic,Taxable Pay;
                                                   Description=[[NSSF]] - Gross,Basic,Taxable Pay] }
    { 36  ;   ;Rounding Precision  ;Decimal        }
    { 37  ;   ;Earnings No         ;Code20        ;TableRelation="No. Series" }
    { 38  ;   ;Deductions No       ;Code20        ;TableRelation="No. Series" }
    { 39  ;   ;Currency Exchange Date;Date         }
    { 40  ;   ;BasedOnTimesheet    ;Boolean        }
    { 41  ;   ;NHIF Relief         ;Decimal        }
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

