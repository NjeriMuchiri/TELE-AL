OBJECT CodeUnit 20406 User Setup Management BR
{
  OBJECT-PROPERTIES
  {
    Date=09/07/15;
    Time=[ 1:57:34 PM];
    Modified=Yes;
    Version List=BOSA ManagementV1.0(Surestep Systems);
  }
  PROPERTIES
  {
    Permissions=TableData 14=r,
                TableData 5714=r;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'ENU=customer';
      Text001@1001 : TextConst 'ENU=vendor';
      Text002@1002 : TextConst 'ENU=This %1 is related to %2 %3. Your identification is setup to process from %2 %4.';
      Text003@1003 : TextConst 'ENU=This document will be processed in your %2.';
      UserSetup@1004 : Record 91;
      RespCenter@1005 : Record 50112;
      CompanyInfo@1006 : Record 79;
      UserLocation@1008 : Code[10];
      UserRespCenter@1014 : Code[10];
      SalesUserRespCenter@1013 : Code[10];
      PurchUserRespCenter@1012 : Code[10];
      ServUserRespCenter@1007 : Code[10];
      HasGotSalesUserSetup@1009 : Boolean;
      HasGotPurchUserSetup@1010 : Boolean;
      HasGotServUserSetup@1011 : Boolean;
      DimensionVal@1102755000 : Code[20];

    PROCEDURE GetSalesFilter@1() : Code[10];
    BEGIN
      EXIT(GetSalesFilter2(USERID));
    END;

    PROCEDURE GetPurchasesFilter@3() : Code[10];
    BEGIN
      EXIT(GetPurchasesFilter2(USERID));
    END;

    PROCEDURE GetServiceFilter@5() : Code[10];
    BEGIN
      EXIT(GetServiceFilter2(USERID));
    END;

    PROCEDURE GetSalesFilter2@6(UserCode@1000 : Code[20]) : Code[10];
    BEGIN
      IF NOT HasGotSalesUserSetup THEN BEGIN
        CompanyInfo.GET;
        SalesUserRespCenter := CompanyInfo."Responsibility Center";
        UserLocation := CompanyInfo."Location Code";
        IF (UserSetup.GET(UserCode)) AND (UserCode <> '') THEN
          IF UserSetup."Sales Resp. Ctr. Filter" <> '' THEN
            SalesUserRespCenter := UserSetup."Sales Resp. Ctr. Filter";
        HasGotSalesUserSetup := TRUE;
      END;
      EXIT(SalesUserRespCenter);
    END;

    PROCEDURE GetPurchasesFilter2@13(UserCode@1000 : Code[20]) : Code[10];
    BEGIN
      IF NOT HasGotPurchUserSetup THEN BEGIN
        CompanyInfo.GET;
        PurchUserRespCenter := CompanyInfo."Responsibility Center";
        UserLocation := CompanyInfo."Location Code";
        IF (UserSetup.GET(UserCode)) AND (UserCode <> '') THEN
          IF UserSetup."Purchase Resp. Ctr. Filter" <> '' THEN
            PurchUserRespCenter := UserSetup."Purchase Resp. Ctr. Filter";
        HasGotPurchUserSetup := TRUE;
      END;
      EXIT(PurchUserRespCenter);
    END;

    PROCEDURE GetServiceFilter2@17(UserCode@1000 : Code[20]) : Code[10];
    BEGIN
      IF NOT HasGotServUserSetup THEN BEGIN
        CompanyInfo.GET;
        ServUserRespCenter := CompanyInfo."Responsibility Center";
        UserLocation := CompanyInfo."Location Code";
        IF (UserSetup.GET(UserCode)) AND (UserCode <> '') THEN
          IF UserSetup."Service Resp. Ctr. Filter" <> '' THEN
            ServUserRespCenter := UserSetup."Service Resp. Ctr. Filter";
        HasGotServUserSetup := TRUE;
      END;
      EXIT(ServUserRespCenter);
    END;

    PROCEDURE GetRespCenter@2(DocType@1000 : 'Sales,Purchase,Service';AccRespCenter@1001 : Code[20]) : Code[10];
    VAR
      AccType@1002 : Text[50];
    BEGIN
      CASE DocType OF
        DocType::Sales:
          BEGIN
            AccType := Text000;
            UserRespCenter := GetSalesFilter;
          END;
        DocType::Purchase:
          BEGIN
            AccType := Text001;
            UserRespCenter := GetPurchasesFilter;
          END;
        DocType::Service:
          BEGIN
            AccType := Text000;
            UserRespCenter := GetServiceFilter;
          END;
      END;
      IF (AccRespCenter <> '') AND
         (UserRespCenter <> '') AND
         (AccRespCenter <> UserRespCenter)
      THEN
        MESSAGE(
          Text002 +
          Text003,
          AccType,RespCenter.TABLECAPTION,AccRespCenter,UserRespCenter);
      IF UserRespCenter = '' THEN
        EXIT(AccRespCenter)
      ELSE
        EXIT(UserRespCenter);
    END;

    PROCEDURE CheckRespCenter@4(DocType@1000 : 'Sales,Purchase,Service';AccRespCenter@1001 : Code[20]) : Boolean;
    BEGIN
      EXIT(CheckRespCenter2(DocType,AccRespCenter,USERID));
    END;

    PROCEDURE CheckRespCenter2@7(DocType@1000 : 'Sales,Purchase,Service';AccRespCenter@1001 : Code[20];UserCode@1002 : Code[20]) : Boolean;
    BEGIN
      CASE DocType OF
        DocType::Sales: UserRespCenter := GetSalesFilter2(UserCode);
        DocType::Purchase: UserRespCenter := GetPurchasesFilter2(UserCode);
        DocType::Service: UserRespCenter := GetServiceFilter2(UserCode);
      END;
      IF (UserRespCenter <> '') AND
         (AccRespCenter <> UserRespCenter)
      THEN
        EXIT(FALSE)
      ELSE
        EXIT(TRUE);
    END;

    PROCEDURE GetLocation@46(DocType@1000 : 'Sales,Purchase,Service';AccLocation@1001 : Code[20];RespCenterCode@1002 : Code[20]) : Code[10];
    BEGIN
      CASE DocType OF
        DocType::Sales: UserRespCenter := GetSalesFilter;
        DocType::Purchase: UserRespCenter := GetPurchasesFilter;
        DocType::Service: UserRespCenter := GetServiceFilter;
      END;
      IF UserRespCenter <> '' THEN
        RespCenterCode := UserRespCenter;
      IF RespCenter.GET(RespCenterCode) THEN
        IF RespCenter."Location Code" <> '' THEN
          UserLocation := RespCenter."Location Code";
      IF AccLocation <> '' THEN
        EXIT(AccLocation)
      ELSE
        EXIT(UserLocation);
    END;

    PROCEDURE GetSetDimensions@1102755000(UserCode@1000 : Code[20];DimensionNo@1102755000 : Integer) : Code[10];
    BEGIN
        DimensionVal:='';
         CASE DimensionNo OF
         1:
         BEGIN
         IF (UserSetup.GET(UserCode)) AND (UserCode <> '') THEN
          IF UserSetup."Global Dimension 1 Code" <> '' THEN
            DimensionVal := UserSetup."Global Dimension 1 Code";
         EXIT(DimensionVal);
         END;
         2:
         BEGIN
         IF (UserSetup.GET(UserCode)) AND (UserCode <> '') THEN
          IF UserSetup."Shortcut Dimension 2 Code" <> '' THEN
            DimensionVal := UserSetup."Shortcut Dimension 2 Code";
         EXIT(DimensionVal);
         END;
         3:
         BEGIN
         IF (UserSetup.GET(UserCode)) AND (UserCode <> '') THEN
          IF UserSetup."Shortcut Dimension 3 Code" <> '' THEN
            DimensionVal := UserSetup."Shortcut Dimension 3 Code";
         EXIT(DimensionVal);
         END;
         4:
         BEGIN
         IF (UserSetup.GET(UserCode)) AND (UserCode <> '') THEN
          IF UserSetup."Shortcut Dimension 4 Code" <> '' THEN
            DimensionVal := UserSetup."Shortcut Dimension 4 Code";
         EXIT(DimensionVal);
         END;
        END;
    END;

    BEGIN
    END.
  }
}

