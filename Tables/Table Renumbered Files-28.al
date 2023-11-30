OBJECT table 50047 Store Requistion Header
{
  OBJECT-PROPERTIES
  {
    Date=09/06/16;
    Time=[ 4:26:34 PM];
    Modified=Yes;
    Version List=SureStep Funds Module v1.0;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               GenLedgerSetup.GET;
               //TESTFIELD("Stores Requisition No");
               IF "No." = '' THEN BEGIN
                 NoSeriesMgt.InitSeries(GenLedgerSetup."Stores Requisition No",xRec."No. Series",0D,"No.","No. Series");
               END;
               //EXIT(GetNoSeriesRelCode(NoSeriesCode));
               "Request date":=TODAY;
               "Posting Date":=TODAY;
               "User ID":=USERID;
             END;

    OnModify=BEGIN
                 {IF Status=Status::Released THEN
                   ERROR('You Cannot modify an already Approved Requisition');}

               ReqLines.RESET;
               ReqLines.SETRANGE(ReqLines."Requistion No","No.");
               IF ReqLines.FIND('-') THEN BEGIN
               REPEAT
                 ReqLines."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                 ReqLines."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                 ReqLines."Shortcut Dimension 3 Code":="Shortcut Dimension 3 Code";
                 ReqLines."Shortcut Dimension 4 Code":="Shortcut Dimension 4 Code";
               UNTIL ReqLines.NEXT=0;
               END;
             END;

    OnDelete=BEGIN
                 IF Status<>Status::Open THEN
                    ERROR('You Cannot DELETE an already released Requisition')
             END;

  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                //IF "No." = '' THEN BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                    GenLedgerSetup.GET();
                                                                    NoSeriesMgt.TestManual( GenLedgerSetup."Stores Requisition No");
                                                                     "No." := '';
                                                                END;
                                                                //END;
                                                              END;

                                                   Editable=No }
    { 2   ;   ;Request date        ;Date          ;OnValidate=BEGIN
                                                                //IF "Request date" < TODAY THEN ERROR('Required date should be furture date');
                                                              END;
                                                               }
    { 5   ;   ;Required Date       ;Date           }
    { 6   ;   ;Requester ID        ;Code50        ;OnValidate=VAR
                                                                LoginMgt@1000 : Codeunit 418;
                                                              BEGIN
                                                              END;

                                                   OnLookup=VAR
                                                              LoginMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=ENU=Requester ID;
                                                   Editable=No }
    { 7   ;   ;Request Description ;Text150        }
    { 9   ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 10  ;   ;Status              ;Option        ;OptionString=Open,Released,Pending Approval,Pending Prepayment,Cancelled,Posted;
                                                   Editable=Yes }
    { 11  ;   ;Supplier            ;Code20        ;TableRelation=Vendor }
    { 12  ;   ;Action Type         ;Option        ;OnValidate=BEGIN
                                                                     {
                                                                     IF Type=Type::"G/L Account" THEN BEGIN
                                                                        IF "Action Type"="Action Type"::Issue THEN
                                                                                 ERROR('You cannot Issue a G/L Account please order for it')
                                                                     END;


                                                                    //Compare Quantity in Store and Qty to Issue
                                                                     IF Type=Type::Item THEN BEGIN
                                                                        IF "Action Type"="Action Type"::Issue THEN BEGIN
                                                                         IF Quantity>"Qty in store" THEN
                                                                           ERROR('You cannot Issue More than what is available in store')
                                                                        END;
                                                                     END;
                                                                     }
                                                              END;

                                                   OptionString=[ ,Ask for Tender,Ask for Quote] }
    { 29  ;   ;Justification       ;Text250        }
    { 30  ;   ;User ID             ;Code50        ;Editable=No }
    { 31  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                Dimval.RESET;
                                                                Dimval.SETRANGE(Dimval."Global Dimension No.",1);
                                                                Dimval.SETRANGE(Dimval.Code,"Global Dimension 1 Code");
                                                                 IF Dimval.FIND('-') THEN
                                                                    "Function Name":=Dimval.Name
                                                              END;

                                                   CaptionML=ENU=Global Dimension 1 Code;
                                                   NotBlank=No;
                                                   Description=Stores the reference to the first global dimension in the database;
                                                   CaptionClass='1,1,1' }
    { 56  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                Dimval.RESET;
                                                                Dimval.SETRANGE(Dimval."Global Dimension No.",2);
                                                                Dimval.SETRANGE(Dimval.Code,"Shortcut Dimension 2 Code");
                                                                 IF Dimval.FIND('-') THEN
                                                                    "Budget Center Name":=Dimval.Name
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 2 Code;
                                                   NotBlank=No;
                                                   Description=Stores the reference of the second global dimension in the database;
                                                   CaptionClass='1,2,2' }
    { 57  ;   ;Function Name       ;Text100       ;Description=Stores the name of the function in the database }
    { 58  ;   ;Budget Center Name  ;Text100       ;Description=Stores the name of the budget center in the database }
    { 81  ;   ;Shortcut Dimension 3 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3));
                                                   OnValidate=BEGIN
                                                                Dimval.RESET;
                                                                //Dimval.SETRANGE(Dimval."Global Dimension No.",3);
                                                                Dimval.SETRANGE(Dimval.Code,"Shortcut Dimension 3 Code");
                                                                 IF Dimval.FIND('-') THEN
                                                                    Dim3:=Dimval.Name
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 3 Code;
                                                   Description=Stores the reference of the Third global dimension in the database;
                                                   CaptionClass='1,2,3' }
    { 82  ;   ;Shortcut Dimension 4 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4));
                                                   OnValidate=BEGIN
                                                                Dimval.RESET;
                                                                //Dimval.SETRANGE(Dimval."Global Dimension No.",4);
                                                                Dimval.SETRANGE(Dimval.Code,"Shortcut Dimension 4 Code");
                                                                 IF Dimval.FIND('-') THEN
                                                                    Dim4:=Dimval.Name
                                                              END;

                                                   CaptionML=ENU=Shortcut Dimension 4 Code;
                                                   Description=Stores the reference of the Third global dimension in the database;
                                                   CaptionClass='1,2,4' }
    { 83  ;   ;Dim3                ;Text250        }
    { 84  ;   ;Dim4                ;Text250        }
    { 85  ;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   OnValidate=BEGIN

                                                                TESTFIELD(Status,Status::Open);
                                                                IF NOT UserMgt.CheckRespCenter(1,"Responsibility Center") THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    RespCenter.TABLECAPTION,UserMgt.GetPurchasesFilter);
                                                                 {
                                                                "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
                                                                IF "Location Code" = '' THEN BEGIN
                                                                  IF InvtSetup.GET THEN
                                                                    "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
                                                                END ELSE BEGIN
                                                                  IF Location.GET("Location Code") THEN;
                                                                  "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
                                                                END;

                                                                UpdateShipToAddress;
                                                                   }
                                                                   {
                                                                CreateDim(
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DATABASE::Vendor,"Pay-to Vendor No.",
                                                                  DATABASE::"Salesperson/Purchaser","Purchaser Code",
                                                                  DATABASE::Campaign,"Campaign No.");

                                                                IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
                                                                  RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
                                                                  "Assigned User ID" := '';
                                                                END;
                                                                  }
                                                              END;

                                                   CaptionML=ENU=Responsibility Center }
    { 86  ;   ;TotalAmount         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Store Requistion-Lines"."Line Amount" WHERE (Requistion No=FIELD(No.))) }
    { 87  ;   ;Issuing Store       ;Code10        ;TableRelation=Location;
                                                   OnValidate=BEGIN

                                                                ReqLines.RESET;
                                                                ReqLines.SETRANGE(ReqLines."Requistion No","No.");
                                                                IF ReqLines.FIND('-') THEN BEGIN
                                                                REPEAT
                                                                  ReqLines."Issuing Store":="Issuing Store";
                                                                UNTIL ReqLines.NEXT=0;
                                                                END;
                                                              END;
                                                               }
    { 88  ;   ;Job No              ;Code20         }
    { 89  ;   ;Posting Date        ;Date           }
    { 90  ;   ;Document Type       ;Option        ;OptionCaptionML=ENU=" ,Grant,PR";
                                                   OptionString=[ ,Grant,PR] }
    { 91  ;   ;No. Printed         ;Integer       ;CaptionML=ENU=No. Printed;
                                                   Editable=No }
    { 92  ;   ;Cancelled           ;Boolean        }
    { 93  ;   ;Cancelled By        ;Code30         }
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
      NoSeriesMgt@1000000001 : Codeunit 396;
      GenLedgerSetup@1000000000 : Record 312;
      UserMgt@1102755000 : Codeunit 51516155;
      Text001@1102755002 : TextConst 'ENU=Your identification is set up to process from %1 %2 only.';
      Dimval@1102755003 : Record 349;
      ReqLines@1102755004 : Record 51516064;
      HrEmp@1000 : Record 51516160;
      RespCenter@1000000002 : Record 5714;

    PROCEDURE GetNoSeriesRelCode@1(NoSeriesCode@1003 : Code[20]) : Code[10];
    VAR
      GenLedgerSetup@1000 : Record 98;
      DimMgt@1002 : Codeunit 408;
      NoSrsRel@1004 : Record 310;
      RespCenter@1000000000 : Record 5714;
    BEGIN
      //EXIT(GetNoSeriesRelCode(NoSeriesCode));
      {GenLedgerSetup.GET;
      CASE GenLedgerSetup."Base No. Series" OF
        GenLedgerSetup."Base No. Series"::"Responsibility Center":
         BEGIN
          NoSrsRel.RESET;
          NoSrsRel.SETRANGE(Code,NoSeriesCode);
          NoSrsRel.SETRANGE("Series Filter","Responsibility Center");
          IF NoSrsRel.FINDFIRST THEN
            EXIT(NoSrsRel."Series Code")
         END;
        GenLedgerSetup."Base No. Series"::"Shortcut Dimension 1":
         BEGIN
          NoSrsRel.RESET;
          NoSrsRel.SETRANGE(Code,NoSeriesCode);
          NoSrsRel.SETRANGE("Series Filter","Global Dimension 1 Code");
          IF NoSrsRel.FINDFIRST THEN
            EXIT(NoSrsRel."Series Code")
         END;
        GenLedgerSetup."Base No. Series"::"Shortcut Dimension 2":
         BEGIN
          NoSrsRel.RESET;
          NoSrsRel.SETRANGE(Code,NoSeriesCode);
          NoSrsRel.SETRANGE("Series Filter","Shortcut Dimension 2 Code");
          IF NoSrsRel.FINDFIRST THEN
            EXIT(NoSrsRel."Series Code")
         END;
        GenLedgerSetup."Base No. Series"::"Shortcut Dimension 3":
         BEGIN
          NoSrsRel.RESET;
          NoSrsRel.SETRANGE(Code,NoSeriesCode);
          NoSrsRel.SETRANGE("Series Filter","Shortcut Dimension 3 Code");
          IF NoSrsRel.FINDFIRST THEN
            EXIT(NoSrsRel."Series Code")
         END;
        GenLedgerSetup."Base No. Series"::"Shortcut Dimension 4":
         BEGIN
          NoSrsRel.RESET;
          NoSrsRel.SETRANGE(Code,NoSeriesCode);
          NoSrsRel.SETRANGE("Series Filter","Shortcut Dimension 4 Code");
          IF NoSrsRel.FINDFIRST THEN
            EXIT(NoSrsRel."Series Code")
         END;
        ELSE EXIT(NoSeriesCode);
      END;
      }
    END;

    LOCAL PROCEDURE GetNoSeriesCode@9() : Code[10];
    VAR
      NoSeriesCode@1102755001 : Code[20];
    BEGIN
        GenLedgerSetup.GET();
        {
        IF "Document Type" = "Document Type"::Grant THEN
          GenLedgerSetup.TESTFIELD(GenLedgerSetup."Staff Grants Nos.")
       ELSE
       }
          GenLedgerSetup.TESTFIELD(GenLedgerSetup."Stores Requisition No");
        {
        IF "Document Type" = "Document Type"::Grant THEN
          NoSeriesCode:=GenLedgerSetup."Staff Grants Nos."
        ELSE
        }

          NoSeriesCode:=GenLedgerSetup."Stores Requisition No";

        EXIT(GetNoSeriesRelCode(NoSeriesCode));
    END;

    BEGIN
    END.
  }
}

