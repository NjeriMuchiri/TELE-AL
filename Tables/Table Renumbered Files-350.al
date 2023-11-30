OBJECT table 20495 Co-operative Dividends
{
  OBJECT-PROPERTIES
  {
    Date=07/14/22;
    Time=10:14:11 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               "Date Entered":=CURRENTDATETIME;
               "Processed By":=USERID;
             END;

  }
  FIELDS
  {
    { 1   ;   ;Member No           ;Code20         }
    { 2   ;   ;Start Date          ;Date           }
    { 3   ;   ;Gross Dividends     ;Decimal        }
    { 4   ;   ;Witholding Tax      ;Decimal        }
    { 5   ;   ;Net Dividends       ;Decimal        }
    { 6   ;   ;Qualifying Shares   ;Decimal        }
    { 7   ;   ;Shares              ;Decimal        }
    { 8   ;   ;Date Entered        ;DateTime      ;Editable=No }
    { 9   ;   ;Processed By        ;Code30        ;Editable=No }
    { 10  ;   ;Year                ;Integer       ;Editable=No }
    { 11  ;   ;End Date            ;Date           }
    { 12  ;   ;Member Name         ;Text100       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Members Register".Name WHERE (No.=FIELD(Member No))) }
    { 13  ;   ;Posted              ;Boolean       ;Editable=No }
    { 14  ;   ;Posted By           ;Code50        ;Editable=No }
    { 15  ;   ;Posted On           ;DateTime      ;Editable=No }
    { 16  ;   ;Processing Fee      ;Decimal        }
  }
  KEYS
  {
    {    ;Member No,Start Date,Year               ;SumIndexFields=Gross Dividends,Net Dividends,Shares,Qualifying Shares,Witholding Tax;
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

