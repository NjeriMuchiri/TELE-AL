OBJECT table 17228 Member Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=08/25/20;
    Time=[ 3:16:45 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    CaptionML=ENU=Member Ledger Entry;
    LookupPageID=Page51516229;
    DrillDownPageID=Page51516229;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=ENU=Entry No. }
    { 3   ;   ;Customer No.        ;Code20        ;TableRelation="Members Register".No.;
                                                   CaptionML=ENU=Customer No. }
    { 4   ;   ;Posting Date        ;Date          ;CaptionML=ENU=Posting Date }
    { 5   ;   ;Document Type       ;Option        ;CaptionML=ENU=Document Type;
                                                   OptionCaptionML=ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund";
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 6   ;   ;Document No.        ;Code20        ;CaptionML=ENU=Document No. }
    { 7   ;   ;Description         ;Text100       ;CaptionML=ENU=Description }
    { 11  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=ENU=Currency Code }
    { 13  ;   ;Amount              ;Decimal       ;CaptionML=ENU=Amount;
                                                   Editable=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 14  ;   ;Remaining Amount    ;Decimal       ;CaptionML=ENU=Remaining Amount;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 15  ;   ;Original Amt. (LCY) ;Decimal       ;CaptionML=ENU=Original Amt. (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 16  ;   ;Remaining Amt. (LCY);Decimal       ;CaptionML=ENU=Remaining Amt. (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 17  ;   ;Amount (LCY)        ;Decimal       ;CaptionML=ENU=Amount (LCY);
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 18  ;   ;Sales (LCY)         ;Decimal       ;CaptionML=ENU=Sales (LCY);
                                                   AutoFormatType=1 }
    { 19  ;   ;Profit (LCY)        ;Decimal       ;CaptionML=ENU=Profit (LCY);
                                                   AutoFormatType=1 }
    { 20  ;   ;Inv. Discount (LCY) ;Decimal       ;CaptionML=ENU=Inv. Discount (LCY);
                                                   AutoFormatType=1 }
    { 21  ;   ;Sell-to Customer No.;Code20        ;TableRelation="Members Register";
                                                   CaptionML=ENU=Sell-to Customer No. }
    { 22  ;   ;Customer Posting Group;Code10      ;TableRelation="Customer Posting Group";
                                                   CaptionML=ENU=Customer Posting Group }
    { 23  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   CaptionClass='1,1,1' }
    { 24  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=ENU=Global Dimension 2 Code;
                                                   CaptionClass='1,1,2' }
    { 25  ;   ;Salesperson Code    ;Code10        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=ENU=Salesperson Code }
    { 27  ;   ;User ID             ;Code50        ;TableRelation=User;
                                                   OnLookup=VAR
                                                              LoginMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              LoginMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   CaptionML=ENU=User ID }
    { 28  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=ENU=Source Code }
    { 33  ;   ;On Hold             ;Code3         ;CaptionML=ENU=On Hold }
    { 34  ;   ;Applies-to Doc. Type;Option        ;CaptionML=ENU=Applies-to Doc. Type;
                                                   OptionCaptionML=ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund";
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 35  ;   ;Applies-to Doc. No. ;Code20        ;CaptionML=ENU=Applies-to Doc. No. }
    { 36  ;   ;Open                ;Boolean       ;CaptionML=ENU=Open }
    { 37  ;   ;Due Date            ;Date          ;OnValidate=VAR
                                                                ReminderEntry@1000 : Record 300;
                                                                ReminderIssue@1102601000 : Codeunit 393;
                                                              BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                                IF "Due Date" <> xRec."Due Date" THEN BEGIN
                                                                  ReminderEntry.SETCURRENTKEY("Customer Entry No.",Type);
                                                                  ReminderEntry.SETRANGE("Customer Entry No.","Entry No.");
                                                                  ReminderEntry.SETRANGE(Type,ReminderEntry.Type::Reminder);
                                                                  ReminderEntry.SETRANGE("Reminder Level","Last Issued Reminder Level");
                                                                  IF ReminderEntry.FINDLAST THEN
                                                                    ReminderIssue.ChangeDueDate(ReminderEntry,"Due Date",xRec."Due Date");
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Due Date }
    { 38  ;   ;Pmt. Discount Date  ;Date          ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                              END;

                                                   CaptionML=ENU=Pmt. Discount Date }
    { 39  ;   ;Original Pmt. Disc. Possible;Decimal;
                                                   CaptionML=ENU=Original Pmt. Disc. Possible;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 40  ;   ;Pmt. Disc. Given (LCY);Decimal     ;CaptionML=ENU=Pmt. Disc. Given (LCY);
                                                   AutoFormatType=1 }
    { 43  ;   ;Positive            ;Boolean       ;CaptionML=ENU=Positive }
    { 44  ;   ;Closed by Entry No. ;Integer       ;TableRelation="Cust. Ledger Entry";
                                                   CaptionML=ENU=Closed by Entry No. }
    { 45  ;   ;Closed at Date      ;Date          ;CaptionML=ENU=Closed at Date }
    { 46  ;   ;Closed by Amount    ;Decimal       ;CaptionML=ENU=Closed by Amount;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 47  ;   ;Applies-to ID       ;Code20        ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                              END;

                                                   CaptionML=ENU=Applies-to ID }
    { 49  ;   ;Journal Batch Name  ;Code10        ;CaptionML=ENU=Journal Batch Name }
    { 50  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=ENU=Reason Code }
    { 51  ;   ;Bal. Account Type   ;Option        ;CaptionML=ENU=Bal. Account Type;
                                                   OptionCaptionML=ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,Member,None,Staff;
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,Member,None,Staff }
    { 52  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
                                                   CaptionML=ENU=Bal. Account No. }
    { 53  ;   ;Transaction No.     ;Integer       ;CaptionML=ENU=Transaction No. }
    { 54  ;   ;Closed by Amount (LCY);Decimal     ;CaptionML=ENU=Closed by Amount (LCY);
                                                   AutoFormatType=1 }
    { 58  ;   ;Debit Amount        ;Decimal       ;CaptionML=ENU=Debit Amount;
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 59  ;   ;Credit Amount       ;Decimal       ;CaptionML=ENU=Credit Amount;
                                                   BlankZero=Yes;
                                                   Editable=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 60  ;   ;Debit Amount (LCY)  ;Decimal       ;CaptionML=ENU=Debit Amount (LCY);
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 61  ;   ;Credit Amount (LCY) ;Decimal       ;CaptionML=ENU=Credit Amount (LCY);
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 62  ;   ;Document Date       ;Date          ;CaptionML=ENU=Document Date }
    { 63  ;   ;External Document No.;Code50       ;CaptionML=ENU=External Document No. }
    { 64  ;   ;Calculate Interest  ;Boolean       ;CaptionML=ENU=Calculate Interest }
    { 65  ;   ;Closing Interest Calculated;Boolean;CaptionML=ENU=Closing Interest Calculated }
    { 66  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series }
    { 67  ;   ;Closed by Currency Code;Code10     ;TableRelation=Currency;
                                                   CaptionML=ENU=Closed by Currency Code }
    { 68  ;   ;Closed by Currency Amount;Decimal  ;CaptionML=ENU=Closed by Currency Amount;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Closed by Currency Code" }
    { 73  ;   ;Adjusted Currency Factor;Decimal   ;CaptionML=ENU=Adjusted Currency Factor;
                                                   DecimalPlaces=0:15 }
    { 74  ;   ;Original Currency Factor;Decimal   ;CaptionML=ENU=Original Currency Factor;
                                                   DecimalPlaces=0:15 }
    { 75  ;   ;Original Amount     ;Decimal       ;CaptionML=ENU=Original Amount;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 76  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=ENU=Date Filter }
    { 77  ;   ;Remaining Pmt. Disc. Possible;Decimal;
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                                //CALCFIELDS(Amount,"Original Amount");

                                                                IF "Remaining Pmt. Disc. Possible" * Amount < 0 THEN
                                                                  FIELDERROR("Remaining Pmt. Disc. Possible",STRSUBSTNO(Text000,FIELDCAPTION(Amount)));

                                                                IF ABS("Remaining Pmt. Disc. Possible") > ABS("Original Amount") THEN
                                                                  FIELDERROR("Remaining Pmt. Disc. Possible",STRSUBSTNO(Text001,FIELDCAPTION("Original Amount")));
                                                              END;

                                                   CaptionML=ENU=Remaining Pmt. Disc. Possible;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 78  ;   ;Pmt. Disc. Tolerance Date;Date     ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                              END;

                                                   CaptionML=ENU=Pmt. Disc. Tolerance Date }
    { 79  ;   ;Max. Payment Tolerance;Decimal     ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                                //CALCFIELDS(Amount,"Remaining Amount");

                                                                IF "Max. Payment Tolerance" * Amount < 0 THEN
                                                                  FIELDERROR("Max. Payment Tolerance",STRSUBSTNO(Text000,FIELDCAPTION(Amount)));

                                                                IF ABS("Max. Payment Tolerance") > ABS("Remaining Amount") THEN
                                                                  FIELDERROR("Max. Payment Tolerance",STRSUBSTNO(Text001,FIELDCAPTION("Remaining Amount")));
                                                              END;

                                                   CaptionML=ENU=Max. Payment Tolerance;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 80  ;   ;Last Issued Reminder Level;Integer ;CaptionML=ENU=Last Issued Reminder Level }
    { 81  ;   ;Accepted Payment Tolerance;Decimal ;CaptionML=ENU=Accepted Payment Tolerance;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 82  ;   ;Accepted Pmt. Disc. Tolerance;Boolean;
                                                   CaptionML=ENU=Accepted Pmt. Disc. Tolerance }
    { 83  ;   ;Pmt. Tolerance (LCY);Decimal       ;CaptionML=ENU=Pmt. Tolerance (LCY);
                                                   AutoFormatType=1 }
    { 84  ;   ;Amount to Apply     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                                //CALCFIELDS("Remaining Amount");

                                                                IF "Amount to Apply" * "Remaining Amount" < 0 THEN
                                                                  FIELDERROR("Amount to Apply",STRSUBSTNO(Text000,FIELDCAPTION("Remaining Amount")));

                                                                IF ABS("Amount to Apply") > ABS("Remaining Amount") THEN
                                                                  FIELDERROR("Amount to Apply",STRSUBSTNO(Text001,FIELDCAPTION("Remaining Amount")));
                                                              END;

                                                   CaptionML=ENU=Amount to Apply;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 85  ;   ;IC Partner Code     ;Code20        ;TableRelation="IC Partner";
                                                   CaptionML=ENU=IC Partner Code }
    { 86  ;   ;Applying Entry      ;Boolean       ;CaptionML=ENU=Applying Entry }
    { 87  ;   ;Reversed            ;Boolean       ;CaptionML=ENU=Reversed;
                                                   BlankZero=Yes }
    { 88  ;   ;Reversed by Entry No.;Integer      ;TableRelation="Cust. Ledger Entry";
                                                   CaptionML=ENU=Reversed by Entry No.;
                                                   BlankZero=Yes }
    { 89  ;   ;Reversed Entry No.  ;Integer       ;TableRelation="Cust. Ledger Entry";
                                                   CaptionML=ENU=Reversed Entry No.;
                                                   BlankZero=Yes }
    { 90  ;   ;Prepayment          ;Boolean       ;CaptionML=ENU=Prepayment }
    { 68000;  ;Transaction Type    ;Option        ;OptionCaptionML=ENU=" ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated";
                                                   OptionString=[ ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated] }
    { 68001;  ;Loan No             ;Code20         }
    { 68002;  ;Group Code          ;Code20         }
    { 68003;  ;Type                ;Option        ;OptionCaptionML=ENU=" ,Registration,PassBook,Loan Insurance,Loan Application Fee,Down Payment";
                                                   OptionString=[ ,Registration,PassBook,Loan Insurance,Loan Application Fee,Down Payment] }
    { 68004;  ;Member Name         ;Text30         }
    { 68005;  ;Loan Type           ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Loans Register"."Loan Product Type" WHERE (Loan  No.=FIELD(Loan No))) }
    { 68006;  ;Prepayment Date     ;Date           }
    { 68007;  ;Totals              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Document No.=FILTER(JUNE  15/06/14))) }
    { 68008;  ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   CaptionML=[ENU=Dimension Set ID;
                                                              ESM=Id. grupo dimensiones;
                                                              FRC=Code ensemble de dimensions;
                                                              ENC=Dimension Set ID] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Customer No.,Posting Date,Currency Code ;SumIndexFields=Sales (LCY),Profit (LCY),Inv. Discount (LCY);
                                                   SIFTLevelsToMaintain=[{Customer No.},
                                                                         {Customer No.,Posting Date:Year},
                                                                         {Customer No.,Posting Date:Month}] }
    {    ;Customer No.,Currency Code,Posting Date ;KeyGroups=Cust(Curr) }
    {    ;Document No.                             }
    {    ;External Document No.                    }
    {    ;Customer No.,Open,Positive,Due Date,Currency Code }
    {    ;Open,Due Date                            }
    {    ;Document Type,Customer No.,Posting Date,Currency Code;
                                                   SumIndexFields=Sales (LCY),Profit (LCY),Inv. Discount (LCY);
                                                   MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    {    ;Salesperson Code,Posting Date           ;KeyGroups=Cust(Comm) }
    {    ;Closed by Entry No.                      }
    {    ;Transaction No.                          }
    {    ;Customer No.,Open,Positive,Calculate Interest,Due Date;
                                                   KeyGroups=Cust(int) }
    {    ;Customer No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date,Currency Code;
                                                   SumIndexFields=Sales (LCY),Profit (LCY),Inv. Discount (LCY);
                                                   KeyGroups=Cust(Dim) }
    {    ;Customer No.,Open,Global Dimension 1 Code,Global Dimension 2 Code,Positive,Due Date,Currency Code;
                                                   SumIndexFields=Amount (LCY),Amount;
                                                   KeyGroups=Cust(Dim) }
    {    ;Open,Global Dimension 1 Code,Global Dimension 2 Code,Due Date;
                                                   KeyGroups=Cust(Dim) }
    {    ;Document Type,Customer No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date,Currency Code;
                                                   KeyGroups=Cust(Dim) }
    {    ;Customer No.,Applies-to ID,Open,Positive,Due Date }
    {    ;Customer No.,Transaction Type,Loan No   ;SumIndexFields=Amount (LCY),Amount }
    {    ;Transaction Type,Loan No,Posting Date,Customer No.;
                                                   SumIndexFields=Amount (LCY),Amount }
    {    ;Amount,Customer No.                     ;SumIndexFields=Amount (LCY),Amount }
    {    ;Customer Posting Group                   }
    {    ;Posting Date                             }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=must have the same sign as %1';
      Text001@1001 : TextConst 'ENU=must not be larger than %1';

    PROCEDURE DrillDownOnEntries@1(VAR CustLedger@1000 : Record 51516224);
    VAR
      CustLedgEntry@1001 : Record 51516224;
    BEGIN

      //DtldCustLedgEntry.COPYFILTER("Customer No.",CustLedgEntry."Customer No.");
      //DtldCustLedgEntry.COPYFILTER("Currency Code",CustLedgEntry."Currency Code");
      //DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 1",CustLedgEntry."Global Dimension 1 Code");
      //DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 2",CustLedgEntry."Global Dimension 2 Code");
      CustLedgEntry.RESET;
      CustLedgEntry.SETCURRENTKEY("Customer No.","Posting Date");
      CustLedgEntry.SETRANGE(CustLedgEntry."Customer No.",CustLedger."Customer No.");
      CustLedgEntry.SETRANGE(Open,TRUE);
      PAGE.RUN(0,CustLedgEntry);
    END;

    PROCEDURE DrillDownOnOverdueEntries@4(VAR DtldCustLedgEntry@1000 : Record 379);
    VAR
      CustLedgEntry@1001 : Record 21;
    BEGIN
      CustLedgEntry.RESET;
      DtldCustLedgEntry.COPYFILTER("Customer No.",CustLedgEntry."Customer No.");
      DtldCustLedgEntry.COPYFILTER("Currency Code",CustLedgEntry."Currency Code");
      DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 1",CustLedgEntry."Global Dimension 1 Code");
      DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 2",CustLedgEntry."Global Dimension 2 Code");
      CustLedgEntry.SETCURRENTKEY("Customer No.","Posting Date");
      CustLedgEntry.SETFILTER("Date Filter",'..%1',WORKDATE);
      CustLedgEntry.SETFILTER("Due Date",'..%1',WORKDATE);
      CustLedgEntry.SETFILTER("Remaining Amount",'<>%1',0);
      PAGE.RUN(0,CustLedgEntry);
    END;

    PROCEDURE GetOriginalCurrencyFactor@2() : Decimal;
    BEGIN
      IF "Original Currency Factor" = 0 THEN
        EXIT(1);
      EXIT("Original Currency Factor");
    END;

    LOCAL PROCEDURE CheckGLAcc@1102755000(AccNo@1000 : Code[20];CheckProdPostingGroup@1001 : Boolean;CheckDirectPosting@1002 : Boolean);
    VAR
      GLAcc@1003 : Record 15;
    BEGIN
      {
      IF AccNo <> '' THEN BEGIN
        GLAcc.GET(AccNo);
        GLAcc.CheckGLAcc;
        IF CheckProdPostingGroup THEN
          GLAcc.TESTFIELD("Gen. Prod. Posting Group");
        IF CheckDirectPosting THEN
          GLAcc.TESTFIELD("Direct Posting",TRUE);
      END;
      }
    END;

    PROCEDURE TestNoEntriesExist@1006(CurrentFieldName@1000 : Text[100];GLNO@1102755000 : Code[20]);
    VAR
      MemberLedgEntry@1001 : Record 51516224;
    BEGIN
       //To prevent change of field
       MemberLedgEntry.SETCURRENTKEY(MemberLedgEntry."Customer No.");
       MemberLedgEntry.SETRANGE(MemberLedgEntry."Customer No.","Customer No.");
      IF MemberLedgEntry.FIND('-') THEN
        ERROR(
        Text000,
         CurrentFieldName);
    END;

    PROCEDURE RecalculateAmounts@26(FromCurrencyCode@1001 : Code[10];ToCurrencyCode@1002 : Code[10];PostingDate@1003 : Date);
    VAR
      CurrExchRate@1004 : Record 330;
    BEGIN
      IF ToCurrencyCode = FromCurrencyCode THEN
        EXIT;

      "Remaining Amount" :=
        CurrExchRate.ExchangeAmount("Remaining Amount",FromCurrencyCode,ToCurrencyCode,PostingDate);
      "Remaining Pmt. Disc. Possible" :=
        CurrExchRate.ExchangeAmount("Remaining Pmt. Disc. Possible",FromCurrencyCode,ToCurrencyCode,PostingDate);
      "Accepted Payment Tolerance" :=
        CurrExchRate.ExchangeAmount("Accepted Payment Tolerance",FromCurrencyCode,ToCurrencyCode,PostingDate);
      "Amount to Apply" :=
        CurrExchRate.ExchangeAmount("Amount to Apply",FromCurrencyCode,ToCurrencyCode,PostingDate);
    END;

    PROCEDURE CopyFromGenJnlLine@6(GenJnlLine@1000 : Record 81);
    BEGIN
      "Customer No." := GenJnlLine."Account No.";
      "Posting Date" := GenJnlLine."Posting Date";
      "Document Date" := GenJnlLine."Document Date";
      "Document Type" := GenJnlLine."Document Type";
      "Document No." := GenJnlLine."Document No.";
      "External Document No." := GenJnlLine."External Document No.";
      Description := GenJnlLine.Description;
      "Currency Code" := GenJnlLine."Currency Code";
      "Sales (LCY)" := GenJnlLine."Sales/Purch. (LCY)";
      "Profit (LCY)" := GenJnlLine."Profit (LCY)";
      "Inv. Discount (LCY)" := GenJnlLine."Inv. Discount (LCY)";
      "Sell-to Customer No." := GenJnlLine."Sell-to/Buy-from No.";
      "Customer Posting Group" := GenJnlLine."Posting Group";
      "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
      "Salesperson Code" := GenJnlLine."Salespers./Purch. Code";
      "Source Code" := GenJnlLine."Source Code";
      "On Hold" := GenJnlLine."On Hold";
        //Bett
      "Transaction Type":=GenJnlLine."Transaction Type";
      "Loan No":=GenJnlLine."Loan No";
      "Prepayment Date":=GenJnlLine."Prepayment date";// added to cater for prepayments by david
      "Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
      "Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
      "Due Date" := GenJnlLine."Due Date";
      "Pmt. Discount Date" := GenJnlLine."Pmt. Discount Date";
      "Applies-to ID" := GenJnlLine."Applies-to ID";
      "Journal Batch Name" := GenJnlLine."Journal Batch Name";
      "Reason Code" := GenJnlLine."Reason Code";
      "User ID" := USERID;
      "Bal. Account Type" := GenJnlLine."Bal. Account Type";
      "Bal. Account No." := GenJnlLine."Bal. Account No.";
      "No. Series" := GenJnlLine."Posting No. Series";
      "IC Partner Code" := GenJnlLine."IC Partner Code";
      Prepayment := GenJnlLine.Prepayment;
        //cyrus
      "Group Code":=GenJnlLine."Group Code";
        //cyrus
      //Bett
      "Debit Amount":=GenJnlLine."Debit Amount";
      "Credit Amount":=GenJnlLine."Credit Amount";
       // CustLedgEntry."Debit Amount (LCY)":="Debit Amount (LCY)";
       // CustLedgEntry."Credit Amount (LCY)":="Credit Amount (LCY)";
      "Loan No":="Loan No";
      //Bett
    END;

    PROCEDURE UpdateDebitCredit@47(Correction@1000 : Boolean);
    BEGIN
      IF ((Amount > 0) OR ("Amount (LCY)" > 0)) AND NOT Correction OR
         ((Amount < 0) OR ("Amount (LCY)" < 0)) AND Correction
      THEN BEGIN
        "Debit Amount" := Amount;
        "Credit Amount" := 0;
        "Debit Amount (LCY)" := "Amount (LCY)";
        "Credit Amount (LCY)" := 0;
      END ELSE BEGIN
        "Debit Amount" := 0;
        "Credit Amount" := -Amount;
        "Debit Amount (LCY)" := 0;
        "Credit Amount (LCY)" := -"Amount (LCY)";
      END;
    END;

    BEGIN
    END.
  }
}

