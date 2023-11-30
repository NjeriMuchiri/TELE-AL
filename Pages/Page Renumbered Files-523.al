OBJECT page 172118 CRBA List 2
{
  OBJECT-PROPERTIES
  {
    Date=04/03/20;
    Time=[ 1:37:17 PM];
    Modified=Yes;
    Version List=CRB;
  }
  PROPERTIES
  {
    Editable=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table51516456;
    SourceTableView=WHERE(No of Days in Arreas=FILTER(>0));
    PageType=List;
    OnAfterGetRecord=BEGIN
                       Gender2:='';
                       Marital2:='';
                       workString := CONVERTSTR(Name,' ',',');
                       {
                       IF SELECTSTR(1,workString)<>'' THEN
                       Forename1:= SELECTSTR(1,workString);
                       workString:=DELCHR(workString,'=',Forename1);
                       IF STRLEN(workString)>1 THEN BEGIN
                         IF SELECTSTR(2,workString)<>'' THEN
                         Forename2:= SELECTSTR(2,workString);
                       END;
                       workString:=DELCHR(workString,'=',Forename2);
                       IF STRLEN(workString)>2 THEN BEGIN
                         IF SELECTSTR(3,workString)<>'' THEN
                         Surname := SELECTSTR(3,workString);
                         //Forename3:= SELECTSTR(4,workString);
                         END;}
                           Surname := '';
                           Forename1 :='';
                           Forename2 :='';
                           Forename3 :='';
                           "Outstanding Interest":=0;
                           "Outstanding Principal":=0;
                         Sourcestring:=workString;
                         Separator:=',';
                         TempArray:=Sourcestring.Split(Separator.ToCharArray());
                         IF TempArray.Length>0 THEN
                         Forename1 := TempArray.GetValue(0);
                         IF TempArray.Length>1 THEN
                         Forename2 := TempArray.GetValue(1);
                         IF TempArray.Length>2 THEN
                         Surname := TempArray.GetValue(2);
                         IF TempArray.Length>3 THEN
                         Forename3 := TempArray.GetValue(3);

                       IF Gender=Gender::Male THEN BEGIN
                       Salutation:='MR.';
                       Gender2:='M';
                       END;
                       IF Gender=Gender::Female THEN BEGIN
                       Salutation:='MRS.';
                       Gender2:='F';
                       END;
                       IF "Marital Status"="Marital Status"::Married THEN
                       Marital2:='M';
                       IF "Marital Status"="Marital Status"::Single THEN
                       Marital2:='S';

                       "Primary Identification Doc Type":='001';

                       IF LoansRegister.GET("Account Number") THEN BEGIN
                       LoansRegister.CALCFIELDS(LoansRegister."Outstanding Loan");
                       LoansRegister.CALCFIELDS(LoansRegister."Oustanding Interest");
                       "Outstanding Principal":=LoansRegister."Outstanding Loan";
                       "Outstanding Interest":=LoansRegister."Oustanding Interest";
                       LastPDate:='';
                       month:='';
                       day:='';
                       MemberLedgerEntry.RESET;
                       MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Loan No",LoansRegister."Loan  No.");
                       MemberLedgerEntry.SETRANGE(MemberLedgerEntry."Transaction Type",MemberLedgerEntry."Transaction Type"::Repayment);
                       IF MemberLedgerEntry.FINDLAST THEN BEGIN
                       Lastpamount:=-1*MemberLedgerEntry.Amount;
                       Lastpaydate:=MemberLedgerEntry."Posting Date";
                       month:=FORMAT(DATE2DMY(Lastpaydate,2));
                       IF STRLEN(month)<2 THEN BEGIN
                       month:='0'+month;
                       END;
                       day:=FORMAT(DATE2DMY(Lastpaydate,1));
                       IF STRLEN(day)<2 THEN BEGIN
                       day:='0'+day;
                       END;
                       LastPDate:=FORMAT(DATE2DMY(Lastpaydate,3))+month+day;
                       END;
                       END;
                       Deposits:=0;
                       IF MembersRegister.GET("Client Code") THEN BEGIN
                       MembersRegister.CALCFIELDS(MembersRegister."Current Shares");
                       Deposits:=MembersRegister."Current Shares";
                       END;
                     END;

  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1000000002;2;Field  ;
                SourceExpr=No;
                Visible=false }

    { 1120054000;2;Field  ;
                CaptionML=ENU=Surname;
                SourceExpr=Surname }

    { 1120054001;2;Field  ;
                CaptionML=ENU=Forename 1;
                SourceExpr=Forename1 }

    { 1000000003;2;Field  ;
                CaptionML=ENU=Forename 2;
                SourceExpr=Forename2 }

    { 1120054002;2;Field  ;
                CaptionML=ENU=Forename 3;
                SourceExpr=Forename3 }

    { 1120054003;2;Field  ;
                SourceExpr=Name;
                Visible=false }

    { 1120054027;2;Field  ;
                SourceExpr="Trading as" }

    { 1000000050;2;Field  ;
                SourceExpr=Salutation }

    { 1000000004;2;Field  ;
                SourceExpr="Date of Birth" }

    { 1000000005;2;Field  ;
                CaptionML=ENU=Client No;
                SourceExpr="Client Code" }

    { 1000000006;2;Field  ;
                SourceExpr="Account Number" }

    { 1120054028;2;Field  ;
                SourceExpr="Old Account Number" }

    { 1000000007;2;Field  ;
                CaptionML=ENU=Gender;
                SourceExpr=Gender2 }

    { 1000000008;2;Field  ;
                SourceExpr=Nationality }

    { 1000000009;2;Field  ;
                CaptionML=ENU=Marital Status;
                SourceExpr=Marital2 }

    { 1120054004;2;Field  ;
                CaptionML=ENU=Primary Identification Doc Type;
                SourceExpr="Primary Identification Doc Type" }

    { 1000000010;2;Field  ;
                CaptionML=ENU=Primary Identification Doc No;
                SourceExpr="Primary Identification 1" }

    { 1000000011;2;Field  ;
                CaptionML=ENU=Secondary Identification Doc Type;
                SourceExpr="Secondary Identification Doc Type" }

    { 1120054005;2;Field  ;
                CaptionML=ENU=Secondary Identification Doc No;
                SourceExpr="Secondary Identification Doc No" }

    { 1120054006;2;Field  ;
                CaptionML=ENU=Other Identification Doc Type;
                SourceExpr="Other Identification Doc Type" }

    { 1120054007;2;Field  ;
                CaptionML=ENU=Other Identification Doc No;
                SourceExpr="Other Identification Doc No" }

    { 1120054029;2;Field  ;
                SourceExpr="Passport Country Code" }

    { 1000000012;2;Field  ;
                SourceExpr="Mobile No" }

    { 1000000013;2;Field  ;
                Name=<Home Telephone>;
                CaptionML=ENU=Home Telephone No;
                SourceExpr="Work Telephone" }

    { 1120054008;2;Field  ;
                CaptionML=ENU=Work Telephone No;
                SourceExpr="Work Telephone" }

    { 1000000014;2;Field  ;
                SourceExpr="Postal Address 1" }

    { 1000000015;2;Field  ;
                SourceExpr="Postal Address 2" }

    { 1000000016;2;Field  ;
                SourceExpr="Postal Location Town" }

    { 1000000017;2;Field  ;
                SourceExpr="Postal Location Country" }

    { 1000000018;2;Field  ;
                SourceExpr="Post Code" }

    { 1000000019;2;Field  ;
                SourceExpr="Physical Address 1" }

    { 1000000020;2;Field  ;
                SourceExpr="Physical Address 2" }

    { 1120054009;2;Field  ;
                CaptionML=ENU=Plot No;
                SourceExpr=PLot }

    { 1000000021;2;Field  ;
                SourceExpr="Location Town" }

    { 1000000022;2;Field  ;
                SourceExpr="Location Country" }

    { 1120054030;2;Field  ;
                SourceExpr="Type of Residency" }

    { 1000000023;2;Field  ;
                SourceExpr="Date of Physical Address" }

    { 1120054010;2;Field  ;
                CaptionML=ENU=Pin No;
                SourceExpr=Pin }

    { 1000000024;2;Field  ;
                SourceExpr="Customer Work Email" }

    { 1000000025;2;Field  ;
                SourceExpr="Employer Name" }

    { 1120054031;2;Field  ;
                SourceExpr="Occupational Industry Type" }

    { 1120054012;2;Field  ;
                SourceExpr="Employer Industry Type" }

    { 1120054011;2;Field  ;
                CaptionML=ENU=Employment Date;
                SourceExpr=EmploymentDate }

    { 1000000026;2;Field  ;
                SourceExpr="Employment Type" }

    { 1000000058;2;Field  ;
                SourceExpr="Salary Band" }

    { 1120054016;2;Field  ;
                SourceExpr="Lenders Registered Name" }

    { 1120054015;2;Field  ;
                SourceExpr="Lenders Trading Name" }

    { 1120054014;2;Field  ;
                SourceExpr="Lenders Branch Name" }

    { 1120054013;2;Field  ;
                SourceExpr="Lenders Branch Code" }

    { 1000000027;2;Field  ;
                SourceExpr="Account Type" }

    { 1000000028;2;Field  ;
                SourceExpr="Account Product Type" }

    { 1120054026;2;Field  ;
                CaptionML=ENU=Date Account Opened;
                SourceExpr="Account Opened Date" }

    { 1000000029;2;Field  ;
                SourceExpr="Date Account Opened";
                Visible=false }

    { 1000000030;2;Field  ;
                SourceExpr="Installment Due Date" }

    { 1000000031;2;Field  ;
                SourceExpr="Original Amount" }

    { 1000000032;2;Field  ;
                SourceExpr="Currency of Facility" }

    { 1000000033;2;Field  ;
                SourceExpr="Amonut in Kenya shillings" }

    { 1000000034;2;Field  ;
                SourceExpr="Current Balance";
                Visible=true }

    { 1120054023;2;Field  ;
                CaptionML=ENU=Current Balance;
                SourceExpr="Outstanding Principal";
                Visible=false }

    { 1000000035;2;Field  ;
                SourceExpr="Overdue Balance" }

    { 1000000069;2;Field  ;
                SourceExpr="Overdue Date" }

    { 1000000036;2;Field  ;
                SourceExpr="No of Days in Arreas" }

    { 1000000037;2;Field  ;
                SourceExpr="No of Installment In" }

    { 1000000038;2;Field  ;
                SourceExpr="Performing / NPL Indicator" }

    { 1000000039;2;Field  ;
                SourceExpr="Account Status" }

    { 1000000040;2;Field  ;
                SourceExpr="Account Status Date" }

    { 1120054017;2;Field  ;
                SourceExpr="Account Closure Reason" }

    { 1000000041;2;Field  ;
                SourceExpr="Repayment Period" }

    { 1120054019;2;Field  ;
                SourceExpr="Deferred Payment Date" }

    { 1120054018;2;Field  ;
                SourceExpr="Deferred Payment" }

    { 1000000042;2;Field  ;
                SourceExpr="Payment Frequency" }

    { 1000000043;2;Field  ;
                SourceExpr="Disbursement Date" }

    { 1120054032;2;Field  ;
                SourceExpr="Next paymentamount" }

    { 1000000044;2;Field  ;
                SourceExpr="Insallment Amount" }

    { 1000000045;2;Field  ;
                SourceExpr="Date of Latest Payment";
                Visible=false }

    { 1120054024;2;Field  ;
                CaptionML=ENU=Date of Latest Payment;
                SourceExpr=LastPDate }

    { 1000000046;2;Field  ;
                SourceExpr="Last Payment Amount";
                Visible=false }

    { 1120054025;2;Field  ;
                CaptionML=ENU=Last Payment Amount;
                SourceExpr=Lastpamount;
                Visible=false }

    { 1000000066;2;Field  ;
                SourceExpr="Type of Security" }

    { 1120054020;2;Field  ;
                Name=Curr Bal;
                CaptionML=ENU=Curr Bal;
                SourceExpr="Outstanding Principal";
                Visible=false }

    { 1120054021;2;Field  ;
                CaptionML=ENU=Outstanding Interest;
                SourceExpr="Outstanding Interest" }

    { 1120054022;2;Field  ;
                CaptionML=ENU=Deposits;
                SourceExpr=Deposits }

    { 1120054033;2;Field  ;
                SourceExpr="Group ID" }

  }
  CODE
  {
    VAR
      Forename1@1120054000 : Text[100];
      Forename2@1120054001 : Text[100];
      Surname@1120054002 : Text[100];
      workString@1120054003 : Text[100];
      Forename3@1120054004 : Text[100];
      Gender2@1120054005 : Code[10];
      Marital2@1120054006 : Code[10];
      Sourcestring@1120054007 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      TempArray@1120054008 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";
      Separator@1120054009 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      "Primary Identification Doc Type"@1120054010 : Code[100];
      "Secondary Identification Doc Type"@1120054011 : Code[100];
      "Secondary Identification Doc No"@1120054012 : Code[100];
      "Other Identification Doc Type"@1120054014 : Code[100];
      "Other Identification Doc No"@1120054013 : Code[100];
      PLot@1120054015 : Code[10];
      Pin@1120054016 : Code[10];
      EmploymentDate@1120054017 : Date;
      "Employer Industry Type"@1120054018 : Code[10];
      LoansRegister@1120054019 : Record 51516230;
      "Outstanding Principal"@1120054020 : Decimal;
      "Outstanding Interest"@1120054021 : Decimal;
      Deposits@1120054022 : Decimal;
      MembersRegister@1120054023 : Record 51516223;
      Lastpaydate@1120054024 : Date;
      MemberLedgerEntry@1120054025 : Record 51516224;
      LastPDate@1120054026 : Text;
      month@1120054027 : Text;
      day@1120054028 : Text;
      Lastpamount@1120054029 : Decimal;

    BEGIN
    END.
  }
}

