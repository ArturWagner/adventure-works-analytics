-- dim_employee.sql
-- Extract and transform DimEmployee from AdventureWorks2022
-- Target: adventureworks.dim_employee (BigQuery)
-- Strategy: full load (WRITE_TRUNCATE)

SELECT
    EmployeeKey                     AS employee_key,
    ParentEmployeeKey               AS parent_employee_key,
    EmployeeNationalIDAlternateKey  AS employee_national_id,
    ParentEmployeeNationalIDAlternateKey AS parent_employee_national_id,
    SalesTerritoryKey               AS sales_territory_key,
    FirstName                       AS first_name,
    LastName                        AS last_name,
    MiddleName                      AS middle_name,
    NameStyle                       AS name_style,
    Title                           AS title,
    HireDate                        AS hire_date,
    BirthDate                       AS birth_date,
    LoginID                         AS login_id,
    EmailAddress                    AS email_address,
    Phone                           AS phone,
    MaritalStatus                   AS marital_status,
    EmergencyContactName            AS emergency_contact_name,
    EmergencyContactPhone           AS emergency_contact_phone,
    SalariedFlag                    AS salaried_flag,
    Gender                          AS gender,
    PayFrequency                    AS pay_frequency,
    BaseRate                        AS base_rate,
    VacationHours                   AS vacation_hours,
    SickLeaveHours                  AS sick_leave_hours,
    CurrentFlag                     AS current_flag,
    SalesPersonFlag                 AS sales_person_flag,
    DepartmentName                  AS department_name,
    StartDate                       AS start_date,
    EndDate                         AS end_date,
    Status                          AS status
FROM AdventureWorks2022.dbo.DimEmployee
