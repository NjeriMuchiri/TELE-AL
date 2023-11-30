OBJECT table 20434 Advance Eligibility
{
  OBJECT-PROPERTIES
  {
    Date=11/28/19;
    Time=12:21:57 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry NO            ;Integer       ;AutoIncrement=Yes }
    { 2   ;   ;Account             ;Code50         }
    { 3   ;   ;Name                ;Code250        }
    { 4   ;   ;Loan type           ;Option        ;OptionCaptionML=ENU=Mobile Loan,Vukisha Loan;
                                                   OptionString=Mobile Loan,Vukisha Loan }
    { 5   ;   ;Status              ;Option        ;OptionCaptionML=ENU=Success,Failed;
                                                   OptionString=Success,Failed }
    { 6   ;   ;Loan Amount         ;Decimal        }
    { 7   ;   ;Description         ;Text250        }
    { 8   ;   ;Date                ;Date           }
    { 9   ;   ;Datetime            ;DateTime       }
    { 10  ;   ;Staff No            ;Code50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Vendor."Staff No" WHERE (No.=FIELD(Account))) }
    { 11  ;   ;Phone number        ;Code50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Vendor."Phone No." WHERE (No.=FIELD(Account))) }
  }
  KEYS
  {
    {    ;Entry NO                                ;Clustered=Yes }
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

