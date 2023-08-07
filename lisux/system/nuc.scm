(use-modules (gnu) (gnu system nss))
(use-service-modules syncthing xorg ssh desktop)
(use-package-modules bootloaders certs emacs emacs-xyz suckless wm xorg)

(define %user-liszt
  (user-account 
    (name "liszt") 
    (group "users") 
    (comment "Li Shuzhi") 
    (supplementary-groups '("wheel" "netdev" "audio" "video"))))

(operating-system
  (host-name "nuc")
  (timezone "Asia/Shanghai")
  (locale "en_US.utf8")

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))))

  ;; Assume the target root file system is labelled "my-root",
  ;; and the EFI System Partition has UUID 1234-ABCD.
  (file-systems (append
                 (list (file-system
                         (device (file-system-label "ROOT"))
                         (mount-point "/")
                         (type "ext4"))
                       (file-system
                         (device (uuid "D637-CAE4" 'fat))
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  (users (cons %user-liszt
               %base-user-accounts))

  ;; Add a bunch of window managers; we can choose one at
  ;; the log-in screen with F1.
  (packages (append (list
                     ;; window managers
                     i3-wm i3status dmenu
                     emacs emacs-exwm emacs-desktop-environment
                     ;; terminal emulator
                     xterm
                     ;; for HTTPS access
                     nss-certs)
                    %base-packages))

  ;; Use the "desktop" services, which include the X11
  ;; log-in service, networking with NetworkManager, and more.
  (services (modify-services
             (append
              (list
                (service syncthing-service-type
                     (syncthing-configuration
                      (user "liszt")))
                (service openssh-service-type
                  (openssh-configuration
                    (x11-forwarding? #t))))
              %desktop-services)
             (gdm-service-type
              config => (gdm-configuration
                         (inherit config)
                         (auto-suspend? #f)))
             (guix-service-type
              config => (guix-configuration
                           (inherit config)
                           (substitute-urls '("https://mirror.sjtu.edu.cn/guix" "https://ci.guix.gnu.org"))))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
