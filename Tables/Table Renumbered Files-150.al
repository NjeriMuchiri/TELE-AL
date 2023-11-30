OBJECT table 17268 BOSA Transfers
{
  OBJECT-PROPERTIES
  {
    Date=07/17/23;
    Time=10:35:17 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF No = '' THEN BEGIN
                 NoSetup.GET;
                 NoSetup.TESTFIELD(NoSetup."BOSA Transfer Nos");
                 NoSeriesMgt.InitSeries(NoSetup."BOSA Transfer Nos",xRec."No. Series",0D,No,"No. Series");
                 END;
                "Transaction Date":=TODAY;
                "Transaction Time":=TIME;
                "Created By":=USERID;
                "Created On":=CURRENTDATETIME;
             END;

    OnModify=BEGIN
               IF Posted THEN
               ERROR('Cannot modify a posted batch');
             END;

    OnDelete=BEGIN
               IF Approved OR Posted THEN
               ERROR('Cannot delete posted or approved batch');
             END;

    OnRename=BEGIN
               IF Posted THEN
               ERROR('Cannot rename a posted batch');
             END;

    LookupPageID=Page51516374;
    DrillDownPageID=Page51516374;
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code10        ;OnValidate=BEGIN
                                                                IF No <> xRec.No THEN BEGIN
                                                                  NoSetup.GET(0);
                                                                  NoSeriesMgt.TestManual(No);
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Transaction Date    ;Date           }
    { 3   ;   ;Schedule Total      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("BOSA Transfer Schedule".Amount WHERE (No.=FIELD(No))) }
    { 4   ;   ;Approved            ;Boolean        }
    { 5   ;   ;Approved By         ;Code50        ;Editable=No }
    { 6   ;   ;Posted              ;Boolean        }
    { 7   ;   ;No. Series          ;Code20         }
    { 8   ;   ;Responsibility Center;Code10        }
    { 9   ;   ;Remarks             ;Code30         }
    { 10  ;   ;Transaction Time    ;Time           }
    { 11  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Canceled;
                                                   OptionString=Open,Pending,Approved,Canceled;
                                                   Editable=No }
    { 12  ;   ;Created By          ;Code200       ;Editable=No }
    { 13  ;   ;Created On          ;DateTime      ;Editable=No }
    { 14  ;   ;Approved On         ;DateTime      ;Editable=No }
    { 15  ;   ;Mode of Payment     ;Option        ;OptionCaptionML=ENU=Cash,Cheque,Mpesa,Standing order,Deposit Slip;
                                                   OptionString=Cash,Cheque,Mpesa,Standing order,Deposit Slip }
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
      NoSetup@1102760000 : Record 311;
      NoSeriesMgt@1102760001 : Codeunit 396;

    PROCEDURE ApprovalsRequest@1120054002(TheOption@1120054000 : 'Send,Cancel');
    VAR
      ApprovalsMgmt@1120054001 : Codeunit 1535;
      err_type@1120054002 : TextConst 'ENU=Type must have a value!';
      BOSATransfers@1120054003 : Record 51516264;
      BOSATransferSchedule@1120054004 : Record 51516265;
      err_lines@1120054005 : TextConst 'ENU=Please enter the lines in the table.';
    BEGIN
      CASE TheOption OF
         TheOption::Send:BEGIN

             BOSATransferSchedule.RESET;
             BOSATransferSchedule.SETRANGE(BOSATransferSchedule."No.",Rec.No);
             IF BOSATransferSchedule.FINDSET THEN
               BEGIN
                    REPEAT
                         BOSATransferSchedule.TESTFIELD(BOSATransferSchedule."Source Account No.");
                         BOSATransferSchedule.TESTFIELD(BOSATransferSchedule."Source Type");
                         BOSATransferSchedule.TESTFIELD(BOSATransferSchedule."Destination Account No.");
                         //BOSATransferSchedule.TESTFIELD(BOSATransferSchedule."Destination Account Type");
                         BOSATransferSchedule.TESTFIELD(BOSATransferSchedule.Amount);
                      UNTIL BOSATransferSchedule.NEXT = 0;
                 END ELSE
                     ERROR(err_lines);

              TESTFIELD("Transaction Date");
              TESTFIELD("Transaction Time");
              TESTFIELD(Status,Status::Open);
              TESTFIELD(Remarks);

               IF ApprovalsMgmt.CheckBosaTransferWorkflowEnabled(Rec) THEN
                 ApprovalsMgmt.OnSendBosaTransferForApproval(Rec);

           END;
         TheOption::Cancel:BEGIN
              TESTFIELD(Status,Status::Pending);
              TESTFIELD("Created By",USERID);
              ApprovalsMgmt.OnCancelBosaTransferApprovalRequest(Rec);
              END;
        END;
    END;

    BEGIN
    END.
  }
}

