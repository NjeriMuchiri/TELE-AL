OBJECT table 17263 Membership Withdrawals
{
  OBJECT-PROPERTIES
  {
    Date=07/06/23;
    Time=[ 3:33:50 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN


               IF "No." = '' THEN BEGIN
                 SalesSetup.GET;
                 SalesSetup.TESTFIELD(SalesSetup."Closure  Nos");
                 NoSeriesMgt.InitSeries(SalesSetup."Closure  Nos",xRec."No. Series",0D,"No.","No. Series");
               END;

               "Captured By":=USERID;
             END;

    OnModify=BEGIN
               {IF (Status=Status::Pending) OR (Status=Status::Approved) THEN
                 ERROR('You cannot modify an approved or pending withdrawal application');
                 }
             END;

    OnDelete=BEGIN
               IF (Status=Status::Pending) OR (Status=Status::Approved) THEN
                 ERROR('You cannot delete an approved or pending withdrawal application');
             END;

    OnRename=BEGIN
               IF (Status=Status::Pending) OR (Status=Status::Approved) THEN
                 ERROR('You cannot rename an approved or pending withdrawal application');
             END;

  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."Closure  Nos");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Member No.          ;Code20        ;TableRelation="Members Register";
                                                   OnValidate=BEGIN
                                                                MembershipWithdrawals.RESET;
                                                                MembershipWithdrawals.SETRANGE("Member No.","Member No.");
                                                                MembershipWithdrawals.SETRANGE(Registered,FALSE);
                                                                IF MembershipWithdrawals.FINDLAST THEN
                                                                  ERROR(Err_DocNo,MembershipWithdrawals."No.","Member No.");

                                                                IntTotal:=0;
                                                                LoanTotal:=0;
                                                                AccruedInt:=0;
                                                                InsFund:=0;

                                                                IF Cust.GET("Member No.") THEN BEGIN
                                                                "Member Name":=Cust.Name;
                                                                "ID No.":=Cust."ID No.";
                                                                "Payroll/Staff No":=Cust."Payroll/Staff No";
                                                                Cust.CALCFIELDS(Cust."Current Savings",Cust."School Fees Shares");
                                                                {Cust.CALCFIELDS(Cust."Current Shares",Cust."Principle Balance",Cust."Outstanding Balance",Cust."Outstanding Interest");
                                                                "Principle Balance":=Cust."Principle Balance";
                                                                "Outstanding Interest":=Cust."Outstanding Interest";
                                                                "Outstanding Balance":=Cust."Outstanding Balance";
                                                                "Current Shares":=Cust."Current Shares";}
                                                                "Member Deposits":=Cust."Current Savings";//+Cust."School Fees Shares");
                                                                "School Fees Shares":=Cust."School Fees Shares";
                                                                "FOSA Account No.":=Cust."FOSA Account";
                                                                AccruedInt:=Cust."Accrued Interest";
                                                                InsFund:=Cust."Insurance Fund";
                                                                //"BBF Amount":=0.5*39500;
                                                                MODIFY;
                                                                END;
                                                                IF CustomerRecord.GET("Member No.") THEN BEGIN
                                                                CustomerRecord.CALCFIELDS(CustomerRecord."Front Side ID",CustomerRecord."Back Side ID");
                                                                IF CustomerRecord."Front Side ID".HASVALUE=FALSE THEN
                                                                ERROR('Members Front side ID must be captured');
                                                                IF CustomerRecord."Back Side ID".HASVALUE=FALSE THEN
                                                                ERROR('Members Back side ID must be captured');
                                                                IF CustomerRecord."Date of Birth"=0D THEN
                                                                ERROR('Member Has no Date of Birth');
                                                                IF CustomerRecord."ID No."='' THEN
                                                                ERROR('Member Has no Identification Number');
                                                                IF CustomerRecord."E-Mail"='' THEN
                                                                ERROR('Member Has no E-mail Address');
                                                                IF CustomerRecord.Pin='' THEN
                                                                ERROR('Member Has no KRA Pin');
                                                                CustomerRecord.TESTFIELD("Phone No.");
                                                                END;



                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Client Code","Member No.");
                                                                Loans.SETRANGE(Loans.Source,Loans.Source::BOSA);
                                                                Loans.SETRANGE(Loans.Posted,TRUE);
                                                                //Loans.SETFILTER(Loans."Outstanding Balance",'>0');
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Oustanding Interest");
                                                                IntTotal:=IntTotal+Loans."Oustanding Interest";
                                                                LoanTotal:=LoanTotal+Loans."Outstanding Balance";
                                                                UNTIL Loans.NEXT=0;
                                                                END;


                                                                //FOSA Loans
                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Client Code","FOSA Account No.");
                                                                Loans.SETRANGE(Loans.Posted,TRUE);
                                                                Loans.SETRANGE(Loans.Source,Loans.Source::FOSA);
                                                                Loans.SETFILTER(Loans."Outstanding Balance",'>0');
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance",Loans."Oustanding Interest");
                                                                IntTotalFOSA:=IntTotalFOSA+Loans."Oustanding Interest";
                                                                LoanTotalFOSA:=LoanTotalFOSA+Loans."Outstanding Balance";
                                                                UNTIL Loans.NEXT=0;
                                                                END;
                                                                "Total Adds":="Member Deposits"+InsFund;
                                                                "Total Loan":=LoanTotal+LoanTotalFOSA;
                                                                "Total Interest":=IntTotal+IntTotalFOSA;
                                                                //"Total Loan":=LoanTotal;
                                                                //"Total Interest":=IntTotal;
                                                                "Total Loans FOSA":=LoanTotalFOSA;
                                                                "Total Oustanding Int FOSA":=IntTotalFOSA;
                                                                "Total Lesses":="Total Loan"+"Total Interest"+AccruedInt;
                                                                "Net Refund":="Total Adds"-"Total Lesses";

                                                                "Date Registered":=TODAY;
                                                              END;
                                                               }
    { 3   ;   ;Member Name         ;Text50         }
    { 4   ;   ;Closing Date        ;Date           }
    { 5   ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected,Canceled;
                                                   OptionString=Open,Pending,Approved,Rejected,Canceled }
    { 6   ;   ;Posted              ;Boolean        }
    { 7   ;   ;Total Loan          ;Decimal        }
    { 8   ;   ;Total Interest      ;Decimal        }
    { 9   ;   ;Member Deposits     ;Decimal        }
    { 10  ;   ;No. Series          ;Code20         }
    { 11  ;   ;Closure Type        ;Option        ;OptionCaptionML=ENU=Notice,Death,Expulsion;
                                                   OptionString=Notice,Death,Expulsion }
    { 12  ;   ;Mode Of Disbursement;Option        ;OptionCaptionML=ENU=FOSA Transfer,Cheque,EFT;
                                                   OptionString=FOSA Transfer,Cheque,EFT }
    { 13  ;   ;Paying Bank         ;Code20        ;TableRelation="Bank Account".No.;
                                                   OnValidate=BEGIN
                                                                IF ("Mode Of Disbursement"="Mode Of Disbursement"::Cheque) OR ("Mode Of Disbursement"="Mode Of Disbursement"::EFT) THEN BEGIN
                                                                IF "Paying Bank"='' THEN
                                                                ERROR('You Must Specify the Paying bank');
                                                                END;
                                                              END;
                                                               }
    { 14  ;   ;Cheque No.          ;Code20         }
    { 15  ;   ;FOSA Account No.    ;Code20         }
    { 16  ;   ;Payee               ;Text80         }
    { 17  ;   ;Net Pay             ;Decimal        }
    { 18  ;   ;BBF Amount          ;Decimal        }
    { 19  ;   ;Amount to withhold  ;Decimal       ;OnValidate=BEGIN
                                                                  IF "Amount to withhold"<0 THEN
                                                                  ERROR('Amount must not be less than zero');
                                                              END;
                                                               }
    { 20  ;   ;Effective Date      ;Date          ;OnValidate=BEGIN
                                                                   IF "Closure Type"<>"Closure Type":: "3" THEN
                                                                   ERROR('Option Only for Termination Withdrawal');
                                                              END;
                                                               }
    { 21  ;   ;Service Charge      ;Decimal        }
    { 22  ;   ;Withdrawable savings Scheme;Decimal }
    { 23  ;   ;Approved By         ;Code30        ;Editable=No }
    { 24  ;   ;Captured By         ;Code30        ;Editable=No }
    { 25  ;   ;Notice Date         ;Date          ;OnValidate=BEGIN
                                                                "Due Date":="Notice Date"+60;
                                                                IF "Due Date"=TODAY THEN
                                                                 MODIFY;
                                                              END;
                                                               }
    { 26  ;   ;Due Date            ;Date           }
    { 27  ;   ;Payroll/Staff No    ;Code20        ;OnValidate=BEGIN
                                                                {IF "Customer Type" = "Customer Type"::" " THEN
                                                                EXIT;

                                                                IF "Customer Type" = "Customer Type"::FOSA THEN
                                                                EXIT;
                                                                IF "Payroll/Staff No"<>'' THEN BEGIN
                                                                Cust.RESET;
                                                                Cust.SETRANGE(Cust."Payroll/Staff No","Payroll/Staff No");
                                                                Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                //IF Cust."No." <> "No." THEN
                                                                   //ERROR('Staff/Payroll No. already exists');
                                                                END;
                                                                END;

                                                                IF xRec."Payroll/Staff No"<>'' THEN BEGIN
                                                                IF "Payroll/Staff No"<>xRec."Payroll/Staff No" THEN BEGIN
                                                                IF CONFIRM('Are you sure you want to change the staff number?',TRUE)=TRUE THEN BEGIN
                                                                CustFosa:='5-02-'+"No."+'-00';

                                                                //MESSAGE('%1',CustFosa);



                                                                Cust.RESET;
                                                                Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::FOSA);
                                                                Cust.SETRANGE("No.",CustFosa);
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                Cust."Payroll/Staff No":="Payroll/Staff No";
                                                                END;




                                                                Vend.RESET;
                                                                Vend.SETRANGE(Vend."No.","FOSA Account");
                                                                IF Vend.FIND('-') THEN BEGIN
                                                                IF Vend."Staff No" <> '' THEN BEGIN
                                                                Vend2.RESET;
                                                                Vend2.SETRANGE(Vend2."Staff No",Vend."Staff No");
                                                                IF Vend2.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                Vend2."Staff No":="Payroll/Staff No";
                                                                Vend2.MODIFY;
                                                                UNTIL Vend2.NEXT = 0;
                                                                END;
                                                                END;
                                                                END;
                                                                Vend.RESET;
                                                                Vend2.RESET;

                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Client Code","No.");
                                                                Loans.SETFILTER(Loans.Source,'BOSA');
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                //MESSAGE('NIMEGET %1%2',"Staff No",Loans."Staff No");
                                                                Loans."Staff No":="Payroll/Staff No";
                                                                Loans.MODIFY;
                                                                UNTIL Loans.NEXT=0;
                                                                END;

                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Client Code","FOSA Account");
                                                                Loans.SETFILTER(Loans.Source,'FOSA');
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                //MESSAGE('NIMEGET %1%2',"Staff No",Loans."Staff No");
                                                                Loans."Staff No":="Payroll/Staff No";
                                                                Loans.MODIFY;
                                                                UNTIL Loans.NEXT=0;
                                                                END;



                                                                END
                                                                ELSE
                                                                "Payroll/Staff No":=xRec."Payroll/Staff No"
                                                                END;
                                                                END;     }
                                                              END;
                                                               }
    { 28  ;   ;ID No.              ;Code50        ;OnValidate=BEGIN
                                                                {IF "ID No."<>'' THEN BEGIN
                                                                Cust.RESET;
                                                                Cust.SETRANGE(Cust."ID No.","ID No.");
                                                                Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                IF Cust."No." <> "No." THEN
                                                                   ERROR('ID No. already exists');
                                                                END;
                                                                END;



                                                                Vend2.RESET;
                                                                Vend2.SETRANGE(Vend2."Creditor Type",Vend2."Creditor Type"::Account);
                                                                Vend2.SETRANGE(Vend2."Staff No","Payroll/Staff No");
                                                                IF Vend2.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                Vend2."ID No.":="ID No.";
                                                                Vend2.MODIFY;
                                                                UNTIL Vend2.NEXT = 0;
                                                                END;
                                                                    }
                                                              END;
                                                               }
    { 29  ;   ;ID No.2             ;Code40         }
    { 30  ;   ;Payroll/Staff No2   ;Code40         }
    { 31  ;   ;Date Filter2        ;Date           }
    { 32  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=ENU=Date Filter }
    { 33  ;   ;Guarantorship Check ;Boolean        }
    { 34  ;   ;Batch No.           ;Code20        ;TableRelation="Membership Withdrawal-Batching"."Batch No." }
    { 68003;  ;Current Shares      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                        Transaction Type=FILTER(Deposit Contribution),
                                                                                                        Posting Date=FIELD(Date Filter)));
                                                   Editable=No }
    { 68011;  ;Outstanding Balance ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                       Transaction Type=FILTER(Loan|Repayment|Loan Adjustment|Interest Due|Interest Paid)));
                                                   Editable=No }
    { 68110;  ;Outstanding Interest;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                               Transaction Type=FILTER(Interest Paid|Interest Due))) }
    { 69090;  ;Principle Balance   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                       Transaction Type=FILTER(Loan|Repayment|Loan Adjustment)));
                                                   Editable=No }
    { 69091;  ;Withdrawal Status   ;Option        ;OptionCaptionML=ENU=Initiated,Processed,Posted;
                                                   OptionString=Initiated,Processed,Posted }
    { 69092;  ;Registered          ;Boolean        }
    { 69093;  ;Date Registered     ;Date           }
    { 69094;  ;Posted By           ;Code100        }
    { 69095;  ;Net Refund          ;Decimal        }
    { 69096;  ;Total Adds          ;Decimal        }
    { 69097;  ;Total Lesses        ;Decimal        }
    { 69098;  ;Total Loans FOSA    ;Decimal        }
    { 69099;  ;Total Oustanding Int FOSA;Decimal   }
    { 69100;  ;School Fees Shares  ;Decimal        }
    { 69101;  ;Disbursement Type   ;Option        ;OptionCaptionML=ENU=,Full Amount,Tranches;
                                                   OptionString=,Full Amount,Tranches }
    { 69102;  ;Amount to Refund    ;Decimal        }
    { 69103;  ;Number of Installments;Integer      }
    { 69104;  ;Total Amount Disbursed;Decimal      }
    { 69105;  ;Reason for Withdrawal;Text250       }
    { 69106;  ;Description         ;Text250        }
    { 69107;  ;Current Deposits    ;Decimal        }
    { 69108;  ;Membes Deposits     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Member No.),
                                                                                                        Transaction Type=FILTER(Deposit Contribution),
                                                                                                        Posting Date=FIELD(Date Filter))) }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SalesSetup@1102755000 : Record 51516258;
      NoSeriesMgt@1102755001 : Codeunit 396;
      Cust@1102755002 : Record 51516223;
      Loans@1102755003 : Record 51516230;
      MemLed@1102755004 : Record 51516224;
      IntTotal@1102755005 : Decimal;
      LoanTotal@1102755006 : Decimal;
      IntTotalFOSA@1120054000 : Decimal;
      LoanTotalFOSA@1120054001 : Decimal;
      AccruedInt@1120054002 : Decimal;
      InsFund@1120054003 : Decimal;
      Err_DocNo@1120054004 : TextConst 'ENU=Please utilize document No. %1 for member %2';
      MembershipWithdrawals@1120054005 : Record 51516259;
      CustomerRecord@1120054006 : Record 51516223;

    BEGIN
    END.
  }
}

