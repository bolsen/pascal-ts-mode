;;; compilation-free-pascal.el --- Compilation regexp for using Free Pascal in compilation-mode  -*- lexical-binding: t; -*-

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

;;; This is a simple regexp for using in compilation-mode.
;;; Just need to load this file to add them in.

;;; Code:

(require 'compile)

(defun complication-free-pascal ()
  "SET the regexes required to Free Pascal output in `compilation-mode'."
  (interactive)
  (add-to-list 'compilation-error-regexp-alist 'fpc)
  (add-to-list 'compilation-error-regexp-alist-alist
               '(fpc "^\\(.+\\)(\\([0-9]+\\),\\([0-9]+\\)) \\(.+\\):.+" 1 2 3 (4))))

(provide 'compilation-free-pascal)

;;; compilation-free-pascal.el ends here
