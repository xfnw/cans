# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  #fileSystems."/home" = {
  #  device = "tmpfs";
  #  fsType = "tmpfs";
  #  options = [ "defaults" "mode=755" ];
  #};


  networking.hostName = "nix"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  #networking.interfaces.wlp1s0.useDHCP = true;
  networking.interfaces.enp1s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  #services.getty.autologinUser = "xfnw";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xfnw = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirt" "docker" ];
    
    initialPassword = "honk69";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDBUk5IjB3+trnVO6pncivFbOetUL8BPTl3CwAtk4532 xfnw@raven" ];
  };
  security.sudo.wheelNeedsPassword = false;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim tmux gnupg ncdu mosh
    git curl rsync wireguard-tools
    inetutils dnsutils lynx jo jq
  ];

  environment.variables = { EDITOR = "vim"; };

  environment.etc = {
    "tmux.conf" = {
      text = ''
        set-option -g default-terminal "tmux-256color"
        set-option -g history-limit 20000
        set-option -g focus-events on
        set-option -g xterm-keys on
        set-option -g set-titles on
        set-option -g set-titles-string "tmux - #T"
        set-option -g escape-time 25
        set-option -g status-left-style             "fg=colour10"
        set-option -g status-right-style            "fg=colour10"
        set-option -g status-style                  "bg=default,fg=colour10"
        set-option -g pane-active-border-style      "bg=default,fg=colour10"
        set-option -g window-status-activity-style  "bg=default,fg=colour235,bold,reverse"
        set-option -g window-status-bell-style      "bg=default,fg=white,bold,reverse"
        set-option -g window-status-current-style   "bg=default,fg=colour10,bold,reverse"
        set-option -g window-status-style           "bg=default,fg=colour10"
        set-option -g status on
        set-option -g status-interval 5
        set-option -g status-position top
        set-option -g status-justify left
        set-option -g window-status-format          " #I #W "
        set-option -g window-status-separator       ""
        set-option -g window-status-current-format  " #I #W "
        set-option -g status-left                   ""
        set-option -g status-right                  "#h %I:%M %p"
        set-option -g status-left-length            0
        set-option -g monitor-activity on
        set-option -g visual-activity on
        set-option -g renumber-windows on
        set-option -g focus-events on
        bind N swap-window -t +1 -d
        bind P swap-window -t -1 -d
        bind S-Left swap-pane -s '{left-of}'
        bind S-Right swap-pane -s '{right-of}'
        bind S-Up swap-pane -s '{up-of}'
        bind S-Down swap-pane -s '{down-of}'
      '';
    };
    "vimrc" = {
      text = ''
        set number
        set relativenumber
        syntax on
        color pablo
        set nocompatible
        filetype plugin indent on
        set showcmd
        set showmatch
        set ignorecase
        set smartcase
        set incsearch
        set autowrite
        set hidden
        set mouse=a
        set textwidth=60
        set formatoptions-=t
      '';
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

