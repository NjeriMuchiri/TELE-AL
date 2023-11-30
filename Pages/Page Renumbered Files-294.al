OBJECT page 17485 BOSA Transfer Sched
{
  OBJECT-PROPERTIES
  {
    Date=08/19/21;
    Time=11:20:05 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516265;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102760000;1;Group  ;
                GroupType=Repeater }

    { 1102760014;2;Field  ;
                CaptionML=ENU=Account Type;
                SourceExpr="Source Type" }

    { 1102760001;2;Field  ;
                CaptionML=ENU=Account to Debit(BOSA);
                SourceExpr="Source Account No." }

    { 1102760003;2;Field  ;
                SourceExpr="Source Account Name" }

    { 1102755000;2;Field  ;
                SourceExpr="Transaction Type" }

    { 1120054000;2;Field  ;
                Name=Transfer Type;
                CaptionML=ENU=Transfer Type;
                SourceExpr="Type of Transfer";
                ShowMandatory=true }

    { 1102755002;2;Field  ;
                SourceExpr=Loan }

    { 1102760009;2;Field  ;
                SourceExpr=Amount }

    { 1102760005;2;Field  ;
                SourceExpr="Destination Account Type" }

    { 1102760007;2;Field  ;
                SourceExpr="Destination Account No." }

    { 1102760016;2;Field  ;
                SourceExpr="Destination Account Name" }

    { 1102755006;2;Field  ;
                SourceExpr="Destination Loan" }

    { 1000000000;2;Field  ;
                SourceExpr="Destination Type" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

