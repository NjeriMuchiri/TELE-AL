OBJECT page 172138 HR Leave Journal Lines
{
  OBJECT-PROPERTIES
  {
    Date=11/05/20;
    Time=[ 4:33:45 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    SaveValues=Yes;
    InsertAllowed=Yes;
    DeleteAllowed=Yes;
    ModifyAllowed=Yes;
    SourceTable=Table51516410;
    DelayedInsert=Yes;
    PageType=Worksheet;
    AutoSplitKey=No;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=ENU=New,Process,Report,Functions,Approvals;
    ShowFilter=Yes;
    OnOpenPage=VAR
                 JnlSelected@1102755001 : Boolean;
                 InsuranceJnlManagement@1102755000 : Codeunit 51516016;
               BEGIN
                 OpenedFromBatch := ("Journal Batch Name" <> '') AND ("Journal Template Name" = '');
                 IF OpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   InsuranceJnlManagement.OpenJournal(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 InsuranceJnlManagement.TemplateSelection(PAGE::"HR Leave Journal Lines",Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 InsuranceJnlManagement.OpenJournal(CurrentJnlBatchName,Rec);
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102755001;1 ;ActionGroup;
                      CaptionML=ENU=F&unctions }
      { 1102755002;2 ;Action    ;
                      Name=Post Adjustment;
                      CaptionML=ENU=Post Adjustment;
                      Promoted=Yes;
                      Image=PostBatch;
                      PromotedCategory=Category4;
                      OnAction=BEGIN

                                 CODEUNIT.RUN(CODEUNIT::"HR Leave Jnl.-Post",Rec);

                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 1102755004;2 ;Action    ;
                      Name=Batch Allocation;
                      RunObject=Report 53932;
                      Promoted=Yes;
                      Image=Allocate;
                      PromotedCategory=Category4;
                      OnAction=BEGIN



                                 {
                                 AllocationDone:=TRUE;

                                 HRJournalBatch.RESET;
                                 HRJournalBatch.GET("Journal Template Name","Journal Batch Name");


                                 //GET THE CURRENT LEAVE PERIOD
                                 HRLeavePeriods.RESET;
                                 HRLeavePeriods.SETRANGE(HRLeavePeriods."New Fiscal Year",FALSE);
                                 HRLeavePeriods.FIND('-');


                                 //WE ARE ALLOCATING FOR ACTIVE EMPLOYEES ONLY AND GRADE SHOULD BE BETWEEN NIB 1-6
                                 HREmp.RESET;
                                 HREmp.SETRANGE(HREmp.Status,HREmp.Status::Normal);
                                 HREmp.FINDFIRST;

                                 HRLeaveTypes.RESET;
                                 HRLeaveTypes.FINDFIRST;
                                     BEGIN
                                     REPEAT
                                            REPEAT
                                               //CHECK IF ALLOCATION OF CURRENT LEAVE TYPE FOR THE CURRENT PERIOD AND FOR CURRENT EMPLOYEE HAS BEEN DONE
                                               HRLeaveLedger.SETRANGE(HRLeaveLedger."Staff No.",HREmp."No.");
                                               HRLeaveLedger.SETRANGE(HRLeaveLedger."Leave Type",HRLeaveTypes.Code);
                                               HRLeaveLedger.SETRANGE(HRLeaveLedger."Leave Entry Type",HRJournalBatch.Type);
                                               HRLeaveLedger.SETRANGE(HRLeaveLedger."Leave Period",FORMAT(HRLeavePeriods."Starting Date"));
                                               IF NOT HRLeaveLedger.FIND('-') THEN

                                               OK:=CheckGender(HREmp,HRLeaveTypes);

                                               IF OK THEN

                                                 BEGIN

                                                     //INSERT INTO JOURNAL
                                                      INIT;
                                                     IF HREmp.Gender = HREmp.Gender::" " THEN BEGIN
                                                         ERROR('Please specify Gender for Employee No %1',HREmp."No.");
                                                     END;
                                                     IF HREmp."Grade" = '' THEN
                                                     BEGIN
                                                         ERROR('Please specify Job Group for Employee No %1: ',HREmp."No.");
                                                     END;


                                                     "Journal Template Name":="Journal Template Name";
                                                     "Journal Batch Name":="Journal Batch Name";
                                                     "Line No.":="Line No."+1000;
                                                     "Leave Period Name":=HRLeavePeriods."Period Name";
                                                     "Leave Period Start Date":=HRLeavePeriods."Starting Date";
                                                     "Staff No.":=HREmp."No.";

                                                      VALIDATE("Staff No.");
                                                     "Posting Date":=TODAY;
                                                      Description:=HRJournalBatch."Posting Description";
                                                     "Leave Entry Type":=HRJournalBatch.Type;
                                                     "Leave Type":=HRLeaveTypes.Code;
                                                      IF "Leave Type" = 'ANNUAL' THEN
                                                      BEGIN
                                                           IF HREmp."Job Group Code" = 'NIB11'  THEN
                                                           BEGIN
                                                                "No. of Days":=26;
                                                           END ELSE
                                                           BEGIN
                                                                "No. of Days":=HRLeaveTypes.Days;
                                                           END;
                                                           IF HREmp."Job Group Code" = 'NIB12'THEN
                                                           BEGIN
                                                                "No. of Days":=26;
                                                           END ELSE
                                                           BEGIN
                                                                "No. of Days":=HRLeaveTypes.Days;
                                                           END;
                                                           IF HREmp."Job Group Code" = 'NIB13'  THEN
                                                           BEGIN
                                                                "No. of Days":=26;
                                                           END ELSE
                                                           BEGIN
                                                               "No. of Days":=HRLeaveTypes.Days;
                                                           END;
                                                      END ELSE
                                                      BEGIN
                                                           "No. of Days":=HRLeaveTypes.Days;
                                                      END;

                                                     "Job Group":=HREmp."Job Group Code";
                                                     "Journal Created BY":=USERID;
                                                     "Document No.":='LV2014_2015';
                                                     "Shortcut Dimension 1 Code":=HREmp."Scheme Code";
                                                     "Shortcut Dimension 2 Code":=HREmp."Department Code";
                                                         INSERT;

                                                     AllocationDone:=TRUE;

                                                END;

                                               UNTIL HRLeaveTypes.NEXT=0;

                                               HRLeaveTypes.FINDFIRST;

                                       UNTIL HREmp.NEXT=0;
                                     END;
                                 HRLeaveTypes.FINDFIRST;



                                 IF NOT AllocationDone THEN
                                 MESSAGE('Allocation of leave days for '+HRLeavePeriods."Period Name"+
                                  ' period has already been done for all ACTIVE employees');
                                       }
                               END;
                                }
      { 1000000006;1 ;ActionGroup;
                      CaptionML=[ENU=Request Approval;
                                 ESM=Aprobaci¢n solic.;
                                 FRC=Approbation de demande;
                                 ENC=Request Approval] }
      { 1000000005;2 ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[ENU=Send A&pproval Request;
                                 ESM=Enviar solicitud a&probaci¢n;
                                 FRC=Envoyer demande d'a&pprobation;
                                 ENC=Send A&pproval Request];
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category9;
                      OnAction=BEGIN
                                 //IF ApprovalsMgmt.CheckSalesApprovalsWorkflowEnabled(Rec) THEN
                                   //ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                               END;
                                }
      { 1000000004;2 ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[ENU=Cancel Approval Re&quest;
                                 ESM=&Cancelar solicitud aprobaci¢n;
                                 FRC=Annuler demande d'appro&bation;
                                 ENC=Cancel Approval Re&quest];
                      Promoted=Yes;
                      Enabled=OpenApprovalEntriesExist;
                      Image=Cancel;
                      PromotedCategory=Category9;
                      OnAction=BEGIN
                                 //ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1102755024;1;Field  ;
                Lookup=Yes;
                CaptionML=ENU=Batch Name;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             InsuranceJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                               CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;

                           //Rec.RESET;

                           InsuranceJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1102755000;1;Group  ;
                GroupType=Repeater }

    { 1102755005;2;Field  ;
                SourceExpr="Line No." }

    { 1102755007;2;Field  ;
                SourceExpr="Leave Period" }

    { 1102755009;2;Field  ;
                SourceExpr="Staff No." }

    { 1102755011;2;Field  ;
                SourceExpr="Staff Name" }

    { 1102755015;2;Field  ;
                SourceExpr="Leave Type" }

    { 1102755003;2;Field  ;
                SourceExpr="Leave Entry Type" }

    { 1102755017;2;Field  ;
                SourceExpr="No. of Days" }

    { 1102755027;2;Field  ;
                SourceExpr=Description }

    { 1000000000;2;Field  ;
                SourceExpr="Document No." }

    { 1000000001;2;Field  ;
                SourceExpr="Posting Date" }

    { 1000000002;2;Field  ;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 1000000003;2;Field  ;
                SourceExpr="Shortcut Dimension 2 Code" }

  }
  CODE
  {
    VAR
      HRLeaveTypes@1102755000 : Record 51516193;
      HREmp@1102755001 : Record 51516160;
      HRLeaveLedger@1102755002 : Record 51516201;
      InsuranceJnlManagement@1102755013 : Codeunit 51516016;
      ReportPrint@1102755012 : Codeunit 228;
      CurrentJnlBatchName@1102755011 : Code[10];
      InsuranceDescription@1102755010 : Text[30];
      FADescription@1102755009 : Text[30];
      ShortcutDimCode@1102755008 : ARRAY [8] OF Code[20];
      OpenedFromBatch@1102755007 : Boolean;
      HRLeavePeriods@1102755004 : Record 51516198;
      AllocationDone@1102755005 : Boolean;
      HRJournalBatch@1102755006 : Record 51516195;
      OK@1102755003 : Boolean;
      ApprovalEntries@1000000000 : Record 454;
      LLE@1102755015 : Record 51516227;
      ApprovalsMgmt@1000000003 : Codeunit 1535;
      OpenApprovalEntriesExistForCurrUser@1000000002 : Boolean;
      OpenApprovalEntriesExist@1000000001 : Boolean;

    PROCEDURE CheckGender@1102755000(Emp@1102755000 : Record 51516160;LeaveType@1102755001 : Record 51516193) Allocate : Boolean;
    BEGIN

      //CHECK IF LEAVE TYPE ALLOCATION APPLIES TO EMPLOYEE'S GENDER

      IF Emp.Gender=Emp.Gender::Male THEN BEGIN
       IF LeaveType.Gender=LeaveType.Gender::Male THEN
       Allocate:=TRUE;
      END;

      IF Emp.Gender=Emp.Gender::Female THEN BEGIN
       IF LeaveType.Gender=LeaveType.Gender::Female THEN
       Allocate:=TRUE;
      END;

      IF LeaveType.Gender=LeaveType.Gender::Both THEN
      Allocate:=TRUE;
      EXIT(Allocate);

      IF Emp.Gender<>LeaveType.Gender THEN
      Allocate:=FALSE;

      EXIT(Allocate);
    END;

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      InsuranceJnlManagement.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    PROCEDURE AllocateLeave1@1000000006();
    BEGIN
    END;

    PROCEDURE AllocateLeave2@1000000007();
    BEGIN
    END;

    BEGIN
    END.
  }
}

