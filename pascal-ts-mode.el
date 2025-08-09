;;; pascal-ts-mode.el --- Major mode for Object Pascal using Tree-sitter  -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Brian Olsen

;; Author: Brian Olsen <brian@bolsen.org>
;; Created: July 2025
;; Keywords: pascal languages tree-sitter
;; URL: https://gitlab.com/bolsen80/pascal-ts-mode
;; Package-Requires: ((emacs "29.1"))

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This packages provides basic Pascal syntax highlighting using tree-sitter.
;; It uses `opascal-mode' for everything else. Before using this, you need
;; the proper grammar installed.

;;; Code:

(require 'opascal)

(defconst pascal-ts-mode--keywords
  (mapcar #'list ;; Keywords.
          '(
            kAbsolute kAbstract kAnd kArray kAs kAsm kAssembler kAt
            kBegin
            kCase kCdecl kCppdecl kClass kCvar kConst kConstref kConstructor
            kDefault kDelayed kDeprecated kDestructor kDispId kDispInterface kDiv kDo kDownto kDynamic
            kElse kEnd kExcept kExperimental kExport kExports kExternal
            kFar kFile kFinalization kFinally kFor kForward kFunction
            kGeneric kGoto
            kHardfloat kHat kHelper
            kIf kImplementation kImplements kIn kIndex kInherited kInitialization kInline kInterface kInterrupt kIocheck kIs
            kLabel kLibrary kLocal
            kMessage kMod kMs_abi_default kMs_abi_cdecl kMwpascal
            kName kNear kNil kNodefault kNoreturn kNostackframe kNot
            kOf kObject kObjcclass kObjccategory kObjcprotocol kOn kOperator kOptional kOr kOut kOverload kOverride
            kPacked kPascal kPlatform kProcedure kProgram kProperty kPublic kPublished kPrivate kProtected
            kRaise kRead kRegister kReintroduce kRecord kRepeat kRequired kResourcestring
            kSafecall kSaveregisters kSealed kSet kShl kShr kSoftfloat kSpecialize kStatic kStdcall kString kStrict kStored
            kThen kThreadvar kTo kTry kType
            kUnit kUses kUnimplemented kUntil
            kVar kVarargs kVectorcall kVirtual
            kWhile kWith kWinapi kWrite
            kXor))
  "OPASCAL4 keywords.")

(defvar pascal-ts-mode--font-lock-settings
  (treesit-font-lock-rules
    ;; :language pascal
    ;; :feature assignment
    ;; '((assignment
    ;;    lhs: (identifier) (kAssign) rhs: (literalNumber) @font-lock-variable-use-face))

   :language 'pascal
   :feature 'delimiter
   '(["," "." ":" ";"] @font-lock-delimiter-face)

   :language 'pascal
   :feature 'comment
   '((comment) @font-lock-comment-face)

   :language 'pascal
   :feature 'preprocessor
   '((pp) @font-lock-preprocessor-face)

   ;; Keywords
   :language 'pascal
   :feature 'keyword
   `([,@pascal-ts-mode--keywords] @font-lock-keyword-face)

   ;; Operators
   ;; :language 'pascal
   ;; :feature 'operator
   ;; :override 'prepend
   ;; '([(kAdd) (kSub) (kFdiv) (kMul) (kAssign) (kDot .) (kGt) (kLt) (kGte) (kLte)
   ;;    (kAnd) (kElse) (kOr) (kThen) (kXor) (kNot) (kIn)] @font-lock-operator-face)

   ;; Definitions
   :language 'pascal
   :feature 'definition
   :override 'prepend
   '((assignment lhs: (identifier) @font-lock-function-name-face)
     ([(kProcedure) (kFunction) (kConstructor) (kDestructor)]
      name: (identifier) @font-lock-function-name-face)

    ;; constructor foobar
    (declProc (kConstructor) name: (identifier) @font-lock-function-name-face)

    ;; function foobar.meth | procedure foobar.meth | constructor foobar.meth |
    ;; destructor foobar.meth
    (declProc [(kFunction) (kProcedure) (kConstructor) (kDestructor)]
              name: (genericDot lhs: (identifier) @font-lock-type-face
                                operator: _ rhs: (identifier) @font-lock-function-name-face))
    (declArg name: (identifier) @font-lock-variable-name-face)

    (declConst name: (identifier) @font-lock-constant-face)
    ((declString (kString)) @font-lock-type-face)
    (declVar name: (identifier) @font-lock-variable-name-face)


    (declProp _ name: (identifier) @font-lock-function-name-face)
    ((kRead) getter: (identifier) @font-lock-variable-use-face)
    ((kRead) getter: (identifier) @font-lock-variable-use-face (kWrite) setter: (identifier) @font-lock-variable-use-face)

    (inherited _ (identifier) @font-lock-variable-name-face)
    (with _ entity: (identifier) @font-lock-variable-name-face)

    (exceptionHandler variable: (identifier) @font-lock-variable-name-face)
    )

  ;; Types
  :language 'pascal
  :feature 'type
  '((declType name: (identifier) @font-lock-type-face)
    (genericTpl entity: (identifier) @font-lock-type-face)

    (declField name: (identifier) @font-lock-property-name-face)
    (declEnumValue name: (identifier) @font-lock-type-face)
    ((typeref (identifier)) @font-lock-type-face)
    (typeref (typerefPtr operator: _ operand: (identifier) @font-lock-type-face))
    (recInitializerField name: (identifier) @font-lock-variable-name-face)
    (typerefTpl entity: (identifier) @font-lock-type-face)
    (typerefArgs (identifier) @font-lock-type-face)
    (typerefPtr operator: _ operand: (identifier) @font-lock-type-face)
    (typeref (typerefDot lhs: (typerefTpl entity: _ args: _ _) operator: _ rhs: _ @font-lock-type-face))
    (genericArg name: (identifier) @font-lock-type-face)
    (genericArg name: (identifier) @font-lock-type-face _
                type: (typeref (identifier) @font-lock-type-face))

    (genericDot (identifier) @type)
    (genericDot (genericTpl entity: (identifier) @type)))

  ;; Function and procedure calls.
  :language 'pascal
  :feature 'function
  :override 'prepend

  '((exprCall entity: (identifier) @font-lock-function-call-face)
    (exprCall entity: (exprDot lhs: _ operator: _ rhs: (identifier) @font-lock-function-call-face))
    (exprDot lhs: _ operator: _ rhs: (identifier) @font-lock-function-call-face)
    (statement (identifier) @font-lock-function-call-face)
    (exprCall
     entity: (inherited _ (identifier) @font-lock-function-call-face))

    (statement (identifier) @font-lock-function-call-face)
    (statement (exprDot rhs: (identifier) @font-lock-function-call-face))
    (statement (exprTpl entity: (identifier) @font-lock-function-call-face))
    (statement (exprDot rhs: (exprTpl entity: (identifier) @font-lock-function-call-face))))

  ;; String

  :language 'pascal
  :feature 'string
  '((literalString) @font-lock-string-face)


  ;; Numeric literals
  :language 'pascal
  :feature 'number
  '((literalNumber) @font-lock-number-face)

   ;; Control
   :language 'pascal
   :feature 'control
   '((case (kCase) (identifier) @font-lock-variable-use-face)
     (caseCase label: (caseLabel (identifier) @font-lock-constant-face)))

   :language 'pascal
   :feature 'constant
   '(((kNil) @font-lock-constant-face)
    ((kTrue) @font-lock-constant-face)
    ((kFalse) @font-lock-constant-face))

   ;; ERROR
   :language 'pascal
   :feature 'error
   '(
     ((ERROR) @font-lock-warning-face)
     ((ERROR (identifier)) @font-lock-warning-face))))

(defun pascal-ts-setup ()
  "Setup treesit for Pascal."
  (interactive)
  (setq-local treesit-font-lock-settings
                     pascal-ts-mode--font-lock-settings)

;;  (setq-local treesit-simple-indent-rules pascal-ts-indent-rules)

  (setq-local treesit-font-lock-feature-list
              '((comment definition)
                (keyword preprocessor string type constant)
                (attribute assignment constant control function number operator)
                (bracket delimiter error label)))

  (treesit-major-mode-setup))

(define-derived-mode pascal-ts-mode opascal-mode "Pascal[TS]"
  "Major mode for editing Object Pascal/Free Pascal with tree-sitter."
  :syntax-table opascal-mode-syntax-table

  (setq-local font-lock-defaults nil)
  (when (treesit-ready-p 'pascal)
    (treesit-parser-create 'pascal)
    (pascal-ts-setup)))

(provide 'pascal-ts-mode)

;;; pascal-ts-mode.el ends here
