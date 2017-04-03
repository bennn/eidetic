for BM in acquire-worst dungeon-worst forth-bad forth-worst fsm-worst-case gregor-worst lnm-worst mbta-worst morsecode-worst quadBG-worst quadMB-bad quadMB-worst snake-worst suffixtree-worst tetris-worst zombie-worst zordoz-worst; do
  cd ${BM};
  raco make -v main.rkt
  racket -W info@contract-wrapping main.rkt 2>&1 | sort | uniq -c > OUTPUT.txt;
  cd ..;
done;
