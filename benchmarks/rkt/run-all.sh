# E = experimental
# C = control
RACOE=raco-contract-2
RACKETE=racket-contract-2
RACOC=raco-contract
RACKETC=racket-contract
ITERS=20
for BM in acquire-worst array combinations dungeon-worst forth-bad forth-worst fsm-bad fsmoo-bad fsmoo-worst fsm-worst-case graph gregor-worst hanoi jpeg kcfa-worst lnm-worst mbta-worst morsecode-worst quadBG-worst quadMB-bad quadMB-worst snake-worst suffixtree-worst synth synth-worst take5-worst tetris-worst trie trie-vector zombie-worst zordoz-worst; do
  #cd ${BM};
  # rm -r compiled; ${RACOC} make main.rkt;
  # PLTSTDERR="error info@space-efficient-non-flat-leaf info@space-efficient-chaperone-leaf info@space-efficient-impersonator-leaf info@space-efficient-drop-unequal-blame info@space-efficient-missing-blame info@space-efficient-would-drop-flat" ${RACKETC} main.rkt >& OUTPUT.txt
  #cp ${BM}/${RACKETE}.txt output-2017-07-28/${BM}-experimental.txt
  #cp ${BM}/${RACKETC}.txt output-2017-07-28/${BM}-master.txt
  #find . -name "compiled" | xargs rm -r; ${RACOE} make -v main.rkt; for i in `seq 0 ${ITERS}`; do ${RACKETE} main.rkt >> ${RACKETE}.txt; done;
  #find . -name "compiled" | xargs rm -r; ${RACOC} make -v main.rkt; for i in `seq 0 ${ITERS}`; do ${RACKETC} main.rkt >> ${RACKETC}.txt; done;
  #cd ..;
done;
