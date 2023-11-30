OBJECT table 50098 HR Leave Types
{
  OBJECT-PROPERTIES
  {
    Date=11/20/17;
    Time=10:26:28 AM;
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    LookupPageID=Page51516873;
    DrillDownPageID=Page51516873;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code40        ;NotBlank=Yes }
    { 2   ;   ;Description         ;Text200        }
    { 3   ;   ;Days                ;Decimal        }
    { 4   ;   ;Acrue Days          ;Boolean        }
    { 5   ;   ;Unlimited Days      ;Boolean        }
    { 6   ;   ;Gender              ;Option        ;OptionCaptionML=ENU=Both,Male,Female;
                                                   OptionString=Both,Male,Female }
    { 7   ;   ;Balance             ;Option        ;OptionCaptionML=ENU=Ignore,Carry Forward,Convert to Cash;
                                                   OptionString=Ignore,Carry Forward,Convert to Cash }
    { 8   ;   ;Inclusive of Holidays;Boolean       }
    { 9   ;   ;Inclusive of Saturday;Boolean       }
    { 10  ;   ;Inclusive of Sunday ;Boolean        }
    { 11  ;   ;Off/Holidays Days Leave;Boolean     }
    { 12  ;   ;Max Carry Forward Days;Decimal      }
    { 13  ;   ;Inclusive of Non Working Days;Boolean }
    { 14  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter }
    { 15  ;   ;Carry Forward Allowed;Boolean       }
    { 16  ;   ;Fixed Days          ;Boolean        }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
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

