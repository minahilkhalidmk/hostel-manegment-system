# 🏨 Hostel Management System v3.0

A comprehensive **Hostel Management System** developed in **x86 Assembly Language (MASM)** using the **Irvine32 Library**. This project demonstrates low-level programming concepts, structured data management, input validation, and menu-driven system design through a real-world hostel administration application.

## 🚀 Features

### 🔐 Secure Administrator Authentication

* Username and password-based login system
* Strong password policy enforcement
* Maximum 3 login attempts before system lockout
* Detailed validation feedback for incorrect passwords

### 👨‍🎓 Student Management

* Add and manage student records
* Roll number format validation (`YYYYDDDnnn`)
* Department, session, name, and age validation
* View all registered students
* Update student information dynamically

### 👨‍💼 Staff Management

* Add and manage hostel staff members
* Multiple predefined job categories
* Automatic salary calculation based on job role and working hours
* Update staff records and recalculate salaries instantly
* View complete staff information

### 📅 Attendance Tracking

* Monthly attendance management
* Month-specific day validation
* Attendance history for all 12 months
* Editable attendance records

### 💰 Billing & Salary System

* Automatic student mess bill generation
* Attendance-based billing calculation
* Job-specific salary rates
* Real-time salary updates

### 🏢 Warden Information Module

* View hostel warden details
* Contact and room information display

### 📊 Summary Dashboard

* Total registered students count
* Total registered staff count
* Quick administrative overview

---

## 🛠 Technologies Used

* **x86 Assembly Language**
* **MASM (Microsoft Macro Assembler)**
* **Irvine32 Library**
* **Windows Console Application**
* **Visual Studio**

---

## 🎯 Learning Objectives

This project showcases:

* Low-level software development
* Structured programming in Assembly Language
* Memory management concepts
* Data validation techniques
* Record management systems
* Menu-driven user interfaces
* Real-world problem solving using Assembly

---

## 📋 Validation & Data Integrity

The system performs extensive validation before storing any information:

✅ Password Complexity Enforcement
✅ Unique Student Roll Numbers
✅ Alphabet-Only Names & Departments
✅ Age Restrictions for Students & Staff
✅ Attendance Range Validation
✅ Job-Type Restrictions
✅ Gender Validation
✅ Working Hour Limits

This ensures that only valid and consistent data is maintained throughout the system.

---

## 📌 Key Highlights

* Built entirely in **Assembly Language**
* Uses structured procedures and modular design
* Implements real-world hostel administration workflows
* Demonstrates advanced input validation techniques
* Features attendance tracking, billing, salary management, and authentication
* Excellent academic project for learning **MASM**, **Irvine32**, and low-level system design

---

## ⚠️ Current Limitations

* Data is stored in memory only (no database/file storage)
* No delete functionality for records
* Password stored in plain text
* February fixed to 28 days (no leap year support)
* Maximum capacity:

  * 30 Students
  * 20 Staff Members
---
