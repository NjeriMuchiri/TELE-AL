OBJECT table 50033 Quotation Request Vendors
{
  OBJECT-PROPERTIES
  {
    Date=04/13/18;
    Time=[ 9:37:04 AM];
    Modified=Yes;
    Version List=Supply Chain Management;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;OptionString=Quotation Request,Open Tender,Restricted Tender }
    { 2   ;   ;Requisition Document No.;Code20     }
    { 3   ;   ;Vendor No.          ;Code20        ;TableRelation=Vendor WHERE (Vendor Posting Group=FILTER(<>DRIVERS)) }
    { 4   ;   ;Vendor Name         ;Text100       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Vendor.Name WHERE (No.=FIELD(Vendor No.))) }
  }
  KEYS
  {
    {    ;Requisition Document No.,Vendor No.     ;Clustered=Yes }
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

