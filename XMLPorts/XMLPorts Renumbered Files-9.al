OBJECT XMLport 20373 Update BOSA Members
{
  OBJECT-PROPERTIES
  {
    Date=12/09/20;
    Time=11:23:41 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Format=Variable Text;
  }
  ELEMENTS
  {
    { [{8F36B81F-ED8C-4EE8-894C-A0BF7F654A45}];  ;root                ;Element ;Text     }

    { [{15613175-A5A0-4EE7-B3C4-7EE41C935217}];1 ;tbl                 ;Element ;Table   ;
                                                  SourceTable=Table51516223;
                                                  AutoUpdate=Yes }

    { [{5F96659A-3DF9-46E6-B4ED-2FE9DAEE8FE1}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Members Register::No. }

    { [{2692BD36-5C10-43C4-9901-978B7F9DEDFD}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Boolean;
                                                  SourceField=Members Register::Pays Benevolent;
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

