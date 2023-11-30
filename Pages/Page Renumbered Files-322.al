OBJECT page 50013 Tracker list
{
  OBJECT-PROPERTIES
  {
    Date=05/12/16;
    Time=[ 4:44:05 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516282;
    SourceTableView=SORTING(Staff/Payroll No)
                    ORDER(Ascending)
                    WHERE(Multiple Receipts=FILTER(<>2));
    PageType=List;
    CardPageID=Tracker Applications;
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr="Staff/Payroll No" }

    { 1000000016;2;Field  ;
                SourceExpr="Employer Code" }

    { 1000000003;2;Field  ;
                SourceExpr=Generated }

    { 1000000004;2;Field  ;
                SourceExpr="Multiple Receipts" }

    { 1000000005;2;Field  ;
                SourceExpr=Name }

    { 1000000017;2;Field  ;
                SourceExpr="Date Filter" }

    { 1000000018;2;Field  ;
                SourceExpr="Transaction Date" }

    { 1000000006;2;Field  ;
                SourceExpr=Gnumber }

    { 1000000007;2;Field  ;
                SourceExpr=Userid1 }

    { 1000000008;2;Field  ;
                SourceExpr="Loans Not found" }

    { 1000000009;2;Field  ;
                SourceExpr="Interest Balance" }

    { 1000000010;0;Container;
                ContainerType=FactBoxArea }

    { 1000000011;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

    { 1000000012;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

    { 1000000013;1;Part   ;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1000000014;1;Part   ;
                PartType=System;
                SystemPartID=MyNotes }

    { 1000000015;1;Part   ;
                PartType=Chart;
                ChartPartID=CYRUS TEST FOSA }

  }
  CODE
  {

    BEGIN
    END.
  }
}

