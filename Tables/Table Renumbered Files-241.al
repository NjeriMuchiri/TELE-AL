OBJECT table 20382 Loan PayOff
{
  OBJECT-PROPERTIES
  {
    Date=11/25/19;
    Time=[ 3:20:18 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnInsert=BEGIN

               IF "Document No" = '' THEN BEGIN
                 SalesSetup.GET;
                 SalesSetup.TESTFIELD(SalesSetup."Loan PayOff Nos");
                 NoSeriesMgt.InitSeries(SalesSetup."Loan PayOff Nos",xRec."No. Series",0D,"Document No","No. Series");
               END;
             END;

  }
  FIELDS
  {
    { 1   ;   ;Document No         ;Code20        ;OnValidate=BEGIN
                                                                IF "Document No" <> xRec."Document No" THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."Loan PayOff Nos");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Member No           ;Code20        ;TableRelation="Members Register".No.;
                                                   OnValidate=BEGIN
                                                                IF Cust.GET("Member No") THEN BEGIN
                                                                  "Member Name":=Cust.Name;
                                                                  "FOSA Account No":=Cust."FOSA Account";
                                                                  "Personal No":=Cust."Payroll/Staff No";
                                                                 END;
                                                              END;
                                                               }
    { 3   ;   ;Member Name         ;Code50         }
    { 4   ;   ;Application Date    ;Date           }
    { 5   ;   ;Requested PayOff Amount;Decimal     }
    { 6   ;   ;Approved PayOff Amount;Decimal      }
    { 7   ;   ;Created By          ;Code20         }
    { 8   ;   ;No. Series          ;Code20         }
    { 9   ;   ;FOSA Account No     ;Code20        ;TableRelation=Vendor.No. }
    { 10  ;   ;Total PayOut Amount ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Loans PayOff Details"."Total PayOff" WHERE (Document No=FIELD(Document No))) }
    { 11  ;   ;Global Dimension 2 Code;Code10     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2),
                                                                                               Dimension Value Type=CONST(Standard));
                                                   CaptionClass='1,2,2' }
    { 12  ;   ;Posted              ;Boolean        }
    { 13  ;   ;Posting Date        ;Date           }
    { 14  ;   ;Posted By           ;Code20         }
    { 15  ;   ;Personal No         ;Code30         }
  }
  KEYS
  {
    {    ;Document No                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SalesSetup@1000000001 : Record 51516258;
      NoSeriesMgt@1000000000 : Codeunit 396;
      Cust@1000000002 : Record 51516223;

    BEGIN
    END.
  }
}

