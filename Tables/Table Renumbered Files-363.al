OBJECT table 17358 TempBlob
{
  OBJECT-PROPERTIES
  {
    Date=09/11/23;
    Time=12:27:32 PM;
    Modified=Yes;
    Version List=NAVW19.00;
  }
  PROPERTIES
  {
    CaptionML=[ENU=TempBlob;
               ESM=Blob temporal;
               FRC=BlobTemp;
               ENC=TempBlob];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Integer       ;CaptionML=[ENU=Primary Key;
                                                              ESM=Clave primaria;
                                                              FRC=Cl  primaire;
                                                              ENC=Primary Key] }
    { 2   ;   ;Blob                ;BLOB          ;CaptionML=[ENU=Blob;
                                                              ESM=Blob;
                                                              FRC=Grand objet binaire;
                                                              ENC=Blob] }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    PROCEDURE ReadAsText@5(LineSeperator@1001 : Text;Encoding@1000 : TextEncoding) Content : Text;
    VAR
      InStream@1002 : InStream;
      ContentLine@1003 : Text;
    BEGIN
      Blob.CREATEINSTREAM(InStream,Encoding);

      InStream.READTEXT(Content);
      WHILE NOT InStream.EOS DO BEGIN
        InStream.READTEXT(ContentLine);
        Content += LineSeperator + ContentLine;
      END;
    END;

    PROCEDURE ToBase64String@1120054000() : Text;
    VAR
      IStream@1120054000 : InStream;
      Convert@1120054001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
      MemoryStream@1120054002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
      Base64String@1120054003 : Text;
    BEGIN
      IF NOT Blob.HASVALUE THEN
        EXIT('');
      Blob.CREATEINSTREAM(IStream);
      MemoryStream := MemoryStream.MemoryStream;
      COPYSTREAM(MemoryStream,IStream);
      Base64String := Convert.ToBase64String(MemoryStream.ToArray);
      MemoryStream.Close;
      EXIT(Base64String);
    END;

    BEGIN
    END.
  }
}

OBJECT Table 2000000165 Tenant Permission Set
{
  OBJECT-PROPERTIES
  {
    Date=09/16/15;
    Time=12:00:00 PM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    CaptionML=[ENU=Tenant Permission Set;
               ESM=Conjunto de permisos del inquilino;
               FRC=Ensemble d'autorisations abonn ;
               ENC=Tenant Permission Set];
  }
  FIELDS
  {
    { 1   ;   ;App ID              ;GUID          ;CaptionML=[ENU=App ID;
                                                              ESM=Id. aplicaci n;
                                                              FRC=Code appli;
                                                              ENC=App ID] }
    { 2   ;   ;Role ID             ;Code20        ;CaptionML=[ENU=Role ID;
                                                              ESM=Id. rol;
                                                              FRC=Code r le;
                                                              ENC=Role ID] }
    { 3   ;   ;Name                ;Text30        ;CaptionML=[ENU=Name;
                                                              ESM=Nombre;
                                                              FRC=Nom;
                                                              ENC=Name] }
  }
  KEYS
  {
    {    ;App ID,Role ID                          ;Clustered=Yes }
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
