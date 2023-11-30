OBJECT table 17224 Membership Applications
{
  OBJECT-PROPERTIES
  {
    Date=07/31/23;
    Time=[ 3:47:54 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Name;
    OnInsert=BEGIN

               IF "No." = '' THEN BEGIN
                 SalesSetup.GET;
                 SalesSetup.TESTFIELD(SalesSetup."Member Application Nos");
                 NoSeriesMgt.InitSeries(SalesSetup."Member Application Nos",xRec."No. Series",0D,"No.","No. Series");
               END;

               "Customer Posting Group":='MEMBER';

               "Global Dimension 1 Code":='BOSA';

               "Created By":=USERID;
             END;

    OnModify=BEGIN
               IF (Status=Status::Approved) OR(Status=Status::Rejected)  THEN
               MESSAGE('You cannot edit an approved Member application');
             END;

    OnDelete=VAR
               CampaignTargetGr@1000 : Record 7030;
               ContactBusRel@1001 : Record 5054;
               Job@1004 : Record 167;
               CampaignTargetGrMgmt@1002 : Codeunit 7030;
               StdCustSalesCode@1003 : Record 172;
             BEGIN
                IF (Status=Status::Approved) OR(Status=Status::Rejected) THEN
               ERROR('You cannot delete an approved Member application');
             END;

    OnRename=BEGIN
               IF (Status=Status::Approved) OR(Status=Status::Rejected) THEN
               ERROR('You cannot Rename an approved Member application');
             END;

    CaptionML=ENU=Member Application;
    LookupPageID=Page51516220;
    DrillDownPageID=Page51516220;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;AltSearchField=Search Name;
                                                   OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."Member Application Nos");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   CaptionML=ENU=No. }
    { 2   ;   ;Name                ;Text50        ;OnValidate=BEGIN
                                                                IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
                                                                  "Search Name" := Name;
                                                                Name:=UPPERCASE(Name);
                                                              END;

                                                   CaptionML=ENU=Name }
    { 3   ;   ;Search Name         ;Code50        ;CaptionML=ENU=Search Name }
    { 4   ;   ;Name 2              ;Text50        ;CaptionML=ENU=Name 2 }
    { 5   ;   ;Address             ;Text50        ;OnValidate=BEGIN
                                                                Address:=UPPERCASE(Address);
                                                              END;

                                                   CaptionML=ENU=Address }
    { 6   ;   ;Address 2           ;Text50        ;OnValidate=BEGIN
                                                                "Address 2":=UPPERCASE("Address 2");
                                                              END;

                                                   CaptionML=ENU=Address 2 }
    { 7   ;   ;Phone No.           ;Text30        ;OnValidate=BEGIN
                                                                "Phone No.":=UPPERCASE("Phone No.")
                                                              END;

                                                   ExtendedDatatype=Phone No.;
                                                   CaptionML=ENU=Phone No. }
    { 8   ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   CaptionClass='1,1,1' }
    { 9   ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=ENU=Global Dimension 2 Code;
                                                   CaptionClass='1,1,2' }
    { 10  ;   ;Customer Posting Group;Code10      ;TableRelation="Customer Posting Group";
                                                   CaptionML=ENU=Customer Posting Group }
    { 11  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=ENU=Currency Code }
    { 12  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   CaptionML=ENU=Customer Price Group }
    { 68000;  ;Customer Type       ;Option        ;OptionCaptionML=ENU=,Member,FOSA,Investments,Property,MicroFinance;
                                                   OptionString=[ ,Member,FOSA,Investments,Property,MicroFinance] }
    { 68001;  ;Registration Date   ;Date           }
    { 68002;  ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected }
    { 68003;  ;Employer Code       ;Code20        ;TableRelation="Sacco Employers";
                                                   OnValidate=BEGIN
                                                                Employer.GET("Employer Code");
                                                                "Employer Name":=Employer.Description;
                                                                IF "Employer Code"= 'BUSINESS COMP' THEN BEGIN
                                                                  GenSetUp.GET;
                                                                  "Payroll/Staff No":=NoSeriesMgt.GetNextNo(GenSetUp.BusinessGNos,TODAY,TRUE);
                                                                  END;

                                                                IF "Employer Code"= 'RSL' THEN BEGIN
                                                                  GenSetUp.GET;
                                                                  "Payroll/Staff No":=NoSeriesMgt.GetNextNo(GenSetUp.ReatNos,TODAY,TRUE);
                                                                  END;

                                                                IF "Employer Code"= 'PTL' THEN BEGIN
                                                                  PFSetup.GET;
                                                                  "Payroll/Staff No":=NoSeriesMgt.GetNextNo(PFSetup.PTL,TODAY,TRUE);
                                                                  END;
                                                              END;
                                                               }
    { 68004;  ;Date of Birth       ;Date          ;OnValidate=BEGIN
                                                                 IF "Date of Birth" > TODAY THEN
                                                                 ERROR('Date of birth cannot be greater than today');

                                                                IF "Account Category" <>"Account Category"::Junior THEN BEGIN
                                                                IF "Date of Birth" <> 0D THEN BEGIN
                                                                IF GenSetUp.GET() THEN BEGIN
                                                                IF CALCDATE(GenSetUp."Min. Member Age","Date of Birth") > TODAY THEN
                                                                ERROR('Applicant bellow the mininmum membership age of %1',GenSetUp."Min. Member Age");
                                                                END;
                                                                END;
                                                                END;
                                                                Age:=Dates.DetermineAge("Date of Birth",TODAY);
                                                                "Date Of Retirement" := CALCDATE('60Y',"Date of Birth");
                                                              END;
                                                               }
    { 68005;  ;E-Mail (Personal)   ;Text50         }
    { 68006;  ;Station/Department  ;Code20        ;TableRelation="Loans Guarantee Details"."Loan No" WHERE (Name=FIELD(Employer Code)) }
    { 68007;  ;Home Address        ;Text50        ;OnValidate=BEGIN
                                                                "Home Address":=UPPERCASE("Home Address");
                                                              END;
                                                               }
    { 68008;  ;Location            ;Text50         }
    { 68009;  ;Sub-Location        ;Text50         }
    { 68010;  ;District            ;Text50         }
    { 68011;  ;Payroll/Staff No    ;Code20         }
    { 68012;  ;ID No.              ;Code50        ;OnValidate=BEGIN

                                                                IF Cust."Customer Posting Group"<> 'PLAZA'  THEN
                                                                IF "ID No."<>'' THEN BEGIN
                                                                Cust.RESET;
                                                                Cust.SETRANGE(Cust."ID No.","ID No.");
                                                                Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                IF Cust."No." <> "No." THEN
                                                                   ERROR('ID No. already exists');
                                                                END;
                                                                END;


                                                                {
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
                                                                IF STRLEN("ID No.")<>8 THEN
                                                                ERROR('Id Number should have 8 characters.');
                                                              END;
                                                               }
    { 68013;  ;Mobile Phone No     ;Code50        ;OnValidate=BEGIN
                                                                {
                                                                Vend.RESET;
                                                                Vend.SETRANGE(Vend."Staff No","Staff No");
                                                                IF Vend.FIND('-') THEN
                                                                Vend.MODIFYALL(Vend."Mobile Phone No","Mobile Phone No");

                                                                Cust.RESET;
                                                                Cust.SETRANGE(Cust."Staff No","Staff No");
                                                                IF Cust.FIND('-') THEN
                                                                Cust.MODIFYALL(Cust."Mobile Phone No","Mobile Phone No");
                                                                }
                                                                {
                                                                Vend.RESET;
                                                                Vend.SETRANGE(Vend."Staff No","Payroll/Staff No");
                                                                IF Vend.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                Vend."Mobile Phone No":="Mobile Phone No";
                                                                Vend.MODIFY;
                                                                UNTIL Vend.NEXT=0;
                                                                END;

                                                                Cust.RESET;
                                                                Cust.SETRANGE(Cust."Payroll/Staff No","Payroll/Staff No");
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                IF Cust."No." <> "No." THEN BEGIN
                                                                Cust."Mobile Phone No":="Mobile Phone No";
                                                                Cust.MODIFY;

                                                                END;

                                                                UNTIL Cust.NEXT = 0;
                                                                END;
                                                                 }

                                                                IF STRLEN("Mobile Phone No")<>13 THEN
                                                                ERROR('Mobile number should be 13 digits.');
                                                              END;
                                                               }
    { 68014;  ;Marital Status      ;Option        ;OptionString=[ ,Single,Married,Divorced,Widower,Widow] }
    { 68015;  ;Signature           ;BLOB          ;SubType=Bitmap }
    { 68016;  ;Passport No.        ;Code50         }
    { 68017;  ;Gender              ;Option        ;OptionCaptionML=ENU=Male,Female;
                                                   OptionString=Male,Female }
    { 68018;  ;Monthly Contribution;Decimal        }
    { 68019;  ;Investment B/F      ;Decimal        }
    { 68020;  ;Dividend Amount     ;Decimal        }
    { 68021;  ;Name of Chief       ;Text50         }
    { 68022;  ;Office Telephone No.;Code50         }
    { 68023;  ;Extension No.       ;Code30         }
    { 68024;  ;Insurance Contribution;Decimal      }
    { 68025;  ;Province            ;Code50         }
    { 68026;  ;Current File Location;Code50       ;FieldClass=FlowField;
                                                   CalcFormula=Max("File Movement Tracker".Station WHERE (Member No.=FIELD(No.)));
                                                   Editable=No }
    { 68027;  ;Village/Residence   ;Text50         }
    { 68028;  ;File Movement Remarks;Text150       }
    { 68029;  ;Office Branch       ;Code20         }
    { 68030;  ;Department          ;Code20        ;TableRelation="Member Departments".No. }
    { 68031;  ;Section             ;Code20        ;TableRelation="Member Section".No. }
    { 68032;  ;No. Series          ;Code10         }
    { 68033;  ;Occupation          ;Text30         }
    { 68034;  ;Designation         ;Text30         }
    { 68035;  ;Terms of Employment ;Option        ;OptionString=[ ,Permanent,Contract,Casual] }
    { 68036;  ;Category            ;Code20         }
    { 68037;  ;Picture             ;BLOB          ;SubType=Bitmap }
    { 68038;  ;Postal Code         ;Code20        ;TableRelation="Post Code";
                                                   OnValidate=BEGIN
                                                                PostCode.RESET;
                                                                PostCode.SETRANGE(PostCode.Code,"Postal Code");
                                                                IF PostCode.FIND('-') THEN BEGIN
                                                                Town:=PostCode.City
                                                                END;
                                                              END;
                                                               }
    { 68039;  ;City                ;Text30        ;OnValidate=BEGIN
                                                                //PostCode.ValidateCity(City,"Post Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              //PostCode.LookUpCity(City,"Post Code",TRUE);
                                                            END;

                                                   CaptionML=ENU=City }
    { 68040;  ;Contact Person      ;Code20         }
    { 68041;  ;Approved By         ;Code100        }
    { 68042;  ;Sent for Approval By;Code20         }
    { 68043;  ;Responsibility Centre;Code20        }
    { 68044;  ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   OnValidate=BEGIN
                                                                //IF ("Country/Region Code" <> xRec."Country/Region Code") AND (xRec."Country/Region Code" <> '') THEN
                                                                  //PostCode.ClearFields(City,"Post Code",County);
                                                              END;

                                                   CaptionML=ENU=Country/Region Code }
    { 68045;  ;County              ;Text30        ;CaptionML=ENU=County }
    { 68046;  ;Bank Code           ;Code20         }
    { 68047;  ;Bank Name           ;Code20         }
    { 68048;  ;Bank Account No     ;Code20         }
    { 68049;  ;Contact Person Phone;Code30         }
    { 68050;  ;ContactPerson Relation;Code20      ;TableRelation="Relationship Types" }
    { 68051;  ;Recruited By        ;Code20        ;TableRelation="Members Register".No.;
                                                   OnValidate=BEGIN
                                                                 Cust.RESET;
                                                                 Cust.SETRANGE(Cust."No.","Recruited By");
                                                                 IF Cust.FIND('-') THEN BEGIN
                                                                 "Recruiter Name":=Cust.Name;
                                                                END;
                                                              END;
                                                               }
    { 68052;  ;ContactPerson Occupation;Code20     }
    { 68053;  ;Dioces              ;Code30         }
    { 68054;  ;Mobile No. 2        ;Code20         }
    { 68055;  ;Employer Name       ;Code50         }
    { 68056;  ;Title               ;Option        ;OptionCaptionML=ENU=" ,Mr.,Mrs.,Miss.,DR.,Prof.,Fr.,Sr.,Bro.";
                                                   OptionString=[ ,Mr.,Mrs.,Miss.,DR.,Prof.,Fr.,Sr.,Bro.] }
    { 68057;  ;Town                ;Code30         }
    { 68058;  ;Received 1 Copy Of ID;Boolean       }
    { 68059;  ;Received 1 Copy Of Passport;Boolean }
    { 68060;  ;Specimen Signature  ;Boolean        }
    { 68061;  ;Home Postal Code    ;Code20        ;TableRelation="Post Code";
                                                   OnValidate=BEGIN
                                                                PostCode.RESET;
                                                                PostCode.SETRANGE(PostCode.Code,"Home Postal Code");
                                                                IF PostCode.FIND('-') THEN BEGIN
                                                                "Home Town":=PostCode.City
                                                                END;
                                                              END;
                                                               }
    { 68062;  ;Created             ;Boolean        }
    { 68063;  ;Incomplete Application;Boolean      }
    { 68064;  ;Created By          ;Text60        ;Editable=No }
    { 68065;  ;Assigned No.        ;Code30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Members Register".No. WHERE (ID No.=FIELD(ID No.))) }
    { 68066;  ;Home Town           ;Text60         }
    { 68067;  ;Recruiter Name      ;Text50         }
    { 68068;  ;Copy of Current Payslip;Boolean     }
    { 68069;  ;Member Registration Fee Receiv;Boolean }
    { 68070;  ;Account Category    ;Option        ;OptionCaptionML=ENU=Individual,Joint,Corporate,Group,Junior;
                                                   OptionString=Single,Joint,Corporate,Group,Junior }
    { 68071;  ;Copy of KRA Pin     ;Boolean       ;OnValidate=BEGIN
                                                                IF STRLEN("KRA Pin")<>11 THEN
                                                                ERROR('KRA Pin should have 11 characters.');
                                                              END;
                                                               }
    { 68072;  ;Contact person age  ;Date          ;OnValidate=BEGIN
                                                                { IF "Contact person age" > TODAY THEN
                                                                 ERROR('Age cannot be greater than today');


                                                                IF "Contact person age" <> 0D THEN BEGIN
                                                                IF GenSetUp.GET() THEN BEGIN
                                                                IF CALCDATE(GenSetUp."Min. Member Age","Contact person age") > TODAY THEN
                                                                ERROR('Contact person should be atleast 18years and above %1',GenSetUp."Min. Member Age");
                                                                END;
                                                                END;  }
                                                              END;
                                                               }
    { 68073;  ;First member name   ;Text30         }
    { 68075;  ;Date Establish      ;Date           }
    { 68076;  ;Registration No     ;Code30         }
    { 68077;  ;ID NO/Passport 2    ;Code30         }
    { 68079;  ;Registration office ;Text30        ;TableRelation=Location.Code }
    { 68080;  ;Picture 2           ;BLOB          ;SubType=Bitmap }
    { 68081;  ;Signature  2        ;BLOB          ;SubType=Bitmap }
    { 68082;  ;Title2              ;Option        ;OptionCaptionML=ENU=" ,Mr.,Mrs.,Miss.,DR.,Prof.,Fr.,Sr.,Bro.";
                                                   OptionString=[ ,Mr.,Mrs.,Miss.,DR.,Prof.,Fr.,Sr.,Bro.] }
    { 68083;  ;Mobile No. 3        ;Code20         }
    { 68084;  ;Date of Birth2      ;Date          ;OnValidate=BEGIN
                                                                 IF "Date of Birth" > TODAY THEN
                                                                 ERROR('Date of birth cannot be greater than today');


                                                                IF "Date of Birth" <> 0D THEN BEGIN
                                                                IF GenSetUp.GET() THEN BEGIN
                                                                IF CALCDATE(GenSetUp."Min. Member Age","Date of Birth") > TODAY THEN
                                                                ERROR('Applicant bellow the mininmum membership age of %1',GenSetUp."Min. Member Age");
                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 68085;  ;Marital Status2     ;Option        ;OptionString=[ ,Single,Married,Devorced,Widower,Widow] }
    { 68086;  ;Gender2             ;Option        ;OptionCaptionML=ENU=Male,Female;
                                                   OptionString=Male,Female }
    { 68087;  ;Address3            ;Code30         }
    { 68088;  ;Home Postal Code2   ;Code20        ;TableRelation="Post Code";
                                                   OnValidate=BEGIN
                                                                PostCode.RESET;
                                                                PostCode.SETRANGE(PostCode.Code,"Home Postal Code");
                                                                IF PostCode.FIND('-') THEN BEGIN
                                                                "Home Town":=PostCode.City
                                                                END;
                                                              END;
                                                               }
    { 68089;  ;Home Town2          ;Text60         }
    { 68090;  ;Payroll/Staff No2   ;Code20         }
    { 68100;  ;Employer Code2      ;Code20        ;TableRelation="Sacco Employers";
                                                   OnValidate=BEGIN
                                                                Employer.GET("Employer Code");
                                                                "Employer Name":=Employer.Description;
                                                              END;
                                                               }
    { 68101;  ;Employer Name2      ;Code50         }
    { 68102;  ;E-Mail (Personal2)  ;Text50         }
    { 68103;  ;Age                 ;Text50         }
    { 68104;  ;Copy of constitution;Boolean        }
    { 68105;  ;KRA Pin             ;Code30        ;OnValidate=BEGIN
                                                                IF STRLEN("KRA Pin")<>11 THEN
                                                                ERROR('KRA Pin should have 11 Characters.');
                                                              END;
                                                               }
    { 68106;  ;Converted           ;Boolean        }
    { 68107;  ;Fosa Account No     ;Code20        ;TableRelation=Vendor.No. }
    { 68108;  ;Sms Notification    ;Boolean        }
    { 68109;  ;Group Account       ;Boolean        }
    { 68110;  ;Account Type        ;Option        ;OptionCaptionML=ENU=" ,Single,Group";
                                                   OptionString=[ ,Single,Group] }
    { 68111;  ;FOSA Account Type   ;Code30        ;TableRelation="Account Types-Saving Products".Code;
                                                   Editable=No }
    { 68112;  ;Sales Code          ;Code10        ;OnValidate=BEGIN
                                                                 {
                                                                 Name:='';
                                                                 IF "Sales Code Type" IN ["Sales Code Type"::Staff,"Sales Code Type"::Delegate,"Sales Code Type"::"Board Member",
                                                                 "Sales Code Type"::"Direct Marketers","Sales Code Type"::Others]   THEN

                                                                CASE "Sales Code Type"  OF
                                                                "Sales Code Type"::Staff:
                                                                BEGIN
                                                                HR.GET("Sales Code Type");
                                                                Name:=HR."First Name";
                                                                END;

                                                                "Sales Code Type"::Delegate:
                                                                  BEGIN
                                                                  Cust.GET("Sales Code Type");
                                                                  Name:=Cust.Name;
                                                                  END;

                                                                "Sales Code Type"::"Board Member":
                                                                BEGIN
                                                                Cust.GET("Sales Code Type");
                                                                Name:=Cust.Name;
                                                                END;
                                                                END;
                                                                 }
                                                              END;
                                                               }
    { 68113;  ;Salesperson Name    ;Code20        ;CaptionML=ENU=Business Loan Officer Name }
    { 68114;  ;Group Account No    ;Code50        ;TableRelation="Membership Applications".No. WHERE (Group Account=FILTER(Yes));
                                                   OnValidate=BEGIN
                                                                 //"Group Account Name":='';
                                                                {MemberAppl.RESET;
                                                                IF MemberAppl.GET("Group Account No") THEN BEGIN
                                                                IF MemberAppl."Group Account"=TRUE THEN
                                                                "Group Account Name":=MemberAppl.Name;
                                                                "Recruited By":=MemberAppl."Recruited By";
                                                                "Salesperson Name":=MemberAppl."Loan Officer Name";
                                                                END;}

                                                                {
                                                                GenSetUp.GET;
                                                                 IF "Group Account No" = '5000' THEN BEGIN
                                                                  "Monthly Contribution":=GenSetUp."Business Min. Shares";
                                                                 END;
                                                                 }
                                                                {
                                                                MemberAppl.SETRANGE(MemberAppl."Group Account No","BOSA Account No.");
                                                                MemberAppl.SETRANGE(MemberAppl."Group Account",TRUE);
                                                                IF MemberAppl.FIND('-') THEN BEGIN
                                                                "Group Account Name":=MemberAppl.Name;
                                                                END
                                                                }
                                                              END;
                                                               }
    { 68116;  ;Group Account Name  ;Code50         }
    { 68117;  ;BOSA Account No.    ;Code30        ;TableRelation="Members Register" WHERE (Customer Posting Group=FILTER(MEMBER));
                                                   OnValidate=BEGIN
                                                                {
                                                                GenSetUp.GET();

                                                                CustMember.RESET;
                                                                CustMember.SETRANGE(CustMember."No.","BOSA Account No.");
                                                                IF CustMember.FIND('-') THEN

                                                                CustMember.TESTFIELD(CustMember."FOSA Account");
                                                                CustMember.TESTFIELD(CustMember."Member Category");
                                                                CustMember.TESTFIELD(CustMember."ID No.");
                                                                CustMember.TESTFIELD(CustMember."Date of Birth");
                                                                CustMember.TESTFIELD(CustMember."Global Dimension 2 Code");

                                                                IF CustMember.Status<>CustMember.Status::Active THEN BEGIN
                                                                ERROR(Text0024,CustMember.Status);
                                                                END;

                                                                IF "Class B Category"="Class B Category"::Sibling THEN BEGIN
                                                                ERROR(Text0026,CustMember."Member Category");
                                                                END;




                                                                Name:=CustMember.Name;
                                                                "Payroll/Staff No":=CustMember."Payroll/Staff No";
                                                                "ID No.":=CustMember."ID No.";
                                                                "FOSA Account No.":=CustMember."FOSA Account";
                                                                "Account Category":=CustMember."Account Category";
                                                                "Post Code":=CustMember."Post Code";
                                                                "Phone No.":=CustMember."Phone No.";
                                                                "Employer Code":=CustMember."Employer Code";
                                                                "Date of Birth":=CustMember."Date of Birth";
                                                                "Mobile Phone No":=CustMember."Mobile Phone No";
                                                                "Mobile Phone No":=CustMember."Phone No.";
                                                                "Marital Status":=CustMember."Marital Status";
                                                                Gender:=CustMember.Gender;
                                                                "E-Mail (Personal)":=CustMember."E-Mail";
                                                                "Global Dimension 2 Code":=CustMember."Global Dimension 2 Code";
                                                                "Member Category":=CustMember."Member Category";
                                                                "Bank Code":=CustMember."Bank Code";
                                                                "Bank Name":=CustMember."Bank Branch Code";
                                                                "Bank Account No":=CustMember."Bank Account No.";

                                                                IF "Business Loan Appl Type"="Business Loan Appl Type"::Individual THEN BEGIN
                                                                "Monthly Contribution":=GenSetUp."Bus.Loans Group Appl Amount";
                                                                END ELSE
                                                                "Monthly Contribution":=GenSetUp."Min. Contribution Bus Loan";


                                                                {
                                                                GetMemberCust.RESET;
                                                                GetMemberCust.SETRANGE(GetMemberCust."ID No.","ID No.");
                                                                IF GetMemberCust.FINDFIRST THEN BEGIN
                                                                ERROR(Text0023,GetMemberCust."No.");
                                                                END;

                                                                CustContributions.RESET;
                                                                CustContributions.SETRANGE(CustContributions."No.","BOSA Account No.");
                                                                IF CustContributions.FIND('-') THEN
                                                                REPEAT
                                                                IF CustContributions.Type=CustContributions.Type::"Deposit Contribution" THEN BEGIN
                                                                "Monthly Contribution":=CustContributions.Amount;
                                                                END;
                                                                UNTIL CustContributions.NEXT=0;
                                                                }

                                                                CustMemb.RESET;
                                                                CustMemb.SETRANGE(CustMemb."No.","BOSA Account No.");
                                                                IF CustMemb.FIND('-') THEN BEGIN
                                                                "Customer Posting Group":='MICRO';
                                                                MODIFY;
                                                                END;
                                                                }
                                                              END;
                                                               }
    { 68118;  ;FOSA Account No.    ;Code30         }
    { 68119;  ;Micro Group Code    ;Code50         }
    { 68120;  ;Source              ;Option        ;OptionCaptionML=ENU=Bosa,Business Loans;
                                                   OptionString=Bosa,Micro;
                                                   Editable=No }
    { 68121;  ;Work Station        ;Text50         }
    { 68122;  ;Front Side ID       ;BLOB          ;SubType=Bitmap }
    { 68123;  ;Back Side ID        ;BLOB          ;SubType=Bitmap }
    { 68124;  ;Account To Open     ;Option        ;OptionCaptionML=ENU=BOSA,FOSA;
                                                   OptionString=BOSA,FOSA }
    { 68125;  ;Account Type FOSA   ;Code20        ;TableRelation="Account Types-Saving Products".Code;
                                                   OnValidate=BEGIN
                                                                IF AccountTypes.GET("Account Type") THEN BEGIN
                                                                AccountTypes.TESTFIELD(AccountTypes."Posting Group");
                                                                "Vendor Posting Group":=AccountTypes."Posting Group";
                                                                "Allow Multiple Accounts":=AccountTypes."Allow Multiple Accounts";
                                                                IF AccountTypes."Activity Code"=AccountTypes."Activity Code"::FOSA THEN
                                                                "Global Dimension 1 Code":='FOSA'
                                                                ELSE
                                                                "Global Dimension 1 Code":='MICRO';

                                                                IF AccountTypes."Fixed Deposit"=TRUE THEN BEGIN

                                                                "Fixed Deposit":=TRUE;

                                                                END;
                                                                END;

                                                                IF "Account Type FOSA" = 'JUNIOR' THEN
                                                                "Date of Birth":=0D;
                                                              END;
                                                               }
    { 68126;  ;Vendor Posting Group;Code10        ;TableRelation="Vendor Posting Group";
                                                   CaptionML=ENU=Vendor Posting Group }
    { 68127;  ;Allow Multiple Accounts;Boolean     }
    { 68128;  ;Fixed Deposit       ;Boolean        }
    { 68129;  ;Date Of Retirement  ;Date          ;Editable=No }
    { 68130;  ;Expiry Date(Passport);Date          }
    { 68131;  ;Sub-County          ;Code20         }
    { 68132;  ;Contract Expiry Date;Date           }
    { 68133;  ;Source Of Funds     ;Option        ;OptionCaptionML=ENU=,Salary,Business,Pension,Others;
                                                   OptionString=,Salary,Business,Pension,Others }
    { 68134;  ;Employment Type     ;Option        ;OptionCaptionML=ENU=,Self Employed,Employed;
                                                   OptionString=,Self Employed,Employed }
    { 68135;  ;Name of Business    ;Text120        }
    { 68136;  ;Nature of Business  ;Text120        }
    { 68137;  ;Terms And Conditions;Text150        }
    { 68138;  ;Registration Fee Paid;Boolean       }
    { 68139;  ;Image 2             ;BLOB          ;SubType=Bitmap }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Search Name                              }
    {    ;Name,Address,Phone No.                   }
    {    ;Name                                    ;KeyGroups=SearchCol }
    {    ;Phone No.                               ;KeyGroups=SearchCol }
    {    ;Global Dimension 2 Code                 ;KeyGroups=SearchCol }
    {    ;Global Dimension 1 Code                 ;KeyGroups=SearchCol }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Name,Phone No.,Field91,Global Dimension 2 Code,Global Dimension 1 Code }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=You cannot delete %1 %2 because there is at least one outstanding Sales %3 for this customer.';
      Text002@1001 : TextConst 'ENU=Do you wish to create a contact for %1 %2?';
      SalesSetup@1002 : Record 51516258;
      Text003@1020 : TextConst 'ENU=Contact %1 %2 is not related to customer %3 %4.';
      Text004@1023 : TextConst 'ENU=post';
      Text005@1024 : TextConst 'ENU=create';
      Text006@1025 : TextConst 'ENU=You cannot %1 this type of document when Customer %2 is blocked with type %3';
      Text007@1028 : TextConst 'ENU=You cannot delete %1 %2 because there is at least one not cancelled Service Contract for this customer.';
      Text008@1029 : TextConst 'ENU=Deleting the %1 %2 will cause the %3 to be deleted for the associated Service Items. Do you want to continue?';
      Text009@1030 : TextConst 'ENU=Cannot delete customer.';
      Text010@1031 : TextConst 'ENU=The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3. Enter another code.';
      Text011@1033 : TextConst 'ENU=Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?';
      Text012@1032 : TextConst 'ENU=You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.';
      Text013@1035 : TextConst 'ENU=You cannot delete %1 %2 because there is at least one outstanding Service %3 for this customer.';
      Text014@1017 : TextConst 'ENU=Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
      Text015@1036 : TextConst 'ENU=You cannot delete %1 %2 because there is at least one %3 associated to this customer.';
      GenSetUp@1102756009 : Record 51516257;
      MinShares@1102756008 : Decimal;
      MovementTracker@1102756007 : Record 51516253;
      Cust@1102756005 : Record 51516223;
      Vend@1102756004 : Record 23;
      CustFosa@1102756003 : Code[20];
      Vend2@1102756002 : Record 23;
      FOSAAccount@1102756001 : Record 23;
      StatusPermissions@1102756000 : Record 51516310;
      RefundsR@1102756011 : Record 51516269;
      Text016@1102755000 : TextConst 'ENU=You cannot change the contents of the %1 field because this %2 has one or more posted ledger entries.';
      NoSeriesMgt@1102755001 : Codeunit 396;
      PostCode@1102755002 : Record 225;
      User@1102755003 : Record 2000000120;
      Employer@1102755004 : Record 51516260;
      Dates@1000000000 : Codeunit 51516005;
      DAge@1000000001 : DateFormula;
      AccountTypes@1000000002 : Record 51516295;
      PFSetup@1120054000 : Record 51516834;

    PROCEDURE @1102755000();
    BEGIN
    END;

    BEGIN
    END.
  }
}

