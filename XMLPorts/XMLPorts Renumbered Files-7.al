OBJECT XMLport 20371 Payroll Employees
{
  OBJECT-PROPERTIES
  {
    Date=11/03/20;
    Time=10:41:43 AM;
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
                                                  SourceTable=Table51516180;
                                                  AutoUpdate=Yes;
                                                  AutoReplace=No }

    { [{E51F290F-C873-4021-AD35-213DC797EFAA}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Payroll Employee::No. }

    { [{1B585C01-FCAA-4004-82DD-004EC2273C5C}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Payroll Employee::Surname }

    { [{55E7CDEA-B70E-4B74-8724-7A206820B52D}];2 ;c                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Payroll Employee::Firstname }

    { [{68B90791-FBDE-45E7-9B2C-7EF07B08701D}];2 ;d                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Payroll Employee::Lastname }

    { [{C188C325-AD7D-4C19-9B91-43E5793325CF}];2 ;e                   ;Element ;Field   ;
                                                  DataType=Date;
                                                  SourceField=Payroll Employee::Joining Date }

    { [{EC2FCF52-2A7C-4E4C-88D2-8E7FE208EF19}];2 ;f                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Payroll Employee::Posting Group }

    { [{98ACF9C0-A5CF-498C-B9A7-F6C9CF84AEFC}];2 ;g                   ;Element ;Field   ;
                                                  DataType=Option;
                                                  SourceField=Payroll Employee::Payment Mode }

    { [{E7E4D47D-B927-4DD8-A999-145DD76D2B44}];2 ;h                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Payroll Employee::Full Name }

    { [{3493D4E9-7EDB-47B8-85E4-67B64C400D41}];2 ;i                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Payroll Employee::NSSF No }

    { [{B4FD525E-538F-4598-8628-0E24356EB415}];2 ;j                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Payroll Employee::NHIF No }

    { [{23342CBD-48F6-478E-A869-CA8215733DA0}];2 ;k                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Payroll Employee::PIN No }

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

