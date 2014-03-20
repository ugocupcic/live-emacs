;; User pack init file
;;
;; Use this file to initiate the pack configuration.
;; See README for more information.

;; Load bindings config
(live-load-config-file "bindings.el")

(custom-set-variables
 '(ros-completion-function (quote ido-completing-read)))

;; bind Caps-Lock to M-x
;; http://sachachua.com/wp/2008/08/04/emacs-caps-lock-as-m-x/
;; of course, this disables normal Caps-Lock for *all* apps...
(if (eq window-system 'x)
    (shell-command "xmodmap -e 'clear Lock' -e 'keycode 66 = F13'"))
(global-set-key [f13] 'execute-extended-command)


(require 'windmove)
(global-set-key (kbd "M-<left>") 'windmove-left)
(global-set-key (kbd "M-<up>") 'windmove-up)
(global-set-key (kbd "M-<right>") 'windmove-right)
(global-set-key (kbd "M-<down>") 'windmove-down)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; modify emacs frame-title
(setq frame-title-format
  '("" invocation-name ": "(:eval (if (buffer-file-name)
                (abbreviate-file-name (buffer-file-name))
                "%b"))))

;;colorise the compilation buffer properly
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;;compiling for catkin
(setq compile-command "cd ../../..; catkin_make")

;;email and identity
(setq user-mail-address "ugo@shadowrobot.com")
(setq user-full-name "Ugo Cupcic")

;;scroll compilation buffer
(setq compilation-scroll-output 1)

(defun toggle-fullscreen ()
  "Toggle full screen on X11"
  (interactive)
  (when (eq window-system 'x)
    (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth))))

(global-set-key [f11] 'toggle-fullscreen)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;           ROS stuffs             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tell emacs where to find the rosemacs sources
;; replace the path with location of rosemacs on your system
(push "~/.live-packs/ugo-pack/rosemacs" load-path)

(require 'rosemacs)
(invoke-rosemacs)
(global-set-key "\C-x\C-r" ros-keymap)

(require 'rng-loc)
(push (concat (ros-package-path "rosemacs") "/rng-schemas.xml") rng-schema-locating-files)
(add-to-list 'auto-mode-alist '("\.launch$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\.test$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\.machine$" . nxml-mode))
(add-to-list 'auto-mode-alist '("manifest.xml" . nxml-mode))
(add-to-list 'auto-mode-alist '("\.xacro$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\.urdf$" . nxml-mode))

(add-to-list 'auto-mode-alist '("\.md$" . markdown-mode))

(add-to-list 'auto-mode-alist '("\.cfg$" . python-mode))

;; Add ROS message files to gdb-script mode for syntax highlighting
(add-to-list 'auto-mode-alist '("\\.msg\\'" . gdb-script-mode))
(add-to-list 'auto-mode-alist '("\\.srv\\'" . gdb-script-mode))
(add-to-list 'auto-mode-alist '("\\.action\\'" . gdb-script-mode))

;; Add ROS standard message types to gdb-script-mode for different highlighting
(font-lock-add-keywords 'gdb-script-mode
                        '(("\\<\\(bool\\|int8\\|uint8\\|int16\\|uint16\\|int32\\|uint32\\|int64\\|uint64\\|float32\\|float64\\|string\\|time\\|duration\\)\\>" . font-lock-builtin-face)))
