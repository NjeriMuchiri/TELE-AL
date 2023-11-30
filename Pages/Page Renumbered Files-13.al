OBJECT page 20377 Coop Transaction Codes
{
  OBJECT-PROPERTIES
  {
    Date=04/17/21;
    Time=[ 4:39:47 PM];
    Modified=Yes;
    Version List=SkyCoop;
  }
  PROPERTIES
  {
    SourceTable=Table170042;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1120054004;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1120054005;1 ;Action    ;
                      Name=Charges;
                      RunObject=page 20378;
                      RunPageLink=Code=FIELD(Code),
                                  Terminal=FIELD(Terminal),
                                  Channel=FIELD(Channel);
                      Promoted=Yes;
                      PromotedIsBig=Yes }
    }
  }
  CONTROLS
  {
    { 1120054000;0;Container;
                ContainerType=ContentArea }

    { 1120054001;1;Group  ;
                Name=Group;
                GroupType=Repeater }

    { 1120054002;2;Field  ;
                SourceExpr=Code }

    { 1120054006;2;Field  ;
                SourceExpr=Terminal;
                OnValidate=BEGIN
                             IF Terminal <> '' THEN
                                 IF Code <> '0011' THEN
                                       IF Code <> '0027' THEN
                                           IF Code <> '0014' THEN
                                                 IF Code <> '0016' THEN
                                                     ERROR('Not Applicable to this Code');
                           END;
                            }

    { 1120054007;2;Field  ;
                SourceExpr=Channel;
                OnValidate=BEGIN

                             IF Channel <> '' THEN
                                 IF Code <> '0011' THEN
                                       IF Code <> '0027' THEN
                                           IF Code <> '0014' THEN
                                                 IF Code <> '0016' THEN
                                                     ERROR('Not Applicable to this Code');
                           END;
                            }

    { 1120054003;2;Field  ;
                SourceExpr=Description }

    { 1120054008;2;Field  ;
                SourceExpr="Daily Limit" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

