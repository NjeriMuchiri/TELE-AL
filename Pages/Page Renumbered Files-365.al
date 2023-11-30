OBJECT page 50056 HR Applicants UnQualified Card
{
  OBJECT-PROPERTIES
  {
    Date=04/23/20;
    Time=[ 1:57:18 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SourceTable=Table51516209;
    SourceTableView=WHERE(Qualification Status=FILTER(UnQualified));
    PageType=Card;
  }
  CONTROLS
  {
    { 13  ;0   ;Container ;
                ContainerType=ContentArea }

    { 12  ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 11  ;2   ;Field     ;
                SourceExpr="Application No" }

    { 10  ;2   ;Field     ;
                SourceExpr="First Name" }

    { 9   ;2   ;Field     ;
                SourceExpr="Middle Name" }

    { 8   ;2   ;Field     ;
                SourceExpr="Last Name" }

    { 7   ;2   ;Field     ;
                SourceExpr="Job Applied For" }

    { 6   ;2   ;Field     ;
                SourceExpr=Qualified }

    { 5   ;2   ;Field     ;
                SourceExpr="Date of Interview" }

    { 4   ;2   ;Field     ;
                SourceExpr="From Time" }

    { 3   ;2   ;Field     ;
                SourceExpr="To Time" }

    { 2   ;2   ;Field     ;
                SourceExpr=Venue }

    { 1   ;2   ;Field     ;
                SourceExpr="Interview Type" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

