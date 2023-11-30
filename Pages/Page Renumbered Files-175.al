OBJECT page 17366 Members Statistics
{
  OBJECT-PROPERTIES
  {
    Date=07/06/23;
    Time=11:00:16 AM;
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516223;
    PageType=Card;
    OnOpenPage=VAR
                 UserSetup@1120054000 : Record 91;
               BEGIN
                 UserSetup.GET(USERID);
                 Administration := UserSetup.Administration;
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755000;1;Group  ;
                CaptionML=ENU=General }

    { 1102755004;2;Field  ;
                CaptionML=ENU=Share Capital;
                SourceExpr="Shares Retained" }

    { 1120054001;2;Field  ;
                SourceExpr="Current Savings" }

    { 1102755008;2;Field  ;
                CaptionML=ENU=Deposits;
                SourceExpr="Current Shares" }

    { 1102755010;2;Field  ;
                SourceExpr="Outstanding Balance" }

    { 1102755003;2;Field  ;
                SourceExpr="Benevolent Fund" }

    { 1102755005;2;Field  ;
                SourceExpr="Un-allocated Funds" }

    { 1102755001;2;Field  ;
                SourceExpr="Registration Fee Paid" }

    { 1   ;2   ;Field     ;
                SourceExpr="Principle Unallocated" }

    { 2   ;2   ;Field     ;
                SourceExpr="Interest Unallocated" }

    { 1120054000;2;Field  ;
                SourceExpr="Insurance Fund" }

    { 1102755011;2;Field  ;
                SourceExpr="Insurance Contribution";
                Visible=FALSE;
                Editable=FALSE }

    { 1000000000;2;Field  ;
                SourceExpr="Monthly Contribution" }

    { 1000000001;2;Field  ;
                SourceExpr="School Fees Shares" }

    { 1000000002;2;Field  ;
                SourceExpr="Monthly Sch.Fees Cont." }

    { 1120054004;2;Field  ;
                CaptionML=ENU=BBF Contribution;
                SourceExpr=BBF }

    { 1102755016;2;Field  ;
                SourceExpr="Dividend Amount";
                Visible=TRUE;
                Editable=FALSE }

    { 1120054003;2;Field  ;
                SourceExpr="Co-operative Shares" }

    { 1102755002;1;Part   ;
                SubPageLink=Client Code=FIELD(No.);
                PagePartID=Page51516250;
                PartType=Page }

    { 1120054002;1;Part   ;
                SubPageLink=Client Code=FIELD(No.);
                PagePartID=Page51516044;
                Visible=Administration;
                PartType=Page }

  }
  CODE
  {
    VAR
      Administration@1120054000 : Boolean;

    BEGIN
    END.
  }
}

