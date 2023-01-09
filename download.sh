rm -rf demo &&
    mkdir demo &&
    cd demo &&
    curl -o demo.zip https://edu.postgrespro.ru/demo-small-20161013.zip &&
    unzip demo.zip &&
    rm -f demo.zip &&
    cd ..
