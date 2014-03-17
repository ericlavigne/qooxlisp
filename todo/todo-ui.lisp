(in-package :qooxlisp)

(defparameter *ug* (format nil "A Qooxlisp implementation of TodoMVC"))

(defmd todo-session (qxl-session)
  (todos (c-in nil))
  :kids (c? (the-kids
             (vbox (:spacing 6)
               (:add '(:left 0 :top 0 :width "100%" :height "100%")
                 :padding 6)
               (lbl *ug* :rich t :width 600)
               (todo-list self)))))

(defun todo-list (self)
  (vbox ()(:add '(:flex 1))
    (lbl "What needs to be done?")
    (qxlist :todo-list
            (:add '(:flex 1)
                  :max-height 96 
                  :spacing -6
                  :selection-mode 'additive
                  :onchangeselection (lambda (self req)
                                       (declare (ignore self req))
                                       (print "todo-list onchangeselection")))
            (loop for x in '("Angus" "Beef" "Chicken" "Dog" "Eggs" "Fillet-Mignon" "Goat" "Horse")
                collecting
                  (make-kid 'qx-list-item
                            :model x
                            :label x)))))
			  