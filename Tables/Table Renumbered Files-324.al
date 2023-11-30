OBJECT table 20468 Mobile Loan Guarantors
{
  OBJECT-PROPERTIES
  {
    Date=06/16/22;
    Time=[ 1:23:17 AM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Loan Entry No.      ;Integer        }
    { 2   ;   ;Guarantor Mobile No.;Code20         }
    { 3   ;   ;Guarantor Member No.;Code20        ;OnValidate=BEGIN
                                                                "Available Deposits" := 0;


                                                                Members.RESET;
                                                                Members.SETRANGE(Members."No.","Guarantor Member No.");
                                                                IF Members.FINDFIRST THEN BEGIN
                                                                    Members.CALCFIELDS(Members."Current Shares");
                                                                    "Available Deposits" := Members."Current Shares";
                                                                END;
                                                              END;
                                                               }
    { 4   ;   ;Loan Product        ;Code20         }
    { 5   ;   ;Loan Product Name   ;Text100        }
    { 6   ;   ;Guarantor Name      ;Text100        }
    { 7   ;   ;Guarantor Accepted  ;Option        ;OptionString=Pending,No,Yes }
    { 8   ;   ;Guarantor Response Date;Date        }
    { 9   ;   ;Guarantor Response Time;Time        }
    { 10  ;   ;Status              ;Option        ;OptionString=Pending Approval,Approved,Rejected }
    { 11  ;   ;Appraisal Deposit Products;Code20   }
    { 12  ;   ;Available Deposits  ;Decimal        }
    { 13  ;   ;Amount Guaranteed   ;Decimal        }
    { 14  ;   ;Guarantor Dep. A/C  ;Code30         }
    { 15  ;   ;Date Created        ;DateTime       }
    { 16  ;   ;Loan Status         ;Option        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Sky Mobile Loans".Status WHERE (Entry No=FIELD(Loan Entry No.)));
                                                   OptionCaptionML=ENU=Pending,Successful,Failed,Pending Guarantors,Appraisal,Approved;
                                                   OptionString=Pending,Successful,Failed,Pending Guarantors,Appraisal,Approved }
    { 17  ;   ;Identifier          ;Integer        }
  }
  KEYS
  {
    {    ;Loan Entry No.,Guarantor Mobile No.     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SavingsAccounts@1120054000 : Record 23;
      Members@1120054001 : Record 51516223;

    BEGIN
    END.
  }
}

