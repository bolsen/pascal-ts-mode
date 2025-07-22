# Tree Sitter Emacs Mode for Pascal

This is a quick-and-dirty (for now) Emacs mode for the Pascal tree-sitter grammar. It just does syntax highlighting but piggy-backs on opascal-mode for everything else.

# Installation

This is not on MELPA.

1. Clone the repo
2. Run `(treesit-install-language-grammar)` and use the grammar from here: [https://github.com/Isopod/tree-sitter-pascal](https://github.com/Isopod/tree-sitter-pascal).
2. Add to your init file: `(load-file "path-to/pascal-ts-mode.el")`

# References

- [https://www.masteringemacs.org/article/lets-write-a-treesitter-major-mode](https://www.masteringemacs.org/article/lets-write-a-treesitter-major-mode)
- I took a lot of hints from `ada-ts-mode`: [https://github.com/brownts/ada-ts-mode](https://github.com/brownts/ada-ts-mode).

# Improving over opascal-mode OOTB

Besides using tree-sitter, what made me try this (and also easy to do and "modernizing" in the process):

1. TS parser recognizes keywords in the form of `Procedure` as well as `procedure`.
2. Preprocessor directives are properly colored and not treated like comments
3. Types and variables, in the right places, are highlighted better.
4. Highlighting different types of procedure/function declarations are better.

# TODO

Figure out what to do with the forms:

1. `A := CallFunction;` : `CallFunction` would not be highlighted because it could be a function or a variable.
2. `Var.Func` : `Var` would not highlighted, because it can be a variable or a type.
