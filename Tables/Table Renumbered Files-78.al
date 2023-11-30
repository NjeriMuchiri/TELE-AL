OBJECT table 50097 HR Setup
{
  OBJECT-PROPERTIES
  {
    Date=02/07/23;
    Time=[ 3:11:21 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10         }
    { 2   ;   ;Employee Nos.       ;Code10        ;TableRelation="No. Series".Code }
    { 3   ;   ;Training Application Nos.;Code10   ;TableRelation="No. Series".Code }
    { 4   ;   ;Leave Application Nos.;Code10      ;TableRelation="No. Series".Code }
    { 6   ;   ;Disciplinary Cases Nos.;Code10     ;TableRelation="No. Series".Code }
    { 7   ;   ;Base Calendar       ;Code10        ;TableRelation="HR Calendar" }
    { 8   ;   ;Job Nos             ;Code10        ;TableRelation="No. Series".Code }
    { 13  ;   ;Transport Req Nos   ;Code10        ;TableRelation="No. Series".Code }
    { 14  ;   ;Employee Requisition Nos.;Code10   ;TableRelation="No. Series".Code }
    { 15  ;   ;Leave Posting Period[FROM];Date     }
    { 16  ;   ;Leave Posting Period[TO];Date       }
    { 17  ;   ;Job Application Nos ;Code10        ;TableRelation="No. Series" }
    { 18  ;   ;Exit Interview Nos  ;Code10        ;TableRelation="No. Series" }
    { 19  ;   ;Appraisal Nos       ;Code10        ;TableRelation="No. Series" }
    { 20  ;   ;Company Activities  ;Code10        ;TableRelation="No. Series" }
    { 21  ;   ;Default Leave Posting Template;Code10;
                                                   TableRelation="HR Leave Journal Batch"."Journal Template Name" }
    { 22  ;   ;Positive Leave Posting Batch;Code10;TableRelation="HR Leave Journal Batch".Name }
    { 23  ;   ;Leave Template      ;Code10        ;TableRelation="HR Leave Journal Batch"."Journal Template Name" }
    { 24  ;   ;Leave Batch         ;Code10        ;TableRelation="HR Leave Journal Batch".Name }
    { 25  ;   ;Job Interview Nos   ;Code20        ;TableRelation="No. Series".Code }
    { 26  ;   ;Company Documents   ;Code20        ;TableRelation="No. Series".Code }
    { 27  ;   ;HR Policies         ;Code20        ;TableRelation="No. Series" }
    { 28  ;   ;Notice Board Nos.   ;Code20        ;TableRelation="No. Series" }
    { 29  ;   ;Leave Reimbursment Nos.;Code20     ;TableRelation="No. Series".Code }
    { 30  ;   ;Min. Leave App. Months;Integer     ;CaptionML=ENU=Minimum Leave Application Months }
    { 31  ;   ;Negative Leave Posting Batch;Code10;TableRelation="HR Leave Journal Batch".Name }
    { 32  ;   ;Appraisal Method    ;Option        ;OptionCaptionML=ENU=" ,Normal Appraisal,360 Appraisal";
                                                   OptionString=[ ,Normal Appraisal,360 Appraisal] }
    { 50000;  ;Loan Application Nos.;Code20       ;TableRelation="No. Series".Code }
    { 50001;  ;Leave Carry Over App Nos.;Code20   ;TableRelation="No. Series".Code }
    { 50002;  ;Pay-change No.      ;Code20        ;TableRelation="No. Series".Code }
    { 50003;  ;Max Appraisal Rating;Decimal        }
    { 50004;  ;Medical Claims Nos  ;Code10        ;TableRelation="No. Series".Code }
    { 50005;  ;Employee Transfer Nos.;Code20      ;TableRelation="No. Series".Code }
    { 50006;  ;Leave Planner Nos.  ;Code20        ;TableRelation="No. Series".Code }
    { 50007;  ;Deployed Nos        ;Code20        ;TableRelation="No. Series".Code }
    { 50008;  ;Full Time Nos       ;Code20        ;TableRelation="No. Series".Code }
    { 50009;  ;Board Nos           ;Code20        ;TableRelation="No. Series".Code }
    { 50010;  ;Committee Nos       ;Code20        ;TableRelation="No. Series".Code }
    { 50011;  ;Current Leave Period;Code20         }
    { 50012;  ;Staff Movement Nos  ;Code20        ;TableRelation="No. Series".Code }
    { 50013;  ;HR Meeting Nos      ;Code20        ;TableRelation="No. Series".Code }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

