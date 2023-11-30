OBJECT table 20424 ATM Card Applications NEW
{
  OBJECT-PROPERTIES
  {
    Date=09/20/19;
    Time=[ 2:38:48 PM];
    Modified=Yes;
    Version List=ATM;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
               NoSetup.GET();
               NoSetup.TESTFIELD(NoSetup."ATM Applications");
               NoSeriesMgt.InitSeries(NoSetup."ATM Applications",xRec."No. Series",0D,"No.","No. Series");
               END;

               "Application Date":=TODAY;
               "Time Captured":=TIME;
               "Captured By":=UPPERCASE(USERID);
               VALIDATE("Application Date");
             END;

  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  NoSetup.GET;
                                                                  NoSeriesMgt.TestManual(NoSetup."ATM Applications");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Account No          ;Code30        ;TableRelation=Vendor.No.;
                                                   OnValidate=BEGIN
                                                                IF Vend.GET("Account No") THEN BEGIN
                                                                //"Account Name":=PADSTR(Vend.Name,19);
                                                                "Account Name":=Vend.Name;
                                                                "Customer ID":=Vend."ID No.";
                                                                "Branch Code":=Vend."Global Dimension 2 Code";
                                                                "Phone No.":=Vend."Mobile Phone No";
                                                                "Address 1":=Vend.Address;
                                                                "Account Category":=Vend."Account Category";
                                                                "ID No":=Vend."ID No.";



                                                                END;
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
    { 3   ;   ;Branch Code         ;Code30         }
    { 4   ;   ;Account Type        ;Option        ;OptionCaptionML=ENU=Savings,Current;
                                                   OptionString=Savings,Current }
    { 5   ;   ;Account Name        ;Text70         }
    { 6   ;   ;Address 1           ;Text70         }
    { 7   ;   ;Address 2           ;Text70         }
    { 8   ;   ;Address 3           ;Text50         }
    { 9   ;   ;Address 4           ;Text50         }
    { 10  ;   ;Address 5           ;Text50         }
    { 11  ;   ;Customer ID         ;Code50         }
    { 12  ;   ;Relation Indicator  ;Option        ;OptionCaptionML=ENU=Primary,Suplimentary;
                                                   OptionString=Primary,Suplimentary }
    { 13  ;   ;Card Type           ;Text30         }
    { 14  ;   ;Request Type        ;Option        ;OptionCaptionML=ENU=New,Replacement,Renewal;
                                                   OptionString=New,Replacement,Renewal }
    { 15  ;   ;Application Date    ;Date          ;OnValidate=BEGIN
                                                                generalSetup.GET();
                                                                "ATM Expiry Date":=CALCDATE(generalSetup."ATM Expiry Duration","Application Date");
                                                              END;
                                                               }
    { 16  ;   ;Card No             ;Code30         }
    { 17  ;   ;Date Issued         ;Date           }
    { 18  ;   ;Limit               ;Decimal        }
    { 19  ;   ;Terms Read and Understood;Boolean   }
    { 20  ;   ;Card Issued         ;Boolean        }
    { 21  ;   ;Form No             ;Code30         }
    { 22  ;   ;Sent To External File;Option       ;OptionString=No,Yes }
    { 23  ;   ;Card Status         ;Option        ;OptionCaptionML=ENU=Pending,Active,Frozen;
                                                   OptionString=Pending,Active,Frozen }
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
    { 39  ;   ;Card Issued By      ;Code20         }
    { 40  ;   ;Approval Date       ;Date           }
    { 41  ;   ;Reason for Account blocking;Text50  }
    { 42  ;   ;ATM Expiry Date     ;Date           }
    { 43  ;   ;Card Issued to Customer;Option     ;OptionCaptionML=ENU=Owner Collected,Card Sent,Card Issued to;
                                                   OptionString=Owner Collected,Card Sent,Card Issued to }
    { 44  ;   ;Issued to           ;Text70         }
    { 45  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected }
    { 46  ;   ;Entry No            ;Integer        }
    { 47  ;   ;Captured By         ;Code20         }
    { 48  ;   ;Time Captured       ;Time           }
    { 49  ;   ;ATM Card Fee Charged;Boolean        }
    { 50  ;   ;ATM Card Fee Charged On;Date        }
    { 51  ;   ;ATM Card Fee Charged By;Code20      }
    { 52  ;   ;ATM Card Linked     ;Boolean        }
    { 53  ;   ;ATM Card Linked By  ;Code20         }
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
    { 57  ;   ;Ordered By          ;Code20         }
    { 58  ;   ;Ordered On          ;Date           }
    { 59  ;   ;Card Received       ;Boolean        }
    { 60  ;   ;Received By         ;Code20         }
    { 61  ;   ;Received On         ;Date           }
    { 68018;  ;Account Category    ;Option        ;OptionCaptionML=ENU=Single,Joint,Corporate,Group,Branch,Project;
                                                   OptionString=Single,Joint,Corporate,Group,Branch,Project }
    { 68019;  ;ID No               ;Code20         }
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

    BEGIN
    END.
  }
}

