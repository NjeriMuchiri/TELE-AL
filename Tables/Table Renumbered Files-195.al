OBJECT table 17314 Status Change Permision
{
  OBJECT-PROPERTIES
  {
    Date=08/15/16;
    Time=12:08:31 PM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;User Id             ;Code50        ;TableRelation="User Setup"."User ID" }
    { 2   ;   ;Function            ;Option        ;OptionCaptionML=ENU=Account Status,Standing Order,Discounting Cheque,Inter Teller Approval,Discounting Loan,Nominee,Discounting Shares,Discounting Dividends,Loan External EFT,Overide Defaulters,BOSA Account Status,Fosa Loan Approval,PV Approval,PV Verify,PV Cancel,ATM Approval,Petty Cash Approval,Bosa Loan Approval,Bosa Loan Appraisal,Atm card ready,Audit Approval,Finance Approval,Replace Guarantors,Account Opening,Mpesa Change,Edit,NameEdit,GL Account Edit,Disable ATM;
                                                   OptionString=Account Status,Standing Order,Discounting Cheque,Inter Teller Approval,Discounting Loan,Nominee,Discounting Shares,Discounting Dividends,Loan External EFT,Overide Defaulters,BOSA Account Status,Fosa Loan Approval,PV Approval,PV Verify,PV Cancel,ATM Approval,Petty Cash Approval,Bosa Loan Approval,Bosa Loan Appraisal,Atm card ready,Audit Approval,Finance Approval,Replace Guarantors,Account Opening,Mpesa Change,Edit,NameEdit,GL Account Edit,Disable ATM;
                                                   NotBlank=No }
  }
  KEYS
  {
    {    ;Function,User Id                        ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      UserMgt@1102755000 : Codeunit 5700;

    BEGIN
    END.
  }
}

