;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;      documentation. There you'll find a link to Doom's Module Index where all
;;      of our modules are listed, including what flags they support.

;; NOTE Move your cursor over a module's name (or its flags) and press 'K' (or
;;      'C-c c k' for non-vim users) to view its documentation. This works on
;;      flags as well (those symbols that start with a plus).
;;
;;      Alternatively, press 'gd' (or 'C-c c d') on a module to browse its
;;      directory (for easy access to its source code).

(doom!
 :completion
 ;;company           ; the ultimate code completion backend
 (corfu +orderless)  ; complete with cap(f), cape and a flying feather!
 ;;helm              ; the *other* search engine for love and life
 ;;ido               ; the other *other* search engine...
 ;;ivy               ; a search engine for love and life
 vertico           ; the search engine of the future

 :ui
 ;;deft              ; notational velocity for Emacs
 doom              ; what makes DOOM look the way it does
 doom-dashboard    ; a nifty splash screen for Emacs
 ;;doom-quit         ; DOOM quit-message prompts when you quit Emacs
 ;;(emoji +unicode)  ; 🙂
 hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
 ;;indent-guides     ; highlighted indent columns
 ligatures         ; ligatures and symbols to make your code pretty again
 ;;minimap           ; show a map of the code on the side
 modeline          ; snazzy, Atom-inspired modeline, plus API
 ;;nav-flash         ; blink cursor line after big motions
 ;;neotree           ; a project drawer, like NERDTree for vim
 ophints           ; highlight the region an operation acts on
 (popup +defaults)   ; tame sudden yet inevitable temporary windows
 ;;smooth-scroll     ; So smooth you won't believe it's not butter
 tabs              ; a tab bar for Emacs
 ;;treemacs          ; a project drawer, like neotree but cooler
 ;;unicode           ; extended unicode support for various languages
 (vc-gutter +pretty) ; vcs diff in the fringe
 vi-tilde-fringe   ; fringe tildes to mark beyond EOB
 ;;window-select     ; visually switch windows
 workspaces        ; tab emulation, persistence & separate workspaces
 zen               ; distraction-free coding or writing

 :editor
 (evil +everywhere); come to the dark side, we have cookies
 file-templates    ; auto-snippets for empty files
 fold              ; (nigh) universal code folding
 (format +onsave)  ; automated prettiness
 ;;god               ; run Emacs commands without modifier keys
 ;;lispy             ; vim for lisp, for people who don't like vim
 ;;multiple-cursors  ; editing in many places at once
 ;;objed             ; text object editing for the innocent
 ;;parinfer          ; turn lisp into python, sort of
 ;;rotate-text       ; cycle region at point between text candidates
 snippets          ; my elves. They type so I don't have to
 word-wrap         ; soft wrapping with language-aware indent

 :emacs
 dired             ; making dired pretty [functional]
 electric          ; smarter, keyword-based electric-indent
 ;;eww               ; the internet is gross
 ;;ibuffer           ; interactive buffer management
 undo              ; persistent, smarter undo for your inevitable mistakes
 vc                ; version-control and Emacs, sitting in a tree

 :checkers
 syntax              ; tasing you for every semicolon you forget
 (spell +flyspell) ; tasing you for misspelling mispelling
                                        ; grammar           ; tasing grammar mistake every you make

 :os
 (:if (featurep :system 'macos) macos)  ; improve compatibility with macOS
 ;;tty               ; improve the terminal Emacs experience

 :lang
 emacs-lisp
 markdown          ; writing docs for people to ignore
 (org               ; organize your plain life in plain text
  +pretty
  +journal
  +roam2
  +dragndrop
  +present)

 :tools
 project

 :app
 calendar
 ;;emms
 ;;everywhere        ; *leave* Emacs!? You must be joking
 ;;irc               ; how neckbeards socialize
 ;;(rss +org)        ; emacs as an RSS reader

 :config
 ;;literate
 (default +bindings +smartparens))
