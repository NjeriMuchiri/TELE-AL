OBJECT table 50036 Imprest Details-User
{
  OBJECT-PROPERTIES
  {
    Date=06/24/21;
    Time=10:55:05 AM;
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20        ;OnValidate=BEGIN
                                                                // IF Pay.GET(No) THEN
                                                                // "Imprest Holder":=Pay."Account No.";
                                                              END;

                                                   NotBlank=Yes }
    { 2   ;   ;Account No:         ;Code10        ;TableRelation="G/L Account".No.;
                                                   OnValidate=BEGIN
                                                                IF GLAcc.GET("Account No:") THEN
                                                                 "Account Name":=GLAcc.Name;
                                                                {
                                                                IF Pay.GET(No) THEN BEGIN
                                                                 IF Pay."Account No."<>'' THEN
                                                                  BEGIN
                                                                      "Imprest Holder":=Pay."Account No."
                                                                  END
                                                                 ELSE
                                                                  BEGIN
                                                                      ERROR('Please Enter the Customer/Account Number');
                                                                  END;
                                                                END;
                                                                }
                                                              END;

                                                   NotBlank=Yes }
    { 3   ;   ;Account Name        ;Text30         }
    { 4   ;   ;Amount              ;Decimal        }
    { 5   ;   ;Due Date            ;Date           }
    { 6   ;   ;Imprest Holder      ;Code20        ;TableRelation=Customer.No. }
    { 7   ;   ;Actual Spent        ;Decimal        }
    { 41  ;   ;Apply to            ;Code20         }
    { 42  ;   ;Apply to ID         ;Code20         }
    { 44  ;   ;Surrender Date      ;Date           }
    { 45  ;   ;Surrendered         ;Boolean        }
    { 46  ;   ;M.R. No             ;Code20         }
    { 47  ;   ;Date Issued         ;Date           }
    { 48  ;   ;Type of Surrender   ;Option        ;OptionString=[ ,Cash,Receipt] }
    { 49  ;   ;Dept. Vch. No.      ;Code20         }
    { 50  ;   ;Cash Surrender Amt  ;Decimal        }
    { 51  ;   ;Bank/Petty Cash     ;Code20        ;TableRelation="Bank Account" }
  }
  KEYS
  {
    {    ;No                                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      GLAcc@1001 : Record 15;

    BEGIN
    END.
  }
}

