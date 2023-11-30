OBJECT CodeUnit 20401 PORTALIntegration
{
  OBJECT-PROPERTIES
  {
    Date=09/11/23;
    Time=[ 4:25:18 PM];
    Modified=Yes;
    Version List=PortalCloudPesa;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            //MESSAGE( fnMemberStatement('000002','','');
            //fnTotalDepositsGraph('055000005','2013');
            //fnCurrentShareGraph('10000','2013');
            //fnTotalRepaidGraph('055000005','2013');
            //MESSAGE( MiniStatement('1024'));
            //fnMemberStatement('1024','006995Thox.pdf');
            //FnDepositsStatement('006995','dstatemnt.pdf');
            //FnLoanStatement('ACI015683','lsmnt.pdf');
            //MESSAGE(FosaMiniStatement('0502-001-08721'));
            //MESSAGE(FORMAT(MiniStatement('012061')));
            //MESSAGE(FORMAT( FnLoanApplication('1023','D303',20000,'DEV',2,FALSE,FALSE,TRUE)));
            //fnFosaStatement('2483-05-1-1189','fosa1.pdf');
            //fnLoanRepaymentShedule('BLN0036','fstn11.pdf');
            //fndividentstatement('000547','divident.pdf')
            //fnLoanGuranteed('006995','loansguaranteed.pdf');
            //fnLoanRepaymentShedule('10000','victorLoanrepay.pdf');
            //fnLoanGurantorsReport('10000','Guarantors.pdf');
            //fnAtmApplications('0101-001-00266')
            //FnLoanStatement('1024','jk');
            //fnChangePassword('10000','1122','1200');
            //FnUpdateMonthlyContrib('2439', 2000);
            //fnUpdatePassword('10001','8340224','1340');
            //fnAtmApplications('2483-05-1-1189');
            //FnStandingOrders('2439','2483-05-1-1189','1W','1Y','2483-05-06-1189',091317D,240,1);
            //MESSAGE(FORMAT( FnLoanApplication('2439','TANK LOAN',12500,'DEVELOPMENT',6,TRUE, FALSE, FALSE)));
            //fnFosaStatement('0502-001-08721','070122','080423' 'thox.pdf')
            //MESSAGE(FORMAT( Fnlogin('1024','')));
            //MESSAGE( MiniStatement('ACI015683'));
            //MESSAGE( fnAccountInfo('1024'));
            //MESSAGE(FORMAT(fnLoanDetails('d308')));
             //MESSAGE(FnmemberInfo('1024'));
            //MESSAGE(Fnloanssetup());
            //fnFeedback('1024', 'I have a big problem');
            //MESSAGE( FnloanCalc(50000,12, 'L01', 0,FALSE));
            //MESSAGE( FnNotifications());
            //MESSAGE(fnLoanDetails('ss'));
            //FnApproveGurarantors(
            //fnGuarantorsPortal('1024', '1023', 'BLN00148', 'Has requested you to quarantee laon');
            //FnApproveGurarantors(1, '000001',5, '',10000);
            //MESSAGE( FNAppraisalLoans('1024'));
            //MESSAGE( FnGetLoansForGuarantee('000001'));
            //MESSAGE(FnEditableLoans('1024','BLN00167'));
            //MESSAGE(fnLoans('012061'));
            //MESSAGE(FnmemberInfo('27394785'));
            //MESSAGE(FnGetLoansForGuarantee('000005'));
            //MESSAGE(FnApprovedGuarantors('1024', 'BLN00051'));
            //MESSAGE(FnloanCalc(40000,12,'D301'));
            //MESSAGE(FORMAT(fnTotalLoanAm('BLN00019')));
            //MESSAGE(fnLoans('000002'));
            //Fnquestionaire('000005', 'ASKDL', 'WATCH','TIME','FND','1',2,3,2,'Hellen');
            //FnNotifications('bln00084','manu1.pdf');
            //fnLoanApplicationform('10230');
            //fnLoanApplicationform('1050',TODAY, '10');
            //MESSAGE(FnLoanfo('1050'));
            //MESSAGE(fnGetFosaAccounts('20614286'));
            //MESSAGE( Fnloanssetup());
            MESSAGE(fnaccounts('012034'));
          END;

  }
  CODE
  {
    VAR
      objMember@1000000000 : Record 51516223;
      Vendor@1000000001 : Record 23;
      VendorLedgEntry@1000000002 : Record 51516224;
      FILESPATH@1000000003 : TextConst 'ENU=D:\Kentours Revised\KENTOURS\Kentours\Kentours\Downloads\';
      objLoanRegister@1000000004 : Record 51516230;
      objAtmapplication@1000000005 : Record 51516321;
      objRegMember@1000000009 : Record 51516220;
      objNextKin@1000000010 : Record 51516352;
      GenSetup@1000000011 : Record 98;
      FreeShares@1000000012 : Decimal;
      glamount@1000000013 : Decimal;
      LoansGuaranteeDetails@1000000014 : Record 51516231;
      objStandingOrders@1000000015 : Record 51516307;
      freq@1000000016 : DateFormula;
      dur@1000000017 : DateFormula;
      phoneNumber@1000000018 : Code[20];
      SMSMessages@1000000019 : Record 51516329;
      iEntryNo@1000000020 : Integer;
      FAccNo@1000000021 : Text[250];
      sms@1000000022 : Text[250];
      ClientName@1000000024 : Code[20];
      Loansetup@1000 : Record 51516240;
      feedback@1001 : Record 51516906;
      LoansPurpose@1002 : Record 51516237;
      ObjLoansregister@1003 : Record 51516230;
      LPrincipal@1004 : Decimal;
      LInterest@1005 : Decimal;
      Amount@1006 : Decimal;
      LBalance@1007 : Decimal;
      LoansRec@1008 : Record 51516230;
      TotalMRepay@1009 : Decimal;
      InterestRate@1010 : Decimal;
      Date@1011 : Date;
      FormNo@1012 : Code[40];
      PortaLuPS@1013 : Record 51516206;
      Loanperiod@1015 : Integer;
      Questinnaires@1016 : Record 51516907;
      LastFieldNo@1111 : Integer;
      FooterPrinted@1110 : Boolean;
      Cust@1109 : Record 51516223;
      StartDate@1108 : Date;
      DateFilter@1107 : Text[100];
      FromDate@1106 : Date;
      ToDate@1105 : Date;
      FromDateS@1104 : Text[100];
      ToDateS@1103 : Text[100];
      DivTotal@1102 : Decimal;
      CDeposits@1100 : Decimal;
      PostingDate@1089 : Date;
      "W/Tax"@1088 : Decimal;
      CommDiv@1087 : Decimal;
      DivInTotal@1086 : Decimal;
      WTaxInTotal@1085 : Decimal;
      CapTotal@1084 : Decimal;
      Period@1083 : Code[20];
      WTaxShareCap@1072 : Decimal;
      CloudPesaLive@1014 : CodeUnit 20387;
      Loans_Portal@1120054000 : Record 51516908;
      PortalGuarantors@1120054001 : Record 51516909;
      StartBalanceLCY@1120054002 : Decimal;
      DetailedVendorLedgEntry@1120054003 : Record 380;
      StartBalAdjLCY@1120054004 : Decimal;
      DividendsProgression@1120054005 : Record 51516252;
      TLoans@1120054006 : Decimal;
      SFactory@1120054007 : CodeUnit 20389;
      FosaBal@1120054008 : Decimal;

    PROCEDURE fnUpdatePassword@1000000000(MemberNo@1000000000 : Code[50];idNo@1000000002 : Code[10];NewPassword@1000000001 : Text[100];smsport@1000 : Text) emailAddress : Boolean;
    BEGIN
      sms:=smsport+NewPassword;

      objMember.RESET;
      objMember.SETRANGE(objMember."No.",MemberNo);
      //objMember.SETRANGE(objMember."ID No.",idNo);
      IF objMember.FIND('-') THEN BEGIN

         phoneNumber:= objMember."Mobile Phone No";
         FAccNo := objMember."No.";
        objMember.Password:=NewPassword;

        objMember.MODIFY;
        FnSMSMessage(FAccNo,phoneNumber,sms);
        emailAddress:=TRUE;
        END
        ELSE BEGIN
      objMember.RESET;
      objMember.SETRANGE(objMember."Payroll/Staff No",MemberNo);
      //objMember.SETRANGE(objMember."ID No.",idNo);
      IF objMember.FIND('-') THEN BEGIN

          phoneNumber:= objMember."Mobile Phone No";
         FAccNo := objMember."FOSA Account";
        objMember.Password:=NewPassword;
        objMember.MODIFY;
        FnSMSMessage(FAccNo,phoneNumber,sms);
        emailAddress:=TRUE;
        END;

      END;
        EXIT(emailAddress);
    END;

    PROCEDURE MiniStatement@1000000001(MemberNo@1000000000 : Text[100]) MiniStmt : Text;
    VAR
      minimunCount@1000000002 : Integer;
      amount@1000000003 : Decimal;
      Balance@1120054000 : Decimal;
      totalAmount@1120054001 : Decimal;
    BEGIN

       { BEGIN
        MiniStmt :='';
          objMember.RESET;
         objMember.SETRANGE("No."  ,MemberNo);

        IF objMember .FIND('-') THEN BEGIN

           minimunCount:=1;
           //Vendor.CALCFIELDS(Vendor.Balance);
           VendorLedgEntry.SETCURRENTKEY(VendorLedgEntry."Entry No.");
           VendorLedgEntry.ASCENDING(FALSE);
           VendorLedgEntry.SETRANGE(VendorLedgEntry."Customer No.",MemberNo);
         VendorLedgEntry.SETRANGE(VendorLedgEntry."Transaction Type",VendorLedgEntry."Transaction Type"::"Deposit Contribution");
          IF VendorLedgEntry.FINDSET THEN BEGIN
              MiniStmt:='';
              REPEAT
                amount:=VendorLedgEntry.Amount;
                IF amount<1 THEN   amount:= amount*-1;
                    MiniStmt :=MiniStmt + FORMAT(VendorLedgEntry."Posting Date") +':::'+ COPYSTR(FORMAT(VendorLedgEntry.Description),1,25) +':::' +
                    FORMAT(amount)+ ':::' + FORMAT(0) + '::::';
                    minimunCount:= minimunCount +1;
                    IF minimunCount > 5 THEN BEGIN
                    EXIT(MiniStmt);
                    END
                UNTIL VendorLedgEntry.NEXT =0;
                END;

        END;

        END;
        EXIT(MiniStmt);}

      MiniStmt := '';
      StartBalAdjLCY := 0;
      Balance:=0;
      objMember.RESET;
      objMember.SETRANGE("No.", MemberNo);

      IF objMember.FIND('-') THEN BEGIN
          minimunCount := 1;
          VendorLedgEntry.SETCURRENTKEY(VendorLedgEntry."Entry No.");
          VendorLedgEntry.ASCENDING(FALSE);
          VendorLedgEntry.SETRANGE(VendorLedgEntry."Customer No.", MemberNo);
          VendorLedgEntry.SETRANGE(VendorLedgEntry."Transaction Type",VendorLedgEntry."Transaction Type"::"Deposit Contribution");
          VendorLedgEntry.SETRANGE(VendorLedgEntry.Reversed, FALSE);
          objMember.CALCFIELDS(objMember."Current Shares");

          IF VendorLedgEntry.FINDSET THEN BEGIN
              Balance := objMember."Current Shares";
              MiniStmt := FORMAT(VendorLedgEntry."Posting Date") + ':::' + COPYSTR(FORMAT(VendorLedgEntry.Description), 1, 25) + ':::' +
                  FORMAT(VendorLedgEntry."Credit Amount") + ':::' + FORMAT(Balance) + '::::';

              REPEAT
                  IF VendorLedgEntry.NEXT = 0 THEN BEGIN
                      EXIT(MiniStmt);
                  END;
                  amount := VendorLedgEntry.Amount;
                  Balance := Balance + amount;

                  MiniStmt := MiniStmt + FORMAT(VendorLedgEntry."Posting Date") + ':::' + COPYSTR(FORMAT(VendorLedgEntry.Description), 1, 25) + ':::' +
                    FORMAT(VendorLedgEntry."Credit Amount") + ':::' + FORMAT(Balance) + '::::';

                  minimunCount := minimunCount + 1;

                  IF minimunCount = 5 THEN BEGIN
                      EXIT(MiniStmt);
                  END;

              UNTIL VendorLedgEntry.NEXT = 0;
          END;
      END;

      EXIT(MiniStmt);








    END;

    PROCEDURE FosaMiniStatement@1120054007(MemberNo@1000000000 : Text[100]) MiniStmt : Text;
    VAR
      minimunCount@1000000002 : Integer;
      amount@1000000003 : Decimal;
      VenderLedger@1120054000 : Record 25;
      Vendor@1120054001 : Record 23;
      Balance@1120054002 : Decimal;
    BEGIN
      MiniStmt := '';
      StartBalAdjLCY := 0;
      Balance:=0;
      Vendor.RESET;
      Vendor.SETRANGE("No.", MemberNo);

      IF Vendor.FIND('-') THEN BEGIN
          minimunCount := 1;
          VenderLedger.SETCURRENTKEY(VenderLedger."Entry No.");
          VenderLedger.ASCENDING(FALSE);
          VenderLedger.SETRANGE(VenderLedger."Vendor No.", MemberNo);
           Vendor.CALCFIELDS(Vendor."Net Change (LCY)");
          IF VenderLedger.FINDSET THEN BEGIN
              MiniStmt := '';
              REPEAT

                 VenderLedger.CALCFIELDS(VenderLedger.Amount);
                  amount := VenderLedger.Amount;

                  IF amount < 1 THEN BEGIN
                       Balance := Vendor."Net Change (LCY)" - amount;
                     MESSAGE(FORMAT(Balance));
                  END ELSE BEGIN
                      Balance:= Vendor."Net Change (LCY)" + amount;
                     MESSAGE(FORMAT(Balance));
                  END;

                  IF VenderLedger."Balance (LCY)" = 0 THEN BEGIN
                      StartBalAdjLCY := -Vendor."Net Change (LCY)";
                  END ELSE BEGIN
                      StartBalAdjLCY := -VenderLedger."Balance (LCY)";
                  END;

                  MiniStmt := MiniStmt + FORMAT(VenderLedger."Posting Date") + ':::' + COPYSTR(FORMAT(VenderLedger.Description), 1, 25) + ':::' +
                    FORMAT(amount) + ':::' + FORMAT(Balance) + '::::';

                  minimunCount := minimunCount + 1;

                  IF minimunCount > 5 THEN BEGIN
                      EXIT(MiniStmt);
                  END

              UNTIL VenderLedger.NEXT = 0;
          END;
      END;

      EXIT(MiniStmt);
    END;

    PROCEDURE fnMemberStatement@1000000002(MemberNo@1000000000 : Code[50];From@1000 : Date;EndDate@1120054000 : Date;VAR BigText@1011 : BigText) exitString : Text;
    VAR
      Filename@1000000002 : Text[100];
      Convert@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
      Path@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Path";
      _File@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.File";
      FileAccess@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileAccess";
      FileMode@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
      MemoryStream@1006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
      FileStream@1007 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileStream";
      Outputstream@1009 : OutStream;
    BEGIN

        objMember.RESET;
        objMember.SETRANGE(objMember."No.",MemberNo);
      IF objMember.FIND('-') THEN BEGIN
       objMember.SETFILTER(objMember."Date Filter",'%1..%2',From,EndDate);
      Filename:=Path.GetTempPath()+Path.GetRandomFileName();
      REPORT.SAVEASPDF(51516223,Filename, objMember);

       FileMode:=4;
       FileAccess:=1;

       FileStream:=_File.Open(Filename,FileMode,FileAccess);

       MemoryStream:=MemoryStream.MemoryStream();

       MemoryStream.SetLength(FileStream.Length);
       FileStream.Read(MemoryStream.GetBuffer(),0,FileStream.Length);

       BigText.ADDTEXT((Convert.ToBase64String(MemoryStream.GetBuffer())));
       MESSAGE(FORMAT(BigText));
      // exitString:=BigText;
      //MESSAGE(exitString);
      MemoryStream.Close();
      MemoryStream.Dispose();
      FileStream.Close();
      FileStream.Dispose();
      _File.Delete(Filename);

      END;
    END;

    PROCEDURE fnFosaStatement@1000000003(MemberNo@1002 : Code[50];StartDate@1120054000 : Date;EndDate@1120054001 : Date;VAR BigText@1000 : BigText);
    VAR
      Filename@1011 : Text[100];
      Convert@1010 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
      Path@1009 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Path";
      _File@1008 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.File";
      FileAccess@1007 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileAccess";
      FileMode@1006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
      MemoryStream@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
      FileStream@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileStream";
      Outputstream@1003 : OutStream;
      StartDateString@1120054002 : Text;
      EndDateString@1120054003 : Text;
      Day@1120054004 : Text;
      Month@1120054005 : Text;
      Year@1120054006 : Text;
      Day1@1120054007 : Text;
      Month1@1120054008 : Text;
      Year1@1120054009 : Text;
    BEGIN

        Vendor.RESET;
        Vendor.SETRANGE(Vendor."No." ,MemberNo);
        Vendor.SETFILTER(Vendor."Date Filter",'%1..%2',StartDate,EndDate);
      IF Vendor.FIND('-') THEN BEGIN
      Filename:=Path.GetTempPath()+Path.GetRandomFileName();
      REPORT.SAVEASPDF(51516389,Filename, Vendor);

       FileMode:=4;
       FileAccess:=1;

       FileStream:=_File.Open(Filename,FileMode,FileAccess);

       MemoryStream:=MemoryStream.MemoryStream();

       MemoryStream.SetLength(FileStream.Length);
       FileStream.Read(MemoryStream.GetBuffer(),0,FileStream.Length);

       BigText.ADDTEXT((Convert.ToBase64String(MemoryStream.GetBuffer())));
       MESSAGE(FORMAT(BigText));
      // exitString:=BigText;
      //MESSAGE(exitString);
      MemoryStream.Close();
      MemoryStream.Dispose();
      FileStream.Close();
      FileStream.Dispose();
      _File.Delete(Filename);

      END;
    END;

    PROCEDURE fndividentstatement@1000000004(No@1000000000 : Code[50];Path@1000000001 : Text[100]);
    VAR
      filename@1000000002 : Text;
      "Member No"@1000000003 : Code[50];
    BEGIN
      filename := FILESPATH+Path;
      IF EXISTS(filename) THEN

        ERASE(filename);
        objMember.RESET;
        objMember.SETRANGE(objMember."No.",No);

      IF objMember.FIND('-') THEN BEGIN
        REPORT.SAVEASPDF(51516241,filename,objMember);

      END;
    END;

    PROCEDURE fDiviendsSlip@1120054062(MemberNo@1000000000 : Code[50];VAR BigText@1011 : BigText) exitString : Text;
    VAR
      Filename@1000000002 : Text[100];
      Convert@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
      Path@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Path";
      _File@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.File";
      FileAccess@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileAccess";
      FileMode@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
      MemoryStream@1006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
      FileStream@1007 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileStream";
      Outputstream@1009 : OutStream;
    BEGIN

        objMember.RESET;
        objMember.SETRANGE(objMember."No.",MemberNo);


      IF objMember.FIND('-') THEN BEGIN

      Filename:=Path.GetTempPath()+Path.GetRandomFileName();
      REPORT.SAVEASPDF(50017,Filename, objMember);

       FileMode:=4;
       FileAccess:=1;

       FileStream:=_File.Open(Filename,FileMode,FileAccess);

       MemoryStream:=MemoryStream.MemoryStream();

       MemoryStream.SetLength(FileStream.Length);
       FileStream.Read(MemoryStream.GetBuffer(),0,FileStream.Length);

       BigText.ADDTEXT((Convert.ToBase64String(MemoryStream.GetBuffer())));
       MESSAGE(FORMAT(BigText));
      // exitString:=BigText;
      //MESSAGE(exitString);
      MemoryStream.Close();
      MemoryStream.Dispose();
      FileStream.Close();
      FileStream.Dispose();
      _File.Delete(Filename);

      END;
    END;

    PROCEDURE fnLoanGuranteed@1000000005(MemberNo@1002 : Code[50];filter@1001 : Text;VAR BigText@1000 : BigText);
    VAR
      Filename@1011 : Text[100];
      Convert@1010 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
      Path@1009 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Path";
      _File@1008 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.File";
      FileAccess@1007 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileAccess";
      FileMode@1006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
      MemoryStream@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
      FileStream@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileStream";
      Outputstream@1003 : OutStream;
    BEGIN

        objMember.RESET;
        objMember.SETRANGE(objMember."No.",MemberNo);


      IF objMember.FIND('-') THEN BEGIN
      //  objMember.SETFILTER("Date Filter", filter);
      Filename:=Path.GetTempPath()+Path.GetRandomFileName();
      REPORT.SAVEASPDF(51516226,Filename, objMember);

       FileMode:=4;
       FileAccess:=1;

       FileStream:=_File.Open(Filename,FileMode,FileAccess);

       MemoryStream:=MemoryStream.MemoryStream();

       MemoryStream.SetLength(FileStream.Length);
       FileStream.Read(MemoryStream.GetBuffer(),0,FileStream.Length);

       BigText.ADDTEXT((Convert.ToBase64String(MemoryStream.GetBuffer())));
       MESSAGE(FORMAT(BigText));
      // exitString:=BigText;
      //MESSAGE(exitString);
      MemoryStream.Close();
      MemoryStream.Dispose();
      FileStream.Close();
      FileStream.Dispose();
      _File.Delete(Filename);

      END;
    END;

    PROCEDURE fnLoanRepaymentShedule@1000000006("Loan No"@1000000000 : Code[50];path@1000000001 : Text[100]);
    VAR
      "Member No"@1000000002 : Code[100];
      filename@1000000003 : Text[250];
    BEGIN
      filename := FILESPATH+path;
      IF EXISTS(filename) THEN

        ERASE(filename);
        objLoanRegister.RESET;
        objLoanRegister.SETRANGE(objLoanRegister."Loan  No.","Loan No");

      IF objLoanRegister.FIND('-') THEN BEGIN
        REPORT.SAVEASPDF(51516477,filename,objLoanRegister);
        MESSAGE(FILESPATH);
      END;
    END;

    PROCEDURE FnLoanForm@1000000007(MemberNo@1002 : Integer;VAR BigText@1000 : BigText);
    VAR
      Filename@1011 : Text[100];
      Convert@1010 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
      Path@1009 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Path";
      _File@1008 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.File";
      FileAccess@1007 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileAccess";
      FileMode@1006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
      MemoryStream@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
      FileStream@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileStream";
      Outputstream@1003 : OutStream;
    BEGIN

        Loans_Portal.RESET;
        Loans_Portal.SETRANGE(Loans_Portal.Entry,MemberNo);


      IF Loans_Portal.FIND('-') THEN BEGIN
      //  objMember.SETFILTER("Date Filter", filter);
      Filename:=Path.GetTempPath()+Path.GetRandomFileName();
      REPORT.SAVEASPDF(51516323,Filename, Loans_Portal);

       FileMode:=4;
       FileAccess:=1;

       FileStream:=_File.Open(Filename,FileMode,FileAccess);

       MemoryStream:=MemoryStream.MemoryStream();

       MemoryStream.SetLength(FileStream.Length);
       FileStream.Read(MemoryStream.GetBuffer(),0,FileStream.Length);

       BigText.ADDTEXT((Convert.ToBase64String(MemoryStream.GetBuffer())));
       MESSAGE(FORMAT(BigText));
      // exitString:=BigText;
      //MESSAGE(exitString);
      MemoryStream.Close();
      MemoryStream.Dispose();
      FileStream.Close();
      FileStream.Dispose();
      _File.Delete(Filename);

      END;
    END;

    PROCEDURE fnAtmApplications@1000000008(Account@1000000000 : Code[100]);
    BEGIN
      {objAtmapplication.INIT;
      objAtmapplication."No.":=Account;
      //objAtmapplication."Request Type":=TODAY;
      objAtmapplication."Card Type":=objAtmapplication."Card Type"::"0";
      objAtmapplication."Sent To External File":=objAtmapplication."Sent To External File"::No;
      objAtmapplication.VALIDATE(objAtmapplication."No.");
      objAtmapplication.VALIDATE( "Account No");
      //objAtmapplication.VALIDATE("Order ATM Card");
      objAtmapplication.INSERT;
      }
    END;

    PROCEDURE fnAtmBlocking@1000000024(Account@1000000000 : Code[100];ReasonForBlock@1000000001 : Text[250]);
    BEGIN
      objAtmapplication.RESET;
      objAtmapplication.SETRANGE(objAtmapplication."No.",Account);
      IF objAtmapplication.FIND('-') THEN BEGIN
      objAtmapplication."Sent To External File":=objAtmapplication."Sent To External File"::"2";
      objAtmapplication."Reason for Account blocking":=ReasonForBlock;
      objAtmapplication.MODIFY;
      END;
    END;

    PROCEDURE fnChangePassword@1000000009(memberNumber@1000000000 : Code[100];currentPass@1000000001 : Code[100];newPass@1000000002 : Code[100]) updated : Boolean;
    BEGIN
      sms:= 'You have successfully updated your password. Your new password is: '+newPass;
      updated:=FALSE;
      objMember.RESET;
      objMember.SETRANGE(objMember."No.", memberNumber);
      objMember.SETRANGE(objMember.Password, currentPass);
      IF objMember.FIND('-') THEN BEGIN
        objMember.Password :=newPass;
        phoneNumber:= objMember."Phone No.";
         FAccNo := objMember."FOSA Account";
      updated := objMember.MODIFY;
      MESSAGE('Successful pass change');
      FnSMSMessage(FAccNo,phoneNumber,sms);
      EXIT(updated);
      END
      ELSE
        objMember.RESET;
      objMember.SETRANGE(objMember."Payroll/Staff No", memberNumber);
      objMember.SETRANGE(objMember.Password, currentPass);
      IF objMember.FIND('-') THEN BEGIN
        objMember.Password :=newPass;
        phoneNumber:= objMember."Phone No.";
         FAccNo := objMember."FOSA Account";
      updated := objMember.MODIFY;
      MESSAGE('Successful pass change');
      FnSMSMessage(FAccNo,phoneNumber,sms);
      EXIT(updated);
      END;
    END;

    PROCEDURE fnTotalRepaidGraph@1000000010(Mno@1000000000 : Code[10];year@1000000001 : Code[10]) total : Decimal;
    BEGIN
      objMember.RESET;
      objMember.SETRANGE("No.", Mno);
      IF objMember.FIND('-') THEN BEGIN

      objMember.SETFILTER("Date Filter",'0101'+year+'..1231'+year);
      //objMember.CALCFIELDS("Current Shares");
      total:=objMember."Total Repayments";
      MESSAGE ('current repaid is %1', total);
      END;
    END;

    PROCEDURE fnCurrentShareGraph@1000000013(Mno@1000000000 : Code[10];year@1000000001 : Code[10]) total : Decimal;
    BEGIN
      objMember.RESET;
      objMember.SETRANGE("No.", Mno);
      IF objMember.FIND('-') THEN BEGIN

      objMember.SETFILTER("Date Filter",'0101'+year+'..1231'+year);
      objMember.CALCFIELDS("Current Shares");
      total:=objMember."Current Shares";
      MESSAGE ('current shares is %1', total);
      END;
    END;

    PROCEDURE fnTotalDepositsGraph@1000000016(Mno@1000000000 : Code[10];year@1000000001 : Code[10]) total : Decimal;
    BEGIN
      objMember.RESET;
      objMember.SETRANGE("No.", Mno);
      IF objMember.FIND('-') THEN BEGIN

      objMember.SETFILTER("Date Filter",'0101'+year+'..1231'+year);
      objMember.CALCFIELDS("Shares Retained");
      total:=objMember."Shares Retained";
      MESSAGE ('current deposits is %1', total);
      END;
    END;

    PROCEDURE FnRegisterKin@1000000011("Full Names"@1000000000 : Text;Relationship@1000000001 : Text;"ID Number"@1000000002 : Code[10];"Phone Contact"@1000000003 : Code[10];Address@1000000004 : Text;Idnomemberapp@1000000005 : Code[10]);
    BEGIN
      BEGIN
            objRegMember.RESET;
            objNextKin.RESET;
            objNextKin.INIT();
            objRegMember.SETRANGE("ID No.",Idnomemberapp);
            IF objRegMember.FIND('-') THEN BEGIN
              objNextKin."Account No":=objRegMember."No.";
            objNextKin.Name:="Full Names";
            objNextKin.Relationship:=Relationship;
            objNextKin."ID No.":="ID Number";
            objNextKin.Telephone:="Phone Contact";
            objNextKin.Address:=Address;
            objNextKin.INSERT(TRUE);
            END;
          END;
    END;

    PROCEDURE FnMemberApply@1000000015("First Name"@1000000000 : Code[30];"Mid Name"@1000000001 : Code[30];"Last Name"@1000000002 : Code[30];"PO Box"@1000000003 : Text;Residence@1000000004 : Code[30];"Postal Code"@1000000005 : Text;Town@1000000006 : Code[30];"Phone Number"@1000000007 : Code[30];Email@1000000008 : Text;"ID Number"@1000000009 : Code[30];"Branch Code"@1000000010 : Code[30];"Branch Name"@1000000011 : Code[30];"Account Number"@1000000012 : Code[30];Gender@1000000013 : Option;"Marital Status"@1000000014 : Option;"Account Category"@1000000015 : Option;"Application Category"@1000000016 : Option;"Customer Group"@1000000017 : Code[30];"Employer Name"@1000000018 : Code[30];"Date of Birth"@1000000019 : Date) num : Text;
    BEGIN
      BEGIN

            objRegMember.RESET;
            objRegMember.SETRANGE("ID No.","ID Number");
            IF objRegMember.FIND('-') THEN BEGIN
              MESSAGE('already registered');
            END
              ELSE  BEGIN
            objRegMember.INIT;
            objRegMember.Name:="First Name"+' '+"Mid Name"+' '+"Last Name";
            objRegMember.Address:="PO Box";
            objRegMember."Address 2":=Residence;
            objRegMember."Postal Code":="Postal Code";
            objRegMember.Town:=Town;
            objRegMember."Mobile Phone No":="Phone Number";
            objRegMember."E-Mail (Personal)":=Email;
            objRegMember."Date of Birth":= "Date of Birth";
            objRegMember."ID No.":="ID Number";
            objRegMember."Bank Code":="Branch Code";
            objRegMember."Bank Name":="Branch Name";
            objRegMember."Bank Account No":= "Account Number";
            objRegMember.Gender:=Gender;
            objRegMember."Created By":=USERID;
            objRegMember."Global Dimension 1 Code":='BOSA';
           // objRegMember."Date of Registration":=TODAY;
            objRegMember.Status:=objRegMember.Status::Open;
            //objRegMember."Application Category":="Application Category";
            objRegMember."Account Category":="Account Category";
            objRegMember."Marital Status":="Marital Status";
            objRegMember."Employer Name":="Employer Name";
            objRegMember."Customer Posting Group":="Customer Group";
            objRegMember.INSERT(TRUE);
            END;


            //FnRegisterKin('','','','','');
          END;
    END;

    LOCAL PROCEDURE FnFreeShares@1000000012("Member No"@1000000000 : Text) Shares : Text;
    BEGIN
      BEGIN
            BEGIN
            GenSetup.GET();
            FreeShares:=0;
            glamount:=0;

              objMember.RESET;
              objMember.SETRANGE(objMember."No.","Member No");
              IF objMember.FIND('-') THEN BEGIN
                objMember.CALCFIELDS("Current Shares");
                LoansGuaranteeDetails.RESET;
                LoansGuaranteeDetails.SETRANGE(LoansGuaranteeDetails."Member No",objMember."No.");
                LoansGuaranteeDetails.SETRANGE(LoansGuaranteeDetails.Substituted,FALSE);
                  IF LoansGuaranteeDetails.FIND('-') THEN BEGIN
                    REPEAT
                        glamount:=glamount+LoansGuaranteeDetails."Amont Guaranteed";
                        //MESSAGE('Member No %1 Account no %2',Members."No.",glamount);
                        UNTIL LoansGuaranteeDetails.NEXT =0;
                  END;
                 //FreeShares:=(objMember."Current Shares"*GenSetup."Contactual Shares (%)")-glamount;
                  Shares:= FORMAT(FreeShares,0,'<Precision,2:2><Integer><Decimals>');
              END;
              END;
          END;
    END;

    PROCEDURE FnStandingOrders@1000000014(BosaAcNo@1000000000 : Code[30];SourceAcc@1000000001 : Code[50];frequency@1000000002 : Text;Duration@1000000003 : Text;DestAccNo@1000000004 : Code[30];StartDate@1000000005 : Date;Amount@1000000007 : Decimal;DestAccType@1000000008 : Option);
    BEGIN
      objStandingOrders.INIT();
      objStandingOrders."BOSA Account No.":=BosaAcNo;
      objStandingOrders."Source Account No.":=SourceAcc;
      objStandingOrders.VALIDATE(objStandingOrders."Source Account No.");
      IF FORMAT(freq) ='' THEN
        EVALUATE(freq, frequency);
      objStandingOrders.Frequency:= freq;
      IF FORMAT(dur) ='' THEN
        EVALUATE(dur, Duration);
      objStandingOrders.Duration:=dur;
      objStandingOrders."Destination Account No." :=DestAccNo;
      objStandingOrders.VALIDATE(objStandingOrders."Destination Account No.");
      objStandingOrders."Destination Account Type":= DestAccType;
      objStandingOrders.Amount:= Amount;
      objStandingOrders."Effective/Start Date" :=StartDate;
      objStandingOrders.VALIDATE(objStandingOrders.Duration);
      objStandingOrders.Status:=objStandingOrders.Status::Open;
      objStandingOrders.INSERT(TRUE);
      objMember.RESET;
      objMember.SETRANGE(objMember."No.", BosaAcNo);
      IF objMember.FIND('-') THEN BEGIN
        phoneNumber:=objMember."Phone No.";
        sms:='You have created a standing order of amount : ' +FORMAT(Amount)+' from Account '+SourceAcc+' start date: '
              + FORMAT(StartDate)+'. Thanks for using TELEPOST SACCO Portal.';
        FnSMSMessage(SourceAcc,phoneNumber,sms);
        //MESSAGE('All Cool');
        END
    END;

    PROCEDURE FnUpdateMonthlyContrib@1000000017("Member No"@1000000000 : Code[30];"Updated Fig"@1000000001 : Decimal);
    BEGIN
      objMember.RESET;
      objMember.SETRANGE(objMember."No.", "Member No");

      IF objMember.FIND('-') THEN BEGIN
       phoneNumber:= objMember."Phone No.";
        FAccNo := objMember."FOSA Account";
        objMember."Monthly Contribution":="Updated Fig";
        objMember.MODIFY;
        sms := 'You have adjusted your monthly contributions to: '+FORMAT("Updated Fig")+' account number '+FAccNo+
              '. Thank you for using SURESTEP Sacco Portal';
        FnSMSMessage(FAccNo,phoneNumber,sms);

      //MESSAGE('Updated');
      END
    END;

    PROCEDURE FnSMSMessage@1000000038(accfrom@1000000001 : Text[30];phone@1000000002 : Text[20];message@1000000003 : Text[250]);
    BEGIN

          SMSMessages.RESET;
          IF SMSMessages.FIND('+') THEN BEGIN
          iEntryNo:=SMSMessages."Entry No";
          iEntryNo:=iEntryNo+1;
          END
          ELSE BEGIN
          iEntryNo:=1;
          END;
          SMSMessages.INIT;
          SMSMessages."Entry No":=iEntryNo;
          //SMSMessages."Batch No":=documentNo;
          //SMSMessages."Document No":=documentNo;
          SMSMessages."Account No":=accfrom;
          SMSMessages."Date Entered":=TODAY;
          SMSMessages."Time Entered":=TIME;
          SMSMessages.Source:='WEBPORTAL';
          SMSMessages."Entered By":=USERID;
          SMSMessages."Sent To Server":=SMSMessages."Sent To Server"::No;
          SMSMessages."SMS Message":=message;
          SMSMessages."Telephone No":=phone;
          IF SMSMessages."Telephone No"<>'' THEN
          SMSMessages.INSERT;
    END;

    PROCEDURE FnLoanApplication@1000000018(Member@1000000000 : Code[30];LoanProductType@1000000002 : Code[10];AmountApplied@1000000003 : Decimal;LoanPurpose@1000000004 : Code[30];RepaymentFrequency@1000000007 : Integer;LoanConsolidation@1000000009 : Boolean;LoanBridging@1000000010 : Boolean;LoanRefinancing@1000000011 : Boolean) Result : Boolean;
    BEGIN
      //objMember.RESET;
      //objMember.SETRANGE(objMember."No.", Member);
      // IF objMember.FIND('-') THEN BEGIN
      //
      //   objLoanApplication.RESET;
      //   objLoanApplication.INIT;
      //    objLoanApplication.INSERT(TRUE);
      //  // objLoanApplication.Type:=objLoanApplication.Type::"Loan Form";
      //   objLoanApplication."Account No":=Member;
      //   objLoanApplication.VALIDATE(objLoanApplication."Account No");
      //
      //   objLoanApplication."Loan Type" :=LoanProductType;
      //
      //   objLoanApplication."Captured by":=USERID;
      //   objLoanApplication.Amount:=AmountApplied;
      //   objLoanApplication."Purpose of loan":=LoanPurpose;
      //   objLoanApplication."Repayment Period" :=RepaymentFrequency;
      //   objLoanApplication."Loan Bridging":=LoanBridging;
      //   objLoanApplication."Loan Consolidation":=LoanConsolidation;
      //   objLoanApplication."Loan Refinancing":=LoanRefinancing;
      //   objLoanApplication.Submited:=TRUE;
      //  objLoanApplication.MODIFY;
      //
      //
      // END;


             objLoanRegister.INIT;
           //  objLoanRegister.INSERT;
             objLoanRegister."Client Code":=Member;
           //   objLoanRegister.INSERT(TRUE);

             objLoanRegister.VALIDATE("Client Code");      objLoanRegister."Loan Product Type":=LoanProductType;
             objLoanRegister.VALIDATE("Loan Product Type");
             objLoanRegister."Account No":='20303030';
              objLoanRegister.Installments:=RepaymentFrequency;
            objLoanRegister.VALIDATE(Installments);
            objLoanRegister."Requested Amount":=AmountApplied;
          //  objLoanRegister.VALIDATE("Requested Amount");
           objLoanRegister.Source:=objLoanRegister.Source::BOSA;
             objLoanRegister."Captured By":=USERID;
             objLoanRegister."Loan Purpose":=LoanPurpose;
            MESSAGE(objLoanRegister."Loan  No.");

           // objLoanRegister.Source:=objLoanRegister.Source::FOSA;
            //  objLoanRegister.VALIDATE("Requested Amount");
             objLoanRegister."Loan Status":=objLoanRegister."Loan Status"::Application;
             objLoanRegister."Application Date":=TODAY;


          objLoanRegister.INSERT;
             MESSAGE('here');
              Result:=TRUE;
              phoneNumber:=objMember."Phone No.";
              ClientName := objMember."FOSA Account";
              sms:='We have received your '+LoanProductType+' loan application of  amount : ' +FORMAT(AmountApplied)+
              '. We are processing your loan, you will hear from us soon. Thanks for using MAGADI SACCO  Portal.';
              FnSMSMessage(ClientName,phoneNumber,sms);
              PortaLuPS.INIT;
             // PortaLuPS.INSERT(TRUE);
             objLoanRegister.RESET;
             objLoanRegister.SETRANGE("Client Code", Member);
             objLoanRegister.SETCURRENTKEY("Application Date");
             objLoanRegister.ASCENDING(TRUE);
             IF objLoanRegister.FINDLAST
               THEN

              PortaLuPS.LaonNo:=objLoanRegister."Loan  No.";
              PortaLuPS.RequestedAmount:=AmountApplied;
              PortaLuPS.INSERT;
              //MESSAGE('All Cool');
            //MESSAGE('Am just cool');
      //END;
    END;

    PROCEDURE FnDepositsStatement@1000000023("Account No"@1000000000 : Code[30];path@1000000001 : Text[100]);
    VAR
      Filename@1000000002 : Text[100];
    BEGIN
      Filename := FILESPATH+path;
      MESSAGE(FILESPATH);
      IF EXISTS(Filename) THEN

        ERASE(Filename);
        objMember.RESET;
        objMember.SETRANGE(objMember."No.","Account No");

      IF objMember.FIND('-') THEN BEGIN
        REPORT.SAVEASPDF(51516354,Filename,objMember);
      END;
    END;

    PROCEDURE FnLoanStatement@1000000028(MemberNo@1002 : Code[50];filter@1001 : Text;VAR BigText@1000 : BigText);
    VAR
      Filename@1011 : Text[100];
      Convert@1010 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
      Path@1009 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Path";
      _File@1008 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.File";
      FileAccess@1007 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileAccess";
      FileMode@1006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
      MemoryStream@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
      FileStream@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileStream";
      Outputstream@1003 : OutStream;
    BEGIN

        objMember.RESET;
        objMember.SETRANGE(objMember."No.",MemberNo);


      IF objMember.FIND('-') THEN BEGIN
      //  objMember.SETFILTER("Date Filter", filter);
      Filename:=Path.GetTempPath()+Path.GetRandomFileName();
      REPORT.SAVEASPDF(50308,Filename, objMember);

       FileMode:=4;
       FileAccess:=1;

       FileStream:=_File.Open(Filename,FileMode,FileAccess);

       MemoryStream:=MemoryStream.MemoryStream();

       MemoryStream.SetLength(FileStream.Length);
       FileStream.Read(MemoryStream.GetBuffer(),0,FileStream.Length);

       BigText.ADDTEXT((Convert.ToBase64String(MemoryStream.GetBuffer())));
       MESSAGE(FORMAT(BigText));
      // exitString:=BigText;
      //MESSAGE(exitString);
      MemoryStream.Close();

      MemoryStream.Dispose();
      FileStream.Close();
      FileStream.Dispose();
      _File.Delete(Filename);

      END;
    END;

    PROCEDURE Fnlogin@1(username@1000 : Code[20];password@1001 : Code[10]) status : Boolean;
    BEGIN
      objMember.RESET;
      objMember.SETRANGE(objMember."No.", username);
      objMember.SETRANGE(Password, password);
      IF objMember.FIND('-') THEN  BEGIN
        status:=TRUE;
        END
        ELSE BEGIN

      objMember.RESET;
      objMember.SETRANGE(objMember."Payroll/Staff No",username);
      objMember.SETRANGE(Password, password);
      IF objMember.FIND('-') THEN BEGIN
      status:=TRUE  END ELSE
        status:=FALSE;
        END;
    END;

    PROCEDURE FnmemberInfo@21(MemberNo@1000 : Code[20]) info : Text;
    BEGIN
      objMember.RESET;
      objMember.SETRANGE(objMember."No.", MemberNo);
      IF objMember.FIND('-') THEN BEGIN
        info:=objMember."No."+'.'+':'+objMember.Name+'.'+':'+objMember."E-Mail"+':'+ FORMAT(objMember.Status)+':'+FORMAT(objMember."Account Category")+':'+objMember."Mobile Phone No"
        +':'+objMember."ID No."+':'+objMember."FOSA Account";
      END
      ELSE
      objMember.RESET;
      objMember.SETRANGE (objMember."Payroll/Staff No", MemberNo);
      IF objMember.FIND('-') THEN BEGIN
        info:=objMember."No."+':'+objMember.Name+':'+objMember."E-Mail"+':'+objMember."Employer Name"+':'+FORMAT(objMember.Status)+':'+objMember."Mobile Phone No"
        +':'+objMember."ID No."+':'+objMember."FOSA Account"+':'+objMember."FOSA Account";
        END

      ELSE
      objMember.RESET;
      objMember.SETRANGE (objMember."ID No.", MemberNo);
      IF objMember.FIND('-') THEN BEGIN
        info:=objMember."No."+':'+objMember.Name+':'+objMember."E-Mail"+':'+objMember."Employer Name"+':'+FORMAT(objMember.Status)+':'+objMember."Mobile Phone No"
        +':'+objMember."ID No."+':'+objMember."FOSA Account"+':'+objMember."FOSA Account";
        END;
    END;

    PROCEDURE fnAccountInfo@29(Memberno@1000 : Code[20]) info : Text;
    BEGIN
      objMember.RESET;
      objMember.SETRANGE(objMember."No.", Memberno);
      IF objMember.FIND('-') THEN BEGIN
        FosaBal:=SFactory.FnGetAccountAvailableBalance(objMember."FOSA Account");
        objMember.CALCFIELDS("Current Shares",objMember."Total Loans Outstanding");
      objMember.CALCFIELDS("Shares Retained", objMember."FOSA  Account Bal", objMember."School Fees Shares");
        info:=FORMAT(FosaBal)+':'+FORMAT(objMember."Shares Retained")+':'+FORMAT(objMember."Current Shares")+':'+FORMAT(objMember."Total Loans Outstanding")+':'+FORMAT(objMember."Dividend Amount")
        +':'+FORMAT(objMember."School Fees Shares");
        END;
    END;

    PROCEDURE fnaccounts@1120054002(Memberno@1000 : Code[20]) info : Text;
    BEGIN
      Vendor.RESET;
      Vendor.SETRANGE(Vendor."BOSA Account No", Memberno);
       IF Vendor.FINDSET THEN BEGIN
        REPEAT
           info:=info+FORMAT(SFactory.FnGetAccountAvailableBalance(Vendor."No."))+':'+FORMAT(Vendor."No.")+':'+FORMAT(Vendor.Name)+':'+FORMAT(Vendor.Status)+':'+FORMAT(Vendor."Account Type")+'::';
          UNTIL
          Vendor.NEXT=0;
        END;
    END;

    PROCEDURE fnloaninfo@47(Memberno@1000 : Code[20]) info : Text;
    BEGIN
        TLoans:=0;
        objLoanRegister.RESET;
       objLoanRegister.CALCFIELDS(objLoanRegister."Outstanding Balance");
      objLoanRegister.SETFILTER(objLoanRegister."Outstanding Balance", '>0');
      objLoanRegister.SETRANGE(objLoanRegister."Client Code", Memberno);
       IF objLoanRegister.FIND('-') THEN BEGIN
        REPEAT
           objLoanRegister.CALCFIELDS("Outstanding Balance","Oustanding Interest");
       TLoans:=TLoans+objLoanRegister."Outstanding Balance"+objLoanRegister."Oustanding Interest";
          UNTIL
          objLoanRegister.NEXT=0;
          info:=FORMAT(TLoans)+':'+FORMAT(TLoans);
        END;
    END;

    PROCEDURE fnLoans@57(MemberNo@1000 : Code[20]) loans : Text;
    BEGIN
      objLoanRegister.RESET;
       objLoanRegister.CALCFIELDS(objLoanRegister."Outstanding Balance");
      objLoanRegister.SETFILTER(objLoanRegister."Outstanding Balance", '>0');
      objLoanRegister.SETRANGE(objLoanRegister."Client Code", MemberNo);

       IF objLoanRegister.FIND('-') THEN BEGIN
      //     MESSAGE('test%1',Loanperiod);
       // objLoanRegister.SETCURRENTKEY(objLoanRegister."Application Date");
       // objLoanRegister.ASCENDING(FALSE);

        REPEAT
        // Loanperiod:=Kentoursfactory.KnGetCurrentPeriodForLoan(objLoanRegister."Loan  No.");

           objLoanRegister.CALCFIELDS("Outstanding Balance","Oustanding Interest");
       loans:=loans+objLoanRegister."Loan Product Type Name"+':'+ FORMAT(objLoanRegister."Outstanding Balance"+objLoanRegister."Oustanding Interest")+':'+FORMAT(objLoanRegister."Loan Status")+':'+FORMAT(objLoanRegister.Installments)+':'
        +FORMAT(objLoanRegister.Installments-Loanperiod)+':'+FORMAT(objLoanRegister."Outstanding Balance"+objLoanRegister."Oustanding Interest")+':'+FORMAT(objLoanRegister."Approved Amount")+'::';

          UNTIL
          objLoanRegister.NEXT=0;

        END;
    END;

    PROCEDURE fnLoansAccounts@1120054012(MemberNo@1000 : Code[20]) loans : Text;
    BEGIN
      objLoanRegister.RESET;
       objLoanRegister.CALCFIELDS(objLoanRegister."Outstanding Balance");
      objLoanRegister.SETFILTER(objLoanRegister."Outstanding Balance", '>0');
      objLoanRegister.SETRANGE(objLoanRegister."Client Code", MemberNo);
      //objLoanRegister.SETRANGE(objLoanRegister.Source, objLoanRegister.Source::FOSA);
       IF objLoanRegister.FIND('-') THEN BEGIN

        REPEAT

       loans:=loans+objLoanRegister."Loan  No."+':'+ FORMAT(objLoanRegister."Loan Product Type Name")+'::';
          UNTIL
          objLoanRegister.NEXT=0;

        END;
    END;

    PROCEDURE FnloanCalc@24(LoanAmount@1000 : Decimal;RepayPeriod@1001 : Integer;LoanCode@1002 : Code[30];Repayment@1000000000 : Decimal;Bool@1000000001 : Boolean) text : Text;
    BEGIN
       Loansetup.RESET;
      Loansetup.SETRANGE(Code, LoanCode);

      IF Loansetup.FIND('-') THEN BEGIN
      //   if loansetup."repayment method" = loansetup."repayment method"::amortised then begin
      //     totalmrepay := round((loansetup."interest rate" / 12 / 100) / (1 - power((1 + (loansetup."interest rate" / 12 / 100)), -repayperiod)) * loanamount, 0.0001, '>');
      //     linterest := round(lbalance / 100 / 12 * interestrate, 0.0001, '>');
      //     lprincipal := totalmrepay - linterest;
      //
      //        text := text + FORMAT(Date) + '!!' + FORMAT(ROUND(TotalMRepay)) + '!!' + FORMAT(ROUND(LInterest)) + '!!' + FORMAT(ROUND(LPrincipal)) + '!!' + FORMAT(ROUND(LoanAmount)) + '??';
      //   end;

      //   IF Loansetup."Repayment Method" = Loansetup."Repayment Method"::"Straight Line" THEN BEGIN
      //     LoansRec.TESTFIELD(LoansRec.Interest);
      //     LoansRec.TESTFIELD(LoansRec.Installments);
      //     LPrincipal := LoanAmount / RepayPeriod;
      //     LInterest := (Loansetup."Interest rate" / 12 / 100) * LoanAmount / RepayPeriod;
      //   END;
       IF Loansetup."Repayment Method" = Loansetup."Repayment Method"::Amortised THEN BEGIN
         LBalance:=LoanAmount;
         InterestRate:=Loansetup."Interest rate";
      Date := CALCDATE('+1M', TODAY);
        IF RepayPeriod > Loansetup."Default Installements" THEN BEGIN
          text := text + FORMAT('Please') + '!!' + FORMAT('Use ') + '!!' + FORMAT('Installments lower than') + '!!' + FORMAT('Our') + '!!' + FORMAT('Limit') + '??';
        END ELSE BEGIN
            TotalMRepay :=  ROUND((InterestRate/12/100) / (1 - POWER((1 +(InterestRate/12/100)),- (RepayPeriod))) * (LoanAmount));
            REPEAT
              LBalance:=LBalance-LPrincipal;
             LInterest := ROUND(LBalance / 100 / 12 * InterestRate, 0.0001, '>');
              LPrincipal := TotalMRepay - LInterest;
              LoanAmount := LoanAmount - LPrincipal;
              RepayPeriod := RepayPeriod - 1;
              text := text + FORMAT(Date) + '!!' + FORMAT(ROUND(LPrincipal)) + '!!' + FORMAT(ROUND(LInterest)) + '!!' + FORMAT(ROUND(TotalMRepay)) + '!!' + FORMAT(ROUND(LoanAmount)) + '??';
              Date := CALCDATE('+1M', Date);
               UNTIL RepayPeriod = 0;
        END;
      END;


        IF Loansetup."Repayment Method" = Loansetup."Repayment Method"::"Reducing Balance" THEN BEGIN
          Date := TODAY;
          IF RepayPeriod > Loansetup."No of Installment" THEN BEGIN
            text := text + FORMAT('Please') + '!!' + FORMAT('Use ') + '!!' + FORMAT('Installments lower than') + '!!' + FORMAT('Our') + '!!' + FORMAT('Limit') + '??';
          END ELSE BEGIN
            IF Bool = TRUE THEN BEGIN
              TotalMRepay := Repayment;
              LoanAmount := Repayment * RepayPeriod;
              REPEAT
                LInterest := ROUND(LoanAmount * Loansetup."Interest rate" / 12 / 100, 0.0001, '>');
                LPrincipal := TotalMRepay - LInterest;
                LoanAmount := LoanAmount - LPrincipal;
                RepayPeriod := RepayPeriod - 1;
                text := text + FORMAT(Date) + '!!' + FORMAT(ROUND(LPrincipal)) + '!!' + FORMAT(ROUND(LInterest)) + '!!' + FORMAT(ROUND(TotalMRepay)) + '!!' + FORMAT(ROUND(LoanAmount)) + '??';
                Date := CALCDATE('+1M', Date);
              UNTIL RepayPeriod = 0;
            END ELSE IF Bool = FALSE THEN BEGIN
              TotalMRepay := ROUND(LoanAmount / RepayPeriod, 0.0001, '>');
              REPEAT
                LInterest := ROUND(LoanAmount * Loansetup."Interest rate" / 12 / 100, 0.0001, '>');
                LPrincipal := LInterest + TotalMRepay;
                RepayPeriod := RepayPeriod - 1;
                text := text + FORMAT(Date) + '!!' + FORMAT(ROUND(TotalMRepay)) + '!!' + FORMAT(ROUND(LInterest)) + '!!' + FORMAT(ROUND(LPrincipal)) + '!!' + FORMAT(ROUND(LoanAmount)) + '??';
                LoanAmount := LoanAmount - TotalMRepay;
                Date := CALCDATE('+1M', Date);
              UNTIL RepayPeriod = 0;
            END;
          END;
        END;

      IF  Loansetup."Repayment Method"= Loansetup."Repayment Method"::Constants THEN BEGIN
        LoansRec.TESTFIELD(LoansRec.Repayment);
        IF LBalance < LoansRec.Repayment THEN
        LPrincipal:=LBalance
        ELSE
        LPrincipal:=LoansRec.Repayment;
        LInterest:=LoansRec.Interest;
        END;
        END;


        //END;

      //EXIT(Amount);
    END;

    PROCEDURE Fnloanssetup@25() loanType : Text;
    BEGIN
      Loansetup.RESET;
      Loansetup.SETFILTER(Loansetup.ShowPortal, 'yes');
      BEGIN
      loanType:='';

      REPEAT
      loanType:=FORMAT(Loansetup.Code)+':'+Loansetup."Product Description"+':::'+loanType;
        UNTIL Loansetup.NEXT=0;
        END;
    END;

    PROCEDURE FnGetProductName@1120054107(LoanCode@1120054000 : Code[30]) Name : Text;
    BEGIN
      Loansetup.RESET;
      Loansetup.SETRANGE(Loansetup.Code,LoanCode);
      IF Loansetup.FINDFIRST THEN
      BEGIN
      Name:=Loansetup."Product Description"+':'+FORMAT(Loansetup."Default Installements");
         END;
    END;

    PROCEDURE fnLoanDetails@40(Loancode@1000 : Code[20]) loandetail : Text;
    BEGIN
      Loansetup.RESET;
      //Loansetup.SETRANGE(Code, Loancode);
      Loansetup.SETFILTER(Loansetup.ShowPortal, 'yes');
      IF Loansetup.FIND('-') THEN BEGIN
        REPEAT
        loandetail:=loandetail+Loansetup."Product Description"+'!!'+ FORMAT(Loansetup."Repayment Method")+'!!'+FORMAT(Loansetup."Max. Loan Amount")+'!!'+FORMAT(Loansetup."Instalment Period")+'!!'+FORMAT(Loansetup."Interest rate")+'!!'
        +FORMAT(Loansetup."Repayment Frequency")+'??';
        UNTIL Loansetup.NEXT=0;
      END;
    END;

    PROCEDURE fnFeedback@2(No@1000 : Code[20];Comment@1001 : Text[200]);
    BEGIN
       objMember.RESET;
       objMember.SETRANGE("No.", No);
       IF objMember.FIND('-') THEN BEGIN
        IF feedback.FIND('+') THEN
        feedback.Entry:=feedback.Entry+1
        ELSE
        feedback.Entry:=1;
        feedback.No:=No;
        feedback.Portalfeedback:=Comment;
        feedback.DatePosted:=TODAY;
        feedback.INSERT(TRUE)


       END
       ELSE
       EXIT;
    END;

    PROCEDURE fnLoansPurposes@3() LoanType : Text;
    BEGIN
      LoansPurpose.RESET;
      BEGIN
      LoanType:='';
      REPEAT
      LoanType:=FORMAT(LoansPurpose.Code)+':'+LoansPurpose.Description+':::'+LoanType;
        UNTIL LoansPurpose.NEXT=0;
      END;
    END;

    PROCEDURE fnReplys@4(No@1000 : Code[20]) text : Text;
    BEGIN
       feedback.RESET;
       feedback.SETRANGE(No, No);
       feedback.SETCURRENTKEY(Entry);
       feedback.ASCENDING(FALSE);
       IF feedback.FIND('-') THEN BEGIN
         REPEAT
            IF(feedback.Reply ='') THEN BEGIN

        END ELSE
           text:=text+FORMAT(feedback.DatePosted)+'!!'+feedback.Portalfeedback+'!!'+ feedback.Reply+'??';
       UNTIL feedback.NEXT=0;
       END;
    END;

    PROCEDURE FnNotifications@5("Member No"@1001 : Code[10];path@1000 : Text) text : Text;
    VAR
      Filename@1002 : Text[100];
    BEGIN
       Filename := FILESPATH+path;
       IF EXISTS(Filename) THEN

        ERASE(Filename);
       objLoanRegister.RESET;
       objLoanRegister.SETRANGE("Loan  No.", "Member No");

       IF objLoanRegister.FIND('-') THEN BEGIN
        REPORT.SAVEASPDF(51516964,Filename,objLoanRegister);

       END;
    END;

    PROCEDURE fnGuarantorsPortal@6(Member@1003 : Code[40];Number@1000 : Code[40];LoanNo@1001 : Code[40];Message@1002 : Text[100]);
    BEGIN
       objMember.RESET;
       objMember.SETRANGE("No.", Member);
       IF objMember.FIND('-') THEN BEGIN
        IF feedback.FIND('+') THEN
        feedback.Entry:=feedback.Entry+1
        ELSE
        feedback.Entry:=1;
        feedback.No:=Member;
        feedback.LoanNo:=LoanNo;
       // feedback.Portalfeedback:=Message;
        feedback.DatePosted:=TODAY;
       feedback.Guarantor:=Number;

       //feedback.LoanNo:=objLoanRegister."Loan  No.";
       feedback.Accepted:=0;
       feedback.Rejected:=0;
        feedback.INSERT(TRUE)


       END
       ELSE
       EXIT;
    END;

    PROCEDURE FnApproveGurarantors@11(Approval@1000 : Integer;Number@1001 : Code[40];LoanNo@1002 : Integer;reply@1003 : Text;Amount@1004 : Decimal);
    BEGIN
       feedback.INIT;
       IF (Approval=0) THEN BEGIN
          feedback.SETRANGE(Entry,LoanNo);
      feedback.SETRANGE(Guarantor, Number);
      IF feedback.FIND ('-') THEN BEGIN


        feedback.Accepted:=0;
        feedback.Rejected:=1;
        feedback.MODIFY;
        END;
        END

       ELSE IF Approval=1 THEN BEGIN
      feedback.RESET;

      feedback.SETRANGE(Entry,LoanNo);
      feedback.SETRANGE(Guarantor, Number);
      IF feedback.FIND ('-') THEN BEGIN


        feedback.Accepted:=1;
        feedback.Rejected:=0;
        feedback.Amount:=Amount;
      objMember.SETRANGE("No.", Number);
      IF objMember.FIND('-') THEN


      reply:=objMember.Name+' '+'Has accepted to quarntee your loan';

      objLoanRegister.RESET;
      objLoanRegister.SETRANGE("Loan  No.",feedback.LoanNo);
      MESSAGE(feedback.LoanNo);
      IF objLoanRegister.FIND('-') THEN
      reply:=reply+ 'of amount '+ FORMAT(objLoanRegister."Requested Amount");
      LoansGuaranteeDetails.INIT;
      LoansGuaranteeDetails.CALCFIELDS("Loanees  No");

      LoansGuaranteeDetails."Member No":=Number;
      LoansGuaranteeDetails.VALIDATE("Member No");
      LoansGuaranteeDetails.VALIDATE("Substituted Guarantor");
      LoansGuaranteeDetails."Loan No":=feedback.LoanNo;
      LoansGuaranteeDetails.VALIDATE("Loan No");
      LoansGuaranteeDetails."Amont Guaranteed":=Amount;
      LoansGuaranteeDetails.VALIDATE("Amont Guaranteed");
      PortaLuPS.SETRANGE(LaonNo, feedback.LoanNo);
      IF PortaLuPS.FIND('-') THEN BEGIN
       // PortaLuPS.INIT;
      PortaLuPS.TotalGuaranteed:=PortaLuPS.TotalGuaranteed+Amount;
      PortaLuPS.MODIFY;

      //LoansGuaranteeDetails.VALIDATE("Amont Guaranteed");
      //LoansGuaranteeDetails."Loanees  No":=feedback.No;

      //LoansGuaranteeDetails.VALIDATE("Loanees  No");
      feedback.Reply:=reply;
      feedback.MODIFY;
      LoansGuaranteeDetails.INSERT;
      END;
      END;
      END;
    END;

    PROCEDURE FNAppraisalLoans@7(Member@1000 : Code[10]) loans : Text;
    BEGIN
      objLoanRegister.RESET;
      objLoanRegister.SETRANGE("Client Code",Member);
      IF objLoanRegister.FIND('-') THEN BEGIN
        objLoanRegister.SETCURRENTKEY("Application Date");

       // objLoanRegister.ASCENDING(FALSE);
       // objLoanRegister.SETFILTER("Loan Status", '=%1',objLoanRegister."Loan Status"::Application);
        // objLoanRegister."Loan Status"::Appraisal;
        REPEAT
          objLoanRegister.CALCFIELDS("Total Loans Outstanding");
          loans:=loans+objLoanRegister."Loan  No."+':'+objLoanRegister."Loan Product Type"+':'+ FORMAT(objLoanRegister."Requested Amount")+'::';
          UNTIL
          objLoanRegister.NEXT=0;
      END;
    END;

    PROCEDURE FnGetLoansForGuarantee@8(Member@1000 : Code[40]) Guarantee : Text;
    BEGIN
      feedback.RESET;
      feedback.SETRANGE(Guarantor, Member);
      feedback.SETRANGE(Accepted, 0);
      feedback.SETRANGE(Rejected,0);

       IF feedback.FIND('-') THEN BEGIN

         REPEAT
           objMember.SETRANGE("No.", feedback.No);
           IF objMember.FIND('-') THEN
             FAccNo:=objMember.Name;
           phoneNumber:=objMember."Phone No.";
           PortaLuPS.SETRANGE(LaonNo, feedback.LoanNo);
           IF PortaLuPS.FIND('-') THEN
             Amount:=(PortaLuPS.RequestedAmount-PortaLuPS.TotalGuaranteed);
           Guarantee:=Guarantee+FORMAT(feedback.Entry)+':'+FAccNo+':'+FORMAT(phoneNumber)+'>>'+':'+FORMAT(Amount)+'::';

      UNTIL feedback.NEXT=0;
      END;
    END;

    PROCEDURE FnEditableLoans@9(MemberNo@1000 : Code[10];Loan@1003 : Code[20]) Edit : Text;
    VAR
      Loantpe@1001 : Text;
      Loanpurpose@1002 : Text;
    BEGIN
      LoansGuaranteeDetails.RESET;
      LoansGuaranteeDetails.SETRANGE("Member No", MemberNo);
      LoansGuaranteeDetails.SETRANGE("Loan No",Loan);

      IF LoansGuaranteeDetails.FIND('-') THEN BEGIN
        REPEAT
         Edit:=Edit+LoansGuaranteeDetails."Loan No"+LoansGuaranteeDetails."Loanees  Name"+ FORMAT(LoansGuaranteeDetails."Amont Guaranteed");
          UNTIL LoansGuaranteeDetails.NEXT=0;

      END;
    END;

    PROCEDURE fnedtitloan@10(Amount@1000 : Decimal;Loan@1001 : Integer;Repaymperiod@1002 : Integer;LoanPurpose@1003 : Code[20];LoanType@1004 : Code[20]);
    BEGIN
      Loansetup.RESET;
      Loansetup.SETRANGE(Loansetup.Code, LoanType);
      IF Loansetup.FIND('-') THEN BEGIN

        IF Amount> Loansetup."Max. Loan Amount" THEN
         // ERROR('You cannot apply more than the maximum loan amount')
          MESSAGE('');
       // ELSE
        IF Repaymperiod>Loansetup."Default Installements" THEN
        ERROR('Recommended Loan period for this loan is '+FORMAT( Loansetup."Default Installements")+ ' please apply use the recommended installments or below');
      Loans_Portal.RESET;
      Loans_Portal.GET(8);
      //IF Loans_Portal.FIND('-')THEN BEGIN
      //Loans_Portal.CLientCode:=Member;
      Loans_Portal.AppliedAmount:=Amount;
      Loans_Portal.IntrestRate:=Loansetup."Interest rate";
      Loans_Portal."Repayment Frequency":=Loansetup."Repayment Frequency";
      Loans_Portal.Installments:=Repaymperiod;
      Loans_Portal.LoanType:=LoanType;
      Loans_Portal.VALIDATE(LoanType);
      Loans_Portal.MODIFY;
      //END;
      END;
    END;

    PROCEDURE FnApprovedGuarantors@38(Member@1000 : Code[40];Loan@1001 : Code[40]) Guarantee : Text;
    BEGIN
      feedback.RESET;
      feedback.SETRANGE(No, Member);
      feedback.SETRANGE(Accepted, 1);
      feedback.SETRANGE(Rejected,0);
      feedback.SETRANGE(LoanNo,Loan);

       IF feedback.FIND('-') THEN BEGIN

         REPEAT
           objMember.SETRANGE("No.", feedback.Guarantor);
           IF objMember.FIND('-') THEN
             FAccNo:=objMember.Name;
           phoneNumber:=objMember."Phone No.";
           objLoanRegister.SETRANGE("Loan  No.", feedback.LoanNo);
           IF objLoanRegister.FIND('-') THEN
             Amount:=objLoanRegister."Requested Amount";
           Guarantee:=Guarantee+FORMAT(feedback.Entry)+':'+FAccNo+':'+FORMAT(phoneNumber)+'>>'+':'+FORMAT(feedback.Amount)+'::';

      UNTIL feedback.NEXT=0;
      END;
    END;

    PROCEDURE FnPendingGuarantors@39(Member@1001 : Code[40];Loan@1000 : Code[40]) Guarantee : Text;
    BEGIN
       feedback.RESET;
       feedback.SETRANGE(No, Member);
       feedback.SETRANGE(Accepted, 1);
       feedback.SETRANGE(Rejected,0);
       feedback.SETRANGE(LoanNo,Loan);

       IF feedback.FIND('-') THEN BEGIN

         REPEAT
           objMember.SETRANGE("No.", feedback.Guarantor);
           IF objMember.FIND('-') THEN
             FAccNo:=objMember.Name;
           phoneNumber:=objMember."Phone No.";
           objLoanRegister.SETRANGE("Loan  No.", feedback.LoanNo);
           IF objLoanRegister.FIND('-') THEN
             Amount:=objLoanRegister."Requested Amount";
           Guarantee:=Guarantee+FORMAT(feedback.Entry)+':'+FAccNo+':'+FORMAT(phoneNumber)+'>>'+':'+FORMAT(Amount)+'::';

       UNTIL feedback.NEXT=0;
       END;
    END;

    PROCEDURE FnrejectedGuarantors@41(Member@1001 : Code[40];Loan@1000 : Code[40]) Guarantee : Text;
    BEGIN
       feedback.RESET;
       feedback.SETRANGE(No, Member);
       feedback.SETRANGE(Accepted, 0);
       feedback.SETRANGE(Rejected,1);
       feedback.SETRANGE(LoanNo,Loan);

       IF feedback.FIND('-') THEN BEGIN

         REPEAT
           objMember.SETRANGE("No.", feedback.Guarantor);
           IF objMember.FIND('-') THEN
             FAccNo:=objMember.Name;
           phoneNumber:=objMember."Phone No.";
           objLoanRegister.SETRANGE("Loan  No.", feedback.LoanNo);
           IF objLoanRegister.FIND('-') THEN
             Amount:=objLoanRegister."Requested Amount";
           Guarantee:=Guarantee+FORMAT(feedback.Entry)+':'+FAccNo+':'+FORMAT(phoneNumber)+'>>'+'::';

       UNTIL feedback.NEXT=0;
       END;
    END;

    PROCEDURE FnApplytoAppraise@12(LoanNo@1000 : Code[20]);
    BEGIN
      objLoanRegister.RESET;
      objLoanRegister.SETRANGE("Loan  No.", LoanNo);
      IF objLoanRegister.FIND('-') THEN BEGIN
       // objLoanRegister.INIT;
      objLoanRegister."Loan Status":=objLoanRegister."Loan Status"::Appraisal;
      objLoanRegister.MODIFY;
      END;
    END;

    PROCEDURE fnTotalLoanAm@13(Loan@1000 : Code[10]) amount : Decimal;
    BEGIN
       PortaLuPS.RESET;
       PortaLuPS.SETRANGE(LaonNo, Loan);
       IF PortaLuPS.FIND('-') THEN
        BEGIN
          amount:=( PortaLuPS.RequestedAmount-PortaLuPS.TotalGuaranteed);

       END;
    END;

    PROCEDURE Fnquestionaire@14(Member@1000 : Code[20];reason@1001 : Text;time@1002 : Text;Leastimpressed@1003 : Text;Mostimpressed@1004 : Text;suggestion@1005 : Text;accounts@1006 : Option;customercare@1007 : Option;atmosphere@1008 : Option;serveby@1009 : Text);
    BEGIN
      // Questinnaires.INIT;
      // IF Questinnaires.FIND('+') THEN
      //  Questinnaires.Entry:=Questinnaires.Entry+1
      //
      //  ELSE
      //  //Questinnaires.INSERT;
      //  Questinnaires.Entry:=1;
      // Questinnaires.Member:=Member;
      // Questinnaires.ReasonForVisit:=reason;
      // Questinnaires.LeastImpressedWIth:=Leastimpressed;
      // Questinnaires.MostImpressedwith:=Mostimpressed;
      // Questinnaires.Suggestions:=suggestion;
      // Questinnaires.Accounts:=accounts;
      // Questinnaires.Customercare:=customercare;
      // Questinnaires.OfficeAtmosphere:=atmosphere;
      // Questinnaires.ServedBy:=serveby;
      // Questinnaires.INSERT;
    END;

    PROCEDURE fnLoanApplicationform@16("Member No"@1001 : Code[50];start@1000 : Date;peroid@1002 : Code[10]);
    BEGIN

      // DivProg.RESET;
      // DivProg.SETRANGE(DivProg."Member No","Member No");
      // IF DivProg.FIND('-') THEN
      // DivProg.DELETEALL;
      // StartDate:=start;
      // RunningPeriod:=peroid;
      // IF StartDate = 0D THEN
      // ERROR('You must specify start Date.');
      //
      // IF RunningPeriod='' THEN ERROR('Running Period Must be inserted');
      //
      // DivTotal:=0;
      // DivCapTotal:=0;
      // GenSetup.GET(0);
      //
      //
      //
      //
      //
      // //1st Month(Opening bal.....)
      // EVALUATE(BDate,'01/01/05');
      // FromDate:=BDate;
      // ToDate:=CALCDATE('-1D',StartDate);
      // EVALUATE(FromDateS,FORMAT(FromDate));
      // EVALUATE(ToDateS,FORMAT(ToDate));
      //
      // IF Cust.FIND('-') THEN BEGIN
      // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
      // //IF Cust."Current Shares" <> 0 THEN BEGIN
      // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(12/12);
      // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(12/12);
      //
      // DivTotal:=CDiv;
      // DivCapTotal:=CapDiv;
      //
      //
      //
      // DivProg.INIT;
      // DivProg."Member No":="Member No" ;
      // DivProg.Date:=ToDate;
      // DivProg."Gross Dividends":=CDiv;
      // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
      // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(12/12);
      // DivProg.Shares:=Cust."Current Shares"*-1;
      // DivProg."Share Capital":=Cust."Shares Retained"*-1;
      // DivProg."Gross  Share cap Dividend":=CapDiv;
      // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(12/12);
      // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
      // DivProg.Period:=RunningPeriod;
      // DivProg.INSERT;
      // END;
      // //END;
      // //previous Year End(Opening Bal......)
      //
      //
      //
      //
      //
      // DateFilter:=FromDateS+'..'+ToDateS;
      // Cust.RESET;
      // Cust.SETCURRENTKEY("No.");
      // Cust.SETRANGE(Cust."No.","Member No");
      // Cust.SETFILTER(Cust."Date Filter",DateFilter);
      //
      // //1
      // EVALUATE(BDate,'01/01/16');
      // FromDate:=BDate;//StartDate;
      // ToDate:=CALCDATE('-1D',CALCDATE('1M',StartDate));
      // EVALUATE(FromDateS,FORMAT(FromDate));
      // EVALUATE(ToDateS,FORMAT(ToDate));
      //
      // DateFilter:=FromDateS+'..'+ToDateS;
      // Cust.RESET;
      // Cust.SETRANGE(Cust."No.","Member No");
      // Cust.SETFILTER(Cust."Date Filter",DateFilter);
      // IF Cust.FIND('-') THEN BEGIN
      // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
      // //IF Cust."Current Shares" <> 0 THEN BEGIN
      // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(12/12);
      // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(12/12);
      //
      // DivTotal:=CDiv;
      // DivCapTotal:=CapDiv;
      //
      //
      //
      // DivProg.INIT;
      // DivProg."Member No":="Member No";
      // DivProg.Date:=ToDate;
      // DivProg."Gross Dividends":=CDiv;
      // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
      // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(12/12);
      // DivProg.Shares:=Cust."Current Shares"*-1;
      // DivProg."Share Capital":=Cust."Shares Retained"*-1;
      // DivProg."Gross  Share cap Dividend":=CapDiv;
      // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(12/12);
      // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
      // DivProg.Period:=RunningPeriod;
      // DivProg.INSERT;
      // END;
      // //END ELSE
      // //DivTotal:=0;
      // //END;
      //
      //
      //
      //
      //
      //
      // //2
      // FromDate:=CALCDATE('1M',StartDate);
      // ToDate:=CALCDATE('-1D',CALCDATE('2M',StartDate));
      // EVALUATE(FromDateS,FORMAT(FromDate));
      // EVALUATE(ToDateS,FORMAT(ToDate));
      //
      // DateFilter:=FromDateS+'..'+ToDateS;
      // Cust.RESET;
      // Cust.SETRANGE(Cust."No.","Member No");
      // Cust.SETFILTER(Cust."Date Filter",DateFilter);
      // IF Cust.FIND('-') THEN BEGIN
      // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
      // //IF Cust."Current Shares" <> 0 THEN BEGIN
      // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(11/12);
      // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(11/12);
      //
      // DivTotal:=CDiv;
      // DivCapTotal:=CapDiv;
      //
      // DivProg.INIT;
      // DivProg."Member No":="Member No";
      // DivProg.Date:=ToDate;
      // DivProg."Gross Dividends":=CDiv;
      // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
      // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(11/12);
      // DivProg.Shares:=Cust."Current Shares"*-1;
      // DivProg."Share Capital":=Cust."Shares Retained"*-1;
      // DivProg."Gross  Share cap Dividend":=CapDiv;
      // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(11/12);
      // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
      // DivProg.Period:=RunningPeriod;
      // DivProg.INSERT
      //
      // END;
      // //END;
      //
      //
      //
      //
      //
      // //3
      // FromDate:=CALCDATE('2M',StartDate);
      // ToDate:=CALCDATE('-1D',CALCDATE('3M',StartDate));
      // EVALUATE(FromDateS,FORMAT(FromDate));
      // EVALUATE(ToDateS,FORMAT(ToDate));
      //
      // DateFilter:=FromDateS+'..'+ToDateS;
      // Cust.RESET;
      // Cust.SETRANGE(Cust."No.","Member No");
      // Cust.SETFILTER(Cust."Date Filter",DateFilter);
      // IF Cust.FIND('-') THEN BEGIN
      // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
      // //IF Cust."Current Shares" <> 0 THEN BEGIN
      //
      // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(10/12);
      // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(10/12);
      //
      // DivTotal:=CDiv;
      // DivCapTotal:=CapDiv;
      //
      // DivProg.INIT;
      // DivProg."Member No":="Member No";
      // DivProg.Date:=ToDate;
      // DivProg."Gross Dividends":=CDiv;
      // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
      // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(10/12);
      // DivProg.Shares:=Cust."Current Shares"*-1;
      // DivProg."Share Capital":=Cust."Shares Retained"*-1;
      // DivProg."Gross  Share cap Dividend":=CapDiv;
      // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(10/12);
      // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
      // DivProg.Period:=RunningPeriod;
      // DivProg.INSERT
      //
      // END;
      // //END;
      //
      //
      //
      //
      // //4
      // FromDate:=CALCDATE('3M',StartDate);
      // ToDate:=CALCDATE('-1D',CALCDATE('4M',StartDate));
      // EVALUATE(FromDateS,FORMAT(FromDate));
      // EVALUATE(ToDateS,FORMAT(ToDate));
      //
      // DateFilter:=FromDateS+'..'+ToDateS;
      // Cust.RESET;
      // Cust.SETRANGE(Cust."No.","Member No");
      // Cust.SETFILTER(Cust."Date Filter",DateFilter);
      // IF Cust.FIND('-') THEN BEGIN
      // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
      // //IF Cust."Current Shares" <> 0 THEN BEGIN
      //
      // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(9/12);
      // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(9/12);
      //
      // DivTotal:=CDiv;
      // DivCapTotal:=CapDiv;
      //
      // DivProg.INIT;
      // DivProg."Member No":="Member No";
      // DivProg.Date:=ToDate;
      // DivProg."Gross Dividends":=CDiv;
      // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
      // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(9/12);
      // DivProg.Shares:=Cust."Current Shares"*-1;
      // DivProg."Share Capital":=Cust."Shares Retained"*-1;
      // DivProg."Gross  Share cap Dividend":=CapDiv;
      // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(9/12);
      // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
      // DivProg.Period:=RunningPeriod;
      // DivProg.INSERT
      //
      // END;
      // //END;
      //
      //
      //
      //
      // //5
      // FromDate:=CALCDATE('4M',StartDate);
      // ToDate:=CALCDATE('-1D',CALCDATE('5M',StartDate));
      // EVALUATE(FromDateS,FORMAT(FromDate));
      // EVALUATE(ToDateS,FORMAT(ToDate));
      //
      // DateFilter:=FromDateS+'..'+ToDateS;
      // Cust.RESET;
      // Cust.SETRANGE(Cust."No.","Member No");
      // Cust.SETFILTER(Cust."Date Filter",DateFilter);
      // IF Cust.FIND('-') THEN BEGIN
      // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
      // //IF Cust."Current Shares" <> 0 THEN BEGIN
      //
      // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(8/12);
      // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(8/12);
      //
      // DivTotal:=CDiv;
      // DivCapTotal:=CapDiv;
      //
      // DivProg.INIT;
      // DivProg."Member No":="Member No";
      // DivProg.Date:=ToDate;
      // DivProg."Gross Dividends":=CDiv;
      // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
      // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(8/12);
      // DivProg.Shares:=Cust."Current Shares"*-1;
      // DivProg."Share Capital":=Cust."Shares Retained"*-1;
      // DivProg."Gross  Share cap Dividend":=CapDiv;
      // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(8/12);
      // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
      // DivProg.Period:=RunningPeriod;
      // DivProg.INSERT
      // END;
      // //END;
      //
      //
      //
      //
      // //6
      // FromDate:=CALCDATE('5M',StartDate);
      // ToDate:=CALCDATE('-1D',CALCDATE('6M',StartDate));
      // EVALUATE(FromDateS,FORMAT(FromDate));
      // EVALUATE(ToDateS,FORMAT(ToDate));
      //
      // DateFilter:=FromDateS+'..'+ToDateS;
      // Cust.RESET;
      // Cust.SETRANGE(Cust."No.","Member No");
      // Cust.SETFILTER(Cust."Date Filter",DateFilter);
      // IF Cust.FIND('-') THEN BEGIN
      // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
      // //IF Cust."Current Shares" <> 0 THEN BEGIN
      //
      //
      // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(7/12);
      // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(7/12);
      //
      // DivTotal:=CDiv;
      // DivCapTotal:=CapDiv;;
      //
      // DivProg.INIT;
      // DivProg."Member No":="Member No";
      // DivProg.Date:=ToDate;
      // DivProg."Gross Dividends":=CDiv;
      // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
      // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(7/12);
      // DivProg.Shares:=Cust."Current Shares"*-1;
      // DivProg."Share Capital":=Cust."Shares Retained"*-1;
      // DivProg."Gross  Share cap Dividend":=CapDiv;
      // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(7/12);
      // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
      // DivProg.Period:=RunningPeriod;
      // DivProg.INSERT
      //
      // END;
      // //END;
      //
      //
      //
      //
      //
      // //7
      // FromDate:=CALCDATE('6M',StartDate);
      // ToDate:=CALCDATE('-1D',CALCDATE('7M',StartDate));
      // EVALUATE(FromDateS,FORMAT(FromDate));
      // EVALUATE(ToDateS,FORMAT(ToDate));
      //
      // DateFilter:=FromDateS+'..'+ToDateS;
      // Cust.RESET;
      // Cust.SETRANGE(Cust."No.","Member No");
      // Cust.SETFILTER(Cust."Date Filter",DateFilter);
      // IF Cust.FIND('-') THEN BEGIN
      // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
      // //IF Cust."Current Shares" <> 0 THEN BEGIN
      //
      //
      // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(6/12);
      // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(6/12);
      //
      // DivTotal:=CDiv;
      // DivCapTotal:=CapDiv;
      //
      // DivProg.INIT;
      // DivProg."Member No":="Member No";
      // DivProg.Date:=ToDate;
      // DivProg."Gross Dividends":=CDiv;
      // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
      // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(6/12);
      // DivProg.Shares:=Cust."Current Shares"*-1;
      // DivProg."Share Capital":=Cust."Shares Retained"*-1;
      // DivProg."Gross  Share cap Dividend":=CapDiv;
      // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(6/12);
      // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
      // DivProg.Period:=RunningPeriod;
      // DivProg.INSERT
      //
      // END;
      // //END;
      //
      //
      //
      //
      //
      // //8
      // FromDate:=CALCDATE('7M',StartDate);
      // ToDate:=CALCDATE('-1D',CALCDATE('8M',StartDate));
      // EVALUATE(FromDateS,FORMAT(FromDate));
      // EVALUATE(ToDateS,FORMAT(ToDate));
      //
      // DateFilter:=FromDateS+'..'+ToDateS;
      // Cust.RESET;
      // Cust.SETRANGE(Cust."No.","Member No");
      // Cust.SETFILTER(Cust."Date Filter",DateFilter);
      // IF Cust.FIND('-') THEN BEGIN
      // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
      // //IF Cust."Current Shares" <> 0 THEN BEGIN
      //
      //
      // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(5/12);
      // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(5/12);
      //
      // DivTotal:=CDiv;
      // DivCapTotal:=CapDiv;
      //
      // DivProg.INIT;
      // DivProg."Member No":="Member No";
      // DivProg.Date:=ToDate;
      // DivProg."Gross Dividends":=CDiv;
      // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
      // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(5/12);
      // DivProg.Shares:=Cust."Current Shares"*-1;
      // DivProg."Share Capital":=Cust."Shares Retained"*-1;
      // DivProg."Gross  Share cap Dividend":=CapDiv;
      // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(5/12);
      // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
      // DivProg.Period:=RunningPeriod;
      // DivProg.INSERT
      //
      // END;
      // //END;
      //
      //
      //
      //
      //
      // //9
      // FromDate:=CALCDATE('8M',StartDate);
      // ToDate:=CALCDATE('-1D',CALCDATE('9M',StartDate));
      // EVALUATE(FromDateS,FORMAT(FromDate));
      // EVALUATE(ToDateS,FORMAT(ToDate));
      //
      // DateFilter:=FromDateS+'..'+ToDateS;
      // Cust.RESET;
      // Cust.SETRANGE(Cust."No.","Member No");
      // Cust.SETFILTER(Cust."Date Filter",DateFilter);
      // IF Cust.FIND('-') THEN BEGIN
      // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
      // //IF Cust."Current Shares" <> 0 THEN BEGIN
      //
      //
      // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(4/12);
      // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(4/12);
      //
      // DivTotal:=CDiv;
      // DivCapTotal:=CapDiv;
      //
      // DivProg.INIT;
      // DivProg."Member No":="Member No";
      // DivProg.Date:=ToDate;
      // DivProg."Gross Dividends":=CDiv;
      // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
      // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(4/12);
      // DivProg.Shares:=Cust."Current Shares"*-1;
      // DivProg."Share Capital":=Cust."Shares Retained"*-1;
      // DivProg."Gross  Share cap Dividend":=CapDiv;
      // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(4/12);
      // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
      // DivProg.Period:=RunningPeriod;
      // DivProg.INSERT
      // END;
      // //END;
      //
      //
      //
      //
      //
      // //10
      // FromDate:=CALCDATE('9M',StartDate);
      // ToDate:=CALCDATE('-1D',CALCDATE('10M',StartDate));
      // EVALUATE(FromDateS,FORMAT(FromDate));
      // EVALUATE(ToDateS,FORMAT(ToDate));
      //
      // DateFilter:=FromDateS+'..'+ToDateS;
      // Cust.RESET;
      // Cust.SETRANGE(Cust."No.","Member No");
      // Cust.SETFILTER(Cust."Date Filter",DateFilter);
      // IF Cust.FIND('-') THEN BEGIN
      // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
      // //IF Cust."Current Shares" <> 0 THEN BEGIN
      //
      //
      // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(3/12);
      // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(3/12);
      //
      // DivTotal:=CDiv;
      // DivCapTotal:=CapDiv;
      //
      // DivProg.INIT;
      // DivProg."Member No":="Member No";
      // DivProg.Date:=ToDate;
      // DivProg."Gross Dividends":=CDiv;
      // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
      // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(3/12);
      // DivProg.Shares:=Cust."Current Shares"*-1;
      // DivProg."Share Capital":=Cust."Shares Retained"*-1;
      // DivProg."Gross  Share cap Dividend":=CapDiv;
      // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(3/12);
      // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
      // DivProg.Period:=RunningPeriod;
      // DivProg.INSERT
      // END;
      // //END;
      //
      //
      //
      //
      //
      // //11
      // FromDate:=CALCDATE('10M',StartDate);
      // ToDate:=CALCDATE('-1D',CALCDATE('11M',StartDate));
      // EVALUATE(FromDateS,FORMAT(FromDate));
      // EVALUATE(ToDateS,FORMAT(ToDate));
      //
      // DateFilter:=FromDateS+'..'+ToDateS;
      // Cust.RESET;
      // Cust.SETRANGE(Cust."No.","Member No");
      // Cust.SETFILTER(Cust."Date Filter",DateFilter);
      // IF Cust.FIND('-') THEN BEGIN
      // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
      // //IF Cust."Current Shares" <> 0 THEN BEGIN
      //
      //
      // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(2/12);
      // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(2/12);
      //
      // DivTotal:=CDiv;
      // DivCapTotal:=CapDiv;
      //
      // DivProg.INIT;
      // DivProg."Member No":="Member No";
      // DivProg.Date:=ToDate;
      // DivProg."Gross Dividends":=CDiv;
      // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
      // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(2/12);
      // DivProg.Shares:=Cust."Current Shares"*-1;
      // DivProg."Share Capital":=Cust."Shares Retained"*-1;
      // DivProg."Gross  Share cap Dividend":=CapDiv;
      // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(2/12);
      // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
      // DivProg.Period:=RunningPeriod;
      // DivProg.INSERT
      // END;
      // //END;
      //
      //
      //
      //
      //
      // //12
      // FromDate:=CALCDATE('11M',StartDate);
      // ToDate:=CALCDATE('-1D',CALCDATE('12M',StartDate));
      // EVALUATE(FromDateS,FORMAT(FromDate));
      // EVALUATE(ToDateS,FORMAT(ToDate));
      //
      // DateFilter:=FromDateS+'..'+ToDateS;
      // Cust.RESET;
      // Cust.SETRANGE(Cust."No.","Member No");
      // Cust.SETFILTER(Cust."Date Filter",DateFilter);
      // IF Cust.FIND('-') THEN BEGIN
      // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
      // //IF Cust."Current Shares" <> 0 THEN BEGIN
      //
      //
      // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(1/12);
      // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(1/12);
      //
      // DivTotal:=CDiv;
      // DivCapTotal:=CapDiv;
      //
      // DivProg.INIT;
      // DivProg."Member No":="Member No";
      // DivProg.Date:=ToDate;
      // DivProg."Gross Dividends":=CDiv;
      // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
      // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(1/12);
      // DivProg.Shares:=Cust."Current Shares"*-1;
      // DivProg."Share Capital":=Cust."Shares Retained"*-1;
      // DivProg."Gross  Share cap Dividend":=CapDiv;
      // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(1/12);
      // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
      // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
      // DivProg.Period:=RunningPeriod;
      // DivProg.INSERT
      // END;
    END;

    PROCEDURE FnLoanfo@17(MemberNo@1000 : Code[20]) dividend : Text;
    BEGIN
      //  DivProg.RESET;
      //  DivProg.SETRANGE("Member No",MemberNo);
      //  IF DivProg.FIND('-') THEN BEGIN
      //   REPEAT
      //     dividend:=dividend+FORMAT(DivProg.Date)+':::'+FORMAT(DivProg."Gross Dividends")+':::'+FORMAT(DivProg."Witholding Tax")+':::'+FORMAT(DivProg."Net Dividends")+':::'+FORMAT(DivProg."Qualifying Shares")+':::'
      //     +FORMAT(DivProg.Shares)+'::::';
      //     UNTIL DivProg.NEXT=0;
      //     END;
    END;

    PROCEDURE fnFundsTransfer@15(Acountfrom@1000 : Code[20];AccountTo@1001 : Code[20];Amount@1002 : Decimal;DocNo@1003 : Code[20]) result : Text;
    BEGIN
      result:=CloudPesaLive.FundsTransferFOSA(Acountfrom, AccountTo, DocNo, Amount);
    END;

    PROCEDURE fnGetFosaAccounts@22(BosaNo@1000 : Code[20]) fosas : Text;
    BEGIN
      Vendor.RESET;
      Vendor.SETRANGE("ID No.", BosaNo);
      IF Vendor.FIND('-') THEN BEGIN
        REPEAT
        fosas:=fosas+ Vendor."No."+'>'+':::'+Vendor."Account Type"+'>'+':::';
          UNTIL Vendor.NEXT=0;
        END;
    END;

    PROCEDURE fnGetFosaAccount@1120054026(BosaNo@1000 : Code[20]) fosas : Text;
    BEGIN
      Vendor.RESET;
      Vendor.SETRANGE("ID No.", BosaNo);
      IF Vendor.FIND('-') THEN BEGIN
        REPEAT
       fosas := fosas + Vendor."No." + '.' + Vendor."Account Type" + ':::';
          UNTIL Vendor.NEXT=0;
        END;
    END;

    PROCEDURE fnGetBosaAccounts@1120054010(BosaNo@1000 : Code[20]) fosas : Text;
    BEGIN
      {objMember.RESET;
      objMember.SETRANGE(objMember."No.", BosaNo);
      IF objMember.FIND('-') THEN BEGIN
        REPEAT
        fosas:=fosas+ objMember."No."+'>'+':::'+Vendor."Account Type"+'>'+'::::';
          UNTIL Vendor.NEXT=0;
        END;}
    END;

    PROCEDURE FnGetAtms@18(idnumber@1000 : Code[20]) return : Text;
    BEGIN
      objAtmapplication.RESET;
      objAtmapplication.SETRANGE("Address 5", idnumber);
      IF objAtmapplication.FIND('-') THEN BEGIN
        REPEAT
          return:=objAtmapplication."Account No"+':::'+FORMAT(objAtmapplication."Request Type")+':::'+FORMAT(objAtmapplication."Time Captured")+':::'+FORMAT(objAtmapplication."Date Issued")+'::::'+return;
          UNTIL
          objAtmapplication.NEXT=0;
          END;
    END;

    PROCEDURE fnTransferAuthenticate@1000000019(MemberNo@1000000000 : Code[20];Code@1000000001 : Code[20]) return : Boolean;
    BEGIN
      PortaLuPS.INIT;
      PortaLuPS.RESET;
      PortaLuPS.SETRANGE(PortaLuPS.Mno, MemberNo );
      PortaLuPS.SETRANGE(PortaLuPS.Code, Code);
      IF PortaLuPS.FIND('-') THEN BEGIN
        return:=TRUE;
        PortaLuPS.DELETEALL;
        END
        ELSE
        return:=FALSE;

    END;

    PROCEDURE FnInsertcode@1000000020(MemberNumber@1000000000 : Code[20];Code@1000000001 : Code[20];Accountto@1000000002 : Code[20]);
    BEGIN
      PortaLuPS.RESET;
      PortaLuPS.INIT;
      PortaLuPS.Mno:=MemberNumber;
      PortaLuPS.Code:=Code;
      PortaLuPS.INSERT;
      objMember.RESET;
      objMember.SETRANGE(objMember."No.", MemberNumber);
      IF objMember.FIND('-') THEN BEGIN
        FnSMSMessage(objMember."FOSA Account", objMember."Mobile Phone No", 'Your secret code for Telepost sacco funds transfer is '+Code
        + 'Insert this in your portal to authirize funds transfer you will receive a message if the transaction was succesful');
        END;
    END;

    PROCEDURE fnAccountBalancesReport@1000000021(MemberNo@1000000002 : Code[50];filter@1000000001 : Text;VAR BigText@1000000000 : BigText);
    VAR
      Filename@1000000011 : Text[100];
      Convert@1000000010 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
      Path@1000000009 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Path";
      _File@1000000008 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.File";
      FileAccess@1000000007 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileAccess";
      FileMode@1000000006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
      MemoryStream@1000000005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
      FileStream@1000000004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileStream";
      Outputstream@1000000003 : OutStream;
    BEGIN

        Vendor.RESET;
        Vendor.SETRANGE(Vendor."BOSA Account No" ,MemberNo);


      IF Vendor.FIND('-') THEN BEGIN
      //  objMember.SETFILTER("Date Filter", filter);
      Filename:=Path.GetTempPath()+Path.GetRandomFileName();
      REPORT.SAVEASPDF(51516277,Filename, Vendor);

       FileMode:=4;
       FileAccess:=1;

       FileStream:=_File.Open(Filename,FileMode,FileAccess);

       MemoryStream:=MemoryStream.MemoryStream();

       MemoryStream.SetLength(FileStream.Length);
       FileStream.Read(MemoryStream.GetBuffer(),0,FileStream.Length);

       BigText.ADDTEXT((Convert.ToBase64String(MemoryStream.GetBuffer())));
       MESSAGE(FORMAT(BigText));
      // exitString:=BigText;
      //MESSAGE(exitString);
      MemoryStream.Close();
      MemoryStream.Dispose();
      FileStream.Close();
      FileStream.Dispose();
      _File.Delete(Filename);

      END;
    END;

    LOCAL PROCEDURE fnLoanCalcFromrepayment@1000000029();
    BEGIN
    END;

    PROCEDURE FnLoanApplication_Portal@1120054000(Member@1120054000 : Code[50];Amount@1120054001 : Decimal;Period@1120054002 : Integer;LoanType@1120054003 : Code[50]) EntryNo : Integer;
    BEGIN
      Loansetup.RESET;
      Loansetup.SETRANGE(Loansetup.Code, LoanType);
      IF Loansetup.FIND('-') THEN BEGIN

        IF Amount> Loansetup."Max. Loan Amount" THEN
         // ERROR('You cannot apply more than the maximum loan amount')
          MESSAGE('');
       // ELSE
        IF Period>Loansetup."Default Installements" THEN
        ERROR('Recommended Loan period for this loan is '+FORMAT( Loansetup."Default Installements")+ ' please apply use the recommended installments or below');
      Loans_Portal.INIT;
      Loans_Portal.CLientCode:=Member;
      Loans_Portal.AppliedAmount:=Amount;
      Loans_Portal.IntrestRate:=Loansetup."Interest rate";
      Loans_Portal."Repayment Frequency":=Loansetup."Repayment Frequency";
      Loans_Portal.Installments:=Period;
      Loans_Portal.LoanType:=LoanType;
      Loans_Portal.VALIDATE(LoanType);
      Loans_Portal.INSERT;
      END;
      //Loans_Portal.RESET; Loans_Portal.SETRANGE()
    END;

    PROCEDURE FnLoanGuarantor_Add@1120054005(MemberNumber@1120054000 : Code[60];MemberName@1120054001 : Code[100];LoanNo@1120054002 : Integer);
    BEGIN
      PortalGuarantors.INIT;
      PortalGuarantors.MemberNo:=MemberNumber;
      PortalGuarantors.Amount:=Amount;
      PortalGuarantors.LoanNO:=LoanNo;
      PortalGuarantors.INSERT;
    END;

    PROCEDURE FnLoanGuarantors_Requests@1120054006(Loanno@1120054000 : Integer;MemberNumber@1120054001 : Code[50];Response@1120054002 : Boolean;Amount@1120054003 : Decimal);
    BEGIN
      PortalGuarantors.INIT;
      PortalGuarantors.SETRANGE(PortalGuarantors.LoanNO, Loanno);
      PortalGuarantors.SETRANGE(PortalGuarantors.MemberNo, MemberNumber);
      IF PortalGuarantors.FIND('-') THEN BEGIN
        IF Amount=0 THEN BEGIN
          IF Response=FALSE THEN

        PortalGuarantors.Response:=FALSE;
       // PortalGuarantors.AmountGuaranteed:=Amount;
        PortalGuarantors.MODIFY;
        END;
        IF Amount>0 THEN BEGIN
          IF Response=FALSE THEN
            ERROR('You cannot reject a guarantee with amount please remove the amount you guaranteed and press reject')
          ELSE
              PortalGuarantors.Response:=TRUE;
        PortalGuarantors.AmountGuaranteed:=Amount;
        PortalGuarantors.MODIFY;
        END;
        END;
    END;

    LOCAL PROCEDURE FnGetLoans@1120054008(MemberNumber@1120054000 : Integer) EntryNO : Integer;
    BEGIN
      //Loans_Portal.SETRANGE()
    END;

    PROCEDURE fnLoanGurantorsReport@1120054001(MemberNo@1002 : Code[50];filter@1120054000 : Text;VAR BigText@1000 : BigText);
    VAR
      Filename@1011 : Text[100];
      Convert@1010 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
      Path@1009 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Path";
      _File@1008 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.File";
      FileAccess@1007 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileAccess";
      FileMode@1006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
      MemoryStream@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
      FileStream@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileStream";
      Outputstream@1003 : OutStream;
    BEGIN

        objMember.RESET;
        objMember.SETRANGE(objMember."No.",MemberNo);


      IF objMember.FIND('-') THEN BEGIN
      //  objMember.SETFILTER("Date Filter", filter);
      Filename:=Path.GetTempPath()+Path.GetRandomFileName();
      REPORT.SAVEASPDF(51516225,Filename, objMember);

       FileMode:=4;
       FileAccess:=1;

       FileStream:=_File.Open(Filename,FileMode,FileAccess);

       MemoryStream:=MemoryStream.MemoryStream();

       MemoryStream.SetLength(FileStream.Length);
       FileStream.Read(MemoryStream.GetBuffer(),0,FileStream.Length);

       BigText.ADDTEXT((Convert.ToBase64String(MemoryStream.GetBuffer())));
       MESSAGE(FORMAT(BigText));
      // exitString:=BigText;
      //MESSAGE(exitString);
      MemoryStream.Close();
      MemoryStream.Dispose();
      FileStream.Close();
      FileStream.Dispose();
      _File.Delete(Filename);

      END;
    END;

    PROCEDURE MemberPhoto@1120054016(No@1120054000 : Code[50];VAR PictureText@1120054001 : BigText);
    VAR
      PictureInStream@1120054002 : InStream;
      PictureOutStream@1120054003 : OutStream;
      TempBlob@1120054004 : Record 99008535;
    BEGIN
      objMember.RESET;
      objMember.SETRANGE("No.", No);
      IF objMember.FIND('-') THEN BEGIN
        objMember.CALCFIELDS(Picture);
        IF objMember.Picture.HASVALUE THEN BEGIN
        //  PictureText.ADDTEXT(HREmployees
          CLEAR(PictureText);
          CLEAR(PictureInStream);
          objMember.Picture.CREATEINSTREAM(PictureInStream);
          TempBlob.DELETEALL;
          TempBlob.INIT;
          TempBlob.Blob.CREATEOUTSTREAM(PictureOutStream);
          COPYSTREAM(PictureOutStream, PictureInStream);
          TempBlob.INSERT;
          TempBlob.CALCFIELDS(Blob);
          PictureText.ADDTEXT(TempBlob.ToBase64String);
          END;
          END;
    END;

    BEGIN
    END.
  }
}

