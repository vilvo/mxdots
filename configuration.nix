{ config, pkgs, lib, apple-silicon, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.initrd.luks.devices."encrypted".device = "/dev/disk/by-uuid/44935802-2deb-431f-9eb2-7205d251040d";

  networking.hostName = "blub";
  networking.networkmanager.enable = true;

  # requires --impure with flakes because of firmware location
  hardware.asahi = {
    peripheralFirmwareDirectory = /boot/asahi;
    useExperimentalGPUDriver = true;
  };

  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;
  sound.enable = true;
  services.jack.jackd.enable = true;
  security.rtkit.enable = true;

  users.users.vilvo = {
    isNormalUser = true;
    description = "vilvo";
    extraGroups = [ "networkmanager" "wheel" "dialout" "jackaudio" "video" ];
    packages = with pkgs; [
      firefox
      pulseaudio
      rustup
      clang
      git
      micro
      bat
      gcc
      nix-index
      htop
    ];
  };

  environment.interactiveShellInit = ''
    alias nano='micro'
    alias cat='bat -A --color always'
  '';

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Helsinki";

  i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     useXkbConfig = true;
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      alacritty
      dmenu
      slurp
      grim
    ];
    wrapperFeatures.gtk = true;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = { # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "23.05";

}
