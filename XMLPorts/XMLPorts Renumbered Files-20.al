OBJECT XMLport 20384 Import Sacco Jnl
{
  OBJECT-PROPERTIES
  {
    Date=09/12/23;
    Time=[ 5:33:40 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
    Format=Variable Text;
  }
  ELEMENTS
  {
    { [{EA310BB0-2264-43A1-8D22-FF139F0AA8E4}];  ;root                ;Element ;Text     }

    { [{DB03FA6D-335B-41BD-A42A-2B1178DC08A6}];1 ;Paybill             ;Element ;Table   ;
                                                  SourceTable=Table81;
                                                  AutoUpdate=Yes;
                                                  AutoReplace=No }

    { [{D11B42AF-DEB7-4A8E-9489-41109EA87C5A}];2 ;C                   ;Element ;Field   ;
                                                  DataType=Integer;
                                                  SourceField=Gen. Journal Line::Line No. }

    { [{C349B9C0-9ADC-461B-A484-87E8882B5A0C}];2 ;A                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Gen. Journal Line::Journal Template Name }

    { [{91D7AA37-DCD5-4442-8A45-1D281FA6A719}];2 ;B                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Gen. Journal Line::Journal Batch Name }

    { [{2CCF538D-5395-4795-BABE-9490DC155916}];2 ;D                   ;Element ;Field   ;
                                                  DataType=Date;
                                                  SourceField=Gen. Journal Line::Posting Date }

    { [{4C1B06B3-F1BB-4F98-A2A4-3332B05C1FB9}];2 ;E                   ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Gen. Journal Line::Document No. }

    { [{646C51A7-BE1D-44FB-8E11-26EF93BC9D37}];2 ;H                   ;Element ;Field   ;
                                                  DataType=Option;
                                                  SourceField=Gen. Journal Line::Account Type }

    { [{7B6B05C9-7F4C-4F1A-B35B-7527372963D3}];2 ;JJ                  ;Element ;Field   ;
                                                  DataType=Code;
                                                  SourceField=Gen. Journal Line::Account No.;
                                                  MinOccurs=Zero }

    { [{AAA99656-A770-4BF4-9F64-05E8663F94D5}];2 ;J                   ;Element ;Field   ;
                                                  DataType=Text;
                                                  SourceField=Gen. Journal Line::Description }

    { [{4B4A5E6A-C0CA-45B7-B733-6EF660429755}];2 ;K                   ;Element ;Field   ;
                                                  DataType=Decimal;
                                                  SourceField=Gen. Journal Line::Amount }

    { [{D0DEBEA0-19C4-456E-A6C8-BA8E84B78188}];2 ;FF                  ;Element ;Field   ;
                                                  DataType=Option;
                                                  SourceField=Gen. Journal Line::Transaction Type }

  }
  EVENTS
  {
  }
  REQUESTPAGE
  {
    PROPERTIES
    {
    }
    CONTROLS
    {
    }
  }
  CODE
  {

    BEGIN
    END.
  }
}

