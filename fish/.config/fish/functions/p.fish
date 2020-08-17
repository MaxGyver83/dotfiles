function p --description 'Return running processes'
    ps wup (pgrep -f "$argv")
end
