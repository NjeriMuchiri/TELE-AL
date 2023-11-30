OBJECT table 20471 Mpesa Rec. Lines
{
  OBJECT-PROPERTIES
  {
    Date=12/15/20;
    Time=[ 5:41:42 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;Editable=No }
    { 2   ;   ;Receipt No.         ;Code20        ;Editable=No }
    { 3   ;   ;Phone No.           ;Code20        ;Editable=No }
    { 4   ;   ;Amount              ;Decimal       ;Editable=No }
    { 5   ;   ;Date                ;Date          ;Editable=No }
    { 6   ;   ;Reconciled          ;Boolean       ;Editable=No }
    { 7   ;   ;Found               ;Boolean        }
    { 8   ;   ;Posted              ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Sky Transactions".Posted WHERE (Transaction ID=FIELD(Receipt No.))) }
  }
  KEYS
  {
    {    ;Receipt No.                             ;Clustered=Yes }
    {    ;Entry No.                                }
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

