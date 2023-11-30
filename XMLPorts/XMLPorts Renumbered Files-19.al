OBJECT XMLport 20383 Import Fosa Accounts
{
  OBJECT-PROPERTIES
  {
    Date=10/28/16;
    Time=11:05:38 AM;
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
                                                  SourceTable=Table23;
                                                  AutoSave=Yes;
                                                  AutoUpdate=Yes;
                                                  AutoReplace=No }

    { [{C349B9C0-9ADC-461B-A484-87E8882B5A0C}];2 ;A                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Vendor::No.;
                                                  MinOccurs=Zero }

    { [{91D7AA37-DCD5-4442-8A45-1D281FA6A719}];2 ;B                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Vendor::Name;
                                                  MinOccurs=Zero }

    { [{93781A01-DACE-4675-83B7-6620AB36951B}];2 ;H                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Vendor::Account Type }

    { [{2CB30B01-EA25-4D92-9D6F-4C0C61ED26BD}];2 ;KK                  ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Vendor::Vendor Posting Group }

    { [{B464E4CD-7078-497D-BD9A-49C21E11C208}];2 ;V                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Vendor::ID No. }

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

