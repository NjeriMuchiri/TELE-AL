OBJECT CodeUnit 20365 Tax Calculation
{
  OBJECT-PROPERTIES
  {
    Date=07/21/17;
    Time=12:48:25 PM;
    Modified=Yes;
    Version List=Funds;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {

    PROCEDURE CalculateTax@1102756001(Rec@1102756000 : Record 51516113;CalculationType@1102756001 : 'VAT,W/Tax,Retention,VAT6') Amount : Decimal;
    BEGIN
      CASE CalculationType OF
        CalculationType::VAT:
          BEGIN
              Amount:=(Rec."VAT Rate"/(100+Rec."VAT Rate"))*Rec.Amount;
          END;
        CalculationType::"W/Tax":
          BEGIN
              Amount:=(Rec.Amount-((Rec."VAT Rate"/(100+Rec."VAT Rate"))*Rec.Amount))
              *(Rec."W/Tax Rate"/100);
          END;
        CalculationType::Retention:
          BEGIN
              Amount:=(Rec.Amount-((Rec."VAT Rate"/(100+Rec."VAT Rate"))*Rec.Amount))
               *(Rec."Retention Rate"/100);
          END;
        {  //Added for VAT 6% OF VAT
        CalculationType::VAT6:
          BEGIN
              Amount:=(Rec.Amount*Rec."VAT 6% Rate"/116);
          END;
          }
      END;
    END;

    PROCEDURE CalculatePurchTax@1102755000(Rec@1102756000 : Record 39;CalculationType@1102756001 : 'VAT,W/Tax,Retention') Amount : Decimal;
    BEGIN
      {
      CASE CalculationType OF
        CalculationType::VAT:
          BEGIN
              //Amount:=(Rec."VAT Rate"/(100+Rec."VAT Rate"))*Rec.Amount;
              Amount:=(Rec."VAT Rate"/(100+Rec."VAT Rate"))*Rec.Amount;
          END;
        CalculationType::"W/Tax":
          BEGIN
              //Amount:=(Rec.Amount-((Rec."VAT Rate"/(100+Rec."VAT Rate"))*Rec.Amount))
              //*(Rec."W/Tax Rate"/100);
              Amount:=(Rec.Amount*(Rec."W/Tax Rate"/(100+Rec."VAT Rate")));

          END;
        CalculationType::Retention:
          BEGIN
              Amount:=(Rec.Amount-((Rec."VAT Rate"/100)*Rec.Amount))
               *(Rec."Retention Rate"/100);
          END;
      END;
      }
    END;

    BEGIN
    END.
  }
}

