OBJECT table 20455 Sky USSD Auth
{
  OBJECT-PROPERTIES
  {
    Date=12/17/20;
    Time=[ 7:17:05 AM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Mobile No.          ;Code30         }
    { 2   ;   ;Account No.         ;Code30        ;Editable=Yes }
    { 3   ;   ;PIN No.             ;Text250       ;Editable=Yes }
    { 4   ;   ;Reset PIN           ;Boolean       ;OnValidate=BEGIN


                                                                Vend.GET("Account No.");

                                                                PINChangeLog.INIT;
                                                                PINChangeLog.Date := CURRENTDATETIME;
                                                                PINChangeLog."Account No." := "Account No.";
                                                                PINChangeLog."Account Name" := Vend.Name;
                                                                PINChangeLog."Changed By" := USERID;
                                                                PINChangeLog."Old Value" := FORMAT(xRec."Reset PIN");
                                                                PINChangeLog."New Value" := FORMAT("Reset PIN");
                                                                PINChangeLog."Field Modified" := 'Reset PIN';
                                                                PINChangeLog.INSERT;
                                                              END;
                                                               }
    { 5   ;   ;User Status         ;Option        ;OnValidate=BEGIN

                                                                Vend.GET("Account No.");

                                                                PINChangeLog.INIT;
                                                                PINChangeLog.Date := CURRENTDATETIME;
                                                                PINChangeLog."Account No." := "Account No.";
                                                                PINChangeLog."Account Name" := Vend.Name;
                                                                PINChangeLog."Changed By" := USERID;
                                                                PINChangeLog."Old Value" := FORMAT(xRec."User Status");
                                                                PINChangeLog."New Value" := FORMAT("User Status");
                                                                PINChangeLog."Field Modified" := 'User Status';
                                                                PINChangeLog.INSERT;
                                                              END;

                                                   OptionCaptionML=ENU="Active,Inactive, ";
                                                   OptionString=[Active,Inactive, ] }
    { 6   ;   ;Date Created        ;Date           }
    { 7   ;   ;Date Updated        ;Date           }
    { 8   ;   ;Initial PIN Sent    ;Boolean        }
    { 9   ;   ;Force PIN           ;Boolean       ;OnValidate=BEGIN

                                                                "Reset PIN":="Force PIN";

                                                                Vend.GET("Account No.");

                                                                PINChangeLog.INIT;
                                                                PINChangeLog.Date := CURRENTDATETIME;
                                                                PINChangeLog."Account No." := "Account No.";
                                                                PINChangeLog."Account Name" := Vend.Name;
                                                                PINChangeLog."Changed By" := USERID;
                                                                PINChangeLog."Old Value" := FORMAT(xRec."Force PIN");
                                                                PINChangeLog."New Value" := FORMAT("Force PIN");
                                                                PINChangeLog.INSERT;
                                                              END;
                                                               }
    { 10  ;   ;Pin Sent            ;Boolean        }
    { 11  ;   ;IMSI                ;Text250        }
    { 12  ;   ;IMEI                ;Text250        }
    { 13  ;   ;Mobile App Activated;Boolean        }
    { 15  ;   ;Mobile App KYC Login Enabled;Boolean;
                                                   OnValidate=BEGIN

                                                                Vend.GET("Account No.");

                                                                PINChangeLog.INIT;
                                                                PINChangeLog.Date := CURRENTDATETIME;
                                                                PINChangeLog."Account No." := "Account No.";
                                                                PINChangeLog."Account Name" := Vend.Name;
                                                                PINChangeLog."Changed By" := USERID;
                                                                PINChangeLog."Old Value" := FORMAT(xRec."Mobile App KYC Login Enabled");
                                                                PINChangeLog."New Value" := FORMAT("Mobile App KYC Login Enabled");
                                                                PINChangeLog."Field Modified" := 'Mobile App KYC Login Enabled';
                                                                PINChangeLog.INSERT;
                                                              END;
                                                               }
    { 16  ;   ;PIN Encrypted       ;Boolean        }
    { 17  ;   ;Login Attempts Count;Integer        }
    { 18  ;   ;Login Attempts Tag  ;Text30         }
    { 19  ;   ;Login Attempts Action;Text50        }
    { 20  ;   ;Login Attempts Action Expiry;DateTime }
    { 21  ;   ;OTP Attempts Count  ;Integer        }
    { 22  ;   ;OTP Attempts Tag    ;Text30         }
    { 23  ;   ;OTP Attempts Action ;Text50         }
    { 24  ;   ;OTP Attempts Action Expiry;DateTime }
    { 25  ;   ;Reset IMSI          ;Boolean       ;OnValidate=BEGIN

                                                                Vend.GET("Account No.");

                                                                PINChangeLog.INIT;
                                                                PINChangeLog.Date := CURRENTDATETIME;
                                                                PINChangeLog."Account No." := "Account No.";
                                                                PINChangeLog."Account Name" := Vend.Name;
                                                                PINChangeLog."Changed By" := USERID;
                                                                PINChangeLog."Old Value" := FORMAT(xRec."Reset IMSI");
                                                                PINChangeLog."New Value" := FORMAT("Reset IMSI");
                                                                PINChangeLog."Field Modified" := 'Reset IMSI';
                                                                PINChangeLog.INSERT;
                                                              END;
                                                               }
    { 26  ;   ;Clear M-Banking Suspension;Boolean  }
    { 27  ;   ;Member Name         ;Text200       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Vendor.Name WHERE (Transactional Mobile No=FIELD(Mobile No.))) }
    { 28  ;   ;ID No.              ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Vendor."ID No." WHERE (Transactional Mobile No=FIELD(Mobile No.))) }
  }
  KEYS
  {
    {    ;Mobile No.                              ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      PINChangeLog@1000 : Record 51516710;
      Vend@1001 : Record 23;

    BEGIN
    END.
  }
}

