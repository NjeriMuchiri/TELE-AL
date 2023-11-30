OBJECT table 20432 SurePESA Applications
{
  OBJECT-PROPERTIES
  {
    Date=11/28/19;
    Time=[ 1:03:50 PM];
    Modified=Yes;
    Version List=SurePESA;
  }
  PROPERTIES
  {
    OnInsert=BEGIN

               IF "No." = '' THEN BEGIN
                 SaccoNoSeries.GET;
                 SaccoNoSeries.TESTFIELD(SaccoNoSeries."SurePESA Registration Nos");
                 NoSeriesMgt.InitSeries(SaccoNoSeries."SurePESA Registration Nos",xRec."No. Series",0D,"No.","No. Series");
               END;
             END;

  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  SaccoNoSeries.GET;
                                                                  NoSeriesMgt.TestManual(SaccoNoSeries."SurePESA Registration Nos");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Account No          ;Code30        ;TableRelation=Vendor.No.;
                                                   OnValidate=BEGIN
                                                                IF Accounts.GET("Account No") THEN BEGIN
                                                                  Cloudpesaapp.RESET;
                                                                  Cloudpesaapp.SETRANGE(Cloudpesaapp."Account No","Account No");
                                                                  IF Cloudpesaapp.FIND('-') THEN
                                                                     ERROR('Account has already been registered for mobile banking');
                                                                  IF Accounts.Status<> Accounts.Status::Active THEN
                                                                    ERROR('Account must be active');
                                                                  IF Accounts."Account Type"<>'ORDINARY' THEN
                                                                  ERROR('Account must be ORDINARY Savings account');
                                                                  IF Accounts."ID No."='' THEN
                                                                  ERROR('Account must have an ID NO.');
                                                                  IF Accounts.Signature.HASVALUE=FALSE THEN
                                                                  ERROR('Account must have a signature');
                                                                   IF Accounts.Picture.HASVALUE=FALSE THEN
                                                                  ERROR('Account must have a passport photo');


                                                                    Members.RESET;
                                                                    Members.SETRANGE(Members."No.",Accounts."BOSA Account No");
                                                                    IF Members.FIND('-') THEN BEGIN
                                                                    IF Members."Registration Date"<>0D THEN BEGIN
                                                                     IF CALCDATE('6M',Members."Registration Date")>TODAY  THEN
                                                                       ERROR('Account must be in operation for not less than 6 Months');
                                                                     END ELSE
                                                                     ERROR('Account does not have Registration Date');

                                                                    Members.CALCFIELDS(Members."Shares Retained");

                                                                    IF Members."Shares Retained"<15000 THEN BEGIN
                                                                       ERROR('Member has less share capital');
                                                                    END;



                                                                    END;
                                                                    Members.CALCFIELDS(Members."Front Side ID",Members."Back Side ID");
                                                                    Accounts.CALCFIELDS(Accounts.Picture,Accounts.Signature);

                                                                "Account Name":=Accounts.Name;
                                                                "ID No":=Accounts."ID No.";
                                                                Telephone:=Accounts."Phone No.";
                                                                "Staff No":=Accounts."Staff No";
                                                                "Date Applied":=TODAY;
                                                                "Created By":=USERID;
                                                                "Time Applied":=TIME;
                                                                "Created By":=USERID;
                                                                Picture:=Accounts.Picture;
                                                                Signature:=Accounts.Signature;
                                                                "ID Front":=Members."Front Side ID";
                                                                "ID Back":=Members."Back Side ID";
                                                                "Membership Registration Date":=Members."Registration Date"
                                                                END;
                                                              END;
                                                               }
    { 3   ;   ;Account Name        ;Text50         }
    { 4   ;   ;Telephone           ;Code20         }
    { 5   ;   ;ID No               ;Code20         }
    { 6   ;   ;Status              ;Option        ;OptionCaptionML=ENU=Application, Pending Approval,Approved,Rejected;
                                                   OptionString=Application, Pending Approval,Approved,Rejected }
    { 7   ;   ;Date Applied        ;Date           }
    { 8   ;   ;Time Applied        ;Time           }
    { 9   ;   ;Created By          ;Code50         }
    { 10  ;   ;Sent                ;Boolean        }
    { 11  ;   ;No. Series          ;Code20         }
    { 12  ;   ;SentToServer        ;Boolean        }
    { 13  ;   ;Staff No            ;Code10         }
    { 14  ;   ;Picture             ;BLOB          ;SubType=Bitmap }
    { 15  ;   ;Signature           ;BLOB          ;SubType=Bitmap }
    { 16  ;   ;ID Front            ;BLOB          ;SubType=Bitmap }
    { 17  ;   ;ID Back             ;BLOB          ;SubType=Bitmap }
    { 18  ;   ;Membership Registration Date;Date   }
    { 19  ;   ;Last PIN Reset      ;Date           }
    { 20  ;   ;Reset By            ;Code150        }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SaccoNoSeries@1000000000 : Record 51516258;
      NoSeriesMgt@1000000001 : Codeunit 396;
      Accounts@1000000002 : Record 23;
      Members@1120054000 : Record 51516223;
      Cloudpesaapp@1120054001 : Record 51516521;

    BEGIN
    END.
  }
}

