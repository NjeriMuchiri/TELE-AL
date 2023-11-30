OBJECT Query 17202 NextOfKeenDetails
{
  OBJECT-PROPERTIES
  {
    Date=09/29/16;
    Time=[ 4:25:49 PM];
    Modified=Yes;
    Version List=;
  }
  PROPERTIES
  {
  }
  ELEMENTS
  {
    { 1000000000;;DataItem;                  ;
               DataItemTable=Table51516225 }

    { 1000000001;1;Column;                   ;
               DataSource=Name }

    { 1000000003;1;Column;                   ;
               DataSource=Beneficiary }

    { 1000000004;1;Column;                   ;
               DataSource=Date of Birth }

    { 1000000005;1;Column;                   ;
               DataSource=Address }

    { 1000000006;1;Column;                   ;
               DataSource=Telephone }

    { 1000000008;1;Column;                   ;
               DataSource=Email }

    { 1000000009;1;Column;                   ;
               DataSource=Account No }

    { 1000000010;1;Column;                   ;
               DataSource=ID No. }

    { 1000000011;1;Column;                   ;
               DataSource=%Allocation }

    { 1000000002;1;DataItem;                 ;
               DataItemTable=Table51516318;
               DataItemLink=code=Members_Next_Kin_Details.Relationship }

    { 1000000007;2;Column;Relationship       ;
               DataSource=Describution }

  }
  CODE
  {

    BEGIN
    END.
  }
}

