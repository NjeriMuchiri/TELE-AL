OBJECT table 50056 SACCO Categorization
{
  OBJECT-PROPERTIES
  {
    Date=01/16/20;
    Time=12:29:08 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan No.            ;Code20         }
    { 2   ;   ;Loans Category-SACCO;Option        ;OptionCaptionML=ENU=Perfoming,Watch,Substandard,Doubtful,Loss;
                                                   OptionString=Perfoming,Watch,Substandard,Doubtful,Loss }
    { 3   ;   ;Outstanding Balance ;Decimal        }
    { 4   ;   ;Defaulted Months    ;Integer        }
    { 5   ;   ;Defaulted Amount    ;Decimal        }
    { 6   ;   ;As At               ;Date           }
    { 7   ;   ;Defaulted Days      ;Integer        }
  }
  KEYS
  {
    {    ;Loan No.                                ;Clustered=Yes }
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

