{ config, pkgs, lib, apple-silicon, ... }:

{
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "blib";
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
    extraGroups = [ "networkmanager" "wheel" "dialout" "jackaudio" "video" "input" ];
    packages = with pkgs; [
      firefox
      pulseaudio
      rustup
      clang
      bat
      gcc
      nix-index
      htop
      vscode
      micro
      foot
      dracut
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwRelxFwR6WPBm86b52q7pjQd8mEiqj1R3yj6YVL6wM vilvo@blip"
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
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.autorun = false;
  services.xserver.desktopManager.gnome.enable = true;

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      waybar
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
      trusted-users = [ "root" "vilvo" ];
    };
    gc = { # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  environment.systemPackages = with pkgs;
  [
    git
    clang
  ];

  system.stateVersion = "23.11";

}
