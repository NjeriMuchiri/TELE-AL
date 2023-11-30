OBJECT table 17262 Sacco No. Series
{
  OBJECT-PROPERTIES
  {
    Date=03/20/23;
    Time=[ 6:37:26 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10         }
    { 2   ;   ;FOSA Loans Nos      ;Code10        ;TableRelation="No. Series" }
    { 3   ;   ;Members Nos         ;Code10        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                {CustMemb.RESET;
                                                                CustMemb.SETRANGE(CustMemb."No. Series","Members Nos");
                                                                IF CustMemb.FIND('-') = FALSE THEN BEGIN
                                                                 ERROR('You cannot Delete/Modify since Series has been used in one or more entries');
                                                                END;
                                                                  }
                                                              END;
                                                               }
    { 4   ;   ;BOSA Loans Nos      ;Code10        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                {LoanApps.RESET;
                                                                LoanApps.SETRANGE(LoanApps."No. Series","BOSA Loans Nos");
                                                                IF LoanApps.FIND('-') = FALSE THEN BEGIN
                                                                 ERROR('You cannot Delete/Modify since Series has been used in one or more transactions');
                                                                END;
                                                                    }
                                                              END;
                                                               }
    { 5   ;   ;Loans Batch Nos     ;Code10        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                {LoanApps.RESET;
                                                                LoanApps.SETRANGE(LoanApps."Batch No.","Loans Batch Nos");
                                                                IF LoanApps.FIND('-') = FALSE THEN BEGIN
                                                                 ERROR('You cannot Delete/Modify since Series has been used in one or more transactions');
                                                                END;
                                                                         }
                                                              END;
                                                               }
    { 6   ;   ;Investors Nos       ;Code10         }
    { 7   ;   ;Property Nos        ;Code10        ;TableRelation="No. Series" }
    { 8   ;   ;BOSA Receipts Nos   ;Code10        ;TableRelation="No. Series" }
    { 9   ;   ;Investment Project Nos;Code10      ;TableRelation="No. Series" }
    { 10  ;   ;BOSA Transfer Nos   ;Code10        ;TableRelation="No. Series" }
    { 11  ;   ;SMS Request Series  ;Code10        ;TableRelation="No. Series" }
    { 12  ;   ;Withholding Tax %   ;Decimal        }
    { 13  ;   ;Withholding Tax Account;Code20     ;TableRelation="G/L Account".No. }
    { 14  ;   ;VAT %               ;Decimal        }
    { 15  ;   ;VAT Account         ;Code20        ;TableRelation="G/L Account".No. }
    { 16  ;   ;PV No.              ;Code20        ;TableRelation="No. Series" }
    { 17  ;   ;Receipts Nos        ;Code10        ;TableRelation="No. Series".Code }
    { 18  ;   ;Petty Cash  No.     ;Code20        ;TableRelation="No. Series".Code }
    { 19  ;   ;Member Application Nos;Code10      ;TableRelation="No. Series".Code;
                                                   OnValidate=BEGIN
                                                                   {
                                                                CustMembApp.RESET;
                                                                CustMembApp.SETRANGE(CustMembApp."No. Series","Member Application Nos");
                                                                IF CustMembApp.FIND('-') = FALSE THEN BEGIN
                                                                 ERROR('You cannot Delete/Modify since Series has been used in one or more entries');
                                                                END;
                                                                      }
                                                              END;
                                                               }
    { 20  ;   ;Closure  Nos        ;Code10        ;TableRelation="No. Series".Code;
                                                   OnValidate=BEGIN
                                                                {AccClosure.RESET;
                                                                AccClosure.SETRANGE(AccClosure."No. Series","Closure  Nos");
                                                                IF AccClosure.FIND('-') = TRUE THEN BEGIN
                                                                 ERROR('You cannot Delete/Modify since Series has been used in one or more entries');
                                                                END;
                                                                    }
                                                              END;
                                                               }
    { 21  ;   ;Bosa Transaction Nos;Code10        ;TableRelation="No. Series" }
    { 22  ;   ;Transaction Nos.    ;Code10        ;TableRelation="No. Series" }
    { 23  ;   ;Treasury Nos.       ;Code10        ;TableRelation="No. Series" }
    { 24  ;   ;Standing Orders Nos.;Code10        ;TableRelation="No. Series" }
    { 25  ;   ;FOSA Current Account;Code20        ;TableRelation="G/L Account" }
    { 26  ;   ;BOSA Current Account;Code20        ;TableRelation="Bank Account" }
    { 27  ;   ;Teller Transactions No;Code10      ;TableRelation="No. Series" }
    { 28  ;   ;Treasury Transactions No;Code10    ;TableRelation="No. Series" }
    { 29  ;   ;Applicants Nos.     ;Code10        ;TableRelation="No. Series" }
    { 30  ;   ;STO Register No     ;Code10        ;TableRelation="No. Series" }
    { 31  ;   ;EFT Header Nos.     ;Code10        ;TableRelation="No. Series" }
    { 32  ;   ;EFT Details Nos.    ;Code10        ;TableRelation="No. Series" }
    { 33  ;   ;Salaries Nos.       ;Code10        ;TableRelation="No. Series" }
    { 34  ;   ;Requisition No      ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=Requisition No }
    { 35  ;   ;Internal Requisition No.;Code10    ;TableRelation="No. Series" }
    { 36  ;   ;Internal Purchase No.;Code10       ;TableRelation="No. Series".Code }
    { 37  ;   ;Quatation Request No;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=Quatation Request No }
    { 38  ;   ;ATM Applications    ;Code20        ;TableRelation="No. Series" }
    { 39  ;   ;Stores Requisition No;Code10       ;TableRelation="No. Series" }
    { 40  ;   ;Requisition Default Vendor;Code10   }
    { 41  ;   ;Use Procurement limits;Boolean      }
    { 42  ;   ;Request for Quotation Nos;Code20    }
    { 43  ;   ;Teller Bulk Trans Nos.;Code10      ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                {RcptBuffer.RESET;
                                                                RcptBuffer.SETRANGE(RcptBuffer."No. Series","Receipt Buffer Nos.");
                                                                IF RcptBuffer.FIND('-') = FALSE THEN BEGIN
                                                                 ERROR('You cannot Delete/Modify since Series has been used in one or more transactions');
                                                                END;
                                                                 }
                                                              END;
                                                               }
    { 44  ;   ;Micro Loans         ;Code10        ;TableRelation="No. Series" }
    { 45  ;   ;Micro Transactions  ;Code10        ;TableRelation="No. Series" }
    { 46  ;   ;Micro Finance Transactions;Code10  ;TableRelation="No. Series" }
    { 47  ;   ;Micro Group Nos.    ;Code10        ;TableRelation="No. Series".Code }
    { 48  ;   ;MPESA Change Nos    ;Code30        ;TableRelation="No. Series" }
    { 49  ;   ;MPESA Application Nos;Code30       ;TableRelation="No. Series" }
    { 50  ;   ;Change MPESA PIN Nos;Code30        ;TableRelation="No. Series" }
    { 51  ;   ;Change MPESA Application Nos;Code30;TableRelation="No. Series" }
    { 52  ;   ;Last Memb No.       ;Code30         }
    { 53  ;   ;BosaNumber          ;Code30         }
    { 54  ;   ;Investor Application Nos;Code30    ;TableRelation="No. Series" }
    { 55  ;   ;Investor Nos        ;Code30         }
    { 56  ;   ;Paybill Processing  ;Code30        ;TableRelation="No. Series" }
    { 57  ;   ;Checkoff-Proc Distributed Nos;Code30;
                                                   TableRelation="No. Series" }
    { 58  ;   ;Tracker no          ;Code30        ;TableRelation="No. Series" }
    { 59  ;   ;SurePESA Registration Nos;Code30   ;TableRelation="No. Series" }
    { 60  ;   ;Change Request No   ;Code15        ;TableRelation="No. Series" }
    { 61  ;   ;Guarantor Substitution;Code20      ;TableRelation="No. Series" }
    { 51516001;;Loan PayOff Nos    ;Code20        ;TableRelation="No. Series" }
    { 51516002;;FixedDposit        ;Code10         }
    { 51516003;;RequestNo          ;Code15         }
    { 51516004;;Salaries Upload Nos.;Code10       ;TableRelation="No. Series" }
    { 51516005;;Withdrawal Batch   ;Code20        ;TableRelation="No. Series" }
    { 51516006;;Salary Processing Nos;Code20      ;TableRelation="No. Series" }
    { 51516007;;Shares Transfer Nos;Code10        ;TableRelation="No. Series" }
    { 51516008;;Collector Change Nos;Code20       ;TableRelation="No. Series" }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      LoanApps@1102755000 : Record 51516230;
      CustMemb@1102755001 : Record 51516223;
      CustMembApp@1102755002 : Record 51516220;
      AccClosure@1102755003 : Record 51516259;

    PROCEDURE TestNoEntriesExist@1006(CurrentFieldName@1000 : Text[100]);
    VAR
      LoanApps@1001 : Record 51516230;
    BEGIN
      {
      //To prevent change of field
       LoanApps.SETCURRENTKEY(LoanApps."No. Series");
       LoanApps.SETRANGE(LoanApps."No. Series","No.");
      IF LoanApps.FIND('-') THEN
        ERROR(
        Text000,
         CurrentFieldName);
      }
    END;

    BEGIN
    END.
  }
}

