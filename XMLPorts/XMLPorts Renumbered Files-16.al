OBJECT XMLport 20379 Import Checkoff Block
{
  OBJECT-PROPERTIES
  {
    Date=09/09/20;
    Time=[ 4:30:54 PM];
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
                                                  SourceTable=Table51516249 }

    { [{87DFAF53-1B61-46E9-B0B8-2EB616E08E2A}];2 ;No                  ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=ReceiptsProcessing_L-Checkoff::Staff/Payroll No }

    { [{CE34E9EE-8357-4B42-B555-C46FBBE17075}];2 ;Amount              ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=ReceiptsProcessing_L-Checkoff::Amount }

    { [{3A760407-FD04-4194-9A7A-16D93751AD8B}];2 ;Header_No           ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=ReceiptsProcessing_L-Checkoff::Receipt Header No }

    { [{6E0DA01D-1BCD-40DB-B557-0295FC383CA3}];2 ;Employer_No         ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=ReceiptsProcessing_L-Checkoff::Employer Code }

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

