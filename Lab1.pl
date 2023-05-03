#!/usr/bin/swipl -q
%!/usr/bin/env python
% coding: utf-8

% In[1]:


%%% get_ipython().run_line_magic('', 'Purchaseable products')

%%% get_ipython().run_line_magic('', 'product(id, name, category, unit_price).')

product(1, "Foobar", metasyntactic, 0.99) :- true.
%%% get_ipython().run_line_magic('', 'TODO: add more')

%%% get_ipython().run_line_magic('pinfo', '- findall((X,Y,Z,T), product(X,Y,Z,T), Products).')



% In[2]:


%%% get_ipython().run_line_magic('', 'Clients')

%%% get_ipython().run_line_magic('', 'client(name, phone_number).')

client("Alice", 111111) :- true.
client("Bob", 222222).
client("Charlie", 333333).
%%% get_ipython().run_line_magic('pinfo', '- findall((X,Y), client(X,Y), Clients).')



% In[3]:


%%% get_ipython().run_line_magic('', 'Purchase transactions')

%%% get_ipython().run_line_magic('', 'purchase(purchase_id, client_phone, product_id, quantity, day_number).')

purchase(1, 111111, 1, 5, 1) :- true.
purchase(2, 222222, 1, 2, 1).
purchase(3, 222222, 1, 2, 2).
purchase(4, 333333, 1, 20, 3).
purchase(5, 111111, 1, 5, 4).
purchase(6, 222222, 1, 6000, 4).

%%% get_ipython().run_line_magic('pinfo', '- findall((I,X,Y,Z,T), purchase(I,X,Y,Z,T), Purchases).')



% In[4]:


%%% get_ipython().run_line_magic('', 'Client tiers, based on how much the client has spent')

%%% get_ipython().run_line_magic('', 'tier(tier_name, threshold)')

tier(none, 0) :- true.
tier(bronze, 1000).
tier(silver, 5000).
tier(gold, 10000).
tier(platinum, 25000).


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

%%% get_ipython().run_line_magic('pinfo', '- day_purchase_prices(1, P).')



% In[8]:


%%% get_ipython().run_line_magic('', 'The cashflow of a day is defined as the total sum of the purchases made on that day.')

cashflow(Day, Amount) :-
    day_purchase_prices(Day, Plist), % First gather the list of purchases with their costs
    findall(Cost, (
        member((_, Cost), Plist),  % then extract the second item from each tuple
        true
    ),AmountList),  % and gather those into a list
    sum_list(AmountList, Amount). % which is then folded

%%% get_ipython().run_line_magic('pinfo', '- cashflow(1, X).')



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

%%% get_ipython().run_line_magic('pinfo', '- client_purchase_prices(111111, X).')



% In[10]:


%%% get_ipython().run_line_magic('', '(internal) The total sum paid by the client across all their purchases.')

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



% In[ ]:




% Arrange for the main goal, which should be prolog/0, to be solved, and then halt
metaprolog :- prolog, halt.
:- initialization(metaprolog, program).
