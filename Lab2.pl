#!/usr/bin/swipl -q
%!/usr/bin/env python
% coding: utf-8

% In[1]:


%%% get_ipython().run_line_magic('', 'Purchaseable products')

%%% get_ipython().run_line_magic('', 'product(id, name, category, unit_price).')


%%% get_ipython().run_line_magic('', 'Clients')

%%% get_ipython().run_line_magic('', 'client(name, phone_number).')


%%% get_ipython().run_line_magic('', 'Purchase transactions')

%%% get_ipython().run_line_magic('', 'purchase(purchase_id, client_phone, product_id, quantity, day_number).')


%%% get_ipython().run_line_magic('', 'Client tiers, based on how much the client has spent')

%%% get_ipython().run_line_magic('', 'tier(tier_name, threshold)')


%%% get_ipython().run_line_magic('', 'This line is for interactive use.')

%%% get_ipython().run_line_magic('pinfo', '- consult("DATABASE.plfact").')


%%% get_ipython().run_line_magic('', 'This line adds an invocation to the main program target.')

%%% get_ipython().run_line_magic('', 'The main program will be defined after this.')

prolog :- 
    consult("DATABASE.plfact"),
    fail.

%%% get_ipython().run_line_magic('pinfo', '- findall((X,Y,Z,T), product(X,Y,Z,T), Products).')



% In[2]:


%%% get_ipython().run_line_magic('', 'A repeat client is defined as a customer who has multiple purchases made on different days.')

repeat_client(PID) :-
    purchase(_,PID, _, _, D1),
    purchase(_,PID, _, _, D2),
    not(D1 = D2).
%%% get_ipython().run_line_magic('', '   purchase(pid, _f3, _f4, d2).')

%%% get_ipython().run_line_magic('pinfo', '- findall(X, repeat_client(X), _RC), list_to_set(_RC, RepeatClients).')



% In[3]:


%%% get_ipython().run_line_magic('', '(internal) The price of a particular purchase is the number of items involved in that purchase,')

%%% get_ipython().run_line_magic('', 'multiplied by the cost of an item.')

purchase_price(PurchaseId, PurchasePrice) :-
    purchase(PurchaseId, _, ProductId, ProductCount, _),
    product(ProductId, _, _, UnitPrice),
    PurchasePrice is ProductCount*UnitPrice.
%%% get_ipython().run_line_magic('pinfo', '- purchase_price(1, X).')



% In[4]:


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



% In[5]:


%%% get_ipython().run_line_magic('', 'The cashflow of a day is defined as the total sum of the purchases made on that day.')

cashflow(Day, Amount) :-
    day_purchase_prices(Day, Plist), % First gather the list of purchases with their costs
    findall(Cost, (
        member((_, Cost), Plist),  % then extract the second item from each tuple
        true
    ),AmountList),  % and gather those into a list
    sum_list(AmountList, Amount). % which is then folded

%%% get_ipython().run_line_magic('pinfo', '- cashflow(12, X).')



% In[6]:


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



% In[7]:


%%% get_ipython().run_line_magic('', 'The total sum paid by the client across all their purchases.')

client_spent(Cid, Amount) :-
    client(_, Cid),  % There must be a client with this id.
    client_purchase_prices(Cid, Plist),
    findall(Cost, member((_, Cost), Plist), AmtList),
    sum_list(AmtList, Amount).
%%% get_ipython().run_line_magic('pinfo', '- findall((X,Y), client_spent(X,Y), Spendings).')



% In[8]:


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



% In[9]:


%%% get_ipython().run_line_magic('', 'The list of products per day is defined as the list of product names that feature in purchases for that day')

products_per_day(Day, ProductList) :- 
    findall(ProductId, purchase(_,_,ProductId,_,Day), ProductIdList),  % gather IDs
    findall(ProductName, (
        product(Id, ProductName, _, _),  % then convert ID to name
        member(Id, ProductIdList)
    ), ProductList).
%%% get_ipython().run_line_magic('pinfo', '- products_per_day(13, X).')



% In[10]:


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



% In[11]:


%%% get_ipython().run_line_magic('', 'The list of categories by client is defined as the list of product categories that this client has bought.')

categories_by_client(Cid, Cats) :-
    findall(ProductId, purchase(_, Cid, ProductId, _, _), ProductIds), % Gather list of categories
    findall(Cat, (
        member(Pid, ProductIds),  % for every product
        product(Pid, _, Cat, _)   % find its category
    ), CatsMultiple),
    list_to_set(CatsMultiple, Cats).
%%% get_ipython().run_line_magic('pinfo', '- findall((Cid, Cats), (client(_, Cid), categories_by_client(Cid, Cats)), Answers).')



% In[12]:


%%% get_ipython().run_line_magic('', 'A product category is defined as a (unique) category that a product has.')


product_cats_internal(Cats) :- findall(Cat, product(_,_,Cat,_), CatsMulti), sort(CatsMulti, Cats).
product_category(Cat) :- product_cats_internal(Cats), member(Cat, Cats).

%%% get_ipython().run_line_magic('pinfo', '- findall(X, product_category(X), Xs).')



% In[13]:


%%% get_ipython().run_line_magic('', '------ Examples ------')

example1:-
    writeln("---- Example 1 ----"),
    writeln("Get list of repeat clients:"),
    setof(RepC, repeat_client(RepC), RepeatClients),
    writeln(RepeatClients).


% In[14]:


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


% In[15]:


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


% In[16]:


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


% In[17]:


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


% In[18]:


example6 :-
    writeln("---- Example 6 (new!) ----"),
    writeln("Which categories does a client not buy?"), fail;
    (
        product_category(Category), % Get a product category,
        client(ClientName, Cid),  % Then get a client,
        \+ (  % And make sure that
            purchase(_, Cid, Pid, _, _),  % there is no purchase such
            product(Pid, _, Category, _) % that the product has the given category,
        ),
        write("Client "), write(ClientName), write(" does not buy category "), write(Category), nl,
        fail
    );
    true.


% In[19]:


say_hi(Request) :- 
    reply_json(_{
        hello: world,
        try_me: [
            "/purchases",
            "/products",
            "/clients"
        ]
    }).

product_info(Pid, Prod) :-
    product(Pid, Name, Cat, Cost),
    Prod = _{ id: Pid, name: Name, category: Cat, cost: Cost}.


products_list(Request) :- 
    findall(Prod, product_info(Pid, Prod), Products),
    reply_json(Products).


purchase_info(Pid, Purch) :- 
    purchase(Pid, Cid, ProdId, Quantity, Day),
    client_info(Cid, Cli),
    Purch = _{id: Pid, client_id: Cid, product_id: ProdId, quantity: Quantity, day: Day,
        expand: _{
            client: Cli%,
        }%,
    }.

purchases_list(Request) :-
    findall(Purch, purchase_info(Pid, Purch), Purchases),
    reply_json(Purchases).

client_info(Cid, Cli) :- 
    client(Name, Cid), % As an example, some properties of the client are being calculated here
    client_spent(Cid, Amt),
    client_tier(Cid, Tier),
    Cli = _{name: Name, id: Cid, amount_spent: Amt, loyalty_tier: Tier}.

clients_list(Request) :-
    findall(Cli, client_info(Cid, Cli), Clients),
    reply_json(Clients).



example7 :- 
    writeln("---- Example 7 (new!) ----"),
    writeln("Run a simple HTTP server that returns JSON data about the database"),
    fail;
    
%%% get_ipython().run_line_magic('', 'If the `run_web_server/0` is not defined, then exit early with a message.')

    \+ current_predicate(run_web_server/0),
    writeln("!!!!! The web server is disabled in the config. Assert `run_web_server/0` to enable it"),
    true;
    
%%% get_ipython().run_line_magic('', 'If it is defined and true, instantiate the server.')

    current_predicate(run_web_server/0),
    run_web_server,
    use_module(library(http/thread_httpd)),
    use_module(library(http/http_dispatch)),
    use_module(library(http/http_json)),
    http_handler(root(.), say_hi, []),
    http_handler(root(products), products_list, []),
    http_handler(root(purchases), purchases_list, []),
    http_handler(root(clients), clients_list, []),

    
    
    writeln("Starting server on port 8080!!"),
    http_server(http_dispatch, [port(8080)]),
    writeln("Type any Prolog term then press Enter to stop..."),
    read(X).


% In[20]:


prolog :-
    example1,
    example2,
    example3,
    example4,
    example5,
    example6,
    example7.
%%% get_ipython().run_line_magic('pinfo', '- prolog.')



% In[ ]:





% In[ ]:




% Arrange for the main goal, which should be prolog/0, to be solved, and then halt
metaprolog :- prolog, halt.
:- initialization(metaprolog, program).
