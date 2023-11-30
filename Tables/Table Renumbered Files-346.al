OBJECT table 20491 Guarantors_Portal
{
  OBJECT-PROPERTIES
  {
    Date=02/14/19;
    Time=10:56:55 AM;
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               VALIDATE(MemberNo);
               MembersReg.RESET;
               MembersReg.SETRANGE(MembersReg."No.", LoneeNo);
               IF MembersReg.FIND('-') THEN BEGIN

                 END;
               COMMIT;
               //INSERT;
             END;

  }
  FIELDS
  {
    { 1   ;   ;Entry               ;Integer       ;AutoIncrement=Yes }
    { 2   ;   ;LoanNO              ;Integer       ;OnValidate=BEGIN
                                                                IF TotalsLoans.GET(LoanNO) THEN
                                                                  Amount:=TotalsLoans.AppliedAmount;
                                                              END;
                                                               }
    { 3   ;   ;MemberNo            ;Code70        ;OnValidate=BEGIN
                                                                MembersReg.SETRANGE(MembersReg."No.", MemberNo);
                                                                IF MembersReg.FIND('-') THEN BEGIN
                                                                 MemberName:=MembersReg."Search Name";

                                                                 // END;
                                                                  END;
                                                              END;
                                                               }
    { 5   ;   ;Amount              ;Decimal        }
    { 6   ;   ;AmountGuaranteed    ;Decimal        }
    { 7   ;   ;Response            ;Boolean       ;OnValidate=BEGIN
                                                                IF Response =TRUE THEN Date:=TODAY;
                                                              END;
                                                               }
    { 8   ;   ;GuarantorName       ;Code70         }
    { 9   ;   ;MemberName          ;Code70         }
    { 10  ;   ;LoneeNo             ;Code40        ;OnValidate=BEGIN
                                                                IF MembersReg.GET(LoneeNo) THEN
                                                                  MemberName:=MembersReg."Search Name";
                                                                MembersReg.SETRANGE(MembersReg."No.", LoneeNo);
                                                                IF MembersReg.FIND('-') THEN BEGIN
                                                                  GuarantorName:=MembersReg."Search Name";
                                                                 TotalsLoans.SETRANGE(TotalsLoans.Entry, LoanNO);
                                                                  IF TotalsLoans.FIND('-') THEN BEGIN
                                                                    TotalsLoans.CALCFIELDS(TotalsLoans.AmountGuaranteed);
                                                                 Sms.FnSMSMessage(MembersReg."No.", MembersReg."Mobile Phone No",'Dear '+Rec.GuarantorName+', '  +Rec.MemberName+' is requesting for '+TotalsLoans.LoanTypeName+' of Kshs '
                                                                 +FORMAT( Rec.Amount)+' payable in '+FORMAT( TotalsLoans.Installments)+' Months.'
                                                                 +' Please login to Telepost sacco portal to guarantee or reject this request THANK YOU' );
                                                                END;

                                                                  END;
                                                              END;
                                                               }
    { 11  ;   ;Date                ;Date           }
  }
  KEYS
  {
    {    ;Entry                                   ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      TotalsLoans@1120054000 : Record 51516908;
      MembersReg@1120054001 : Record 51516223;
      Sms@1120054002 : Codeunit 51516120;

    BEGIN
    END.
  }
}

