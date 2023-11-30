OBJECT page 172072 Update PIN Change
{
  OBJECT-PROPERTIES
  {
    Date=02/15/23;
    Time=[ 5:24:28 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    SourceTable=Table51516709;
    PageType=Card;
    OnInit=BEGIN
             StatusChangePermissions.RESET;
             StatusChangePermissions.SETRANGE("Reset Mpesa Pin",TRUE);
             IF NOT StatusChangePermissions.FINDFIRST THEN BEGIN
                 ERROR('You do not have the following permission: "Reset Mpesa Pin"');
             END;
           END;

    OnClosePage=VAR
                  SaccoSetup@1120054000 : Record 51516700;
                  SkyworldUSSDAuth@1120054001 : Record 51516709;
                  Priority@1120054002 : Integer;
                  NewPin@1120054003 : Text;
                  RandomPIN@1120054004 : Text;
                  SavAcc@1120054005 : Record 23;
                  Msg@1120054006 : Text;
                BEGIN
                  SkyMbanking.PinReset;
                  IMSIReset();

                  IF "Clear M-Banking Suspension" THEN BEGIN
                    SkyAuth.RESET;
                    SkyAuth.SETRANGE("Mobile No.", "Mobile No.");
                    IF(SkyAuth.FIND('-')) THEN BEGIN
                      SkyAuth."Login Attempts Action" := 'NONE';
                      SkyAuth."Login Attempts Tag" := '';
                      CLEAR(SkyAuth."Login Attempts Action Expiry");
                      SkyAuth."Login Attempts Count" := 0;
                      SkyAuth."OTP Attempts Action" := 'NONE';
                      SkyAuth."OTP Attempts Tag" := '';
                      CLEAR(SkyAuth."OTP Attempts Action Expiry");
                      SkyAuth."OTP Attempts Count" := 0;
                      SkyAuth."Clear M-Banking Suspension" := FALSE;
                      SkyAuth.MODIFY;
                      SkyAuth.RESET;
                    END;
                  END;
                END;

    ActionList=ACTIONS
    {
      { 1120054002;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054001;1 ;Action    ;
                      Name=Reset IMEI;
                      Visible=false;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to reset the IMEI Code?') THEN BEGIN
                                     IMEI := '';
                                     MODIFY;
                                     MESSAGE('Reset Successful');
                                 END;
                               END;
                                }
      { 1120054000;1 ;Action    ;
                      Name=Reset IMSI;
                      Visible=false;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to reset the IMSI Code?') THEN BEGIN
                                     IMSI := '';
                                     MODIFY;
                                     MESSAGE('Reset Successful');
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                SourceExpr="Mobile No.";
                Editable=false }

    { 4   ;2   ;Field     ;
                SourceExpr="Account No." }

    { 5   ;2   ;Field     ;
                SourceExpr="User Status" }

    { 6   ;2   ;Field     ;
                SourceExpr="Reset PIN";
                OnValidate=BEGIN
                             IF "Reset PIN" THEN
                                 IF NOT CONFIRM('Are you sure you want to Send Pin Reset to this Account?') THEN
                                       ERROR('Aborted');
                           END;
                            }

    { 7   ;2   ;Field     ;
                SourceExpr="Force PIN";
                Editable=false }

    { 10  ;2   ;Field     ;
                SourceExpr="Mobile App KYC Login Enabled";
                OnValidate=BEGIN
                             IF "Mobile App KYC Login Enabled" THEN
                                 IF NOT CONFIRM('Are you sure you want to enable Mobile App KYC Login?') THEN
                                       ERROR('Aborted');
                           END;
                            }

    { 9   ;2   ;Field     ;
                SourceExpr="Reset IMSI";
                OnValidate=BEGIN
                             IF "Reset IMSI" THEN
                                 IF NOT CONFIRM('Are you sure you want to Reset IMSI for this Account?') THEN
                                       ERROR('Aborted');
                           END;
                            }

    { 1120054003;2;Field  ;
                SourceExpr="Clear M-Banking Suspension";
                OnValidate=BEGIN
                             IF "Clear M-Banking Suspension" THEN
                                 IF NOT CONFIRM('Are you sure you want to "Clear M-Banking Suspension" for this Account?') THEN
                                       ERROR('Aborted');
                           END;
                            }

  }
  CODE
  {
    VAR
      StatusChangePermissions@1000 : Record 51516702;
      SkyMbanking@1001 : Codeunit 51516701;
      SkyAuth@1120054000 : Record 51516709;

    PROCEDURE IMSIReset@35() ResetStatus : Text;
    VAR
      SkyworldUSSDAuth@1003 : Record 51516709;
      NewPin@1000 : Text;
      NewIntPin@1001 : Integer;
      SavAcc@1002 : Record 23;
      Msg@1004 : Text;
    BEGIN

      SkyworldUSSDAuth.RESET;
      SkyworldUSSDAuth.SETRANGE(SkyworldUSSDAuth."Reset IMSI",TRUE);
      IF SkyworldUSSDAuth.FINDFIRST THEN BEGIN
          REPEAT
              SavAcc.RESET;
              SavAcc.SETRANGE("Transactional Mobile No",SkyworldUSSDAuth."Mobile No.");
              IF SavAcc.FINDFIRST THEN BEGIN
                  SkyworldUSSDAuth.IMSI:='';
                  SkyworldUSSDAuth."Reset IMSI" := FALSE;
                  SkyworldUSSDAuth.MODIFY;
              END;
          UNTIL SkyworldUSSDAuth.NEXT=0;
      END;
    END;

    BEGIN
    END.
  }
}

