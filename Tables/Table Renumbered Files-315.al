OBJECT table 20459 Sky Mobile Loans
{
  OBJECT-PROPERTIES
  {
    Date=08/18/23;
    Time=[ 3:17:14 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    OnDelete=BEGIN
                  ERROR('Deletion not allowed');
             END;

  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer       ;AutoIncrement=Yes;
                                                   Editable=No }
    { 2   ;   ;Account No          ;Text30        ;Editable=No }
    { 3   ;   ;Date                ;DateTime       }
    { 4   ;   ;Requested Amount    ;Decimal       ;Editable=No }
    { 5   ;   ;Posted              ;Boolean       ;Editable=Yes }
    { 6   ;   ;Status              ;Option        ;OptionCaptionML=ENU=Pending,Successful,Failed,Pending Guarantors,Guarantors Qualified;
                                                   OptionString=Pending,Successful,Failed,Pending Guarantors,Guarantors Qualified;
                                                   Editable=Yes }
    { 7   ;   ;Date Posted         ;DateTime       }
    { 8   ;   ;Remarks             ;Text200       ;Editable=No }
    { 9   ;   ;DocumentNo          ;Text30        ;Editable=No }
    { 10  ;   ;Latest Salary Amount;Decimal       ;Editable=No }
    { 11  ;   ;STO Amount          ;Decimal        }
    { 12  ;   ;Net Salary          ;Decimal        }
    { 13  ;   ;Total loans         ;Decimal        }
    { 14  ;   ;Approved Amount     ;Decimal        }
    { 15  ;   ;Commision Amount    ;Decimal        }
    { 16  ;   ;Loan Product Type   ;Code20        ;TableRelation="Loan Products Setup" }
    { 17  ;   ;Amount              ;Decimal        }
    { 18  ;   ;Session ID          ;Code20         }
    { 19  ;   ;Date Entered        ;Date           }
    { 20  ;   ;Time Entered        ;Time           }
    { 21  ;   ;Telephone No        ;Text20         }
    { 22  ;   ;Message             ;Text250        }
    { 23  ;   ;Member No.          ;Code20         }
    { 24  ;   ;Entry Code          ;Text50         }
    { 25  ;   ;Installments        ;Integer        }
    { 50050;  ;Deactivated         ;Boolean        }
    { 50051;  ;Deactivated By      ;Code50         }
    { 50052;  ;Date Deactivated    ;Date           }
    { 50053;  ;Micro Loan Category ;Code20        ;TableRelation=Table39005554 }
    { 50054;  ;Needs Guarantors    ;Boolean        }
    { 50055;  ;Micro Loan          ;Boolean        }
    { 50056;  ;Name                ;Text200        }
    { 50057;  ;Staff No.           ;Code20         }
    { 50058;  ;Overdraft           ;Boolean        }
    { 50059;  ;Posting Attempts    ;Integer        }
    { 50060;  ;Account Name        ;Text30         }
    { 50061;  ;Loan Name           ;Text30        ;TableRelation="Loan Products Setup" WHERE (Product Description=CONST(Loan Name)) }
    { 50062;  ;Expected Guarantors ;Integer        }
    { 50063;  ;Source              ;Code30         }
    { 50064;  ;Loan No             ;Code30         }
    { 50065;  ;PendingAmount       ;Decimal        }
    { 50066;  ;Amount Guaranteed   ;Decimal        }
    { 50067;  ;Qualified Amount    ;Decimal        }
  }
  KEYS
  {
    {    ;Entry No                                ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

