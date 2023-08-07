(use-modules (gnu system images wsl2)
             (gnu services web)
             (gnu services base)
             (gnu services)
             (gnu packages linux)
             (gnu packages base))

(operating-system
  (inherit wsl-os)
  (host-name "wsl-guix")
  (timezone "Asia/Shanghai")
  (users (cons* (user-account
                  (name "liszt")
                  (group "users")
                  (supplementary-groups '("wheel"))
                  (comment "Li Shuzhi"))
                (user-account
                  (inherit %root-account)
                  (shell (wsl-boot-program "liszt")))
                %base-user-accounts)))
