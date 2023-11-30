OBJECT table 20465 Virtual Member Reg Buffer
{
  OBJECT-PROPERTIES
  {
    Date=10/23/20;
    Time=[ 8:16:54 PM];
    Modified=Yes;
    Version List=Sky;
  }
  PROPERTIES
  {
  }
  FIELDS
  {
    { 1   ;   ;Entry Number        ;Text50         }
    { 2   ;   ;Date Created        ;DateTime       }
    { 3   ;   ;Name                ;Code50         }
    { 4   ;   ;National ID Number  ;Text30         }
    { 5   ;   ;Mobile Number       ;Text30         }
    { 6   ;   ;Date of Birth       ;Date           }
    { 7   ;   ;Referee Name        ;Code50         }
    { 8   ;   ;Referee Member Number;Text30        }
  }
  KEYS
  {
    {    ;Entry Number                            ;Clustered=Yes }
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

