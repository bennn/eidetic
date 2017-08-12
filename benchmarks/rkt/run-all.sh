ITERS=20
for BM in acquire-worst array combinations dungeon-worst forth-bad forth-worst fsm-bad fsmoo-bad fsmoo-worst fsm-worst-case graph gregor-worst hanoi jpeg kcfa-worst lnm-worst mbta-worst morsecode-worst quadBG-worst quadMB-bad quadMB-worst snake-worst suffixtree-worst synth synth-worst take5-worst tetris-worst trie trie-vector zombie-worst zordoz-worst; do
  cd ${BM};
  for R in "master" "base" "mono" "poly" "spec" "anyc" "spec-anyc" "mono-anyc" "poly-anyc" "mono-spec" "poly-spec" "mono-spec-anyc" "poly-spec-anyc"; do
    RCO="/home/ben/code/racket/racket-contract/${R}/racket/bin/raco"
    RKT="/home/ben/code/racket/racket-contract/${R}/racket/bin/racket"
    find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; for i in `seq 0 ${ITERS}`; do ${RKT} main.rkt >> ${R}.txt; done;
  done
  cd ..;
done;
