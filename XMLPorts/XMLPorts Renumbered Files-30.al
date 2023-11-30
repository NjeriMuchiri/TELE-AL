OBJECT XMLport 20394 Import Paybill Lines
{
  OBJECT-PROPERTIES
  {
    Date=12/15/20;
    Time=[ 5:04:04 PM];
    Modified=Yes;
    Version List=Sky;
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
                                                  SourceTable=Table51516725 }

    { [{A715E0FD-8BDD-4256-8D97-AFD4CB8DC027}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Integer;
                                                  SourceField=Mpesa Rec. Lines::Entry No. }

    { [{281FF890-C5C3-42AA-B374-993FA77738AE}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Date;
                                                  SourceField=Mpesa Rec. Lines::Date }

    { [{64FE7185-8061-4A1F-8F0D-596662CA9A1F}];2 ;c                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Mpesa Rec. Lines::Receipt No. }

    { [{0D32CDE9-DBB2-4E9A-B97C-93EFC479ED96}];2 ;e                   ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=Mpesa Rec. Lines::Amount }

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

