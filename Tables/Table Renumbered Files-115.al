OBJECT table 17233 Members-Group
{
  OBJECT-PROPERTIES
  {
    Date=10/05/15;
    Time=[ 5:29:52 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Account No.         ;Code20        ;TableRelation=Customer;
                                                   NotBlank=Yes }
    { 2   ;   ;Member No.          ;Code20        ;TableRelation=Customer.No. WHERE (code=CONST(1),
                                                                                     Delete This Field=FILTER(0|4|11|10));
                                                   OnValidate=BEGIN
                                                                {IF Cust.GET("Member No.") THEN BEGIN
                                                                "Staff No.":=Cust."Payroll/Staff No";
                                                                Names:=Cust.Name;

                                                                END;
                                                                }
                                                              END;

                                                   NotBlank=Yes }
    { 3   ;   ;Staff No.           ;Code20        ;OnValidate=BEGIN
                                                                {Cust.RESET;
                                                                Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                                                                Cust.SETRANGE(Cust."Payroll/Staff No","Staff No.");
                                                                IF Cust.FIND('-') THEN BEGIN
                                                                "Member No.":=Cust."No.";
                                                                VALIDATE("Member No.");
                                                                END;
                                                                }
                                                              END;
                                                               }
    { 4   ;   ;Names               ;Text150        }
  }
  KEYS
  {
    {    ;Account No.,Staff No.,Member No.        ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Cust@1102760000 : Record 18;

    BEGIN
    END.
  }
}

