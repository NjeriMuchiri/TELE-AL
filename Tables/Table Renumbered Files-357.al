OBJECT table 17352 Dividends Progression Hist
{
  OBJECT-PROPERTIES
  {
    Date=01/31/23;
    Time=[ 4:59:47 PM];
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

