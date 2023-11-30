OBJECT table 50040 Cash Office Setup
{
  OBJECT-PROPERTIES
  {
    Date=05/26/16;
    Time=[ 8:47:25 PM];
    Modified=Yes;
    Version List=Payment ProcessesV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10         }
    { 50001;  ;Normal Payments No  ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=ENU=Normal Payments No }
    { 50002;  ;Cheque Reject Period;DateFormula    }
    { 50003;  ;Petty Cash Payments No;Code10      ;TableRelation="No. Series";
                                                   CaptionML=ENU=Petty Cash Payments No }
    { 50004;  ;Current Budget      ;Code20        ;TableRelation="G/L Budget Name".Name }
    { 50005;  ;Current Budget Start Date;Date      }
    { 50006;  ;Current Budget End Date;Date        }
    { 50009;  ;Surrender Template  ;Code20        ;TableRelation="Gen. Journal Template" }
    { 50010;  ;Surrender  Batch    ;Code20        ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Surrender Template)) }
    { 50011;  ;Payroll Template    ;Code20        ;TableRelation="Gen. Journal Template" }
    { 50012;  ;Payroll  Batch      ;Code20        ;TableRelation="Gen. Journal Batch".Name }
    { 50013;  ;Payroll Control A/C ;Code20        ;TableRelation="G/L Account" }
    { 50014;  ;PV Template         ;Code20        ;TableRelation="Gen. Journal Template" }
    { 50015;  ;PV  Batch           ;Code20        ;TableRelation="Gen. Journal Batch".Name }
    { 50016;  ;Contract No         ;Code20        ;TableRelation="No. Series" }
    { 50017;  ;Receipts No         ;Code20        ;TableRelation="No. Series" }
    { 50018;  ;Petty Cash Voucher  Template;Code20;TableRelation="Gen. Journal Template" }
    { 50019;  ;Petty Cash Voucher Batch;Code20    ;TableRelation="Gen. Journal Batch".Name }
    { 50020;  ;Max. Petty Cash Request;Decimal     }
    { 50022;  ;Imprest Req No      ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=ENU=Receipts No }
    { 50023;  ;Quotation Request No;Code20        ;TableRelation="No. Series" }
    { 50024;  ;Tender Request No   ;Code20        ;TableRelation="No. Series" }
    { 50025;  ;Transport Pay Type  ;Code20         }
    { 50026;  ;Minimum Chargeable Weight;Decimal   }
    { 50027;  ;Imprest Surrender No;Code20        ;TableRelation="No. Series";
                                                   CaptionML=ENU=Imprest Surrender No }
    { 50028;  ;Bank Deposit No.    ;Code20        ;TableRelation="No. Series" }
    { 50029;  ;InterBank Transfer No.;Code20      ;TableRelation="No. Series" }
    { 50030;  ;PA Payment Vouchers Nos;Code20     ;TableRelation="No. Series".Code;
                                                   CaptionML=ENU=Farmers Payment Vouchers Nos. }
    { 50031;  ;Cash Request Nos    ;Code20        ;TableRelation="No. Series".Code }
    { 50032;  ;Cash Issue Nos      ;Code20        ;TableRelation="No. Series".Code }
    { 50033;  ;Cash Receipt Nos    ;Code20        ;TableRelation="No. Series".Code }
    { 50034;  ;Cash Transfer Template;Code10      ;TableRelation="Gen. Journal Template".Name }
    { 50035;  ;Cash Transfer Batch ;Code10        ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Cash Transfer Template)) }
    { 50036;  ;Enable AutoTeller Monitor;Boolean   }
    { 50037;  ;Alert After ?(Mins) ;Integer        }
    { 50038;  ;Transporter Depot   ;Code20        ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionClass='1,1,1' }
    { 50039;  ;Transporter Department;Code20      ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionClass='1,2,2' }
    { 50040;  ;Transporter Cashier ;Code20        ;TableRelation="Destination Rates" }
    { 50041;  ;Transporter PayType ;Code20        ;TableRelation="Funds Transaction Types"."Transaction Code" WHERE (Transaction Type=CONST(Payment)) }
    { 50042;  ;Cashier Transfer Nos;Code20        ;TableRelation="No. Series".Code }
    { 50043;  ;Interim Transfer Account;Code20    ;TableRelation="Bank Account" }
    { 50044;  ;Default Bank Deposit Slip A/C;Code20;
                                                   TableRelation="Bank Account".No. }
    { 50045;  ;Apply Cash Expenditure Limit;Boolean }
    { 50046;  ;Expenditure Limit Amount(LCY);Decimal }
    { 50050;  ;Staff Claim No.     ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=ENU=Staff Claim No }
    { 50051;  ;Other Staff Advance No.;Code20     ;TableRelation="No. Series";
                                                   CaptionML=ENU=Other Staff Advance No }
    { 50052;  ;Staff Advance Surrender No.;Code20 ;TableRelation="No. Series";
                                                   CaptionML=ENU=Staff Adv. Surrender No }
    { 50053;  ;Prompt Cash Reimbursement;Boolean   }
    { 50054;  ;Use Central Payment System;Boolean  }
    { 50060;  ;Payment Request Nos ;Code20        ;TableRelation="No. Series" }
    { 50061;  ;Journal Voucher Nos ;Code20        ;TableRelation="No. Series" }
    { 50070;  ;Minimum Cheque Creation Amount;Decimal;
                                                   Description=Starting Amount to create a check }
    { 50071;  ;Grant Surrender Nos ;Code20        ;TableRelation="No. Series".Code }
    { 50072;  ;Cash Purchases      ;Code20        ;TableRelation="No. Series" }
    { 50073;  ;Board Payment Nos   ;Code20        ;TableRelation="No. Series".Code }
    { 50074;  ;Committee Payment Nos;Code20       ;TableRelation="No. Series".Code }
    { 50075;  ;Board PV Nos        ;Code20        ;TableRelation="No. Series".Code }
    { 50076;  ;Committee PV Nos    ;Code20        ;TableRelation="No. Series".Code }
    { 50077;  ;Cash Collection A/C ;Code20        ;TableRelation="Bank Account".No. }
    { 50078;  ;Cheque Collection A/C;Code20       ;TableRelation="Bank Account".No. }
    { 50079;  ;MPESA Collection A/C;Code20        ;TableRelation="Bank Account".No. }
    { 50080;  ;Airtel Collection A/C;Code20       ;TableRelation="Bank Account".No. }
    { 50081;  ;Mobile Money Payment Nos;Code20     }
    { 50082;  ;Casual Req. No's    ;Code20        ;TableRelation="No. Series" }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
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

