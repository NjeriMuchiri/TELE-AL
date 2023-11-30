OBJECT table 17343 Member Monthly Contributions
{
  OBJECT-PROPERTIES
  {
    Date=08/01/16;
    Time=[ 9:00:42 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    LookupPageID=Page51516379;
    DrillDownPageID=Page51516379;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;TableRelation="Members Register" }
    { 2   ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                IF Type = Type::"Registration Fee" THEN BEGIN
                                                                Descripition:='Registration Fee';
                                                                "Check Off Priority":=1;
                                                                END ELSE
                                                                IF Type = Type::Loan THEN BEGIN
                                                                Descripition:='Loan Repayment';

                                                                END ELSE
                                                                IF Type = Type::"Benevolent Fund" THEN BEGIN
                                                                Descripition:='BBF';
                                                                END ELSE
                                                                IF Type = Type::"Interest Due" THEN BEGIN
                                                                Descripition:='Interest Due';
                                                                END ELSE
                                                                IF Type = Type::"Interest Paid" THEN BEGIN
                                                                Descripition:='Interest Paid';
                                                                END ELSE
                                                                IF Type = Type::"FOSA Account" THEN BEGIN
                                                                Descripition:='Interest Paid';
                                                                END ELSE
                                                                IF Type = Type::"Deposit Contribution" THEN BEGIN
                                                                Descripition:='Deposit Contribution';
                                                                END;
                                                              END;

                                                   OptionCaptionML=ENU=" ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Holiday_Savers,Penalty Paid,Dev Shares,Fanikisha,Welfare Contribution 2,Loan Penalty,Loan Guard,Gpange,Junior,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement";
                                                   OptionString=[ ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Holiday_Savers,Penalty Paid,Dev Shares,Fanikisha,Welfare Contribution 2,Loan Penalty,Loan Guard,Gpange,Junior,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge ,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement] }
    { 3   ;   ;Amount ON           ;Decimal       ;OnValidate=BEGIN
                                                                      "Last Advice Date":=TODAY;


                                                                      Customer.RESET;
                                                                      Customer.SETRANGE(Customer."No.","No.");
                                                                      IF Customer.FIND('-') THEN BEGIN
                                                                      LoanApps.RESET;
                                                                      LoanApps.SETRANGE(LoanApps."Loan  No.","Loan No");
                                                                      IF LoanApps.FIND('-') THEN BEGIN
                                                                      IF LoanTypes.GET(LoanApps."Loan Product Type") THEN BEGIN
                                                                    //IF Customer.GET(LoanApps."Client Code") THEN BEGIN
                                                                    //Loans."Staff No":=Customer."Payroll/Staff No";
                                                                    IF (Type=Type::Loan) OR (Type=Type::Repayment) THEN BEGIN
                                                                    DataSheet.RESET;
                                                                    DataSheet.SETRANGE(DataSheet."PF/Staff No",Customer."Payroll/Staff No");
                                                                    //DataSheet.SETRANGE(DataSheet."Type of Deduction",'SLOAN');
                                                                    DataSheet.SETRANGE(DataSheet."Remark/LoanNO",LoanApps."Loan  No.");
                                                                    DataSheet.SETRANGE( DataSheet."ID NO.",Customer."ID No.");
                                                                        IF DataSheet.FIND('-') THEN BEGIN
                                                                    DataSheet.DELETE;
                                                                          END;
                                                                           DataSheet.RESET;
                                                                    DataSheet.SETRANGE(DataSheet."PF/Staff No",Customer."Payroll/Staff No");
                                                                    //DataSheet.SETRANGE(DataSheet."Type of Deduction",'SLOAN');
                                                                    DataSheet.SETRANGE(DataSheet."Remark/LoanNO",LoanApps."Loan  No.");
                                                                    DataSheet.SETRANGE( DataSheet."ID NO.",Customer."ID No.");
                                                                        IF DataSheet.FIND('-') THEN BEGIN

                                                                    DataSheet."PF/Staff No":=Customer."Payroll/Staff No";
                                                                    DataSheet."Type of Deduction":=LoanTypes."Product Description";
                                                                    DataSheet."Remark/LoanNO":=LoanApps."Loan  No.";
                                                                    DataSheet.Name:=Customer.Name;
                                                                    DataSheet."ID NO.":=Customer."ID No.";
                                                                    DataSheet."Principal Amount":=LoanApps."Loan Principle Repayment";
                                                                    DataSheet."Interest Amount":=LoanApps."Loan Interest Repayment";
                                                                    DataSheet."Amount ON":="Amount ON";
                                                                    //ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');
                                                                    DataSheet."REF.":='2026';
                                                                    //DataSheet."Batch No.":="Batch No.";
                                                                    CALCFIELDS(Balance);
                                                                    DataSheet."New Balance":=Balance;
                                                                    MESSAGE('%1',Balance);
                                                                     MESSAGE('%1',Customer."Payroll/Staff No");

                                                                    DataSheet."Repayment Method":=Customer."Repayment Method";
                                                                    DataSheet.Date:=TODAY;
                                                                    DataSheet."Amount OFF":="Amount Off";
                                                                    //IF Customer.GET(LoanApps."Client Code") THEN BEGIN
                                                                    DataSheet.Employer:=Customer."Employer Code";
                                                                    //END;
                                                                    //DataSheet."Sort Code":=PTEN;
                                                                      DataSheet.MODIFY();
                                                                    END ELSE BEGIN
                                                                    DataSheet.INIT;
                                                                    DataSheet."PF/Staff No":=Customer."Payroll/Staff No";
                                                                    DataSheet."Type of Deduction":=LoanTypes."Product Description";
                                                                    DataSheet."Remark/LoanNO":=LoanApps."Loan  No.";
                                                                    DataSheet.Name:=Customer.Name;
                                                                    DataSheet."ID NO.":=Customer."ID No.";
                                                                    DataSheet."Principal Amount":=LoanApps."Loan Principle Repayment";
                                                                    DataSheet."Interest Amount":=LoanApps."Loan Interest Repayment";
                                                                    DataSheet."Amount ON":="Amount ON";
                                                                    //ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');
                                                                    DataSheet."REF.":='2026';
                                                                    //DataSheet."Batch No.":="Batch No.";
                                                                    DataSheet."New Balance":=Balance;
                                                                    MESSAGE('%1',Balance);
                                                                     MESSAGE('%1',Customer."Payroll/Staff No");

                                                                    DataSheet."New Balance":=Balance;

                                                                    DataSheet."Repayment Method":=Customer."Repayment Method";
                                                                    DataSheet.Date:=TODAY;
                                                                    DataSheet."Amount OFF":="Amount Off";
                                                                    //IF Customer.GET(LoanApps."Client Code") THEN BEGIN
                                                                    DataSheet.Employer:=Customer."Employer Code";
                                                                    //DataSheet."Sort Code":=PTEN;
                                                                    DataSheet.INSERT(TRUE);
                                                                    DataSheet.MODIFY;
                                                                    END;
                                                                    END;
                                                                    //END;
                                                                    IF (Type=Type::"Interest Paid")  THEN BEGIN
                                                                    DataSheet.RESET;
                                                                    DataSheet.SETRANGE(DataSheet."PF/Staff No",LoanApps."Staff No");
                                                                   DataSheet.SETRANGE(DataSheet."Type of Deduction",'SINTEREST');
                                                                    DataSheet.SETRANGE(DataSheet."Remark/LoanNO",LoanApps."Loan  No.");
                                                                    IF DataSheet.FIND('-') THEN BEGIN
                                                                      DataSheet.DELETE;
                                                                      END;
                                                                      DataSheet.RESET;
                                                                    DataSheet.SETRANGE(DataSheet."PF/Staff No",LoanApps."Staff No");
                                                                   DataSheet.SETRANGE(DataSheet."Type of Deduction",'SINTEREST');
                                                                    DataSheet.SETRANGE(DataSheet."Remark/LoanNO",LoanApps."Loan  No.");
                                                                    IF DataSheet.FIND('-') THEN BEGIN
                                                                    //DataSheet.INIT;
                                                                    DataSheet."PF/Staff No":=Customer."Payroll/Staff No";
                                                                    DataSheet."Type of Deduction":='SINTEREST';
                                                                    DataSheet."Remark/LoanNO":=LoanApps."Loan  No.";
                                                                    DataSheet.Name:=Customer.Name;
                                                                    DataSheet."ID NO.":=Customer."ID No.";
                                                                    DataSheet."Principal Amount":=LoanApps."Loan Principle Repayment";
                                                                    DataSheet."Interest Amount":=LoanApps."Loan Interest Repayment";
                                                                    DataSheet."Amount ON":="Amount ON";
                                                                    //ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');
                                                                    DataSheet."REF.":='2026';
                                                                    //DataSheet."Batch No.":="Batch No.";
                                                                    DataSheet."New Balance":=Balance;
                                                                    DataSheet."Repayment Method":=Customer."Repayment Method";
                                                                    DataSheet.Date:=TODAY;
                                                                    DataSheet."Amount OFF":="Amount Off";
                                                                    //IF Customer.GET(LoanApps."Client Code") THEN BEGIN
                                                                    DataSheet.Employer:=Customer."Employer Code";
                                                                    //DataSheet."Sort Code":=PTEN;
                                                                    DataSheet.MODIFY;
                                                                    END ELSE BEGIN
                                                                    DataSheet.INIT;
                                                                    DataSheet."PF/Staff No":=Customer."Payroll/Staff No";
                                                                    DataSheet."Type of Deduction":='SINTEREST';
                                                                    DataSheet."Remark/LoanNO":=LoanApps."Loan  No.";
                                                                    DataSheet.Name:=Customer.Name;
                                                                    DataSheet."ID NO.":=Customer."ID No.";
                                                                    DataSheet."Principal Amount":=LoanApps."Loan Principle Repayment";
                                                                    DataSheet."Interest Amount":=LoanApps."Loan Interest Repayment";
                                                                    DataSheet."Amount ON":="Amount ON";
                                                                    DataSheet."Amount OFF":="Amount Off";
                                                                    //ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');
                                                                    DataSheet."REF.":='2026';
                                                                    //DataSheet."Batch No.":="Batch No.";
                                                                    DataSheet."New Balance":=Balance;
                                                                    DataSheet."Repayment Method":=Customer."Repayment Method";
                                                                    DataSheet.Date:=TODAY;
                                                                    //IF Customer.GET(LoanApps."Client Code") THEN BEGIN
                                                                    DataSheet.Employer:=Customer."Employer Code";
                                                                    //DataSheet."Sort Code":=PTEN;
                                                                    DataSheet.INSERT(TRUE);
                                                                    END;
                                                                    END;
                                                                    END;
                                                                    END
                                                                    END;
                                                                    IF Type=Type::"Deposit Contribution" THEN BEGIN
                                                                      //"Previous Share Contribution":=xRec."Monthly Contribution";


                                                                Customer.RESET;
                                                                Customer.SETRANGE(Customer."No.","No.");
                                                                IF Customer.FIND('-') THEN BEGIN
                                                                    DataSheet.RESET;
                                                                    DataSheet.SETRANGE(DataSheet."PF/Staff No",Customer."Payroll/Staff No");
                                                                    DataSheet.SETRANGE(DataSheet."Type of Deduction",'SSHARE');
                                                                    DataSheet.SETRANGE(DataSheet."Remark/LoanNO",'ADJ FORM');
                                                                    IF DataSheet.FIND('-') THEN BEGIN
                                                                      DataSheet.DELETE;
                                                                      END;
                                                                    DataSheet.RESET;
                                                                    DataSheet.SETRANGE(DataSheet."PF/Staff No",Customer."Payroll/Staff No");
                                                                    DataSheet.SETRANGE(DataSheet."Type of Deduction",'SSHARE');
                                                                    DataSheet.SETRANGE(DataSheet."Remark/LoanNO",'ADJ FORM');
                                                                    IF DataSheet.FIND('-') THEN BEGIN
                                                                    Customer.Advice:=TRUE;
                                                                //"Advice Type":="Advice Type"::Adjustment;

                                                                            CALCFIELDS(Balance);
                                                                        //DataSheet.INIT;
                                                                        DataSheet."PF/Staff No":=Customer."Payroll/Staff No";
                                                                        DataSheet."Type of Deduction":='SSHARE';
                                                                        DataSheet."Remark/LoanNO":='ADJ FORM';
                                                                        DataSheet.Name:=Customer.Name;
                                                                        DataSheet."ID NO.":=Customer."ID No.";
                                                                        DataSheet."Amount ON":="Amount ON";
                                                                        DataSheet."REF.":='2026';
                                                                        DataSheet."New Balance":=Balance;
                                                                        DataSheet.Date:=TODAY;
                                                                        DataSheet."Amount OFF":="Amount Off";
                                                                        DataSheet.Employer:=Customer."Employer Code";
                                                                        DataSheet."Transaction Type":=DataSheet."Transaction Type"::VARIATION;
                                                                        //DataSheet."Sort Code":=PTEN;
                                                                        DataSheet.MODIFY;
                                                                    END ELSE BEGIN
                                                                Customer.Advice:=TRUE;
                                                                //"Advice Type":="Advice Type"::Adjustment;

                                                                CALCFIELDS(Balance);
                                                                DataSheet.INIT;
                                                                DataSheet."PF/Staff No":=Customer."Payroll/Staff No";
                                                                DataSheet."Type of Deduction":='SSHARE';
                                                                DataSheet."Remark/LoanNO":='ADJ FORM';
                                                                DataSheet.Name:=Customer.Name;
                                                                DataSheet."ID NO.":=Customer."ID No.";
                                                                DataSheet."Amount ON":="Amount ON";
                                                                DataSheet."REF.":='2026';
                                                                DataSheet."New Balance":=Balance;
                                                                DataSheet.Date:=TODAY;
                                                                DataSheet."Amount OFF":="Amount Off";
                                                                DataSheet.Employer:=Customer."Employer Code";
                                                                DataSheet."Transaction Type":=DataSheet."Transaction Type"::EFFECT;
                                                                //DataSheet."Sort Code":=PTEN;
                                                                DataSheet.INSERT;
                                                                      END;
                                                                      END;
                                                                      END;

                                                                IF Type=Type::"FOSA Account" THEN BEGIN
                                                                      //"Previous Share Contribution":=xRec."Monthly Contribution";


                                                                Customer.RESET;
                                                                Customer.SETRANGE(Customer."No.","No.");
                                                                IF Customer.FIND('-') THEN BEGIN
                                                                    DataSheet.RESET;
                                                                    DataSheet.SETRANGE(DataSheet."PF/Staff No",Customer."Payroll/Staff No");
                                                                    DataSheet.SETRANGE(DataSheet."Type of Deduction",'WCONT');
                                                                    DataSheet.SETRANGE(DataSheet."Remark/LoanNO",'ADJ FORM');
                                                                    IF DataSheet.FIND('-') THEN BEGIN
                                                                      DataSheet.DELETE;
                                                                      END;
                                                                      DataSheet.RESET;
                                                                    DataSheet.SETRANGE(DataSheet."PF/Staff No",Customer."Payroll/Staff No");
                                                                    DataSheet.SETRANGE(DataSheet."Type of Deduction",'WCONT');
                                                                    DataSheet.SETRANGE(DataSheet."Remark/LoanNO",'ADJ FORM');
                                                                    IF DataSheet.FIND('-') THEN BEGIN
                                                                    Customer.Advice:=TRUE;
                                                                //"Advice Type":="Advice Type"::Adjustment;

                                                                            CALCFIELDS(Balance);
                                                                        //DataSheet.INIT;
                                                                        DataSheet."PF/Staff No":=Customer."Payroll/Staff No";
                                                                        DataSheet."Type of Deduction":='WCONT';
                                                                        DataSheet."Remark/LoanNO":='ADJ FORM';
                                                                        DataSheet.Name:=Customer.Name;
                                                                        DataSheet."ID NO.":=Customer."ID No.";
                                                                        DataSheet."Amount ON":="Amount ON";
                                                                        DataSheet."REF.":='2026';
                                                                        DataSheet."New Balance":=Balance;
                                                                        DataSheet.Date:=TODAY;
                                                                        DataSheet."Amount OFF":="Amount Off";
                                                                        DataSheet.Employer:=Customer."Employer Code";
                                                                        DataSheet."Transaction Type":=DataSheet."Transaction Type"::VARIATION;
                                                                        //DataSheet."Sort Code":=PTEN;
                                                                        DataSheet.MODIFY;
                                                                    END ELSE BEGIN
                                                                Customer.Advice:=TRUE;
                                                                //"Advice Type":="Advice Type"::Adjustment;

                                                                CALCFIELDS(Balance);
                                                                DataSheet.INIT;
                                                                DataSheet."PF/Staff No":=Customer."Payroll/Staff No";
                                                                DataSheet."Type of Deduction":='WCONT';
                                                                DataSheet."Remark/LoanNO":='ADJ FORM';
                                                                DataSheet.Name:=Customer.Name;
                                                                DataSheet."ID NO.":=Customer."ID No.";
                                                                DataSheet."Amount ON":="Amount ON";
                                                                DataSheet."REF.":='2026';
                                                                DataSheet."New Balance":=Balance;
                                                                DataSheet.Date:=TODAY;
                                                                DataSheet."Amount OFF":="Amount Off";
                                                                DataSheet.Employer:=Customer."Employer Code";
                                                                DataSheet."Transaction Type":=DataSheet."Transaction Type"::EFFECT;
                                                                //DataSheet."Sort Code":=PTEN;
                                                                DataSheet.INSERT;
                                                                      END;
                                                                      END;
                                                                      END;
                                                                      IF Type=Type::"Benevolent Fund" THEN BEGIN
                                                                      //"Previous Share Contribution":=xRec."Monthly Contribution";


                                                                Customer.RESET;
                                                                Customer.SETRANGE(Customer."No.","No.");
                                                                IF Customer.FIND('-') THEN BEGIN
                                                                    DataSheet.RESET;
                                                                    DataSheet.SETRANGE(DataSheet."PF/Staff No",Customer."Payroll/Staff No");
                                                                    DataSheet.SETRANGE(DataSheet."Type of Deduction",'BBF');
                                                                    DataSheet.SETRANGE(DataSheet."Remark/LoanNO",'ADJ FORM');
                                                                    IF DataSheet.FIND('-') THEN BEGIN
                                                                      DataSheet.DELETE;
                                                                      END;
                                                                      DataSheet.RESET;
                                                                    DataSheet.SETRANGE(DataSheet."PF/Staff No",Customer."Payroll/Staff No");
                                                                    DataSheet.SETRANGE(DataSheet."Type of Deduction",'BBF');
                                                                    DataSheet.SETRANGE(DataSheet."Remark/LoanNO",'ADJ FORM');
                                                                    IF DataSheet.FIND('-') THEN BEGIN
                                                                    Customer.Advice:=TRUE;
                                                                //"Advice Type":="Advice Type"::Adjustment;

                                                                            CALCFIELDS(Balance);
                                                                        //DataSheet.INIT;
                                                                        DataSheet."PF/Staff No":=Customer."Payroll/Staff No";
                                                                        DataSheet."Type of Deduction":='BBF';
                                                                        DataSheet."Remark/LoanNO":='ADJ FORM';
                                                                        DataSheet.Name:=Customer.Name;
                                                                        DataSheet."ID NO.":=Customer."ID No.";
                                                                        DataSheet."Amount ON":="Amount ON";
                                                                        DataSheet."REF.":='2026';
                                                                        DataSheet."New Balance":=Balance;
                                                                        DataSheet.Date:=TODAY;
                                                                        DataSheet."Amount OFF":="Amount Off";
                                                                        DataSheet.Employer:=Customer."Employer Code";
                                                                        DataSheet."Transaction Type":=DataSheet."Transaction Type"::VARIATION;
                                                                        //DataSheet."Sort Code":=PTEN;
                                                                        DataSheet.MODIFY;
                                                                    END ELSE BEGIN
                                                                Customer.Advice:=TRUE;
                                                                //"Advice Type":="Advice Type"::Adjustment;

                                                                CALCFIELDS(Balance);
                                                                DataSheet.INIT;
                                                                DataSheet."PF/Staff No":=Customer."Payroll/Staff No";
                                                                DataSheet."Type of Deduction":='BBF';
                                                                DataSheet."Remark/LoanNO":='ADJ FORM';
                                                                DataSheet.Name:=Customer.Name;
                                                                DataSheet."ID NO.":=Customer."ID No.";
                                                                DataSheet."Amount ON":="Amount ON";
                                                                DataSheet."REF.":='2026';
                                                                DataSheet."New Balance":=Balance;
                                                                DataSheet.Date:=TODAY;
                                                                DataSheet."Amount OFF":="Amount Off";
                                                                DataSheet.Employer:=Customer."Employer Code";
                                                                DataSheet."Transaction Type":=DataSheet."Transaction Type"::EFFECT;
                                                                //DataSheet."Sort Code":=PTEN;
                                                                DataSheet.INSERT;
                                                                      END;
                                                                      END;
                                                                      END;
                                                              END;
                                                               }
    { 5   ;   ;Descripition        ;Text50         }
    { 10  ;   ;Last Advice Date    ;Date          ;Editable=No }
    { 11  ;   ;Check Off Priority  ;Integer        }
    { 12  ;   ;Type Code           ;Code10         }
    { 13  ;   ;Balance             ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Transaction Type=FIELD(Type),
                                                                                                        Customer No.=FIELD(No.))) }
    { 14  ;   ;Staffno             ;Code10        ;OnValidate=BEGIN

                                                                CustomerRecord.RESET;
                                                                CustomerRecord.SETRANGE(CustomerRecord."Payroll/Staff No",Staffno);
                                                                IF CustomerRecord.FIND('-') THEN BEGIN
                                                                "No.":=CustomerRecord."No.";
                                                                VALIDATE("No.");
                                                                END
                                                              END;
                                                               }
    { 15  ;   ;Loan No             ;Code20        ;TableRelation="Loans Register"."Loan  No." WHERE (Client Code=FIELD(No.)) }
    { 16  ;   ;Amount Off          ;Decimal        }
    { 17  ;   ;Balance 2           ;Decimal        }
  }
  KEYS
  {
    {    ;No.,Type                                ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Ledger@1000 : Integer;
      CustomerRecord@1001 : Record 51516223;
      LoanTypes@1000000000 : Record 51516240;
      Customer@1000000001 : Record 51516223;
      LoanApps@1000000002 : Record 51516230;
      DataSheet@1000000003 : Record 51516341;

    BEGIN
    END.
  }
}

