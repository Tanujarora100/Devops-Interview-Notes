
### Step 1: Find the Installation Path
You can locate where `pip3` installed the `trufflehog` executable by running the following command:

```bash
python3 -m site --user-base
```

This will output a directory path. The `trufflehog` executable is likely located in the `bin` subdirectory of this path.

For example, if the output is `/home/tanujgym/.local`, then the executable should be in:

```bash
/home/tanujgym/.local/bin/trufflehog
```

### Step 2: Add the Directory to Your PATH
Once you've located the directory, you need to add it to your `PATH` environment variable.

You can do this temporarily by running:

```bash
export PATH=$PATH:/home/tanujgym/.local/bin
```

To make this change permanent, add the export line to your `~/.bashrc` or `~/.bash_profile` file:

```bash
echo 'export PATH=$PATH:/home/tanujgym/.local/bin' >> ~/.bashrc
source ~/.bashrc
```

### Step 3: Verify Installation
After adding the directory to your `PATH`, try running:

```bash
trufflehog --version
```