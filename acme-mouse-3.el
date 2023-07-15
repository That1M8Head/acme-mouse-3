;;; acme-mouse-3.el --- Evaluate code using mouse-3

;; Author: Arsalan Kazmi <sonicspeed848@gmail.com>
;; Version: 1.0
;; Package-Requires: ((emacs "24.4"))
;; Keywords: convenience, evaluation

;; This package provides the functionality to evaluate Elisp code using the right mouse button (mouse-3), inspired by Rob Pike's Acme editor.
;; It allows you to evaluate either the current region or the word under the mouse cursor.

;;; Commentary:

;; To use this package, load it into your Emacs configuration and activate the `eval-region-or-word` function with the right mouse button (mouse-3).
;; It will evaluate the selected region or the word under the mouse cursor, allowing you to quickly test and execute code snippets.

;; The `eval-region-or-word` function behaves as follows:
;;   - If a region is active, it evaluates the code within the region.
;;   - If no region is active, it retrieves the word under the mouse cursor and evaluates it.
;;     A "word" in this instance includes hyphens.

;; Example usage:
;;   - Select a region with code and press mouse-3 to evaluate it.
;;   - Place the cursor on a word and press mouse-3 to evaluate it.

;;; Code:

(defun eval-region-or-word ()
  "Evaluate the current region or word under the mouse cursor."
  (interactive)
  (let ((region (if (region-active-p)
                    (buffer-substring-no-properties (region-beginning) (region-end))
                  (progn
                    (mouse-set-point last-nonmenu-event)
                    (with-syntax-table (copy-syntax-table (syntax-table))
                      (modify-syntax-entry ?- "w")
                      (thing-at-point 'word))))))
    (when region
      (unless (string-prefix-p "(" region)
        (setq region (concat "(" region)))
      (unless (string-suffix-p ")" region)
        (setq region (concat region ")")))
      (eval (read region)))))

(global-set-key (kbd "<mouse-3>") 'eval-region-or-word)

;; Try it! Select the following line without the ;; and press mouse-3:
;; message "Hello!"

;; This one, you can simply press mouse-3 on:
;; eval-buffer

(provide 'acme-mouse-3)

;;; acme-mouse-3.el ends here
