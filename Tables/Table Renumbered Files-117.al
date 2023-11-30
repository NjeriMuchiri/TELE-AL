OBJECT table 17235 Loans Guarantee Details
{
  OBJECT-PROPERTIES
  {
    Date=12/30/22;
    Time=11:05:36 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan No             ;Code20        ;TableRelation="Loans Register"."Loan  No.";
                                                   NotBlank=Yes }
    { 2   ;   ;Member No           ;Code20        ;TableRelation="Members Register".No.;
                                                   OnValidate=VAR
                                                                AmountCommitted@1120054000 : Decimal;
                                                                MaximumAmountToCommit@1120054001 : Decimal;
                                                                BalanceToCommit@1120054002 : Decimal;
                                                              BEGIN

                                                                "Self Guarantee":=FALSE;
                                                                SelfGuaranteedA:=0;
                                                                Date:=TODAY;


                                                                //Evaluate guarantor basic info
                                                                IF Cust.GET("Member No") THEN BEGIN
                                                                Cust.CALCFIELDS(Cust."Outstanding Balance",Cust."Current Shares",Cust."Co-operative Shares");//,Cust."Loans Guaranteed"
                                                                Name:=Cust.Name;
                                                                "Staff/Payroll No." := Cust."Payroll/Staff No";
                                                                "Loan Balance":=Cust."Outstanding Balance";
                                                                Shares:=Cust."Current Shares"+Cust."Co-operative Shares";
                                                                "Amont Guaranteed":=Cust."Current Shares"+Cust."Co-operative Shares";
                                                                "ID No.":=Cust."ID No.";
                                                                "Employer Code":=Cust."Employer Code";
                                                                END;



                                                                GenSetUp.GET();


                                                                IF Cust."Registration Date" <> 0D THEN BEGIN
                                                                IF CALCDATE(GenSetUp."Min. Loan Application Period",Cust."Registration Date") > TODAY THEN
                                                                IF CONFIRM('Member is less than'+' '+GenSetUp."Min. Loan Application Period"+' '+
                                                                'months old therefore not eligibl to guarantee a loan,Is the Member Self-Guranteeing?')THEN

                                                                Cust.RESET;
                                                                Cust.SETRANGE(Cust."No.","Member No");
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                  IF (Cust.Status=Cust.Status::Closed) THEN
                                                                    ERROR('This member account is closed.');

                                                                END;



                                                                //Check Max garantors
                                                                LoansG:=0;
                                                                AmountGuaranteed:=0;
                                                                LoanGuarantors.RESET;
                                                                LoanGuarantors.SETRANGE(LoanGuarantors."Member No","Member No");
                                                                LoanGuarantors.SETRANGE(LoanGuarantors.Substituted,FALSE);
                                                                IF LoanGuarantors.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                IF LoanGuarantors."Outstanding Balance">0 THEN BEGIN
                                                                LoansG:=LoansG+1;
                                                                AmountGuaranteed:=AmountGuaranteed+LoanGuarantors."Amont Guaranteed";
                                                                IF LoanGuarantors."Self Guarantee" = TRUE THEN BEGIN
                                                                SelfGuaranteedA:=SelfGuaranteedA+Loans."Outstanding Balance";
                                                                END;
                                                                END;
                                                                UNTIL LoanGuarantors.NEXT = 0;
                                                                END;
                                                                //CHECK defaulter

                                                                GenSetUp.GET();
                                                                IF LoansG > GenSetUp."Maximum No of Guarantees" THEN BEGIN
                                                                ERROR('Member has guaranteed more than 25 active loans and  can not Guarantee any other Loans');
                                                                "Member No":='';
                                                                "Staff/Payroll No.":='';
                                                                Name:='';
                                                                "Loan Balance":=0;
                                                                Date:=0D;
                                                                EXIT;
                                                                END;
                                                                //END;
                                                                //Check Max garantors


                                                                //Check If Self Guarantee
                                                                IF LoansR.GET("Loan No") THEN BEGIN
                                                                IF LoansR."Client Code" = "Member No" THEN BEGIN
                                                                IF GenSetUp.GET(0) THEN BEGIN
                                                                IF GenSetUp."Member Can Guarantee Own Loan" = FALSE THEN
                                                                ERROR('Member can not guarantee own loan.')
                                                                END;
                                                                IF (SelfGuaranteedA + LoansR."Approved Amount") > Shares*-1 THEN
                                                                //ERROR('Member Shares not sufficient to guarantee self.');

                                                                "Self Guarantee":=TRUE;

                                                                END;
                                                                END;
                                                                //Check If Self Guarantee


                                                                IF Cust.GET("Member No") THEN BEGIN
                                                                IF Loans.Source=Loans.Source::MICRO THEN BEGIN
                                                                Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::MicroFinance);
                                                                IF Cust.FIND('-')= FALSE THEN
                                                                ERROR('Sorry selected Member is not a micro member');
                                                                END;
                                                                "Employer Code":=Cust."Employer Code";
                                                                "Employer Name":=Cust."Employer Name";
                                                                "ID No.":= Cust."ID No.";
                                                                END;



                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Loan  No.","Loan No");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                "Loanees  No":=Loans."Client Code";
                                                                "Loanees  Name":=Loans."Client Name";
                                                                END;
                                                                END;
                                                                //END;


                                                                IF Cust.GET("Member No") THEN
                                                                Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained",Cust."Co-operative Shares");
                                                                Name:=Cust.Name;
                                                                "ID No.":=Cust."ID No.";
                                                                "Staff/Payroll No.":=Cust."Payroll/Staff No";
                                                                "Cummulative Shares":=(Cust."Current Shares"+Cust."Co-operative Shares");
                                                                "Cummulative Shares2":= ROUND ((Cust."Current Shares"+Cust."Co-operative Shares")* 10*2/3);

                                                                RESET;
                                                                LoanGuarantors.RESET;
                                                                LoanGuarantors.SETRANGE(LoanGuarantors."Member No","Member No");
                                                                LoanGuarantors.SETRANGE(LoanGuarantors.Substituted,FALSE);
                                                                IF LoanGuarantors.FIND('-')THEN BEGIN
                                                                REPEAT

                                                                LoanGuarantors.CALCFIELDS(LoanGuarantors."Outstanding Balance",LoanGuarantors."Loan amount");
                                                                IF LoanGuarantors."Outstanding Balance"<>0 THEN BEGIN
                                                                IF LoanGuarantors.Substituted=FALSE THEN BEGIN
                                                                balance:=balance+LoanGuarantors."Outstanding Balance";
                                                                amountg:=amountg+LoanGuarantors."Amont Guaranteed";
                                                                loanamnt:=loanamnt+LoanGuarantors."Loan amount";
                                                                END;
                                                                END;
                                                                UNTIL  LoanGuarantors.NEXT=0;



                                                                IF (balance=0) OR (loanamnt=0) THEN
                                                                EXIT;
                                                                Liability:= ROUND(balance*amountg/loanamnt);

                                                                IF Liability >= "Cummulative Shares2" THEN
                                                                ERROR('Member has reached the maximum gurantorship!');

                                                                END;

                                                                IF Cust.GET("Member No") THEN BEGIN
                                                                //SendSMS;
                                                                END;

                                                                IF Custs.GET("Member No") THEN
                                                                BEGIN
                                                                IF Custs.Status=Cust.Status::Dormant THEN
                                                                MESSAGE('Loan Guarantor Must Not Be Dormant');
                                                                END;


                                                                LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."Client Code","Member No");
                                                                LoanApp.SETFILTER(LoanApp."Loans Category",'%1',LoanApp."Loans Category"::Loss);
                                                                IF(LoanApp.FIND('-')) THEN BEGIN
                                                                REPEAT
                                                                LoanApp.CALCFIELDS("Outstanding Balance");
                                                                IF LoanApp."Outstanding Balance">0 THEN
                                                                ERROR('Member has Aloan which is in Loss');
                                                                UNTIL LoanApp.NEXT=0;
                                                                END;
                                                                 //LoanApp.INIT;
                                                                LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."Client Code","Member No");
                                                                LoanApp.SETFILTER(LoanApp."Loans Category",'%1',LoanApp."Loans Category"::Substandard);
                                                                IF(LoanApp.FIND('-')) THEN BEGIN
                                                                REPEAT
                                                                LoanApp.CALCFIELDS("Outstanding Balance");
                                                                IF LoanApp."Outstanding Balance">0 THEN
                                                                ERROR('Member has Aloan which is substandard');
                                                                UNTIL LoanApp.NEXT=0;
                                                                END;

                                                                  //LoanApp.INIT;
                                                                LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."Client Code","Member No");
                                                                LoanApp.SETFILTER(LoanApp."Loans Category",'%1',LoanApp."Loans Category"::Doubtful);
                                                                IF(LoanApp.FIND('-')) THEN BEGIN
                                                                REPEAT
                                                                LoanApp.CALCFIELDS("Outstanding Balance");
                                                                IF LoanApp."Outstanding Balance">0 THEN
                                                                ERROR('Member has Aloan which is doubtfull');
                                                                UNTIL LoanApp.NEXT=0;
                                                                END;
                                                                AmountCommitted:=0;
                                                                GuarantorsDetails.RESET;
                                                                GuarantorsDetails.SETRANGE(GuarantorsDetails."Member No","Member No");
                                                                IF GuarantorsDetails.FINDFIRST THEN
                                                                BEGIN
                                                                REPEAT
                                                                LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."Loan  No.",GuarantorsDetails."Loan No");
                                                                LoanApp.SETAUTOCALCFIELDS(LoanApp."Outstanding Balance");
                                                                LoanApp.SETFILTER(LoanApp."Outstanding Balance",'>%1',0);
                                                                IF LoanApp.FINDFIRST THEN BEGIN
                                                                AmountCommitted:=GuarantorsDetails."Amont Guaranteed"+AmountCommitted;
                                                                END;
                                                                UNTIL GuarantorsDetails.NEXT=0;

                                                                IF CustR.GET("Member No") THEN
                                                                CustR.CALCFIELDS(CustR."Current Shares");
                                                                MaximumAmountToCommit:=0;
                                                                SaccoSetup.GET();
                                                                MaximumAmountToCommit:=CustR."Current Shares"*SaccoSetup."Guarantors Multiplier";
                                                                IF AmountCommitted>MaximumAmountToCommit THEN BEGIN
                                                                ERROR('You can only guarantee shares up to %1.Your current guaranteed amount is %2',MaximumAmountToCommit,AmountCommitted);
                                                                END ELSE BEGIN
                                                                BalanceToCommit:=MaximumAmountToCommit-AmountCommitted;
                                                                MESSAGE('Maximum shares to guarantee is %1.Committed amount is %2 .Shares balance to guarantee is %3.',MaximumAmountToCommit,AmountCommitted,BalanceToCommit);
                                                                END;
                                                                END;


                                                                {AmountGuaranteed:=0;
                                                                GuarantorsDetails.RESET;
                                                                GuarantorsDetails.SETRANGE(GuarantorsDetails."Member No","Member No");
                                                                GuarantorsDetails.SETRANGE(GuarantorsDetails."Self Guarantee",TRUE);
                                                                GuarantorsDetails.SETAUTOCALCFIELDS(GuarantorsDetails."Outstanding Balance");
                                                                GuarantorsDetails.SETFILTER(GuarantorsDetails."Outstanding Balance",'>%1',0);
                                                                IF GuarantorsDetails.FINDFIRST THEN BEGIN
                                                                AmountGuaranteedR:=CustR."Current Shares"-GuarantorsDetails."Amont Guaranteed";
                                                                IF (AmountGuaranteedR/CustR."Current Shares"*100)>90 THEN
                                                                ERROR('The member has self guaranteed his loan.');
                                                                END;}
                                                              END;

                                                   NotBlank=No }
    { 3   ;   ;Name                ;Text200       ;Editable=No }
    { 4   ;   ;Loan Balance        ;Decimal       ;Editable=No }
    { 5   ;   ;Shares              ;Decimal       ;Editable=No }
    { 6   ;   ;No Of Loans Guaranteed;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Guarantee Details" WHERE (Member No=FIELD(Member No),
                                                                                                      Outstanding Balance=FILTER(>1,000)));
                                                   Editable=No }
    { 7   ;   ;Substituted         ;Boolean       ;OnValidate=BEGIN
                                                                // TESTFIELD("Substituted Guarantor");
                                                              END;
                                                               }
    { 8   ;   ;Date                ;Date           }
    { 9   ;   ;Shares Recovery     ;Boolean        }
    { 10  ;   ;New Upload          ;Boolean        }
    { 11  ;   ;Amont Guaranteed    ;Decimal       ;OnValidate=BEGIN

                                                                IF "Member No"='' THEN
                                                                ERROR('Kindly Input Guarantors Member Number before You Continue');

                                                                RESET;
                                                                LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."Loan  No.","Loan No");

                                                                IF LoanApp.FIND('-') THEN BEGIN
                                                                //IF LoanApp.Posted=TRUE THEN
                                                                //IF Signed=TRUE THEN
                                                                //ERROR('You cannot change the initial amount guranteed');

                                                                END;

                                                                "Amount Committed":="Amont Guaranteed";
                                                                IF Loans.GET("Loan No") THEN
                                                                "% Proportion":=("Amont Guaranteed"/Loans."Approved Amount")*100;
                                                                //SendSMS;

                                                                IF Cust.GET("Member No") THEN
                                                                BEGIN
                                                                TotalDeposits:=0;
                                                                Cust.CALCFIELDS(Cust."Current Shares",Cust."Co-operative Shares");
                                                                IF "Amont Guaranteed">(Cust."Current Shares"+Cust."Co-operative Shares") THEN
                                                                ERROR('Guarantor does not have enough deposits to guarantee this amount.');
                                                                END;
                                                                //MESSAGE('Expected Amount %1',"Balance To Commit");
                                                                //IF "Amont Guaranteed">"Balance To Commit" THEN
                                                                //ERROR('You cannot guarantee an amount greater than %1',"Balance To Commit");
                                                              END;
                                                               }
    { 12  ;   ;Staff/Payroll No.   ;Code20        ;OnValidate=BEGIN
                                                                Cust.RESET;
                                                                Cust.SETRANGE(Cust."Payroll/Staff No","Staff/Payroll No.");
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                "Member No":=Cust."No.";
                                                                VALIDATE("Member No");
                                                                END
                                                                ELSE
                                                                "Member No":='';//ERROR('Record not found.')
                                                              END;
                                                               }
    { 13  ;   ;Account No.         ;Code20         }
    { 14  ;   ;Self Guarantee      ;Boolean        }
    { 15  ;   ;ID No.              ;Code50         }
    { 16  ;   ;Outstanding Balance ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Transaction Type=FILTER(Loan|Repayment),
                                                                                                       Loan No=FIELD(Loan No))) }
    { 17  ;   ;Total Loans Guaranteed;Decimal     ;FieldClass=Normal }
    { 18  ;   ;Loans Outstanding   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Transaction Type=FILTER(Loan|Repayment),
                                                                                                       Loan No=FIELD(Loan No)));
                                                   OnValidate=BEGIN
                                                                "Total Loans Guaranteed":="Outstanding Balance";
                                                                //MODIFY;
                                                              END;
                                                               }
    { 19  ;   ;Guarantor Outstanding;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Member No),
                                                                                                       Transaction Type=FILTER(Loan|Repayment))) }
    { 20  ;   ;Employer Code       ;Code20        ;TableRelation="Sacco Employers";
                                                   Editable=No }
    { 21  ;   ;Employer Name       ;Text100        }
    { 22  ;   ;Substituted Guarantor;Code80       ;TableRelation="Members Register".No.;
                                                   OnValidate=BEGIN
                                                                GenSetUp.GET();
                                                                IF LoansG > GenSetUp."Maximum No of Guarantees" THEN BEGIN
                                                                ERROR('Member has guaranteed more than 25 active loans and  can not Guarantee any other Loans');
                                                                "Member No":='';
                                                                "Staff/Payroll No.":='';
                                                                Name:='';
                                                                "Loan Balance":=0;
                                                                Date:=0D;
                                                                EXIT;
                                                                END;


                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Client Code","Member No");
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                IF LoanGuarantors."Self Guarantee"=TRUE THEN
                                                                ERROR('This Member has Self Guaranteed and Can not Guarantee another Loan');
                                                                END;
                                                              END;
                                                               }
    { 23  ;   ;Loanees  No         ;Code30        ;FieldClass=Normal }
    { 24  ;   ;Loanees  Name       ;Text80         }
    { 25  ;No ;Member Guaranteed   ;Code50         }
    { 26  ;   ;Telephone No        ;Code10         }
    { 27  ;   ;Cummulative Shares  ;Decimal        }
    { 28  ;   ;Cummulative Shares2 ;Decimal        }
    { 29  ;   ;Loan amount         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Loan No=FIELD(Loan No),
                                                                                                       Transaction Type=FILTER(Loan|Loan Adjustment))) }
    { 30  ;   ;Amount Committed    ;Decimal        }
    { 31  ;   ;% Proportion        ;Decimal        }
    { 32  ;   ;Amount Released     ;Decimal        }
    { 33  ;   ;Signed              ;Boolean        }
    { 34  ;   ;Distribution %      ;Decimal        }
    { 35  ;   ;Distribution Amount ;Decimal        }
    { 36  ;   ;Group Account No.   ;Code50         }
    { 37  ;   ;Share capital       ;Decimal        }
    { 69119;  ;Loan Product        ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Loans Register"."Loan Product Type" WHERE (Loan  No.=FIELD(Loan No))) }
    { 69120;  ;Substituted Guarantor Name;Text100  }
    { 69121;  ;Deposits variance   ;Decimal        }
    { 69122;  ;Total Committed Shares;Decimal      }
    { 69123;  ;Oustanding Interest ;Decimal        }
    { 69124;  ;Guar Sub Doc No.    ;Code20         }
    { 69125;  ;Balance To Commit   ;Decimal        }
  }
  KEYS
  {
    {    ;Loan No,Staff/Payroll No.,Member No      }
    {    ;Loan No,Member No                       ;SumIndexFields=Shares;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Cust@1000000000 : Record 51516223;
      LoanGuarantors@1102760000 : Record 51516231;
      Loans@1102760001 : Record 51516230;
      LoansR@1102756001 : Record 51516230;
      LoansG@1102760002 : Integer;
      GenSetUp@1102756000 : Record 51516257;
      SelfGuaranteedA@1102756002 : Decimal;
      StatusPermissions@1102755000 : Record 51516310;
      Employer@1102755001 : Record 51516260;
      loanG@1102755002 : Record 51516231;
      CustomerRecord@1000000001 : Record 51516223;
      MemberSaccoAge@1000000002 : Date;
      LoanApp@1000000014 : Record 51516230;
      SMSMessage@1000000013 : Record 51516329;
      iEntryNo@1000000012 : Integer;
      Vend@1000000011 : Record 23;
      StrTel@1000000010 : Text[150];
      MessageFailed@1000000009 : Boolean;
      LoansH@1000000008 : Record 51516230;
      balance@1000000007 : Decimal;
      amountg@1000000006 : Decimal;
      loanamnt@1000000005 : Decimal;
      Liability@1000000004 : Decimal;
      TotGuranteed@1000000003 : Decimal;
      LoansReg@1120054000 : Record 51516230;
      AmountGuaranteed@1120054001 : Decimal;
      TotalDeposits@1120054002 : Decimal;
      Custs@1120054003 : Record 51516223;
      Loanss@1120054004 : Record 51516230;
      CustR@1120054005 : Record 51516223;
      GuarantorsDetails@1120054006 : Record 51516231;
      SaccoSetup@1120054007 : Record 51516257;
      AmountGuaranteedR@1120054008 : Decimal;

    PROCEDURE SendSMS@1102755003();
    BEGIN
      {//SMS MESSAGE
      LoanApp.RESET;
      LoanApp.SETRANGE(LoanApp."Loan  No.","Loan No");
      IF LoanApp.FIND('-') THEN BEGIN

      SMSMessage.RESET;
      IF SMSMessage.FIND('+') THEN BEGIN
      iEntryNo:=SMSMessage."Entry No";
      iEntryNo:=iEntryNo+1;
      END
      ELSE BEGIN
      iEntryNo:=1;
      END;

      SMSMessage.INIT;
      SMSMessage."Entry No":=iEntryNo;
      SMSMessage."Account No":="Staff/Payroll No.";
      SMSMessage."Date Entered":=TODAY;
      SMSMessage."Time Entered":=TIME;
      SMSMessage.Source:='LOAN GUARANTORS';
      SMSMessage."Entered By":=USERID;
      SMSMessage."System Created Entry":=TRUE;
      SMSMessage."Document No":="Loan No";
      SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::No;
      SMSMessage."SMS Message":='You have guaranteed '+FORMAT("Amont Guaranteed") +', '+ LoanApp."Client Name"+' '+'Staff No:-'+LoanApp."Staff No"+' Loan Type '+LoanApp."Loan Product Type"+' '+' at TELEPOST SACCO.'
      +' '+'Call if in dispute.';

      //FOSA
      IF LoanApp.Source=LoanApp.Source::FOSA THEN BEGIN
      Vend.RESET;
      Vend.SETRANGE(Vend."No.","Member No");
      IF Vend.FIND('-') THEN BEGIN
      SMSMessage."Telephone No":=Vend."MPESA Mobile No";
      END;
      END;

      //BOSA
      IF LoanApp.Source=LoanApp.Source::BOSA THEN BEGIN
      Cust.RESET;
      Cust.SETRANGE(Cust."No.","Member No");
      Cust.SETRANGE(Cust."Customer Posting Group",'MEMBER');
      IF Cust.FIND('-') THEN BEGIN
      SMSMessage."Telephone No":=Cust."Phone No.";//Cust."Mobile Phone No";
      END;
      END;

      MessageFailed:=FALSE;

      StrTel:=COPYSTR(SMSMessage."Telephone No",1,4);

      IF StrTel<>'+254' THEN BEGIN
      MessageFailed:=TRUE;
      END;

      IF STRLEN(SMSMessage."Telephone No")<>13 THEN BEGIN
      MessageFailed:=TRUE;
      END;

      IF MessageFailed=TRUE THEN BEGIN
      SMSMessage."Sent To Server":=SMSMessage."Sent To Server"::Failed;
      END;

      SMSMessage.INSERT;

      END;
      }
    END;

    BEGIN
    END.
  }
}

