OBJECT table 20449 MBanking Applications
{
  OBJECT-PROPERTIES
  {
    Date=12/27/22;
    Time=[ 1:41:49 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    OnInsert=VAR
               MemberList@1120054000 : Record 51516223;
             BEGIN
               Permission.RESET;
               Permission.SETRANGE("User ID",USERID);
               Permission.SETRANGE("Create MBanking Applications",TRUE);
               IF NOT Permission.FINDFIRST THEN
                 ERROR('You do not have the following permission: "Create MBanking Applications"');


               IF No = '' THEN BEGIN
                   NoSetup.GET;
                   NoSetup.TESTFIELD(NoSetup."MBanking Application Nos");
                   NoSeriesMgt.InitSeries(NoSetup."MBanking Application Nos",xRec."No. Series",0D,No,"No. Series");
               END;


               // MPESAApp.RESET;
               // MPESAApp.SETRANGE(Status,MPESAApp.Status::Open);
               // IF MPESAApp.FINDFIRST THEN
               //     IF MPESAApp.COUNT > 0 THEN
               //         ERROR('There is an open Document No. %1. Kindly Finalize with No. %1',MPESAApp.No);


               "Entered By"    :=USERID;
               "Date Entered"  :=TODAY;
               "Time Entered"  :=TIME;
             END;

    OnModify=BEGIN
               TESTFIELD(Status,Status::Open);
             END;

    OnDelete=BEGIN


               {
               IF Status<>Status::Open THEN BEGIN
               ERROR('You cannot delete the MPESA transaction because it has already been sent for first approval.');
               END;
               }
             END;

    LookupPageID=Page51516700;
    DrillDownPageID=Page51516700;
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code30         }
    { 2   ;   ;Date Entered        ;Date           }
    { 3   ;   ;Time Entered        ;Time           }
    { 4   ;   ;Entered By          ;Code40         }
    { 5   ;   ;Document Serial No  ;Text50         }
    { 6   ;   ;Document Date       ;Date           }
    { 7   ;   ;Customer ID No      ;Code50        ;OnValidate=BEGIN
                                                                "Customer ID No":=DELCHR("Customer ID No",'=','A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_');

                                                                //FieldLength("Customer ID No",10);
                                                              END;
                                                               }
    { 8   ;   ;Customer Name       ;Text200       ;OnValidate=BEGIN

                                                                {
                                                                "Customer Name":=DELCHR("Customer Name",'=','0|1|2|3|4|5|6|7|8|9|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|+|_|~');
                                                                //FieldLength("MPESA Mobile No",10);
                                                                }
                                                              END;
                                                               }
    { 9   ;   ;MPESA Mobile No     ;Text50        ;OnValidate=BEGIN

                                                                IF "MPESA Mobile No"<>'' THEN BEGIN
                                                                    IF (STRLEN("MPESA Mobile No")<> 13) OR (COPYSTR("MPESA Mobile No",1,4)<>'+254') THEN
                                                                      ERROR('Invalid MPESA Mobile No.');


                                                                    SavingsAccount.RESET;
                                                                    SavingsAccount.SETRANGE("Transactional Mobile No","MPESA Mobile No");
                                                                    IF SavingsAccount.FIND('-') THEN BEGIN
                                                                        ERROR('Transactional Phone No. %1 already exists under Account No. %2:%3',"MPESA Mobile No",SavingsAccount."No.",SavingsAccount.Name);
                                                                    END;


                                                                END;


                                                                {

                                                                "MPESA Mobile No":=DELCHR("MPESA Mobile No",'=','A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-');
                                                                 FieldLength("MPESA Mobile No",13);
                                                                }
                                                              END;

                                                   Editable=Yes }
    { 10  ;   ;MPESA Corporate No  ;Code30         }
    { 11  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected,Created;
                                                   OptionString=Open,Pending,Approved,Rejected,Created }
    { 12  ;   ;Comments            ;Text200        }
    { 13  ;   ;Rejection Reason    ;Text30         }
    { 14  ;   ;Date Approved       ;Date           }
    { 15  ;   ;Time Approved       ;Time           }
    { 16  ;   ;Approved By         ;Code30         }
    { 17  ;   ;Date Rejected       ;Date           }
    { 18  ;   ;Time Rejected       ;Time           }
    { 19  ;   ;Rejected By         ;Code30         }
    { 20  ;   ;Sent To Server      ;Option        ;OptionString=No,Yes }
    { 21  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 22  ;   ;1st Approval By     ;Code30         }
    { 23  ;   ;Date 1st Approval   ;Date           }
    { 24  ;   ;Time First Approval ;Time           }
    { 25  ;   ;Withdrawal Limit Code;Code20        }
    { 26  ;   ;Withdrawal Limit Amount;Decimal     }
    { 27  ;   ;Application Type    ;Option        ;OnValidate=BEGIN
                                                                IF "Application Type"="Application Type"::Initial THEN BEGIN
                                                                IF "Application No"<>'' THEN BEGIN
                                                                ERROR('Please ensure the application number field is blank if the application is not a change application.');
                                                                END;
                                                                END;
                                                              END;

                                                   OptionString=Initial,Change }
    { 28  ;   ;Application No      ;Code30        ;TableRelation="MBanking Applications".No WHERE (Status=CONST(Approved));
                                                   OnValidate=BEGIN

                                                                IF "Application Type"<>"Application Type"::Change THEN BEGIN
                                                                ERROR('The application must be a change application before selecting this option.');
                                                                END;

                                                                MPESAApp.RESET;
                                                                MPESAApp.SETRANGE(MPESAApp.No,"Application No");
                                                                IF MPESAApp.FIND('-') THEN BEGIN
                                                                "Old Telephone No":=MPESAApp."MPESA Mobile No";
                                                                "Document Serial No":=MPESAApp."Document Serial No";
                                                                "Customer ID No":=MPESAApp."Customer ID No";
                                                                "Customer Name":=MPESAApp."Customer Name";
                                                                "Membership No" := MPESAApp."Membership No";
                                                                "MPESA Mobile No" := MPESAApp."MPESA Mobile No";

                                                                END
                                                                ELSE
                                                                BEGIN

                                                                "Old Telephone No":='';

                                                                END;

                                                                MPESAAppDetails.RESET;
                                                                MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No",No);
                                                                IF MPESAAppDetails.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                MPESAAppDetails.DELETE;
                                                                UNTIL MPESAAppDetails.NEXT=0
                                                                END;


                                                                MPESAAppDetails.RESET;
                                                                MPESAAppDetails.SETRANGE(MPESAAppDetails."Application No","Application No");
                                                                IF MPESAAppDetails.FIND('-') THEN BEGIN
                                                                REPEAT

                                                                MPESAAppDet2.RESET;
                                                                MPESAAppDet2.INIT;
                                                                MPESAAppDet2."Application No":=No;
                                                                MPESAAppDet2."Account Type":=MPESAAppDetails."Account Type";
                                                                MPESAAppDet2."Account No.":=MPESAAppDetails."Account No.";
                                                                MPESAAppDet2.Description:=MPESAAppDetails.Description;
                                                                MPESAAppDet2.INSERT;

                                                                UNTIL MPESAAppDetails.NEXT=0
                                                                END;
                                                              END;
                                                               }
    { 29  ;   ;Changed             ;Option        ;OptionString=No,Yes }
    { 30  ;   ;Date Changed        ;Date           }
    { 31  ;   ;Time Changed        ;Time           }
    { 32  ;   ;Changed By          ;Code30         }
    { 33  ;   ;Old Telephone No    ;Code30         }
    { 34  ;   ;I agree information is true;Boolean }
    { 35  ;   ;App Status          ;Option        ;OptionString=Pending,1st Approval,Approved,Rejected }
    { 36  ;   ;Responsibility Center;Code20        }
    { 37  ;   ;Virtual Registration;Boolean        }
    { 38  ;   ;Membership No       ;Code30        ;TableRelation=Customer }
    { 39  ;   ;Account No          ;Code80        ;TableRelation=Vendor WHERE (Account Type=CONST(ORDINARY));
                                                   OnValidate=VAR
                                                                Vendor@1120054000 : Record 23;
                                                              BEGIN
                                                                SavingsAccount.GET("Account No");

                                                                Members.GET(SavingsAccount."BOSA Account No");
                                                                "Customer ID No" := Members."ID No.";
                                                                "MPESA Mobile No" := Members."Mobile Phone No";
                                                                "Customer Name" := Members.Name;
                                                                // IF (members.Status <> Members.Status::Active) OR (members.Status <> Members.Status::Dormant)  THEN
                                                                //   ERROR('Member account is closed');

                                                                Vendor.RESET;
                                                                Vendor.SETRANGE(Vendor."No.","Account No");
                                                                Vendor.SETFILTER(Vendor.Status,'%1',Vendor.Status::Closed);
                                                                IF Vendor.FINDSET  THEN
                                                                REPEAT
                                                                      IF Vendor.Status =Vendor.Status::Closed THEN
                                                                        ERROR(Vendor."No."+' account is closed')

                                                                UNTIL Vendor.NEXT=0;
                                                                // (Vendor.Status <> Vendor.Status::Active) OR (Vendor.Status <> Vendor.Status::Dormant)
                                                                // Members.RESET;
                                                                // Members.SETRANGE(Members."No.","Account No");
                                                                // Members.SETFILTER(Members.Status,'%1|%2',Members.Status::Active,Members.Status::Dormant);
                                                                // IF Members.FINDSET  THEN
                                                                // REPEAT
                                                                //       IF (Members.Status <> Members.Status::Active) OR (Members.Status <> Members.Status::Dormant) THEN
                                                                //         ERROR('Member account is closed')
                                                                //
                                                                // UNTIL Members.NEXT=0;


                                                                MPESAApp.RESET;
                                                                MPESAApp.SETRANGE("Account No","Account No");
                                                                MPESAApp.SETRANGE("Application Type",MPESAApp."Application Type"::Initial);
                                                                IF MPESAApp.FINDFIRST THEN
                                                                    ERROR('Applicant already exists with Application No. %1',MPESAApp.No);

                                                                MPESAAppDet2.RESET;
                                                                MPESAAppDet2.SETRANGE(MPESAAppDet2."Application No",No);
                                                                IF MPESAAppDet2.FIND('-') THEN BEGIN
                                                                    MPESAAppDet2.DELETE;

                                                                    MPESAAppDet2.INIT;
                                                                    MPESAAppDet2."Application No":= No;
                                                                    MPESAAppDet2."Account Type":= MPESAAppDet2."Account Type"::Creditor;
                                                                    MPESAAppDet2."Account No.":= "Account No";
                                                                    MPESAAppDet2.Description:= "Customer Name";
                                                                    MPESAAppDet2.INSERT;
                                                                END
                                                                ELSE BEGIN

                                                                    MPESAAppDet2.INIT;
                                                                    MPESAAppDet2."Application No":= No;
                                                                    MPESAAppDet2."Account Type":= MPESAAppDet2."Account Type"::Creditor;
                                                                    MPESAAppDet2."Account No.":= "Account No";
                                                                    MPESAAppDet2.Description:= "Customer Name";
                                                                    MPESAAppDet2.INSERT;

                                                                END;
                                                              END;
                                                               }
    { 40  ;   ;Delinked            ;Boolean        }
    { 50000;  ;Date of Birth       ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Members Register"."Date of Birth" WHERE (No.=FIELD(Account No)));
                                                   Editable=No }
    { 50001;  ;Member No.          ;Code20         }
  }
  KEYS
  {
    {    ;No                                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NoSetup@1102756001 : Record 51516700;
      NoSeriesMgt@1102756000 : Codeunit 396;
      MPESAApp@1102755001 : Record 51516703;
      MPESAAppDetails@1102755002 : Record 51516715;
      MPESAAppDet2@1102755003 : Record 51516715;
      SavingsAccount@1000 : Record 23;
      AppendMobile@1001 : Text[30];
      Members@1002 : Record 51516223;
      Length@1003 : Integer;
      Permission@1120054000 : Record 51516702;
      nCount@1120054001 : Integer;
      SaccoSetup@1120054002 : Record 51516700;
      Loans@1120054003 : Record 51516230;

    PROCEDURE FieldLength@1(VarVariant@1000 : Text;FldLength@1001 : Integer) : Text;
    VAR
      FieldLengthError@1002 : TextConst 'ENU=Field cannot be more than %1 Characters.';
    BEGIN
      IF STRLEN(VarVariant) > FldLength THEN
        ERROR(FieldLengthError,FldLength);
    END;

    PROCEDURE ValidateMember@1120054000();
    BEGIN

      SavingsAccount.GET("Account No");

      Members.GET(SavingsAccount."BOSA Account No");
      Members.CALCFIELDS(Members."Shares Retained",Members."Current Shares");
      SaccoSetup.GET;
      "Member No." := Members."No.";
      Members.TESTFIELD(Members."Registration Date");
      IF CALCDATE('6M',Members."Registration Date") > TODAY THEN
          MESSAGE('Member is less than 6 months old in the SACCO');



      IF Members."Current Shares" <= 0  THEN
          MESSAGE('Member has not contributed any share deposits');

      Loans.RESET;
      Loans.SETRANGE(Loans."Client Code",Members."No.");
      Loans.SETFILTER(Loans."Outstanding Balance",'>0');
      Loans.SETFILTER("Loans Category-SASRA",'%1|%2|%3',Loans."Loans Category-SASRA"::Substandard,
      Loans."Loans Category-SASRA"::Doubtful,Loans."Loans Category-SASRA"::Loss);
      IF Loans.FINDFIRST THEN
         MESSAGE('Member has defaulted %1 , Loan No. %2',Loans."Loan Product Type Name",Loans."Loan  No.");

      IF SaccoSetup."Minimum Share Capital" > Members."Shares Retained" THEN
          MESSAGE('Minimum Share Capital Expected. Current Shares: %1',Members."Shares Retained");




      Members.CALCFIELDS(Members.Picture,Members.Signature,Members."Front Side ID",Members."Back Side ID");
      IF NOT Members.Picture.HASVALUE THEN
          ERROR('Member does not have a picture attached to his/her account');
      IF NOT Members.Signature.HASVALUE THEN
          ERROR('Member does not have a signature attached to his/her account');


      IF NOT Members."Back Side ID".HASVALUE THEN
          ERROR('Member does not have a "Back Side ID" attached to his/her account');
      IF NOT Members."Front Side ID".HASVALUE THEN
          ERROR('Member does not have a "Front Side ID" attached to his/her account');
    END;

    BEGIN
    END.
  }
}

