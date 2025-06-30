use banking_project;
select * from dc_sql;

#Q1 Total Credit Amount
select concat(round(sum(amount)/1000,2),'K') as Total_Credit from dc_sql where transactiontype = "Credit";

#Q2 Total Debit Amount
select concat(round(sum(amount)/1000,2),'K') as Total_Debit from dc_sql where transactiontype = "debit";

#Q3 Credit-Debit ratio
select 
(sum(case when transactiontype = 'Credit'  then amount 
else 0 end)*1.0)/nullif(sum(case when transactiontype = 'Debit'  then amount else 0 end),0)as Credit_Debit_Ratio
from dc_sql;

#Q4 Net Transaction amount
select sum(case when transactiontype = 'credit' then amount else 0 end ) -
sum(case when transactiontype = 'debit' then amount else 0 end) as Net_Tranascation_Amount
from dc_sql;

#Q5 Account Activity Ratio
select CustomerName, (count(Amount)/avg(Balance))AccountActivityRatio from dc_sql group by CustomerName 
order by (count(Amount)/avg(Balance)) desc;

#Q6 Transactions per day/week/month
select date(TransactionDate)Dayoftransaction, count(Amount)Transactionsperday from dc_sql group by date(TransactionDate) order by date(TransactionDate);
select monthname(TransactionDate)MonthName, count(Amount)TransactionsperMonth 
from dc_sql group by month(TransactionDate), monthname(TransactionDate) order by month(TransactionDate);
select week(TransactionDate)WeekNumber, count(Amount)Transactionsperweek 
from dc_sql group by week(TransactionDate) order by week(TransactionDate);

#Q7 Total Transaction amount by branch
select branch , concat(round(sum(amount)/1000,2),'K') as total_transaction_amount from dc_sql group by branch;

#Q8 Transaction volume by bank
select BankName, concat(round(sum(Amount)/1000,2),'K') Transaction_volume from dc_sql group by BankName;

#Q9 Transaction method distribution
select TransactionMethod, concat(round(count(Amount) * 100 / sum(count(Amount)) over (),2),' %')percentage
from dc_sql group by TransactionMethod;

#Q10 Branch transaction growth
with monthly_totals as (
select Branch, DATE_FORMAT(TransactionDate, '%Y-%m') as Month, sum(Amount) as TotalAmount from dc_sql group by Branch, DATE_FORMAT(TransactionDate, '%Y-%m')),
with_changes as (select Branch, Month, TotalAmount, lag(TotalAmount) over (partition by Branch order by Month) as PrevTotal from monthly_totals)
select Branch, Month, TotalAmount, concat(round((TotalAmount - PrevTotal) / PrevTotal * 100, 2),' %') as PercentChange from with_changes
order by Branch, Month;

#Q11 High risk transaction flag
select Amount, case when Amount>4000 then 'High Risk' else 'Low Risk' end as TransactionFlag from dc_sql;

#Q12 Suspicious transaction frequency
select case when Amount>4000 then 'High Risk' else 'Low Risk' end as TransactionFlag, count(*)TransactionFrequency from dc_sql
group by case when Amount>4000 then 'High Risk' else 'Low Risk' end;