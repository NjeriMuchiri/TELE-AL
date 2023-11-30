OBJECT table 17330 Cue Sacco Roles Fosa
{
  OBJECT-PROPERTIES
  {
    Date=10/05/15;
    Time=[ 5:16:13 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10         }
    { 2   ;   ;Application Loans   ;Integer       ;FieldClass=FlowField }
    { 3   ;   ;Appraisal Loans     ;Integer       ;FieldClass=FlowField }
    { 4   ;   ;Approved Loans      ;Integer       ;FieldClass=FlowField }
    { 5   ;   ;Rejected Loans      ;Integer       ;FieldClass=FlowField }
    { 6   ;   ;Pending Account Opening;Integer    ;FieldClass=FlowField }
    { 7   ;   ;Approved Accounts Opening;Integer  ;FieldClass=FlowField }
    { 8   ;   ;Pending Loan Batches;Integer       ;FieldClass=FlowField }
    { 9   ;   ;Approved Loan Batches;Integer      ;FieldClass=FlowField }
    { 10  ;No ;Pending Payment Voucher;Integer    ;FieldClass=FlowField }
    { 11  ;No ;Approved Payment Voucher;Integer   ;FieldClass=FlowField }
    { 12  ;No ;Pending Petty Cash  ;Integer       ;FieldClass=FlowField }
    { 13  ;No ;Approved  Petty Cash;Integer       ;FieldClass=FlowField }
    { 14  ;   ;Open Account Opening;Integer       ;FieldClass=FlowField }
    { 20  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=ENU=Date Filter;
                                                   Editable=No }
    { 21  ;   ;Date Filter2        ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=ENU=Date Filter2;
                                                   Editable=No }
    { 22  ;   ;Pending Standing Orders;Integer    ;FieldClass=FlowField }
    { 23  ;   ;Approved Standing Orders;Integer   ;FieldClass=FlowField }
    { 24  ;   ;Unbanked Cheques    ;Integer       ;FieldClass=FlowField }
    { 25  ;   ;Uncreated Approved Accounts;Integer;FieldClass=FlowField }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
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

