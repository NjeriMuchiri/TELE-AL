OBJECT page 172059 Sky Mobile Setup
{
  OBJECT-PROPERTIES
  {
    Date=10/05/21;
    Time=[ 2:11:49 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    SourceTable=Table51516704;
    PageType=List;
    OnInit=BEGIN
             Permission.RESET;
             Permission.SETRANGE("User ID",USERID);
             Permission.SETRANGE("Sky Mobile Setups",TRUE);
             IF NOT Permission.FINDFIRST THEN
               ERROR('You do not have the following permission: "Sky Mobile Setups"');
           END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 12      ;1   ;Action    ;
                      Name=Update MPESA;
                      OnAction=VAR
                                 Acc@1000 : Code[20];
                                 Phone@1001 : Code[20];
                               BEGIN

                                 Acc:='5000017665000';
                                 Phone:='+254722346758';

                                 Savings.GET(Acc);
                                 Savings."Transactional Mobile No" := Phone;
                                 Savings.Status:=Savings.Status::Closed;
                                 Savings.Blocked:=Savings.Blocked::" ";
                                 Savings.MODIFY;

                                 IF NOT Auth.GET(Phone) THEN BEGIN
                                     Auth.INIT;
                                     Auth."Mobile No." := Phone;
                                     Auth."Account No.":=Acc;
                                     Auth.INSERT;
                                 END;

                                 Auth.RESET;
                                 Auth.SETRANGE("Account No.",Savings."No.");
                                 IF Auth.FINDFIRST THEN BEGIN
                                     //Auth."Mobile No." := Savings."Transactional Mobile No";
                                     //Auth.MODIFY;
                                     Auth.RENAME(Savings."Transactional Mobile No");
                                     SkyMbanking.GenerateNewPin(COPYSTR(Savings."Transactional Mobile No",2,12));
                                 END;
                                 MESSAGE('Updated');
                               END;
                                }
      { 13      ;1   ;Action    ;
                      Name=Reset Pin;
                      OnAction=BEGIN

                                 Savings.GET('5000000127000');
                                 Savings."Transactional Mobile No" := '+254706405989';
                                 Savings.Status:=Savings.Status::Closed;
                                 Savings.Blocked:=Savings.Blocked::" ";
                                 Savings.MODIFY;

                                 Auth.RESET;
                                 Auth.SETRANGE("Account No.",Savings."No.");
                                 IF Auth.FINDFIRST THEN BEGIN
                                     //Auth."Mobile No." := Savings."Transactional Mobile No";
                                     //Auth.MODIFY;
                                     Auth.RENAME(Savings."Transactional Mobile No");
                                     Auth."Reset PIN" := TRUE;
                                     Auth.MODIFY;

                                     SkyMbanking.PinReset;
                                 END;
                                 MESSAGE('Updated');
                               END;
                                }
      { 14      ;1   ;Action    ;
                      Name=Activate Bosa;
                      OnAction=BEGIN

                                 Cust.GET('0019558');
                                 Cust.Status := Cust.Status::Blocked;
                                 Cust.MODIFY;

                                 Savings.GET('5000000127000');
                                 Savings."Registration Date" := 010117D;
                                 Savings.MODIFY;

                                 MESSAGE('Updated');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 22  ;2   ;Field     ;
                SourceExpr=Disable }

    { 7   ;2   ;Field     ;
                SourceExpr="Transaction Type" }

    { 4   ;2   ;Field     ;
                SourceExpr="Vendor Commission Account" }

    { 1120054002;2;Field  ;
                SourceExpr="Vendor Charge Type" }

    { 8   ;2   ;Field     ;
                SourceExpr="Vendor Commission" }

    { 1120054003;2;Field  ;
                SourceExpr="Vendor Staggered Code" }

    { 5   ;2   ;Field     ;
                SourceExpr="Sacco Fee Account" }

    { 1120054000;2;Field  ;
                SourceExpr="Sacco Charge Type" }

    { 9   ;2   ;Field     ;
                SourceExpr="Sacco Fee" }

    { 1120054001;2;Field  ;
                SourceExpr="Sacco Staggered Code" }

    { 10  ;2   ;Field     ;
                SourceExpr="Safaricom Account" }

    { 6   ;2   ;Field     ;
                SourceExpr="Bank Account" }

    { 1120054006;2;Field  ;
                SourceExpr="Network Service Provider" }

    { 11  ;2   ;Field     ;
                SourceExpr="Safaricom Fee";
                Visible=false }

    { 1120054004;2;Field  ;
                SourceExpr="3rd Party Charge Type" }

    { 1120054005;2;Field  ;
                SourceExpr="3rd Party Staggered Code" }

    { 15  ;2   ;Field     ;
                SourceExpr="Pre-Payment Account";
                Visible=false }

    { 16  ;2   ;Field     ;
                SourceExpr="SMS Charge" }

    { 17  ;2   ;Field     ;
                SourceExpr="SMS Account" }

    { 1000000000;2;Field  ;
                SourceExpr="Transaction Limit" }

    { 18  ;2   ;Field     ;
                SourceExpr="Non-Member Debit Account" }

    { 19  ;2   ;Field     ;
                SourceExpr="Daily Limit" }

    { 20  ;2   ;Field     ;
                SourceExpr="Weekly Limit" }

    { 21  ;2   ;Field     ;
                SourceExpr="Monthly Limit" }

  }
  CODE
  {
    VAR
      Savings@1000 : Record 23;
      Auth@1001 : Record 51516709;
      SkyMbanking@1002 : Codeunit 51516701;
      Cust@1003 : Record 51516223;
      Permission@1004 : Record 51516702;

    BEGIN
    END.
  }
}

