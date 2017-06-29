space-efficient-log
===

### results

Q1. For each log, how many benchmarks raised at least once?

    | log type           | num. benchmarks |
    | missing-blame      |               0 |
    | would-drop-flat    |              19 |
    | non-flat-leaf      |               0 |
    | chaperone-leaf     |               7 |
    | impersonate-leaf   |               0 |
    | drop-unequal-blame |              19 |

Q2. For each benchmark, how many times raised each log?

    | benchmark            | missing-blame | would-drop-flat | non-flat-leaf | chaperone-leaf | impersonate-leaf | drop-unequal-blame |
    | array.txt            |             0 |             300 |             0 |              0 |                0 |                300 |
    | dungeon-worst.txt    |             0 |           20784 |             0 |              0 |                0 |              27532 |
    | forth-bad.txt        |             0 |               0 |             0 |              0 |                0 |                  0 |
    | forth-worst.txt      |             0 |             116 |             0 |            326 |                0 |                485 |
    | fsm-bad.txt          |             0 |           20000 |             0 |              0 |                0 |              20000 |
    | fsmoo-bad.txt        |             0 |         2155994 |             0 |              0 |                0 |            2934651 |
    | fsmoo-worst.txt      |             0 |         2155994 |             0 |              0 |                0 |            2934651 |
    | fsm-worst-case.txt   |             0 |           20000 |             0 |              0 |                0 |              20000 |
    | graph.txt            |             0 |           25900 |             0 |              0 |                0 |              25900 |
    | gregor-worst.txt     |             0 |           58000 |             0 |              0 |                0 |              58000 |
    | jpeg.txt             |             0 |          149160 |             0 |              0 |                0 |             149160 |
    | kcfa-worst.txt       |             0 |               0 |             0 |              0 |                0 |                  0 |
    | lnm-worst.txt        |             0 |               2 |             0 |              0 |                0 |                  2 |
    | mbta-worst.txt       |             0 |               0 |             0 |              0 |                0 |                  0 |
    | morsecode-worst.txt  |             0 |               0 |             0 |              0 |                0 |                  0 |
    | quadBG-worst.txt     |             0 |            2114 |             0 |          31748 |                0 |              22864 |
    | quadMB-bad.txt       |             0 |               0 |             0 |              0 |                0 |                  0 |
    | quadMB-worst.txt     |             0 |            2085 |             0 |          30690 |                0 |              22772 |
    | snake-worst.txt      |             0 |               0 |             0 |              0 |                0 |                  0 |
    | suffixtree-worst.txt |             0 |               0 |             0 |              0 |                0 |                  0 |
    | synth.txt            |             0 |         5347603 |             0 |              0 |                0 |            5347603 |
    | synth-worst.txt      |             0 |        14074104 |             0 |            104 |                0 |           14074156 |
    | take5-worst.txt      |             0 |           31800 |             0 |              0 |                0 |              31800 |
    | tetris-worst.txt     |             0 |               0 |             0 |              0 |                0 |                  0 |
    | trie.txt             |             0 |               0 |             0 |              0 |                0 |                  0 |
    | trie-vector.txt      |             0 |             200 |             0 |          10302 |                0 |                398 |
    | zombie-worst.txt     |             0 |           12200 |             0 |          18300 |                0 |              17500 |
    | zordoz-worst.txt     |             0 |              37 |             0 |             15 |                0 |                 39 |


### Script to build table
    ```
    echo '| benchmark | non-flat-leaf | chaperone-leaf | impersonate-leaf | drop-unequal-blame |';
    for F in *.txt; do
      echo "| ${F} | $( ack 'space-efficient-non-flat-leaf: ' ${F} | wc -l ) | $( ack 'space-efficient-chaperone-leaf: ' ${F} | wc -l ) | $( ack 'space-efficient-impersonate-leaf: ' ${F} | wc -l ) | $( ack 'space-efficient-drop-unequal-blame: ' ${F} | wc -l ) |";
    done
    ```

### Script to create logs

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
