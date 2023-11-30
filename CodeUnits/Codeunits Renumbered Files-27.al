OBJECT CodeUnit 20391 Crb Details
{
  OBJECT-PROPERTIES
  {
    Date=09/19/19;
    Time=[ 6:37:23 PM];
    Modified=Yes;
    Version List=CloudPESA;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            //MESSAGE(PostTransactionsFB('2246423'));
            //MESSAGE(GnSendIdDetails());
          END;

  }
  CODE
  {
    VAR
      ExxcDuty@1000000044 : TextConst 'ENU=01-1-0275';
      fosaConst@1000000047 : TextConst 'ENU=SAVINGS';
      DimensionFOSA@1000000049 : TextConst 'ENU=FOSA';
      DimensionBRANCH@1000000050 : TextConst 'ENU=NAIROBI';
      DimensionBOSA@1000000052 : TextConst 'ENU=BOSA';

    PROCEDURE FnCRBPersonalDetails@1(crbName@1000 : Text[100];reportDate@1001 : Date;reportType@1002 : Text[100];productDisplayName@1003 : Text[100];requester@1004 : Text[100];requestNo@1005 : Integer;crn@1006 : Integer;salutation@1007 : Text[50];surname@1008 : Text[100];otherNames@1009 : Text[100];fullName@1010 : Text[100];nationaIID@1011 : Code[30];passportNo@1012 : Code[50];drivingLicenseNo@1013 : Code[40];serviceID@1014 : Code[30];dateOfBirth@1015 : Date;alienID@1016 : Code[30];mobiLoansScore@1017 : Integer;probability@1018 : Text[100];grade@1019 : Code[10];reasonCodeAARC1@1020 : Text;reasonCodeAARC2@1021 : Text;reasonCodeAARC3@1022 : Text;reasonCodeAARC4@1023 : Text;responseCode@1024 : Text;CreditUnit@1025 : Decimal);
    BEGIN
      {CRBMobiLoan.RESET;
      CRBMobiLoan.SETRANGE(CRBMobiLoan."Request No",requestNo);
      IF CRBMobiLoan.FIND('-')=FALSE THEN BEGIN
        CRBMobiLoan.INIT;
        CRBMobiLoan."Crb Name":=crbName;
        CRBMobiLoan."Report Date":=reportDate;
        CRBMobiLoan."Report Type":=reportType;
        CRBMobiLoan."Product Display Name":=productDisplayName;
        CRBMobiLoan.Requester:=requester;
        CRBMobiLoan."Request No":=requestNo;
        CRBMobiLoan."Credit Reference No":=crn;
        CRBMobiLoan.Salutation:=salutation;
        CRBMobiLoan.Surname:=surname;
        CRBMobiLoan."Date Requested":=CURRENTDATETIME;
        CRBMobiLoan."Other Names":=otherNames;
        CRBMobiLoan."Full Name":=fullName;
        CRBMobiLoan."NationaI ID":=nationaIID;
        CRBMobiLoan."Passport No":=passportNo;
        CRBMobiLoan."Driving License No":=drivingLicenseNo;
        CRBMobiLoan."Service ID":=serviceID;
        CRBMobiLoan."Date Of Birth":=dateOfBirth;
        CRBMobiLoan."Alien ID":=alienID;
        CRBMobiLoan."Mobi Loans Score":=mobiLoansScore;
        CRBMobiLoan.Probability:=probability;
        CRBMobiLoan.Grade:=grade;
        CRBMobiLoan."Reason Code AARC1":=reasonCodeAARC1;
        CRBMobiLoan."Reason Code AARC2":=reasonCodeAARC2;
        CRBMobiLoan."Reason Code AARC3":=reasonCodeAARC3;
        CRBMobiLoan."Reason Code AARC4":=reasonCodeAARC4;
        CRBMobiLoan."Respnse Code":=responseCode;
        CRBMobiLoan.INSERT;
      END;
      }
    END;

    PROCEDURE FnCRBSummary@4(creditHistory@1000 : Integer;npaAccounts@1001 : Integer;npaClosedAccounts@1002 : Integer;npaOpenAccounts@1003 : Integer;paAccounts@1004 : Integer;paClosedAccounts@1005 : Integer;paOpenAccounts@1006 : Integer;paAccountsWithDh@1007 : Integer;paOpenAccountsWithDh@1008 : Integer;paClosedAccountsWithDh@1009 : Integer;mobiLoanAccounts@1010 : Integer;"paOpenMobiLoanAccounts'"@1011 : Integer;paClosedMobiLoanAccounts@1012 : Integer;npaOpenMobiLoanAccounts@1013 : Integer;npaClosedMobiLoanAccounts@1014 : Integer;paOpenMobiLoanAccountsWithDh@1015 : Integer;paClosedMobiLoanAccountsWithDh@1016 : Integer;minMobiLoanPrincipalAmount@1017 : Decimal;maxMobiLoanPrincipalAmount@1018 : Decimal;avgMobiLoanPrincipalAmount@1019 : Decimal;lastMobiLoanPrincipalAmount@1020 : Decimal;lastMobiLoanListingDate@1021 : Date;requestno@1022 : Integer);
    BEGIN
      {CRBSummary.RESET;
      CRBSummary.SETRANGE(CRBSummary."Request No",requestno);
      IF CRBSummary.FIND('-') =FALSE THEN BEGIN
        CRBSummary."Request No":=requestno;
        CRBSummary."Credit History.My sector":=creditHistory;
        CRBSummary."Npa Accounts":=npaAccounts;
        CRBSummary.npaClosedAccounts:=npaClosedAccounts;
        CRBSummary.npaOpenAccounts:=npaOpenAccounts;
        CRBSummary.paAccounts:=paAccounts;
        CRBSummary.paClosedAccounts:=paClosedAccounts;
        CRBSummary.paOpenAccounts:=paOpenAccounts;
        CRBSummary.paAccountsWithDh:=paAccountsWithDh;
        CRBSummary.paOpenAccountsWithDh:=paOpenAccountsWithDh;
        CRBSummary.paClosedAccountsWithDh:=paClosedAccountsWithDh;
        CRBSummary.mobiLoanAccounts:=mobiLoanAccounts;
        CRBSummary.paOpenMobiLoanAccounts:="paOpenMobiLoanAccounts'";
        CRBSummary.paClosedMobiLoanAccounts:=paClosedMobiLoanAccounts;
        CRBSummary.npaOpenMobiLoanAccounts:=npaOpenMobiLoanAccounts;
        CRBSummary.npaClosedMobiLoanAccounts:=npaClosedMobiLoanAccounts;
        CRBSummary.paOpenMobiLoanAccountsWithDh:=paOpenMobiLoanAccountsWithDh;
        CRBSummary.paClosedMobiLoanAccountsWithDh:=paClosedMobiLoanAccountsWithDh;
        CRBSummary.minMobiLoanPrincipalAmount:=minMobiLoanPrincipalAmount;
        CRBSummary.maxMobiLoanPrincipalAmount:=maxMobiLoanPrincipalAmount;
        CRBSummary.avgMobiLoanPrincipalAmount:=avgMobiLoanPrincipalAmount;
        CRBSummary.lastMobiLoanPrincipalAmount:=lastMobiLoanPrincipalAmount;
        CRBSummary.lastMobiLoanListingDate:=lastMobiLoanListingDate;
        CRBSummary.INSERT;
      END;
      }
    END;

    PROCEDURE FnPhoneList@10(phoneType@1000 : Code[20];phoneNo@1001 : Code[20];phoneExchange@1002 : Text;createDate@1003 : Date;Requestno@1004 : Integer);
    BEGIN
      {CRBMobile.RESET;
      CRBMobile.SETRANGE(CRBMobile."Phone No",phoneNo);
      IF CRBMobile.FIND('-')=FALSE THEN BEGIN
        CRBMobile."Request No":=Requestno;
        CRBMobile."Phone Creation Date":=createDate;
        CRBMobile."Phone Type":=phoneType;
        CRBMobile."Phone Exchange":=phoneExchange;
        CRBMobile."Phone No":=phoneNo;
        CRBMobile.INSERT;
      END;
      }
    END;

    PROCEDURE FnErrorCode@5(ResponseCode@1000 : Code[10];RequestNo@1001 : Integer;idnumber@1002 : Code[50];names@1003 : Text[250]);
    BEGIN
      {CRBErrologs.RESET;
      CRBErrologs.SETRANGE(CRBErrologs."Request No",RequestNo);
      IF CRBErrologs.FIND('-')=FALSE THEN BEGIN
        CRBErrologs.INIT;
        CRBErrologs."Request No":=RequestNo;
        CRBErrologs."Response code":=ResponseCode;
        CRBErrologs."ID Number":=idnumber;
        CRBErrologs.Names:=names;
        CRBErrologs."Date Requested":=CURRENTDATETIME;
        CRBErrologs.INSERT;
      END;
      }
    END;

    PROCEDURE GetQualifyAmount@1000000008(amount@1000000000 : Decimal;code@1000000001 : Text[20]) LoanAmount : Decimal;
    BEGIN
      {LoanAmount:=0;
      TariffReport.RESET;
      TariffReport.SETRANGE(TariffReport.Code,code);
      TariffReport.SETFILTER(TariffReport."Lower Limit",'<=%1',amount);
      TariffReport.SETFILTER(TariffReport."Upper Limit",'>=%1',amount);
      IF TariffReport.FIND('-') THEN BEGIN
       LoanAmount:=TariffReport."Qualify Amount";
      END
      }
    END;

    PROCEDURE FngetMemberDetails@2(Account@1000 : Code[50]) result : Code[1000];
    BEGIN
      {Vendor.RESET;
      Vendor.SETRANGE(Vendor."No.",Account);
      IF Vendor.FIND('-') THEN BEGIN
       result:= Vendor.Name+':::'+Vendor."ID No.";
      END ELSE
      result:='GEOFFREY KOECH:::31754744';
      }
    END;

    PROCEDURE FngetTransactionDetails@9() result : Code[1000];
    BEGIN
      {Vendor.RESET;
      //Vendor.SETRANGE(Vendor."No.",Account);
      IF Vendor.FIND('-') THEN BEGIN
       result:= Vendor.Name+':::'+Vendor."ID No.";
      END ELSE
      result:='No';
      }
    END;

    PROCEDURE FnpostDetails@3(RequestNo@1000 : Integer;code@1001 : Code[10];idnumber@1002 : Code[50];Names@1003 : Text[250]);
    BEGIN
    END;

    BEGIN
    END.
  }
}

