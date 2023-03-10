PWD := `pwd`

# Show dot files in this directory
show:
    #!/bin/bash
    for file in `find src -type f`; do
        echo $file
    done

# Create symbolic link to home directory
link TARGET:
    #!/bin/bash
    for dir in `find src -type d -not -name src`; do
        if [[ {{TARGET}} == *$dir* || {{TARGET}} == "all" ]]; then
            dir_path=$HOME/${dir#src/}
            if [[ ! -d $dir_path ]]; then
                echo "Create: $dir_path"
                mkdir $dir_path
            fi
        fi
    done
    for file in `find src -type f`; do
        if [[ {{TARGET}} == $file || {{TARGET}} == "all" ]]; then
            file_path=$HOME/${file#src/}
            if [[ -f $file_path ]]; then
                if [[ -L $file_path ]]; then
                    unlink $file_path
                else
                    echo "Backup: $file_path"
                    echo "    -> ${file_path}_bup"
                    mv $file_path ${file_path}_bup
                fi
            fi
            echo "Link: $file_path"
            echo "    -> ./$file"
            ln -s {{PWD}}/$file $file_path
        fi
    done