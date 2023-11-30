OBJECT table 20395 prSalary Card
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=[ 2:36:16 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnDelete=BEGIN
               ERROR('Delete not allowed');
             END;

  }
  FIELDS
  {
    { 1   ;   ;Employee Code       ;Code20        ;TableRelation="HR Employees".No. }
    { 2   ;   ;Basic Pay           ;Decimal       ;OnValidate=BEGIN
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
                                                                  IF prEmpTran.FIND('-') THEN BEGIN
                                                                  prEmpTran.Amount:="Basic Pay"*(10/100);
                                                                  prEmpTran.MODIFY;
                                                                  END;
                                                                  END;
                                                                  END;
                                                                 }
                                                              END;
                                                               }
    { 3   ;   ;Payment Mode        ;Option        ;OptionString=[ ,Bank Transfer,Cheque,Cash,FOSA];
                                                   Description=Bank Transfer,Cheque,Cash,SACCO }
    { 4   ;   ;Currency            ;Code20        ;TableRelation=Table39003987.Field1 }
    { 5   ;   ;Pays NSSF           ;Boolean       ;OnValidate=BEGIN
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
    { 6   ;   ;Pays NHIF           ;Boolean        }
    { 7   ;   ;Pays PAYE           ;Boolean        }
    { 8   ;   ;Payslip Message     ;Text100        }
    { 9   ;   ;Cumm BasicPay       ;Decimal       ;Editable=No }
    { 10  ;   ;Cumm GrossPay       ;Decimal       ;Editable=No }
    { 11  ;   ;Cumm NetPay         ;Decimal       ;Editable=No }
    { 12  ;   ;Cumm Allowances     ;Decimal       ;Editable=No }
    { 13  ;   ;Cumm Deductions     ;Decimal       ;Editable=No }
    { 14  ;   ;Suspend Pay         ;Boolean        }
    { 15  ;   ;Suspension Date     ;Date           }
    { 16  ;   ;Suspension Reasons  ;Text200        }
    { 17  ;   ;Period Filter       ;Date          ;FieldClass=FlowFilter;
                                                   TableRelation="prPayroll Periods"."Date Opened" }
    { 18  ;   ;Exists              ;Boolean        }
    { 19  ;   ;Cumm PAYE           ;Decimal        }
    { 20  ;   ;Cumm NSSF           ;Decimal        }
    { 21  ;   ;Cumm Pension        ;Decimal        }
    { 22  ;   ;Cumm HELB           ;Decimal        }
    { 23  ;   ;Cumm NHIF           ;Decimal        }
    { 24  ;   ;Bank Account Number ;Code50         }
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
  }
  KEYS
  {
    {    ;Employee Code                           ;SumIndexFields=Basic Pay;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Employee@1102755000 : Record 51516160;
      HREmp@1000 : Record 51516160;

    BEGIN
    END.
  }
}

