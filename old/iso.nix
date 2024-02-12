# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{config, pkgs, lib, ...}:

with lib;

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/iso-image.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>

    <nixpkgs/nixos/modules/profiles/clone-config.nix>
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
    <nixpkgs/nixos/modules/profiles/base.nix>
  ];
  
  # ISO naming.
  isoImage.isoName = "${config.isoImage.isoBaseName}-${config.system.nixos.label}-${pkgs.stdenv.system}.iso";

  isoImage.volumeID = substring 0 11 "NIXOS_ISO";

  # EFI booting
  isoImage.makeEfiBootable = true;

  # USB booting
  isoImage.makeUsbBootable = true;

  # Add Memtest86+ to the CD.
  boot.loader.grub.memtest86.enable = true;
 
  networking.hostName = "iso";
  networking.wireless.enable = true;
  networking.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  

  documentation.nixos.enable = true;

  services.getty.autologinUser = "nix";

  users.users.nix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "libvirt" "docker" ];
    
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1N
TE5AAAAIDBUk5IjB3+trnVO6pncivFbOetUL8BPTl3CwAtk4532 xfnw@raven" ];
  };
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    wget vim tmux gnupg ncdu mosh
    git curl rsync wireguard-tools
  ];

  environment.variables.GC_INITIAL_HEAP_SIZE = "1M";
  boot.kernel.sysctl."vm.overcommit_memory" = "1";
  boot.consoleLogLevel = 7;
  networking.firewall.logRefusedConnections = false;
  system.extraDependencies = with pkgs; [ stdenv stdenvNoCC busybox jq ];

  services.openssh.enable = true;
}
