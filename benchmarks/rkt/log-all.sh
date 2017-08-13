for BM in acquire-worst array combinations dungeon-worst forth-bad forth-worst fsm-bad fsmoo-bad fsmoo-worst fsm-worst-case graph gregor-worst hanoi jpeg kcfa-worst lnm-worst mbta-worst morsecode-worst quadBG-worst quadMB-bad quadMB-worst snake-worst suffixtree-worst synth synth-worst take5-worst tetris-worst trie trie-vector zombie-worst zordoz-worst; do
  # base
  RCO="/home/ben/code/racket/racket-contract/base/racket/bin/raco"
  RKT="/home/ben/code/racket/racket-contract/base/racket/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout" main.rkt >& base.log;
  # mono
  RCO="/home/ben/code/racket/racket-contract/mono/racket/bin/raco"
  RKT="/home/ben/code/racket/racket-contract/mono/racket/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss" main.rkt >& mono.log;
  # poly
  RCO="/home/ben/code/racket/racket-contract/poly/racket/bin/raco"
  RKT="/home/ben/code/racket/racket-contract/poly/racket/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss" main.rkt >& poly.log;
  # spec
  RCO="/home/ben/code/racket/racket-contract/spec/racket/bin/raco"
  RKT="/home/ben/code/racket/racket-contract/spec/racket/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout" main.rkt >& spec.log;
  # anyc
  RCO="/home/ben/code/racket/racket-contract/anyc/racket/bin/raco"
  RKT="/home/ben/code/racket/racket-contract/anyc/racket/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-merge-any" main.rkt >& anyc.log;
  # spec-anyc
  RCO="/home/ben/code/racket/racket-contract/spec-anyc/racket/bin/raco"
  RKT="/home/ben/code/racket/racket-contract/spec-anyc/racket/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-merge-any" main.rkt >& spec-anyc.log;
  # mono-anyc
  RCO="/home/ben/code/racket/racket-contract/mono-anyc/racket/bin/raco"
  RKT="/home/ben/code/racket/racket-contract/mono-anyc/racket/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss info@space-efficient-merge-any" main.rkt >& mono-anyc.log;
  # poly-anyc
  RCO="/home/ben/code/racket/racket-contract/poly-anyc/racket/bin/raco"
  RKT="/home/ben/code/racket/racket-contract/poly-anyc/racket/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss info@space-efficient-merge-any" main.rkt >& poly-anyc.log;
  # mono-spec
  RCO="/home/ben/code/racket/racket-contract/mono-spec/racket/bin/raco"
  RKT="/home/ben/code/racket/racket-contract/mono-spec/racket/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss" main.rkt >& mono-spec.log;
  # poly-spec
  RCO="/home/ben/code/racket/racket-contract/poly-spec/racket/bin/raco"
  RKT="/home/ben/code/racket/racket-contract/poly-spec/racket/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss" main.rkt >& poly-spec.log;
  # mono-spec-anyc
  RCO="/home/ben/code/racket/racket-contract/mono-spec-anyc/racket/bin/raco"
  RKT="/home/ben/code/racket/racket-contract/mono-spec-anyc/racket/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss info@space-efficient-merge-any" main.rkt >& mono-spec-anyc.log;
  # poly-spec-anyc
  RCO="/home/ben/code/racket/racket-contract/poly-spec-anyc/racket/bin/raco"
  RKT="/home/ben/code/racket/racket-contract/poly-spec-anyc/racket/bin/racket"
  find . -name "compiled" | xargs rm -r; ${RCO} make -v main.rkt; ${RKT} -W "error info@space-efficient-contract-bailout info@space-efficient-value-bailout info@space-efficient-inline-cache-access info@space-efficient-inline-cache-miss info@space-efficient-merge-any" main.rkt >& poly-spec-anyc.log;
  cd ..;
done;

