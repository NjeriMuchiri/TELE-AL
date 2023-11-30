OBJECT page 50049 HR Applicant Referees
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=10:51:21 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516210;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                GroupType=Repeater }

    { 1000000001;2;Field  ;
                SourceExpr=Names }

    { 1000000003;2;Field  ;
                SourceExpr=Designation }

    { 1000000005;2;Field  ;
                SourceExpr=Institution }

    { 1000000007;2;Field  ;
                SourceExpr=Address }

    { 1000000009;2;Field  ;
                SourceExpr="Telephone No" }

    { 1000000011;2;Field  ;
                SourceExpr="E-Mail" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

