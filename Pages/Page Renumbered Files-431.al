OBJECT page 172026 Guarantor Sub Subform
{
  OBJECT-PROPERTIES
  {
    Date=07/11/18;
    Time=[ 3:27:25 PM];
    Modified=Yes;
    Version List=GuarantorSub Ver1.0;
  }
  PROPERTIES
  {
    SourceTable=Table51516557;
    PageType=ListPart;
    OnAfterGetRecord=BEGIN
                       IF GSubHeader.GET("Document No") THEN BEGIN
                         IF GSubHeader.Status=GSubHeader.Status::Open THEN BEGIN
                         SubPageEditable:=TRUE
                         END ELSE
                         IF GSubHeader.Status<>GSubHeader.Status::Open THEN BEGIN
                         SubPageEditable:=FALSE;
                           END;
                         END;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           IF GSubHeader.GET("Document No") THEN BEGIN
                             IF GSubHeader.Status=GSubHeader.Status::Open THEN BEGIN
                             SubPageEditable:=TRUE
                             END ELSE
                             IF GSubHeader.Status<>GSubHeader.Status::Open THEN BEGIN
                             SubPageEditable:=FALSE;
                               END;
                             END;
                         END;

  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000008;2;Field  ;
                SourceExpr="Substitute Member" }

    { 1000000002;2;Field  ;
                SourceExpr="Loan No." }

    { 1000000003;2;Field  ;
                SourceExpr="Member No" }

    { 1000000004;2;Field  ;
                SourceExpr="Member Name" }

    { 1000000005;2;Field  ;
                SourceExpr="Amount Guaranteed" }

    { 1000000011;2;Field  ;
                SourceExpr="Current Commitment";
                Editable=FALSE }

    { 1000000006;2;Field  ;
                SourceExpr=Substituted;
                Editable=FALSE }

    { 1000000009;2;Field  ;
                SourceExpr="Substitute Member Name";
                Editable=FALSE }

    { 1000000010;2;Field  ;
                SourceExpr="Sub Amount Guaranteed" }

    { 1000000007;2;Field  ;
                SourceExpr="Outstanding Balance" }

    { 1000000012;2;Field  ;
                SourceExpr="Current Shares";
                Editable=FALSE }

  }
  CODE
  {
    VAR
      SubPageEditable@1000000000 : Boolean;
      GSubHeader@1000000001 : Record 51516556;

    BEGIN
    END.
  }
}

