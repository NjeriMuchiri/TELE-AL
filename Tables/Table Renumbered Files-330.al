OBJECT table 20474 Dividends History
{
  OBJECT-PROPERTIES
  {
    Date=02/17/22;
    Time=12:36:17 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer        }
    { 2   ;   ;CLient No           ;Code10         }
    { 3   ;   ;Dividend Amount     ;Decimal        }
    { 4   ;   ;Dividend Type       ;Text80         }
    { 5   ;   ;Transaction Date    ;Date           }
    { 6   ;   ;Gross Dividends     ;Decimal        }
    { 7   ;   ;Qualifying Shares   ;Decimal        }
    { 8   ;   ;Witholding Tax      ;Decimal        }
    { 9   ;   ;Deposit Type        ;Option        ;OptionCaptionML=ENU=,Share Capital,Deposits,ESS;
                                                   OptionString=,Share Capital,Deposits,ESS }
    { 10  ;   ;Year                ;Code10         }
    { 11  ;   ;Name                ;Text80         }
  }
  KEYS
  {
    {    ;Entry No                                ;Clustered=Yes }
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

