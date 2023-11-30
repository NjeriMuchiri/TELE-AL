OBJECT XMLport 20374 Update Postal Coop Members
{
  OBJECT-PROPERTIES
  {
    Date=08/01/23;
    Time=[ 2:05:02 PM];
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
                                                  SourceTable=Table51516457;
                                                  AutoUpdate=Yes }

    { [{5F96659A-3DF9-46E6-B4ED-2FE9DAEE8FE1}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=POSTAL CORP::Payroll No }

    { [{2692BD36-5C10-43C4-9901-978B7F9DEDFD}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=POSTAL CORP::Employer Name;
                                                  MinOccurs=Zero }

    { [{F92A210E-DF10-4C3C-B943-8835937F8F99}];2 ;c                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=POSTAL CORP::Account No }

    { [{188D71B9-7303-4A64-A60C-376C35D95D91}];2 ;d                   ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=POSTAL CORP::Salary Amount }

    { [{8D5878BB-5F73-498F-AE9B-31DEA9333854}];2 ;e                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=POSTAL CORP::Grade }

    { [{3CB058B9-0212-408E-8D2D-1E7FC67C9846}];2 ;f                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=POSTAL CORP::County }

    { [{0E75260A-CC8B-4F2D-8BA2-7F3D62D2E8ED}];2 ;g                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=POSTAL CORP::Employer Code }

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

