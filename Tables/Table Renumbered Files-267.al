OBJECT table 20410 Loan Officers Details
{
  OBJECT-PROPERTIES
  {
    Date=08/01/16;
    Time=11:17:17 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10         }
    { 2   ;   ;Sales Code          ;Code10        ;TableRelation=IF (Sales Code Type=CONST(Staff)) "HR Employees"
                                                                 ELSE IF (Sales Code Type=CONST(Others)) "Members Register";
                                                   OnValidate=BEGIN

                                                                 Name:='';
                                                                 IF "Sales Code Type" IN ["Sales Code Type"::Staff,"Sales Code Type"::Delegate,"Sales Code Type"::"Board Member",
                                                                 "Sales Code Type"::"Direct Marketers","Sales Code Type"::Others]   THEN

                                                                CASE "Sales Code Type"  OF
                                                                "Sales Code Type"::Staff:
                                                                BEGIN
                                                                HR.GET("Sales Code Type");
                                                                Name:=HR.County;
                                                                END;

                                                                "Sales Code Type"::Delegate:
                                                                  BEGIN
                                                                  Cust.GET("Sales Code Type");
                                                                  Name:=Cust.Name;
                                                                  END;

                                                                "Sales Code Type"::"Board Member":
                                                                BEGIN
                                                                Cust.GET("Sales Code Type");
                                                                Name:=Cust.Name;
                                                                END;
                                                                END;
                                                              END;
                                                               }
    { 3   ;   ;Name                ;Code10         }
    { 4   ;   ;Sales Code Type     ;Option        ;OptionCaptionML=ENU=" ,Staff,Delegate,Board Member,Direct Marketers,Others";
                                                   OptionString=[ ,Staff,Delegate,Board Member,Direct Marketers,Others] }
    { 5   ;   ;Savings Target      ;Decimal        }
    { 6   ;   ;Membership Target   ;Decimal        }
    { 7   ;   ;Disbursement Target ;Decimal        }
    { 8   ;   ;Payment Target      ;Decimal        }
    { 9   ;   ;Exit Target         ;Code10         }
    { 10  ;   ;Status              ;Option        ;OptionCaptionML=ENU=Open,Pending,Approved,Rejected;
                                                   OptionString=Open,Pending,Approved,Rejected;
                                                   Editable=No }
    { 11  ;   ;Created             ;Boolean       ;Editable=No }
    { 12  ;   ;Account Type        ;Option        ;CaptionML=ENU=Account Type;
                                                   OptionCaptionML=ENU=Staff,Customer,Vendor,Member,None;
                                                   OptionString=Staff,Customer,Vendor,Member,None }
    { 13  ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type=CONST(Staff)) "HR Employees"
                                                                 ELSE IF (Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Account Type=CONST(Member)) "Members Register"
                                                                 ELSE IF (Account Type=CONST(Vendor)) Vendor;
                                                   OnValidate=BEGIN


                                                                "Account Name":='';

                                                                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::Member,"Account Type"::Staff] THEN

                                                                CASE "Account Type" OF

                                                                  "Account Type"::Customer:
                                                                    BEGIN
                                                                      Cust.GET("Account No.");
                                                                      "Account Name":=Cust.Name;
                                                                    END;

                                                                //Member
                                                                  "Account Type"::Member:
                                                                    BEGIN
                                                                      Mem.GET("Account No.");
                                                                      "Account Name":=Mem.Name;
                                                                    END;

                                                                  "Account Type"::Staff:
                                                                    BEGIN
                                                                      HR.GET("Account No.");
                                                                      "Account Name":=HR."Post Code";
                                                                    END;


                                                                  "Account Type"::Vendor:
                                                                    BEGIN
                                                                      Vend.GET("Account No.");
                                                                      "Account Name":=Vend.Name;
                                                                    END;
                                                                END;
                                                              END;

                                                   CaptionML=ENU=Account No. }
    { 14  ;   ;Account Name        ;Text30        ;Editable=Yes }
    { 15  ;   ;Currency Code       ;Code10         }
    { 16  ;   ;Branch              ;Code10        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2)) }
    { 17  ;   ;Group Target        ;Code10         }
    { 18  ;   ;Staff Status        ;Option        ;OptionCaptionML=ENU=Active,Resigned,Discharged,Retrenched,Pension,Disabled;
                                                   OptionString=Active,Resigned,Discharged,Retrenched,Pension,Disabled;
                                                   Editable=No }
    { 19  ;   ;No. of Loans        ;Code20         }
    { 20  ;   ;Member Target       ;Code10         }
  }
  KEYS
  {
    {    ;Account No.                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Account Name                             }
  }
  CODE
  {
    VAR
      HR@1000000000 : Record 51516160;
      Custs@1000000001 : Record 51516223;
      GLAcc@1000000006 : Record 15;
      Cust@1000000005 : Record 18;
      Vend@1000000004 : Record 23;
      FA@1000000003 : Record 5600;
      BankAcc@1000000002 : Record 270;
      Mem@1000000007 : Record 51516223;

    BEGIN
    END.
  }
}

