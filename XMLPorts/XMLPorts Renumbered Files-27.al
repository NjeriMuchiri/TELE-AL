OBJECT XMLport 20391 Employee Import
{
  OBJECT-PROPERTIES
  {
    Date=10/27/16;
    Time=[ 4:42:04 PM];
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
                                                  SourceTable=Table51516160;
                                                  AutoSave=Yes;
                                                  AutoUpdate=Yes;
                                                  AutoReplace=No }

    { [{B82D441F-69DE-4DA4-9328-8E25C09C51CA}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Employee::City }

    { [{7631D872-10A3-4C1E-84B1-29819ACE6B50}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=HR Employee::Post Code }

    { [{606D8C8E-33B9-49F7-A0C2-51C3B2F37ADF}];2 ;D                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=HR Employee::Home Phone Number }

    { [{AA9C2966-3E77-42AF-AE06-0F9451FBB2B3}];2 ;DD                  ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=HR Employee::County }

    { [{88F06080-C261-487A-9831-C0AD1F3E7EE5}];2 ;SS                  ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Employee::E-Mail }

    { [{E2805C61-B565-48D3-B9D7-5563BDE73008}];2 ;R                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Employee::UIF Number }

    { [{84A886F8-56F6-4536-914B-C68C6CF2F403}];2 ;G                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=HR Employee::Statistics Group Code }

    { [{CC22F224-0947-4999-A36C-248677769A86}];2 ;T                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Employee::Picture }

    { [{9051D3F6-017A-4A3E-AADE-F62D6EB7AD69}];2 ;Y                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Employee::Field18 }

    { [{3538D424-120A-4373-B8B4-2AD5847FEC97}];2 ;S                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Employee::Office }

    { [{9C6512C2-299E-4AFD-AAEE-DAC9B442E4D7}];2 ;YP                  ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Employee::Resource No. }

    { [{C7DBA6FC-D252-4462-97AE-1907A80967EB}];2 ;YY                  ;Element ;Field   ;
                                                  DataType=Date;
                                                  SourceField=HR Employee::Field30 }

    { [{8FD7AFE7-A5D4-413F-9A7C-A35042943010}];2 ;HH                  ;Element ;Field   ;
                                                  DataType=Date;
                                                  SourceField=HR Employee::Location/Division Code }

    { [{73399F5A-72F1-4177-B7B6-06E1336FF0CC}];2 ;YYP                 ;Element ;Field   ;
                                                  DataType=Option;
                                                  SourceField=HR Employee::Field29 }

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

