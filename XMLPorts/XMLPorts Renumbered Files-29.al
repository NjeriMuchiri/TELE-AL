OBJECT XMLport 20392 Import Mobile Nos.
{
  OBJECT-PROPERTIES
  {
    Date=06/11/20;
    Time=10:29:31 AM;
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
                                                  SourceTable=Table51516420 }

    { [{A715E0FD-8BDD-4256-8D97-AFD4CB8DC027}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Loan Specific-Sector::Code }

    { [{281FF890-C5C3-42AA-B374-993FA77738AE}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Loan Specific-Sector::Description }

    { [{64FE7185-8061-4A1F-8F0D-596662CA9A1F}];2 ;c                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Loan Specific-Sector::No }

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

