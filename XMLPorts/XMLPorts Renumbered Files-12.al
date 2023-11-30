OBJECT XMLport 20377 Coop Rec. Transactios
{
  OBJECT-PROPERTIES
  {
    Date=03/24/23;
    Time=[ 2:21:38 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Format=Variable Text;
  }
  ELEMENTS
  {
    { [{2C656967-8791-4B33-A822-CCE2DB6B8C2D}];  ;root                ;Element ;Text     }

    { [{65B83050-AE46-43E0-96DD-CDF28AA6B94B}];1 ;a                   ;Element ;Table   ;
                                                  SourceTable=Table170066 }

    { [{DA7FDA7A-179C-413A-A784-88811CAF2728}];2 ;b                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Coop Reconcillation trans.::Reconcilled }

    { [{80AB5D96-1CB1-4230-89A1-29AA0482E731}];2 ;c                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Coop Reconcillation trans.::Field33 }

    { [{8EA43DC5-9C3F-4BF6-B323-BCAFEC8183FF}];2 ;d                   ;Element ;Field   ;
                                                  DataType=Date;
                                                  SourceField=Coop Reconcillation trans.::Document No. }

    { [{D5DEA685-6C32-406C-B015-4ECA2E95E26A}];2 ;e                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Coop Reconcillation trans.::Field15 }

    { [{A44A8F0D-6CB9-46B3-A104-3E557092B026}];2 ;f                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Coop Reconcillation trans.::Field32 }

    { [{D9E1D643-2E45-4E8C-986B-7A8CBF2D30FA}];2 ;g                   ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=Coop Reconcillation trans.::Field17 }

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

