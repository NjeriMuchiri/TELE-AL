OBJECT table 17306 Treasury Coinage
{
  OBJECT-PROPERTIES
  {
    Date=04/24/19;
    Time=[ 4:14:05 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20        ;TableRelation="Treasury Transactions" WHERE (No=FIELD(No)) }
    { 2   ;   ;Code                ;Code20        ;TableRelation=Denominations;
                                                   OnValidate=BEGIN
                                                                IF Coinage.GET(Code) THEN BEGIN
                                                                Description:=Coinage.Description;
                                                                Type:=Coinage.Type;
                                                                Value:=Coinage.Value;
                                                                END;
                                                              END;

                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text50         }
    { 4   ;   ;Type                ;Option        ;OptionString=Note,Coin }
    { 5   ;   ;Value               ;Decimal        }
    { 6   ;   ;Quantity            ;Integer       ;OnValidate=BEGIN
                                                                TotalDN:=0;
                                                                AddVarDN:=0;
                                                                "Excess/Shortage":=0;

                                                                //

                                                                TransactionDetails.RESET;

                                                                TransactionDetails.SETRANGE(TransactionDetails.No,No);

                                                                IF TransactionDetails.FIND('-') THEN BEGIN
                                                                REPEAT

                                                                AddVarDN:=0;

                                                                AddVarDN:=TransactionDetails.Value*TransactionDetails.Quantity;
                                                                TotalDN:=TotalDN+AddVarDN;


                                                                UNTIL TransactionDetails.NEXT=0;
                                                                END;


                                                                Transactions.RESET;
                                                                IF Transactions.GET(No) THEN BEGIN;
                                                                Transactions."Coinage Amount":=TotalDN;
                                                                Transactions."Excess/Shortage Amount":=Transactions."Excess/Shortage Amount"-TotalDN;
                                                                Transactions.MODIFY;
                                                                END;



                                                                IF Quantity<>0 THEN BEGIN
                                                                "Total Amount":=Quantity*Value;
                                                                END ELSE BEGIN
                                                                "Total Amount":=0;
                                                                  END;
                                                                MODIFY;
                                                              END;
                                                               }
    { 7   ;   ;Total Amount        ;Decimal        }
  }
  KEYS
  {
    {    ;No,Code                                 ;SumIndexFields=Total Amount;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Coinage@1000000002 : Record 51516303;
      TotalDN@1000000001 : Decimal;
      AddVarDN@1000000000 : Decimal;
      Transactions@1000000004 : Record 51516301;
      TransactionDetails@1000000003 : Record 51516302;
      "Excess/Shortage"@1102755000 : Decimal;

    BEGIN
    END.
  }
}

