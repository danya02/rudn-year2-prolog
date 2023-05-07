#!/usr/bin/swipl -q
%!/usr/bin/env python
% coding: utf-8

% In[1]:


%%% get_ipython().run_line_magic('', 'Purchaseable products')

%%% get_ipython().run_line_magic('', 'product(id, name, category, unit_price).')

product(1, "Молоко","Mолочный отдел", 120):- true.
product(2, "Творог","Mолочный отдел", 230).
product(3, "Сыр","Mолочный отдел", 300).
product(4, "Кефир","Mолочный отдел", 90).

product(5, "Картофель","Овощи", 35).
product(6, "Лук","Овощи", 12).
product(7, "Томаты","Овощи", 56).
product(8, "Морковь","Овощи", 22).

product(9, "Голень куриная","Мясо", 21).
product(10, "Свиная шея","Мясо", 48).
product(11, "Окорок бараний","Мясо", 129).
product(12, "Филе индейки","Мясо", 43).

product(13, "Греча","Бакалея", 60).
product(14, "Манная крупа","Бакалея", 25).
product(15, "Овсяная крупа","Бакалея", 105).
product(16, "Рис","Бакалея", 95).
product(17, "Сахар","Бакалея", 58).
product(18, "Соль","Бакалея", 23).
product(19, "Спагетти","Бакалея", 120).
product(20, "Мука","Бакалея", 120).
%%% get_ipython().run_line_magic('pinfo', '- findall((X,Y,Z,T), product(X,Y,Z,T), Products).')



% In[2]:


%%% get_ipython().run_line_magic('', 'Clients')

%%% get_ipython().run_line_magic('', 'client(name, phone_number).')

client("Анна Иванова", "+7 999 123 45 67") :- true.
client("Илья Петров", "+7 926 987 65 43").
client("Елена Сидорова", "+7 925 555 44 33").
client("Сергей Кузнецов", "+7 965 432 10 98").
%%% get_ipython().run_line_magic('pinfo', '- findall((X,Y), client(X,Y), Clients).')



% In[3]:


%%% get_ipython().run_line_magic('', 'Purchase transactions')

%%% get_ipython().run_line_magic('', 'purchase(purchase_id, client_phone, product_id, quantity, day_number).')

purchase(1, "+7 999 123 45 67", 3, 1, 12).
purchase(2, "+7 999 123 45 67", 5, 3, 12).
purchase(3, "+7 999 123 45 67", 6, 2, 12).

purchase(4, "+7 999 123 45 67", 12, 6, 13).
purchase(5, "+7 999 123 45 67", 14, 1, 13).
purchase(6, "+7 999 123 45 67", 17, 1, 13).

purchase(7, "+7 999 123 45 67", 3, 1, 15).
purchase(8, "+7 999 123 45 67", 5, 4, 15).
purchase(9, "+7 999 123 45 67", 4, 1, 15).
purchase(10, "+7 999 123 45 67", 12, 5, 15).
purchase(11, "+7 999 123 45 67", 1, 1, 15).
purchase(12, "+7 999 123 45 67", 15, 1, 15).
purchase(13, "+7 999 123 45 67", 20, 1, 15).

purchase(14, "+7 926 987 65 43", 1, 2, 19).
purchase(15, "+7 926 987 65 43", 2, 2, 19).
purchase(16, "+7 926 987 65 43", 3, 1, 19).
purchase(17, "+7 926 987 65 43", 6, 1, 19).
purchase(18, "+7 926 987 65 43", 10, 5, 19).
purchase(19, "+7 926 987 65 43", 16, 1, 19).

purchase(20, "+7 925 555 44 33", 2, 2, 20).
purchase(21, "+7 925 555 44 33", 7, 3, 20).
purchase(22, "+7 925 555 44 33", 8, 2, 20).
purchase(23, "+7 925 555 44 33", 12, 3, 20).
purchase(24, "+7 925 555 44 33", 8, 2, 20).
purchase(25, "+7 925 555 44 33", 12, 3, 20).
purchase(26, "+7 925 555 44 33", 19, 3, 20).

purchase(27, "+7 965 432 10 98", 3, 1, 19).
purchase(28, "+7 965 432 10 98", 4, 1, 19).
purchase(29, "+7 965 432 10 98", 6, 4, 19).
purchase(30, "+7 965 432 10 98", 8, 3, 19).
purchase(31, "+7 965 432 10 98", 2, 3, 19).
purchase(32, "+7 965 432 10 98", 5, 3, 19).
purchase(33, "+7 965 432 10 98", 15, 1, 19).

purchase(34, "+7 965 432 10 98", 1, 3, 20).
purchase(35, "+7 965 432 10 98", 5, 3, 20).
purchase(36, "+7 965 432 10 98", 1, 3, 20).
purchase(37, "+7 965 432 10 98", 6, 4, 20).
purchase(38, "+7 965 432 10 98", 6, 3, 20).
purchase(39, "+7 965 432 10 98", 8, 2, 20).
purchase(40, "+7 965 432 10 98", 17, 2, 20).

purchase(41, "+7 965 432 10 98", 13, 1, 20).
purchase(42, "+7 965 432 10 98", 20, 1, 20).

purchase(43, "+7 999 123 45 67", 2, 1, 20).
purchase(44, "+7 999 123 45 67", 3, 1, 20).
purchase(45, "+7 999 123 45 67", 6, 4, 20).
purchase(46, "+7 999 123 45 67", 10, 3, 20).

purchase(47, "+7 965 432 10 98",1, 2, 20).
purchase(48, "+7 965 432 10 98",3, 1, 20).
purchase(49, "+7 965 432 10 98", 4, 3, 20).
purchase(50, "+7 965 432 10 98", 20, 1, 20).
purchase(51, "+7 965 432 10 98", 1, 2, 20).

purchase(52, "+7 926 987 65 43", 2, 1, 23).
purchase(53, "+7 926 987 65 43", 5, 4, 23).
purchase(54, "+7 926 987 65 43", 9, 4, 23).
purchase(55, "+7 926 987 65 43", 12, 1, 23).
purchase(56, "+7 926 987 65 43", 16, 1, 23).
purchase(57, "+7 926 987 65 43", 18, 1, 23).

purchase(58, "+7 926 987 65 43", 4, 1, 24).
purchase(59, "+7 965 432 10 98", 6, 2, 24).
purchase(60, "+7 965 432 10 98", 19, 2, 24).

%%% get_ipython().run_line_magic('pinfo', '- findall((I,X,Y,Z,T), purchase(I,X,Y,Z,T), Purchases).')



% In[4]:


%%% get_ipython().run_line_magic('', 'Client tiers, based on how much the client has spent')

%%% get_ipython().run_line_magic('', 'tier(tier_name, threshold)')

tier(none, 0) :- true.
tier(bronze, 1000).
tier(silver, 2000).
tier(gold, 3000).
tier(platinum, 4000).


% In[5]:


%%% get_ipython().run_line_magic('', 'A repeat client is defined as a customer who has multiple purchases made on different days.')

repeat_client(PID) :-
    purchase(_,PID, _, _, D1),
    purchase(_,PID, _, _, D2),
    not(D1 = D2).
%%% get_ipython().run_line_magic('', '   purchase(pid, _f3, _f4, d2).')

%%% get_ipython().run_line_magic('pinfo', '- findall(X, repeat_client(X), _RC), list_to_set(_RC, RepeatClients).')



% In[6]:


%%% get_ipython().run_line_magic('', '(internal) The price of a particular purchase is the number of items involved in that purchase,')

%%% get_ipython().run_line_magic('', 'multiplied by the cost of an item.')

purchase_price(PurchaseId, PurchasePrice) :-
    purchase(PurchaseId, _, ProductId, ProductCount, _),
    product(ProductId, _, _, UnitPrice),
    PurchasePrice is ProductCount*UnitPrice.
%%% get_ipython().run_line_magic('pinfo', '- purchase_price(1, X).')



% In[7]:


%%% get_ipython().run_line_magic('', '(internal) The list of all purchases on a particular day, along with their prices.')

day_purchase_prices(Day, Plist) :- 
    findall(PurchaseId, purchase(PurchaseId, _, _, Count, Day), DayPurchases),  % gather list of all purchases for the day
    findall((PurchaseId, PurchasePrice), % then associate purchaseids with a purchaseprice
        (
            member(PurchaseId, DayPurchases), % for the purchaseids in the purchases of the day only
            purchase_price(PurchaseId, PurchasePrice)
        ),
        Plist).

%%% get_ipython().run_line_magic('pinfo', '- day_purchase_prices(12, P).')



% In[8]:


%%% get_ipython().run_line_magic('', 'The cashflow of a day is defined as the total sum of the purchases made on that day.')

cashflow(Day, Amount) :-
    day_purchase_prices(Day, Plist), % First gather the list of purchases with their costs
    findall(Cost, (
        member((_, Cost), Plist),  % then extract the second item from each tuple
        true
    ),AmountList),  % and gather those into a list
    sum_list(AmountList, Amount). % which is then folded

%%% get_ipython().run_line_magic('pinfo', '- cashflow(12, X).')



% In[9]:


%%% get_ipython().run_line_magic('', '(internal) The list of purchases made by a specific client, along with their prices.')

client_purchase_prices(Cid, Plist) :- 
    client(_, Cid),  % There must be a client with this id.
    findall(PurchaseId, purchase(PurchaseId, Cid, _, Count, _), ClientPurchases),
    findall((PurchaseId, PurchasePrice),
        (
            member(PurchaseId, ClientPurchases), % for the purchaseids in the purchases of the day only
            purchase_price(PurchaseId, PurchasePrice)
        ),
        Plist).

%%% get_ipython().run_line_magic('pinfo', '- client_purchase_prices("+7 999 123 45 67", X).')



% In[10]:


%%% get_ipython().run_line_magic('', 'The total sum paid by the client across all their purchases.')

client_spent(Cid, Amount) :-
    client(_, Cid),  % There must be a client with this id.
    client_purchase_prices(Cid, Plist),
    findall(Cost, member((_, Cost), Plist), AmtList),
    sum_list(AmtList, Amount).
%%% get_ipython().run_line_magic('pinfo', '- findall((X,Y), client_spent(X,Y), Spendings).')



% In[11]:


%%% get_ipython().run_line_magic('', "The client's tier is defined as the largest tier whose threshold the client's purchase sum has exceeded.")

client_tier(Cid, Tier) :-
    client(_, Cid),  % There must be a client with this id.
    client_spent(Cid, Amount),  % Check how much the client spent
    findall(PassedTierAmt, 
    (
        tier(_, PassedTierAmt),  % Get all tier amounts
        PassedTierAmt =< Amount  % that are smaller than that
    ), PassedTierAmts),
    max_list(PassedTierAmts, MaxTierAmt),  % then find the largest one
    tier(Tier, MaxTierAmt).  % and return the tier corresponding to it
    
%%% get_ipython().run_line_magic('pinfo', '- findall((X,Y), client_tier(X,Y), CTiers).')



% In[12]:


%%% get_ipython().run_line_magic('', 'The list of products per day is defined as the list of product names that feature in purchases for that day')

products_per_day(Day, ProductList) :- 
    findall(ProductId, purchase(_,_,ProductId,_,Day), ProductIdList),  % gather IDs
    findall(ProductName, (
        product(Id, ProductName, _, _),  % then convert ID to name
        member(Id, ProductIdList)
    ), ProductList).
%%% get_ipython().run_line_magic('pinfo', '- products_per_day(13, X).')



% In[13]:


%%% get_ipython().run_line_magic('', 'The list of clients per product is defined as the list of names of the clients for whom there exists a purchase')

%%% get_ipython().run_line_magic('', 'for the product with the given ID.')

buyers_of_product(Pid, Buyers) :- 
    findall(BuyerId, purchase(_, BuyerId, Pid, _, _), BuyerIds),  % gather list of buyer IDs
    list_to_set(BuyerIds, UniqBuyerIds),  % uniquify
    findall(Name, (
        client(Name, Bid),  % to names
        member(Bid, UniqBuyerIds)
    ), Buyers).

%%% get_ipython().run_line_magic('pinfo', '- findall((1, Names), buyers_of_product(1, Names), Answers).')

%%% get_ipython().run_line_magic('pinfo', '- findall((20, Names), buyers_of_product(20, Names), Answers).')



% In[14]:


%%% get_ipython().run_line_magic('', 'The list of categories by client is defined as the list of product categories that this client has bought.')

categories_by_client(Cid, Cats) :-
    findall(ProductId, purchase(_, Cid, ProductId, _, _), ProductIds), % Gather list of categories
    findall(Cat, (
        member(Pid, ProductIds),  % for every product
        product(Pid, _, Cat, _)   % find its category
    ), CatsMultiple),
    list_to_set(CatsMultiple, Cats).
%%% get_ipython().run_line_magic('pinfo', '- findall((Cid, Cats), (client(_, Cid), categories_by_client(Cid, Cats)), Answers).')



% In[15]:


%%% get_ipython().run_line_magic('', '------ Examples ------')

example1:-
    writeln("---- Example 1 ----"),
    writeln("Get list of repeat clients:"),
    setof(RepC, repeat_client(RepC), RepeatClients),
    writeln(RepeatClients).


% In[16]:


example2 :-
    writeln("---- Example 2 ----"),
    writeln("Get each client's total spending and tier:"),
    (
        client(Name, Id),
        write(Name), write(":"),
        client_spent(Id, Spent),
        write(Spent), write(":"),
        client_tier(Id, Tier),
        write(Tier),
        nl,
        fail()
    );
    true.


% In[17]:


example3 :-
    writeln("---- Example 3 ----"),
    writeln("Get the products purchased on every day:"),
    findall(Day,purchase(_,_,_,_,Day), DaysMulti),
    list_to_set(DaysMulti, Days),
    (
        member(Day, Days),
        products_per_day(Day, ProductsMulti),
        list_to_set(ProductsMulti, Products),
        write(Day), write(":"), write(Products), nl, fail()
    );
    true.


% In[18]:


example4 :-
    writeln("---- Example 4 ----"),
    writeln("Get the cashflow for every day:"),
    findall(Day,purchase(_,_,_,_,Day), DaysMulti),
    list_to_set(DaysMulti, Days),
    (
        member(Day, Days),
        cashflow(Day, Cash),
        write(Day), write(":"), write(Cash), nl, fail()
    );
    true.


% In[19]:


example5 :-
    writeln("---- Example 5 ----"),
    writeln("Get the categories of product purchased by every client:"),
    writeln("(the last client does not purchase meat products)"),
    (
        client(ClientName, Cid),
        categories_by_client(Cid, Cats),
        write(ClientName), write(":"), write(Cats), nl, fail()
    );
    true.


% In[20]:


prolog :-
    example1,
    example2,
    example3,
    example4,
    example5.


% In[ ]:





% In[ ]:




% Arrange for the main goal, which should be prolog/0, to be solved, and then halt
metaprolog :- prolog, halt.
:- initialization(metaprolog, program).
