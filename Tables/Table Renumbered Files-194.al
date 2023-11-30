OBJECT table 17313 Supervisors Approval Levels
{
  OBJECT-PROPERTIES
  {
    Date=03/29/16;
    Time=11:11:35 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;SupervisorID        ;Code50        ;TableRelation=User."User Name";
                                                   OnValidate=VAR
                                                                UserMgt@1102755000 : Codeunit 418;
                                                              BEGIN
                                                                 UserMgt.ValidateUserID(SupervisorID);
                                                              END;

                                                   OnLookup=VAR
                                                              UserMgt@1102755000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID(SupervisorID);
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[ENU=User ID;
                                                              ESM=Id. usuario;
                                                              FRC=Code utilisateur;
                                                              ENC=User ID];
                                                   NotBlank=Yes }
    { 2   ;   ;Maximum Approval Amount;Decimal     }
    { 3   ;   ;Transaction Type    ;Option        ;OptionString=Cash Deposits,Cheque Deposits,Withdrawals }
    { 4   ;   ;E-mail Address      ;Text30         }
  }
  KEYS
  {
    {    ;SupervisorID,Transaction Type           ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      UserMgt@1102755000 : Codeunit 5700;

    BEGIN
    END.
  }
}

