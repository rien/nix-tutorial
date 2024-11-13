Create the OVA image:

```sh
nix run github:nix-community/nixos-generators -- -f virtualbox -c configuration.nix
```

Then, in VirtualBox, import the resulting `.ova` file with File > Import Appliance.
