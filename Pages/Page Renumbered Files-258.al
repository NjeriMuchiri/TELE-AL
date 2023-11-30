OBJECT page 17449 EFT Header Card
{
  OBJECT-PROPERTIES
  {
    Date=08/31/16;
    Time=10:58:05 AM;
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516314;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102760022;1 ;ActionGroup;
                      CaptionML=ENU=Get }
      { 1102760023;2 ;Action    ;
                      CaptionML=ENU=Standing Orders EFT;
                      Visible=false;
                      OnAction=BEGIN
                                 IF Transferred = TRUE THEN
                                 ERROR('EFT Batch already transfered. Please use another one.');

                                 STORegister.RESET;
                                 STORegister.SETRANGE(STORegister.EFT,TRUE);
                                 STORegister.SETRANGE(STORegister."Transfered to EFT",FALSE);
                                 IF STORegister.FIND('-') THEN BEGIN
                                 REPEAT
                                 EFTDetails.INIT;
                                 EFTDetails.No:='';
                                 EFTDetails."Header No":=No;
                                 EFTDetails."Account No":=STORegister."Source Account No.";
                                 //EFTDetails."Account Name":=STORegister."Account Name";
                                 EFTDetails.VALIDATE(EFTDetails."Account No");
                                 //IF Accounts.GET(EFTDetails."Account No") THEN BEGIN
                                 //EFTDetails."Account Type":=Accounts."Account Type";
                                 //EFTDetails."Staff No":=Account."Staff No";
                                 //END;
                                 EFTDetails.Amount:=STORegister."Amount Deducted";
                                 EFTDetails."Destination Account Type":=EFTDetails."Destination Account Type"::External;
                                 //EFTDetails."Destination Account No":=STORegister."Destination Account No.";
                                 IF STO.GET(STORegister."Standing Order No.") THEN BEGIN
                                 EFTDetails."Destination Account No":=STO."Destination Account No.";
                                 EFTDetails."Bank No":=STO."Bank Code";
                                 EFTDetails.VALIDATE(EFTDetails."Bank No");
                                 END;
                                 EFTDetails."Destination Account Name":=COPYSTR(STORegister."Destination Account Name",1,28);
                                 EFTDetails."Standing Order No":=STORegister."Standing Order No.";
                                 EFTDetails."Standing Order Register No":=STORegister."Register No.";
                                 EFTDetails.Charges:=0;
                                 IF EFTDetails.Amount > 0 THEN
                                 EFTDetails.INSERT(TRUE)

                                 UNTIL STORegister.NEXT = 0
                                 END;
                               END;
                                }
      { 1102760031;2 ;Action    ;
                      CaptionML=ENU=Standing Orders EFT;
                      OnAction=BEGIN
                                 {IF Transferred = TRUE THEN
                                 ERROR('EFT Batch already transfered. Please use another one.');

                                 EFTHeader.RESET;
                                 EFTHeader.SETRANGE(EFTHeader.No,No);
                                 IF EFTHeader.FIND('-') THEN
                                 REPORT.RUN(,TRUE,TRUE,EFTHeader)
                                  }
                               END;
                                }
      { 1102760024;2 ;Separator  }
      { 1102760025;2 ;Action    ;
                      CaptionML=ENU=Salary EFT;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReverseLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN

                                 IF Transferred = TRUE THEN
                                 ERROR('EFT Batch already transfered. Please use another one.');

                                 EFTHeader.RESET;
                                 EFTHeader.SETRANGE(EFTHeader.No,No);
                                 IF EFTHeader.FIND('-') THEN

                                   MESSAGE('%1',EFTHeader.No);
                                 REPORT.RUN(51516292,TRUE,TRUE,EFTHeader)
                               END;
                                }
      { 1102760027;2 ;Separator  }
      { 1102760028;2 ;Action    ;
                      CaptionML=ENU=Re-genarate EFT Format;
                      Visible=false;
                      OnAction=BEGIN

                                 EFTDetails.RESET;
                                 EFTDetails.SETRANGE(EFTDetails."Header No",No);
                                 IF EFTDetails.FIND('-') THEN BEGIN
                                 REPEAT
                                 //EFTDetails.TESTFIELD(EFTDetails."Destination Account No");
                                 EFTDetails.TESTFIELD(EFTDetails.Amount);
                                 //EFTDetails.TESTFIELD(EFTDetails."Destination Account Name");
                                 EFTDetails.TESTFIELD(EFTDetails."Bank No");

                                 IF STRLEN(EFTDetails."Destination Account Name") > 28 THEN
                                 ERROR('Destnation account name of staff no %1 more than 28 characters.',EFTDetails."Staff No");

                                 IF STRLEN(EFTDetails."Destination Account No") > 14 THEN
                                 ERROR('Destnation account of staff no %1 more than 14 characters.',EFTDetails."Staff No");

                                 //For STIMA, replace staff No with stima
                                 ReffNo:='STIMA';

                                 IF EFTDetails.Amount <> ROUND(EFTDetails.Amount,1) THEN BEGIN
                                 IF EFTDetails.Amount <> ROUND(EFTDetails.Amount,0.1) THEN BEGIN
                                 EFTDetails.ExportFormat:=PADSTR('',14-STRLEN(EFTDetails."Destination Account No"),' ')+EFTDetails."Destination Account No"+
                                                          PADSTR('',5,' ')+
                                                          PADSTR('',6-STRLEN(EFTDetails."Bank No"),' ')+EFTDetails."Bank No"+' '+
                                                          EFTDetails."Destination Account Name"+PADSTR('',30-STRLEN(EFTDetails."Destination Account Name"),' ')+
                                                          PADSTR('',9-STRLEN(DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')),' ')+
                                                                 DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')+
                                                          PADSTR('',8-STRLEN(COPYSTR(ReffNo,1,8)),' ')+ReffNo;
                                 END ELSE BEGIN
                                 EFTDetails.ExportFormat:=PADSTR('',14-STRLEN(EFTDetails."Destination Account No"),' ')+EFTDetails."Destination Account No"+
                                                          PADSTR('',5,' ')+
                                                          PADSTR('',6-STRLEN(EFTDetails."Bank No"),' ')+EFTDetails."Bank No"+' '+
                                                          EFTDetails."Destination Account Name"+PADSTR('',30-STRLEN(EFTDetails."Destination Account Name"),' ')+
                                                          PADSTR('',8-STRLEN(DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')),' ')+
                                                                 DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')+'0'+
                                                          PADSTR('',8-STRLEN(COPYSTR(ReffNo,1,8)),' ')+ReffNo;
                                 END;
                                 END ELSE BEGIN
                                 TextGen:=FORMAT(EFTDetails."Staff No");

                                 EFTDetails.ExportFormat:=PADSTR('',14-STRLEN(EFTDetails."Destination Account No"),' ')+EFTDetails."Destination Account No"+
                                                          PADSTR('',5,' ')+
                                                          PADSTR('',6-STRLEN(EFTDetails."Bank No"),' ')+EFTDetails."Bank No"+' '+
                                                          EFTDetails."Destination Account Name"+PADSTR('',30-STRLEN(EFTDetails."Destination Account Name"),' ')+
                                                          PADSTR('',7-STRLEN(DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')),' ')+
                                                                 DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')+'00'+
                                                          PADSTR('',8-STRLEN(COPYSTR(ReffNo,1,8)),' ')+ReffNo;
                                 END;



                                 EFTDetails.MODIFY;
                                 UNTIL EFTDetails.NEXT = 0;
                                 END;




                                 EFTDetails.RESET;
                                 EFTDetails.SETRANGE(EFTDetails."Header No",No);
                                 IF EFTDetails.FIND('-') THEN
                               END;
                                }
      { 1102760032;2 ;Separator  }
      { 1102760033;2 ;Action    ;
                      CaptionML=ENU=Dividends EFT;
                      Visible=FALSE;
                      OnAction=BEGIN
                                 //IF Transferred = TRUE THEN
                                 //ERROR('EFT Batch already transfered. Please use another one.');
                                 {
                                 EFTHeader.RESET;
                                 EFTHeader.SETRANGE(EFTHeader.No,No);
                                 IF EFTHeader.FIND('-') THEN
                                 REPORT.RUN(,TRUE,TRUE,EFTHeader)
                                 }
                               END;
                                }
      { 1102760035;2 ;Separator  }
      { 1102760037;2 ;Action    ;
                      CaptionML=ENU=Salary Dividends EFT;
                      Visible=FALSE;
                      OnAction=BEGIN
                                 {IF Transferred = TRUE THEN
                                 ERROR('EFT Batch already transfered. Please use another one.');

                                 EFTHeader.RESET;
                                 EFTHeader.SETRANGE(EFTHeader.No,No);
                                 IF EFTHeader.FIND('-') THEN
                                 REPORT.RUN(,TRUE,TRUE,EFTHeader)
                                 }
                               END;
                                }
      { 1102760034;2 ;Separator  }
      { 1102760036;2 ;Action    ;
                      CaptionML=ENU=Generate Dividends EFT;
                      Visible=FALSE;
                      OnAction=BEGIN

                                 EFTDetails.RESET;
                                 EFTDetails.SETRANGE(EFTDetails."Header No",No);
                                 IF EFTDetails.FIND('-') THEN BEGIN
                                 REPEAT
                                 //EFTDetails.TESTFIELD(EFTDetails."Destination Account No");
                                 EFTDetails.TESTFIELD(EFTDetails.Amount);
                                 //EFTDetails.TESTFIELD(EFTDetails."Destination Account Name");
                                 //EFTDetails.TESTFIELD(EFTDetails."Bank No");

                                 IF STRLEN(EFTDetails."Destination Account Name") > 28 THEN
                                 ERROR('Destnation account name of staff no %1 more than 28 characters.',EFTDetails."Staff No");

                                 IF STRLEN(EFTDetails."Destination Account No") > 14 THEN
                                 ERROR('Destnation account of staff no %1 more than 14 characters.',EFTDetails."Staff No");

                                 //For TELEPOST, replace staff No with TELEPOST
                                 ReffNo:='TELEPOST';

                                 IF EFTDetails.Amount <> ROUND(EFTDetails.Amount,1) THEN BEGIN
                                 IF EFTDetails.Amount <> ROUND(EFTDetails.Amount,0.1) THEN BEGIN
                                 EFTDetails.ExportFormat:=PADSTR('',14-STRLEN(EFTDetails."Destination Account No"),' ')+EFTDetails."Destination Account No"+
                                                          PADSTR('',5,' ')+
                                                          PADSTR('',6-STRLEN(EFTDetails."Bank No"),' ')+EFTDetails."Bank No"+' '+
                                                          EFTDetails."Destination Account Name"+PADSTR('',30-STRLEN(EFTDetails."Destination Account Name"),' ')+
                                                          PADSTR('',9-STRLEN(DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')),' ')+
                                                                 DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')+
                                                          PADSTR('',8-STRLEN(COPYSTR(ReffNo,1,8)),' ')+ReffNo;
                                 END ELSE BEGIN
                                 EFTDetails.ExportFormat:=PADSTR('',14-STRLEN(EFTDetails."Destination Account No"),' ')+EFTDetails."Destination Account No"+
                                                          PADSTR('',5,' ')+
                                                          PADSTR('',6-STRLEN(EFTDetails."Bank No"),' ')+EFTDetails."Bank No"+' '+
                                                          EFTDetails."Destination Account Name"+PADSTR('',30-STRLEN(EFTDetails."Destination Account Name"),' ')+
                                                          PADSTR('',8-STRLEN(DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')),' ')+
                                                                 DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')+'0'+
                                                          PADSTR('',8-STRLEN(COPYSTR(ReffNo,1,8)),' ')+ReffNo;
                                 END;
                                 END ELSE BEGIN
                                 TextGen:=FORMAT(EFTDetails."Staff No");

                                 EFTDetails.ExportFormat:=PADSTR('',14-STRLEN(EFTDetails."Destination Account No"),' ')+EFTDetails."Destination Account No"+
                                                          PADSTR('',5,' ')+
                                                          PADSTR('',6-STRLEN(EFTDetails."Bank No"),' ')+EFTDetails."Bank No"+' '+
                                                          EFTDetails."Destination Account Name"+PADSTR('',30-STRLEN(EFTDetails."Destination Account Name"),' ')+
                                                          PADSTR('',7-STRLEN(DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')),' ')+
                                                                 DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')+'00'+
                                                          PADSTR('',8-STRLEN(COPYSTR(ReffNo,1,8)),' ')+ReffNo;
                                 END;



                                 EFTDetails.MODIFY;
                                 UNTIL EFTDetails.NEXT = 0;
                                 END;




                                 EFTDetails.RESET;
                                 EFTDetails.SETRANGE(EFTDetails."Header No",No);
                                 IF EFTDetails.FIND('-') THEN
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102760017;1 ;Action    ;
                      CaptionML=ENU=View Schedule;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 {EFTHeader.RESET;
                                 EFTHeader.SETRANGE(EFTHeader.No,No);
                                 IF EFTHeader.FIND('-') THEN
                                 REPORT.RUN(,TRUE,TRUE,EFTHeader)
                                 }
                               END;
                                }
      { 1000000001;1 ;Action    ;
                      CaptionML=ENU=Transfer;
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TESTFIELD("Bank  No");

                                 IF Transferred = TRUE THEN
                                 ERROR('Funds transfers has already been done.');

                                 IF CONFIRM('Are you absolutely sure you want to post the EFT tranfers.',FALSE) = FALSE THEN
                                 EXIT;


                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name",'EFT');
                                 IF GenJournalLine.FIND('-') THEN
                                 GenJournalLine.DELETEALL;

                                 EFTDetails.RESET;
                                 EFTDetails.SETRANGE(EFTDetails."Header No",No);
                                 IF EFTDetails.FIND('-') THEN BEGIN
                                 REPEAT
                                 //EFTDetails.TESTFIELD(EFTDetails."Destination Account No");
                                 EFTDetails.TESTFIELD(EFTDetails.Amount);
                                 //EFTDetails.TESTFIELD(EFTDetails."Destination Account Name");
                                 //EFTDetails.TESTFIELD(EFTDetails."Bank No");

                                 IF STRLEN(EFTDetails."Destination Account Name") > 28 THEN
                                 ERROR('Destnation account name of staff no %1 more than 28 characters.',EFTDetails."Staff No");

                                 IF STRLEN(EFTDetails."Destination Account No") > 14 THEN
                                 ERROR('Destnation account of staff no %1 more than 14 characters.',EFTDetails."Staff No");


                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='EFT';
                                 GenJournalLine."Document No.":=No;
                                 GenJournalLine."External Document No.":=COPYSTR(EFTDetails."Destination Account No",1,20);
                                 GenJournalLine."Line No.":=LineNo;
                                 IF EFTDetails."Standing Order No" <> '' THEN BEGIN
                                 IF AccountType.GET(EFTDetails."Account Type") THEN BEGIN
                                 AccountType.TESTFIELD(AccountType."Standing Orders Suspense");
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"G/L Account";
                                 GenJournalLine."Account No.":=AccountType."Standing Orders Suspense";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='STO EFT - ' + EFTDetails."Standing Order No";
                                 END;
                                 END ELSE BEGIN
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=EFTDetails."Account No";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine.Description:='EFT to Account ' + EFTDetails."Destination Account No";
                                 END;
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=EFTDetails.Amount;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN BEGIN
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 END;
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 //Charges
                                 IF (EFTDetails."Account No" <> '5-02-09565-00') AND
                                    (EFTDetails."Account No" <> '5-02-09276-01') THEN BEGIN

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='EFT';
                                 GenJournalLine."Document No.":=No;
                                 GenJournalLine."External Document No.":=COPYSTR(EFTDetails."Destination Account No",1,20);
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::Vendor;
                                 GenJournalLine."Account No.":=EFTDetails."Account No";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 IF RTGS = TRUE THEN
                                 GenJournalLine.Description:='RTGS Charges'
                                 ELSE
                                 GenJournalLine.Description:='EFT Charges';
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=EFTDetails.Charges;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                                 GenJournalLine."Bal. Account No.":=EFTDetails."EFT Charges Account";
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN BEGIN
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 END;
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;

                                 END;

                                 //Charges

                                 //Clear EFT
                                 Transactions.RESET;
                                 Transactions.SETRANGE(Transactions."Cheque No",EFTDetails.No);
                                 Transactions.SETRANGE(Transactions."Transaction Type",'EFT');
                                 Transactions.SETRANGE(Transactions."Account No",EFTDetails."Account No");
                                 IF Transactions.FIND('-') THEN BEGIN
                                 Transactions."Cheque Processed":=TRUE;
                                 Transactions."Date Cleared":=TODAY;
                                 Transactions.MODIFY;
                                 END;
                                 //Clear EFT

                                 //IF STRLEN(EFTDetails."Destination Account No") > 13 THEN
                                 //ERROR('Destnation account %1 more than 13 characters.',EFTDetails."Destination Account No");

                                 {
                                 IF EFTDetails.Amount <> ROUND(EFTDetails.Amount,1) THEN BEGIN
                                 EFTDetails.ExportFormat:=PADSTR('',13-STRLEN(EFTDetails."Destination Account No"),' ')+EFTDetails."Destination Account No"+
                                                          PADSTR('',6,' ')+
                                                          PADSTR('',6-STRLEN(EFTDetails."Bank No"),' ')+EFTDetails."Bank No"+' '+
                                                          EFTDetails."Destination Account Name"+PADSTR('',30-STRLEN(EFTDetails."Destination Account Name"),' ')+
                                                          PADSTR('',9-STRLEN(DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')),' ')+
                                                                 DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')+
                                                          PADSTR('',8-STRLEN(EFTDetails."Staff No"),' ')+EFTDetails."Staff No";

                                 END ELSE BEGIN
                                 EFTDetails.ExportFormat:=PADSTR('',13-STRLEN(EFTDetails."Destination Account No"),' ')+EFTDetails."Destination Account No"+
                                                          PADSTR('',6,' ')+
                                                          PADSTR('',6-STRLEN(EFTDetails."Bank No"),' ')+EFTDetails."Bank No"+' '+
                                                          EFTDetails."Destination Account Name"+PADSTR('',30-STRLEN(EFTDetails."Destination Account Name"),' ')+
                                                          PADSTR('',7-STRLEN(DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')),' ')+
                                                                 DELCHR(DELCHR(FORMAT(EFTDetails.Amount),'=','.'),'=',',')+'00'+
                                                          PADSTR('',8-STRLEN(EFTDetails."Staff No"),' ')+EFTDetails."Staff No";
                                 END;
                                 }

                                 EFTDetails.Transferred:=TRUE;
                                 EFTDetails.MODIFY;



                                 //Mark the standing order register has transfered
                                 STORegister.RESET;
                                 STORegister.SETRANGE(STORegister."Register No.",EFTDetails."Standing Order Register No");
                                 IF STORegister.FIND('-') THEN BEGIN
                                 STORegister."Transfered to EFT":=TRUE;
                                 STORegister.MODIFY;
                                 END;

                                 UNTIL EFTDetails.NEXT = 0;
                                 END;


                                 //Bank Entry
                                 CALCFIELDS(Total);

                                 LineNo:=LineNo+10000;

                                 GenJournalLine.INIT;
                                 GenJournalLine."Journal Template Name":='PURCHASES';
                                 GenJournalLine."Journal Batch Name":='EFT';
                                 GenJournalLine."Document No.":=No;
                                 GenJournalLine."External Document No.":="Cheque No";
                                 GenJournalLine."Line No.":=LineNo;
                                 GenJournalLine."Account Type":=GenJournalLine."Account Type"::"Bank Account";
                                 GenJournalLine."Account No.":="Bank  No";
                                 GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                                 GenJournalLine."Posting Date":=TODAY;
                                 GenJournalLine.Description:='Electronic Funds Transfer - ' + No;
                                 GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                                 GenJournalLine.Amount:=-Total;
                                 GenJournalLine.VALIDATE(GenJournalLine.Amount);
                                 GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                                 IF GenJournalLine."Shortcut Dimension 1 Code" = '' THEN BEGIN
                                 GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                                 GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                                 END;
                                 IF GenJournalLine.Amount<>0 THEN
                                 GenJournalLine.INSERT;
                                 //Bank Entry

                                 GenJournalLine.RESET;
                                 GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                                 GenJournalLine.SETRANGE("Journal Batch Name",'EFT');
                                 IF GenJournalLine.FIND('-') THEN BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournalLine);
                                 END;


                                 Transferred:=TRUE;
                                 "Date Transferred":=TODAY;
                                 "Time Transferred":=TIME;
                                 "Transferred By":=USERID;
                                 MODIFY;


                                 MESSAGE('EFT Posted successfully.');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 13  ;0   ;Container ;
                ContainerType=ContentArea }

    { 12  ;1   ;Group     ;
                CaptionML=ENU=EFT Batch }

    { 11  ;2   ;Field     ;
                SourceExpr=No;
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                SourceExpr="Bank  No" }

    { 1000000000;2;Field  ;
                SourceExpr="Cheque No" }

    { 9   ;2   ;Field     ;
                SourceExpr=Total }

    { 8   ;2   ;Field     ;
                CaptionML=ENU=Record Count;
                SourceExpr="Total Count" }

    { 7   ;2   ;Field     ;
                SourceExpr=Remarks }

    { 6   ;2   ;Field     ;
                SourceExpr=Transferred;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                SourceExpr="Date Transferred" }

    { 4   ;2   ;Field     ;
                SourceExpr="Time Transferred" }

    { 3   ;2   ;Field     ;
                SourceExpr="Transferred By" }

    { 2   ;2   ;Field     ;
                SourceExpr=RTGS }

    { 1   ;1   ;Part      ;
                SubPageLink=Header No=FIELD(No);
                PagePartID=Page51516312 }

  }
  CODE
  {
    VAR
      GenJournalLine@1102760009 : Record 81;
      GLPosting@1102760008 : Codeunit 12;
      Account@1102760007 : Record 23;
      AccountType@1102760006 : Record 51516295;
      AvailableBal@1102760005 : Decimal;
      LineNo@1102760000 : Integer;
      EFTDetails@1102760001 : Record 51516315;
      STORegister@1102760002 : Record 51516308;
      Accounts@1102760003 : Record 23;
      EFTHeader@1102760004 : Record 51516314;
      Transactions@1102760010 : Record 51516299;
      TextGen@1102760011 : Text[250];
      STO@1102760012 : Record 51516307;
      ReffNo@1102760013 : Code[20];

    BEGIN
    END.
  }
}

