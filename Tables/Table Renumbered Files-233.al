OBJECT table 20374 CloudPesa Change Request
{
  OBJECT-PROPERTIES
  {
    Date=07/26/23;
    Time=12:08:58 PM;
    Modified=Yes;
    Version List=ChangeRequestV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN

               IF No = '' THEN BEGIN
                 SalesSetup.GET;
                 SalesSetup.TESTFIELD(SalesSetup."Change Request No");
                 NoSeriesMgt.InitSeries(SalesSetup."Change Request No",xRec."No. Series",0D,No,"No. Series");
               END;

               "Captured by":=USERID;
               "Capture Date":=TODAY;
             END;

    LookupPageID=Page51516842;
    DrillDownPageID=Page51516842;
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code30        ;OnValidate=BEGIN
                                                                IF No <> xRec.No THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."Change Request No");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   Editable=No }
    { 2   ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                "Account No":='';
                                                              END;

                                                   OptionCaptionML=ENU=" ,Mobile Change,Atm Change,Backoffice Change,Agile Change,Picture Change";
                                                   OptionString=[ ,Mobile Change,Atm Change,Backoffice Change,Agile Change,Picture Change] }
    { 3   ;   ;Account No          ;Code50        ;TableRelation=IF (Type=CONST(Backoffice Change)) "Members Register".No.
                                                                 ELSE IF (Type=CONST(Mobile Change)) Vendor.No.
                                                                 ELSE IF (Type=CONST(Atm Change)) Vendor.No.
                                                                 ELSE IF (Type=CONST(Agile Change)) Vendor.No.
                                                                 ELSE IF (Type=CONST(Picture Change)) "Members Register".No.;
                                                   OnValidate=BEGIN
                                                                IF  ((Type=Type::"Mobile Change") OR (Type=Type::"Atm Change") OR (Type=Type::"Agile Change")) THEN BEGIN
                                                                       vend.RESET;
                                                                       vend.SETRANGE(vend."No.","Account No");
                                                                      IF vend.FIND('-') THEN
                                                                         vend.CALCFIELDS(vend.Picture,vend.Signature);
                                                                         Name:=vend.Name;
                                                                         "Payroll Number":=vend."Staff No";
                                                                         Branch:=vend."Global Dimension 2 Code";
                                                                         Address:=vend.Address;
                                                                         Picture:=vend.Picture;
                                                                         "Date Of Birth":=vend."Date of Birth";

                                                                         "Mobile No":=vend."Phone No.";
                                                                         Email:=vend."E-Mail";
                                                                         "Mobile No":=vend."Mobile Phone No";
                                                                         "S-Mobile No":=vend. "MPESA Mobile No";
                                                                         //"ATM Collector Name":=vend."FD Maturity Instructions";
                                                                         "ID No":=vend."ID No.";
                                                                         "Personal No":=vend."Staff No";
                                                                         "Account Type":=vend."Account Type";
                                                                         City:=vend.City;
                                                                         Section:=vend.Section;
                                                                         "Card Expiry Date":=vend."Card Expiry Date";
                                                                         "Card No":=vend."Card No.";
                                                                         Gender:=vend.Gender;
                                                                         "ATM No.":=vend."ATM No.";
                                                                         "Card Valid From":=vend."Card Valid From";
                                                                         "Card Valid To":=vend."Card Valid To";
                                                                         "Marital Status":=vend."Marital Status";
                                                                         "Signing Instructions":=vend."Signing Instructions";
                                                                         "Reason for change":=vend."Reason For Blocking Account";
                                                                         "Agile Account Status":=vend.Status;
                                                                         "Agile Account Status(New)":=vend.Status;
                                                                         "Member No":=vend."BOSA Account No";
                                                                         Memb.RESET;
                                                                         Memb.SETRANGE(Memb."No.",vend."BOSA Account No");
                                                                         IF Memb.FIND('-') THEN BEGIN
                                                                          Memb.CALCFIELDS(Memb.Picture,Memb.Signature,Memb."Back Side ID",Memb."Front Side ID",Memb.Signature);
                                                                            "KRA Pin":=Memb.Pin;
                                                                            "Date Of Birth":=Memb."Date of Birth";
                                                                           workstation:=Memb.Station;
                                                                           Email:=Memb."E-Mail";
                                                                           Section:=Memb.Section;
                                                                           "Registration Date":=Memb."Registration Date";
                                                                           Designation:=Memb.Designation;
                                                                           "Designation new":=Memb.Designation;
                                                                           "Employer Code":=Memb."Employer Code";
                                                                           "Designation new":=Memb.Designation;
                                                                           "Employer Code":=Memb."Employer Code";
                                                                            "Insider Classification":=Memb."Insider Classification";
                                                                           "Application Date":=Memb."Registration Date";
                                                                            "Front Side ID":=Memb."Front Side ID";
                                                                         //"Back Side ID":=vend."Back Side ID";
                                                                         //  signinature:=vend.Signature;
                                                                                                  END



                                                                   END;


                                                                IF Type=Type::"Backoffice Change" THEN BEGIN
                                                                    Memb.RESET;
                                                                    Memb.SETRANGE(Memb."No.","Account No");
                                                                  IF Memb.FIND('-') THEN BEGIN
                                                                       Memb.CALCFIELDS(Memb.Picture,Memb.Signature,Memb."Back Side ID",Memb."Front Side ID",Memb.Signature);
                                                                       Name:=Memb.Name;
                                                                         Branch:=Memb."Global Dimension 2 Code";
                                                                         Address:=Memb.Address;
                                                                         "Mobile No":=Memb."Phone No.";
                                                                         "Payroll Number":=Memb."Payroll/Staff No";
                                                                         Email:=Memb."E-Mail";
                                                                         "Mobile No":=Memb."Phone No.";
                                                                         "Mobile No":=Memb."Mobile Phone No";
                                                                         "ID No":=Memb."ID No.";
                                                                         "Personal No":=Memb."Payroll/Staff No";
                                                                         City:=Memb.City;
                                                                         "Membership Status":=Memb."Membership Status";
                                                                         "Member Account Status(New)":=Memb."Membership Status";
                                                                         Section:=Memb.Section;
                                                                         "FOSA Account":=Memb."FOSA Account";
                                                                         workstation:=Memb.Station;
                                                                         Gender:=Memb.Gender;
                                                                         "Workstation New":=Memb.Station;
                                                                         "Application Date":=Memb."Registration Date";
                                                                         "Marital Status":=Memb."Marital Status";
                                                                         "Monthly Contributions":=Memb."Monthly Contribution";
                                                                         //"Signing Instructions":=Memb."Signing Instructions";
                                                                         //"Bank Account Branch Code":=Memb."Bank Code";
                                                                         //"Bank Account No":=Memb."Bank Account No.";
                                                                         Address:=Memb.Address;
                                                                         City:=Memb.City;
                                                                         "Member Account Status":=Memb.Status;
                                                                         "Member Account Status(New)":=Memb.Status;
                                                                         "Registration Date":=Memb."Registration Date";
                                                                         "Registration Date New":=Memb."Registration Date";
                                                                         "Pays Benevolent":=Memb."Pays Benevolent";
                                                                         "Pays Benevolent(New)":=Memb."Pays Benevolent";
                                                                         "Loan Defaulter":=Memb."Loan Defaulter";
                                                                         "Insider Classification":=Memb."Insider Classification";
                                                                         "Loan Defaulter(New)":=Memb."Loan Defaulter";
                                                                         "KRA Pin":=Memb.Pin;
                                                                         "Employer Code":=Memb."Employer Code";
                                                                         "Member No":=Memb."No.";
                                                                         Designation:=Memb.Designation;
                                                                         "Designation new":=Memb.Designation;
                                                                         "Date Of Birth":=Memb."Date of Birth";
                                                                         //workstation:=Memb."Village/Residence";
                                                                        "Front Side ID":=Memb."Front Side ID";
                                                                    END;

                                                                    END;



                                                                IF Type=Type::"Picture Change" THEN BEGIN
                                                                    Memb.RESET;
                                                                    Memb.SETRANGE(Memb."No.","Account No");
                                                                  IF Memb.FIND('-') THEN BEGIN
                                                                       Memb.CALCFIELDS(Memb.Picture,Memb.Signature,Memb."Back Side ID",Memb."Front Side ID",Memb.Signature);
                                                                         Picture:=Memb.Picture;
                                                                         "Front Side ID":=Memb."Front Side ID";
                                                                         "Back Side ID":=Memb."Back Side ID";
                                                                         signinature:=Memb.Signature;
                                                                    END;

                                                                    END;
                                                              END;
                                                               }
    { 4   ;   ;Mobile No           ;Code50         }
    { 5   ;   ;Name                ;Text40        ;OnValidate=BEGIN
                                                                Name:=UPPERCASE(Name);
                                                              END;
                                                               }
    { 6   ;   ;No. Series          ;Code30         }
    { 7   ;   ;Address             ;Code80         }
    { 8   ;   ;Branch              ;Code30         }
    { 9   ;   ;Picture             ;BLOB          ;SubType=Bitmap }
    { 10  ;   ;signinature         ;BLOB          ;SubType=Bitmap }
    { 11  ;   ;City                ;Code30         }
    { 12  ;   ;E-mail              ;Code30         }
    { 13  ;   ;Personal No         ;Code30         }
    { 14  ;   ;ID No               ;Code40         }
    { 15  ;   ;Marital Status      ;Option        ;OptionCaptionML=ENU=Married,Single;
                                                   OptionString=Married,Single }
    { 16  ;   ;Passport No.        ;Code30         }
    { 17  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected }
    { 18  ;   ;Account Type        ;Code30         }
    { 19  ;   ;Account Category    ;Code30         }
    { 20  ;   ;Email               ;Code40         }
    { 21  ;   ;Section             ;Code40         }
    { 22  ;   ;Card No             ;Code30         }
    { 23  ;   ;Home Address        ;Code30         }
    { 24  ;   ;Loaction            ;Code20         }
    { 25  ;   ;Sub-Location        ;Code30         }
    { 26  ;   ;District            ;Code30         }
    { 27  ;   ;Reason for change   ;Text140        }
    { 28  ;   ;Signing Instructions;Text40         }
    { 29  ;   ;S-Mobile No         ;Code15         }
    { 30  ;   ;ATM Approve         ;Code30         }
    { 31  ;   ;Card Expiry Date    ;Date           }
    { 32  ;   ;Card Valid From     ;Date           }
    { 33  ;   ;Card Valid To       ;Date           }
    { 34  ;   ;Date ATM Linked     ;Date           }
    { 35  ;   ;ATM No.             ;Code16         }
    { 36  ;   ;ATM Issued          ;Boolean        }
    { 37  ;   ;ATM Self Picked     ;Boolean        }
    { 38  ;   ;ATM Collector Name  ;Code30         }
    { 39  ;   ;ATM Collectors ID   ;Code20         }
    { 40  ;   ;Atm Collectors Moile;Code30         }
    { 41  ;   ;Member Type         ;Option        ;OptionCaptionML=ENU=" ,class A,class B";
                                                   OptionString=[ ,class A,class B] }
    { 42  ;   ;Monthly Contributions;Decimal       }
    { 43  ;   ;Captured by         ;Code50        ;Editable=No }
    { 44  ;   ;Capture Date        ;Date          ;Editable=No }
    { 46  ;   ;Approved by         ;Code50        ;Editable=No }
    { 47  ;   ;Approval Date       ;Date          ;Editable=No }
    { 48  ;   ;Changed             ;Boolean       ;Editable=No }
    { 49  ;   ;Responsibility Centers;Code20      ;TableRelation="Responsibility Center" }
    { 50  ;   ;Member Cell Group   ;Code30        ;TableRelation="Hexa Binary";
                                                   OnValidate=BEGIN
                                                                {IF MemberCell.GET("Member Cell Group") THEN BEGIN
                                                                 // "Member Cell Name":=MemberCell."Cell Group Name";
                                                                  END;}
                                                              END;
                                                               }
    { 51  ;   ;Member Cell Name    ;Code30         }
    { 52  ;   ;Group Account No    ;Code30         }
    { 53  ;   ;Group Account Name  ;Code30         }
    { 54  ;   ;Employer Code       ;Code20        ;TableRelation="Sacco Employers" }
    { 55  ;   ;Fixed Deposit Status;Option        ;OptionCaptionML=ENU=" ,Active,Matured,Closed,Not Matured";
                                                   OptionString=[ ,Active,Matured,Closed,Not Matured] }
    { 56  ;   ;Payroll Number      ;Code20         }
    { 57  ;   ;Gender              ;Option        ;OptionCaptionML=ENU=Male,Female;
                                                   OptionString=Male,Female }
    { 58  ;   ;Application Date(old);Date          }
    { 59  ;   ;Application Date    ;Date           }
    { 60  ;   ;Member Account Status;Option       ;OnValidate=BEGIN
                                                                //Advice:=TRUE;
                                                                //"Status Change Date" := TODAY;
                                                                //"Last Marking Date" := TODAY;
                                                                //MODIFY;
                                                                {
                                                                IF xRec.Status=xRec.Status::Deceased THEN
                                                                ERROR('Deceased status cannot be changed');

                                                                Vend2.RESET;
                                                                Vend2.SETRANGE(Vend2."Staff No","Payroll/Staff No");
                                                                Vend2.SETRANGE(Vend2."Account Type",'PRIME');
                                                                IF Vend2.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                IF Status = Status::Deceased THEN BEGIN
                                                                IF (Vend2."Account Type"<>'JUNIOR') THEN BEGIN
                                                                Vend2.Status:=Vend2.Status::"6";
                                                                Vend2.Blocked:=Vend2.Blocked::All;
                                                                Vend2.MODIFY;
                                                                END;
                                                                END;
                                                                UNTIL Vend2.NEXT = 0;
                                                                END;

                                                                //Charge Entrance fee on reinstament
                                                                IF Status=Status::"Re-instated" THEN BEGIN
                                                                GenSetUp.GET(0);
                                                                "Registration Fee":=GenSetUp."Registration Fee";
                                                                MODIFY;
                                                                END;

                                                                IF (Status<>Status::Active) OR (Status<>Status::Dormant) THEN
                                                                Blocked:=Blocked::All;
                                                                 }
                                                              END;

                                                   OptionCaptionML=ENU=Active,Non-Active,Blocked,Dormant,Re-instated,Deceased,Withdrawal,Retired,Termination,Resigned,Ex-Company,Casuals,Family Member,Defaulter;
                                                   OptionString=Active,Non-Active,Blocked,Dormant,Re-instated,Deceased,Withdrawal,Retired,Termination,Resigned,Ex-Company,Casuals,Family Member,Defaulter }
    { 61  ;   ;Member Account Status(New);Option  ;OnValidate=BEGIN
                                                                //Advice:=TRUE;
                                                                //"Status Change Date" := TODAY;
                                                                //"Last Marking Date" := TODAY;
                                                                //MODIFY;
                                                                {
                                                                IF xRec.Status=xRec.Status::Deceased THEN
                                                                ERROR('Deceased status cannot be changed');

                                                                Vend2.RESET;
                                                                Vend2.SETRANGE(Vend2."Staff No","Payroll/Staff No");
                                                                Vend2.SETRANGE(Vend2."Account Type",'PRIME');
                                                                IF Vend2.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                IF Status = Status::Deceased THEN BEGIN
                                                                IF (Vend2."Account Type"<>'JUNIOR') THEN BEGIN
                                                                Vend2.Status:=Vend2.Status::"6";
                                                                Vend2.Blocked:=Vend2.Blocked::All;
                                                                Vend2.MODIFY;
                                                                END;
                                                                END;
                                                                UNTIL Vend2.NEXT = 0;
                                                                END;

                                                                //Charge Entrance fee on reinstament
                                                                IF Status=Status::"Re-instated" THEN BEGIN
                                                                GenSetUp.GET(0);
                                                                "Registration Fee":=GenSetUp."Registration Fee";
                                                                MODIFY;
                                                                END;

                                                                IF (Status<>Status::Active) OR (Status<>Status::Dormant) THEN
                                                                Blocked:=Blocked::All;
                                                                 }
                                                              END;

                                                   OptionCaptionML=ENU=Active,Non-Active,Blocked,Dormant,Re-instated,Deceased,Withdrawal,Retired,Termination,Resigned,Ex-Company,Casuals,Family Member,Defaulter;
                                                   OptionString=Active,Non-Active,Blocked,Dormant,Re-instated,Deceased,Withdrawal,Retired,Termination,Resigned,Ex-Company,Casuals,Family Member,Defaulter }
    { 62  ;   ;Account Status      ;Code10        ;FieldClass=FlowFilter }
    { 63  ;   ;Agile Account Status;Option        ;OptionCaptionML=ENU=Active,Frozen,Closed,Archived,New,Dormant,Deceased;
                                                   OptionString=Active,Frozen,Closed,Archived,New,Dormant,Deceased }
    { 64  ;   ;Agile Account Status(New);Option   ;OptionCaptionML=ENU=Active,Frozen,Closed,Archived,New,Dormant,Deceased;
                                                   OptionString=Active,Frozen,Closed,Archived,New,Dormant,Deceased }
    { 65  ;   ;ATM No.(New)        ;Code16         }
    { 66  ;   ;Registration Date   ;Date           }
    { 67  ;   ;Registration Date New;Date          }
    { 68  ;   ;Front Side ID       ;BLOB          ;CaptionML=ENU=Front Side ID;
                                                   SubType=Bitmap }
    { 69  ;   ;Back Side ID        ;BLOB          ;CaptionML=ENU=Back Side ID;
                                                   SubType=Bitmap }
    { 71  ;   ;Updated By          ;Code60         }
    { 72  ;   ;Pays Benevolent     ;Boolean        }
    { 73  ;   ;Loan Defaulter      ;Boolean        }
    { 74  ;   ;Pays Benevolent(New);Boolean        }
    { 75  ;   ;Loan Defaulter(New) ;Boolean        }
    { 76  ;   ;KRA Pin             ;Code20         }
    { 77  ;   ;Member No           ;Code20        ;TableRelation="Members Register" }
    { 78  ;   ;Date Of Birth       ;Date           }
    { 79  ;   ;workstation         ;Text200        }
    { 80  ;   ;Workstation New     ;Text200        }
    { 81  ;   ;Designation         ;Text100        }
    { 82  ;   ;Designation new     ;Text100        }
    { 83  ;   ;Terms of Service    ;Option        ;OptionCaptionML=ENU=,Permanent,Temporary,Contract;
                                                   OptionString=,Permanent,Temporary,Contract }
    { 84  ;   ;Reason For Change Moble;Text150     }
    { 85  ;   ;Date Changed        ;Date           }
    { 86  ;   ;Insider Classification;Option      ;OptionCaptionML=ENU=Member,Delegate,Board Member,Staff;
                                                   OptionString=Member,Delegate,Board Member,Staff;
                                                   Editable=No }
    { 87  ;   ;Insider Classification(New);Option ;OptionCaptionML=ENU=Member,Delegate,Board Member,Staff;
                                                   OptionString=Member,Delegate,Board Member,Staff }
    { 88  ;   ;FOSA Account        ;Code40        ;Editable=No }
    { 89  ;   ;FOSA Account(New)   ;Code40        ;TableRelation=Vendor.No. WHERE (Account Type=CONST(ORDINARY),
                                                                                   BOSA Account No=FIELD(Account No)) }
    { 90  ;   ;Membership Status   ;Option        ;OptionCaptionML=ENU=Active,Re-instated,Awaiting Withdrawal,Closed;
                                                   OptionString=Active,Re-instated,Awaiting Withdrawal,Closed;
                                                   Editable=No }
    { 91  ;   ;Membership Status(New);Option      ;OptionCaptionML=ENU=Active,Re-instated,Awaiting Withdrawal,Closed;
                                                   OptionString=Active,Re-instated,Awaiting Withdrawal,Closed }
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
      SalesSetup@1000000000 : Record 51516258;
      NoSeriesMgt@1000000001 : Codeunit 396;
      vend@1000000002 : Record 23;
      Memb@1000000003 : Record 51516223;

    BEGIN
    END.
  }
}

