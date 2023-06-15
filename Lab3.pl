#!/usr/bin/swipl -q
%!/usr/bin/env python
% coding: utf-8

% In[188]:


%%% get_ipython().run_line_magic('', 'Purchaseable products')

%%% get_ipython().run_line_magic('', 'product(product_info{id:id, name:name, category:category, cost:unit_price}).')


%%% get_ipython().run_line_magic('', 'Clients')

%%% get_ipython().run_line_magic('', 'client(client_info{name:name, phone:phone_number}).')


%%% get_ipython().run_line_magic('', 'Purchase transactions')

%%% get_ipython().run_line_magic('', 'purchase(purchase_info{id:purchase_id, phone:client_phone, product_id:product_id, quantity:quantity, day_number:day_number}).')


%%% get_ipython().run_line_magic('', 'Client tiers, based on how much the client has spent')

%%% get_ipython().run_line_magic('', 'tier(tier_name, threshold)')


%%% get_ipython().run_line_magic('', 'This line is for interactive use.')


:- dynamic product/1.
:- dynamic purchase/1.
:- dynamic client/1.


%%% get_ipython().run_line_magic('pinfo', '- consult("DATABASE-ver2.plfact").')


%%% get_ipython().run_line_magic('', 'This line adds an invocation to the main program target.')

%%% get_ipython().run_line_magic('', 'The main program will be defined after this.')

prolog :- 
    consult("DATABASE-ver2.plfact"),
    fail.

%%% get_ipython().run_line_magic('pinfo', '- findall(Info, product(Info), Products).')



% In[189]:


%%% get_ipython().run_line_magic('', 'A repeat client is defined as a customer who has multiple purchases made on different days.')

repeat_client(PID) :-
    purchase(P1), _{phone:PID, day_number: D1} :< P1,
    purchase(P2), _{phone:PID, day_number: D2} :< P2,
    not(D1 = D2).
%%% get_ipython().run_line_magic('', '   purchase(pid, _f3, _f4, d2).')

%%% get_ipython().run_line_magic('pinfo', '- findall(X, repeat_client(X), _RC), list_to_set(_RC, RepeatClients).')



% In[190]:


%%% get_ipython().run_line_magic('', '(internal) The price of a particular purchase is the number of items involved in that purchase,')

%%% get_ipython().run_line_magic('', 'multiplied by the cost of an item.')

purchase_price(PurchaseId, PurchasePrice) :-
    purchase(P), _{id: PurchaseId, product_id: PI, quantity: Q} :< P,
    product(Pr), _{id: PI, cost: Uprice} :< Pr,
    PurchasePrice is Q*Uprice.
%%% get_ipython().run_line_magic('pinfo', '- purchase_price(1, X).')



% In[191]:


%%% get_ipython().run_line_magic('', '(internal) The list of all purchases on a particular day, along with their prices.')

day_purchase_prices(Day, Plist) :- 
    findall(PurchaseId, (
        purchase(Purch),
        _{id: PurchaseId, quantity: Count, day_number: Day} :< Purch
    ), DayPurchases),  % gather list of all purchases for the day
    findall((PurchaseId, PurchasePrice), % then associate purchaseids with a purchaseprice
        (
            member(PurchaseId, DayPurchases), % for the purchaseids in the purchases of the day only
            purchase_price(PurchaseId, PurchasePrice)
        ),
        Plist).

%%% get_ipython().run_line_magic('pinfo', '- day_purchase_prices(12, P).')



% In[192]:


%%% get_ipython().run_line_magic('', 'The cashflow of a day is defined as the total sum of the purchases made on that day.')

cashflow(Day, Amount) :-
    day_purchase_prices(Day, Plist), % First gather the list of purchases with their costs
    findall(Cost, (
        member((_, Cost), Plist),  % then extract the second item from each tuple
        true
    ),AmountList),  % and gather those into a list
    sum_list(AmountList, Amount). % which is then folded

%%% get_ipython().run_line_magic('pinfo', '- cashflow(12, X).')



% In[193]:


%%% get_ipython().run_line_magic('', '(internal) The list of purchases made by a specific client, along with their prices.')

client_purchase_prices(Cid, Plist) :- 
    client(C), _{phone: Cid} :< C,  % There must be a client with this id.
    findall(PurchaseId, (
        purchase(Purch),
        _{id: PurchaseId, phone: Cid, quantity: Count} :< Purch
    ), ClientPurchases),
    findall((PurchaseId, PurchasePrice),
        (
            member(PurchaseId, ClientPurchases), % for the purchaseids in the purchases of the day only
            purchase_price(PurchaseId, PurchasePrice)
        ),
        Plist).

%%% get_ipython().run_line_magic('pinfo', '- client_purchase_prices("+7 999 123 45 67", X).')



% In[194]:


%%% get_ipython().run_line_magic('', 'The total sum paid by the client across all their purchases.')

client_spent(Cid, Amount) :-
    client(C), _{phone: Cid} :< C,  % There must be a client with this id.
    client_purchase_prices(Cid, Plist),
    findall(Cost, member((_, Cost), Plist), AmtList),
    sum_list(AmtList, Amount).
%%% get_ipython().run_line_magic('pinfo', '- findall((X,Y), client_spent(X,Y), Spendings).')



% In[195]:


%%% get_ipython().run_line_magic('', "The client's tier is defined as the largest tier whose threshold the client's purchase sum has exceeded.")

client_tier(Cid, Tier) :-
    client(C), _{phone: Cid} :< C,  % There must be a client with this id.
    client_spent(Cid, Amount),  % Check how much the client spent
    findall(PassedTierAmt, 
    (
        tier(_, PassedTierAmt),  % Get all tier amounts
        PassedTierAmt =< Amount  % that are smaller than that
    ), PassedTierAmts),
    max_list(PassedTierAmts, MaxTierAmt),  % then find the largest one
    tier(Tier, MaxTierAmt).  % and return the tier corresponding to it
    
%%% get_ipython().run_line_magic('pinfo', '- findall((X,Y), client_tier(X,Y), CTiers).')



% In[196]:


%%% get_ipython().run_line_magic('', 'The list of products per day is defined as the list of product names that feature in purchases for that day')

products_per_day(Day, ProductList) :- 
    findall(ProductId, (
        purchase(Purch), _{product_id: ProductId, day_number: Day} :< Purch
    ), ProductIdList),  % gather IDs
    findall(ProductName, (
        product(Prod), _{name: ProductName, id: Id} :< Prod, % then convert ID to name
        member(Id, ProductIdList)
    ), ProductList).
%%% get_ipython().run_line_magic('pinfo', '- products_per_day(13, X).')



% In[197]:


%%% get_ipython().run_line_magic('', 'The list of clients per product is defined as the list of names of the clients for whom there exists a purchase')

%%% get_ipython().run_line_magic('', 'for the product with the given ID.')

buyers_of_product(Pid, Buyers) :- 
    findall(BuyerId, (
        purchase(Purch), _{product_id: Pid, phone: BuyerId} :< Purch
    ), BuyerIds),  % gather list of buyer IDs
    list_to_set(BuyerIds, UniqBuyerIds),  % uniquify
    findall(Name, (
        client(C), _{phone: Bid, name: Name} :< C, % to names
        member(Bid, UniqBuyerIds)
    ), Buyers).

%%% get_ipython().run_line_magic('pinfo', '- findall((1, Names), buyers_of_product(1, Names), Answers).')

%%% get_ipython().run_line_magic('pinfo', '- findall((20, Names), buyers_of_product(20, Names), Answers).')



% In[198]:


%%% get_ipython().run_line_magic('', 'The list of categories by client is defined as the list of product categories that this client has bought.')

categories_by_client(Cid, Cats) :-
    findall(ProductId, (
        purchase(Purch), _{phone: Cid, product_id: ProductId} :< Purch
    ), ProductIds), % Gather list of categories
    findall(Cat, (
        member(Pid, ProductIds),  % for every product
        product(Prod), _{id: Pid, category: Cat} :< Prod   % find its category
    ), CatsMultiple),
    list_to_set(CatsMultiple, Cats).
%%% get_ipython().run_line_magic('pinfo', '- findall((Cid, Cats), (client(C), _{phone: Cid} :< C, categories_by_client(Cid, Cats)), Answers).')



% In[199]:


%%% get_ipython().run_line_magic('', 'A product category is defined as a (unique) category that a product has.')


product_cats_internal(Cats) :- findall(Cat, (product(Prod), _{category: Cat} :< Prod), CatsMulti), sort(CatsMulti, Cats).
product_category(Cat) :- product_cats_internal(Cats), member(Cat, Cats).

%%% get_ipython().run_line_magic('pinfo', '- findall(X, product_category(X), Xs).')



% In[200]:


%%% get_ipython().run_line_magic('', '------ Examples ------')

example1:-
    writeln("---- Example 1 ----"),
    writeln("Get list of repeat clients:"),
    setof(RepC, repeat_client(RepC), RepeatClients),
    writeln(RepeatClients).


% In[201]:


example2 :-
    writeln("---- Example 2 ----"),
    writeln("Get each client's total spending and tier:"),
    (
        client(C), _{name: Name, phone: Id} :< C,
        write(Name), write(":"),
        client_spent(Id, Spent),
        write(Spent), write(":"),
        client_tier(Id, Tier),
        write(Tier),
        nl,
        fail()
    );
    true.


% In[202]:


example3 :-
    writeln("---- Example 3 ----"),
    writeln("Get the products purchased on every day:"),
    findall(Day,(purchase(Purch), _{day_number: Day} :< Purch), DaysMulti),
    list_to_set(DaysMulti, Days),
    (
        member(Day, Days),
        products_per_day(Day, ProductsMulti),
        list_to_set(ProductsMulti, Products),
        write(Day), write(":"), write(Products), nl, fail()
    );
    true.


% In[203]:


example4 :-
    writeln("---- Example 4 ----"),
    writeln("Get the cashflow for every day:"),
    findall(Day,(purchase(Purch), _{day_number: Day} :< Purch), DaysMulti),
    list_to_set(DaysMulti, Days),
    (
        member(Day, Days),
        cashflow(Day, Cash),
        write(Day), write(":"), write(Cash), nl, fail()
    );
    true.


% In[204]:


example5 :-
    writeln("---- Example 5 ----"),
    writeln("Get the categories of product purchased by every client:"),
    writeln("(the last client does not purchase meat products)"),
    (
        client(C), _{name: ClientName, phone: Cid} :< C,
        categories_by_client(Cid, Cats),
        write(ClientName), write(":"), write(Cats), nl, fail()
    );
    true.


% In[205]:


example6 :-
    writeln("---- Example 6 ----"),
    writeln("Which categories does a client not buy?"), fail;
    (
        product_category(Category), % Get a product category,
        client(C), _{name: ClientName, phone: Cid} :< C,  % Then get a client,
        \+ (  % And make sure that
            purchase(Purch), _{product_id: Pid, phone: Cid} :< Purch, % there is no purchase such
            product(Prod), _{id: Pid, category: Category} :< Prod % that the product has the given category,
        ),
        write("Client "), write(ClientName), write(" does not buy category "), write(Category), nl,
        fail
    );
    true.


% In[206]:


say_hi(Request) :- 
    reply_json(_{
        hello: world,
        try_me: [
            _{method: "GET", url:"/purchases"},
            _{method: "GET", url:"/clients"},
            _{method: "GET", url:"/products"},
            _{method: "GET", url:"/products/<:id>", args: _{id: int}},
            _{method: "POST", url:"/products", data: _{id: int, name: str, category: str, cost: int}},
            _{method: "POST", url:"/purchases", data: _{id: int, phone: str, product_id: int, quantity: int, day: int}},
            _{method: "POST", url:"/clients", data: _{phone: str, name: str}}

        ]
    }).

product_info(Pid, Prod) :-
    product(Prod), _{id: Pid} :< Prod.


products_list(Request) :- 
    findall(Prod, product(Prod), Products),
    reply_json(Products).

product(get, ProductIdStr, Request) :-
    atom_number(ProductIdStr, ProductId),
    product_info(ProductId, Prod),
    reply_json(Prod).

purchase_info(Pid, Purch) :- 
    purchase(Purchinfo), _{id: Pid, phone: Cid, product_id: ProdId, quantity: Quantity, day_number: Day} :< Purchinfo,
    client_info(Cid, Cli),
    product_info(ProdId, Prod),
    Purch = _{id: Pid, client_id: Cid, product_id: ProdId, quantity: Quantity, day: Day,
        expand: _{
            client: Cli,
            product: Prod
        }%,
    }.

purchases_list(Request) :-
    findall(Purch, purchase_info(Pid, Purch), Purchases),
    reply_json(Purchases).

purchase(get, PurchaseIdStr, Request) :-
    atom_number(PurchaseIdStr, PurchaseId),
    purchase_info(PurchaseId, Purch),
    reply_json(Purch).

client_info(Cid, Cli) :- 
    client(_{name:Name, phone:Cid}),  % As an example, some properties of the client are being calculated here
    client_spent(Cid, Amt),
    client_tier(Cid, Tier),
    Cli = _{name: Name, id: Cid, amount_spent: Amt, loyalty_tier: Tier}.

clients_list(Request) :-
    findall(Cli, client_info(Cid, Cli), Clients),
    reply_json(Clients).

client(get, ClientIdStr, Request) :-
    atom_number(ClientIdStr, ClientId),
    client_info(ClientId, Client),
    reply_json(Client).
    
    

product(post, Request) :-
    http_read_json(Request, NewProduct, [json_object(dict)]),
    _{id: IdStr, name: Name, category: Cat, cost: CostStr} :< NewProduct,
    atom_number(IdStr, IdInt), atom_number(CostStr, CostInt),
    assert(product(product_info{id: IdInt, name: Name, category: Cat, cost: CostInt})),
    
    format(string(Ref), "/products/~d", [IdInt]),
    reply_json(_{status: ok, ref: Ref}).

client(post, Request) :- 
    http_read_json(Request, NewClient, [json_object(dict)]),
    _{name: Name, phone: Phone} :< NewClient,
    assert(client(client_info{name: Name, phone: Phone})),
    reply_json(_{status: ok}).


purchase(post, Request) :-
    http_read_json(Request, NewPurchase, [json_object(dict)]),
    _{
        id: IdStr,
        phone: Phone,
        quantity: QuantityStr,
        day: DayNumberStr
    } :< NewPurchase,
    atom_number(IdStr, Id),
    atom_number(ProductIdStr, ProductId),
    atom_number(QuantityStr, Quantity),
    atom_number(DayNumberStr, DayNumber),
    assert(purchase(purchase_info{
        id: Id, phone: Phone,
        product_id: ProductId,
        quantity: Quantity,
        day: DayNumber
    })),
    format(string(Ref), "/purchases/~d", [Id]),
    reply_json(_{status: ok, ref: Ref}).

products_root(get, Request) :- products_list(Request).
products_root(post, Request) :- product(post, Request).

purchases_root(get, Request) :- purchases_list(Request).
purchases_root(post, Request) :- purchase(post, Request).


    

example7 :- 
    writeln("---- Example 7 ----"),
    writeln("Run a simple HTTP server that returns JSON data about the database"),
    writeln("and allows adding new facts into the database (in memory only)"),
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
    use_module(library(http/json_convert)),
    use_module(library(http/http_json)),
    http_handler(root(.), say_hi, []),
    http_handler(root(products), products_root(Method), [methods([get, post])]),
    http_handler(root(products/ProductId), product(get, ProductId), [methods([get])]),
    http_handler(root(purchases), purchases_root(Method), [methods([get, post])]),
    http_handler(root(purchases/PurchaseId), purchase(Methos, PurchaseId), [methods([get])]),
    http_handler(root(clients), clients_root(Method), [methods([get, post])]),

    
    
    
    writeln("Starting server on port 8080!!"),
    http_server(http_dispatch, [port(8080)]),
    writeln("Type any Prolog term then press Enter to stop..."),
    read(X).


% In[ ]:


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
