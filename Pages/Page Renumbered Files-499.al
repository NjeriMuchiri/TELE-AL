OBJECT page 172094 ATM Collection form
{
  OBJECT-PROPERTIES
  {
    Date=03/17/22;
    Time=[ 4:31:31 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    SourceTable=Table51516321;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1120054011;  ;ActionContainer;
                      Name=Issue ATMS;
                      ActionContainerType=NewDocumentItems }
      { 1120054012;1 ;Action    ;
                      Name=Issue ATM Card;
                      Promoted=Yes;
                      Visible=TRUE;
                      Image=EnableAllBreakpoints;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Userss@1120054000 : Record 2000000120;
                                 Vend@1120054001 : Record 23;
                                 AuditTrail@1120054002 : Codeunit 51516107;
                                 CloudPESA@1120054003 : Codeunit 51516019;
                                 msg@1120054004 : Text;
                               BEGIN
                                 IF Status<>Status::Approved THEN
                                     ERROR('This ATM You are about to issue has not been approved');

                                 // IF "Card Status" <> "Card Status"::Disabled THEN
                                 //   ERROR('Card is not Disabled');
                                 // IF "Card Issued"=TRUE THEN BEGIN
                                 //   ERROR('The ATM Card You Are Trying to Issue is Already Issued');
                                 //   END;

                                 IF Collected = TRUE THEN BEGIN
                                   ERROR('ATM Already Collected');
                                   END;

                                 // IF Userss.GET(USERID) THEN BEGIN
                                 //     IF Userss."Link/Delink Atm"=FALSE THEN
                                 //         ERROR('You Dont Have Rights To Enable ATM.Kindly Contact System Administrator');
                                 // END;

                                 // IF "Reason for Account blocking"='' THEN
                                 //     ERROR('Please Give reason For Enabling ATM');

                                 Vend.GET("Account No");
                                 IF CONFIRM('Are you sure you want to Issue ATM no. %1 for this account  ?',TRUE)=TRUE    THEN
                                     Vend."ATM No.":="Card No";
                                 Vend.MODIFY;

                                 "Card Status":="Card Status"::Active;
                                 "Enabled By":=USERID;
                                 "Enabled On":=TODAY;
                                 MODIFY;

                                 //Create Audit Entry
                                 AuditTrail.FnGetLastEntry();
                                 AuditTrail.FnGetComputerName();
                                 AuditTrail.FnInsertAuditRecords("Entry No",USERID,'Issue ATM Card',0,'ATM',TODAY,TIME,'',"Account No","No.","Card No");
                                 //End Create Audit Entry

                                 MESSAGE:='Dear '+"Account Name"+', Your Telepost Sacco ATM Card Has been Issued';
                                 CloudPESA.SMSMessage('ATMAPP',"Account No","Phone No.",msg);
                                 MESSAGE ('ATM Card Issued Succesfully');
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
                SourceExpr="No." }

    { 1120054014;2;Field  ;
                SourceExpr="Account No" }

    { 1120054015;2;Field  ;
                SourceExpr="Account Name" }

    { 1120054003;2;Field  ;
                SourceExpr="Card No" }

    { 1120054004;2;Field  ;
                SourceExpr="Date Collected" }

    { 1120054010;2;Field  ;
                SourceExpr=ModeOfCollection;
                OnValidate=BEGIN
                             TESTFIELD(ModeOfCollection);
                           END;

                OnLookup=BEGIN
                           TESTFIELD(ModeOfCollection);
                         END;
                          }

    { 1120054013;2;Field  ;
                SourceExpr="Phone No." }

    { 1120054006;2;Field  ;
                SourceExpr="ID No" }

    { 1120054007;2;Field  ;
                SourceExpr=Collected }

    { 1120054008;2;Field  ;
                SourceExpr=Address }

    { 1120054005;2;Field  ;
                SourceExpr="Card Issued By" }

    { 1120054009;2;Field  ;
                SourceExpr=Signature;
                TableRelation="ATM Card Applications" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

