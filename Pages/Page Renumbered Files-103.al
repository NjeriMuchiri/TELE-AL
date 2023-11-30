OBJECT page 20444 HR Employee Card
{
  OBJECT-PROPERTIES
  {
    Date=02/02/23;
    Time=[ 3:23:08 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516160;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Report,Print,Functions,Employee,Attachments;
    OnOpenPage=BEGIN
                 IF "No."<>'' THEN
                   BEGIN
                     IF "Date Of Join"<>0D THEN
                       BEGIN
                       "Length Of Service":=Dates.DetermineAge("Date Of Join",TODAY);
                         MODIFY;
                       END;

                       IF ("Date Of Leaving the Company" = 0D) THEN BEGIN
                         IF  ("Date Of Birth" <> 0D) THEN
                         DAge:= Dates.DetermineAge("Date Of Birth",TODAY);
                         IF  ("Date Of Joining the Company" <> 0D) THEN
                         DService:= Dates.DetermineAge("Date Of Joining the Company",TODAY);
                         IF  ("Date Of Join" <> 0D) THEN
                         DPension:= Dates.DetermineAge("Pension Scheme Join Date",TODAY);
                         IF  ("Medical Scheme Join Date" <> 0D) THEN
                         DMedical:= Dates.DetermineAge("Medical Scheme Join Date",TODAY);
                         MODIFY;
                       END ELSE BEGIN
                         IF  ("Date Of Birth" <> 0D) THEN
                         DAge:= Dates.DetermineAge("Date Of Birth","Date Of Leaving the Company");
                         IF  ("Date Of Joining the Company" <> 0D) THEN
                         DService:= Dates.DetermineAge("Date Of Joining the Company","Date Of Leaving the Company");
                         IF  ("Pension Scheme Join Date" <> 0D) THEN
                         DPension:= Dates.DetermineAge("Pension Scheme Join Date","Date Of Leaving the Company");
                         IF  ("Medical Scheme Join Date" <> 0D) THEN
                         DMedical:= Dates.DetermineAge("Medical Scheme Join Date","Date Of Leaving the Company");
                         MODIFY;
                       END;
                   END;
               END;

    OnClosePage=BEGIN
                  { TESTFIELD("First Name");
                   TESTFIELD("Middle Name");
                   TESTFIELD("Last Name");
                   TESTFIELD("ID Number");
                   TESTFIELD("Cellular Phone Number");
                  }
                END;

    OnNextRecord=BEGIN
                   IF "Date Of Join"<>0D THEN
                     BEGIN
                     "Length Of Service":=Dates.DetermineAge("Date Of Join",TODAY);
                       MODIFY;
                     END;

                     IF ("Date Of Leaving the Company" = 0D) THEN BEGIN
                       IF  ("Date Of Birth" <> 0D) THEN
                       DAge:= Dates.DetermineAge("Date Of Birth",TODAY);
                       IF  ("Date Of Joining the Company" <> 0D) THEN
                       DService:= Dates.DetermineAge("Date Of Joining the Company",TODAY);
                       IF  ("Date Of Join" <> 0D) THEN
                       DPension:= Dates.DetermineAge("Pension Scheme Join Date",TODAY);
                       IF  ("Medical Scheme Join Date" <> 0D) THEN
                       DMedical:= Dates.DetermineAge("Medical Scheme Join Date",TODAY);
                       MODIFY;
                     END ELSE BEGIN
                       IF  ("Date Of Birth" <> 0D) THEN
                       DAge:= Dates.DetermineAge("Date Of Birth","Date Of Leaving the Company");
                       IF  ("Date Of Joining the Company" <> 0D) THEN
                       DService:= Dates.DetermineAge("Date Of Joining the Company","Date Of Leaving the Company");
                       IF  ("Pension Scheme Join Date" <> 0D) THEN
                       DPension:= Dates.DetermineAge("Pension Scheme Join Date","Date Of Leaving the Company");
                       IF  ("Medical Scheme Join Date" <> 0D) THEN
                       DMedical:= Dates.DetermineAge("Medical Scheme Join Date","Date Of Leaving the Company");
                       MODIFY;
                     END;
                 END;

    OnAfterGetRecord=BEGIN
                       {COMMIT;
                       IF "Date Of Join"<>0D THEN
                         BEGIN
                         "Length Of Service":=Dates.DetermineAge("Date Of Join",TODAY);
                           //MODIFY;
                         END;

                       DAge:='';
                       DService:='';
                       DPension:='';
                       DMedical:='';

                       //Recalculate Important Dates
                         IF ("Date Of Leaving the Company" = 0D) THEN BEGIN
                           IF  ("Date Of Birth" <> 0D) THEN
                           DAge:= Dates.DetermineAge("Date Of Birth",TODAY);
                           IF  ("Date Of Joining the Company" <> 0D) THEN
                           DService:= Dates.DetermineAge("Date Of Joining the Company",TODAY);
                           IF  ("Date Of Join" <> 0D) THEN
                           DPension:= Dates.DetermineAge("Pension Scheme Join Date",TODAY);
                           IF  ("Medical Scheme Join Date" <> 0D) THEN
                           DMedical:= Dates.DetermineAge("Medical Scheme Join Date",TODAY);
                           MODIFY;
                         END ELSE BEGIN
                           IF  ("Date Of Birth" <> 0D) THEN
                           DAge:= Dates.DetermineAge("Date Of Birth","Date Of Leaving the Company");
                           IF  ("Date Of Joining the Company" <> 0D) THEN
                           DService:= Dates.DetermineAge("Date Of Joining the Company","Date Of Leaving the Company");
                           IF  ("Pension Scheme Join Date" <> 0D) THEN
                           DPension:= Dates.DetermineAge("Pension Scheme Join Date","Date Of Leaving the Company");
                           IF  ("Medical Scheme Join Date" <> 0D) THEN
                           DMedical:= Dates.DetermineAge("Medical Scheme Join Date","Date Of Leaving the Company");
                           MODIFY;
                         END;}

                       //Recalculate Leave Days
                       VALIDATE("Allocated Leave Days");
                       SupervisorNames:=GetSupervisor("User ID");
                     END;

    OnQueryClosePage=BEGIN
                       //IF "First Name"='' THEN ERROR('Error First Name is not specified');
                       //IF "Last Name"='' THEN ERROR('Error Last Name is not specified');
                       //IF  THEN ERROR('Error General posting group is not specified');
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755101;1 ;ActionGroup;
                      CaptionML=ENU=&Print }
      { 1102755102;2 ;Action    ;
                      CaptionML=ENU=Personal Information File;
                      Promoted=Yes;
                      Visible=false;
                      Image=PrintReport;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 HREmp.RESET;
                                 HREmp.SETRANGE(HREmp."No.","No.");
                                 IF HREmp.FIND('-') THEN
                                 REPORT.RUN(55585,TRUE,TRUE,HREmp);
                               END;
                                }
      { 1102755199;2 ;Action    ;
                      CaptionML=ENU=Misc. Article Info;
                      Promoted=No;
                      Image=PrintReport;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 Misc.RESET;
                                 Misc.SETRANGE(Misc."Employee No.","No.");
                                 IF Misc.FIND('-') THEN
                                 REPORT.RUN(5202,TRUE,TRUE,Misc);
                               END;
                                }
      { 1102755200;2 ;Action    ;
                      CaptionML=ENU=Confidential Info;
                      Promoted=No;
                      Visible=false;
                      Image=PrintReport;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 Conf.RESET;
                                 Conf.SETRANGE(Conf."Employee No.","No.");
                                 IF Conf.FIND('-') THEN
                                 REPORT.RUN(5203,TRUE,TRUE,Conf);
                               END;
                                }
      { 1102755215;2 ;Action    ;
                      CaptionML=ENU=Label;
                      Promoted=No;
                      Visible=false;
                      Image=PrintReport;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 HREmp.RESET;
                                 HREmp.SETRANGE(HREmp."No.","No.");
                                 IF HREmp.FIND('-') THEN
                                 REPORT.RUN(5200,TRUE,TRUE,HREmp);
                               END;
                                }
      { 1102755216;2 ;Action    ;
                      CaptionML=ENU=Addresses;
                      Promoted=No;
                      Image=PrintReport;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 HREmp.RESET;
                                 HREmp.SETRANGE(HREmp."No.","No.");
                                 IF HREmp.FIND('-') THEN
                                 REPORT.RUN(5207,TRUE,TRUE,HREmp);
                               END;
                                }
      { 1102755217;2 ;Action    ;
                      CaptionML=ENU=Alt. Addresses;
                      Promoted=No;
                      Image=PrintReport;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 HREmp.RESET;
                                 HREmp.SETRANGE(HREmp."No.","No.");
                                 IF HREmp.FIND('-') THEN
                                 REPORT.RUN(5213,TRUE,TRUE,HREmp);
                               END;
                                }
      { 1102755218;2 ;Action    ;
                      CaptionML=ENU=Phone Nos;
                      Promoted=No;
                      Image=PrintReport;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 HREmp.RESET;
                                 HREmp.SETRANGE(HREmp."No.","No.");
                                 IF HREmp.FIND('-') THEN
                                 REPORT.RUN(5210,TRUE,TRUE,HREmp);
                               END;
                                }
      { 1102755077;1 ;ActionGroup;
                      CaptionML=ENU=&Employee }
      { 1102755179;2 ;Action    ;
                      CaptionML=ENU=KIn/Beneficiaries;
                      RunObject=page 20470;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Relatives;
                      PromotedCategory=Category6 }
      { 1102755188;2 ;Action    ;
                      CaptionML=ENU=Co&mments;
                      RunObject=Page 5222;
                      RunPageLink=Table Name=CONST(Employee),
                                  No.=FIELD(No.);
                      Promoted=No;
                      Image=ViewComments;
                      PromotedCategory=Category6 }
      { 1102755185;2 ;Action    ;
                      CaptionML=ENU=Qualifications;
                      RunObject=page 17355;
                      RunPageLink=Employee No.=FIELD(No.);
                      Promoted=Yes;
                      Image=QualificationOverview;
                      PromotedCategory=Category6 }
      { 1102755189;2 ;Action    ;
                      CaptionML=ENU=Employment History;
                      RunObject=page 20450;
                      RunPageLink=Employee No.=FIELD(No.);
                      Promoted=Yes;
                      Image=History;
                      PromotedCategory=Category6 }
      { 1102755190;2 ;Action    ;
                      CaptionML=ENU=Alternative Addresses;
                      RunObject=Page 5203;
                      RunPageLink=Employee No.=FIELD(No.);
                      Promoted=No;
                      Image=AlternativeAddress;
                      PromotedCategory=Category6 }
      { 1102755193;2 ;Action    ;
                      CaptionML=ENU=Misc. Articles;
                      RunObject=Page 5219;
                      RunPageLink=Employee No.=FIELD(No.);
                      Promoted=Yes;
                      Image=ExternalDocument;
                      PromotedCategory=Category6 }
      { 1102755194;2 ;Action    ;
                      CaptionML=ENU=Misc. Articles Overview;
                      RunObject=Page 5228;
                      Promoted=Yes;
                      Image=ViewSourceDocumentLine;
                      PromotedCategory=Category6 }
      { 1102755087;2 ;Action    ;
                      CaptionML=ENU=&Confidential Information;
                      RunObject=Page 5221;
                      RunPageLink=Employee No.=FIELD(No.);
                      Promoted=No;
                      Image=SNInfo;
                      PromotedCategory=Category6 }
      { 1102755095;2 ;Action    ;
                      CaptionML=ENU=Co&nfidential Info. Overview;
                      RunObject=Page 5229;
                      PromotedCategory=Category6 }
      { 1102755195;2 ;Action    ;
                      CaptionML=ENU=A&bsences;
                      RunObject=Page 5211;
                      RunPageLink=Employee No.=FIELD(No.);
                      Promoted=No;
                      Image=AbsenceCalendar;
                      PromotedCategory=Category6 }
      { 1102755198;2 ;Action    ;
                      CaptionML=ENU=Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5200),
                                  No.=FIELD(No.);
                      Promoted=No;
                      Image=Dimensions;
                      PromotedCategory=Category6 }
      { 1102755008;2 ;Action    ;
                      CaptionML=ENU=Education Sponsor;
                      RunObject=page 50065;
                      RunPageLink=Employee No.=FIELD(No.) }
      { 1102755010;2 ;Action    ;
                      CaptionML=ENU=Leave Family Employees List;
                      RunObject=page 20455;
                      RunPageLink=Employee No=FIELD(No.) }
      { 1102755012;2 ;Action    ;
                      CaptionML=ENU=Grievances;
                      RunObject=page 172139;
                      RunPageLink=Starting Date=FIELD(No.) }
      { 1000000005;2 ;Action    ;
                      CaptionML=ENU=Supervisees;
                      RunObject=Page 51516169 }
      { 1000000008;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 11      ;1   ;Action    ;
                      Name=Employee Attachements;
                      RunObject=page 17356;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Attach;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                CaptionML=ENU=General Details;
                GroupType=Group }

    { 1102755001;2;Field  ;
                AssistEdit=Yes;
                SourceExpr="No.";
                Importance=Promoted;
                OnAssistEdit=BEGIN
                                // IF AssistEdit() THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 5   ;2   ;Field     ;
                SourceExpr=Title }

    { 1102755003;2;Field  ;
                SourceExpr="First Name";
                Importance=Promoted }

    { 1102755005;2;Field  ;
                SourceExpr="Middle Name";
                Importance=Promoted }

    { 1102755007;2;Field  ;
                SourceExpr="Last Name";
                Importance=Promoted }

    { 1102755196;2;Field  ;
                SourceExpr="ID Number";
                Importance=Promoted }

    { 1102755013;2;Field  ;
                SourceExpr="Passport Number";
                Importance=Promoted }

    { 1102755015;2;Field  ;
                SourceExpr=Citizenship }

    { 1000000000;2;Field  ;
                CaptionML=ENU=Country / Region Code;
                SourceExpr="Citizenship Text";
                Editable=false }

    { 3   ;2   ;Field     ;
                SourceExpr="Global Dimension 1 Code" }

    { 1102755017;2;Field  ;
                SourceExpr="Global Dimension 2 Code" }

    { 1000000004;2;Field  ;
                CaptionML=ENU=Board Member;
                SourceExpr=IsBoard;
                Visible=false }

    { 9   ;2   ;Field     ;
                CaptionML=ENU=Board Chair;
                SourceExpr=IsBoardChair;
                Visible=false }

    { 10  ;2   ;Field     ;
                CaptionML=ENU=Committee Member;
                SourceExpr=IsCommette;
                Visible=false }

    { 8   ;2   ;Field     ;
                SourceExpr="Contract Type";
                Importance=Promoted }

    { 1102755153;2;Field  ;
                SourceExpr="Post Code" }

    { 1102755078;2;Field  ;
                SourceExpr="Postal Address" }

    { 1102755151;2;Field  ;
                SourceExpr=City }

    { 1102755155;2;Field  ;
                SourceExpr=County }

    { 1102755075;2;Field  ;
                SourceExpr=Picture }

    { 1102755014;2;Field  ;
                SourceExpr=Signature }

    { 1102755029;2;Field  ;
                SourceExpr="Last Date Modified" }

    { 1102755135;2;Field  ;
                SourceExpr="User ID";
                Importance=Promoted;
                OnValidate=BEGIN
                             SupervisorNames:=GetSupervisor("User ID");
                           END;
                            }

    { 1000000007;2;Field  ;
                SourceExpr="Fosa Account" }

    { 1102755021;2;Field  ;
                SourceExpr=Status;
                Importance=Promoted;
                Style=Strong;
                StyleExpr=TRUE }

    { 1120054000;2;Field  ;
                SourceExpr="Supervisor User ID" }

    { 1120054002;2;Field  ;
                SourceExpr="Supervisor Names" }

    { 1120054001;2;Field  ;
                SourceExpr=Department }

    { 1102755016;2;Field  ;
                CaptionML=ENU=Is Supervisor;
                SourceExpr=Supervisor }

    { 1902768601;1;Group  ;
                CaptionML=ENU=Communication Details;
                GroupType=Group }

    { 6   ;2   ;Field     ;
                ExtendedDatatype=Phone No.;
                SourceExpr="Cell Phone Number";
                Importance=Promoted }

    { 1102755083;2;Field  ;
                ExtendedDatatype=Phone No.;
                SourceExpr="Home Phone Number";
                Importance=Promoted }

    { 1102755084;2;Field  ;
                ExtendedDatatype=Phone No.;
                SourceExpr="Fax Number";
                Importance=Promoted }

    { 1102755085;2;Field  ;
                ExtendedDatatype=Phone No.;
                SourceExpr="Work Phone Number" }

    { 1102755086;2;Field  ;
                ExtendedDatatype=Phone No.;
                SourceExpr="Ext." }

    { 1102755089;2;Field  ;
                ExtendedDatatype=E-Mail;
                SourceExpr="E-Mail" }

    { 1102755090;2;Field  ;
                ExtendedDatatype=E-Mail;
                SourceExpr="Company E-Mail";
                Importance=Promoted }

    { 1901769001;1;Group  ;
                CaptionML=ENU=Personal Details }

    { 1102755057;2;Field  ;
                SourceExpr=Gender;
                Importance=Promoted }

    { 1102755045;2;Field  ;
                SourceExpr="Marital Status";
                Importance=Promoted }

    { 1102755035;2;Field  ;
                SourceExpr="First Language (R/W/S)";
                Importance=Promoted;
                Visible=false }

    { 1102755174;2;Field  ;
                SourceExpr="First Language Read";
                Visible=false }

    { 1102755176;2;Field  ;
                SourceExpr="First Language Write";
                Visible=false }

    { 1102755178;2;Field  ;
                SourceExpr="First Language Speak";
                Visible=false }

    { 1102755033;2;Field  ;
                SourceExpr="Second Language (R/W/S)";
                Importance=Promoted;
                Visible=false }

    { 1102755180;2;Field  ;
                SourceExpr="Second Language Read";
                Visible=false }

    { 1102755184;2;Field  ;
                SourceExpr="Second Language Speak";
                Visible=false }

    { 1102755182;2;Field  ;
                SourceExpr="Second Language Write";
                Visible=false }

    { 1102755031;2;Field  ;
                SourceExpr="Additional Language";
                Visible=false }

    { 1102755025;2;Field  ;
                SourceExpr="Vehicle Registration Number";
                Importance=Promoted }

    { 1102755071;2;Field  ;
                SourceExpr="Number Of Dependants" }

    { 1102755059;2;Field  ;
                SourceExpr=Disabled }

    { 1102755050;2;Field  ;
                SourceExpr="Health Assesment?" }

    { 1102755051;2;Field  ;
                SourceExpr="Medical Scheme No." }

    { 1102755052;2;Field  ;
                SourceExpr="Medical Scheme Head Member" }

    { 1102755053;2;Field  ;
                SourceExpr="Medical Scheme Name" }

    { 1102755054;2;Field  ;
                SourceExpr="Cause of Inactivity Code" }

    { 1102755056;2;Field  ;
                SourceExpr="Health Assesment Date" }

    { 1904937601;1;Group  ;
                CaptionML=ENU=Bank Details;
                Visible=false }

    { 1102755201;2;Field  ;
                SourceExpr="Main Bank";
                Importance=Promoted }

    { 7   ;2   ;Field     ;
                Name=<Bank Code>;
                CaptionML=ENU=Bank Code;
                SourceExpr="Bank Code" }

    { 1102755203;2;Field  ;
                SourceExpr="Branch Bank";
                Importance=Promoted }

    { 4   ;2   ;Field     ;
                Name=<Branch Code>;
                CaptionML=ENU=Branch Code;
                SourceExpr="Branch Code" }

    { 1102755205;2;Field  ;
                SourceExpr="Bank Account Number";
                Importance=Promoted }

    { 1900723601;1;Group  ;
                CaptionML=ENU=Important Dates }

    { 1102755062;2;Field  ;
                SourceExpr="Date Of Birth";
                Importance=Promoted;
                OnValidate=BEGIN
                             IF "Date Of Birth" >= TODAY THEN BEGIN
                               ERROR('Invalid Entry');
                             END;
                             DAge:= Dates.DetermineAge("Date Of Birth",TODAY);
                           END;
                            }

    { 1102755063;2;Field  ;
                CaptionML=ENU=Age;
                SourceExpr=DAge;
                Importance=Promoted;
                Enabled=false;
                Editable=false }

    { 1102755069;2;Field  ;
                SourceExpr="Date Of Join";
                Importance=Promoted;
                Visible=True;
                OnValidate=BEGIN
                                 DService:= Dates.DetermineAge("Date Of Join",TODAY);
                           END;
                            }

    { 12  ;2   ;Field     ;
                SourceExpr="Length Of Service";
                Editable=false }

    { 1102755081;2;Field  ;
                SourceExpr="End Of Probation Date" }

    { 1102755099;2;Field  ;
                SourceExpr="Pension Scheme Join Date";
                OnValidate=BEGIN
                             DPension:= Dates.DetermineAge("Pension Scheme Join Date",TODAY);
                           END;
                            }

    { 1102755107;2;Field  ;
                SourceExpr="Medical Scheme Join Date";
                OnValidate=BEGIN
                             DMedical:= Dates.DetermineAge("Medical Scheme Join Date",TODAY);
                           END;
                            }

    { 1102755118;2;Field  ;
                CaptionML=ENU=Time On Medical Aid Scheme;
                SourceExpr=DMedical;
                Enabled=false;
                Editable=FALSE }

    { 1102755125;2;Field  ;
                SourceExpr="Wedding Anniversary" }

    { 1901302901;1;Group  ;
                CaptionML=ENU=Job Details }

    { 1102755067;2;Field  ;
                SourceExpr="Job Specification";
                Importance=Promoted }

    { 1102755065;2;Field  ;
                SourceExpr="Job Title";
                Importance=Promoted }

    { 1102755123;2;Field  ;
                SourceExpr=Grade;
                Importance=Promoted }

    { 1906042301;1;Group  ;
                CaptionML=ENU=Terms of Service;
                Visible=false }

    { 1000000003;2;Field  ;
                CaptionML=ENU=Seondment;
                SourceExpr="Secondment Institution" }

    { 1102755110;2;Field  ;
                SourceExpr="Contract End Date";
                Importance=Promoted;
                Editable=TRUE }

    { 1102755111;2;Field  ;
                SourceExpr="Notice Period" }

    { 1102755112;2;Field  ;
                SourceExpr="Send Alert to" }

    { 1102755044;2;Field  ;
                SourceExpr="Terms Of Service";
                Importance=Promoted;
                Visible=false }

    { 1907488601;1;Group  ;
                CaptionML=ENU=Payment Information }

    { 1102755146;2;Field  ;
                SourceExpr="PIN No.";
                Importance=Promoted }

    { 1102755148;2;Field  ;
                SourceExpr="NSSF No.";
                Importance=Promoted }

    { 1102755169;2;Field  ;
                SourceExpr="NHIF No.";
                Importance=Promoted }

    { 1906602301;1;Group  ;
                CaptionML=ENU=Separation Details;
                GroupType=Group }

    { 1102755119;2;Field  ;
                SourceExpr="Date Of Leaving the Company";
                Importance=Promoted;
                OnLookup=BEGIN

                           {
                           FrmCalendar.SetDate("Date Of Leaving the Company");
                           FrmCalendar.RUNMODAL;
                           D := FrmCalendar.GetDate;
                           CLEAR(FrmCalendar);
                           IF D <> 0D THEN
                             "Date Of Leaving the Company":= D;
                           //DAge:= Dates.DetermineAge("Date Of Birth",TODAY);

                           }
                         END;
                          }

    { 1102755121;2;Field  ;
                SourceExpr="Termination Grounds";
                Importance=Promoted }

    { 1102755129;2;Field  ;
                SourceExpr="Exit Interview Date";
                Importance=Promoted }

    { 1102755132;2;Field  ;
                SourceExpr="Exit Interview Done by";
                Importance=Promoted }

    { 1903677101;1;Group  ;
                CaptionML=ENU=Leave Details/Medical Claims;
                GroupType=Group }

    { 1102755009;2;Field  ;
                SourceExpr="Reimbursed Leave Days";
                Importance=Promoted;
                Editable=FALSE }

    { 1102755126;2;Field  ;
                SourceExpr="Allocated Leave Days";
                Importance=Promoted;
                Editable=FALSE }

    { 1102755140;2;Field  ;
                SourceExpr="Total (Leave Days)";
                Importance=Promoted;
                Editable=FALSE }

    { 1102755160;2;Field  ;
                SourceExpr="Total Leave Taken";
                Importance=Promoted;
                Editable=false }

    { 1102755162;2;Field  ;
                SourceExpr="Leave Balance";
                Importance=Promoted;
                Enabled=FALSE }

    { 1102755223;2;Field  ;
                SourceExpr="Acrued Leave Days";
                Importance=Promoted;
                Editable=FALSE }

    { 1102755164;2;Field  ;
                SourceExpr="Cash per Leave Day";
                Importance=Promoted;
                Editable=FALSE }

    { 1102755166;2;Field  ;
                SourceExpr="Cash - Leave Earned";
                Importance=Promoted;
                Editable=FALSE }

    { 1102755213;2;Field  ;
                SourceExpr="Leave Status";
                Importance=Promoted }

    { 1102755221;2;Field  ;
                SourceExpr="Leave Type Filter";
                Importance=Promoted }

    { 1102755024;2;Field  ;
                SourceExpr="Leave Period Filter";
                Importance=Promoted }

    { 1000000002;2;Field  ;
                SourceExpr="Claim Limit" }

    { 1000000006;2;Field  ;
                SourceExpr="Claim Amount Used" }

    { 1000000009;2;Field  ;
                SourceExpr="Claim Remaining Amount" }

    { 1102755006;;Container;
                ContainerType=FactBoxArea }

    { 1102755004;1;Part   ;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page51516137;
                PartType=Page }

    { 1102755002;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

    { 1   ;1   ;Part      ;
                PartType=System;
                SystemPartID=RecordLinks }

  }
  CODE
  {
    VAR
      PictureExists@1102755000 : Boolean;
      Text001@1102755002 : TextConst 'ENU=Do you want to replace the existing picture of %1 %2?';
      Text002@1102755001 : TextConst 'ENU=Do you want to delete the picture of %1 %2?';
      Dates@1102755003 : Codeunit 51516100;
      DAge@1102755007 : Text[100];
      DService@1102755006 : Text[100];
      DPension@1102755005 : Text[100];
      DMedical@1102755004 : Text[100];
      D@1102755009 : Date;
      DoclLink@1102755010 : Record 51516207;
      Filter@1102755011 : Boolean;
      prEmployees@1102755014 : Record 51516160;
      prPayrollType@1102755013 : Record 51516282;
      Mail@1102755015 : Codeunit 397;
      HREmp@1102755017 : Record 51516160;
      SupervisorNames@1102755018 : Text[60];
      Misc@1102755012 : Record 5214;
      Conf@1102755016 : Record 5216;
      SMTP@1000000000 : Codeunit 400;
      CompInfo@1000000001 : Record 79;
      Body@1000000002 : Text[1024];
      Text003@1000000003 : TextConst 'ENU=Welcome to Lotus Capital Limited';
      Filename@1000000004 : Text;
      Recordlink@1000000005 : Record 2000000068;
      Text004a@1000000006 : TextConst 'ENU=It is a great pleasure to welcome you to Moi Teaching and Referral Hospital. You are now part of an organization that has its own culture and set of values. On your resumption and during your on-boarding process,  to help you to understand and adapt quickly and easily to the LOTUS CAPITAL culture and values, HR Unit shall provide you with various important documents that you are encouraged to read and understand.';
      Text004b@1000000007 : TextConst 'ENU=On behalf of the Managing Director, I congratulate you for your success in the interview process and I look forward to welcoming you on board LOTUS CAPITAL Limited.';
      Text004c@1000000008 : TextConst 'ENU=Adebola SAMSON-FATOKUN';
      Text004d@1000000009 : TextConst 'ENU=Strategy & Corporate Services';
      NL@1000000011 : Char;
      LF@1000000010 : Char;
      objpostingGroup@1000 : Record 51516283;
      objDimVal@1001 : Record 349;
      "Citizenship Text"@1002 : Text[200];
      RAge@1000000012 : Text[100];

    PROCEDURE GetSupervisor@1102755001(VAR sUserID@1102755000 : Code[50]) SupervisorName : Text[200];
    VAR
      UserSetup@1102755001 : Record 91;
    BEGIN
                              IF sUserID<>'' THEN
                              BEGIN
                                      UserSetup.RESET;
                                      IF UserSetup.GET(sUserID) THEN
                                      BEGIN

                                      SupervisorName:=UserSetup."Approver ID";
                                          IF SupervisorName<>'' THEN BEGIN

                                          HREmp.SETRANGE(HREmp."User ID",SupervisorName);
                                          IF HREmp.FIND('-') THEN
                                          SupervisorName:=HREmp.FullName;

                                          END ELSE BEGIN
                                          SupervisorName:='';
                                          END;


                                      END ELSE BEGIN
                                      //ERROR('User'+' '+ sUserID +' '+ 'does not exist in the user setup table');
                                      SupervisorName:='';
                                      END;
                                END;
    END;

    PROCEDURE GetSupervisorID@1000000000(VAR EmpUserID@1102755000 : Code[50]) SID : Text[200];
    VAR
      UserSetup@1102755001 : Record 91;
      SupervisorID@1000000000 : Code[20];
    BEGIN
                              IF EmpUserID<>'' THEN
                              BEGIN
                                   SupervisorID:='';

                                   UserSetup.RESET;
                                   IF UserSetup.GET(EmpUserID) THEN
                                   BEGIN
                                      SupervisorID:=UserSetup."Approver ID";
                                      IF SupervisorID <> '' THEN
                                      BEGIN
                                         SID:=SupervisorID;
                                      END ELSE
                                      BEGIN
                                         SID:='';
                                      END;
                                   END ELSE BEGIN
                                   ERROR('User'+' '+ EmpUserID +' '+ 'does not exist in the user setup table');
                                   END;
                                END;
    END;

    BEGIN
    END.
  }
}

