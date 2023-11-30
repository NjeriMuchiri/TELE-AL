OBJECT Query 17206 ministatement
{
  OBJECT-PROPERTIES
  {
    Date=09/28/16;
    Time=10:24:13 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  ELEMENTS
  {
    { 1000000000;;DataItem;                  ;
               DataItemTable=Table380 }

    { 1000000004;1;Column;                   ;
               DataSource=Debit Amount }

    { 1000000005;1;Column;                   ;
               DataSource=Credit Amount }

    { 1000000002;1;Column;                   ;
               DataSource=Amount }

    { 1000000003;1;Column;                   ;
               DataSource=Vendor No. }

    { 1000000006;1;Column;                   ;
               DataSource=Vendor Ledger Entry No. }

    { 1000000010;1;Column;                   ;
               DataSource=Posting Date }

    { 1000000007;1;Column;                   ;
               DataSource=Document No. }

    { 1000000008;1;DataItem;                 ;
               DataItemTable=Table25;
               DataItemLink=Entry No.=Detailed_Vendor_Ledg_Entry."Vendor Ledger Entry No.";
               DataItemLinkType=SQL Advanced Options }

    { 1000000001;2;Column;                   ;
               DataSource=Entry No. }

    { 1000000009;2;Column;                   ;
               DataSource=Description }

    { 1000000011;2;Column;                   ;
               DataSource=External Document No. }

  }
  CODE
  {

    BEGIN
    END.
  }
}

