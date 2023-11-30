OBJECT table 17344 Paybill Keywords
{
  OBJECT-PROPERTIES
  {
    Date=02/14/23;
    Time=[ 1:52:32 PM];
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Keyword             ;Text50        ;NotBlank=Yes }
    { 2   ;   ;Loan Code           ;Code20        ;TableRelation="Loan Products Setup".Code }
    { 3   ;   ;Destination Type    ;Option        ;OptionString=None,Loan Repayment,Shares Capital,Deposit Contribution,Benevolent Funds }
  }
  KEYS
  {
    {    ;Keyword                                 ;Clustered=Yes }
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

