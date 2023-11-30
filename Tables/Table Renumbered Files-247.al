OBJECT table 20390 HR Education Assistance
{
  OBJECT-PROPERTIES
  {
    Date=04/24/20;
    Time=11:42:06 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    LookupPageID=Page55660;
    DrillDownPageID=Page55660;
  }
  FIELDS
  {
    { 1   ;   ;Employee No.        ;Code20        ;TableRelation="HR Employees".No.;
                                                   OnValidate=BEGIN
                                                                      OK:= Employee.GET("Employee No.");
                                                                      IF OK THEN BEGIN
                                                                       "Employee First Name":= Employee."First Name";
                                                                       "Employee Last Name":= Employee."Last Name";
                                                                      END;
                                                              END;
                                                               }
    { 2   ;   ;Refund Level        ;Text30         }
    { 3   ;   ;Year Of Study       ;Integer        }
    { 4   ;   ;Student Number      ;Text30         }
    { 5   ;   ;Educational Institution;Text100     }
    { 6   ;   ;Type Of Institution ;Code20         }
    { 7   ;   ;Subject Registered1 ;Text80         }
    { 8   ;   ;Cost Of Subject1    ;Decimal        }
    { 9   ;   ;Subject Registered2 ;Text80         }
    { 10  ;   ;Cost Of Subject2    ;Decimal        }
    { 11  ;   ;Subject Registered3 ;Text80         }
    { 12  ;   ;Cost Of Subject3    ;Decimal        }
    { 13  ;   ;Subject Registered4 ;Text80         }
    { 14  ;   ;Cost Of Subject4    ;Decimal        }
    { 15  ;   ;Subject Registered5 ;Text80         }
    { 16  ;   ;Cost Of Subject5    ;Decimal        }
    { 17  ;   ;Subject Registered6 ;Text80         }
    { 18  ;   ;Cost Of Subject6    ;Decimal        }
    { 20  ;   ;Date Rewrite1       ;Date           }
    { 21  ;   ;Date Completed1     ;Date           }
    { 22  ;   ;CompletedResult1    ;Option        ;OptionString=[ ,Passed,Failed] }
    { 23  ;   ;Date Rewrite2       ;Date           }
    { 24  ;   ;Date Completed2     ;Date           }
    { 25  ;   ;CompletedResult2    ;Option        ;OptionString=[ ,Passed,Failed] }
    { 26  ;   ;Date Rewrite3       ;Date           }
    { 27  ;   ;Date Completed3     ;Date           }
    { 28  ;   ;CompletedResult3    ;Option        ;OptionString=[ ,Passed,Failed] }
    { 29  ;   ;Date Rewrite4       ;Date           }
    { 30  ;   ;Date Completed4     ;Date           }
    { 31  ;   ;CompletedResult4    ;Option        ;OptionString=[ ,Passed,Failed] }
    { 32  ;   ;Date Rewrite5       ;Date           }
    { 33  ;   ;Date Completed5     ;Date           }
    { 34  ;   ;CompletedResult5    ;Option        ;OptionString=[ ,Passed,Failed] }
    { 35  ;   ;Date Rewrite6       ;Date           }
    { 36  ;   ;Date Completed6     ;Date           }
    { 37  ;   ;CompletedResult6    ;Option        ;OptionString=[ ,Passed,Failed] }
    { 38  ;   ;Study Period        ;Integer        }
    { 39  ;   ;Employee First Name ;Text50         }
    { 40  ;   ;Employee Last Name  ;Text50         }
    { 41  ;   ;Duration            ;Option        ;OptionString=Hours,Days,Weeks,Months,Years }
    { 42  ;   ;Enrollment Fee      ;Decimal        }
    { 43  ;   ;Book Cost Subject1  ;Decimal        }
    { 44  ;   ;Book Cost Subject2  ;Decimal        }
    { 45  ;   ;Book Cost Subject3  ;Decimal        }
    { 46  ;   ;Book Cost Subject4  ;Decimal        }
    { 47  ;   ;Book Cost Subject5  ;Decimal        }
    { 48  ;   ;Book Cost Subject6  ;Decimal        }
    { 49  ;   ;RewriteResult1      ;Option        ;OptionString=[ ,Passed,Failed] }
    { 50  ;   ;RewriteResult2      ;Option        ;OptionString=[ ,Passed,Failed] }
    { 51  ;   ;RewriteResult3      ;Option        ;OptionString=[ ,Passed,Failed] }
    { 52  ;   ;RewriteResult4      ;Option        ;OptionString=[ ,Passed,Failed] }
    { 53  ;   ;RewriteResult5      ;Option        ;OptionString=[ ,Passed,Failed] }
    { 54  ;   ;RewriteResult6      ;Option        ;OptionString=[ ,Passed,Failed] }
    { 55  ;   ;Refunded1           ;Boolean        }
    { 56  ;   ;Refunded2           ;Boolean        }
    { 57  ;   ;Refunded3           ;Boolean        }
    { 58  ;   ;Refunded4           ;Boolean        }
    { 59  ;   ;Refunded5           ;Boolean        }
    { 60  ;   ;Refunded6           ;Boolean        }
    { 61  ;   ;Training Credits1   ;Decimal        }
    { 62  ;   ;Education Credits1  ;Decimal        }
    { 63  ;   ;Training Credits2   ;Decimal        }
    { 64  ;   ;Education Credits2  ;Decimal        }
    { 65  ;   ;Training Credits3   ;Decimal        }
    { 66  ;   ;Education Credits3  ;Decimal        }
    { 67  ;   ;Training Credits4   ;Decimal        }
    { 68  ;   ;Education Credits4  ;Decimal        }
    { 69  ;   ;Training Credits5   ;Decimal        }
    { 70  ;   ;Education Credits5  ;Decimal        }
    { 71  ;   ;Training Credits6   ;Decimal        }
    { 72  ;   ;Education Credits6  ;Decimal        }
    { 73  ;   ;Total Cost          ;Decimal        }
    { 74  ;   ;Year                ;Integer       ;CaptionML=ENU=From }
    { 75  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("HR Human Resource Comments" WHERE (Table Name=CONST(Education Assistance),
                                                                                                         No.=FIELD(Employee No.)));
                                                   Editable=No }
    { 76  ;   ;Line No             ;Integer        }
    { 77  ;   ;To                  ;Integer        }
    { 78  ;   ;Qualification       ;Code20        ;TableRelation=Qualification.Code }
  }
  KEYS
  {
    {    ;Employee No.,Year,Line No               ;SumIndexFields=Total Cost;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Employee@1102755001 : Record 51516160;
      OK@1102755000 : Boolean;

    BEGIN
    END.
  }
}

