OBJECT page 172157 posted Fixed deposit list
{
  OBJECT-PROPERTIES
  {
    Date=11/09/18;
    Time=[ 1:46:58 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516015;
    SourceTableView=WHERE(Posted=FILTER(Yes),
                          matured=FILTER(Yes));
    PageType=List;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="FD No" }

    { 1120054003;2;Field  ;
                SourceExpr="Account No" }

    { 1120054004;2;Field  ;
                SourceExpr="Account Name" }

    { 1120054005;2;Field  ;
                SourceExpr="Fd Duration" }

    { 1120054007;2;Field  ;
                SourceExpr=Amount }

    { 1120054008;2;Field  ;
                SourceExpr=InterestRate }

    { 1120054006;2;Field  ;
                SourceExpr="ID NO" }

    { 1120054009;2;Field  ;
                SourceExpr="Creted by" }

    { 1120054011;2;Field  ;
                SourceExpr="Amount After maturity" }

    { 1120054012;2;Field  ;
                SourceExpr=Date }

    { 1120054013;2;Field  ;
                SourceExpr=MaturityDate }

    { 1120054014;2;Field  ;
                SourceExpr=Posted;
                Enabled=false }

    { 1120054015;2;Field  ;
                SourceExpr=matured }

    { 1120054018;2;Field  ;
                SourceExpr="Posted Date";
                Editable=false }

    { 1120054019;2;Field  ;
                SourceExpr="posted time";
                Editable=false }

  }
  CODE
  {

    BEGIN
    END.
  }
}

