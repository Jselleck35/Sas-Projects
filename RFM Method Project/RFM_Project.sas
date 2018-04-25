
FILENAME REFFILE '/folders/myfolders/Data Science with SAS/Datasets/ECommerce.xlsx'; 

PROC IMPORT DATAFILE=REFFILE 
    DBMS=XLSX 
    OUT=WORK.Ecommerce; 
    GETNAMES=YES; 
RUN; 

Proc SQL Data=Ecommerce; 
    by Customer_Name; 
    Proc Print data=Ecommerce(OBS=10); 
    title 'Sales by Customer'; 
    ID Customer_Name; 
    Var Order_ID Order_Date Sales; 
    run;     

proc sql; 
create table Cust_Summary as  
    select Customer_Name, 
    max(Order_Date) as Recency format=date9., 
    Count(*) as Frequency, 
    Sum(Sales) as Monetary format dollar12.2 
    from Ecommerce 
    group by Customer_Name; 
quit; 

Proc rank data=Cust_Summary OUT=RFM ties=high group=3; 
    var Recency Frequency Monetary; 
    Ranks R F M; 
run; 

data RFM_Final; 
    set RFM; 
    R+1; F+1; M+1; 
    RFM = Cats(R,F,M); 
    RFM_Sum = Sum(R,F,M); 
run; 