OBJECT XMLport 20386 Import Sacco Loan No
{
  OBJECT-PROPERTIES
  {
    Date=05/06/16;
    Time=[ 7:33:24 PM];
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
                                                  SourceTable=Table51516230;
                                                  AutoUpdate=Yes }

    { [{C349B9C0-9ADC-461B-A484-87E8882B5A0C}];2 ;A                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Loans Register::Loan  No. }

    { [{09808987-487C-43BD-B328-C45D165F89FB}];2 ;B                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Loans Register::old no }

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

