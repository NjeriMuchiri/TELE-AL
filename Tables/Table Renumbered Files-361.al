OBJECT table 17356 Scrap
{
  OBJECT-PROPERTIES
  {
    Date=11/11/19;
    Time=[ 3:49:33 PM];
    Modified=Yes;
    Version List=NAVW17.00;
  }
  PROPERTIES
  {
    CaptionML=[ENU=Scrap;
               ESM=Rechazo;
               FRC=Rebut;
               ENC=Scrap];
    LookupPageID=Page99000780;
    DrillDownPageID=Page99000780;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10        ;CaptionML=[ENU=Code;
                                                              ESM=C digo;
                                                              FRC="Code  ";
                                                              ENC=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text50        ;CaptionML=[ENU=Description;
                                                              ESM=Descripci n;
                                                              FRC=Description;
                                                              ENC=Description] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

