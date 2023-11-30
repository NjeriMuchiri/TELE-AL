OBJECT page 172121 HR Job Occupants
{
  OBJECT-PROPERTIES
  {
    Date=11/21/17;
    Time=12:07:54 PM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table51516100;
    PageType=Card;
    PromotedActionCategoriesML=ENU=New,Process,Report;
    OnOpenPage=BEGIN
                       IF ISEMPTY THEN
                       ERROR('No jobs have been setup');
               END;

    ActionList=ACTIONS
    {
      { 1000000002;  ;ActionContainer;
                      CaptionML=ENU=Reports;
                      ActionContainerType=ActionItems }
      { 1000000003;1 ;Action    ;
                      Name=Print HR Job Occupants;
                      RunObject=Report 55582;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000000;1;Group  ;
                CaptionML=ENU=Job Details;
                Editable=FALSE;
                GroupType=Group }

    { 1000000001;2;Field  ;
                SourceExpr="Job ID";
                Importance=Promoted;
                Enabled=false }

    { 1102755006;2;Field  ;
                SourceExpr="Job Description";
                Importance=Promoted;
                Enabled=false }

    { 1102755000;1;Part   ;
                CaptionML=ENU=Job Occupants;
                PagePartID=Page51516852;
                Editable=false;
                PartType=Page }

    { 1102755007;;Container;
                ContainerType=FactBoxArea }

    { 1102755003;1;Part   ;
                PartType=System;
                SystemPartID=Outlook }

  }
  CODE
  {
    VAR
      Text19006026@19067672 : TextConst 'ENU=Job Occupants';

    BEGIN
    END.
  }
}

