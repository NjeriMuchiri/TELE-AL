OBJECT table 20446 Sacco Setup
{
  OBJECT-PROPERTIES
  {
    Date=10/17/21;
    Time=[ 6:24:50 AM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               RestrictAccess(USERID)
             END;

    OnModify=BEGIN
               RestrictAccess(USERID)
             END;

    OnDelete=BEGIN
               RestrictAccess(USERID)
             END;

    OnRename=BEGIN
               RestrictAccess(USERID)
             END;

  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20         }
    { 9   ;   ;Excise Duty G/L     ;Code20        ;TableRelation="G/L Account" }
    { 11  ;   ;Excise Duty (%)     ;Decimal        }
    { 12  ;   ;Sacco SMS Expense GL;Code20        ;TableRelation="G/L Account" }
    { 13  ;   ;Mobile Vendor Account;Code20       ;TableRelation=Vendor }
    { 14  ;   ;Sacco SMS Income GL ;Code20        ;TableRelation="G/L Account" }
    { 15  ;   ;Vendor SMS Split Amount;Decimal     }
    { 16  ;   ;Maximum Mobile Loan Limit;Decimal   }
    { 17  ;   ;Minimum Share Capital;Decimal       }
    { 18  ;   ;Initial Loan Limit  ;Decimal        }
    { 19  ;   ;Defaulter Initial Limit;Decimal     }
    { 20  ;   ;Loan Increment      ;Decimal        }
    { 21  ;   ;Defaulter Loan Increment;Decimal    }
    { 22  ;   ;Loan Penalty %      ;Decimal        }
    { 50001;  ;MBanking Application Nos;Code20    ;TableRelation="No. Series" }
    { 50014;  ;SMS Sender ID       ;BigInteger     }
    { 50015;  ;SMS Sender Name     ;Text30         }
    { 50016;  ;Virtual Members Images Path;Text250 }
    { 50017;  ;Loan Interest Expense GL;Code20    ;TableRelation="G/L Account" }
    { 50018;  ;Mbanking Application Name;Text30    }
    { 50019;  ;USSD Code           ;Text30         }
    { 50020;  ;Max Posting Attempts;Integer        }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    PROCEDURE RestrictAccess@1(UserNo@1000 : Code[100]);
    VAR
      StatusPermission@1001 : Record 51516310;
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

