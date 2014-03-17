(in-package :qooxlisp)

(defun serve-todo (&optional (port 8000))
  (when *wserver* (shutdown))
  (qx-reset)
  (net.aserve:start :debug nil :port port)
  (net.aserve::debug-off :all)
  (flet ((pfl (p f)
           (publish-file :port port
             :path p
             :file f))
         (pdr (p d)
           (publish-directory :port port
             :prefix p
             :destination d))

         (pfn (p fn)
           (publish :path p :function fn)))
    
    (pdr "/qx/" "/devel/qx/")
    (pfn "/begin" 'qx-begin) ;; <=== qx-begin (below) gets customized
    (pfn "/callback" 'qx-callback-js)
    (pfn "/cbjson" 'qx-callback-json)

    (let* ((src-build "build")
           (app-root "/Users/eric/workspace/qooxlisp/ide") ;; <=== just change this
           (app-source (format nil "~a/~a/" app-root src-build)))
      (flet ((src-ext (x)
               (format nil "~a~a" app-source x)))
        (pfl "/" (src-ext "index.html"))
        (pdr (format nil "/~a/" src-build) app-source)
        (pdr "/script/" (src-ext "script/"))
        (pdr "/resource/" (src-ext "resource/")) ;;>>> move this to qxl-session and figure out how to combine
        (format t "~&Now serving port ~a." port)))))

(defun qx-begin (req ent)
  (ukt::stop-check :qx-begin)
  ;(trace md-awaken make-qx-instance)
  (print "Started qx-begin")
  (let ((*ekojs* t)) ;; qx-begin
    (with-js-response (req ent)
      (top-level.debug::with-auto-zoom-and-exit ("aabegin-zoo.txt" :exit nil)
        (let ((*web-session* nil))
          (with-integrity ()
            (qxfmt "
function cbjs (oid,opcode,data) {
	var req = new qx.io.remote.Request('/callback','GET', 'text/javascript');
	req.setParameter('sessId', sessId);
	req.setParameter('oid', oid);
	req.setParameter('opcode', opcode);
	req.setParameter('data', data);
	req.send();
}
clDict[0] = qx.core.Init.getApplication().getRoot();
sessId=~a;" (session-id (setf *web-session*
                          (make-instance 'todo-session))))))))))


