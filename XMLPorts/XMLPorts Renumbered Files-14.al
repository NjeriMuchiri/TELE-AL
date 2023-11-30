OBJECT XMLport 20378 Import Leave Balances
{
  OBJECT-PROPERTIES
  {
    Date=01/24/18;
    Time=[ 5:10:35 PM];
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

    { [{DB03FA6D-335B-41BD-A42A-2B1178DC08A6}];1 ;HRLeave             ;Element ;Table   ;
                                                  SourceTable=Table51516197;
                                                  AutoUpdate=Yes }

    { [{8A93D9F1-C499-415F-A23A-7004DAFA5442}];2 ;aa                  ;Element ;Field   ;
                                                  DataType=Integer;
                                                  SourceField=HR Journal Line::Field3 }

    { [{E070D8E4-AFD5-43A8-9987-6982AD442641}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Journal Line::Field22 }

    { [{12CAB2A0-6360-47AB-AA83-3EDFF7987DD4}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Journal Line::From Date }

    { [{BDF7AAB2-A12D-4991-BC7C-50F5FFC27B97}];2 ;c                   ;Element ;Field   ;
                                                  DataType=Option;
                                                  SourceField=HR Journal Line::Cost }

    { [{26DEC388-50E8-4716-A2C7-076F307AF37F}];2 ;d                   ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=HR Journal Line::Expiration Date }

    { [{87A50EEE-3C98-4F3A-883D-B0829E0FE80A}];2 ;e                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=HR Journal Line::Employee Status }

    { [{38F914F1-BB41-4EFC-97E9-B24B571585B2}];2 ;f                   ;Element ;Field   ;
                                                  DataType=Date;
                                                  SourceField=HR Journal Line::Institution/Company }

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

