OBJECT XMLport 20390 Export EFT
{
  OBJECT-PROPERTIES
  {
    Date=05/13/16;
    Time=10:05:54 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Format=Variable Text;
  }
  ELEMENTS
  {
    { [{124C650C-DD99-4B6C-9D9E-D0A152BE169C}];  ;Loansrrr            ;Element ;Text     }

    { [{3DF8C457-6CA4-4A52-8569-04D01AEBFE2B}];1 ;Loan                ;Element ;Table   ;
                                                  SourceTable=Table51516230;
                                                  Import::OnBeforeInsertRecord=VAR
                                                                                 OrgICGLAcc@1000 : Record 410;
                                                                               BEGIN





                                                                                 {
                                                                                 XMLInbound := TRUE;

                                                                                 IF TempICGLAcc.GET(ICGLAcc."No.") THEN BEGIN
                                                                                   IF (ICGLAcc.Name <> TempICGLAcc.Name) OR (ICGLAcc."Account Type" <> TempICGLAcc."Account Type") OR
                                                                                      (ICGLAcc."Income/Balance" <> TempICGLAcc."Income/Balance") OR (ICGLAcc.Blocked <> TempICGLAcc.Blocked)
                                                                                   THEN
                                                                                     Modified := Modified + 1;
                                                                                   ICGLAcc."Map-to G/L Acc. No." := TempICGLAcc."Map-to G/L Acc. No.";
                                                                                   OrgICGLAcc.GET(ICGLAcc."No.");
                                                                                   OrgICGLAcc.DELETE;
                                                                                   TempICGLAcc.DELETE;
                                                                                 END ELSE
                                                                                   Inserted := Inserted + 1;
                                                                                 }
                                                                               END;

                                                  Export::OnAfterGetRecord=BEGIN

                                                                              IF cust.GET("Loans Register"."Client Code") THEN BEGIN
                                                                                 "Loans Register"."Bank code":=cust."Bank Code";
                                                                                 "Loans Register"."Bank No":= cust."Bank Account No.";
                                                                                 "Loans Register"."Bank Branch":=cust."Bank Branch";
                                                                                 "Loans Register".MODIFY;
                                                                              END;
                                                                           END;
                                                                            }

    { [{DF89A923-8B0F-4A4B-91D4-DCAF39B64119}];2 ;No                  ;Attribute;Field  ;
                                                  DataType=Code;
                                                  SourceField=Loans Register::Client Code }

    { [{C1EF940C-FFF3-44FD-B2BE-50CC96BA8A47}];2 ;Name                ;Attribute;Field  ;
                                                  DataType=Text;
                                                  SourceField=Loans Register::Client Name }

    { [{76AAB394-4C21-42B8-818B-76AB6302C1FD}];2 ;BCode               ;Attribute;Field  ;
                                                  DataType=Code;
                                                  SourceField=Loans Register::Bank code }

    { [{B1943B8E-E447-4B5B-92C1-C98B24FAE2E1}];2 ;BNo                 ;Attribute;Field  ;
                                                  DataType=Code;
                                                  SourceField=Loans Register::Bank No }

    { [{581D1E72-885A-40B9-B7C8-6674457874BA}];2 ;AppAmount           ;Attribute;Field  ;
                                                  DataType=Decimal;
                                                  SourceField=Loans Register::Loan Disbursed Amount }

    { [{23CD5D5E-41F1-4941-826E-5A0D2AA0411A}];2 ;Branch              ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Loans Register::Bank Branch }

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
      cust@1000 : Record 51516223;

    BEGIN
    END.
  }
}

