OBJECT table 17251 Receipts & Payments
{
  OBJECT-PROPERTIES
  {
    Date=02/16/22;
    Time=[ 1:12:32 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "Transaction No." = '' THEN BEGIN
               NoSetup.GET();
               NoSetup.TESTFIELD(NoSetup."BOSA Receipts Nos");
               NoSeriesMgt.InitSeries(NoSetup."BOSA Receipts Nos",xRec."No. Series",0D,"Transaction No.","No. Series");
               END;

               "User ID":=USERID;
               "Transaction Date":=TODAY;
               "Transaction Time":=TIME;
             END;

    OnModify=BEGIN
               IF Posted THEN
               ERROR('Cannot modify a posted transaction');
             END;

    OnDelete=BEGIN

               IF Posted THEN
               ERROR('Cannot delete a posted transaction');
             END;

    OnRename=BEGIN
               IF Posted THEN
               ERROR('Cannot rename a posted transaction');
             END;

  }
  FIELDS
  {
    { 1   ;   ;Transaction No.     ;Code20         }
    { 2   ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type=CONST(Member)) "Members Register"
                                                                 ELSE IF (Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Account Type=CONST(FOSA Loan)) "Loans Register" WHERE (Source=CONST(FOSA));
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Source);

                                                                IF ("Account Type" = "Account Type"::"FOSA Loan") OR
                                                                   ("Account Type" = "Account Type"::Debtor) THEN BEGIN
                                                                IF Cust.GET("Account No.") THEN BEGIN
                                                                Name:=Cust.Name;
                                                                "ID NO.":=Cust."ID Number";
                                                                "Phone No.":=Cust."Phone No.";
                                                                END;
                                                                END;
                                                                IF ("Account Type" = "Account Type"::Member) THEN BEGIN
                                                                IF Mem.GET("Account No.") THEN
                                                                Name:=Mem.Name;
                                                                "ID NO.":=Mem."ID No.";
                                                                "Phone No.":=Mem."Phone No.";
                                                                END;

                                                                IF ("Account Type" = "Account Type"::Vendor) THEN BEGIN
                                                                IF Vend.GET("Account No.") THEN
                                                                Name:=Vend.Name;
                                                                "ID NO.":=Vend."ID No.";
                                                                "Phone No.":=Vend."Phone No.";
                                                                END;

                                                                IF ("Account Type" = "Account Type"::"G/L Account") THEN BEGIN
                                                                IF GLAcct.GET("Account No.") THEN BEGIN
                                                                Name:=GLAcct.Name;
                                                                END;
                                                                END;
                                                                IF "Phone No."='' THEN
                                                                ERROR('Please update Phone No.');
                                                                IF "ID NO."='' THEN
                                                                ERROR('Please update ID No.');
                                                              END;

                                                   NotBlank=Yes }
    { 3   ;   ;Name                ;Text50         }
    { 4   ;   ;Amount              ;Decimal       ;NotBlank=Yes }
    { 5   ;   ;Cheque No.          ;Code50        ;OnValidate=BEGIN
                                                                {
                                                                BOSARcpt.RESET;
                                                                BOSARcpt.SETRANGE(BOSARcpt."Cheque No.","Cheque No.");
                                                                BOSARcpt.SETRANGE(BOSARcpt.Posted,TRUE);
                                                                IF BOSARcpt.FIND('-') THEN
                                                                ERROR('Cheque no already exist in a posted receipt.');
                                                                }
                                                              END;
                                                               }
    { 6   ;   ;Cheque Date         ;Date           }
    { 7   ;   ;Posted              ;Boolean       ;Editable=Yes }
    { 8   ;   ;Employer No.        ;Code20        ;TableRelation=IF (Source=CONST(Bosa)) "Bank Account".No.
                                                                 ELSE IF (Source=CONST(Fosa)) "Bank Account".No. WHERE (Account Type=FILTER(Cashier));
                                                   Editable=Yes }
    { 9   ;   ;User ID             ;Code50        ;Editable=No }
    { 10  ;   ;Allocated Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Receipt Allocation".Amount WHERE (Document No=FIELD(Transaction No.),
                                                                                                      Member No=FIELD(Account No.)));
                                                   OnValidate=BEGIN
                                                                CALCFIELDS("Un allocated Amount");
                                                                VALIDATE("Un allocated Amount");
                                                              END;

                                                   Editable=No }
    { 11  ;   ;Transaction Date    ;Date           }
    { 12  ;   ;Transaction Time    ;Time          ;Editable=No }
    { 13  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 14  ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=Member,Debtor,G/L Account,FOSA Loan,Customer,Vendor;
                                                   OptionString=Member,Debtor,G/L Account,FOSA Loan,Customer,Vendor }
    { 15  ;   ;Transaction Slip Type;Option       ;OptionCaptionML=ENU=" ,Standing Order,Direct Debit,Direct Deposit,Cash,Cheque,M-Pesa";
                                                   OptionString=[ ,Standing Order,Direct Debit,Direct Deposit,Cash,Cheque,M-Pesa] }
    { 16  ;   ;Bank Name           ;Code50         }
    { 50000;  ;Insuarance          ;Decimal       ;FieldClass=Normal }
    { 50001;  ;Un allocated Amount ;Decimal        }
    { 50002;  ;Source              ;Option        ;OptionString=[ ,Bosa,Fosa] }
    { 50003;  ;Mode of Payment     ;Option        ;OptionCaptionML=ENU=Cash,Cheque,Mpesa,Standing order,Deposit Slip;
                                                   OptionString=Cash,Cheque,Mpesa,Standing order,Deposit Slip }
    { 50004;  ;Remarks             ;Text100        }
    { 50005;  ;Code                ;Code100        }
    { 50006;  ;Type                ;Option        ;OptionString=[ ,Receipt,Payment,Imprest,Advance];
                                                   NotBlank=Yes }
    { 50007;  ;Description         ;Text50         }
    { 50008;  ;Default Grouping    ;Code20        ;Editable=No }
    { 50009;  ;Transation Remarks  ;Text50         }
    { 50010;  ;Customer Payment On Account;Boolean }
    { 50011;  ;G/L Account         ;Code20        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account".No.;
                                                   OnValidate=BEGIN
                                                                GLAcc.RESET;

                                                                IF GLAcc.GET("G/L Account") THEN
                                                                BEGIN
                                                                //IF Type=Type::Payment THEN
                                                                 //  GLAcc.TESTFIELD(GLAcc."Budget Controlled",TRUE);
                                                                IF GLAcc."Direct Posting"=FALSE THEN
                                                                  BEGIN
                                                                    ERROR('Direct Posting must be True');
                                                                  END;
                                                                END;

                                                                 {PayLine.RESET;
                                                                 PayLine.SETRANGE(PayLine.Type,Code);
                                                                 IF PayLine.FIND('-') THEN
                                                                    ERROR('This Transaction Code Is Already in Use You Cannot Delete');uncomment}
                                                              END;
                                                               }
    { 50012;  ;Blocked             ;Boolean        }
    { 50013;  ;Old receipt No      ;Code30        ;OnValidate=BEGIN
                                                                //IF xRec."Old receipt No"="Old receipt No" THEN ERROR ('OLD RECEIPT NO ALREADY EXIST');
                                                                BOSARcpt.RESET;
                                                                BOSARcpt.SETRANGE(BOSARcpt."Old receipt No","Old receipt No");
                                                                IF BOSARcpt.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                OldNo:=BOSARcpt."Old receipt No";
                                                                UNTIL BOSARcpt.NEXT=0;
                                                                IF OldNo =Rec."Old receipt No" THEN ERROR ('This old receipt No. already exists!');
                                                                END;
                                                              END;
                                                               }
    { 50014;  ;ID NO.              ;Code30         }
    { 50016;  ;Phone No.           ;Code50         }
    { 50017;  ;Loan Number         ;Code30        ;TableRelation="Loans Register"."Loan  No." WHERE (Posted=CONST(Yes),
                                                                                                     Loan Product Type=CONST(A03)) }
  }
  KEYS
  {
    {    ;Transaction No.                         ;Clustered=Yes }
    {    ;Account Type,Posted                     ;SumIndexFields=Amount }
    {    ;Code                                     }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Cust@1102760000 : Record 18;
      NoSetup@1102760002 : Record 51516258;
      NoSeriesMgt@1102760001 : Codeunit 396;
      BOSARcpt@1102760003 : Record 51516247;
      GLAcct@1102760004 : Record 15;
      Mem@1102755000 : Record 51516223;
      Vend@1102755001 : Record 23;
      GLAcc@1000 : Record 15;
      PayLine@1001 : Record 51516001;
      OldNo@1000000000 : Code[20];

    BEGIN
    END.
  }
}

