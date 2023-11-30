OBJECT table 17269 BOSA Transfer Schedule
{
  OBJECT-PROPERTIES
  {
    Date=03/01/22;
    Time=[ 4:20:01 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnModify=BEGIN
               IF "Source Account No." <> '' THEN BEGIN
               Bosa.RESET;
               IF Bosa.GET("No.") THEN BEGIN
               IF (Bosa.Posted) OR (Bosa.Approved) THEN
               ERROR('Cannot modify approved or posted batch');
               END;
               END;
             END;

    OnDelete=BEGIN
               IF "Source Account No." <> '' THEN BEGIN
               Bosa.RESET;
               IF Bosa.GET("No.") THEN BEGIN
               IF (Bosa.Posted) OR (Bosa.Approved) THEN
               ERROR('Cannot delete approved or posted batch');
               END;
               END;
             END;

    OnRename=BEGIN
               Bosa.RESET;
               IF Bosa.GET("No.") THEN BEGIN
               IF (Bosa.Posted) OR (Bosa.Approved) THEN
               ERROR('Cannot rename approved or posted batch');
               END;
             END;

  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code10         }
    { 2   ;   ;Source Account No.  ;Code20        ;TableRelation=IF (Source Type=FILTER(Customer)) Customer.No.
                                                                 ELSE IF (Source Type=FILTER(Vendor)) Vendor.No.
                                                                 ELSE IF (Source Type=FILTER(Bank)) "Bank Account".No.
                                                                 ELSE IF (Source Type=FILTER(G/L ACCOUNT)) "G/L Account".No.
                                                                 ELSE IF (Source Type=FILTER(MEMBER)) "Members Register".No.;
                                                   OnValidate=BEGIN
                                                                IF "Source Type"="Source Type"::Customer THEN BEGIN
                                                                Cust.RESET;
                                                                IF Cust.GET("Source Account No.") THEN BEGIN
                                                                "Source Account Name":=Cust.Name;
                                                                "Destination Account Type":="Destination Account Type"::FOSA;
                                                                //"Destination Account No.":=Cust."FOSA Account";
                                                                VALIDATE("Destination Account No.");
                                                                END;
                                                                END;

                                                                IF "Source Type"="Source Type":: Bank THEN BEGIN
                                                                Bank.RESET;
                                                                IF Bank.GET("Source Account No.") THEN BEGIN
                                                                "Source Account Name":=Bank.Name;
                                                                END;
                                                                END;

                                                                IF "Source Type"="Source Type"::Vendor THEN BEGIN
                                                                Vend.RESET;
                                                                IF Vend.GET("Source Account No.") THEN BEGIN
                                                                "Source Account Name":=Vend.Name;
                                                                END;
                                                                END;

                                                                IF "Source Type"="Source Type"::MEMBER THEN BEGIN
                                                                memb.RESET;
                                                                IF memb.GET("Source Account No.") THEN BEGIN
                                                                "Source Account Name":=memb.Name;
                                                                END;
                                                                END;


                                                                IF "Source Type"="Source Type"::"G/L ACCOUNT" THEN BEGIN
                                                                "G/L".RESET;
                                                                IF "G/L".GET("Source Account No.") THEN BEGIN
                                                                "Source Account Name":="G/L".Name;
                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 3   ;   ;Source Account Name ;Text100        }
    { 4   ;   ;Destination Account Type;Option    ;OnValidate=BEGIN
                                                                {IF "Destination Account Type"="Destination Account Type"::BANK THEN BEGIN
                                                                "Destination Account No.":='5-02-09276-01';
                                                                VALIDATE("Destination Account No.");
                                                                END;
                                                                   }
                                                              END;

                                                   OptionCaptionML=ENU=FOSA,BANK,bosa,G/L ACCOUNT,MEMBER,CUSTOMER;
                                                   OptionString=FOSA,BANK,bosa,G/L ACCOUNT,MEMBER,CUSTOMER }
    { 5   ;   ;Destination Account No.;Code20     ;TableRelation=IF (Destination Account Type=CONST(FOSA)) Vendor.No.
                                                                 ELSE IF (Destination Account Type=CONST(BANK)) "Bank Account".No.
                                                                 ELSE IF (Destination Account Type=CONST(G/L ACCOUNT)) "G/L Account".No.
                                                                 ELSE IF (Destination Account Type=CONST(MEMBER)) "Members Register".No.
                                                                 ELSE IF (Destination Account Type=CONST(CUSTOMER)) Customer.No.;
                                                   OnValidate=BEGIN
                                                                IF "Destination Account Type" = "Destination Account Type"::FOSA THEN BEGIN
                                                                Vend.RESET;
                                                                IF Vend.GET("Destination Account No.") THEN
                                                                "Destination Account Name":=Vend.Name;
                                                                END ELSE
                                                                IF "Destination Account Type" = "Destination Account Type"::CUSTOMER THEN BEGIN
                                                                Cust.RESET;
                                                                IF Cust.GET("Destination Account No.") THEN
                                                                "Destination Account Name":=Cust.Name;
                                                                END;

                                                                IF "Destination Account Type"="Destination Account Type"::"G/L ACCOUNT" THEN BEGIN
                                                                "G/L".RESET;
                                                                IF "G/L".GET("Destination Account No.") THEN BEGIN
                                                                "Destination Account Name":="G/L".Name;
                                                                END;
                                                                END;

                                                                IF "Destination Account Type"="Destination Account Type"::MEMBER THEN BEGIN
                                                                memb.RESET;
                                                                IF memb.GET("Destination Account No.") THEN BEGIN
                                                                "Destination Account Name":=memb.Name;
                                                                END;
                                                                END;
                                                                IF "Destination Account Type"="Destination Account Type"::BANK THEN BEGIN
                                                                Bank.RESET;
                                                                IF Bank.GET("Destination Account No.") THEN BEGIN
                                                                "Destination Account Name":=Bank.Name;
                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 6   ;   ;Amount              ;Decimal        }
    { 7   ;   ;Source Type         ;Option        ;OptionCaptionML=ENU=Customer,Vendor,Bank,G/L ACCOUNT,MEMBER;
                                                   OptionString=Customer,Vendor,Bank,G/L ACCOUNT,MEMBER }
    { 8   ;   ;Destination Account Name;Text100    }
    { 9   ;   ;Destination Bank No.;Code20         }
    { 10  ;   ;Destination Bank Name;Text30        }
    { 11  ;   ;Transaction Type    ;Option        ;OnValidate=BEGIN
                                                                IF "Transaction Type"="Transaction Type"::"Registration Fee" THEN
                                                                   Description:='Registration Fee';
                                                                 IF "Transaction Type"="Transaction Type"::Loan THEN
                                                                   Description:='Loan';
                                                                 IF "Transaction Type"="Transaction Type"::Repayment THEN
                                                                   Description:='Loan Repayment';
                                                                 IF "Transaction Type"="Transaction Type"::Withdrawal THEN
                                                                   Description:='Withdrawal';
                                                                 IF "Transaction Type"="Transaction Type"::"Interest Due" THEN
                                                                   Description:='Interest Due';
                                                                 IF "Transaction Type"="Transaction Type"::"Interest Paid" THEN
                                                                   Description:='Interest Paid';
                                                                 IF "Transaction Type"="Transaction Type"::"Benevolent Fund" THEN
                                                                   Description:='ABF Fund';
                                                                 IF "Transaction Type"="Transaction Type"::"Deposit Contribution" THEN
                                                                   Description:='Shares Contribution';
                                                                 IF "Transaction Type"="Transaction Type"::"Appraisal Fee" THEN
                                                                   Description:='Appraisal Fee';
                                                                 IF "Transaction Type"="Transaction Type"::"Application Fee" THEN
                                                                   Description:='Application Fee';
                                                                 IF "Transaction Type"="Transaction Type"::"Unallocated Funds" THEN
                                                                   Description:='Unallocated Funds';
                                                              END;

                                                   OptionCaptionML=ENU=" ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated";
                                                   OptionString=[ ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated] }
    { 12  ;   ;Loan                ;Code30        ;TableRelation=IF (Source Type=CONST(Customer)) "Loans Register"."Loan  No." WHERE (Client Code=FIELD(Source Account No.))
                                                                 ELSE IF (Destination Account Type=CONST(bosa)) "Loans Register"."Loan  No." WHERE (Client Code=FIELD(Destination Account No.))
                                                                 ELSE IF (Destination Account Type=CONST(MEMBER)) "Loans Register"."Loan  No." WHERE (Client Code=FIELD(Destination Account No.))
                                                                 ELSE IF (Source Type=CONST(MEMBER)) "Loans Register"."Loan  No." WHERE (Client Code=FIELD(Source Account No.)) }
    { 13  ;   ;Destination Loan    ;Code30        ;TableRelation=IF (Destination Account Type=CONST(bosa)) "Loans Register"."Loan  No." WHERE (Client Code=FIELD(Destination Account No.))
                                                                 ELSE IF (Destination Account Type=CONST(bosa)) "Loans Register"."Loan  No." WHERE (Client Code=FIELD(Destination Account No.))
                                                                 ELSE IF (Destination Account Type=CONST(MEMBER)) "Loans Register"."Loan  No." WHERE (Client Code=FIELD(Destination Account No.)) }
    { 14  ;   ;Description         ;Text100        }
    { 15  ;   ;Destination Type    ;Option        ;OptionCaptionML=ENU=" ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated";
                                                   OptionString=[ ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated] }
    { 18  ;   ;Basic Pay           ;Decimal        }
    { 25  ;   ;Bank Branch         ;Code50         }
    { 26  ;   ;Employee's Bank     ;Code50         }
    { 27  ;   ;Posting Group       ;Code20        ;TableRelation=Employee;
                                                   NotBlank=No }
    { 28  ;   ;Cumm Employer Pension;Decimal       }
    { 29  ;   ;Pays Pension        ;Boolean        }
    { 30  ;   ;Gratuity %          ;Code20         }
    { 31  ;   ;Gratuity Amount     ;Decimal        }
    { 32  ;   ;Gratuity            ;Integer        }
    { 33  ;   ;Fosa Accounts       ;Code50        ;TableRelation=Vendor.No. }
    { 34  ;   ;Sacco Paying Bank   ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("HR Employees"."Sacco Paying Bank Code" WHERE (No.=FIELD(Employee Code))) }
    { 35  ;   ;Cheque No           ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("HR Employees"."Cheque No" WHERE (No.=FIELD(Employee Code))) }
    { 100 ;   ;Employee Code       ;Code20        ;TableRelation="HR Employees".No. }
    { 111 ;   ;Cumm NetPay         ;Decimal       ;Editable=No }
    { 121 ;   ;Cumm Allowances     ;Decimal       ;Editable=No }
    { 131 ;   ;Cumm Deductions     ;Decimal       ;Editable=No }
    { 141 ;   ;Suspend Pay         ;Boolean        }
    { 150 ;   ;Cumm GrossPay       ;Decimal       ;Editable=No }
    { 151 ;   ;Suspension Date     ;Date           }
    { 161 ;   ;Suspension Reasons  ;Text200        }
    { 171 ;   ;Period Filter       ;Date          ;FieldClass=FlowFilter;
                                                   TableRelation="prPayroll Periods"."Date Opened" }
    { 181 ;   ;Exists              ;Boolean        }
    { 191 ;   ;Cumm PAYE           ;Decimal        }
    { 201 ;   ;Cumm NSSF           ;Decimal        }
    { 211 ;   ;Cumm Pension        ;Decimal        }
    { 221 ;   ;Cumm HELB           ;Decimal        }
    { 231 ;   ;Cumm NHIF           ;Decimal        }
    { 241 ;   ;Bank Account Number ;Code50         }
    { 300 ;   ;Payment Mode        ;Option        ;OptionString=[ ,Bank Transfer,Cheque,Cash,FOSA];
                                                   Description=Bank Transfer,Cheque,Cash,SACCO }
    { 400 ;   ;Currency            ;Code20        ;TableRelation=Table39003987.Field1 }
    { 500 ;   ;Pays NSSF           ;Boolean       ;OnValidate=BEGIN
                                                                {objPeriod.RESET;
                                                                objPeriod.SETRANGE(objPeriod.Closed,FALSE);
                                                                IF objPeriod.FIND('-') THEN;
                                                                SelectedPeriod:=objPeriod."Date Opened";

                                                                //  IF "Basic Pay"<>xRec."Basic Pay" THEN BEGIN
                                                                  IF "Pays NSSF"=FALSE THEN BEGIN
                                                                  prTrans.RESET;
                                                                  prTrans.SETRANGE(prTrans."coop parameters",prTrans."coop parameters"::Pension);
                                                                  IF prTrans.FIND('-') THEN BEGIN
                                                                  prEmpTran.RESET;
                                                                  prEmpTran.SETRANGE(prEmpTran."Employee Code","Employee Code");
                                                                  prEmpTran.SETRANGE(prEmpTran."Transaction Code",prTrans."Transaction Code");
                                                                  prEmpTran.SETRANGE(prEmpTran."Payroll Period",SelectedPeriod);
                                                                  IF NOT prEmpTran.FIND('-') THEN BEGIN
                                                                  prEmpTran2.INIT;
                                                                  prEmpTran2."Employee Code":="Employee Code";
                                                                  prEmpTran2."Transaction Code":=prTrans."Transaction Code";
                                                                  prEmpTran2."Period Month":=objPeriod."Period Month";
                                                                  prEmpTran2."Period Year":=objPeriod."Period Year";
                                                                  prEmpTran2."Payroll Period":=objPeriod."Date Opened";
                                                                  prEmpTran2."Transaction Name":=prTrans."Transaction Name";
                                                                  prEmpTran2.Amount:="Basic Pay"*(10/100);
                                                                  prEmpTran2.INSERT;
                                                                  END;
                                                                  END;
                                                                  END;
                                                                  }
                                                              END;
                                                               }
    { 600 ;   ;Pays NHIF           ;Boolean        }
    { 700 ;   ;Pays PAYE           ;Boolean        }
    { 800 ;   ;Payslip Message     ;Text100        }
    { 900 ;   ;Cumm BasicPay       ;Decimal       ;Editable=No }
    { 901 ;   ;Type of Transfer    ;Option        ;OptionCaptionML=ENU=, ,Bosa Deposit Refunds,ESS Refund,Erroneous Deduction Refund,BOSA Deposit Transfer;
                                                   OptionString=, ,Bosa Deposit Refunds,ESS Refund,Erroneous Deduction Refund,BOSA Deposit Transfer }
  }
  KEYS
  {
    {    ;No.,Source Account No.,Destination Bank No.,Transaction Type,Loan,Destination Account No.,Amount;
                                                   SumIndexFields=Amount;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Cust@1102760000 : Record 18;
      Vend@1102760001 : Record 23;
      Bank@1102760002 : Record 270;
      Bosa@1102760003 : Record 51516264;
      "G/L"@1102755000 : Record 15;
      memb@1102755001 : Record 51516223;

    BEGIN
    END.
  }
}

