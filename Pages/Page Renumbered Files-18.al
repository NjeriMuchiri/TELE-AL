OBJECT page 20382 Coop Reconcillation Header Car
{
  OBJECT-PROPERTIES
  {
    Date=03/24/23;
    Time=[ 3:23:53 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table170067;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1120054012;  ;ActionContainer;
                      Name=Import;
                      ActionContainerType=NewDocumentItems }
      { 1120054013;1 ;Action    ;
                      CaptionML=ENU=Import Coop Records;
                      RunObject=XMLport 170069;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      PromotedCategory=Category5 }
      { 1120054014;1 ;Action    ;
                      Name=Reconcile;
                      CaptionML=ENU=Reconcile;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Action;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 CoopATMTransaction@1120054000 : Record 170041;
                                 CoopReconcillationtrans@1120054001 : Record 170066;
                                 CoopReconcilationHeader@1120054002 : Record 170067;
                               BEGIN
                                 CoopATMTransaction.RESET;
                                 CoopATMTransaction.SETRANGE(CoopATMTransaction."Reconcillation Header",CoopReconcilationHeader."No.");
                                 IF FINDFIRST THEN BEGIN
                                   REPEAT
                                     CoopReconcillationtrans.RESET;
                                     CoopReconcillationtrans.SETRANGE(CoopReconcillationtrans."Document No.",CoopATMTransaction."Document No.");
                                     IF CoopReconcillationtrans.FINDFIRST THEN BEGIN
                                       CoopReconcillationtrans.Reconcilled :=TRUE;
                                       CoopATMTransaction.Reconcilled := TRUE;
                                       END;
                                   UNTIL CoopATMTransaction.NEXT =0;
                                 END;
                               END;
                                }
      { 1120054015;1 ;Action    ;
                      Name=Reverse;
                      CaptionML=ENU=Reverse;
                      OnAction=VAR
                                 CoopProcessing@1120054000 : Codeunit 2000008;
                                 CT@1120054001 : Record 170041;
                               BEGIN
                                 // CoopProcessing.FundsTransfer(
                                 // CoopProcessing.FundsTransfer(CT."Transaction ID",CT."Document No.",CT."Service Name",CT."Foreign Amount",CT."Transaction Date",
                                 // CT."Transaction Time",CT.Channel,CT."Transaction Type",CT."Terminal Code",CT."Document No.",CT."Transaction Name",CT."Description 1",CT."Original Transaction ID"
                                 //
                                 //
                                 // ServiceName - Service Name
                                 // RequestReference - Document No.
                                 // TransactionDate - Transaction Date
                                 // TerminalID -
                                 // Channel - Channel
                                 // ConnectionMode
                                 // TransactionType - Transaction Type
                                 // OriginalMessageID - Original Transaction ID
                                 // InstitutionCode - Institution Code
                                 // InstitutionName Institution Name
                                 // TransactionAmount - Amount
                                 // Currency - Amount Currency
                                 // DebitAccount - Member Account
                                 // CreditAccount - Sacco Account
                                 // ChargeAmount - Commission
                                 // ChargeCurrency - Commission Currency
                                 // FeeAmount - Fee Charged
                                 // FeeCurrency - Fee Currency
                                 // Narrative1 - Description 1
                                 // Narrative2 - Description 2
                                 // deviceType - Device Type
                                 // location - location
                                 // conversionRate
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1120054002;2;Field  ;
                SourceExpr="No." }

    { 1120054003;2;Field  ;
                SourceExpr="Reconcillation Date" }

    { 1120054004;2;Field  ;
                SourceExpr="No. Series" }

    { 1120054005;2;Field  ;
                SourceExpr="Reconcilled By" }

    { 1120054006;2;Field  ;
                SourceExpr=Status }

    { 1120054007;2;Field  ;
                SourceExpr="Rec.   Start Date" }

    { 1120054008;2;Field  ;
                SourceExpr="Rec.   End Date" }

    { 1120054009;1;Group  ;
                GroupType=Group }

    { 1120054010;2;Part   ;
                SubPageLink=Reconcillation Header=FIELD(No.);
                PagePartID=Page170069;
                PartType=Page }

    { 1120054011;2;Part   ;
                PagePartID=Page170071;
                PartType=Page }

  }
  CODE
  {

    BEGIN
    END.
  }
}

