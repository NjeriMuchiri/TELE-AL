OBJECT XMLport 20387 Import Salaries
{
  OBJECT-PROPERTIES
  {
    Date=03/10/20;
    Time=10:49:09 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnPostXMLport=BEGIN
                    COMMIT;
                    SaccoNoSeries.GET;
                    CLEAR(NoSeriesManagement);
                    Notouse:=NoSeriesManagement.GetNextNo(SaccoNoSeries."Salaries Upload Nos.",TODAY,TRUE);
                    MESSAGE('Imported successfully');
                  END;

    Format=Variable Text;
  }
  ELEMENTS
  {
    { [{C1253C4E-4CEC-49FD-B343-56BCAAF49D23}];  ;Salaries_Processing ;Element ;Text     }

    { [{7083F801-5AB2-4C8D-93CA-241CD98BD21B}];1 ;SalaryImport        ;Element ;Table   ;
                                                  SourceTable=Table51516317 }

    { [{15A544C6-F3BD-45AB-B33A-C08793C3B289}];2 ;Header              ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Salary Processing Lines::Salary No;
                                                  Import::OnAfterAssignField=BEGIN
                                                                               SaccoNoSeries.GET;
                                                                               CLEAR(NoSeriesManagement);
                                                                               Notouse:=NoSeriesManagement.GetNextNo(SaccoNoSeries."Salaries Upload Nos.",TODAY,FALSE);


                                                                               //IF "Salary Processing Lines"."Salary No"<>Notouse THEN
                                                                                 //ERROR('Salary No must be %1',Notouse);
                                                                             END;
                                                                              }

    { [{2C8C637B-6C50-4FDD-ABD3-AE761FFEB1A3}];2 ;StaffNo             ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Salary Processing Lines::Staff No. }

    { [{6D972CA0-4AAA-4F96-BEAA-D69D0E9429D1}];2 ;Amount              ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=Salary Processing Lines::Amount }

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
    VAR
      SaccoNoSeries@1120054000 : Record 51516258;
      NoSeriesManagement@1120054001 : Codeunit 396;
      Notouse@1120054002 : Code[100];

    BEGIN
    END.
  }
}

