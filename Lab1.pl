#!/usr/bin/swipl -q
%!/usr/bin/env python
% coding: utf-8

% In[1]:


hello(world).
hello(prolog).


% In[ ]:


%%% get_ipython().run_line_magic('pinfo', '- hello(X).')

%%% get_ipython().run_line_magic('pinfo', '- retry.')

%%% get_ipython().run_line_magic('pinfo', '- retry.')



% In[3]:


prolog :- forall(
    (Goal = hello(X), call(Goal)),
    (write(Goal), nl)
).


% In[4]:


%%% get_ipython().run_line_magic('pinfo', '- prolog.')



% In[ ]:




% Arrange for the main goal, which should be prolog/0, to be solved, and then halt
metaprolog :- prolog, halt.
:- initialization(metaprolog, program).
