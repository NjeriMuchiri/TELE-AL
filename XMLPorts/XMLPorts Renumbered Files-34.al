OBJECT XMLport 20398 Import Withdrawn Members
{
  OBJECT-PROPERTIES
  {
    Date=03/25/22;
    Time=10:15:47 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Format=Variable Text;
  }
  ELEMENTS
  {
    { [{EA310BB0-2264-43A1-8D22-FF139F0AA8E4}];  ;root                ;Element ;Text     }

    { [{DB03FA6D-335B-41BD-A42A-2B1178DC08A6}];1 ;Paybill             ;Element ;Table   ;
                                                  SourceTable=Table51516259 }

    { [{4EF5FA8C-07A7-492C-BC70-01C2D178A41D}];2 ;A                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  FieldValidate=No;
                                                  SourceField=Membership Withdrawals::No. }

    { [{D262FB97-C3C3-4D36-99BB-7332F53109C0}];2 ;B                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  FieldValidate=No;
                                                  SourceField=Membership Withdrawals::Member No. }

    { [{486297FF-8333-429F-98DA-6ABE9FE31210}];2 ;C                   ;Element ;Field   ;
                                                  DataType=Date;
                                                  FieldValidate=No;
                                                  SourceField=Membership Withdrawals::Closing Date }

    { [{4252D1B1-AEF3-4538-8EA4-9A9A6ECA3200}];2 ;D                   ;Element ;Field   ;
                                                  DataType=Option;
                                                  FieldValidate=No;
                                                  SourceField=Membership Withdrawals::Status }

    { [{B956103E-9E29-4694-BD84-80A9CE8FAF74}];2 ;E                   ;Element ;Field   ;
                                                  DataType=Boolean;
                                                  FieldValidate=No;
                                                  SourceField=Membership Withdrawals::Posted }

    { [{A551CDF2-58D5-4F46-9D23-455827BBC5CD}];2 ;F                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  FieldValidate=No;
                                                  SourceField=Membership Withdrawals::Captured By }

    { [{83B12CFF-64C8-4A13-99E1-A5E1167482D4}];2 ;G                   ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  FieldValidate=Yes;
                                                  SourceField=Membership Withdrawals::Net Refund }

    { [{26F42C0A-5FEF-4CA3-BD09-89D569A052D0}];2 ;I                   ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  FieldValidate=Yes;
                                                  SourceField=Membership Withdrawals::Amount to Refund }

    { [{A1BB975E-B1A5-4615-9175-211226DFA70A}];2 ;J                   ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  FieldValidate=Yes;
                                                  SourceField=Membership Withdrawals::Net Pay }

    { [{7F1A9421-26CE-432D-ACDD-E6F17DE36F3B}];2 ;L                   ;Element ;Field   ;
                                                  DataType=Boolean;
                                                  FieldValidate=No;
                                                  SourceField=Membership Withdrawals::Posted }

    { [{51E5510C-FF8B-43CA-A054-FFD870E429D8}];2 ;M                   ;Element ;Field   ;
                                                  DataType=Option;
                                                  FieldValidate=No;
                                                  SourceField=Membership Withdrawals::Withdrawal Status }

    { [{80598572-0AEE-46FC-B0A3-6618597935F8}];2 ;N                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  FieldValidate=No;
                                                  SourceField=Membership Withdrawals::FOSA Account No. }

    { [{11556085-9E82-40D8-855F-9E33A3FC7F8C}];2 ;o                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  FieldValidate=No;
                                                  SourceField=Membership Withdrawals::Description }

  }
  EVENTS
  {
  }
  REQUESTPAGE
  {
    PROPERTIES
    {
    }
    CONTROLS
    {
    }
  }
  CODE
  {

    BEGIN
    END.
  }
}
