OBJECT page 172159 Revoked  Fixed deposit list
{
  OBJECT-PROPERTIES
  {
    Date=07/23/20;
    Time=[ 3:12:54 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516015;
    SourceTableView=WHERE(Revoked=FILTER(Yes));
    PageType=List;
    CardPageID=Revoked FD Card;
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="FD No";
                Editable=false }

    { 1120054003;2;Field  ;
                SourceExpr="Account No";
                Editable=false }

    { 1120054004;2;Field  ;
                SourceExpr="Account Name";
                Editable=false }

    { 1120054005;2;Field  ;
                SourceExpr="Fd Duration";
                Editable=false }

    { 1120054007;2;Field  ;
                SourceExpr=Amount;
                Editable=false }

    { 1120054008;2;Field  ;
                SourceExpr=InterestRate;
                Editable=false }

    { 1120054006;2;Field  ;
                SourceExpr="ID NO";
                Editable=false }

    { 1120054009;2;Field  ;
                SourceExpr="Creted by";
                Editable=false }

    { 1120054011;2;Field  ;
                SourceExpr="Amount After maturity";
                Editable=false }

    { 1120054012;2;Field  ;
                SourceExpr=Date;
                Editable=false }

    { 1120054013;2;Field  ;
                SourceExpr=MaturityDate;
                Editable=false }

    { 1120054010;2;Field  ;
                SourceExpr="Revoked Date";
                Editable=false }

    { 1120054014;2;Field  ;
                SourceExpr="Revoked Time";
                Editable=false }

    { 1120054015;2;Field  ;
                SourceExpr="Revoked By";
                Editable=false }

  }
  CODE
  {

    BEGIN
    END.
  }
}

