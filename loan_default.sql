USE loans; 


SELECT * 
FROM loan_applications 
;

SELECT * 
FROM borrower_profiles 
;


SELECT *
FROM loan_applications
JOIN borrower_profiles
    ON loan_applications.borrower_id = borrower_profiles.borrower_id
    ; 


## Credit Score Buckets
SELECT
    CASE
        WHEN bp.credit_score < 580 THEN 'Poor (<580)'
        WHEN bp.credit_score BETWEEN 580 AND 669 THEN 'Fair (580-669)'
        WHEN bp.credit_score BETWEEN 670 AND 739 THEN 'Good (670-739)'
        WHEN bp.credit_score BETWEEN 740 AND 799 THEN 'Very Good (740-799)'
        WHEN bp.credit_score >= 800 THEN 'Excellent (800+)'
    END AS credit_score_bucket,
    
    COUNT(*) AS total_loans,
    SUM(la.defaulted) AS defaults,
    ROUND(AVG(la.defaulted) * 100, 2) AS default_rate_percent

FROM loan_applications AS la
JOIN borrower_profiles AS bp
    ON la.borrower_id = bp.borrower_id

GROUP BY credit_score_bucket
ORDER BY default_rate_percent DESC;

### Debt-to-Income ratio 

SELECT
    CASE
        WHEN la.dti_ratio < 20 THEN 'Low (<20%)'
        WHEN la.dti_ratio < 30 THEN 'Moderate (20%-29%)'
        WHEN la.dti_ratio < 40 THEN 'High (30%-39%)'
        ELSE 'Very High (40%+)'
    END AS dti_bucket,
    COUNT(*) AS total_loans,
    SUM(la.defaulted) AS defaults,
    ROUND(AVG(la.defaulted) * 100, 2) AS default_rate_percent
FROM loan_applications AS la
JOIN borrower_profiles AS bp
    ON la.borrower_id = bp.borrower_id
GROUP BY dti_bucket
ORDER BY default_rate_percent DESC;


### Employment Status 

SELECT bp.employment_status, COUNT(*) AS total_loans, SUM(la.defaulted) AS defaults, ROUND(AVG(la.defaulted) * 100, 2) AS default_rate_percent
FROM loan_applications AS la 
JOIN borrower_profiles AS bp 
	ON la.borrower_id = bp.borrower_id  
GROUP BY employment_status 
ORDER BY default_rate_percent DESC 
;

### Loan Purpose 

SELECT
    la.loan_purpose,
    COUNT(*) AS total_loans,
    SUM(la.defaulted) AS defaults,
    ROUND(AVG(la.defaulted) * 100, 2) AS default_rate_percent

FROM loan_applications AS la
JOIN borrower_profiles AS bp
    ON la.borrower_id = bp.borrower_id

GROUP BY la.loan_purpose
ORDER BY default_rate_percent DESC;

### Education Level
SELECT
    bp.education_level,
    SUM(la.defaulted) AS defaults

FROM loan_applications AS la
JOIN borrower_profiles AS bp
    ON la.borrower_id = bp.borrower_id

GROUP BY
    bp.education_level
ORDER BY defaults DESC;




### Correlation Analysis 

SELECT
    bp.credit_score,
    la.dti_ratio,
    bp.annual_income,
    la.loan_amount,
    la.interest_rate,
    la.defaulted
FROM loan_applications AS la
JOIN borrower_profiles AS bp
    ON la.borrower_id = bp.borrower_id;

### Wedding Data

SELECT AVG(dti_ratio), AVG(credit_score), AVG(annual_income)
FROM loan_applications AS la
JOIN borrower_profiles AS bp
    ON la.borrower_id = bp.borrower_id
WHERE la.loan_purpose = 'Wedding' AND la.defaulted = 1
;

