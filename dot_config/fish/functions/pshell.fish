function pshell --wraps='eval (poetry env activate)' --description 'alias pshell=eval (poetry env activate)'
  eval (poetry env activate) $argv
        
end
