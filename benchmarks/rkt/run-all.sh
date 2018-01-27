ITERS=20
#  fsmoo-bad fsmoo-worst kcfa-worst
OUTPUT="output-2018-01-26"
for BM in acquire-worst array combinations dungeon-worst forth-bad forth-worst fsm-bad fsm-worst-case graph gregor-worst hanoi jpeg lnm-worst mbta-worst morsecode-worst quadBG-worst quadMB-bad quadMB-worst snake-worst suffixtree-worst synth synth-worst take5-worst tetris-worst trie trie-vector zombie-worst zordoz-worst; do
  cd ${BM} && \
  for R in "6.12"; do
    # run a Racket release
    RCO="/home/ben/code/racket/${R}/bin/raco"
    RKT="/home/ben/code/racket/${R}/bin/racket"
    find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; for i in `seq 0 ${ITERS}`; do ${RKT} main.rkt >> ${R}.txt; done;
    mv ${R}.txt ../${OUTPUT}/${BM}-${R}.txt
  done
  #for R in "base" "base-no-gunk" "base-enter-s-e-on-10"; do
  #  # run space-efficient Rackets
  #  RCO="/home/ben/code/racket/racket-contract/${R}/racket/bin/raco"
  #  RKT="/home/ben/code/racket/racket-contract/${R}/racket/bin/racket"
  #  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; for i in `seq 0 ${ITERS}`; do ${RKT} main.rkt >> ${R}.txt; done;
  #  mv ${R}.txt ../${OUTPUT}/${BM}-${R}.txt
  #done
  cd ..;
done;
