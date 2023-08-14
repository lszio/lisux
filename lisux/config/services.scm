(define-module (lisux config services)
  #:use-module (gnu)
  #:use-module (guix)
  #:export (with-guix-mirror))

(define (with-guix-mirror services)
  (modify-services services
    (guix-service-type config => 
      (guix-configuration
        (inherit config)
        (substitute-urls 
          (list "https://mirror.sjtu.edu.cn/guix" 
                "https://ci.guix.gnu.org"))))))