OBJECT table 17278 Bosa Loan Clearances
{
  OBJECT-PROPERTIES
  {
    Date=04/06/16;
    Time=[ 3:38:33 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               SalesSetup.GET;
               SalesSetup.TESTFIELD(SalesSetup."BOSA Loans Nos");
               NoSeriesMgt.InitSeries(SalesSetup."BOSA Loans Nos",xRec."No. Series",0D,"BLA Number","No. Series");
             END;

  }
  FIELDS
  {
    { 1   ;   ;BLA Number          ;Code10         }
    { 2   ;   ;Client Code         ;Code10        ;TableRelation="Members Register".No.;
                                                   OnValidate=BEGIN
                                                                IF "Client Code" = '' THEN
                                                                "Client Name":='';

                                                                IF CustomerRecord.GET("Client Code") THEN BEGIN
                                                                IF CustomerRecord.Blocked=CustomerRecord.Blocked::All THEN
                                                                ERROR('Member is blocked from transacting ' + "Client Code");



                                                                CustomerRecord.TESTFIELD(CustomerRecord."ID No.");
                                                                IF CustomerRecord."Registration Date" <> 0D THEN BEGIN
                                                                IF CALCDATE(GenSetUp."Min. Loan Application Period",CustomerRecord."Registration Date") > TODAY THEN
                                                                ERROR('Member is less than six months old therefor not eligible for loan application.');
                                                                END;
                                                                END;

                                                                "Client Name":=CustomerRecord.Name;
                                                                "Account No":=CustomerRecord."FOSA Account";
                                                                "Staff No":=CustomerRecord."Payroll/Staff No";
                                                                "ID No":=CustomerRecord."ID No.";
                                                              END;
                                                               }
    { 3   ;   ;Client Name         ;Code60         }
    { 4   ;   ;Loan Product Type   ;Code60        ;TableRelation="Loan Products Setup".Code;
                                                   OnValidate=BEGIN
                                                                IF LoanType.GET("Loan Product Type") THEN BEGIN
                                                                "Loan Product Type Name":=LoanType."Product Description";
                                                                END;
                                                              END;
                                                               }
    { 5   ;   ;Loan Product Type Name;Code60       }
    { 6   ;   ;Interest            ;Decimal        }
    { 7   ;   ;Request Amount      ;Decimal        }
    { 8   ;   ;Approved Amount     ;Decimal       ;OnValidate=BEGIN
                                                                IF "Approved Amount"> "Request Amount" THEN BEGIN
                                                                ERROR('APPROVED AMOUNT CANT BE GREATER THAN REQUESTED AMOUNT');
                                                                END;
                                                              END;
                                                               }
    { 9   ;   ;Main Loan Number    ;Code60        ;TableRelation="Loans Register"."Loan  No." WHERE (Client Code=FIELD(Client Code),
                                                                                                     Posted=CONST(No));
                                                   OnValidate=BEGIN
                                                                IF Loan.GET("Main Loan Number") THEN BEGIN
                                                                Loan."Has BLA":= TRUE;
                                                                Loan.MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 10  ;   ;Approval Status     ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected }
    { 11  ;   ;No. Series          ;Code10         }
    { 12  ;   ;Staff No            ;Code60         }
    { 13  ;   ;Account No          ;Code60         }
    { 14  ;   ;ID No               ;Code60         }
    { 15  ;   ;Responsibility Center;Code60       ;TableRelation="Responsibility Center" }
    { 16  ;   ;Posted              ;Boolean        }
    { 17  ;   ;Balances            ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry"."Amount (LCY)" WHERE (Loan No=FIELD(BLA Number))) }
  }
  KEYS
  {
    {    ;BLA Number                              ;Clustered=Yes }
    {    ;Client Code,Main Loan Number,Posted     ;SumIndexFields=Approved Amount }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SalesSetup@1000000076 : Record 51516258;
      NoSeriesMgt@1000000075 : Codeunit 396;
      LoanType@1000000074 : Record 51516240;
      CustomerRecord@1000000073 : Record 51516223;
      i@1000000072 : Integer;
      PeriodDueDate@1000000071 : Date;
      Gnljnline@1000000070 : Record 81;
      Jnlinepost@1000000069 : Codeunit 12;
      CumInterest@1000000068 : Decimal;
      NewPrincipal@1000000067 : Decimal;
      PeriodPrRepayment@1000000066 : Decimal;
      GenBatch@1000000065 : Record 232;
      LineNo@1000000064 : Integer;
      GnljnlineCopy@1000000063 : Record 81;
      NewLNApplicNo@1000000062 : Code[10];
      IssuedDate@1000000061 : Date;
      GracePerodDays@1000000060 : Integer;
      InstalmentDays@1000000059 : Integer;
      GracePeiodEndDate@1000000058 : Date;
      InstalmentEnddate@1000000057 : Date;
      NoOfGracePeriod@1000000056 : Integer;
      G@1000000055 : Integer;
      RunningDate@1000000054 : Date;
      NewSchedule@1000000053 : Record 51516234;
      ScheduleCode@1000000052 : Code[20];
      GP@1000000051 : Text[30];
      Groups@1000000050 : Record 51516275;
      PeriodInterval@1000000049 : Code[10];
      GLSetup@1000000048 : Record 98;
      Users@1000000047 : Record 2000000120;
      FlatPeriodInterest@1000000046 : Decimal;
      FlatRateTotalInterest@1000000045 : Decimal;
      FlatPeriodInterval@1000000044 : Code[10];
      ProdCycles@1000000043 : Record 51516275;
      LoanApp@1000000042 : Record 51516230;
      MemberCycle@1000000041 : Integer;
      PCharges@1000000040 : Record 51516242;
      TCharges@1000000039 : Decimal;
      LAppCharges@1000000038 : Record 51516244;
      Vendor@1000000037 : Record 23;
      Cust@1000000036 : Record 51516223;
      Vend@1000000035 : Record 23;
      Cust2@1000000034 : Record 51516223;
      TotalMRepay@1000000033 : Decimal;
      LPrincipal@1000000032 : Decimal;
      LInterest@1000000031 : Decimal;
      InterestRate@1000000030 : Decimal;
      LoanAmount@1000000029 : Decimal;
      RepayPeriod@1000000028 : Integer;
      LBalance@1000000027 : Decimal;
      UsersID@1000000026 : Record 2000000120;
      LoansBatches@1000000025 : Record 51516236;
      Employer@1000000024 : Record 51516260;
      GenSetUp@1000000023 : Record 51516257;
      Batches@1000000022 : Record 51516236;
      MovementTracker@1000000021 : Record 51516253;
      SpecialComm@1000000020 : Decimal;
      CustR@1000000019 : Record 51516223;
      RAllocation@1000000018 : Record 51516246;
      "Standing Orders"@1000000017 : Record 51516307;
      StatusPermissions@1000000016 : Record 51516310;
      CustLedg@1000000015 : Record 51516224;
      LoansClearedSpecial@1000000014 : Record 51516276;
      BridgedLoans@1000000013 : Record 51516276;
      Loan@1000000012 : Record 51516230;
      banks@1000000011 : Record 270;
      DefaultInfo@1000000010 : Text[180];
      sHARES@1000000009 : Decimal;
      MonthlyRepayT@1000000008 : Decimal;
      MonthlyRepay@1000000007 : Decimal;
      CurrExchRate@1000000006 : Record 330;
      RepaySched@1000000005 : Record 51516234;
      currYear@1000000004 : Integer;
      StartDate@1000000003 : Date;
      EndDate@1000000002 : Date;
      Month@1000000001 : Integer;
      Mwezikwisha@1000000000 : Date;

    BEGIN
    END.
  }
}

