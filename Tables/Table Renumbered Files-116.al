OBJECT table 17234 Loans Register
{
  OBJECT-PROPERTIES
  {
    Date=08/22/23;
    Time=[ 5:58:08 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=VAR
               DoubleLoan@1120054000 : Record 51516230;
               NoOfApps@1120054001 : TextConst 'ENU=Hey %1, Please utilize the unused loan no %2 that you have not utilized';
             BEGIN
               DoubleLoan.RESET;
               DoubleLoan.SETRANGE("Captured By",USERID);
               DoubleLoan.SETRANGE("Loan Status",DoubleLoan."Loan Status"::Application);
               CASE Source OF
                  Source::BOSA:
                       BEGIN
                           // DoubleLoan.SETFILTER("Client Code",'%1','');
                            DoubleLoan.SETRANGE(Source,DoubleLoan.Source::BOSA);
                       END;
                  Source::FOSA:
                       BEGIN
                           //DoubleLoan.SETFILTER("Account No",'%1','');
                           DoubleLoan.SETRANGE(Source,DoubleLoan.Source::FOSA);
                         END;
                 END;


               IF NOT "Mobile Loan" THEN
               IF DoubleLoan.FINDLAST THEN
                  ERROR(NoOfApps,USERID,DoubleLoan."Loan  No.");


               //SURESTEP
               IF Source=Source::BOSA THEN BEGIN
               IF "Loan  No." = '' THEN BEGIN
                 SalesSetup.GET;
                 SalesSetup.TESTFIELD(SalesSetup."BOSA Loans Nos");
                 NoSeriesMgt.InitSeries(SalesSetup."BOSA Loans Nos",xRec."No. Series",0D,"Loan  No.","No. Series");
               END;

               END ELSE IF Source=Source::MICRO THEN BEGIN
               IF "Loan  No." = '' THEN BEGIN
                 SalesSetup.GET;
                 SalesSetup.TESTFIELD(SalesSetup."Micro Loans");
                 NoSeriesMgt.InitSeries(SalesSetup."Micro Loans",xRec."No. Series",0D,"Loan  No.","No. Series");
               END;


               END ELSE BEGIN

               IF "Loan  No." = '' THEN BEGIN
                 SalesSetup.GET;
                 SalesSetup.TESTFIELD(SalesSetup."FOSA Loans Nos");
                 NoSeriesMgt.InitSeries(SalesSetup."FOSA Loans Nos",xRec."No. Series",0D,"Loan  No.","No. Series");
               END;


               END;
               //SURESTEP

               "Application Date":=TODAY;
               Advice:=TRUE;

               "Captured By":=UPPERCASE(USERID);

               "Registration Time":=TIME;
               "Expected Disbursement Time":="Registration Time"+14400000;
               "Mode of Disbursement" := Rec."Mode of Disbursement"::"Transfer to FOSA";

               "Registration Date":=TODAY;
               "Registration Time":=TIME;
               //Create Audit Entry
               AuditTrail.FnGetLastEntry();
               AuditTrail.FnGetComputerName();
               AuditTrail.FnInsertAuditRecords(EntryNo,USERID,'Loan Application',0,'CREDIT',TODAY,TIME,"Loan  No.","Loan  No.",'','');
               //End Create Audit Entry




               //IF UsersID.GET(USERID) THEN
               //"Transacting Branch":=UsersID.Branch;
             END;

    OnModify=BEGIN
               {
                //IF "Loan Status"="Loan Status"::Approved THEN
                //ERROR('A loan cannot be modified once it has been approved');
               IF "Batch No."<>'' THEN BEGIN
               IF LoansBatches.GET("Batch No.") THEN BEGIN
               IF LoansBatches.Status<>LoansBatches.Status::Open THEN
               ERROR('You cannot modify the loan because the batch is already %1',LoansBatches.Status);
               END;
               END;
               }
               //TESTFIELD(Posted,FALSE);
             END;

    OnDelete=BEGIN
               //IF "Loan Status"="Loan Status"::Approved THEN
               ERROR('A loan cannot be deleted once it has been approved');

               //TESTFIELD(Posted,FALSE);
             END;

    LookupPageID=Page51516384;
    DrillDownPageID=Page51516384;
  }
  FIELDS
  {
    { 1   ;   ;Loan  No.           ;Code30        ;OnValidate=BEGIN

                                                                  //SURESTEP
                                                                IF Source=Source::BOSA THEN BEGIN

                                                                IF "Loan  No." <> xRec."Loan  No." THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."BOSA Loans Nos");
                                                                  "No. Series" := '';
                                                                END;

                                                                END ELSE IF Source=Source::MICRO THEN BEGIN
                                                                IF "Loan  No." <> xRec."Loan  No." THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."Micro Loans");
                                                                  "No. Series" := '';
                                                                END;


                                                                END ELSE BEGIN

                                                                IF "Loan  No." <> xRec."Loan  No." THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."FOSA Loans Nos");
                                                                  "No. Series" := '';
                                                                END;


                                                                END;
                                                                  //SURESTEP

                                                              END;
                                                               }
    { 2   ;   ;Application Date    ;Date          ;OnValidate=BEGIN
                                                                IF "Application Date" > TODAY THEN
                                                                ERROR('Application date can not be in the future.');
                                                              END;
                                                               }
    { 3   ;   ;Loan Product Type   ;Code20        ;TableRelation="Loan Products Setup";
                                                   OnValidate=VAR
                                                                EightyFiveNet@1120054000 : Decimal;
                                                              BEGIN

                                                                IF "Loan Product Type"='A15' THEN BEGIN
                                                                FosaAcc.RESET;
                                                                FosaAcc.SETRANGE(FosaAcc."No.","Account No");
                                                                FosaAcc.SETRANGE(FosaAcc."Salary Processing",TRUE);
                                                                IF FosaAcc.FINDFIRST THEN
                                                                BEGIN
                                                                EightyFiveNet:=0;
                                                                EightyFiveNet:=0.85*FosaAcc."Net Salary";
                                                                IF EightyFiveNet<0 THEN
                                                                EightyFiveNet:=EightyFiveNet*-1
                                                                ELSE
                                                                EightyFiveNet:=EightyFiveNet;
                                                                FnCheckDeductions("Client Code");
                                                                //MESSAGE('Net%1EightyFive%2AmountTODeduct%3',FosaAcc."Net Salary",EightyFiveNet,AmountToDeduct);
                                                                EightyFiveNet:=EightyFiveNet-AmountToDeduct;
                                                                "Recommended Amount":=EightyFiveNet;
                                                                "Recovery Mode":="Recovery Mode"::Salary;
                                                                END;
                                                                END;

                                                                //get account type comparison
                                                                IF LoanType.GET("Loan Product Type") THEN BEGIN
                                                                IF LoanType."Attached Accounts" <> '' THEN BEGIN
                                                                  Vend.RESET;
                                                                  Vend.SETRANGE(Vend."No.",Loan."Account No");
                                                                  IF Vend.FINDSET THEN BEGIN
                                                                    IF Vend."Account Type"<>LoanType."Attached Accounts" THEN
                                                                      MESSAGE('member does not have the account type %1 ',LoanType."Attached Accounts");

                                                                    END;

                                                                  END;
                                                                  END;
                                                                //Check Same product type
                                                                Loan.RESET;
                                                                Loan.SETRANGE(Loan."Client Code","Client Code");
                                                                Loan.SETRANGE(Loan."Loan Product Type","Loan Product Type");
                                                                Loan.SETRANGE(Loan.Posted,TRUE);
                                                                IF Loan. FIND('-') THEN BEGIN
                                                                   REPEAT
                                                                     IF "Offset Loan" = FALSE THEN
                                                                    Loan.CALCFIELDS(Loan."Outstanding Balance",Loan."Oustanding Interest");
                                                                IF (Loan."Outstanding Balance" > 1) OR (Loan."Oustanding Interest" > 1)   THEN //BEGIN
                                                                ERROR('This member has the same product type with balance %1,%2',Loan."Outstanding Balance",Loan."Oustanding Interest");
                                                                //END;

                                                                UNTIL Loan.NEXT = 0;

                                                                END;
                                                                //End Check Same product type
                                                                // Register.RESET;
                                                                // Register.SETRANGE(Register."Client Code","Client Code");
                                                                //Register.SETRANGE(Register."Loan Product Type","Loan Product Type");
                                                                //Register.SETFILTER(Register."Outstanding Balance",'>0');
                                                                //IF Register.FIND('-') THEN BEGIN
                                                                // ERROR('The client has an existing loan of the same product.');
                                                                // END;


                                                                //Check Same product type
                                                                {Loan.RESET;
                                                                Loan.SETRANGE(Loan."Client Code","Client Code");
                                                                Loan.SETRANGE(Loan."Offset Loan",FALSE);
                                                                Loan.SETRANGE(Loan."Loan Product Type","Loan Product Type");
                                                                Loan.SETRANGE(Loan.Posted,TRUE);
                                                                IF Loan. FIND('-') THEN BEGIN

                                                                  REPEAT
                                                                    Loan.CALCFIELDS(Loan."Outstanding Balance",Loan."Oustanding Interest");
                                                                IF (Loan."Outstanding Balance" > 1) OR (Loan."Oustanding Interest" > 1) THEN BEGIN
                                                                ERROR('This member has the same product type with balance %1,%2',Loan."Outstanding Balance",Loan."Oustanding Interest");
                                                                END;

                                                                UNTIL Loan.NEXT = 0;

                                                                END;}
                                                                //End Check Same product type


                                                                IF LoanType.GET("Loan Product Type") THEN BEGIN
                                                                  "Loan Product Type Name":=LoanType."Product Description";

                                                                  IF "Loan Product Type Name"='Normal Loan ' THEN
                                                                      LoantypeCode:='72';
                                                                   IF "Loan Product Type Name"='Normal Loan 1 ' THEN
                                                                       LoantypeCode:='72';

                                                                  IF "Loan Product Type Name"='Emergency Loan' THEN
                                                                       LoantypeCode:='7G';

                                                                   IF "Loan Product Type Name"='ESS Loan' THEN
                                                                       LoantypeCode:='7E';

                                                                   IF "Loan Product Type Name"='Instant Loan' THEN
                                                                       LoantypeCode:='BA';

                                                                     IF "Loan Product Type Name"=' Okoa Loan' THEN
                                                                       LoantypeCode:='BB';

                                                                     IF "Loan Product Type Name"='Reloaded Plus' THEN
                                                                       LoantypeCode:='BB';

                                                                     IF "Loan Product Type Name"='Salary Advance ' THEN
                                                                      LoantypeCode:='';
                                                                   IF "Loan Product Type Name"='Electricity Advance ' THEN
                                                                       LoantypeCode:='';

                                                                  IF "Loan Product Type Name"='FDA Advance Loan' THEN
                                                                       LoantypeCode:='';

                                                                   IF "Loan Product Type Name"='Golden Age Advance Loan' THEN
                                                                       LoantypeCode:='';

                                                                   IF "Loan Product Type Name"='Consumer Loan-FOSA' THEN
                                                                       LoantypeCode:='';

                                                                     IF "Loan Product Type Name"=' Insurance Loan' THEN
                                                                       LoantypeCode:='';

                                                                     IF "Loan Product Type Name"='DEFAULTER LOAN' THEN
                                                                       LoantypeCode:='';
                                                                       IF "Loan Product Type Name"='Development Loan' THEN
                                                                       LoantypeCode:='';

                                                                     IF "Loan Product Type Name"='Salary Advance Bosa' THEN
                                                                       LoantypeCode:='';

                                                                     IF "Loan Product Type Name"='Consumer Loan-BOSA' THEN
                                                                       LoantypeCode:='';

                                                                     IF "Loan Product Type Name"=' Medical Advance Loan' THEN
                                                                       LoantypeCode:='';

                                                                   IF "Loan Product Type Name"='Car Overhaul' THEN
                                                                       LoantypeCode:='';

                                                                     IF "Loan Product Type Name"='Car Loan' THEN
                                                                       LoantypeCode:='';

                                                                     IF "Loan Product Type Name"='Education Loan' THEN
                                                                       LoantypeCode:='';
                                                                       IF "Loan Product Type Name"='Super Loan' THEN
                                                                       LoantypeCode:='';

                                                                     IF "Loan Product Type Name"='Golden Age Advantage' THEN
                                                                       LoantypeCode:='';

                                                                     IF "Loan Product Type Name"='Consumer Loan 2015' THEN
                                                                       LoantypeCode:='';

                                                                     IF "Loan Product Type Name"=' Jijenge Loan' THEN
                                                                       LoantypeCode:='';

                                                                     IF "Loan Product Type Name"='Dormant Loans' THEN
                                                                       LoantypeCode:='';

                                                                     IF "Loan Product Type Name"='Staff Development Loan' THEN
                                                                       LoantypeCode:='';

                                                                     IF "Loan Product Type Name"='Staff house Loan' THEN
                                                                       LoantypeCode:='';

                                                                     IF "Loan Product Type Name"='Guarantor Loan' THEN
                                                                       LoantypeCode:='';

                                                                 MODIFY;

                                                                  //IF "Requested Amount" > 100000 THEN BEGIN
                                                                  //Interest:=LoanType."Interest rate";
                                                                  ///END ELSE BEGIN

                                                                   Interest:=LoanType."Interest rate";
                                                                   "interest upfront1":=LoanType."Interest upfront";

                                                                  //END;
                                                                  "Instalment Period":=LoanType."Instalment Period";
                                                                  "Grace Period":=LoanType."Grace Period";
                                                                  "Grace Period - Principle (M)":=LoanType."Grace Period - Principle (M)";
                                                                  "Grace Period - Interest (M)":=LoanType."Grace Period - Interest (M)";
                                                                  "Loan to Share Ratio":=LoanType."Loan to Share Ratio";
                                                                  "Staff Loan":=LoanType."Staff Loan";
                                                                  "Interest Calculation Method":=LoanType."Interest Calculation Method";
                                                                  "Repayment Method":=LoanType."Repayment Method";
                                                                  "Product Currency Code":=LoanType."Product Currency Code";
                                                                   Installments:=LoanType."Default Installements";
                                                                  "Max. Installments":=LoanType."No of Installment";
                                                                  "Max. Loan Amount":=LoanType."Max. Loan Amount";
                                                                  "Repayment Frequency":=LoanType."Repayment Frequency";


                                                                 //Where repayment is by employer

                                                                  IF LoanType."Use Cycles" = FALSE THEN BEGIN
                                                                  "Loan Cycle":=0;
                                                                  "Max. Installments":=LoanType."No of Installment";
                                                                  "Max. Loan Amount":=LoanType."Max. Loan Amount";
                                                                  Installments:=LoanType."Default Installements";
                                                                  "Product Code":=LoanType."Source of Financing";
                                                                  "Paying Bank Account No":=LoanType."BacK Code";

                                                                  END;

                                                                  IF LoanType."Use Cycles" = TRUE THEN BEGIN
                                                                  LoanApp.RESET;
                                                                  LoanApp.SETRANGE(LoanApp."Client Code","Client Code");
                                                                  LoanApp.SETRANGE(LoanApp."Loan Product Type","Loan Product Type");
                                                                  //LoanApp.SETRANGE(LoanApp.Posted,TRUE);
                                                                  IF LoanApp.FIND('-') THEN
                                                                  MemberCycle:=LoanApp.COUNT + 1
                                                                  ELSE
                                                                  MemberCycle:=1;



                                                                  ProdCycles.RESET;
                                                                  ProdCycles.SETRANGE(ProdCycles."Product Code","Loan Product Type");
                                                                  IF ProdCycles.FIND('-') THEN BEGIN
                                                                  REPEAT
                                                                  IF MemberCycle=ProdCycles.Cycle THEN BEGIN
                                                                  "Loan Cycle":=ProdCycles.Cycle;
                                                                  "Max. Installments":=ProdCycles."Max. Installments";
                                                                  "Max. Loan Amount":=ProdCycles."Max. Amount";
                                                                  Installments:=ProdCycles."Max. Installments";
                                                                  END;
                                                                  UNTIL ProdCycles.NEXT = 0;
                                                                  IF "Loan Cycle"= 0 THEN BEGIN
                                                                  "Loan Cycle":=ProdCycles.Cycle;
                                                                  "Max. Installments":=ProdCycles."Max. Installments";
                                                                  "Max. Loan Amount":=ProdCycles."Max. Amount";
                                                                  Installments:=ProdCycles."Max. Installments";




                                                                  END;
                                                                  END;


                                                                  END;
                                                                END;

                                                                EXIT;

                                                                //Loan Repayments

                                                                LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."Client Code","Client Code");
                                                                LoanApp.SETFILTER("Loan Product Type",'<>%1','DIV ADV');//// To Exclude DIV ADV Loan Product
                                                                //LoanApp.SETFILTER("Loan Product Type",'<>%1','MSADV');
                                                                IF LoanApp.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                LoanApp.CALCFIELDS(LoanApp."Outstanding Balance");
                                                                IF (LoanApp."Outstanding Balance">0)  THEN  BEGIN
                                                                IF LoanApp."Outstanding Balance" < LoanApp."Loan Principle Repayment" THEN BEGIN

                                                                //MonthlyRepayT:=MonthlyRepayT+(LoanApp."Loan Principle Repayment"+LoanApp."Loan Interest Repayment");

                                                                END ELSE BEGIN

                                                                //MonthlyRepayT:=MonthlyRepayT+(LoanApp."Loan Principle Repayment"+LoanApp."Loan Interest Repayment");
                                                                END
                                                                END;
                                                                UNTIL LoanApp.NEXT=0;
                                                                END;
                                                                "Existing Loan Repayments":=MonthlyRepayT;

                                                                //Employer Advice client codes
                                                                CheckoffMatrix.RESET;
                                                                CheckoffMatrix.SETRANGE(CheckoffMatrix."check Interest",FALSE);
                                                                CheckoffMatrix.SETRANGE(CheckoffMatrix."Employer Code","Employer Code");
                                                                CheckoffMatrix.SETRANGE(CheckoffMatrix."Loan Product Code","Loan Product Type");
                                                                IF CheckoffMatrix.FIND('-') THEN BEGIN
                                                                "Emp Loan Codes":=CheckoffMatrix."Check off Code";
                                                                MODIFY;
                                                                END;


                                                                IF MembX.GET("Client Code") THEN BEGIN
                                                                IF MembX."Loan Defaulter"=TRUE THEN BEGIN
                                                                ERROR('Member has defaulted mobile Loan.');
                                                                END;

                                                                IF MembX."Registration Date"=0D THEN
                                                                ERROR('Member should have a registration date.');

                                                                IF (TODAY-MembX."Registration Date")<=180 THEN  BEGIN
                                                                //Deposits Check Kitui
                                                                DateSix:=CALCDATE('<-6M>',MembX."Registration Date");
                                                                FnCheckContribution("Client Code",DateSix);
                                                                DateFive:=CALCDATE('<-5M>',TODAY);
                                                                FnCheckContribution("Client Code",DateFive);
                                                                DateFour:=CALCDATE('<-4M>',MembX."Registration Date");
                                                                FnCheckContribution("Client Code",DateFour);
                                                                DateThree:=CALCDATE('<-3M>',MembX."Registration Date");
                                                                FnCheckContribution("Client Code",DateThree);
                                                                DateTwo:=CALCDATE('<-2M>',MembX."Registration Date");
                                                                FnCheckContribution("Client Code",DateTwo);
                                                                DateOne:=CALCDATE('<-1M>',MembX."Registration Date");
                                                                FnCheckContribution("Client Code",DateOne);
                                                                //End Deposits Check
                                                                END;


                                                                IF (TODAY-MembX."Registration Date")>180 THEN  BEGIN
                                                                DateThree:=CALCDATE('<-3M>',TODAY);
                                                                FnCheckContribution("Client Code",DateThree);
                                                                DateTwo:=CALCDATE('<-2M>',TODAY);
                                                                FnCheckContribution("Client Code",DateTwo);
                                                                DateOne:=CALCDATE('<-1M>',TODAY);
                                                                FnCheckContribution("Client Code",DateOne);
                                                                END;
                                                                END;
                                                                MembX.RESET;
                                                                MembX.SETRANGE(MembX."No.","BOSA No");
                                                                IF MembX.FINDFIRST THEN BEGIN
                                                                IF LoanType.GET("Loan Product Type") THEN BEGIN
                                                                IF MembX."Monthly Contribution"<LoanType."Minimum Monthly Contribution" THEN
                                                                ERROR('You mothly deposit contribution of Ksh%1 do not meet the specified minimum contribution Ksh%2 of this product.'
                                                                ,MembX."Monthly Contribution",LoanType."Minimum Monthly Contribution");
                                                                END;
                                                                END;
                                                              END;

                                                   Editable=Yes }
    { 4   ;   ;Client Code         ;Code50        ;TableRelation=IF (Source=CONST(BOSA)) "Members Register".No.
                                                                 ELSE IF (Source=CONST(FOSA)) "Members Register".No.
                                                                 ELSE IF (Source=CONST(MICRO)) "Members Register".No. WHERE (Customer Posting Group=CONST(MICRO));
                                                   OnValidate=VAR
                                                                DoubleLoan@1120054000 : Record 51516230;
                                                                ErrOpen@1120054001 : TextConst 'ENU=An open application, loan no %1 for %2, still exists, complete it before proceeding';
                                                              BEGIN

                                                                MembX.RESET;
                                                                MembX.SETRANGE(MembX."No.","Client Code");
                                                                MembX.SETRANGE(MembX.Status,MembX.Status::Dormant);
                                                                IF MembX.FINDFIRST THEN BEGIN
                                                                ERROR('Member is dormant.');
                                                                END;

                                                                // MembX.RESET;
                                                                // MembX.SETRANGE(MembX."No.","Client Code");
                                                                // MembX.SETRANGE(MembX."Loan Defaulter",TRUE);
                                                                // IF MembX.FINDFIRST THEN BEGIN
                                                                // ERROR('Member is a loan defaulter.');
                                                                // END;//Kit

                                                                MobileLoanAnalysis.RESET;
                                                                MobileLoanAnalysis.SETRANGE(MobileLoanAnalysis."Member No","Client Code");
                                                                MobileLoanAnalysis.SETFILTER(MobileLoanAnalysis."Next Loan Application Date",'<>%1',0D);
                                                                MobileLoanAnalysis.SETRANGE(MobileLoanAnalysis."Deposits Refunded",FALSE);
                                                                IF MobileLoanAnalysis.FINDFIRST THEN BEGIN
                                                                    REPEAT
                                                                        IF MobileLoanAnalysis."Next Loan Application Date" > TODAY THEN
                                                                            ERROR('Member Defaulted Mobile Loan. Next Loan Application Date is %1',MobileLoanAnalysis."Next Loan Application Date");
                                                                    UNTIL MobileLoanAnalysis.NEXT=0;
                                                                END;


                                                                DoubleLoan.RESET;
                                                                DoubleLoan.SETRANGE("Captured By",USERID);
                                                                DoubleLoan.SETRANGE("Loan Status",DoubleLoan."Loan Status"::Application);
                                                                DoubleLoan.SETFILTER("Client Code",'=%1',"Client Code");
                                                                IF DoubleLoan.FINDLAST THEN
                                                                  IF DoubleLoan."Client Code"<>'' THEN
                                                                   ERROR(ErrOpen,DoubleLoan."Loan  No.","Client Code");


                                                                {LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."Client Code","Client Code");
                                                                LoanApp.SETFILTER(LoanApp."Loans Category",'Loss');
                                                                IF(LoanApp.FIND('-')) THEN REPEAT
                                                                IF LoanApp."Loans Category"=LoanApp."Loans Category"::Loss THEN
                                                                ERROR('Member has Aloan which is in Loss- %1',LoanApp."Loan  No.");
                                                                 //currentShares:=currentShares+Cust2.Amount;
                                                                 UNTIL LoanApp.NEXT=0;}
                                                                 //LoanApp.INIT;
                                                                {LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."Client Code","Client Code");
                                                                LoanApp.SETFILTER(LoanApp."Loans Category",'Substandard');
                                                                IF(LoanApp.FIND('-')) THEN REPEAT
                                                                IF LoanApp."Loans Category"=LoanApp."Loans Category"::Substandard THEN
                                                                ERROR('Member has Aloan which is substandard- %1',LoanApp."Loan  No.");
                                                                 //currentShares:=currentShares+Cust2.Amount;
                                                                 UNTIL LoanApp.NEXT=0;}
                                                                  //LoanApp.INIT;
                                                                {LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."Client Code","Client Code");
                                                                LoanApp.SETFILTER("Outstanding Balance",'>0');
                                                                LoanApp.SETFILTER("Loans Category-SASRA",'<>%1&<>%2',LoanApp."Loans Category-SASRA"::Perfoming,LoanApp."Loans Category-SASRA"::Watch);
                                                                ///  LoanApp."Loans Category",'Doubtful');
                                                                IF LoanApp.FINDSET THEN REPEAT
                                                                      ERROR('Member has Aloan which is %1',FORMAT(LoanApp."Loans Category-SASRA")+' '+LoanApp."Loan  No.");
                                                                   //currentShares:=currentShares+Cust2.Amount;
                                                                 UNTIL LoanApp.NEXT=0;}//Kit

                                                                 {LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."Client Code","Client Code");
                                                                LoanApp.SETRANGE(LoanApp.Posted,TRUE);
                                                                IF LoanApp.FIND('-') THEN BEGIN
                                                                 IF "Loans Category"<> LoanApp."Loans Category"::Perfoming
                                                                    THEN BEGIN
                                                                      ERROR:='The member is a defaulter' +'. '+ 'Loan No' + ' '+LoanApp."Loan  No."+' ' + 'is in loan category' +' '+
                                                                FORMAT(LoanApp."Loans Category");
                                                                END;
                                                                END;}
                                                                //Jonah-new sacco
                                                                //credit policy assessment-check if member is a defaulter
                                                                {LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."Client Code","Client Code");
                                                                LoanApp.SETRANGE(LoanApp.Posted,TRUE);
                                                                IF LoanApp.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                LoanApp.CALCFIELDS(LoanApp."Outstanding Balance");
                                                                IF LoanApp."Outstanding Balance">0 THEN BEGIN
                                                                IF (LoanApp."Loans Category"=LoanApp."Loans Category"::Substandard) OR
                                                                (LoanApp."Loans Category"=LoanApp."Loans Category"::Doubtful) OR (LoanApp."Loans Category"=LoanApp."Loans Category"::Loss)
                                                                THEN BEGIN

                                                                IF NOT (USERID='TELEPOST\GOMINDE') OR (USERID='TELEPOST\MNDEKEI') OR (USERID='TELEPOST\Administrator') THEN
                                                                ERROR:='The member is a defaulter' +'. '+ 'Loan No' + ' '+LoanApp."Loan  No."+' ' + 'is in loan category' +' '+
                                                                FORMAT(LoanApp."Loans Category");
                                                                END;
                                                                END;
                                                                UNTIL LoanApp.NEXT=0;
                                                                END;}
                                                                //

                                                                GenSetUp.GET(0);

                                                                "BOSA No":="Client Code";
                                                                "Phone No.":=Cust."Phone No.";
                                                                Workstation:=Cust.Station;
                                                                "Employer Code":=Cust."Employer Code";
                                                                "Registration Time":=TIME;
                                                                LoansClearedSpecial.RESET;
                                                                LoansClearedSpecial.SETRANGE(LoansClearedSpecial."Loan No.","Loan  No.");
                                                                IF LoansClearedSpecial.FIND('-') THEN
                                                                LoansClearedSpecial.DELETEALL;

                                                                IF "Client Code" = '' THEN
                                                                "Client Name":='';




                                                                {
                                                                IF CustomerRecord.GET("Client Code") THEN BEGIN
                                                                "Monthly Shares Cont":=CustomerRecord."Monthly Contribution";
                                                                "Insurance On Shares":=CustomerRecord."Insurance on Shares";
                                                                MODIFY;
                                                                END;
                                                                }
                                                                //check if member account active

                                                                IF CustomerRecord.GET("Client Code") THEN BEGIN
                                                                CustomerRecord.CALCFIELDS(CustomerRecord."Front Side ID",CustomerRecord."Back Side ID");
                                                                IF CustomerRecord.Status<>CustomerRecord.Status::Active THEN
                                                                ERROR('Member %1 account not active',"Client Code");
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
                                                                IF CustomerRecord."FOSA Account"='' THEN
                                                                ERROR('Member Has no FOSA Account.');
                                                                IF CustomerRecord.Pin='' THEN
                                                                ERROR('Member Has no KRA Pin');
                                                                CustomerRecord.TESTFIELD("Phone No.");
                                                                END;

                                                                //end check if member account active

                                                                //check withdrawal case

                                                                IF CustomerRecord.GET("Client Code") THEN BEGIN
                                                                   CustomerRecord.TESTFIELD(CustomerRecord.Pin);
                                                                IF CustomerRecord.Status=CustomerRecord.Status::"Awaiting Withdrawal" THEN
                                                                ERROR('Member %1 is awaiting withdrawal and cannot apply for a new loan',"Client Code");
                                                                END;

                                                                //end check withdrawal case

                                                                IF CustomerRecord.GET("Client Code") THEN BEGIN
                                                                IF CustomerRecord.Blocked=CustomerRecord.Blocked::All THEN
                                                                ERROR('Member is blocked from transacting ' + "Client Code");
                                                                {IF CustomerRecord."Loan Defaulter"=TRUE THEN BEGIN
                                                                Lregister.RESET;
                                                                Lregister.SETRANGE(Lregister."Staff No",CustomerRecord."Payroll/Staff No");
                                                                Lregister.SETFILTER(Lregister."Loans Category",'%1|%2|%3',Lregister."Loans Category"::Loss,Lregister."Loans Category"::Doubtful,Lregister."Loans Category"::Substandard);
                                                                IF Lregister.FINDFIRST THEN
                                                                ERROR('This member has defaulted loan %1 and thus blocked from applying a loan.',Lregister."Loan  No.");
                                                                END;}
                                                                IF CustomerRecord.GET("Client Code") THEN BEGIN
                                                                IF CustomerRecord.Status<>CustomerRecord.Status::Active THEN
                                                                ERROR('Member is not Active ' + "Client Code");
                                                                END;
                                                                //IF CustomerRecord."Loan Defaulter"=TRUE THEN
                                                                //ERROR('This member is a loan defaulter and thus blocked from applying a loan.');

                                                                IF Source = Source::BOSA THEN BEGIN
                                                                //CustomerRecord.TESTFIELD(CustomerRecord."ID No.");
                                                                CustomerRecord.TESTFIELD(CustomerRecord.Pin);
                                                                CustomerRecord.TESTFIELD(CustomerRecord."Employer Code");
                                                                CustomerRecord.ValidateDateOfBirth;
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                Cust.CALCFIELDS(Cust."Current Shares");
                                                                sHARES:=Cust."Current Shares"*-1;
                                                                {IF sHARES=0 THEN
                                                                ERROR(Text012);}
                                                                END;
                                                                END;

                                                                IF CustomerRecord."Registration Date" <> 0D THEN BEGIN
                                                                IF CALCDATE(GenSetUp."Min. Loan Application Period",CustomerRecord."Registration Date") > TODAY THEN
                                                                ERROR('Member is less than six months old therefor not eligible for loan application.');
                                                                END;



                                                                CustomerRecord.CALCFIELDS(CustomerRecord."Current Shares",CustomerRecord."Outstanding Balance",
                                                                CustomerRecord."Current Loan");
                                                                //check mandatories
                                                                  CustomerRecord.TESTFIELD(CustomerRecord.Name);
                                                                  CustomerRecord.TESTFIELD(CustomerRecord."ID No.");
                                                                  CustomerRecord.TESTFIELD(CustomerRecord.Picture);
                                                                  CustomerRecord.TESTFIELD(CustomerRecord.Signature);
                                                                  CustomerRecord.ValidateDateOfBirth;
                                                                //end of check
                                                                "Client Name":=CustomerRecord.Name;
                                                                "Employer Code":=CustomerRecord."Employer Code";
                                                                "Shares Balance":=CustomerRecord."Current Shares";
                                                                Savings:=CustomerRecord."Current Shares";
                                                                "Existing Loan":=CustomerRecord."Outstanding Balance";
                                                                "Account No":=CustomerRecord."FOSA Account";
                                                                "Staff No":=CustomerRecord."Payroll/Staff No";
                                                                Gender:=CustomerRecord.Gender;
                                                                "ID NO":=CustomerRecord."ID No.";
                                                                "Member Deposits":=CustomerRecord."Current Shares";
                                                                "Phone No.":=CustomerRecord."Phone No.";
                                                                "Monthly Contribution":=CustomerRecord."Monthly Contribution";
                                                                Designation:=CustomerRecord.Designation;
                                                                Workstation:=CustomerRecord.Station;
                                                                "Terms of Service":=CustomerRecord."Terms of Service";

                                                                "Branch Code":=CustomerRecord."Global Dimension 2 Code";
                                                                IF ("Loan Product Type" <> 'DFTL FOSA') AND ("Loan Product Type" <> 'DFTL') THEN BEGIN
                                                                //Check Shares Boosting
                                                                IF "Application Date" <> 0D THEN BEGIN
                                                                {CustLedg.RESET;
                                                                CustLedg.SETRANGE(CustLedg."Customer No.","Client Code");
                                                                CustLedg.SETRANGE(CustLedg."Transaction Type",CustLedg."Transaction Type"::"Deposit Contribution");
                                                                CustLedg.SETRANGE(CustLedg.Reversed,FALSE);
                                                                IF CustLedg.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                IF CustLedg."Posting Date" > CALCDATE(GenSetUp."Boosting Shares Maturity (M)","Application Date") THEN BEGIN
                                                                CustLedg.CALCFIELDS(CustLedg.Amount);
                                                                IF ABS(CustLedg.Amount)>
                                                                (((CustomerRecord."Monthly Contribution"*GenSetUp."Boosting Shares %")*0.01)) THEN BEGIN
                                                                "Shares Boosted":=TRUE;
                                                                END;
                                                                END;
                                                                UNTIL CustLedg.NEXT = 0;
                                                                END;
                                                                }
                                                                END;
                                                                END;

                                                                //END;

                                                                END;
                                                                {
                                                                CALCFIELDS("Total Loans Outstanding");
                                                                TotalOutstanding:="Total Loans Outstanding"+"Requested Amount";
                                                                IF BANDING.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                IF (TotalOutstanding>=BANDING."Minimum Amount") AND (TotalOutstanding<=BANDING."Maximum Amount") THEN BEGIN
                                                                Band:=BANDING."Minimum Dep Contributions";
                                                                "Min Deposit As Per Tier":=Band;
                                                                MODIFY;
                                                                END;
                                                                UNTIL BANDING.NEXT=0;
                                                                END;
                                                                }
                                                                //Block if loan Previously recovered from gurantors
                                                                LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."BOSA No","BOSA No");
                                                                LoanApp.SETRANGE("Recovered From Guarantor",TRUE);
                                                                IF LoanApp.FIND('-') THEN
                                                                ERROR('Member has a loan which has previously been recovered from gurantors. - %1',LoanApp."Loan  No.");

                                                                //Block if loan Previously recovered from gurantors
                                                                 //SURESTEP MICRO CREDIT
                                                                IF Source=Source::MICRO THEN BEGIN
                                                                Cust.RESET;
                                                                Cust.SETRANGE(Cust."No.","Client Code");
                                                                Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::MicroFinance);
                                                                IF Cust.FIND('-')= FALSE THEN
                                                                ERROR('Sorry selected Member is not a micro member');
                                                                END ELSE
                                                                "Group Code":=Cust."Group Code";
                                                                  //SURESTEP MICRO CREDIT

                                                                IF MembX.GET("Client Code") THEN BEGIN
                                                                IF MembX."Registration Date"=0D THEN
                                                                ERROR('Member should have a registration date.');

                                                                IF (TODAY-MembX."Registration Date")<=180 THEN  BEGIN
                                                                //Deposits Check Kitui
                                                                DateSix:=CALCDATE('<-6M>',MembX."Registration Date");
                                                                FnCheckContribution("Client Code",DateSix);
                                                                DateFive:=CALCDATE('<-5M>',TODAY);
                                                                FnCheckContribution("Client Code",DateFive);
                                                                DateFour:=CALCDATE('<-4M>',MembX."Registration Date");
                                                                FnCheckContribution("Client Code",DateFour);
                                                                DateThree:=CALCDATE('<-3M>',MembX."Registration Date");
                                                                FnCheckContribution("Client Code",DateThree);
                                                                DateTwo:=CALCDATE('<-2M>',MembX."Registration Date");
                                                                FnCheckContribution("Client Code",DateTwo);
                                                                DateOne:=CALCDATE('<-1M>',MembX."Registration Date");
                                                                FnCheckContribution("Client Code",DateOne);
                                                                //End Deposits Check
                                                                END;


                                                                IF (TODAY-MembX."Registration Date")>180 THEN  BEGIN
                                                                DateThree:=CALCDATE('<-3M>',TODAY);
                                                                FnCheckContribution("Client Code",DateThree);
                                                                DateTwo:=CALCDATE('<-2M>',TODAY);
                                                                FnCheckContribution("Client Code",DateTwo);
                                                                DateOne:=CALCDATE('<-1M>',TODAY);
                                                                FnCheckContribution("Client Code",DateOne);
                                                                END;
                                                                END;

                                                                LoanOffsetDetail.RESET;
                                                                LoanOffsetDetail.SETRANGE(LoanOffsetDetail."Loan No.","Loan  No.");
                                                                IF LoanOffsetDetail.FINDSET THEN BEGIN
                                                                LoanOffsetDetail.DELETEALL;
                                                                END;

                                                                LGuarantee.RESET;
                                                                LGuarantee.SETRANGE(LGuarantee."Loan No","Loan  No.");
                                                                IF LGuarantee.FINDSET THEN BEGIN
                                                                LGuarantee.DELETEALL;
                                                                END;
                                                              END;
                                                               }
    { 5   ;   ;Group Code          ;Code20         }
    { 6   ;   ;Savings             ;Decimal       ;Editable=No }
    { 7   ;   ;Existing Loan       ;Decimal       ;Editable=No }
    { 8   ;   ;Requested Amount    ;Decimal       ;OnValidate=BEGIN
                                                                LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."Client Code","Client Code");
                                                                LoanApp.SETAUTOCALCFIELDS(LoanApp."Outstanding Balance");
                                                                LoanApp.SETFILTER(LoanApp."Outstanding Balance",'>%1',0);
                                                                LoanApp.SETFILTER(LoanApp."Loans Category",'%1|%2|%3',LoanApp."Loans Category"::Doubtful,LoanApp."Loans Category"::Substandard,LoanApp."Loans Category"::Loss);
                                                                IF LoanApp.FINDFIRST THEN BEGIN
                                                                REPEAT
                                                                MESSAGE('This member has defaulted loan %1',LoanApp."Loan  No.");
                                                                LoanOffsetDetails.RESET;
                                                                LoanOffsetDetails.SETRANGE(LoanOffsetDetails."Loan No.","Loan  No.");
                                                                LoanOffsetDetails.SETRANGE(LoanOffsetDetails."Loan Top Up",LoanApp."Loan  No.");
                                                                IF NOT LoanOffsetDetails.FINDFIRST THEN BEGIN
                                                                ERROR('This member is a defaulter.The defaulted loan needs to be offset first.');
                                                                END;
                                                                UNTIL LoanApp.NEXT=0;
                                                                END;

                                                                LoanOffsetDetail.RESET;
                                                                LoanOffsetDetail.SETRANGE(LoanOffsetDetail."Loan No.","Loan  No.");
                                                                IF NOT LoanOffsetDetail.FINDSET THEN BEGIN
                                                                LoanOffsetDetail.CALCSUMS(LoanOffsetDetail."Total Top Up");
                                                                OffsetAmount:=LoanOffsetDetail."Total Top Up";
                                                                END;
                                                                IF "Requested Amount"<OffsetAmount THEN
                                                                ERROR('Requested amount should be greater than the amount to be offset.');
                                                                //"Approved Amount":="Requested Amount";
                                                                //"Net Payment to FOSA":="Requested Amount";

                                                                //VALIDATE("Approved Amount");

                                                                IF ProdSetup.GET("Loan Product Type") THEN BEGIN
                                                                  //IF ProdSetup."Max. Loan Amount"> 0 THEN BEGIN
                                                                    IF "Requested Amount"> ProdSetup."Max. Loan Amount" THEN
                                                                      ERROR('You can not request more than product max loan amount %1',ProdSetup."Max. Loan Amount");
                                                                    //"Requested Amount":=ProdSetup."Max. Loan Amount";
                                                                 // END;
                                                                END;

                                                                IF "Loan Product Type"='A15' THEN BEGIN
                                                                IF "Requested Amount">"Recommended Amount" THEN
                                                                ERROR('Requested amount should not be more than recommended amount.');
                                                                END;


                                                                "Approved Amount":="Requested Amount";
                                                                "Recommended Amount" :="Requested Amount";
                                                                "Net Payment to FOSA":="Requested Amount";
                                                                "Loan Principle Repayment":=ROUND(("Approved Amount"/Installments),0.01,'>');
                                                                "Loan Interest Repayment":=ROUND((Interest/100*"Approved Amount"),0.01,'>');

                                                                CALCFIELDS("Total Loans Outstanding");
                                                                TotalOutstanding:="Total Loans Outstanding"+"Requested Amount";
                                                                IF BANDING.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                IF (TotalOutstanding>=BANDING."Minimum Amount") AND (TotalOutstanding<=BANDING."Maximum Amount") THEN BEGIN
                                                                Band:=BANDING."Minimum Dep Contributions";
                                                                "Min Deposit As Per Tier":=Band;
                                                                MODIFY;
                                                                END;
                                                                UNTIL BANDING.NEXT=0;
                                                                END;

                                                                //Repayments for amortised method''
                                                                //Repayments for reducing balance method
                                                                {IF ("Repayment Method"="Repayment Method"::"Reducing Balance") THEN BEGIN
                                                                  LoanExemptInterest.RESET;
                                                                  LoanExemptInterest.SETRANGE(LoanExemptInterest."Loan Product","Loan Product Type");
                                                                  IF NOT LoanExemptInterest.FINDFIRST THEN
                                                                    BEGIN
                                                                      TESTFIELD(Interest);
                                                                      //IF ("Loan Product Type"<>'L05') THEN BEGIN//OR ("Loan Product Type"<>'L07')THEN BEGIN
                                                                    END;
                                                                    LoanAmount:="Approved Amount";
                                                                    RepayPeriod:=Installments;
                                                                TESTFIELD(Installments);
                                                                LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
                                                                LInterest:=ROUND((InterestRate/12/100)*LBalance,0.05,'>');
                                                                Repayment:=LPrincipal+LInterest;
                                                                NewSchedule."Principal Repayment":=LPrincipal;
                                                                NewSchedule."Monthly Interest":=LInterest;
                                                                END;}

                                                                {IF "Repayment Method"="Repayment Method"::Amortised THEN BEGIN
                                                                //TESTFIELD(Interest);
                                                                //TESTFIELD(Installments);

                                                                TotalMRepay:=(InterestRate/12/100) / (1 - POWER((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount;
                                                                LInterest:=LBalance / 100 / 12 * InterestRate;


                                                                LPrincipal:=TotalMRepay-LInterest;
                                                                NewSchedule."Principal Repayment":=LPrincipal;
                                                                NewSchedule."Monthly Interest":=LInterest;

                                                                //Insuarence:=0.0001667*LoanAmount;
                                                                Repayment:=TotalMRepay;
                                                                END;}
                                                                //End Repayments for amortised met

                                                                IF "Loan Product Type"='A17' THEN
                                                                BEGIN
                                                                Vendors.RESET;
                                                                Vendors.SETRANGE(Vendors."Staff No","Staff No");
                                                                Vendors.SETRANGE(Vendors."Account Type",'JIBAMBE HOLIDAY');
                                                                IF Vendors.FINDFIRST THEN BEGIN
                                                                LoanProdType.GET("Loan Product Type");
                                                                Vendors.CALCFIELDS(Balance);
                                                                IF (LoanProdType."Shares Multiplier"*Vendors.Balance)>"Requested Amount" THEN
                                                                ERROR('The maximum accepted amount is %1',(LoanProdType."Shares Multiplier"*Vendors.Balance));
                                                                END;
                                                                END;


                                                                IF "Loan Product Type"='A18' THEN
                                                                BEGIN
                                                                Vendors.RESET;
                                                                Vendors.SETRANGE(Vendors."Staff No","Staff No");
                                                                Vendors.SETRANGE(Vendors."Account Type",'FOSA SAVINGS');
                                                                IF Vendors.FINDFIRST THEN BEGIN
                                                                LoanProdType.GET("Loan Product Type");
                                                                Vendors.CALCFIELDS(Balance);
                                                                IF Vendors.Balance>"Requested Amount" THEN
                                                                ERROR('The maximum accepted amount is %1',Vendors.Balance);
                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 9   ;   ;Approved Amount     ;Decimal       ;OnValidate=BEGIN


                                                                {IF "Max. Loan Amount" <> 0 THEN BEGIN
                                                                IF "Approved Amount" > "Max. Loan Amount" THEN
                                                                ERROR('Approved amount cannot be greater than the maximum amount. %1',"Loan  No.");
                                                                END;

                                                                IF "Approved Amount" > "Requested Amount" THEN
                                                                ERROR('Approved amount must not be more than the requested amount. %1',"Loan  No.");

                                                                IF "Loan Status" <>"Loan Status"::Application THEN BEGIN
                                                                //Approved must not be more than requested amount
                                                                IF "Approved Amount" > "Requested Amount" THEN
                                                                ERROR('Approved amount must not be more than the requested amount. %1',"Loan  No.");

                                                                //Recommended must not be more than requested amount
                                                                IF "Approved Amount" > "Recommended Amount" THEN  BEGIN
                                                                MESSAGE('Approved amount must not be more than the Recommended Amount put remarks. %1',"Loan  No.");
                                                                //TESTFIELD(Remarks);vic
                                                                END;
                                                                //Recommended must not be more than requested amount
                                                                IF "Approved Amount" < "Recommended Amount" THEN  BEGIN
                                                                MESSAGE('Approved amount is less than the Recommended Amount put remarks. %1',"Loan  No.");
                                                                //TESTFIELD(Remarks);vic
                                                                END;
                                                                 END;}
                                                                IF "Loan Product Type"='A15' THEN BEGIN
                                                                IF "Approved Amount" > "Recommended Amount" THEN
                                                                MESSAGE('Approved amount must not be more than the Recommended Amount.',"Loan  No.");
                                                                END;
                                                                IF Source=Source::FOSA THEN BEGIN
                                                                IF "Approved Amount" > "Requested Amount" THEN
                                                                ERROR('Approved amount must not be more than the requested amount. %1',"Loan  No.");
                                                                END;

                                                                //IF Source=Source::BOSA THEN BEGIN
                                                                IF "Approved Amount" > "Recommended Amount" THEN
                                                                ERROR('Approved amount must not be more than the recommended amount. %1',"Loan  No.");
                                                                //END;

                                                                LAppCharges.RESET;
                                                                LAppCharges.SETRANGE(LAppCharges."Loan No","Loan  No.");
                                                                IF LAppCharges.FIND('-') THEN
                                                                LAppCharges.DELETEALL;

                                                                IF "Loan Product Type"= 'SOKO'THEN BEGIN
                                                                //MESSAGE('loan Product is %1',"Loan Product Type");
                                                                PCharges.RESET;
                                                                PCharges.SETRANGE(PCharges."Product Code","Loan Product Type");
                                                                IF PCharges.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                    LAppCharges.INIT;
                                                                    LAppCharges."Loan No":="Loan  No.";
                                                                    LAppCharges.Code:=PCharges.Code;
                                                                    LAppCharges.Description:=PCharges.Description;
                                                                    LAppCharges."Use Perc":=PCharges."Use Perc";
                                                                    LAppCharges."Perc (%)":=PCharges.Percentage;
                                                                    IF PCharges."Use Perc" = TRUE THEN
                                                                    LAppCharges.Amount:=("Approved Amount" * PCharges.Percentage/100)*(Installments/12)
                                                                    ELSE
                                                                    LAppCharges.Amount:=PCharges.Amount;
                                                                    LAppCharges."G/L Account":=PCharges."G/L Account";
                                                                    LAppCharges.INSERT;

                                                                UNTIL PCharges.NEXT = 0;
                                                                END;
                                                                END;

                                                                "Flat rate Interest":=0;
                                                                "Flat Rate Principal":=0;
                                                                //Repayment :=0;
                                                                "Total Repayment":=0;

                                                                {IF Installments <= 0 THEN
                                                                ERROR('Number of installments must be greater than Zero.');}



                                                                //
                                                                {TotalMRepay:=0;
                                                                LPrincipal:=0;
                                                                LInterest:=0;
                                                                InterestRate:=Interest;
                                                                LoanAmount:="Approved Amount";
                                                                RepayPeriod:=Installments;
                                                                LBalance:="Approved Amount";}


                                                                {
                                                                //Repayments for amortised method

                                                                IF "Repayment Method"="Repayment Method"::Amortised THEN BEGIN
                                                                //TESTFIELD(Interest);
                                                                //TESTFIELD(Installments);

                                                                TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount,1,'>');
                                                                LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');


                                                                LPrincipal:=TotalMRepay-LInterest;
                                                                "Loan Principle Repayment":=LPrincipal;
                                                                "Loan Interest Repayment":=LInterest;

                                                                //Insuarence:=0.0001667*LoanAmount;
                                                                Repayment:=TotalMRepay;
                                                                END;
                                                                //End Repayments for amortised method
                                                                  }
                                                                {IF "Repayment Method"="Repayment Method"::"Straight Line" THEN BEGIN

                                                                TESTFIELD(Installments);
                                                                LPrincipal:=ROUND(LoanAmount/RepayPeriod,1,'>');
                                                                LInterest:=ROUND((InterestRate/12/100)*LoanAmount,1,'>');
                                                                Insuarence:=0.2*LoanAmount;

                                                                IF ("Loan Product Type"='L05') OR ("Loan Product Type"='L07') THEN
                                                                Repayment:="Approved Amount"/12;

                                                                IF "Loan Product Type"='L17' THEN
                                                                Repayment:="Approved Amount"/84;

                                                                IF LoanAmount>100000 THEN BEGIN
                                                                Repayment:=LPrincipal+LInterest+Insuarence
                                                                END ELSE
                                                                Repayment:=LPrincipal+LInterest;
                                                                NewSchedule."Principal Repayment":=LPrincipal;
                                                                NewSchedule."Monthly Interest":=LInterest;
                                                                END;}

                                                                //SURESTEP
                                                                //Repayments for reducing balance method
                                                                {IF ("Repayment Method"="Repayment Method"::"Reducing Balance") THEN BEGIN
                                                                  LoanExemptInterest.RESET;
                                                                  LoanExemptInterest.SETRANGE(LoanExemptInterest."Loan Product","Loan Product Type");
                                                                  IF NOT LoanExemptInterest.FINDFIRST THEN
                                                                    BEGIN
                                                                      TESTFIELD(Interest);
                                                                      //IF ("Loan Product Type"<>'L05') THEN BEGIN//OR ("Loan Product Type"<>'L07')THEN BEGIN
                                                                    END;}
                                                                {TESTFIELD(Installments);
                                                                // LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
                                                                // LInterest:=ROUND((InterestRate/12/100)*LBalance,0.05,'>');
                                                                Repayment:=LPrincipal+LInterest;
                                                                NewSchedule."Principal Repayment":=LPrincipal;
                                                                NewSchedule."Monthly Interest":=LInterest;
                                                                END;}
                                                                 //SURESTEP


                                                                {IF "Repayment Method"="Repayment Method"::Amortised THEN BEGIN
                                                                //TESTFIELD(Interest);
                                                                //TESTFIELD(Installments);

                                                                TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount,1,'>');
                                                                LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');


                                                                LPrincipal:=TotalMRepay-LInterest;
                                                                NewSchedule."Principal Repayment":=LPrincipal;
                                                                NewSchedule."Monthly Interest":=LInterest;

                                                                "Approved Repayment":="Recommended Amount";

                                                                END;}

                                                                {IF "Approved Amount">"Recommended Amount" THEN
                                                                //ERROR('your recommended is %1',"Recommended Amount");

                                                                  IF LoanType.GET("Loan Product Type") THEN BEGIN//Commented by Kitui zerolising interest when changing installments
                                                                 IF "Approved Amount">100000 THEN BEGIN
                                                                 Interest:=LoanType."Interest Rate-Outstanding >1.5"
                                                                 END ELSE
                                                                Interest:=LoanType."Interest rate";
                                                                 MODIFY;
                                                                END;}


                                                                //VALIDATE("Approved Amount");
                                                              END;

                                                   Editable=Yes }
    { 16  ;   ;Interest            ;Decimal       ;OnValidate=BEGIN
                                                                //VALIDATE(Installments);
                                                              END;
                                                               }
    { 17  ;   ;Insurance           ;Decimal       ;Editable=No }
    { 21  ;   ;Source of Funds     ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                 GLSetup.GET;
                                                                 Dimension:=GLSetup."Shortcut Dimension 3 Code";
                                                              END;
                                                               }
    { 22  ;   ;Client Cycle        ;Integer       ;Editable=No }
    { 26  ;   ;Client Name         ;Text50        ;Editable=No }
    { 27  ;   ;Loan Status         ;Option        ;OnValidate=BEGIN
                                                                {"Date Approved":=TODAY;

                                                                IF "Loan Status" <> "Loan Status"::Approved THEN
                                                                EXIT;

                                                                RepaySched.RESET;
                                                                RepaySched.SETRANGE(RepaySched."Loan No.","Loan  No.");
                                                                IF NOT RepaySched.FIND('-') THEN
                                                                ERROR('Loan Schedule must be generated and confirmed before loan is approved');

                                                                {IF "Account No" = '' THEN BEGIN
                                                                IF CONFIRM('This Applicant does not have FOSA account. Do you wish to proceed?',FALSE)=FALSE THEN
                                                                ERROR('You must specify the FOSA Account No. for this members.');
                                                                END;}




                                                                {//Check STO for Family & Ex Company
                                                                IF "External EFT" = FALSE THEN BEGIN
                                                                IF LoanType.GET("Loan Product Type") THEN BEGIN
                                                                IF LoanType."Check Off Recovery" = TRUE THEN BEGIN
                                                                IF CustomerRecord.GET("BOSA No") THEN BEGIN
                                                                IF Employer.GET(CustomerRecord."Employer Code") THEN BEGIN
                                                                IF Employer."Check Off" = FALSE THEN BEGIN
                                                                RAllocation.RESET;
                                                                RAllocation.SETRANGE(RAllocation."Loan No.","Loan  No.");
                                                                IF RAllocation.FIND('-') THEN BEGIN
                                                                IF "Standing Orders".GET(RAllocation."Document No") THEN BEGIN
                                                                IF "Standing Orders".Status <> "Standing Orders".Status::Active THEN
                                                                ERROR('Standing order No. %1 for this loan must be activated',RAllocation."Document No");
                                                                END;
                                                                END ELSE
                                                                ERROR('You must place a active standing order for this loan for non-check of members.');
                                                                END;
                                                                END;
                                                                END;
                                                                END;
                                                                END;
                                                                }
                                                                  }
                                                              END;

                                                   OptionString=Application,Appraisal,Rejected,Approved,Issued;
                                                   Editable=Yes }
    { 29  ;   ;Issued Date         ;Date           }
    { 30  ;   ;Installments        ;Integer       ;OnValidate=BEGIN
                                                                LoanProdType.GET("Loan Product Type");
                                                                "Max. Installments":=LoanProdType."Default Installements";
                                                                IF Posted <> TRUE THEN BEGIN
                                                                IF Installments > "Max. Installments" THEN
                                                                ERROR('Installments cannot be greater than the maximum installments.');
                                                                END;
                                                                IF Installments <= "Max. Installments" THEN BEGIN
                                                                  Installments:= Installments
                                                                  END;
                                                                IF "Loan Status"="Loan Status"::Appraisal THEN BEGIN
                                                                VALIDATE("Approved Amount");
                                                                END;
                                                                GenSetUp.GET(0);
                                                                IF Cust.GET("Client Code") THEN BEGIN
                                                                IF (Cust."Date of Birth" <> 0D) AND ("Application Date" <> 0D) AND (Installments > 0) THEN BEGIN
                                                                IF CALCDATE(FORMAT(Installments)+'M',"Application Date") > CALCDATE(GenSetUp."Retirement Age",Cust."Date of Birth") THEN
                                                                IF CONFIRM('Member due to retire before loan repayment is complete. Do you wish to continue?') = FALSE THEN BEGIN
                                                                //Installments:=0;
                                                                END;
                                                                END;
                                                                END;

                                                                 //"Expected Date of Completion":=CALCDATE(FORMAT(Installments)+'M',"Issued Date");


                                                                IF "Loan Product Type"='SOKO' THEN BEGIN

                                                                IF Installments=1 THEN
                                                                Interest:=60
                                                                ELSE IF Installments=2 THEN
                                                                Interest:=72
                                                                ELSE IF Installments=3 THEN
                                                                Interest:=84
                                                                ELSE IF Installments=4 THEN
                                                                Interest:=96;

                                                                END;
                                                              END;
                                                               }
    { 34  ;   ;Loan Disbursement Date;Date        ;OnValidate=BEGIN
                                                                "Issued Date":="Loan Disbursement Date";
                                                                "Repayment Start Date":=GetRepaymentStartDate;
                                                                "Expected Date of Completion":=CALCDATE(FORMAT(Installments)+'M',"Repayment Start Date");
                                                                {GenSetUp.GET;
                                                                //
                                                                currYear := DATE2DMY(TODAY,3);
                                                                StartDate := 0D;
                                                                EndDate := 0D;
                                                                Month:=DATE2DMY("Loan Disbursement Date",2);
                                                                DAY:=DATE2DMY("Loan Disbursement Date",1);


                                                                StartDate := DMY2DATE(1, Month, currYear); // StartDate will be the date of the first day of the month

                                                                IF Month=12 THEN BEGIN
                                                                Month:=0;
                                                                currYear:=currYear+1;

                                                                END;


                                                                EndDate := DMY2DATE(1, Month+1, currYear)-1; // EndDate will be the last day of the month



                                                                IF DAY <=15 THEN BEGIN
                                                                "Repayment Start Date":=EndDate;

                                                                END ELSE BEGIN
                                                                "Repayment Start Date":=CALCDATE('1M',EndDate);
                                                                END;}




                                                                {
                                                                StartDate := DMY2DATE(1, Month, currYear); // StartDate will be the date of the first day of the month

                                                                IF Month=12 THEN BEGIN
                                                                Month:=0;
                                                                currYear:=currYear+1;

                                                                END;
                                                                EndDate := DMY2DATE(1, Month+1, currYear)-1; // EndDate will be the last day of the month

                                                                //MESSAGE('%1 %2 %3',Month,currYear,EndDate);
                                                                Mwezikwisha:=CALCDATE('CM',EndDate);

                                                                IF "Loan Disbursement Date">CALCDATE(GenSetUp."Days for Checkoff",StartDate) THEN BEGIN
                                                                   Mwezikwisha:=CALCDATE('1M',EndDate);
                                                                   "Repayment Start Date":=CALCDATE('CM',Mwezikwisha);
                                                                END ELSE

                                                                   Repayment Start Date":=EndDate;

                                                                }

                                                                //"Repayment Start Date":=CALCDATE('<CM>',"Loan Disbursement Date");
                                                                //"Expected Month of completion":=CALCDATE(FORMAT(Installments)+'M',"Repayment start Month");
                                                                 //"Expected Date of Completion":=CALCDATE(FORMAT(Installments)+'M',"Repayment Start Date");

                                                                 //MESSAGE('The month is %1',Month);
                                                              END;
                                                               }
    { 35  ;   ;Mode of Disbursement;Option        ;OnValidate=BEGIN
                                                                IF "Mode of Disbursement"="Mode of Disbursement"::"Transfer to FOSA" THEN BEGIN
                                                                TESTFIELD("Account No");
                                                                END;
                                                              END;

                                                   OptionCaptionML=ENU=" ,Cheque,Transfer To FOSA,EFT,RTGS,Cheque NonMember,FOSA Loans,Individual Cheques,Agency";
                                                   OptionString=[ ,Cheque,Transfer to FOSA,EFT,RTGS,Cheque NonMember,FOSA Loans,Individual Cheques,Agency];
                                                   ValuesAllowed=Transfer to FOSA }
    { 53  ;   ;Affidavit - Item 1 Details;Text50   }
    { 54  ;   ;Affidavit - Estimated Value 1;Decimal }
    { 55  ;   ;Affidavit - Item 2 Details;Text100  }
    { 56  ;   ;Affidavit - Estimated Value 2;Decimal }
    { 57  ;   ;Affidavit - Item 3 Details;Text100  }
    { 58  ;   ;Affidavit - Estimated Value 3;Decimal }
    { 59  ;   ;Affidavit - Item 4 Details;Text100  }
    { 60  ;   ;Affidavit - Estimated Value 4;Decimal }
    { 61  ;   ;Affidavit - Item 5 Details;Text100  }
    { 62  ;   ;Affidavit - Estimated Value 5;Decimal }
    { 63  ;   ;Magistrate Name     ;Text30         }
    { 64  ;   ;Date for Affidavit  ;Date           }
    { 65  ;   ;Name of Chief/ Assistant;Text30     }
    { 66  ;   ;Affidavit Signed?   ;Boolean        }
    { 67  ;   ;Date Approved       ;Date           }
    { 53048;  ;Grace Period        ;DateFormula    }
    { 53049;  ;Instalment Period   ;DateFormula    }
    { 53050;  ;Repayment           ;Decimal       ;OnValidate=BEGIN
                                                                //Repayment:="Approved Amount"/Installments;
                                                                Advice:=TRUE;
                                                                //VALIDATE(Repayment);
                                                                "Previous Repayment":=xRec.Repayment;
                                                                Advice:=TRUE;

                                                                "Previous Repayment":=xRec.Repayment;

                                                                Advice:=TRUE;
                                                                "Advice Type":="Advice Type"::Adjustment;

                                                                IF LoanTypes.GET("Loan Product Type") THEN BEGIN
                                                                IF Cust.GET("Client Code") THEN BEGIN
                                                                Loan."Staff No":=Cust."Payroll/Staff No";

                                                                {DataSheet.INIT;
                                                                DataSheet."PF/Staff No":="Staff No";
                                                                DataSheet."Type of Deduction":=LoanTypes."Product Description";
                                                                DataSheet."Remark/LoanNO":="Loan  No.";
                                                                DataSheet.Name:="Client Name";
                                                                DataSheet."ID NO.":="ID NO";
                                                                DataSheet."Amount ON":=Repayment;
                                                                DataSheet."Amount OFF":=xRec.Repayment;

                                                                DataSheet."REF.":='2026';
                                                                DataSheet."New Balance":="Approved Amount";
                                                                DataSheet.Date:=Loan."Issued Date";
                                                                DataSheet.Date:=TODAY;
                                                                DataSheet.Employer:="Employer Code";
                                                                //DataSheet.Employer:=EmployerName;
                                                                DataSheet."Transaction Type":=DataSheet."Transaction Type"::"ADJUSTMENT LOAN";
                                                                //DataSheet."Sort Code":=PTEN;
                                                                DataSheet.INSERT;
                                                                }
                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 53051;  ;Pays Interest During GP;Boolean     }
    { 53053;  ;Percent Repayments  ;Decimal       ;Editable=No }
    { 53054;  ;Paying Bank Account No;Code20      ;TableRelation="Bank Account".No. }
    { 53055;  ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 53056;  ;Loan Product Type Name;Text90      ;Editable=No }
    { 53057;  ;Cheque Number       ;Code20        ;OnValidate=BEGIN
                                                                {Loan.RESET;

                                                                Loan.SETRANGE(Loan."Cheque Number","Cheque Number");
                                                                Loan.SETRANGE(Loan."Bela Branch","Bela Branch");
                                                                IF Loan.FIND('-') THEN BEGIN
                                                                IF Loan."Cheque Number"="Cheque Number" THEN
                                                                ERROR('The Cheque No. has already been used');
                                                                END; }

                                                                IF "Cheque No."<>'' THEN BEGIN
                                                                Loan.RESET;
                                                                Loan.SETRANGE(Loan."Cheque No.","Cheque No.");
                                                                Loan.SETRANGE(Loan."Bela Branch","Bela Branch");
                                                                IF Loan.FIND('-') THEN BEGIN
                                                                IF  Loan."Cheque No."<>"Cheque No." THEN
                                                                   ERROR('"Cheque No.". already exists');
                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 53058;  ;Bank No             ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Bank Account".No. }
    { 53059;  ;Slip Number         ;Code20        ;FieldClass=FlowFilter }
    { 53060;  ;Total Paid          ;Decimal       ;FieldClass=FlowFilter }
    { 53061;  ;Schedule Repayments ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loan Repayment Schedule"."Principal Repayment" WHERE (Loan No.=FIELD(Loan  No.),
                                                                                                                          Repayment Date=FIELD(Date filter))) }
    { 53062;  ;Doc No Used         ;Code20         }
    { 53063;  ;Posting Date        ;Date          ;FieldClass=FlowFilter }
    { 53065;  ;Batch No.           ;Code20        ;FieldClass=Normal;
                                                   TableRelation=IF (Posted=CONST(No)) "Loan Disburesment-Batching"."Batch No." WHERE (Posted=CONST(No),
                                                                                                                                       Batch Type=FILTER(Loans),
                                                                                                                                       Source=FIELD(Source))
                                                                                                                                       ELSE IF (Posted=CONST(Yes)) "Loan Disburesment-Batching"."Batch No." WHERE (Batch Type=FILTER(Loans));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Loan Disbursement Date");

                                                                  {
                                                                ApprovalsUsers.RESET;
                                                                ApprovalsUsers.SETRANGE(ApprovalsUsers."Approval Type",);
                                                                ApprovalsUsers.SETRANGE(ApprovalsUsers.Stage,);
                                                                ApprovalsUsers.SETRANGE(ApprovalsUsers."User ID",);
                                                                                  }
                                                                                  {
                                                                RepaySched.RESET;
                                                                RepaySched.SETRANGE(RepaySched."Loan No.","Loan  No.");
                                                                IF NOT RepaySched.FIND('-') THEN
                                                                ERROR('Loan Schedule must be generated and confirmed before loan is attached to batch');
                                                                }
                                                                {
                                                                IF "Batch No." <> '' THEN BEGIN
                                                                IF "Loan Product Type" = '' THEN
                                                                  ERROR('You must specify Loan Product Type before assigning a loan a Batch No.');

                                                                IF LoansBatches.GET("Batch No.") THEN BEGIN
                                                                IF LoansBatches.Status<>LoansBatches.Status::Open THEN
                                                                ERROR('You cannot modify the loan because the batch is already %1',LoansBatches.Status);
                                                                END;
                                                                END;
                                                                }
                                                                "Checked By":=USERID;
                                                              END;

                                                   Editable=Yes }
    { 53066;  ;Edit Interest Rate  ;Boolean        }
    { 53067;  ;Posted              ;Boolean       ;Editable=Yes }
    { 53068;  ;Product Code        ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                 GLSetup.GET;
                                                                 Dimension:=GLSetup."Shortcut Dimension 3 Code";
                                                              END;
                                                               }
    { 53077;  ;Document No 2 Filter;Code20        ;FieldClass=FlowFilter }
    { 53078;  ;Field Office        ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(FIELD OFFICE)) }
    { 53079;  ;Dimension           ;Code20         }
    { 53080;  ;Amount Disbursed    ;Decimal        }
    { 53081;  ;Fully Disbursed     ;Boolean        }
    { 53082;  ;New Interest Rate   ;Decimal       ;Editable=No }
    { 53083;  ;New No. of Instalment;Integer      ;Editable=No }
    { 53084;  ;New Grace Period    ;DateFormula   ;Editable=No }
    { 53085;  ;New Regular Instalment;DateFormula ;Editable=No }
    { 53086;  ;Loan Balance at Rescheduling;Decimal;
                                                   Editable=No }
    { 53087;  ;Loan Reschedule     ;Boolean        }
    { 53088;  ;Date Rescheduled    ;Date           }
    { 53089;  ;Reschedule by       ;Code20         }
    { 53090;  ;Flat Rate Principal ;Decimal        }
    { 53091;  ;Flat rate Interest  ;Decimal        }
    { 53092;  ;Total Repayment     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Loan No=FIELD(Loan  No.),
                                                                                                       Customer No.=FIELD(Client Code),
                                                                                                       Transaction Type=CONST(Repayment),
                                                                                                       Posting Date=FIELD(Date filter)));
                                                   Editable=No }
    { 53093;  ;Interest Calculation Method;Option ;OptionString=,No Interest,Flat Rate,Reducing Balances }
    { 53094;  ;Edit Interest Calculation Meth;Boolean }
    { 53095;  ;Balance BF          ;Decimal        }
    { 53098;  ;Interest to be paid ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loan Repayment Schedule"."Monthly Interest" WHERE (Loan No.=FIELD(Loan  No.),
                                                                                                                       Member No.=FIELD(Client Code),
                                                                                                                       Repayment Date=FIELD(Date filter))) }
    { 53099;  ;Date filter         ;Date          ;FieldClass=FlowFilter }
    { 53101;  ;Cheque Date         ;Date           }
    { 53102;  ;Outstanding Balance ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Loan No=FIELD(Loan  No.),
                                                                                                       Transaction Type=FILTER(Loan|Repayment),
                                                                                                       Currency Code=FIELD(Currency Filter),
                                                                                                       Posting Date=FIELD(Date filter)));
                                                   Editable=No }
    { 53103;  ;Loan to Share Ratio ;Decimal        }
    { 53104;  ;Shares Balance      ;Decimal       ;Editable=No }
    { 53105;  ;Max. Installments   ;Integer       ;Editable=No }
    { 53106;  ;Max. Loan Amount    ;Decimal       ;Editable=No }
    { 53107;  ;Loan Cycle          ;Integer       ;Editable=No }
    { 53108;  ;Penalty Charged     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Transaction Type=FILTER(Penalty Charged),
                                                                                                       Loan No=FIELD(Loan  No.),
                                                                                                       Posting Date=FIELD(Date filter)));
                                                   Editable=No }
    { 53109;  ;Loan Amount         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Transaction Type=FILTER(Loan),
                                                                                                       Loan No=FIELD(Loan  No.)));
                                                   Editable=No }
    { 53110;  ;Current Shares      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                        Transaction Type=FILTER(Deposit Contribution))) }
    { 53111;  ;Loan Repayment      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Transaction Type=FILTER(Repayment),
                                                                                                       Loan No=FIELD(Loan  No.),
                                                                                                       Posting Date=FIELD(Date filter)));
                                                   Editable=No }
    { 53112;Yes;Repayment Method   ;Option        ;OnValidate=BEGIN
                                                                //VALIDATE("Approved Amount");
                                                              END;

                                                   OptionString=Amortised,Reducing Balance,Straight Line,Constants }
    { 53113;  ;Grace Period - Principle (M);Integer;
                                                   OnValidate=BEGIN
                                                                Installments:="Installment Including Grace"-"Grace Period - Principle (M)"
                                                              END;
                                                               }
    { 53114;  ;Grace Period - Interest (M);Integer }
    { 53115;  ;Adjustment          ;Text100        }
    { 53116;  ;Payment Due Date    ;Text70         }
    { 53117;  ;Tranche Number      ;Integer        }
    { 53118;  ;Amount Of Tranche   ;Decimal        }
    { 53119;  ;Total Disbursment to Date;Decimal   }
    { 53133;  ;Copy of ID          ;Boolean        }
    { 53134;  ;Contract            ;Boolean        }
    { 53135;  ;Payslip             ;Boolean        }
    { 53136;  ;Contractual Shares  ;Decimal        }
    { 53182;  ;Last Pay Date       ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Max("Member Ledger Entry"."Posting Date" WHERE (Loan No=FIELD(Loan  No.),
                                                                                                               Transaction Type=FILTER(Repayment|Loan)));
                                                   Editable=No }
    { 53183;  ;Interest Due        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Loan No=FIELD(Loan  No.),
                                                                                                       Transaction Type=FILTER(Interest Due),
                                                                                                       Posting Date=FIELD(Date filter),
                                                                                                       Reversed=CONST(No))) }
    { 53184;  ;Appraisal Status    ;Option        ;OnValidate=BEGIN
                                                                IF "Appraisal Status" = "Appraisal Status"::"Management Approved" THEN BEGIN
                                                                IF "Requested Amount" > 5000000 THEN
                                                                ERROR('Management can only approve a request below or equal to 5,000,000.')
                                                                ELSE
                                                                "Loan Status":="Loan Status"::Appraisal;

                                                                END;

                                                                IF "Appraisal Status" = "Appraisal Status"::"Credit Subcommitee Approved" THEN BEGIN
                                                                IF "Requested Amount" > 10000000 THEN
                                                                ERROR('Creit Subcommittee can only approve a request below or equal to 10,000,000.')
                                                                ELSE
                                                                "Loan Status":="Loan Status"::Appraisal;

                                                                END;

                                                                IF "Appraisal Status" = "Appraisal Status"::"Trust Board Approved" THEN
                                                                "Loan Status":="Loan Status"::Appraisal;
                                                              END;

                                                   OptionCaptionML=ENU=Expresion of Interest,Desk Appraisal,Loan form purchased,Loan Officer Approved,Management Approved,Credit Subcommitee Approved,Trust Board Approved;
                                                   OptionString=Expresion of Interest,Desk Appraisal,Loan form purchased,Loan Officer Approved,Management Approved,Credit Subcommitee Approved,Trust Board Approved }
    { 53185;  ;Interest Paid       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Loan No=FIELD(Loan  No.),
                                                                                                        Transaction Type=FILTER(Interest Paid),
                                                                                                        Posting Date=FIELD(Date filter))) }
    { 53186;  ;Penalty Paid        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Transaction Type=FILTER(Penalty Paid),
                                                                                                       Loan No=FIELD(Loan  No.),
                                                                                                       Posting Date=FIELD(Date filter))) }
    { 53187;  ;Application Fee Paid;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Loan No=FIELD(Loan  No.),
                                                                                                       Transaction Type=FILTER(Application Fee),
                                                                                                       Posting Date=FIELD(Date filter)));
                                                   Editable=No }
    { 53188;  ;Appraisal Fee Paid  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Loan No=FIELD(Loan  No.),
                                                                                                       Transaction Type=FILTER(Appraisal Fee),
                                                                                                       Posting Date=FIELD(Date filter)));
                                                   Editable=No }
    { 53189;  ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   CaptionClass='1,1,1' }
    { 53190;  ;Repayment Start Date;Date          ;OnValidate=BEGIN
                                                                "Expected Date of Completion":=CALCDATE(FORMAT(Installments)+'M',"Repayment Start Date");
                                                              END;
                                                               }
    { 53191;  ;Installment Including Grace;Integer;OnValidate=BEGIN
                                                                IF "Installment Including Grace"  > "Max. Installments" THEN
                                                                ERROR('Installments cannot be greater than the maximum installments.');

                                                                Installments:="Installment Including Grace"-"Grace Period - Principle (M)"
                                                              END;
                                                               }
    { 53192;  ;Schedule Repayment  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loan Repayment Schedule"."Principal Repayment" WHERE (Loan No.=FIELD(Loan  No.),
                                                                                                                          Repayment Date=FIELD(Date filter))) }
    { 53193;  ;Schedule Interest   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loan Repayment Schedule"."Monthly Interest" WHERE (Loan No.=FIELD(Loan  No.))) }
    { 53194;  ;Interest Debit      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Loan No=FIELD(Loan  No.),
                                                                                                       Transaction Type=FILTER(Interest Due),
                                                                                                       Posting Date=FIELD(Date filter))) }
    { 53195;  ;Schedule Interest to Date;Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loan Repayment Schedule"."Monthly Interest" WHERE (Loan No.=FIELD(Loan  No.),
                                                                                                                       Repayment Date=FIELD(Date filter))) }
    { 53196;  ;Repayments BF       ;Decimal        }
    { 68000;  ;Account No          ;Code20        ;TableRelation=Vendor.No. WHERE (Creditor Type=CONST(Account),
                                                                                   Account Type=CONST(ORDINARY));
                                                   OnValidate=VAR
                                                                Err_defloan@1120054000 : TextConst 'ENU=Selected member has a Loan %1 which is in %2 category, member cannot access any loan!';
                                                                DefLoan@1120054001 : Record 51516230;
                                                              BEGIN
                                                                {Vendor.RESET;
                                                                Vendor.SETRANGE(Vendor."No.","Account No");
                                                                Vendor.SETRANGE(Vendor."Account Type",'DIVIDEND');
                                                                IF Vendor.FIND('-') THEN BEGIN
                                                                ERROR('You cannot use a Dividend account to disburse loans');
                                                                END;
                                                                    }

                                                                {MembX.RESET;
                                                                MembX.SETRANGE(MembX."FOSA Account","Account No");
                                                                MembX.SETRANGE(MembX."Loan Defaulter",TRUE);
                                                                IF MembX.FINDFIRST THEN BEGIN
                                                                ERROR('Member is a defaulter.');
                                                                END;}//Kit

                                                                "Approved Amount":=0;
                                                                "Recommended Amount":=0;
                                                                "Requested Amount":=0;
                                                                "Loan Product Type":='';
                                                                Installments:=0;
                                                                "Main Sector":='';
                                                                "Sub-Sector":='';
                                                                "Specific Sector":='';
                                                                "Application Date":=TODAY;
                                                                "Estimated Monthly Expense":=0;
                                                                "Estimated Net Monthly Income":=0;


                                                                //Surestep
                                                                IF (Source = Source::BOSA) OR (Source = Source::MICRO)THEN
                                                                EXIT;

                                                                GenSetUp.GET(0);

                                                                LoansClearedSpecial.RESET;
                                                                LoansClearedSpecial.SETRANGE(LoansClearedSpecial."Loan No.","Loan  No.");
                                                                IF LoansClearedSpecial.FIND('-') THEN
                                                                LoansClearedSpecial.DELETEALL;



                                                                IF Vendor.GET("Account No") THEN BEGIN


                                                                   { DefLoan.RESET;
                                                                    DefLoan.SETRANGE(DefLoan."Client Code",Vendor."BOSA Account No");
                                                                    DefLoan.SETFILTER(DefLoan."Outstanding Balance",'>0');
                                                                    DefLoan.SETFILTER(DefLoan."Loans Category-SASRA",'%1|%2|%3',
                                                                    DefLoan."Loans Category-SASRA"::Substandard,DefLoan."Loans Category-SASRA"::Doubtful,
                                                                    DefLoan."Loans Category-SASRA"::Watch);
                                                                    IF DefLoan.FINDSET THEN
                                                                      REPEAT
                                                                          ERROR(Err_defloan,DefLoan."Loan  No."+ ' : '+ DefLoan."Loan Product Type"+ ' '+DefLoan."Loan Product Type Name",DefLoan."Loans Category-SASRA");
                                                                        UNTIL DefLoan.NEXT =0;}//Kit


                                                                      CustomerRecord.RESET;
                                                                      CustomerRecord.SETRANGE(CustomerRecord."No.",Vendor."BOSA Account No");
                                                                      IF CustomerRecord.FIND('-') THEN BEGIN
                                                                      CustomerRecord.CALCFIELDS(CustomerRecord."Current Shares",CustomerRecord."Outstanding Balance",
                                                                      CustomerRecord."Current Loan");
                                                                      CustomerRecord.TESTFIELD(CustomerRecord.Pin);
                                                                      CustomerRecord.TESTFIELD(CustomerRecord."Employer Code");
                                                                      CustomerRecord.TESTFIELD(CustomerRecord."Front Side ID");
                                                                      CustomerRecord.TESTFIELD(CustomerRecord."Back Side ID");
                                                                      CustomerRecord.TESTFIELD(CustomerRecord."ID No.");
                                                                      "Client Name":=CustomerRecord.Name;
                                                                      "Shares Balance":=CustomerRecord."Current Shares";
                                                                      Savings:=CustomerRecord."Current Shares";
                                                                      "Existing Loan":=CustomerRecord."Outstanding Balance";

                                                                      //"Account No":=CustomerRecord."FOSA Account";
                                                                      "Staff No":=CustomerRecord."Payroll/Staff No";
                                                                      Gender:=CustomerRecord.Gender;
                                                                      "BOSA No":=Vendor."BOSA Account No";
                                                                      "Client Code":=Vendor."BOSA Account No";
                                                                      "Branch Code":=Vendor."Global Dimension 2 Code";
                                                                      "ID NO":=Vendor."ID No.";
                                                                      IF "Branch Code" = '' THEN
                                                                      "Branch Code":=CustomerRecord."Global Dimension 2 Code";

                                                                IF ("Loan Product Type" <> 'DFTL FOSA') AND ("Loan Product Type" <> 'DFTL') THEN BEGIN
                                                                //Check Shares Boosting
                                                                IF "Application Date" <> 0D THEN BEGIN
                                                                CustLedg.RESET;
                                                                CustLedg.SETRANGE(CustLedg."Customer No.",Vendor."BOSA Account No");
                                                                CustLedg.SETRANGE(CustLedg."Transaction Type",CustLedg."Transaction Type"::"Deposit Contribution");
                                                                CustLedg.SETRANGE(CustLedg.Reversed,FALSE);
                                                                IF CustLedg.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                IF CustLedg."Posting Date" > CALCDATE(GenSetUp."Boosting Shares Maturity (M)","Application Date") THEN BEGIN
                                                                //CustLedg.CALCFIELDS(CustLedg.Amount);
                                                                IF ABS(CustLedg.Amount)>
                                                                (((CustomerRecord."Monthly Contribution"*GenSetUp."Boosting Shares %")*0.01)) THEN BEGIN
                                                                "Shares Boosted":=TRUE;
                                                                END;
                                                                END;
                                                                UNTIL CustLedg.NEXT = 0;
                                                                END;
                                                                END;
                                                                END;
                                                                //Check Shares Boosting



                                                                END ELSE
                                                                //ERROR('You must specify the account holder BOSA Account No.');

                                                                {
                                                                IF ("Loan Product Type" <> 'BRIDGING') AND ("Loan Product Type" <> 'DISCOUNT') AND
                                                                   ("Loan Product Type" <> 'DIV DISC') AND
                                                                   ("Loan Product Type" <> 'DFTL FOSA') AND ("Loan Product Type" <> 'DFTL') THEN BEGIN
                                                                IF Vendor."Salary Processing" = FALSE THEN  BEGIN
                                                                IF Vendor."Account Type" <> 'FAHARI' THEN BEGIN
                                                                IF CONFIRM('Member salary not processed through the SACCO. Do you wish to continue?',TRUE) = FALSE THEN BEGIN
                                                                "Account No":='';
                                                                EXIT;
                                                                END;
                                                                END;
                                                                END;
                                                                END;
                                                                }

                                                                {IF CustR.GET("Account No") THEN BEGIN
                                                                "BOSA No":=Vendor."BOSA Account No";
                                                                "Client Code":=Vendor."No.";
                                                                "Client Name":=Vendor.Name;
                                                                //VALIDATE("Client Code");
                                                                Designation:=Vendor.Designation;
                                                                Workstation:=Vendor."Work Station";
                                                                "Terms of Service":=Vendor."Terms of Service";
                                                                END ELSE BEGIN
                                                                "BOSA No":=Vendor."BOSA Account No";
                                                                "Client Code":=Vendor."No.";
                                                                "Client Name":=Vendor.Name;
                                                                //VALIDATE("Client Code");}


                                                                IF CustR.GET("Account No") THEN BEGIN
                                                                CustR.INIT;
                                                                CustR."No.":=Vendor."No.";
                                                                CustR.Name:=Vendor.Name;
                                                                CustR."Global Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                                                CustR."Global Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                                                CustR.Status:=Cust.Status::Active;
                                                                CustR."Customer Type":=CustR."Customer Type"::FOSA;
                                                                CustR."Customer Posting Group":='FOSA';
                                                                CustR."FOSA Account":="Account No";
                                                                IF CustR."Payroll/Staff No" <> '' THEN
                                                                CustR."Payroll/Staff No":=Vendor."Staff No";
                                                                CustR."ID No.":=Vendor."ID No.";
                                                                CustR.Gender:=Vendor.Gender;
                                                                CustR.INSERT;

                                                                CustR.RESET;
                                                                IF CustR.GET("Account No") THEN BEGIN
                                                                CustR.Name:=Vendor.Name;
                                                                CustR."Global Dimension 1 Code":=Vendor."Global Dimension 1 Code";
                                                                CustR."Global Dimension 2 Code":=Vendor."Global Dimension 2 Code";
                                                                CustR."Customer Posting Group":='FOSA';
                                                                CustR.VALIDATE(CustR.Name);
                                                                CustR.VALIDATE(CustR."Global Dimension 1 Code");
                                                                CustR.VALIDATE(CustR."Global Dimension 2 Code");
                                                                //CustR.VALIDATE(CustR."Customer Posting Group");
                                                                CustR.MODIFY;

                                                                END;

                                                                END;

                                                                Cust2.RESET;
                                                                //Cust2.SETRANGE(Cust2."Customer Type",Cust2."Customer Type"::Member);
                                                                Cust2.SETRANGE(Cust2."FOSA Account",Vendor."No.");
                                                                IF Cust2.FIND('-') THEN BEGIN
                                                                "BOSA No":=Cust2."No.";
                                                                IF Cust2."Payroll/Staff No" <> '' THEN
                                                                "Staff No":=Cust2."Payroll/Staff No";
                                                                VALIDATE("BOSA No");

                                                                IF Cust2.Status=Cust2.Status::Dormant THEN BEGIN
                                                                ERROR('Member is dormant.');
                                                                END;
                                                                END;



                                                                END;

                                                                //LoanApp.RESET;
                                                                //LoanApp.SETRANGE(LoanApp."BOSA No","BOSA No");
                                                                //LoanApp.SETRANGE("Recommended Amount",0);
                                                                //IF LoanApp.FIND('-') THEN
                                                                //IF "Recommended Amount" =0 THEN //Kitui
                                                                //"Recommended Amount":="Approved Amount";
                                                                //LoanApp.MODIFY;

                                                                //Block if loan Previously recovered from gurantors
                                                                LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."BOSA No","BOSA No");
                                                                LoanApp.SETRANGE("Recovered From Guarantor",TRUE);
                                                                IF LoanApp.FIND('-') THEN
                                                                ERROR('Member has a loan which has previously been recovered from gurantors. - %1',LoanApp."Loan  No.");
                                                                //Block if loan Previously recovered from gurantors

                                                                Cust.RESET;
                                                                Cust.SETRANGE(Cust."ID No.","ID NO");
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                Cust.CALCFIELDS(Cust."Outstanding Balance",Cust."Current Shares");//,Cust."Loans Guaranteed"
                                                                "BOSA Deposits":=Cust."Current Shares";
                                                                 "Employer Code":=Cust."Employer Code";
                                                                 Workstation:=Cust.Station;
                                                                //"Amont Guaranteed":=Cust."Current Shares";
                                                                 END;
                                                                //End Surestep


                                                                IF Vendor.GET("Account No") THEN BEGIN
                                                                "Client Code":=Vendor."BOSA Account No";
                                                                "Client Name":=Vendor.Name;
                                                                Designation:=Vendor.Designation;
                                                                Workstation:=Vendor."Work Station";
                                                                "Terms of Service":=Vendor."Terms of Service";
                                                                "BOSA No":=Vendor."BOSA Account No";

                                                                END;
                                                              END;
                                                               }
    { 68001;  ;BOSA No             ;Code20        ;TableRelation="Members Register".No. }
    { 68002;  ;Staff No            ;Code20        ;OnValidate=BEGIN
                                                                {IF xRec."Staff No" <> '' THEN BEGIN
                                                                IF xRec."Staff No" <> "Staff No" THEN BEGIN
                                                                IF CONFIRM('Are you sure you want to change the staff No.') = FALSE THEN
                                                                ERROR('Change cancelled.');
                                                                END;
                                                                END;


                                                                IF (Source=Source::BOSA) THEN BEGIN
                                                                CustomerRecord.RESET;
                                                                CustomerRecord.SETRANGE(CustomerRecord."Customer Type",CustomerRecord."Customer Type"::Member);
                                                                CustomerRecord.SETRANGE(CustomerRecord."Payroll/Staff No","Staff No");
                                                                IF CustomerRecord.FIND('-') THEN BEGIN
                                                                "Client Code":=CustomerRecord."No.";
                                                                VALIDATE("Client Code");
                                                                END
                                                                ELSE
                                                                ERROR('Record not found.');

                                                                END
                                                                ELSE BEGIN
                                                                Vend.RESET;
                                                                Vend.SETFILTER(Vend."Account Type",'SAVINGS');
                                                                Vend.SETRANGE(Vend."Staff No","Staff No");
                                                                IF Vend.FIND('-') THEN BEGIN
                                                                "Account No":=Vend."No.";
                                                                VALIDATE("Account No");
                                                                END
                                                                ELSE
                                                                ERROR('Record not found.');

                                                                END;
                                                                }
                                                              END;
                                                               }
    { 68003;  ;BOSA Loan Amount    ;Decimal        }
    { 68004;  ;Top Up Amount       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loan Offset Details"."Total Top Up" WHERE (Loan No.=FIELD(Loan  No.),
                                                                                                               Client Code=FIELD(Client Code)));
                                                   Editable=No }
    { 68005;  ;Loan Received       ;Boolean        }
    { 68006;  ;Period Date Filter  ;Date          ;FieldClass=FlowFilter }
    { 68007;  ;Current Repayment   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Loan No=FIELD(Loan  No.),
                                                                                                       Transaction Type=FILTER(Repayment),
                                                                                                       Posting Date=FIELD(Period Date Filter)));
                                                   Editable=No }
    { 68008;  ;Oustanding Interest ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Loan No=FIELD(Loan  No.),
                                                                                                       Transaction Type=FILTER(Interest Paid|Interest Due),
                                                                                                       Posting Date=FIELD(Date filter),
                                                                                                       Document No.=FILTER(<>'')));
                                                   Editable=No }
    { 68009;  ;Oustanding Interest to Date;Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Loan No=FIELD(Loan  No.),
                                                                                                       Transaction Type=FILTER(Interest Paid|Interest Due),
                                                                                                       Document No.=FIELD(Document No. Filter),
                                                                                                       Description=FILTER(<>'')));
                                                   Editable=No }
    { 68010;  ;Current Interest Paid;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Loan No=FIELD(Loan  No.),
                                                                                                       Transaction Type=CONST(Interest Paid),
                                                                                                       Posting Date=FIELD(Period Date Filter)));
                                                   Editable=No }
    { 68011;  ;Document No. Filter ;Code100       ;FieldClass=FlowFilter }
    { 68012;  ;Cheque No.          ;Code20        ;OnValidate=BEGIN
                                                                 {
                                                                Loan.SETRANGE(Loan."Cheque Number","Cheque Number");
                                                                Loan.SETRANGE(Loan."Bela Branch","Bela Branch");
                                                                IF Loan.FIND('-') THEN BEGIN
                                                                IF Loan."Cheque Number"="Cheque Number" THEN
                                                                ERROR('The Cheque No. has already been used');
                                                                END; }

                                                                IF "Cheque No."<>'' THEN BEGIN
                                                                Loan.RESET;
                                                                Loan.SETRANGE(Loan."Cheque No.","Cheque No.");
                                                                Loan.SETRANGE(Loan."Bela Branch","Bela Branch");
                                                                IF Loan.FIND('-') THEN BEGIN
                                                                IF  Loan."Cheque No."="Cheque No." THEN
                                                                   ERROR('Cheque No. already exists');
                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 68013;  ;Personal Loan Off-set;Decimal       }
    { 68014;  ;Old Account No.     ;Code20         }
    { 68015;  ;Loan Principle Repayment;Decimal   ;OnValidate=BEGIN
                                                                // "Loan Principle Repayment":="Approved Amount";
                                                                // Advice:=TRUE;
                                                                // VALIDATE(Repayment);
                                                                //"Loan Principle Repayment":="Approved Amount"/Installments;
                                                              END;
                                                               }
    { 68016;  ;Loan Interest Repayment;Decimal    ;OnValidate=BEGIN
                                                                // "Loan Interest Repayment":=Interest*"Loan Principle Repayment";
                                                                // Advice:=TRUE;
                                                                // VALIDATE(Repayment);
                                                              END;
                                                               }
    { 68017;  ;Contra Account      ;Code20         }
    { 68018;  ;Transacting Branch  ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2)) }
    { 68019;  ;Source              ;Option        ;OptionCaptionML=ENU=BOSA,FOSA,MICRO;
                                                   OptionString=BOSA,FOSA,MICRO }
    { 68020;  ;Net Income          ;Decimal        }
    { 68021;  ;No. Of Guarantors   ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Guarantee Details" WHERE (Loan No=FIELD(Loan  No.),
                                                                                                      Substituted=CONST(No))) }
    { 68022;  ;Total Loan Guaranted;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Guarantee Details".Shares WHERE (Loan No=FIELD(Loan  No.))) }
    { 68023;  ;Shares Boosted      ;Boolean        }
    { 68024;  ;Basic Pay           ;Decimal       ;OnValidate=BEGIN
                                                                //"Net Income":=("Basic Pay"+"House Allowance"+"Other Allowance"+"Cleared Effects")-"Total Deductions";
                                                                "Net Income":=("Basic Pay"+"House Allowance"+"Other Allowance"+"Mileage Allowance"+"Transport Allowance"+"Other Benefits")
                                                                -"Total Deductions";
                                                              END;
                                                               }
    { 68025;  ;House Allowance     ;Decimal       ;OnValidate=BEGIN
                                                                "Net Income":=("Basic Pay"+"House Allowance"+"Other Allowance"+"Mileage Allowance"+"Transport Allowance"+"Other Benefits")
                                                                -"Total Deductions";
                                                              END;
                                                               }
    { 68026;  ;Other Allowance     ;Decimal       ;OnValidate=BEGIN
                                                                "Net Income":=("Basic Pay"+"House Allowance"+"Other Allowance"+"Mileage Allowance"+"Transport Allowance"+"Other Benefits")
                                                                -"Total Deductions";
                                                              END;
                                                               }
    { 68027;  ;Total Deductions    ;Decimal       ;OnValidate=BEGIN
                                                                "Net Income":=("Basic Pay"+"House Allowance"+"Other Allowance"+"Mileage Allowance"+"Transport Allowance"+"Other Benefits")
                                                                -"Total Deductions";
                                                              END;
                                                               }
    { 68028;  ;Cleared Effects     ;Decimal       ;OnValidate=BEGIN
                                                                //"Net Income":=("Basic Pay"+"House Allowance"+"Other Allowance"+"Milage Allowance"+"Transport Allowance"+"Other Benefits")
                                                                //-"Total Deductions";
                                                              END;
                                                               }
    { 68029;  ;Remarks             ;Text60         }
    { 68030;  ;Advice              ;Boolean        }
    { 68031;  ;Special Loan Amount ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loan Special Clearance"."Total Off Set" WHERE (Loan No.=FIELD(Loan  No.),
                                                                                                                   Client Code=FIELD(BOSA No)));
                                                   CaptionML=ENU=Bridging Loan Amount;
                                                   Editable=No }
    { 68032;  ;Bridging Loan Posted;Boolean        }
    { 68033;  ;BOSA Loan No.       ;Code20        ;TableRelation="Loans Register"."Loan  No." }
    { 68034;  ;Previous Repayment  ;Decimal        }
    { 68035;  ;No Loan in MB       ;Boolean        }
    { 68036;  ;Recovered Balance   ;Decimal        }
    { 68037;  ;Recon Issue         ;Boolean        }
    { 68038;  ;Loan Purpose        ;Code20        ;TableRelation="Loans Purpose".Code }
    { 68039;  ;Reconciled          ;Boolean        }
    { 68040;  ;Appeal Amount       ;Decimal       ;OnValidate=BEGIN
                                                                IF Posted = FALSE THEN
                                                                ERROR('Appeal only applicable for issued loans.');
                                                                //"Approved Amount":="Appeal Amount"+"Approved Amount";
                                                                //VALIDATE("Approved Amount");
                                                              END;
                                                               }
    { 68041;  ;Appeal Posted       ;Boolean        }
    { 68042;  ;Project Amount      ;Decimal       ;OnValidate=BEGIN
                                                                CALCFIELDS("Top Up Amount","Special Loan Amount");

                                                                SpecialComm:=0;
                                                                IF "Special Loan Amount" > 0 THEN
                                                                SpecialComm:=("Special Loan Amount"*0.01)+ ("Special Loan Amount"+("Special Loan Amount"*0.01))*0.1;

                                                                IF "Project Amount" > ("Approved Amount" - ("Top Up Amount" + "Special Loan Amount" + SpecialComm)) THEN
                                                                ERROR('Amount to project cannot be more than the net payable amount i.e.  %1',
                                                                     ("Approved Amount" - ("Top Up Amount" + "Special Loan Amount" + SpecialComm)));
                                                              END;
                                                               }
    { 68043;  ;Project Account No  ;Code20        ;TableRelation=Vendor.No. WHERE (Creditor Type=CONST(Account),
                                                                                   Account Type=FILTER(SAVINGS|ENCASHCH),
                                                                                   Status=CONST(Active)) }
    { 68044;  ;Location Filter     ;Integer       ;FieldClass=FlowFilter;
                                                   TableRelation="Approvals Set Up".Stage WHERE (Approval Type=CONST(File Movement)) }
    { 68045;  ;Other Commitments Clearance;Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Other Commitements Clearance".Amount WHERE (Loan No.=FIELD(Loan  No.)));
                                                   Editable=No }
    { 68046;  ;Discounted Amount   ;Decimal       ;Editable=No }
    { 68047;  ;Transport Allowance ;Decimal       ;OnValidate=BEGIN
                                                                "Mileage Allowance":=0;
                                                                "Net Income":=("Basic Pay"+"House Allowance"+"Other Allowance"+"Mileage Allowance"+"Transport Allowance")-"Total Deductions";
                                                              END;
                                                               }
    { 68048;  ;Mileage Allowance   ;Decimal       ;OnValidate=BEGIN
                                                                "Transport Allowance":=0;
                                                                "Net Income":=("Basic Pay"+"House Allowance"+"Other Allowance"+"Mileage Allowance"+"Transport Allowance")-"Total Deductions";
                                                              END;
                                                               }
    { 68049;  ;System Created      ;Boolean        }
    { 68050;  ;Boosting Commision  ;Decimal        }
    { 68051;  ;Voluntary Deductions;Decimal        }
    { 68052;  ;4 % Bridging        ;Boolean       ;OnValidate=BEGIN
                                                                //IF CONFIRM('Are you sure you want to charge 7.5%') = TRUE THEN
                                                              END;
                                                               }
    { 68053;  ;No. Of Guarantors-FOSA;Integer     ;FieldClass=Normal }
    { 68054;  ;Defaulted           ;Boolean        }
    { 68055;  ;Bridging Posting Date;Date          }
    { 68056;  ;Commitements Offset ;Decimal        }
    { 68057;  ;Gender              ;Option        ;OptionCaptionML=ENU=Male,Female;
                                                   OptionString=Male,Female }
    { 68058;  ;Captured By         ;Code40        ;TableRelation=User."User Security ID" }
    { 68059;  ;Branch Code         ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   ValidateTableRelation=No }
    { 68060;  ;Recovered From Guarantor;Boolean    }
    { 68061;  ;Guarantor Amount    ;Decimal        }
    { 68062;  ;External EFT        ;Boolean       ;OnValidate=BEGIN
                                                                //Surestep
                                                                {StatusPermissions.RESET;
                                                                StatusPermissions.SETRANGE(StatusPermissions."Account No",USERID);
                                                                StatusPermissions.SETRANGE(StatusPermissions.Name,StatusPermissions.Name::"7");
                                                                IF StatusPermissions.FIND('-') = FALSE THEN
                                                                ERROR('You do not have permissions to update External EFT.');
                                                                 }
                                                              END;
                                                               }
    { 68063;  ;Defaulter Overide Reasons;Text120   }
    { 68064;  ;Defaulter Overide   ;Boolean       ;OnValidate=BEGIN
                                                                //Surestep
                                                                {TESTFIELD("Defaulter Overide Reasons");

                                                                StatusPermissions.RESET;
                                                                StatusPermissions.SETRANGE(StatusPermissions."Account No",USERID);
                                                                StatusPermissions.SETRANGE(StatusPermissions.Name,StatusPermissions.Name::"8");
                                                                IF StatusPermissions.FIND('-') = FALSE THEN
                                                                ERROR('You do not have permissions to overide defaulters.');
                                                                 }
                                                              END;
                                                               }
    { 68065;  ;Last Interest Pay Date;Date        ;FieldClass=FlowField;
                                                   CalcFormula=Max("Member Ledger Entry"."Posting Date" WHERE (Loan No=FIELD(Loan  No.),
                                                                                                               Transaction Type=FILTER(Interest Paid),
                                                                                                               Posting Date=FIELD(Date filter)));
                                                   Editable=No }
    { 68066;  ;Other Benefits      ;Decimal       ;OnValidate=BEGIN
                                                                "Net Income":=("Basic Pay"+"House Allowance"+"Other Allowance"+"Mileage Allowance"+"Transport Allowance"+"Other Benefits")
                                                                -"Total Deductions";
                                                              END;
                                                               }
    { 68067;  ;Recovered Loan      ;Code20        ;TableRelation="Loans Register"."Loan  No." }
    { 68068;  ;1st Notice          ;Date           }
    { 68069;  ;2nd Notice          ;Date           }
    { 68070;  ;Final Notice        ;Date           }
    { 68071;  ;Outstanding Balance to Date;Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Transaction Type=FILTER(Loan|Repayment|Loan Adjustment),
                                                                                                       Loan No=FIELD(Loan  No.),
                                                                                                       Posting Date=FIELD(Date filter)));
                                                   Editable=No }
    { 68072;  ;Last Advice Date    ;Date           }
    { 68073;  ;Advice Type         ;Option        ;OptionString=[ ,Fresh Loan,Adjustment,Reintroduction,Stoppage] }
    { 68074;  ;Current Location    ;Code40        ;FieldClass=FlowField;
                                                   CalcFormula=Max("Movement Tracker".Station WHERE (Document No.=FIELD(Batch No.),
                                                                                                     Current Location=CONST(Yes)));
                                                   Editable=No }
    { 68090;  ;Compound Balance    ;Decimal        }
    { 68091;  ;Repayment Rate      ;Decimal        }
    { 68092;  ;Exp Repay           ;Decimal       ;FieldClass=Normal }
    { 68093;  ;ID NO               ;Code25        ;OnValidate=BEGIN
                                                                //Surestep
                                                                {IF Source=Source::FOSA THEN BEGIN
                                                                IF "Account No"='00-0000003000' THEN BEGIN
                                                                Vend.RESET;
                                                                Vend.SETCURRENTKEY(Vend."ID No.");
                                                                Vend.SETRANGE(Vend."ID No.","ID NO");
                                                                IF Vend.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                MESSAGE('THE MEMBER HAS AN ACCOUNT'+' '+ Vend."No."+' ''+ HE/SHE CANNOT TRANSACT ON THIS ACCOUNT');
                                                                UNTIL Vend.NEXT=0;
                                                                END;
                                                                END;
                                                                END;
                                                                }
                                                              END;
                                                               }
    { 68094;  ;RAmount             ;Decimal        }
    { 68095;  ;Employer Code       ;Code20        ;TableRelation="Sacco Employers" }
    { 68096;  ;Last Loan Issue Date;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Max("Member Ledger Entry"."Posting Date" WHERE (Customer No.=FIELD(Client Code),
                                                                                                               Transaction Type=FILTER(Loan),
                                                                                                               Posting Date=FIELD(Date filter))) }
    { 68097;  ;Lst LN1             ;Boolean        }
    { 68098;  ;Lst LN2             ;Boolean        }
    { 68099;  ;Last loan           ;Code20        ;FieldClass=Normal }
    { 69000;  ;Loans Category      ;Option        ;OptionCaptionML=ENU=Perfoming,Watch,Substandard,Doubtful,Loss;
                                                   OptionString=Perfoming,Watch,Substandard,Doubtful,Loss }
    { 69001;  ;Loans Category-SASRA;Option        ;OptionCaptionML=ENU=Perfoming,Watch,Substandard,Doubtful,Loss;
                                                   OptionString=Perfoming,Watch,Substandard,Doubtful,Loss }
    { 69002;  ;Bela Branch         ;Code40         }
    { 69003;  ;Net Amount          ;Decimal        }
    { 69004;  ;Bank code           ;Code40        ;TableRelation="Member App Signatories";
                                                   OnValidate=BEGIN
                                                                {banks.RESET;
                                                                banks.SETRANGE(banks.Code,"Bank code");

                                                                IF  banks.FIND('-') THEN BEGIN

                                                                "Bank code":=banks.Code;
                                                                "Bank Name":=banks."Bank Name";
                                                                "Bank Branch":=banks.Branch;

                                                                Loan.MODIFY;
                                                                END;}
                                                              END;
                                                               }
    { 69005;  ;Bank Name           ;Text40         }
    { 69006;  ;Bank Branch         ;Text40         }
    { 69007;  ;Outstanding Loan    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Transaction Type=FILTER(Loan|Repayment),
                                                                                                       Loan No=FIELD(Loan  No.),
                                                                                                       Posting Date=FIELD(Date filter)));
                                                   Editable=No }
    { 69008;  ;Loan Count          ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Member Ledger Entry" WHERE (Customer No.=FIELD(Client Code),
                                                                                                  Transaction Type=FILTER(Loan),
                                                                                                  Loan No=FIELD(Loan  No.))) }
    { 69009;  ;Repay Count         ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Member Ledger Entry" WHERE (Customer No.=FIELD(Client Code),
                                                                                                  Transaction Type=FILTER(Repayment),
                                                                                                  Loan No=FIELD(Loan  No.))) }
    { 69010;  ;Outstanding Loan2   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Posting Date=FIELD(Date filter),
                                                                                                       Amount=FIELD(Approved Amount)));
                                                   Editable=No }
    { 69011;  ;Topup Loan No       ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Loan Offset Details"."Loan No." WHERE (Loan Top Up=FIELD(Loan  No.),
                                                                                                              Client Code=FIELD(Client Code))) }
    { 69012;  ;Defaulter           ;Boolean        }
    { 69013;  ;DefaulterInfo       ;Text50         }
    { 69014;  ;Total Earnings(Salary);Decimal     ;FieldClass=Normal }
    { 69015;  ;Total Deductions(Salary);Decimal   ;FieldClass=Normal;
                                                   OnValidate=BEGIN
                                                                "Net take Home":="Two Thirds Basic"-("Total Deductions(Salary)"+"Other Deductions");
                                                                //"Net take Home":=("Total Earnings(Salary)"+"Bridge Amount Release")-("Total Deductions(Salary)"+"Third basic");
                                                              END;
                                                               }
    { 69016;  ;Share Purchase      ;Decimal        }
    { 69017;  ;Product Currency Code;Code30       ;TableRelation=Currency }
    { 69018;  ;Currency Filter     ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=Currency;
                                                   CaptionML=ENU=Currency Filter }
    { 69019;  ;Amount Disburse     ;Decimal        }
    { 69020;  ;Prepayments         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Transaction Type=FILTER(Prepayment),
                                                                                                       Loan No=FIELD(Loan  No.),
                                                                                                       Posting Date=FIELD(Date filter),
                                                                                                       Document No.=FIELD(Document No. Filter))) }
    { 69021;  ;Appln. between Currencies;Option   ;CaptionML=ENU=Appln. between Currencies;
                                                   OptionCaptionML=ENU=None,EMU,All;
                                                   OptionString=None,EMU,All }
    { 69022;  ;Expected Date of Completion;Date    }
    { 69023;  ;Total Schedule Repayment;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loan Repayment Schedule"."Monthly Repayment" WHERE (Loan No.=FIELD(Loan  No.))) }
    { 69024;  ;Recovery Mode       ;Option        ;OnValidate=VAR
                                                                err_sal@1120054000 : TextConst 'ENU=The salary of this member does not come through FOSA, do you want to proceed with this recovery mode?';
                                                                operationstopped@1120054001 : TextConst 'ENU=The operation has been stopped by %1.';
                                                                Err_SalThroughFosa@1120054002 : TextConst 'ENU=The salary of %1 does not pass through FOSA!';
                                                                Changing@1120054003 : TextConst 'ENU=You are changing the recovery mode to %1, Please confirm!';
                                                                Err_MemNo@1120054004 : TextConst 'ENU=Client has no member no in FOSA, please update to proceed!';
                                                                VendLedge@1120054005 : Record 25;
                                                              BEGIN

                                                                //IF xRec."Recovery Mode"<>Rec."Recovery Mode" THEN BEGIN
                                                                //IF NOT CONFIRM(Changing,FALSE,"Recovery Mode") THEN
                                                                 // ERROR(operationstopped,USERID);

                                                                IF "Recovery Mode"="Recovery Mode"::Salary THEN BEGIN
                                                                    IF NOT Posted THEN BEGIN
                                                                        FosaAcc.RESET;
                                                                        FosaAcc.SETRANGE(FosaAcc."BOSA Account No","BOSA No");
                                                                        IF FosaAcc.FINDFIRST THEN BEGIN
                                                                          IF FosaAcc."Net Salary"<>0 THEN BEGIN
                                                                            LoanAppraisalSalaryDetails.RESET;
                                                                            LoanAppraisalSalaryDetails.SETRANGE("Loan No","Loan  No.");
                                                                           // LoanAppraisalSalaryDetails.SETRANGE("Client Code","Client Code");
                                                                            IF LoanAppraisalSalaryDetails.FINDSET THEN BEGIN
                                                                              LoanAppraisalSalaryDetails.DELETEALL;
                                                                              END;
                                                                            LoanAppraisalSalaryDetails.INIT;
                                                                            LoanAppraisalSalaryDetails."Appraisal Type":=LoanAppraisalSalaryDetails."Appraisal Type"::Salary;
                                                                            LoanAppraisalSalaryDetails.VALIDATE(Code,'BASIC');
                                                                        //    MESSAGE('Netsalary%1',FosaAcc."Net Salary");
                                                                            LoanAppraisalSalaryDetails.Amount:=FosaAcc."Net Salary";
                                                                            LoanAppraisalSalaryDetails.Basic:=TRUE;
                                                                            LoanAppraisalSalaryDetails."Loan No":="Loan  No.";
                                                                            LoanAppraisalSalaryDetails."Client Code":="Client Code";
                                                                            LoanAppraisalSalaryDetails.INSERT;
                                                                            END
                                                                            END ELSE BEGIN
                                                                                 // ERROR(Err_MemNo);
                                                                              END;
                                                                     END;

                                                                   FosaAcc.RESET;
                                                                   FosaAcc.SETRANGE(FosaAcc."BOSA Account No","Client Code");
                                                                   IF FosaAcc.FINDFIRST THEN
                                                                      IF NOT FosaAcc."Salary Processing" THEN BEGIN
                                                                        // ERROR(Err_SalThroughFosa,"Client Name");
                                                                         //IF NOT CONFIRM(err_sal,FALSE) THEN
                                                                        //   ERROR(operationstopped,USERID);
                                                                        END;
                                                                  END;


                                                                IF "Recovery Mode"="Recovery Mode"::Pension THEN BEGIN
                                                                    IF NOT Posted THEN BEGIN
                                                                        FosaAcc.RESET;
                                                                        FosaAcc.SETRANGE(FosaAcc."BOSA Account No","Client Code");
                                                                        IF FosaAcc.FINDFIRST THEN BEGIN
                                                                          IF FosaAcc."Net Salary"<>0 THEN BEGIN
                                                                            VendLedge.RESET;
                                                                            VendLedge.SETRANGE(VendLedge."Vendor No.",FosaAcc."No.");
                                                                            VendLedge.SETFILTER(VendLedge."Document No.",'*PENSION*');
                                                                            IF VendLedge.FINDLAST THEN
                                                                            LoanAppraisalSalaryDetails.RESET;
                                                                            LoanAppraisalSalaryDetails.SETRANGE("Loan No","Loan  No.");
                                                                            LoanAppraisalSalaryDetails.SETRANGE("Client Code","Client Code");
                                                                            IF LoanAppraisalSalaryDetails.FINDFIRST THEN
                                                                              LoanAppraisalSalaryDetails.DELETEALL;

                                                                            LoanAppraisalSalaryDetails.INIT;
                                                                            LoanAppraisalSalaryDetails."Appraisal Type":=LoanAppraisalSalaryDetails."Appraisal Type"::Salary;
                                                                            LoanAppraisalSalaryDetails.Amount:=VendLedge.Amount;
                                                                            LoanAppraisalSalaryDetails.Basic:=TRUE;
                                                                            LoanAppraisalSalaryDetails."Loan No":="Loan  No.";
                                                                            LoanAppraisalSalaryDetails."Client Code":="Client Code";
                                                                            LoanAppraisalSalaryDetails.INSERT;
                                                                            END
                                                                            END ELSE BEGIN
                                                                                //  ERROR(Err_MemNo);
                                                                              END;
                                                                     END;

                                                                   FosaAcc.RESET;
                                                                   FosaAcc.SETRANGE(FosaAcc."BOSA Account No","Client Code");
                                                                   IF FosaAcc.FINDFIRST THEN
                                                                      IF NOT FosaAcc."Salary Processing" THEN BEGIN
                                                                       //  ERROR(Err_SalThroughFosa,"Client Name");
                                                                        END;
                                                                         //IF NOT CONFIRM(err_sal,FALSE) THEN
                                                                        //   ERROR(operationstopped,USERID);
                                                                  END;
                                                                //END;
                                                              END;

                                                   OptionCaptionML=[ENU=Checkoff,Standing Order,Salary,Pension,Direct Debits,Mobile;
                                                                    ENG=Checkoff,Standing Order,Salary,Pension,Direct Debits];
                                                   OptionString=Checkoff,Standing Order,Salary,Pension,Direct Debits,Mobile }
    { 69025;  ;Repayment Frequency ;Option        ;OnValidate=BEGIN
                                                                IF "Repayment Frequency"="Repayment Frequency"::Daily THEN
                                                                EVALUATE("Instalment Period",'1D')
                                                                ELSE IF "Repayment Frequency"="Repayment Frequency"::Weekly THEN
                                                                EVALUATE("Instalment Period",'1W')
                                                                ELSE IF "Repayment Frequency"="Repayment Frequency"::Monthly THEN
                                                                EVALUATE("Instalment Period",'1M')
                                                                ELSE IF "Repayment Frequency"="Repayment Frequency"::Quaterly THEN
                                                                EVALUATE("Instalment Period",'1Q');
                                                              END;

                                                   OptionCaptionML=ENU=Daily,Weekly,Monthly,Quaterly;
                                                   OptionString=Daily,Weekly,Monthly,Quaterly }
    { 69026;  ;Approval Status     ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected;
                                                   Editable=Yes }
    { 69027;  ;Old Vendor No       ;Code20         }
    { 69028;  ;Insurance 0.25      ;Decimal        }
    { 69029;  ;Total TopUp Commission;Decimal     ;FieldClass=Normal }
    { 69030;  ;Total loan Outstanding;Decimal     ;FieldClass=Normal }
    { 69031;  ;Monthly Shares Cont ;Decimal        }
    { 69032;  ;Insurance On Shares ;Decimal        }
    { 69033;  ;Total Loan Repayment;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register"."Loan Principle Repayment" WHERE (Client Code=FIELD(Client Code),
                                                                                                                      Outstanding Balance=FILTER(>1))) }
    { 69034;  ;Total Loan Interest ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register"."Loan Interest Repayment" WHERE (Client Code=FIELD(Client Code),
                                                                                                                     Outstanding Balance=FILTER(>1))) }
    { 69035;  ;Net Payment to FOSA ;Decimal        }
    { 69036;  ;Processed Payment   ;Boolean        }
    { 69037;  ;Date payment Processed;Date         }
    { 69038;  ;Attached Amount     ;Decimal        }
    { 69039;  ;PenaltyAttached     ;Decimal        }
    { 69040;  ;InDueAttached       ;Decimal        }
    { 69041;  ;Attached            ;Boolean        }
    { 69042;  ;Advice Date         ;Date           }
    { 69043;  ;Attachement Date    ;Date           }
    { 69044;  ;Total Loans Outstanding;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Transaction Type=FILTER(Loan|Repayment),
                                                                                                       Loan Type=FILTER(<>ADV|ASSET|B/L|FL|IPF))) }
    { 69045;  ;Jaza Deposits       ;Decimal       ;OnValidate=BEGIN

                                                                //LoanType.GET("Loan Product Type");
                                                                LoanApp.RESET;
                                                                LoanApp.SETRANGE(LoanApp."Client Code","Client Code");
                                                                IF LoanApp.FIND('-') THEN BEGIN
                                                                Mdep:="Member Deposits"*3;
                                                                MESSAGE('Member Deposits *3 is %1',Mdep);

                                                                IF "Jaza Deposits" > Mdep  THEN
                                                                ERROR('Jaza deposits can not be more than 3 times the deposits');

                                                                //"Jaza Deposits":=ROUND(Mdep,1,'<' );
                                                                IF "Jaza Deposits">Mdep THEN
                                                                "Jaza Deposits":=Mdep
                                                                ELSE
                                                                "Jaza Deposits":="Jaza Deposits"

                                                                END;
                                                                MODIFY;

                                                                IF LoanTyped.GET("Loan Product Type") THEN BEGIN
                                                                IF "Jaza Deposits" > LoanTyped."Jaza Max Boosting Amount" THEN BEGIN
                                                                ERROR('Amount Entered is Greater than recommended Max. Jaza Deposits of %1',LoanTyped."Jaza Max Boosting Amount");
                                                                END;
                                                                END;
                                                                IF LoanTyped.GET("Loan Product Type") THEN BEGIN
                                                                IF "Jaza Deposits" < LoanTyped."Jaza Min Boosting Amount" THEN BEGIN
                                                                ERROR('Amount Entered is Less than recommended Min. Jaza Deposits of %1',LoanTyped."Jaza Min Boosting Amount");
                                                                END;
                                                                END;
                                                                PCharges.RESET;
                                                                PCharges.SETRANGE(PCharges."Product Code","Loan Product Type");
                                                                IF PCharges.FIND('-') THEN BEGIN
                                                                "Levy On Jaza Deposits":="Jaza Deposits"*(PCharges.Percentage/100);
                                                                MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 69046;  ;Member Deposits     ;Decimal       ;Editable=No }
    { 69047;  ;Levy On Jaza Deposits;Decimal       }
    { 69048;  ;Min Deposit As Per Tier;Decimal     }
    { 69049;  ;Total Repayments    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register"."Loan Principle Repayment" WHERE (Client Code=FIELD(Client Code),
                                                                                                                      Outstanding Balance=FILTER(>0))) }
    { 69050;  ;Total Interest      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans Register"."Loan Interest Repayment" WHERE (Client Code=FIELD(Client Code),
                                                                                                                     Outstanding Balance=FILTER(>0))) }
    { 69051;  ;Bridged             ;Boolean        }
    { 69052;  ;Deposit Reinstatement;Decimal       }
    { 69053;  ;Member Found        ;Boolean        }
    { 69054;  ;Recommended Amount  ;Decimal       ;OnValidate=BEGIN
                                                                IF "Recommended Amount" = 0 THEN
                                                                  "Recommended Amount" :="Approved Amount";
                                                                MODIFY;
                                                              END;
                                                               }
    { 69055;  ;Previous Years Dividend;Decimal     }
    { 69056;  ;partially Bridged   ;Boolean        }
    { 69057;  ;loan  Interest      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Loan No=FIELD(Loan  No.),
                                                                                                       Transaction Type=FILTER(Interest Paid|Interest Due),
                                                                                                       Posting Date=FIELD(Date filter)));
                                                   Editable=No }
    { 69058;  ;BOSA Deposits       ;Decimal        }
    { 69059;  ;Topup Commission    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loan Offset Details".Commision WHERE (Loan No.=FIELD(Loan  No.))) }
    { 69060;  ;Topup iNTEREST      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loan Offset Details"."Interest Top Up" WHERE (Loan No.=FIELD(Loan  No.))) }
    { 69061;  ;No of Gurantors FOSA;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loan GuarantorsFOSA" WHERE (Loan No=FIELD(Loan  No.),
                                                                                                  Substituted=CONST(No))) }
    { 69062;  ;Loan No Found       ;Boolean        }
    { 69063;  ;Checked By          ;Code30         }
    { 69064;  ;Approved By         ;Code30         }
    { 69065;  ;New Repayment Period;Integer       ;OnValidate=BEGIN
                                                                //Reschedule
                                                                //Surestep
                                                                {IF Posted=TRUE THEN BEGIN
                                                                StatusPermissions.RESET;
                                                                StatusPermissions.SETRANGE(StatusPermissions."Account No",USERID);
                                                                StatusPermissions.SETRANGE(StatusPermissions.Name,StatusPermissions.Name::"27");
                                                                IF StatusPermissions.FIND('-') = FALSE THEN
                                                                ERROR('You do not have permissions to Reschedule Loans.');
                                                                 END;







                                                                 "Checked By":=USERID;
                                                                {IF "New Repayment Period" > Installments THEN BEGIN
                                                                ERROR('you cannot reshedule loan  more than the original installments');
                                                                END;
                                                                Enddates:= CALCDATE(FORMAT("New Repayment Period")+'M',"Repayment Start Date");
                                                                //MESSAGE('Enddates is %1',Enddates);
                                                                IF "Expected Date of Completion"< CALCDATE(FORMAT("New Repayment Period")+'M',"Repayment Start Date") THEN

                                                                ERROR('you cannot reshedule loan  more than the original installments');
                                                                     }

                                                                Installments:="New Repayment Period";
                                                                ///IF CALCDATE(GenSetUp."Min. Loan Application Period",CustomerRecord."Registration Date") > TODAY THEN
                                                                }
                                                              END;
                                                               }
    { 69066;  ;Rejected By         ;Code30         }
    { 69067;  ;Loans Insurance     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Transaction Type=FILTER(Insurance Charge|Insurance Paid),
                                                                                                       Loan No=FIELD(Loan  No.))) }
    { 69068;  ;Last Int Date       ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Max("Member Ledger Entry"."Posting Date" WHERE (Customer No.=FIELD(Client Code),
                                                                                                               Loan No=FIELD(Loan  No.),
                                                                                                               Transaction Type=FILTER(Interest Due))) }
    { 69069;  ;Approval remarks    ;Code30         }
    { 69070;  ;Loan Disbursed Amount;Decimal       }
    { 69071;  ;Bank Bridge Amount  ;Decimal        }
    { 69072;  ;Approved Repayment  ;Decimal        }
    { 69073;  ;Rejection  Remark   ;Text40        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Approval Comment Line".Comment WHERE (Document No.=FIELD(Loan  No.)));
                                                   Editable=No }
    { 69074;  ;Original Approved Amount;Decimal    }
    { 69075;  ;Original Approved Updated;Boolean   }
    { 69076;  ;Print               ;Boolean        }
    { 69077;  ;Employer Name       ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.Name WHERE (No.=FIELD(Employer Code))) }
    { 69078;  ;Totals Loan Outstanding;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Transaction Type=FILTER(Loan|Repayment),
                                                                                                       Posting Date=FIELD(Date filter))) }
    { 69079;  ;Interest Upfront Amount;Decimal     }
    { 69080;  ;Loan Processing Fee ;Decimal        }
    { 69081;  ;Loan Appraisal Fee  ;Decimal        }
    { 69082;  ;Loan Insurance      ;Decimal        }
    { 69083;  ;TotalInterestCharged;Boolean        }
    { 69084;  ;Last IntcalcDate    ;Date           }
    { 69085;  ;Loan Collateral Fee ;Decimal        }
    { 69086;  ;Net Loan Disbursed  ;Decimal        }
    { 69087;  ;Bosa Loan Clearances;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Bosa Loan Clearances"."Approved Amount" WHERE (Main Loan Number=FIELD(Loan  No.),
                                                                                                                   Client Code=FIELD(Client Code),
                                                                                                                   Posted=CONST(Yes))) }
    { 69088;  ;Has BLA             ;Boolean        }
    { 69089;  ;Partial Disbursement;Boolean        }
    { 69090;  ;Partial Amount Disbursed;Decimal   ;OnValidate=BEGIN

                                                                IF NOT "Partial Disbursement" THEN
                                                                    ERROR('This Loan Application is not set for Partial Disbursment');
                                                              END;
                                                               }
    { 69091;  ;Boosting Shares     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Boosting Shares"."Boosting Amount" WHERE (Loan No.=FIELD(Loan  No.),
                                                                                                              Client Code=FIELD(Client Code))) }
    { 69092;  ;Entry Type          ;Option        ;OptionCaptionML=ENU=Insertion,Modification,Deletion;
                                                   OptionString=Insertion,Modification,Deletion }
    { 69093;  ;Master Loan No.     ;Code10        ;TableRelation="Partial Disbursment Table"."Loan No." WHERE (Disbursment Balance=FILTER(>0),
                                                                                                               Client Code=FIELD(Client Code));
                                                   OnValidate=BEGIN


                                                                IF NOT "Partial Disbursement" THEN
                                                                    ERROR('This Loan Application is not set for Partial Disbursment');

                                                                Partial.RESET;
                                                                IF Partial.GET("Master Loan No.") THEN BEGIN
                                                                   "Loan Product Type":=Partial."Loan Product Type";
                                                                   VALIDATE("Loan Product Type");
                                                                   "Requested Amount":=Partial."Requested Amount";
                                                                   "Approved Amount":=Partial."Approved Amount";
                                                                   IF "Recommended Amount" = 0 THEN BEGIN
                                                                   "Recommended Amount" := Partial."Approved Amount";
                                                                   MODIFY;
                                                                   END;
                                                                   "Partial Amount Disbursed":=Partial."Disbursment Balance";
                                                                   Installments:=Partial.Installments;

                                                                END;
                                                              END;

                                                   Description=//Daudi - to hold Master Loan No for partially disbursed loans }
    { 69094;  ;Bridge Shares       ;Decimal        }
    { 69095;  ;Discount Amount     ;Decimal        }
    { 69096;  ;Vendor No           ;Code20        ;TableRelation=Vendor.No. WHERE (Creditor Type=FILTER(<>Account));
                                                   OnValidate=BEGIN
                                                                IF LoanType.GET("Loan Product Type") THEN BEGIN
                                                                IF LoanType."Requires LPO"=FALSE THEN
                                                                ERROR('This is only applicable to LPO loans');
                                                                END;


                                                                VendLPO.RESET;
                                                                VendLPO.SETRANGE(VendLPO."No.","Vendor No");
                                                                IF VendLPO.FIND('-') THEN BEGIN
                                                                "Vendor Name":=VendLPO.Name;
                                                                END;
                                                              END;
                                                               }
    { 69097;  ;Vendor Name         ;Text30         }
    { 69098;  ;Monthly Repayment   ;Decimal        }
    { 69099;  ;Defaulted install   ;Decimal        }
    { 69100;  ;LastPayDateImport   ;Date           }
    { 69101;  ;Total Loans Default ;Decimal        }
    { 69102;  ;Installment Defaulted;Decimal       }
    { 69103;  ;old no              ;Code15        ;OnValidate=BEGIN
                                                                CustomerRecord.RESET;
                                                                CustomerRecord.SETRANGE(CustomerRecord."Old Account No.","old no");
                                                                IF CustomerRecord.FIND('-') THEN BEGIN
                                                                  "Client Code":=CustomerRecord."No.";
                                                                  END;
                                                              END;
                                                               }
    { 69104;  ;Eft Amount          ;Decimal        }
    { 69105;  ;Initial Approved Amount;Decimal     }
    { 69106;  ;Appeal Date         ;Date           }
    { 69107;  ;Appeal Loan         ;Boolean        }
    { 69108;  ;Appeal Batch No.    ;Code20        ;TableRelation="Loan Disburesment-Batching"."Batch No." WHERE (Batch Type=CONST(Appeal Loans)) }
    { 69109;  ;Tax Excempt         ;Boolean        }
    { 69110;  ;Group Account       ;Code40        ;TableRelation="Members Register".No. WHERE (Customer Posting Group=CONST(MICRO),
                                                                                               Group Account=CONST(Yes)) }
    { 69111;  ;Loan Officer        ;Code30        ;TableRelation="Loan Officers Details"."Account No." }
    { 69112;  ;Group Name          ;Text35         }
    { 69113;  ;Check Previous Tiers;Boolean       ;OnValidate=BEGIN

                                                                TESTFIELD("Reason Overriding Tiers");
                                                              END;
                                                               }
    { 69114;  ;Reason Overriding Tiers;Text35      }
    { 69115;  ;Loan Tier           ;Option        ;OptionCaptionML=ENU=" ,Tier One,Tier Two,Tier Three";
                                                   OptionString=[ ,Tier One,Tier Two,Tier Three] }
    { 69116;  ;Loan Tiers          ;Option        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Loan Products Setup"."Loan Tiers" WHERE (Code=FIELD(Loan Product Type)));
                                                   OptionCaptionML=ENU=" ,Tier One,Tier Two,Tier Three";
                                                   OptionString=[ ,Tier One,Tier Two,Tier Three] }
    { 69117;  ;Check Int           ;Boolean        }
    { 69118;  ;Phone No.           ;Text30         }
    { 69119;  ;Arears              ;Decimal        }
    { 69120;  ;Period In Arears    ;Decimal        }
    { 69121;  ;NHIF                ;Decimal        }
    { 69122;  ;NSSF                ;Decimal        }
    { 69123;  ;PAYE                ;Decimal       ;OnValidate=BEGIN
                                                                {ust.RESET;
                                                                cust.SETRANGE(cust."No.","No.");
                                                                IF cust.FIND('-') THEN BEGIN
                                                                cust.PAYE:=xRec.PAYE;
                                                                //cust.MODIFY;
                                                                MESSAGE('NIKO HAPA');
                                                                END;
                                                                         }
                                                              END;
                                                               }
    { 69124;  ;Basic Pay H         ;Decimal       ;OnValidate=VAR
                                                                ExisitingLoan@1120054000 : Record 51516230;
                                                              BEGIN
                                                                "Third basic":=0;
                                                                "Two Thirds Basic":=0;
                                                                "Total Earnings(Salary)":="Basic Pay H"+"Other Income.";
                                                                {
                                                                "Sacco Deductions":=0;
                                                                Loans.RESET;
                                                                Loans.SETRANGE(Loans."Client Code","Client Code");
                                                                Loans.SETRANGE(Loans.Posted,TRUE);
                                                                IF Loans.FIND('-') THEN BEGIN
                                                                 REPEAT
                                                                Loans.CALCFIELDS(Loans."Outstanding Balance");
                                                                IF Loans."Outstanding Balance">0 THEN BEGIN
                                                                "Sacco Deductions":="Sacco Deductions"+Loans."Adjted Repayment"+Loans."Loan Interest Repayment";
                                                                END;
                                                                UNTIL Loans.NEXT=0;
                                                                VALIDATE("Sacco Deductions");
                                                                END;
                                                                }

                                                                "Third basic":=1/3*"Basic Pay H";
                                                                "Two Thirds Basic":=2/3*"Basic Pay H";
                                                                IF "Recovery Mode"="Recovery Mode"::Salary THEN BEGIN
                                                                   "Third basic":=0.25*"Basic Pay H";
                                                                   "Two Thirds Basic":=0.75*"Basic Pay H";
                                                                   "Net take Home":=("Two Thirds Basic"+"Bridge Amount Release")-"Total Deductions(Salary)";
                                                                END ELSE BEGIN

                                                                   "Net take Home":="Two Thirds Basic"-"Check off Deductions";
                                                                END;
                                                              END;

                                                   Description=Payslip Details }
    { 69125;  ;Medical AllowanceH  ;Decimal       ;OnValidate=BEGIN
                                                                {IF "Basic Pay H">500000 THEN
                                                                ERROR('Basic pay is above maximum expected'); }
                                                              END;
                                                               }
    { 69126;  ;House AllowanceH    ;Decimal       ;OnValidate=BEGIN
                                                                {IF "Basic Pay H">500000 THEN
                                                                ERROR('Basic pay is above maximum expected');  }
                                                              END;
                                                               }
    { 69127;  ;Gross Pay           ;Decimal        }
    { 69128;  ;Total DeductionsH   ;Decimal        }
    { 69129;  ;Utilizable Amount   ;Decimal        }
    { 69130;  ;Net Utilizable Amount;Decimal       }
    { 69131;  ;Net take Home       ;Decimal        }
    { 69132;  ;Other Tax Relief    ;Decimal        }
    { 69133;  ;Disabled            ;Boolean        }
    { 69134;  ;Staff Assement      ;Decimal       ;OnValidate=BEGIN
                                                                {IF "Staff Assement">500000 THEN
                                                                ERROR('Staff Assement is above maximum expected');
                                                                }
                                                              END;
                                                               }
    { 69135;  ;Pension             ;Decimal       ;OnValidate=BEGIN
                                                                {IF Pension>500000 THEN
                                                                ERROR('Pension is above maximum expected');
                                                                }
                                                              END;
                                                               }
    { 69136;  ;Medical Insurance   ;Decimal       ;OnValidate=BEGIN
                                                                {IF "Medical Insurance">500000 THEN
                                                                ERROR('Medical Insurance is above maximum expected');
                                                                }
                                                              END;
                                                               }
    { 69137;  ;Life Insurance      ;Decimal       ;OnValidate=BEGIN
                                                                {IF "Life Insurance">500000 THEN
                                                                ERROR('Life Insurance is above maximum expected');
                                                                }
                                                              END;
                                                               }
    { 69138;  ;Other Liabilities   ;Decimal       ;OnValidate=BEGIN
                                                                {IF "House AllowanceH">500000 THEN
                                                                ERROR('Other Allowances is above maximum expected');
                                                                }
                                                              END;
                                                               }
    { 69139;  ;Transport/Bus Fare  ;Decimal        }
    { 69140;  ;Other Income        ;Code10        ;OnValidate=BEGIN
                                                                {OtherInc.RESET;
                                                                OtherInc.SETRANGE(OtherInc.Code,"Other Income");
                                                                IF OtherInc.FIND('-') THEN BEGIN
                                                                  "Other Incomes Amount":=OtherInc.Amount;
                                                                END;
                                                                }
                                                              END;
                                                               }
    { 69141;  ;Pension Scheme      ;Decimal        }
    { 69142;  ;Other Non-Taxable   ;Decimal        }
    { 69143;  ;Monthly Contribution;Decimal        }
    { 69144;  ;Sacco Deductions    ;Decimal        }
    { 69145;  ;Other Loans Repayments;Decimal      }
    { 69146;  ;Bridge Amount Release;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loan Offset Details"."Monthly Repayment" WHERE (Client Code=FIELD(Client Code),
                                                                                                                    Loan No.=FIELD(Loan  No.)));
                                                   Description=End Payslip Details }
    { 69147;  ;Exempted from PAYE  ;Boolean        }
    { 69148;  ;Total Outstanding Loan BAL;Decimal  }
    { 69149;  ;Offset Loan         ;Boolean        }
    { 69150;  ;Reason For Loan Rejection;Text40    }
    { 69151;  ;Existing Loan Repayments;Decimal    }
    { 69152;  ;Third basic         ;Decimal        }
    { 69153;  ;Two Thirds Basic    ;Decimal        }
    { 69154;  ;Other Income.       ;Decimal       ;OnValidate=BEGIN
                                                                "Total Earnings(Salary)":="Basic Pay H"+"Other Income.";
                                                                //MESSAGE('BridgeAmount%1THirdBasic%2',"Bridge Amount Release","Third basic");
                                                                "Net take Home":=("Total Earnings(Salary)"+"Bridge Amount Release")-"Third basic";
                                                              END;
                                                               }
    { 69155;  ;Appraised By        ;Code30         }
    { 69156;  ;Disbursed By        ;Code30         }
    { 69157;  ;Registration Time   ;Time           }
    { 69158;  ;Emp Loan Codes      ;Code15         }
    { 69159;  ;Defaulted Loan      ;Code20         }
    { 69160;  ;LoantypeCode        ;Code25         }
    { 69161;  ;Reason for rejection;Code55         }
    { 69162;  ;DocLink             ;Integer        }
    { 69163;  ;Reason for Loan Re-open;Code10      }
    { 69164;  ;Registration Date   ;Date          ;TableRelation="Members Register" }
    { 69165;  ;Other Deductions    ;Decimal        }
    { 69166;  ;Do not Charge Interest;Boolean      }
    { 69167;  ;View Schedule       ;Boolean        }
    { 69168;  ;Appraised Date      ;Date           }
    { 69169;  ;Approved Date       ;Date           }
    { 69170;  ;Disbursement Date   ;Date           }
    { 69180;  ;WriteOff            ;Boolean        }
    { 51516000;;Loans Category-SACCO;Option       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("SACCO Categorization"."Loans Category-SACCO" WHERE (Loan No.=FIELD(Loan  No.)));
                                                   OptionCaptionML=ENU=Perfoming,Watch,Substandard,Doubtful,Loss;
                                                   OptionString=Perfoming,Watch,Substandard,Doubtful,Loss }
    { 51516001;;Days in Arrears-SASRA;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("SACCO Categorization"."Defaulted Days" WHERE (Loan No.=FIELD(Loan  No.))) }
    { 51516002;;Months in Arrears-SASRA;Integer   ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("SACCO Categorization"."Defaulted Months" WHERE (Loan No.=FIELD(Loan  No.))) }
    { 51516003;;Financial Year     ;Date          ;OnValidate=BEGIN

                                                                IF AsAt = 0D THEN
                                                                    AsAt:=TODAY;
                                                              END;
                                                               }
    { 51516004;;Outstanding Balance At Date;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Loan No=FIELD(Loan  No.),
                                                                                                       Transaction Type=FILTER(Loan|Repayment),
                                                                                                       Currency Code=FIELD(Currency Filter),
                                                                                                       Posting Date=FIELD(Date filter)));
                                                   Editable=No }
    { 51516005;;Main Sector        ;Code10        ;TableRelation="Loan Sectors".Code }
    { 51516006;;Sub-Sector         ;Code10         }
    { 51516007;;Specific Sector    ;Code10         }
    { 51516008;;Staff Loan         ;Boolean        }
    { 51516009;;MonthOne           ;Boolean        }
    { 51516010;;MonthTwo           ;Boolean        }
    { 51516011;;MonthThree         ;Boolean        }
    { 51516012;;MonthFour          ;Boolean        }
    { 51516013;;MonthFive          ;Boolean        }
    { 51516014;;MonthSix           ;Boolean        }
    { 51516015;;Marked For Sms Alert;Boolean       }
    { 51516016;;Days In Arrears    ;Integer       ;Editable=No }
    { 51516017;;Mobile Loan        ;Boolean        }
    { 51516018;;Last Mobile Loan Rem. Date;Date    }
    { 51516019;;Oustanding Penalty ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Loan No=FIELD(Loan  No.),
                                                                                                       Transaction Type=FILTER(Penalty Charged|Penalty Paid),
                                                                                                       Posting Date=FIELD(Date filter))) }
    { 51516020;;Check off Deductions;Decimal       }
    { 51516021;;Express Loan       ;Boolean       ;Editable=No }
    { 51516022;;interest upfront1  ;Decimal        }
    { 51516023;;interest upfront Amount1;Decimal   }
    { 51516024;;Terms of Service   ;Option        ;OptionCaptionML=ENU=,Permanent,Temporary,Contract;
                                                   OptionString=,Permanent,Temporary,Contract }
    { 51516025;;Designation        ;Text40         }
    { 51516026;;Workstation        ;Text40         }
    { 51516027;;Gross monthly Income;Decimal       }
    { 51516028;;Estimated Monthly Expense;Decimal  }
    { 51516029;;Estimated Net Monthly Income;Decimal }
    { 51516030;;Repayment Amount (New);Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(BOSA No),
                                                                                                        Loan No=FIELD(Loan  No.),
                                                                                                        Transaction Type=FILTER(Repayment|Interest Paid))) }
    { 51516031;;Outstanding Total Loan;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(BOSA No),
                                                                                                       Loan No=FIELD(Loan  No.))) }
    { 51516032;;Debt Collectors Name;Text30       ;TableRelation="Debt Collectors Details"."Collectors Name";
                                                   OnValidate=VAR
                                                                Collector@1120054000 : Record 51516918;
                                                              BEGIN
                                                                CALCFIELDS("Outstanding Balance","Oustanding Interest");
                                                                TotalOutstandingAmount:="Outstanding Balance"+"Oustanding Interest";
                                                                Collector.RESET;
                                                                Collector.SETRANGE(Collector."Collectors Name","Debt Collectors Name");
                                                                IF Collector.FINDFIRST THEN BEGIN
                                                                "Debt Collector Commission":=Collector.Rate/100*TotalOutstandingAmount;
                                                                "VAT on Commission":=0.16*"Debt Collector Commission";
                                                                "Total Collection Amount":="Debt Collector Commission"+"VAT on Commission"+TotalOutstandingAmount;
                                                                END;
                                                              END;
                                                               }
    { 51516033;;Loan Arrears       ;Decimal        }
    { 51516034;;Days In Arrears.   ;Integer        }
    { 51516035;;FOSA Balance       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FIELD(Account No))) }
    { 51516036;;Appraised Time     ;Time           }
    { 51516037;;Disbursed Time     ;Time           }
    { 51516038;;Expected Disbursement Time;Time    }
    { 51516039;;Approved Time      ;Time           }
    { 51516040;;Other Incomes      ;Decimal       ;OnValidate=BEGIN
                                                                "Net take Home":="Other Income."+("Two Thirds Basic"-"Total Deductions(Salary)");
                                                              END;
                                                               }
    { 51516042;;Debtor Collection Status;Option   ;OptionCaptionML=ENU=,Debt Cleared,Debtor being Traced,Debtor Deceased,Disputing,Inability to Pay,Invalid Number,Negotiation in Process,Non-Committal,Phone Switched Off,Promised to Pay,Ringing No Response,Sick,Temporarily out of service,Unable to Trace,Wrong Number,No Contact provided;
                                                   OptionString=,Debt Cleared,Debtor being Traced,Debtor Deceased,Disputing,Inability to Pay,Invalid Number,Negotiation in Process,Non-Committal,Phone Switched Off,Promised to Pay,Ringing No Response,Sick,Temporarily out of service,Unable to Trace,Wrong Number,No Contact provided }
    { 51516044;;Defaulted Balance  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Transaction Type=FILTER(Loan|Repayment|Interest Due|Interest Paid|Penalty Charged|Penalty Paid),
                                                                                                       Customer No.=FIELD(Client Code),
                                                                                                       Loan No=FIELD(Loan  No.))) }
    { 51516045;;Agreed Instalments ;Integer        }
    { 51516046;;Agreed Amount      ;Decimal        }
    { 51516047;;Payment Date       ;Date          ;OnValidate=BEGIN
                                                                "Notification Date":=CALCDATE('-14D',"Payment Date");
                                                              END;
                                                               }
    { 51516048;;Notification Date  ;Date           }
    { 51516049;;Debt Collector Commission;Decimal  }
    { 51516050;;VAT on Commission  ;Decimal        }
    { 51516051;;Total Collection Amount;Decimal    }
    { 51516052;;No Of Defaulted Loans;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Loans Register" WHERE (BOSA No=FIELD(BOSA No),
                                                                                             Loans Category=FILTER(Substandard|Doubtful|Loss))) }
    { 51516053;;Totals Outstanding ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Member Ledger Entry".Amount WHERE (Customer No.=FIELD(Client Code),
                                                                                                       Loan No=FIELD(Loan  No.),
                                                                                                       Transaction Type=FILTER(Interest Paid|Interest Due|Repayment|Loan|Penalty Charged|Penalty Paid))) }
  }
  KEYS
  {
    {    ;Loan  No.                               ;Clustered=Yes }
    {    ;Posted                                   }
    {    ;Loan Product Type                       ;SumIndexFields=Requested Amount }
    {    ;Source,Client Code,Loan Product Type,Issued Date }
    {    ;Batch No.,Source,Loan Status,Loan Product Type;
                                                   SumIndexFields=Approved Amount,Appeal Amount }
    {    ;BOSA Loan No.,Account No,Batch No.       }
    {    ;Old Account No.                          }
    {    ;Client Code                              }
    {    ;Staff No                                 }
    {    ;BOSA No                                  }
    {    ;Loan Product Type,Client Code,Posted     }
    {    ;Client Code,Loan Product Type,Posted,Issued Date;
                                                   SumIndexFields=Approved Amount }
    {    ;Loan Product Type,Application Date,Posted;
                                                   SumIndexFields=Approved Amount }
    {    ;Source,Mode of Disbursement,Issued Date,Posted;
                                                   SumIndexFields=Approved Amount }
    {    ;Issued Date,Loan Product Type           ;SumIndexFields=Approved Amount }
    {    ;Application Date                         }
    {    ;Client Code,Old Account No.              }
    {    ;Group Code                               }
    {    ;Account No                               }
    {    ;Source,Issued Date,Loan Product Type,Client Code }
    {    ;Client Code,Loan Product Type            }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Loan  No.,Loan Product Type Name,Outstanding Balance,Oustanding Interest }
  }
  CODE
  {
    VAR
      SalesSetup@1000000001 : Record 51516258;
      NoSeriesMgt@1000000000 : Codeunit 396;
      LoanType@1000000002 : Record 51516240;
      CustomerRecord@1000000004 : Record 51516223;
      i@1000000006 : Integer;
      PeriodDueDate@1000000008 : Date;
      Gnljnline@1000000009 : Record 81;
      Jnlinepost@1000000010 : Codeunit 12;
      CumInterest@1000000011 : Decimal;
      NewPrincipal@1000000012 : Decimal;
      PeriodPrRepayment@1000000013 : Decimal;
      GenBatch@1000000014 : Record 232;
      LineNo@1000000015 : Integer;
      GnljnlineCopy@1000000016 : Record 81;
      NewLNApplicNo@1000000018 : Code[10];
      IssuedDate@1000000019 : Date;
      GracePerodDays@1000000020 : Integer;
      InstalmentDays@1000000021 : Integer;
      GracePeiodEndDate@1000000022 : Date;
      InstalmentEnddate@1000000023 : Date;
      NoOfGracePeriod@1000000024 : Integer;
      G@1000000025 : Integer;
      RunningDate@1000000026 : Date;
      NewSchedule@1000000027 : Record 51516234;
      ScheduleCode@1000000028 : Code[30];
      GP@1000000029 : Text[30];
      Groups@1000000031 : Record 51516243;
      PeriodInterval@1000000032 : Code[10];
      GLSetup@1000000033 : Record 98;
      Users@1000000034 : Record 2000000120;
      FlatPeriodInterest@1000000037 : Decimal;
      FlatRateTotalInterest@1000000036 : Decimal;
      FlatPeriodInterval@1000000035 : Code[10];
      ProdCycles@1000000038 : Record 51516243;
      LoanApp@1000000039 : Record 51516230;
      MemberCycle@1000000040 : Integer;
      PCharges@1000000043 : Record 51516242;
      TCharges@1000000042 : Decimal;
      LAppCharges@1000000041 : Record 51516244;
      Vendor@1102760000 : Record 23;
      Cust@1102760001 : Record 51516223;
      Vend@1102760002 : Record 23;
      Cust2@1102760003 : Record 51516223;
      TotalMRepay@1102760004 : Decimal;
      LPrincipal@1102760005 : Decimal;
      LInterest@1102760006 : Decimal;
      InterestRate@1102760007 : Decimal;
      LoanAmount@1102760008 : Decimal;
      RepayPeriod@1102760009 : Integer;
      LBalance@1102760010 : Decimal;
      UsersID@1102760011 : Record 2000000120;
      LoansBatches@1102760012 : Record 51516236;
      Employer@1102760013 : Record 51516260;
      GenSetUp@1102760014 : Record 51516257;
      Batches@1102760015 : Record 51516236;
      MovementTracker@1102760017 : Record 51516253;
      SpecialComm@1102760018 : Decimal;
      CustR@1102760019 : Record 51516223;
      RAllocation@1102760020 : Record 51516246;
      "Standing Orders"@1102760021 : Record 51516307;
      StatusPermissions@1102760022 : Record 51516310;
      CustLedg@1102760023 : Record 51516224;
      LoansClearedSpecial@1102760024 : Record 51516238;
      BridgedLoans@1102756000 : Record 51516238;
      Loan@1102755001 : Record 51516230;
      banks@1102755002 : Record 270;
      DefaultInfo@1102755003 : Text[180];
      sHARES@1102755004 : Decimal;
      MonthlyRepayT@1102755005 : Decimal;
      MonthlyRepay@1102755006 : Decimal;
      CurrExchRate@1102755007 : Record 330;
      RepaySched@1102755008 : Record 51516234;
      currYear@1102755009 : Integer;
      StartDate@1102755010 : Date;
      EndDate@1102755011 : Date;
      Month@1102755012 : Integer;
      Mwezikwisha@1102755013 : Date;
      AvailDep@1102755000 : Decimal;
      LoansOut@1102755014 : Decimal;
      Mdep@1102755015 : Decimal;
      BANDING@1102755016 : Record 51516261;
      Band@1102755017 : Decimal;
      TotalOutstanding@1102755018 : Decimal;
      Insuarence@1102755019 : Decimal;
      ProdSetup@1120054003 : Record 51516240;
      LoanTyped@1102755020 : Record 51516240;
      DAY@1102755021 : Integer;
      loannums@1102755022 : Integer;
      Enddates@1102755023 : Date;
      Partial@1000000003 : Record 51516279;
      VendLPO@1000000005 : Record 23;
      DataSheet@1000000017 : Record 51516341;
      LoanTypes@1000000007 : Record 51516240;
      Text012@1000000030 : TextConst 'ENG=<Member does not have shares, therefore cannot qualify for any Loan>';
      LoanExemptInterest@1000000044 : Record 51516860;
      Register@1000000045 : Record 51516230;
      Lregister@1000000046 : Record 51516230;
      CheckoffMatrix@1000000047 : Record 51516286;
      Loans@1000000048 : Record 51516230;
      "Default Installments"@1120054000 : Record 51516240;
      LoanAppraisalSalaryDetails@1120054001 : Record 51516232;
      FosaAcc@1120054002 : Record 23;
      Perfoming@1120054004 : Option;
      AsAt@1120054005 : Date;
      AuditTrail@1120054008 : Codeunit 51516107;
      Trail@1120054007 : Record 51516655;
      EntryNo@1120054006 : Integer;
      DateOne@1120054009 : Date;
      DateTwo@1120054010 : Date;
      DateThree@1120054011 : Date;
      DateFour@1120054013 : Date;
      DateFive@1120054014 : Date;
      DateSix@1120054012 : Date;
      MembX@1120054015 : Record 51516223;
      MobileLoanAnalysis@1120054016 : Record 51516718;
      PayrollManagement@1120054017 : Codeunit 51516002;
      ThePayeeIs@1120054018 : Decimal;
      Vendors@1120054019 : Record 23;
      LoanProdType@1120054020 : Record 51516240;
      AmountToDeduct@1120054021 : Decimal;
      TotalOutstandingAmount@1120054022 : Decimal;
      VendR@1120054023 : Record 23;
      LoanOffsetDetails@1120054024 : Record 51516235;
      LoanOffsetDetail@1120054025 : Record 51516235;
      OffsetAmount@1120054026 : Decimal;
      LGuarantee@1120054027 : Record 51516231;

    PROCEDURE CreateAnnuityLoan@6();
    VAR
      LoanTypeRec@1000000002 : Record 51516240;
      LoopEndBool@1000000003 : Boolean;
      LineNoInt@1000000004 : Integer;
      PeriodCode@1000000005 : Code[10];
      InterestAmountDec@1000000006 : Decimal;
      RemainingPrincipalAmountDec@1000000007 : Decimal;
      RepaymentAmountDec@1000000008 : Decimal;
      RoundPrecisionDec@1000000009 : Decimal;
      RoundDirectionCode@1000000010 : Code[10];
    BEGIN
    END;

    PROCEDURE DebtService@3(Principal@1000000000 : Decimal;Interest@1000000001 : Decimal;PayPeriods@1000000002 : Integer) : Decimal;
    VAR
      PeriodInterest@1000000003 : Decimal;
    BEGIN
    END;

    PROCEDURE GetGracePeriod@1000000000();
    BEGIN
        IssuedDate:="Loan Disbursement Date";
        GracePeiodEndDate:=CALCDATE("Grace Period",IssuedDate);
        InstalmentEnddate:=CALCDATE("Instalment Period",IssuedDate);
        GracePerodDays:=GracePeiodEndDate-IssuedDate;
        InstalmentDays:=InstalmentEnddate-IssuedDate;
        IF InstalmentDays<>0 THEN
         NoOfGracePeriod:=ROUND(GracePerodDays/InstalmentDays,1);
    END;

    PROCEDURE FlatRateCalc@1000000002(VAR FlatLoanAmount@1000000000 : Decimal;VAR FlatInterestRate@1000000001 : Decimal) FlatRateCalc : Decimal;
    BEGIN
    END;

    LOCAL PROCEDURE SetCurrencyCode@4(AccType2@1000 : 'G/L Account,Customer,Vendor,Bank Account';AccNo2@1001 : Code[20]) : Boolean;
    BEGIN
      { := '';
      IF AccNo2 <> '' THEN
        CASE AccType2 OF
          AccType2::Customer:
            IF Cust2.GET(AccNo2) THEN
              "Currency Code" := Cust2."Currency Code";
          AccType2::Vendor:
            IF Vend2.GET(AccNo2) THEN
              "Currency Code" := Vend2."Currency Code";
          AccType2::"Bank Account":
            IF BankAcc2.GET(AccNo2) THEN
              "Currency Code" := BankAcc2."Currency Code";
        END;
      EXIT("Currency Code" <> '');
      }
    END;

    LOCAL PROCEDURE GetCurrency@1102755000();
    BEGIN
      {IF "Additional-Currency Posting" =
         "Additional-Currency Posting"::"Additional-Currency Amount Only"
      THEN BEGIN
        IF GLSetup."Additional Reporting Currency" = '' THEN
          GLSetup.GET;
        CurrencyCode := GLSetup."Additional Reporting Currency";
      END ELSE
        CurrencyCode := "Currency Code";

      IF CurrencyCode = '' THEN BEGIN
        CLEAR(Currency);
        Currency.InitRoundingPrecision
      END ELSE
        IF CurrencyCode <> Currency.Code THEN BEGIN
          Currency.GET(CurrencyCode);
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
       }
    END;

    LOCAL PROCEDURE FnCheckContribution@1120054000(ClientCode@1120054000 : Code[40];CheckDate@1120054001 : Date);
    VAR
      DateFilterx@1120054002 : Text;
      StartDate@1120054003 : Date;
      Enddate@1120054004 : Date;
      MembersR@1120054006 : Record 51516223;
      ContribAmount@1120054005 : Decimal;
    BEGIN

      StartDate:=CALCDATE('<-CM>',CheckDate);
      Enddate:=CALCDATE('<CM>',CheckDate);
      DateFilterx:=FORMAT(StartDate)+'..'+FORMAT(Enddate);

      MembersR.RESET;
      MembersR.SETRANGE(MembersR."No.","Client Code");
      MembersR.SETFILTER(MembersR."Date Filter",DateFilterx);
      IF MembersR.FINDFIRST THEN
      BEGIN
      ContribAmount:=0;
      MembersR.CALCFIELDS(MembersR."Current Shares");
      ContribAmount:=MembersR."Current Shares";
      IF ContribAmount>0 THEN BEGIN
      END ELSE BEGIN
      //ERROR('Member has not contributed deposits consistently for a period of six months.');
      END;
      END ELSE BEGIN
      //ERROR('You are supposed to have contributed deposits consistently for a period of six months.');
      END;
    END;

    PROCEDURE GetDefaultedAmounts@1120054001(WhichOption@1120054000 : 'AmountDefaulted,DaysInArrears';AsAt@1120054001 : Date;LoanNumber@1120054002 : Code[20]) : Decimal;
    VAR
      Ln@1120054003 : Record 51516230;
      AmountPaid@1120054004 : Decimal;
      AmountDefaulted@1120054005 : Decimal;
      DaysInArrears@1120054006 : Integer;
    BEGIN
      AmountDefaulted:=0; DaysInArrears:=0;

      Ln.RESET;
      Ln.SETRANGE("Loan  No.",LoanNumber);
      Ln.SETFILTER("Date filter",'..%1',AsAt);
      Ln.SETAUTOCALCFIELDS("Schedule Repayments","Total Repayment","Outstanding Balance","Oustanding Interest");
      Ln.SETFILTER("Outstanding Balance",'>0');
      Ln.SETFILTER(Repayment,'>0');
      IF Ln.FINDFIRST THEN BEGIN
        IF Ln."Outstanding Balance">Ln."Approved Amount" THEN
            UpdateAmounts(Ln);
        AmountPaid:=ABS(Ln."Total Repayment");
        AmountDefaulted:=Ln."Schedule Repayments"-AmountPaid;
        IF Ln."Oustanding Interest"<Ln."Outstanding Balance" THEN
          IF Ln."Oustanding Interest">0 THEN
             AmountDefaulted+=Ln."Oustanding Interest";
        IF AmountDefaulted<0 THEN
           AmountDefaulted:=0;
        DaysInArrears:=ROUND((AmountDefaulted/Ln.GetLoanExpectedRepayment(0,AsAt))*30,1,'=');
        IF Ln."Expected Date of Completion"<>0D THEN
          IF AsAt > Ln."Expected Date of Completion" THEN
              DaysInArrears += (AsAt-Ln."Expected Date of Completion");
        END;

      CASE WhichOption OF

           WhichOption::AmountDefaulted:EXIT(AmountDefaulted);
           WhichOption::DaysInArrears:EXIT(DaysInArrears);

        END;
    END;

    LOCAL PROCEDURE UpdateAmounts@1120054003(VAR Loan@1120054000 : Record 51516230);
    BEGIN
      WITH Loan DO BEGIN
      //    CALCFIELDS("Outstanding Balance");
          "Approved Amount":="Outstanding Balance";
          "Requested Amount":="Approved Amount";
          "Recommended Amount":="Approved Amount";

          IF (Interest>0) AND (Installments>0) THEN BEGIN

          IF "Repayment Method"="Repayment Method"::Amortised THEN BEGIN
            Repayment:=ROUND((Interest/12/100) / (1 - POWER((1 +(Interest/12/100)),- (Installments))) * ("Approved Amount"),0.05,'>');
            "Loan Interest Repayment":=ROUND("Approved Amount" / 100 / 12 * Interest,0.05,'>');
            "Loan Principle Repayment":=Repayment-"Loan Interest Repayment";
          END;

          IF "Repayment Method"="Repayment Method"::"Straight Line" THEN BEGIN
              "Loan Principle Repayment":=ROUND("Approved Amount"/Installments,0.05,'>');
              "Loan Interest Repayment":=ROUND((Interest/12/100)*"Approved Amount",0.05,'>');
              Repayment:="Loan Principle Repayment"+"Loan Interest Repayment";
          END;

          IF "Repayment Method"="Repayment Method"::"Reducing Balance" THEN BEGIN
              "Loan Principle Repayment":=ROUND("Approved Amount"/Installments,0.05,'>');
              "Loan Interest Repayment":=ROUND((Interest/12/100)*"Approved Amount",0.05,'>');
              Repayment:="Loan Principle Repayment"+"Loan Interest Repayment";
          END;

          IF "Repayment Method"="Repayment Method"::Constants THEN BEGIN

          IF "Approved Amount" < Repayment THEN
          "Loan Principle Repayment":="Approved Amount"
          ELSE
          "Loan Principle Repayment":="Approved Amount";
          "Loan Interest Repayment":=Interest;

          END;

           Loan.MODIFY;
           COMMIT;

          END;
      END;
    END;

    PROCEDURE GetRepaymentStartDate@1120054002() : Date;
    VAR
      DateToExit@1120054000 : Date;
      CheckoffEndDay@1120054001 : Date;
      SalaryEndDay@1120054002 : Date;
      EndMonthOfIssuedDate@1120054003 : Date;
      NextEndMonthAfterIssuedDate@1120054004 : Date;
    BEGIN
      IF "Issued Date"=0D THEN EXIT(0D);

      GenSetUp.GET;
      GenSetUp.TESTFIELD("Checkoff Cutoff Days");
      GenSetUp.TESTFIELD("Salary Cutoff Days");
      EndMonthOfIssuedDate:=CALCDATE('CM',"Issued Date");
      NextEndMonthAfterIssuedDate:=CALCDATE('1M+CM',"Issued Date");
      DateToExit:=EndMonthOfIssuedDate;
      CASE "Recovery Mode" OF
        Rec."Recovery Mode"::Checkoff:
          BEGIN
              CheckoffEndDay:=CALCDATE(GenSetUp."Checkoff Cutoff Days",CALCDATE('-CM',"Issued Date"));
              IF "Issued Date">=CheckoffEndDay THEN
                 DateToExit:=NextEndMonthAfterIssuedDate;
            END;
        ELSE BEGIN
             SalaryEndDay:=CALCDATE(GenSetUp."Salary Cutoff Days",CALCDATE('-CM',"Issued Date"));
             IF "Issued Date">=SalaryEndDay THEN
                 DateToExit:=NextEndMonthAfterIssuedDate;
        END;
        END;

      EXIT(DateToExit);
    END;

    PROCEDURE GetLatestPayment@1120054004() : Decimal;
    VAR
      MembLedger@1120054000 : Record 51516224;
    BEGIN
      MembLedger.RESET;
      MembLedger.SETRANGE(MembLedger."Loan No","Loan  No.");
      MembLedger.SETRANGE(MembLedger."Transaction Type",MembLedger."Transaction Type"::Repayment);
      MembLedger.SETRANGE(MembLedger.Reversed,FALSE);
      MembLedger.SETFILTER(MembLedger.Amount,'<0');
      IF MembLedger.FINDLAST THEN
        EXIT(MembLedger.Amount);
      EXIT(0);
    END;

    PROCEDURE GetLoanExpectedRepayment@1120054005(ReturnOption@1120054000 : 'Repayment,Principal,Interest';AsAt@1120054002 : Date) : Decimal;
    VAR
      RSch@1120054001 : Record 51516234;
      MRep@1120054003 : Decimal;
      MPrinc@1120054004 : Decimal;
      MInt@1120054005 : Decimal;
    BEGIN
      MRep:=0;MPrinc:=0;MInt:=0;
      RSch.RESET;
      RSch.SETRANGE(RSch."Loan No.","Loan  No.");
      RSch.SETRANGE(RSch."Repayment Date",0D,AsAt);
      RSch.SETRANGE(RSch."Close Schedule",FALSE);
      IF RSch.FINDLAST THEN BEGIN
         MRep:=RSch."Monthly Repayment";
         MInt:=RSch."Monthly Interest";
         MPrinc:=RSch."Principal Repayment";
        END;

      IF MRep=0 THEN BEGIN
         RSch.RESET;
         RSch.SETRANGE(RSch."Loan No.","Loan  No.");
         IF RSch.FINDLAST THEN BEGIN
            MRep:=RSch."Monthly Repayment";
            MPrinc:=RSch."Principal Repayment";
            MInt:=RSch."Monthly Interest";
          END;
        END;


      IF MRep=0 THEN BEGIN
          MRep:=Repayment;
          MPrinc:="Loan Principle Repayment";
          MInt:="Loan Interest Repayment";
        END;


      CASE ReturnOption OF
        ReturnOption::Repayment:EXIT(ROUND(MRep,1,'>'));
        ReturnOption::Principal:EXIT(ROUND(MPrinc,1,'>'));
        ReturnOption::Interest:EXIT(ROUND(MInt,1,'>'));
        END;
    END;

    PROCEDURE InterestBalanceAsAt@1120054006(AsAt@1120054000 : Date) : Decimal;
    VAR
      MembLedger@1120054001 : Record 51516224;
    BEGIN
      MembLedger.RESET;
      MembLedger.SETRANGE(MembLedger."Loan No","Loan  No.");
      MembLedger.SETFILTER(MembLedger."Transaction Type",'%1|%2',MembLedger."Transaction Type"::"Interest Paid",MembLedger."Transaction Type"::"Interest Due");
      MembLedger.SETRANGE("Posting Date",0D,AsAt);
      MembLedger.SETFILTER(MembLedger."Document No.",'<>%1','');
      IF MembLedger.FINDFIRST THEN BEGIN
          MembLedger.CALCSUMS(MembLedger.Amount);
          EXIT(MembLedger.Amount);
        END;
    END;

    PROCEDURE OffsetCondition@1120054007();
    VAR
      Loan@1120054000 : Record 51516230;
      LoanOffset@1120054001 : Record 51516235;
      err_offset@1120054002 : TextConst 'ENU=Loan %1, must be inserted in the loan offset details';
    BEGIN
      Loan.RESET;
      Loan.SETRANGE("Loan Product Type",Rec."Loan Product Type");
      Loan.SETFILTER("Outstanding Balance",'>0');
      Loan.SETRANGE("Client Code","Client Code");
      IF Loan.FINDSET THEN
      REPEAT
         LoanOffset.RESET;
         LoanOffset.SETRANGE("Loan Top Up",Loan."Loan  No.");
         IF NOT LoanOffset.FINDFIRST THEN
            ERROR(err_offset,Loan."Loan  No." +' '+ Loan."Loan Product Type");
      UNTIL Loan.NEXT = 0;
    END;

    PROCEDURE MarkLoanAsExpress@1120054008();
    VAR
      LoanBatch@1120054000 : Record 51516236;
      cnfm_express@1120054001 : TextConst 'ENU=Sure to Mark this loan as an express loan?';
      SaccoGeneralSetUp@1120054002 : Record 51516257;
    BEGIN
      IF CONFIRM(cnfm_express,FALSE) THEN BEGIN
         SaccoGeneralSetUp.GET;
         SaccoGeneralSetUp.TESTFIELD(SaccoGeneralSetUp."Express Loan Charge");
          LoanBatch.INIT;
          LoanBatch."Batch Type":=LoanBatch."Batch Type"::Loans;
          LoanBatch.Source:=Source;
          LoanBatch."Description/Remarks":= "Loan Product Type Name" + ' Express';
          LoanBatch."Mode Of Disbursement":= LoanBatch."Mode Of Disbursement"::"Transfer to FOSA";
          IF LoanBatch.INSERT(TRUE) THEN BEGIN

              "Batch No." := LoanBatch."Batch No.";
              "Express Loan" := TRUE;
              MODIFY;

                 MESSAGE('Loan marked for express charges, %1 will be charged on the loan', SaccoGeneralSetUp."Express Loan Charge"*0.01*"Approved Amount");
          END ELSE MESSAGE('Operation failed!');

      END;
    END;

    LOCAL PROCEDURE FnCheckDeductions@1120054014(CLientCode@1120054000 : Code[10]) : Decimal;
    VAR
      StandingOrders@1120054002 : Record 51516307;
    BEGIN
      StandingOrders.RESET;
      StandingOrders.SETRANGE(StandingOrders."BOSA Account No.","Client Code");
      StandingOrders.SETRANGE(StandingOrders.Status,StandingOrders.Status::Approved);
      IF StandingOrders.FINDFIRST THEN BEGIN
      REPEAT
      AmountToDeduct:=AmountToDeduct+StandingOrders.Amount;
      UNTIL StandingOrders.NEXT=0;
      END;
      EXIT(AmountToDeduct);
    END;

    BEGIN
    {
      {IF Installments <=0 THEN
       ERROR('Number of installments must be greater than Zero!');}

      {IF LoanType.GET("Lease product type") THEN BEGIN
      IF LoanType."Interest Calculation Method" = LoanType."Interest Calculation Method"::"Reducing Balances" THEN BEGIN
        IF Interest = 0 THEN
          Repayment := ROUND("Approved Amount"/ Installments,0.0001,'>')
        ELSE
          Repayment := ROUND(DebtService("Approved Amount",Interest,Installments),0.0001,'>');
      END;
      END;}
      //"Total Repayment":=Installments*Repayment;
      //
    }
    END.
  }
}

