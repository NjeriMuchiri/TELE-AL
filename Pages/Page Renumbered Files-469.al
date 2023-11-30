OBJECT page 172064 Sky Update Paybill ID
{
  OBJECT-PROPERTIES
  {
    Date=04/13/23;
    Time=[ 2:36:38 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
    SourceTable=Table51516712;
    SourceTableView=WHERE(Posted=CONST(No));
    PageType=Card;
    OnInit=BEGIN
             StatusChangePermissions.RESET;
             StatusChangePermissions.SETRANGE("User ID",USERID);
             StatusChangePermissions.SETRANGE("Update Paybill Transaction",TRUE);
             IF NOT StatusChangePermissions.FINDFIRST THEN
               ERROR('You do not have the following permission: "Update Paybill Transaction"');
           END;

    ActionList=ACTIONS
    {
      { 8       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;Action    ;
                      Name=Retry;
                      OnAction=BEGIN
                                 IF CONFIRM('Are you sure you want to retry posting this transaction') THEN BEGIN
                                     "Needs Change" := FALSE;
                                     MODIFY;
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                SourceExpr="Transaction ID";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                SourceExpr="Transaction Date";
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                SourceExpr="Transaction Time";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                SourceExpr=Amount;
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                SourceExpr="Line Amount";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                Name=Member ID/Phone/Acc. No;
                SourceExpr="Member Account";
                OnValidate=VAR
                             KeyWord@1000 : Code[10];
                             KeyFound@1001 : Boolean;
                             ProductFactory@1002 : Record 51516717;
                             AccountNo@1003 : Code[20];
                             SavingsProduct@1004 : Code[20];
                             MemberID@1005 : Code[20];
                             LoanNo@1006 : Code[20];
                             Loans@1007 : Record 51516230;
                             GLAccount@1120054000 : Record 15;
                             GLAccountNo@1120054001 : Code[20];
                           BEGIN
                             IF GLAccount.GET("Member Account") THEN BEGIN
                               "Needs Change" := FALSE;
                               "Changed By":=USERID;
                               "Date Changed":=TODAY;
                               "Changed By":=USERID;
                             //   MODIFY;
                               MESSAGE('Paybill updated Sucessfully');
                               EXIT;
                             END;
                             AccountNo := "Member Account";

                             KeyWord := '';
                             KeyFound := FALSE;
                             ProductFactory.RESET;
                             ProductFactory.SETRANGE("Product Class Type",ProductFactory."Product Class Type"::Savings);
                             ProductFactory.SETFILTER("Key Word",'<>%1','');
                             IF ProductFactory.FINDFIRST THEN BEGIN
                                 REPEAT
                                     KeyWord := ProductFactory."Key Word";

                                     IF COPYSTR(AccountNo,1,STRLEN(KeyWord)) = KeyWord THEN BEGIN
                                         AccountNo := COPYSTR(AccountNo,(STRLEN(KeyWord)+1),STRLEN(AccountNo));
                                         KeyFound := TRUE;
                                         SavingsProduct := ProductFactory."Product ID";
                                     END;

                                 UNTIL (ProductFactory.NEXT = 0) OR (KeyFound);
                             END;

                             MemberID := '';
                             Savings.RESET;
                             Savings.SETRANGE("ID No.",AccountNo);
                             IF Savings.FINDFIRST THEN BEGIN
                               //MESSAGE('%1',Savings.COUNT);
                                 MemberID := Savings."ID No.";
                                 AccountNo := Savings."No.";

                             END;

                             IF MemberID ='' THEN
                               MemberID := CREATEGUID;



                             Savings.RESET;
                             Savings.SETRANGE("ID No.",MemberID);
                             IF (Savings.FINDFIRST) AND (MemberID<>'') THEN BEGIN
                                 IF CONFIRM(Savings.Name+'\ Confirm Member?') THEN BEGIN
                                     "Needs Change" := FALSE;
                                     "Changed By":=USERID;
                                     "Date Changed":=TODAY;
                                     "Changed By":=USERID;
                                     MODIFY;
                             //         SkyMbanking.PostMpesaTransaction("Transaction ID")
                                 END
                                 ELSE
                                     ERROR('Aborted');
                             END
                             ELSE BEGIN
                                 Savings.RESET;
                                 Savings.SETRANGE("Transactional Mobile No","Member Account");
                                 IF Savings.FINDFIRST THEN BEGIN
                                     IF CONFIRM(Savings.Name+'\ Confirm Member?') THEN BEGIN
                                         "Needs Change" := FALSE;
                                         "Changed By":=USERID;
                                         "Date Changed":=TODAY;
                                         "Changed By":=USERID;
                                         MODIFY;
                             //             SkyMbanking.PostMpesaTransaction("Transaction ID")
                                     END
                                     ELSE
                                         ERROR('Aborted');
                                 END
                                 ELSE BEGIN

                                     IF (COPYSTR(AccountNo,1,4) = 'LOAN') OR Loans.GET(AccountNo) THEN BEGIN


                                         IF Loans.GET(AccountNo) THEN
                                           LoanNo := Loans."Loan  No."
                                         ELSE
                                             LoanNo := COPYSTR(AccountNo,5,STRLEN(AccountNo));



                                         IF Loans.GET(LoanNo) THEN BEGIN

                                             Savings.RESET;
                                             Savings.SETRANGE("No.",Loans."Account No");
                                             IF Savings.FINDFIRST THEN BEGIN
                                                 Loans.CALCFIELDS("Outstanding Balance",Loans."Oustanding Interest");
                                                 IF CONFIRM(Savings.Name+'\Loan Product: '+Loans."Loan Product Type"+
                                                     '\Loan Balance: '+FORMAT(Loans."Outstanding Balance"+Loans."Oustanding Interest")+'\ Confirm Member?') THEN BEGIN
                                                     "Needs Change" := FALSE;
                                                     "Transaction Type" := "Transaction Type"::"Loan Repayment";
                                                     Description := 'Loan Repayment';
                                                     "Changed By":=USERID;
                                                     "Date Changed":=TODAY;
                                                     "Changed By":=USERID;

                                                     "Member Account":=Savings."No.";
                                                     "Loan No." := Loans."Loan  No.";
                                                     "Loan Product" := Loans."Loan Product Type";
                                                     MODIFY;
                                                 END
                                                 ELSE
                                                     ERROR('Aborted');

                                             END
                                             ELSE BEGIN


                                                 Savings.RESET;
                                                 Savings.SETRANGE(Savings."BOSA Account No",Loans."Account No");
                                                 Savings.SETRANGE(Savings."Account Type",'ORDINARY');
                                                 IF Savings.FINDFIRST THEN BEGIN
                                                     Loans.CALCFIELDS("Outstanding Balance",Loans."Oustanding Interest");
                                                     IF CONFIRM(Savings.Name+'\Loan Product: '+Loans."Loan Product Type"+
                                                         '\Loan Balance: '+FORMAT(Loans."Outstanding Balance"+Loans."Oustanding Interest")+'\ Confirm Member?') THEN BEGIN
                                                         "Needs Change" := FALSE;
                                                         "Transaction Type" := "Transaction Type"::"Loan Repayment";
                                                         Description := 'Loan Repayment';
                                                         "Changed By":=USERID;
                                                         "Date Changed":=TODAY;
                                                         "Changed By":=USERID;

                                                         "Member Account":=Savings."No.";
                                                         "Loan No." := Loans."Loan  No.";
                                                         "Loan Product" := Loans."Loan Product Type";
                                                         MODIFY;
                                                     END
                                                     ELSE
                                                         ERROR('Aborted');

                                                 END

                                                 ELSE
                                                     ERROR('Member/Loan Does not Exist');
                                             END
                                         END
                                         ELSE
                                           ERROR('Member/Loan Does not Exist');

                                     END
                                     ELSE
                                         ERROR('Member/Loan Does not Exist');
                                 END;





                                IF (COPYSTR(AccountNo,1,4) = 'TENDER') OR GLAccount.GET(AccountNo) THEN BEGIN


                                         IF GLAccount.GET(AccountNo) THEN
                                           //GLAccount := GLAccount."No."

                                             GLAccountNo := COPYSTR(AccountNo,5,STRLEN(AccountNo));



                                         IF GLAccount.GET(GLAccountNo) THEN BEGIN
                                         END;
                                 END;

                             END;

                             //CALCFIELDS("Line Amount");
                             //IF "Line Amount" <> Amount THEN
                               //  ERROR('Allocation MUST be equal to Paybill Amount');
                           END;
                            }

    { 10  ;1   ;Part      ;
                SubPageLink=Receipt No.=FIELD(Transaction ID);
                PagePartID=Page51516718;
                Visible=FALSE;
                PartType=Page }

  }
  CODE
  {
    VAR
      StatusChangePermissions@1000 : Record 51516702;
      Savings@1001 : Record 23;
      SkyMbanking@1120054000 : Codeunit 51516701;

    BEGIN
    END.
  }
}

