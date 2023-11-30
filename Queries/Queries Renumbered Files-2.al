OBJECT Query 17200 Bank Rec. Match Candidates
{
  OBJECT-PROPERTIES
  {
    Date=05/28/15;
    Time=[ 4:05:45 PM];
    Modified=Yes;
    Version List=NAVW18.00;
  }
  PROPERTIES
  {
    CaptionML=ENU=Bank Rec. Match Candidates;
  }
  ELEMENTS
  {
    { 1   ;    ;DataItem;                    ;
               DataItemTable=Table50000;
               DataItemTableFilter=Difference=FILTER(<>0),
                                   Type=FILTER(=Bank Account Ledger Entry) }

    { 2   ;1   ;Column  ;Rec_Line_Bank_Account_No;
               DataSource=Bank Account No. }

    { 3   ;1   ;Column  ;Rec_Line_Statement_No;
               DataSource=Statement No. }

    { 4   ;1   ;Column  ;Rec_Line_Statement_Line_No;
               DataSource=Statement Line No. }

    { 5   ;1   ;Column  ;Rec_Line_Transaction_Date;
               DataSource=Transaction Date }

    { 6   ;1   ;Column  ;Rec_Line_Description;
               DataSource=Description }

    { 22  ;1   ;Column  ;Rec_Line_RltdPty_Name;
               DataSource=Related-Party Name }

    { 23  ;1   ;Column  ;Rec_Line_Transaction_Info;
               DataSource=Additional Transaction Info }

    { 7   ;1   ;Column  ;Rec_Line_Statement_Amount;
               DataSource=Statement Amount }

    { 8   ;1   ;Column  ;Rec_Line_Applied_Amount;
               DataSource=Applied Amount }

    { 21  ;1   ;Column  ;Rec_Line_Difference ;
               DataSource=Difference }

    { 9   ;1   ;Column  ;Rec_Line_Type       ;
               DataSource=Type }

    { 10  ;1   ;Column  ;Rec_Line_Applied_Entries;
               DataSource=Applied Entries }

    { 24  ;1   ;Column  ;Rec_Line_Check_No   ;
               DataSource=Check No. }

    { 12  ;1   ;DataItem;                    ;
               DataItemTable=Table271;
               DataItemTableFilter=Remaining Amount=FILTER(<>0),
                                   Open=CONST(Yes),
                                   Statement Status=FILTER(Open);
               DataItemLink=Bank Account No.=Bank_Acc_Statement_Line."Bank Account No." }

    { 11  ;2   ;Column  ;                    ;
               DataSource=Entry No. }

    { 13  ;2   ;Column  ;Bank_Account_No     ;
               DataSource=Bank Account No. }

    { 14  ;2   ;Column  ;                    ;
               DataSource=Posting Date }

    { 15  ;2   ;Column  ;                    ;
               DataSource=Document No. }

    { 16  ;2   ;Column  ;                    ;
               DataSource=Description }

    { 17  ;2   ;Column  ;                    ;
               DataSource=Remaining Amount }

    { 18  ;2   ;Column  ;Bank_Ledger_Entry_Open;
               DataSource=Open }

    { 19  ;2   ;Column  ;                    ;
               DataSource=Statement Status }

    { 20  ;2   ;Column  ;                    ;
               DataSource=External Document No. }

  }
  CODE
  {

    BEGIN
    END.
  }
}

