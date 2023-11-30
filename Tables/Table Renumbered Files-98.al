OBJECT table 17216 Control-Information
{
  OBJECT-PROPERTIES
  {
    Date=05/26/16;
    Time=[ 2:05:00 PM];
    Modified=Yes;
    Version List=Payroll ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10         }
    { 2   ;   ;Name                ;Text50         }
    { 3   ;   ;Name 2              ;Text50         }
    { 4   ;   ;Address             ;Text50         }
    { 5   ;   ;Address 2           ;Text50         }
    { 6   ;   ;City                ;Text50         }
    { 7   ;   ;Phone No.           ;Text150        }
    { 8   ;   ;Phone No. 2         ;Text20         }
    { 9   ;   ;Telex No.           ;Text20         }
    { 10  ;   ;Fax No.             ;Text20         }
    { 11  ;   ;Giro No.            ;Text20         }
    { 12  ;   ;Bank Name           ;Text30         }
    { 13  ;   ;Bank Branch No.     ;Text20         }
    { 14  ;   ;Bank Account No.    ;Text20         }
    { 15  ;   ;Payment Routing No. ;Text20         }
    { 17  ;   ;Customs Permit No.  ;Text10         }
    { 18  ;   ;Customs Permit Date ;Date           }
    { 19  ;   ;VAT Registration No.;Text20         }
    { 20  ;   ;Registration No.    ;Text20         }
    { 21  ;   ;Telex Answer Back   ;Text20         }
    { 22  ;   ;Ship-to Name        ;Text30         }
    { 23  ;   ;Ship-to Name 2      ;Text30         }
    { 24  ;   ;Ship-to Address     ;Text30         }
    { 25  ;   ;Ship-to Address 2   ;Text30         }
    { 26  ;   ;Ship-to City        ;Text30         }
    { 27  ;   ;Ship-to Contact     ;Text30         }
    { 28  ;   ;Location Code       ;Code10        ;TableRelation=Location }
    { 29  ;   ;Picture             ;BLOB          ;SubType=Bitmap }
    { 30  ;   ;Post Code           ;Code20        ;TableRelation="Post Code";
                                                   OnValidate=BEGIN
                                                                IF PostCode.GET("Post Code") THEN
                                                                  City := PostCode.City;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No }
    { 31  ;   ;County              ;Text30         }
    { 32  ;   ;Ship-to Post Code   ;Code20        ;TableRelation="Post Code";
                                                   OnValidate=BEGIN
                                                                IF PostCode.GET("Ship-to Post Code") THEN
                                                                  "Ship-to City" := PostCode.City;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No }
    { 33  ;   ;Ship-to County      ;Text30         }
    { 34  ;   ;E-Mail              ;Text80         }
    { 35  ;   ;Home Page           ;Text80         }
    { 50000;  ;Company P.I.N       ;Code30         }
    { 50001;  ;N.S.S.F No.         ;Code30         }
    { 50002;  ;Company code        ;Code10         }
    { 50003;  ;Working Days Per Year;Integer       }
    { 50004;  ;Working Hours Per Week;Integer      }
    { 50005;  ;Working Hours Per Day;Integer       }
    { 50006;  ;Mission             ;Text250        }
    { 50007;  ;Mission/Vision Link ;Text50         }
    { 50008;  ;Vision              ;Text250        }
    { 50009;  ;N.H.I.F No          ;Text100        }
    { 50010;  ;Payslip Message     ;Text250       ;Description=Dennis Added }
    { 50011;  ;Multiple Payroll    ;Boolean        }
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
    VAR
      PostCode@1102750000 : Record 225;

    BEGIN
    END.
  }
}

