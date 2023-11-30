OBJECT table 50072 HR Employees
{
  OBJECT-PROPERTIES
  {
    Date=03/17/23;
    Time=[ 1:04:06 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,First Name,Middle Name,Last Name,Job Title,Search Name;
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                   HrSetup.GET;
                   HrSetup.TESTFIELD(HrSetup."Employee Nos.");
                   NoSeriesMgt.InitSeries(HrSetup."Employee Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;
             END;

    OnModify=BEGIN
               //"Last Date Modified" := TODAY;
             END;

    OnDelete=BEGIN
               //ERROR('Cannot be deleted')
             END;

    OnRename=BEGIN
               //"Last Date Modified" := TODAY;
             END;

    CaptionML=ENU=HR Employees;
    LookupPageID=Page51516130;
    DrillDownPageID=Page51516130;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;AltSearchField=Search Name;
                                                   OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  HrSetup.GET;
                                                                  NoSeriesMgt.TestManual(HrSetup."Employee Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   Editable=Yes }
    { 2   ;   ;First Name          ;Text50        ;OnValidate=BEGIN
                                                                "First Name":=UPPERCASE("First Name");
                                                              END;
                                                               }
    { 3   ;   ;Middle Name         ;Text50        ;OnValidate=BEGIN
                                                                "Middle Name":=UPPERCASE("Middle Name");
                                                              END;
                                                               }
    { 4   ;   ;Last Name           ;Text50        ;OnValidate=VAR
                                                                Reason@1000000000 : Text[30];
                                                              BEGIN
                                                                "Last Name":=UPPERCASE("Last Name")
                                                              END;
                                                               }
    { 5   ;   ;Initials            ;Text15        ;OnValidate=BEGIN
                                                                IF ("Search Name" = UPPERCASE(xRec.Initials)) OR ("Search Name" = '') THEN
                                                                  "Search Name" := Initials;
                                                              END;
                                                               }
    { 7   ;   ;Search Name         ;Code50         }
    { 8   ;   ;Postal Address      ;Text80         }
    { 9   ;   ;Residential Address ;Text80         }
    { 10  ;   ;City                ;Text30         }
    { 11  ;   ;Post Code           ;Code20        ;TableRelation="Post Code";
                                                   OnValidate=BEGIN
                                                                 PostCode.RESET;
                                                                 PostCode.SETRANGE(PostCode.Code,"Post Code");
                                                                 IF PostCode.FIND('-') THEN BEGIN
                                                                 City:=PostCode.City;
                                                                 END;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No }
    { 12  ;   ;County              ;Text30         }
    { 13  ;   ;Home Phone Number   ;Text30         }
    { 14  ;   ;Cellular Phone Number;Text30        }
    { 15  ;   ;Work Phone Number   ;Text30         }
    { 16  ;   ;Ext.                ;Text7          }
    { 17  ;   ;E-Mail              ;Text70        ;ExtendedDatatype=E-Mail }
    { 19  ;   ;Picture             ;BLOB          ;SubType=Bitmap }
    { 21  ;   ;ID Number           ;Text30         }
    { 22  ;   ;Union Code          ;Code15        ;TableRelation=Union }
    { 23  ;   ;UIF Number          ;Text30         }
    { 24  ;   ;Gender              ;Option        ;OptionString=[ ,Male,Female] }
    { 25  ;   ;Country Code        ;Code20        ;TableRelation=Country/Region }
    { 28  ;   ;Statistics Group Code;Code20       ;TableRelation="Employee Statistics Group" }
    { 31  ;   ;Status              ;Option        ;OnValidate=BEGIN
                                                                "Status Change Date":=TODAY;
                                                              END;

                                                   OptionCaptionML=ENU=Active,Inactive,Terminated;
                                                   OptionString=Active,Inactive,Terminated }
    { 32  ;   ;stat                ;Option        ;OptionCaptionML=ENU=" ,new";
                                                   OptionString=[ ,new] }
    { 35  ;   ;Location/Division Code;Code20      ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4));
                                                   OnValidate=BEGIN
                                                                IF SalCard.GET("No.") THEN BEGIN
                                                                //SalCard."Pays Pension":="Location/Division Code";
                                                                SalCard.MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 36  ;   ;Department Code     ;Code20        ;OnValidate=BEGIN
                                                                IF SalCard.GET("No.") THEN BEGIN
                                                                SalCard."Gratuity %":="Department Code";
                                                                SalCard.MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 37  ;   ;Office              ;Code40        ;Description=Dimension 3 }
    { 38  ;   ;Resource No.        ;Code20        ;TableRelation=Resource }
    { 39  ;   ;Comment             ;Boolean       ;Editable=No }
    { 40  ;   ;Last Date Modified  ;Date          ;Editable=No }
    { 41  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter }
    { 42  ;   ;Department Filter 1 ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3)) }
    { 43  ;   ;Office Filter       ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2)) }
    { 45  ;   ;Job T               ;Text1          }
    { 47  ;   ;Employee No. Filter ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=Employee }
    { 49  ;   ;Fax Number          ;Text30         }
    { 50  ;   ;Company E-Mail      ;Text70         }
    { 51  ;   ;Title               ;Option        ;OptionString=MR,MRS,MISS,MS,DR, ENG. ,DR.,CC,Prof }
    { 52  ;   ;Salespers./Purch. Code;Code20       }
    { 53  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   Editable=No }
    { 54  ;   ;Known As            ;Text30         }
    { 55  ;   ;Position            ;Text30        ;OnValidate=BEGIN
                                                                  {
                                                                      IF ((Position <> xRec.Position) AND (xRec.Position <> '')) THEN BEGIN
                                                                        Jobs.RESET;
                                                                        Jobs.SETRANGE(Jobs."Job ID",Position);
                                                                        IF Jobs.FIND('-') THEN BEGIN
                                                                            Payroll.RESET;
                                                                            Payroll.SETRANGE(Payroll.Code,"No.");
                                                                            IF Payroll.FIND('-') THEN BEGIN
                                                                                Payroll."Salary Scheme Category":=Jobs.Category;
                                                                                Payroll."Salary Steps":=Jobs.Grade;
                                                                                Payroll.VALIDATE(Payroll."Salary Steps");
                                                                                Payroll.MODIFY;
                                                                            END
                                                                        END



                                                                          {
                                                                        CareerEvent.SetMessage('Job Title Changed');
                                                                       CareerEvent.RUNMODAL;
                                                                       OK:= CareerEvent.ReturnResult;
                                                                        IF OK THEN BEGIN
                                                                           CareerHistory.INIT;
                                                                           IF NOT CareerHistory.FIND('-') THEN
                                                                            CareerHistory."Line No.":=1
                                                                          ELSE BEGIN
                                                                            CareerHistory.FIND('+');
                                                                            CareerHistory."Line No.":=CareerHistory."Line No."+1;
                                                                          END;

                                                                           CareerHistory."Employee No.":= "No.";
                                                                           CareerHistory."Date Of Event":= WORKDATE;
                                                                           CareerHistory."Career Event":= 'Job Title Changed';
                                                                           CareerHistory."Job Title":= "Position Title";
                                                                           CareerHistory."Employee First Name":= "Known As";
                                                                           CareerHistory."Employee Last Name":= "Last Name";
                                                                           CareerHistory.INSERT;
                                                                        END;
                                                                        }

                                                                    END;
                                                                 }
                                                              END;
                                                               }
    { 57  ;   ;Terms Of Service    ;Option        ;OptionCaptionML=ENU=" ,Full Time, Part Time,Interns,Casual";
                                                   OptionString=[ ,Full Time, Part Time,Interns,Casual] }
    { 58  ;   ;Contract Type       ;Option        ;CaptionML=ENU=Contract Status;
                                                   OptionCaptionML=ENU=Contract,Secondment,Temporary,Volunteer,Project Staff,Consultant-Contract,Consultant,Deployed,Board,Committee,Full Time,Casual;
                                                   OptionString=Contract,Secondment,Temporary,Volunteer,Project Staff,Consultant-Contract,Consultant,Deployed,Board,Committee,Full Time,Casual }
    { 59  ;   ;Contract End Date   ;Date           }
    { 60  ;   ;Notice Period       ;Code20         }
    { 61  ;   ;Union Member?       ;Boolean        }
    { 62  ;   ;Shift Worker?       ;Boolean        }
    { 63  ;   ;Contracted Hours    ;Decimal        }
    { 64  ;   ;Pay Period          ;Option        ;OptionString=[Weekly,2 Weekly,4 Weekly,Monthly, ] }
    { 65  ;   ;Pay Per Period      ;Decimal        }
    { 66  ;   ;Cost Code           ;Code20         }
    { 68  ;   ;Secondment Institution;Text30       }
    { 69  ;   ;UIF Contributor?    ;Boolean        }
    { 73  ;   ;Marital Status      ;Option        ;OptionString=[ ,Single,Married,Separated,Divorced,Widow(er),Other] }
    { 74  ;   ;Ethnic Origin       ;Option        ;OptionString=African,Indian,White,Coloured }
    { 75  ;   ;First Language (R/W/S);Code15       }
    { 76  ;   ;Driving Licence     ;Code15         }
    { 77  ;   ;Vehicle Registration Number;Code15  }
    { 78  ;   ;Disabled            ;Option        ;OnValidate=BEGIN
                                                                IF (Disabled = Disabled::Yes) THEN
                                                                   Status := Status::"5";
                                                              END;

                                                   OptionString=[No,Yes, ] }
    { 79  ;   ;Health Assesment?   ;Boolean        }
    { 80  ;   ;Health Assesment Date;Date          }
    { 81  ;   ;Date Of Birth       ;Date           }
    { 82  ;   ;Age                 ;Text80         }
    { 83  ;   ;Date Of Join        ;Date           }
    { 84  ;   ;Length Of Service   ;Text80         }
    { 85  ;   ;End Of Probation Date;Date          }
    { 86  ;   ;Pension Scheme Join ;Date           }
    { 87  ;   ;Time Pension Scheme ;Text50         }
    { 88  ;   ;Medical Scheme Join ;Date           }
    { 89  ;   ;Time Medical Scheme ;Text80        ;ValidateTableRelation=Yes;
                                                   TestTableRelation=Yes }
    { 90  ;   ;Date Of Leaving     ;Date           }
    { 91  ;   ;Paterson            ;Code15         }
    { 92  ;   ;Peromnes            ;Code15         }
    { 93  ;   ;Hay                 ;Code15         }
    { 94  ;   ;Castellion          ;Code15         }
    { 95  ;   ;Per Annum           ;Decimal        }
    { 96  ;   ;Allow Overtime      ;Option        ;OptionString=[Yes,No, ] }
    { 97  ;   ;Medical Scheme No.  ;Text30        ;OnValidate=BEGIN
                                                                        //MedicalAidBenefit.SETRANGE("Employee No.","No.");
                                                              END;
                                                               }
    { 98  ;   ;Medical Scheme Head Member;Text60  ;OnValidate=BEGIN
                                                                      //  MedicalAidBenefit.SETRANGE("Employee No.","No.");
                                                                      //   OK := MedicalAidBenefit.FIND('+');
                                                                      //  IF OK THEN BEGIN
                                                                        //  REPEAT
                                                                        //   MedicalAidBenefit."Medical Aid Head Member":= "Medical Aid Head Member";
                                                                       //    MedicalAidBenefit.MODIFY;
                                                                        //  UNTIL MedicalAidBenefit.NEXT = 0;
                                                                       // END;
                                                              END;
                                                               }
    { 99  ;   ;Number Of Dependants;Integer       ;OnValidate=BEGIN
                                                                        // MedicalAidBenefit.SETRANGE("Employee No.","No.");
                                                                        // OK := MedicalAidBenefit.FIND('+');
                                                                       // IF OK THEN BEGIN
                                                                          //REPEAT
                                                                         //  MedicalAidBenefit."Number Of Dependants":= "Number Of Dependants";
                                                                         //  MedicalAidBenefit.MODIFY;
                                                                          //UNTIL MedicalAidBenefit.NEXT = 0;
                                                                      // END;
                                                              END;
                                                               }
    { 100 ;   ;Medical Scheme Name ;Text80        ;OnValidate=BEGIN
                                                                         //MedicalAidBenefit.SETRANGE("Employee No.","No.");
                                                                         //OK := MedicalAidBenefit.FIND('+');
                                                                       //IF OK THEN BEGIN
                                                                         // REPEAT
                                                                          // MedicalAidBenefit."Medical Aid Name":= "Medical Aid Name";
                                                                         //  MedicalAidBenefit.MODIFY;
                                                                         // UNTIL MedicalAidBenefit.NEXT = 0;
                                                                       // END;
                                                              END;
                                                               }
    { 101 ;   ;Amount Paid By Employee;Decimal    ;OnValidate=BEGIN
                                                                       //  MedicalAidBenefit.SETRANGE("Employee No.","No.");
                                                                      //  OK := MedicalAidBenefit.FIND('+');
                                                                     //   IF OK THEN BEGIN
                                                                     //     REPEAT
                                                                     //      MedicalAidBenefit."Amount Paid By Employee":= "Amount Paid By Employee";
                                                                    //       MedicalAidBenefit.MODIFY;
                                                                    //     UNTIL MedicalAidBenefit.NEXT = 0;
                                                                    //    END;
                                                              END;
                                                               }
    { 102 ;   ;Amount Paid By Company;Decimal     ;OnValidate=BEGIN
                                                                       //  MedicalAidBenefit.SETRANGE("Employee No.","No.");
                                                                      //   OK := MedicalAidBenefit.FIND('+');
                                                                      //  IF OK THEN BEGIN
                                                                         // REPEAT
                                                                     //      MedicalAidBenefit."Amount Paid By Company":= "Amount Paid By Company";
                                                                     //      MedicalAidBenefit.MODIFY;
                                                                         // UNTIL MedicalAidBenefit.NEXT = 0;
                                                                     //   END;
                                                              END;
                                                               }
    { 103 ;   ;Receiving Car Allowance ?;Boolean   }
    { 104 ;   ;Second Language (R/W/S);Code15      }
    { 105 ;   ;Additional Language ;Code15         }
    { 106 ;   ;Cell Phone Reimbursement?;Boolean   }
    { 107 ;   ;Amount Reimbursed   ;Decimal        }
    { 108 ;   ;UIF Country         ;Code15        ;TableRelation=Country/Region.Code }
    { 109 ;   ;Direct/Indirect     ;Option        ;OptionString=Direct,Indirect }
    { 110 ;   ;Primary Skills Category;Option     ;OptionString=Auditors,Consultants,Training,Certification,Administration,Marketing,Management,Business Development,Other }
    { 111 ;   ;Level               ;Option        ;OptionString=[ ,Level 1,Level 2,Level 3,Level 4,Level 5,Level 6,Level 7] }
    { 112 ;   ;Termination Category;Option        ;OnValidate=VAR
                                                                "Lrec Resource"@1000000000 : Record 156;
                                                                OK@1000000001 : Boolean;
                                                              BEGIN
                                                              END;

                                                   OptionString=[ ,Resignation,Non-Renewal Of Contract,Dismissal,Retirement,Death,Other] }
    { 113 ;   ;Job Specification   ;Code30        ;TableRelation="HR Jobs"."Job ID";
                                                   OnValidate=BEGIN
                                                                objJobs.RESET;
                                                                objJobs.SETRANGE(objJobs."Job ID","Job Specification");
                                                                IF objJobs.FIND('-') THEN BEGIN
                                                                 "Job Title":=objJobs."Job Description";
                                                                END;
                                                              END;

                                                   Description=To put description on Job title field }
    { 114 ;   ;DateOfBirth         ;Date           }
    { 115 ;   ;DateEngaged         ;Text8          }
    { 116 ;   ;Postal Address2     ;Text30         }
    { 117 ;   ;Postal Address3     ;Text20         }
    { 118 ;   ;Residential Address2;Text30         }
    { 119 ;   ;Residential Address3;Text20         }
    { 120 ;   ;Post Code2          ;Code20        ;TableRelation="Post Code" }
    { 121 ;   ;Citizenship         ;Code15        ;TableRelation=Country/Region.Code }
    { 122 ;   ;Name Of Manager     ;Text45         }
    { 123 ;   ;User ID             ;Code30        ;TableRelation=User."User Name";
                                                   OnValidate=BEGIN
                                                                UserMgt.ValidateUserID("User ID");

                                                                IF "User ID" = '' THEN EXIT;

                                                                HREmp.RESET;
                                                                IF HREmp.GET("User ID") THEN
                                                                BEGIN
                                                                   EmpFullName:=HREmp."First Name" + SPACER + HREmp."Middle Name" + SPACER + HREmp."Last Name";
                                                                   ERROR('UserID [%1] has already been assigned to another Employee [%2]',"User ID",EmpFullName);
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=Yes }
    { 124 ;   ;Disabling Details   ;Text30         }
    { 125 ;   ;Disability Grade    ;Text30         }
    { 126 ;   ;Passport Number     ;Text30         }
    { 127 ;   ;2nd Skills Category ;Option        ;OptionString=[ ,Auditors,Consultants,Training,Certification,Administration,Marketing,Management,Business Development,Other] }
    { 128 ;   ;3rd Skills Category ;Option        ;OptionString=[ ,Auditors,Consultants,Training,Certification,Administration,Marketing,Management,Business Development,Other] }
    { 129 ;   ;PensionJoin         ;Text30         }
    { 130 ;   ;DateLeaving         ;Text30         }
    { 131 ;   ;Region              ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(REGION)) }
    { 132 ;   ;Manager Emp No      ;Code30         }
    { 133 ;   ;Temp                ;Text20         }
    { 134 ;   ;Employee Qty        ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("HR Employees") }
    { 135 ;   ;Employee Act. Qty   ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("HR Employees") }
    { 136 ;   ;Employee Arc. Qty   ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("HR Employees") }
    { 137 ;   ;Contract Location   ;Text20        ;Description=Location where contract was closed }
    { 138 ;   ;First Language Read ;Boolean        }
    { 139 ;   ;First Language Write;Boolean        }
    { 140 ;   ;First Language Speak;Boolean        }
    { 141 ;   ;Second Language Read;Boolean        }
    { 142 ;   ;Second Language Write;Boolean       }
    { 143 ;   ;Second Language Speak;Boolean       }
    { 144 ;   ;Custom Grading      ;Code20         }
    { 145 ;   ;PIN No.             ;Code20         }
    { 146 ;   ;NSSF No.            ;Code20         }
    { 147 ;   ;NHIF No.            ;Code20         }
    { 148 ;   ;Cause of Inactivity Code;Code15    ;TableRelation="Cause of Inactivity";
                                                   CaptionML=ENU=Cause of Inactivity Code }
    { 149 ;   ;Grounds for Term. Code;Code15      ;TableRelation="Grounds for Termination";
                                                   CaptionML=ENU=Grounds for Term. Code }
    { 150 ;   ;Sacco Staff No      ;Code20         }
    { 151 ;   ;Period Filter       ;Date          ;TableRelation="prPayroll Periods"."Date Opened" }
    { 152 ;   ;HELB No             ;Text15         }
    { 153 ;   ;Co-Operative No     ;Text30         }
    { 154 ;   ;Wedding Anniversary ;Date           }
    { 156 ;   ;Competency Area     ;Code20        ;FieldClass=FlowFilter }
    { 157 ;   ;Cost Center Code    ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2),
                                                                                               Dimension Value Type=CONST(Standard));
                                                   OnValidate=BEGIN
                                                                IF SalCard.GET("No.") THEN BEGIN
                                                                //SalCard."Gratuity Amount":="Cost Center Code";
                                                                SalCard.MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 158 ;   ;Position To Succeed ;Code20         }
    { 159 ;   ;Succesion Date      ;Date           }
    { 160 ;   ;Send Alert to       ;Code20         }
    { 161 ;   ;Tribe               ;Code15         }
    { 162 ;   ;Religion            ;Code20        ;TableRelation="HR Lookup Values".Code WHERE (Type=FILTER(Religion)) }
    { 163 ;   ;Job Title           ;Text35         }
    { 164 ;   ;Post Office No      ;Text10         }
    { 165 ;   ;Posting Group       ;Code15        ;TableRelation="Payroll Posting Groups";
                                                   NotBlank=No }
    { 166 ;   ;Payroll Posting Group;Code10       ;TableRelation="Payroll Posting Groups" }
    { 167 ;   ;Served Notice Period;Boolean        }
    { 168 ;   ;Exit Interview Date ;Date           }
    { 169 ;   ;Exit Interview Done by;Code20      ;TableRelation="HR Employees".No. }
    { 170 ;   ;Allow Re-Employment In Future;Boolean }
    { 171 ;   ;Medical Scheme Name #2;Text15      ;OnValidate=BEGIN
                                                                         //MedicalAidBenefit.SETRANGE("Employee No.","No.");
                                                                         //OK := MedicalAidBenefit.FIND('+');
                                                                       //IF OK THEN BEGIN
                                                                         // REPEAT
                                                                          // MedicalAidBenefit."Medical Aid Name":= "Medical Aid Name";
                                                                         //  MedicalAidBenefit.MODIFY;
                                                                         // UNTIL MedicalAidBenefit.NEXT = 0;
                                                                       // END;
                                                              END;
                                                               }
    { 172 ;   ;Resignation Date    ;Date           }
    { 173 ;   ;Suspension Date     ;Date           }
    { 174 ;   ;Demised Date        ;Date           }
    { 175 ;   ;Retirement date     ;Date           }
    { 176 ;   ;Retrenchment date   ;Date           }
    { 177 ;   ;Campus              ;Code15        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(CAMPUS)) }
    { 178 ;   ;Permanent           ;Boolean        }
    { 179 ;   ;Library Category    ;Option        ;OptionString=ADMIN STAFF,TEACHING STAFF,DIRECTORS }
    { 180 ;   ;Category            ;Code15         }
    { 181 ;   ;Payroll Departments ;Code15        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3)) }
    { 188 ;   ;Salary Grade        ;Code15        ;TableRelation="Payment Terms".Field1396040;
                                                   OnValidate=BEGIN
                                                                IF NOT CONFIRM('Changing the Grade will affect the Basic Salary',FALSE) THEN
                                                                   ERROR('You have opted to abort the process');


                                                                "Salary Notch/Step":='';

                                                                IF SalCard.GET("No.") THEN BEGIN
                                                                //SalCard.Gratuity:="Salary Grade";
                                                                SalCard.MODIFY;
                                                                END;


                                                                {
                                                                IF SalGrade.GET("Salary Grade") THEN BEGIN
                                                                    IF SalGrade."Salary Amount"<>0 THEN BEGIN
                                                                       IF SalCard.GET("No.") THEN BEGIN
                                                                          SalCard."Basic Pay":=SalGrade."Salary Amount";
                                                                          SalCard.MODIFY;
                                                                       END;
                                                                    END;
                                                                END;
                                                                }
                                                              END;
                                                               }
    { 189 ;   ;Company Type        ;Option        ;OptionCaptionML=ENU=Others,USAID;
                                                   OptionString=Others,USAID }
    { 190 ;   ;Main Bank           ;Code15         }
    { 191 ;   ;Branch Bank         ;Code20         }
    { 192 ;   ;Lock Bank Details   ;Boolean        }
    { 193 ;   ;Bank Account Number ;Code20         }
    { 195 ;   ;Payroll Code        ;Code20        ;TableRelation="prPayroll Type" }
    { 196 ;   ;Holiday Days Entitlement;Decimal    }
    { 197 ;   ;Holiday Days Used   ;Decimal        }
    { 198 ;   ;Payment Mode        ;Option        ;OptionString=[ ,Bank Transfer,Cheque,Cash,FOSA];
                                                   Description=Bank Transfer,Cheque,Cash,SACCO }
    { 199 ;   ;Hourly Rate         ;Decimal        }
    { 200 ;   ;Daily Rate          ;Decimal        }
    { 300 ;   ;Social Security No. ;Code20         }
    { 301 ;   ;Pension House       ;Code20         }
    { 302 ;   ;Salary Notch/Step   ;Code20        ;OnValidate=BEGIN

                                                                IF SalCard.GET("No.") THEN BEGIN
                                                                IF SalGrade.GET("Salary Grade") THEN
                                                                SalaryGrades."Pays NHF":=SalGrade."Pays NHF";
                                                                SalCard."Fosa Accounts":="Salary Notch/Step";

                                                                SalNotch.RESET;
                                                                SalNotch.SETRANGE(SalNotch."Salary Grade","Salary Grade");
                                                                SalNotch.SETRANGE(SalNotch."Salary Notch","Salary Notch/Step");
                                                                IF SalNotch.FIND('-') THEN BEGIN
                                                                IF SalNotch."Salary Amount"<>0 THEN BEGIN
                                                                IF SalCard.GET("No.") THEN BEGIN
                                                                SalCard."Basic Pay":=SalNotch."Salary Amount";
                                                                END;
                                                                END;
                                                                END;

                                                                SalCard.MODIFY;
                                                                END ELSE BEGIN
                                                                SalCard.INIT;
                                                                SalCard."Employee Code":="No.";
                                                                SalCard."Pays PAYE":=TRUE;
                                                                //SalCard."Pays Pension":="Location/Division Code";
                                                                SalCard."Gratuity %":="Department Code";
                                                                //SalCard."Gratuity Amount":="Cost Center Code";
                                                                //SalCard.Gratuity:="Salary Grade";
                                                                SalCard."Fosa Accounts":="Salary Notch/Step";
                                                                IF SalGrade.GET("Salary Grade") THEN
                                                                SalaryGrades."Pays NHF":=SalGrade."Pays NHF";

                                                                SalNotch.RESET;
                                                                SalNotch.SETRANGE(SalNotch."Salary Grade","Salary Grade");
                                                                SalNotch.SETRANGE(SalNotch."Salary Notch","Salary Notch/Step");
                                                                IF SalNotch.FIND('-') THEN BEGIN
                                                                IF SalNotch."Salary Amount"<>0 THEN BEGIN
                                                                SalCard."Basic Pay":=SalNotch."Salary Amount";
                                                                END;
                                                                END;
                                                                SalCard.INSERT;

                                                                END;


                                                                objPayrollPeriod.RESET;
                                                                objPayrollPeriod.SETRANGE(objPayrollPeriod.Closed,FALSE);
                                                                IF objPayrollPeriod.FIND('-') THEN BEGIN
                                                                NotchTrans.RESET;
                                                                NotchTrans.SETRANGE(NotchTrans."Salary Grade","Salary Grade");
                                                                NotchTrans.SETRANGE(NotchTrans."Salary Step/Notch","Salary Notch/Step");
                                                                IF NotchTrans.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                EmpTrans.RESET;
                                                                EmpTrans.SETCURRENTKEY(EmpTrans."Employee Code",EmpTrans."Transaction Code");
                                                                EmpTrans.SETRANGE(EmpTrans."Employee Code","No.");
                                                                EmpTrans.SETRANGE(EmpTrans."Transaction Code",NotchTrans."Transaction Code");
                                                                EmpTrans.SETRANGE(EmpTrans."Payroll Period",objPayrollPeriod."Date Opened");
                                                                IF EmpTrans.FIND('-') THEN BEGIN
                                                                EmpTrans.Amount:=NotchTrans.Amount;
                                                                EmpTrans.MODIFY;
                                                                END ELSE BEGIN
                                                                EmpTransR.INIT;
                                                                EmpTransR."Employee Code":="No.";
                                                                EmpTransR."Transaction Code":=NotchTrans."Transaction Code";
                                                                EmpTransR."Period Month":=objPayrollPeriod."Period Month";
                                                                EmpTransR."Period Year":=objPayrollPeriod."Period Year";
                                                                EmpTransR."Payroll Period":=objPayrollPeriod."Date Opened";
                                                                EmpTransR."Transaction Name":=NotchTrans."Transaction Name";
                                                                EmpTransR.Amount:=NotchTrans.Amount;
                                                                EmpTransR.INSERT;

                                                                END;


                                                                UNTIL NotchTrans.NEXT = 0;
                                                                END;

                                                                END;
                                                              END;
                                                               }
    { 303 ;   ;Status Change Date  ;Date           }
    { 304 ;   ;Previous Month Filter;Date         ;FieldClass=FlowFilter;
                                                   TableRelation="prPayroll Periods"."Date Opened" }
    { 305 ;   ;Current Month Filter;Date          ;FieldClass=FlowFilter }
    { 306 ;   ;Prev. Basic Pay     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("prPeriod Transactions".Amount WHERE (Employee Code=FIELD(No.),
                                                                                                         Transaction Code=CONST(BPAY),
                                                                                                         Payroll Period=FIELD(Previous Month Filter))) }
    { 307 ;   ;Curr. Basic Pay     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("prPeriod Transactions".Amount WHERE (Employee Code=FIELD(No.),
                                                                                                         Transaction Code=CONST(BPAY),
                                                                                                         Payroll Period=FIELD(Current Month Filter))) }
    { 308 ;   ;Prev. Gross Pay     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("prPeriod Transactions".Amount WHERE (Employee Code=FIELD(No.),
                                                                                                         Transaction Code=CONST(GPAY),
                                                                                                         Payroll Period=FIELD(Previous Month Filter))) }
    { 309 ;   ;Curr. Gross Pay     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("prPeriod Transactions".Amount WHERE (Employee Code=FIELD(No.),
                                                                                                         Transaction Code=CONST(GPAY),
                                                                                                         Payroll Period=FIELD(Current Month Filter))) }
    { 310 ;   ;Gross Income Variation;Decimal     ;FieldClass=Normal }
    { 311 ;   ;Basic Pay           ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("prSalary Card"."Basic Pay" WHERE (Employee Code=FIELD(No.)));
                                                   Editable=No }
    { 312 ;   ;Net Pay             ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("prPeriod Transactions".Amount WHERE (Employee Code=FIELD(No.),
                                                                                                         Transaction Code=CONST(NPAY),
                                                                                                         Payroll Period=FIELD(Current Month Filter))) }
    { 313 ;   ;Transaction Amount  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("prPeriod Transactions".Amount WHERE (Employee Code=FIELD(No.),
                                                                                                         Transaction Code=FIELD(Transaction Code Filter),
                                                                                                         Payroll Period=FIELD(Current Month Filter))) }
    { 314 ;   ;Transaction Code Filter;Text30     ;FieldClass=FlowFilter;
                                                   TableRelation="Job-Journal Line"."Journal Template Name" }
    { 317 ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=" ,Savings,Current";
                                                   OptionString=[ ,Savings,Current] }
    { 318 ;   ;Location/Division Filter;Code20    ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(LOC/DIV)) }
    { 319 ;   ;Department Filter   ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(DEPARTMENT)) }
    { 320 ;   ;Cost Centre Filter  ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(COSTCENTRE)) }
    { 323 ;   ;Payroll Type        ;Option        ;OptionCaptionML=ENU=General,Consultants,Seconded Staff;
                                                   OptionString=General,Consultants,Seconded Staff;
                                                   Description=General,Consultants,Seconded Staff }
    { 324 ;   ;Employee Classification;Code20     ;Description=Service }
    { 328 ;   ;Department Name     ;Text20         }
    { 2004;   ;Total Leave Taken   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Staff No.=FIELD(No.),
                                                                                                                  Posting Date=FIELD(Date Filter),
                                                                                                                  Leave Entry Type=CONST(Negative),
                                                                                                                  Period Closed=CONST(No)));
                                                   DecimalPlaces=2:2 }
    { 2006;   ;Total (Leave Days)  ;Decimal       ;DecimalPlaces=2:2;
                                                   Editable=No }
    { 2007;   ;Cash - Leave Earned ;Decimal       ;DecimalPlaces=2:2 }
    { 2008;   ;Reimbursed Leave Days;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Staff No.=FIELD(No.),
                                                                                                                  Posting Date=FIELD(Date Filter),
                                                                                                                  Leave Entry Type=CONST(Reimbursement),
                                                                                                                  Leave Type=FIELD(Leave Type Filter),
                                                                                                                  Period Closed=CONST(No)));
                                                   OnValidate=BEGIN
                                                                          VALIDATE("Allocated Leave Days");
                                                              END;

                                                   DecimalPlaces=2:2 }
    { 2009;   ;Cash per Leave Day  ;Decimal       ;DecimalPlaces=2:2 }
    { 2023;   ;Allocated Leave Days;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Staff No.=FIELD(No.),
                                                                                                                  Posting Date=FIELD(Date Filter),
                                                                                                                  Leave Entry Type=CONST(Positive),
                                                                                                                  Period Closed=CONST(No)));
                                                   OnValidate=BEGIN
                                                                CALCFIELDS("Total Leave Taken");
                                                                "Total (Leave Days)" := "Allocated Leave Days"; //+ "Reimbursed Leave Days";
                                                                //SUM UP LEAVE LEDGER ENTRIES
                                                                "Leave Balance" := "Total (Leave Days)" + "Total Leave Taken";
                                                                //TotalDaysVal := Rec."Total Leave Taken";
                                                              END;
                                                               }
    { 2024;   ;End of Contract Date;Date           }
    { 2040;   ;Leave Period Filter ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="HR Leave Periods"."Starting Date" WHERE (New Fiscal Year=CONST(No)) }
    { 3971;   ;Annual Leave Account;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(ANNUAL),
                                                                                                                  Staff No.=FIELD(No.))) }
    { 3972;   ;Compassionate Leave Acc.;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(COMPASSIONATE),
                                                                                                                  Staff No.=FIELD(No.),
                                                                                                                  Period Closed=CONST(No))) }
    { 3973;   ;Maternity Leave Acc.;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(MATERNITY),
                                                                                                                  Staff No.=FIELD(No.),
                                                                                                                  Period Closed=CONST(No))) }
    { 3974;   ;Paternity Leave Acc.;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(PARTENITY),
                                                                                                                  Staff No.=FIELD(No.),
                                                                                                                  Period Closed=CONST(No))) }
    { 3975;   ;Sick Leave Acc.     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(SICK LEAVE),
                                                                                                                  Staff No.=FIELD(No.),
                                                                                                                  Period Closed=CONST(No))) }
    { 3976;   ;Study Leave Acc     ;Decimal        }
    { 3977;   ;Appraisal Method    ;Option        ;OptionCaptionML=ENU=" ,Normal Appraisal,360 Appraisal";
                                                   OptionString=[ ,Normal Appraisal,360 Appraisal] }
    { 3988;   ;Leave Type          ;Code20        ;TableRelation="HR Leave Types".Code }
    { 50002;  ;Bosa Member account ;Code20        ;TableRelation="Members Register" }
    { 50003;  ;Sacco Paying Bank Code;Code20      ;TableRelation="Bank Account".No.;
                                                   OnValidate=BEGIN
                                                                 {BankRec.RESET;
                                                                 BankRec.SETRANGE(BankRec."No.","Sacco Paying Bank Code");
                                                                 IF BankRec.FIND('-') THEN BEGIN
                                                                 "Sacco Paying Bank Name":=BankRec.Name;
                                                                  END;
                                                                  }
                                                              END;
                                                               }
    { 50004;  ;Sacco Paying Bank Name;Text20       }
    { 50005;  ;Cheque No           ;Code20        ;OnValidate=BEGIN
                                                                 {
                                                                 //***Avoid cheque no Duplications
                                                                 BankLedg.RESET;
                                                                 BankLedg.SETRANGE(BankLedg."Bank Account No.","Sacco Paying Bank Code");
                                                                 BankLedg.SETRANGE(BankLedg."External Document No.","Cheque No");
                                                                 IF BankLedg.FIND('-') THEN BEGIN
                                                                 ERROR('A document with the same Cheque no has been posted');
                                                                 END;
                                                                 }
                                                              END;
                                                               }
    { 53900;  ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   CaptionClass='1,1,1' }
    { 53901;  ;Global Dimension 2 Code;Code30     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=ENU=Global Dimension 2 Code;
                                                   CaptionClass='1,1,2' }
    { 53902;  ;Responsibility Center;Code15       ;TableRelation="Responsibility Center".Code }
    { 53903;  ;HR                  ;Boolean        }
    { 53904;  ;Date Of Joining the Company;Date    }
    { 53905;  ;Date Of Leaving the Company;Date    }
    { 53906;  ;Termination Grounds ;Option        ;OptionCaptionML=ENU=" ,Resignation,Non-Renewal Of Contract,Dismissal,Retirement,Death,Other";
                                                   OptionString=[ ,Resignation,Non-Renewal Of Contract,Dismissal,Retirement,Death,Other] }
    { 53907;  ;Cell Phone Number   ;Text30        ;ExtendedDatatype=Phone No. }
    { 53908;  ;Grade               ;Code20        ;TableRelation="HR Lookup Values".Code WHERE (Type=CONST(Grade)) }
    { 53909;  ;Employee UserID     ;Code30        ;TableRelation="User Setup"."User ID" }
    { 53910;  ;Leave Balance       ;Decimal        }
    { 53911;  ;Leave Status        ;Option        ;OptionCaptionML=ENU=" ,On Leave,Resumed";
                                                   OptionString=[ ,On Leave,Resumed] }
    { 53912;  ;Pension Scheme Join Date;Date       }
    { 53913;  ;Medical Scheme Join Date;Date       }
    { 53914;  ;Leave Type Filter   ;Code20        ;TableRelation="HR Leave Types".Code }
    { 53915;  ;Acrued Leave Days   ;Decimal        }
    { 53916;  ;Supervisor          ;Boolean        }
    { 53917;  ;Signature           ;BLOB          ;SubType=Bitmap }
    { 53918;  ;Grant/Compliance Officer;Boolean    }
    { 53919;  ;Shortcut Dimension 3 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(PRODUCT));
                                                   OnValidate=BEGIN
                                                                {DimVal.RESET;
                                                                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                                                                DimVal.SETRANGE(DimVal.Code,"Shortcut Dimension 3 Code");
                                                                 IF DimVal.FIND('-') THEN
                                                                    IsCommette:=DimVal.Name
                                                                }
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 3 Code;
                                                   Description=Stores the reference of the Third global dimension in the database;
                                                   CaptionClass='1,2,3' }
    { 53920;  ;Shortcut Dimension 4 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4));
                                                   OnValidate=BEGIN
                                                                {DimVal.RESET;
                                                                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                                                                DimVal.SETRANGE(DimVal.Code,"Shortcut Dimension 4 Code");
                                                                 IF DimVal.FIND('-') THEN
                                                                    IsBoardChair:=DimVal.Name
                                                                }
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 4 Code;
                                                   Description=Stores the reference of the Fourth global dimension in the database;
                                                   CaptionClass='1,2,4' }
    { 53921;  ;IsCommette          ;Boolean        }
    { 53922;  ;IsBoardChair        ;Boolean        }
    { 53923;  ;IsPayrollPeriodCreator;Boolean      }
    { 53924;  ;Shortcut Dimension 5 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(5));
                                                   OnValidate=BEGIN
                                                                {DimVal.RESET;
                                                                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                                                                DimVal.SETRANGE(DimVal.Code,"Shortcut Dimension 4 Code");
                                                                 IF DimVal.FIND('-') THEN
                                                                    IsBoardChair:=DimVal.Name
                                                                 }
                                                              END;

                                                   Description=Stores the reference of the 5th global dimension in the database Station;
                                                   CaptionClass='1,2,5' }
    { 53925;  ;Institutional Base  ;Decimal        }
    { 53926;  ;Bank Code           ;Code15         }
    { 53927;  ;IsBoard             ;Boolean        }
    { 53928;  ;Branch Code         ;Code15         }
    { 53929;  ;Attachement 1       ;BLOB          ;SubType=Bitmap }
    { 53930;  ;Attachement 2       ;BLOB          ;SubType=Bitmap }
    { 53931;  ;Attachement 3       ;BLOB          ;SubType=Bitmap }
    { 53932;  ;Attachement 4       ;BLOB          ;SubType=Bitmap }
    { 53933;  ;Attachement 5       ;BLOB          ;SubType=Bitmap }
    { 53934;  ;Attachement 6       ;BLOB          ;SubType=Bitmap }
    { 53935;  ;Attachement 7       ;BLOB          ;SubType=Bitmap }
    { 53936;  ;Attachement 8       ;BLOB          ;SubType=Bitmap }
    { 53937;  ;Attachement 9       ;BLOB          ;SubType=Bitmap }
    { 53938;  ;Attachement 10      ;BLOB          ;SubType=Bitmap }
    { 53939;  ;Pension Number      ;Code20         }
    { 53940;  ;Claim Limit         ;Decimal       ;OnValidate=BEGIN
                                                                IF "Claim Limit"<0 THEN
                                                                ERROR('Your Cannot have Negative Amount');
                                                              END;

                                                   CaptionML=ENU=Medical Claim Limit }
    { 53941;  ;Claim Amount Used   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Medical Claim Entries"."Amount Claimed" WHERE (Employee No=FIELD(No.)));
                                                   OnValidate=BEGIN
                                                                {ClaimEntries.RESET;
                                                                ClaimEntries.SETRANGE(ClaimEntries."Employee No","No.");
                                                                IF ClaimEntries.FIND('-') THEN BEGIN
                                                                  UsedAMTBuffer:=ClaimEntries."Amount Claimed";
                                                                  END;
                                                                "Claim Remaining Amount":="Claim Limit"-UsedAMTBuffer;
                                                                MODIFY;
                                                                }
                                                              END;

                                                   CaptionML=ENU=Medical Claim Amount Used;
                                                   Editable=No }
    { 53942;  ;Fosa Account        ;Code20        ;TableRelation=Vendor.No. }
    { 53943;  ;Claim Remaining Amount;Decimal     ;FieldClass=Normal;
                                                   CaptionML=ENU=Medical Claim Remaining Amount;
                                                   Editable=No }
    { 53944;  ;Leave Allowance Claimed;Boolean     }
    { 53945;  ;Leave Allowance Amount;Decimal      }
    { 53946;  ;Annual Leave Account Total;Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(ANNUAL),
                                                                                                                  Staff No.=FIELD(No.))) }
    { 53947;  ;Compassionate Leave Total;Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(COMPASSIONATE),
                                                                                                                  Staff No.=FIELD(No.),
                                                                                                                  Leave Entry Type=CONST(Positive))) }
    { 53948;  ;Maternity Leave  Total;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(MATERNITY),
                                                                                                                  Staff No.=FIELD(No.),
                                                                                                                  Leave Entry Type=CONST(Positive))) }
    { 53949;  ;Paternity Leave Total;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(PATERNITY),
                                                                                                                  Staff No.=FIELD(No.),
                                                                                                                  Leave Entry Type=CONST(Positive))) }
    { 53950;  ;Sick Leave Total    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(SICK),
                                                                                                                  Staff No.=FIELD(No.),
                                                                                                                  Leave Entry Type=CONST(Positive))) }
    { 53951;  ;Emmergency Leave Total;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(EMERGENCY),
                                                                                                                  Staff No.=FIELD(No.),
                                                                                                                  Leave Entry Type=CONST(Positive))) }
    { 53952;  ;Annual Leave Taken  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(ANNUAL),
                                                                                                                   Staff No.=FIELD(No.),
                                                                                                                   Leave Entry Type=CONST(Negative),
                                                                                                                   Period Closed=CONST(No))) }
    { 53953;  ;Compassionate Leave Taken;Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(COMPASSIONATE),
                                                                                                                   Staff No.=FIELD(No.),
                                                                                                                   Leave Entry Type=CONST(Negative),
                                                                                                                   Period Closed=CONST(No))) }
    { 53954;  ;Maternity Leave  taken;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(MATERNITY),
                                                                                                                   Staff No.=FIELD(No.),
                                                                                                                   Leave Entry Type=CONST(Negative),
                                                                                                                   Period Closed=CONST(No))) }
    { 53955;  ;Paternity Leave Taken;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(PATERNITY),
                                                                                                                   Staff No.=FIELD(No.),
                                                                                                                   Leave Entry Type=CONST(Negative),
                                                                                                                   Period Closed=CONST(No))) }
    { 53956;  ;Sick Leave Taken    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(SICK),
                                                                                                                   Staff No.=FIELD(No.),
                                                                                                                   Leave Entry Type=CONST(Negative),
                                                                                                                   Period Closed=CONST(No))) }
    { 53957;  ;Emmergency LeaveTaken;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(EMERGENCY),
                                                                                                                   Staff No.=FIELD(No.),
                                                                                                                   Leave Entry Type=CONST(Negative),
                                                                                                                   Period Closed=CONST(No))) }
    { 53958;  ;P9 Report           ;Boolean        }
    { 53959;  ;Advance Leave       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(452),
                                                                                                                  Staff No.=FIELD(No.),
                                                                                                                  Leave Entry Type=CONST(Positive))) }
    { 53960;  ;Advance Leave Taken ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("HR Leave Ledger Entries"."No. of days" WHERE (Leave Type=CONST(452),
                                                                                                                   Staff No.=FIELD(No.),
                                                                                                                   Leave Entry Type=CONST(Negative),
                                                                                                                   Period Closed=CONST(No))) }
    { 53961;  ;Medical Claim Limit ;Decimal        }
    { 53962;  ;Mobile No           ;Code20         }
    { 53963;  ;Supervisor User ID  ;Code40        ;TableRelation="User Setup"."User ID";
                                                   OnValidate=BEGIN
                                                                HREmp.RESET;
                                                                HREmp.SETRANGE(HREmp."User ID","Supervisor User ID");
                                                                IF HREmp.FINDFIRST THEN BEGIN
                                                                "Supervisor Names":=HREmp."First Name"+' '+HREmp."Middle Name";
                                                                END;
                                                              END;
                                                               }
    { 53964;  ;Department          ;Code40        ;TableRelation="HR Lookup Values".Code WHERE (Type=CONST(Department)) }
    { 53965;  ;Supervisor Names    ;Text60        ;Editable=No }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;First Name                               }
    {    ;Last Name                                }
    {    ;ID Number                                }
    {    ;Known As                                 }
    {    ;User ID                                  }
    {    ;Cost Code                                }
    {    ;Date Of Join,Date Of Leaving             }
    {    ;Termination Category                     }
    {    ;Department Code                          }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Initials,First Name,Middle Name,Last Name }
  }
  CODE
  {
    VAR
      Res@1000000002 : Record 156;
      PostCode@1000000003 : Record 225;
      SalespersonPurchaser@1000000011 : Record 13;
      NoSeriesMgt@1000000012 : Codeunit 396;
      OK@1000000018 : Boolean;
      User@1000000038 : Record 91;
      ERROR1@1000000039 : TextConst 'ENU=Employee Career History Starting Information already exist.';
      MSG1@1000000040 : TextConst 'ENU=Employee Career History Starting Information successfully created.';
      ReasonDiaglog@1000000041 : Dialog;
      EmpQualification@1000000046 : Record 5203;
      PayStartDate@1000000050 : Date;
      PayPeriodText@1000000051 : Text[30];
      ToD@1000000053 : Date;
      CurrentMonth@1102760000 : Date;
      HrSetup@1102760002 : Record 51516192;
      SalCard@1102756000 : Record 51516265;
      SalGrade@1102756001 : Record 51516162;
      SalNotch@1102755000 : Record 51516166;
      objPayrollPeriod@1102755001 : Record 51516112;
      EmpTrans@1102755002 : Record 51516412;
      EmpTransR@1102755004 : Record 51516412;
      NotchTrans@1102755003 : Record 51516167;
      SalaryGrades@1102755005 : Record 51516162;
      UserMgt@1000 : Codeunit 418;
      DimVal@1001 : Record 349;
      objJobs@1000000000 : Record 51516100;
      HREmp@1002 : Record 51516160;
      EmpFullName@1003 : Text;
      SPACER@1004 : TextConst 'ENU=" "';
      BankRec@1000000001 : Record 270;
      ClaimEntries@1000000004 : Record 51516294;
      UsedAMTBuffer@1000000005 : Decimal;

    PROCEDURE AssistEdit@2(OldEmployee@1000000000 : Record 51516160) : Boolean;
    BEGIN
    END;

    PROCEDURE FullName@1() : Text[100];
    BEGIN
      IF "Middle Name" = '' THEN
        EXIT("First Name" + ' ' + "Last Name")
      ELSE
        EXIT("First Name" + ' ' + "Middle Name" + ' ' + "Last Name");
    END;

    PROCEDURE CurrentPayDetails@3();
    BEGIN
    END;

    PROCEDURE UpdtResUsersetp@4(VAR HREmpl@1000000000 : Record 51516160);
    VAR
      Res@1000000001 : Record 156;
      Usersetup@1000000002 : Record 91;
    BEGIN
      {
      ContMgtSetup.GET;
      IF ContMgtSetup."Customer Integration" =
         ContMgtSetup."Customer Integration"::"No Integration"
      THEN
        EXIT;
      }
      {
      Res.SETCURRENTKEY("No.");
      Res.SETRANGE("No.",HREmpl."Resource No.");
      IF Res.FIND('-') THEN BEGIN
        Res."Global Dimension 1 Code" := HREmpl."Department Code";
        Res."Global Dimension 2 Code" := HREmpl.Office;
        Res.MODIFY;
      END;

      IF Usersetup.GET(HREmpl."User ID") THEN BEGIN
        Usersetup.Department := HREmpl."Department Code";
        Usersetup.Office := HREmpl.Office;
        Usersetup.MODIFY;
      END;
      }
    END;

    PROCEDURE SetEmployeeHistory@5();
    BEGIN
    END;

    PROCEDURE GetPayPeriod@1000000000();
    BEGIN
    END;

    BEGIN
    END.
  }
}

