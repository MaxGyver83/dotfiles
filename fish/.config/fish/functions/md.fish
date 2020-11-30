function md -d "transform markdown file to html and open in firefox"
    set input $argv[1]
    set output /tmp/(basename $input).html
    pandoc $input -t html -o $output && firefox $output
end
