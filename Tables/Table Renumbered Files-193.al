OBJECT table 17312 Standing Order Register
{
  OBJECT-PROPERTIES
  {
    Date=03/15/17;
    Time=[ 1:09:27 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "Register No." = '' THEN BEGIN
               NoSetup.GET();
               NoSetup.TESTFIELD(NoSetup."STO Register No");
               NoSeriesMgt.InitSeries(NoSetup."STO Register No",xRec."No. Series",0D,"Register No.","No. Series");
               END;
             END;

  }
  FIELDS
  {
    { 1   ;   ;Register No.        ;Code20        ;OnValidate=BEGIN
                                                                IF "Register No." <> xRec."Register No." THEN BEGIN
                                                                  NoSetup.GET();
                                                                  NoSeriesMgt.TestManual(NoSetup."STO Register No");
                                                                  "No. Series" := '';
                                                                END;

                                                                IF "Register No." = '' THEN BEGIN
                                                                NoSetup.GET();
                                                                NoSetup.TESTFIELD(NoSetup."STO Register No");
                                                                NoSeriesMgt.InitSeries(NoSetup."STO Register No",xRec."No. Series",0D,"Register No.","No. Series");
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Source Account No.  ;Code20        ;TableRelation=Vendor.No.;
                                                   NotBlank=Yes }
    { 3   ;   ;Staff/Payroll No.   ;Code20         }
    { 4   ;   ;Account Name        ;Text50         }
    { 5   ;   ;Destination Account Type;Option    ;OptionCaptionML=ENU=Internal,External,BOSA;
                                                   OptionString=Internal,External,BOSA }
    { 6   ;   ;Destination Account No.;Code20     ;TableRelation=IF (Destination Account Type=CONST(Internal)) Vendor.No. WHERE (Creditor Type=CONST(Account)) }
    { 7   ;   ;Destination Account Name;Text50     }
    { 8   ;   ;BOSA Account No.    ;Code20        ;TableRelation=Customer.No. }
    { 9   ;   ;Effective/Start Date;Date           }
    { 10  ;   ;End Date            ;Date           }
    { 11  ;   ;Duration            ;DateFormula   ;NotBlank=Yes }
    { 12  ;   ;Frequency           ;DateFormula   ;NotBlank=Yes }
    { 13  ;   ;Don't Allow Partial Deduction;Boolean }
    { 14  ;   ;Deduction Status    ;Option        ;OptionCaptionML=ENU=Successfull,Partial Deduction,Failed;
                                                   OptionString=Successfull,Partial Deduction,Failed;
                                                   Editable=No }
    { 15  ;   ;Remarks             ;Text100        }
    { 16  ;   ;Amount              ;Decimal       ;NotBlank=Yes }
    { 17  ;   ;Amount Deducted     ;Decimal        }
    { 18  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 19  ;   ;Date                ;Date           }
    { 20  ;   ;EFT                 ;Boolean        }
    { 21  ;   ;Transfered to EFT   ;Boolean        }
    { 22  ;   ;Standing Order No.  ;Code20        ;TableRelation="Payroll Company Setup".Field1 }
    { 23  ;   ;Document No.        ;Code20         }
  }
  KEYS
  {
    {    ;Register No.                            ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NoSetup@1102760001 : Record 51516258;
      NoSeriesMgt@1102760000 : Codeunit 396;

    BEGIN
    END.
  }
}

