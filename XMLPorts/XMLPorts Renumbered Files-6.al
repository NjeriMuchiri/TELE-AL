OBJECT XMLport 20370 Import Loans Nos
{
  OBJECT-PROPERTIES
  {
    Date=11/17/16;
    Time=[ 2:27:48 PM];
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
                                                  SourceTable=Table20391;
                                                  AutoUpdate=Yes;
                                                  AutoReplace=No }

    { [{E51F290F-C873-4021-AD35-213DC797EFAA}];2 ;a                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Checkoff Ctrl::Loan No }

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

