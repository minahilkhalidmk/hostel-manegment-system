================================================================================
  HOSTEL MANAGEMENT SYSTEM v3.0
  x86 Assembly Language | MASM | Irvine32 | Windows Console Application
================================================================================

------------------------------------------------------------------------
  WHAT IS THIS?
------------------------------------------------------------------------

This is a fully featured Hostel Management System written in x86 Assembly
language using MASM (Microsoft Macro Assembler) and the Irvine32 library.
It runs as a Windows console application and allows an administrator to
manage students, staff members, attendance records, mess billing, and
warden information through a secure, menu-driven interface.

Everything is validated before storing. No wrong value is ever saved.
The screen clears after every action. All input rules match real-world
hostel administration requirements.

------------------------------------------------------------------------
  SYSTEM REQUIREMENTS
------------------------------------------------------------------------

  Assembler   : MASM (Microsoft Macro Assembler)
                Bundled with Visual Studio - no separate install needed

  Library     : Irvine32
                Must be installed at exactly: C:\Irvine\
                Download from: http://asmirvine.com/

  IDE         : Visual Studio 2019 or later

  Build Mode  : Debug | x86   (NOT x64 - MASM is 32-bit only)

  OS          : Windows 10 or Windows 11
                (32-bit mode or 64-bit with WOW64 subsystem)

  File        : hostel_management.asm  (single source file, all-in-one)

------------------------------------------------------------------------
  HOW TO BUILD AND RUN
------------------------------------------------------------------------

  Step 1 : Install Irvine32 into C:\Irvine\
           Make sure Irvine32.inc and Irvine32.lib are there.

  Step 2 : Open Visual Studio
           File -> New -> Project -> Empty Project
           IMPORTANT: Select x86 architecture, NOT x64

  Step 3 : Add the file
           Right-click Source Files -> Add -> Existing Item
           Select hostel_management.asm

  Step 4 : Configure project properties
           Project Properties -> Build Customizations -> tick "masm"
           Linker -> Input -> Additional Dependencies -> add Irvine32.lib
           Linker -> General -> Output File -> hostel_management.exe

  Step 5 : Build
           Build -> Build Solution   (shortcut: Ctrl + Shift + B)
           You should see "Build: 1 succeeded, 0 failed"

  Step 6 : Run
           Debug -> Start Without Debugging   (shortcut: Ctrl + F5)

------------------------------------------------------------------------
  ADMIN LOGIN
------------------------------------------------------------------------

  Username    : admin
  Password    : Admin@123

  Password Rules (enforced on every login attempt):
    - Minimum 8 characters, maximum 16 characters
    - At least one UPPERCASE letter  (A-Z)
    - At least one lowercase letter  (a-z)
    - At least one digit             (0-9)
    - At least one special character (!  @  #  $  %  ^  &  *  -  _)

  The system allows a maximum of 3 failed login attempts.
  After 3 failures the system locks and exits automatically.
  Each failed attempt shows exactly which password rule was violated.

------------------------------------------------------------------------
  MAIN MENU OPTIONS
------------------------------------------------------------------------

  1   Add Student
        Adds a new student after validating every field.
        Roll number must follow the format: YYYYDDDnnn
          e.g. 2024cs604 = year 2024, dept code cs, roll 604
        Department must be alphabets only.
        Name must be alphabets and spaces only.
        Age must be 18 to 40.

  2   Display All Students
        Shows all registered students: roll number, department,
        session year, name, and age.

  3   Generate Student Mess Bill
        Enter a roll number to calculate and display the mess bill.
        Bill = total attendance days across all months x Rs. 200

  4   Add Staff Member
        Adds a new staff member. Job is selected from a menu:
          1. Cook          Rs. 50 per hour
          2. Guard         Rs. 20 per hour
          3. Munshi        Rs. 10 per hour
          4. Mess Boy      Rs. 30 per hour
          5. Dish Washer   Rs. 20 per hour
          6. Sweeper       Rs. 10 per hour
        Name: alphabets and spaces only.
        Gender: only Male or Female accepted.
        Age: 18 to 60.
        Hours: maximum 312 per month.
        Salary is calculated automatically: hours x job rate.

  5   Display All Staff
        Shows all staff members: job, name, gender, age,
        hours worked, and salary.

  6   View Warden Details
        Displays the warden's name, ID, phone number,
        room number, and bank account number.

  7   Show Staff Salary
        Search for a staff member by job title and name.
        Enter updated hours (max 312). Salary is recalculated
        automatically using the correct rate for that job type.

  8   Mark Monthly Attendance
        Search for a student by roll number.
        Enter month (1-12). The system shows the maximum days
        allowed for that specific month (e.g. February = 28).
        Enter days present. Only valid values are accepted.
        Previous attendance for any month can be overwritten.

  9   View Attendance History
        Search for a student by roll number.
        Displays all 12 months showing days present for each.
        Month names (Jan, Feb, ..., Dec) are printed with values.

  10  Update Student Record
        Search by roll number, then choose which field to update:
          1. Department  (re-validated: alphabets only)
          2. Session     (re-validated: 1990 to 2030)
          3. Name        (re-validated: alphabets and spaces)
          4. Age         (re-validated: 18 to 40)

  11  Update Staff Record
        Search by job title and name, then choose field to update:
          1. Job Title   (re-selected from job menu, salary recalculated)
          2. Name        (re-validated: alphabets and spaces)
          3. Gender      (re-validated: Male or Female only)
          4. Age         (re-validated: 18 to 60)
          5. Hours       (re-validated: max 312, salary recalculated)

  12  Summary
        Displays total number of students and staff currently
        registered in the system.

  0   Exit
        Closes the program.

------------------------------------------------------------------------
  VALIDATION RULES SUMMARY
------------------------------------------------------------------------

  Field                  Rule
  ---------------------  -------------------------------------------------
  Admin Password         8-16 chars, upper, lower, digit, special char
  Student Roll Number    Format: 4 digits + 2-3 letters + 3 digits
  Roll Number Uniqueness Duplicate roll numbers are rejected immediately
  Department Name        Alphabets only, no digits or symbols
  Session Year           Between 1990 and 2030
  Student Name           Alphabets and spaces only
  Student Age            18 to 40 (re-prompts on invalid input)
  Staff Job              Only from the 6 allowed job types
  Staff Name             Alphabets and spaces only
  Gender                 Exactly "Male" or "Female" (case-sensitive)
  Staff Age              18 to 60 (re-prompts on invalid input)
  Hours Worked           1 to 312 maximum per month
  Attendance Month       1 to 12
  Attendance Days        0 to actual days in that month (e.g. Feb = 28)

------------------------------------------------------------------------
  PRE-LOADED STAFF (at startup)
------------------------------------------------------------------------

  Job        Name      Gender   Age   Hours   Salary
  ---------  --------  ------   ---   -----   ------
  Guard      Iqbal     Male     46    84      Rs. 1,680
  Cook       Anees     Male     40    80      Rs. 4,000
  Sweeper    Meesum    Male     28    56      Rs.   560
  Mess Boy   Tariq     Male     30    96      Rs. 2,880

------------------------------------------------------------------------
  BILLING RATES
------------------------------------------------------------------------

  Mess Bill Rate : Rs. 200 per attendance day
  Bill Formula   : Sum of all monthly attendance days x 200

  Staff Salary Rates:
    Cook          Rs. 50  per hour
    Guard         Rs. 20  per hour
    Munshi        Rs. 10  per hour
    Mess Boy      Rs. 30  per hour
    Dish Washer   Rs. 20  per hour
    Sweeper       Rs. 10  per hour

------------------------------------------------------------------------
  DATA LIMITS
------------------------------------------------------------------------

  Maximum Students   : 30
  Maximum Staff      : 20
  Attendance History : 12 months per student (all months stored)

  NOTE: All data is stored in memory only. When the program closes,
  all records are lost. There is no file save/load feature.

------------------------------------------------------------------------
  FILES IN THIS PROJECT
------------------------------------------------------------------------

  hostel_management.asm              Main source file (all code)
  README.txt                         This file
  Hostel_Management_Documentation    Full technical Word document

------------------------------------------------------------------------
  VERSION HISTORY
------------------------------------------------------------------------

  v1.0  Original submission
        Basic add/display for students and staff only.

  v2.0  Major bug fix release
        Fixed wrong struct offsets, added validation, fixed loop
        instructions (A2075), fixed .MODEL duplicate (A4011),
        removed & chaining syntax errors (102 errors fixed),
        added attendance history, update options, and login.

  v3.0  Full improvement release
        Password complexity enforcement (8-16 chars, 4 rules).
        Roll number format validation (YYYYDDDnnn).
        Alphabets-only validation for names and departments.
        Job type restricted to 6 allowed positions via menu.
        Gender strictly Male or Female only.
        Hours capped at 312 per month.
        Per-job salary rates (Cook=50, Guard=20, etc.).
        Attendance limited by actual calendar month days.
        Fixed A2026 (constant expected), A4011 (.MODEL duplicate),
        A2006 (undefined symbol AStaf_job).

------------------------------------------------------------------------
  KNOWN LIMITATIONS
------------------------------------------------------------------------

  - No file I/O: data is not saved between sessions
  - Password is stored in plain text in the .data section
  - February attendance is fixed at 28 days (no leap year check)
  - Maximum 30 students and 20 staff (edit constants to change)
  - No delete function for student or staff records
  - Irvine32 must be at C:\Irvine\ exactly

================================================================================
  END OF README
================================================================================
