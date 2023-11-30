OBJECT page 50019 Appeal Batches - List
{
  OBJECT-PROPERTIES
  {
    Date=05/24/16;
    Time=11:10:42 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516236;
    PageType=List;
    CardPageID=Appeal batches Card;
  }
  CONTROLS
  {
    { 1000000007;0;Container;
                ContainerType=ContentArea }

    { 1000000006;1;Group  ;
                GroupType=Repeater }

    { 1000000005;2;Field  ;
                SourceExpr="Batch No.";
                Editable=FALSE }

    { 1000000004;2;Field  ;
                SourceExpr=Source }

    { 1000000003;2;Field  ;
                SourceExpr="Description/Remarks" }

    { 1000000002;2;Field  ;
                SourceExpr="Posting Date" }

    { 1000000001;2;Field  ;
                SourceExpr="No of Appeal Loans";
                Editable=FALSE }

    { 1000000000;2;Field  ;
                SourceExpr="Mode Of Disbursement";
                Editable=TRUE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

