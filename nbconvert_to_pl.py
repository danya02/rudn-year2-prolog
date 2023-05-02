#!/usr/bin/python3
import sys
import os

what = sys.argv[1]
target = what.replace('.py', '.pl')
with open(target, 'w') as outp, open(what) as inp:
    # Write header to run the program file
    print("#!/usr/bin/swipl -q", file=outp)

    for line in inp:
      line = line.replace('#', '%', 1)  # Comments are with percent signs
      if line.startswith('get_ipython().run_line_magic'):  # This is what jupyter magic to query facts interactively looks like
          print('%%% ' + line, file=outp)  # Those need to be commented-out.
      else:
          print(line, end='', file=outp)

    print('% Arrange for the main goal, which should be prolog/0, to be solved, and then halt', file=outp)
    print('metaprolog :- prolog, halt.', file=outp)
    print(':- initialization(metaprolog, program).', file=outp)

os.system(f'chmod +x "{target}"')
os.unlink(what)
