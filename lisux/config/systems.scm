(define-module (lisux config systems)
  #:use-module (lisux config users)
  #:use-module (lisux config services)
  #:use-module (gnu system images wsl2))

(define-public base-wsl-services
  (with-guix-mirror (operating-system-user-services wsl-os)))

(define-public base-wsl-os
  (operating-system 
    (inherit wsl-os)
    (host-name "wsl-guix")
    (timezone "Asia/Shanghai")
    (users 
      (cons* 
        @user-liszt
        (user-account
          (inherit %root-account)
          (shell (wsl-boot-program "liszt")))
        %base-user-accounts))
    (services base-wsl-services)))
