OBJECT table 17327 ATM Transactions
{
  OBJECT-PROPERTIES
  {
    Date=10/12/20;
    Time=[ 5:57:05 PM];
    Modified=Yes;
    Version List=FOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               //ERROR('You are not allowed to manually insert anything into this table');
             END;

    OnModify=BEGIN
               //ERROR('You are not allowed to modify anything in this table');
             END;

    OnDelete=BEGIN
               ERROR('You are not allowed to delete anything from this table');
             END;

    OnRename=BEGIN
               //ERROR('You are not allowed to edit anything from this table');
             END;

  }
  FIELDS
  {
    { 1   ;   ;Trace ID            ;Code20        ;OnValidate=BEGIN
                                                                      ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 2   ;   ;Posting Date        ;Date          ;OnValidate=BEGIN
                                                                         ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 3   ;   ;Account No          ;Code50        ;TableRelation=Vendor.No.;
                                                   OnValidate=BEGIN
                                                                   ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 4   ;   ;Description         ;Text250       ;OnValidate=BEGIN
                                                                   ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 5   ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                    ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 6   ;   ;Posting S           ;Text100       ;OnValidate=BEGIN
                                                                    ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 7   ;   ;Posted              ;Boolean        }
    { 8   ;   ;Unit ID             ;Code10        ;OnValidate=BEGIN
                                                                ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 9   ;   ;Transaction Type    ;Text100        }
    { 10  ;   ;Trans Time          ;Text50         }
    { 11  ;   ;Transaction Time    ;Time           }
    { 12  ;   ;Transaction Date    ;Date           }
    { 13  ;   ;Source              ;Option        ;OptionCaptionML=ENU=ATM Bridge,MSacco;
                                                   OptionString=ATM Bridge,MSacco }
    { 14  ;   ;Reversed            ;Boolean        }
    { 16  ;   ;Reversed Posted     ;Boolean       ;Editable=Yes }
    { 17  ;   ;Reversal Trace ID   ;Code20        ;OnValidate=BEGIN
                                                                ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 18  ;   ;Transaction Description;Text150    ;OnValidate=BEGIN
                                                                       ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 19  ;   ;Withdrawal Location ;Text150       ;OnValidate=BEGIN
                                                                                ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 20  ;   ;Entry No            ;Integer       ;OnValidate=BEGIN
                                                                             ERROR('You are not allowed to modify anything in this table');
                                                              END;

                                                   AutoIncrement=Yes;
                                                   Editable=No }
    { 22  ;   ;Transaction Type Charges;Option    ;OnValidate=BEGIN
                                                                            ERROR('You are not allowed to modify anything in this table');
                                                              END;

                                                   OptionCaptionML=ENU=Balance Enquiry,Mini Statement,Cash Withdrawal - Coop ATM,Cash Withdrawal - VISA ATM,Reversal,Utility Payment,POS - Normal Purchase,M-PESA Withdrawal,Airtime Purchase,POS - School Payment,POS - Purchase With Cash Back,POS - Cash Deposit,POS - Benefit Cash Withdrawal,POS - Cash Deposit to Card,POS - M Banking,POS - Cash Withdrawal,POS - Balance Enquiry,POS - Mini Statement,MINIMUM BALANCE;
                                                   OptionString=Balance Enquiry,Mini Statement,Cash Withdrawal - Coop ATM,Cash Withdrawal - VISA ATM,Reversal,Utility Payment,POS - Normal Purchase,M-PESA Withdrawal,Airtime Purchase,POS - School Payment,POS - Purchase With Cash Back,POS - Cash Deposit,POS - Benefit Cash Withdrawal,POS - Cash Deposit to Card,POS - M Banking,POS - Cash Withdrawal,POS - Balance Enquiry,POS - Mini Statement,MINIMUM BALANCE }
    { 23  ;   ;Card Acceptor Terminal ID;Code20   ;OnValidate=BEGIN
                                                                            ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 24  ;   ;ATM Card No         ;Code20        ;OnValidate=BEGIN
                                                                         ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 25  ;   ;Customer Names      ;Text250       ;OnValidate=BEGIN
                                                                         ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 26  ;   ;Process Code        ;Code50        ;OnValidate=BEGIN
                                                                         ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 50000;  ;Reference No        ;Text250       ;OnValidate=BEGIN
                                                                        ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 50001;  ;Is Coop Bank        ;Boolean       ;OnValidate=BEGIN
                                                                       ERROR('You are not allowed to modify anything in this table');
                                                              END;
                                                               }
    { 50002;  ;POS Vendor          ;Option        ;OnValidate=BEGIN
                                                                        ERROR('You are not allowed to modify anything in this table');
                                                              END;

                                                   OptionCaptionML=ENU=ATM Lobby,Agent Banking,Coop Branch,Sacco POS;
                                                   OptionString=ATM Lobby,Agent Banking,Coop Branch,Sacco POS }
  }
  KEYS
  {
    {    ;Entry No                                 }
    {    ;Trace ID,Unit ID,Transaction Type,Posting S;
                                                   Clustered=Yes }
    {    ;Account No,Posted                       ;SumIndexFields=Amount }
    {    ;Transaction Date,Transaction Time        }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

