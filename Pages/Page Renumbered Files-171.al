OBJECT page 17362 Membership App Kin Details
{
  OBJECT-PROPERTIES
  {
    Date=07/06/23;
    Time=12:27:42 PM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516221;
    PageType=List;
    OnOpenPage=BEGIN

                 MemberApp.RESET;
                 MemberApp.SETRANGE(MemberApp."No.","Account No");
                 IF MemberApp.FIND('-') THEN BEGIN
                  IF MemberApp.Status=MemberApp.Status::Approved THEN BEGIN                        //MESSAGE(FORMAT(MemberApp.Status));
                   CurrPage.EDITABLE:=FALSE;
                  END ELSE
                   CurrPage.EDITABLE:=TRUE;
                 END;
                 "Maximun Allocation %":=100;
               END;

    OnAfterGetRecord=BEGIN
                       "Maximun Allocation %":=100;
                     END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 1000000000;2;Field  ;
                SourceExpr=Type }

    { 3   ;2   ;Field     ;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                SourceExpr=Relationship;
                Editable=true }

    { 5   ;2   ;Field     ;
                SourceExpr=Beneficiary }

    { 7   ;2   ;Field     ;
                SourceExpr=Address }

    { 8   ;2   ;Field     ;
                SourceExpr=Telephone }

    { 12  ;2   ;Field     ;
                SourceExpr="ID No." }

    { 13  ;2   ;Field     ;
                SourceExpr="%Allocation" }

  }
  CODE
  {
    VAR
      MemberApp@1102755000 : Record 51516220;
      ReltnShipTypeEditable@1102755001 : Boolean;

    BEGIN
    END.
  }
}

