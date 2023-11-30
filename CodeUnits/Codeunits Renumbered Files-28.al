OBJECT CodeUnit 20392 HR Datess
{
  OBJECT-PROPERTIES
  {
    Date=11/03/20;
    Time=[ 1:08:09 PM];
    Modified=Yes;
    Version List=HRMIS;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      dayOfWeek@1000000000 : Integer;
      weekNumber@1000000001 : Integer;
      year@1000000002 : Integer;
      weekends@1000000003 : Integer;
      NextDay@1000000004 : Date;
      TEXTDATE1@1000000005 : TextConst 'ENU=The Start date cannot be Greater then the end Date.';

    PROCEDURE DetermineAge@3(DateOfBirth@1000000000 : Date;DateOfJoin@1000000001 : Date) AgeString : Text[45];
    VAR
      dayB@1000000002 : Integer;
      monthB@1000000003 : Integer;
      yearB@1000000004 : Integer;
      dayJ@1000000005 : Integer;
      monthJ@1000000006 : Integer;
      yearJ@1000000007 : Integer;
      Year@1000000008 : Integer;
      Month@1000000009 : Integer;
      Day@1000000010 : Integer;
      monthsToBirth@1000000011 : Integer;
      D@1000000012 : Date;
      DateCat@1000000013 : Integer;
    BEGIN
                IF ((DateOfBirth <> 0D) AND (DateOfJoin <> 0D)) THEN BEGIN
                  dayB:= DATE2DMY(DateOfBirth,1);
                  monthB:= DATE2DMY(DateOfBirth,2);
                  yearB:= DATE2DMY(DateOfBirth,3);
                  dayJ:= DATE2DMY(DateOfJoin,1);
                  monthJ:= DATE2DMY(DateOfJoin,2);
                  yearJ:= DATE2DMY(DateOfJoin,3);
                  Day:= 0; Month:= 0; Year:= 0;
                  DateCat := DateCategory(dayB,dayJ,monthB,monthJ,yearB,yearJ);
                  CASE (DateCat) OF
                      1: BEGIN
                           Year:= yearJ - yearB;
                           IF monthJ >= monthB THEN
                              Month:= monthJ - monthB
                           ELSE BEGIN
                              Month:= (monthJ + 12) - monthB;
                              Year:= Year - 1;
                           END;

                           IF (dayJ >= dayB) THEN
                              Day:= dayJ - dayB
                           ELSE IF (dayJ < dayB) THEN BEGIN
                              Day:= (DetermineDaysInMonth(monthJ,yearJ) + dayJ) - dayB;
                              Month:= Month - 1;
                           END;

                              AgeString:= '%1  Years, %2  Months and #3## Days';
                              AgeString:= STRSUBSTNO(AgeString,Year,Month,Day);

                          END;

                      2,3,7:BEGIN
                            IF (monthJ <> monthB) THEN BEGIN
                                 IF monthJ >= monthB THEN
                                    Month:= monthJ - monthB
                               //  ELSE ERROR('The wrong date category!');
                             END;

                           IF (dayJ <> dayB) THEN BEGIN
                            IF (dayJ >= dayB) THEN
                              Day:= dayJ - dayB
                            ELSE IF (dayJ < dayB) THEN BEGIN
                              Day:= (DetermineDaysInMonth(monthJ,yearJ) + dayJ) - dayB;
                              Month:= Month - 1;
                            END;
                           END;

                             AgeString:= '%1  Months %2 Days';
                             AgeString:= STRSUBSTNO(AgeString,Month,Day);
                            END;
                       4: BEGIN
                             Year:= yearJ - yearB;
                             AgeString:='#1## Years';
                             AgeString:= STRSUBSTNO(AgeString,Year);
                          END;
                       5: BEGIN
                           IF (dayJ >= dayB) THEN
                              Day:= dayJ - dayB
                           ELSE IF (dayJ < dayB) THEN BEGIN
                              Day:= (DetermineDaysInMonth(monthJ,yearJ) + dayJ) - dayB;
                              monthJ:= monthJ - 1;
                              Month:= (monthJ + 12) - monthB;
                              yearJ:= yearJ - 1;
                           END;

                           Year:= yearJ - yearB;
                              AgeString:= '%1  Years, %2 Months and #3## Days';
                              AgeString:= STRSUBSTNO(AgeString,Year,Month,Day);
                           END;
                       6: BEGIN
                           IF monthJ >= monthB THEN
                              Month:= monthJ - monthB
                           ELSE BEGIN
                              Month:= (monthJ + 12) - monthB;
                              yearJ:= yearJ - 1;
                           END;
                              Year:= yearJ - yearB;
                              AgeString:= '%1  Years and #2## Months';
                              AgeString:= STRSUBSTNO(AgeString,Year,Month);
                          END;
                      ELSE AgeString:= '';
                      END;
                    END ELSE MESSAGE('For Date Calculation Enter All Applicable Dates!');
                     EXIT;
    END;

    PROCEDURE DifferenceStartEnd@1(StartDate@1000000000 : Date;EndDate@1000000001 : Date) DaysValue : Integer;
    VAR
      dayStart@1000000002 : Integer;
      monthS@1000000003 : Integer;
      yearS@1000000004 : Integer;
      dayEnd@1000000005 : Integer;
      monthE@1000000006 : Integer;
      yearE@1000000007 : Integer;
      Year@1000000008 : Integer;
      Month@1000000009 : Integer;
      Day@1000000010 : Integer;
      monthsBetween@1000000011 : Integer;
      i@1000000012 : Integer;
      j@1000000013 : Integer;
      monthValue@1000000014 : Integer;
      monthEnd@1000000015 : Integer;
      p@1000000016 : Integer;
      q@1000000017 : Integer;
      l@1000000018 : Integer;
      DateCat@1000000019 : Integer;
      daysInYears@1000000020 : Integer;
      m@1000000021 : Integer;
      yearStart@1000000022 : Integer;
      t@1000000023 : Integer;
      s@1000000024 : Integer;
      WeekendDays@1000000025 : Integer;
      AbsencePreferences@1000000026 : Record 51516161;
      Holidays@1000000027 : Integer;
    BEGIN
               IF ((StartDate <> 0D) AND (EndDate <> 0D)) THEN BEGIN
                  Day:=0; monthValue:= 0; p:=0; q:=0; l:= 0;
                  Year:= 0; daysInYears:=0; DaysValue:= 0;
                  dayStart:= DATE2DMY(StartDate,1);
                  monthS:= DATE2DMY(StartDate,2);
                  yearS:= DATE2DMY(StartDate,3);
                  dayEnd:= DATE2DMY(EndDate,1);
                  monthE:= DATE2DMY(EndDate,2);
                  yearE:= DATE2DMY(EndDate,3);

                  WeekendDays:= 0;
                  AbsencePreferences.FIND('-');
                   IF (AbsencePreferences."Include Weekends" = TRUE) THEN
                     WeekendDays:= DetermineWeekends(StartDate,EndDate);

                  Holidays:= 0;
                  AbsencePreferences.FIND('-');
                   IF (AbsencePreferences."Include Holidays" = TRUE) THEN
                      Holidays:= DetermineHolidays(StartDate,EndDate);

                  DateCat := DateCategory(dayStart,dayEnd,monthS,monthE,yearS,yearE);
                  CASE (DateCat) OF
                      1: BEGIN
                          p:=0; q:=0;
                          Year := yearE - yearS;
                          yearStart := yearS;
                          t := 1; s := 1;
                          IF (monthE <> monthS) THEN BEGIN

                           FOR j := 1 TO (monthS - 1) DO BEGIN
                               q := q + DetermineDaysInMonth(t,yearS);
                               t := t+1;
                           END;
                               q:= q + dayStart;

                           FOR i := 1 TO (monthE - 1) DO BEGIN
                               p := p + DetermineDaysInMonth(s,yearE);
                               s:= s+1;
                           END;
                               p:= p + dayEnd;

                           FOR m := 1 TO Year DO BEGIN
                              IF LeapYear(yearStart) THEN daysInYears := daysInYears + 366
                              ELSE daysInYears:= daysInYears + 365;
                              yearStart := yearStart + 1;
                           END;
                              DaysValue := (((daysInYears - q) + p) - WeekendDays) - Holidays;
                           END;
                         END;

                      2,7 : BEGIN
                            FOR l := (monthS + 1) TO (monthE - 1) DO
                                DaysValue:= DaysValue + DetermineDaysInMonth(l,yearS);
                            DaysValue:= ((DaysValue + (DetermineDaysInMonth(monthS,yearS) - dayStart) + dayEnd)- WeekendDays)- Holidays;
                            END;

                      3: BEGIN
                           IF (dayEnd >= dayStart) THEN
                              DaysValue:= dayEnd - dayStart - WeekendDays - Holidays
                              ELSE IF (dayEnd = dayStart) THEN DaysValue:= 0
                              ELSE DaysValue:= ((dayStart - dayEnd) - WeekendDays) - Holidays;

                         END;

                      4: BEGIN
                          DaysValue:= 0;
                          Year:= yearE - yearS;
                          yearStart := yearS;
                          FOR m:= 1 TO Year DO BEGIN
                           IF (LeapYear(yearStart)) THEN daysInYears:= 366
                               ELSE daysInYears:= 365;
                               DaysValue:= DaysValue +  daysInYears;
                               yearStart:= yearStart + 1;
                          END;
                          DaysValue:= (DaysValue - WeekendDays) - Holidays;
                          END;

                       5: BEGIN
                          Year := yearE - yearS;
                          yearStart := yearS;
                           FOR m := 1 TO Year DO BEGIN
                              IF LeapYear(yearStart) THEN daysInYears := daysInYears + 366
                              ELSE daysInYears:= daysInYears + 365;
                              yearStart := yearStart + 1;
                           END;
                              DaysValue:= daysInYears;
                            IF dayEnd > dayStart THEN
                              DaysValue:= (DaysValue + (dayEnd - dayStart) - WeekendDays) - Holidays
                            ELSE IF dayStart > dayEnd THEN
                              DaysValue:= (DaysValue - (dayStart - dayEnd) - WeekendDays) - Holidays;
                          END;

                       6: BEGIN
                          q:= 0; p:= 0;
                          Year := yearE - yearS;
                          yearStart := yearS;
                          t := 1; s := 1;

                           FOR j := 1 TO monthS DO BEGIN
                               q := q + DetermineDaysInMonth(t,yearS);
                               t := t+1;
                           END;

                           FOR i := 1 TO monthE DO BEGIN
                               p := p + DetermineDaysInMonth(s,yearE);
                               s:= s+1;
                           END;

                           FOR m := 1 TO Year DO BEGIN
                              IF LeapYear(yearStart) THEN daysInYears := daysInYears + 366
                              ELSE daysInYears:= daysInYears + 365;
                              yearStart := yearStart + 1;
                           END;

                            DaysValue := ((daysInYears - q) + p) - WeekendDays - Holidays;
                           END;
                      ELSE DaysValue:= 0;

                  END;
              END ELSE MESSAGE('Enter all applicable dates for calculation!');
                  DaysValue += 1;
                  EXIT;
    END;

    PROCEDURE DetermineDaysInMonth@5(Month@1000000000 : Integer;Year@1000000001 : Integer) DaysInMonth : Integer;
    BEGIN
                          CASE (Month) OF
                               1              :   DaysInMonth:=31;
                               2              :   BEGIN
                                                    IF (LeapYear(Year)) THEN DaysInMonth:=29
                                                    ELSE DaysInMonth:= 28;
                                                  END;
                               3              :   DaysInMonth:=31;
                               4              :   DaysInMonth:=30;
                               5              :   DaysInMonth:=31;
                               6              :   DaysInMonth:=30;
                               7              :   DaysInMonth:=31;
                               8              :   DaysInMonth:=31;
                               9              :   DaysInMonth:= 30;
                               10             :   DaysInMonth:= 31;
                               11             :   DaysInMonth:= 30;
                               12             :   DaysInMonth:= 31;
                               ELSE MESSAGE('Not valid date. The month must be between 1 and 12');
                          END;

                          EXIT;
    END;

    PROCEDURE DateCategory@2(BDay@1000000000 : Integer;EDay@1000000001 : Integer;BMonth@1000000002 : Integer;EMonth@1000000003 : Integer;BYear@1000000004 : Integer;EYear@1000000005 : Integer) Category : Integer;
    BEGIN
                           IF ((EYear > BYear) AND (EMonth <> BMonth) AND (EDay <> BDay)) THEN Category:= 1
                           ELSE IF ((EYear = BYear) AND (EMonth <> BMonth) AND (EDay = BDay)) THEN Category:=2
                           ELSE IF ((EYear = BYear) AND (EMonth = BMonth) AND (EDay <> BDay)) THEN Category:=3
                           ELSE IF ((EYear > BYear) AND (EMonth = BMonth) AND (EDay = BDay)) THEN Category:=4
                           ELSE IF ((EYear > BYear) AND (EMonth = BMonth) AND (EDay <> BDay)) THEN Category:= 5
                           ELSE IF ((EYear > BYear) AND (EMonth <> BMonth) AND (EDay = BDay)) THEN Category:= 6
                           ELSE IF ((EYear = BYear) AND (EMonth <> BMonth) AND (EDay <> BDay)) THEN Category:=7
                           ELSE IF ((EYear = BYear) AND (EMonth = BMonth) AND (EDay = BDay)) THEN Category:=3
                           ELSE IF ((EYear < BYear)) THEN
                           ERROR(TEXTDATE1)
                           ELSE BEGIN
                                Category:=0;
                                //ERROR('The start date cannot be after the end date.');
                                END;
                           EXIT;
    END;

    PROCEDURE LeapYear@7(Year@1000000000 : Integer) LY : Boolean;
    VAR
      CenturyYear@1000000001 : Boolean;
      DivByFour@1000000002 : Boolean;
    BEGIN
                         CenturyYear := Year MOD 100 = 0;
                         DivByFour:= Year MOD 4 = 0;
                         IF ((NOT CenturyYear AND DivByFour) OR (Year MOD 400 = 0)) THEN
                          LY:= TRUE
                         ELSE
                          LY:= FALSE;
    END;

    PROCEDURE ReservedDates@4(NewStartDate@1000000000 : Date;NewEndDate@1000000001 : Date;EmployeeNumber@1000000002 : Code[20]) Reserved : Boolean;
    VAR
      AbsenceHoliday@1000000003 : Record 51516027;
      OK@1000000004 : Boolean;
    BEGIN
                        AbsenceHoliday.SETFILTER("Employee No.",EmployeeNumber);
                        OK:= AbsenceHoliday.FIND('-');
                        REPEAT
                            IF (NewStartDate > AbsenceHoliday."Start Date") AND (NewStartDate < AbsenceHoliday."End Date") THEN
                               Reserved := TRUE
                            ELSE
                            IF (NewEndDate < AbsenceHoliday."End Date") AND (NewEndDate > AbsenceHoliday."Start Date") THEN
                               Reserved := TRUE
                            ELSE
                            IF (NewStartDate > AbsenceHoliday."Start Date") AND (NewEndDate < AbsenceHoliday."End Date") THEN
                               Reserved := TRUE
                            ELSE Reserved := FALSE;

                        UNTIL AbsenceHoliday.NEXT = 0;
    END;

    PROCEDURE DetermineWeekends@6(DateStart@1000000000 : Date;DateEnd@1000000001 : Date) Weekends : Integer;
    BEGIN
               Weekends:= 0;
               WHILE (DateStart <= DateEnd) DO BEGIN
                 dayOfWeek:= DATE2DWY(DateStart,1);
                   IF (dayOfWeek = 6) OR (dayOfWeek = 7) THEN
                      Weekends:= Weekends + 1;
                 NextDay:= CalculateNextDay(DateStart);
                 DateStart:= NextDay;
               END;
    END;

    PROCEDURE CalculateNextDay@8(Date@1000000000 : Date) NextDate : Date;
    VAR
      today@1000000001 : Integer;
      month@1000000002 : Integer;
      year@1000000003 : Integer;
      nextDay@1000000004 : Integer;
      daysInMonth@1000000005 : Integer;
    BEGIN
                  today:= DATE2DMY(Date,1);
                  month:= DATE2DMY(Date,2);
                  year:= DATE2DMY(Date,3);
                  daysInMonth:= DetermineDaysInMonth(month,year);
                  nextDay:= today + 1;
                  IF (nextDay > daysInMonth) THEN BEGIN
                    nextDay:= 1;
                    month:= month + 1;
                    IF (month > 12) THEN BEGIN
                      month:= 1;
                      year:= year + 1;
                    END;
                  END;
                   NextDate:= DMY2DATE(nextDay,month,year);
    END;

    PROCEDURE DetermineHolidays@9(DateStart@1000000000 : Date;DateEnd@1000000001 : Date) Holiday : Integer;
    VAR
      StatutoryHoliday@1000000002 : Record 51516028;
      NextDay@1000000003 : Date;
    BEGIN
                Holiday:= 0;
                WHILE (DateStart <= DateEnd) DO BEGIN
                  dayOfWeek:= DATE2DWY(DateStart,1);
                  StatutoryHoliday.FIND('-');
                  REPEAT
                   IF (DateStart = StatutoryHoliday."Non Working Dates") THEN
                      Holiday:= Holiday + StatutoryHoliday.Code;

                  UNTIL StatutoryHoliday.NEXT = 0;
                  NextDay:= CalculateNextDay(DateStart);
                  DateStart:= NextDay;
               END;
    END;

    PROCEDURE ConvertDate@1102758000(nDate@1102758000 : Date) strDate : Text[30];
    VAR
      lDay@1102758001 : Integer;
      lMonth@1102758002 : Integer;
      lYear@1102758003 : Integer;
      strDay@1102758004 : Text[4];
      StrMonth@1102758005 : Text[20];
      strYear@1102758006 : Text[6];
    BEGIN
      //this function converts the date to the format required by ksps
      lDay:=DATE2DMY(nDate,1);
      lMonth:=DATE2DMY(nDate,2);
      lYear:=DATE2DMY(nDate,3);

      IF lDay=1 THEN BEGIN strDay:='1st' END;
      IF lDay=2 THEN BEGIN strDay:='2nd' END;
      IF lDay=3 THEN BEGIN strDay:='3rd' END;
      IF lDay=4 THEN BEGIN strDay:='4th' END;
      IF lDay=5 THEN BEGIN strDay:='5th' END;
      IF lDay=6 THEN BEGIN strDay:='6th' END;
      IF lDay=7 THEN BEGIN strDay:='7th' END;
      IF lDay=8 THEN BEGIN strDay:='8th' END;
      IF lDay=9 THEN BEGIN strDay:='9th' END;
      IF lDay=10 THEN BEGIN strDay:='10th' END;
      IF lDay=11 THEN BEGIN strDay:='11th' END;
      IF lDay=12 THEN BEGIN strDay:='12th' END;
      IF lDay=13 THEN BEGIN strDay:='13th' END;
      IF lDay=14 THEN BEGIN strDay:='14th' END;
      IF lDay=15 THEN BEGIN strDay:='15th' END;
      IF lDay=16 THEN BEGIN strDay:='16th' END;
      IF lDay=17 THEN BEGIN strDay:='17th' END;
      IF lDay=18 THEN BEGIN strDay:='18th' END;
      IF lDay=19 THEN BEGIN strDay:='19th' END;
      IF lDay=20 THEN BEGIN strDay:='20th' END;
      IF lDay=21 THEN BEGIN strDay:='21st' END;
      IF lDay=22 THEN BEGIN strDay:='22nd' END;
      IF lDay=23 THEN BEGIN strDay:='23rd' END;
      IF lDay=24 THEN BEGIN strDay:='24th' END;
      IF lDay=25 THEN BEGIN strDay:='25th' END;
      IF lDay=26 THEN BEGIN strDay:='26th' END;
      IF lDay=27 THEN BEGIN strDay:='27th' END;
      IF lDay=28 THEN BEGIN strDay:='28th' END;
      IF lDay=29 THEN BEGIN strDay:='29th' END;
      IF lDay=30 THEN BEGIN strDay:='30th' END;
      IF lDay=31 THEN BEGIN strDay:='31st' END;

      IF lMonth=1 THEN BEGIN StrMonth:=' January ' END;
      IF lMonth=2 THEN BEGIN StrMonth:=' February ' END;
      IF lMonth=3 THEN BEGIN StrMonth:=' March ' END;
      IF lMonth=4 THEN BEGIN StrMonth:=' April ' END;
      IF lMonth=5 THEN BEGIN StrMonth:=' May ' END;
      IF lMonth=6 THEN BEGIN StrMonth:=' June ' END;
      IF lMonth=7 THEN BEGIN StrMonth:=' July ' END;
      IF lMonth=8 THEN BEGIN StrMonth:=' August ' END;
      IF lMonth=9 THEN BEGIN StrMonth:=' September ' END;
      IF lMonth=10 THEN BEGIN StrMonth:=' October ' END;
      IF lMonth=11 THEN BEGIN StrMonth:=' November ' END;
      IF lMonth=12 THEN BEGIN StrMonth:=' December ' END;

      strYear:=FORMAT(lYear);
      //return the date
      strDate:=strDay + StrMonth + strYear;
    END;

    BEGIN
    END.
  }
}

