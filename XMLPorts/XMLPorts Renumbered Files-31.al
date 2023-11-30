OBJECT XMLport 20395 MpesaTransImport
{
  OBJECT-PROPERTIES
  {
    Date=09/15/18;
    Time=11:51:34 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Format=Variable Text;
  }
  ELEMENTS
  {
    { [{6522531C-078D-4D12-9DC0-72BD23F1C6C2}];  ;Root                ;Element ;Text     }

    { [{A03778CB-3C09-4E8C-AF2D-1D694CDAE46F}];1 ;CloudPEsaTRansactions;Element;Table   ;
                                                  SourceTable=Table51516654;
                                                  AutoUpdate=Yes }

    { [{DB886441-723B-4C53-AEC0-21B472754587}];2 ;A                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=CloudPESA Paybill Buffer::Receipt No. }

    { [{43D9FBA8-04CB-4E0D-8342-7FC365D104AE}];2 ;B                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=CloudPESA Paybill Buffer::Completion Time }

    { [{303DEE12-035F-42F8-B502-98BAB50367B3}];2 ;C                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=CloudPESA Paybill Buffer::Initiation Time }

    { [{969BE3B4-D26B-49CF-8DFB-513996A9F7A4}];2 ;D                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=CloudPESA Paybill Buffer::Details }

    { [{855F17FF-8F53-4CC3-B781-079DCDE3C481}];2 ;E                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=CloudPESA Paybill Buffer::Transaction Status }

    { [{E6F3AD22-0156-48D2-965C-7390A2610AD9}];2 ;F                   ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=CloudPESA Paybill Buffer::Paid In }

    { [{1BA3E793-A319-4E54-A5DE-B64911BB0572}];2 ;G                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=CloudPESA Paybill Buffer::Withdrawn }

    { [{2CE452BE-3278-4B78-A77E-1E0A16F8283E}];2 ;H                   ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=CloudPESA Paybill Buffer::Balance }

    { [{F08E5F53-8145-4136-B479-31DC0BE8A67A}];2 ;I                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=CloudPESA Paybill Buffer::Balance Confirmed }

    { [{ABBC526B-BD83-4687-A3F4-A3122910BD34}];2 ;J                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=CloudPESA Paybill Buffer::Reason Type }

    { [{7EC77F55-D29B-4685-BBDA-3909A8B53759}];2 ;K                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=CloudPESA Paybill Buffer::Other Party Info }

    { [{43C92CDE-079E-4062-ABB4-39EF73CB2642}];2 ;L                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=CloudPESA Paybill Buffer::Linked Transaction ID }

    { [{470C1584-6B02-4CB6-A5AF-A6B304C971DA}];2 ;M                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=CloudPESA Paybill Buffer::A/C No. }

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

