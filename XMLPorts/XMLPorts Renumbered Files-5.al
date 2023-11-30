OBJECT XMLport 20369 Import BOSA Members
{
  OBJECT-PROPERTIES
  {
    Date=10/20/16;
    Time=12:31:26 AM;
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
                                                  SourceTable=Table51516223;
                                                  AutoUpdate=Yes;
                                                  AutoReplace=No }

    { [{5F96659A-3DF9-46E6-B4ED-2FE9DAEE8FE1}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Members Register::No. }

    { [{29BE13A7-A9EF-4054-B0B7-21C2F91FF87C}];2 ;c                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Members Register::Payroll/Staff No;
                                                  MinOccurs=Zero }

    { [{81828D53-D905-4CC5-B7DB-92435741DC17}];2 ;f                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Members Register::Old Account No.;
                                                  MinOccurs=Zero }

    { [{95F40B37-B325-44D1-8557-CEB6A8193E8A}];2 ;dd                  ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Members Register::Employer Code;
                                                  MinOccurs=Zero }

    { [{12400176-386A-4484-86A2-733419905297}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Members Register::Name;
                                                  MinOccurs=Zero }

    { [{B3D26651-728B-4A0E-95AB-FD3C94DA1EAF}];2 ;cc                  ;Element ;Field   ;
                                                  DataType=Option;
                                                  SourceField=Members Register::Gender;
                                                  MinOccurs=Zero }

    { [{686481AD-FDA6-4FF1-BB2F-57E67DAD59A9}];2 ;ghege               ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Members Register::Address;
                                                  MinOccurs=Zero }

    { [{4D39014F-56EF-49ED-BAE0-6230D3557796}];2 ;ye                  ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Members Register::Phone No.;
                                                  MinOccurs=Zero }

    { [{F1DCECDF-6116-4895-A03C-4C70DED9AA1D}];2 ;d                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Members Register::FOSA Account;
                                                  MinOccurs=Zero }

    { [{0E60ACB4-3ADA-4260-8692-69A94A1345F5}];2 ;dob                 ;Element ;Field   ;
                                                  DataType=Date;
                                                  SourceField=Members Register::Date of Birth;
                                                  MinOccurs=Zero }

    { [{F77FBBEF-0086-4561-ADB2-A044CD746CBC}];2 ;id                  ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Members Register::ID No.;
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

