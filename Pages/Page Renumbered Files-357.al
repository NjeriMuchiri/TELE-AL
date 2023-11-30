OBJECT page 50048 HR Applicant Qualifications
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=10:43:41 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    CaptionML=ENU=Applicant Qualifications;
    SaveValues=Yes;
    SourceTable=Table51516105;
    PageType=List;
    ShowFilter=Yes;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                GroupType=Repeater }

    { 1000000001;2;Field  ;
                SourceExpr="Qualification Type";
                Importance=Promoted }

    { 1000000003;2;Field  ;
                SourceExpr="Qualification Code" }

    { 1000000005;2;Field  ;
                SourceExpr="Qualification Description";
                Importance=Promoted }

    { 1000000007;2;Field  ;
                SourceExpr="From Date" }

    { 1000000009;2;Field  ;
                SourceExpr="To Date" }

    { 1000000015;2;Field  ;
                SourceExpr=Type }

    { 1000000011;2;Field  ;
                SourceExpr="Institution/Company";
                Importance=Promoted }

    { 1000000013;2;Field  ;
                SourceExpr="Score ID";
                Importance=Promoted }

  }
  CODE
  {

    BEGIN
    END.
  }
}

