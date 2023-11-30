OBJECT CodeUnit 20368 Silent Reversal-Post
{
  OBJECT-PROPERTIES
  {
    Date=02/26/21;
    Time=[ 6:33:40 PM];
    Modified=Yes;
    Version List=SkyCoop;
  }
  PROPERTIES
  {
    TableNo=179;
    OnRun=VAR
            GLReg@1003 : Record 45;
            GenJnlTemplate@1002 : Record 80;
            GenJnlPostReverse@1001 : Codeunit 17;
            Txt@1004 : Text[1024];
            WarningText@1000 : Text[250];
            Number@1005 : Integer;
          BEGIN
            RESET;
            SETRANGE("Entry Type","Entry Type"::"Fixed Asset");
            IF FINDFIRST THEN
              WarningText := Text007;
            SETRANGE("Entry Type");
            IF PrintRegister THEN
              Txt := Text004 + WarningText + '\' + Text005
            ELSE
              Txt := Text004 + WarningText + '\' + Text002;
            IF NOT FINDFIRST THEN
              ERROR(Text006);
            //IF CONFIRM(Txt,FALSE) THEN BEGIN
              ReversalEntry := Rec;
              IF "Reversal Type" = "Reversal Type"::Transaction THEN
                ReversalEntry.SetReverseFilter("Transaction No.","Reversal Type")
              ELSE
                ReversalEntry.SetReverseFilter("G/L Register No.","Reversal Type");
              ReversalEntry.CheckEntries;
              GET(1);
              IF "Reversal Type" = "Reversal Type"::Register THEN
                Number := "G/L Register No."
              ELSE
                Number := "Transaction No.";
              IF NOT ReversalEntry.VerifyReversalEntries(Rec,Number,"Reversal Type") THEN
                ERROR(Text008);
              GenJnlPostReverse.Reverse(ReversalEntry,Rec);
              IF PrintRegister THEN BEGIN
                GenJnlTemplate.VALIDATE(Type);
                IF GenJnlTemplate."Posting Report ID" <> 0 THEN
                  IF GLReg.FINDLAST THEN BEGIN;
                    GLReg.SETRECFILTER;
                    REPORT.RUN(GenJnlTemplate."Posting Report ID",FALSE,FALSE,GLReg);
                  END;
              END;
              DELETEALL;
              //MESSAGE(Text003);
            //END;
          END;

  }
  CODE
  {
    VAR
      Text002@1007 : TextConst 'ENU=Do you want to reverse the entries?;ESM= Desea revertir estos movimientos?;FRC=Voulez-vous inverser les  critures ?;ENC=Do you want to reverse the entries?';
      Text003@1005 : TextConst 'ENU=The entries were successfully reversed.;ESM=Movimientos revertidos correctamente.;FRC=La contrepassation des  critures a r ussi.;ENC=The entries were successfully reversed.';
      Text004@1012 : TextConst 'ENU=To reverse these entries, correcting entries will be posted.;ESM=Para revertir los movimientos, se registrar n los movimientos que los corrijan.;FRC=Pour inverser ces  critures, des  critures de correction seront report es.;ENC=To reverse these entries, correcting entries will be posted.';
      Text005@1000 : TextConst 'ENU=Do you want to reverse the entries and print the report?;ESM= Desea revertir los movimientos e imprimir el informe?;FRC=Voulez-vous inverser les  critures et imprimer l'' tat ?;ENC=Do you want to reverse the entries and print the report?';
      Text006@1001 : TextConst 'ENU=There is nothing to reverse.;ESM=No hay movimientos para revertir.;FRC=Aucun  l ment   inverser.;ENC=There is nothing to reverse.';
      Text007@1004 : TextConst 'ENU=\There are one or more FA Ledger Entries. You should consider using the fixed asset function Cancel Entries.;ESM=\Hay uno o varios movimientos de A/F. Es recomendable usar la funci n de activos fijos de cancelar movimientos.;FRC=\Il existe une ou plusieurs  critures immobilisation. La fonction des immobilisations Annuler  critures peut s''av rer utile.;ENC=\There are one or more FA Ledger Entries. You should consider using the fixed asset function Cancel Entries.';
      Text008@1003 : TextConst 'ENU=Changes have been made to posted entries after the window was opened.\Close and reopen the window to continue.;ESM=Se han modificado entradas registradas despu s de abrir la ventana.\Cierre la ventana y vuelva a abrirla para continuar.;FRC=Des modifications ont  t  apport es aux  critures report es apr s l''ouverture de la fen tre.\Fermez et rouvrez la fen tre pour continuer.;ENC=Changes have been made to posted entries after the window was opened.\Close and reopen the window to continue.';
      ReversalEntry@1002 : Record 179;
      PrintRegister@1009 : Boolean;

    PROCEDURE SetPrint@1000(NewPrintRegister@1001 : Boolean);
    BEGIN
      PrintRegister := NewPrintRegister;
    END;

    BEGIN
    END.
  }
}

