OBJECT table 20498 Bank Account Ledger Entry Arch
{
  OBJECT-PROPERTIES
  {
    Date=02/05/21;
    Time=[ 1:07:27 PM];
    Modified=Yes;
    Version List=NAVW19.00,NAVNA9.00;
  }
  PROPERTIES
  {
    OnInsert=VAR
               GenJnlPostPreview@1000 : Codeunit 19;
             BEGIN
               GenJnlPostPreview.SaveBankAccLedgEntry(Rec);
             END;

    CaptionML=[ENU=Bank Account Ledger Entry;
               ESM=Mov. banco;
               FRC= criture compte bancaire;
               ENC=Bank Account Ledger Entry];
    LookupPageID=Page372;
    DrillDownPageID=Page372;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[ENU=Entry No.;
                                                              ESM=N  mov.;
                                                              FRC=N   criture;
                                                              ENC=Entry No.] }
    { 3   ;   ;Bank Account No.    ;Code20        ;TableRelation="Bank Account";
                                                   CaptionML=[ENU=Bank Account No.;
                                                              ESM=C d. cuenta banco;
                                                              FRC=N  compte bancaire;
                                                              ENC=Bank Account No.] }
    { 4   ;   ;Posting Date        ;Date          ;CaptionML=[ENU=Posting Date;
                                                              ESM=Fecha registro;
                                                              FRC=Date de report;
                                                              ENC=Posting Date] }
    { 5   ;   ;Document Type       ;Option        ;CaptionML=[ENU=Document Type;
                                                              ESM=Tipo documento;
                                                              FRC=Type de document;
                                                              ENC=Document Type];
                                                   OptionCaptionML=[ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund";
                                                                    ESM=" ,Pago,Factura,Nota cr dito,Docs. inter s,Recordatorio,Reembolso";
                                                                    FRC=" ,Paiement,Facture,Note de cr dit,Note de frais financiers,Rappel,Remboursement";
                                                                    ENC=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 6   ;   ;Document No.        ;Code20        ;CaptionML=[ENU=Document No.;
                                                              ESM=N  documento;
                                                              FRC=N  de document;
                                                              ENC=Document No.] }
    { 7   ;   ;Description         ;Text50        ;CaptionML=[ENU=Description;
                                                              ESM=Descripci n;
                                                              FRC=Description;
                                                              ENC=Description] }
    { 11  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[ENU=Currency Code;
                                                              ESM=C d. divisa;
                                                              FRC=Code devise;
                                                              ENC=Currency Code] }
    { 13  ;   ;Amount              ;Decimal       ;CaptionML=[ENU=Amount;
                                                              ESM=Importe;
                                                              FRC=Montant;
                                                              ENC=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 14  ;   ;Remaining Amount    ;Decimal       ;CaptionML=[ENU=Remaining Amount;
                                                              ESM=Importe pendiente;
                                                              FRC=Solde ouvert;
                                                              ENC=Remaining Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 17  ;   ;Amount (LCY)        ;Decimal       ;CaptionML=[ENU=Amount ($);
                                                              ESM=Importe ($);
                                                              FRC=Montant ($);
                                                              ENC=Amount ($)];
                                                   AutoFormatType=1 }
    { 22  ;   ;Bank Acc. Posting Group;Code10     ;TableRelation="Bank Account Posting Group";
                                                   CaptionML=[ENU=Bank Acc. Posting Group;
                                                              ESM=Grupo contable banco;
                                                              FRC=Groupe reports compte bancaire;
                                                              ENC=Bank Acc. Posting Group] }
    { 23  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[ENU=Global Dimension 1 Code;
                                                              ESM=C d. dimensi n global 1;
                                                              FRC=Code de dimension principal 1;
                                                              ENC=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 24  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[ENU=Global Dimension 2 Code;
                                                              ESM=C d. dimensi n global 2;
                                                              FRC=Code de dimension principal 2;
                                                              ENC=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 25  ;   ;Our Contact Code    ;Code10        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[ENU=Our Contact Code;
                                                              ESM=Ntro. c d. contacto;
                                                              FRC=Notre code contact;
                                                              ENC=Our Contact Code] }
    { 27  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   CaptionML=[ENU=User ID;
                                                              ESM=Id. usuario;
                                                              FRC=Code utilisateur;
                                                              ENC=User ID] }
    { 28  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[ENU=Source Code;
                                                              ESM=C d. origen;
                                                              FRC=Code d'origine;
                                                              ENC=Source Code] }
    { 36  ;   ;Open                ;Boolean       ;CaptionML=[ENU=Open;
                                                              ESM=Pendiente;
                                                              FRC=Ouvert;
                                                              ENC=Open] }
    { 43  ;   ;Positive            ;Boolean       ;CaptionML=[ENU=Positive;
                                                              ESM=Positivo;
                                                              FRC=Positif;
                                                              ENC=Positive] }
    { 44  ;   ;Closed by Entry No. ;Integer       ;TableRelation="Bank Account Ledger Entry";
                                                   CaptionML=[ENU=Closed by Entry No.;
                                                              ESM=Cerrado por n  mov.;
                                                              FRC=Ferm  par l' criture n ;
                                                              ENC=Closed by Entry No.] }
    { 45  ;   ;Closed at Date      ;Date          ;CaptionML=[ENU=Closed at Date;
                                                              ESM=Cerrado a la fecha;
                                                              FRC=Ferm  en date de;
                                                              ENC=Closed at Date] }
    { 49  ;   ;Journal Batch Name  ;Code10        ;CaptionML=[ENU=Journal Batch Name;
                                                              ESM=Nombre secci n diario;
                                                              FRC=Nom lot de journal;
                                                              ENC=Journal Batch Name] }
    { 50  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[ENU=Reason Code;
                                                              ESM=C d. auditor a;
                                                              FRC=Code motif;
                                                              ENC=Reason Code] }
    { 51  ;   ;Bal. Account Type   ;Option        ;CaptionML=[ENU=Bal. Account Type;
                                                              ESM=Tipo contrapartida;
                                                              FRC=Type compte contr le;
                                                              ENC=Bal. Account Type];
                                                   OptionCaptionML=[ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,,Employee;
                                                                    ESM=Cuenta,Cliente,Proveedor,Banco,Activo,,Empleado;
                                                                    FRC=Compte GL,Client,Fournisseur,Compte bancaire,Immobilisation,,Employ ;
                                                                    ENC=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,,Employee];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,,Employee }
    { 52  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                 ELSE IF (Bal. Account Type=CONST(Employee)) Employee;
                                                   CaptionML=[ENU=Bal. Account No.;
                                                              ESM=Cta. contrapartida;
                                                              FRC=N  compte contr le;
                                                              ENC=Bal. Account No.] }
    { 53  ;   ;Transaction No.     ;Integer       ;CaptionML=[ENU=Transaction No.;
                                                              ESM=N  asiento;
                                                              FRC=N  transaction;
                                                              ENC=Transaction No.] }
    { 55  ;   ;Statement Status    ;Option        ;CaptionML=[ENU=Statement Status;
                                                              ESM=Estado liquidaci n;
                                                              FRC= tat du relev ;
                                                              ENC=Statement Status];
                                                   OptionCaptionML=[ENU=Open,Bank Acc. Entry Applied,Check Entry Applied,Closed;
                                                                    ESM=Pendiente,Liq. por mov. banco,Liq. por mov. cheque,Cerrado;
                                                                    FRC=Ouvert, criture de compte bancaire affect e, criture ch que affect e,Ferm ;
                                                                    ENC=Open,Bank Acc. Entry Applied,Cheque Entry Applied,Closed];
                                                   OptionString=Open,Bank Acc. Entry Applied,Check Entry Applied,Closed }
    { 56  ;   ;Statement No.       ;Code20        ;TableRelation=IF (Statement Status=FILTER(Bank Acc. Entry Applied|Check Entry Applied)) "Bank Rec. Header"."Statement No." WHERE (Bank Account No.=FIELD(Bank Account No.))
                                                                 ELSE IF (Statement Status=CONST(Closed)) "Posted Bank Rec. Header"."Statement No." WHERE (Bank Account No.=FIELD(Bank Account No.));
                                                   TestTableRelation=No;
                                                   CaptionML=[ENU=Statement No.;
                                                              ESM=N  estado de cta. banco;
                                                              FRC=N  de relev ;
                                                              ENC=Statement No.] }
    { 57  ;   ;Statement Line No.  ;Integer       ;TableRelation=IF (Statement Status=FILTER(Bank Acc. Entry Applied|Check Entry Applied)) "Bank Rec. Line"."Line No." WHERE (Bank Account No.=FIELD(Bank Account No.),
                                                                                                                                                                              Statement No.=FIELD(Statement No.))
                                                                                                                                                                              ELSE IF (Statement Status=CONST(Closed)) "Posted Bank Rec. Line"."Line No." WHERE (Bank Account No.=FIELD(Bank Account No.),
                                                                                                                                                                                                                                                                 Statement No.=FIELD(Statement No.));
                                                   TestTableRelation=No;
                                                   CaptionML=[ENU=Statement Line No.;
                                                              ESM=N  l n. estado de cta. banco;
                                                              FRC=N  ligne relev ;
                                                              ENC=Statement Line No.] }
    { 58  ;   ;Debit Amount        ;Decimal       ;CaptionML=[ENU=Debit Amount;
                                                              ESM=Importe debe;
                                                              FRC=Montant de d bit;
                                                              ENC=Debit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 59  ;   ;Credit Amount       ;Decimal       ;CaptionML=[ENU=Credit Amount;
                                                              ESM=Importe haber;
                                                              FRC=Montant de cr dit;
                                                              ENC=Credit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 60  ;   ;Debit Amount (LCY)  ;Decimal       ;CaptionML=[ENU=Debit Amount ($);
                                                              ESM=Importe debe ($);
                                                              FRC=Montant de d bit ($);
                                                              ENC=Debit Amount ($)];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 61  ;   ;Credit Amount (LCY) ;Decimal       ;CaptionML=[ENU=Credit Amount ($);
                                                              ESM=Importe haber ($);
                                                              FRC=Montant de cr dit ($);
                                                              ENC=Credit Amount ($)];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 62  ;   ;Document Date       ;Date          ;CaptionML=[ENU=Document Date;
                                                              ESM=Fecha emisi n documento;
                                                              FRC=Date document;
                                                              ENC=Document Date];
                                                   ClosingDates=Yes }
    { 63  ;   ;External Document No.;Code35       ;CaptionML=[ENU=External Document No.;
                                                              ESM=N  documento externo;
                                                              FRC=N  document externe;
                                                              ENC=External Document No.] }
    { 64  ;   ;Reversed            ;Boolean       ;CaptionML=[ENU=Reversed;
                                                              ESM=Revertido;
                                                              FRC=Renvers e;
                                                              ENC=Reversed] }
    { 65  ;   ;Reversed by Entry No.;Integer      ;TableRelation="Bank Account Ledger Entry";
                                                   CaptionML=[ENU=Reversed by Entry No.;
                                                              ESM=Revertido por el movimiento n ;
                                                              FRC=Renvers e par l' criture n ;
                                                              ENC=Reversed by Entry No.];
                                                   BlankZero=Yes }
    { 66  ;   ;Reversed Entry No.  ;Integer       ;TableRelation="Bank Account Ledger Entry";
                                                   CaptionML=[ENU=Reversed Entry No.;
                                                              ESM=N  movimiento revertido;
                                                              FRC= criture renvers e n ;
                                                              ENC=Reversed Entry No.];
                                                   BlankZero=Yes }
    { 70  ;   ;Check Ledger Entries;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Check Ledger Entry" WHERE (Bank Account Ledger Entry No.=FIELD(Entry No.)));
                                                   CaptionML=[ENU=Check Ledger Entries;
                                                              ESM=Movs. cheques;
                                                              FRC= critures du grand livre de contr le;
                                                              ENC=Cheque Ledger Entries] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[ENU=Dimension Set ID;
                                                              ESM=Id. grupo dimensiones;
                                                              FRC=Code ensemble de dimensions;
                                                              ENC=Dimension Set ID];
                                                   Editable=No }
    { 481 ;   ;Naration            ;Text250       ;OnValidate=BEGIN

                                                                Naration:=Treasury.Naration;
                                                              END;

                                                   CaptionML=[SWK=Naration;
                                                              ENG=Naration] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Bank Account No.,Posting Date           ;SumIndexFields=Amount,Amount (LCY),Debit Amount,Credit Amount,Debit Amount (LCY),Credit Amount (LCY) }
    {    ;Bank Account No.,Open                    }
    {    ;Document Type,Bank Account No.,Posting Date;
                                                   SumIndexFields=Amount;
                                                   MaintainSQLIndex=No }
    {    ;Document No.,Posting Date                }
    {    ;Transaction No.                          }
    { No ;Bank Account No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date;
                                                   SumIndexFields=Amount,Amount (LCY),Debit Amount,Credit Amount,Debit Amount (LCY),Credit Amount (LCY) }
    {    ;Bank Account No.,Posting Date,Statement Status }
    { No ;External Document No.,Posting Date      ;KeyGroups=NavDep }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Description,Bank Account No.,Posting Date,Document Type,Document No. }
  }
  CODE
  {
    VAR
      DimMgt@1000 : Codeunit 408;
      Treasury@1120054000 : Record 51516301;

    PROCEDURE ShowDimensions@1();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    END;

    PROCEDURE CopyFromGenJnlLine@3(GenJnlLine@1000 : Record 81);
    BEGIN
      "Bank Account No." := GenJnlLine."Account No.";
      "Posting Date" := GenJnlLine."Posting Date";
      "Document Date" := GenJnlLine."Document Date";
      "Document Type" := GenJnlLine."Document Type";
      "Document No." := GenJnlLine."Document No.";
      "External Document No." := GenJnlLine."External Document No.";
      Description := GenJnlLine.Description;
      "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := GenJnlLine."Dimension Set ID";
      "Our Contact Code" := GenJnlLine."Salespers./Purch. Code";
      "Source Code" := GenJnlLine."Source Code";
      "Journal Batch Name" := GenJnlLine."Journal Batch Name";
      "Reason Code" := GenJnlLine."Reason Code";
      "Currency Code" := GenJnlLine."Currency Code";
      "User ID" := USERID;
      "Bal. Account Type" := GenJnlLine."Bal. Account Type";
      "Bal. Account No." := GenJnlLine."Bal. Account No.";
    END;

    PROCEDURE UpdateDebitCredit@2(Correction@1000 : Boolean);
    BEGIN
      IF (Amount > 0) AND (NOT Correction) OR
         (Amount < 0) AND Correction
      THEN BEGIN
        "Debit Amount" := Amount;
        "Credit Amount" := 0;
        "Debit Amount (LCY)" := "Amount (LCY)";
        "Credit Amount (LCY)" := 0;
      END ELSE BEGIN
        "Debit Amount" := 0;
        "Credit Amount" := -Amount;
        "Debit Amount (LCY)" := 0;
        "Credit Amount (LCY)" := -"Amount (LCY)";
      END;
    END;

    PROCEDURE IsApplied@4() IsApplied : Boolean;
    VAR
      CheckLedgerEntry@1000 : Record 272;
    BEGIN
      CheckLedgerEntry.SETRANGE("Bank Account No.","Bank Account No.");
      CheckLedgerEntry.SETRANGE("Bank Account Ledger Entry No.","Entry No.");
      CheckLedgerEntry.SETRANGE(Open,TRUE);
      CheckLedgerEntry.SETRANGE("Statement Status",CheckLedgerEntry."Statement Status"::"Check Entry Applied");
      CheckLedgerEntry.SETFILTER("Statement No.",'<>%1','');
      CheckLedgerEntry.SETFILTER("Statement Line No.",'<>%1',0);
      IsApplied := NOT CheckLedgerEntry.ISEMPTY;

      IsApplied := IsApplied OR
        (("Statement Status" = "Statement Status"::"Bank Acc. Entry Applied") AND
         ("Statement No." <> '') AND ("Statement Line No." <> 0));

      EXIT(IsApplied);
    END;

    PROCEDURE SetStyle@5() : Text;
    BEGIN
      IF IsApplied THEN
        EXIT('Favorable');

      EXIT('');
    END;

    BEGIN
    END.
  }
}

