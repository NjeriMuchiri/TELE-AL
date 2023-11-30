OBJECT table 50048 Store Requistion-Lines
{
  OBJECT-PROPERTIES
  {
    Date=09/14/20;
    Time=12:41:36 PM;
    Modified=Yes;
    Version List=SureStep Funds Module v1.0;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
                  "Line Amount":="Unit Cost"*Quantity;

                ReqHeader.RESET;
                ReqHeader.SETRANGE(ReqHeader."No.","Requistion No");
                IF ReqHeader.FIND('-') THEN BEGIN
                 "Shortcut Dimension 1 Code":=ReqHeader."Global Dimension 1 Code";
                 "Shortcut Dimension 2 Code":=ReqHeader."Shortcut Dimension 2 Code";
                 "Shortcut Dimension 3 Code":=ReqHeader."Shortcut Dimension 3 Code";
                 "Shortcut Dimension 4 Code":=ReqHeader."Shortcut Dimension 4 Code";
                 IF ReqHeader.Status<>ReqHeader.Status::Open THEN
                     ERROR('You Cannot Enter Entries if status is not Pending')
                END;
             END;

    OnModify=BEGIN
                 IF Type=Type::Item THEN
                  "Line Amount":="Unit Cost"*Quantity;

               { ReqHeader.RESET;
                ReqHeader.SETRANGE(ReqHeader."No.","Requistion No");
                IF ReqHeader.FIND('-') THEN BEGIN
                 "Shortcut Dimension 1 Code":=ReqHeader."Global Dimension 1 Code";
                 "Shortcut Dimension 2 Code":=ReqHeader."Shortcut Dimension 2 Code";
                 "Shortcut Dimension 3 Code":=ReqHeader."Shortcut Dimension 3 Code";
                 "Shortcut Dimension 4 Code":=ReqHeader."Shortcut Dimension 4 Code";
                 IF ReqHeader.Status<>ReqHeader.Status::Open THEN
                     ERROR('You Cannot Modify Entries if status is not Pending')
                END; }
             END;

    OnDelete=BEGIN
                ReqHeader.RESET;
                ReqHeader.SETRANGE(ReqHeader."No.","Requistion No");
                IF ReqHeader.FIND('-') THEN
                 IF ReqHeader.Status<>ReqHeader.Status::Open THEN
                     ERROR('You Cannot Delete Entries if status is not Pending')
             END;

  }
  FIELDS
  {
    { 1   ;   ;Requistion No       ;Code20        ;OnValidate=BEGIN
                                                                {
                                                                  IF ReqHeader.GET("Requistion No") THEN BEGIN
                                                                    IF ReqHeader."Global Dimension 1 Code"='' THEN
                                                                       ERROR('Please Select the Global Dimension 1 Requisitioning')
                                                                  END;
                                                                 }
                                                              END;
                                                               }
    { 3   ;   ;Line No.            ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=ENU=Line No. }
    { 4   ;   ;Type                ;Option        ;CaptionML=ENU=Type;
                                                   OptionCaptionML=ENU=" ,Item,Minor Asset";
                                                   OptionString=[ ,Item,Minor Asset] }
    { 5   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(Item)) Item.No.
                                                                 ELSE IF (Type=CONST(Minor Asset)) "Fixed Asset".No. WHERE (FA Location Code=FIELD(Issuing Store),
                                                                                                                            Issued=CONST(No));
                                                   OnValidate=BEGIN


                                                                  //Control: Don't Post Same Item Twice NOT GL's
                                                                 IF Type=Type::Item THEN BEGIN
                                                                 RequisitionLine.RESET;
                                                                 RequisitionLine.SETRANGE(RequisitionLine."Requistion No","Requistion No");
                                                                 RequisitionLine.SETRANGE(RequisitionLine."No.","No.");
                                                                 IF RequisitionLine.FIND('-') THEN
                                                                    ERROR('You Cannot enter two lines for the same Item');
                                                                 END;
                                                                 //


                                                                "Action Type":="Action Type"::"Ask for Quote";

                                                                IF Type=Type::Item THEN BEGIN
                                                                   IF QtyStore.GET("No.") THEN
                                                                      Description:=QtyStore.Description;

                                                                      IF ReqHeader.GET("Requistion No") THEN BEGIN
                                                                      "Issuing Store":=ReqHeader."Issuing Store";
                                                                      END;

                                                                      "Unit of Measure":=QtyStore."Base Unit of Measure";
                                                                      "Unit Cost":=QtyStore."Unit Cost";
                                                                      "Line Amount":="Unit Cost"*Quantity;
                                                                      QtyStore.CALCFIELDS(QtyStore.Inventory);
                                                                      "Qty in store":=QtyStore.Inventory;
                                                                 END;

                                                                {IF Type=Type::Item THEN BEGIN
                                                                   IF GLAccount.GET("No.") THEN
                                                                      Description:=GLAccount.Name;
                                                                 END;}

                                                                {
                                                                {Modified}
                                                                         //Validate Item
                                                                      GLAccount.GET(QtyStore."Item G/L Budget Account");
                                                                      GLAccount.CheckGLAcc;

                                                                }

                                                                    { IF Type=Type::"G/L Account" THEN BEGIN
                                                                        IF "Action Type"="Action Type"::Issue THEN
                                                                                 ERROR('You cannot Issue a G/L Account please order for it')
                                                                     END;
                                                                      }

                                                                    //Compare Quantity in Store and Qty to Issue
                                                                     IF Type=Type::Item THEN BEGIN
                                                                        IF "Action Type"="Action Type"::Issue THEN BEGIN
                                                                         IF Quantity>"Qty in store" THEN
                                                                           ERROR('You cannot Issue More than what is available in store')
                                                                        END;
                                                                     END;
                                                              END;

                                                   CaptionML=ENU=No. }
    { 6   ;   ;Description         ;Text50        ;CaptionML=ENU=Description }
    { 7   ;   ;Description 2       ;Text50        ;CaptionML=ENU=Description 2 }
    { 8   ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                IF Type=Type::Item THEN BEGIN
                                                                      "Line Amount":="Unit Cost"*Quantity;
                                                                END;

                                                                IF Quantity>"Quantity Requested" THEN
                                                                  ERROR('Quantity issued cannot be greater than quantity requested');

                                                                //   IF QtyStore.GET("No.") THEN
                                                                //      QtyStore.CALCFIELDS(QtyStore.Inventory);
                                                                //      "Qty in store":=QtyStore.Inventory;
                                                                //       Qty:=QtyStore.Inventory;

                                                                    ItemLedgerEntry.RESET;
                                                                    ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Item No.","No.");
                                                                    ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Location Code","Issuing Store");
                                                                    IF ItemLedgerEntry.FIND('-') THEN BEGIN
                                                                         // QtyStore.CALCFIELDS(ItemLedgerEntry.Inventory);
                                                                          Qty:=ItemLedgerEntry.Quantity;
                                                                   END;

                                                                //ERROR('You cannot request more  than what is in the store');

                                                                IF "Quantity Requested"<0 THEN
                                                                ERROR('You cannot request negative quantities');




                                                                // IF Quantity>"Quantity Requested" THEN
                                                                //   ERROR('Quantity issued cannot be greater than quantity requested');
                                                                //
                                                                //
                                                                // IF Type=Type::Item THEN BEGIN
                                                                //       "Line Amount":="Unit Cost"*Quantity;
                                                                // END;
                                                                //
                                                                //    IF QtyStore.GET("No.") THEN
                                                                //       QtyStore.CALCFIELDS(QtyStore.Inventory);
                                                                //       "Qty in store":=QtyStore.Inventory;
                                                              END;

                                                   CaptionML=ENU=Quantity;
                                                   DecimalPlaces=0:5 }
    { 9   ;   ;Qty in store        ;Decimal       ;FieldClass=Normal }
    { 10  ;   ;Request Status      ;Option        ;OptionString=Pending,Released,Director Approval,Budget Approval,FD Approval,CEO Approval,Approved,Closed;
                                                   Editable=Yes }
    { 11  ;   ;Action Type         ;Option        ;OnValidate=BEGIN
                                                                     IF Type=Type::Item THEN BEGIN
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
                                                              END;

                                                   OptionString=[ ,Issue,Ask for Quote] }
    { 12  ;   ;Unit of Measure     ;Code20        ;TableRelation="Unit of Measure" }
    { 13  ;   ;Total Budget        ;Decimal        }
    { 14  ;   ;Current Month Budget;Decimal        }
    { 15  ;   ;Unit Cost           ;Decimal       ;OnValidate=BEGIN
                                                                 // IF Type=Type::Item THEN
                                                                   "Line Amount":="Unit Cost"*Quantity;
                                                              END;
                                                               }
    { 16  ;   ;Line Amount         ;Decimal        }
    { 17  ;   ;Quantity Requested  ;Decimal       ;OnValidate=BEGIN
                                                                Quantity:="Quantity Requested";
                                                                    VALIDATE(Quantity);
                                                                "Line Amount":="Unit Cost"*Quantity;


                                                                //       IF QtyStore.GET("No.") THEN
                                                                //      QtyStore.CALCFIELDS(QtyStore.Inventory);
                                                                //      "Qty in store":=QtyStore.Inventory;
                                                                //       Qty:=QtyStore.Inventory;

                                                                    ItemLedgerEntry.RESET;
                                                                    ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Item No.","No.");
                                                                    ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Location Code","Issuing Store");
                                                                    IF ItemLedgerEntry.FIND('-') THEN BEGIN
                                                                         // QtyStore.CALCFIELDS(ItemLedgerEntry.Inventory);
                                                                          Qty:=ItemLedgerEntry.Quantity
                                                                          END;


                                                                // IF "Last Quantity Issued">"Qty in store" THEN
                                                                // ERROR('You cannot request more  than what is in the store');
                                                                //

                                                                IF "Quantity Requested">Qty THEN
                                                                ERROR('You cannot request more  than what is in the store');





                                                                // Quantity:="Quantity Requested";
                                                                //     VALIDATE(Quantity);
                                                                // "Line Amount":="Unit Cost"*Quantity;
                                                              END;

                                                   CaptionML=ENU=Quantity Requested;
                                                   DecimalPlaces=0:5 }
    { 24  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=ENU=Shortcut Dimension 1 Code;
                                                   CaptionClass='1,2,1' }
    { 25  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=ENU=Shortcut Dimension 2 Code;
                                                   CaptionClass='1,2,2' }
    { 26  ;   ;Current Actuals Amount;Decimal      }
    { 27  ;   ;Committed           ;Boolean        }
    { 81  ;   ;Shortcut Dimension 3 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3));
                                                   CaptionML=ENU=Shortcut Dimension 3 Code;
                                                   Description=Stores the reference of the Third global dimension in the database;
                                                   CaptionClass='1,2,3' }
    { 82  ;   ;Shortcut Dimension 4 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4));
                                                   CaptionML=ENU=Shortcut Dimension 4 Code;
                                                   Description=Stores the reference of the Third global dimension in the database;
                                                   CaptionClass='1,2,4' }
    { 83  ;   ;Issuing Store       ;Code20        ;TableRelation=IF (Type=CONST(Item)) Location
                                                                 ELSE IF (Type=CONST(Minor Asset)) "FA Location" }
    { 84  ;   ;Posting Date        ;Date           }
    { 85  ;   ;Last Date of Issue  ;Date           }
  }
  KEYS
  {
    {    ;Requistion No,No.                       ;SumIndexFields=Line Amount;
                                                   Clustered=Yes }
    {    ;No.,Type,Request Status                 ;SumIndexFields=Quantity }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      GLAccount@1000000001 : Record 15;
      GenLedSetup@1000000000 : Record 98;
      QtyStore@1000000002 : Record 27;
      GenPostGroup@1000000003 : Record 252;
      Budget@1000000004 : Decimal;
      CurrMonth@1000000005 : Code[10];
      CurrYR@1000000006 : Code[10];
      BudgDate@1000000007 : Text[30];
      ReqHeader@1000000008 : Record 51516063;
      BudgetDate@1000000009 : Date;
      YrBudget@1000000010 : Decimal;
      RequisitionLine@1000000011 : Record 51516064;
      Item@1102756000 : Record 27;
      FA@1102756001 : Record 5600;
      ItemLedgerEntry@1120054000 : Record 32;
      Qty@1120054001 : Decimal;

    BEGIN
    END.
  }
}

