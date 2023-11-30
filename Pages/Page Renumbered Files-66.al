OBJECT page 20430 CloudPESA Paybill Imports
{
  OBJECT-PROPERTIES
  {
    Date=08/07/19;
    Time=[ 4:42:23 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Editable=No;
    SourceTable=Table51516654;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1120054016;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054018;1 ;ActionGroup }
      { 1120054020;1 ;Action    ;
                      Name=Import cloud pesa;
                      Promoted=Yes;
                      Image=Import;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Paybill@1120054000 : Record 51516654;
                               BEGIN

                                 XMLPORT.RUN(51516017);
                               END;
                                }
      { 1120054019;1 ;Action    ;
                      Name=Clear;
                      Promoted=Yes;
                      Image=Default;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Paybill@1120054000 : Record 51516654;
                               BEGIN
                                 fnClearTble(Paybill);
                               END;
                                }
      { 1120054015;1 ;Action    ;
                      Name=Transfer;
                      Promoted=Yes;
                      Image=Post;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 PaybillBuffer@1120054000 : Record 51516654;
                                 MPESAPAYBILL@1120054001 : Record 51516098;
                                 AccountSplit@1120054002 : Text;
                                 AccountFinal@1120054003 : Text;
                                 TextTosplit@1120054004 : Text;
                                 stringAcc@1120054005 : Decimal;
                                 newString@1120054006 : Text;
                                 newDate@1120054007 : Text;
                                 finalDate@1120054008 : Text;
                                 Vardecimal@1120054009 : Decimal;
                                 myDate@1120054010 : Decimal;
                                 myMonth@1120054011 : Decimal;
                                 myYear@1120054012 : Decimal;
                                 LastDate@1120054013 : Date;
                               BEGIN
                                 PaybillBuffer.RESET;
                                 PaybillBuffer.SETRANGE(PaybillBuffer."Linked Transaction ID",'');
                                 IF PaybillBuffer.FIND('-')THEN BEGIN
                                   REPEAT
                                     MPESAPAYBILL.RESET;
                                     MPESAPAYBILL.SETRANGE(MPESAPAYBILL."Document No", PaybillBuffer."Receipt No.");
                                     IF MPESAPAYBILL.FIND('-')=FALSE THEN BEGIN

                                    TextTosplit:=PaybillBuffer.Details;
                                     Part1 := SplitString(TextTosplit,'Acc.');
                                     stringAcc:=STRLEN(Part1+'Acc.  ');
                                     Part2:=COPYSTR(TextTosplit,stringAcc,100);

                                     newString:=PaybillBuffer."Completion Time";
                                     newDate:=SplitString(newString,' ');

                                      finalDate:= DELCHR(newDate,'=',DELCHR(newDate,'=','1234567890'));

                                 //31082018
                                 //MESSAGE(finalDate);
                                 IF(STRLEN(finalDate)>7) THEN BEGIN
                                      EVALUATE(myDate,COPYSTR(finalDate,1,2));
                                      EVALUATE(myMonth,COPYSTR(finalDate,3,2));
                                      EVALUATE(myYear,COPYSTR(finalDate,5,8));
                                 END ELSE BEGIN
                                   EVALUATE(myDate,COPYSTR(finalDate,1,2));
                                      EVALUATE(myMonth,COPYSTR(finalDate,3,2));
                                      EVALUATE(myYear,'20'+COPYSTR(finalDate,4,8));
                                 END;

                                    LastDate:=DMY2DATE(myDate,myMonth,myYear);

                                 //ERROR('%1',LastDate);

                                     MPESAPAYBILL.INIT;
                                     MPESAPAYBILL."Document No":=PaybillBuffer."Receipt No.";
                                     MPESAPAYBILL."Transaction Date":=LastDate;
                                     MPESAPAYBILL."Transaction Time":=TODAY;
                                     MPESAPAYBILL.Amount:=PaybillBuffer."Paid In";
                                     MPESAPAYBILL."Paybill Acc Balance":=PaybillBuffer.Balance;
                                     MPESAPAYBILL."Document Date":=TODAY;
                                     MPESAPAYBILL."Key Word":=COPYSTR(Part2,1,3);
                                     MPESAPAYBILL."Account No":=Part2;
                                     MPESAPAYBILL."Account Name":=COPYSTR(PaybillBuffer."Other Party Info",16,250);
                                     MPESAPAYBILL.Telephone:=COPYSTR(PaybillBuffer."Other Party Info",1,12);
                                     MPESAPAYBILL.Description:='Paybill Deposit';
                                     MPESAPAYBILL."Imported By":=USERID;
                                     MPESAPAYBILL."Imported On":=CURRENTDATETIME;
                                     MPESAPAYBILL.INSERT;

                                     END;
                                     UNTIL PaybillBuffer.NEXT=0;

                                 MESSAGE('Posted successfully');
                                 fnClearTble(PaybillBuffer);
                                   END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr="Receipt No." }

    { 1120054003;2;Field  ;
                SourceExpr="Completion Time" }

    { 1120054004;2;Field  ;
                SourceExpr="Initiation Time" }

    { 1120054005;2;Field  ;
                SourceExpr=Details }

    { 1120054006;2;Field  ;
                SourceExpr="Transaction Status" }

    { 1120054007;2;Field  ;
                SourceExpr="Paid In" }

    { 1120054008;2;Field  ;
                SourceExpr=Withdrawn }

    { 1120054009;2;Field  ;
                SourceExpr=Balance }

    { 1120054010;2;Field  ;
                SourceExpr="Balance Confirmed" }

    { 1120054011;2;Field  ;
                SourceExpr="Reason Type" }

    { 1120054012;2;Field  ;
                SourceExpr="Other Party Info" }

    { 1120054013;2;Field  ;
                SourceExpr="Linked Transaction ID" }

    { 1120054014;2;Field  ;
                SourceExpr="A/C No." }

  }
  CODE
  {
    VAR
      Part1@1120054000 : Text;
      Part2@1120054001 : Text;
      Part3@1120054002 : Text;

    LOCAL PROCEDURE fnClearTble@1120054011(Paybill@1120054000 : Record 51516654);
    BEGIN
      Paybill.RESET;
      Paybill.SETRANGE(Paybill."Linked Transaction ID",'');
      IF Paybill.FIND('-')THEN BEGIN
        REPEAT
        Paybill.DELETE;

        UNTIL Paybill.NEXT=0;
        END;
    END;

    LOCAL PROCEDURE SplitString@24(sText@1000 : Text;separator@1001 : Text) Token : Text;
    VAR
      Pos@1002 : Integer;
      Tokenq@1003 : Text;
    BEGIN
      Pos := STRPOS(sText,separator);
      IF Pos > 0 THEN BEGIN
        Token := COPYSTR(sText,1,Pos-1);
        IF Pos+1 <= STRLEN(sText) THEN
          sText := COPYSTR(sText,Pos+1)
        ELSE
          sText := '';
      END ELSE BEGIN
        Token := sText;
        sText := '';
      END;
    END;

    BEGIN
    END.
  }
}

