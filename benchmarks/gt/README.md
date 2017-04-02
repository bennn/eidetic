gt
===

Gradually typed benchmark programs,
 inspired by _Is Sound Gradual Typing Dead_, POPL 2016.

## Overview

Each folder in this directory must have:
- a `README.md` file documenting its source and purpose
- a `typed/` folder containing a Typed Racket program
- an `untyped/` folder containing a Racket program
- a `both/` folder of files that are common across the typed and untyped programs

The programs under `typed/` and `untyped/` must be semantically similar.
This property is not enforced.

Each folder in this directory may also contain:
- a `base/` folder, for data & libraries that are common to the typed and
  untyped programs, but take up more space


#### Why `base/` and `both/`?

The `both/` files will be copied in to configuration directories (explained below).
Copying is necesary for the _adaptor module_ pattern (not explained in this file).
The `base/` files are not copied in.

Bottom line: use `base/` if possible and `both/` if necessary.


#### Configuration directories

From the above directory structure, an external program will generate all
 _typed/untyped configurations_ made of some typed and some untyped modules.





## More Later
