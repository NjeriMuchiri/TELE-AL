OBJECT XMLport 20366 Import/Export ISO Data
{
  OBJECT-PROPERTIES
  {
    Date=05/07/16;
    Time=12:14:44 PM;
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
                                                  SourceTable=Table51516347 }

    { [{5F96659A-3DF9-46E6-B4ED-2FE9DAEE8FE1}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Integer;
                                                  SourceField=ISO-Defined Data Elements::Data Element }

    { [{12400176-386A-4484-86A2-733419905297}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=ISO-Defined Data Elements::Type }

    { [{D243B3FA-ED25-48DC-BD28-D18DCB0CBBDF}];2 ;c                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=ISO-Defined Data Elements::Usage }

    { [{EB09EF24-5BF8-4013-AFD4-E3D14BF96A71}];2 ;d                   ;Element ;Field   ;
                                                  DataType=Integer;
                                                  SourceField=ISO-Defined Data Elements::Length }

    { [{E49D92FD-0BC2-4EBE-9471-5DC4CE7FFC98}];2 ;e                   ;Element ;Field   ;
                                                  DataType=Integer;
                                                  SourceField=ISO-Defined Data Elements::Variable Field }

    { [{DBFBB574-D9CF-42D9-8B36-5FCCDFF6657C}];2 ;f                   ;Element ;Field   ;
                                                  DataType=Integer;
                                                  SourceField=ISO-Defined Data Elements::Variable Field Length }

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

OBJECT XMLPort 20367 ImporT BUFFER
{
  OBJECT-PROPERTIES
  {
    Date=10/19/16;
    Time=11:45:03 PM;
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
                                                  SourceTable=Table51516260;
                                                  AutoUpdate=Yes;
                                                  AutoReplace=No }

    { [{5F96659A-3DF9-46E6-B4ED-2FE9DAEE8FE1}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Sacco Employers::Code }

    { [{12400176-386A-4484-86A2-733419905297}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Sacco Employers::Description }

    { [{B26F835F-2741-47FB-8DA4-C89BA3EAE502}];2 ;c                   ;Element ;Field   ;
                                                  DataType=Boolean;
                                                  SourceField=Sacco Employers::Check Off }

    { [{E78D2A3A-080C-402A-BFB1-04359F7B67C3}];2 ;d                   ;Element ;Field   ;
                                                  DataType=Option;
                                                  SourceField=Sacco Employers::Repayment Method }

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

