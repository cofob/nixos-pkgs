{ pkgs ? import <nixpkgs> {} }:
{
  deta = pkgs.callPackage ./pkgs/deta { };
  ultimmc = pkgs.callPackage ./pkgs/ultimmc { };
  infrared = pkgs.callPackage ./pkgs/infrared { };
  proxmox-backup = pkgs.callPackage ./pkgs/proxmox-backup { };
}
