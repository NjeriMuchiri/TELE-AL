OBJECT page 172116 CloudPesa Changed Request
{
  OBJECT-PROPERTIES
  {
    Date=05/12/23;
    Time=12:18:42 PM;
    Modified=Yes;
    Version List=Change RequestV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    SourceTable=Table51516350;
    SourceTableView=WHERE(Changed=CONST(Yes));
    PageType=Card;
    OnOpenPage=BEGIN
                 AccountVisible:=FALSE;
                 MobileVisible:=FALSE;
                 AtmVisible:=FALSE;
                 nxkinvisible:=FALSE;
                 PicturesVisible:=FALSE;
                 IF Type=Type::"Mobile Change" THEN BEGIN
                   MobileVisible:=TRUE;
                 END;

                 IF Type=Type::"Atm Change" THEN BEGIN
                   AtmVisible:=TRUE;

                 END;

                 IF Type=Type::"Backoffice Change" THEN BEGIN
                   AccountVisible:=TRUE;
                   nxkinvisible:=TRUE;
                 END;

                 IF Type=Type::"Agile Change" THEN BEGIN
                   AccountVisible:=TRUE;
                   nxkinvisible:=TRUE;
                 END;

                 IF Type=Type::"Picture Change" THEN BEGIN
                 PicturesVisible:=TRUE;
                 END;
               END;

    OnAfterGetRecord=BEGIN
                       AccountVisible:=FALSE;
                       MobileVisible:=FALSE;
                       AtmVisible:=FALSE;
                       nxkinvisible:=FALSE;
                       PicturesVisible:=FALSE;
                       IF Type=Type::"Mobile Change" THEN BEGIN
                         MobileVisible:=TRUE;
                       END;

                       IF Type=Type::"Atm Change" THEN BEGIN
                         AtmVisible:=TRUE;

                       END;

                       IF Type=Type::"Backoffice Change" THEN BEGIN
                         AccountVisible:=TRUE;
                         nxkinvisible:=TRUE;
                       END;

                       IF Type=Type::"Agile Change" THEN BEGIN
                         AccountVisible:=TRUE;
                         nxkinvisible:=TRUE;
                       END;

                       IF Type=Type::"Picture Change" THEN BEGIN
                       PicturesVisible:=TRUE;
                       END;
                     END;

    ActionList=ACTIONS
    {
      { 1000000043;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1000000046;1 ;Action    ;
                      CaptionML=ENU=Approvals;
                      Promoted=Yes;
                      Image=approvals;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 MESSAGE('1234');
                               END;
                                }
      { 1000000044;1 ;Action    ;
                      CaptionML=ENU=Send Approval Request;
                      Promoted=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 MESSAGE('Change Request %1 has been Approved Automatically',No);
                                 Status:=Status::Approved;
                                 MODIFY;

                                 "Approved by":=USERID;
                                 "Approval Date":=TODAY;
                               END;
                                }
      { 1000000045;1 ;Action    ;
                      CaptionML=ENU=Cancel Approval Request;
                      Promoted=Yes;
                      Image=cancel;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 MESSAGE('Change Request %1 has been cancelled successfully',No);
                                 Status:=Status::Open;
                                 MODIFY;
                               END;
                                }
      { 1000000047;1 ;Separator  }
      { 1000000048;1 ;Action    ;
                      CaptionML=ENU=Update Changes;
                      Promoted=Yes;
                      Image=UpdateShipment;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF  ((Type=Type::"Mobile Change") OR (Type=Type::"Atm Change") OR (Type=Type::"Agile Change")) THEN BEGIN
                                        vend.RESET;
                                        vend.SETRANGE(vend."No.","Account No");
                                       IF vend.FIND('-') THEN
                                          vend.CALCFIELDS(vend.Picture,vend.Signature);
                                          vend.Name:=Name;
                                          vend."Global Dimension 2 Code":= Branch;
                                          vend.Address:=Address;
                                          vend.Picture:=Picture;
                                          vend.Signature:=signinature;
                                          vend."E-Mail":=Email;
                                          vend."Mobile Phone No":= "Mobile No";
                                          vend. "MPESA Mobile No":="S-Mobile No";
                                 //         vend."FD Maturity Instructions":="ATM Collector Name";
                                          vend."ID No.":="ID No";
                                          vend."Staff No":="Personal No";
                                          vend."Account Type":="Account Type";
                                          vend.City:=City;
                                          vend.Section:=Section;
                                          vend."Card Expiry Date":= "Card Expiry Date";
                                          vend."Card No.":="Card No";
                                          vend."Card Valid From":="Card Valid From";
                                          vend."Card Valid To":="Card Valid To";
                                          vend."Marital Status":="Marital Status";
                                          vend.MODIFY






                                    END;


                                 IF Type=Type::"Backoffice Change" THEN BEGIN
                                     Memb.RESET;
                                     Memb.SETRANGE(Memb."No.","Account No");
                                   IF Memb.FIND('-') THEN BEGIN

                                         Memb.CALCFIELDS(Memb.Picture,Memb.Signature);
                                         Memb.Name:=Name;
                                         Memb."Global Dimension 2 Code":= Branch;
                                         Memb.Address:=Address;
                                         Memb.Picture:=Picture;
                                         Memb.Signature:=signinature;
                                         Memb."E-Mail":=Email;
                                         Memb."Mobile Phone No":= "Mobile No";
                                         Memb."ID No.":="ID No";
                                         Memb."Payroll/Staff No":="Personal No";
                                         Memb.City:=City;
                                         Memb.Section:=Section;
                                         Memb."Marital Status":="Marital Status";
                                         Memb.Pin:="KRA Pin";
                                         Memb.MODIFY




                                     END;

                                     END;

                                 Changed:=TRUE;
                                 MODIFY;
                                 MESSAGE('Changes have been updated Successfully');
                               END;
                                }
      { 1120054002;1 ;Action    ;
                      Name=Update PIc;
                      OnAction=VAR
                                 PDial@1120054000 : Dialog;
                                 ModifyMember@1120054001 : Boolean;
                                 ModifyFosa@1120054002 : Boolean;
                                 Counter@1120054003 : Integer;
                                 TotalCount@1120054004 : Integer;
                               BEGIN
                                 PDial.OPEN('Updating images for #1###########');

                                 CR.RESET;
                                 //CR.SETRANGE("Capture Date",CALCDATE('-2D',TODAY),TODAY);
                                 CR.SETRANGE(Changed,TRUE);
                                 CR.SETRANGE(Type,CR.Type::"Backoffice Change");
                                 //CR.SETRANGE("Account No",'004739');
                                 IF CR.FINDSET THEN BEGIN
                                   TotalCount:=CR.COUNT;
                                     REPEAT
                                        Counter+=1;
                                        PDial.UPDATE(1,FORMAT(Counter)+'of'+FORMAT(TotalCount));
                                        ModifyMember:=FALSE;
                                         Memb.RESET;
                                         Memb.SETRANGE(Memb."No.",CR."Account No");
                                         IF Memb.FIND('-') THEN BEGIN
                                             CR.CALCFIELDS(Picture,signinature,"Front Side ID","Back Side ID");

                                             Memb.CALCFIELDS(Memb.Picture,Memb.Signature,Memb."Front Side ID",Memb."Back Side ID");
                                             IF (NOT Memb.Picture.HASVALUE) AND (CR.Picture.HASVALUE) THEN BEGIN
                                               Memb.Picture:=CR.Picture;
                                               ModifyMember:=TRUE;
                                               END;

                                             IF (NOT Memb.Signature.HASVALUE) AND (CR.signinature.HASVALUE) THEN BEGIN
                                                Memb.Signature:=CR.signinature;
                                                ModifyMember:=TRUE;
                                               END;

                                             IF (NOT Memb."Front Side ID".HASVALUE) AND (CR."Front Side ID".HASVALUE) THEN BEGIN
                                                 Memb."Front Side ID":=CR."Front Side ID";
                                                 ModifyMember:=TRUE;
                                               END;

                                             IF (NOT Memb."Back Side ID".HASVALUE) AND (CR."Back Side ID".HASVALUE) THEN BEGIN
                                               Memb."Back Side ID":=CR."Back Side ID";
                                               ModifyMember:=TRUE;
                                               END;

                                             IF ModifyMember THEN BEGIN
                                                 Memb.MODIFY;
                                                 COMMIT;
                                               END;

                                      ModifyFosa:=FALSE;
                                            vend.RESET;
                                            vend.SETRANGE(vend."No.",Memb."FOSA Account");
                                           IF vend.FIND('-') THEN
                                              vend.CALCFIELDS(vend.Picture,vend.Signature,vend."Front Side ID",vend."Back Side ID");
                                             IF (NOT vend.Picture.HASVALUE) AND (CR.Picture.HASVALUE) THEN BEGIN
                                             vend.Picture:=CR.Picture;
                                               ModifyFosa:=TRUE;
                                               END;

                                             IF (NOT vend.Signature.HASVALUE) AND (CR.signinature.HASVALUE) THEN BEGIN
                                                 vend.Signature:=CR.signinature;
                                                   ModifyFosa := TRUE;
                                               END;

                                             IF (NOT vend."Front Side ID".HASVALUE) AND (CR."Front Side ID".HASVALUE) THEN BEGIN
                                                vend."Front Side ID":=CR."Front Side ID";
                                                ModifyFosa:=TRUE;
                                               END;

                                             IF (NOT vend."Back Side ID".HASVALUE) AND (CR."Back Side ID".HASVALUE) THEN BEGIN
                                                vend."Back Side ID":=CR."Back Side ID";
                                                ModifyFosa:=TRUE;
                                               END;

                                             IF ModifyFosa THEN BEGIN
                                              vend.MODIFY;
                                               COMMIT;
                                             END;

                                         END;

                                     UNTIL CR.NEXT=0;
                                 END;

                                 PDial.CLOSE;

                                 MESSAGE('Done');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=General;
                GroupType=Group }

    { 1000000003;2;Field  ;
                SourceExpr=No }

    { 1000000002;2;Field  ;
                SourceExpr=Type;
                OnValidate=BEGIN
                             AccountVisible:=FALSE;
                             MobileVisible:=FALSE;
                             AtmVisible:=FALSE;

                             IF Type=Type::"Mobile Change" THEN BEGIN
                               MobileVisible:=TRUE;
                             END;

                             IF Type=Type::"Atm Change" THEN BEGIN
                               AtmVisible:=TRUE;
                             END;

                             IF Type=Type::"Backoffice Change" THEN BEGIN
                               AccountVisible:=TRUE;
                             END;

                             IF Type=Type::"Agile Change" THEN BEGIN
                               AccountVisible:=TRUE;
                             END;
                           END;
                            }

    { 1000000004;2;Field  ;
                SourceExpr="Account No" }

    { 1000000049;2;Field  ;
                SourceExpr="Captured by" }

    { 1000000050;2;Field  ;
                SourceExpr="Capture Date" }

    { 1000000051;2;Field  ;
                SourceExpr="Approved by" }

    { 1000000052;2;Field  ;
                SourceExpr="Approval Date" }

    { 1000000041;1;Group  ;
                Name=Mobile;
                CaptionML=ENU=Mobile;
                Visible=Mobilevisible;
                GroupType=Group }

    { 1000000005;2;Field  ;
                SourceExpr="Mobile No" }

    { 1000000029;2;Field  ;
                SourceExpr="S-Mobile No" }

    { 1000000042;1;Group  ;
                Name=Atm Details;
                Visible=Atmvisible;
                GroupType=Group }

    { 1000000030;2;Field  ;
                SourceExpr="ATM Approve" }

    { 1000000031;2;Field  ;
                SourceExpr="Card Expiry Date" }

    { 1000000032;2;Field  ;
                SourceExpr="Card Valid From" }

    { 1000000033;2;Field  ;
                SourceExpr="Card Valid To" }

    { 1000000034;2;Field  ;
                SourceExpr="Date ATM Linked" }

    { 1000000035;2;Field  ;
                SourceExpr="ATM No." }

    { 1000000036;2;Field  ;
                SourceExpr="ATM Issued" }

    { 1000000037;2;Field  ;
                SourceExpr="ATM Self Picked" }

    { 1000000038;2;Field  ;
                SourceExpr="ATM Collector Name" }

    { 1000000039;2;Field  ;
                SourceExpr="ATM Collectors ID" }

    { 1000000040;2;Field  ;
                SourceExpr="Atm Collectors Moile" }

    { 1000000053;2;Field  ;
                SourceExpr="Responsibility Centers" }

    { 1000000008;1;Group  ;
                Name=Account Info;
                Visible=Accountvisible;
                GroupType=Group }

    { 1120054000;2;Field  ;
                Name=ID Front;
                CaptionML=ENU=ID Front;
                SourceExpr="Front Side ID" }

    { 1000000006;2;Field  ;
                SourceExpr=Name }

    { 1000000007;2;Field  ;
                SourceExpr=Address }

    { 1000000011;2;Field  ;
                SourceExpr=City }

    { 1000000012;2;Field  ;
                SourceExpr="E-mail" }

    { 1000000013;2;Field  ;
                SourceExpr="Personal No" }

    { 1000000014;2;Field  ;
                SourceExpr="ID No" }

    { 1000000015;2;Field  ;
                SourceExpr="Marital Status" }

    { 1000000016;2;Field  ;
                SourceExpr="Passport No." }

    { 1000000017;2;Field  ;
                SourceExpr=Status }

    { 1000000018;2;Field  ;
                SourceExpr="Account Type" }

    { 1000000019;2;Field  ;
                SourceExpr="Account Category" }

    { 1000000020;2;Field  ;
                SourceExpr=Email }

    { 1000000021;2;Field  ;
                SourceExpr=Section }

    { 1000000022;2;Field  ;
                SourceExpr="Card No" }

    { 1000000023;2;Field  ;
                SourceExpr="Home Address" }

    { 1000000024;2;Field  ;
                SourceExpr=Loaction }

    { 1000000025;2;Field  ;
                SourceExpr="Sub-Location" }

    { 1000000026;2;Field  ;
                SourceExpr=District }

    { 1000000027;2;Field  ;
                SourceExpr="Reason for change" }

    { 1000000028;2;Field  ;
                SourceExpr="Signing Instructions" }

    { 1120054007;1;Group  ;
                Name=Member Pictures;
                Visible=PicturesVisible;
                Editable=DetailsEditable;
                GroupType=Group }

    { 1120054006;2;Field  ;
                SourceExpr=Picture }

    { 1120054005;2;Field  ;
                SourceExpr=signinature }

    { 1120054004;2;Field  ;
                SourceExpr="Front Side ID" }

    { 1120054003;2;Field  ;
                SourceExpr="Back Side ID" }

  }
  CODE
  {
    VAR
      vend@1000000000 : Record 23;
      Memb@1000000001 : Record 51516223;
      MobileVisible@1000000002 : Boolean;
      AtmVisible@1000000003 : Boolean;
      AccountVisible@1000000004 : Boolean;
      CR@1120054000 : Record 51516350;
      PicturesVisible@1120054001 : Boolean;
      DetailsEditable@1120054002 : Boolean;
      nxkinvisible@1120054003 : Boolean;

    BEGIN
    END.
  }
}

