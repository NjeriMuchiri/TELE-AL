OBJECT XMLport 20365 Import Sms Lines
{
  OBJECT-PROPERTIES
  {
    Date=11/02/20;
    Time=[ 4:32:55 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Format=Variable Text;
  }
  ELEMENTS
  {
    { [{A0A3EB7E-52C5-46E8-B5F3-3222891C5162}];  ;root                ;Element ;Text     }

    { [{D5AA79E3-FE80-4D25-8616-BC2E34FECDA2}];1 ;tbl                 ;Element ;Table   ;
                                                  SourceTable=Table51516421;
                                                  AutoUpdate=Yes;
                                                  AutoReplace=No }

    { [{E51F290F-C873-4021-AD35-213DC797EFAA}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Integer;
                                                  SourceField=Sms Lines::Entry No }

    { [{1B585C01-FCAA-4004-82DD-004EC2273C5C}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Sms Lines::Mobile No }

    { [{55E7CDEA-B70E-4B74-8724-7A206820B52D}];2 ;c                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Sms Lines::Message To Send;
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

