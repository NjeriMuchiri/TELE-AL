OBJECT table 17289 Cheque Disbursment Table
{
  OBJECT-PROPERTIES
  {
    Date=05/08/15;
    Time=[ 3:33:44 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
                IF codes = '' THEN BEGIN
                 SalesSetup.GET;
                 SalesSetup.TESTFIELD(SalesSetup."Cheque Nos.");
                 NoSeriesMgt.InitSeries(SalesSetup."Cheque Nos.",xRec."No. Series",0D,codes,"No. Series");
                END;


               IF Loans.GET("Loan Number") THEN BEGIN
                   IF Loans."Appeal Loan" THEN
                       Appeal:=TRUE;
               END;
             END;

  }
  FIELDS
  {
    { 1   ;   ;codes               ;Code30        ;OnValidate=BEGIN

                                                                IF codes<> xRec.codes THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."Cheque Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Loan Number         ;Code30        ;OnValidate=BEGIN

                                                                "Account Type":="Account Type"::"Bank Account";
                                                              END;
                                                               }
    { 3   ;   ;Cheque Number       ;Code10        ;OnValidate=BEGIN
                                                                IF Posted THEN
                                                                    ERROR('This Cheque was already disbursed. It Cannot be Modified');
                                                              END;
                                                               }
    { 4   ;   ;Cheque Amount       ;Decimal       ;OnValidate=BEGIN
                                                                IF Posted THEN
                                                                    ERROR('This Cheque was already disbursed. It Cannot be Modified');
                                                              END;
                                                               }
    { 5   ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 6   ;   ;Bank Account        ;Code10        ;TableRelation="Bank Account";
                                                   OnValidate=BEGIN
                                                                IF Posted THEN
                                                                    ERROR('This Cheque was already disbursed. It Cannot be Modified');
                                                              END;
                                                               }
    { 7   ;   ;Dedact From         ;Boolean       ;OnValidate=BEGIN
                                                                IF Posted THEN
                                                                    ERROR('This Cheque was already disbursed. It Cannot be Modified');
                                                              END;
                                                               }
    { 8   ;   ;Posting Date        ;Date          ;OnValidate=BEGIN
                                                                IF Posted THEN
                                                                    ERROR('This Cheque was already disbursed. It Cannot be Modified');
                                                              END;
                                                               }
    { 9   ;   ;Account Type        ;Option        ;OnValidate=BEGIN
                                                                IF Posted THEN
                                                                    ERROR('This Cheque was already disbursed. It Cannot be Modified');
                                                              END;

                                                   OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,None,Staff;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,None,Staff }
    { 10  ;   ;Appeal              ;Boolean        }
    { 11  ;   ;Posted              ;Boolean        }
    { 12  ;   ;Description         ;Text50         }
  }
  KEYS
  {
    {    ;codes,Loan Number,Cheque Number         ;SumIndexFields=Cheque Amount;
                                                   Clustered=Yes }
    {    ;Cheque Number                            }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SalesSetup@1102760000 : Record 39004267;
      NoSeriesMgt@1102760001 : Codeunit 396;
      Loans@1000 : Record 39004241;
      AppealAmount@1001 : Decimal;
      ChequeDisb@1002 : Record 39004373;

    BEGIN
    END.
  }
}

