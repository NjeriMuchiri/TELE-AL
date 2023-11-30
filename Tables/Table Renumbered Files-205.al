OBJECT table 17325 ATM Card Applications
{
  OBJECT-PROPERTIES
  {
    Date=10/11/22;
    Time=12:02:45 PM;
    Modified=Yes;
    Version List=ATM;
  }
  PROPERTIES
  {
    OnInsert=BEGIN

                IF "No." = '' THEN BEGIN
                  SalesSetup.GET;
                  SalesSetup.TESTFIELD(SalesSetup."ATM Applications");
                  NoSeriesMgt.InitSeries(SalesSetup."ATM Applications",xRec."No. Series",0D,"No.","No. Series");
                END;



               "Card No":='42993479';
               "Application Date":=TODAY;
               "Time Captured":=TIME;
               "Captured By":=UPPERCASE(USERID);
               VALIDATE("Application Date");

               SkyPermissions.RESET;
               SkyPermissions.SETRANGE(SkyPermissions."User ID",USERID);
               SkyPermissions.SETRANGE(SkyPermissions."ATM Permisions",TRUE);
               IF NOT SkyPermissions.FINDFIRST THEN ERROR('You do not have permisions to view this page');


               ATMCardApplications.RESET;
               ATMCardApplications.SETRANGE(Status,ATMCardApplications.Status::Open);
               //ATMCardApplications.SETRANGE("Account No",'');
               IF ATMCardApplications.FINDFIRST THEN ERROR('Kindly Utilize an Open Card @ %1: ',ATMCardApplications."No.");
             END;

  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                 SalesSetup.GET;
                                                                 NoSeriesMgt.TestManual(SalesSetup."ATM Applications");
                                                                 "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Account No          ;Code30        ;TableRelation=Vendor.No.;
                                                   OnValidate=BEGIN
                                                                IF Vend.GET("Account No") THEN BEGIN

                                                                  "Card No":='';
                                                                "Replacement For Card No":='';
                                                                IF "Request Type"="Request Type"::Replacement THEN BEGIN
                                                                  IF Vend.GET("Account No") THEN BEGIN
                                                                    atnmcard.RESET;
                                                                    atnmcard.SETRANGE(atnmcard."Account No","Account No");
                                                                    IF atnmcard.FINDFIRST THEN BEGIN
                                                                      "Replacement For Card No":=atnmcard."Card No";
                                                                    END ELSE BEGIN
                                                                        ERROR('Card should exists');
                                                                END;
                                                                  END;
                                                                END;
                                                                IF "Request Type"="Request Type"::Renewal THEN BEGIN
                                                                  IF Vend.GET("Account No") THEN BEGIN
                                                                    atnmcard.RESET;
                                                                    atnmcard.SETRANGE(atnmcard."Account No","Account No");
                                                                    IF atnmcard.FINDFIRST THEN BEGIN
                                                                      "Replacement For Card No":=atnmcard."Card No";
                                                                      "Card No":=atnmcard."Card No";
                                                                    END ELSE BEGIN
                                                                        ERROR('Card should exists');
                                                                END;
                                                                  END;
                                                                END;

                                                                IF "Request Type"="Request Type"::New THEN BEGIN
                                                                  IF Vend.GET("Account No") THEN BEGIN
                                                                    atnmcard.RESET;
                                                                    atnmcard.SETRANGE(atnmcard."Account No","Account No");
                                                                   atnmcard.SETRANGE(atnmcard."Request Type",atnmcard."Request Type"::New);
                                                                   IF atnmcard.FINDFIRST THEN BEGIN
                                                                     ERROR('Card already exists');
                                                                  END;
                                                                END;
                                                                END;

                                                                //"Account Name":=PADSTR(Vend.Name,19);
                                                                "Account Name":=Vend.Name;
                                                                "Customer ID":=Vend."ID No.";
                                                                //"Branch Code":=Vend."Global Dimension 2 Code";
                                                                "Phone No.":=Vend."Mobile Phone No";
                                                                Address:=Vend.Address;
                                                                "Account Category":=Vend."Account Category";
                                                                "ID No":=Vend."ID No.";

                                                                "Terms Read and Understood":=TRUE;
                                                                Picture:=Vend.Picture;
                                                                Signature:=Vend.Signature;
                                                                IF Vend.Status<> Vend.Status::Active THEN
                                                                    ERROR('Account must be active');
                                                                  IF Vend."Account Type"<>'ORDINARY' THEN
                                                                  ERROR('Account must be ORDINARY Savings account');
                                                                  IF Vend."ID No."='' THEN
                                                                  ERROR('Account must have an ID NO.');
                                                                  IF Vend.Signature.HASVALUE=FALSE THEN
                                                                  ERROR('Account must have a signature');
                                                                   IF Vend.Picture.HASVALUE=FALSE THEN
                                                                  ERROR('Account must have a passport photo');

                                                                Members.RESET;
                                                                Members.GET(Vend."BOSA Account No");
                                                                "Member No." := Vend."BOSA Account No";
                                                                "Staff No" := Members."Payroll/Staff No";

                                                                //"ID Front":=Members."Front Side ID";
                                                                //"ID Back":=Members."Back Side ID";

                                                                //Members.CALCFIELDS(Members."Front Side ID",Members."Back Side ID");
                                                                  //  Vend.CALCFIELDS(Vend.Picture,Vend.Signature);
                                                                END;
                                                                generalSetup.GET();
                                                                Limit:=generalSetup."ATM Withdrawal Limit Amount";
                                                                "Application Date":=TODAY;

                                                                "Account No C":=CONVERTSTR("Account No",'-',' ');
                                                                {
                                                                ObjAtmcardBuffer.RESET;
                                                                ObjAtmcardBuffer.SETRANGE(ObjAtmcardBuffer."Account No","Account No");
                                                                ObjAtmcardBuffer.SETRANGE(ObjAtmcardBuffer."ID No","ID No");
                                                                IF ObjAtmcardBuffer.FINDSET THEN BEGIN
                                                                  "Request Type":="Request Type"::Replacement;
                                                                  END;
                                                                }
                                                              END;
                                                               }
    { 3   ;   ;Branch Code         ;Option        ;OptionCaptionML=ENU=31;
                                                   OptionString=31 }
    { 4   ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=Savings,Current;
                                                   OptionString=Savings,Current }
    { 5   ;   ;Account Name        ;Text70         }
    { 6   ;   ;Address             ;Text70         }
    { 7   ;   ;Address 2           ;Text70         }
    { 8   ;   ;Address 3           ;Text50         }
    { 9   ;   ;Address 4           ;Text50         }
    { 10  ;   ;Address 5           ;Text50         }
    { 11  ;   ;Customer ID         ;Code50         }
    { 12  ;   ;Relation Indicator  ;Option        ;OptionCaptionML=ENU=Primary,Suplimentary;
                                                   OptionString=Primary,Suplimentary }
    { 13  ;   ;Card Type           ;Text30         }
    { 14  ;   ;Request Type        ;Option        ;OptionCaptionML=ENU=New,Replacement,Renewal,Returned,Issued;
                                                   OptionString=New,Replacement,Renewal,Returned,Issued }
    { 15  ;   ;Application Date    ;Date          ;OnValidate=BEGIN
                                                                generalSetup.GET();
                                                                "ATM Expiry Date":=CALCDATE(generalSetup."ATM Expiry Duration","Application Date");
                                                              END;
                                                               }
    { 16  ;   ;Card No             ;Code30        ;OnValidate=BEGIN
                                                                "Confirm Card No" := ''
                                                              END;
                                                               }
    { 17  ;   ;Date Issued         ;Date           }
    { 18  ;   ;Limit               ;Decimal        }
    { 19  ;   ;Terms Read and Understood;Boolean   }
    { 20  ;   ;Card Issued         ;Boolean       ;Editable=No }
    { 21  ;   ;Form No             ;Code30         }
    { 22  ;   ;Sent To External File;Option       ;OptionString=No,Yes }
    { 23  ;   ;Card Status         ;Option        ;OptionCaptionML=ENU=Pending,Active,Disabled;
                                                   OptionString=Pending,Active,Disabled;
                                                   Editable=No }
    { 24  ;   ;Date Activated      ;Date           }
    { 25  ;   ;Date Frozen         ;Date           }
    { 26  ;   ;Replacement For Card No;Code20      }
    { 27  ;   ;Has Other Accounts  ;Boolean        }
    { 28  ;   ;Account Type C      ;Code20         }
    { 29  ;   ;Relation Indicator C;Code20         }
    { 30  ;   ;Request Type C      ;Code20         }
    { 31  ;   ;Account No C        ;Code30         }
    { 33  ;   ;Phone No.           ;Code20         }
    { 35  ;   ;No. Series          ;Code20         }
    { 36  ;   ;Collected           ;Boolean        }
    { 37  ;   ;Application Approved;Boolean        }
    { 38  ;   ;Date Collected      ;Date           }
    { 39  ;   ;Card Issued By      ;Code100        }
    { 40  ;   ;Approval Date       ;Date           }
    { 41  ;   ;Reason for Account blocking;Text50  }
    { 42  ;   ;ATM Expiry Date     ;Date           }
    { 43  ;   ;ModeOfCollection    ;Option        ;OnValidate=BEGIN
                                                                // IF ModeOfCollection = '<>';
                                                                // ERROR('Kindly specify the mode of collection');
                                                                // END;
                                                              END;

                                                   OptionCaptionML=ENU=" ,Owner Collected,Card Sent,Card Issued to ";
                                                   OptionString=[ ,Owner Collected,Card Sent,Card Issued to] }
    { 44  ;   ;Issued to           ;Text70         }
    { 45  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected;
                                                   Editable=No }
    { 46  ;   ;Entry No            ;Integer        }
    { 47  ;   ;Captured By         ;Code100        }
    { 48  ;   ;Time Captured       ;Time           }
    { 49  ;   ;ATM Card Fee Charged;Boolean        }
    { 50  ;   ;ATM Card Fee Charged On;Date        }
    { 51  ;   ;ATM Card Fee Charged By;Code100     }
    { 52  ;   ;ATM Card Linked     ;Boolean        }
    { 53  ;   ;ATM Card Linked By  ;Code100        }
    { 54  ;   ;ATM Card Linked On  ;Date           }
    { 55  ;   ;Batch No            ;Code20         }
    { 56  ;   ;Order ATM Card      ;Boolean       ;OnValidate=BEGIN
                                                                IF "Order ATM Card"=TRUE THEN BEGIN
                                                                "Ordered By":=USERID;
                                                                "Ordered On":=TODAY;
                                                                END;
                                                                IF "Order ATM Card"=FALSE THEN BEGIN
                                                                "Ordered By":='';
                                                                "Ordered On":=0D;
                                                                END;
                                                              END;
                                                               }
    { 57  ;   ;Ordered By          ;Code100        }
    { 58  ;   ;Ordered On          ;Date           }
    { 59  ;   ;Card Received       ;Boolean        }
    { 60  ;   ;Received By         ;Code100        }
    { 61  ;   ;Received On         ;Date           }
    { 68018;  ;Account Category    ;Option        ;OptionCaptionML=ENU=Single,Joint,Corporate,Group,Branch,Project;
                                                   OptionString=Single,Joint,Corporate,Group,Branch,Project }
    { 68019;  ;ID No               ;Code20         }
    { 68020;  ;Picture             ;BLOB          ;SubType=Bitmap }
    { 68021;  ;Signature           ;BLOB          ;SubType=Bitmap }
    { 68022;  ;ID Front            ;BLOB          ;SubType=Bitmap }
    { 68023;  ;ID Back             ;BLOB          ;SubType=Bitmap }
    { 68024;  ;Disable On          ;Date           }
    { 68025;  ;Dasabled By         ;Code250        }
    { 68026;  ;Enabled By          ;Code100        }
    { 68027;  ;Enabled On          ;Date           }
    { 68028;  ;Reasons For Disabling;Text250       }
    { 68029;  ;Confirm Card No     ;Code30        ;OnValidate=BEGIN
                                                                //IF "Confirm Card No"<> "Account No" THEN
                                                                 // ERROR('Confirm Card No must be equal to Card No. ,Thank you');
                                                              END;
                                                               }
    { 68030;  ;Member No.          ;Code20         }
    { 68031;  ;Staff No            ;Code20        ;Editable=No }
    { 68032;  ;Reason              ;Text250        }
    { 68033;  ;Branch              ;Option        ;OptionCaptionML=ENU=C. O. UNIVERSITYWAY BRANCH;
                                                   OptionString=C. O. UNIVERSITYWAY BRANCH }
    { 68034;  ;Sacco_Name          ;Option        ;OptionCaptionML=ENU=" TELEPOST SACCO";
                                                   OptionString=TELEPOST SACCO }
    { 68035;  ;8 Digits Pin Code   ;Option        ;OptionCaptionML=ENU=" 4299349823";
                                                   OptionString=4299349823 }
    { 68036;  ;BEGIN               ;Option        ;OptionCaptionML=ENU=BEGIN;
                                                   OptionString=BEGIN }
    { 68037;  ;END                 ;Option        ;OptionCaptionML=ENU=END;
                                                   OptionString=END }
    { 68038;  ;START               ;Option        ;OptionCaptionML=ENU=BEGIN;
                                                   OptionString=BEGIN }
    { 68039;  ;FINISH              ;Option        ;OptionCaptionML=ENU=END;
                                                   OptionString=END }
    { 68040;  ;Sent to CoopBank    ;Boolean        }
    { 68041;  ;Date sent to coopBank;Date          }
  }
  KEYS
  {
    {    ;No.,Application Date,Entry No           ;Clustered=Yes }
    {    ;No.,Customer ID                          }
    {    ;Request Type,No.                         }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Account No,Account Name,Status       }
  }
  CODE
  {
    VAR
      Vend@1102755002 : Record 23;
      NoSeriesMgt@1102755000 : Codeunit 396;
      generalSetup@1102755003 : Record 51516257;
      NoSetup@1000000000 : Record 51516257;
      SalesSetup@1120054000 : Record 51516258;
      atnmcard@1120054001 : Record 51516321;
      Members@1120054002 : Record 51516223;
      SkyPermissions@1120054003 : Record 51516702;
      ATMCardApplications@1120054004 : Record 51516321;

    BEGIN
    END.
  }
}

