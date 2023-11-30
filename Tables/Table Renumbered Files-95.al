OBJECT table 17213 HR Job Applications
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=[ 1:09:49 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               //GENERATE NEW NUMBER FOR THE DOCUMENT
               IF  "Application No" = '' THEN BEGIN
                 HRSetup.GET;
                 HRSetup.TESTFIELD(HRSetup."Job Application Nos");
                 NoSeriesMgt.InitSeries(HRSetup."Job Application Nos",xRec."No. Series",0D,"Application No","No. Series");
               END;

               "Date Applied":=TODAY;
             END;

    CaptionML=ENU=HR Job Applications;
  }
  FIELDS
  {
    { 1   ;   ;Application No      ;Code50         }
    { 2   ;   ;First Name          ;Text100        }
    { 3   ;   ;Middle Name         ;Text50         }
    { 4   ;   ;Last Name           ;Text50        ;OnValidate=VAR
                                                                Reason@1000000000 : Text[30];
                                                              BEGIN
                                                              END;
                                                               }
    { 5   ;   ;Initials            ;Text15         }
    { 7   ;   ;Search Name         ;Code50         }
    { 8   ;   ;Postal Address      ;Text80         }
    { 9   ;   ;Residential Address ;Text80         }
    { 10  ;   ;City                ;Text30         }
    { 11  ;   ;Post Code           ;Code20        ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No }
    { 12  ;   ;County              ;Text30         }
    { 13  ;   ;Home Phone Number   ;Text30         }
    { 14  ;   ;Cell Phone Number   ;Text30         }
    { 15  ;   ;Work Phone Number   ;Text30         }
    { 16  ;   ;Ext.                ;Text7          }
    { 17  ;   ;E-Mail              ;Text80         }
    { 19  ;   ;Picture             ;BLOB          ;SubType=Bitmap }
    { 20  ;   ;ID Number           ;Text30        ;OnValidate=BEGIN
                                                                HRJobApp.RESET;
                                                                HRJobApp.SETRANGE(HRJobApp."ID Number","ID Number");
                                                                IF HRJobApp.FIND('-') THEN BEGIN
                                                                  ERROR('This ID Number has been used in a prior Job Application.');
                                                                END;
                                                              END;
                                                               }
    { 21  ;   ;Gender              ;Option        ;OptionString=Male,Female }
    { 22  ;   ;Country Code        ;Code10        ;TableRelation=Country/Region }
    { 23  ;   ;Status              ;Option        ;OptionString=Normal,Resigned,Discharged,Retrenched,Pension,Disabled }
    { 24  ;   ;Comment             ;Boolean       ;FieldClass=Normal;
                                                   Editable=No }
    { 25  ;   ;Fax Number          ;Text30         }
    { 26  ;   ;Marital Status      ;Option        ;OptionString=[ ,Single,Married,Separated,Divorced,Widow(er),Other] }
    { 27  ;   ;Ethnic Origin       ;Option        ;OptionString=African,Indian,White,Coloured }
    { 28  ;   ;First Language (R/W/S);Code10      ;TableRelation="HR Lookup Values".Code WHERE (Type=FILTER(Language)) }
    { 29  ;   ;Driving Licence     ;Code10         }
    { 30  ;   ;Disabled            ;Option        ;OptionString=[No,Yes, ] }
    { 31  ;   ;Health Assesment?   ;Boolean        }
    { 32  ;   ;Health Assesment Date;Date          }
    { 33  ;   ;Date Of Birth       ;Date          ;OnValidate=BEGIN
                                                                IF "Date Of Birth" >=TODAY THEN BEGIN
                                                                    ERROR('Date of Birth cannot be after %1',TODAY);
                                                                END;
                                                              END;
                                                               }
    { 34  ;   ;Age                 ;Text80         }
    { 35  ;   ;Second Language (R/W/S);Code10     ;TableRelation="HR Lookup Values".Code WHERE (Type=FILTER(Language)) }
    { 36  ;   ;Additional Language ;Code10        ;TableRelation="HR Lookup Values".Code WHERE (Type=FILTER(Language)) }
    { 37  ;   ;Primary Skills Category;Option     ;OptionString=Auditors,Consultants,Training,Certification,Administration,Marketing,Management,Business Development,Other }
    { 38  ;   ;Level               ;Option        ;OptionString=[ ,Level 1,Level 2,Level 3,Level 4,Level 5,Level 6,Level 7] }
    { 39  ;   ;Termination Category;Option        ;OnValidate=VAR
                                                                "Lrec Resource"@1000000000 : Record 156;
                                                                OK@1000000001 : Boolean;
                                                              BEGIN
                                                              END;

                                                   OptionString=[ ,Resignation,Non-Renewal Of Contract,Dismissal,Retirement,Death,Other] }
    { 40  ;   ;Postal Address2     ;Text30         }
    { 41  ;   ;Postal Address3     ;Text20         }
    { 42  ;   ;Residential Address2;Text30         }
    { 43  ;   ;Residential Address3;Text20         }
    { 44  ;   ;Post Code2          ;Code20        ;TableRelation="Post Code" }
    { 45  ;   ;Citizenship         ;Code10        ;TableRelation=Country/Region.Code;
                                                   OnValidate=BEGIN
                                                                Country.RESET;
                                                                Country.SETRANGE(Country.Code,Citizenship);
                                                                IF Country.FIND('-') THEN
                                                                BEGIN
                                                                    "Citizenship Details":=Country.Name;
                                                                END;
                                                              END;
                                                               }
    { 46  ;   ;Disabling Details   ;Text50         }
    { 47  ;   ;Disability Grade    ;Text30         }
    { 48  ;   ;Passport Number     ;Text30         }
    { 49  ;   ;2nd Skills Category ;Option        ;OptionString=[ ,Auditors,Consultants,Training,Certification,Administration,Marketing,Management,Business Development,Other] }
    { 50  ;   ;3rd Skills Category ;Option        ;OptionString=[ ,Auditors,Consultants,Training,Certification,Administration,Marketing,Management,Business Development,Other] }
    { 51  ;   ;Region              ;Code10        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4)) }
    { 52  ;   ;First Language Read ;Boolean        }
    { 53  ;   ;First Language Write;Boolean        }
    { 54  ;   ;First Language Speak;Boolean        }
    { 55  ;   ;Second Language Read;Boolean        }
    { 56  ;   ;Second Language Write;Boolean       }
    { 57  ;   ;Second Language Speak;Boolean       }
    { 58  ;   ;PIN Number          ;Code20         }
    { 59  ;   ;Job Applied For     ;Code30        ;TableRelation="HR Jobs"."Job ID";
                                                   OnValidate=BEGIN
                                                                IF ObjHrJobs.GET("Job Applied For") THEN
                                                                  BEGIN
                                                                    "Job Applied for Description":=ObjHrJobs."Job Description";
                                                                    END;
                                                              END;

                                                   Editable=No }
    { 60  ;   ;Employee Requisition No;Code20     ;TableRelation="HR Employee Requisitions"."Requisition No." WHERE (Closed=CONST(No),
                                                                                                                     Status=CONST(Approved));
                                                   OnValidate=BEGIN

                                                                HREmpReq.RESET;
                                                                HREmpReq.SETRANGE(HREmpReq."Requisition No.","Employee Requisition No");
                                                                IF HREmpReq.FIND('-') THEN
                                                                "Job Applied For":=HREmpReq."Job ID";
                                                              END;
                                                               }
    { 61  ;   ;Total Score         ;Decimal       ;FieldClass=Normal }
    { 62  ;   ;Shortlist           ;Boolean        }
    { 63  ;   ;Qualified           ;Boolean       ;Editable=Yes }
    { 64  ;   ;Stage               ;Code20        ;FieldClass=FlowFilter }
    { 65  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 66  ;   ;Employee No         ;Code20        ;TableRelation="HR Employees".No.;
                                                   OnValidate=BEGIN
                                                                //COPY EMPLOYEE DETAILS FROM EMPLOYEE TABLE
                                                                Employee.RESET;
                                                                IF Employee.GET("Employee No") THEN BEGIN
                                                                "First Name":=Employee."First Name";
                                                                "Middle Name":=Employee."Middle Name";
                                                                "Last Name":=Employee."Last Name";
                                                                "Search Name":=Employee."Search Name";
                                                                "Postal Address":=Employee."Postal Address";
                                                                "Residential Address":=Employee."Residential Address";
                                                                City:=Employee.City;
                                                                "Post Code":=Employee."Post Code";
                                                                County:=Employee.County;
                                                                "Home Phone Number":=Employee."Home Phone Number";
                                                                "Cell Phone Number":=Employee."Cell Phone Number";
                                                                "Work Phone Number":=Employee."Work Phone Number";
                                                                "Ext.":=Employee."Ext.";
                                                                "E-Mail":=Employee."E-Mail";
                                                                "ID Number":=Employee."ID Number";
                                                                Gender:=Employee.Gender;
                                                                "Country Code":=Employee.Citizenship;
                                                                "Fax Number":=Employee."Fax Number";
                                                                "Marital Status":=Employee."Marital Status";
                                                                "Ethnic Origin":=Employee."Ethnic Origin";
                                                                "First Language (R/W/S)":=Employee."First Language (R/W/S)";
                                                                //"Driving Licence":=Employee."Has Driving Licence";
                                                                Disabled:=Employee.Disabled;
                                                                "Health Assesment?":=Employee."Health Assesment?";
                                                                "Health Assesment Date":=Employee."Health Assesment Date";
                                                                "Date Of Birth":=Employee."Date Of Birth";
                                                                Age:=Employee.Age;
                                                                "Second Language (R/W/S)":=Employee."Second Language (R/W/S)";
                                                                "Additional Language":=Employee."Additional Language";
                                                                Citizenship:=Employee.Citizenship;
                                                                "Passport Number":=Employee."Passport Number";
                                                                "First Language Read":=Employee."First Language Read";
                                                                "First Language Write":=Employee."First Language Write";
                                                                "First Language Speak":=Employee."First Language Speak";
                                                                "Second Language Read":=Employee."Second Language Read";
                                                                "Second Language Write":=Employee."Second Language Write";
                                                                "Second Language Speak":=Employee."Second Language Speak";
                                                                "PIN Number":=Employee."PIN No.";

                                                                "Applicant Type":="Applicant Type"::Internal;
                                                                MODIFY;

                                                                            //DELETE QUALIFICATIONS PREVIOUSLY COPIED
                                                                            AppQualifications.RESET;
                                                                            AppQualifications.SETRANGE(AppQualifications."Application No","Application No");
                                                                            IF AppQualifications.FIND('-') THEN
                                                                            AppQualifications.DELETEALL;

                                                                            //GET EMPL0YEE QUALIFICATIONS
                                                                            EmpQualifications.RESET;
                                                                            EmpQualifications.SETRANGE(EmpQualifications."Employee No.",Employee."No.");
                                                                            IF EmpQualifications.FIND('-') THEN
                                                                            EmpQualifications.FINDFIRST;
                                                                            BEGIN
                                                                            AppQualifications.RESET;

                                                                                REPEAT
                                                                                AppQualifications.INIT;
                                                                                AppQualifications."Application No":="Application No";
                                                                                AppQualifications."Employee No.":="Employee No";
                                                                                AppQualifications."Qualification Type":=EmpQualifications."Qualification Type";
                                                                                AppQualifications."Qualification Code":=EmpQualifications."Qualification Code";
                                                                                AppQualifications."Qualification Description":=EmpQualifications."Qualification Description";
                                                                                AppQualifications."From Date":=EmpQualifications."From Date";
                                                                                AppQualifications."To Date":=EmpQualifications."To Date";
                                                                                AppQualifications.Type:=EmpQualifications.Type;
                                                                                AppQualifications."Institution/Company":=EmpQualifications."Institution/Company";
                                                                                AppQualifications.INSERT();

                                                                                UNTIL EmpQualifications.NEXT = 0;
                                                                            END
                                                                END;

                                                                {
                                                                END ELSE BEGIN
                                                                "First Name":='';
                                                                "Middle Name":='';
                                                                "Last Name":='';
                                                                "Search Name":='';
                                                                "Postal Address":='';
                                                                "Residential Address":='';
                                                                City:=Employee.City;
                                                                "Post Code":='';
                                                                County:='';
                                                                "Home Phone Number":='';
                                                                "Cell Phone Number":='';
                                                                "Work Phone Number":='';
                                                                "Ext.":='';
                                                                "E-Mail":='';
                                                                "ID Number":='';

                                                                "Country Code":='';
                                                                "Fax Number":='';

                                                                "First Language (R/W/S)":='';
                                                                //"Driving Licence":=Employee."Has Driving Licence";

                                                                "Health Assesment Date":=0D;
                                                                "Date Of Birth":=0D;
                                                                Age:='';
                                                                "Second Language (R/W/S)":='';
                                                                "Additional Language":='';
                                                                "Postal Address2":='';
                                                                "Postal Address3":='';
                                                                "Residential Address2":='';
                                                                "Residential Address3":='';
                                                                "Post Code2":='';
                                                                Citizenship:='';
                                                                "Passport Number":='';
                                                                "First Language Read":=FALSE;
                                                                "First Language Write":=FALSE;
                                                                "First Language Speak":=FALSE;
                                                                "Second Language Read":=FALSE;
                                                                "Second Language Write":=FALSE;
                                                                "Second Language Speak":=FALSE;
                                                                "PIN Number":='';

                                                                "Applicant Type":="Applicant Type"::External;
                                                                MODIFY;

                                                                //DELETE QUALIFICATIONS PREVIOUSLY COPIED
                                                                AppQualifications.RESET;
                                                                AppQualifications.SETRANGE(AppQualifications."Application No","Application No");
                                                                IF AppQualifications.FIND('-') THEN
                                                                AppQualifications.DELETEALL;

                                                                //DELETE APPLICANT REFEREES
                                                                AppRefferees.RESET;
                                                                AppRefferees.SETRANGE(AppRefferees."Job Application No","Application No");
                                                                IF AppRefferees.FIND('-') THEN
                                                                AppRefferees.DELETEALL;

                                                                //DELETE APPLICANT HOBBIES
                                                                AppHobbies.RESET;
                                                                AppHobbies.SETRANGE(AppHobbies."Job Application No","Application No");
                                                                IF AppHobbies.FIND('-') THEN
                                                                AppHobbies.DELETEALL;

                                                                END;
                                                                }
                                                              END;
                                                               }
    { 67  ;   ;Applicant Type      ;Option        ;OptionCaptionML=ENU=External,Internal;
                                                   OptionString=External,Internal,AMPATH;
                                                   Editable=No }
    { 68  ;   ;Interview Invitation Sent;Boolean  ;Editable=No }
    { 69  ;   ;Date Applied        ;Date           }
    { 70  ;   ;Citizenship Details ;Text60         }
    { 71  ;   ;Expatriate          ;Boolean        }
    { 72  ;   ;Total Score After Interview;Decimal }
    { 73  ;   ;Total Score After Shortlisting;Decimal }
    { 74  ;   ;Date of Interview   ;Date           }
    { 75  ;   ;From Time           ;Time           }
    { 76  ;   ;To Time             ;Time           }
    { 77  ;   ;Venue               ;Text100        }
    { 78  ;   ;Job Applied for Description;Text100 }
    { 79  ;   ;Regret Notice Sent  ;Boolean        }
    { 80  ;   ;Interview Type      ;Option        ;OptionCaptionML=ENU=Writen,Practicals,Oral;
                                                   OptionString=Writen,Practicals,Oral }
    { 81  ;   ;Qualification Status;Option        ;OptionCaptionML=ENU=" ,Qualified,UnQualified";
                                                   OptionString=[ ,Qualified,UnQualified] }
  }
  KEYS
  {
    {    ;Application No                          ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      HREmpReq@1000000000 : Record 51516103;
      Employee@1000000001 : Record 51516160;
      HRSetup@1000000002 : Record 51516192;
      NoSeriesMgt@1000000003 : Codeunit 396;
      EmpQualifications@1000000004 : Record 51516197;
      AppQualifications@1000000005 : Record 51516105;
      AppRefferees@1102755000 : Record 51516210;
      AppHobbies@1102755001 : Record 51516647;
      HRJobApp@1102755002 : Record 51516209;
      Country@1102755003 : Record 9;
      ObjHrJobs@1000 : Record 51516100;

    PROCEDURE FullName@1() : Text[100];
    BEGIN
      IF "Middle Name" = '' THEN
        EXIT("First Name" + ' ' + "Last Name")
      ELSE
        EXIT("First Name" + ' ' + "Middle Name" + ' ' + "Last Name");
    END;

    BEGIN
    END.
  }
}

