OBJECT XMLport 20380 Import Checkoff Distributed
{
  OBJECT-PROPERTIES
  {
    Date=04/05/18;
    Time=[ 2:42:32 PM];
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
                                                  SourceTable=Table51516282 }

    { [{87DFAF53-1B61-46E9-B0B8-2EB616E08E2A}];2 ;Header_No           ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Checkoff Lines-Distributed::Receipt Header No;
                                                  MinOccurs=Zero }

    { [{2BF3DC86-2EF8-45CA-A3A5-F7A120025223}];2 ;Entry_No            ;Element ;Field   ;
                                                  DataType=Integer;
                                                  SourceField=Checkoff Lines-Distributed::Entry No;
                                                  MinOccurs=Zero }

    { [{3A760407-FD04-4194-9A7A-16D93751AD8B}];2 ;Personal_No         ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Checkoff Lines-Distributed::Staff/Payroll No;
                                                  MinOccurs=Zero }

    { [{0D421334-A392-44FE-8A0E-24EFE7AD570C}];2 ;Reference           ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Checkoff Lines-Distributed::Reference;
                                                  MinOccurs=Zero }

    { [{F862BE91-C3A5-4E9F-8AD7-BF662449594B}];2 ;Amount              ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=Checkoff Lines-Distributed::Amount;
                                                  MinOccurs=Zero }

    { [{E4D3BE32-2DE4-495C-9F6A-8F3FF2B34FB5}];2 ;EmployerCode        ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Checkoff Lines-Distributed::Employer Code;
                                                  MinOccurs=Zero }

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

