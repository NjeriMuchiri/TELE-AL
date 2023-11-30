OBJECT XMLport 20368 Import G/L Accounts
{
  OBJECT-PROPERTIES
  {
    Date=10/19/16;
    Time=10:14:22 PM;
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
                                                  SourceTable=Table15;
                                                  AutoUpdate=Yes;
                                                  AutoReplace=No }

    { [{5F96659A-3DF9-46E6-B4ED-2FE9DAEE8FE1}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=G/L Account::No. }

    { [{12400176-386A-4484-86A2-733419905297}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=G/L Account::Old Account No }

    { [{29BE13A7-A9EF-4054-B0B7-21C2F91FF87C}];2 ;c                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=G/L Account::Name }

    { [{F1DCECDF-6116-4895-A03C-4C70DED9AA1D}];2 ;d                   ;Element ;Field   ;
                                                  DataType=Option;
                                                  SourceField=G/L Account::Income/Balance }

    { [{C8378614-7707-4923-882C-21605D42E86F}];2 ;e                   ;Element ;Field   ;
                                                  DataType=Option;
                                                  SourceField=G/L Account::Account Type }

    { [{7A8993A4-1BA1-4001-AC73-3AFBBA8FDC13}];2 ;f                   ;Element ;Field   ;
                                                  DataType=Boolean;
                                                  SourceField=G/L Account::Direct Posting }

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

