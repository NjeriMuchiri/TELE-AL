OBJECT page 17361 Membership App Signatories
{
  OBJECT-PROPERTIES
  {
    Date=05/04/22;
    Time=[ 2:27:44 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516222;
    PageType=Card;
    CardPageID=Membership App Signatories;
    OnOpenPage=BEGIN
                 MemberApp.RESET;
                 MemberApp.SETRANGE(MemberApp."No.","Account No");
                 IF MemberApp.FIND('-') THEN BEGIN
                  IF MemberApp.Status=MemberApp.Status::Approved THEN BEGIN
                   CurrPage.EDITABLE:=FALSE;
                  END ELSE
                   CurrPage.EDITABLE:=TRUE;
                 END;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102760015;1 ;ActionGroup;
                      CaptionML=ENU=Signatory }
      { 1102760016;2 ;Action    ;
                      Name=Page Account Signatories Card;
                      CaptionML=ENU=Card;
                      RunObject=page 17361;
                      RunPageLink=Account No=FIELD(Account No),
                                  Names=FIELD(Names);
                      Image=EditLines }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 1102760001;2;Field  ;
                SourceExpr=Names }

    { 1102760007;2;Field  ;
                SourceExpr="ID No.";
                OnValidate=BEGIN
                             CUST.RESET;
                             CUST.SETRANGE(CUST."ID No.","ID No.");
                             IF CUST.FIND('-')  THEN BEGIN
                             "BOSA No.":=CUST."No.";
                             MODIFY;
                             END;
                           END;
                            }

    { 1102760005;2;Field  ;
                CaptionML=ENU=Staff/Payroll No;
                SourceExpr="Staff/Payroll" }

    { 1102760003;2;Field  ;
                SourceExpr="Date Of Birth" }

    { 1102760009;2;Field  ;
                SourceExpr=Signatory }

    { 1102760011;2;Field  ;
                SourceExpr="Must Sign" }

    { 1102760013;2;Field  ;
                SourceExpr="Must be Present" }

    { 1102760017;2;Field  ;
                SourceExpr="Expiry Date" }

    { 1102755000;2;Field  ;
                SourceExpr="Account No" }

    { 1102755001;2;Field  ;
                SourceExpr="BOSA No.";
                Editable=FALSE }

    { 1102755002;2;Field  ;
                SourceExpr="Email Address" }

  }
  CODE
  {
    VAR
      MemberApp@1102755000 : Record 51516220;
      ReltnShipTypeEditable@1102755001 : Boolean;
      CUST@1102755002 : Record 51516223;

    BEGIN
    END.
  }
}

