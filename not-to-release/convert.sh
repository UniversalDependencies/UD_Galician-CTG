#!/bin/bash

udapy -h >/dev/null || { echo "udapy is not installed, see https://github.com/udapi/udapi-python"; exit 1; }

for a in train dev test; do
    cat gl-ud-$a.conllu | udapy -s \
      read.Conllu \
      read.AddSentences files=raw_$a.txt \
      ud.ComplyWithText \
      ud.JoinAsMwt \
      ud.gl.To2 \
      ud.Convert1to2 \
      util.Eval tree="tree.bundle.bundle_id='$a-'+tree.bundle.bundle_id" \
    > ../gl-ud-$a.conllu
done

cat ../gl-ud-{train,dev,test}.conllu | udapy -HAMC ud.MarkBugs skip='no-(PronType|VerbForm|NumType)' > bugs.html
