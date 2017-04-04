for BM in fsm-bad fsmoo-bad fsmoo-worst synth synth-worst; do
  cd ${BM};
  raco make -v main.rkt
  racket -W info@contract-wrapping main.rkt 2>&1 | sort | uniq -c > OUTPUT.txt;
  cd ..;
done;
