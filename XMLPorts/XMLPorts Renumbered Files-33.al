OBJECT XMLport 20397 Investor Import
{
  OBJECT-PROPERTIES
  {
    Date=10/01/18;
    Time=[ 4:58:56 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    TransactionType=UpdateNoLocks;
    Format=Variable Text;
  }
  ELEMENTS
  {
    { [{A72F9E3A-A50F-4FF0-8193-89EB76736FC7}];  ;root                ;Element ;Text     }

    { [{453EEE77-1FAC-41D9-8556-79460BB00EF6}];1 ;table               ;Element ;Table   ;
                                                  SourceTable=Table51516223 }

    { [{A715E0FD-8BDD-4256-8D97-AFD4CB8DC027}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Members Register::No. }

    { [{281FF890-C5C3-42AA-B374-993FA77738AE}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Members Register::Name }

    { [{CB5F2692-66CB-4128-B83A-A66F06148E4B}];2 ;c                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Members Register::Phone No. }

    { [{681FEC54-9C85-44EB-A98E-86D4236DE58E}];2 ;d                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Members Register::Mobile Phone No }

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

