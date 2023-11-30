OBJECT table 50082 Top Savers Buffer
{
  OBJECT-PROPERTIES
  {
    Date=12/04/20;
    Time=11:42:16 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry No            ;Integer       ;AutoIncrement=Yes }
    { 2   ;   ;Product Type        ;Option        ;OptionString=[ ,Deposit Contribution,Share Capital,School Fees Shares,Co-Operative Shares,FOSA] }
    { 3   ;   ;Member No           ;Code20        ;TableRelation="Members Register";
                                                   Editable=No }
    { 4   ;   ;Member Name         ;Text100       ;Editable=No }
    { 5   ;   ;Balance             ;Decimal       ;Editable=No }
    { 6   ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter }
  }
  KEYS
  {
    {    ;Entry No                                ;Clustered=Yes }
    {    ;Product Type,Balance                     }
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

