;; Get Melpa Repo.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

(require 'dired-x)
(require 'dashboard)

;; NOTE: use as workaround when converting ORG to HTML!
(setq org-html-htmlize-output-type nil)

;; Functions. ;;
(defun open-init-file ()
  "Open the init.el file located in ~/.emacs.d/ directory."
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;; Enable ANSI color support in compilation buffer
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (read-only-mode -1) ; Disable read-only mode
  (ansi-color-apply-on-region compilation-filter-start (point))
  (read-only-mode 1)) ; Enable read-only mode
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; Set transparency.
(defun set-frame-alpha (arg &optional active)
  (interactive "nEnter alpha value (1-100): \np")
  (let* ((elt (assoc 'alpha default-frame-alist))
         (old (frame-parameter nil 'alpha))
         (new (cond ((atom old)     `(,arg ,arg))
                    ((eql 1 active) `(,arg ,(cadr old)))
                    (t              `(,(car old) ,arg)))))
    (if elt (setcdr elt new) (push `(alpha ,@new) default-frame-alist))
    (set-frame-parameter nil 'alpha new)))
(set-frame-parameter nil 'alpha 90)
;; (global-set-key (kbd "C-c t") 'set-frame-alpha)

(defun untabify-except-makefiles ()
  "Replace tabs with spaces except in makefiles."
  (unless (derived-mode-p 'makefile-mode)
    (untabify (point-min) (point-max))))
(add-hook 'before-save-hook 'untabify-except-makefiles)

;; Open my repos.
(defun zdh-repos ()
  (interactive)
  (start-process "firefox" nil "firefox" "https://github.com/malloc-nbytes?tab=repositories"))

;; --- End Functions ---

;; --- Misc. Config ---
(setq split-width-threshold nil) ;; have windows open horizontally instead of vertically.

(setq compilation-scroll-output t)
(setq package-install-upgrade-built-in t)
(setq completion-ignored-extensions
      (append completion-ignored-extensions
              '(".exe" ".dll" ".so" ".dylib" ".o" ".a" ".elc" "main")))

;; (setq ring-bell-function 'ignore)
(setq whitespace-style (quote (face spaces tabs space-mark tab-mark)))
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "yellow")

;; Remove confirmation of reverting a PDF buffer.
(add-to-list 'revert-without-query "\\(?:.*\\.\\)?pdf\\'")

(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; (setq inhibit-startup-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)

;; (dashboard-setup-startup-hook)
;; (setq dashboard-startup-banner "~/Pictures/xemacs_color.svg")
;; (setq dashboard-startup-banner "~/Pictures/blackhole-lines.svg")
;; (setq dashboard-banner-logo-title "")
;; (setq dashboard-footer-messages '(""))
;; (setq dashboard-items nil)

(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
(display-time-mode 1)
(setq-default indent-tab-mode nil)
(show-paren-mode 1)
(setq make-backup-files nil)
(delete-selection-mode 1)
;; (setq display-line-numbers-type 'relative)
(setq display-line-numbers-type 'absolute)
(scroll-bar-mode -1)
(global-display-line-numbers-mode)
(set-frame-font "ComicShannsMonoNerdFontMono-14")
;; (set-frame-font "Ubuntu Mono-14")
;; (set-frame-font "Fira Code-15")
;; (set-frame-font "Mx437 ApricotXenC-18")

(ido-mode 1)
(ido-everywhere 1)
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-alh")
(setq mc/always-run-for-all t)
(golden-ratio-mode)

(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(global-auto-complete-mode t)

;; --- End Misc. Config ---
(defun switch-to-compilation-buffer ()
  "Switch to the *compilation* buffer if it exists."
  (interactive)
  (let ((buf (get-buffer "*compilation*")))
    (if buf
        (switch-to-buffer buf)
      (message "Compilation buffer does not exist"))))

;; --- Keybindings ---
(global-set-key (kbd "<f12>") 'open-init-file)

(define-key ido-common-completion-map (kbd "C-n") 'ido-next-match)
(define-key ido-common-completion-map (kbd "C-p") 'ido-prev-match)

(global-set-key (kbd "C-<tab>") 'switch-to-compilation-buffer)
(global-set-key (kbd "C-c C-j") 'eval-print-last-sexp)
(global-set-key (kbd "C-c w") 'global-whitespace-mode)
(global-set-key (kbd "C-x C-j") 'dired-jump)
(global-set-key (kbd "C-.") 'mark-word)
(global-set-key (kbd "C-q") 'undo)
(global-set-key (kbd "C-x m") 'delete-other-windows)
(global-set-key (kbd "C-x '") 'shell)
(global-set-key (kbd "C-c e") 'crux-eval-and-replace)
(global-set-key (kbd "M-k") 'crux-kill-whole-line)
(global-set-key (kbd "C-c d") 'crux-duplicate-current-line-or-region)
(global-set-key (kbd "C-c k") 'crux-kill-other-buffers)
(global-set-key (kbd "M-j") 'crux-top-join-line)
(global-set-key (kbd "C-x C-u") 'crux-upcase-region)
(global-set-key (kbd "C-x C-l") 'crux-downcase-region)
(global-set-key [(shift return)] #'crux-smart-open-line)
(global-set-key (kbd "M-s M-s") 'helm-swoop)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-tnis)
(global-set-key (kbd "C-?") 'mc/skip-to-next-like-this)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)
(global-set-key (kbd "C-x -") 'split-window-vertically)
(global-set-key (kbd "C-x /") 'split-window-horizontally)
(global-key-binding (kbd "M-x") #'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c f") 'helm-imenu)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C-c c") 'compile)
(global-set-key (kbd "C-c M-c") 'query-replace)
(global-set-key (kbd "C-x M-x") 'grep-find)
(global-set-key (kbd "M-g M-f") 'xref-find-definitions)
(global-set-key (kbd "M-g f") 'xref-find-references)
;; --- End Keybindings ---

;; --- Other ---

(add-hook 'c++-mode-hook
          (lambda ()
            (setq c-default-style "bsd")
            (setq c-basic-offset 4)))

;; Score mode
(defconst score-mode-syntax-table
  (with-syntax-table (copy-syntax-table)
    (modify-syntax-entry ?- ". 124b")
    (modify-syntax-entry ?* ". 23")
    (modify-syntax-entry ?\n "> b")
    (modify-syntax-entry ?' "\"")
    (modify-syntax-entry ?' ".")
    (syntax-table))
  "Syntax table for `score-mode'.")

;; Function taken from:
;;  https://www.omarpolo.com/post/writing-a-major-mode.html
(defun score-indent-line ()
  "Indent current line."
  (let (indent
        boi-p
        move-eol-p
        (point (point)))
    (save-excursion
      (back-to-indentation)
      (setq indent (car (syntax-ppss))
            boi-p (= point (point)))
      (when (and (eq (char-after) ?\n)
                 (not boi-p))
        (setq indent 0))
      (when boi-p
        (setq move-eol-p t))
      (when (or (eq (char-after) ?\))
                (eq (char-after) ?\}))
        (setq indent (1- indent)))
      (delete-region (line-beginning-position)
                     (point))
      (indent-to (* tab-width indent)))
    (when move-eol-p
      (move-end-of-line nil))))

(eval-and-compile
  (defconst score-keywords
    '("if" "else" "while" "let" "void" "i32"
      "str" "for" "proc" "return" "mut" "break" "macro"
      "usize" "struct" "char" "import" "ref" "end" "export"
      "def" "in" "null" "type" "module" "where")))

(defconst score-highlights
  `((,(regexp-opt score-keywords 'symbols) . font-lock-keyword-face)
    (,(rx (group "--" (zero-or-more (not (any "\n"))))
         (group-n 1 (zero-or-more (any "\n"))))
     (1 font-lock-comment-delimiter-face)
     (2 font-lock-comment-face nil t))))

;;;###autoload
(define-derived-mode score-mode prog-mode "score"
  "Major Mode for editing Score source code."
  :syntax-table score-mode-syntax-table
  (setq font-lock-defaults '(score-highlights))
  (setq-local comment-start "--")
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 4)
  (setq-local indent-line-function #'score-indent-line)
  (setq-local standard-indent 2))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.scr\\'" . score-mode))

(provide 'score-mode)
;; End Score mode

;; qbe mode
(defconst qbe-mode-syntax-table
  (with-syntax-table (copy-syntax-table)
    (modify-syntax-entry ?- ". 124b")
    (modify-syntax-entry ?* ". 23")
    (modify-syntax-entry ?\n "> b")
    (modify-syntax-entry ?' "\"")
    (modify-syntax-entry ?' ".")
    (syntax-table))
  "Syntax table for `qbe-mode'.")

(defun qbe-indent-line ()
  "Indent current line."
  (let (indent
        boi-p
        move-eol-p
        (point (point)))
    (save-excursion
      (back-to-indentation)
      (setq indent (car (syntax-ppss))
            boi-p (= point (point)))
      (when (and (eq (char-after) ?\n)
                 (not boi-p))
        (setq indent 0))
      (when boi-p
        (setq move-eol-p t))
      (when (or (eq (char-after) ?\))
                (eq (char-after) ?\}))
        (setq indent (1- indent)))
      (delete-region (line-beginning-position)
                     (point))
      (indent-to (* tab-width indent)))
    (when move-eol-p
      (move-end-of-line nil))))

(eval-and-compile
  (defconst qbe-keywords
    '("export" "function" "data" "type" "w" "l" "s" "d" "b" "h"
      "add" "and" "div" "mul" "neg" "or" "rem" "sar"
      "shl" "shr" "sub" "udiv" "urem" "xor" "alloc16"
      "alloc4" "alloc8" "blit" "loadd" "loadl" "loads"
      "loadsb" "loadsh" "loadsw" "loadub" "loaduh" "loaduw"
      "loadw" "storeb" "stored" "storeh" "storel" "stores"
      "storew" "ceqd" "ceql" "ceqs" "ceqw" "cged" "cges"
      "cgtd" "cgts" "cled" "cles" "cltd" "clts" "cned"
      "cnel" "cnes" "cnew" "cod" "cos" "csgel" "csgew"
      "csgtl" "csgtw" "cslel" "cslew" "csltl" "csltw"
      "cugel" "cugew" "cugtl" "cugtw" "culel" "culew"
      "cultl" "cultw" "cuod" "cuos" "dtosi" "dtoui"
      "exts" "extsb" "extsh" "extsw" "extub" "extuh" "extuw"
      "sltof" "ultof" "stosi" "stoui" "swtof" "uwtof" "truncd"
      "cast" "copy" "call" "vastart" "vaarg" "phi" "hlt"
      "jmp" "jnz" "ret" )))

(defconst qbe-highlights
  `((,(regexp-opt qbe-keywords 'symbols) . font-lock-keyword-face)
    (,(rx (group "#" (zero-or-more (not (any "\n"))))
         (group-n 1 (zero-or-more (any "\n"))))
     (1 font-lock-comment-delimiter-face)
     (2 font-lock-comment-face nil t))))

;;;###autoload
(define-derived-mode qbe-mode prog-mode "qbe"
  "Major Mode for editing Qbe source code."
  :syntax-table qbe-mode-syntax-table
  (setq font-lock-defaults '(qbe-highlights))
  (setq-local comment-start "#")
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 4)
  (setq-local indent-line-function #'qbe-indent-line)
  (setq-local standard-indent 2))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.ssa\\'" . qbe-mode))

(provide 'qbe-mode)
;; End qbe mode

;; Sic mode
(defconst sic-mode-syntax-table
  (with-syntax-table (copy-syntax-table)
    (modify-syntax-entry ?- ". 124b")
    (modify-syntax-entry ?* ". 23")
    (modify-syntax-entry ?\n "> b")
    (modify-syntax-entry ?' "\"")
    (modify-syntax-entry ?' ".")
    (syntax-table))
  "Syntax table for `sic-mode'.")

;; Function taken from:
;;  https://www.omarpolo.com/post/writing-a-major-mode.html
(defun sic-indent-line ()
  "Indent current line."
  (let (indent
        boi-p
        move-eol-p
        (point (point)))
    (save-excursion
      (back-to-indentation)
      (setq indent (car (syntax-ppss))
            boi-p (= point (point)))
      (when (and (eq (char-after) ?\n)
                 (not boi-p))
        (setq indent 0))
      (when boi-p
        (setq move-eol-p t))
      (when (or (eq (char-after) ?\))
                (eq (char-after) ?\}))
        (setq indent (1- indent)))
      (delete-region (line-beginning-position)
                     (point))
      (indent-to (* tab-width indent)))
    (when move-eol-p
      (move-end-of-line nil))))

(eval-and-compile
  (defconst sic-keywords
    '("var" "r" "n" "iota" "write" "output" "w" "limitWildCard")))

(defconst sic-highlights
  `((,(regexp-opt sic-keywords 'symbols) . font-lock-keyword-face)
    (,(rx (group "//" (zero-or-more (not (any "\n"))))
         (group-n 1 (zero-or-more (any "\n"))))
     (1 font-lock-comment-delimiter-face)
     (2 font-lock-comment-face nil t))))

;;;###autoload
(define-derived-mode sic-mode prog-mode "sic"
  "Major Mode for editing Sic source code."
  :syntax-table sic-mode-syntax-table
  (setq font-lock-defaults '(sic-highlights))
  (setq-local comment-start "//")
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 4)
  (setq-local indent-line-function #'sic-indent-line)
  (setq-local standard-indent 2))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.scr\\'" . sic-mode))

(provide 'sic-mode)
;; End Sic mode

;; Earl mode
(defconst earl-mode-syntax-table
  (with-syntax-table (copy-syntax-table)
    (modify-syntax-entry ?- ". 124b")
    (modify-syntax-entry ?* ". 23")
    (modify-syntax-entry ?\n "> b")
    (modify-syntax-entry ?' "\"")
    (modify-syntax-entry ?' ".")
    (syntax-table))
  "Syntax table for `earl-mode'.")

;; Function taken from:
;;  https://www.omarpolo.com/post/writing-a-major-mode.html
(defun earl-indent-line ()
  "Indent current line."
  (let (indent
        boi-p
        move-eol-p
        (point (point)))
    (save-excursion
      (back-to-indentation)
      (setq indent (car (syntax-ppss))
            boi-p (= point (point)))
      (when (and (eq (char-after) ?\n)
                 (not boi-p))
        (setq indent 0))
      (when boi-p
        (setq move-eol-p t))
      (when (or (eq (char-after) ?\))
                (eq (char-after) ?\}))
        (setq indent (1- indent)))
      (delete-region (line-beginning-position)
                     (point))
      (indent-to (* tab-width indent)))
    (when move-eol-p
      (move-end-of-line nil))))

(eval-and-compile
  (defconst earl-keywords
    '("if" "else" "while" "let" "void" "int"
      "str" "for" "def" "return" "break"
      "struct" "char" "import" "in"
      ;; intrinsic functions
      "print"
      ;; function attributes
      "world" "pub"
      )))

(defconst earl-highlights
  `((,(regexp-opt earl-keywords 'symbols) . font-lock-keyword-face)
    (,(rx (group "#" (zero-or-more nonl))) . font-lock-comment-face)))

;;;###autoload
(define-derived-mode earl-mode prog-mode "earl"
  "Major Mode for editing Earl source code."
  :syntax-table earl-mode-syntax-table
  (setq font-lock-defaults '(earl-highlights))
  (setq-local comment-start "#")
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 4)
  (setq-local indent-line-function #'earl-indent-line)
  (setq-local standard-indent 2))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.earl\\'" . earl-mode))

(provide 'earl-mode)
;; End Earl mode
