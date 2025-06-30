use banking_project;
select * from banking_data_date_new;

# Q1 Total Loan Amount Funded
select concat(round(sum(FundedAmount)/1000000,0),'M')Loan_Amount_Funded from banking_data_date_new;

# Q2 Total Loans
select concat(round(count(FundedAmount)/1000,2),'K')Total_Loans from banking_data_date_new;

# Q3 Total Collection
select concat(round(sum(TotalPymnt)/1000000,0),'M')Total_payment_sum from banking_data_date_new;

# Q4 Total Interest
select concat(round(sum(TotalRrecint)/1000000,0),'M')Total_interest from banking_data_date_new;

# Q5 Branch wise interest, fees, total revenue
select BranchName, concat(round(sum(TotalFees)/1000,2),'K')Total_Fees, concat(round(sum(TotalRrecint)/1000,2),'K')Total_interest, 
concat(round(sum(TotalPymntinv)/1000000),'M')Total_Payment from banking_data_date_new
group by BranchName order by sum(TotalPymntinv) desc;

# Q6 State wise loan
select StateName, concat(round(sum(LoanAmount)/1000000,0),'M')Sum_of_Loan
from banking_data_date_new group by StateName;

# Q7 Religion wise loan
select Religion, concat(round(sum(LoanAmount)/1000000,0),'M')Sum_of_Loan
from banking_data_date_new group by Religion;

# Q8 Product group wise loan
select PurposeCategory, concat(round(sum(LoanAmount)/1000,2),'K')Sum_of_Loan
from banking_data_date_new group by PurposeCategory;

# Q9 Disbursement trend
select DisbursementDateinYears, Loan_month, Concat(round(sum(LoanAmount)/1000,2),'K')Sum_of_Loans 
from ( select DisbursementDateinYears, month(DisbursementDate)Month_no, monthname(DisbursementDate)Loan_month, LoanAmount from
banking_data_date_new)a group by DisbursementDateinYears, Month_no, Loan_month
order by DisbursementDateinYears, Month_no;

#10 Grade wise Loan
select grrade, count(*) 
from banking_data_new 
group by grrade
order by grrade;

#11 Default loan count
select count(loanamount) as default_loan_count
from banking_data_date_new 
where IsDefaultLoan = 'Y';

#12 Delinquent loan count
select count(loanamount) as Delinquent_loan_count
from banking_data_date_new
where IsDelinquentLoan = 'Y';

#13 Default loan rate
select concat(sum(case when IsDefaultLoan = 'Y' then loanamount else 0 end)*100/ sum(loanamount),'%') as default_loan_rate 
from banking_data_date_new;

#14 Delinquent loan rate
select concat(sum(case when IsDelinquentLoan = 'Y' then loanamount else 0 end)*100/ sum(loanamount),'%') as Delinquent_Loan_rate
from banking_data_date_new;

#15 Loan status wise group
Select loanstatus, sum(loanamount)
from banking_data_date_new
group by loanstatus;

#16 Age group wise loan
select Age, count(loanamount) as total_loan_count
from banking_data_date_new
group by age
order by age;

#17 Loan maturity - fully paid
select loanstatus, count(loanamount) as loans_maturity
from banking_data_date_new 
where loanstatus = 'fully paid';

#18 No Verified loans
select VerificationStatus, count(loanamount) as not_verfied
from banking_data_date_new
where VerificationStatus = 'not verified';