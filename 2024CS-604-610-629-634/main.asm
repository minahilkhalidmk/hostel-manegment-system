

INCLUDE C:\Irvine\Irvine32.inc
INCLUDELIB C:\Irvine\Irvine32.lib
.stack 4096

ExitProcess PROTO, dwExitCode:DWORD

; ============================================================
;  CONSTANTS
; ============================================================
max_student  = 30
max_staff    = 20
NUM_MONTHS   = 12

; ============================================================
;  STRUCT - student
;  Offsets:
;    0  : roll_str     BYTE[12]   e.g. "2024cs604",0  (11 chars + null)
;   12  : department   BYTE[21]
;   33  : session      DWORD
;   37  : name         BYTE[30]
;   67  : age          DWORD
;   71  : monthly_att  DWORD[12]  (48 bytes)
;  119  : bill         DWORD
;  SIZEOF = 123
; ============================================================
student STRUCT
    roll_str    BYTE  12 DUP(0)
    department  BYTE  21 DUP(0)
    session     DWORD ?
    name        BYTE  30 DUP(0)
    age         DWORD ?
    monthly_att DWORD NUM_MONTHS DUP(0)
    bill        DWORD ?
student ENDS

; ============================================================
;  STRUCT - staff
;  Offsets:
;    0  : job         BYTE[15]
;   15  : name1       BYTE[30]
;   45  : gender      BYTE[10]
;   55  : Age         DWORD
;   59  : total_hours DWORD
;   63  : TotalSalary DWORD
;  SIZEOF = 67
; ============================================================
staff STRUCT
    job         BYTE  15 DUP(0)
    name1       BYTE  30 DUP(0)
    gender      BYTE  10 DUP(0)
    Age         DWORD ?
    total_hours DWORD ?
    TotalSalary DWORD ?
staff ENDS

; ============================================================
;  STRUCT - warden
; ============================================================
warden STRUCT
    wname     BYTE  30 DUP(0)
    wid       DWORD ?
    pnumber   BYTE  15 DUP(0)
    roomno    DWORD ?
    accountno BYTE  20 DUP(0)
warden ENDS

; ============================================================
;  .DATA
; ============================================================
.data

; --- Admin credentials (password now meets complexity rules)
admin_username BYTE "admin",0
admin_password BYTE "Admin@123",0     ; upper+lower+digit+special, 9 chars
input_username BYTE 30 DUP(0)
input_password BYTE 20 DUP(0)
login_attempts DWORD 0

; --- Login / password messages
login_banner1   BYTE "  ============================================================",0
login_banner2   BYTE "  |      HOSTEL MANAGEMENT SYSTEM  -  ADMIN LOGIN            |",0
login_banner3   BYTE "  ============================================================",0
login_user_str  BYTE "  Enter Admin Username : ",0
login_pass_str  BYTE "  Enter Admin Password : ",0
login_success   BYTE "  Access Granted!  Welcome, Admin.",0
login_fail      BYTE "  Incorrect username or password. Try again.",0
login_locked    BYTE "  Too many failed attempts. System Locked. Exiting...",0
pass_len_err    BYTE "  ERROR: Password must be 8-16 characters!",0
pass_upper_err  BYTE "  ERROR: Password must contain at least one uppercase letter!",0
pass_lower_err  BYTE "  ERROR: Password must contain at least one lowercase letter!",0
pass_digit_err  BYTE "  ERROR: Password must contain at least one digit (0-9)!",0
pass_spec_err   BYTE "  ERROR: Password must contain at least one special character (!@#$%^&*)!",0
pass_rules      BYTE "  Password rules: 8-16 chars, uppercase, lowercase, digit, special char",0

; --- Menu strings
menu_border BYTE "  -----------------------------------------------------------------------",0
menu_1  BYTE "  | 1.  Add Student                                                     |",0
menu_2  BYTE "  | 2.  Display All Students                                            |",0
menu_3  BYTE "  | 3.  Generate Student Mess Bill                                      |",0
menu_4  BYTE "  | 4.  Add Staff Member                                                |",0
menu_5  BYTE "  | 5.  Display All Staff                                               |",0
menu_6  BYTE "  | 6.  View Warden Details                                             |",0
menu_7  BYTE "  | 7.  Show Staff Salary                                               |",0
menu_8  BYTE "  | 8.  Mark Monthly Attendance                                         |",0
menu_9  BYTE "  | 9.  View Attendance History                                         |",0
menu_10 BYTE "  | 10. Update Student Record                                           |",0
menu_11 BYTE "  | 11. Update Staff Record                                             |",0
menu_12 BYTE "  | 12. Summary (Total Students / Staff)                                |",0
menu_13 BYTE "  | 0.  Exit                                                            |",0
menu_prompt  BYTE "  Enter Your Choice: ",0
menu_invalid BYTE "  Invalid choice! Please enter a number from the menu.",0

; --- Student strings
stu_roll_str  BYTE "  Enter Roll No (e.g. 2024cs604) : ",0
stu_roll_err  BYTE "  ERROR: Format must be YYYYDDDnnn (4 digits, 2-3 letters, 3 digits)!",0
stu_dup_roll  BYTE "  ERROR: This roll number already exists!",0
stu_dept_str  BYTE "  Enter Department (letters only) : ",0
stu_dept_err  BYTE "  ERROR: Department must contain alphabets only!",0
stu_sess_str  BYTE "  Enter Session Year (1990-2030)  : ",0
stu_name_str  BYTE "  Enter Student Name (letters)   : ",0
stu_name_err  BYTE "  ERROR: Name must contain alphabets and spaces only!",0
stu_age_str   BYTE "  Enter Student Age (18-40)      : ",0
stu_age_err   BYTE "  ERROR: Age must be 18 to 40 for students!",0
stu_full_str  BYTE "  Hostel is full. Cannot add more students.",0
stu_nodata    BYTE "  No student records found.",0
stu_notfound  BYTE "  Student not found.",0
stu_added     BYTE "  Student added successfully!",0

; --- Student display labels
lbl_roll BYTE "  Roll No    : ",0
lbl_dept BYTE "  Department : ",0
lbl_sess BYTE "  Session    : ",0
lbl_name BYTE "  Name       : ",0
lbl_age  BYTE "  Age        : ",0
sep_line BYTE "  -------------------------------------------",0

; --- Attendance strings
att_month_str  BYTE "  Enter Month Number (1-12)  : ",0
att_days_str   BYTE "  Enter Days Present (0-XX)  : ",0
att_max_str    BYTE "  (Max days this month: ",0
att_max_end    BYTE ")",0
att_month_err  BYTE "  ERROR: Month must be 1 to 12!",0
att_days_err   BYTE "  ERROR: Days exceed the maximum for this month!",0
att_roll_str   BYTE "  Enter Roll Number          : ",0
att_his_str    BYTE "  Attendance History - Roll  : ",0
att_month_lbl  BYTE "  Month ",0
att_days_lbl   BYTE "   : ",0
att_updated    BYTE "  Attendance marked successfully!",0

; --- Month days table (Jan=31, Feb=28, Mar=31, Apr=30, May=31, Jun=30,
;                        Jul=31, Aug=31, Sep=30, Oct=31, Nov=30, Dec=31)
month_days DWORD 31,28,31,30,31,30,31,31,30,31,30,31

; --- Month names for display
month_names BYTE "Jan",0,"Feb",0,"Mar",0,"Apr",0,"May",0,"Jun",0
            BYTE "Jul",0,"Aug",0,"Sep",0,"Oct",0,"Nov",0,"Dec",0

; --- Bill strings
bill_roll_str BYTE "  Enter Roll Number for Bill : ",0
bill_rate     DWORD 200
bill_result   BYTE "  Total Mess Bill : Rs. ",0

; --- Staff job menu
sta_job_menu  BYTE "  Select Job:",0
sta_job_m1    BYTE "  1. Cook          (Rs.50/hr)",0
sta_job_m2    BYTE "  2. Guard         (Rs.20/hr)",0
sta_job_m3    BYTE "  3. Munshi        (Rs.10/hr)",0
sta_job_m4    BYTE "  4. Mess Boy      (Rs.30/hr)",0
sta_job_m5    BYTE "  5. Dish Washer   (Rs.20/hr)",0
sta_job_m6    BYTE "  6. Sweeper       (Rs.10/hr)",0
sta_job_pmt   BYTE "  Enter choice (1-6): ",0
sta_job_err   BYTE "  ERROR: Select a valid job number (1-6)!",0

; --- Job name strings (stored into struct)
job_cook   BYTE "Cook",0
job_guard  BYTE "Guard",0
job_munshi BYTE "Munshi",0
job_messboy BYTE "Mess Boy",0
job_dish   BYTE "Dish Washer",0
job_sweep  BYTE "Sweeper",0

; --- Per-job hourly rates
rate_cook   DWORD 50
rate_guard  DWORD 20
rate_munshi DWORD 10
rate_messboy DWORD 30
rate_dish   DWORD 20
rate_sweep  DWORD 10

; --- Staff input strings
sta_name_str  BYTE "  Enter Staff Name (letters only)   : ",0
sta_name_err  BYTE "  ERROR: Name must contain alphabets and spaces only!",0
sta_gen_str   BYTE "  Enter Gender (Male / Female)      : ",0
sta_gen_err   BYTE "  ERROR: Only 'Male' or 'Female' accepted!",0
sta_age_str   BYTE "  Enter Staff Age (18-60)           : ",0
sta_age_err   BYTE "  ERROR: Age must be 18 to 60 for staff!",0
sta_hrs_str   BYTE "  Enter Hours Worked (max 312)      : ",0
sta_hrs_err   BYTE "  ERROR: Working hours cannot exceed 312!",0
sta_sal_str   BYTE "  Calculated Salary : Rs. ",0
sta_full_str  BYTE "  Staff limit reached. Cannot add more.",0
sta_nodata    BYTE "  No staff records found.",0
sta_notfound  BYTE "  Staff member not found.",0
sta_added     BYTE "  Staff member added successfully!",0
sta_find_job  BYTE "  Enter Job to search : ",0
sta_find_name BYTE "  Enter Name to search: ",0

; --- gender comparison strings
str_male   BYTE "Male",0
str_female BYTE "Female",0

; --- Staff display labels
slbl_job  BYTE "  Job        : ",0
slbl_name BYTE "  Name       : ",0
slbl_gen  BYTE "  Gender     : ",0
slbl_age  BYTE "  Age        : ",0
slbl_hrs  BYTE "  Hours/Month: ",0
slbl_sal  BYTE "  Salary     : Rs. ",0

; --- Update strings
upd_roll_str  BYTE "  Enter Roll Number of student to update: ",0
upd_field_str BYTE "  Which field to update?",0
upd_opt1      BYTE "  1. Department",0
upd_opt2      BYTE "  2. Session",0
upd_opt3      BYTE "  3. Name",0
upd_opt4      BYTE "  4. Age",0
upd_choice    BYTE "  Enter choice: ",0
upd_done      BYTE "  Record updated successfully!",0
upd_staff_job BYTE "  Enter Job of staff to update  : ",0
upd_staff_nm  BYTE "  Enter Name of staff to update : ",0
upd_stf_opt1  BYTE "  1. Job Title",0
upd_stf_opt2  BYTE "  2. Name",0
upd_stf_opt3  BYTE "  3. Gender",0
upd_stf_opt4  BYTE "  4. Age",0
upd_stf_opt5  BYTE "  5. Hours Worked",0
upd_new_val   BYTE "  Enter new value: ",0

; --- Warden record
warden_record warden <"Usman Ali", 1001, "0332-2222074", 3, "PK-HBL-00123">
wlbl_name  BYTE "  Warden Name    : ",0
wlbl_id    BYTE "  Warden ID      : ",0
wlbl_phone BYTE "  Phone Number   : ",0
wlbl_room  BYTE "  Room Number    : ",0
wlbl_acc   BYTE "  Account Number : ",0

; --- Summary
sum_stu_str BYTE "  Total Students Registered : ",0
sum_sta_str BYTE "  Total Staff   Registered  : ",0

; --- Generic
press_key BYTE "  Press ENTER to return to menu...",0

; --- Arrays
student_arr   student max_student DUP(<>)
student_count DWORD 0

staff_arr   staff max_staff DUP(<>)
staff_count DWORD 0

; --- Search buffers
search_job  BYTE 15 DUP(0)
search_name BYTE 30 DUP(0)

; --- Pre-loaded staff (valid jobs, corrected rates)
init_guard  staff <"Guard",    "Iqbal",  "Male",   46, 84, 1680>
init_cook   staff <"Cook",     "Anees",  "Male",   40, 80, 4000>
init_sweep  staff <"Sweeper",  "Meesum", "Male",   28, 56,  560>
init_mess   staff <"Mess Boy", "Tariq",  "Male",   30, 96, 2880>

; --- Temp buffers
roll_input  BYTE 14 DUP(0)
temp_str    BYTE 30 DUP(0)
temp_dword  DWORD 0
job_rate    DWORD 0          ; rate for currently selected job

; --- Banner
banner0 BYTE "  ====================================================",0
banner1 BYTE "        HOSTEL MANAGEMENT SYSTEM  v3.0",0
banner2 BYTE "  ====================================================",0

; ============================================================
;  .CODE
; ============================================================
.code

; ############################################################
;  MAIN
; ############################################################
main PROC
    call AdminLogin
    call InitStaff
    call ClrScr

MainMenuLoop:
    call ClrScr
    call ShowMenu

    mov edx, OFFSET menu_prompt
    call WriteString
    call ReadInt
    mov temp_dword, eax

    .IF eax == 1
        call AddStudent
    .ELSEIF eax == 2
        call DisplayAllStudents
    .ELSEIF eax == 3
        call ShowMessBill
    .ELSEIF eax == 4
        call AddStaff
    .ELSEIF eax == 5
        call DisplayAllStaff
    .ELSEIF eax == 6
        call ShowWarden
    .ELSEIF eax == 7
        call ShowStaffSalary
    .ELSEIF eax == 8
        call MarkAttendance
    .ELSEIF eax == 9
        call ViewAttendanceHistory
    .ELSEIF eax == 10
        call UpdateStudent
    .ELSEIF eax == 11
        call UpdateStaff
    .ELSEIF eax == 12
        call ShowSummary
    .ELSEIF eax == 0
        jmp ExitProgram
    .ELSE
        call crlf
        mov eax, 12
        call SetTextColor
        mov edx, OFFSET menu_invalid
        call WriteString
        call crlf
        mov eax, white
        call SetTextColor
        call PauseForUser
    .ENDIF
    jmp MainMenuLoop

ExitProgram:
    INVOKE ExitProcess, 0
main ENDP

; ############################################################
;  ShowMenu
; ############################################################
ShowMenu PROC uses eax edx
    call crlf
    mov edx, OFFSET banner0
    call WriteString
    call crlf
    mov edx, OFFSET banner1
    call WriteString
    call crlf
    mov edx, OFFSET banner2
    call WriteString
    call crlf
    call crlf
    mov edx, OFFSET menu_border
    call WriteString
    call crlf
    mov edx, OFFSET menu_1
    call WriteString
    call crlf
    mov edx, OFFSET menu_2
    call WriteString
    call crlf
    mov edx, OFFSET menu_3
    call WriteString
    call crlf
    mov edx, OFFSET menu_4
    call WriteString
    call crlf
    mov edx, OFFSET menu_5
    call WriteString
    call crlf
    mov edx, OFFSET menu_6
    call WriteString
    call crlf
    mov edx, OFFSET menu_7
    call WriteString
    call crlf
    mov edx, OFFSET menu_8
    call WriteString
    call crlf
    mov edx, OFFSET menu_9
    call WriteString
    call crlf
    mov edx, OFFSET menu_10
    call WriteString
    call crlf
    mov edx, OFFSET menu_11
    call WriteString
    call crlf
    mov edx, OFFSET menu_12
    call WriteString
    call crlf
    mov edx, OFFSET menu_13
    call WriteString
    call crlf
    mov edx, OFFSET menu_border
    call WriteString
    call crlf
    call crlf
    ret
ShowMenu ENDP

; ############################################################
;  PauseForUser
; ############################################################
PauseForUser PROC uses eax edx
    call crlf
    mov edx, OFFSET press_key
    call WriteString
    call ReadChar
    call ReadChar
    ret
PauseForUser ENDP

; ############################################################
;  ErrMsg  - print red message, restore white
;  EDX must point to string before call
; ############################################################
ErrMsg PROC uses eax
    push edx
    call crlf
    mov eax, 12
    call SetTextColor
    pop edx
    call WriteString
    call crlf
    mov eax, white
    call SetTextColor
    ret
ErrMsg ENDP

; ############################################################
;  OkMsg  - print green message
; ############################################################
OkMsg PROC uses eax
    push edx
    call crlf
    mov eax, 0Ah
    call SetTextColor
    pop edx
    call WriteString
    call crlf
    mov eax, white
    call SetTextColor
    ret
OkMsg ENDP

; ############################################################
;  InitStaff  - copy 4 pre-loaded entries into staffArr
; ############################################################
InitStaff PROC uses esi edi ecx
    mov edi, OFFSET staff_arr

    mov esi, OFFSET init_guard
    mov ecx, SIZEOF staff
    rep movsb

    mov esi, OFFSET init_cook
    mov ecx, SIZEOF staff
    rep movsb

    mov esi, OFFSET init_sweep
    mov ecx, SIZEOF staff
    rep movsb

    mov esi, OFFSET init_mess
    mov ecx, SIZEOF staff
    rep movsb

    mov staff_count, 4
    ret
InitStaff ENDP

; ############################################################
;  StrCmp  ESI vs EDI, up to 30 chars. EAX=0 equal, 1 not.
; ############################################################
StrCmp PROC uses esi edi ecx ebx
    mov ecx, 30
SC_loop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne SC_ne
    cmp al, 0
    je  SC_eq
    inc esi
    inc edi
    dec ecx
    jnz NEAR PTR SC_loop
SC_eq:
    xor eax, eax
    ret
SC_ne:
    mov eax, 1
    ret
StrCmp ENDP

; ############################################################
;  StrLen  - ESI points to string, returns length in ECX
; ############################################################
StrLen PROC uses esi
    xor ecx, ecx
SL_loop:
    mov al, [esi]
    cmp al, 0
    je  SL_done
    inc ecx
    inc esi
    jmp SL_loop
SL_done:
    ret
StrLen ENDP

; ############################################################
;  CopyStr - copy from ESI to EDI (up to 30 chars incl null)
; ############################################################
CopyStr PROC uses esi edi ecx
    mov ecx, 30
CS_loop:
    mov al, [esi]
    mov [edi], al
    cmp al, 0
    je  CS_done
    inc esi
    inc edi
    dec ecx
    jnz NEAR PTR CS_loop
CS_done:
    ret
CopyStr ENDP

; ############################################################
;  IsAllAlpha  - ESI points to string
;  Returns EAX=1 if all chars are letters or spaces, else 0
;  Empty string returns 0
; ############################################################
IsAllAlpha PROC uses esi ecx ebx
    xor ecx, ecx          ; char count
IAA_loop:
    mov al, [esi]
    cmp al, 0
    je  IAA_end
    cmp al, ' '
    je  IAA_ok
    cmp al, 'A'
    jl  IAA_fail
    cmp al, 'Z'
    jle IAA_ok
    cmp al, 'a'
    jl  IAA_fail
    cmp al, 'z'
    jle IAA_ok
    jmp IAA_fail
IAA_ok:
    inc ecx
    inc esi
    jmp IAA_loop
IAA_end:
    cmp ecx, 0
    je  IAA_fail
    mov eax, 1
    ret
IAA_fail:
    xor eax, eax
    ret
IsAllAlpha ENDP

; ############################################################
;  ValidateRoll - ESI points to roll_input buffer
;  Format: 4 digits, 2-3 letters, 3 digits  e.g. 2024cs604
;  Returns EAX=1 valid, EAX=0 invalid
; ############################################################
ValidateRoll PROC uses esi ecx ebx
    ; -- count total length first
    push esi
    call StrLen       ; ECX = length
    pop  esi
    ; total length = 4+2+3=9 (min) or 4+3+3=10 (max)
    cmp ecx, 9
    jl  VR_fail
    cmp ecx, 10
    jg  VR_fail

    ; -- first 4 must be digits
    mov ecx, 4
VR_dig1:
    mov al, [esi]
    cmp al, '0'
    jl  VR_fail
    cmp al, '9'
    jg  VR_fail
    inc esi
    dec ecx
    jnz NEAR PTR VR_dig1

    ; -- next 2 or 3 must be letters (lowercase)
    mov ecx, 0
VR_alpha:
    mov al, [esi]
    cmp al, 'a'
    jl  VR_alpha_end
    cmp al, 'z'
    jg  VR_alpha_end
    inc ecx
    inc esi
    jmp VR_alpha
VR_alpha_end:
    cmp ecx, 2
    jl  VR_fail
    cmp ecx, 3
    jg  VR_fail

    ; -- last 3 must be digits
    mov ecx, 3
VR_dig2:
    mov al, [esi]
    cmp al, '0'
    jl  VR_fail
    cmp al, '9'
    jg  VR_fail
    inc esi
    dec ecx
    jnz NEAR PTR VR_dig2

    ; -- must be at null now
    mov al, [esi]
    cmp al, 0
    jne VR_fail

    mov eax, 1
    ret
VR_fail:
    xor eax, eax
    ret
ValidateRoll ENDP

; ############################################################
;  CheckDupRollStr - compare roll_input vs all stored rolls
;  Returns ZF=1 if duplicate
; ############################################################
CheckDupRollStr PROC uses esi edi ecx
    mov ecx, student_count
    cmp ecx, 0
    je  CDRS_unique
    mov esi, OFFSET student_arr
CDRS_loop:
    push ecx
    push esi
    mov edi, esi           ; EDI = student.roll_str
    mov esi, OFFSET roll_input
    call StrCmp
    pop  esi
    pop  ecx
    cmp  eax, 0
    je   CDRS_found
    add  esi, SIZEOF student
    dec  ecx
    jnz  NEAR PTR CDRS_loop
CDRS_unique:
    or   eax, 1            ; clear ZF
    ret
CDRS_found:
    xor  eax, eax          ; set ZF
    ret
CheckDupRollStr ENDP

; ############################################################
;  ValidatePassword - EDX points to password string
;  Checks: length 8-16, has upper, lower, digit, special
;  Returns EAX=1 valid, EAX=0 invalid (also prints which rule failed)
; ############################################################
ValidatePassword PROC uses esi ecx ebx
    mov esi, edx

    ; -- length check
    push esi
    call StrLen        ; ECX = length
    pop  esi
    cmp ecx, 8
    jl  VP_len_err
    cmp ecx, 16
    jg  VP_len_err
    jmp VP_check_chars

VP_len_err:
    mov edx, OFFSET pass_len_err
    call ErrMsg
    xor eax, eax
    ret

VP_check_chars:
    ; scan once, track flags in EBX bits:
    ; bit0=hasUpper, bit1=hasLower, bit2=hasDigit, bit3=hasSpecial
    xor ebx, ebx
VP_scan:
    mov al, [esi]
    cmp al, 0
    je  VP_done_scan
    cmp al, 'A'
    jl  VP_not_upper
    cmp al, 'Z'
    jg  VP_not_upper
    or  ebx, 1
    jmp VP_next
VP_not_upper:
    cmp al, 'a'
    jl  VP_not_lower
    cmp al, 'z'
    jg  VP_not_lower
    or  ebx, 2
    jmp VP_next
VP_not_lower:
    cmp al, '0'
    jl  VP_not_digit
    cmp al, '9'
    jg  VP_not_digit
    or  ebx, 4
    jmp VP_next
VP_not_digit:
    ; special chars: !@#$%^&*()-_=+
    cmp al, '!'
    je  VP_is_spec
    cmp al, '@'
    je  VP_is_spec
    cmp al, '#'
    je  VP_is_spec
    cmp al, '$'
    je  VP_is_spec
    cmp al, '%'
    je  VP_is_spec
    cmp al, '^'
    je  VP_is_spec
    cmp al, '&'
    je  VP_is_spec
    cmp al, '*'
    je  VP_is_spec
    cmp al, '-'
    je  VP_is_spec
    cmp al, '_'
    je  VP_is_spec
    jmp VP_next
VP_is_spec:
    or  ebx, 8
VP_next:
    inc esi
    jmp VP_scan

VP_done_scan:
    test ebx, 1
    jz   VP_no_upper
    test ebx, 2
    jz   VP_no_lower
    test ebx, 4
    jz   VP_no_digit
    test ebx, 8
    jz   VP_no_spec
    mov  eax, 1
    ret

VP_no_upper:
    mov edx, OFFSET pass_upper_err
    call ErrMsg
    xor eax, eax
    ret
VP_no_lower:
    mov edx, OFFSET pass_lower_err
    call ErrMsg
    xor eax, eax
    ret
VP_no_digit:
    mov edx, OFFSET pass_digit_err
    call ErrMsg
    xor eax, eax
    ret
VP_no_spec:
    mov edx, OFFSET pass_spec_err
    call ErrMsg
    xor eax, eax
    ret
ValidatePassword ENDP

; ############################################################
;  AdminLogin
; ############################################################
AdminLogin PROC uses eax ebx ecx edx esi edi

AL_retry:
    call ClrScr
    call crlf
    mov edx, OFFSET login_banner1
    call WriteString
    call crlf
    mov edx, OFFSET login_banner2
    call WriteString
    call crlf
    mov edx, OFFSET login_banner3
    call WriteString
    call crlf
    call crlf
    mov edx, OFFSET pass_rules
    call WriteString
    call crlf
    call crlf

    mov edx, OFFSET login_user_str
    call WriteString
    lea edx, input_username
    mov ecx, 29
    call ReadString

    mov edx, OFFSET login_pass_str
    call WriteString
    lea edx, input_password
    mov ecx, 17
    call ReadString

    ; Validate password complexity first
    lea edx, input_password
    call ValidatePassword
    cmp eax, 1
    jne AL_retry

    ; Compare username
    mov esi, OFFSET input_username
    mov edi, OFFSET admin_username
    call StrCmp
    cmp eax, 0
    jne AL_fail

    ; Compare password
    mov esi, OFFSET input_password
    mov edi, OFFSET admin_password
    call StrCmp
    cmp eax, 0
    jne AL_fail

    ; Success
    mov edx, OFFSET login_success
    call OkMsg
    call PauseForUser
    ret

AL_fail:
    inc login_attempts
    mov edx, OFFSET login_fail
    call ErrMsg
    cmp login_attempts, 3
    jl  AL_retry

    mov edx, OFFSET login_locked
    call ErrMsg
    INVOKE ExitProcess, 1

AdminLogin ENDP

; ############################################################
;  AddStudent
; ############################################################
AddStudent PROC uses esi eax edx ecx ebx
    call ClrScr

    mov eax, student_count
    cmp eax, max_student
    jl  AStud_space
    mov edx, OFFSET stu_full_str
    call ErrMsg
    call PauseForUser
    ret

AStud_space:
    mov esi, OFFSET student_arr
    mov eax, SIZEOF student
    mov ebx, student_count
    mul ebx
    add esi, eax
    call crlf

    ; ---- Roll Number (format: 2024cs604) ----
AStud_roll:
    mov edx, OFFSET stu_roll_str
    call WriteString
    lea edx, roll_input
    mov ecx, 12
    call ReadString

    ; validate format
    lea esi, roll_input
    call ValidateRoll
    cmp eax, 1
    jne AStud_roll_fmt_err

    ; check duplicate
    call CheckDupRollStr
    jz  AStud_roll_dup

    ; copy roll_input into student.roll_str (offset 0)
    lea esi, roll_input
    lea edi, [esi + 0]      ; ESI=source
    push esi
    mov esi, OFFSET roll_input
    lea edi, [esp + 4]      ; trick: just use CopyStr with proper args
    pop esi
    ; simpler: use rep movsb
    lea esi, roll_input
    lea edi, [eax]          ; EAX is garbage here; recalc slot
    ; recalc slot into EDI properly
    mov edi, OFFSET student_arr
    mov eax, SIZEOF student
    mov ebx, student_count
    mul ebx
    add edi, eax            ; EDI = slot
    mov esi, OFFSET roll_input
    mov ecx, 12
    rep movsb
    ; reload esi to slot start
    mov esi, OFFSET student_arr
    mov eax, SIZEOF student
    mov ebx, student_count
    mul ebx
    add esi, eax
    jmp AStud_dept

AStud_roll_fmt_err:
    mov edx, OFFSET stu_roll_err
    call ErrMsg
    jmp AStud_roll

AStud_roll_dup:
    mov edx, OFFSET stu_dup_roll
    call ErrMsg
    jmp AStud_roll

    ; ---- Department (letters only) ----
AStud_dept:
    mov edx, OFFSET stu_dept_str
    call WriteString
    lea edx, [esi + 12]        ; department offset 12
    mov ecx, 20
    call ReadString
    lea esi, [esi]             ; keep esi
    lea edx, [esi + 12]
    push esi
    mov esi, edx
    call IsAllAlpha
    pop esi
    cmp eax, 1
    jne AStud_dept_err
    jmp AStud_sess

AStud_dept_err:
    mov edx, OFFSET stu_dept_err
    call ErrMsg
    jmp AStud_dept

    ; ---- Session Year ----
AStud_sess:
    mov edx, OFFSET stu_sess_str
    call WriteString
    call ReadDec
    cmp eax, 1990
    jl  AStud_sess
    cmp eax, 2030
    jg  AStud_sess
    mov [esi + 33], eax        ; session offset 33

    ; ---- Name (letters + spaces) ----
AStud_name:
    mov edx, OFFSET stu_name_str
    call WriteString
    lea edx, [esi + 37]        ; name offset 37
    mov ecx, 29
    call ReadString
    push esi
    lea esi, [esi + 37]
    call IsAllAlpha
    pop esi
    cmp eax, 1
    jne AStud_name_err
    jmp AStud_age

AStud_name_err:
    mov edx, OFFSET stu_name_err
    call ErrMsg
    jmp AStud_name

    ; ---- Age 18-40 ----
AStud_age:
    mov edx, OFFSET stu_age_str
    call WriteString
    call ReadDec
    cmp eax, 18
    jl  AStud_age_bad
    cmp eax, 40
    jg  AStud_age_bad
    mov [esi + 67], eax        ; age offset 67
    jmp AStud_done

AStud_age_bad:
    mov edx, OFFSET stu_age_err
    call ErrMsg
    jmp AStud_age

AStud_done:
    lea edi, [esi + 71]        ; monthly_att offset 71
    mov ecx, NUM_MONTHS
    xor eax, eax
    rep stosd
    mov DWORD PTR [esi + 119], 0   ; bill offset 119
    inc student_count
    mov edx, OFFSET stu_added
    call OkMsg
    call PauseForUser
    ret

AddStudent ENDP

; ############################################################
;  CheckDupRollStr helper used inside AddStudent (standalone)
; ############################################################

; ############################################################
;  DisplayAllStudents
; ############################################################
DisplayAllStudents PROC uses esi ecx edx eax
    call ClrScr
    call crlf

    mov ecx, student_count
    cmp ecx, 0
    je  DAS_none

    mov esi, OFFSET student_arr
DAS_loop:
    push ecx
    mov edx, OFFSET sep_line
    call WriteString
    call crlf

    mov edx, OFFSET lbl_roll
    call WriteString
    lea edx, [esi + 0]         ; roll_str offset 0
    call WriteString
    call crlf

    mov edx, OFFSET lbl_dept
    call WriteString
    lea edx, [esi + 12]
    call WriteString
    call crlf

    mov edx, OFFSET lbl_sess
    call WriteString
    mov eax, [esi + 33]
    call WriteDec
    call crlf

    mov edx, OFFSET lbl_name
    call WriteString
    lea edx, [esi + 37]
    call WriteString
    call crlf

    mov edx, OFFSET lbl_age
    call WriteString
    mov eax, [esi + 67]
    call WriteDec
    call crlf

    add esi, SIZEOF student
    pop ecx
    dec ecx
    jnz NEAR PTR DAS_loop
    call crlf
    call PauseForUser
    ret

DAS_none:
    mov edx, OFFSET stu_nodata
    call WriteString
    call crlf
    call PauseForUser
    ret
DisplayAllStudents ENDP

; ############################################################
;  ShowMessBill
; ############################################################
ShowMessBill PROC uses esi ecx edx eax ebx edi
    call ClrScr
    call crlf

    mov ecx, student_count
    cmp ecx, 0
    je  SMB_none

    mov edx, OFFSET bill_roll_str
    call WriteString
    lea edx, roll_input
    mov ecx, 12
    call ReadString

    mov esi, OFFSET student_arr
    mov ecx, student_count
SMB_loop:
    push ecx
    push esi
    mov edi, esi
    mov esi, OFFSET roll_input
    mov ecx, 12
SMB_cmp:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne SMB_no
    cmp al, 0
    je  SMB_yes
    inc esi
    inc edi
    dec ecx
    jnz NEAR PTR SMB_cmp
SMB_yes:
    pop esi
    pop ecx
    jmp SMB_found
SMB_no:
    pop esi
    pop ecx
    add esi, SIZEOF student
    dec ecx
    jnz NEAR PTR SMB_loop

    mov edx, OFFSET stu_notfound
    call ErrMsg
    call PauseForUser
    ret

SMB_found:
    lea edi, [esi + 71]   ; monthly_att
    xor eax, eax
    xor ecx, ecx
SMB_sum:
    add eax, [edi + ecx*4]
    inc ecx
    cmp ecx, NUM_MONTHS
    jl  SMB_sum
    mov ebx, bill_rate
    mul ebx
    mov [esi + 119], eax

    call crlf
    mov edx, OFFSET lbl_roll
    call WriteString
    lea edx, [esi + 0]
    call WriteString
    call crlf
    mov edx, OFFSET lbl_name
    call WriteString
    lea edx, [esi + 37]
    call WriteString
    call crlf
    mov edx, OFFSET bill_result
    call WriteString
    mov eax, [esi + 119]
    call WriteDec
    call crlf
    call PauseForUser
    ret

SMB_none:
    mov edx, OFFSET stu_nodata
    call WriteString
    call crlf
    call PauseForUser
    ret
ShowMessBill ENDP

; ############################################################
;  AddStaff  - job chosen from menu, name/gender validated,
;              hours max 312, salary by job type
; ############################################################
AddStaff PROC uses esi eax edx ecx ebx
    call ClrScr

    mov eax, staff_count
    cmp eax, max_staff
    jl  AStaf_space
    mov edx, OFFSET sta_full_str
    call ErrMsg
    call PauseForUser
    ret

AStaf_space:
    mov esi, OFFSET staff_arr
    mov eax, SIZEOF staff
    mov ebx, staff_count
    mul ebx
    add esi, eax
    call crlf

    ; ---- Job (menu choice) ----
AStaf_job:
    mov edx, OFFSET sta_job_menu
    call WriteString
    call crlf
    mov edx, OFFSET sta_job_m1
    call WriteString
    call crlf
    mov edx, OFFSET sta_job_m2
    call WriteString
    call crlf
    mov edx, OFFSET sta_job_m3
    call WriteString
    call crlf
    mov edx, OFFSET sta_job_m4
    call WriteString
    call crlf
    mov edx, OFFSET sta_job_m5
    call WriteString
    call crlf
    mov edx, OFFSET sta_job_m6
    call WriteString
    call crlf
    mov edx, OFFSET sta_job_pmt
    call WriteString
    call ReadDec

    .IF eax == 1
        mov edi, esi
        push esi
        mov esi, OFFSET job_cook
        call CopyStr        ; copies esi->edi (job offset 0)
        pop  esi
        mov eax, rate_cook
        mov job_rate, eax
    .ELSEIF eax == 2
        mov edi, esi
        push esi
        mov esi, OFFSET job_guard
        call CopyStr
        pop  esi
        mov eax, rate_guard
        mov job_rate, eax
    .ELSEIF eax == 3
        mov edi, esi
        push esi
        mov esi, OFFSET job_munshi
        call CopyStr
        pop  esi
        mov eax, rate_munshi
        mov job_rate, eax
    .ELSEIF eax == 4
        mov edi, esi
        push esi
        mov esi, OFFSET job_messboy
        call CopyStr
        pop  esi
        mov eax, rate_messboy
        mov job_rate, eax
    .ELSEIF eax == 5
        mov edi, esi
        push esi
        mov esi, OFFSET job_dish
        call CopyStr
        pop  esi
        mov eax, rate_dish
        mov job_rate, eax
    .ELSEIF eax == 6
        mov edi, esi
        push esi
        mov esi, OFFSET job_sweep
        call CopyStr
        pop  esi
        mov eax, rate_sweep
        mov job_rate, eax
    .ELSE
        mov edx, OFFSET sta_job_err
        call ErrMsg
        jmp AStaf_job
    .ENDIF

    ; ---- Name (letters only) ----
AStaf_name:
    mov edx, OFFSET sta_name_str
    call WriteString
    lea edx, [esi + 15]        ; name1 offset 15
    mov ecx, 29
    call ReadString
    push esi
    lea esi, [esi + 15]
    call IsAllAlpha
    pop esi
    cmp eax, 1
    jne AStaf_name_err
    jmp AStaf_gen

AStaf_name_err:
    mov edx, OFFSET sta_name_err
    call ErrMsg
    jmp AStaf_name

    ; ---- Gender (Male / Female only) ----
AStaf_gen:
    mov edx, OFFSET sta_gen_str
    call WriteString
    lea edx, [esi + 45]        ; gender offset 45
    mov ecx, 9
    call ReadString

    ; compare to "Male"
    push esi
    lea esi, [esi + 45]
    mov edi, OFFSET str_male
    call StrCmp
    pop esi
    cmp eax, 0
    je  AStaf_gen_ok

    push esi
    lea esi, [esi + 45]
    mov edi, OFFSET str_female
    call StrCmp
    pop esi
    cmp eax, 0
    je  AStaf_gen_ok

    mov edx, OFFSET sta_gen_err
    call ErrMsg
    jmp AStaf_gen

AStaf_gen_ok:
    ; ---- Age 18-60 ----
AStaf_age:
    mov edx, OFFSET sta_age_str
    call WriteString
    call ReadDec
    cmp eax, 18
    jl  AStaf_age_bad
    cmp eax, 60
    jg  AStaf_age_bad
    mov [esi + 55], eax        ; Age offset 55
    jmp AStaf_hrs

AStaf_age_bad:
    mov edx, OFFSET sta_age_err
    call ErrMsg
    jmp AStaf_age

    ; ---- Hours (max 312) ----
AStaf_hrs:
    mov edx, OFFSET sta_hrs_str
    call WriteString
    call ReadDec
    cmp eax, 0
    je  AStaf_hrs_bad
    cmp eax, 312
    jg  AStaf_hrs_bad
    mov [esi + 59], eax        ; total_hours offset 59

    ; Salary = hours * job_rate
    mov ebx, job_rate
    mul ebx
    mov [esi + 63], eax        ; TotalSalary offset 63

    call crlf
    mov edx, OFFSET sta_sal_str
    call WriteString
    mov eax, [esi + 63]
    call WriteDec
    call crlf

    inc staff_count
    mov edx, OFFSET sta_added
    call OkMsg
    call PauseForUser
    ret

AStaf_hrs_bad:
    mov edx, OFFSET sta_hrs_err
    call ErrMsg
    jmp AStaf_hrs

AddStaff ENDP

; ############################################################
;  DisplayAllStaff
; ############################################################
DisplayAllStaff PROC uses esi ecx edx eax
    call ClrScr
    call crlf

    mov ecx, staff_count
    cmp ecx, 0
    je  DASf_none

    mov esi, OFFSET staff_arr
DASf_loop:
    push ecx
    mov edx, OFFSET sep_line
    call WriteString
    call crlf

    mov edx, OFFSET slbl_job
    call WriteString
    lea edx, [esi + 0]
    call WriteString
    call crlf

    mov edx, OFFSET slbl_name
    call WriteString
    lea edx, [esi + 15]
    call WriteString
    call crlf

    mov edx, OFFSET slbl_gen
    call WriteString
    lea edx, [esi + 45]
    call WriteString
    call crlf

    mov edx, OFFSET slbl_age
    call WriteString
    mov eax, [esi + 55]
    call WriteDec
    call crlf

    mov edx, OFFSET slbl_hrs
    call WriteString
    mov eax, [esi + 59]
    call WriteDec
    call crlf

    mov edx, OFFSET slbl_sal
    call WriteString
    mov eax, [esi + 63]
    call WriteDec
    call crlf

    add esi, SIZEOF staff
    pop ecx
    dec ecx
    jnz NEAR PTR DASf_loop
    call crlf
    call PauseForUser
    ret

DASf_none:
    mov edx, OFFSET sta_nodata
    call WriteString
    call crlf
    call PauseForUser
    ret
DisplayAllStaff ENDP

; ############################################################
;  ShowWarden
; ############################################################
ShowWarden PROC uses eax edx
    call ClrScr
    call crlf
    mov edx, OFFSET sep_line
    call WriteString
    call crlf
    mov edx, OFFSET wlbl_name
    call WriteString
    lea edx, warden_record
    call WriteString
    call crlf
    mov edx, OFFSET wlbl_id
    call WriteString
    mov eax, warden_record.wid
    call WriteDec
    call crlf
    mov edx, OFFSET wlbl_phone
    call WriteString
    lea edx, warden_record.pnumber
    call WriteString
    call crlf
    mov edx, OFFSET wlbl_room
    call WriteString
    mov eax, warden_record.roomno
    call WriteDec
    call crlf
    mov edx, OFFSET wlbl_acc
    call WriteString
    lea edx, warden_record.accountno
    call WriteString
    call crlf
    call crlf
    call PauseForUser
    ret
ShowWarden ENDP

; ############################################################
;  ShowStaffSalary
; ############################################################
ShowStaffSalary PROC uses esi edi ecx edx eax ebx
    call ClrScr
    call crlf

    mov ecx, staff_count
    cmp ecx, 0
    je  SSS_none

    mov edx, OFFSET sta_find_job
    call WriteString
    lea edx, search_job
    mov ecx, 14
    call ReadString

    mov edx, OFFSET sta_find_name
    call WriteString
    lea edx, search_name
    mov ecx, 29
    call ReadString

    mov ecx, staff_count
    mov esi, OFFSET staff_arr

SSS_loop:
    push ecx
    lea edi, [esi + 0]
    push esi
    mov esi, OFFSET search_job
    call StrCmp
    pop esi
    cmp eax, 0
    jne SSS_next

    lea edi, [esi + 15]
    push esi
    mov esi, OFFSET search_name
    call StrCmp
    pop esi
    cmp eax, 0
    jne SSS_next

    ; Found
AStaf_hrs2:
    mov edx, OFFSET sta_hrs_str
    call WriteString
    call ReadDec
    cmp eax, 0
    je  AStaf_hrs2_bad
    cmp eax, 312
    jg  AStaf_hrs2_bad
    mov [esi + 59], eax

    ; Get job rate by comparing job string
    push esi
    mov esi, esi               ; job at offset 0
    mov edi, OFFSET job_cook
    call StrCmp
    pop esi
    cmp eax, 0
    je  SSS_rate_cook

    push esi
    mov edi, OFFSET job_guard
    lea esi, [esi + 0]
    call StrCmp
    pop esi
    cmp eax, 0
    je  SSS_rate_guard

    push esi
    mov edi, OFFSET job_munshi
    lea esi, [esi + 0]
    call StrCmp
    pop esi
    cmp eax, 0
    je  SSS_rate_munshi

    push esi
    mov edi, OFFSET job_messboy
    lea esi, [esi + 0]
    call StrCmp
    pop esi
    cmp eax, 0
    je  SSS_rate_messboy

    push esi
    mov edi, OFFSET job_dish
    lea esi, [esi + 0]
    call StrCmp
    pop esi
    cmp eax, 0
    je  SSS_rate_dish

    mov ebx, rate_sweep
    jmp SSS_do_sal

SSS_rate_cook:
    mov ebx, rate_cook
    jmp SSS_do_sal
SSS_rate_guard:
    mov ebx, rate_guard
    jmp SSS_do_sal
SSS_rate_munshi:
    mov ebx, rate_munshi
    jmp SSS_do_sal
SSS_rate_messboy:
    mov ebx, rate_messboy
    jmp SSS_do_sal
SSS_rate_dish:
    mov ebx, rate_dish

SSS_do_sal:
    mov eax, [esi + 59]
    mul ebx
    mov [esi + 63], eax

    call crlf
    mov edx, OFFSET sta_sal_str
    call WriteString
    mov eax, [esi + 63]
    call WriteDec
    call crlf
    call PauseForUser
    pop ecx
    ret

AStaf_hrs2_bad:
    mov edx, OFFSET sta_hrs_err
    call ErrMsg
    jmp AStaf_hrs2

SSS_next:
    add esi, SIZEOF staff
    pop ecx
    dec ecx
    jnz NEAR PTR SSS_loop

    mov edx, OFFSET sta_notfound
    call ErrMsg
    call PauseForUser
    ret

SSS_none:
    mov edx, OFFSET sta_nodata
    call WriteString
    call crlf
    call PauseForUser
    ret
ShowStaffSalary ENDP

; ############################################################
;  MarkAttendance  - days limited by actual month length
; ############################################################
MarkAttendance PROC uses esi ecx edx eax ebx edi
    call ClrScr
    call crlf

    mov ecx, student_count
    cmp ecx, 0
    je  MA_none

    mov edx, OFFSET att_roll_str
    call WriteString
    lea edx, roll_input
    mov ecx, 12
    call ReadString

    ; find student
    mov esi, OFFSET student_arr
    mov ecx, student_count
MA_find:
    push ecx
    push esi
    mov edi, esi
    mov esi, OFFSET roll_input
    call StrCmp
    pop  esi
    pop  ecx
    cmp  eax, 0
    je   MA_found
    add  esi, SIZEOF student
    dec  ecx
    jnz  NEAR PTR MA_find

    mov edx, OFFSET stu_notfound
    call ErrMsg
    call PauseForUser
    ret

MA_found:
MA_month:
    mov edx, OFFSET att_month_str
    call WriteString
    call ReadDec
    cmp eax, 1
    jl  MA_month_bad
    cmp eax, 12
    jg  MA_month_bad
    mov ebx, eax              ; ebx = month (1-based)

    ; look up max days for this month (ebx = month 1-based)
    lea edi, month_days
    mov ecx, ebx
    dec ecx                   ; 0-based index
    mov edx, [edi + ecx*4]    ; edx = max days for this month

    ; show max days hint  (edx = max_days throughout)
    push edx                  ; save max_days
    call crlf
    mov  edx, OFFSET att_max_str
    call WriteString
    pop  eax                  ; eax = max_days for WriteDec
    push eax                  ; keep on stack for MA_days
    call WriteDec
    mov  edx, OFFSET att_max_end
    call WriteString
    call crlf
    pop  edx                  ; edx = max_days  -> pass into MA_days

    jmp MA_days

MA_month_bad:
    mov edx, OFFSET att_month_err
    call ErrMsg
    jmp MA_month

MA_days:
    push edx                  ; save max days
    mov edx, OFFSET att_days_str
    call WriteString
    call ReadDec
    pop  edx                  ; edx = max days
    push eax                  ; save entered days
    ; validate: 0 <= entered <= max
    pop  eax
    push eax
    cmp  eax, 0
    jl   MA_days_bad
    cmp  eax, edx
    jg   MA_days_bad
    pop  eax                  ; entered days in eax

    ; store: monthly_att base = esi+71, index = ebx-1
    lea edi, [esi + 71]
    dec ebx
    mov [edi + ebx*4], eax

    mov edx, OFFSET att_updated
    call OkMsg
    call PauseForUser
    ret

MA_days_bad:
    pop  eax                  ; clean stack
    mov edx, OFFSET att_days_err
    call ErrMsg
    ; reload max days from month_days
    lea edi, month_days
    mov eax, ebx              ; ebx still = month (1-based) since we didn't dec yet
    dec eax
    mov edx, [edi + eax*4]
    jmp MA_days

MA_none:
    mov edx, OFFSET stu_nodata
    call WriteString
    call crlf
    call PauseForUser
    ret
MarkAttendance ENDP

; ############################################################
;  ViewAttendanceHistory
; ############################################################
ViewAttendanceHistory PROC uses esi ecx edx eax ebx edi
    call ClrScr
    call crlf

    mov ecx, student_count
    cmp ecx, 0
    je  VAH_none

    mov edx, OFFSET att_roll_str
    call WriteString
    lea edx, roll_input
    mov ecx, 12
    call ReadString

    mov esi, OFFSET student_arr
    mov ecx, student_count
VAH_find:
    push ecx
    push esi
    mov edi, esi
    mov esi, OFFSET roll_input
    call StrCmp
    pop  esi
    pop  ecx
    cmp  eax, 0
    je   VAH_found
    add  esi, SIZEOF student
    dec  ecx
    jnz  NEAR PTR VAH_find

    mov edx, OFFSET stu_notfound
    call ErrMsg
    call PauseForUser
    ret

VAH_found:
    call crlf
    mov edx, OFFSET att_his_str
    call WriteString
    lea edx, [esi + 0]
    call WriteString
    call crlf
    mov edx, OFFSET lbl_name
    call WriteString
    lea edx, [esi + 37]
    call WriteString
    call crlf
    call crlf

    lea edi, [esi + 71]
    mov ecx, 0
VAH_loop:
    ; print month name
    push ecx
    mov eax, ecx
    mov ebx, 4               ; each name = 4 bytes ("Jan",0)
    mul ebx
    lea edx, month_names
    add edx, eax
    call WriteString
    mov edx, OFFSET att_days_lbl
    call WriteString
    pop ecx
    mov eax, [edi + ecx*4]
    call WriteDec
    call crlf
    inc ecx
    cmp ecx, NUM_MONTHS
    jl  VAH_loop

    call crlf
    call PauseForUser
    ret

VAH_none:
    mov edx, OFFSET stu_nodata
    call WriteString
    call crlf
    call PauseForUser
    ret
ViewAttendanceHistory ENDP

; ############################################################
;  UpdateStudent
; ############################################################
UpdateStudent PROC uses esi ecx edx eax ebx
    call ClrScr
    call crlf

    mov ecx, student_count
    cmp ecx, 0
    je  US_none

    mov edx, OFFSET upd_roll_str
    call WriteString
    lea edx, roll_input
    mov ecx, 12
    call ReadString

    mov esi, OFFSET student_arr
    mov ecx, student_count
US_find:
    push ecx
    push esi
    mov edi, esi
    mov esi, OFFSET roll_input
    call StrCmp
    pop  esi
    pop  ecx
    cmp  eax, 0
    je   US_found
    add  esi, SIZEOF student
    dec  ecx
    jnz  NEAR PTR US_find

    mov edx, OFFSET stu_notfound
    call ErrMsg
    call PauseForUser
    ret

US_found:
    call crlf
    mov edx, OFFSET upd_field_str
    call WriteString
    call crlf
    mov edx, OFFSET upd_opt1
    call WriteString
    call crlf
    mov edx, OFFSET upd_opt2
    call WriteString
    call crlf
    mov edx, OFFSET upd_opt3
    call WriteString
    call crlf
    mov edx, OFFSET upd_opt4
    call WriteString
    call crlf
    call crlf
    mov edx, OFFSET upd_choice
    call WriteString
    call ReadDec

    .IF eax == 1
US_dept2:
        mov edx, OFFSET upd_new_val
        call WriteString
        lea edx, [esi + 12]
        mov ecx, 20
        call ReadString
        push esi
        lea esi, [esi + 12]
        call IsAllAlpha
        pop esi
        cmp eax, 1
        jne US_dept2_err
        jmp US_ok
US_dept2_err:
        mov edx, OFFSET stu_dept_err
        call ErrMsg
        jmp US_dept2

    .ELSEIF eax == 2
US_sess2:
        mov edx, OFFSET upd_new_val
        call WriteString
        call ReadDec
        cmp eax, 1990
        jl  US_sess2
        cmp eax, 2030
        jg  US_sess2
        mov [esi + 33], eax

    .ELSEIF eax == 3
US_name2:
        mov edx, OFFSET upd_new_val
        call WriteString
        lea edx, [esi + 37]
        mov ecx, 29
        call ReadString
        push esi
        lea esi, [esi + 37]
        call IsAllAlpha
        pop esi
        cmp eax, 1
        jne US_name2_err
        jmp US_ok
US_name2_err:
        mov edx, OFFSET stu_name_err
        call ErrMsg
        jmp US_name2

    .ELSEIF eax == 4
US_age2:
        mov edx, OFFSET stu_age_str
        call WriteString
        call ReadDec
        cmp eax, 18
        jl  US_age2_bad
        cmp eax, 40
        jg  US_age2_bad
        mov [esi + 67], eax
        jmp US_ok
US_age2_bad:
        mov edx, OFFSET stu_age_err
        call ErrMsg
        jmp US_age2
    .ENDIF

US_ok:
    mov edx, OFFSET upd_done
    call OkMsg
    call PauseForUser
    ret

US_none:
    mov edx, OFFSET stu_nodata
    call WriteString
    call crlf
    call PauseForUser
    ret
UpdateStudent ENDP

; ############################################################
;  UpdateStaff
; ############################################################
UpdateStaff PROC uses esi ecx edx eax ebx
    call ClrScr
    call crlf

    mov ecx, staff_count
    cmp ecx, 0
    je  USt_none

    mov edx, OFFSET upd_staff_job
    call WriteString
    lea edx, search_job
    mov ecx, 14
    call ReadString

    mov edx, OFFSET upd_staff_nm
    call WriteString
    lea edx, search_name
    mov ecx, 29
    call ReadString

    mov esi, OFFSET staff_arr
    mov ecx, staff_count
USt_find:
    push ecx
    lea edi, [esi + 0]
    push esi
    mov esi, OFFSET search_job
    call StrCmp
    pop esi
    cmp eax, 0
    jne USt_next

    lea edi, [esi + 15]
    push esi
    mov esi, OFFSET search_name
    call StrCmp
    pop esi
    cmp eax, 0
    jne USt_next

    pop ecx
    jmp USt_found

USt_next:
    add esi, SIZEOF staff
    pop ecx
    dec ecx
    jnz NEAR PTR USt_find

    mov edx, OFFSET sta_notfound
    call ErrMsg
    call PauseForUser
    ret

USt_found:
    call crlf
    mov edx, OFFSET upd_field_str
    call WriteString
    call crlf
    mov edx, OFFSET upd_stf_opt1
    call WriteString
    call crlf
    mov edx, OFFSET upd_stf_opt2
    call WriteString
    call crlf
    mov edx, OFFSET upd_stf_opt3
    call WriteString
    call crlf
    mov edx, OFFSET upd_stf_opt4
    call WriteString
    call crlf
    mov edx, OFFSET upd_stf_opt5
    call WriteString
    call crlf
    call crlf
    mov edx, OFFSET upd_choice
    call WriteString
    call ReadDec

    .IF eax == 1
        ; --- Inline job menu for update ---
USt_job2:
        call crlf
        mov edx, OFFSET sta_job_menu
        call WriteString
        call crlf
        mov edx, OFFSET sta_job_m1
        call WriteString
        call crlf
        mov edx, OFFSET sta_job_m2
        call WriteString
        call crlf
        mov edx, OFFSET sta_job_m3
        call WriteString
        call crlf
        mov edx, OFFSET sta_job_m4
        call WriteString
        call crlf
        mov edx, OFFSET sta_job_m5
        call WriteString
        call crlf
        mov edx, OFFSET sta_job_m6
        call WriteString
        call crlf
        mov edx, OFFSET sta_job_pmt
        call WriteString
        call ReadDec
        .IF eax == 1
            mov edi, esi
            push esi
            mov esi, OFFSET job_cook
            call CopyStr
            pop  esi
            mov eax, rate_cook
            mov job_rate, eax
        .ELSEIF eax == 2
            mov edi, esi
            push esi
            mov esi, OFFSET job_guard
            call CopyStr
            pop  esi
            mov eax, rate_guard
            mov job_rate, eax
        .ELSEIF eax == 3
            mov edi, esi
            push esi
            mov esi, OFFSET job_munshi
            call CopyStr
            pop  esi
            mov eax, rate_munshi
            mov job_rate, eax
        .ELSEIF eax == 4
            mov edi, esi
            push esi
            mov esi, OFFSET job_messboy
            call CopyStr
            pop  esi
            mov eax, rate_messboy
            mov job_rate, eax
        .ELSEIF eax == 5
            mov edi, esi
            push esi
            mov esi, OFFSET job_dish
            call CopyStr
            pop  esi
            mov eax, rate_dish
            mov job_rate, eax
        .ELSEIF eax == 6
            mov edi, esi
            push esi
            mov esi, OFFSET job_sweep
            call CopyStr
            pop  esi
            mov eax, rate_sweep
            mov job_rate, eax
        .ELSE
            mov edx, OFFSET sta_job_err
            call ErrMsg
            jmp USt_job2
        .ENDIF
        ; recalculate salary with new job rate
        mov eax, [esi + 59]     ; total_hours
        mul job_rate
        mov [esi + 63], eax     ; TotalSalary
        jmp USt_ok

    .ELSEIF eax == 2
USt_name2:
        mov edx, OFFSET upd_new_val
        call WriteString
        lea edx, [esi + 15]
        mov ecx, 29
        call ReadString
        push esi
        lea esi, [esi + 15]
        call IsAllAlpha
        pop esi
        cmp eax, 1
        jne USt_name2_err
        jmp USt_ok
USt_name2_err:
        mov edx, OFFSET sta_name_err
        call ErrMsg
        jmp USt_name2

    .ELSEIF eax == 3
USt_gen2:
        mov edx, OFFSET sta_gen_str
        call WriteString
        lea edx, [esi + 45]
        mov ecx, 9
        call ReadString
        push esi
        lea esi, [esi + 45]
        mov edi, OFFSET str_male
        call StrCmp
        pop esi
        cmp eax, 0
        je  USt_ok
        push esi
        lea esi, [esi + 45]
        mov edi, OFFSET str_female
        call StrCmp
        pop esi
        cmp eax, 0
        je  USt_ok
        mov edx, OFFSET sta_gen_err
        call ErrMsg
        jmp USt_gen2

    .ELSEIF eax == 4
USt_age2:
        mov edx, OFFSET sta_age_str
        call WriteString
        call ReadDec
        cmp eax, 18
        jl  USt_age2_bad
        cmp eax, 60
        jg  USt_age2_bad
        mov [esi + 55], eax
        jmp USt_ok
USt_age2_bad:
        mov edx, OFFSET sta_age_err
        call ErrMsg
        jmp USt_age2

    .ELSEIF eax == 5
USt_hrs2:
        mov edx, OFFSET sta_hrs_str
        call WriteString
        call ReadDec
        cmp eax, 0
        je  USt_hrs2_bad
        cmp eax, 312
        jg  USt_hrs2_bad
        mov [esi + 59], eax
        ; recalc salary using stored job name
        push esi
        mov edi, OFFSET job_cook
        lea esi, [esi + 0]
        call StrCmp
        pop esi
        cmp eax, 0
        je  USt_sal_cook
        push esi
        mov edi, OFFSET job_guard
        lea esi, [esi + 0]
        call StrCmp
        pop esi
        cmp eax, 0
        je  USt_sal_guard
        push esi
        mov edi, OFFSET job_munshi
        lea esi, [esi + 0]
        call StrCmp
        pop esi
        cmp eax, 0
        je  USt_sal_munshi
        push esi
        mov edi, OFFSET job_messboy
        lea esi, [esi + 0]
        call StrCmp
        pop esi
        cmp eax, 0
        je  USt_sal_messboy
        push esi
        mov edi, OFFSET job_dish
        lea esi, [esi + 0]
        call StrCmp
        pop esi
        cmp eax, 0
        je  USt_sal_dish
        mov ebx, rate_sweep
        jmp USt_do_sal
USt_sal_cook:
        mov ebx, rate_cook
        jmp USt_do_sal
USt_sal_guard:
        mov ebx, rate_guard
        jmp USt_do_sal
USt_sal_munshi:
        mov ebx, rate_munshi
        jmp USt_do_sal
USt_sal_messboy:
        mov ebx, rate_messboy
        jmp USt_do_sal
USt_sal_dish:
        mov ebx, rate_dish
USt_do_sal:
        mov eax, [esi + 59]
        mul ebx
        mov [esi + 63], eax
        call crlf
        mov edx, OFFSET sta_sal_str
        call WriteString
        mov eax, [esi + 63]
        call WriteDec
        call crlf
        jmp USt_ok

USt_hrs2_bad:
        mov edx, OFFSET sta_hrs_err
        call ErrMsg
        jmp USt_hrs2
    .ENDIF

USt_ok:
    mov edx, OFFSET upd_done
    call OkMsg
    call PauseForUser
    ret

USt_none:
    mov edx, OFFSET sta_nodata
    call WriteString
    call crlf
    call PauseForUser
    ret
UpdateStaff ENDP

; ############################################################
;  ShowSummary
; ############################################################
ShowSummary PROC uses eax edx
    call ClrScr
    call crlf
    mov edx, OFFSET sep_line
    call WriteString
    call crlf
    mov edx, OFFSET sum_stu_str
    call WriteString
    mov eax, student_count
    call WriteDec
    call crlf
    mov edx, OFFSET sum_sta_str
    call WriteString
    mov eax, staff_count
    call WriteDec
    call crlf
    mov edx, OFFSET sep_line
    call WriteString
    call crlf
    call crlf
    call PauseForUser
    ret
ShowSummary ENDP

END main