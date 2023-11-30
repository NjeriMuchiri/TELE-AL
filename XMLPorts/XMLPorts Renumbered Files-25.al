OBJECT XMLport 20389 Import Bank statement.
{
  OBJECT-PROPERTIES
  {
    Date=06/17/20;
    Time=[ 1:21:45 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Format=Variable Text;
  }
  ELEMENTS
  {
    { [{75F9FA07-DEC9-4416-A222-0C9726995963}];  ;Member              ;Element ;Text     }

    { [{529AB5D6-5B45-41ED-A932-BF113ECC8382}];1 ;Members             ;Element ;Table   ;
                                                  SourceTable=TableXMLPort 20365;
                                                  AutoUpdate=Yes;
                                                  AutoReplace=No }

    { [{ECEEF143-CA89-4B21-B644-A21A36AD13B5}];2 ;No                  ;Element ;Field   ;
                                                  DataType=Date;
                                                  SourceField=Bank Acc. Statement Line::Transaction Date }

    { [{DCCC8A3B-163E-4713-9A07-E022C814A82E}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Bank Acc. Statement Line::Check No. }

    { [{A90FC05F-A855-4F2B-9481-545E77A29F8B}];2 ;DDD                 ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Bank Acc. Statement Line::Description }

    { [{949B89DC-1E9B-46C4-8F7A-6B0F092A581E}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=Bank Acc. Statement Line::Statement Amount }

    { [{95D109C0-5DB7-4227-9CAB-FF6F60C2D52F}];2 ;c                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Bank Acc. Statement Line::Bank Account No. }

    { [{5F630D4A-2B32-4474-89FD-DC3673145C50}];2 ;d                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Bank Acc. Statement Line::Statement No. }

    { [{8B4204A1-F003-4156-BC25-20FD7F30C781}];2 ;e                   ;Element ;Field   ;
                                                  DataType=Integer;
                                                  SourceField=Bank Acc. Statement Line::Statement Line No. }

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

