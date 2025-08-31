;;; flycheck-free-pascal.el --- Flycheck checker using Free Pascal compiler for Object Pascal  -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Brian Olsen

;; Author: Brian Olsen <brian@bolsen.org>
;; Created: August 2025
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

;;; This provdes a Flycheck checker using the Free Pascal compiler for
;;; error messaging.

;;; Code:

(require 'flycheck)

(flycheck-define-checker free-pascal
  "A Free Pascal syntax checker using the FPC compiler.
See URL `https://www.freepascal.org/'."
  :command ("fpc.sh" "-s" "-ap" "-FE/tmp" source)
  :error-patterns
  ((error line-start (file-name) "(" line "," column ") " (or "Error: " "Fatal: ") (message) line-end)
   (warning line-start (file-name) "(" line "," column ") " "Warning: " (message) line-end)
   (info line-start (file-name) "(" line "," column ") " (or "Hint: " "Note: ") (message) line-end))
  :modes pascal-ts-mode)

(add-to-list 'flycheck-checkers 'free-pascal)

(provide 'flycheck-free-pascal)

;;; flycheck-free-pascal.el ends here
