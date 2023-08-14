(define-module (lisux config users)
  #:use-module (gnu))

(define-public @user-liszt
  (user-account 
    (name "liszt") 
    (group "users") 
    (password "")
    (comment "Li Shuzhi") 
    (supplementary-groups '("wheel" "netdev" "audio" "video"))))