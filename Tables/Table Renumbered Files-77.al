OBJECT table 50096 HR Leave Application
{
  OBJECT-PROPERTIES
  {
    Date=02/20/23;
    Time=11:48:45 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnInsert=VAR
               LeaveEntry@1120054000 : Record 51516201;
             BEGIN
               //No. Series
               IF "Application Code" = '' THEN
               BEGIN
                 HRSetup.GET;
                 HRSetup.TESTFIELD(HRSetup."Leave Application Nos.");
                 NoSeriesMgt.InitSeries(HRSetup."Leave Application Nos.",xRec."No series",0D,"Application Code","No series");
               END;

               HREmp.RESET;
               HREmp.SETRANGE(HREmp."User ID",USERID);
               IF HREmp.FIND('-') THEN
               BEGIN
                   HREmp.TESTFIELD(HREmp."Date Of Join");

                   Calendar.RESET;
                   Calendar.SETRANGE("Period Type",Calendar."Period Type"::Month);
                   Calendar.SETRANGE("Period Start",HREmp."Date Of Join",TODAY);
                   empMonths := Calendar.COUNT;

                   //Minimum duration in months for Leave Applications
                   IF HRSetup.GET THEN
                   BEGIN
                      // HRSetup.TESTFIELD(HRSetup."Min. Leave App. Months");
                       IF empMonths < HRSetup."Min. Leave App. Months" THEN ERROR(Text002,HRSetup."Min. Leave App. Months");
                   END;

                   //Populate fields
                   "Employee No":=HREmp."No.";
                   "Employee Name":= HREmp.FullName;
                   Gender:=HREmp.Gender;
                   "E-mail Address":=HREmp."E-Mail";
                   "Cell Phone Number":=HREmp."Cell Phone Number";
                   "Application Date":=TODAY;
                    "Department Code":=HREmp.Department;
                    Supervisor:=HREmp."Supervisor Names";
                   Supervisor:=HREmp."Supervisor User ID";
                   "User ID":=USERID;
                   "Job Tittle":=HREmp."Job Title";
                   HREmp.CALCFIELDS(HREmp.Picture);
                   Picture:=HREmp.Picture;
                   //Approver details
                   //GetApplicantSupervisor(USERID);
               END ELSE
               BEGIN
                  // ERROR('UserID'+' '+'['+USERID+']'+' has not been assigned to any employee. Please consult the HR officer for assistance')
               END;
               HRLeavePeriods.RESET;
               HRLeavePeriods.SETRANGE(HRLeavePeriods.Closed,FALSE);
               IF HRLeavePeriods.FINDFIRST THEN BEGIN
               "Leave Period":=HRLeavePeriods."Period Code";
               END;
             END;

    OnDelete=BEGIN
                IF Status<>Status::New THEN ERROR('You cannot delete this leave application');
             END;

  }
  FIELDS
  {
    { 1   ;   ;Application Code    ;Code20        ;OnValidate=BEGIN
                                                                //TEST IF MANUAL NOs ARE ALLOWED
                                                                IF "Application Code" <> xRec."Application Code" THEN BEGIN
                                                                  HRSetup.GET;
                                                                  NoSeriesMgt.TestManual(HRSetup."Leave Application Nos.");
                                                                  "No series" := '';
                                                                END;
                                                              END;

                                                   Editable=No }
    { 3   ;   ;Leave Type          ;Code30        ;TableRelation="HR Leave Types".Code;
                                                   OnValidate=VAR
                                                                LeaveEntry@1120054001 : Record 51516201;
                                                              BEGIN
                                                                IF emp.GET("Employee No") THEN BEGIN
                                                                IF LeaveTypes.GET("Leave Type") THEN
                                                                    BEGIN
                                                                IF LeaveTypes.Gender=LeaveTypes.Gender::Female THEN BEGIN
                                                                IF emp.Gender=emp.Gender::Male THEN
                                                                ERROR('%1 can only be assigned to %2 employees',LeaveTypes.Description,LeaveTypes.Gender);
                                                                END;
                                                                IF LeaveTypes.Gender=LeaveTypes.Gender::Male THEN BEGIN
                                                                IF emp.Gender=emp.Gender::Female THEN
                                                                ERROR('%1 can only be assigned to %2 employees',LeaveTypes.Description,LeaveTypes.Gender);
                                                                END;
                                                                END;
                                                                END;
                                                                IF "Leave Type"='ANNUAL' THEN BEGIN
                                                                LeaveEntry.RESET;
                                                                LeaveEntry.SETRANGE(LeaveEntry."Staff No.","Employee No");
                                                                LeaveEntry.SETRANGE(LeaveEntry."Leave Type","Leave Type");
                                                                IF LeaveEntry.FINDSET THEN BEGIN
                                                                LeaveEntry.CALCSUMS(LeaveEntry."No. of days");
                                                                "Available Days":=LeaveEntry."No. of days";
                                                                //"Leave Balance":=LeaveEntry."No. of days";
                                                                END;
                                                                END ELSE BEGIN
                                                                LeaveEntry.RESET;
                                                                LeaveEntry.SETRANGE(LeaveEntry."Leave Period","Leave Period");
                                                                LeaveEntry.SETRANGE(LeaveEntry."Staff No.","Employee No");
                                                                LeaveEntry.SETRANGE(LeaveEntry."Leave Type","Leave Type");
                                                                IF LeaveEntry.FINDSET THEN BEGIN
                                                                LeaveEntry.CALCSUMS(LeaveEntry."No. of days");
                                                                "Available Days":=LeaveEntry."No. of days";
                                                                //"Leave Balance":=LeaveEntry."No. of days";
                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 4   ;   ;Days Applied        ;Decimal       ;OnValidate=BEGIN
                                                                {
                                                                TESTFIELD("Leave Type");
                                                                //CALCULATE THE END DATE AND RETURN DATE
                                                                BEGIN
                                                                IF ("Days Applied" <> 0) AND ("Start Date" <> 0D) THEN
                                                                "Return Date" := DetermineLeaveReturnDate("Start Date","Days Applied");
                                                                "End Date" := DeterminethisLeaveEndDate("Return Date");
                                                                MODIFY;
                                                                END;
                                                                 }



                                                                //CALCFIELDS("Available Days");
                                                                IF "Leave Type"='ANNUAL' THEN BEGIN
                                                                "Leave Balance":="Available Days"-"Days Applied";
                                                                IF (("Available Days"=0) OR ("Days Applied">"Available Days"))  THEN BEGIN
                                                                  ERROR('This will exceed your leave balance');
                                                                END;
                                                                IF ("Days Applied" <> 0) AND ("Start Date" <> 0D) THEN BEGIN
                                                                  VALIDATE("Start Date")
                                                                END;
                                                                END;
                                                                "Approved days":="Days Applied";
                                                                "Leave Balance":="Available Days"-"Days Applied";
                                                              END;
                                                               }
    { 5   ;   ;Start Date          ;Date          ;OnValidate=BEGIN
                                                                {{
                                                                IF "Leave Type"<>'EMERGENCY' THEN BEGIN
                                                                    Calendar.RESET;
                                                                    Calendar.SETRANGE("Period Type",Calendar."Period Type"::Date);
                                                                    Calendar.SETFILTER("Period Start",'%1..%2',TODAY,"Start Date");
                                                                    empMonths := Calendar.COUNT;
                                                                END ELSE
                                                                     empMonths := 0;

                                                                IF "Leave Type"<>'EMERGENCY' THEN BEGIN
                                                                 IF empMonths<30 THEN ERROR('You have to apply for leave one month earlier');
                                                                END;
                                                                 }
                                                                IF "Start Date"=0D THEN BEGIN
                                                                "Return Date":=0D;
                                                                EXIT;
                                                                END ELSE BEGIN
                                                                      IF DetermineIfIsNonWorking("Start Date")= TRUE THEN BEGIN;
                                                                      ERROR('Start date must be a working day');
                                                                      END;
                                                                      VALIDATE("Days Applied");
                                                                END;
                                                                 }





                                                                //new start date validation
                                                                dates.RESET;
                                                                dates.SETRANGE(dates."Period Start","Start Date");
                                                                dates.SETFILTER(dates."Period Type",'=%1',dates."Period Type"::Date);
                                                                IF dates.FIND('-') THEN
                                                                  IF ((dates."Period Name"='Sunday') OR (dates."Period Name"='Saturday')) THEN BEGIN
                                                                  IF (dates."Period Name"='Sunday') THEN ERROR('You can not start your leave on a Sunday')
                                                                  ELSE IF (dates."Period Name"='Saturday') THEN ERROR('You can not start your leave on a Saturday')
                                                                  END;
                                                                BaseCalendar.RESET;
                                                                BaseCalendar.SETFILTER(BaseCalendar."Base Calendar Code",GeneralOptions."Base Calendar");
                                                                BaseCalendar.SETRANGE(BaseCalendar.Date,"Start Date");
                                                                IF BaseCalendar.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                IF BaseCalendar.Nonworking = TRUE THEN BEGIN
                                                                IF BaseCalendar.Description<>'' THEN
                                                                 ERROR('You can not start your Leave on a Holiday - '''+BaseCalendar.Description+'''')
                                                                 ELSE ERROR('You can not start your Leave on a Holiday');
                                                                END;
                                                                UNTIL BaseCalendar.NEXT=0;
                                                                END;

                                                                // For Annual Holidays
                                                                BaseCalendar.RESET;
                                                                BaseCalendar.SETFILTER(BaseCalendar."Base Calendar Code",GeneralOptions."Base Calendar");
                                                                BaseCalendar.SETRANGE(BaseCalendar."Recurring System",BaseCalendar."Recurring System"::"Annual Recurring");
                                                                IF BaseCalendar.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                IF ((DATE2DMY("Start Date",1)=BaseCalendar."Date Day") AND (DATE2DMY("Start Date",2)=BaseCalendar."Date Month")) THEN BEGIN
                                                                IF BaseCalendar.Nonworking = TRUE THEN BEGIN
                                                                IF BaseCalendar.Description<>'' THEN
                                                                 ERROR('You can not start your Leave on a Holiday - '''+BaseCalendar.Description+'''')
                                                                 ELSE ERROR('You can not start your Leave on a Holiday');
                                                                END;
                                                                END;
                                                                UNTIL BaseCalendar.NEXT=0;
                                                                END;


                                                                IF ("Days Applied" <> 0) AND ("Start Date" <> 0D) THEN BEGIN
                                                                   "End Date":=CalcEndDate("Start Date","Days Applied" );
                                                                   "Return Date" :=CalcReturnDate("End Date");
                                                                   dates.RESET;
                                                                dates.SETRANGE(dates."Period Start","Start Date");
                                                                dates.SETFILTER(dates."Period Type",'=%1',dates."Period Type"::Date);
                                                                IF dates.FIND('-') THEN
                                                                  IF (dates."Period Name"='Monday')  THEN BEGIN
                                                                  "Return Date" :=CalcReturnDate("End Date")-1;
                                                                  END;
                                                                   //"Approved End Date":="End Date";

                                                                END;

                                                                {Start Date - OnLookup()

                                                                End Date - OnValidate()

                                                                End Date - OnLookup()

                                                                Purpose - OnValidate()

                                                                Purpose - OnLookup()

                                                                Leave Type - OnValidate()
                                                                  CALCFIELDS("Availlable Days");
                                                                 IF Emp.GET("Employee No") THEN BEGIN
                                                                 Emp.CALCFIELDS(Emp."Leave Balance");
                                                                 "Leave Balance":=Emp."Leave Balance";
                                                                 END;
                                                                  }


                                                                  IF "Start Date"<"Application Date"THEN
                                                                ERROR('You cannot Start your leave before the application date');
                                                              END;
                                                               }
    { 6   ;   ;Return Date         ;Date          ;CaptionML=ENU=Return Date }
    { 7   ;   ;Application Date    ;Date           }
    { 12  ;   ;Status              ;Option        ;OnValidate=BEGIN
                                                                IF Status=Status::Approved THEN
                                                                 BEGIN
                                                                  intEntryNo:=0;

                                                                  HRLeaveEntries.RESET;
                                                                  HRLeaveEntries.SETRANGE(HRLeaveEntries."Entry No.");
                                                                   IF HRLeaveEntries.FIND('-') THEN intEntryNo:=HRLeaveEntries."Entry No.";

                                                                  intEntryNo:=intEntryNo+1;

                                                                  HRLeaveEntries.INIT;
                                                                  HRLeaveEntries."Entry No.":=intEntryNo;
                                                                  HRLeaveEntries."Staff No.":="Employee No";
                                                                  HRLeaveEntries."Staff Name":= Names;
                                                                  HRLeaveEntries."Posting Date":=TODAY;
                                                                  HRLeaveEntries."Leave Entry Type":=HRLeaveEntries."Leave Entry Type"::Negative;
                                                                  HRLeaveEntries."Leave Approval Date":="Application Date";
                                                                  HRLeaveEntries."Document No.":="Application Code";
                                                                  HRLeaveEntries."External Document No.":="Employee No";
                                                                  HRLeaveEntries."Job ID":="Job Tittle";
                                                                  HRLeaveEntries."No. of days":="Days Applied";
                                                                  HRLeaveEntries."Leave Start Date":="Start Date";
                                                                  HRLeaveEntries."Leave Posting Description":='Leave';
                                                                  HRLeaveEntries."Leave End Date":="End Date";
                                                                  HRLeaveEntries."Leave Return Date":="Return Date";
                                                                  HRLeaveEntries."User ID" :="User ID";
                                                                  HRLeaveEntries."Leave Type":="Leave Type";
                                                                  HRLeaveEntries.INSERT;
                                                                END;
                                                              END;

                                                   OptionCaptionML=ENU=New,Pending Approval,HOD Approval,HR Approval,Final Approval,Rejected,Canceled,Approved,On leave,Resumed,Posted;
                                                   OptionString=New,Pending Approval,HOD Approval,HR Approval,MDApproval,Rejected,Canceled,Approved,On leave,Resumed,Posted;
                                                   Editable=Yes }
    { 15  ;   ;Applicant Comments  ;Text250        }
    { 17  ;   ;No series           ;Code30         }
    { 18  ;   ;Gender              ;Option        ;OptionCaptionML=ENU=" ,Male,Female";
                                                   OptionString=[ ,Male,Female];
                                                   Editable=No }
    { 28  ;   ;Selected            ;Boolean        }
    { 31  ;   ;Current Balance     ;Decimal        }
    { 36  ;   ;Department Code     ;Code60        ;OnValidate=BEGIN
                                                                {IF SalCard.GET("No.") THEN BEGIN
                                                                SalCard.Department:="Department Code";
                                                                SalCard.MODIFY;
                                                                END;
                                                                }
                                                              END;
                                                               }
    { 3900;   ;End Date            ;Date           }
    { 3901;   ;Total Taken         ;Decimal       ;DecimalPlaces=2:2 }
    { 3921;   ;E-mail Address      ;Text60        ;ExtendedDatatype=E-Mail;
                                                   Editable=No }
    { 3924;   ;Entry No            ;Integer        }
    { 3929;   ;Start Date Filter   ;Date          ;FieldClass=FlowFilter }
    { 3936;   ;Cell Phone Number   ;Text50        ;ExtendedDatatype=Phone No. }
    { 3937;   ;Request Leave Allowance;Boolean    ;OnValidate=BEGIN
                                                                HREmp.RESET;
                                                                HREmp.SETRANGE(HREmp."No.","Employee No");
                                                                IF HREmp.FIND('-') THEN BEGIN
                                                                  IF HREmp."Leave Allowance Claimed"=TRUE THEN
                                                                    ERROR('Leave Allowance has been claimed');
                                                                  Allowance:=HREmp."Leave Allowance Amount";
                                                                  IF "Request Leave Allowance"=TRUE THEN BEGIN
                                                                  "Leave Allowance Amount":=Allowance;

                                                                END
                                                                ELSE BEGIN
                                                                  "Leave Allowance Amount":=0;


                                                                END;
                                                                  //HREmp."Leave Allowance Claimed":=TRUE;
                                                                  //HREmp.MODIFY;

                                                                END;
                                                              END;
                                                               }
    { 3939;   ;Picture             ;BLOB           }
    { 3940;   ;Names               ;Text100        }
    { 3942;   ;Leave Allowance Entittlement;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Lookup("HR Employees"."Leave Allowance Amount" WHERE (No.=FIELD(Employee No))) }
    { 3943;   ;Leave Allowance Amount;Decimal      }
    { 3945;   ;Details of Examination;Text200      }
    { 3947;   ;Date of Exam        ;Date           }
    { 3949;   ;Reliever            ;Code50        ;TableRelation="User Setup"."User ID";
                                                   OnValidate=BEGIN
                                                                                    //DISPLAY RELEIVERS NAME
                                                                                    IF Reliever = "Employee No" THEN
                                                                                    ERROR('Employee cannot relieve him/herself');

                                                                                    IF HREmp.GET(Reliever) THEN
                                                                                    "Reliever Name":=HREmp.FullName;
                                                              END;
                                                               }
    { 3950;   ;Reliever Name       ;Text100        }
    { 3952;   ;Description         ;Text30         }
    { 3955;   ;Supervisor Email    ;Text50         }
    { 3956;   ;Number of Previous Attempts;Text200 }
    { 3958;   ;Job Tittle          ;Text50         }
    { 3959;   ;User ID             ;Code50         }
    { 3961;   ;Employee No         ;Code20        ;OnValidate=BEGIN
                                                                {HREmp.RESET;
                                                                HREmp.SETRANGE(HREmp."No.","Employee No");
                                                                IF HREmp.FIND('-') THEN BEGIN
                                                                "Employee Name":=HREmp."First Name"+ ' ' +HREmp."Middle Name"+ ' ' +HREmp."Last Name";
                                                                  MODIFY;
                                                                END
                                                                }
                                                              END;
                                                               }
    { 3962;   ;Supervisor          ;Code50        ;TableRelation="User Setup"."User ID" }
    { 3969;   ;Responsibility Center;Code20       ;TableRelation="Responsibility Center".Code }
    { 3970;   ;Approved days       ;Integer       ;OnValidate=BEGIN
                                                                 IF "Approved days">"Days Applied" THEN
                                                                 ERROR(TEXT001);
                                                              END;
                                                               }
    { 3971;   ;Attachments         ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Company Documents" WHERE (Doc No.=FIELD(Application Code)));
                                                   Editable=No }
    { 3972;   ;Emergency           ;Boolean       ;Description=This is used to ensure one can apply annual leave which is emergency }
    { 3973;   ;Approver Comments   ;Text200        }
    { 3974;   ;Available Days      ;Decimal       ;FieldClass=Normal }
    { 3975;   ;Reliever2           ;Code50        ;TableRelation="User Setup"."User ID";
                                                   OnValidate=BEGIN
                                                                                    //DISPLAY RELEIVERS NAME
                                                                                    IF Reliever2 = "Employee No" THEN
                                                                                    ERROR('Employee cannot relieve him/herself');

                                                                                    IF HREmp.GET(Reliever2) THEN
                                                                                    "Reliever Name2":=HREmp.FullName;
                                                              END;
                                                               }
    { 3976;   ;Reliever Name2      ;Text100       ;Editable=No }
    { 3977;   ;Date Of Exam 1      ;Date          ;OnValidate=BEGIN
                                                                  IF "Date Of Exam 1"<"Application Date"THEN
                                                                ERROR('You cannot Start your leave before the application date');


                                                                IF "Date Of Exam 1"="Date Of Exam 7"THEN
                                                                ERROR('Date already assigned');
                                                                IF "Date Of Exam 1"="Date Of Exam 3"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 1"="Date Of Exam 4"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 1"="Date Of Exam 5"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 1"="Date Of Exam 6"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 1"="Date Of Exam 2"THEN
                                                                ERROR('Date already assigned');
                                                              END;
                                                               }
    { 3978;   ;Date Of Exam 2      ;Date          ;OnValidate=BEGIN
                                                                  IF "Date Of Exam 2"<"Application Date"THEN
                                                                ERROR('You cannot Start your leave before the application date');

                                                                IF "Date Of Exam 2"="Date Of Exam 1"THEN
                                                                ERROR('Date already assigned');
                                                                IF "Date Of Exam 2"="Date Of Exam 3"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 2"="Date Of Exam 4"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 2"="Date Of Exam 5"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 2"="Date Of Exam 6"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 2"="Date Of Exam 7"THEN
                                                                ERROR('Date already assigned');
                                                              END;
                                                               }
    { 3979;   ;Date Of Exam 3      ;Date          ;OnValidate=BEGIN
                                                                  IF "Date Of Exam 3"<"Application Date"THEN
                                                                ERROR('You cannot Start your leave before the application date');

                                                                  IF "Date Of Exam 3"="Date Of Exam 1"THEN
                                                                ERROR('Date already assigned');
                                                                IF "Date Of Exam 3"="Date Of Exam 2"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 3"="Date Of Exam 4"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 3"="Date Of Exam 5"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 3"="Date Of Exam 6"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 3"="Date Of Exam 7"THEN
                                                                ERROR('Date already assigned');
                                                              END;
                                                               }
    { 3980;   ;Date Of Exam 4      ;Date          ;OnValidate=BEGIN
                                                                  IF "Date Of Exam 4"<"Application Date"THEN
                                                                ERROR('You cannot Start your leave before the application date');

                                                                IF "Date Of Exam 4"="Date Of Exam 1"THEN
                                                                ERROR('Date already assigned');
                                                                IF "Date Of Exam 4"="Date Of Exam 3"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 4"="Date Of Exam 2"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 4"="Date Of Exam 5"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 4"="Date Of Exam 6"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 4"="Date Of Exam 7"THEN
                                                                ERROR('Date already assigned');
                                                              END;
                                                               }
    { 3981;   ;Date Of Exam 5      ;Date          ;OnValidate=BEGIN
                                                                  IF "Date Of Exam 5"<"Application Date"THEN
                                                                ERROR('You cannot Start your leave before the application date');

                                                                IF "Date Of Exam 5"="Date Of Exam 1"THEN
                                                                ERROR('Date already assigned');
                                                                IF "Date Of Exam 5"="Date Of Exam 3"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 5"="Date Of Exam 4"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 5"="Date Of Exam 2"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 5"="Date Of Exam 6"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 5"="Date Of Exam 7"THEN
                                                                ERROR('Date already assigned');
                                                              END;
                                                               }
    { 3982;   ;Date Of Exam 6      ;Date          ;OnValidate=BEGIN
                                                                  IF "Date Of Exam 6"<"Application Date"THEN
                                                                ERROR('You cannot Start your leave before the application date');

                                                                IF "Date Of Exam 6"="Date Of Exam 1"THEN
                                                                ERROR('Date already assigned');
                                                                IF "Date Of Exam 6"="Date Of Exam 3"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 6"="Date Of Exam 4"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 6"="Date Of Exam 5"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 6"="Date Of Exam 2"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 6"="Date Of Exam 7"THEN
                                                                ERROR('Date already assigned');
                                                              END;
                                                               }
    { 3983;   ;Date Of Exam 7      ;Date          ;OnValidate=BEGIN
                                                                 IF "Date Of Exam 7"<"Application Date"THEN
                                                                ERROR('You cannot Start your leave before the application date');

                                                                IF "Date Of Exam 7"="Date Of Exam 1"THEN
                                                                ERROR('Date already assigned');
                                                                IF "Date Of Exam 7"="Date Of Exam 3"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 7"="Date Of Exam 4"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 7"="Date Of Exam 5"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 7"="Date Of Exam 6"THEN
                                                                ERROR('Date already assigned');

                                                                IF "Date Of Exam 7"="Date Of Exam 2"THEN
                                                                ERROR('Date already assigned');
                                                              END;
                                                               }
    { 3984;   ;Employee Name       ;Text150        }
    { 3985;   ;Address No.         ;Text80         }
    { 3986;   ;Rejection Remarks   ;Text100        }
    { 3987;   ;Balance             ;Decimal       ;OnValidate=BEGIN
                                                                IF "Leave Type"='ANNUAL' THEN BEGIN
                                                                Balance:="Available Days"-"Days Applied";
                                                                END;
                                                              END;

                                                   Editable=No }
    { 3988;   ;Leave Period        ;Code40         }
    { 3989;   ;Leave Balance       ;Decimal        }
    { 3990;   ;Posted              ;Boolean        }
    { 3991;   ;Reccommended Days   ;Integer        }
  }
  KEYS
  {
    {    ;Application Code                        ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      TEXT001@1000000001 : TextConst 'ENU=Days Approved cannot be more than applied days';
      Text002@1008 : TextConst 'ENU=You cannot apply for leave until your are over [%1] months old in the company';
      Text003@1009 : TextConst 'ENU=UserID [%1] does not exist in [%2]';
      Allowance@1000000032 : Decimal;
      HRSetup@1000000031 : Record 51516192;
      NoSeriesMgt@1000000030 : Codeunit 396;
      HREmp@1000000029 : Record 51516160;
      varDaysApplied@1000000028 : Integer;
      HRLeaveTypes@1000000027 : Record 51516193;
      BaseCalendarChange@1000000026 : Record 51516272;
      ReturnDateLoop@1000000025 : Boolean;
      mSubject@1000000024 : Text[250];
      ApplicantsEmail@1000000023 : Text[30];
      SMTP@1000000022 : Codeunit 400;
      LeaveGjline@1000000021 : Record 51516410;
      "LineNo."@1000000020 : Integer;
      ApprovalComments@1000000019 : Record 455;
      URL@1000000018 : Text[500];
      sDate@1000000017 : Record 2000000007;
      Customized@1000000016 : Record 51516224;
      HREmailParameters@1000000015 : Record 51516202;
      HRLeavePeriods@1000000014 : Record 51516198;
      HRJournalBatch@1000000013 : Record 51516196;
      HRLeaveEntries@1000000012 : Record 51516201;
      intEntryNo@1000000011 : Integer;
      Calendar@1000000010 : Record 2000000007;
      empMonths@1000000009 : Integer;
      HRLeaveApp@1000000008 : Record 51516191;
      mWeekDay@1000000007 : Integer;
      empGender@1000000006 : 'Female';
      mMinDays@1000000005 : Integer;
      dates@1000000004 : Record 2000000007;
      BaseCalendar@1000000003 : Record 7601;
      GeneralOptions@1000000002 : Record 51516192;
      LeaveTypes@1000000000 : Record 51516193;
      emp@1120054000 : Record 51516160;

    PROCEDURE DetermineIfIsNonWorking@1102760000(VAR bcDate@1102760000 : Date;VAR ltype@1001 : Record 51516193) ItsNonWorking : Boolean;
    VAR
      dates@1000 : Record 2000000007;
    BEGIN
      CLEAR(ItsNonWorking);
      GeneralOptions.FIND('-');
      //One off Hollidays like Good Friday
      BaseCalendar.RESET;
      BaseCalendar.SETFILTER(BaseCalendar."Base Calendar Code",GeneralOptions."Base Calendar");
      BaseCalendar.SETRANGE(BaseCalendar.Date,bcDate);
      IF BaseCalendar.FIND('-') THEN BEGIN
      IF BaseCalendar.Nonworking = TRUE THEN
      ItsNonWorking:=TRUE;
      END;

      // For Annual Holidays
      BaseCalendar.RESET;
      BaseCalendar.SETFILTER(BaseCalendar."Base Calendar Code",GeneralOptions."Base Calendar");
      BaseCalendar.SETRANGE(BaseCalendar."Recurring System",BaseCalendar."Recurring System"::"Annual Recurring");
      IF BaseCalendar.FIND('-') THEN BEGIN
      REPEAT
      IF ((DATE2DMY(bcDate,1)=BaseCalendar."Date Day") AND (DATE2DMY(bcDate,2)=BaseCalendar."Date Month")) THEN BEGIN
      IF BaseCalendar.Nonworking = TRUE THEN
      ItsNonWorking:=TRUE;
      END;
      UNTIL BaseCalendar.NEXT=0;
      END;

      IF ItsNonWorking=FALSE THEN BEGIN
      // Check if its a weekend
      dates.RESET;
      dates.SETRANGE(dates."Period Type",dates."Period Type"::Date);
      dates.SETRANGE(dates."Period Start",bcDate);
      IF dates.FIND('-') THEN BEGIN
      //if date is a sunday
      IF dates."Period Name"='Sunday' THEN BEGIN
      //check if Leave includes sunday
      IF ltype."Inclusive of Sunday"=FALSE THEN ItsNonWorking:=TRUE;
      END ELSE IF dates."Period Name"='Saturday' THEN BEGIN
      //check if Leave includes sato
       IF ltype."Inclusive of Saturday"=FALSE THEN ItsNonWorking:=TRUE;
      END;
      END;
      END;
    END;

    PROCEDURE DetermineIfIncludesNonWorking@1102760001(VAR fLeaveCode@1102760000 : Code[10]) : Boolean;
    BEGIN
      IF LeaveTypes.GET(fLeaveCode) THEN BEGIN
      IF LeaveTypes."Inclusive of Non Working Days" = TRUE THEN
      EXIT(TRUE);
      END;
    END;

    PROCEDURE DetermineLeaveReturnDate@1102760002(VAR fBeginDate@1102760000 : Date;VAR fDays@1102760001 : Decimal) fReturnDate : Date;
    VAR
      ltype@1000 : Record 51516193;
    BEGIN
      ltype.RESET;
      IF ltype.GET("Leave Type") THEN BEGIN
      END;
      varDaysApplied := fDays;
      fReturnDate := fBeginDate;
      REPEAT
        IF DetermineIfIncludesNonWorking("Leave Type") =FALSE THEN BEGIN
          fReturnDate := CALCDATE('1D', fReturnDate);
          IF DetermineIfIsNonWorking(fReturnDate,ltype) THEN BEGIN
           varDaysApplied := varDaysApplied + 1;
      END ELSE
            varDaysApplied := varDaysApplied;
          varDaysApplied := varDaysApplied + 1
        END
        ELSE BEGIN
          fReturnDate := CALCDATE('1D', fReturnDate);
          varDaysApplied := varDaysApplied -1;
        END;
      UNTIL varDaysApplied = 0;
      EXIT(fReturnDate);
    END;

    PROCEDURE DeterminethisLeaveEndDate@1102760025(VAR fDate@1102760000 : Date) fEndDate : Date;
    VAR
      ltype@1000 : Record 51516193;
    BEGIN
      IF ltype.GET("Leave Type") THEN BEGIN
      END;
      ReturnDateLoop := TRUE;
      fEndDate := fDate;
      IF fEndDate <> 0D THEN BEGIN
        fEndDate := CALCDATE('1D', fEndDate);
        WHILE (ReturnDateLoop) DO BEGIN
        IF DetermineIfIsNonWorking(fEndDate,ltype) THEN
          fEndDate := CALCDATE('-1D', fEndDate)
         ELSE
          ReturnDateLoop := FALSE;
        END
        END;
      EXIT(fEndDate);
    END;

    PROCEDURE CreateLeaveLedgerEntries@1102755000();
    BEGIN
      IF Status=Status::Posted THEN ERROR('Leave Already posted');
      TESTFIELD("Approved days");

      HRLeavePeriods.RESET;
      HRLeavePeriods.SETRANGE(HRLeavePeriods.Closed,FALSE);
      HRLeavePeriods.FINDFIRST;

      HRSetup.RESET;
      IF HRSetup.FIND('-') THEN BEGIN

      LeaveGjline.RESET;
      LeaveGjline.SETRANGE("Journal Template Name",HRSetup."Leave Template");
      LeaveGjline.SETRANGE("Journal Batch Name",HRSetup."Leave Batch");
      LeaveGjline.DELETEALL;
        //Dave
      HRSetup.TESTFIELD(HRSetup."Leave Template");
      HRSetup.TESTFIELD(HRSetup."Leave Batch");

      HREmp.GET("Employee No");
      HREmp.TESTFIELD(HREmp."E-Mail");

      //POPULATE JOURNAL LINES

      "LineNo.":=10000;
      LeaveGjline.INIT;
      LeaveGjline."Journal Template Name":=HRSetup."Leave Template";
      LeaveGjline."Journal Batch Name":=HRSetup."Leave Batch";
      LeaveGjline."Line No.":="LineNo.";
      LeaveGjline."Leave Period":=HRLeavePeriods.Name;
      LeaveGjline."Leave Application No.":="Application Code";
      LeaveGjline."Document No.":="Application Code";
      LeaveGjline."Staff No.":="Employee No";
      LeaveGjline.VALIDATE(LeaveGjline."Staff No.");
      LeaveGjline."Posting Date":=TODAY;
      LeaveGjline."Leave Entry Type":=LeaveGjline."Leave Entry Type"::Negative;
      LeaveGjline."Leave Approval Date":=TODAY;
      LeaveGjline.Description:='Leave Taken';
      LeaveGjline."Leave Type":="Leave Type";
      //------------------------------------------------------------
      //HRSetup.RESET;
      //HRSetup.FIND('-');
      HRSetup.TESTFIELD(HRSetup."Leave Posting Period[FROM]");
      HRSetup.TESTFIELD(HRSetup."Leave Posting Period[TO]");
      //------------------------------------------------------------
      LeaveGjline."Leave Period Start Date":=HRSetup."Leave Posting Period[FROM]";
      LeaveGjline."Leave Period End Date":=HRSetup."Leave Posting Period[TO]";
      LeaveGjline."No. of Days":="Approved days"*-1;
      IF LeaveGjline."No. of Days"<>0 THEN
      LeaveGjline.INSERT(TRUE);

      //Post Journal
      LeaveGjline.RESET;
      LeaveGjline.SETRANGE("Journal Template Name",HRSetup."Leave Template");
      LeaveGjline.SETRANGE("Journal Batch Name",HRSetup."Leave Batch");
      IF LeaveGjline.FIND('-') THEN BEGIN
      CODEUNIT.RUN(CODEUNIT::"HR Leave Jnl.-Post",LeaveGjline);
      END;


      {END ELSE BEGIN
      ERROR('You must specify no of days');
      END;
      END;}
      NotifyApplicant;
      END;
    END;

    PROCEDURE NotifyApplicant@1102755001();
    BEGIN
      HREmp.GET("Employee No");
      HREmp.TESTFIELD(HREmp."Company E-Mail");

      //GET E-MAIL PARAMETERS FOR GENERAL E-MAILS
      HREmailParameters.RESET;
      HREmailParameters.SETRANGE(HREmailParameters."Associate With",HREmailParameters."Associate With"::"Interview Invitations");
      IF HREmailParameters.FIND('-') THEN
      BEGIN


           HREmp.TESTFIELD(HREmp."E-Mail");
           SMTP.CreateMessage(HREmailParameters."Sender Name",HREmailParameters."Sender Address",HREmp."E-Mail",
           HREmailParameters.Subject,'Dear'+' '+ HREmp."First Name" +' '+
           HREmailParameters.Body+' '+"Application Code"+' '+ HREmailParameters."Body 2",TRUE);
           SMTP.Send();


      MESSAGE('Leave applicant has been notified successfully');
      END;
    END;

    LOCAL PROCEDURE GetApplicantSupervisor@2(EmpUserID@1001 : Code[50]) SupervisorID : Code[10];
    VAR
      UserSetup@1000 : Record 91;
      UserSetup2@1002 : Record 91;
      HREmp2@1003 : Record 51516160;
    BEGIN
      {SupervisorID:='';

      UserSetup.RESET;
      IF UserSetup.GET(EmpUserID) THEN
      BEGIN
          UserSetup.TESTFIELD(UserSetup."Approver ID");

          //Get supervisor e-mail
          UserSetup2.RESET;
          IF UserSetup2.GET(UserSetup."Approver ID") THEN
          BEGIN
              UserSetup2.TESTFIELD(UserSetup2."E-Mail");
              "Supervisor Email":=UserSetup2."E-Mail";
          END;

      END ELSE
      BEGIN
          ERROR(Text003,EmpUserID,UserSetup.TABLECAPTION);
      END;
        }
    END;

    PROCEDURE CalcEndDate@4(SDate@1102755002 : Date;LDays@1102755003 : Integer) LEndDate : Date;
    VAR
      EndLeave@1102755001 : Boolean;
      DayCount@1102755000 : Integer;
      ltype@1000 : Record 51516193;
    BEGIN
        ltype.RESET;
        IF ltype.GET("Leave Type") THEN BEGIN
        END;
         SDate:=SDate-1;
         EndLeave:=FALSE;
         WHILE EndLeave=FALSE DO BEGIN
         IF NOT DetermineIfIsNonWorking(SDate,ltype) THEN
         DayCount:=DayCount+1;
         SDate:=SDate+1;
         IF DayCount>LDays THEN
         EndLeave:=TRUE;
         END;
         LEndDate:=SDate-1;

      WHILE DetermineIfIsNonWorking(LEndDate,ltype)=TRUE DO
      BEGIN
      LEndDate:=LEndDate+1;
      END;
    END;

    PROCEDURE CalcReturnDate@1102755002(EndDate@1102755002 : Date) RDate : Date;
    VAR
      EndLeave@1102755001 : Boolean;
      DayCount@1102755000 : Integer;
      LEndDate@1102755003 : Date;
      ltype@1000 : Record 51516193;
    BEGIN
         IF ltype.GET("Leave Type") THEN BEGIN
         END;
        { EndLeave:=FALSE;
         EndDate:=EndDate+1;
         LEndDate:=EndDate;
         CLEAR(DayCount);
         WHILE EndLeave=FALSE DO BEGIN
         IF NOT DetermineIfIsNonWorking(EndDate,ltype) THEN BEGIN
         DayCount:=DayCount+1;
         EndDate:=EndDate+1;

         END ELSE BEGIN
         EndLeave:=TRUE;
         END;
         END;
           }
         RDate:=EndDate+1;
      WHILE DetermineIfIsNonWorking(RDate,ltype)=TRUE DO
      BEGIN
       RDate:= RDate+1;
      END;
    END;

    PROCEDURE GetDate@3(VAR Applied_Dayes@1000 : Integer;VAR Start_Date@1001 : Date);
    VAR
      DaysCount@1002 : Integer;
      NewDate@1003 : Date;
      Last_is_WotkingDay@1004 : Boolean;
    BEGIN
      {clear(DaysCount);
      clear(NewDate);
       NewDate:=Start_Date;
      repeat
      DaysCount:=DaysCount+1;
      Last_is_WotkingDay:=false;

      until (() AND ()) }
    END;

    PROCEDURE ItsHolliday@1(VAR Start_Date@1000 : Date) holliday : Boolean;
    VAR
      baseCal@1001 : Record 7601;
      days@1002 : Integer;
      Months@1003 : Integer;
      bool_Non_Working@1004 : Boolean;
    BEGIN
      CLEAR(days);
      CLEAR(Months);
      CLEAR(bool_Non_Working);
      days:=DATE2DMY(Start_Date,1);
      Months:=DATE2DMY(Start_Date,2);
      baseCal.RESET;
      baseCal.SETFILTER(baseCal."Recurring System",'=%1',baseCal."Recurring System"::"Annual Recurring");
      IF baseCal.FIND('-') THEN BEGIN
      REPEAT
       IF ((Months=DATE2DMY(baseCal.Date,1)) AND (days=DATE2DMY(baseCal.Date,1))) THEN bool_Non_Working:=TRUE;
      UNTIL ((((Months=DATE2DMY(baseCal.Date,1)) AND (days=DATE2DMY(baseCal.Date,1)))) OR (baseCal.NEXT=0))
      END;
    END;

    PROCEDURE ItsSunday@6(VAR Start_Date@1000 : Date;VAR LeaveType@1003 : Integer);
    VAR
      leave_types@1001 : Record 51516182;
      dates@1002 : Record 2000000007;
    BEGIN
    END;

    BEGIN
    END.
  }
}

