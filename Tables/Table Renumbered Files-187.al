OBJECT table 17305 Treasury Transactions
{
  OBJECT-PROPERTIES
  {
    Date=02/16/22;
    Time=[ 4:37:10 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF No = '' THEN BEGIN
               NoSetup.GET();
               NoSetup.TESTFIELD(NoSetup."Treasury Transactions No");
               NoSeriesMgt.InitSeries(NoSetup."Treasury Transactions No",xRec."No. Series",0D,No,"No. Series");
               END;

               IF "Transaction Type"="Transaction Type"::"Issue To Teller" THEN
               Description:='ISSUE TO TELLER'
               ELSE IF "Transaction Type"="Transaction Type"::"Issue From Bank" THEN
               Description:='ISSUE FROM BANK'
               ELSE
               Description:='RETURN TO TREASURY';

               //IF UsersID.GET(USERID) THEN
               //"Transacting Branch":=UsersID.Branch;

               Requester:=USERID;
               "Transaction Date":=TODAY;
               "Transaction Time":=TIME;

               Denominations.RESET;
               TransactionCoinage.RESET;
               Denominations.INIT;
               TransactionCoinage.INIT;

               IF Denominations.FIND('-') THEN BEGIN

               REPEAT
               TransactionCoinage.No:=No;
               TransactionCoinage.Code:=Denominations.Code;
               TransactionCoinage.Description:=Denominations.Description;
               TransactionCoinage.Type:=Denominations.Type;
               TransactionCoinage.Value:=Denominations.Value;
               TransactionCoinage.Quantity:=0;
               TransactionCoinage.INSERT;
               UNTIL Denominations.NEXT = 0;

               END;
             END;

    OnModify=BEGIN
               IF Posted THEN BEGIN
               ERROR('The transaction has been posted and therefore cannot be modified.');
               EXIT;
               END;
             END;

    OnDelete=BEGIN
               IF Posted THEN BEGIN
               ERROR('The transaction has been posted and therefore cannot be deleted.');
               EXIT;
               END;
             END;

    OnRename=BEGIN
               IF Posted THEN BEGIN
               ERROR('The transaction has been posted and therefore cannot be modified.');
               EXIT;
               END;
             END;

  }
  FIELDS
  {
    { 1   ;   ;No                  ;Code20        ;OnValidate=BEGIN
                                                                IF No <> xRec.No THEN BEGIN
                                                                  NoSetup.GET( );
                                                                  NoSeriesMgt.TestManual(NoSetup."Treasury Transactions No");
                                                                  "No. Series" := '';
                                                                END;

                                                                Requester:=USERID;
                                                              END;
                                                               }
    { 2   ;   ;Transaction Date    ;Date           }
    { 3   ;   ;Transaction Type    ;Option        ;OnValidate=BEGIN
                                                                IF "Transaction Type"="Transaction Type"::"Issue To Teller" THEN
                                                                Description:='ISSUE TO TELLER';

                                                                IF "Transaction Type"="Transaction Type"::"Return To Treasury" THEN
                                                                Description:='RETURN TO TREASURY';

                                                                IF "Transaction Type"="Transaction Type"::"Inter Teller Transfers" THEN
                                                                Description:='INTER TELLER TRANSFERS';

                                                                IF "Transaction Type"="Transaction Type"::"Issue From Bank" THEN
                                                                Description:='ISSUE FROM BANK';

                                                                IF "Transaction Type"="Transaction Type"::"Return To Bank" THEN
                                                                Description:='RETURN TO BANK';

                                                                IF "Transaction Type"="Transaction Type"::"End of Day Return to Treasury" THEN
                                                                Description:='END OF DAY RETURN TO TREASURY';


                                                                IF "Transaction Type"="Transaction Type"::"Branch Treasury Transactions" THEN
                                                                Description:='BRANCH TREASURY TRANSACTIONS';


                                                                "From Account":='';
                                                                "To Account":='';
                                                              END;

                                                   OptionCaptionML=ENU=Issue To Teller,Return To Treasury,Issue From Bank,Return To Bank,Inter Teller Transfers,End of Day Return to Treasury,Branch Treasury Transactions;
                                                   OptionString=Issue To Teller,Return To Treasury,Issue From Bank,Return To Bank,Inter Teller Transfers,End of Day Return to Treasury,Branch Treasury Transactions }
    { 4   ;   ;From Account        ;Code20        ;TableRelation=IF (Transaction Type=FILTER(Issue To Teller|Return To Bank|Branch Treasury Transactions)) "Bank Account".No. WHERE (Account Type=CONST(Treasury))
                                                                 ELSE IF (Transaction Type=FILTER(Return To Treasury|Return To Treasury|Inter Teller Transfers)) "Bank Account".No. WHERE (Account Type=CONST(Cashier))
                                                                 ELSE IF (Transaction Type=FILTER(Issue From Bank)) "Bank Account".No. WHERE (Account Type=CONST(" "));
                                                   OnValidate=BEGIN
                                                                IF "Transaction Type"="Transaction Type"::"Issue To Teller" THEN
                                                                BEGIN
                                                                IF requested=FALSE THEN ERROR('Transaction should be requested before issuing.');
                                                                END;
                                                                Banks.RESET;
                                                                Banks.SETRANGE(Banks."No.","From Account");
                                                                IF Banks.FIND('-') THEN BEGIN
                                                                "From Account Name":=Banks.Name;
                                                                MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 5   ;   ;To Account          ;Code20        ;TableRelation=IF (Transaction Type=FILTER(Return To Treasury|Issue From Bank|Branch Treasury Transactions)) "Bank Account".No. WHERE (Account Type=CONST(Treasury))
                                                                 ELSE IF (Transaction Type=FILTER(Issue To Teller|Inter Teller Transfers)) "Bank Account".No. WHERE (Account Type=CONST(Cashier))
                                                                 ELSE IF (Transaction Type=FILTER(Return To Bank)) "Bank Account".No. WHERE (Account Type=CONST(" "));
                                                   OnValidate=BEGIN
                                                                Banks.RESET;
                                                                Banks.SETRANGE(Banks."No.","To Account");
                                                                IF Banks.FIND('-') THEN BEGIN
                                                                "To Account Name":=Banks.Name;
                                                                MODIFY;
                                                                END;
                                                              END;
                                                               }
    { 6   ;   ;Description         ;Text100        }
    { 7   ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                IF "Transaction Type"="Transaction Type"::"Issue To Teller" THEN BEGIN
                                                                IF Amount>"Amount to request" THEN
                                                                ERROR('Amount should be equal or less than amount requested.');
                                                                END;
                                                              END;
                                                               }
    { 8   ;   ;Posted              ;Boolean        }
    { 9   ;   ;Date Posted         ;Date           }
    { 10  ;   ;Time Posted         ;Time           }
    { 11  ;   ;Posted By           ;Text30         }
    { 12  ;   ;No. Series          ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=No. Series;
                                                   Editable=No }
    { 13  ;   ;Transaction Time    ;Time           }
    { 14  ;   ;Coinage Amount      ;Decimal        }
    { 15  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=ENU=Currency Code }
    { 16  ;   ;Issued              ;Option        ;OptionString=No,Yes,N/A }
    { 17  ;   ;Date Issued         ;Date           }
    { 18  ;   ;Time Issued         ;Time           }
    { 19  ;   ;Issue Received      ;Option        ;OptionString=No,Yes,N/A;
                                                   Editable=No }
    { 20  ;   ;Date Received       ;Date          ;Editable=No }
    { 21  ;   ;Time Received       ;Time          ;Editable=No }
    { 22  ;   ;Issued By           ;Text100       ;Editable=No }
    { 23  ;   ;Received By         ;Text100       ;Editable=No }
    { 24  ;   ;Received            ;Option        ;OptionCaptionML=ENU=No,Yes;
                                                   OptionString=No,Yes;
                                                   Editable=No }
    { 32  ;   ;Request No          ;Code20         }
    { 33  ;   ;Bank No             ;Code20        ;TableRelation="Bank Account".No. WHERE (code=CONST(0)) }
    { 34  ;   ;Denomination Total  ;Decimal        }
    { 35  ;   ;External Document No.;Code20        }
    { 36  ;   ;Cheque No.          ;Code20         }
    { 37  ;   ;Transacting Branch  ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2)) }
    { 38  ;   ;Approved            ;Boolean        }
    { 39  ;   ;End of Day Trans Time;Time          }
    { 40  ;   ;End of Day          ;Date           }
    { 41  ;   ;Last Transaction    ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Min("Treasury Transactions".No WHERE (Transaction Type=FILTER(End of Day Return to Treasury),
                                                                                                     To Account=FIELD(To Account))) }
    { 42  ;   ;Total Cash on Treasury Coinage;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Treasury Coinage"."Total Amount" WHERE (No=FIELD(No)));
                                                   Editable=No }
    { 43  ;   ;Till/Treasury Balance;Decimal       }
    { 44  ;   ;Excess/Shortage Amount;Decimal      }
    { 45  ;   ;From Account Name   ;Text80         }
    { 46  ;   ;To Account Name     ;Text80         }
    { 47  ;   ;Actual Cash At Hand ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Treasury Coinage"."Total Amount" WHERE (No=FIELD(No))) }
    { 48  ;   ;requested           ;Boolean        }
    { 49  ;   ;Requester           ;Code30         }
    { 50  ;   ;Requested Date      ;Date           }
    { 51  ;   ;Requested Time      ;Time           }
    { 52  ;   ;Request to          ;Text30         }
    { 53  ;   ;Amount to request   ;Decimal       ;OnValidate=BEGIN
                                                                IF "Amount to request"<1 THEN
                                                                  ERROR('AMOUNT REQUESTED MUST BE GREATER THAN 1');
                                                              END;
                                                               }
    { 54  ;   ;Naration            ;Text250       ;OnValidate=BEGIN
                                                                // IF Naration=FALSE THEN
                                                                //   ERROR('must have naration first');
                                                              END;
                                                               }
  }
  KEYS
  {
    {    ;No                                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NoSetup@1000000000 : Record 51516258;
      NoSeriesMgt@1000000001 : Codeunit 396;
      Denominations@1000000003 : Record 51516303;
      TransactionCoinage@1000000002 : Record 51516302;
      UsersID@1102760000 : Record 2000000120;
      Banks@1102755000 : Record 270;

    BEGIN
    END.
  }
}

