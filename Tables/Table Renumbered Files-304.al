OBJECT table 20448 Sky Permissions
{
  OBJECT-PROPERTIES
  {
    Date=02/15/23;
    Time=[ 5:27:58 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               RestrictAccess(USERID);
             END;

    OnModify=BEGIN
               RestrictAccess(USERID);
             END;

    OnDelete=BEGIN
               RestrictAccess(USERID);
             END;

  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code80        ;TableRelation="User Setup"."User ID";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=ENU=User ID. }
    { 48  ;   ;Reset Mpesa Pin     ;Boolean        }
    { 49  ;   ;Update Paybill Transaction;Boolean  }
    { 50000;  ;Update Transactional Mobile No;Boolean }
    { 50050;  ;Sky Mobile Setups   ;Boolean        }
    { 50051;  ;Reverse Sky Transactions;Boolean    }
    { 50052;  ;Black-List Accounts ;Boolean        }
    { 50053;  ;Generate CRB        ;Boolean        }
    { 50054;  ;Edit Batches        ;Boolean        }
    { 50055;  ;Update Loan Sectors ;Boolean        }
    { 50056;  ;Update MPESA Withdrawal;Boolean     }
    { 50057;  ;Micro Applications  ;Boolean        }
    { 50058;  ;Micro Transactions  ;Boolean        }
    { 50059;  ;Micro Loans         ;Boolean        }
    { 50060;  ;View BlackListed Accounts;Boolean   }
    { 50061;  ;Export GL Entries   ;Boolean        }
    { 50062;  ;Clear Transactional Mobile;Boolean  }
    { 50063;  ;Upload Loan Sectorial;Boolean       }
    { 50064;  ;Loan Rescheduling   ;Boolean        }
    { 50065;  ;Interest Due Period ;Boolean        }
    { 50066;  ;Undo Mahitaji BlackList;Boolean     }
    { 50067;  ;Approve Mobile Banking;Boolean      }
    { 50068;  ;Create MBanking Applications;Boolean }
    { 50069;  ;Mpesa Reconciliation;Boolean        }
    { 50070;  ;Reverse M Bank Transfer;Boolean     }
    { 50071;  ;ATM Permisions      ;Boolean        }
    { 50072;  ;T-Kash Accounts     ;Boolean        }
  }
  KEYS
  {
    {    ;User ID                                 ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      UserMgt@1000 : Codeunit 5700;
      Temp@1001 : Record 91;

    PROCEDURE RestrictAccess@1(UserNo@1000 : Code[100]);
    VAR
      StatusPermission@1001 : Record 51516709;
      ErrorOnRestrictViewTxt@1002 : TextConst 'ENU=You do not have permissions to MODIFY or DELETE on this Page. Contact your system administrator for further details';
    BEGIN
      {
      StatusPermission.RESET;
      StatusPermission.SETRANGE("User ID",UserNo);
      StatusPermission.SETRANGE("Edit Setup",TRUE);
      IF NOT StatusPermission.FIND('-') THEN BEGIN
        ERROR(ErrorOnRestrictViewTxt);
        END;
        }
    END;

    BEGIN
    END.
  }
}

