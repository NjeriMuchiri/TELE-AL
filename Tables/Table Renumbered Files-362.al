OBJECT table 17357 Production Forecast Name
{
  OBJECT-PROPERTIES
  {
    Date=11/18/19;
    Time=11:58:43 AM;
    Modified=Yes;
    Version List=NAVW18.00;
  }
  PROPERTIES
  {
    OnDelete=VAR
               ProdForecastEntry@1000 : Record 99000852;
             BEGIN
               ProdForecastEntry.SETRANGE("Production Forecast Name",Name);
               IF NOT ProdForecastEntry.ISEMPTY THEN BEGIN
                 IF GUIALLOWED THEN
                   IF NOT CONFIRM(Confirm001Qst,TRUE,Name) THEN
                     ERROR('');
                 ProdForecastEntry.DELETEALL;
               END;
             END;

    CaptionML=[ENU=Production Forecast Name;
               ESM=Nombre previsi n producci n;
               FRC=Nom pr vision de production;
               ENC=Production Forecast Name];
    LookupPageID=Page99000921;
    DrillDownPageID=Page99000921;
  }
  FIELDS
  {
    { 1   ;   ;Name                ;Code10        ;CaptionML=[ENU=Name;
                                                              ESM=Nombre;
                                                              FRC=Nom;
                                                              ENC=Name];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text50        ;CaptionML=[ENU=Description;
                                                              ESM=Descripci n;
                                                              FRC=Description;
                                                              ENC=Description] }
  }
  KEYS
  {
    {    ;Name                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Confirm001Qst@1000 : TextConst 'ENU=The Production Forecast %1 has entries. Do you want to delete it anyway?;ESM=La previsi n de producci n %1 tiene entradas.  Desea eliminarlo de todas maneras?;FRC=La pr vision production %1 comporte des  critures. Souhaitez-vous quand m me la supprimer ?;ENC=The Production Forecast %1 has entries. Do you want to delete it anyway?';

    BEGIN
    END.
  }
}

