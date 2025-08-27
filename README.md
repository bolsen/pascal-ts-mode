# Tree Sitter Emacs Mode for Pascal

This is a quick-and-dirty (for now) Emacs mode for the Pascal tree-sitter grammar. It just does syntax highlighting but piggy-backs on opascal-mode for everything else.

The ancillary utilities (flycheck, compile mode) only target Free Pascal. Thus, they are named `*-free-pascal.el`.

# Installation

This is not on MELPA.

1. Clone the repo
2. Run `(treesit-install-language-grammar)` and use the grammar from here: [https://github.com/bolsen/tree-sitter-pascal](https://github.com/bolsen/tree-sitter-pascal). (This is my fork, which I started to fix small issues in, until I can fully recommend the original Isopod/tree-sitter-pascal version. Using the upstream version will break highlighting completely.)
2. Add to your init file: `(load-file "path-to/pascal-ts-mode.el")`

# References

- [https://www.masteringemacs.org/article/lets-write-a-treesitter-major-mode](https://www.masteringemacs.org/article/lets-write-a-treesitter-major-mode)
- I took a lot of hints from `ada-ts-mode`: [https://github.com/brownts/ada-ts-mode](https://github.com/brownts/ada-ts-mode).

# Improvements over opascal-mode

Besides using tree-sitter, what made me try this (and also easy to do and "modernizing" in the process):

1. TS parser recognizes keywords in the form of `Procedure` as well as `procedure`.
2. Preprocessor directives are properly colored and not treated like comments
3. Types and variables, in the right places, are highlighted better.
4. Highlighting different types of procedure/function declarations are better.

# Flycheck mode

Also included is a simple flycheck mode to run the FPC compiler to check for errors.

To setup:

```
(load-file "path-to/flycheck-free-pascal.el")
(setq flycheck-free-pascal-executable "path/to/fpc")
```

If you use `lsp-mode`, you need to chain this with LSP. There is a syntax check mode in LSP (genericptr fork), but at the moment, I don't have it working. In this case, you can just chain the checker. If the server supports syntax and semantic checks to the level of the compiler output, then this handler can be removed.

```
(flycheck-add-next-checker 'lsp 'free-pascal)
```

# M-x compile

Free Pascal is not supported in Emacs by default, but all that's needed is to have a regexes to detect error/warning lines from the compiler output. To setup:

```
(load-file "path-to/flycheck-free-pascal.el")
(complication-free-pascal)
```

# TODO

These forms are not handled correctly by tree-sitter at the moment, so they will not color correctly:

1. `function ToArray: TArray<T>; override; final;` : The `final` keyword is not implemented in tree-sitter (with `{$mode delphi}`. Example: `generics.collections.pas`).
2. `experimental` keyword is listed but it is not highlighting here.
3. The tree-sitter parser doesn't like this (line 795, generic.collections.pas in FP 3.2.2 ):
   ```
   TAVLTreeMap<TKey, TValue> = class(TCustomAVLTreeMap<TKey, TValue, TEmptyRecord>)
   public
       property Items; default;
   end;

    TIndexedAVLTreeMap<TKey, TValue> = class(TCustomAVLTreeMap<TKey, TValue, SizeInt>)
    ```
4. tree-sitter is strict with the order of `except` and `finally`. There can be a case where you have `finally` before an `except` but each is in a preprocessor `{$if...}`.

For this project:

1. Align more with the tree-sitter-pascal project's highlights.scm file.
2. Implement hooks to handle indentation.
3. Add other useful tools since tooling is otherwise sparse using Emacs (flycheck, better lsp-pascal)
