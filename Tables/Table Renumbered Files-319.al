OBJECT table 20463 Sky Product Setup
{
  OBJECT-PROPERTIES
  {
    Date=06/22/23;
    Time=[ 4:41:45 PM];
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
    { 1   ;   ;Product ID          ;Code20         }
    { 2   ;   ;Product Description ;Text30        ;OnValidate=BEGIN
                                                                IF "USSD Product Name" = '' THEN
                                                                    "USSD Product Name" := "Product Description";
                                                              END;
                                                               }
    { 3   ;   ;Product Class Type  ;Option        ;OptionString=[ ,Loan,Savings,Charges,G/L Account] }
    { 4   ;   ;Product Category    ;Option        ;OptionString=[  ,Registration Fee,Loan,Repayment,Withdrawal,Interest Due,Interest Paid,Benevolent Fund,Deposit Contribution,Penalty Charged,Application Fee,Appraisal Fee,Investment,Unallocated Funds,Shares Capital,Loan Adjustment,Dividend,Withholding Tax,Administration Fee,Insurance Contribution,Prepayment,Withdrawable Deposits,Xmas Contribution,Penalty Paid,Dev Shares,Co-op Shares,Welfare Contribution 2,Loan Penalty,Loan Guard,Lukenya,Konza,Juja,Housing Water,Housing Title,Housing Main,M Pesa Charge,Insurance Charge,Insurance Paid,FOSA Account,Partial Disbursement,Loan Due,FOSA Shares,Loan Form Fee,PassBook Fee,Normal shares,SchFee Shares,Principle Unallocated,Interest Unallocated,Registration fees,Deposit Transfer Fees] }
    { 5   ;   ;USSD Product Name   ;Text30         }
    { 6   ;   ;Key Word            ;Code10         }
    { 7   ;   ;Mobile Transaction  ;Option        ;OptionString=[ ,Deposits Only,Withdrawals Only,Deposits & Withdrawals] }
    { 8   ;   ;Table Present       ;Option        ;OptionString=Members,Vendor,G/LAccount }
    { 9   ;   ;Account Type        ;Code30        ;TableRelation="Account Types-Saving Products".Code }
  }
  KEYS
  {
    {    ;Product ID                              ;Clustered=Yes }
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

