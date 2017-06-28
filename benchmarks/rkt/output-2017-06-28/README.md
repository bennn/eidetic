space-efficient-log
===

### results

Q1. For each log, how many benchmarks raised at least once?

    | log type           | count |
    |--------------------+-------|
    | non-flat-leaf      |     0 |
    | chaperone-leaf     |     8 |
    | impersonate-leaf   |     0 |
    | drop-unequal-blame |    20 |

Q2. For each benchmark, how many times raised each log?

    | benchmark        | non-flat-leaf | chaperone-leaf | impersonate-leaf | drop-unequal-blame |
    |------------------+---------------+----------------+------------------+--------------------|
    | acquire-worst    |             0 |           2790 |                0 |               7130 |
    | array            |             0 |              0 |                0 |                300 |
    | dungeon-worst    |             0 |              0 |                0 |              27532 |
    | forth-bad        |             0 |              0 |                0 |                  0 |
    | forth-worst      |             0 |            326 |                0 |                795 |
    | fsm-bad          |             0 |              0 |                0 |              20000 |
    | fsmoo-bad        |             0 |              0 |                0 |            3134871 |
    | fsmoo-worst      |             0 |              0 |                0 |            3134871 |
    | fsm-worst-case   |             0 |              0 |                0 |              20000 |
    | graph            |             0 |              0 |                0 |              25900 |
    | gregor-worst     |             0 |              0 |                0 |              58000 |
    | jpeg             |             0 |              0 |                0 |             149160 |
    | kcfa-worst       |             0 |              0 |                0 |                  0 |
    | lnm-worst        |             0 |              0 |                0 |                  2 |
    | mbta-worst       |             0 |              0 |                0 |                  0 |
    | morsecode-worst  |             0 |              0 |                0 |                  0 |
    | quadBG-worst     |             0 |          31748 |                0 |              22864 |
    | quadMB-bad       |             0 |              0 |                0 |                  0 |
    | quadMB-worst     |             0 |          30690 |                0 |              22772 |
    | snake-worst      |             0 |              0 |                0 |                  0 |
    | suffixtree-worst |             0 |              0 |                0 |                  0 |
    | synth            |             0 |              0 |                0 |            5347603 |
    | synth-worst      |             0 |            104 |                0 |           14074156 |
    | take5-worst      |             0 |              0 |                0 |              31800 |
    | tetris-worst     |             0 |              0 |                0 |                  0 |
    | trie             |             0 |              0 |                0 |                  0 |
    | trie-vector      |             0 |          10302 |                0 |                398 |
    | zombie-worst     |             0 |          18300 |                0 |              19900 |
    | zordoz-worst     |             0 |             15 |                0 |                 39 |


### Script to build table
    ```
    echo '| benchmark | non-flat-leaf | chaperone-leaf | impersonate-leaf | drop-unequal-blame |';
    for F in *.txt; do
      echo "| ${F} | $( ack 'space-efficient-non-flat-leaf: ' ${F} | wc -l ) | $( ack 'space-efficient-chaperone-leaf: ' ${F} | wc -l ) | $( ack 'space-efficient-impersonate-leaf: ' ${F} | wc -l ) | $( ack 'space-efficient-drop-unequal-blame: ' ${F} | wc -l ) |";
    done
    ```

### Script to collect logs

```
    RACOC=raco-contract
    RACKETC=racket-contract
    for BM in array dungeon-worst forth-bad forth-worst fsm-bad fsmoo-bad fsmoo-worst fsm-worst-case graph gregor-worst jpeg kcfa-worst lnm-worst mbta-worst morsecode-worst quadBG-worst quadMB-bad quadMB-worst snake-worst suffixtree-worst synth synth-worst take5-worst tetris-worst trie trie-vector zombie-worst zordoz-worst; do
      cd ${BM};
      rm -r compiled; ${RACOC} make main.rkt;
      PLTSTDERR="error info@space-efficient-non-flat-leaf info@space-efficient-chaperone-leaf info@space-efficient-impersonator-leaf info@space-efficient-drop-unequal-blame" ${RACKETC} main.rkt >& OUTPUT.txt
      cd ..;
    done;
```
