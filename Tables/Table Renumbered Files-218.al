OBJECT table 17339 Change MPESA Transactions
{
  OBJECT-PROPERTIES
  {
    Date=10/31/16;
    Time=12:56:41 PM;
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
                 IF No = '' THEN BEGIN
                 NoSetup.GET();
                 NoSetup.TESTFIELD(NoSetup."MPESA Change Nos");
                 NoSeriesMgt.InitSeries(NoSetup."MPESA Change Nos",xRec."No. Series",0D,No,"No. Series");
                 END;

               "Initiated By":=USERID;
               "Transaction Date":=TODAY;
             END;

    OnDelete=BEGIN
               IF Status<>Status::Open THEN BEGIN
               ERROR('You cannot delete the MPESA transaction because it has already been sent for first approval.');
               END;
             END;

    LookupPageID=Page52018515;
    DrillDownPageID=Page52018515;
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20         }
    { 2   ;   ;Transaction Date    ;Date           }
    { 3   ;   ;Initiated By        ;Code50         }
    { 4   ;   ;MPESA Receipt No    ;Code20        ;TableRelation="MPESA Transactions"."Document No." WHERE (Posted=CONST(No));
                                                   OnValidate=BEGIN
                                                                MPESATrans.RESET;
                                                                MPESATrans.SETRANGE(MPESATrans."Document No.","MPESA Receipt No");
                                                                IF MPESATrans.FIND('-') THEN BEGIN
                                                                "Account No":=MPESATrans."Account No.";
                                                                END;
                                                              END;
                                                               }
    { 5   ;   ;Account No          ;Code30         }
    { 6   ;   ;New Account No      ;Code30        ;TableRelation=IF (Destination Type=CONST(FOSA)) Vendor.No.
                                                                 ELSE IF (Destination Type=CONST(BOSA)) "Members Register"."ID No." }
    { 7   ;   ;Comments            ;Text100        }
    { 8   ;   ;Approved By         ;Code50         }
    { 9   ;   ;Date Approved       ;Date           }
    { 10  ;   ;Time Approved       ;Time           }
    { 11  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 12  ;   ;Changed             ;Boolean        }
    { 13  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected }
    { 14  ;   ;Send For Approval By;Code50         }
    { 15  ;   ;Date Sent For Approval;Date         }
    { 16  ;   ;Time Sent For Approval;Time         }
    { 17  ;   ;Reasons for rejection;Text200       }
    { 18  ;   ;BOSA Account No     ;Code20        ;TableRelation="Members Register".No.;
                                                   OnValidate=BEGIN
                                                                BOSAAcct.RESET;
                                                                BOSAAcct.SETRANGE(BOSAAcct."No.",No);
                                                                IF BOSAAcct.FIND('-') THEN BEGIN
                                                                BOSAAcct.TESTFIELD(BOSAAcct."ID No.");
                                                                END;
                                                              END;
                                                               }
    { 19  ;   ;Transaction Type    ;Option        ;OptionString=Deposit Contribution,Share Capital,Loan Repayment,Benevolent Funds }
    { 20  ;   ;Destination Type    ;Option        ;OptionCaptionML=ENU=FOSA,BOSA;
                                                   OptionString=FOSA,BOSA }
    { 21  ;   ;Loan Product Type   ;Code20        ;TableRelation="Paybill Keywords".Keyword WHERE (Destination Type=CONST(Loan Repayment)) }
    { 22  ;   ;App Status          ;Option        ;OptionCaptionML=ENU=Pending,First Approval,Changed,Rejected;
                                                   OptionString=Pending,First Approval,Changed,Rejected }
    { 23  ;   ;Responsibility Centre;Code20       ;TableRelation="Responsibility Center" }
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
      NoSetup@1102756001 : Record 98;
      NoSeriesMgt@1102756000 : Codeunit 396;
      MPESATrans@1102756002 : Record 51516334;
      BOSAAcct@1102755000 : Record 51516223;

    BEGIN
    END.
  }
}

