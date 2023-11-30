OBJECT XMLport 20396 HR Employee Import
{
  OBJECT-PROPERTIES
  {
    Date=05/13/16;
    Time=10:56:24 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Format=Variable Text;
  }
  ELEMENTS
  {
    { [{3BC2AF86-B4B2-4014-95AC-C111D383078B}];  ;root                ;Element ;Text     }

    { [{B5C560F5-1178-440A-8627-56371198D6E9}];1 ;tbl                 ;Element ;Table   ;
                                                  SourceTable=Table51516160 }

    { [{B82D441F-69DE-4DA4-9328-8E25C09C51CA}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Employee::City }

    { [{E7FC9924-56C6-4FF0-9C00-405DCC9C494B}];2 ;i                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=HR Employee::County }

    { [{E5E58FE6-C4AE-4101-9588-A7C06D281F80}];2 ;j                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=HR Employee::Home Phone Number }

    { [{A8923DAF-4B94-4871-B830-E181159EA76A}];2 ;k                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=HR Employee::Post Code }

    { [{7631D872-10A3-4C1E-84B1-29819ACE6B50}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=HR Employee::Cellular Phone Number }

    { [{9861E25B-DB52-4D55-B5D8-DB214ACAED14}];2 ;c                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Employee::E-Mail }

    { [{95F12206-6E7C-415B-9A9A-1D19F4C025CD}];2 ;d                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Employee::Field18 }

    { [{5713CC86-7C47-47A5-A2F5-C1B48ED5084C}];2 ;e                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Employee::Office }

    { [{28FB13F3-82EB-47E3-9D18-FC0243F25C1A}];2 ;f                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Employee::Resource No. }

    { [{77CE23C1-E529-417B-B628-44D6E7DA4F31}];2 ;g                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Employee::Picture }

    { [{CE907CE6-C7A4-45B7-AAF3-E8E14E8A76F1}];2 ;h                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=HR Employee::Comment }

    { [{3932A768-7087-499E-8EA8-FD2F0B00B072}];2 ;fe                  ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Employee::UIF Number }

    { [{1413820B-4189-472D-915D-931FF785B56D}];2 ;er                  ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=HR Employee::Statistics Group Code }

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

