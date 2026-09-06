# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual, accessible by running `nixos-help`.

{ config, pkgs, lib, ... }:


let
  unstable = import <nixpkgs-unstable> {
    config.allowUnfree = true;
  };
in

# These files are not in the repo sorry
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./ollama.nix
    ./open-webui.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;

    # Keep only the ten newest bootable NixOS generations.
    configurationLimit = 10;

    # Prevent editing the kernel command line from the boot menu.
    editor = false;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # Nix settings.
  # Reduce duplicate files inside the Nix store.
    nix.settings = {
    auto-optimise-store = true;

    experimental-features = [
      "nix-command"
      "flakes"
      ];
  };

  # Hostname.
  networking.hostName = "orbit";

  # Networking.
  networking.networkmanager = {
    enable = true;

    # Let NetworkManager hand DNS management to systemd-resolved.
    # This enables reliable split DNS for Tailscale MagicDNS.
    dns = "systemd-resolved";
  };

  # Local DNS resolver with split-DNS support.
  services.resolved.enable = true;

  # Bluetooth for Noctalia / desktop integration.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Power / battery / profile services for Noctalia.
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Optional: needed if you want Noctalia calendar/event integration later.
  services.gnome.evolution-data-server.enable = true;

  # Secret storage / keyring for Electron apps such as Tuta Mail.
  services.gnome.gnome-keyring.enable = true;

  # Unlock GNOME Keyring from SDDM login when possible.
  security.pam.services.sddm.enableGnomeKeyring = true;

  # Drive / file-manager integration.
  # Needed so internal drives and USB drives show up properly in
  # Dolphin, Nautilus and GTK file pickers.
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Permanently mount the internal games drive.
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/orbit";
    fsType = "ext4";

    options = [
      "nofail"
      "x-gvfs-show"
      "x-gvfs-name=Games"
    ];
  };

  # Time zone.
  time.timeZone = "Europe/Berlin";

  # Locale.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # X11 / Wayland base support.
  services.xserver.enable = true;

  # KDE Plasma safety desktop.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Tailscale.
  services.tailscale.enable = true;

  # SSH access through Tailscale only.
  services.openssh = {
    enable = true;
    openFirewall = false;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
  
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 22 ];

  # Hyprland.
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };


  # Enable the nh command-line helper for simpler NixOS rebuilds,
  # and automatically clean old generations while keeping anything
  # newer than 30 days plus at least the 5 most recent generations
  programs.nh = {
  enable = true;
  clean.enable = true;
  clean.extraArgs = "--keep-since 30d --keep 5";
  };

  # XDG portals:
  # File pickers, Brave uploads, screen sharing and desktop integration.
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      kdePackages.xdg-desktop-portal-kde
    ];

    config.common.default = "gtk";
  };

  # Wayland / Electron compatibility.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Default terminal text editor.
  # This does not change the login shell.
  environment.variables = {
    EDITOR = "micro";
    VISUAL = "micro";
  };

  # German keyboard layout.
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  console.keyMap = "de";

  # Printing.
  services.printing.enable = true;

  # PipeWire audio stack.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # EasyEffects is part of the normal audio path.
  # Start it with the graphical session, after PipeWire and WirePlumber.
  systemd.user.services.easyeffects = {
    description = "EasyEffects audio processing";

    wantedBy = [ "graphical-session.target" ];

    requires = [
      "pipewire.service"
      "wireplumber.service"
    ];

    after = [
      "pipewire.service"
      "wireplumber.service"
    ];

    # Stop/restart EasyEffects together with the graphical session
    # or when PipeWire is explicitly stopped/restarted.
    partOf = [
      "graphical-session.target"
      "pipewire.service"
    ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.easyeffects}/bin/easyeffects --hide-window --service-mode";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };

  # User account.
  # No shell option is defined here, so your login shell is not changed.
  users.users."orbit" = {
    isNormalUser = true;
    description = "orbit";

    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Firefox.
  programs.firefox.enable = true;

  # Steam
  programs.steam = {
  enable = true;

  # Useful for changing settings inside individual Proton prefixes.
  protontricks.enable = true;

  # Declaratively install GE-Proton as a reliable alternative.
  extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];
  };

  # Allows games to request a performance-oriented CPU profile.
  programs.gamemode = {
  enable = true;

  settings = {
    general = {
      # Correct governor for amd-pstate-epp active mode.
      # The performance bias will be handled by power-profiles-daemon.
      desiredgov = "powersave";
      };
    };
  };

  # Provides Gamescope. Do not force every game through it automatically.
  programs.gamescope.enable = true;

  # Fish shell support.
  #
  # This makes Fish available but does not set it as the login shell.
  programs.fish.enable = true;

  # Java / Maven development.
  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  # Allow unfree packages such as Discord, Spotify and VS Code.
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Core command-line tools.
    git
    rsync
    vim
    neovim
    nano
    micro
    curl
    wget
    kitty
    fastfetch
    imagemagick
    chafa
    btop
    duf
    unzip
    p7zip
    pciutils
    usbutils
    lsof
    ripgrep
    fd
    tree
    file
    which
    zip
    ghostty
    lazydocker
    bat
    eza
    fzf

    # Security / migration tools.
    gnupg
    age
    sops
    veracrypt

    # Development.
    lazygit
    maven
    nodejs
    rustup

    # Audio tools.
    easyeffects
    pavucontrol
    qpwgraph
    crosspipe

    # KDE / desktop tools.
    kdePackages.kate
    kdePackages.kcalc
    kdePackages.dolphin
    kdePackages.kdenlive
    haruna
    seahorse

    # Hyprland / Wayland tools.
    waybar
    rofi
    wl-clipboard
    grim
    slurp
    swappy
    hyprpaper
    hyprlock
    hypridle
    hyprpicker
    hyprshot
    hyprland-qtutils
    hyprpolkitagent

    # Shell / launcher / desktop integration.
    quickshell
    unstable.noctalia
    noctalia-shell
    fuzzel
    nautilus
    brave
    brightnessctl
    playerctl
    libnotify
    yazi
    zoxide
    gtk3

    # Audio / media helpers.
    wireplumber
    pipewire
    mpv
    vlc
    jellyfin-desktop

    # Daily applications.
    libreoffice-qt
    obs-studio
    qbittorrent
    thunderbird
    zotero
    freetube
    heroic
    inkscape
    zoom-us
    discord
    vscode
    obsidian
    spotify
    spicetify-cli
    proton-vpn
    tutanota-desktop
    anki
    mpvpaper

    # Bitwarden command-line client only.
    # The Bitwarden desktop application is intentionally not installed.
    bitwarden-cli
    rbw
    pinentry-qt
    

    # Gaming
    protonplus
    mangohud
    

    # Terminal toys / visual tools.
    cbonsai
    tty-clock
    unimatrix
    cava
    pipes-rs
    ani-cli
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #
  # programs.mtr.enable = true;
  #
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # OpenSSH daemon disabled by default.
  # services.openssh.enable = true;

  # Firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  # Automatic NixOS upgrades.
  # Reboot is disabled so the desktop does not restart by itself.
  #
  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data were taken. Do not change lightly.
  system.stateVersion = "26.05";
}