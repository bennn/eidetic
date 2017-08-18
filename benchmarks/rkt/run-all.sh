ITERS=20
#  fsmoo-bad fsmoo-worst kcfa-worst
for BM in acquire-worst array combinations dungeon-worst forth-bad forth-worst fsm-bad fsm-worst-case graph gregor-worst hanoi jpeg lnm-worst mbta-worst morsecode-worst quadBG-worst quadMB-bad quadMB-worst snake-worst suffixtree-worst synth synth-worst take5-worst tetris-worst trie trie-vector zombie-worst zordoz-worst; do
  cd ${BM} && \
  for R in "base" "base-no-gunk" "base-enter-s-e-on-10"; do
    RCO="/home/ben/code/racket/racket-contract/${R}/racket/bin/raco"
    RKT="/home/ben/code/racket/racket-contract/${R}/racket/bin/racket"
    find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; for i in `seq 0 ${ITERS}`; do ${RKT} main.rkt >> ${R}.txt; done;
    mv ${R}.txt ../output-2017-08-20/${BM}-${R}.txt
  done
  cd ..;
done;
