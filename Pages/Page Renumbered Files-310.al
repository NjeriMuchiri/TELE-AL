OBJECT page 50001 Bulk SMS Lines Part
{
  OBJECT-PROPERTIES
  {
    Date=10/31/16;
    Time=12:58:25 PM;
    Modified=Yes;
    Version List=SPESA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516338;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000004;2;Field  ;
                SourceExpr=No }

    { 1000000002;2;Field  ;
                CaptionML=ENU=Telephone No;
                SourceExpr=Code;
                OnLookup=BEGIN
                              {
                           BulkSMSHeader.RESET;
                           BulkSMSHeader.SETRANGE(BulkSMSHeader.No,No);
                           IF BulkSMSHeader.FIND('-') THEN BEGIN
                           //DIMENSION
                           IF BulkSMSHeader."SMS Type"=BulkSMSHeader."SMS Type"::Dimension THEN BEGIN
                           DimensionValue.RESET;
                           DimensionValue.SETRANGE(DimensionValue."Global Dimension No.",2);
                           IF PAGE.RUNMODAL(560,DimensionValue) = ACTION::LookupOK THEN BEGIN
                           Code:=DimensionValue.Code;
                           Description:=DimensionValue.Name;
                           END;

                           END;

                           END;
                              }
                         END;
                          }

    { 1000000003;2;Field  ;
                SourceExpr=Description }

  }
  CODE
  {
    VAR
      BulkSMSHeader@1000000000 : Record 51516337;
      DimensionValue@1000000001 : Record 349;

    BEGIN
    END.
  }
}

