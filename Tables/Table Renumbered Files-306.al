OBJECT table 20450 Sky Mobile Setup
{
  OBJECT-PROPERTIES
  {
    Date=09/01/23;
    Time=[ 7:18:08 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Integer       ;AutoIncrement=Yes }
    { 2   ;   ;Vendor Commission Account;Code20   ;TableRelation=Vendor }
    { 3   ;   ;Sacco Fee Account   ;Code20        ;TableRelation="G/L Account" }
    { 4   ;   ;Bank Account        ;Code20        ;TableRelation="Bank Account" }
    { 5   ;   ;Transaction Type    ;Option        ;OptionCaptionML=ENU=" ,Withdrawal,Deposit,Utility Payment,Loan Repayment,Balance Enquiry,Mini-Statement,Loan Disbursement,Account Transfer,Pay Loan From Account,Paybill,Mobile App Login,Bank Transfer,Airtime,T-Kash Loan Repayment,T-Kash Paybill,CoopDeposit";
                                                   OptionString=[ ,Withdrawal,Deposit,Utility Payment,Loan Repayment,Balance Enquiry,Mini-Statement,Loan Disbursement,Account Transfer,Pay Loan From Account,Paybill,Mobile App Login,Bank Transfer,Airtime,T-Kash Loan Repayment,T-Kash Paybill,CoopDeposit] }
    { 6   ;   ;Vendor Commission   ;Decimal        }
    { 7   ;   ;Sacco Fee           ;Decimal        }
    { 8   ;   ;Safaricom Account   ;Code20        ;TableRelation="Bank Account" }
    { 9   ;   ;Safaricom Fee       ;Decimal        }
    { 10  ;   ;Pre-Payment Account ;Code20        ;TableRelation="G/L Account" }
    { 11  ;   ;SMS Charge          ;Decimal        }
    { 12  ;   ;SMS Account         ;Code20        ;TableRelation="G/L Account" }
    { 13  ;   ;Transaction Limit   ;Decimal       ;OnLookup=BEGIN
                                                              IF "Transaction Limit" > 0 THEN BEGIN
                                                                  IF ("Transaction Type"<>"Transaction Type"::Withdrawal) AND ("Transaction Type"<>"Transaction Type"::"Utility Payment") THEN
                                                                      ERROR('This option is not applicable for this transaction');
                                                              END;
                                                            END;
                                                             }
    { 14  ;   ;Non-Member Debit Account;Code20    ;TableRelation="G/L Account" }
    { 15  ;   ;Daily Limit         ;Decimal        }
    { 16  ;   ;Weekly Limit        ;Decimal        }
    { 17  ;   ;Monthly Limit       ;Decimal        }
    { 18  ;   ;Restrict to Employer;Code20        ;TableRelation="Sacco Employers" }
    { 19  ;   ;Disable             ;Boolean        }
    { 50063;  ;Use %               ;Boolean        }
    { 50064;  ;% Charge            ;Decimal        }
    { 50065;  ;Vendor Charge Type  ;Option        ;OptionString=Flat Amount,Percentage,Staggered }
    { 50066;  ;Vendor Staggered Code;Code20       ;TableRelation="Staggered Charges" }
    { 50067;  ;Sacco Charge Type   ;Option        ;OptionString=Flat Amount,Percentage,Staggered }
    { 50068;  ;Sacco Staggered Code;Code20        ;TableRelation="Staggered Charges" }
    { 50069;  ;3rd Party Charge Type;Option       ;OptionString=Flat Amount,Percentage,Staggered }
    { 50070;  ;3rd Party Staggered Code;Code20    ;TableRelation="Staggered Charges" }
    { 50071;  ;Network Service Provider;Option    ;OptionString=Safaricom,Telkom }
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

    BEGIN
    END.
  }
}

