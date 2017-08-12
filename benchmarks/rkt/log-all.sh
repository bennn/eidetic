for BM in acquire-worst array combinations dungeon-worst forth-bad forth-worst fsm-bad fsmoo-bad fsmoo-worst fsm-worst-case graph gregor-worst hanoi jpeg kcfa-worst lnm-worst mbta-worst morsecode-worst quadBG-worst quadMB-bad quadMB-worst snake-worst suffixtree-worst synth synth-worst take5-worst tetris-worst trie trie-vector zombie-worst zordoz-worst; do
  cd ${BM};
  # base
  RCO="/home/ben/code/racket/base/bin/raco"
  RKT="/home/ben/code/racket/base/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout" main.rkt >& base.log;
  # mono
  RCO="/home/ben/code/racket/mono/bin/raco"
  RKT="/home/ben/code/racket/mono/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss" main.rkt >& mono.log;
  # poly
  RCO="/home/ben/code/racket/poly/bin/raco"
  RKT="/home/ben/code/racket/poly/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss" main.rkt >& poly.log;
  # spec
  RCO="/home/ben/code/racket/spec/bin/raco"
  RKT="/home/ben/code/racket/spec/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout" main.rkt >& spec.log;
  # anyc
  RCO="/home/ben/code/racket/anyc/bin/raco"
  RKT="/home/ben/code/racket/anyc/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-merge-any" main.rkt >& anyc.log;
  # spec-anyc
  RCO="/home/ben/code/racket/spec-anyc/bin/raco"
  RKT="/home/ben/code/racket/spec-anyc/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-merge-any" main.rkt >& spec-anyc.log;
  # mono-anyc
  RCO="/home/ben/code/racket/mono-anyc/bin/raco"
  RKT="/home/ben/code/racket/mono-anyc/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss info@space-efficient-merge-any" main.rkt >& mono-anyc.log;
  # poly-anyc
  RCO="/home/ben/code/racket/poly-anyc/bin/raco"
  RKT="/home/ben/code/racket/poly-anyc/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss info@space-efficient-merge-any" main.rkt >& poly-anyc.log;
  # mono-spec
  RCO="/home/ben/code/racket/mono-spec/bin/raco"
  RKT="/home/ben/code/racket/mono-spec/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss" main.rkt >& mono-spec.log;
  # poly-spec
  RCO="/home/ben/code/racket/poly-spec/bin/raco"
  RKT="/home/ben/code/racket/poly-spec/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss" main.rkt >& poly-spec.log;
  # mono-spec-anyc
  RCO="/home/ben/code/racket/mono-spec-anyc/bin/raco"
  RKT="/home/ben/code/racket/mono-spec-anyc/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss info@space-efficient-merge-any" main.rkt >& mono-spec-anyc.log;
  # poly-spec-anyc
  RCO="/home/ben/code/racket/poly-spec-anyc/bin/raco"
  RKT="/home/ben/code/racket/poly-spec-anyc/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss info@space-efficient-merge-any" main.rkt >& poly-spec-anyc.log;
  cd ..;
done;

