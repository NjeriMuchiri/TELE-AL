OBJECT table 50038 Jobs
{
  OBJECT-PROPERTIES
  {
    Date=01/31/19;
    Time=[ 4:39:15 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 JobSetup.GET;
                 JobSetup.TESTFIELD("Concept Nos");
                 NoSeriesMgt.InitSeries(JobSetup."Concept Nos",xRec."No. Series",0D,"No.","No. Series");
               END;

               IF GETFILTER("Bill-to Partner No.") <> '' THEN
                 IF GETRANGEMIN("Bill-to Partner No.") = GETRANGEMAX("Bill-to Partner No.") THEN
                   VALIDATE("Bill-to Partner No.",GETRANGEMIN("Bill-to Partner No."));

               DimMgt.UpdateDefaultDim(
                 DATABASE::Jobs,"No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");
               InitWIPFields;

               "Creation Date" := TODAY;
               "Last Date Modified" := "Creation Date";
               //Status:=Status::Proposal;
             END;

    OnModify=BEGIN
               "Last Date Modified" := TODAY;
             END;

    OnDelete=VAR
               CommentLine@1004 : Record 97;
               JobTask@1102755003 : Record 51516052;
             BEGIN
               {MoveEntries.MoveJobEntries(Rec);

               JobTask.SETCURRENTKEY("Grant No.");
               JobTask.SETRANGE("Grant No.","No.");
               JobTask.DELETEALL(TRUE);

               JobResPrice.SETRANGE("Job No.","No.");
               JobResPrice.DELETEALL;

               JobItemPrice.SETRANGE("Job No.","No.");
               JobItemPrice.DELETEALL;

               JobGLAccPrice.SETRANGE("Job No.","No.");
               JobGLAccPrice.DELETEALL;

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Job);
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;

               DimMgt.DeleteDefaultDim(DATABASE::Jobs,"No.");
               TESTFIELD("Approval Status","Approval Status"::Open);

               ProjectPartners.SETRANGE(ProjectPartners."Grant No","No.");
               ProjectPartners.DELETEALL;

               ProjectDonors.SETRANGE(ProjectDonors."Grant No","No.");
               ProjectDonors.DELETEALL;

               ProjPersonnel.SETRANGE(ProjPersonnel.Project,"No.");
               ProjPersonnel.DELETEALL;
               }
             END;

    OnRename=BEGIN
               "Last Date Modified" := TODAY;
               TESTFIELD("Approval Status","Approval Status"::Open);
             END;

    DataCaptionFields=No.,Description;
    CaptionML=ENU=Job;
    LookupPageID=Page53926;
    DrillDownPageID=Page53926;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  JobSetup.GET;
                                                                  NoSeriesMgt.TestManual(JobSetup."Job Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   AltSearchField=Search Description;
                                                   CaptionML=ENU=No. }
    { 2   ;   ;Search Description  ;Code250       ;CaptionML=ENU=Search Description }
    { 3   ;   ;Description         ;Text250       ;OnValidate=BEGIN
                                                                IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
                                                                  "Search Description" := Description;
                                                                TESTFIELD("Approval Status","Approval Status"::Open);
                                                              END;

                                                   CaptionML=ENU=Description }
    { 4   ;   ;Description 2       ;Text80        ;CaptionML=ENU=Description 2 }
    { 5   ;   ;Bill-to Partner No. ;Code20        ;TableRelation=Customer.No. WHERE (Account Type=FILTER(Donor));
                                                   OnValidate=BEGIN
                                                                IF ("Bill-to Partner No." = '') OR ("Bill-to Partner No." <> xRec."Bill-to Partner No.") THEN
                                                                  IF JobLedgEntryExist OR JobPlanningLineExist THEN
                                                                    ERROR(Text000,FIELDCAPTION("Bill-to Partner No."),TABLECAPTION);
                                                                //UpdateCust;
                                                              END;

                                                   CaptionML=ENU=Bill-to Customer No. }
    { 12  ;   ;Creation Date       ;Date          ;CaptionML=ENU=Creation Date;
                                                   Editable=No }
    { 13  ;   ;Starting Date       ;Date          ;OnValidate=BEGIN
                                                                //CheckDate;
                                                              END;

                                                   CaptionML=ENU=Starting Date }
    { 14  ;   ;Ending Date         ;Date          ;OnValidate=BEGIN
                                                                IF "Period of Performance"="Period of Performance"::"Open Ended" THEN ERROR('You cannot insert and end date if status is open ended');
                                                                //CheckDate;
                                                              END;

                                                   CaptionML=ENU=Ending Date }
    { 19  ;   ;Status              ;Option        ;OnValidate=VAR
                                                                JobPlanningLine@1000 : Record 51516054;
                                                              BEGIN
                                                                IF xRec.Status <> Status THEN BEGIN
                                                                  IF Status = Status::Project THEN
                                                                    VALIDATE(Complete,TRUE);
                                                                  IF xRec.Status = xRec.Status::Project THEN BEGIN
                                                                    IF DIALOG.CONFIRM(Text004) THEN
                                                                      VALIDATE(Complete,FALSE)
                                                                    ELSE BEGIN
                                                                      Status := xRec.Status;
                                                                    END;
                                                                  END;
                                                                  JobPlanningLine.SETCURRENTKEY("Grant No.");
                                                                  JobPlanningLine.SETRANGE("Grant No.","No.");
                                                                  JobPlanningLine.MODIFYALL(Status,Status);
                                                                  MODIFY;
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Status;
                                                   OptionCaptionML=ENU=Concept Formulation,Proposal,Contract,Project,Completed;
                                                   OptionString=Concept Formulation,Proposal,Contract,Project,Completed }
    { 20  ;   ;Person Responsible  ;Code20        ;TableRelation=Resource;
                                                   CaptionML=ENU=Person Responsible }
    { 21  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                                                                MODIFY;
                                                              END;

                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   CaptionClass='1,1,1' }
    { 22  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                                                                MODIFY;
                                                              END;

                                                   CaptionML=ENU=Global Dimension 2 Code;
                                                   CaptionClass='1,1,2' }
    { 23  ;   ;Job Posting Group   ;Code10        ;CaptionML=ENU=Kind of Program }
    { 24  ;   ;Blocked             ;Option        ;CaptionML=ENU=Blocked;
                                                   OptionCaptionML=ENU=" ,Posting,All";
                                                   OptionString=[ ,Posting,All] }
    { 29  ;   ;Last Date Modified  ;Date          ;CaptionML=ENU=Last Date Modified;
                                                   Editable=No }
    { 30  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Comment Line" WHERE (Table Name=CONST(16), No.=FIELD(No.)));
                                                   CaptionML=ENU=Comment;
                                                   Editable=No }
    { 31  ;   ;Customer Disc. Group;Code10        ;TableRelation="Customer Discount Group";
                                                   CaptionML=ENU=Customer Disc. Group }
    { 32  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   CaptionML=ENU=Customer Price Group }
    { 41  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=ENU=Language Code }
    { 49  ;   ;Scheduled Res. Qty. ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job-Planning Line"."Quantity (Base)" WHERE (Grant No.=FIELD(No.), Schedule Line=CONST(Yes), Type=CONST(Resource), No.=FIELD(Resource Filter), Planning Date=FIELD(Planning Date Filter)));
                                                   CaptionML=ENU=Scheduled Res. Qty.;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 50  ;   ;Resource Filter     ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=Resource;
                                                   CaptionML=ENU=Resource Filter }
    { 51  ;   ;Posting Date Filter ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=ENU=Posting Date Filter }
    { 55  ;   ;Resource Gr. Filter ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Resource Group";
                                                   CaptionML=ENU=Resource Gr. Filter }
    { 56  ;   ;Scheduled Res. Gr. Qty.;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job-Planning Line"."Quantity (Base)" WHERE (Grant No.=FIELD(No.), Schedule Line=CONST(Yes), Type=CONST(Resource), Resource Group No.=FIELD(Resource Gr. Filter), Planning Date=FIELD(Planning Date Filter)));
                                                   CaptionML=ENU=Scheduled Res. Gr. Qty.;
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 57  ;   ;Picture             ;BLOB          ;CaptionML=ENU=Picture;
                                                   SubType=Bitmap }
    { 58  ;   ;Bill-to Name        ;Text100       ;CaptionML=ENU=Bill-to Name }
    { 59  ;   ;Bill-to Address     ;Text50        ;CaptionML=ENU=" Address" }
    { 60  ;   ;Bill-to Address 2   ;Text50        ;ExtendedDatatype=E-Mail;
                                                   CaptionML=ENU=Email Address }
    { 61  ;   ;Bill-to City        ;Text50        ;CaptionML=ENU=Bill-to City }
    { 63  ;   ;County              ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.County WHERE (No.=FIELD(Bill-to Partner No.)));
                                                   CaptionML=ENU=County;
                                                   Editable=No }
    { 64  ;   ;Bill-to Post Code   ;Code20        ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=ENU=Bill-to Post Code }
    { 66  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 67  ;   ;Bill-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=ENU=Bill-to Country/Region Code;
                                                   Editable=Yes }
    { 68  ;   ;Bill-to Name 2      ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer."Name 2" WHERE (No.=FIELD(Bill-to Partner No.)));
                                                   CaptionML=ENU=Bill-to Name 2;
                                                   Editable=No }
    { 1000;   ;Contractor          ;Option        ;CaptionML=ENU=Contractor;
                                                   OptionCaptionML=ENU=" ,Prime Contractor,Sub Contractor";
                                                   OptionString=[ ,Prime Contractor,Sub Contractor] }
    { 1001;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                IF "Currency Code" <> xRec."Currency Code" THEN
                                                                  IF NOT JobLedgEntryExist THEN
                                                                    CurrencyUpdatePlanningLines
                                                                  ELSE
                                                                    ERROR(Text000,FIELDCAPTION("Currency Code"),TABLECAPTION);

                                                                TESTFIELD("Approval Status","Approval Status"::Open);
                                                              END;

                                                   CaptionML=ENU=Currency Code }
    { 1002;   ;Bill-to Contact No. ;Code20        ;OnValidate=BEGIN
                                                                IF Blocked >= Blocked::Posting THEN
                                                                  ERROR(Text000,FIELDCAPTION("Bill-to Contact No."),TABLECAPTION);

                                                                IF ("Bill-to Contact No." <> xRec."Bill-to Contact No.") AND
                                                                   (xRec."Bill-to Contact No." <> '')
                                                                THEN BEGIN
                                                                  IF ("Bill-to Contact No." = '') AND ("Bill-to Partner No." = '') THEN BEGIN
                                                                    INIT;
                                                                    "No. Series" := xRec."No. Series";
                                                                    VALIDATE(Description,xRec.Description);
                                                                  END;
                                                                END;

                                                                IF ("Bill-to Partner No." <> '') AND ("Bill-to Contact No." <> '') THEN BEGIN
                                                                  Cont.GET("Bill-to Contact No.");
                                                                  ContBusinessRelation.RESET;
                                                                  ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                                                                  ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
                                                                  ContBusinessRelation.SETRANGE("No.","Bill-to Partner No.");
                                                                  IF ContBusinessRelation.FIND('-') THEN
                                                                    IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                                                                      ERROR(Text005,Cont."No.",Cont.Name,"Bill-to Partner No.");
                                                                END;
                                                                UpdateBillToCust("Bill-to Contact No.");
                                                              END;

                                                   OnLookup=BEGIN
                                                              IF ("Bill-to Partner No." <> '') AND Cont.GET("Bill-to Contact No.") THEN
                                                                Cont.SETRANGE("Company No.",Cont."Company No.")
                                                              ELSE
                                                                IF Cust.GET("Bill-to Partner No.") THEN BEGIN
                                                                  ContBusinessRelation.RESET;
                                                                  ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                                                                  ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
                                                                  ContBusinessRelation.SETRANGE("No.","Bill-to Partner No.");
                                                                  IF ContBusinessRelation.FIND('-') THEN
                                                                    Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.");
                                                                END ELSE
                                                                  Cont.SETFILTER("Company No.",'<>''''');

                                                              IF "Bill-to Contact No." <> '' THEN
                                                                IF Cont.GET("Bill-to Contact No.") THEN ;
                                                            END;

                                                   CaptionML=ENU=Bill-to Contact No. }
    { 1003;   ;Bill-to Contact     ;Text50        ;CaptionML=ENU=Bill-to Contact }
    { 1004;   ;Planning Date Filter;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=ENU=Planning Date Filter }
    { 1005;   ;Total WIP Cost Amount;Decimal      ;FieldClass=FlowField;
                                                   CaptionML=ENU=Total WIP Cost Amount;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1006;   ;Total WIP Cost G/L Amount;Decimal  ;FieldClass=FlowField;
                                                   CaptionML=ENU=Total WIP Cost G/L Amount;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1007;   ;WIP Posted To G/L   ;Boolean       ;CaptionML=ENU=WIP Posted To G/L;
                                                   Editable=No }
    { 1008;   ;WIP Posting Date    ;Date          ;CaptionML=ENU=WIP Posting Date;
                                                   Editable=No }
    { 1009;   ;WIP G/L Posting Date;Date          ;FieldClass=FlowField;
                                                   CaptionML=ENU=WIP G/L Posting Date;
                                                   Editable=No }
    { 1010;   ;Posted WIP Method Used;Option      ;CaptionML=ENU=Posted WIP Method Used;
                                                   OptionCaptionML=ENU=" ,Cost Value,Sales Value,Cost of Sales,Percentage of Completion,Completed Contract";
                                                   OptionString=[ ,Cost Value,Sales Value,Cost of Sales,Percentage of Completion,Completed Contract];
                                                   Editable=No }
    { 1011;   ;Invoice Currency Code;Code10       ;TableRelation=Currency;
                                                   CaptionML=ENU=Invoice Currency Code }
    { 1012;   ;Exch. Calculation (Cost);Option    ;CaptionML=ENU=Exch. Calculation (Cost);
                                                   OptionCaptionML=ENU=Fixed LCY,Fixed FCY;
                                                   OptionString=Fixed LCY,Fixed FCY }
    { 1013;   ;Exch. Calculation (Price);Option   ;CaptionML=ENU=Exch. Calculation (Price);
                                                   OptionCaptionML=ENU=Fixed FCY,Fixed LCY;
                                                   OptionString=Fixed FCY,Fixed LCY }
    { 1014;   ;Allow Schedule/Contract Lines;Boolean;
                                                   CaptionML=ENU=Allow Schedule/Contract Lines }
    { 1015;   ;Complete            ;Boolean       ;OnValidate=BEGIN
                                                                IF Complete <> xRec.Complete THEN
                                                                  ChangeJobCompletionStatus;
                                                              END;

                                                   CaptionML=ENU=Complete }
    { 1016;   ;Calc. WIP Method Used;Option       ;CaptionML=ENU=Calc. WIP Method Used;
                                                   OptionCaptionML=ENU=" ,Cost Value,Sales Value,Cost of Sales,Percentage of Completion,Completed Contract";
                                                   OptionString=[ ,Cost Value,Sales Value,Cost of Sales,Percentage of Completion,Completed Contract];
                                                   Editable=No }
    { 1017;   ;Amount Awarded      ;Decimal       ;FieldClass=Normal;
                                                   CaptionML=ENU=Amount Awarded;
                                                   Editable=Yes;
                                                   AutoFormatType=1 }
    { 1018;   ;Recog. Sales G/L Amount;Decimal    ;FieldClass=FlowField;
                                                   CaptionML=ENU=Recog. Sales G/L Amount;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1019;   ;Recog. Costs Amount ;Decimal       ;FieldClass=FlowField;
                                                   CaptionML=ENU=Recog. Costs Amount;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1020;   ;Recog. Costs G/L Amount;Decimal    ;FieldClass=FlowField;
                                                   CaptionML=ENU=Recog. Costs G/L Amount;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1021;   ;Total WIP Sales Amount;Decimal     ;FieldClass=FlowField;
                                                   CaptionML=ENU=Total WIP Sales Amount;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1022;   ;Total WIP Sales G/L Amount;Decimal ;FieldClass=FlowField;
                                                   CaptionML=ENU=Total WIP Sales G/L Amount;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1023;   ;Completion Calculated;Boolean      ;FieldClass=FlowField;
                                                   CaptionML=ENU=Completion Calculated }
    { 1024;   ;Next Invoice Date   ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Min("Job-Planning Line"."Planning Date" WHERE (Grant No.=FIELD(No.), Contract Line=FILTER(=Yes), Invoiced=FILTER(=No)));
                                                   CaptionML=ENU=Next Invoice Date }
    { 50000;  ;Grant Phases        ;Code10         }
    { 50001;  ;Approval Status     ;Option        ;OptionCaptionML=ENU=Open,Pending Approval,Approved;
                                                   OptionString=Open,Pending Approval,Approved;
                                                   Editable=Yes }
    { 50002;  ;Responsibility Center;Code10       ;TableRelation="Responsibility Center BR" }
    { 50003;  ;Total Cost          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job-Planning Line"."Total Cost" WHERE (Grant No.=FIELD(No.)));
                                                   Editable=No }
    { 50004;  ;Total Cost(LCY)     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job-Planning Line"."Total Cost (LCY)" WHERE (Grant No.=FIELD(No.)));
                                                   Editable=No }
    { 50005;  ;Contract Description;Text150        }
    { 50006;  ;Contract Type       ;Code10        ;TableRelation="Responsibility Center" }
    { 50007;  ;Disbursed Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Payment Line.".Amount WHERE (Shortcut Dimension 2 Code=FIELD(No.))) }
    { 50008;  ;Allow OverExpenditure;Boolean       }
    { 50009;  ;Accounted Amount    ;Decimal       ;FieldClass=FlowField;
                                                   Editable=No }
    { 50010;  ;Received Amount     ;Decimal       ;FieldClass=FlowField }
    { 50011;  ;Proposal No         ;Code20        ;TableRelation=Jobs.No. WHERE (No.=FIELD(Proposal No), Status=CONST(Proposal));
                                                   Editable=No }
    { 50012;  ;Converted To Proposal;Boolean      ;Editable=No }
    { 50013;  ;Project No          ;Code20        ;TableRelation=Jobs.No. WHERE (No.=FIELD(Project No), Status=CONST(Contract));
                                                   Editable=Yes }
    { 50014;  ;Converted To Project;Boolean       ;Editable=Yes }
    { 50015;  ;Concept Number      ;Code20         }
    { 50016;  ;Objective           ;Text150        }
    { 50017;  ;Contract No         ;Code20         }
    { 50018;  ;Reporting dates generated;Boolean  ;FieldClass=FlowField;
                                                   Editable=No }
    { 50019;  ;Condition for budget realloca;Code10 }
    { 50020;  ;Principal Investigator;Text100     ;TableRelation=Resource;
                                                   OnValidate=BEGIN
                                                                 objReso.RESET;
                                                                 objReso.SETRANGE(objReso."No.","Principal Investigator");
                                                                IF objReso.FIND('-') THEN BEGIN
                                                                 "Principal Investigator name":=objReso.Name;
                                                                 "Bill-to Address" :=objReso.Address;
                                                                 //"Bill-to Address 2":=objReso.Email;
                                                                 //Institution:=objReso.Institution;
                                                                END;
                                                              END;
                                                               }
    { 50021;  ;Expected Receipt Amount;Decimal    ;FieldClass=FlowField }
    { 50022;  ;Partners            ;Boolean       ;FieldClass=FlowField;
                                                   CaptionML=ENU=Collaborative Grants;
                                                   Editable=No }
    { 50023;  ;Project Location    ;Text70         }
    { 50024;  ;Income Account      ;Code10         }
    { 50025;  ;Concept Approval Date;DateTime     ;Editable=No }
    { 50026;  ;Project Filter      ;Code10        ;FieldClass=Normal }
    { 50027;  ;Title               ;Text30         }
    { 50028;  ;Project Coordinator ;Text100       ;TableRelation=Resource }
    { 50029;  ;Task                ;Option        ;OptionCaptionML=ENU=" ,Research,Service";
                                                   OptionString=[ ,Research,Service] }
    { 50030;  ;Project Status      ;Option        ;OptionCaptionML=ENU=Setup,In Progress,Halted,Completed;
                                                   OptionString=Setup,In Progress,Halted,Completed }
    { 50031;  ;Audit Indicator     ;Boolean        }
    { 50032;  ;Approved Funding Start Date;Date    }
    { 50033;  ;Approved Funding End Date;Date      }
    { 50034;  ;Justification Narration;Text200    ;Description=Narrations defined esp. when modifying  the project/contract info }
    { 50035;  ;Amount Invoiced     ;Decimal       ;FieldClass=FlowField }
    { 50036;  ;Grant Level         ;Option        ;OptionCaptionML=ENU=Grant,Sub-Grant;
                                                   OptionString=Grant,Sub-Grant }
    { 50037;  ;RSPO No.            ;Code30         }
    { 50038;  ;Alert sent          ;Boolean        }
    { 50039;  ;Proposal Application due Date;Date  }
    { 50040;  ;Submission          ;Option        ;OptionCaptionML=ENU=" ,Paper Submission,Electronic Submission";
                                                   OptionString=[ ,Paper Submission,Electronic Submission] }
    { 50041;  ;PI Name             ;Text100       ;OnValidate=BEGIN
                                                                {objPImaster.RESET;
                                                                objPImaster.SETRANGE(objPImaster."PI Code","PI Name");
                                                                IF objPImaster.FIND('-') THEN BEGIN
                                                                 "PI Address":=objPImaster."PI Address";
                                                                 "PI Telephone":=objPImaster."PI Telephone";
                                                                 "PI EMail":=objPImaster."PI EMail";
                                                                 MODIFY;
                                                                END;
                                                                }
                                                              END;

                                                   CaptionML=ENU=PI At Collaborative Institution }
    { 50042;  ;PI Address          ;Text30         }
    { 50043;  ;PI Telephone        ;Text30         }
    { 50044;  ;PI EMail            ;Text30        ;ExtendedDatatype=E-Mail }
    { 50045;  ;Collaborative Grant ;Boolean        }
    { 50046;  ;IREC Approval       ;Option        ;OptionCaptionML=ENU=Pending Approval,Approved,Exempt;
                                                   OptionString=Pending Approval,Approved,Exempt }
    { 50047;  ;IREC Approval Date  ;Date           }
    { 50048;  ;Cost Share          ;Boolean        }
    { 50049;  ;Cost Share Details  ;Text100        }
    { 50050;  ;Matching            ;Boolean        }
    { 50051;  ;Matching Details    ;Text150        }
    { 50052;  ;Application disposition Status;Option;
                                                   OptionCaptionML=ENU=" ,Signed By Institutions Authorities,Returned to PI,Forwarded to funding Agency";
                                                   OptionString=[ ,Signed By Institutions Authorities,Returned to PI,Forwarded to funding Agency] }
    { 50053;  ;SubAward No.        ;Code20        ;Description=Project Sub award }
    { 50054;  ;Payment Methods     ;Code20        ;TableRelation="Payment Method".Code }
    { 50055;  ;Schools             ;Code10        ;CaptionML=ENU=Kind of Program }
    { 50056;  ;Application Due Date;Date           }
    { 50057;  ;Funding Request     ;Boolean        }
    { 50058;  ;Budget              ;Boolean        }
    { 50059;  ;Budget Justification;Boolean        }
    { 50060;  ;Project Summary Abstract;Boolean    }
    { 50061;  ;RSPO Completion List;Boolean        }
    { 50062;  ;Donors              ;Boolean       ;FieldClass=FlowField }
    { 50063;  ;Workplan            ;Boolean       ;FieldClass=FlowField }
    { 50064;  ;Period of Performance;Option       ;OnValidate=BEGIN
                                                                IF "Period of Performance"="Period of Performance"::"Open Ended" THEN "Ending Date":=0D;
                                                              END;

                                                   OptionString=Multiple Years,One Year,Open Ended }
    { 50065;  ;Principal Investigator name;Text100 }
    { 50066;  ;Response To fund Opportunity;Boolean }
    { 50067;  ;Main Donor          ;Code50        ;TableRelation=Customer.No. WHERE (Account Type=FILTER(Donor)) }
    { 50068;  ;Main Sub            ;Code50        ;TableRelation=Vendor.No. WHERE (Field55580=FILTER(1)) }
    { 50069;  ;Special Contract Provision;Text250  }
    { 50070;  ;Funding Agency No.  ;Code20         }
    { 50071;  ;Type Of Funding     ;Option        ;OptionCaptionML=ENU=,Discretionary,Donations,Supplimental Funds,Others;
                                                   OptionString=,Discretionary,Donations,Supplimental Funds,Others }
    { 50072;  ;Responsible Officer ;Code50        ;TableRelation=Table55543.Field1 WHERE (Field53918=CONST(Yes)) }
    { 50073;  ;RFA/A Receipt Date  ;Date           }
    { 50074;  ;Project Team        ;Code20        ;TableRelation="Resource Group".No. }
    { 50075;  ;Institution         ;Option        ;OptionCaptionML=ENU=" ,MTRH,MU,OTHERS";
                                                   OptionString=[ ,MTRH,MU,OTHERS] }
    { 50076;  ;Moi/MTRH Collaborator;Boolean      ;CaptionML=ENU=Do you have a previous Collaboration with Moi/MTRH ? }
    { 50077;  ;AMPATH Affiliation Consortium;Boolean }
    { 50078;  ;Previous MU Consortium School?;Boolean }
    { 50079;  ;Which MU Consortium School;Text50   }
    { 50080;  ;ASANTE Collaborator?;Boolean        }
    { 50081;  ;ASANTE Collaborator Details;Text50  }
    { 50082;  ;Assist identifying Collabotor?;Boolean }
    { 50083;  ;Study Type          ;Option        ;OptionCaptionML=ENU=" ,Retrospective Cohort,Propective Cohort,Clinical trial,Others";
                                                   OptionString=[ ,Retrospective Cohort,Propective Cohort,Clinical trial,Others] }
    { 50084;  ;Study Type Details  ;Text50         }
    { 50085;  ;Brief Description of Study;Text20   }
    { 50086;  ;Study Funded        ;Boolean        }
    { 50087;  ;Funding Source/Funding Sought;Text50 }
    { 50088;  ;Application Deadline;Date           }
    { 50089;  ;Lab Services        ;Boolean       ;OnValidate=BEGIN
                                                                 {IF "Lab Services"=TRUE THEN BEGIN
                                                                   IF CONFIRM('Are you sure you want to update the Lab Request')=TRUE THEN BEGIN
                                                                     `objLabRequest.RESET;
                                                                     objLabRequest.SETRANGE(objLabRequest."Proposal No.","No.");
                                                                     IF objLabRequest.FIND('-') THEN EXIT
                                                                     ELSE BEGIN
                                                                      objLabRequest.INIT;
                                                                      objLabRequest."Proposal No.":="No.";
                                                                      objLabRequest.INSERT;
                                                                     END;
                                                                   END;
                                                                 END;
                                                                 }
                                                              END;
                                                               }
    { 50090;  ;AMPATH Data Mgt Core Required;Boolean }
    { 50091;  ;Contracted To       ;Text150       ;Description=Added:' for capturing details of subs in commas form  -came up during data import }
    { 50092;  ;Biostats Core Required;Boolean      }
    { 50093;  ;Prime Institution   ;Code50        ;Description=Added:' for capturing details prime institution -came up during data import }
    { 50094;  ;Workgroup Recomendation;Option     ;OptionCaptionML=ENU=" ,Do not support further Development,Support further Development,Support Study and feel no further input is needed";
                                                   OptionString=[ ,Do not support further Development,Support further Development,Support Study and feel no further input is needed] }
    { 50095;  ;Recomendation Description;Text50    }
    { 50096;  ;Approved Budget Start Date;Date     }
    { 50097;  ;Approved Budget End Date;Date       }
    { 50098;  ;Financial Reporting Due Date;DateFormula }
    { 50099;  ;Technical  Reporting Due Date;DateFormula }
    { 50100;  ;Obligated Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum(Committment.Amount WHERE (Shortcut Dimension 2 Code=FIELD(No.)));
                                                   Description=An alert to be provided when the grant expenditure is 95% of the project expenditure }
    { 50101;  ;Re:                 ;Text100        }
    { 50102;  ;System Contract No  ;Code20         }
    { 50103;  ;Converted To Contract;Boolean       }
    { 50104;  ;Indirect Cost       ;Boolean        }
    { 50105;  ;Allowed Indirect Cost;Decimal       }
    { 50106;  ;Consistence with inst. Objs.;Boolean }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Search Description                       }
    {    ;Bill-to Partner No.                      }
    {    ;Description                             ;KeyGroups=SearchCol }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=You cannot change %1 because one or more entries are associated with this %2.';
      JobSetup@1004 : Record 51516051;
      PostCode@1015 : Record 225;
      Job@1014 : Record 51516044;
      Cust@1006 : Record 18;
      Cont@1005 : Record 5050;
      ContBusinessRelation@1001 : Record 5054;
      NoSeriesMgt@1010 : Codeunit 396;
      DimMgt@1012 : Codeunit 408;
      Text003@1022 : TextConst 'ENU=You must run the %1 and %2 functions to create and post the completion entries for this job.';
      Text004@1017 : TextConst 'ENU=This will delete any unposted WIP entries for this job and allow you to reverse the completion postings for this job.\\Do you wish to continue?';
      Text005@1019 : TextConst 'ENU=Contact %1 %2 is related to a different company than customer %3.';
      Text006@1018 : TextConst 'ENU=Contact %1 %2 is not related to customer %3.';
      Text007@1009 : TextConst 'ENU=Contact %1 %2 is not related to a customer.';
      Text008@1002 : TextConst 'ENU=%1 %2 must not be blocked with type %3.';
      Text009@1008 : TextConst 'ENU=You must run the %1 function to reverse the completion entries that have already been posted for this job.';
      MoveEntries@1003 : Codeunit 361;
      Text010@1007 : TextConst 'ENU=Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
      Text011@1023 : TextConst 'ENU=%1 must be equal to or earlier than %2.';
      JobTask@1102755000 : Record 51516052;
      JobTasks@1102755001 : Record 51516052;
      JobPlanningLine@1102755002 : Record 51516054;
      JobPlanningLines@1102755003 : Record 51516054;
      LastEntryNo@1102755009 : Integer;
      JobEntryNo@1102755010 : Record 1015;
      ApprovalEntries@1102755008 : Record 454;
      ApprovalDate@1102755013 : DateTime;
      DimVal@1102755015 : Record 349;
      GLSetup@1102755014 : Record 98;
      ProjectCode@1102755016 : Code[10];
      objReso@1011 : Record 156;

    PROCEDURE AssistEdit@2(OldJob@1000 : Record 51516044) : Boolean;
    BEGIN
      WITH Job DO BEGIN
        Job := Rec;
        JobSetup.GET;
        JobSetup.TESTFIELD("Job Nos.");
        IF NoSeriesMgt.SelectSeries(JobSetup."Job Nos.",OldJob."No. Series","No. Series") THEN BEGIN
          JobSetup.GET;
          JobSetup.TESTFIELD(JobSetup."Job Nos.");
          NoSeriesMgt.SetSeries("No.");
          Rec := Job;
          EXIT(TRUE);
        END;
      END;
    END;

    PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::Jobs,"No.",FieldNumber,ShortcutDimCode);
      MODIFY;
    END;

    PROCEDURE UpdateBillToCont@27(CustomerNo@1000 : Code[20]);
    VAR
      ContBusRel@1003 : Record 5054;
      Cust@1001 : Record 18;
    BEGIN
      IF Cust.GET(CustomerNo) THEN BEGIN
        IF Cust."Primary Contact No." <> '' THEN
          "Bill-to Contact No." := Cust."Primary Contact No."
        ELSE BEGIN
          ContBusRel.RESET;
          ContBusRel.SETCURRENTKEY("Link to Table","No.");
          ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
          ContBusRel.SETRANGE("No.","Bill-to Partner No.");
          IF ContBusRel.FIND('-') THEN
            "Bill-to Contact No." := ContBusRel."Contact No.";
        END;
        "Bill-to Contact" := Cust.Contact;
      END;
    END;

    LOCAL PROCEDURE JobLedgEntryExist@5() : Boolean;
    VAR
      JobLedgEntry@1000 : Record 51516055;
    BEGIN
      CLEAR(JobLedgEntry);
      JobLedgEntry.SETCURRENTKEY("Job No.");
      JobLedgEntry.SETRANGE("Job No.","No.");
      EXIT(JobLedgEntry.FIND('-'));
    END;

    LOCAL PROCEDURE JobPlanningLineExist@3() : Boolean;
    VAR
      JobPlanningLine@1000 : Record 51516054;
    BEGIN
      JobPlanningLine.INIT;
      JobPlanningLine.SETRANGE("Grant No.","No.");
      EXIT(JobPlanningLine.FIND('-'));
    END;

    PROCEDURE UpdateBillToCust@26(ContactNo@1000 : Code[20]);
    VAR
      ContBusinessRelation@1005 : Record 5054;
      Cust@1004 : Record 18;
      Cont@1003 : Record 5050;
    BEGIN
      IF Cont.GET(ContactNo) THEN BEGIN
        "Bill-to Contact No." := Cont."No.";
        IF Cont.Type = Cont.Type::Person THEN
          "Bill-to Contact" := Cont.Name
        ELSE
          IF Cust.GET("Bill-to Partner No.") THEN
            "Bill-to Contact" := Cust.Contact
          ELSE
            "Bill-to Contact" := '';
      END ELSE BEGIN
        "Bill-to Contact" := '';
        EXIT;
      END;

      ContBusinessRelation.RESET;
      ContBusinessRelation.SETCURRENTKEY("Link to Table","Contact No.");
      ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
      ContBusinessRelation.SETRANGE("Contact No.",Cont."Company No.");
      IF ContBusinessRelation.FIND('-') THEN BEGIN
        IF "Bill-to Partner No." = '' THEN
          VALIDATE("Bill-to Partner No.",ContBusinessRelation."No.")
        ELSE
          IF "Bill-to Partner No." <> ContBusinessRelation."No." THEN
            ERROR(Text006,Cont."No.",Cont.Name,"Bill-to Partner No.");
      END ELSE
        ERROR(Text007,Cont."No.",Cont.Name);
    END;

    PROCEDURE UpdateCust@4();
    BEGIN
      IF "Bill-to Partner No." <> '' THEN BEGIN
        Cust.GET("Bill-to Partner No.");
        Cust.TESTFIELD("Customer Posting Group");
        Cust.TESTFIELD("Bill-to Customer No.",'');
        "Bill-to Name" := Cust.Name;
        "Bill-to Name 2" := Cust."Name 2";
        "Bill-to Address" := Cust.Address;
        "Bill-to Address 2" := Cust."Address 2";
        "Bill-to City" := Cust.City;
        "Bill-to Post Code" := Cust."Post Code";
        "Bill-to Country/Region Code" := Cust."Country/Region Code";
        "Currency Code" := Cust."Currency Code";
        "Customer Disc. Group" := Cust."Customer Disc. Group";
        "Customer Price Group" := Cust."Customer Price Group";
        "Language Code" := Cust."Language Code";
        County := Cust.County;
        UpdateBillToCont("Bill-to Partner No.");
      END ELSE BEGIN
        "Bill-to Name" := '';
        "Bill-to Name 2" := '';
        "Bill-to Address" := '';
        "Bill-to Address 2" := '';
        "Bill-to City" := '';
        "Bill-to Post Code" := '';
        "Bill-to Country/Region Code" := '';
        "Currency Code" := '';
        "Customer Disc. Group" := '';
        "Customer Price Group" := '';
        "Language Code" := '';
        County := '';
        VALIDATE("Bill-to Contact No.",'');
      END;
    END;

    PROCEDURE InitWIPFields@1();
    BEGIN
      "WIP Posted To G/L" := FALSE;
      "WIP Posting Date" := 0D;
      "WIP G/L Posting Date" := 0D;
      "Posted WIP Method Used" := 0;
    END;

    PROCEDURE TestBlocked@6();
    BEGIN
      IF Blocked = Blocked::" " THEN
        EXIT;
      ERROR(Text008,TABLECAPTION,"No.",Blocked);
    END;

    PROCEDURE CurrencyUpdatePlanningLines@10();
    VAR
      PlaningLine@1000 : Record 51516054;
    BEGIN
      {PlaningLine.SETRANGE("Grant No.","No.");
      IF PlaningLine.FIND('-') THEN
        REPEAT
          IF PlaningLine.Transferred THEN
            ERROR(Text000,FIELDCAPTION("Currency Code"),TABLECAPTION);
          PlaningLine.VALIDATE("Currency Code","Currency Code");
          PlaningLine.VALIDATE("Currency Date");
          PlaningLine.MODIFY;
        UNTIL PlaningLine.NEXT = 0;
        }
    END;

    PROCEDURE ChangeJobCompletionStatus@7();
    VAR
      AllObjwithCaption@1003 : Record 2000000058;
      JobCalcWIP@1001 : Codeunit 1000;
      ReportCaption1@1002 : Text[250];
      ReportCaption2@1004 : Text[250];
    BEGIN
      AllObjwithCaption.GET(AllObjwithCaption."Object Type"::Report,REPORT::"Job Calculate WIP");
      ReportCaption1 := AllObjwithCaption."Object Caption";
      AllObjwithCaption.GET(AllObjwithCaption."Object Type"::Report,REPORT::"Job Post WIP to G/L");
      ReportCaption2 := AllObjwithCaption."Object Caption";

      IF Complete = TRUE THEN
        MESSAGE(Text003,ReportCaption1,ReportCaption2)
      ELSE BEGIN
        JobCalcWIP.ReOpenJob("No.");
        "WIP Posting Date" := 0D;
        "Calc. WIP Method Used" := 0;
        MESSAGE(Text009,ReportCaption2);
      END;
    END;

    PROCEDURE DisplayMap@8();
    VAR
      MapPoint@1001 : Record 800;
      MapMgt@1000 : Codeunit 802;
    BEGIN
      IF MapPoint.FIND('-') THEN
        MapMgt.MakeSelection(DATABASE::Jobs,GETPOSITION)
      ELSE
        MESSAGE(Text010);
    END;

    PROCEDURE GetQuantityAvailable@9(ItemNo@1000 : Code[20];LocationCode@1001 : Code[10];VariantCode@1002 : Code[10];InEntryType@1004 : 'Usage,Sale,Both';Direction@1005 : 'Possitive,Negative,Both') QtyBase : Decimal;
    VAR
      JobLedgEntry@1003 : Record 51516055;
    BEGIN
      CLEAR(JobLedgEntry);
      WITH JobLedgEntry DO BEGIN
        SETCURRENTKEY("Job No.","Entry Type",Type,"No.");
        SETRANGE("Job No.",Rec."No.");
        IF NOT (InEntryType = InEntryType::Both) THEN
          SETRANGE("Entry Type",InEntryType);
        SETRANGE(Type,Type::Item);
        SETRANGE("No.",ItemNo);
        IF FINDSET THEN
          REPEAT
            IF ("Location Code" = LocationCode) AND
               ("Variant Code" = VariantCode) AND
               ((Direction = Direction::Both) OR
                ((Direction = Direction::Possitive) AND ("Quantity (Base)" > 0)) OR
                ((Direction = Direction::Negative) AND ("Quantity (Base)" < 0)))
            THEN
              QtyBase := QtyBase + "Quantity (Base)";
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckDate@30();
    BEGIN
      IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
        ERROR(Text011,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"));
    END;

    PROCEDURE ChangeProjectStatus@1102755001();
    BEGIN
      {//LastEntryNo:=JobPlanningLine.GETRANGEMAX(JobPlanningLine."Grant Contract Entry No.");
      ApprovalEntries.RESET;
      ApprovalEntries.SETRANGE(ApprovalEntries."Document Type",ApprovalEntries."Document Type"::None);
      ApprovalEntries.SETRANGE(ApprovalEntries."Document No.","No.");
      IF ApprovalEntries.FIND('+') THEN
      ApprovalDate:=ApprovalEntries."Last Date-Time Modified"
      ELSE
      ApprovalDate:=0DT;
      }
      //+++++++++++++++++++++++++++++++++++++++++++++++++++

      IF Status = Status::"Concept Formulation" THEN BEGIN
      IF CONFIRM('Convert concept to proposal?',TRUE)=FALSE THEN EXIT;
         IF "Approval Status"<>"Approval Status"::Approved THEN ERROR('Status must be approved to continue');
      //+++++++++++++++++++++++++++++++++++++++++++++++++++
       IF "Proposal No" ='' THEN
        BEGIN
          JobSetup.GET;
          JobSetup.TESTFIELD(JobSetup."Proposal Nos");
          NoSeriesMgt.InitSeries(JobSetup."Proposal Nos",xRec."No. Series",0D,"Proposal No","No. Series");
        END;
          //+++++++++++++++++++++++++++++++++++++++++++++++++++
          Job.INIT;
          Job."Concept Number":= "No.";
          Job."No.":="Proposal No";
          Job.Description:=Description;
          Job."Description 2":="Description 2";

          Job."Bill-to Partner No.":="Bill-to Partner No.";
          Job.VALIDATE("Bill-to Partner No.");
          Job.Status:=Job.Status::Proposal;
          Job."Approval Status":=Job."Approval Status"::Open;
          Job."Creation Date":=TODAY;
          Job."Person Responsible":="Person Responsible";
          Job."Starting Date":="Starting Date";
          Job."Ending Date":="Ending Date";
          Job."Bill-to Name":="Bill-to Name";
          Job."Bill-to Address":="Bill-to Address";
          Job."Bill-to Address 2":="Bill-to Address 2";
          Job."Bill-to City":="Bill-to City";
          Job."Bill-to Post Code":="Bill-to Post Code";

          Job."Last Date Modified":=TODAY;
          Job.Objective:=Objective;
          Job."Job Posting Group":="Job Posting Group";
          Job."Principal Investigator":="Principal Investigator";
          Job."Concept Approval Date":=ApprovalDate;
          Job.INSERT;

          "Converted To Proposal":=TRUE;
          "Proposal No":=Job."No.";
          //+++++++++++++++++++++++++++++++++++++++++++++++++

          //++++++++++++++++++Copy Project Personnel++++++++++++++
          {ProjPersonnel.RESET;
          ProjPersonnel.SETRANGE(ProjPersonnel.Project,"No.");
          IF ProjPersonnel.FIND('-') THEN
          REPEAT

          WITH ProjPersonnels DO BEGIN
          INIT;
          ProjPersonnels.Project:="Proposal No";
          ProjPersonnels."Employee No":=ProjPersonnel."Employee No";
          ProjPersonnels.VALIDATE(ProjPersonnels."Employee No");
          ProjPersonnels."Project Role":=ProjPersonnel."Project Role";
          ProjPersonnels."Start Date":=ProjPersonnel."Start Date";
          ProjPersonnels."End Date":=ProjPersonnel."End Date";
          ProjPersonnels."% Allocation Value":=ProjPersonnel."% Allocation Value";
          INSERT;
          END;
          UNTIL ProjPersonnel.NEXT=0;
          //++++++++++++++++++End Copy Project Personnel++++++++++++++
          //++++++++++++++++++Copy Partners++++++++++++++++++
          ProjectPartners.RESET;
          ProjectPartners.SETRANGE(ProjectPartners."Grant No","No.");
          IF ProjectPartners.FIND('-') THEN
          REPEAT
          WITH ProjectPartner DO BEGIN
          INIT;
          ProjectPartner."Grant No":="Proposal No";
          ProjectPartner.PartnerID:=ProjectPartners.PartnerID;
          ProjectPartner."Partner Name":=ProjectPartners."Partner Name";
          INSERT;
          END;
          UNTIL ProjectPartners.NEXT =0;

          //++++++++++++++++End Copy Partners++++++++++++++++

          //+++++++++++++++++Copy Donors+++++++++++++++++++++
          ProjectDonors.RESET;
          ProjectDonors.SETRANGE(ProjectDonors."Grant No","No.");
          IF ProjectDonors.FIND('-') THEN
          REPEAT
          WITH ProjectDonor DO BEGIN
          INIT;
          ProjectDonor."Grant No":="Proposal No";
          ProjectDonor."Shortcut Dimension 1 Code":=ProjectDonors."Shortcut Dimension 1 Code";
          ProjectDonor."Donor Name":=ProjectDonors."Donor Name";
          ProjectDonor."Expected Donation":=ProjectDonors."Expected Donation";
          INSERT;
          END;
          UNTIL ProjectDonors.NEXT=0;
          //+++++++++++++++++End Copy Donors++++++++++++++++++

          //++++++Copy Task Lines++++++++++++++++++++++++
          }
           JobTask.RESET;
           JobTask.SETRANGE(JobTask."Grant No.","No.");
           IF JobTask.FINDFIRST THEN
           BEGIN
                REPEAT
                   WITH JobTasks DO
                   BEGIN
                   INIT;
                   VALIDATE(JobTasks."Grant No.","Proposal No");
                   JobTasks."Grant Task No.":=JobTask."Grant Task No.";
                   JobTasks.Description:=JobTask.Description;
                   INSERT;
                   END
                UNTIL JobTask.NEXT=0;
           END;
          //++++++++End Copy Task Lines++++++++++++++++++

          //++++++++Copy Planning Lines++++++++++++++++++
          JobPlanningLine.RESET;
          JobPlanningLine.SETRANGE(JobPlanningLine."Grant No.","No.");
          IF JobPlanningLine.FINDFIRST THEN
          BEGIN
               REPEAT
                  WITH JobPlanningLines DO
                  BEGIN

                  INIT;
                  VALIDATE(JobPlanningLines."Grant No.","Proposal No");
                  JobPlanningLines."Grant Task No.":=JobPlanningLine."Grant Task No.";
                  JobPlanningLines."Line No.":=JobPlanningLine."Line No.";
                  JobPlanningLines.Type:=JobPlanningLines.Type;
                  JobPlanningLines."No.":=JobPlanningLine."No.";
                  JobPlanningLines.Quantity:=JobPlanningLine.Quantity;
                  JobPlanningLines.Partner:=JobPlanningLine.Partner;
                  JobPlanningLines."Global Dimension 1 Code":=JobPlanningLine."Global Dimension 1 Code";
                  JobPlanningLines."Unit Cost":=JobPlanningLine."Unit Cost";
                  JobPlanningLines.VALIDATE(JobPlanningLines."Unit Cost");
                  JobPlanningLines."Budget Period":=JobPlanningLine."Budget Period";
                  JobPlanningLines.Description:=JobPlanningLine.Description;
                  //JobPlanningLines."Grant Contract Entry No.":=JobEntryNo.getGetNextEntryNo;
                  INSERT;
                  END
               UNTIL JobPlanningLine.NEXT=0;
          END;
          //++++++++End Copy Planning Lines++++++++++++++

          MESSAGE('Concept No'+' '+ "No." +' '+ 'has successfully been converted to proposal No.'+' '+"Proposal No");
          MODIFY;
          END ELSE BEGIN IF Status = Status::Proposal THEN BEGIN
          IF CONFIRM('Convert Proposal to Contract?',TRUE)=FALSE THEN EXIT;
          //+++++++++++++++++++++++++++++++++++++++++++++++++++
          IF "System Contract No" ='' THEN
          BEGIN
          JobSetup.GET();
          JobSetup.TESTFIELD(JobSetup."System Contract Nos");
          NoSeriesMgt.InitSeries(JobSetup."System Contract Nos",xRec."No. Series",0D,"System Contract No","No. Series");
          END;
          //+++++++++++++++++++++++++++++++++++++++++++++++++++

          Job.INIT;
          Job."No.":="System Contract No";
          Job.Description:=Description;
          Job."Bill-to Partner No.":="Bill-to Partner No.";
          Job.VALIDATE("Bill-to Partner No.");
          Job.Status:=Job.Status::Contract;
          //insert project status
         // Job."Project Status":=Job."Project Status"::"In Progress";
          Job."Approval Status":=Job."Approval Status"::Open;
          Job."Creation Date":=TODAY;
          Job."Starting Date":="Starting Date";
          Job."Ending Date":="Ending Date";
          Job."Last Date Modified":=TODAY;
          Job.Objective:=Objective;
          Job."Principal Investigator":="Principal Investigator";
          Job."Job Posting Group":="Job Posting Group";
          Job.INSERT;

          "System Contract No":=Job."No.";
          "Converted To Contract":=TRUE;

          //++++++++++++++++++Copy Project Personnel++++++++++++++
          {ProjPersonnel.RESET;
          ProjPersonnel.SETRANGE(ProjPersonnel.Project,"No.");
          IF ProjPersonnel.FIND('-') THEN
          REPEAT

          WITH ProjPersonnels DO BEGIN
          INIT;
          ProjPersonnels.Project:="System Contract No";
          ProjPersonnels."Employee No":=ProjPersonnel."Employee No";
          ProjPersonnels.VALIDATE(ProjPersonnels."Employee No");
          ProjPersonnels."Project Role":=ProjPersonnel."Project Role";
          ProjPersonnels."Start Date":=ProjPersonnel."Start Date";
          ProjPersonnels."End Date":=ProjPersonnel."End Date";
          ProjPersonnels."% Allocation Value":=ProjPersonnel."% Allocation Value";
          INSERT;
          END;
          UNTIL ProjPersonnel.NEXT=0;
          //++++++++++++++++++End Copy Project Personnel++++++++++++++


          //++++++++++++++++++Copy Partners++++++++++++++++++
          ProjectPartners.RESET;
          ProjectPartners.SETRANGE(ProjectPartners."Grant No","No.");
          IF ProjectPartners.FIND('-') THEN
          REPEAT
          WITH ProjectPartner DO BEGIN
          INIT;
          ProjectPartner."Grant No":="System Contract No";
          ProjectPartner.PartnerID:=ProjectPartners.PartnerID;
          ProjectPartner."Partner Name":=ProjectPartners."Partner Name";
          INSERT;
          END;
          UNTIL ProjectPartners.NEXT =0;
          //++++++++++++++++End Copy Partners++++++++++++++++


          //+++++++++++++++++Copy Donors+++++++++++++++++++++
          ProjectDonors.RESET;
          ProjectDonors.SETRANGE(ProjectDonors."Grant No","No.");
          IF ProjectDonors.FIND('-') THEN
          REPEAT
          WITH ProjectDonor DO BEGIN
          INIT;
          ProjectDonor."Grant No":="System Contract No";
          ProjectDonor."Shortcut Dimension 1 Code":=ProjectDonors."Shortcut Dimension 1 Code";
          ProjectDonor."Donor Name":=ProjectDonors."Donor Name";
          ProjectDonor."Expected Donation":=ProjectDonors."Expected Donation";
          INSERT;
          END;
          UNTIL ProjectDonors.NEXT=0;
          //+++++++++++++++++End Copy Donors++++++++++++++++++


          //++++++Copy Task Lines++++++++++++++++++++++++
           }
           JobTask.RESET;
           JobTask.SETRANGE(JobTask."Grant No.","No.");
           IF JobTask.FINDFIRST THEN
           BEGIN
                REPEAT
                   WITH JobTasks DO
                   BEGIN
                   INIT;
                   VALIDATE(JobTasks."Grant No.","System Contract No");
                   JobTasks."Grant Task No.":=JobTask."Grant Task No.";
                   JobTasks.Description:=JobTask.Description;
                   INSERT;
                   END
                UNTIL JobTask.NEXT=0;
           END;
          //++++++++End Copy Task Lines++++++++++++++++++

                  //++++++++Copy Planning Lines++++++++++++++++++
                  JobPlanningLine.RESET;
                  JobPlanningLine.SETRANGE(JobPlanningLine."Grant No.","No.");
                  IF JobPlanningLine.FIND('-') THEN
                  BEGIN
                       REPEAT

                          WITH JobPlanningLines DO
                          BEGIN
                          INIT;
                          VALIDATE(JobPlanningLines."Grant No.","System Contract No");
                          JobPlanningLines."Grant Task No.":=JobPlanningLine."Grant Task No.";
                          JobPlanningLines."Line No.":=JobPlanningLine."Line No.";
                          JobPlanningLines.Type:=JobPlanningLines.Type;
                          JobPlanningLines."No.":=JobPlanningLine."No.";
                          JobPlanningLines.Partner:=JobPlanningLine.Partner;
                          JobPlanningLines."Global Dimension 1 Code":=JobPlanningLine."Global Dimension 1 Code";
                          JobPlanningLines.Quantity:=JobPlanningLine.Quantity;
                          JobPlanningLines."Unit Cost":=JobPlanningLine."Unit Cost";
                          JobPlanningLines.VALIDATE(JobPlanningLines."Unit Cost");
                          JobPlanningLines.Description:=JobPlanningLine.Description;
                          JobPlanningLines."Budget Period":=JobPlanningLine."Budget Period";
                          //JobPlanningLines."Grant Contract Entry No.":=JobEntryNo.GetNextEntryNo;
                          INSERT;
                          END
                       UNTIL JobPlanningLine.NEXT=0;
                  END;
                  //++++++++End Copy Planning Lines++++++++++++++

      MESSAGE('Proposal No'+' '+ "No." +' '+ 'has succesfully been converted to Contract No.'+' '+"System Contract No");
      MODIFY;
      END ELSE BEGIN IF Status = Status::Contract THEN BEGIN

      IF CONFIRM('Convert Contract to a project?',TRUE)=FALSE THEN EXIT;
      //+++++++++++++++++++++++++++++++++++++++++++++++++++
      IF "Project No" ='' THEN
      BEGIN
      JobSetup.GET();
      JobSetup.TESTFIELD(JobSetup."Job Nos.");
      NoSeriesMgt.InitSeries(JobSetup."Job Nos.",xRec."No. Series",0D,"Project No","No. Series");
      END;
      //+++++++++++++++++++++++++++++++++++++++++++++++++++

      Job.INIT;
      Job."No.":="Project No";
      Job.Description:=Description;
      Job."Bill-to Partner No.":="Bill-to Partner No.";
      Job.VALIDATE("Bill-to Partner No.");
      Job.Status:=Job.Status::Project;
      //insert project status
      Job."Project Status":=Job."Project Status"::"In Progress";
      Job."Approval Status":=Job."Approval Status"::Open;
      Job."Creation Date":=TODAY;
      Job."Starting Date":="Starting Date";
      Job."Ending Date":="Ending Date";
      Job."Last Date Modified":=TODAY;
      Job.Objective:=Objective;
      Job."Principal Investigator":="Principal Investigator";
      Job."Job Posting Group":="Job Posting Group";
      Job.INSERT;

      "Converted To Project":=TRUE;
      "Project No":="Project No";

      {Commented and taken to only create projects that are fully approved--
      //Insert grant in Dim No.
      GLSetup.GET;
      IF Job.GET(Job."No.") THEN
      BEGIN
          WITH DimVal DO BEGIN
          INIT;
          DimVal."Dimension Code":=GLSetup."Global Dimension 2 Code";
          DimVal.Code:=Job."No.";
          DimVal.Name:=Job.Description;
          DimVal."Global Dimension No.":=2;
          INSERT
          END;
      MESSAGE('Project ID'+' '+ProjectCode+' '+'successfully added to dimension values for global dimension'
      +' '+GLSetup."Global Dimension 2 Code");
      END;
       }
      //+++++++++++++++++++++++++++++++++++

      //++++++++++++++++++Copy Project Personnel++++++++++++++
      {ProjPersonnel.RESET;
      ProjPersonnel.SETRANGE(ProjPersonnel.Project,"No.");
      IF ProjPersonnel.FIND('-') THEN
      REPEAT

      WITH ProjPersonnels DO BEGIN
      INIT;
      ProjPersonnels.Project:="Project No";
      ProjPersonnels."Employee No":=ProjPersonnel."Employee No";
      ProjPersonnels.VALIDATE(ProjPersonnels."Employee No");
      ProjPersonnels."Project Role":=ProjPersonnel."Project Role";
      ProjPersonnels."Start Date":=ProjPersonnel."Start Date";
      ProjPersonnels."End Date":=ProjPersonnel."End Date";
      ProjPersonnels."% Allocation Value":=ProjPersonnel."% Allocation Value";
      INSERT;
      END;
      UNTIL ProjPersonnel.NEXT=0;
      //++++++++++++++++++End Copy Project Personnel++++++++++++++


      //++++++++++++++++++Copy Partners++++++++++++++++++
      ProjectPartners.RESET;
      ProjectPartners.SETRANGE(ProjectPartners."Grant No","No.");
      IF ProjectPartners.FIND('-') THEN
      REPEAT
      WITH ProjectPartner DO BEGIN
      INIT;
      ProjectPartner."Grant No":="Project No";
      ProjectPartner.PartnerID:=ProjectPartners.PartnerID;
      ProjectPartner."Partner Name":=ProjectPartners."Partner Name";
      INSERT;
      END;
      UNTIL ProjectPartners.NEXT =0;
      //++++++++++++++++End Copy Partners++++++++++++++++


      //+++++++++++++++++Copy Donors+++++++++++++++++++++
      ProjectDonors.RESET;
      ProjectDonors.SETRANGE(ProjectDonors."Grant No","No.");
      IF ProjectDonors.FIND('-') THEN
      REPEAT
      WITH ProjectDonor DO BEGIN
      INIT;
      ProjectDonor."Grant No":="Project No";
      ProjectDonor."Shortcut Dimension 1 Code":=ProjectDonors."Shortcut Dimension 1 Code";
      ProjectDonor."Donor Name":=ProjectDonors."Donor Name";
      ProjectDonor."Expected Donation":=ProjectDonors."Expected Donation";
      INSERT;
      END;
      UNTIL ProjectDonors.NEXT=0;
      //+++++++++++++++++End Copy Donors++++++++++++++++++


      //++++++Copy Task Lines++++++++++++++++++++++++
       }
       JobTask.RESET;
       JobTask.SETRANGE(JobTask."Grant No.","No.");
       IF JobTask.FINDFIRST THEN
       BEGIN
            REPEAT
               WITH JobTasks DO
               BEGIN
               INIT;
               VALIDATE(JobTasks."Grant No.","Project No");
               JobTasks."Grant Task No.":=JobTask."Grant Task No.";
               JobTasks.Description:=JobTask.Description;
               INSERT;
               END
            UNTIL JobTask.NEXT=0;
       END;
      //++++++++End Copy Task Lines++++++++++++++++++

              //++++++++Copy Planning Lines++++++++++++++++++
              JobPlanningLine.RESET;
              JobPlanningLine.SETRANGE(JobPlanningLine."Grant No.","No.");
              IF JobPlanningLine.FIND('-') THEN
              BEGIN
                   REPEAT

                      WITH JobPlanningLines DO
                      BEGIN
                      INIT;
                      VALIDATE(JobPlanningLines."Grant No.","Project No");
                      JobPlanningLines."Grant Task No.":=JobPlanningLine."Grant Task No.";
                      JobPlanningLines."Line No.":=JobPlanningLine."Line No.";
                      JobPlanningLines.Type:=JobPlanningLines.Type;
                      JobPlanningLines."No.":=JobPlanningLine."No.";
                      JobPlanningLines.Partner:=JobPlanningLine.Partner;
                      JobPlanningLines."Global Dimension 1 Code":=JobPlanningLine."Global Dimension 1 Code";
                      JobPlanningLines.Quantity:=JobPlanningLine.Quantity;
                      JobPlanningLines."Unit Cost":=JobPlanningLine."Unit Cost";
                      JobPlanningLines.VALIDATE(JobPlanningLines."Unit Cost");
                      JobPlanningLines.Description:=JobPlanningLine.Description;
                      JobPlanningLines."Budget Period":=JobPlanningLine."Budget Period";
                      //JobPlanningLines."Grant Contract Entry No.":=JobEntryNo.GetNextEntryNo;
                      INSERT;
                      END
                   UNTIL JobPlanningLine.NEXT=0;
              END;
              //++++++++End Copy Planning Lines++++++++++++++

      MESSAGE('Contract No'+' '+ "No." +' '+ 'has succesfully been converted to Project No.'+' '+"Project No");
      MODIFY;

      END
      END;

      END;
    END;

    PROCEDURE AddtoDimensionValues@1102755003(ProjectCode@1102755000 : Code[10]);
    VAR
      DimVal@1102755001 : Record 349;
      GLSetup@1102755002 : Record 98;
    BEGIN
      GLSetup.GET;
      //Job.RESET;
      //Job.SETRANGE(Job."No.",ProjectCode);
      IF Job.GET(ProjectCode) THEN
      BEGIN
          WITH DimVal DO BEGIN
          INIT;
          DimVal."Dimension Code":=GLSetup."Global Dimension 2 Code";
          DimVal.Code:=ProjectCode;
          DimVal.Name:=Job.Description;
          DimVal."Global Dimension No.":=2;
          INSERT
          END;
      MESSAGE('Project ID'+' '+ProjectCode+' '+'successfully added to dimension values for global dimension'
      +' '+GLSetup."Global Dimension 2 Code");
      END;
    END;

    PROCEDURE RecordLinkMove@11(job@1000 : Record 51516044;newJob@1001 : Record 51516044);
    BEGIN
    END;

    PROCEDURE CreateDim@1000000001(mJobs@1000000000 : Record 51516044);
    BEGIN
      //Insert grant in Dim No.
      GLSetup.GET;
          WITH DimVal DO BEGIN
          INIT;
          DimVal."Dimension Code":=GLSetup."Global Dimension 2 Code";
          DimVal.Code:=mJobs."No.";
          DimVal.Name:=mJobs."Description 2";
          DimVal."Global Dimension No.":=2;
          INSERT;
          MESSAGE('Project ID'+' '+mJobs."No."+' '+'successfully added to dimension values for global dimension'
      +' '+GLSetup."Global Dimension 2 Code");
      END;
    END;

    BEGIN
    END.
  }
}

