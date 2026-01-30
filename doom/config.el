;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'dichromacy)
(setq doom-font (font-spec :family "Jetbrains Mono" :size 16))
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq org-roam-directory "~/roam/")
(setq +org-roam-auto-backlinks-buffer :true)

;; 's' for substitute
(define-key evil-visual-state-map (kbd "s") 'evil-substitute)

;; kill the buffer
(map! :leader
      "!" (cmd! (kill-this-buffer)))

(setq org-agenda-files (directory-files-recursively "~/roam" "\\.org$"))

;; org-roam-dailies configuration
(after! org-roam
  (setq org-roam-dailies-directory "daily/")

  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry
           "* Mood after sleep:\n-\n\n* Dream Description\n** Category:\n** Charecters:\n** Location:\n** Storyline:\n** After thoughts:\n -\n\n* Tasks\n- [ ] \n- [ ] \n- [ ] \n\n* Logs\n-\n\n* Today I Learned:\n- \n\n* Daily Habits\n- [ ] 30 minutes of exercise\n- [ ] 30 minutes of meditation\n- [ ] Daily Protein Intake\n\n* Workout Logs\n** Push\n- [ ] Chest\n  - [ ] Incline Barbell Bench Press:\n  - [ ] Flat Barbell Bench Press:\n  - [ ] Weighted Chest Dips (forward lean):\n  - [ ] Incline Dumbbell Bench Press:\n  - [ ] Flat Dumbbell Bench Press:\n  - [ ] High-to-Low Cable Fly:\n- [ ] Shoulders:\n  - [ ] Cable Lateral Raises:\n  - [ ] Reverse Pec Deck / Face Pulls:\n- [ ] Triceps\n  - [ ] EZ-Bar Skull Crushers:\n  - [ ] Cable Pushdowns:\n  - [ ] Overhead Cable Triceps Extension:\n\n** Pull\n- [ ] Back\n  - [ ] Chest-Supported Dumbbell Rows:\n  - [ ] Weighted Pull-Ups / Heavy Lat Pulldown:\n  - [ ] Single-Arm Dumbbell Rows (long stretch):\n  - [ ] Neutral-Grip Lat Pulldown:\n  - [ ] Single-Arm Cable Rows (elbow low):\n  - [ ] Back Extensions:\n- [ ] Biceps\n  - [ ] Barbell Preacher Curls:\n  - [ ] Hammer Curls:\n  - [ ] Incline Dumbbell Curls:\n  - [ ] Cable Curls:\n\n** Legs\n- [ ] Quads\n  - [ ] Back Squats:\n  - [ ] Front Squats / Hack Squats:\n  - [ ] Walking Lunges:\n- [ ] Glutes / Hamstrings\n  - [ ] Barbell Hip Thrusts:\n  - [ ] Seated or Lying Leg Curls:\n- [ ] Calves\n  - [ ] Standing Calf Raises:\n- [ ] Core\n  - [ ] Weighted Crunches:\n\n* Reflections\n** 1. Did I accomplish my top three priorities today? If no, what got in the way?\n-\n\n** 2. What obstacles or distractions affected my productivity?\n-\n\n** 3. How effectively did I manage my time and stay focused?\n- Rating (1 -10) :\n- Notes :\n\n** 4. How satisfied am I with my achievements and progress today?\n- Rating (1 -10) :\n- What went well :\n\n** 5. What am I most grateful for today?\n-\n\n** 6. Did I feel a sense of meaning or purpose in my tasks?\n- [ ] Yes\n- [ ] No\nExamples :\n\n** 7. Which emotions dominated my day, and what triggered them?\n-\n\n** 8. On a scale from 1–10, how would I rate my overall mood today?\n- Rating:\n\n** 9. When did I feel most energized or drained, and why?\n-\n\n** 10. What one change can I make tomorrow to improve my productivity, satisfaction, or mood?\n-\n\n* One sentence to describe the day :\n#\\+BEGIN_QUOTE\n> What was the theme or takeaway of today? \"Adaptation and Flow\", \"Finding Stillness in Chaos\", \"A Breakthrough in Patience\"\n> If you had to sum up today in one sentence, what would you tweet? \"Made Peace with My To-Do List\", \"Took a Risk, Learned a Lot\"\n> What question kept coming back to you all day? \"Why Can't I Finish What I Start?\", \"How Do I Balance Work and Rest?\"\n#\\+END_QUOTE\n"

           :target (file+head "%<%Y-%m-%d>.org"
                              "%<%Y-%m-%d>\n#+filetags: :journal:")))))

;; org mode configuration
(after! org
  ;; Custom TODO keywords
  (setq org-todo-keywords '((sequence "TODO(t)" "HOLD(h)" "|" "FEEDBACK(f)" "VERIFY(v)" "|" "DONE(d)" "DELEGATED(u)")))

  ;; org-download configuration for image support
  (require 'org-download)

  ;; Drag-and-drop to dired
  (add-hook 'dired-mode-hook 'org-download-enable)

  ;; Set image directory
  (setq-default org-download-image-dir "~/roam/img"))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
