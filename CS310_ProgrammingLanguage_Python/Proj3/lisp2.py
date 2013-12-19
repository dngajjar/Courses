#!/usr/bin/python

################ Lispy: Scheme Interpreter in Python

## (c) Peter Norvig, 2010; See http://norvig.com/lispy.html

################ Symbol, Env classes

from __future__ import division
import string

Symbol = str

class Env(dict):
    "An environment: a dict of {'var':val} pairs, with an outer Env."
    def __init__(self, parms=(), args=(), outer=None):
        self.update(zip(parms,args))
        self.outer = outer
        self.update(var = {})
    def find(self, var):
        "Find the innermost Env where var appears."
        return self if var in self else self.outer.find(var)

def add_globals(env):
    "Add some Scheme standard procedures to an environment."
    import math, operator as op
    env.update(vars(math)) # sin, sqrt, ...
    env.update(
     {'say': lambda x: say(x), 'quit' : goodbye,
      '+':op.add, '-':op.sub, '*':op.mul, '/':op.div, 'not':op.not_,
      '>':op.gt, '<':op.lt, '>=':op.ge, '<=':op.le, '=':op.eq, 
      'equal?':op.eq, 'eq?':op.is_, 'length':len, 'cons':lambda x,y:x+y,
      'car':lambda x:x[0],'cdr':lambda x:x[1:], 'append':op.add,  
      'list':lambda *x:list(x), 'list?': lambda x:isa(x,list), 
      'null?':lambda x:x==[], 'symbol?':lambda x: isa(x, Symbol), 'return': lambda x: x})
    return env

def say(x): return x
def goodbye(): print ";; Bye."; quit()
    
global_env = add_globals(Env())

depth = 0
isa = isinstance

################ eval

def eval(x, env=global_env):
    global depth
    "Evaluate an expression in an environment."
    if isa(x, Symbol):             # variable reference
        return env.find(x)[x]
    elif not isa(x, list):         # constant literal
        return x                
    elif x[0] == 'load':
      tmp = eval(x[1],env)
      return eload(tmp)
    elif  x[0] == 'quote' or  x[0] == "'":
        (_, exp) = x
        return exp
    elif x[0] == 'if':             # (if test conseq alt)
        if len(x) > 3: (_, test, conseq, alt) = x 
        else: (_, test, conseq) = x; alt = None
        return eval((conseq if eval(test, env) else alt), env)
    elif x[0] == 'set!':           # (set! var exp)
        (_, var, exp) = x
        env.find(var)[var] = eval(exp, env)
    elif x[0] == 'define':         # (define var exp)
        (_, var, exp) = x
        global_env['var'][var] = False
        env[var] = eval(exp, env)
    elif x[0] == 'let':
        nestedEnv = Env(outer=env)
        for local in x[1]:
          if isa(local, list):
            localVar = local[0]
            nestedEnv[localVar] = eval(local[1], nestedEnv)
          else:
            nestedEnv[local] = list()
        return eval(x[2], nestedEnv)
    elif x[0] == 'not':
        (_, cond) = x
        return not eval(cond, env)
    elif x[0] == 'have':
        (_, cond) = x
        return eval(cond, env)[0] in env.keys()
    elif x[0] == 'dolines':
        iterVar = x[1][0]
        filename = eval(x[1][1], env)
        returnValue = None   
        nestedEnv = Env(outer=env)
        with open(filename) as file:
            for line in file:
              nestedEnv[iterVar] = line
              returnValue = eval(x[2], nestedEnv)
        return returnValue
    elif x[0] == 'lambda':         # (lambda (var*) exp)
        (_, vars, exp) = x
        return lambda *args: eval(exp, Env(vars, args, env))
    elif x[0] == 'begin':          # (begin exp*)
        for exp in x[1:]:
            val = eval(exp, env)
        return val 
    elif x[0] == 'and':           # (and x y)
        if len(x) == 1: return True
        forms = x[1:]
        while forms:
            exp = [forms.pop(0)]+[forms.pop(0)] if forms[0] == "'" else forms.pop(0)
            if not eval(exp, env): return False
        return True
    elif x[0] == 'or':            # (or x y)
        if len(x) == 1: return False
        forms = x[1:]
        while forms:
            exp = [forms.pop(0)]+[forms.pop(0)] if forms[0] == "'" else forms.pop(0)
            if eval(exp, env): return True
        return False       
    elif x[0] == 'map':           # (map function list+)
        lsts = x[2:]
        proc = eval(x[1], env)
        minl = min([len(lsts[i]) for i in range(1, len(lsts), 2)])
        num = len(lsts)
        lst = []
        for s in range(minl):
            exps = [eval(lsts[k][s], env) for k in range(1, num, 2)]
            tmp = proc(*exps)
            lst += [tmp]
        return lst
    elif x[0] == 'reduce':         # (reduce function list [initialValue])
        proc = eval(x[1], env)
        lst = x[3]
        if len(x) > 4:
            ini = eval(x[4], env)
            for s in lst: ini = proc(*[ini, eval(s, env)])
        else: 
            ini = lst[0]
            for s in lst[1:]: ini = proc(*[ini, eval(s, env)])
        return ini        
    elif x[0] == 'dotimes':        # (dotimes (variable maxValue [result]) form)
        iteVal = x[1][0]
        maxVal = eval(x[1][1], env)
        returnVal = None;
        nestedEnv = Env(outer = env)
        for var in range(maxVal):
            nestedEnv[iteVal] = var
            returnVal = eval(x[2], nestedEnv)
        if len(x[1]) < 3:
            result = maxVal
        else: 
            result = eval(x[1][2:][0], env) if len(x[1][2:]) == 1 else eval(x[1][2:], env)        
        return returnVal if not returnVal else result    
    elif x[0] == 'dolist':        # (dolist (variable list [result]) form))
        iteVal = x[1][0]
        lst = eval([x[1][1]] + [x[1][2]], env)
        returnVal = None;
        nestedEnv = Env(outer = env)
        for var in lst:
            nestedEnv[iteVal] = var
            returnVal = eval(x[2], nestedEnv)
        if len(x[1]) < 4:
            result = [] 
        else:
            result = eval(x[1][3:][0], env) if len(x[1][3:]) == 1 else eval(x[1][3:], env)
        return returnVal if not returnVal else result
    elif x[0] == 'trace':          # (trace X)
        if len(x) > 1:
            global_env['var'][x[1]] = True
            print to_string([x[1]])
        if len(x) == 1:
            for k in global_env['var'].keys(): global_env['var'][k] = True
    elif x[0] == 'untrace':       # (untrace X)
        if len(x) > 1:
            global_env['var'][x[1]] = False
    else:                         # (proc exp*)   
        exps = [eval(exp, env) for exp in x]
        head = [x[0]] + exps[1:]
        flage = False
        if x[0] in global_env['var'].keys() and global_env['var'][x[0]]: 
            flage = True; print tabs(depth), depth, ':', to_string(head); depth += 1
        proc = exps.pop(0)
        tmp = proc(*exps)
        if flage:  depth -= 1; print tabs(depth), depth, ': returned ', tmp
        return tmp

################ parse, read, and user interaction

def read(s):
    "Read a Scheme expression from a string."
    return read_from(tokenize(s))

parse = read

def tokenize(s):
    "Convert a string into a list of tokens."
    f = s.replace('(',' ( ').replace(')',' ) ').replace('"', ' " ').split()
    if '"' in f:
        ind, tmp, newf = f.index('"'), '', []
        for i in range(ind+1, f.index('"', ind+1)): tmp += f[i]+ ' '
        f = f[:ind] + ['(']+ ["'"]+[tmp[:-1]]+[')']+f[f.index('"', ind+1)+1:] 
    return f

def read_from(tokens):
    "Read an expression from a sequence of tokens."
    if len(tokens) == 0:
        raise SyntaxError('unexpected EOF while reading')
    token = tokens.pop(0)
    if '(' == token:
        L = []
        while tokens[0] != ')':
            L.append(read_from(tokens))
        tokens.pop(0) # pop off ')'
        return L
    elif ')' == token:
        raise SyntaxError('unexpected )')
    else:
        return atom(token)

def atom(token):
    "Numbers become numbers; every other token is a symbol."
    try: return int(token)
    except ValueError:
        try: return float(token)
        except ValueError:
            return Symbol(token)

def to_string(exp):
    "Convert a Python object back into a Lisp-readable string."
    return '('+' '.join(map(to_string, exp))+')' if isa(exp, list) else str(exp)

def repl(prompt='lis.py> '):
    "A prompt-read-eval-print loop."
    print ";; LITHP ITH LITHTENING ...(v0.1)"
    while True:
        val = eval(parse(raw_input(prompt)))
        if val is not None: print to_string(val)
        
tabs = lambda n: '  ' * n

def sexp(s) :
  level,keep = 0,""
  while s:
    if s[0] == ";":
      while s and s[0] != "\n": s=s[1:]
      if not s: break
    if s[0] == "(": level += 1
    if level > 0  : keep += s[0]
    if s[0] == ")":  
      level -= 1
      if level==0:
        yield keep
        keep=""
    s = s[1:]
  if keep:
    yield keep

def eload(f) :
  with open(f) as contents:
    code = contents.read()
  for part in sexp(code):
      eval(parse(part))
      
import sys
if len(sys.argv) > 1:
  eload(sys.argv[1])
else:
  repl()
  quit()

#print parse("(begin (define r 3) (/ 3 (/ r r)))")