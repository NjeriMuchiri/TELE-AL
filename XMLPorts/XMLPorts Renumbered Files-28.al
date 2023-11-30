OBJECT XMLport 20392  Import Payroll Trans
{
  OBJECT-PROPERTIES
  {
    Date=05/23/16;
    Time=10:52:16 AM;
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
                                                  SourceTable=Table51516182;
                                                  AutoReplace=Yes }

    { [{B82D441F-69DE-4DA4-9328-8E25C09C51CA}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Payroll Employee Transactions::No. }

    { [{7631D872-10A3-4C1E-84B1-29819ACE6B50}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Payroll Employee Transactions::Transaction Code }

    { [{A252E3DC-ADFC-4240-A856-6670809F9977}];2 ;e                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Payroll Employee Transactions::Transaction Name }

    { [{BCE4C2B1-7C81-436C-939F-463450D16053}];2 ;t                   ;Element ;Field   ;
                                                  DataType=Option;
                                                  SourceField=Payroll Employee Transactions::Transaction Type }

    { [{7D59EB39-F59A-42AE-8F25-37EC21B71757}];2 ;U                   ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=Payroll Employee Transactions::Amount }

    { [{E07A932E-0D39-4B58-B967-AE98AED6DA72}];2 ;K                   ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=Payroll Employee Transactions::Balance }

    { [{89866CF7-04CA-43A9-B75D-7F1D6CAE35E9}];2 ;V                   ;Element ;Field   ;
                                                  DataType=Integer;
                                                  SourceField=Payroll Employee Transactions::Period Month }

    { [{CC854ED3-F9F1-473F-B634-4720B155785E}];2 ;W                   ;Element ;Field   ;
                                                  DataType=Integer;
                                                  SourceField=Payroll Employee Transactions::Period Year }

    { [{D453CD30-6157-4FC1-A67D-23B1552D725E}];2 ;X                   ;Element ;Field   ;
                                                  DataType=Date;
                                                  SourceField=Payroll Employee Transactions::Payroll Period }

    { [{F05243D9-B2F5-400C-A323-906A06444953}];2 ;R                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Payroll Employee Transactions::Loan Number }

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

