OBJECT table 17256 Dividends Progression
{
  OBJECT-PROPERTIES
  {
    Date=03/24/23;
    Time=[ 1:39:19 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Member No           ;Code20         }
    { 2   ;   ;Date                ;Date           }
    { 3   ;   ;Gross Dividends     ;Decimal        }
    { 4   ;   ;Witholding Tax      ;Decimal        }
    { 5   ;   ;Net Dividends       ;Decimal        }
    { 6   ;   ;Qualifying Shares   ;Decimal        }
    { 7   ;   ;Shares              ;Decimal        }
    { 8   ;   ;Posted              ;Boolean        }
    { 9   ;   ;Deposit Type        ;Option        ;OptionCaptionML=ENU=,Share Capital,Deposits,ESS;
                                                   OptionString=,Share Capital,Deposits,ESS }
    { 10  ;   ;Year                ;Code10         }
    { 11  ;   ;Saving Type         ;Option        ;OptionCaptionML=ENU=,Jibambe Savings,Mdosi Junior,Pension Akiba,FOSA Savings;
                                                   OptionString=,Jibambe Savings,Mdosi Junior,Pension Akiba,FOSA Savings }
    { 12  ;   ;Total Net Dividends ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Dividends Progression"."Net Dividends" WHERE (Member No=FIELD(Member No),
                                                                                                                  Deposit Type=FIELD(Deposit Type))) }
    { 13  ;   ;Interest Capitalizing Amount;Decimal }
    { 14  ;   ;Total Int Capitalizing Amount;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Dividends Progression"."Interest Capitalizing Amount" WHERE (Member No=FIELD(Member No),
                                                                                                                                 Deposit Type=FIELD(Deposit Type))) }
  }
  KEYS
  {
    {    ;Member No,Date,Deposit Type             ;SumIndexFields=Gross Dividends,Net Dividends,Shares,Qualifying Shares,Witholding Tax;
                                                   Clustered=Yes }
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

