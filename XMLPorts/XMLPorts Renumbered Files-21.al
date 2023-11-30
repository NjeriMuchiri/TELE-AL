OBJECT XMLport 20385 Import Sacco Loans
{
  OBJECT-PROPERTIES
  {
    Date=01/23/18;
    Time=[ 1:09:29 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Direction=Export;
    Format=Variable Text;
  }
  ELEMENTS
  {
    { [{EA310BB0-2264-43A1-8D22-FF139F0AA8E4}];  ;root                ;Element ;Text     }

    { [{DB03FA6D-335B-41BD-A42A-2B1178DC08A6}];1 ;Paybill             ;Element ;Table   ;
                                                  ReqFilterFields=Field69117;
                                                  SourceTable=Table51516230;
                                                  AutoSave=Yes;
                                                  AutoUpdate=Yes;
                                                  AutoReplace=No }

    { [{C349B9C0-9ADC-461B-A484-87E8882B5A0C}];2 ;A                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Loans Register::Loan  No. }

    { [{F720319D-8091-4D8A-A36A-A82427D869D3}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Loans Register::Staff No }

    { [{4C1B06B3-F1BB-4F98-A2A4-3332B05C1FB9}];2 ;E                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Loans Register::Client Name }

    { [{0B0ACABC-6C94-4C1C-88D3-A6D0C5708FC8}];2 ;ff                  ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Loans Register::Loan Product Type }

    { [{49EE1C92-85E5-4871-BE36-E1BE0208197B}];2 ;ddy                 ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=Loans Register::Outstanding Balance }

    { [{47E3D079-F348-49C3-AE8D-EF0C823DD61C}];2 ;vg                  ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=Loans Register::Oustanding Interest }

    { [{1B656C11-457B-4257-85F2-76E6C99303E4}];2 ;vvv                 ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Loans Register::Client Code }

    { [{F42B35A9-F26C-4E59-84BC-CB71BC9BB094}];2 ;xxx                 ;Element ;Field   ;
                                                  DataType=Date;
                                                  SourceField=Loans Register::Issued Date }

    { [{F9B623CE-C832-46C7-8A17-F1377AEE1CF6}];2 ;vt                  ;Element ;Field   ;
                                                  DataType=Boolean;
                                                  SourceField=Loans Register::Posted }

    { [{C5DCC608-E94F-42F1-A4B5-BAB44B6404A4}];2 ;checkedInt          ;Element ;Field   ;
                                                  DataType=Boolean;
                                                  SourceField=Loans Register::Check Int }

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

