OBJECT page 172073 Mbanking Receipt Line
{
  OBJECT-PROPERTIES
  {
    Date=11/23/20;
    Time=12:48:27 PM;
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    SourceTable=Table51516716;
    PageType=ListPart;
    RefreshOnActivate=Yes;
    OnInit=BEGIN
             //"Account Type":="Account Type"::Customer;
           END;

    OnOpenPage=BEGIN
                 //"Account Type":="Account Type"::Customer;
               END;

    OnNewRecord=BEGIN
                  //"Account Type":="Account Type"::Customer;
                END;

    OnInsertRecord=BEGIN
                     //"Account Type":="Account Type"::Customer;
                   END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                GroupType=Repeater }

    { 9   ;2   ;Field     ;
                SourceExpr="Account Type";
                Editable=TRUE;
                OnValidate=BEGIN
                             //"Account Type":="Account Type"::Customer;
                           END;
                            }

    { 8   ;2   ;Field     ;
                SourceExpr="Account No." }

    { 7   ;2   ;Field     ;
                SourceExpr="Account Name" }

    { 6   ;2   ;Field     ;
                SourceExpr=Description }

    { 10  ;2   ;Field     ;
                SourceExpr="Loan Type Code" }

    { 2   ;2   ;Field     ;
                SourceExpr="Loan No" }

    { 11  ;2   ;Field     ;
                SourceExpr="Loan Type Name";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                SourceExpr="Transaction Type" }

    { 1   ;2   ;Field     ;
                SourceExpr=Amount }

  }
  CODE
  {

    BEGIN
    END.
  }
}

