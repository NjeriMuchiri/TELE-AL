OBJECT table 17240 Loan Disburesment-Batching
{
  OBJECT-PROPERTIES
  {
    Date=11/29/22;
    Time=[ 4:34:54 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "Batch No." = '' THEN BEGIN
                 SalesSetup.GET();
                 SalesSetup.TESTFIELD(SalesSetup."Loans Batch Nos");
                 NoSeriesMgt.InitSeries(SalesSetup."Loans Batch Nos",xRec."No. Series",0D,"Batch No.","No. Series");

               END;
               //ERROR('You dont have permission to create %1 batches',"Batch Type")

               "Prepared By":=USERID;
               "Document No.":="Batch No.";
               "Posting Date":=TODAY;
             END;

    OnModify=BEGIN
               IF Posted = TRUE THEN
               ERROR('You can not modify a posted batch.');
             END;

    OnDelete=BEGIN
               IF Posted = TRUE THEN
               ERROR('You cannot delete a posted batch.');
             END;

    OnRename=BEGIN
               IF Posted = TRUE THEN
               ERROR('You cannot rename a posted batch.');
             END;

    LookupPageID=Page51516255;
    DrillDownPageID=Page51516255;
  }
  FIELDS
  {
    { 1   ;   ;Batch No.           ;Code20        ;OnValidate=BEGIN
                                                                IF "Batch No." <> xRec."Batch No." THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."Loans Batch Nos");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   NotBlank=No }
    { 2   ;   ;Description/Remarks ;Text30         }
    { 3   ;   ;Posted              ;Boolean        }
    { 4   ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending Approval,,Approved,Rejected;
                                                   OptionString=Open,Pending Approval,,Approved,Rejected }
    { 5   ;   ;Date Created        ;Date           }
    { 6   ;   ;Posting Date        ;Date           }
    { 7   ;   ;Posted By           ;Code40         }
    { 8   ;   ;Prepared By         ;Code40        ;Editable=No }
    { 9   ;   ;Date                ;Date           }
    { 10  ;   ;Mode Of Disbursement;Option        ;InitValue=Transfer to FOSA;
                                                   OnValidate=BEGIN
                                                                IF "Mode Of Disbursement"<>"Mode Of Disbursement"::"Transfer to FOSA" THEN
                                                                "Cheque No.":="Batch No.";
                                                                MODIFY;
                                                              END;

                                                   OptionCaptionML=ENU=Individual Cheques,Cheque,Transfer to FOSA,FOSA Loans,EFT,RTGS,Agency;
                                                   OptionString=Individual Cheques,Cheque,Transfer to FOSA,FOSA Loans,EFT,RTGS,Agency }
    { 11  ;   ;Document No.        ;Code20         }
    { 12  ;   ;BOSA Bank Account   ;Code20        ;TableRelation=IF (Housing=CONST(No)) "Bank Account".No.
                                                                 ELSE IF (Housing=CONST(Yes)) Customer.No.;
                                                   OnValidate=BEGIN
                                                                { IF ("Mode Of Disbursement"="Mode Of Disbursement"::"FOSA Loans") OR  ("Mode Of Disbursement"="Mode Of Disbursement"::"Transfer to FOSA") THEN
                                                                 ERROR('Cannot be used with this disbursemnt method %1',"Mode Of Disbursement");
                                                                                                                                                 }
                                                              END;
                                                               }
    { 13  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 14  ;   ;Approvals Remarks   ;Text150        }
    { 15  ;   ;Total Loan Amount   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register"."Approved Amount" WHERE (Batch No.=FIELD(Batch No.),
                                                                                                             Loan Status=FILTER(<>Rejected),
                                                                                                             Source=FILTER(FOSA|BOSA|MICRO),
                                                                                                             Loan Product Type=FILTER(<>BRIDGING)));
                                                   Editable=No }
    { 16  ;   ;Current Location    ;Code50        ;FieldClass=FlowField;
                                                   CalcFormula=Max("Movement Tracker".Station WHERE (Document No.=FIELD(Batch No.)));
                                                   Editable=Yes }
    { 17  ;   ;Cheque No.          ;Code20         }
    { 18  ;   ;Batch Type          ;Option        ;OnValidate=BEGIN
                                                                EntryNo:=0;


                                                                {
                                                                ApprovalsSetup.RESET;
                                                                ApprovalsSetup.SETRANGE(ApprovalsSetup."Approval Type","Batch Type");
                                                                IF ApprovalsSetup.FIND('-') THEN BEGIN
                                                                MovementTracker.INIT;
                                                                MovementTracker."Entry No.":=EntryNo;
                                                                MovementTracker."Document No.":="Batch No.";
                                                                MovementTracker."Approval Type":=ApprovalsSetup."Approval Type";
                                                                MovementTracker.Stage:=ApprovalsSetup.Stage;
                                                                MovementTracker."Current Location":=TRUE;
                                                                MovementTracker.Status:=MovementTracker.Status::"Being Processed";
                                                                MovementTracker.Description:=ApprovalsSetup.Description;
                                                                MovementTracker.Station:=ApprovalsSetup.Station;
                                                                MovementTracker."Date/Time In":=CREATEDATETIME(TODAY,TIME);
                                                                MovementTracker.INSERT(TRUE);}




                                                                IF "Batch Type" = "Batch Type"::"Bridging Loans" THEN
                                                                "Mode Of Disbursement":="Mode Of Disbursement"::Cheque;
                                                              END;

                                                   OptionString=Loans,Bridging Loans,Personal Loans,Refunds,Funeral Expenses,Withdrawals - Resignation,Withdrawals - Death,Branch Loans,Journals,File Movement,Appeal Loans }
    { 19  ;   ;Special Advance Posted;Boolean      }
    { 20  ;   ;FOSA Bank Account   ;Code20        ;TableRelation="Bank Account".No. }
    { 21  ;   ;No of Loans         ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Batch No.=FIELD(Batch No.)));
                                                   Editable=No }
    { 22  ;   ;Post to Loan Control;Boolean       ;OnValidate=BEGIN
                                                                IF "Batch Type" <> "Batch Type"::"Branch Loans" THEN
                                                                ERROR('Only applicable for branch loans');
                                                              END;
                                                               }
    { 23  ;   ;Total Appeal Amount ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register"."Appeal Amount" WHERE (Batch No.=FIELD(Batch No.),
                                                                                                           Loan Status=FILTER(<>Rejected),
                                                                                                           Source=CONST(BOSA)));
                                                   Editable=No }
    { 24  ;   ;Source              ;Option        ;OptionCaptionML=ENU=BOSA,FOSA,MICRO;
                                                   OptionString=BOSA,FOSA,MICRO }
    { 25  ;   ;Location            ;Code50        ;FieldClass=FlowField;
                                                   CalcFormula=Max("Movement Tracker".Station WHERE (Document No.=FIELD(Batch No.),
                                                                                                     Current Location=CONST(Yes)));
                                                   Editable=No }
    { 26  ;   ;Finance Approval    ;Boolean        }
    { 27  ;   ;Audit Approval      ;Boolean        }
    { 28  ;   ;Cheque Name         ;Text60         }
    { 29  ;   ;No transfer Fee     ;Boolean        }
    { 31  ;   ;Total Net Loans Disbursed;Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register"."Net Loan Disbursed" WHERE (Batch No.=FIELD(Batch No.))) }
    { 32  ;   ;Net Loan Disbursed  ;Decimal        }
    { 33  ;   ;Housing             ;Boolean       ;OnValidate=BEGIN
                                                                //IF Housing= TRUE THEN
                                                              END;
                                                               }
    { 34  ;   ;No of Appeal Loans  ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (Appeal Batch No.=FIELD(Batch No.))) }
    { 35  ;   ;Approved By         ;Code40        ;Editable=No }
    { 36  ;   ;Overdraft           ;Boolean        }
  }
  KEYS
  {
    {    ;Batch No.                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SalesSetup@1102760000 : Record 51516258;
      NoSeriesMgt@1102760001 : Codeunit 396;
      EntryNo@1102760004 : Integer;

    BEGIN
    END.
  }
}

