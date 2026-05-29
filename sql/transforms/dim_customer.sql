-- dim_customer.sql
-- Extract and transform DimCustomer from AdventureWorks2022
-- Target: adventureworks.dim_customer (BigQuery)
-- Strategy: full load (WRITE_TRUNCATE)

SELECT
    CustomerKey                     AS customer_key,
    GeographyKey                    AS geography_key,
    CustomerAlternateKey            AS customer_alternate_key,
    Title                           AS title,
    FirstName                       AS first_name,
    MiddleName                      AS middle_name,
    LastName                        AS last_name,
    NameStyle                       AS name_style,
    BirthDate                       AS birth_date,
    MaritalStatus                   AS marital_status,
    Suffix                          AS suffix,
    Gender                          AS gender,
    EmailAddress                    AS email_address,
    YearlyIncome                    AS yearly_income,
    TotalChildren                   AS total_children,
    NumberChildrenAtHome            AS number_children_at_home,
    EnglishEducation                AS education,
    EnglishOccupation               AS occupation,
    HouseOwnerFlag                  AS house_owner_flag,
    NumberCarsOwned                 AS number_cars_owned,
    AddressLine1                    AS address_line1,
    AddressLine2                    AS address_line2,
    Phone                           AS phone,
    DateFirstPurchase               AS date_first_purchase,
    CommuteDistance                 AS commute_distance
FROM AdventureWorks2022.dbo.DimCustomer
